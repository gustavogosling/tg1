#!/bin/bash

# Derivadas
gmt grdmath "$5".grd DDX PI 6378000 $4 COSD MUL MUL 180000 1 6378000 SQR 6357000 SQR SUB 6378000 SQR DIV SQR $3 SIND SQR MUL SUB SQRT MUL DIV DIV = "$5"_ddx.grd
gmt grdmath "$5".grd DDY 111.2 DIV = "$5"_ddy.grd

# Filtragem X
gmt grdfilter -G"$5"_ddxf.grd "$5"_ddx.grd -D3 -Fb"$1"
mv "$5"_ddxf.grd "$5"_ddx.grd

# Filtragem Y
gmt grdfilter -G"$5"_ddyf.grd "$5"_ddy.grd -D3 -Fb"$1"
mv "$5"_ddyf.grd "$5"_ddy.grd

# Soma
gmt grdmath "$5"_ddx.grd SQR "$5"_ddy.grd SQR ADD SQRT = "$5"_der.grd

# Módulo de escolha dos pontos de maximo
max=`gmt grdinfo "$5"_der.grd | awk 'FNR==8 {print $5}'`
lim=`bc <<< "scale=1; $max * $2 / 100"`
gmt grdmath "$5"_der.grd $3 GE "$5"_der.grd $lim GE MUL = "$6".grd
