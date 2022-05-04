********************************************************************************
* Project: Advanced Research Methods - Experiment
* Name: Master file.
* Description: Uses the definitive data to make graphs and tables.
* Authors: Rodrigo Fernández Caba & Álvaro San Román del Pozuelo
********************************************************************************

clear all
set more off

global projectdir "C:/Users/Rodrigo/Desktop/ARM"

cd $projectdir

* Configuration:

* 		- Set your working directory in the "projectdir" global variable.
*		- Choose the file(s) to work with and pass it(them) to the setup dofile (using the "filenames" local).
*		- Specify the year for which you want the table in the "time" local.
*		- Commit your changes to github using git_push.do passing the commit text
*		- If you are starting the project, create a github repository and 
*			run git_config dofile passing the name of the repository.

***************
* GIT CONFIG: *
***************

*do git_config.do ARM

*************
* GIT PUSH: *
*************

do git_push.do "excel almost finished with GDP table"

********************************************************************************

**********
* SETUP: *
**********

local time 2020

local filenames ilc_di03

*Specify units (NAC=National Currency, PPS=Purchase Power Standard, etc.)
local filter PPS

foreach x of local filenames {
	do ./02_dofiles/01_setup.do `filter' `x' `time'
}

keep country TOTAL_T_MEI_E_PPS
sort country
********************************************************************************

*********************
* Master file start *
*********************

xteurostat ilc_di01, s(2020) g(country) clear

use ./04_master/ilc_di01, clear
br
