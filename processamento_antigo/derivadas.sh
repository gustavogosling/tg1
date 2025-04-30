#!/bin/bash

# Derivadas
gmt grdmath $1 DDX PI 6378000 $3 COSD MUL MUL 180000 1 6378000 SQR 6357000 SQR SUB 6378000 SQR DIV SQR $3 SIND SQR MUL SUB SQRT MUL DIV DIV = ddx.grd # formula absurda para calcular a medida equivalente para cada grau
gmt grdmath $1 DDY 111.2 DIV = ddy.grd

# Filtragem X
gmt grdfilter -Gddxf.grd ddx.grd -D3 -Fb20
mv ddxf.grd ddx.grd

# Filtragem Y
gmt grdfilter -Gddyf.grd ddy.grd -D3 -Fb20
mv ddyf.grd ddy.grd

# Soma
gmt grdmath ddx.grd SQR ddy.grd SQR ADD SQRT = grad.grd

# modulo de escolha dos pontos de maximo
max=`gmt grdinfo grad.grd | awk 'FNR==8 {print $5}'`
lim=`bc <<< "scale=1; $max * 0.5"`
gmt grdmath grad.grd 10 GE grad.grd $lim GE MUL = "$2".grd
