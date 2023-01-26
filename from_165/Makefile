SHELL		:= /usr/bin/zsh

python		 = source ~/miniconda3/bin/activate emacs ; python


DATA_FILES	:= $(wildcard tsne-data/*.dat)
VIZ_FILES	:= ${DATA_FILES:tsne-data/%.dat=tsne-viz/%.png}
FRAMES		:= $(wildcard tsne-viz/*.png)
USE_IDS		:=

all :
ifndef KEY
	$(error set var KEY required)
endif
	$(MAKE) tsne-data MAKEFLAGS=${MAKEFLAGS}
	$(MAKE) tsne-viz MAKEFLAGS=${MAKEFLAGS}
	$(MAKE) tsne-movie MAKEFLAGS=${MAKEFLAGS}
	$(MAKE) run-movie MAKEFLAGS=${MAKEFLAGS}

.PHONY: tsne-data
tsne-data :
	$(python) -m extract_data			\
	  $(and ${USE_IDS},--use-identities-as-classes) \
	  ${KEY}


ifeq (${DATA_FILES}, )
.PHONY: 
tsne-viz :
	$(error No data to work)
else
.PHONY: tsne-viz
tsne-viz : ${VIZ_FILES}
endif


tsne-viz/%.png : tsne-data/%.dat
	./TSNE$(and ${USE_IDS},_byID).gnuplot '"$<"' '"$@"'


.PHONY: tsne-movie
tsne-movie : 
ifeq (${FRAMES}, )
	$(error No frames to work)
endif
ifeq (${KEY},)
	$(error set var KEY required)
endif
	ffmpeg -r 2 -i tsne-viz/%04d.png \
	  -c:v libx264 -vf fps=2 -pix_fmt yuv420p \
	  TSNE$(and ${USE_IDS},_byID)_${KEY}.mp4


run-movie :
ifeq (${KEY},)
	$(error set var KEY required)
endif
	mpv --loop=inf TSNE$(and ${USE_IDS},_byID)_${KEY}.mp4
