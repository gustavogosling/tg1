#!/bin/bash

# primeiro input eh a resolucao (10 eh 1 grau e 05 eh 0.5 graus)
# segundo input eh a grade de onde serao realizados os cortes, i.e. earth.grd
# terceiro input eh o nome do arquivo LINHAS_DE_COMANDO (falar com bianchi se nao souber)
# quarto input eh o nome da grade final

bash filewriter_brasil_der_paralel.sh $1 $2 $3 colacola.sh
cat $3 | bash runp.sh 8
bash colacola.sh
mv figrd.grd DONTEXCLUDE
rm *.grd gmt.history $3 colacola.sh
mv DONTEXCLUDE "$4".grd
