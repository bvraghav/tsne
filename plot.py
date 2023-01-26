import logging as LG
import h5py as h5
from PyGnuplot import gp
from pathlib import Path
import numpy as np
import click
from tqdm import tqdm


@click.command(context_settings = dict(
  show_default                  = True,
  help_option_names             = ['-h','--help']
))
@click.argument('DATA', type=click.Path(
  exists=True, dir_okay=False, path_type=Path,
))
@click.argument('IMPATH', type=click.Path(
  exists=False, file_okay=False, path_type=Path,
))
@click.option('--xkey', default='data/xkey')
@click.option('--ykey', default='data/ykey')
@click.option('--ynamekey', default='data/ynamekey')
@click.option('--ycolourkey', default='data/ycolourkey')
@click.option('-W', '--width', type=int, default=1600)
@click.option('-H', '--height', type=int, default=900)
@click.option('--step-progression', type=click.Choice([
  'arithmetic', 'geometric'
]), default='geometric')
@click.option('--n-steps', type=int,
              required=True,)
@click.option('--n-iter', type=int,
              required=True)

def main(
    data,
    impath,
    xkey,
    ykey,
    ynamekey,
    ycolourkey,
    width,
    height,
    step_progression,
    n_steps,
    n_iter,
) :
  lg = LG.getLogger(__name__)

  data, ynames, ycolours = read_h5(
    data,
    xkey,
    ykey,
    ynamekey,
    ycolourkey,
  )

  get_steps = {
    'arithmetic': get_AP_steps,
    'geometric': get_GP_steps,
  }.get(step_progression, get_GP_steps)
  steps = get_steps(n_steps, n_iter)
  lg.info(f'Steps: {steps}')

  W, H = width, height

  for step in tqdm(steps) :
    title = f'{xkey} step:{step}/{steps}'
    imname = impath/f'{xkey}_step:{step}'

    plot_and_save(
      H, W, imname, title, ynames, ycolours, data
    )
    lg.info(f'Written to {imname}')

def read_h5(
    data,
    xkey,
    ykey,
    ynamekey,
    ycolourkey,
) :
  hpath = data
  with h5.File(hpath, 'r', swmr_mode=True) as H :
    X = H[xkey]
    Y = H[ykey]
    if X.shape[0] != Y.shape[0]:
      raise RuntimeError(
        f'X:shape:{X.shape} '
        f'is different than '
        f'Y:shape:{Y.shape} '
        f'on 0-th dimension'
      )
    data = np.concatenate([X[:], Y[:]],1)

    ynames = H[ynamekey].asstr()[:].tolist()
    ycolours = H[ycolourkey].asstr()[:].tolist()
    if len(ynames) != len(ycolours) :
      raise RuntimeError(
        f'ynames:len:{len(ynames)} '
        f'is different than '
        f'ycolours:len:{len(ycolours)} '
      )

  return data, ynames, ycolours

def get_AP_steps(n_steps, n_iter) :
  steps = list(map(
    lambda n : int((1+n)/n_steps * (n_iter)),
    range(n_steps)
  ))

  return steps

def get_GP_steps(n_steps, n_iter) :
  a = 1
  b = (n_iter/a)**(1/n_steps)
  steps = list(map(
    lambda n : int(a * (b**(1+n))),
    range(n_steps)
  ))

  return steps

def plot_and_save(
    H, W, imname, title, ynames, ycolours, data
) :

  fig = gp()
  fig.a(f'set term pngcairo size {W},{H}')
  fig.a(f'set output {imname}')
  fig.a(f'set title "{title}"')

  # CBTICS
  fig.a(f'set cbrange [-0.5:{len(ynames)-1}.5]')
  _names = ','.join(
    f'"{yname}" {i}' for i,yname in enumerate(ynames)
  )
  fig.a(f'set cbtics ({_names})')

  # PALETTE
  fig.a(f'set cbrange [-0.5:{len(ycolours)-1}.5]')
  _colours = ','.join(
    f'{i} "{ycolour}"'
    for i,ycolour in enumerate(ycolours)
  )
  fig.a(f'set cbtics ({_colours})')

  # Plot
  fig.plot(data, com='plot "-" u 1:2:3 w p palette')

if __name__ == '__main__' :

  LG.basicConfig(
    level=LG.INFO,
    format='%(levelname)-8s: [%(name)s] %(message)s'
  )

  main()