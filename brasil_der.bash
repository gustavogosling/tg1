#!/bin/bash

# opgrd1 e opgrd2 sao as 2 primeiras grades de operacao da iteracao atual
# opgrd eh a grad de operacao da iteracao atual
# ligrd eh a grade da latitude que eh a concatenacao de diversas opgrd da mesma latitude
# figrd eh a grade final na qual fico juntando as grades ligrd

cond=0
passo=0.5
xy=brasil_05x05.xy

# Encontro maxlat e minlat
maxlat=`bash minmax.bash $xy lat | awk '{print $1}'`
minlat=`bash minmax.bash $xy lat | awk '{print $2}'`

n=`bc <<< "scale=1; ($maxlat + $passo) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
s=`bc <<< "scale=1; $maxlat * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`

# Variaveis extras para o bash nao implicar nos loops
np=`bc <<< "scale=0; $n * 10 / 1"`
minlatp=`bc <<< "scale=0; ($minlat * 10) / 1"`

if [ $cond -eq 0 ]
then
	while [ $np -le $minlatp ] #$minlat
		do
			# mostra a latitude sul atual
			echo $s		
			
			# Encontro maxlon e minlon
			maxlon=`bash minmax.bash $xy lon $s $n | awk '{print $2}'`
			minlon=`bash minmax.bash $xy lon $s $n | awk '{print $1}'`
			
			# cria uma primeira grade de 1x1
			e=`bc <<< "scale=1; ($minlon + $passo) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
			w=`bc <<< "scale=1; $minlon * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
			gmt grdcut -R$w/$e/$s/$n Grades/earth.grd -Gopgrd1.grd
			bash derivadas.bash opgrd1.grd opgrd11 $n
			
			# cria uma segunda grade de 1x1
			e=`bc <<< "scale=1; ($e + $passo) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
			w=`bc <<< "scale=1; ($w + $passo) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
			gmt grdcut -R$w/$e/$s/$n Grades/earth.grd -Gopgrd2.grd
			bash derivadas.bash opgrd2.grd opgrd22 $n
			
			# atualiza "w" e "e" e cola as grades
			e=`bc <<< "scale=1; ($e + $passo) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
			w=`bc <<< "scale=1; ($w + $passo) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
			gmt grdpaste opgrd11.grd opgrd22.grd -Gligrd.grd
			
			# Variaveis extras para o bash nao implicar nos loops
			ep=`bc <<< "scale=0; $e * 10 / 1"`
			maxlonp=`bc <<< "scale=0; $maxlon * 10 / 1"`
			
				while [ $ep -le $maxlonp ] #$maxlon
				do
					# cria uma grade de 1 x 1
					gmt grdcut -R$w/$e/$s/$n Grades/earth.grd -Gopgrd.grd
					bash derivadas.bash opgrd.grd opgrdop $n
					
					# atualiza "w" e "e" e cola a grade de 1x1 na grade 2x1, 3x1, 4x1 ...
					e=`bc <<< "scale=1; ($e + $passo) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
					w=`bc <<< "scale=1; ($w + $passo) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
					gmt grdpaste opgrdop.grd ligrd.grd -Gligrd1.grd
					mv ligrd1.grd ligrd.grd
					
					# Variaveis extras para o bash nao implicar nos loops
					ep=`bc <<< "scale=0; $e * 10 / 1"`
				done
		
			# primeira vez que uma grade nX1 foi feira, cria uma grade final que eh igual a grade nx1
			if [ $cond = 0 ] 
			then
				cp ligrd.grd figrd.grd
				cond=1
			# para o restante dos casos vai concatenando com a margem em comum
			else
				gmt grdblend ligrd.grd figrd.grd -R-74/-34/-34/6 -I2m -Gfigrd1.grd # $minlon/$maxlon/$maxlat/$n
				mv figrd1.grd figrd.grd
			fi
			
			n=`bc <<< "scale=1; ($n + $passo) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
			s=`bc <<< "scale=1; ($s + $passo) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
			
			# Variaveis extras para o bash nao implicar nos loops
			np=`bc <<< "scale=0; $n * 10 / 1"`
		done
fi

gmt psbasemap -R-76/-32/-36/8 -Bxya10 -BWNsE -JM12 -Xc -Y8 -K -P > plot.ps
#~ gmt makecpt -T-1/1/0.1 -Cpolar > brasil_der.cpt
gmt makecpt -T-1/1/0.1 -Cred2green > brasil_der.cpt
gmt grdview  figrd.grd -R -J -O -K -Qi -Cbrasil_der.cpt >> plot.ps
gmt pscoast -R -J -O -K -W0.5p -Dl -N1 -A10000+l >> plot.ps
#~ cat brasil_1x1.xy | gmt psxy -R -J -O -K -W2p,red >> plot.ps
cat brasil_05x05.xy | gmt psxy -R -J -O -K -W1p,green >> plot.ps
gmt psxy -R -J -O -T >> plot.ps

# -47/-43/-24/-21.5 vale do paraiba
# -60/-52/-25/-14 pantanal
# -42/-38/-8.2/-6.7 araripe

#~ gmt grdpaste figrd.grd ligrd.grd -Gfigrd1.grd

[ -f plot.ps ] && gv plot.ps

gmt psconvert -P -A -Tf plot.ps
gmt psconvert -P -A -TG plot.ps

rm -f plot.ps brasil_der.cpt
rm -f ddx.grd ddy.grd grad.grd brasil_der.cpt
rm -f opgrd1.grd opgrd11.grd opgrd2.grd opgrd22.grd opgrd.grd opgrdop.grd ligrd1.grd ligrd.grd figrd1.grd gmt.history
