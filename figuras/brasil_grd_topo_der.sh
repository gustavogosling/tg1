#!/bin/bash

# primeiro input eh a grade
name="$1".ps

# Recorta um pedaço da grade
gmt grdcut grades/earth.grd -R-76/-32/-36/8 -Gbrasil.grd
gmt grdcut grades/earth.grd -Fbrasil_1x1.xy+c -Gbrasil_1x1.grd 

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
gmt psbasemap -R-76/-32/-36/8 -Bxya10 -BWNse -JM8 -X2 -Yc -K -P --FONT_ANNOT_PRIMARY=10p > $name
gmt grdview -R -J -O -K brasil.grd -Qi -Cpal_t.cpt >> $name
gmt pscoast -R -J -O -K -W0.5p -Dl -N1 -A10000+l >> $name
cat contornos/brasil_1x1.xy | gmt psxy -R -J -O -K -W2p,red >> $name
cat contornos/brasil_05x05.xy | gmt psxy -R -J -O -K -W1p,green >> $name
gmt psscale -Dx0.75/-0.75+w6.5/0.25+h -Ba5000f50:'Topografia (m)': -J -R -Cpal_t.cpt -O -K --FONT_ANNOT_PRIMARY=10p --FONT_LABEL=11p  >> name

# Paleta der
gmt makecpt -T0/100/10 -Cgray -I > pal_d.cpt


# Der
gmt psbasemap -R -Bxya10 -BwNsE -JM8 -X9 -Yc -K -O -P --FONT_ANNOT_PRIMARY=10p >> $name
gmt grdview -R -J -O -K grad.grd -Qi -Cpal_d.cpt >> $name
gmt pscoast -R -J -O -K -W0.5p -Dl -N1 -A10000+l >> $name
cat contornos/brasil_1x1.xy | gmt psxy -R -J -O -K -W2p,red >> $name
cat contornos/brasil_05x05.xy | gmt psxy -R -J -O -K -W1p,green >> $name
cat contornos/resolucao_1x1.xy | gmt psxy -R -J -O -K -W2p,red >> $name
cat contornos/resolucao_05x05.xy | gmt psxy -R -J -O -K -W1p,green >> $name
gmt psscale -Dx0.75/-0.75+w6.5/0.25+h -Ba50f5:'Soma quadrática das derivadas (m/km)': -J -R -Cpal_d.cpt -O -K --FONT_ANNOT_PRIMARY=10p --FONT_LABEL=11p  >> name

gmt psxy -R -J -O -T >> $name

[ -f $name ] && gv $name
gmt psconvert -P -A -Tf $name
gmt psconvert -P -A -TG $name

rm -f $name brasil.grd pal.cpt gmt.history
rm -f grad.grd brasil_1x1.grd
rm -f cut.grd ddx.grd ddy.grd pal_t.cpt pal_d.cpt
