#!/bin/bash

# primeiro input eh a grade
# segundo input eh o nome do output
grade="$1"

gmt psbasemap -R-76/-32/-36/8 -Bxya10 -BWNsE -JM12 -Xc -Y8 -K -P --FONT_ANNOT_PRIMARY=10p > "$2".ps
gmt makecpt -T-1/1/0.1 -Cpolar > brasil_der.cpt
#~ gmt makecpt -T-1/1/0.1 -Cred2green > brasil_der.cpt
gmt grdview $grade -R -J -O -K -Qi -Cbrasil_der.cpt >> "$2".ps
gmt pscoast -R -J -O -K -W0.5p -Dl -N1 -A10000+l >> "$2".ps
cat contornos/brasil_1x1.xy | gmt psxy -R -J -O -K -W2p,red >> "$2".ps
#~ cat contornos/brasil_05x05.xy | gmt psxy -R -J -O -K -W1p,green >> "$2".ps
gmt psxy -R -J -O -T >> "$2".ps

# -47/-43/-24/-21.5 vale do paraiba
# -60/-52/-25/-14 pantanal
# -42/-38/-8.2/-6.7 araripe

#~ gmt grdpaste figrd.grd ligrd.grd -Gfigrd1.grd

[ -f "$2".ps ] && gv "$2".ps

gmt psconvert -P -A -Tf "$2".ps
gmt psconvert -P -A -TG "$2".ps

# mudar isso aqui depois
mv "$2".png grades/
mv "$2".pdf grades/

rm -f "$2".ps brasil_der.cpt gmt.history
