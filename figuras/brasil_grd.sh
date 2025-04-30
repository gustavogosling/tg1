#!/bin/bash

# primeiro input eh a grade
# segundo input eh o nome do output
grade=$1
contorno=$2

gmt psbasemap -R-76/-32/-36/8 -Bxya10 -BWNsE -JM12 -Xc -Y8 -K -P --FONT_ANNOT_PRIMARY=10p > "$3".ps
#~ gmt makecpt -T-1/1/0.1 -Cpolar > brasil_der.cpt
gmt makecpt -T-1/1/0.1 -Cred2green > brasil_der.cpt
gmt grdview $grade -R -J -O -K -Qi -Cbrasil_der.cpt >> "$3".ps
gmt pscoast -R -J -O -K -W0.5p -Dl -N1 -A10000+l >> "$3".ps
#~ cat $2 | gmt psxy -R -J -O -K -W2p,red >> "$3".ps
cat $2 | gmt psxy -R -J -O -K -W1p,green >> "$3".ps
gmt psxy -R -J -O -T >> "$3".ps

# -47/-43/-24/-21.5 vale do paraiba
# -60/-52/-25/-14 pantanal
# -42/-38/-8.2/-6.7 araripe

[ -f "$3".ps ] && gv "$3".ps

gmt psconvert -P -A -Tf "$3".ps
gmt psconvert -P -A -TG "$3".ps

# mudar isso aqui depois
mv "$3".png grades/
mv "$3".pdf grades/

rm -f "$3".ps brasil_der.cpt gmt.history
