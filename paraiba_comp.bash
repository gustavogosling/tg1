#!/bin/bash

# Recorta um pedaço da grade
gmt grdcut -R-47/-43/-24/-21.5 figrd_1x1.grd -Gcut1.grd 
gmt psbasemap -R -Bxya1 -BWNse -JM8 -X2 -Yc -P -K > plot.ps
gmt makecpt -T-1/1/0.1 -Cpolar > brasil_der_1x1.cpt
gmt grdview cut1.grd -R -J -O -K -Qi -Cbrasil_der_1x1.cpt >> plot.ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> plot.ps

gmt grdcut -R figrd_05x05.grd -Gcut2.grd
gmt psbasemap -R -Bxya1 -BwNsE -JM8 -X9 -Yc -O -K -P >> plot.ps
gmt makecpt -T-1/1/0.1 -Cred2green > brasil_der_05x05.cpt
gmt grdview cut2.grd -R -J -O -K -Qi -Cbrasil_der_05x05.cpt >> plot.ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> plot.ps

gmt psxy -R -J -O -T >> plot.ps

[ -f plot.ps ] && gv plot.ps
gmt psconvert -P -A -Tf plot.ps
gmt psconvert -P -A -TG plot.ps

rm -f plot.ps cut1.grd cut2.grd brasil_der_1x1.cpt brasil_der_05x05.cpt gmt.history
