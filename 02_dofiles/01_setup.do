********************************************************************************
* Project: Advanced Research Methods - Experiment
* Name: Setup file.
* Description: Downloads Eurostat data and cleans it.
* Authors: Rodrigo Fernández Caba & Álvaro San Román del Pozuelo
********************************************************************************

global projectdir "C:/Users/Rodrigo/Desktop/ARM"

cd $projectdir

do ./02_dofiles/99_onlywide.do // Only cleans to wide form

* Uncomment this to reshape wide to long (panel data):
/*
do ./02_dofiles/99_widetolong.do 
rename y_ear year
*/