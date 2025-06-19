#!/bin/bash

name=apendiceA1

grade1=grades/grade_10x10_10_40_4.grd
grade2=grades/grade_10x10_15_40_4.grd
grade3=grades/grade_10x10_20_40_4.grd
grade4=grades/grade_10x10_25_40_4.grd
grade5=grades/grade_10x10_10_50_4.grd
grade6=grades/grade_10x10_15_50_4.grd
grade7=grades/grade_10x10_20_50_4.grd
grade8=grades/grade_10x10_25_50_4.grd
grade9=grades/grade_10x10_10_40_8.grd
grade10=grades/grade_10x10_15_40_8.grd
grade11=grades/grade_10x10_20_40_8.grd
grade12=grades/grade_10x10_25_40_8.grd
grade13=grades/grade_10x10_10_50_8.grd
grade14=grades/grade_10x10_15_50_8.grd
grade15=grades/grade_10x10_20_50_8.grd
grade16=grades/grade_10x10_25_50_8.grd

gmt makecpt -T-1/1/0.1 -Cpolar > brasil_der_1x1.cpt

gmt grdcut -R-42/-38/-8.1/-6.9 $grade1 -Gcut1.grd
gmt psbasemap -R -Bya1 -Bxa2 -BwNse -JM8 -X1.0 -Y24.5 -K -P --FONT_ANNOT_PRIMARY=10p > "$name".ps
gmt grdview cut1.grd -R -J -O -K -Qi -Cbrasil_der_1x1.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> "$name".ps
echo "-38.5 -7.1 10_40_4" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps
echo "-41.8 -7.9 a)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

gmt grdcut -R $grade2 -Gcut2.grd
gmt psbasemap -R -Bya1 -Bxa2 -Bwnse -JM8 -X0 -Y-3 -O -K -P --FONT_ANNOT_PRIMARY=10p >> "$name".ps
gmt grdview cut2.grd -R -J -O -K -Qi -Cbrasil_der_1x1.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> "$name".ps
echo "-38.5 -7.1 15_40_4" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps
echo "-41.8 -7.9 b)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

gmt grdcut -R $grade3 -Gcut3.grd
gmt psbasemap -R -Bya1 -Bxa2 -Bwnse -JM8 -X0 -Y-3 -O -K -P --FONT_ANNOT_PRIMARY=10p >> "$name".ps
gmt grdview cut3.grd -R -J -O -K -Qi -Cbrasil_der_1x1.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> "$name".ps
echo "-38.5 -7.1 20_40_4" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps
echo "-41.8 -7.9 c)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

gmt grdcut -R $grade4 -Gcut4.grd
gmt psbasemap -R -Bya1 -Bxa2 -Bwnse -JM8 -X0 -Y-3 -O -K -P --FONT_ANNOT_PRIMARY=10p >> "$name".ps
gmt grdview cut4.grd -R -J -O -K -Qi -Cbrasil_der_1x1.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> "$name".ps
echo "-38.5 -7.1 25_40_4" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps
echo "-41.8 -7.9 d)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

gmt grdcut -R $grade5 -Gcut5.grd
gmt psbasemap -R -Bya1 -Bxa2 -Bwnse -JM8 -X0 -Y-3 -O -K -P --FONT_ANNOT_PRIMARY=10p >> "$name".ps
gmt grdview cut5.grd -R -J -O -K -Qi -Cbrasil_der_1x1.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> "$name".ps
echo "-38.5 -7.1 10_50_4" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps
echo "-41.8 -7.9 e)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

gmt grdcut -R $grade6 -Gcut6.grd
gmt psbasemap -R -Bya1 -Bxa2 -Bwnse -JM8 -X0 -Y-3 -O -K -P --FONT_ANNOT_PRIMARY=10p >> "$name".ps
gmt grdview cut6.grd -R -J -O -K -Qi -Cbrasil_der_1x1.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> "$name".ps
echo "-38.5 -7.1 15_50_4" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps
echo "-41.8 -7.9 f)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

gmt grdcut -R $grade7 -Gcut7.grd
gmt psbasemap -R -Bya1 -Bxa2 -Bwnse -JM8 -X0 -Y-3 -O -K -P --FONT_ANNOT_PRIMARY=10p >> "$name".ps
gmt grdview cut7.grd -R -J -O -K -Qi -Cbrasil_der_1x1.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> "$name".ps
echo "-38.5 -7.1 20_50_4" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps
echo "-41.8 -7.9 g)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

gmt grdcut -R $grade8 -Gcut8.grd
gmt psbasemap -R -Bya1 -Bxa2 -Bwnse -JM8 -X0 -Y-3 -O -K -P --FONT_ANNOT_PRIMARY=10p >> "$name".ps
gmt grdview cut8.grd -R -J -O -K -Qi -Cbrasil_der_1x1.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> "$name".ps
echo "-38.5 -7.1 25_50_4" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps
echo "-41.8 -7.9 h)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

gmt grdcut -R $grade9 -Gcut9.grd
gmt psbasemap -R -Bya1 -Bxa2 -BwNsE -JM8 -X10 -Y21 -O -K -P --FONT_ANNOT_PRIMARY=10p >> "$name".ps
gmt grdview cut9.grd -R -J -O -K -Qi -Cbrasil_der_1x1.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> "$name".ps
echo "-38.5 -7.1 10_40_8" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps
echo "-41.8 -7.9 i)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

gmt grdcut -R $grade10 -Gcut10.grd
gmt psbasemap -R -Bya1 -Bxa2 -BwnsE -JM8 -X0 -Y-3 -O -K -P --FONT_ANNOT_PRIMARY=10p >> "$name".ps
gmt grdview cut10.grd -R -J -O -K -Qi -Cbrasil_der_1x1.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> "$name".ps
echo "-38.5 -7.1 15_40_8" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps
echo "-41.8 -7.9 j)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

gmt grdcut -R $grade11 -Gcut11.grd
gmt psbasemap -R -Bya1 -Bxa2 -BwnsE -JM8 -X0 -Y-3 -O -K -P --FONT_ANNOT_PRIMARY=10p >> "$name".ps
gmt grdview cut11.grd -R -J -O -K -Qi -Cbrasil_der_1x1.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> "$name".ps
echo "-38.5 -7.1 20_40_8" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps
echo "-41.8 -7.9 k)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

gmt grdcut -R $grade12 -Gcut12.grd
gmt psbasemap -R -Bya1 -Bxa2 -BwnsE -JM8 -X0 -Y-3 -O -K -P --FONT_ANNOT_PRIMARY=10p >> "$name".ps
gmt grdview cut12.grd -R -J -O -K -Qi -Cbrasil_der_1x1.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> "$name".ps
echo "-38.5 -7.1 25_40_8" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps
echo "-41.8 -7.9 l)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

gmt grdcut -R $grade13 -Gcut13.grd
gmt psbasemap -R -Bya1 -Bxa2 -BwnsE -JM8 -X0 -Y-3 -O -K -P --FONT_ANNOT_PRIMARY=10p >> "$name".ps
gmt grdview cut13.grd -R -J -O -K -Qi -Cbrasil_der_1x1.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> "$name".ps
echo "-38.5 -7.1 10_50_8" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps
echo "-41.8 -7.9 m)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

gmt grdcut -R $grade14 -Gcut14.grd
gmt psbasemap -R -Bya1 -Bxa2 -BwnsE -JM8 -X0 -Y-3 -O -K -P --FONT_ANNOT_PRIMARY=10p >> "$name".ps
gmt grdview cut14.grd -R -J -O -K -Qi -Cbrasil_der_1x1.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> "$name".ps
echo "-38.5 -7.1 15_50_8" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps
echo "-41.8 -7.9 n)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

gmt grdcut -R $grade15 -Gcut15.grd
gmt psbasemap -R -Bya1 -Bxa2 -BwnsE -JM8 -X0 -Y-3 -O -K -P --FONT_ANNOT_PRIMARY=10p >> "$name".ps
gmt grdview cut15.grd -R -J -O -K -Qi -Cbrasil_der_1x1.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> "$name".ps
echo "-38.5 -7.1 20_50_8" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps
echo "-41.8 -7.9 o)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

gmt grdcut -R $grade16 -Gcut16.grd
gmt psbasemap -R -Bya1 -Bxa2 -BwnsE -JM8 -X0 -Y-3 -O -K -P --FONT_ANNOT_PRIMARY=10p >> "$name".ps
gmt grdview cut16.grd -R -J -O -K -Qi -Cbrasil_der_1x1.cpt >> "$name".ps
gmt pscoast -R -J -O -K -W0.5p -Di -N2 -A10000+l >> "$name".ps
echo "-38.5 -7.1 25_50_8" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps
echo "-41.8 -7.9 p)" | gmt pstext -R -J -O -K -F+f12,Helvetica-Bold -Gwhite >> "$name".ps

gmt psxy -R -J -O -T >> "$name".ps

gmt psconvert -P -A -TG "$name".ps

rm -f "$name".ps cut*.grd brasil_der_1x1.cpt gmt.history
