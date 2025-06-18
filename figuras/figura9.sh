#!/bin/bash

name=figura9

grade=grades/grade_5x5_25_40_8.grd
contorno=contornos/brasil_05x05.xy

gmt psbasemap -R-78/-30/-34.5/6.5 -Bxya10 -BwNsE -JM12 -Xc -Y8 -K -P --FONT_ANNOT_PRIMARY=8p > "$name".ps
gmt makecpt -T-1/1/0.1 -Cred2green > brasil_der.cpt
gmt grdcut $grade -F$contorno -GBR_grade.grd
gmt grdview BR_grade.grd -R -J -O -K -Qi -Cbrasil_der.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Dl -N1 -A10000+l >> "$name".ps
cat $contorno | gmt psxy -R -J -O -K -W1p,green >> "$name".ps
gmt psxy -R -J -O -T >> "$name".ps

[ -f "$name".ps ] && gv "$name".ps
gmt psconvert -P -A -TG "$name".ps

rm -f "$name".ps BR_grade.grd brasil_der.cpt gmt.history
