//Ch 11.6 exercise, part a)
//generate variables
gen AX2 = AX*AX
gen WA2 = WA*WA
gen WE2 = WE*WE
gen WA3 = WA2*WA
gen WE3 = WE2*WE
gen WAWE = WA*WE
gen WA2WE = WA2*WE
gen WAWE2 = WA*WE2
gen PRIN = FAMINC - (WHRS*WW)
replace PRIN = FAMINC if WHRS==0
gen LWHRS = ln(WHRS)
sum

//find lamda = INVR1
//Set A variables: KL6 K618 WA WE WA2 WE2 WAWE WA3 WE3 WA2WE WAWE2 WFED WMED UN CIT PRIN
probit LFP KL6 K618 WA WE WA2 WE2 WAWE WA3 WE3 WA2WE WAWE2 WFED WMED UN CIT PRIN, nolog
predict probLFP, xb
gen INVR1 = normalden(probLFP)/normal(probLFP)

//find lamda = INVR2
//Set B variables: KL6 K618 WA WE WA2 WE2 WAWE WA3 WE3 WA2WE WAWE2 WFED WMED UN CIT PRIN AX AX2
probit LFP KL6 K618 WA WE WA2 WE2 WAWE WA3 WE3 WA2WE WAWE2 WFED WMED UN CIT PRIN AX AX2, nolog
predict probLFP2, xb
gen INVR2 = normalden(probLFP2)/normal(probLFP2)

//Ch 11.6 exercise, part b)
reg LWW KL6 K618 WA WE WA2 WE2 WAWE WA3 WE3 WA2WE WAWE2 WFED WMED UN CIT PRIN if WHRS>0 //LWW without sample selectivity, Set A variables
reg LWW KL6 K618 WA WE WA2 WE2 WAWE WA3 WE3 WA2WE WAWE2 WFED WMED UN CIT PRIN AX AX2 if WHRS>0 //LWW without sample selectivity
reg LWW KL6 K618 WA WE WA2 WE2 WAWE WA3 WE3 WA2WE WAWE2 WFED WMED UN CIT PRIN INVR1 if WHRS>0 //LWW without sample selectivity, Set A variables
reg LWW KL6 K618 WA WE WA2 WE2 WAWE WA3 WE3 WA2WE WAWE2 WFED WMED UN CIT PRIN AX AX2 INVR2 if WHRS>0 //LWW without sample selectivity

//Ch 11.6 exercise part c)
//estimate LWHRS from LWW, INVR1 and INVR2
ivregress 2sls LWHRS KL6 K618 WA WE PRIN (LWW=KL6 K618 WA WE WA2 WE2 WAWE WA3 WE3 WA2WE WAWE2 WFED WMED UN CIT PRIN) if WHRS>0, vce(r) //Set A as IV, no lamda
estat endog, forcenonrobust //check endogeneity; low p ==> endo
estat overid, forcenonrobust //check over identification; low p ==> overid

ivregress 2sls LWHRS KL6 K618 WA WE PRIN INVR1 (LWW=KL6 K618 WA WE WA2 WE2 WAWE WA3 WE3 WA2WE WAWE2 WFED WMED UN CIT PRIN INVR1) if WHRS>0, vce(r)
estat endog, forcenonrobust //check endogeneity; low p ==> endo
estat overid, forcenonrobust //check over identification; low p ==> overid

ivregress 2sls LWHRS KL6 K618 WA WE PRIN (LWW=KL6 K618 WA WE WA2 WE2 WAWE WA3 WE3 WA2WE WAWE2 WFED WMED UN CIT PRIN AX AX2) if WHRS>0, vce(r) //Set A as IV, no lamda
estat endog, forcenonrobust //check endogeneity; low p ==> endo
estat overid, forcenonrobust //check over identification; low p ==> overid

ivregress 2sls LWHRS KL6 K618 WA WE PRIN INVR2 (LWW=KL6 K618 WA WE WA2 WE2 WAWE WA3 WE3 WA2WE WAWE2 WFED WMED UN CIT PRIN AX AX2 INVR2) if WHRS>0, vce(r) //Set A as IV, no lamda
estat endog, forcenonrobust //check endogeneity; low p ==> endo
estat overid, forcenonrobust //check over identification; low p ==> overid
