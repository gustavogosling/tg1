#!/bin/bash

name=figura10

# Recorta um pedaço da grade
gmt grdcut grades/earth.grd -Fcontornos/brasil_05x05.xy+c -Gbrasil_05x05.grd 

# Derivada
gmt grdmath brasil_05x05.grd DDX 111.2 DIV = ddx.grd
gmt grdmath brasil_05x05.grd DDY 111.2 DIV = ddy.grd

# Filtragem X
gmt grdfilter -Gddxf.grd ddx.grd -D3 -Fb25
mv ddxf.grd ddx.grd

# Filtragem Y
gmt grdfilter -Gddyf.grd ddy.grd -D3 -Fb25
mv ddyf.grd ddy.grd

# Soma
gmt grdmath ddx.grd SQR ddy.grd SQR ADD SQRT = grad.grd

max=`gmt grdinfo grad.grd | awk 'FNR==8 {print $5}'`
lim=`bc <<< "scale=1; $max * 5 / 100"`
gmt grdmath grad.grd $lim GE = grad2.grd
mv grad2.grd grad.grd

grade=grades/grade_5x5_25_40_8.grd
contorno=contornos/brasil_05x05.xy

gmt psbasemap -R-76/-32/-36/8 -Bxya10 -BwNse -JM8 -X2 -Yc -K -P --FONT_ANNOT_PRIMARY=8p > "$name".ps
gmt makecpt -T-1/1/0.1 -Cred2green > brasil_der.cpt
gmt grdcut $grade -F$contorno -GBR_grade.grd
gmt grdview BR_grade.grd -R -J -O -K -Qi -Cbrasil_der.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Dl -N1 -A10000+l >> "$name".ps
cat $contorno | gmt psxy -R -J -O -K -W1p,green >> "$name".ps
echo "-37 -33 a)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

# Paleta der
gmt makecpt -T0/1/0.1 -Cgray -I > pal_d.cpt

# Der
gmt psbasemap -R -Bxya10 -BwNsE -JM8 -X9 -Yc -K -O -P --FONT_ANNOT_PRIMARY=10p >> "$name".ps
gmt grdview -R -J -O -K grad.grd -Qi -Cpal_d.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Dl -N1 -A10000+l >> "$name".ps
cat contornos/brasil_05x05.xy | gmt psxy -R -J -O -K -W1p,black >> "$name".ps
echo "-37 -33 b)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

gmt psxy -R -J -O -T >> "$name".ps

[ -f "$name".ps ] && gv "$name".ps
gmt psconvert -P -A -TG "$name".ps

rm -f "$name".ps grad.grd brasil_05x05.grd pal.cpt gmt.history
rm -f ddx.grd ddy.grd pal_t.cpt pal_d.cpt legend.ps
rm -f BR_grade.grd brasil_der.cpt
