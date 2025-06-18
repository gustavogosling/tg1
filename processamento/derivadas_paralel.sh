#!/bin/bash

# primeiro input eh o diametro da janela do filtro
# segundo input eh a porcentagem do valor maximo do ght em cada subgrade
# terceiro input eh o limiar do ght para excluir valores muito pequenos do processamento de subgrades
# quarto input eh a latitude media de cada subgrade (vem direto de filewriter)
# quinto input eh o nome da subgrade de entrada

# Derivadas
gmt grdmath "$5".grd DDX PI 6378000 $4 COSD MUL MUL 180000 1 6378000 SQR 6357000 SQR SUB 6378000 SQR DIV $4 SIND SQR MUL SUB SQRT MUL DIV DIV = "$5"_ddx.grd
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
gmt grdmath "$5"_der.grd $3 GE "$5"_der.grd $lim GE MUL = opgrd_"$5".grd
