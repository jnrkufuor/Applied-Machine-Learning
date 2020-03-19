%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Ernest Kufuor Jr
% Course: Data Inference and Applied Machine Learning
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Question 1
noOfFolds = round(log(8848000)/log(2));
noOfFolds = (noOfFolds + 1);
disp("Number of Folds");
disp(noOfFolds);
%%
%Question 2
% Formula v(t) = v(0)e^(-at) , where a = 0.1
v0 = 44;
v_half =22;
a =0.01;
t=1;
vt=43;
while (vt > v_half)
    vt = v0*exp(-0.1*t);
    t = t + 0.01;
end

disp("Time take to reach v(0)/2");
disp(round(t));

%%
%Question 3
%Compound Interest
principal = 100;
rate = 0.05;
pow=1;
while (pow <= 5)
   investment = round(principal*(1+0.05)^pow);
   disp(investment);
   pow = pow+1;
end  
%%
%Question 4
%Loan 
principal =20000;
rate =0.01;
months= 12;
year = 1 ;

while (year <= 3)
    c = (1+rate)^(months*year);
    a = rate* c;
    b = c-1;
    debt_per_month = round(principal * (a/b));
    disp(debt_per_month);
    year = year +1;
end
%%
%Question 5
investment = 100000;
customers =100;
rate =1.01;
each_profits=10;
day =1;
profit = 0;
days = [];
profits=[];
while (profit < investment)
    days(end+1)=day;
    profit = profit + (customers *10);
    profits(end+1)=profit;
    customers = customers*rate;
    day= day +1;
end
plot(days,profits);
hold on;
label = {'Initial Investment/Breakeven Day'};
x=70;
y=100000;
plot(x,y,'*');
text(x,y,['(' num2str(x) ',' num2str(y) ')'],'HorizontalAlignment','left');
text(x,y,label,'HorizontalAlignment','right');
title('Cumulative Profits Per Day');
xlabel('Days');
ylabel('Cumulated Profits');

%%
%Question 6
ebola = readtable('ebola_download.xls');
dates= ebola.Date;
cases=ebola.Cases;
deaths=ebola.Death;
start_date = dates(1);
end_date= dates(end);
dates_array = start_date:end_date;
new_cases = interp1(dates,cases,dates_array);
new_deaths = interp1(dates,deaths,dates_array);
death_date_markers=dates_array(generate_indices(new_deaths));
case_date_markers=dates_array(generate_indices(new_cases));
death_markers=new_deaths(generate_indices(new_deaths));
case_markers=new_cases(generate_indices(new_cases));
plot(dates_array,new_deaths,dates_array,new_cases);
hold on;
plot(death_date_markers,death_markers,'bo');
plot(case_date_markers,case_markers,'ro');
legend('Deaths','Cases','First Instance Death Dates','First Instance Cases Dates','Location','northwest');
title('Ebola Cases and Deaths Against Date');
xlabel('Date');
ylabel('Deaths/Cases');

%%
%Question 7
[f,e]= size(new_deaths);
g_rates_deaths =[];
g_rates_cases =[];
deaths_sum =0 ;
cases_sum=0;
for n= f:(e-1)
    g_rates_deaths(end+1)= (new_deaths(n+1)-new_deaths(n))/new_deaths(n);
    g_rates_cases(end+1)= (new_cases(n+1)-new_cases(n))/new_cases(n);
end
mean_death_growth_rate= mean(g_rates_deaths)*100;
mean_case_growth_rate= mean(g_rates_cases)*100;

disp("Mean Growth Rate of Deaths");
disp(mean_death_growth_rate);

disp("Mean Growth Rate of Cases");
disp(mean_case_growth_rate);
%%
%Question 8
[f,l]= size(new_deaths);
ratio =0;
for j= f:l
    ratio = ratio + (new_cases(j)/new_deaths(j)); 
end
mean_ratio= ratio/l;
plot(dates_array,new_cases,dates_array,new_deaths);
txt = ['Average Ratio of Cases to Deaths: ' num2str(mean_ratio)];
legend('Deaths','Cases','Location','northwest');
text(0,12000,txt);
title('Ebola Deaths vs Cases');
xlabel('Dates');
ylabel('Cases/Deaths');

%%
%Question 9
TLT=readtable('TLT.csv');
SP500 =readtable('SPY.csv');
SP500_dates = datetime(SP500.Date);
TLT_closings = TLT.AdjClose;
SP500_closings = SP500.AdjClose;
TLT_dates = datetime(TLT.Date);
start_date = datetime(2014,01,01);
end_date = datetime(2015,08,31);
date_array = start_date:end_date;
SP500_final=find(SP500_dates > start_date & SP500_dates < end_date);
TLT_final=find(TLT_dates > start_date & TLT_dates < end_date);
closing_TLT = TLT_closings(TLT_final);
closing_SP500 = SP500_closings(SP500_final);
y1 = closing_SP500(1);
y2 = closing_TLT(1);
cSP500= (closing_SP500/y1)*100;
cTLT= (closing_TLT/y2)*100;
plot(SP500_dates(SP500_final),cSP500,TLT_dates(TLT_final),cTLT);
title('Time Series of TLT and SPY Stocks');
xlabel('Date');
ylabel('Stocks');
text(0,200,'TLT');
legend('SPY','TLT');
%%
%Question 10
%Daily Return
[f,l] = size(closing_SP500);
SPY_returns=[];
TLT_returns=[];
for n = (l+1):f
    ps = closing_SP500(n);
    ps1 = closing_SP500(n-1);
    pt = closing_TLT(n);
    pt1 = closing_TLT(n-1);
    SPY_returns(end+1) = (ps/(ps1-1));
    TLT_returns(end+1) = (pt/(pt1-1));
end

SPYmean = mean(SPY_returns);
disp("SPY Average Daily Returns");
disp(SPYmean);
TLTmean = mean(TLT_returns);
disp("TLT Average Daily Returns");
disp(TLTmean);
SPYmin = min(SPY_returns);
disp("SPY Min Daily Returns");
disp(SPYmin);
TLTmin = min(TLT_returns);
disp("TLT Min Daily Returns");
disp(TLTmin);
SPYmax = max(SPY_returns);
disp("SPY Max Daily Returns");
disp(SPYmax);
TLTmax = max(TLT_returns);
disp("TLT Min Daily Returns");
disp(TLTmax);


%%
function f = generate_indices(x)
value = min(x(find( x > 100)));
indices100 = find(x==value);
value = min(x(find( x > 500)));
indices500 = find(x==value);
value = min(x(find( x > 1000)));
indices1000 = find(x==value);
value = min(x(find( x > 2000)));
indices2000 =find(x==value);
value = min(x(find( x > 5000)));
indices5000 = find(x==value);

f =[indices100,indices500,indices1000,indices2000,indices5000];
end