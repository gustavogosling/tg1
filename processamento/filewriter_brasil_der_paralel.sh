#!/bin/bash

# primeiro input eh a resolucao da grade
# segundo input eh o diametro do filtro em derivadas_paralel.sh
# terceiro input eh a porcentagem dos valores maximo de cada grade em derivadas_paralel.sh
# quarto input eh o valor minimo aceitado em derivadas_paralel.sh
# quinto input eh a grade de onde vao ser retiradas as outras grades (setada em run.sh)
# sexto input eh o nome do arquivo LINHAS DE COMANDO (setado em run.sh)
# setimo input eh o nome do arquivo que costura as grades (colacola.sh, setado em run.sh)

echo "#!/bin/bash" > $6
echo "#!/bin/bash" > $7

sul=-340
norte=60
cont=`expr $sul + $1`
contcop=$cont

while [ $cont -le $norte ]
do
	s=`bc <<< "scale=2; ($cont - $1)" | awk '{printf "%.2f", $1 / 10}'`
	n=`bc <<< "scale=2; $cont" | awk '{printf "%.2f", $1 / 10}'`
	nc=`bc <<< "scale=2; ($cont - $1 / 2) * 10" | awk '{printf "%.2f", $1 / 100}'`
	echo "bash linhas_paralel.sh $1 $2 $3 $4 $s $n $nc $5 der_$cont.grd" >> $6
	if [ $cont -eq $contcop ]
	then
		echo "cp der_$cont.grd figrd.grd" >> $7
	else
		echo "gmt grdpaste figrd.grd der_$cont.grd -Gfigrd1.grd" >> $7
		echo "mv figrd1.grd figrd.grd" >> $7
	fi
	cont=`expr $cont + $1`
done
