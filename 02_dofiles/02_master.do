********************************************************************************
* Project: Advanced Research Methods - Experiment
* Name: Master file.
* Description: Uses the definitive data to make graphs and tables.
* Authors: Rodrigo Fernández Caba & Álvaro San Román del Pozuelo
********************************************************************************

global projectdir "C:/Users/Rodrigo/Desktop/ARM"

cd $projectdir

*do ./02_dofiles/01_setup.do // Does everything

do ./02_dofiles/99_onlywide.do // Only cleans to wide form

* Uncomment this to reshape wide to long (panel data):
/*
do ./02_dofiles/99_widetolong.do 
rename y_ear year
*/

********************************************************************************
use ./04_master/nama_10_gdp.dta, clear
