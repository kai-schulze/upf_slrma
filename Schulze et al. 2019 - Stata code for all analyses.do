	****************************************************************************
	*** Kai Schulze
	*** 11/03/2019
	*** Project: Associations Between Ultra-Processed Food Intake and Cardiometabolic Health
	*** Sub-project: Complete Stata Code 
	****************************************************************************
	
	clear all
	version 15
	set more off
	cd "C:\Users\Kaischulze\Google Drive\1. PhD\1. Projects\1. First project - Scope review UPF\June_2018\Submission Process\Github Upload" // Insert file path to folder in which "schulze2019data.xlsx" is saved.
	
	*// Note: If you have any questions regarding the code feel free to contact me:
	*// ks727@medschl.ac.cam.uk
	
	****************************************************************************
	//* I. Potential Installs Prior to Running Code   						 *// 
	****************************************************************************
	
	/*
		ssc install scheme-burd, replace
		set scheme burd
		ssc install mvmeta, replace
		ssc install glst, replace
		ssc install metan
		ssc install metabias
		ssc install metafunnel
		ssc install metareg
	*/ 	
	
	****************************************************************************
	//*        II. Dose-Response and Cardiovascular Disease Risk 			*// 
	****************************************************************************
	import excel schulze2019data.xlsx, sheet("cvd") firstrow clear // Requires Stata 12 or later
	
	/*** STEP A - GENERATE LOGS, CENTER DOSE, CREATE SPLINES ***/
	*Generate logrr and SE 
		gen double logrr = log(rr) 
		gen double se = ((log(ub) - log(lb))/(2*invnorm(.975))) 
	
		cap drop in 79/83 // Some nonsensical missing value-lines created in the last step 
					  // can cause trouble if not removed. 
	
	*Center the dose variable to zero (assumption of GLST)
		bysort study: gen dosec = dose-dose[1]
	
	*Create spline transformations for the centered exposure 
		mkspline dosecs = dosec, nk(3) cubic 
		// Knots according to Harrell(2001) at 10th, 50th, and 90th pctiles. 
	
	*Create spline transformations for the original exposure to be used for predictions
		mkspline doses = dose, nk(3) cubic
	
	/*** STEP B - TWO-STAGES: STUDY SPECIFIC ESTIMATES AND RE-POOLING ***/
	*1: Study specific estimates using splines 
		mvmeta_make glst logrr dosecs1 dosecs2, ///
			cov(n cases) se(se) pfirst(study type) ///
			saving(ssest_spline) replace  by(study)  names(b V)	
		
	*2: Pool study specific estimates using Random-Effects	
		preserve
		
		use ssest_spline, clear

		mvmeta b V, mm i2
		test bdosecs1 bdosecs2 // Test whether coefficients are 0 
		test bdosecs1 = bdosecs2 // Test whether there is a linear relationship(= coefficients are equal)
		capture estimates save mvmeta, replace
		restore 	
	
	/*** STEP C - OBTAIN AND PLOT THE DOSE-RESPONSE RELATIONSHIP BACK ON THE ORIGINAL SCALE ***/
	
	
	*Get values of the splines at the chosen reference value (min)
		su doses1 doses2 if dose == float(10)
	
	*Predict values
		predictnl logrr_sp = _b[bdosecs1]*(doses1-10) + _b[bdosecs2]*(doses2-0) , ci(los his)
		
		gen ors = exp(logrr_sp)
		gen lbs = exp(los)
		gen ubs = exp(his)	
	
	
	/*** D - COMPARE WITH A LINEAR TREND USING TWO-STAGE RANDOM EFFECTS ***/
	*Estimate linear random effects model
		glst logrr dosec, cov(n cases) se(se) pfirst(study type) ts(r)	
	
	*Obtain and plot the dose-response relationship back on the original scale
		predictnl logrr_l  = _b[dosec]*(dose-10) 
		gen orl  = exp(logrr_l)	
		
	/*** E - OVERLAY PREDICTIONS FROM SPLINE AND LINEAR MODELS ***/

	twoway  ///
		(line orl dose, sort  lc(gs10) lp(-)) ///
		(line ors lbs ubs dose, sort ///
		lw(thick medium medium) lc(turquoise black black) ///
		lp(l longdash longdash)) , ///
		yline(1 1.1 1.2 1.3 1.4, lpattern(longdash_dot) lwidth(vthin) lcolor(stone))  ///
		ytitle("Relative Risk of CVD Events") xtitle("Percentiles of Ultra-processed food intake") ///
		scheme(s1mono) ///
		legend(label(1 "Linear")  label(2 "Restricted Cubic Spline") ///
		order(1 2) ring(0) pos(11) col(1) ) ///
		xlabel(10(20)100) xmtick(10(10)100) ///
		ymtick(1(.1)1.3) ylabel(1 1.1 1.2 1.3 1.4, format(%3.2fc) angle(horiz)) ///
		plotregion(style(burd)) 
		
	*|| Values for dose-response table
	sort doses1
	list doses1 orl lbs ubs in 9/71
	
	****************************************************************************
	//* 				III. Dose-Response and T2DM Risk				     *// 
	****************************************************************************
	import excel schulze2019data.xlsx, sheet("t2dm") firstrow clear
	
	/*** STEP A - GENERATE LOGS, CENTER DOSE, CREATE SPLINES ***/
	*Generate logrr and SE 
		gen double logrr = log(rr) 
		gen double se = ((log(ub) - log(lb))/(2*invnorm(.975))) 
	
		cap drop in 40/44 // Some nonsensical missing value-lines created in the last step 
					  // can cause trouble if not removed. 
	
	*Center the dose variable to zero (assumption of GLST)
		bysort study: gen dosec = dose-dose[1]
	
	*Create spline transformations for the centered exposure 
		mkspline dosecs = dosec, nk(3) cubic 
		// Knots according to Harrell(2001) at 10th, 50th, and 90th pctiles. 
	
	*Create spline transformations for the original exposure to be used for predictions
		mkspline doses = dose, nk(3) cubic
	
	/*** STEP B - TWO-STAGES: STUDY SPECIFIC ESTIMATES AND RE-POOLING ***/
	*1: Study specific estimates using splines 
		mvmeta_make glst logrr dosecs1 dosecs2, ///
			cov(n cases) se(se) pfirst(study type) ///
			saving(ssest_spline) replace  by(study)  names(b V)	
		
	*2: Pool study specific estimates using Random-Effects	
		preserve
		use ssest_spline, clear
		mvmeta b V, mm i2
		est store a
		test bdosecs1 bdosecs2 // Test whether coefficients are 0 
		test bdosecs1 = bdosecs2 // Test whether coefficients are equal
		capture estimates save mvmeta, replace
		restore 	
	
	/*** STEP C - OBTAIN AND PLOT THE DOSE-RESPONSE RELATIONSHIP BACK ON THE ORIGINAL SCALE ***/
		estimates use mvmeta 
	
	*Get values of the splines at the chosen reference value (min)
		su doses1 doses2 if dose == float(10)
	
	*Predict values
		predictnl logrr_sp = _b[bdosecs1]*(doses1-10) + _b[bdosecs2]*(doses2-0) , ci(los his)
	 
		gen ors = exp(logrr_sp)
		gen lbs = exp(los)
		gen ubs = exp(his)	
	
	/*** D - COMPARE WITH A LINEAR TREND USING TWO-STAGE RANDOM EFFECTS ***/
	*Estimate linear random effects model
		glst logrr dosec, cov(n cases) se(se) pfirst(study type) ts(r)	
		est store b
		test dosec // Test whether coefficient is 0
	
	*Obtain and plot the dose-response relationship back on the original scale
		predictnl logrr_l  = _b[dosec]*(dose-10) 
		gen orl  = exp(logrr_l)	
		
	/*** E - OVERLAY PREDICTIONS FROM SPLINE AND LINEAR MODELS ***/
	twoway  ///
		(line orl dose, sort  lc(gs10) lp(-)) ///
		(line ors  lbs ubs  dose, sort ///
		lw(thick medium medium) lc(ply3 black black) ///
		lp(l longdash longdash)) , ///
		yline(1 1.2 1.4 1.6, lpattern(longdash_dot) lwidth(thin) lcolor(stone))  ///
		legend(label(1 "Linear")  label(2 "Restricted Cubic Spline") ///
		order(1 2) ring(0) pos(11) col(1) ) ///
		ytitle("Relative Risk of Type 2 Diabetes Mellitus Events") xtitle("Percentiles of Ultra-processed food intake") ///
		scheme(s1mono) ///
		xlabel(10(20)100) xmtick(10(10)100) ///
		ymtick(0.9(.1)1.6) ylabel(1 1.2 1.4 1.6, format(%3.2fc) angle(horiz)) ///
		plotregion(style(burd))	
	
	*|| Values for dose-response table
	sort doses1
	list doses1 orl lbs ubs in 5/36
	
	
	****************************************************************************
	//* 					IV. RE-Meta-Analysis						  	 *// 
	****************************************************************************
	/*** A - CVD ***/
	import excel schulze2019data.xlsx, sheet("cvd2") firstrow clear
	
	*|| Gen Log and SE, label variables
	gen double logrr = log(rr) 
	gen double se = ((log(ub) - log(lb))/(2*invnorm(.975))) 
	
	la var author "Author / Year"
	la var country "Country"
	la var followup "Follow-up time (years)"
	la var participants "Number of participants"
	la var quality "Study quality" 
	la var logrr "Log of relative risk"
	
	*|| RE-MA 
	sort rr
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) ///
		diamopt(lwidth(medium) lcolor(plb3))
	
	gr play metan19	
	*|| My own graph editor recording with minor changes, not reproducible

	graph export "file path and name", as(eps) preview(off) replace
	graph export "file path and name", as(tif) replace
	
	*|| Bias plots
	metabias logrr se, egger
	metabias logrr se, begg
	
	metafunnel ///
		logrr se, xtitle(Log Relative Risk) ytitle(Standard Error of Log RR)
	gr play funnel

	*|| Metareg 
	metareg logrr followup, wsse(se) eform graph
	gr play metareg
	metareg logrr participants, wsse(se) eform graph
	gr play metareg
	metareg logrr quality, wsse(se) eform graph
	gr play metareg

	/*** B - T2DM ***/
	import excel schulze2019data.xlsx, sheet("t2dm2") firstrow clear
	
	*|| Gen Log and SE, label variables
	gen double logrr = log(rr) 
	gen double se = ((log(ub) - log(lb))/(2*invnorm(.975))) 
	
	la var author "Author / Year"
	la var country "Country"
	la var followup "Follow-up time (years)"
	la var participants "Number of participants"
	la var quality "Study quality" 
	la var logrr "Log of relative risk"
	
	*|| RE-MA
	sort rr
	metan rr lb ub, nobox randomi xlabel(0.5, 1, 2, 3.5) ///
			force null(1) astext(80) lcols(author country) ///
			diamopt(lwidth(medium) lcolor(plb3))
	gr play metan19d
	*|| My own graph editor recording with minor changes, not reproducible

	graph export "file path and name", as(eps) preview(off) replace
	graph export "file path and name", as(tif) replace

			
	*|| Bias Plots
	metabias logrr se, begg
	metabias logrr se, egger
	
	metafunnel ///
		logrr se, xtitle(Log Relative Risk) ytitle(Standard Error of Log RR)
	gr play funnel
	*|| My own graph editor recording with minor changes, not reproducible
	
	*|| Metareg 
	metareg logrr followup, wsse(se) eform graph
	gr play metareg
	metareg logrr participants, wsse(se) eform graph
	gr play metareg
	metareg logrr quality, wsse(se) eform graph
	gr play metareg

	****************************************************************************
	//*    Sensitivity Analysis:Exlcusion of One Study: RE-Meta-Analysis     *// 
	****************************************************************************
	/*** A - CVD ***/
	
	import excel schulze2019data.xlsx, sheet("cvd2") firstrow clear
	drop if study==. 

	la var author "Author / Year"
	la var country "Country"
	
	*Atkins 2016
	preserve 
	drop if study==1
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Barington 2016
	preserve 
	drop if study==2
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Chan 2013f
	preserve 
	drop if study==3
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore

	*Chan 2013m
	preserve 
	drop if study==4
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Denova-Gutierrez 2016
	preserve 
	drop if study==5
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Fung 2004b
	preserve 
	drop if study==6
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Guallar-Castillion 2012
	preserve 
	drop if study==7
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Heidemann 2008
	preserve 
	drop if study==8
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Hlebowicz 2011f
	preserve 
	drop if study==9
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Hlebowicz 2011m
	preserve 
	drop if study==10
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
		*Hu 2000
	preserve 
	drop if study==11
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Martinez-Gonzales 2015
	preserve 
	drop if study==12
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*McNaughton 2009
	preserve 
	drop if study==13
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore

	*Mendonca 2017
	preserve 
	drop if study==14
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Mertens 2017
	preserve 
	drop if study==15
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Mohammadifard 2017
	preserve 
	drop if study==16
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Nettleton 2009 
	preserve 
	drop if study==17
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Odegaard 2014
	preserve 
	drop if study==18
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Osler 2002
	preserve 
	drop if study==19
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Shikany 2015
	preserve 
	drop if study==20
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Stricker 2015
	preserve 
	drop if study==21
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Varraso 2012f
	preserve 
	drop if study==22
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Varraso 2012m
	preserve 
	drop if study==23
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
		
	/*** B - T2DM ***/
	
	import excel schulze2019data.xlsx, sheet("t2dm2") firstrow clear
	drop if study==. 

	la var author "Author / Year"
	la var country "Country"
	
	*Dominguez 2014
	preserve 
	drop if study==1
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Fung 2004a
	preserve 
	drop if study==2
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*McNaughton 2008
	preserve 
	drop if study==3
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore

	*Nanri 2013f
	preserve 
	drop if study==4
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Nanri 2013m
	preserve 
	drop if study==5
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Reeds 2016
	preserve 
	drop if study==6
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Odegaard 2012
	preserve 
	drop if study==7
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Schulze 2005
	preserve 
	drop if study==8
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*VanDam 2002
	preserve 
	drop if study==9
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	*Zhang 2006
	preserve 
	drop if study==10
	gen study2 =_n
	drop study
	rename study2 study
	metan rr lb ub, nobox randomi xlabel(0.2, 0.5, 1, 2, 3.5) ///
		force null(1) astext(65) lcols(author country) nowt ///
		diamopt(lwidth(medium) lcolor(plb3))
	restore
	
	****************************************************************************
	//* 				       	 END OF DO-FILE		         	     	  	 *// 
	****************************************************************************
