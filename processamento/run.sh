#!/bin/bash

# primeiro input eh a resolucao da grade
# segundo input eh o diametro do filtro em derivadas_paralel.sh
# terceiro input eh a porcentagem dos valores maximo de cada grade em derivadas_paralel.sh
# quarto input eh o valor minimo aceitado em derivadas_paralel.sh

res=$1
d=$2
porc=$3
min=$4
nome=`awk -v res="$res" -v d="$d" -v porc="$porc" -v min="$min" 'BEGIN {printf "grade_%dx%d_%d_%d_%d", res, res, d, porc, min}' | tr ',' '.'`

bash processamento/filewriter_brasil_der_paralel.sh $res $d $porc $min ../grades/earth.grd "$nome".sh colacola.sh
cat "$nome".sh | bash processamento/runp.sh 8
bash colacola.sh
mv figrd.grd grades/"$nome".grd
rm *.grd gmt.history "$nome".sh colacola.sh LOG*
