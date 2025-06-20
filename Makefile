#~ all: tex/tg1.pdf

all: figura02.png figura03.png figura04.png figura05.png figura06.png figura07.png figura08.png figura09.png figura10.png apendiceB.png

clean:
	rm -rfv grades/*
	rm -rfv ./*.png

grades/earth.grd:
	gmt grdcut -Rg @earth_relief_02m_p -Gearth.grd
	mv earth.grd grades/

figura02.png: grades/earth.grd
	bash figuras/figura02.sh

figura03.png: grades/earth.grd grades/grade_10x10_10_40_4.grd
	bash figuras/figura03.sh

figura04.png: grades/earth.grd
	bash figuras/figura04.sh
	
figura05.png: apendiceA1.png apendiceA2.png
	bash figuras/figura05.sh
	
figura06.png: apendiceA1.png apendiceA2.png
	bash figuras/figura06.sh
	
figura07.png: apendiceA1.png apendiceA2.png
	bash figuras/figura07.sh
	
figura08.png: apendiceA1.png apendiceA2.png
	bash figuras/figura08.sh
	
figura09.png: apendiceA2.png
	bash figuras/figura09.sh
	
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
