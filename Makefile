SHELL			:= /usr/bin/zsh


include sample-config.Makefile
CONFIG-MK		:= config.Makefile
$(info Including config: $(CONFIG-MK))
include ${CONFIG-MK}







conda-env-name		 = $(or ${CONDA_ENV},$(shell	\
  cat ${CONDA_YML}					\
  | sed '/^name/!d'					\
  | awk -F ': ' '{print $$2}'				\
))

conda-activate		 = source ${CONDA_ROOT}/bin/activate ${1}
conda-activate-base	 = $(call conda-activate,base)
conda-activate-env	 = $(call conda-activate,$(conda-env-name))

base-conda		 = $(conda-activate-base) ; conda

conda			 = $(conda-activate-env); conda
python			 = $(conda-activate-env); python

has-env			 = $(shell 			\
  $(base-conda) env list 				\
  | grep $(conda-env-name) 				\
  || echo						\
)

tkey			 = $(and $(has-env), $(shell	\
  $(python) -m get_tkey					\
    --perplexity	${PERPLEXITY}	 		\
    --num-neighbours	${NUM_NEIGHBOURS}		\
    --learning-rate	${LEARNING_RATE} 		\
    --n-iter		${N_ITER}	 		\
    --random-seed	${RANDOM_SEED}	 		\
))

default: run-tsne

create-conda-env : ${CONDA_YML}
	$(base-conda) env create -f ${<} -n $(conda-env-name)

run-tsne :
ifeq ($(has-env),)
	$(MAKE) create-conda-env
endif
	$(python) -m compute_tsne			\
	    --xkey		${XKEY}			\
	    --ykey		${YKEY}			\
	    --tkey		$(or ${TKEY},$(tkey))	\
	    $(and ${DRY_RUN},--dry-run)		 	\
	    --perplexity	${PERPLEXITY}	 	\
	    --num-neighbours	${NUM_NEIGHBOURS}	\
	    --learning-rate	${LEARNING_RATE} 	\
	    --n-iter		${N_ITER}	 	\
	    --n-steps		${N_STEPS}	 	\
	    --step-progression	${STEP_PROGRESSION} 	\
	    --random-seed	${RANDOM_SEED}	 	\
	    $(and ${FORCE_WRITE},--force-write)	 	\
	    ${TSNE_OUT_HDF5}				\
	    ${TSNE_IN_HDF5}				\

plots :
ifeq ($(has-env),)
	$(MAKE) create-conda-env
endif
	$(python) -m plot				\
	    --xkey		$(or ${TKEY},$(tkey))	\
	    --ykey		${YKEY}			\
	    --ynamekey		${YNAMEKEY}		\
	    --ycolourkey	${YCOLOURKEY}		\
	    --n-iter		${N_ITER}	 	\
	    --n-steps		${N_STEPS}	 	\
	    --step-progression	${STEP_PROGRESSION} 	\
	    --width		${WIDTH}	 	\
	    --height		${HEIGHT}	 	\
	    ${TSNE_OUT_HDF5}				\
	    ${TSNE_IMPATH}				\




## ----------------------------------------------------
## DEBUG
## ----------------------------------------------------

has-env :
	$(base-conda) env list 		\
	| grep $(conda-env-name)	\
	|| echo				\


conda-env-name :
	cat ${CONDA_YML}		\
	| sed '/^name/!d'		\
	| awk -F ': ' '{print $$2}'	\
