********************************************************************************
* Cleans Eurostat database to wide format
********************************************************************************
global sevenzip_location "C:\Program Files\7-Zip\7zG.exe"

global filelist ///
 nama_10_pc   /// // GDP per capita
 ilc_di01   /// // Income deciles by quantiles
 ilc_di02  // Income deciles by different income groups

foreach x of global filelist {

*************************************
* Download and extract the datasets *
*************************************

cd "C:/Users/Rodrigo/Desktop/ARM/01_raw/" // This is for Rodrigo's windows working directory
display "`x'"    // just show the file on the screen
local filename "`x'.tsv.gz"
copy "https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?sort=1&file=data%2F`x'.tsv.gz" "`filename'", replace
shell $sevenzip_location e -y `x'.tsv.gz
shell rm `filename'
di "." _cont  // displays a dot for each file


*************************************
* Clean the datasets to wide format *
*************************************

clear

cap cd "C:/Users/Rodrigo/Desktop/ARM" // This is for Rodrigo's windows working directory
cap cd "your mac directory" // This is for Álvaro's Mac working directory

import delimited using ./01_raw/`x'.tsv, delim(tab) clear   

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
foreach l of varlist y* {  
lab var `l' "`l'"
}

save ./04_master/`x'.dta, replace  // save the final file

}
