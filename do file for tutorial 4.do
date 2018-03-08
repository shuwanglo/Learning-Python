
log using "...\hwweek3.smcl", replace

generate LWW= log(WW)
generate AX2 = AX^2
generate WA2=WA^2
regress LWW WA WE CIT AX AX2
predict FLWW if LFP==0, xb 
summarize FLWW
summarize LWW if LFP==1
generate LWW1=LWW if LFP==1
replace LWW1=FLWW if LFP==0
summarize LWW1
save, replace
generate PRIN=FAMINC-(WHRS*WW)
replace PRIN=FAMINC if WW==.
gen LPRIN=log(PRIN)

logit LFP LWW1 
estat clas 
predict LFPfit1, pr
roctab LFP LFPfit1
roctab LFP LFPfit1, graph

logit LFP LWW1 KL6 K618 WA WE UN CIT WA2
estat clas 
predict LFPfit2, pr
roctab LFP LFPfit2
roctab LFP LFPfit2, graph

logit LFP LWW1 KL6 K618 WA WE UN CIT HW
estat clas 
predict LFPfit3, pr
roctab LFP LFPfit3
roctab LFP LFPfit3, graph

logit LFP LWW1 KL6 K618 WA WE UN CIT LPRIN
estat clas 
predict LFPfit4, pr
roctab LFP LFPfit4
roctab LFP LFPfit4, graph

roccomp LFP LFPfit1 LFPfit2 LFPfit3 LFPfit4, graph sum 

/* 2.  */ 
gen LWHRS=log(WHRS)

reg LWHRS KL6 K618 WA WE LPRIN LWW, vce(r) 

// Define some new variables 
gen WE2=WE^2
gen WAWE=WA*WE
gen WA3=WA^3
gen WE3=WE^3
gen WA2WE=WA2*WE
gen WAWE2=WA*WE2

// IV
ivregress 2sls LWHRS KL6 K618 WA WE LPRIN (LWW = WA2 WE2 WAWE UN CIT), vce(r) // LWW elasticity now negative and insignificant
estat overid, forcenonrobust
estat endog, forcenonrobust

ivregress 2sls LWHRS KL6 K618 WA WE LPRIN (LWW = WA2 WE2 WAWE WA3 WE3 WA2WE WAWE2 WMED WFED UN CIT), vce(r) //LWW elasticity now positive, still insignificant 
estat overid, forcenonrobust
estat endog, forcenonrobust

ivregress 2sls LWHRS KL6 K618 WA WE LPRIN (LWW = WA2 WE2 WAWE WA3 WE3 WA2WE WAWE2 WMED WFED UN CIT AX AX2), vce(r) //LWW elasticity positive and significant 
estat overid, forcenonrobust
estat endog, forcenonrobust 

pctile pctLWW=LWW, nq(5) genp(percentLWW)
list pctLWW percentLWW in 1/4

reg LWHRS KL6 K618 WA WE LPRIN LWW if LWW<0.69, vce(r)
reg LWHRS KL6 K618 WA WE LPRIN LWW if inrange(LWW, 0.69, 1.07), vce(r) 
reg LWHRS KL6 K618 WA WE LPRIN LWW if inrange(LWW, 1.07, 1.38), vce(r) 
reg LWHRS KL6 K618 WA WE LPRIN LWW if LWW>1.38, vce(r) 

ivregress 2sls LWHRS KL6 K618 WA WE LPRIN (LWW = WA2 WE2 WAWE WA3 WE3 WA2WE WAWE2 WMED WFED UN CIT AX AX2) if LWW<0.69, vce(r) 
ivregress 2sls LWHRS KL6 K618 WA WE LPRIN (LWW = WA2 WE2 WAWE WA3 WE3 WA2WE WAWE2 WMED WFED UN CIT AX AX2) if inrange(LWW, 0.69, 1.07), vce(r) 
ivregress 2sls LWHRS KL6 K618 WA WE LPRIN (LWW = WA2 WE2 WAWE WA3 WE3 WA2WE WAWE2 WMED WFED UN CIT AX AX2) if inrange(LWW, 1.07, 1.38), vce(r) 
ivregress 2sls LWHRS KL6 K618 WA WE LPRIN (LWW = WA2 WE2 WAWE WA3 WE3 WA2WE WAWE2 WMED WFED UN CIT AX AX2) if LWW>1.38, vce(r)  first



log close 

print "C:\Users\chamb\Google Drive\PhD\Teaching\Applied Econometrics\Term 2\Week 3\hwweek3.smcl" //prints log as pdf file 

translate "C:\Users\chamb\Google Drive\PhD\Teaching\Applied Econometrics\Term 2\Week 3\hwweek3.smcl" hwweek3.log //prints log as text file 
