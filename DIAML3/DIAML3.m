%%Question 1
%
house_data = readtable("monthly.xls");
house_data = house_data(1:312,:);
FTSE = readtable("FTSE100.csv");
price = house_data.AverageHousePrice;
AdjClose = flipud(FTSE.AdjClose);
date = flipud(FTSE.Date(2:312,:));
FTSE_returns=[];
price_returns=[];
for n= 2:size(AdjClose)
    FTSE_returns(end+1) = (AdjClose(n)/AdjClose(n-1))-1;
    price_returns(end+1) = (price(n)/price(n-1))-1;
end
y = FTSE_returns;
x = price_returns;
regression = fitlm(x,y)
figure;
plot(regression);
xlabel("Uk House Price (Avg) Monthly Returns");
ylabel("FTSE Adjusted Close Monthly Returns");
title("Linear Regression Model of FTSE Adjusted Returns against UK Average House Prices");
correlation_coeff = corrcoef(x,y);
Correlation_Coeff = correlation_coeff(1,2)

%%
%Question 2
college = readtable("College.csv");
graduation_rate= college.Grad_Rate;
applications =college.Apps;
enrolled = college.Enroll;
out_of_state= college.Outstate;
top_10 = college.Top10perc;
top_25 = college.Top25perc;
vars=[applications enrolled out_of_state top_10 top_25 graduation_rate];
independent_vars=[applications enrolled out_of_state top_10 top_25];
correlation_coeff= corrcoef(vars);
label = {'Applications';'Enrolled';'Out_Of_State';'Top_10_Percent';'Top_25_Percent';'Graduation_Rate'};
coeffs = array2table(correlation_coeff,'RowNames',label,'VariableNames',label)
R = stepwiselm(independent_vars,graduation_rate,"linear")
%R = stepwisefit(independent_vars,graduation_rate);y
disp("For Bayesian Information Criterion");
B = stepwiselm(independent_vars,graduation_rate,"linear",'Criterion','bic')
lm = fitlm(independent_vars,graduation_rate)


P1 =predict(lm,independent_vars);
P2 =predict(R,independent_vars);

accuracy_all_variables= 100 -(mean((abs(lm.Residuals.Raw))./graduation_rate)*100)
accuracy_some_variables= 100 -(mean((abs(R.Residuals.Raw))./graduation_rate)*100)

%Calculate for CMU
cmu_predicted_graduation_rate = 35.896 + (0.00076872*8728) + (-0.0030019*1191) + (0.001736*17900) + (0.049318*60) + (0.18132*89)
cmu_actual_graduation_rate = "74%"

%%
%Question 3
gdp = readtable("GB_GDP.xlsx");
traffic = flipud(readtable("GB_Road_Traffic_In_Miles.xlsx"));
%calculate correlation coefficeint
gdp =gdp.GDP;

year = traffic.Year;
traffic = traffic.Traffic_inMiles_;

%correlation coefficient : gdp vs traffic in miles
correlation_coeff = corrcoef(gdp,traffic);
Correlation_Coefficient = correlation_coeff(2,1)

%scatter plot gdp vs traffic
figure;
scatter(gdp,traffic)
xlabel("GDP Per Capita");
ylabel("Traffic in Miles");
title("Scatter Plot of GDP Per Capita vs Traffic in Miles of the UK ( 1993-2018)");

%normalise data
gdp_norm = (gdp/gdp(1))*100;
traffic_norm = (traffic/traffic(1))*100;

%timeseries of traffic in miles from 1993 to 2018
figure;
plot(categorical(year),traffic_norm)
hold on;
plot(categorical(year),gdp_norm)
xlabel("Years");
ylabel("Value");
title("Timeseries Graph of GDP Per Capita and Traffic In Miles of The United Kingdom from 1993 to 2018");
legend("Traffic in Miles","GDP Per Capita");
%create model for gdp vs traffic in miles
lm_gdp_vs_traffic= fitlm(gdp,traffic)
year = datenum(year);

%create model for years vs traffic in miles
lm = fitlm(year, gdp);

%predict gdp for 2020
gdp_2020  = predict(lm,13677)

%%predict gdp for 2020
traffic_in_miles_2020= (gdp_2020 * 0.0029496) + 375.95

%%
%Question 4
Quandl.api_key('6RdEtdt3yw3xsBYMvc7z');
unemployment_data = flipud(Quandl.get('ODA/ISR_LUR','type','data'));


lm = fitlm(unemployment_data(1:34,1),unemployment_data(1:34,2))

%predict for 2022
model_prediction_2020 = predict(lm,738156)
qandl_data_prediction_2020 = unemployment_data(41,2)

%calculate accuracy
model_accuracy_in_percentage= 100 -(mean((abs(lm.Residuals.Raw)./unemployment_data(1:34,2))*100))