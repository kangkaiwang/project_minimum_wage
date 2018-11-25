*Author: Kangkai Wang
*Version: Stata/MP 14.1
*File：uhs_sample_slection.do
*This program builds the file used in the wage distribution analysis

*Input files: 1) YEARp.dta, where YEAR is from 2002 to 2009 (8 separate files) 
*             2) minimum_wage_1st_tier_cities_2002_2009.dta                   
*Output files created: 1) wage_1st_tier_cities_2002_2009.dta


******************************************************************************
*   Is Minimum Wage Binding in China ? Evidence from the First-Tier Cities   *
******************************************************************************

global path "C:\Users\hp\Desktop\Minimum_Wage_UHS\build"

cd "C:\Users\hp\Desktop\Minimum_Wage_UHS\build\input"
***** I. Keep the Key Variables for Analysis *****
set more off
forvalue i = 2002(1)2009{
	use "`i'p.dta", clear 
	drop if a1 == 99    					   // variable 'a1' is personal id and the value 99 does NOT represent anybody 
	drop if a7 < 16   						   // drop those who are younger than 16
	keep dcode hcode year a1 a3 a1511  		   // variable 'a3' is hukou and 'a1511' is annual wage
	drop if a1511 == 0                         // drop those whose wage is zero
	rename (a1 a3 a1511) (pid hukou year_wage)
	gen month_wage = year_wage / 12			   // assume that monthly wage equals annual wage divided by 12
	drop if month_wage < 100 				   // drop if monthly wage is lower than 100 RMB

	tostring dcode hcode pid,replace
	gen id = dcode + hcode + pid
	gen cityid = substr(dcode,1,4) 			   // identify and generate city code
	drop dcode hcode pid
	destring cityid id,replace
	order year cityid id hukou year_wage month_wage 

	label var year "yar"
	label var cityid "city code"
	label var id "personal code"
	label var hukou "hukou"
	label var year_wage "annual wage"
	label var month_wage "monthly wage (=annual wage/12)"

	save "..\temp\uhs_`i'p_wage",replace
		}

***** II. Append UHS Dataset and Merge with Minimum-Wage Dataset ***** 
use "..\temp\uhs_2002p_wage.dta",clear
forvalue i = 2003(1)2009{
	append using "..\temp\uhs_`i'p_wage"
}
keep if cityid == 1101 | cityid == 3101 | cityid == 4401 | cityid == 4403 // keep the first-tier-city sample
gen city ="北京市" if cityid == 1101
replace city ="上海市" if cityid == 3101
replace city ="广州市" if cityid == 4401
replace city ="深圳市" if cityid == 4403
gen cname = "I.Beijing" if city =="北京市"
replace cname = "II.Shanghai" if city =="上海市"
replace cname = "III.Guangzhou" if city =="广州市"
replace cname = "IV.Shenzhen" if city =="深圳市"

sort year city
merge m:1 year city using "..\input\minimum_wage_1st_tier_cities_2002_2009.dta"  // merge with minimum-wage dataset
drop _merge
order year cityid city cname
save "..\output\wage_1st_tier_cities_2002_2009.dta",replace
