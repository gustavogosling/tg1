#!/bin/bash

name=figura2

grade=grades/grade_10x10_10_40_0.grd

gmt makecpt -T-1/1/0.1 -Cpolar > brasil_der_1x1.cpt

# Recorta um pedaço da grade
gmt psbasemap -R-62/-50/-22.5/-15.5 -Bxya4 -BwNsE -JM10 -X2 -Yc -P -K --FONT_ANNOT_PRIMARY=7p > "$name".ps
gmt grdview $grade -R -J -O -K -Qi -Cbrasil_der_1x1.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N1 -A10000+l >> "$name".ps

gmt psxy -R -J -O -T >> "$name".ps

[ -f "$name".ps ] && gv "$name".ps
gmt psconvert -P -A -TG "$name".ps

rm -f "$name".ps brasil_der_1x1.cpt gmt.history
