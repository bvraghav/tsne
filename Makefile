SHELL			:= /usr/bin/zsh



include config.Makefile





CONDA_YML		:= conda-env.yml
CONDA_ROOT		:= ${HOME}/miniconda3


conda-env-name		 = $(shell	\
  cat ${CONDA_YML}			\
  | sed '/^name/!d'			\
  | awk -F ': ' '{print $$2}'		\
)

conda-activate		 = source ${CONDA_ROOT}/bin/activate ${1}
conda-activate-base	 = $(call conda-activate,base)
conda-activate-env	 = $(call conda-activate,$(cond-env-name))

base-conda		 = $(conda-activate-base) ; conda

conda			 = $(conda-activate-env); conda
python			 = $(conda-activate-env); python

has-env			 = $(shell 	\
  $(base-conda) env list 		\
  | grep $(conda-env-name) 		\
  || echo				\
)

default: run-tsne

create-conda-env :
	$(base-conda) env create -f ${CONDA_YML}

run-tsne :
ifeq ($(has-env),)
	$(MAKE) create-conda-env
endif
	$(python) -m compute_tsne			\
	    --xkey		${XKEY}			\
	    --ykey		${YKEY}			\
	    $(and ${TKEY},--tkey ${TKEY})		\
	    $(and ${DRY_RUN},--dry-run)		 	\
	    --perplexity	${PERPLEXITY}	 	\
	    --num-neighbours	${NUM_NEIGHBOURS}	\
	    --learning-rate	${LEARNING_RATE} 	\
	    --n-iter		${N_ITER}	 	\
	    --n-steps		${N_STEPS}	 	\
	    --random-seed	${RANDOM_SEED}	 	\
	    $(and ${FORCE_WRITE},--force-write)	 	\

has-env :
	$(base-conda) env list 		\
	| grep $(conda-env-name)	\
	|| echo				\


conda-env-name :
	cat ${CONDA_YML}		\
	| sed '/^name/!d'		\
	| awk -F ': ' '{print $$2}'	\
