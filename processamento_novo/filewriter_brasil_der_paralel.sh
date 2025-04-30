#!/bin/bash

echo "#!/bin/bash" > $3
echo "#!/bin/bash" > $4

sul=-340
norte=60
cont=`expr $sul + $1`
contcop=$cont

while [ $cont -le $norte ]
do
	s=`bc <<< "scale=2; ($cont - $1)" | awk '{printf "%.2f", $1 / 10}' | tr ',' '.'`
	n=`bc <<< "scale=2; $cont" | awk '{printf "%.2f", $1 / 10}' | tr ',' '.'`
	nc=`bc <<< "scale=2; ($cont - $1 / 2) * 10" | awk '{printf "%.2f", $1 / 100}' | tr ',' '.'`
	echo "bash linhas_paralel.sh $1 $s $n $nc $2 der_$cont.grd" >> $3
	if [ $cont -eq $contcop ]
	then
		echo "cp der_$cont.grd figrd.grd" >> $4
	else
		echo "gmt grdpaste figrd.grd der_$cont.grd -Gfigrd1.grd" >> $4
		echo "mv figrd1.grd figrd.grd" >> $4
	fi
	cont=`expr $cont + $1`
done
