#!/bin/bash

minlon=-740
maxlon=-340
s=$2
n=$3
nc=$4
cont=$minlon

# atualizo os valores para a primeira grade
e=`bc <<< "scale=1; $cont + $1" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
w=`bc <<< "scale=1; $cont" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
ngr=`bc <<< "scale=1; ($n + 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
sgr=`bc <<< "scale=1; ($s - 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
egr=`bc <<< "scale=1; ($e + 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
wgr=`bc <<< "scale=1; ($w - 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`	

# cria a primeira grade de 1x1
nome1=`awk -v w="$w" -v e="$e" -v s="$s" -v n="$n" 'BEGIN {printf "OP_%.1f_%.1f_%.1f_%.1f", w, e, s, n}' | tr ',' '.'`
gmt grdcut -R$wgr/$egr/$sgr/$ngr $5 -G"$nome1".grd
bash derivadas_paralel.sh "$nome1" opgrd_"$nome1" $nc
gmt grdcut -R$w/$e/$s/$n opgrd_"$nome1".grd -Gopgrd_"$nome1".grd
	
# atualizo os valores para a segunda grade
cont=`expr $cont + $1`
e=`bc <<< "scale=1; $cont + $1" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
w=`bc <<< "scale=1; $cont" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
egr=`bc <<< "scale=1; ($e + 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
wgr=`bc <<< "scale=1; ($w - 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`	

# cria a segunda grade de 1x1
nome2=`awk -v w="$w" -v e="$e" -v s="$s" -v n="$n" 'BEGIN {printf "OP_%.1f_%.1f_%.1f_%.1f", w, e, s, n}' | tr ',' '.'`
gmt grdcut -R$wgr/$egr/$sgr/$ngr $5 -G"$nome2".grd
bash derivadas_paralel.sh "$nome2" opgrd_"$nome2" $nc
gmt grdcut -R$w/$e/$s/$n opgrd_"$nome2".grd -Gopgrd_"$nome2".grd

# cola as grades
nomelinha=`awk -v s="$s" -v n="$n" 'BEGIN {printf "LI_%.1f_%.1f", s, n}' | tr ',' '.'`
gmt grdpaste opgrd_"$nome1".grd opgrd_"$nome2".grd -Gligrd_"$nomelinha".grd

# da uma limpada
rm *"$nome1"*.grd *"$nome2"*.grd

# atualizo os contornos
cont=`expr $cont + $1`
e=`bc <<< "scale=1; $cont + $1" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
w=`bc <<< "scale=1; $cont" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
egr=`bc <<< "scale=1; ($e + 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
wgr=`bc <<< "scale=1; ($w - 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`

while [ $cont -lt $maxlon ]
do
	# cria uma grade de 1 x 1
	nome=`awk -v w="$w" -v e="$e" -v s="$s" -v n="$n" 'BEGIN {printf "OP_%.1f_%.1f_%.1f_%.1f", w, e, s, n}' | tr ',' '.'`
	gmt grdcut -R$wgr/$egr/$sgr/$ngr $5 -G"$nome".grd
	bash derivadas_paralel.sh "$nome" opgrd_"$nome" $nc
	gmt grdcut -R$w/$e/$s/$n opgrd_"$nome".grd -Gopgrd_"$nome".grd
	
	# atualiza os contornos
	cont=`expr $cont + $1`
	e=`bc <<< "scale=1; $cont + $1" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
	w=`bc <<< "scale=1; $cont" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
	egr=`bc <<< "scale=1; ($e + 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
	wgr=`bc <<< "scale=1; ($w - 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
	
	# cola a grade de 1x1 na grade 1x2, 1x3, 1x4 ...
	gmt grdpaste opgrd_"$nome".grd ligrd_"$nomelinha".grd -Gligrd1_"$nomelinha".grd
	mv ligrd1_"$nomelinha".grd ligrd_"$nomelinha".grd
	
	# da uma limpada
	rm *"$nome"*.grd
done

mv ligrd_"$nomelinha".grd $6
