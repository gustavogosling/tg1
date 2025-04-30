#!/bin/bash

# Derivadas
gmt grdmath "$1".grd DDX PI 6378000 $3 COSD MUL MUL 180000 1 6378000 SQR 6357000 SQR SUB 6378000 SQR DIV SQR $3 SIND SQR MUL SUB SQRT MUL DIV DIV = "$1"_ddx.grd
gmt grdmath "$1".grd DDY 111.2 DIV = "$1"_ddy.grd

# Filtragem X
gmt grdfilter -G"$1"_ddxf.grd "$1"_ddx.grd -D3 -Fb20
mv "$1"_ddxf.grd "$1"_ddx.grd

# Filtragem Y
gmt grdfilter -G"$1"_ddyf.grd "$1"_ddy.grd -D3 -Fb20
mv "$1"_ddyf.grd "$1"_ddy.grd

# Soma
gmt grdmath "$1"_ddx.grd SQR "$1"_ddy.grd SQR ADD SQRT = "$1"_der.grd

# Módulo de escolha dos pontos de maximo
max=`gmt grdinfo "$1"_der.grd | awk 'FNR==8 {print $5}'`
lim=`bc <<< "scale=1; $max * 0.5"`
gmt grdmath "$1"_der.grd 10 GE "$1"_der.grd $lim GE MUL = "$2".grd
