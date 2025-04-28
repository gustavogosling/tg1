#!/bin/bash

# opgrd1 e opgrd2 sao as 2 primeiras grades de operacao da iteracao atual
# opgrd eh a grad de operacao da iteracao atual
# ligrd eh a grade da latitude que eh a concatenacao de diversas opgrd da mesma latitude
# figrd eh a grade final na qual fico juntando as grades ligrd

# np e wp sao variaveis para o bash nao ficar maluco
# ngr sgr wgr egr sao variaveis para fazer o processamento das derivadas
# n s w e sao variaveis para recortar as grades das derivadas

cond=0
passo=0.5
xy=contornos/brasil_05x05.xy

# Encontro maxlat e minlat
maxlat=`bash minmax.sh $xy lat | awk '{print $1}'`
minlat=`bash minmax.sh $xy lat | awk '{print $2}'`

n=`bc <<< "scale=1; ($maxlat + $passo) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
s=`bc <<< "scale=1; $maxlat * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`

# nc eh importante para o derivadas.sh, para ter um valor medio da latitude de cada gradezinha
nc=`bc <<< "scale=2; ($maxlat + $passo / 2) * 100" | awk '{printf "%.2f", ($1 / 100)}' | tr ',' '.'`

# Variaveis extras para o bash nao implicar nos loops
np=`bc <<< "scale=0; $n * 10 / 1"`
minlatp=`bc <<< "scale=0; $minlat * 10 / 1"`

while [ $np -le $minlatp ] #$minlat
	do
		# mostra a latitude sul atual
		echo $s		
		
		# Encontro maxlon e minlon
		maxlon=`bash minmax.sh $xy lon $s $n | awk '{print $2}'`
		minlon=`bash minmax.sh $xy lon $s $n | awk '{print $1}'`
		
		# crio os contornos para o derivadas.sh e para recortar posteriormente
		e=`bc <<< "scale=1; ($minlon + $passo) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
		w=`bc <<< "scale=1; $minlon * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
		ngr=`bc <<< "scale=1; ($n + 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
		sgr=`bc <<< "scale=1; ($s - 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
		egr=`bc <<< "scale=1; ($e + 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
		wgr=`bc <<< "scale=1; ($w - 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`	
		
		# cria uma primeira grade de 1x1
		gmt grdcut -R$w/$e/$s/$n grades/earth.grd -Gopgrd1.grd
		bash derivadas.sh opgrd1.grd opgrd11 $nc
		gmt grdcut -R$w/$e/$s/$n opgrd11.grd -Gopgrd1.grd
			
		# atualizo os para o derivadas.sh e para recortar posteriormente
		e=`bc <<< "scale=1; ($e + $passo) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
		w=`bc <<< "scale=1; ($w + $passo) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
		egr=`bc <<< "scale=1; ($e + 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
		wgr=`bc <<< "scale=1; ($w - 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
		
		# cria uma segunda grade de 1x1
		gmt grdcut -R$wgr/$egr/$sgr/$ngr grades/earth.grd -Gopgrd2.grd
		bash derivadas.sh opgrd2.grd opgrd22 $nc
		gmt grdcut -R$w/$e/$s/$n opgrd22.grd -Gopgrd2.grd
		
		# cola as grades
		gmt grdpaste opgrd1.grd opgrd2.grd -Gligrd.grd
		
		# atualizo os contornos
		e=`bc <<< "scale=1; ($e + $passo) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
		w=`bc <<< "scale=1; ($w + $passo) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
		egr=`bc <<< "scale=1; ($e + 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
		wgr=`bc <<< "scale=1; ($w - 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
		
		# Variaveis extras para o bash nao implicar nos loops
		ep=`bc <<< "scale=0; $e * 10 / 1"`
		maxlonp=`bc <<< "scale=0; $maxlon * 10 / 1"`
		
			while [ $ep -le $maxlonp ] #$maxlon
			do
				# cria uma grade de 1 x 1
				gmt grdcut -R$wgr/$egr/$sgr/$ngr grades/earth.grd -Gopgrd.grd
				bash derivadas.sh opgrd.grd opgrdop $nc
				gmt grdcut -R$w/$e/$s/$n opgrdop.grd -Gopgrd.grd
				
				# atualiza os contornos
				e=`bc <<< "scale=1; ($e + $passo) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
				w=`bc <<< "scale=1; ($w + $passo) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
				egr=`bc <<< "scale=1; ($e + 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
				wgr=`bc <<< "scale=1; ($w - 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
				
				# cola a grade de 1x1 na grade 1x2, 1x3, 1x4 ...
				gmt grdpaste opgrd.grd ligrd.grd -Gligrd1.grd
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
		nc=`bc <<< "scale=2; ($nc + $passo) * 100" | awk '{printf "%.2f", ($1 / 100)}' | tr ',' '.'`
		
		# Variaveis extras para o bash nao implicar nos loops
		np=`bc <<< "scale=0; $n * 10 / 1"`
	done
	
mv figrd.grd grades/"$1".grd

rm -f ddx.grd ddy.grd grad.grd brasil_der.cpt
rm -f opgrd1.grd opgrd11.grd opgrd2.grd opgrd22.grd opgrd.grd opgrdop.grd ligrd1.grd ligrd.grd figrd1.grd gmt.history
