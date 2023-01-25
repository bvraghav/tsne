import logging as LG
from tsnecuda import TSNE
import random
from pathlib import Path
import json
import functools as Ft
import h5py as h5
import numpy as np
import click

## Not for torch inclusion in future.
## -----------------------------------
## conda install pytorch torchvision \
##               torchaudio          \
##               pytorch-cuda=11.6   \
##               -c pytorch -c nvidia
## -----------------------------------
# import torch

# X = data
# p, lr = 64,300
# N=2048
# steps = range(64, N+1, 64)
# nn = 64

# X_embedded = np.stack([
#     TSNE(
#         perplexity=p,
#         num_neighbors=nn,
#         learning_rate=lr, 
#         n_iter=_n,
#         random_seed=R,
#     ).fit_transform(X)
#     for _n in steps
# ])

@click.command(context_settings = dict(
  show_default                  = True,
  help_option_names             = ['-h','--help']
))
@click.argument('OUT_HDF5', type=click.Path(
  exists=False, dir_okay=False, path_type=Path,
  writable=True,
))
@click.argument('HDF5', type=click.Path(
  exists=True, dir_okay=False, path_type=Path,
))
@click.option('--xkey', default='data/X')
@click.option('--xkey', default='data/Y')
@click.option('--tkey',
              help='Computed using tsne params.')
@click.option('-D', '--dry-run',
              is_flag=True, default=False)
@click.option('-p', '--perplexity', type=int,
              default=64)
@click.option('-nn', '--num-neighbors',
              '--num-neighbours', type=int, default=64)
@click.option('-lr', '--learning-rate', type=float,
              default=300.0)
@click.option('-N', '--n-iter', type=int,
              default=2048)
@click.option('-n', '--n-steps', type=int, default=32)
@click.option('-R', '--random-seed', type=int,
              default=0,
              help='Negative value to use nanoseconds')
@click.option('-f', '--force-write', is_flag=True,
              default=False)

def main(
    out_hdf5,
    hdf5,
    xkey,
    ykey,
    tkey,
    dry_run,
    perplexity,
    num_neighbors,              # North American
                                # spelling as in TSNE
                                # CUDA API
    learning_rate,
    n_iter,
    n_steps,
    random_seed,
    force_write,
) :
  '''Compute and store T-SNE embeddings in NDIM under
  key TKEY of OUT_HDF5 file; given data stored in HDF5
  file under keys XKEY for inputs (dtype=float) and
  optionally YKEY as labels (dtype=int).

  Other parameters are as per tsne-cuda package (See
  https://github.com/CannyLab/tsne-cuda for more
  details).

  '''

  ## Sanitise args
  ## --------------------------------------------------
  if tkey is None :
    tkey = get_tkey(
      perplexity,
      num_neighbors,
      learning_rate,
      n_iter,
      random_seed,
    )

  ## Log args
  ## --------------------------------------------------
  log_args(
    out_hdf5      = out_hdf5,
    hdf5          = hdf5,
    xkey          = xkey,
    ykey          = ykey,
    tkey          = tkey,
    dry_run       = dry_run,
    perplexity    = perplexity,
    num_neighbors = num_neighbors,
    learning_rate = learning_rate,
    n_iter        = n_iter,
    n_steps       = n_steps,
    random_seed   = random_seed,
    force_write   = force_write,
  )

  X, Y = load_data(hdf5, xkey, ykey)

  storage = _Storage(out_hdf5, tkey, force_write)

  TSNE(
    perplexity    = perplexity,
    num_neighbors = num_neighbors,
    learning_rate = learning_rate,
    n_iter        = n_iter,
    random_seed   = random_seed,
  )

  if dry_run :
    lg.info('Dry run complete. Exiting.')
    raise SystemExit(0)

  steps = map(
    lambda n : int(((1+n)/n_steps) * n_iter),
    range(n_steps)
  )

  X_embedded = np.stack([
    TSNE(
      perplexity=p,
      num_neighbors=nn,
      learning_rate=lr, 
      n_iter=_n,
      random_seed=R,
    ).fit_transform(X)
    for _n in steps
  ])

  storage.save(X_embedded)

def get_tkey(p, nn, lr, N, R,) :
  return f'tsne/p:{p}_lr:{lr}_N:{N}_nn:{nn}_R:{R:08X}'

def log_args(**kwargs) :
  lg = LG.getLogger(__name__)

  lg.info(f'CLI Args:')

  for (k, v) in kwargs.items() :
    lg.info(f'{k}: {v}')

class _Storage :
  def __init__(self, hpath, tkey, force_write=False) :
    self._H = None
    self.hpath = hpath
    self.tkey = tkey

    self.validate_writable(force_write)

  def validate_writable(self, force) :
    if self.tkey in self.H :
      if not force :
        raise RuntimeError(
          f'Unexpected write location key:'
          f'"{self.tkey}" in "{self.hpath}". KEY '
          f'already exists. Use FORCE flag to '
          f'overwrite.'
        )
      del self.H[self.tkey]

  @property
  def H(self, H) :
    if self._H is None :
      self._H = h5.File(self.hpath, 'a', libver='latest')
      self._H.swmr_mode = True

    return self._H

  def __del__(self) :
    if self._H is not None :
      self._H.close()

  def save(self, data) :
    self.H.create_dataset(self.tkey, data)

if __name__ == '__main__' :

  LG.basicConfig(
    level=LG.INFO,
    format='%(levelname)-8s: [%(name)s] %(message)s'
  )

  main()
