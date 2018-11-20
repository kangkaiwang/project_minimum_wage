*Author: Kangkai Wang
*Version: Stata/MP 14.1
*File：uhs_wage_distribution.do
*This program analyses wage distribution in four first-tier cities in China compared with minimum wage line

*Input files: 1) wage_1st_tier_cities_2002_2009.dta                  


******************************************************************************
*   Is Minimum Wage Binding in China ? Evidence from the First-Tier Cities   *
******************************************************************************


global path "C:\Users\hp\Desktop\Minimum_Wage_UHS\analysis"

cd "..\input"

***** I. Keep the Key Variables for Analysis *****
use wage_1st_tier_cities_2002_2009.dta ,clear 
sort year cname
egen yc = group(year cityid)

gen lwage = ln(month_wage)
gen lminiwage = ln(miniwage)
gen lowage = 1 if month_wage < miniwage
replace lowage = 0 if month_wage >= miniwage

set more off
*** 1. Beijing
forvalue i = 1(4)29{                  
	sum lminiwage if yc == `i'
	local miniwage = r(mean)
	sum lowage if yc == `i'
	local j = round(r(mean)*100)
	sum month_wage if yc == `i'
	local w = round(r(mean))
	sum month_wage if yc == `i'
	local w = round(r(mean))
	count if yc == `i'
	local n = r(N)
	
	local lineopt ",lp(dash) lc(red)"
	tw hist lwage if yc == `i',xline(`miniwage'`lineopt') width(0.26) ///
	lcolor(white) fcolor(blue) fintensity(inten100) legend(off) ///
	ylabel(0(0.4)0.8) xlabel(4(2)12) ///
	|| kdensity lwage if yc == `i',color(orange) ///
	scheme(s1mono) ytitle("密度",size(small)) xtitle("对数工资",size(small)) ///
	subtitle("北京市",size(small)) saving("..\temp\wage_`i'.gph",replace) ///
	text(0.7 5 "`j'%" ///
		 0.7 10 "观测值 = `n'" ///
		 0.5 10 "月平均工资 = `w'",place(n) size(vsmall))
}
*** 2. Shanghai
forvalue i = 2(4)30{                 
	sum lminiwage if yc == `i'
	local miniwage = r(mean)
	sum lowage if yc == `i'
	local j = round(r(mean)*100)
	sum month_wage if yc == `i'
	local w = round(r(mean))
	count if yc == `i'
	local n = r(N)
	local lineopt ",lp(dash) lc(red)"
	tw hist lwage if yc == `i',xline(`miniwage'`lineopt') width(0.26) ///
	lcolor(white) fcolor(blue) fintensity(inten100) legend(off) ///
	ylabel(0(0.4)0.8) xlabel(4(2)12) ///
	|| kdensity lwage if yc == `i',color(orange) ///
	scheme(s1mono) ytitle("密度",size(small)) xtitle("对数工资",size(small)) ///
	subtitle("上海市",size(small)) saving("..\temp\wage_`i'.gph",replace) ///
	text(0.7 5 "`j'%" ///
		 0.7 10 "观测值 = `n'" ///
		 0.5 10 "月平均工资 = `w'",place(n) size(vsmall))
}
*** 3. Guangzhou
forvalue i = 3(4)31{                     
	sum lminiwage if yc == `i'
	local miniwage = r(mean)
	sum lowage if yc == `i'
	local j = round(r(mean)*100)
	sum month_wage if yc == `i'
	local w = round(r(mean))
	count if yc == `i'
	local n = r(N)
	local lineopt ",lp(dash) lc(red)"
	tw hist lwage if yc == `i',xline(`miniwage'`lineopt') width(0.26) ///
	lcolor(white) fcolor(blue) fintensity(inten100) legend(off) ///
	ylabel(0(0.4)0.8) xlabel(4(2)12) ///
	|| kdensity lwage if yc == `i',color(orange) ///
	scheme(s1mono) ytitle("密度",size(small)) xtitle("对数工资",size(small)) ///
	subtitle("广州市",size(small)) saving("..\temp\wage_`i'.gph",replace) ///
	text(0.7 5 "`j'%" ///
		 0.7 10 "观测值 = `n'" ///
		 0.5 10 "月平均工资 = `w'",place(n) size(vsmall))
}
*** 4. Shenzhen
forvalue i = 4(4)32{                     
	sum lminiwage if yc == `i'
	local miniwage = r(mean)
	sum lowage if yc == `i'
	local j = round(r(mean)*100)
	sum month_wage if yc == `i'
	local w = round(r(mean))
	count if yc == `i'
	local n = r(N)
	local lineopt ",lp(dash) lc(red)"
	tw hist lwage if yc == `i',xline(`miniwage'`lineopt') width(0.26) ///
	lcolor(white) fcolor(blue) fintensity(inten100) legend(off) ///
	ylabel(0(0.4)0.8) xlabel(4(2)12) ///
	|| kdensity lwage if yc == `i',color(orange) ///
	scheme(s1mono) ytitle("密度",size(small)) xtitle("对数工资",size(small)) ///
	subtitle("深圳市",size(small)) saving("..\temp\wage_`i'.gph",replace) ///
	text(0.7 5 "`j'%" ///
		 0.7 10 "观测值 = `n'" ///
		 0.5 10 "月平均工资 = `w'",place(n) size(vsmall))
}

*** 1.2 Combine the Graphs
** 1.2.1 Wage
set more off
local y = 2002
forvalue i = 1(4)29{	
	local a = `i' + 1
	local b = `i' + 2
	local c = `i' + 3
	gr combine "..\temp\wage_`i'.gph" "..\temp\wage_`a'.gph" "..\temp\wage_`b'.gph" "..\temp\wage_`c'.gph", ///
	col(2) iscale(1) ycommon xcommon ///
	graphregion(color(white)) plotregion(color(white)) ///
	title("`y'年一线城市工资分布 (UHS数据)") ///
	subtitle("（工资及补贴收入）") ///
	note("注：本图所使用的工资数据是指每月工资及补贴收入（由年工资及补贴收入除以12计算而来），图中" ///
		"红线表示`y'年各一线城市最低工资对数值，其左侧数字代表最低工资线以下样本占比，其右侧标注" ///
		"了观测值数目以及月平均名义工资（此处工资指工资及补贴收入）；深圳市在2002至2009年期间在特" ///
		"和特区外（指宝安区和龙岗区）执行两重标准的最低工资，但UHS数据中深圳市无法识别到区县层面，" ///
		"因此本图中使用的均是特区内最低工资标准。") 
	gr export "..\documentation\wage_distr_`y'.png",replace width(1600) height(1200)
	local y = `y' + 1
}

