%%
%Question 2.3-2.5

titanic = readtable("titanic3.csv");
survived = titanic.survived;
class =titanic.pclass;
age  = titanic.age;
mean_age = mean(rmmissing(age));
age = fillmissing(age,'constant',mean_age);
gender = titanic.sex;
male_indices = find(titanic.sex=="male");
female_indices = find(titanic.sex=="female");
gender(male_indices)={0};
gender(female_indices)={1};
gender = cell2mat(gender);

ctree = ClassificationTree.fit([age,class,gender],survived);
view(ctree,"Mode","graph");

% in-sample evaluation
resuberror = resubLoss(ctree)

% Cross Validation
cvctree = crossval(ctree);
cvloss = kfoldLoss(cvctree)

% Find the optimal pruning level by minimizing cross-validated loss:
[~,~,~,bestlevel] = cvLoss(ctree,'subtrees','all','treesize','min')

% Prune the tree 
pctree = prune(ctree,'Level',3);
view(pctree,'mode','graph');
pvctree = crossval(pctree);
cvloss_out = kfoldLoss(pvctree)

%RegressionTree
mdl =fitglm([age,gender,class],survived,'linear','Distribution','binomial')

y_pred= round(predict(mdl,[age,gender,class])); 
con_mat = confusionmat(survived,y_pred)
accuracy = (con_mat(1,1)+con_mat(2,2))/(con_mat(1,1)+con_mat(1,2)+con_mat(2,1)+con_mat(2,2))
%%
%Question 3
titanic = readtable("titanic3.csv");
survived = titanic.survived;
class =titanic.pclass;
age  = titanic.age;
mean_age = mean(rmmissing(age));
age = fillmissing(age,'constant',mean_age);
gender = titanic.sex;
male_indices = find(titanic.sex=="male");
female_indices = find(titanic.sex=="female");
gender(male_indices)={0};
gender(female_indices)={1};
gender = cell2mat(gender);

X = [age, class, gender];
Y = survived;
[N,D] = size(X);
K = round(logspace(0,log10(N),10)); % number of neighbors
cvloss = zeros(length(K),1);

for k=1:length(K)
    % Construct a cross-validated classification model
    mdl = ClassificationKNN.fit(X,Y,'NumNeighbors',K(k));
    % Calculate the in-sample loss
    rloss(k)  = resubLoss(mdl);
    % Construct a cross-validated classifier from the model.
    cvmdl = crossval(mdl);
    % Examine the cross-validation loss, which is the average loss of each cross-validation model when predicting on data that is not used for training.
    cvloss(k) = kfoldLoss(cvmdl);
end

[cvlossmin,icvlossmin] = min(cvloss);
cvlossmin
kopt = K(icvlossmin)

figure;
semilogx(K,rloss,'g.-');
hold
semilogx(K,cvloss,'b.-');
plot(K(icvlossmin),cvloss(icvlossmin),'ro')
xlabel('Number of nearest neighbors');
ylabel('Ten-fold classification error');
legend('In-sample','Out-of-sample','Optimum','Location','NorthWest')
title('KNN classification');

neightbours = 5;
mdl = ClassificationKNN.fit(X,Y,'NumNeighbors',neightbours,'Distance','cityblock');
% Examine the resubstitution loss, which, by default, is the fraction of misclassifications from the predictions of mdl. (For nondefault cost, weights, or priors, see ClassificationKNN.loss.)
city_block_rloss = resubLoss(mdl)

mdl = ClassificationKNN.fit(X,Y,'Distance','chebychev','NumNeighbors',neightbours);
% Examine the resubstitution loss, which, by default, is the fraction of misclassifications from the predictions of mdl. (For nondefault cost, weights, or priors, see ClassificationKNN.loss.)
cheb_rloss = resubLoss(mdl)

mdl = ClassificationKNN.fit(X,Y,'NumNeighbors',neightbours,'Distance','correlation');
% Examine the resubstitution loss, which, by default, is the fraction of misclassifications from the predictions of mdl. (For nondefault cost, weights, or priors, see ClassificationKNN.loss.)
corr_rloss = resubLoss(mdl)

mdl = ClassificationKNN.fit(X,Y,'NumNeighbors',neightbours,'Distance','cosine');
% Examine the resubstitution loss, which, by default, is the fraction of misclassifications from the predictions of mdl. (For nondefault cost, weights, or priors, see ClassificationKNN.loss.)
cosine_rloss = resubLoss(mdl)

mdl = ClassificationKNN.fit(X,Y,'NumNeighbors',neightbours,'Distance','euclidean');
% Examine the resubstitution loss, which, by default, is the fraction of misclassifications from the predictions of mdl. (For nondefault cost, weights, or priors, see ClassificationKNN.loss.)
euclidean_rloss = resubLoss(mdl)

mdl = ClassificationKNN.fit(X,Y,'NumNeighbors',neightbours,'Distance','mahalanobis');
% Examine the resubstitution loss, which, by default, is the fraction of misclassifications from the predictions of mdl. (For nondefault cost, weights, or priors, see ClassificationKNN.loss.)
mahalanobis_rloss = resubLoss(mdl)

mdl = ClassificationKNN.fit(X,Y,'NumNeighbors',neightbours,'Distance','seuclidean');
% Examine the resubstitution loss, which, by default, is the fraction of misclassifications from the predictions of mdl. (For nondefault cost, weights, or priors, see ClassificationKNN.loss.)
seuclidean_rloss = resubLoss(mdl)



%Logistic Regression
age = titanic.age;
i0_10 = find(age > 0 & age <= 10);
age(i0_10) =0;
i10_20 = find(age > 10 & age <= 20);
age(i10_20) =1;
i20_30 = find(age > 20 & age <= 30);
age(i20_30) =2;
i30_40 = find(age > 30 & age <= 40);
age(i30_40) =3;
i40_50 = find(age > 40 & age <= 50);
age(i40_50) =4;
i50_60 = find(age > 50 & age <= 60);
age(i50_60) =5;
i60_70 = find(age > 60 & age <= 70);
age(i60_70) =6;
i70_80 = find(age > 70 & age <= 80);
age(i70_80) =7;

mdl =fitglm([age,gender,titanic.pclass],survived,'linear','Distribution','binomial')
y_pred= round(predict(mdl,[age,gender,titanic.pclass])); 
con_mat = confusionmat(survived,y_pred)
accuracy = (con_mat(1,1)+con_mat(2,2))/(con_mat(1,1)+con_mat(1,2)+con_mat(2,1)+con_mat(2,2))

%%
%Question 4
white = readtable("winequality-white.csv");
red = readtable("winequality-red.csv");
white_fixed = white.fixedAcidity;
white_volatile = white.volatileAcidity;
white_citric = white.citricAcid;
white_sugar = white.residualSugar;
white_chlorides = white.chlorides;
white_sulphur =white.freeSulfurDioxide;
white_total = white.totalSulfurDioxide;
white_density =white.density;
white_ph =white.pH;
white_sulphates =white.sulphates;
white_alcohol =white.alcohol;
white_quality =white.quality;

red_fixed = red.fixedAcidity;
red_volatile = red.volatileAcidity;
red_citric = red.citricAcid;
red_sugar = red.residualSugar;
red_chlorides = red.chlorides;
red_sulphur = red.freeSulfurDioxide;
red_total = red.totalSulfurDioxide;
red_density = red.density;
red_ph = red.pH;
red_sulphates = red.sulphates;
red_alcohol = red.alcohol;
red_quality = red.quality;

y = [mean(white_fixed),mean(red_fixed);
    mean(white_volatile),mean(red_volatile);mean(white_citric),mean(red_citric);
    mean(white_sugar),mean(red_sugar);mean(white_chlorides),mean(red_chlorides);
    mean(white_sulphur),mean(red_sulphur);mean(white_total),mean(red_total);
    mean(white_density),mean(red_density);
    mean(white_ph),mean(red_ph);mean(white_sulphates),mean(red_sulphates);
    mean(white_alcohol),mean(red_alcohol)];
x = categorical({'Fixed Acidity','Volatile Acidity','Citric Acid','Residual Sugar','Chlorides','Free Sulphur Dioxide','Total Sulphur Dioxide','Density','pH','Sulphates','Alcohol'});
figure;
hb = bar(x,y);
ylabel("Average");
xlabel("Features");
title("Bar Graph of Averages for Features of Red and White Wine");
legend("White Wine", "Red Wine");

%calculate correlation coefficient

rows =["FixedAcidity";"VolatileAcidity";"CitricAcid";"ResidualSugar";"Chlorides";"FreeSulphurDioxide";"TotalSulphurDioxide";"Density";"pH";"Sulphates";"Alcohol";"Quality"];
vars = [white_fixed,white_volatile,white_citric,white_sugar,white_chlorides,white_sulphur,white_total,white_density,white_ph,white_sulphates,white_alcohol,white_quality];
R = corrcoef(vars);
white_corr = array2table(R,"RowNames",rows,"VariableNames",rows);
white_corr(:,1:11) = []

rows =["FixedAcidity";"VolatileAcidity";"CitricAcid";"ResidualSugar";"Chlorides";"FreeSulphurDioxide";"TotalSulphurDioxide";"Density";"pH";"Sulphates";"Alcohol";"Quality"];
vars = [red_fixed,red_volatile,red_citric,red_sugar,red_chlorides,red_sulphur,red_total,red_density,red_ph,red_sulphates,red_alcohol,red_quality];
R = corrcoef(vars);
red_corr = array2table(R,"RowNames",rows,"VariableNames",rows);
red_corr(:,1:11) = [] 

%lasso
r_vars = [red_fixed,red_volatile,red_citric,red_sugar,red_chlorides,red_sulphur,red_total,red_density,red_ph,red_sulphates,red_alcohol];
w_vars = [white_fixed,white_volatile,white_citric,white_sugar,white_chlorides,white_sulphur,white_total,white_density,white_ph,white_sulphates,white_alcohol];
lasso_rows = {'FixedAcidity','VolatileAcidity','CitricAcid','ResidualSugar','Chlorides','FreeSulphurDioxide','TotalSulphurDioxide','Density','pH','Sulphates','Alcohol'};
 
[B,FitInfo] = lasso(w_vars,white_quality,'CV',10,"PredictorNames",lasso_rows);
lassoPlot(B,FitInfo,'PlotType','CV');
legend('show')
title("Cross-Validated MSE of Lasso Fit for White Wine")

[rB,rFitInfo] = lasso(r_vars,red_quality,'CV',10,"PredictorNames",lasso_rows);
red_idxLambdaMinMSE = rFitInfo.IndexMinMSE;
red_minMSEModelPredictors = FitInfo.PredictorNames(rB(:,red_idxLambdaMinMSE)~=0)
lassoPlot(rB,rFitInfo,'PlotType','CV')
legend('show')
title("Cross-Validated MSE of Lasso Fit for Red Wine")

lassoPlot(rB,'PredictorNames',lasso_rows);
legend('show','Location','NorthWest')
ylabel("Parameter Estimates");
xlabel("Lambda");
title("Trace Plots of Coefficients Fit By Lasso for Red Wine")
    
rX = [red_volatile,red_sugar,red_chlorides,red_sulphur, red_total,red_ph, red_sulphates, red_alcohol];
ry = red_quality;
rD = [red_volatile,red_sugar,red_chlorides,red_sulphur, red_total,red_ph, red_sulphates, red_alcohol, red_quality];

c = cvpartition(length(rD),"HoldOut",0.2);
test_ind =  find (c.test==1);
learn_ind = find(c.training ==1);
 
% learnig and testing datasets

Xl = rX(learn_ind,:);
yl = ry(learn_ind,:);
Xt = rX(test_ind,:);
yt = ry(test_ind);
nl = length(yl);
nt = length(yt);
yt_mean = mean(yt); 
K = 2.^[0:5];
for k=1:length(K)
   k;
   [idx, dist] = knnsearch(Xl,Xt,'dist','seuclidean','k',K(k));
   ythat = nanmean(yl(idx),2);
   E = yt - ythat;
   RMSE(k) = sqrt(nanmean(E.^2));
end

minMSE = (min(RMSE))^2

num =  (ythat - yt_mean).^2;
num = sum(num);

denom = (yt - yt_mean).^2;
denom = sum(denom);

R_Square = num/denom


figure
plot(K,RMSE,'k.-');
xlabel('Number of nearest neighbors')
ylabel('RMSE')
title("Graph of Nearest Neighbours");

KNNmdl = ClassificationKNN.fit(rX,ry)
linearmdl = fitlm(rX,ry)
