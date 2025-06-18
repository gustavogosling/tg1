#!/bin/bash

name=figura3

# Recorta um pedaço da grade
gmt grdcut grades/earth.grd -R-76/-32/-36/8 -Gbrasil.grd
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

# Paleta topo
gmt makecpt -T-7000/7000/100 -Cterra > pal_t.cpt

# Topo
gmt psbasemap -R-76/-32/-36/8 -Bxya10 -BwNse -JM8 -X2 -Yc -K -P --FONT_ANNOT_PRIMARY=10p > "$name".ps
gmt grdview -R -J -O -K brasil.grd -Qi -Cpal_t.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Dl -N1 -A10000+l >> "$name".ps
gmt psscale -Dx0.75/-0.75+w6.5/0.25+h -Ba5000f50:'Topografia (m)': -J -R -Cpal_t.cpt -O -K --FONT_ANNOT_PRIMARY=10p --FONT_LABEL=11p  >> "$name".ps
echo "-37 -33 a)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

# Paleta der
gmt makecpt -T0/100/10 -Cgray -I > pal_d.cpt

# Der
gmt psbasemap -R -Bxya10 -BwNsE -JM8 -X9 -Yc -K -O -P --FONT_ANNOT_PRIMARY=10p >> "$name".ps
gmt grdview -R -J -O -K grad.grd -Qi -Cpal_d.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Dl -N1 -A10000+l >> "$name".ps
cat contornos/brasil_1x1.xy | gmt psxy -R -J -O -K -W2p,red >> "$name".ps
cat contornos/brasil_05x05.xy | gmt psxy -R -J -O -K -W1p,green >> "$name".ps
cat contornos/resolucao_1x1.xy | gmt psxy -R -J -O -K -W2p,red >> "$name".ps
cat contornos/resolucao_05x05.xy | gmt psxy -R -J -O -K -W1p,green >> "$name".ps
gmt pslegend -R -J -O -K -Dg-74/-35+w2.6c+jBL -F+p+gazure1+r --FONT_ANNOT_PRIMARY=8 >> "$name".ps << EOF
G 0.05c
S 0.15c r 0.25c red 0p 0.35c 1.0 x 1.0 grau 
G 0.05c
S 0.15c r 0.25c green 0p 0.35c 0.5 x 0.5 grau
G 0.05c
EOF
gmt psscale -Dx0.75/-0.75+w6.5/0.25+h -Ba50f5:'GHT (m/km)': -J -R -Cpal_d.cpt -O -K --FONT_ANNOT_PRIMARY=10p --FONT_LABEL=11p  >> "$name".ps
echo "-37 -33 b)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

gmt psxy -R -J -O -T >> "$name".ps

[ -f "$name".ps ] && gv "$name".ps
gmt psconvert -P -A -TG "$name".ps

rm -f "$name".ps brasil.grd brasil_1x1.grd pal.cpt gmt.history
rm -f grad.grd brasil_1x1.grd
rm -f cut.grd ddx.grd ddy.grd pal_t.cpt pal_d.cpt legend.ps
