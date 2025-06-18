#~ all: tex/tg1.pdf

#~ figura5.png figura6.png figura7.png figura8.png figura10.png

all: figura2.png figura3.png figura4.png figura9.png apendiceB.png

clean:
	rm -rfv grades/*
	rm -rfv ./*.png

grades/earth.grd:
	gmt grdcut -Rg @earth_relief_02m_p -Gearth.grd
	mv earth.grd grades/

figura2.png: grades/earth.grd grades/grade_10x10_10_40_4.grd
	bash figuras/figura2.sh

figura3.png: grades/earth.grd
	bash figuras/figura3.sh

figura4.png: grades/earth.grd
	bash figuras/figura4.sh
	
figura5.png: apendiceA1.png apendiceA2.png
	bash figuras/figura5.sh
	
figura6.png: apendiceA1.png apendiceA2.png
	bash figuras/figura6.sh
	
figura7.png: apendiceA1.png apendiceA2.png
	bash figuras/figura7.sh
	
figura8.png: apendiceA1.png apendiceA2.png
	bash figuras/figura8.sh
	
figura9.png: apendiceA2.png
	bash figuras/figura9.sh
	
figura10.png: apendiceA2.png
	bash figuras/figura10.sh

grades/grade_10x10_10_40_4.grd: grades/earth.grd
	cd processamento
	bash processamento/rotina_apendiceA1.sh
	mv *.grd grades/

apendiceA1.png: grades/grade_10x10_10_40_4.grd
	bash figuras/apendiceA1.sh

grades/grade_5x5_10_40_4.grd: grades/earth.grd
	cd processamento/
	bash processamento/rotina_apendiceA2.sh
	mv *.grd grades/
	
apendiceA2.png: grades/grade_5x5_10_40_4.grd
	bash figuras/apendiceA2.sh
	
apendiceB.png: apendiceA1.png
	bash figuras/apendiceB.sh

#~ tex/tg1.pdf:
