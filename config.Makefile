
XKEY			:= affine/dx
YKEY			:= labels/emotions/dx
TKEY			:= 
YNAMEKEY		:= all/emotions
YCOLOURKEY		:= all/emotions_colors
DRY_RUN			:= 
PERPLEXITY		:= 22
NUM_NEIGHBOURS		:= 8
LEARNING_RATE		:= 10
N_ITER			:= 2048  
N_STEPS			:= 11    
STEP_PROGRESSION	:= geometric
RANDOM_SEED		:= 2903874657
FORCE_WRITE		:= 

# Input and output hdf5 files may be the same
TSNE_OUT_HDF5		:= ${HOME}/data/diffae/mead-features-relative/0c4acaf5/affine-0c4acaf5.hdf5
TSNE_IN_HDF5		:= ${HOME}/data/diffae/mead-features-relative/0c4acaf5/affine-0c4acaf5.hdf5

# Path to save TSNE plots
TSNE_IMPATH		:= ${HOME}/data/diffae/mead-features-relative/0c4acaf5/tsne

# TSNE plot image size
WIDTH			:= 1600
HEIGHT			:= 900

CONDA_ENV		:=
CONDA_YML		:= conda-env.yml
CONDA_ROOT		:= ${HOME}/miniconda3
