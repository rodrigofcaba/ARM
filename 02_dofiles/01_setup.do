********************************************************************************
* Project: Advanced Research Methods - Experiment
* Name: Setup file.
* Description: Downloads Eurostat data and cleans it.
* Authors: Rodrigo Fernández Caba & Álvaro San Román del Pozuelo
********************************************************************************

args filename time 

*Check if xteurostat is installed:
cap which xteurostat
if (_rc==111){
	ssc install xteurostat, replace
}

xteurostat `filename', g(country) clear

local eu_countries AT BE BG CY CZ DK EE FI FR DE GR HU IE IT LV LT LU MT NL PL PT RO SK SI ES SE

* Drops countries that aren't members of the EU
{
	gen eu = 0
	foreach x of local eu_countries{
		recode eu 0 = 1 if country == "`x'"
	}
	drop if !eu
}

* Drops observations for years different from the desired one
drop if time != "`time'"

* Drop unnecesary variables according to differnet criteria
cap drop D*_SHARE* P* Q*
cap drop *_EUR *_NAC 
cap drop A_* ?_M??_* *_MEI_*

* Rename variables:
forval i = 1/9 {
cap rename D`i'_TC_PPS D`i'
cap la var D`i' "Decil `i'"
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