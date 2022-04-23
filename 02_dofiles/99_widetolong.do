* Reshape wide to long:

foreach x of global filelist {
ds, not(varl y*)   // pick variables labels that don't have y
local ivars `r(varlist)'
reshape long y, i(`ivars') j(year) string

drop if y==.   // there might also be zeros as errors or actual values. these need to be checked manually.
destring _all, replace
lab var year "Year"
compress
order geo year
sort geo year
save ./04_master/`x'.dta, replace  // save the final file
}