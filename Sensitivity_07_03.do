	****************************************************************************
	*** Kai Schulze
	*** 01/02/2019
	*** Project: UPF Systematic review and meta-analysis
	*** Sub-project: Exclusion of one study at a time sensitivity analysis
	****************************************************************************
	
	clear all
	version 15
	set more off
	cd "C:\Users\Kaischulze\Google Drive\1. PhD\1. Projects\1. First project - Scope review UPF\June_2018\STATA Analysis\Final"
	
	****************************************************************************
	//* I. Potential Installs Prior to Running Code   						 *// 
	********************s********************************************************
	/*
		ssc install scheme-burd, replace
		set scheme burd
		ssc install mvmeta, replace
		ssc install glst, replace
		ssc install metan
		ssc install metabias
		ssc install metafunnel
	*/ 	
	
	****************************************************************************
	//* 					IV. RE-Meta-Analysis						  	 *// 
	****************************************************************************
	
	/*** A - CVD ***/
	
	import excel data_new2.xlsx, sheet("cvd2") firstrow clear
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
	
	import excel data_new2.xlsx, sheet("t2dm2") firstrow clear
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
	

