********************************************************************************
* Project: Advanced Research Methods - Experiment
* Name: Master file.
* Description: Uses the definitive data to make graphs and tables.
* Authors: Rodrigo Fernández Caba & Álvaro San Román del Pozuelo
********************************************************************************

* IMPORTANT! 

* Configuration:

* 		First of all, open "/02_dofiles/99_onlywide" file and select the datasets to download
*		Configure also your 7-zip installation directory
* 		If you want to get the long format (panel data), go to "/02_dofiles/01_setup.do" and uncomment lines 15 to 18.
*		Once you have done that you can decide whether to reshape it again to have a better looking (see RESHAPE AGAIN section)

do ./02_dofiles/01_setup.do

********************************************************************************

*****************
* RESHAPE AGAIN *
*****************

* [OPTIONAL] reshape again to more readable data using "greshape" 
* (package that uses c language functions = very fast):

cap which gtools
if _rc==111 {
	ssc install gtools, replace
}

* Configure your variables to the desired result:

greshape wide y, i(geo year unit) j(na_item) string 
ren y* y_*

save ./04_master/$filename.dta, replace  // save the final file

********************************************************************************

*********************
* Master file start *
*********************

* Select the file to work with:

global filename "nama_10_pc"

use ./04_master/$filename.dta, clear



