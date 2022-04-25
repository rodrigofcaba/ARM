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

do git_push.do "to confirm last version is uploaded"

********************************************************************************

**********
* SETUP: *
**********


local time 2020

local filenames ilc_di01 ilc_di02

foreach x of local filenames {
	do ./02_dofiles/01_setup.do `x' `time'
}

********************************************************************************

*********************
* Master file start *
*********************

use ./04_master/ilc_di01, clear
br
