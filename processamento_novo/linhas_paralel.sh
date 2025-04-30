#!/bin/bash

# primeiro input eh a resolucao da grade
# segundo input eh o diametro do filtro em derivadas_paralel.sh
# terceiro input eh a porcentagem dos valores maximo de cada grade em derivadas_paralel.sh
# quarto input eh o valor minimo aceitado em derivadas_paralel.sh
# quinto input eh a latitude sul da faixa
# sexto input eh a latitude norte da faixa
# setimo input eh a latitude central da faixa (usado em derivadas_paralel.sh)
# oitvao input eh a grade de onde vao ser retiradas as outras grades (setada em run.sh)
# nono input eh a grade de saida do script, que vai ser usado em colacola.sh

minlon=-740
maxlon=-340
s=$5
n=$6
nc=$7
cont=$minlon

# atualizo os valores para a primeira grade
e=`bc <<< "scale=1; $cont + $1" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
w=`bc <<< "scale=1; $cont" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
ngr=`bc <<< "scale=1; ($n + 0.075) * 1000" | awk '{printf "%.1f", ($1 / 1000)}' | tr ',' '.'`
sgr=`bc <<< "scale=1; ($s - 0.075) * 1000" | awk '{printf "%.1f", ($1 / 1000)}' | tr ',' '.'`
egr=`bc <<< "scale=1; ($e + 0.075) * 1000" | awk '{printf "%.1f", ($1 / 1000)}' | tr ',' '.'`
wgr=`bc <<< "scale=1; ($w - 0.075) * 1000" | awk '{printf "%.1f", ($1 / 1000)}' | tr ',' '.'`	

# cria a primeira grade de 1x1
nome1=`awk -v w="$w" -v e="$e" -v s="$s" -v n="$n" 'BEGIN {printf "OP_%.1f_%.1f_%.1f_%.1f", w, e, s, n}' | tr ',' '.'`
gmt grdcut -R$wgr/$egr/$sgr/$ngr $8 -G"$nome1".grd
bash derivadas_paralel.sh $2 $3 $4 $nc "$nome1" opgrd_"$nome1"
gmt grdcut -R$w/$e/$s/$n opgrd_"$nome1".grd -Gopgrd_"$nome1".grd
	
# atualizo os valores para a segunda grade
cont=`expr $cont + $1`
e=`bc <<< "scale=1; $cont + $1" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
w=`bc <<< "scale=1; $cont" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
egr=`bc <<< "scale=1; ($e + 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
wgr=`bc <<< "scale=1; ($w - 0.1) * 10" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`	

# cria a segunda grade de 1x1
nome2=`awk -v w="$w" -v e="$e" -v s="$s" -v n="$n" 'BEGIN {printf "OP_%.1f_%.1f_%.1f_%.1f", w, e, s, n}' | tr ',' '.'`
gmt grdcut -R$wgr/$egr/$sgr/$ngr $8 -G"$nome2".grd
bash derivadas_paralel.sh $2 $3 $4 $nc "$nome2" opgrd_"$nome2"
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
egr=`bc <<< "scale=1; ($e + 0.075) * 1000" | awk '{printf "%.1f", ($1 / 1000)}' | tr ',' '.'`
wgr=`bc <<< "scale=1; ($w - 0.075) * 1000" | awk '{printf "%.1f", ($1 / 1000)}' | tr ',' '.'`	

while [ $cont -lt $maxlon ]
do
	# cria uma grade de 1 x 1
	nome=`awk -v w="$w" -v e="$e" -v s="$s" -v n="$n" 'BEGIN {printf "OP_%.1f_%.1f_%.1f_%.1f", w, e, s, n}' | tr ',' '.'`
	gmt grdcut -R$wgr/$egr/$sgr/$ngr $8 -G"$nome".grd
	bash derivadas_paralel.sh $2 $3 $4 $nc "$nome" opgrd_"$nome"
	gmt grdcut -R$w/$e/$s/$n opgrd_"$nome".grd -Gopgrd_"$nome".grd
	
	# atualiza os contornos
	cont=`expr $cont + $1`
	e=`bc <<< "scale=1; $cont + $1" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
	w=`bc <<< "scale=1; $cont" | awk '{printf "%.1f", ($1 / 10)}' | tr ',' '.'`
	egr=`bc <<< "scale=1; ($e + 0.075) * 1000" | awk '{printf "%.1f", ($1 / 1000)}' | tr ',' '.'`
	wgr=`bc <<< "scale=1; ($w - 0.075) * 1000" | awk '{printf "%.1f", ($1 / 1000)}' | tr ',' '.'`	
	
	# cola a grade de 1x1 na grade 1x2, 1x3, 1x4 ...
	gmt grdpaste opgrd_"$nome".grd ligrd_"$nomelinha".grd -Gligrd1_"$nomelinha".grd
	mv ligrd1_"$nomelinha".grd ligrd_"$nomelinha".grd
	
	# da uma limpada
	rm *"$nome"*.grd
done

mv ligrd_"$nomelinha".grd $9
