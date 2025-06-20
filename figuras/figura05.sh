#!/bin/bash

name=figura05

grade1=grades/grade_5x5_15_40_4.grd
grade2=grades/grade_5x5_15_40_8.grd

gmt makecpt -T-1/1/0.1 -Cred2green > brasil_der_05x05.cpt

gmt grdcut -R-42/-38/-8.1/-6.9 $grade1 -Gcut1.grd
gmt psbasemap -R -Bya1 -Bxa2 -BwNse -JM8 -X1.0 -Y24.5 -K -P --FONT_ANNOT_PRIMARY=10p > "$name".ps
gmt grdview cut1.grd -R -J -O -K -Qi -Cbrasil_der_05x05.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> "$name".ps
echo "-38.5 -7.1 15_40_4" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps
echo "-41.8 -7.9 a)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

gmt grdcut -R $grade2 -Gcut2.grd
gmt psbasemap -R -Bya1 -Bxa2 -BwNsE -JM8 -X10 -Y0 -K -O -P --FONT_ANNOT_PRIMARY=10p >> "$name".ps
gmt grdview cut2.grd -R -J -O -K -Qi -Cbrasil_der_05x05.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> "$name".ps
echo "-38.5 -7.1 15_40_8" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps
echo "-41.8 -7.9 b)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

gmt psxy -R -J -O -T >> "$name".ps

gmt psconvert -P -A -TG "$name".ps

rm -f "$name".ps cut*.grd brasil_der_05x05.cpt gmt.history
