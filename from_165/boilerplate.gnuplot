#! /usr/bin/gnuplot -c

# Write TERM here
## f'set term pngcairo size {H},{W}'
## f'set output {imname}'

# Write TTILE here
## f'set title "{title}"'

# Write CBTICS here:
## f'set cbrange [-0.5:{len(ynames)-1}.5]' <Enter>
## f'set cbtics (' 
##    ','.join(f'"{yname}" {i}' for i,yname in enumerate(ynames))
## f')'

# Write PALETTE here:
## f'set palette maxcolors {len(ynames)}' <Enter>
## f'set palette defined ('
## ','.join(f'{i} "{ycolour}"' for i,ycolour in enumerate(ycolours))
## f')'

# Write PLOT here:
##f'plot "{dat}" using 1:2:3 with points palette'