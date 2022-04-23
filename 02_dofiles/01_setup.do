********************************************************************************
* Project: Advanced Research Methods - Experiment
* Name: Setup file.
* Description: Downloads Eurostat data and cleans it.
* Authors: Rodrigo Fernández Caba & Álvaro San Román del Pozuelo
********************************************************************************

* Automatic download and update of Eurostat database (nama_10_gdp file in this case)

clear all

cap cd "C:/Users/Rodrigo/Desktop/ARM/01_raw/" // This is for Rodrigo's windows working directory
cap cd "your mac directory" // This is for Álvaro's Mac working directory


* Copy the file from the online source into the local machine:
copy "https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?sort=1&file=data%2Fnama_10_gdp.tsv.gz" "nama_10_gdp.tsv.gz", replace

* Calls 7-zip using the Stata shell command (7zip syntax: e=extract, -y=replace file)

shell "C:\Program Files\7-Zip\7zG.exe" e -y "nama_10_gdp.tsv.gz"


*******************************************************************************

*************************************************
* Optional automated loop for more than 1 file: *
*************************************************
//
// global filelist ///
//  nama_10_gdp   /// // GDP and main components (ESA10)
//  nama_10_a10   /// // GDP for 10 industry classifications
//  demo_r_d2jan      // Population on 1 January by age, sex
// 
// foreach x of global filelist {
// display "`x'"    // just show the file on the screen
// local filename "`x'.tsv.gz"
// copy "https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?sort=1&file=data%2F`x'.tsv.gz" "`x'.tsv.gz", replace
// shell "C:\Program Files\7-Zip\7zG.exe" e -y `x'.tsv.gz
// di "." _cont  // displays a dot for each file
// }

* NOTE: If more than one file is downloaded, the script below must be updated or
* run for each of them.
********************************************************************************

* Once it is downloaded and extracted, now we clean it up and load it.

clear

cap cd "C:/Users/Rodrigo/Desktop/ARM" // This is for Rodrigo's windows working directory
cap cd "your mac directory" // This is for Álvaro's Mac working directory

import delimited using ./01_raw/nama_10_gdp.tsv, delim(tab) clear   

split v1, p(,) gen(a)
drop v1
order a* v*

// removing all non-numeric characters in the a's
 foreach j of varlist a* {
  replace `j'="geo" if `j'=="geo\time"
  local header = `j'[1]
  ren `j' `header'
  }
  
  // removing all non-numeric characters in the v's
foreach i of varlist v* {
 cap replace `i' = regexr(`i', "[a-z]", "")
 cap replace `i' = regexr(`i', ":", "")
 cap replace `i' = regexr(`i', "e", "")
 cap replace `i' = regexr(`i', "p", "")
 cap replace `i' = regexr(`i', "r", "")
 cap replace `i' = regexr(`i', "s", "")
}

// fixing the v columns
foreach k of varlist v* {
  local header = `k'[1]
  ren `k' y`header'
  }
  
drop in 1  // drop the first row
destring _all, replace

**** store variable names as variable labels
foreach x of varlist y* {  
lab var `x' "`x'"
}

* Reshape wide to long:

ds, not(varl y*)   // pick variables labels that don't have y
local ivars `r(varlist)'
reshape long y, i(`ivars') j(year) string

drop if y==.   // there might also be zeros as errors or actual values. these need to be checked manually.
destring _all, replace
lab var year "Year"
compress
order geo year
sort geo year
rename year time
save ./04_master/nama_10_gdp.dta, replace  // save the final file

* [OPTIONAL] reshape again to more readable data using "greshape" (package that uses c language functions = very fast):

*ssc install gtools, replace
greshape wide y, i(geo time unit) j(na_item) string 
ren y* y_*

save ./04_master/nama_10_gdp.dta, replace  // save the final file
