#! /usr/bin/gnuplot -c

DATA = @ARG1
# set term wxt
set term pngcairo size 1600,900
set output @ARG2

set title 'TSNE for MEAD Dataset (by ID)'

set cbrange [-0.5:44.5]
set cbtics (   \
    "W026" 0,  \
    "W029" 1,  \
    "W014" 2,  \
    "W028" 3,  \
    "M035" 4,  \
    "M039" 5,  \
    "W023" 6,  \
    "M034" 7,  \
    "M019" 8,  \
    "M024" 9,  \
    "W037" 10, \
    "W035" 11, \
    "W021" 12, \
    "W019" 13, \
    "W036" 14, \
    "W015" 15, \
    "M011" 16, \
    "M028" 17, \
    "M041" 18, \
    "M009" 19, \
    "M027" 20, \
    "M029" 21, \
    "M040" 22, \
    "W009" 23, \
    "M003" 24, \
    "M025" 25, \
    "M022" 26, \
    "M005" 27, \
    "W033" 28, \
    "W038" 29, \
    "W040" 30, \
    "M007" 31, \
    "M012" 32, \
    "M033" 33, \
    "W011" 34, \
    "M037" 35, \
    "M030" 36, \
    "W018" 37, \
    "M023" 38, \
    "M031" 39, \
    "W025" 40, \
    "M013" 41, \
    "W016" 42, \
    "M042" 43, \
    "W024" 44  \
    )


set palette maxcolors 45
set palette defined ( \
    0 "#801919",      \
    1 "#802719",      \
    2 "#803519",      \
    3 "#804219",      \
    4 "#805019",      \
    5 "#805e19",      \
    6 "#806b19",      \
    7 "#807919",      \
    8 "#798019",      \
    9 "#6b8019",      \
    10 "#5e8019",     \
    11 "#508019",     \
    12 "#428019",     \
    13 "#358019",     \
    14 "#278019",     \
    15 "#198019",     \
    16 "#198027",     \
    17 "#198035",     \
    18 "#198042",     \
    19 "#198050",     \
    20 "#19805d",     \
    21 "#19806b",     \
    22 "#198079",     \
    23 "#197980",     \
    24 "#196b80",     \
    25 "#195d80",     \
    26 "#195080",     \
    27 "#194280",     \
    28 "#193580",     \
    29 "#192780",     \
    30 "#191980",     \
    31 "#271980",     \
    32 "#351980",     \
    33 "#421980",     \
    34 "#501980",     \
    35 "#5e1980",     \
    36 "#6b1980",     \
    37 "#791980",     \
    38 "#801979",     \
    39 "#80196b",     \
    40 "#80195e",     \
    41 "#801950",     \
    42 "#801942",     \
    43 "#801935",     \
    44 "#801927"      \
    )

plot DATA using 1:2:3 with points palette t ''