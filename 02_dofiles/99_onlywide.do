*cleans Eurostat database to wide format
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

save ./04_master/nama_10_gdp.dta, replace  // save the final file