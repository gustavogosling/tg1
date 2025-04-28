#!/bin/bash

# primeiro input eh a grade
# segundo input eh o nome do output
grade="$1"
name="$2".ps

gmt psbasemap -R-76/-32/-36/8 -Bxya10 -BWNsE -JM12 -Xc -Y8 -K -P > $name
#~ gmt makecpt -T-1/1/0.1 -Cpolar > brasil_der.cpt
gmt makecpt -T-1/1/0.1 -Cred2green > brasil_der.cpt
gmt grdview $grade -R -J -O -K -Qi -Cbrasil_der.cpt >> $name
gmt pscoast -R -J -O -K -W0.5p -Dl -N1 -A10000+l >> $name
#~ cat contornos/brasil_1x1.xy | gmt psxy -R -J -O -K -W2p,red >> $name
cat contornos/brasil_05x05.xy | gmt psxy -R -J -O -K -W1p,green >> $name
gmt psxy -R -J -O -T >> $name

# -47/-43/-24/-21.5 vale do paraiba
# -60/-52/-25/-14 pantanal
# -42/-38/-8.2/-6.7 araripe

#~ gmt grdpaste figrd.grd ligrd.grd -Gfigrd1.grd

[ -f $name ] && gv $name

gmt psconvert -P -A -Tf $name
gmt psconvert -P -A -TG $name

rm -f $name brasil_der.cpt gmt.history
