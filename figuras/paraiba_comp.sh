#!/bin/bash

# primeiro input eh a grade da esquerda
# segundo input eh a grade da direita
# terceiro input eh o nome do output
grade1=$1
grade2=$2

# Recorta um pedaço da grade
gmt grdcut -R-47/-43/-24/-21.5 $grade1 -Gcut1.grd 
gmt psbasemap -R -Bxya1 -BWNse -JM8 -X2 -Yc -P -K --FONT_ANNOT_PRIMARY=10p > "$3".ps
gmt makecpt -T-1/1/0.1 -Cpolar > brasil_der_1x1.cpt
gmt grdview cut1.grd -R -J -O -K -Qi -Cbrasil_der_1x1.cpt >> "$3".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> "$3".ps

gmt grdcut -R $grade2 -Gcut2.grd
gmt psbasemap -R -Bxya1 -BwNsE -JM8 -X9 -Yc -O -K -P --FONT_ANNOT_PRIMARY=10p >> "$3".ps
gmt makecpt -T-1/1/0.1 -Cred2green > brasil_der_05x05.cpt
gmt grdview cut2.grd -R -J -O -K -Qi -Cbrasil_der_05x05.cpt >> "$3".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> "$3".ps

gmt psxy -R -J -O -T >> "$3".ps

[ -f "$3".ps ] && gv "$3".ps
gmt psconvert -P -A -Tf "$3".ps
gmt psconvert -P -A -TG "$3".ps

rm -f "$3".ps cut1.grd cut2.grd brasil_der_1x1.cpt brasil_der_05x05.cpt gmt.history
