********************************************************************************
* Project: Advanced Research Methods - Experiment
* Name: Setup file.
* Description: Downloads Eurostat data and cleans it.
* Authors: Rodrigo Fernández Caba & Álvaro San Román del Pozuelo
********************************************************************************

args filter filename time 

*Check if xteurostat is installed:
cap which xteurostat
if (_rc==111){
	ssc install xteurostat, replace
}

*Replace 'http' protocol with 'https':
	* In windows:
		cap ! (Get-Content -path "`c(sysdir_plus)'/x/xteurostat.ado" -Raw) -replace 'http','https'
	* In MacOS:
		cap ! sed -i 's/http/https/' "`c(sysdir_plus)'/x/xteurostat.ado"
	
discard // drop all ado programs in memory

xteurostat `filename' TC_`filter', start(`time') g(country) clear

local eu_countries AT BE BG CY CZ DK EE FI FR DE GR HU IE IT LV LT LU MT NL PL PT RO SK SI ES SE EU27_2020

* Drops countries that aren't members of the EU
{
	gen eu = 0
	foreach x of local eu_countries{
		recode eu 0 = 1 if country == "`x'"
	}
	drop if !eu
}

* Drops observations for years different from the desired one
*cap drop if time != "`time'"

* Drop unnecesary variables according to differnet criteria
cap drop D*_SHARE* P* Q*
cap drop *_EUR 
cap drop A_* ?_M??_* *_MEI_*

* Rename variables:
forval i = 1/9 {
cap rename D`i'_TC_PPS D`i'_PPS
cap rename D`i'_TC_NAC D`i'_NAC

cap la var D`i'_PPS "Decil `i' (PPS)"
cap la var D`i'_PPS "Decil `i' (National Currency)"
}

forval i = 40(10)70 {
	cap rename B_MD`i'_MED_E_PPS below`i'
	cap la var below`i' "Below `i' % of median equivalised income"
}

* Drop time and temporal variables
drop time eu

* Put countries labels:
cap  which kountry
if _rc==111{
	ssc install kountry, replace
}

kountry country, from(iso2c)

drop country
rename NAMES_STD country
order country

* Saves the final file
save ./04_master/`filename'.dta, replace