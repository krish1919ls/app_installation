ods graphics on;
ods html;
ods listing close;

data mobile;
	set 'DATA.sas7bdat';
run;


/* Basic EDA */
proc tabulate data = mobile;
 	class device_platform_class device_make_class device_os_class install;
 	table  device_platform_class * device_make_class * device_os_class, install * n; 
	title 'Table: Platform, Make & OS Version vs Install';
run;

proc sgplot data = mobile;
	histogram device_height / group = device_platform_class transparency = 0.5 binstart = 0 binwidth = 200; 
 	density device_height / group = device_platform_class; 
	title 'Distribution: Device Height vs Platform';
run;

proc sgplot data = mobile;
	histogram device_width / group = device_platform_class transparency = 0.5 binstart = 0 binwidth = 300; 
 	density device_width / group = device_platform_class; 
	title 'Distribution: Device Width vs Platform';
run;

proc sgplot data = mobile;
	histogram device_volume / group = device_platform_class transparency = 0.5 binstart = 0 binwidth = 0.1; 
 	density device_volume / group = device_platform_class; 
	title 'Distribution: Device Volume vs Platform';
run;

proc sgplot data = mobile;
	histogram resolution / group = device_platform_class transparency = 0.5 binstart = 0 binwidth = 0.5; 
 	density resolution / group = device_platform_class;
	title 'Distribution: Device Resolution vs Platform'; 
run;

proc corr data = mobile;
	var device_height device_width device_volume resolution;
	title 'Correlation Matrix: Device Height, Width, Volume & Resolution';
run;


/* Data with Dummy Variables */
data mobile_dummy;
	set mobile;

	if publisher_id_class = 1 then pubid_1 = 1; else pubid_1 = 0;
	if publisher_id_class = 2 then pubid_2 = 1; else pubid_2 = 0;
	if publisher_id_class = 3 then pubid_3 = 1; else pubid_3 = 0;
	if publisher_id_class = 4 then pubid_4 = 1; else pubid_4 = 0;
	if publisher_id_class = 5 then pubid_5 = 1; else pubid_5 = 0;
	if publisher_id_class = 6 then pubid_6 = 1; else pubid_6 = 0;
	if publisher_id_class = 7 then pubid_7 = 1; else pubid_7 = 0;
	if publisher_id_class = 8 then pubid_8 = 1; else pubid_8 = 0;
	if publisher_id_class = 9 then pubid_9 = 1; else pubid_9 = 0;
	if publisher_id_class = 10 then pubid_10 = 1; else pubid_10 = 0;

	label pubid_1 = 'Publisher Id Class 1' pubid_2 = 'Publisher Id Class 2' pubid_3 = 'Publisher Id Class 3'
		pubid_4 = 'Publisher Id Class 4' pubid_5 = 'Publisher Id Class 5' pubid_6 = 'Publisher Id Class 6' 
		pubid_7 = 'Publisher Id Class 7' pubid_8 = 'Publisher Id Class 8' pubid_9 = 'Publisher Id Class 9'
		pubid_10 = 'Publisher Id Class 10';

	if device_os_class = 1 then os_1 = 1; else os_1 = 0;
	if device_os_class = 2 then os_2 = 1; else os_2 = 0;
	if device_os_class = 3 then os_3 = 1; else os_3 = 0;
	if device_os_class = 4 then os_4 = 1; else os_4 = 0;
	if device_os_class = 5 then os_5 = 1; else os_5 = 0;
	if device_os_class = 6 then os_6 = 1; else os_6 = 0;
	if device_os_class = 7 then os_7 = 1; else os_7 = 0;
	if device_os_class = 8 then os_8 = 1; else os_8 = 0;
	if device_os_class = 9 then os_9 = 1; else os_9 = 0;
	if device_os_class = 10 then os_10 = 1; else os_10 = 0;

	label os_1 = 'Device OS Class 1' os_2 = 'Device OS Class 2' os_3 = 'Device OS Class 3'
		os_4 = 'Device OS Class 4' os_5 = 'Device OS Class 5' os_6 = 'Device OS Class 6'
		os_7 = 'Device OS Class 7' os_8 = 'Device OS Class 8' os_9 = 'Device OS Class 9'
		os_10 = 'Device OS Class 10';

	if device_platform_class = 'iOS' then plat_ios = 1; else plat_ios = 0;
	if device_platform_class = 'android' then plat_android = 1; else plat_android = 0;

	label plat_ios = 'Device Platform Class iOS' plat_android = 'Device Platform Class Android';

	if device_make_class = 1 then make_1 = 1; else make_1 = 0;
	if device_make_class = 2 then make_2 = 1; else make_2 = 0;
	if device_make_class = 3 then make_3 = 1; else make_3 = 0;
	if device_make_class = 4 then make_4 = 1; else make_4 = 0;
	if device_make_class = 5 then make_5 = 1; else make_5 = 0;
	if device_make_class = 6 then make_6 = 1; else make_6 = 0;
	if device_make_class = 7 then make_7 = 1; else make_7 = 0;
	if device_make_class = 8 then make_8 = 1; else make_8 = 0;
	if device_make_class = 9 then make_9 = 1; else make_9 = 0;
	if device_make_class = 10 then make_10 = 1; else make_10 = 0;

	label make_1 = 'Device Make Class 1' make_2 = 'Device Make Class 2' make_3 = 'Device Make Class 3'
		make_4 = 'Device Make Class 4' make_5 = 'Device Make Class 5' make_6 = 'Device Make Class 6'
		make_7 = 'Device Make Class 7' make_8 = 'Device Make Class 8' make_9 = 'Device Make Class 9'
		make_10 = 'Device Make Class 10';

	drop resolution publisher_id_class device_os_class device_platform_class device_make_class;

run;

/* Train and Test Set */
proc surveyselect data = mobile_dummy out = mobile_dummy outall samprate = 0.7 seed = 10;
	title '70-30 Split for Train and Test Sets (Original Dataset)';
run;

data mobile_dummy_train mobile_dummy_test;
	set mobile_dummy;
 	if selected then output mobile_dummy_train; 
 	else output mobile_dummy_test;
run;


/* Linear Probability Models */

/* Model 1: Linear Regression with all Variables */
proc reg data = mobile_dummy plots = none; 
	model install = pubid_1 pubid_2 pubid_3 pubid_4 pubid_5 pubid_6 pubid_7 pubid_8 pubid_9 pubid_10
		os_1 os_2 os_3 os_4 os_5 os_6 os_7 os_8 os_9 os_10
		plat_ios plat_android 
		make_1 make_2 make_3 make_4 make_5 make_6 make_7 make_8 make_9 make_10
		wifi device_height device_width device_volume / vif collinoint;
	weight selected;
	output out = mobile_lin_predict_1 p = lin_pred;
	title 'Model 1: Linear Regression with all Variables'; 
quit;

proc logistic data = mobile_lin_predict_1 plots(only) = roc;
 	model install (event = '1') = device_height device_width device_volume / nofit;
 	roc pred = lin_pred;
 	where selected = 0;
quit;

/* Model 2: Stepwise Linear Regression with SBC Selection and best Validation model */
proc glmselect data = mobile_dummy_train testdata = mobile_dummy_test seed = 10 plots = none;
	partition fraction(validate = 0.1);
 	model install = pubid_1 pubid_2 pubid_3 pubid_4 pubid_5 pubid_6 pubid_7 pubid_8 pubid_9 pubid_10
		os_1 os_2 os_3 os_4 os_5 os_6 os_7 os_8 os_9 os_10
		plat_ios plat_android 
		make_1 make_2 make_3 make_4 make_5 make_6 make_7 make_8 make_9 make_10
		wifi device_height device_width device_volume
  	/ selection = stepwise(select = sbc choose = validate stop = none) hierarchy = single;
 	performance buildsscp = incremental;
	title 'Model 2: Stepwise Linear Regression with SBC Selection and best Validation model';
quit;

proc reg data = mobile_dummy plots = none; 
	model install = device_height pubid_3 make_7;
	weight selected;
	output out = mobile_lin_predict_2 p = lin_pred; 
quit;

proc logistic data = mobile_lin_predict_2 plots(only) = roc;
 	model install (event = '1') = device_height pubid_3 make_7 / nofit;
 	roc pred = lin_pred;
	where selected = 0;
quit;

/* Model 3: Lasso Linear Regression with best Validation model */
proc glmselect data = mobile_dummy_train testdata = mobile_dummy_test seed = 10 plots = none;
	partition fraction(validate = 0.1);
 	model install = pubid_1 pubid_2 pubid_3 pubid_4 pubid_5 pubid_6 pubid_7 pubid_8 pubid_9 pubid_10
		os_1 os_2 os_3 os_4 os_5 os_6 os_7 os_8 os_9 os_10
		plat_ios plat_android 
		make_1 make_2 make_3 make_4 make_5 make_6 make_7 make_8 make_9 make_10
		wifi device_height device_width device_volume
  	/ selection = lasso(choose = validate stop = none) hierarchy = single;
 	performance buildsscp = incremental;
	title 'Model 3: Lasso Linear Regression with best Validation model';
quit;
/* Model 3 = Model 1 */


/* Logistic Regression Models without Over-Sampling */

/* Model 1: Logistic Regression with all Variables */
proc logistic data = mobile_dummy_train;
 	model install (event = '1') = pubid_1 pubid_2 pubid_3 pubid_4 pubid_5 pubid_6 pubid_7 pubid_8 pubid_9 pubid_10
		os_1 os_2 os_3 os_4 os_5 os_6 os_7 os_8 os_9 os_10
		plat_ios plat_android 
		make_1 make_2 make_3 make_4 make_5 make_6 make_7 make_8 make_9 make_10
		wifi device_height device_width device_volume;
 	score data = mobile_dummy_test out = mobile_log_predict_1;
	title 'Model 1: Logistic Regression with all Variables';
quit;

proc logistic data = mobile_log_predict_1 plots(only) = roc;
 	model install (event = '1') = device_height device_width device_volume / nofit;
 	roc pred = p_1;
quit;

/* Model 2: Stepwise Logistic Regression with SBC Selection and best Validation model */
proc hplogistic data = mobile_dummy_train;
	partition fraction(validate = 0.1 seed = 10);
 	model install (event = '1') = pubid_1 pubid_2 pubid_3 pubid_4 pubid_5 pubid_6 pubid_7 pubid_8 pubid_9 pubid_10
		os_1 os_2 os_3 os_4 os_5 os_6 os_7 os_8 os_9 os_10
		plat_ios plat_android 
		make_1 make_2 make_3 make_4 make_5 make_6 make_7 make_8 make_9 make_10
		wifi device_height device_width device_volume;
	selection method = stepwise(select = sbc choose = validate stop = none);
	title 'Model 2: Stepwise Logistic Regression with SBC Selection and best Validation model';
quit;

proc logistic data = mobile_dummy_train;
 	model install (event = '1') = pubid_3 make_7 device_height;
 	score data = mobile_dummy_test out = mobile_log_predict_2;
quit;

proc logistic data = mobile_log_predict_2 plots(only) = roc;
 	model install (event = '1') = pubid_3 make_7 device_height / nofit;
 	roc pred = p_1;
	where selected = 0;
quit;


/* Over-Sampling Weights and Offset */
proc freq data = mobile_dummy;
	table install / out = fullpct(where = (install = 1) rename = (percent = fullpct));
	title 'Frequency Counts of Orignal Dataset';
run;

data mobile_dummy_sub;
    set mobile_dummy;
    if install = 1 or (install = 0 and ranuni(75302) < 1 / 14) then output;
run;

proc freq data = mobile_dummy_sub;
	table install / out = subpct(where = (install = 1) rename = (percent = subpct));
	title 'Frequency Counts of Over-Sampled Dataset';
run;

data mobile_dummy_sub;
	set mobile_dummy_sub;
	if _n_= 1 then set fullpct(keep = fullpct);
	if _n_= 1 then set subpct(keep = subpct);
	p1 = fullpct / 100; 
	r1 = subpct / 100;
	w = p1 / r1; 
	if install = 0 then w = (1 - p1)/(1 - r1);
	off = log((r1 * (1 - p1)) / ((1 - r1) * p1));
	drop selected;
run;

/* Over-Sampled Train and Test sets */
proc surveyselect data = mobile_dummy_sub out = mobile_dummy_sub outall samprate = 0.7 seed = 10;
	title '70-30 Split for Train and Test Sets (Over-Sampled Dataset)';
run;

data mobile_dummy_sub_train mobile_dummy_sub_test;
	set mobile_dummy_sub;
 	if selected then output mobile_dummy_sub_train; 
 	else output mobile_dummy_sub_test;
run;


/* PART I */

/* Final Models */

/* Model 1: Linear Regression */
proc reg data = mobile_dummy_sub plots = none; 
	model install = pubid_1 pubid_2 pubid_3 pubid_4 pubid_5 pubid_6 pubid_7 pubid_8 pubid_9 pubid_10
		os_1 os_2 os_3 os_4 os_5 os_6 os_7 os_8 os_9 os_10
		plat_ios plat_android 
		make_1 make_2 make_3 make_4 make_5 make_6 make_7 make_8 make_9 make_10
		wifi device_height device_width device_volume;
	weight selected;
	output out = mobile_lin p = mobile_lin_predict; 
	title 'Final Model 1: Linear Regression';
quit;

proc logistic data = mobile_lin plots(only) = roc;
 	model install (event = '1') = device_height device_width device_volume / nofit;
 	roc pred = mobile_lin_predict;
 	where selected = 0;
quit;

/* Model 2: Logistic Regression (Unadjusted Model) */ 
proc logistic data = mobile_dummy_sub_train;
    model install(event = '1') = pubid_1 pubid_2 pubid_3 pubid_4 pubid_5 pubid_6 pubid_7 pubid_8 pubid_9 pubid_10
		os_1 os_2 os_3 os_4 os_5 os_6 os_7 os_8 os_9 os_10
		plat_ios plat_android 
		make_1 make_2 make_3 make_4 make_5 make_6 make_7 make_8 make_9 make_10
		wifi device_height device_width device_volume;
    output out = mobile_log_unadj_train p = mobile_log_unadj_predict;
	score data = mobile_dummy_sub_test out = mobile_log_unadj_test outroc = mobile_log_unadj_roc;
	title 'Final Model 2: Logistic Regression (Unadjusted)';
run;

proc logistic data = mobile_log_unadj_test plots(only) = roc;
 	model install (event = '1') = device_height device_width device_volume wifi / nofit;
 	roc pred = p_1;
quit;

/* Model 3: Logistic Regression (Weight-Adjusted Model) */ 
proc logistic data =  mobile_log_unadj_train;
	model install(event = '1') = pubid_1 pubid_2 pubid_3 pubid_4 pubid_5 pubid_6 pubid_7 pubid_8 pubid_9 pubid_10
		os_1 os_2 os_3 os_4 os_5 os_6 os_7 os_8 os_9 os_10
		plat_ios plat_android 
		make_1 make_2 make_3 make_4 make_5 make_6 make_7 make_8 make_9 make_10
		wifi device_height device_width device_volume;
	weight w;
	score data = mobile_dummy_sub_test out = mobile_log_weight_test outroc = mobile_log_weight_roc;
	title 'Final Model 3: Logistic Regression (Weight-Adjusted)';
run;

proc logistic data = mobile_log_weight_test plots(only) = roc;
 	model install (event = '1') = device_height device_width device_volume wifi / nofit;
 	roc pred = p_1;
quit;

/* Model 4: Logistic Regression (Offset-Adjusted Model) */ 
proc logistic data =  mobile_log_unadj_train;
    model install(event = '1') = pubid_1 pubid_2 pubid_3 pubid_4 pubid_5 pubid_6 pubid_7 pubid_8 pubid_9 pubid_10
		os_1 os_2 os_3 os_4 os_5 os_6 os_7 os_8 os_9 os_10
		plat_ios plat_android 
		make_1 make_2 make_3 make_4 make_5 make_6 make_7 make_8 make_9 make_10
		wifi device_height device_width device_volume / offset = off;
    score data = mobile_dummy_sub_test out = mobile_log_offset_test outroc = mobile_log_offset_roc;
	title 'Final Model 4: Logistic Regression (Offset-Adjusted)';
run;

proc logistic data = mobile_log_offset_test plots(only) = roc;
 	model install (event = '1') = device_height device_width device_volume wifi / nofit;
 	roc pred = p_1;
quit;



/* PART II */

/* Total Costs */

/* Model 1: Linear Regression */
data mobile_lin_roc;
	set mobile_lin;
	where selected = 0;
	keep install mobile_lin_predict;
run;

data mobile_lin_roc;
	set mobile_lin_roc;
	if install = 0 and mobile_lin_predict > 0.001 then falpos_001 = 1; else falpos_001 = 0;
	if install = 1 and mobile_lin_predict < 0.001 then falneg_001 = 1; else falneg_001 = 0;
	if install = 0 and mobile_lin_predict > 0.005 then falpos_005 = 1; else falpos_005 = 0;
	if install = 1 and mobile_lin_predict < 0.005 then falneg_005 = 1; else falneg_005 = 0;
	if install = 0 and mobile_lin_predict > 0.010 then falpos_010 = 1; else falpos_010 = 0;
	if install = 1 and mobile_lin_predict < 0.010 then falneg_010 = 1; else falneg_010 = 0;
	if install = 0 and mobile_lin_predict > 0.015 then falpos_015 = 1; else falpos_015 = 0;
	if install = 1 and mobile_lin_predict < 0.015 then falneg_015 = 1; else falneg_015 = 0;
	if install = 0 and mobile_lin_predict > 0.020 then falpos_020 = 1; else falpos_020 = 0;
	if install = 1 and mobile_lin_predict < 0.020 then falneg_020 = 1; else falneg_020 = 0;
	if install = 0 and mobile_lin_predict > 0.025 then falpos_025 = 1; else falpos_025 = 0;
	if install = 1 and mobile_lin_predict < 0.025 then falneg_025 = 1; else falneg_025 = 0;
	if install = 0 and mobile_lin_predict > 0.030 then falpos_030 = 1; else falpos_030 = 0;
	if install = 1 and mobile_lin_predict < 0.030 then falneg_030 = 1; else falneg_030 = 0;
	if install = 0 and mobile_lin_predict > 0.035 then falpos_035 = 1; else falpos_035 = 0;
	if install = 1 and mobile_lin_predict < 0.035 then falneg_035 = 1; else falneg_035 = 0;
	if install = 0 and mobile_lin_predict > 0.040 then falpos_040 = 1; else falpos_040 = 0;
	if install = 1 and mobile_lin_predict < 0.040 then falneg_040 = 1; else falneg_040 = 0;
	if install = 0 and mobile_lin_predict > 0.045 then falpos_045 = 1; else falpos_045 = 0;
	if install = 1 and mobile_lin_predict < 0.045 then falneg_045 = 1; else falneg_045 = 0;
	if install = 0 and mobile_lin_predict > 0.050 then falpos_050 = 1; else falpos_050 = 0;
	if install = 1 and mobile_lin_predict < 0.050 then falneg_050 = 1; else falneg_050 = 0;
run;

data mobile_lin_roc;
	set mobile_lin_roc;
	cost_001 = falpos_001 + (100 * falneg_001);
	cost_005 = falpos_005 + (100 * falneg_005);
	cost_010 = falpos_010 + (100 * falneg_010);
	cost_015 = falpos_015 + (100 * falneg_015);
	cost_020 = falpos_020 + (100 * falneg_020);
	cost_025 = falpos_025 + (100 * falneg_025);
	cost_030 = falpos_030 + (100 * falneg_030);
	cost_035 = falpos_035 + (100 * falneg_035);
	cost_040 = falpos_040 + (100 * falneg_040);
	cost_045 = falpos_045 + (100 * falneg_045);
	cost_050 = falpos_050 + (100 * falneg_050);
run;

proc means data = mobile_lin_roc sum maxdec = 0;
    var falpos_001 falneg_001 cost_001 falpos_005 falneg_005 cost_005 falpos_010 falneg_010 cost_010 
		falpos_015 falneg_015 cost_015 falpos_020 falneg_020 cost_020 falpos_025 falneg_025 cost_025 
		falpos_030 falneg_030 cost_030 falpos_035 falneg_035 cost_035 falpos_040 falneg_040 cost_040 
		falpos_045 falneg_045 cost_045 falpos_050 falneg_050 cost_050;
	title 'Total Costs of Final Model 1: Linear Regression';
run;

/* Model 2: Logistic Regression (Unadjusted Model) */ 
data mobile_log_unadj_roc;
	set mobile_log_unadj_roc;
	total_cost = _FALNEG_ * 100 + _FALPOS_ * 1;
run;

proc sort data = mobile_log_unadj_roc out = mobile_log_unadj_roc;
	title 'Total Costs Final Model 2: Logistic Regression (Unadjusted)';
	by total_cost;
run;

proc print data = mobile_log_unadj_roc (obs = 1);
run;

/* Model 3: Logistic Regression (Weight-Adjusted Model) */ 
data mobile_log_weight_roc;
	set mobile_log_weight_roc;
	total_cost = _FALNEG_ * 100 + _FALPOS_ * 1;
run;

proc sort data = mobile_log_weight_roc out = mobile_log_weight_roc;
	title 'Total Costs Final Model 3: Logistic Regression (Weight-Adjusted)';
	by total_cost;
run;

proc print data = mobile_log_weight_roc (obs = 1);
run;

/* Model 4: Logistic Regression (Offset-Adjusted Model) */ 
data mobile_log_offset_roc;
	set mobile_log_offset_roc;
	total_cost = _FALNEG_ * 100 + _FALPOS_ * 1;
run;

proc sort data = mobile_log_offset_roc out = mobile_log_offset_roc;
	title 'Total Costs Final Model 3: Logistic Regression (Offset-Adjusted)';
	by total_cost;
run;

proc print data = mobile_log_offset_roc (obs = 1);
run;
