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
save ./04_master/nama_10_gdp.dta, replace  // save the final file

* [OPTIONAL] reshape again to more readable data using "greshape" (package that uses c language functions = very fast):

*ssc install gtools, replace
greshape wide y, i(geo year unit) j(na_item) string 
ren y* y_*
save ./04_master/nama_10_gdp.dta, replace  // save the final file
