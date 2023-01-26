#! /usr/bin/gnuplot -c

DATA = @ARG1
# set term wxt
set term pngcairo size 1600,900
set output @ARG2

set title 'TSNE for MEAD Dataset'

set cbrange [-0.5:21.5]
set cbtics (            \
    'Neutral L1' 0 ,    \
    'Angry L1' 1 ,      \
    'Angry L2' 2 ,      \
    'Angry L3' 3 ,      \
    'Contempt L1' 4 ,   \
    'Contempt L2' 5 ,   \
    'Contempt L3' 6 ,   \
    'Disgusted L1' 7 ,  \
    'Disgusted L2' 8 ,  \
    'Disgusted L3' 9 ,  \
    'Fear L1' 10 ,      \
    'Fear L2' 11 ,      \
    'Fear L3' 12 ,      \
    'Happy L1' 13 ,     \
    'Happy L2' 14 ,     \
    'Happy L3' 15 ,     \
    'Sad L1' 16 ,       \
    'Sad L2' 17 ,       \
    'Sad L3' 18 ,       \
    'Surprised L1' 19 , \
    'Surprised L2' 20 , \
    'Surprised L3' 21   \
    )


set palette maxcolors 22
set palette defined ( \
    0  '#000000' ,    \
    1  '#b23636',     \
    2  '#cc2929',     \
    3  '#e60000',     \
    4  '#b2a136',     \
    5  '#ccb529',     \
    6  '#e6c500',     \
    7  '#59b236',     \
    8  '#57cc29',     \
    9  '#42e600',     \
    10 '#36b27d',     \
    11 '#29cc86',     \
    12 '#00e683',     \
    13 '#367db2',     \
    14 '#2986cc',     \
    15 '#0083e6',     \
    16 '#5936b2',     \
    17 '#5729cc',     \
    18 '#4200e6',     \
    19 '#b236a1',     \
    20 '#cc29b5',     \
    21 '#e600c5'      \
    )

plot DATA using 1:2:3 with points palette