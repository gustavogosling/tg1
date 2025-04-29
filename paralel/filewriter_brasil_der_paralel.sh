#!/bin/bash

echo "#!/bin/bash" > $3
echo "" >> $3


sul=-340
norte=60
oeste=-740
cont=`expr $sul + $1`

if [ $1 -eq 10 ]
then
	leste=-340
elif [ $1 -eq 05 ]
then
	leste=-345
fi

while [ $cont -le $norte ]
	do
	s=`bc <<< "scale=2; ($cont - $1)" | awk '{printf "%.2f", $1 / 10}' | tr ',' '.'`
	n=`bc <<< "scale=2; $cont" | awk '{printf "%.2f", $1 / 10}' | tr ',' '.'`
	nc=`bc <<< "scale=2; ($cont - $1 / 2) * 10" | awk '{printf "%.2f", $1 / 100}' | tr ',' '.'`
	echo "bash derivadas_paralel.sh $s $n $nc $2" >> $3
	cont=`expr $cont + $1`
	done
