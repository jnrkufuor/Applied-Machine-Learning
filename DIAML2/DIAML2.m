%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Ernest Kufuor Jr
% Course: Data Inference and Applied Machine Learning
% Assignment 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Question 1
gdp=readtable('GDP1.csv');
mal=readtable('malnutrition.csv');
metadata = readtable('gdp_meta.csv');
[e,f]=size(gdp);
mergedData = outerjoin(gdp,metadata);
mergedData(258,:) = [];
figure;
for n = 5:62
    scatter(table2array(gdp(:,n)),table2array(mal(:,n)))
    hold on;
end
xlabel('GDP Per Capita');
ylabel('Malnutrition Prevalence');
title('Scatter Plot of GPD Per Capita vs Malnutrition Prevalence');

figure;
for n = 5:62
    gscatter(table2array(mergedData(:,n)),table2array(mal(:,n)),mergedData.Region)
    hold on;
end
xlabel('GDP Per Capita');
ylabel('Malnutrition Prevalence');
title('Scatter Plot of GPD Per Capita vs Malnutrition Prevalence(Showing Developing Regions');

figure;
for n = 5:62
    gscatter(table2array(mergedData(:,n)),table2array(mal(:,n)),mergedData.Income)
    hold on;
end

xlabel('GDP Per Capita');
ylabel('Malnutrition Prevalence');
title('Scatter Plot of GPD Per Capita vs Malnutrition Prevalence(Showing Income Levels)');


%%
%Question 2
Quandl.api_key('6RdEtdt3yw3xsBYMvc7z');
wheat_data = Quandl.get('ODA/PWHEAMT_USD');
crude_data = Quandl.get('WGEC/WLD_CRUDE_WTI');
gold_data = Quandl.get('BUNDESBANK/BBK01_WT5511');

[sync_gold ,sync_crude] =synchronize(gold_data,crude_data,'intersection'); 
[sync_crude ,sync_wheat] =synchronize(crude_data,wheat_data,'intersection'); 
[sync_gold ,sync_wheat] =synchronize(gold_data,wheat_data,'intersection'); 
minGoldPrice = min(sync_gold.Data);
maxGoldPrice = max(sync_gold.Data);
minWheatPrice = min(sync_wheat.Data);
maxWheatPrice = max(sync_wheat.Data);
minCrudePrice = min(sync_crude.Data);
maxCrudePrice = max(sync_crude.Data);
iMinGold = find(sync_gold.Data == minGoldPrice);
iMaxGold = find(sync_gold.Data ==maxGoldPrice);
iMinWheat = find(sync_wheat.Data == minWheatPrice);
iMaxWheat = find(sync_wheat.Data == maxWheatPrice);
iMinCrude = find(sync_crude.Data == minCrudePrice,1);
iMaxCrude =find(sync_crude.Data == maxCrudePrice);

plot(sync_gold,'-ob','MarkerIndices',[iMinGold,iMaxGold],'MarkerFaceColor', 'b');
hold on;
plot(sync_wheat,'-og','MarkerIndices',[iMinWheat,iMaxWheat],'MarkerFaceColor', 'g');
hold on;
plot(sync_crude,'-or','MarkerIndices',[iMinCrude,iMaxCrude],'MarkerFaceColor', 'r');
xlabel('Years');
ylabel('Prices');
title('Timeseries Graph of Wheat, Gold and Crude Oil Prices');
legend('Gold','Wheat','Crude Oil','Location','NorthWest');

%%
%Question 3
%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 63);
% Specify range and delimiter
opts.DataLines = [6, 268];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "Var25", "Var26", "Var27", "Var28", "Var29", "Var30", "Var31", "Var32", "Var33", "Var34", "Var35", "Var36", "Var37", "Var38", "Var39", "Var40", "Var41", "Var42", "Var43", "Var44", "Var45", "Var46", "Var47", "Var48", "Var49", "Var50", "Var51", "Var52", "Var53", "Var54", "VarName55", "Var56", "Var57", "Var58", "Var59", "Var60", "Var61", "Var62", "Var63"];
opts.SelectedVariableNames = "VarName55";
opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "string", "string", "string", "string", "string", "string", "string"];
opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 56, 57, 58, 59, 60, 61, 62, 63], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 56, 57, 58, 59, 60, 61, 62, 63], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Import the data
Emissions = readtable("C:\Users\jaycu\Documents\MATLAB\Emissions.csv", opts);
opts = delimitedTextImportOptions("NumVariables", 63);
% Specify range and delimiter
opts.DataLines = [6, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "Var25", "Var26", "Var27", "Var28", "Var29", "Var30", "Var31", "Var32", "Var33", "Var34", "Var35", "Var36", "Var37", "Var38", "Var39", "Var40", "Var41", "Var42", "Var43", "Var44", "Var45", "Var46", "Var47", "Var48", "Var49", "Var50", "Var51", "Var52", "Var53", "Var54", "VarName55", "Var56", "Var57", "Var58", "Var59", "Var60", "Var61", "Var62", "Var63"];
opts.SelectedVariableNames = "VarName55";
opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "string", "string", "string", "string", "string", "string", "string"];
opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 56, 57, 58, 59, 60, 61, 62, 63], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 56, 57, 58, 59, 60, 61, 62, 63], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Import the data
Enrollment = readtable("C:\Users\jaycu\Documents\MATLAB\Enrollment.csv", opts);
clear opts;
Mean = nanmean(Emissions.VarName55);
Median = nanmedian(Emissions.VarName55);
standard_deviation = nanstd(Emissions.VarName55);
fifth_percentile = prctile(Emissions.VarName55,5);
twenty_fifth_percentile = prctile(Emissions.VarName55,25);
seventy_fifth_percentile = prctile(Emissions.VarName55,75);
ninety_fifth_percentile = prctile(Emissions.VarName55,95);
T= table(Mean,Median,standard_deviation,fifth_percentile,twenty_fifth_percentile,seventy_fifth_percentile,ninety_fifth_percentile);
disp("Descriptive Statistics For CO2 Emissions in 2010");
disp(T);
Mean = nanmean(Enrollment.VarName55);
Median = nanmedian(Enrollment.VarName55);
Standard_deviation = nanstd(Enrollment.VarName55);
Fifth_percentile = prctile(Enrollment.VarName55,5);
Twenty_fifth_percentile = prctile(Enrollment.VarName55,25);
Seventy_fifth_percentile = prctile(Enrollment.VarName55,75);
Ninety_fifth_percentile = prctile(Enrollment.VarName55,95);
T= table(Mean,Median,Standard_deviation,Fifth_percentile,Twenty_fifth_percentile,Seventy_fifth_percentile,Ninety_fifth_percentile);
disp("");
disp("Descriptive Statistics For School enrolment, primary (% net) in 2010");
disp(T);
%%
%Question 4
%Prepare and Import GDP Data
opts = delimitedTextImportOptions("NumVariables", 63);

% Specify range and delimiter
opts.DataLines = [6, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["DataSource", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "Var25", "Var26", "Var27", "Var28", "Var29", "Var30", "Var31", "Var32", "Var33", "Var34", "VarName35", "Var36", "Var37", "Var38", "Var39", "Var40", "Var41", "Var42", "Var43", "Var44", "Var45", "Var46", "Var47", "Var48", "Var49", "Var50", "Var51", "Var52", "Var53", "Var54", "VarName55", "Var56", "Var57", "Var58", "Var59", "Var60", "Var61", "Var62", "Var63"];
opts.SelectedVariableNames = ["DataSource", "VarName35", "VarName55"];
opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "string", "string", "string", "string", "string", "string", "string"];
opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 56, 57, 58, 59, 60, 61, 62, 63], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 56, 57, 58, 59, 60, 61, 62, 63], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

%Read GDP data
GDP = readtable("C:\Users\jaycu\Documents\MATLAB\GDP.csv", opts);

%Prepare and Import Fertility Data
% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 63);

% Specify range and delimiter
opts.DataLines = [6, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["DataSource", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "Var25", "Var26", "Var27", "Var28", "Var29", "Var30", "Var31", "Var32", "Var33", "Var34", "VarName35", "Var36", "Var37", "Var38", "Var39", "Var40", "Var41", "Var42", "Var43", "Var44", "Var45", "Var46", "Var47", "Var48", "Var49", "Var50", "Var51", "Var52", "Var53", "Var54", "VarName55", "Var56", "Var57", "Var58", "Var59", "Var60", "Var61", "Var62", "Var63"];
opts.SelectedVariableNames = ["DataSource", "VarName35", "VarName55"];
opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "string", "string", "string", "string", "string", "string", "string"];
opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 56, 57, 58, 59, 60, 61, 62, 63], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 56, 57, 58, 59, 60, 61, 62, 63], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
Fertility = readtable("C:\Users\jaycu\Documents\MATLAB\Fertility.csv", opts);
clear opts;

GDP2010 =GDP.VarName55;
Fertility1990 = Fertility.VarName35;
Fertility2010 = Fertility.VarName55;
figure(1);
scatter(GDP2010,Fertility2010)
title('Fetrility Rate vs GDP in 2010');
ylabel('Fertility Rate');
xlabel('GDP');
Fertility1990=rmmissing(Fertility1990);
Fertility2010=rmmissing(Fertility2010);
f_Mean_2010=mean(Fertility2010);
f_Mean_1990=mean(Fertility1990);
f_Median_2010=median(Fertility2010);
f_Median_1990=median(Fertility1990);
[f,x]= ecdf(Fertility1990);
[y,g]= ecdf(Fertility2010);
figure(2);
ecdf(Fertility1990)
hold on;
ecdf(Fertility2010)
xline(f_Mean_2010,'r');
xline(f_Mean_1990,':b');
xline(f_Median_2010,'--m');
xline(f_Median_1990,'-.k');
xlabel('Fertility Rate');
ylabel('Probability(x)');
legend('Fertility Rate 1990','Fertility Rate for 2010','Mean 2010','Mean 1990','Median 2010','Median 1990','Location','southeast');
title('Cumulative Distribution Functions for Fertility Rates for 1990 and 2010');
%%
%Question 5
CPI = readtable('CPI.xlsx');
HPI = readtable('hpi.xlsx');

[Countries, iHPI , iCPI] = intersect(HPI.Country,CPI.Country);
CPIranks = CPI.Rank(iCPI) ;
HPIranks = HPI.HPIRank(iHPI);
CountryCodes = CPI.WBCode(iCPI);
scatter(HPIranks,CPIranks);
title('CPI Ranks vs HPI Ranks 2016');
xlabel('Happy Planet Index Rank(HPI)');
ylabel('Corruption Perceptions Index Rank(CPI)');
text(HPIranks+0.5, CPIranks+0.5, CountryCodes);


