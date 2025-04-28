#!/bin/bash

# primeiro input eh a grade da esquerda
# segundo input eh a grade da direita
# terceiro input eh o nome do output
grade1="$1"
grade2="$2"
name="$3".ps

# Recorta um pedaço da grade
gmt grdcut -R-47/-43/-24/-21.5 $grade1 -Gcut1.grd 
gmt psbasemap -R -Bxya1 -BWNse -JM8 -X2 -Yc -P -K > $name
gmt makecpt -T-1/1/0.1 -Cpolar > brasil_der_1x1.cpt
gmt grdview cut1.grd -R -J -O -K -Qi -Cbrasil_der_1x1.cpt >> $name
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> $name

gmt grdcut -R $grade2 -Gcut2.grd
gmt psbasemap -R -Bxya1 -BwNsE -JM8 -X9 -Yc -O -K -P >> $name
gmt makecpt -T-1/1/0.1 -Cred2green > brasil_der_05x05.cpt
gmt grdview cut2.grd -R -J -O -K -Qi -Cbrasil_der_05x05.cpt >> $name
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> $name

gmt psxy -R -J -O -T >> $name

[ -f $name ] && gv $name
gmt psconvert -P -A -Tf $name
gmt psconvert -P -A -TG $name

rm -f $name cut1.grd cut2.grd brasil_der_1x1.cpt brasil_der_05x05.cpt gmt.history
