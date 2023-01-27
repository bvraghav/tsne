# Compute TSNE and visualise

Efficiently compute TSNE embeddings using [TSNE CUDA
package](https://github.com/CannyLab/tsne-cuda) and
visualise the plot using GNU Plot.

The package automatically installs the environment if
`CONDA_ROOT` is correctly specified in the
configuration.

## Usage ##

1. Compute TSNE embeddings as well as create
   visualisation plots.
   ```sh
   make all-tsne
   ```
2. Only compute TSNE.
   ```sh
   make run-tsne
   ```
3. Only plot precomputed TSNE.
   ```sh
   make plot-tsne
   ```

## Configuration ##

Create `config.Makefile` and update as required, using,
```sh
cp sample-config.Makefile config.Makefile 
```

### Input ###

The input data is taken from `TSNE_IN_HDF5`, where
- `XKEY` specifies path to the feature vectors of
  population with array shape `(N,D)`;
- `YKEY` specifies corresponding labels (integers in
  semi-open range `[0, L-1)`), with array shape `(N,)`;
- `YNAMEKEY` lists the names of each label. `dtype:
  h5py.string_dtype()` and shape `(L,)`;
- `YCOLOURKEY` lists the color to plot for each
  label. `dtype: h5py.string_dtype()` and shape `(L,)`;

### Output ###

The output data is stored into `TSNE_OUT_HDF5`, where
- `TKEY` corresponds to the 2D TSNE-embeddings computed
  over `T` snapshots, bearing shape `(T,N,2)`.
  
Output images are stored in `TSNE_IMPATH`

### TSNE Params ###

- `PERPLEXITY`, `NUM_NEIGHBOURS`, `LEARNING_RATE`,
  `N_ITER` are passed on to TSNE CUDA as is.
- `N_STEPS` defines number of intermediate snapshots to
  be stored;
- `STEP_PROGRESSION` defines how the intermediate steps
  are computed. Valid options are `arithmetic` or
  `geometric`;
- `RANDOM_SEED` is an integer seed to initialise the
  random number generator. Useful to reproduce results.

For more details on parameters per TSNE-CUDA package,
refer to https://github.com/CannyLab/tsne-cuda

### Plot Params ###

- Image size is specified by `WIDTH` and `HEIGHT`.

### Miscellaneous ###
- `DRY_RUN` : Don't compute TSNE (as in target
  `run-tsne`). Just test if the settings work. It has
  no effect on `plot-tsne`. If specified target
  `plot-tsne`, its recipe will execute;
- `CONDA_ENV` is the env name. If unspecified, the
  script discovers it from `CONDA_YML`;
- `CONDA_YML` specifies the conda env file. If a
  different env in intended to be installed. This is
  the same file used to discover the env name that is
  activated to run python scripts;
- `CONDA_ROOT` specifies the conda installation
  root. Eg. in case of miniconda, the default root is
  `${HOME}/miniconda3`

## Prerequisites ##
1. (mini) Conda : [Follow instructions
   here.](https://conda.io/projects/conda/en/stable/user-guide/install/index.html
   "Miniconda installation.")
2. [GNUPlot](http://www.gnuplot.info/ "GNUPlot") :
   Optionally required if visualising. Should be available on your system package
   repository. e.g. 
   ```sh
   apt install gnuplot
   # OR
   pacman -Sy gnuplot
   ```
3. [GNU Make](https://www.gnu.org/software/make/ "GNU
   Make") : to automate computation and generating
   graphs. Should also be available on your system
   package repository. e.g.
   ```sh
   apt install make
   # OR
   pacman -Sy make
   ```

