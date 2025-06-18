#!/bin/bash

name=figura4

gmt grdcut grades/earth.grd -Fcontornos/brasil_1x1.xy+c -Gbrasil_1x1.grd 

# Derivada
gmt grdmath brasil_1x1.grd DDX 111.2 DIV = ddx.grd
gmt grdmath brasil_1x1.grd DDY 111.2 DIV = ddy.grd

# Filtragem X
gmt grdfilter -Gddxf.grd ddx.grd -D3 -Fb15
mv ddxf.grd ddx.grd

# Filtragem Y
gmt grdfilter -Gddyf.grd ddy.grd -D3 -Fb15
mv ddyf.grd ddy.grd

# Soma
gmt grdmath ddx.grd SQR ddy.grd SQR ADD SQRT = grad.grd

gmt makecpt -T0/100/10 -Cgray -I > pal_d.cpt

# Recorta um pedaço da grade
gmt psbasemap -R-42/-38/-8.1/-6.9 -Bya1 -Bxa1 -BwNsE -JM10 -X2 -Yc -P -K --FONT_ANNOT_PRIMARY=6p > "$name".ps
gmt makecpt -T0/100/10 -Cgray -I > pal_d.cpt
gmt grdview grad.grd -R -J -O -K -Qi -Cpal_d.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> "$name".ps
gmt psscale -Dx2/-0.6+w6/0.2+h -Ba50f5:'GHT (m/km)': -J -R -Cpal_d.cpt -O -K --FONT_ANNOT_PRIMARY=6p --FONT_LABEL=7p  >> "$name".ps

gmt psxy -R -J -O -T >> "$name".ps

[ -f "$name".ps ] && gv "$name".ps
gmt psconvert -P -A -TG "$name".ps

rm -f "$name".ps brasil.grd brasil_1x1.grd grad.grd ddx.grd ddy.grd pal_d.cpt gmt.history
