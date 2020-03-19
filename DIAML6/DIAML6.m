%%
%DIAML Assignment 7
%Author: Ernest Kufuor Jr
%andrew id: ekufor
%Question 1

load BlueChipStockMoments
corr = corrcov(AssetCovar);
[wcoeff,score,latent,tsquared,explained] = pca(corr,'VariableWeights','variance');
x =[score(:,1),score(:,2)];

%Bar Charts
figure;
hb = bar(x);
title('Weight of Stocks for the 1st and 2nd Principal Components');
xlabel('Stocks');
ylabel('Weight');
legend('1st Principal Component','2nd Principal Component');

%Scatter Plot
figure;
plot(score(:,1),score(:,2),'+');
xlabel('1st Principal Component');
ylabel('2nd Principal Component');
title('Scatter Plot Showing of the First Two Principal Components');

%Number of PCs needed to explain 95% of the data
k=0;
variance =0;
for n=1:30 
    if (variance<= 95)
        variance= explained(n)+ variance;
        k=k+1
    end
end
variance
k
%Scree Plot
figure;
pareto(explained);
xlabel('Principal Components');
ylabel('Variance Explained');
title('Scree Plot of the Variance Explained fo the First Two Principal Components');

%Mean of Stocks
asset_mean = mean(AssetCovar);

%Euclidean Distances
[D1,I1] = pdist2(AssetCovar,asset_mean,'euclidean','Largest',3);

%Three Most Distant Stocks
AssetList(I1)
D1

%%
%Question 2
load BlueChipStockMoments
corr = corrcov(AssetCovar);

%Calculate Pairwise Distance
%Formula Pairwise-Distance = (2(1 ? ?ij))1/2.

pairwise_dist = sqrt(2*(1-corr));

%dendrogram
tree = linkage(corr,'average');
figure;
H=dendrogram(tree,0,'Labels', AssetList,'Orientation','left','ColorThreshold','default');
set(H,'LineWidth',1)
xlabel('Distances');
ylabel('Stocks');
title('Horizontal Dendrogram of the 30 stocks');

% 3 clusters
c = cluster(tree,'maxclust',3);
figure;
scatter(corr(:,1),corr(:,2),10,c)
dx = 0.01; 
dy = 0.01;
text(corr(:,1)+dx, corr(:,2)+dy, AssetList);
xlabel('Stocks');
ylabel('Distance');
title('Graph of clusters of the 30 stocks');

%%
%Question 3

%Process Data
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

%Build Forest
rfmdl = TreeBagger(50,[age,class,gender],survived ,'OOBPrediction','On',...
    'Method','classification');

%View Treel
view(rfmdl.Trees{1},"Mode","Graph");
error = oobError(rfmdl);
optimum = find(error == min(error))

figure;
plot(oobError(rfmdl));
xlabel('Number of Grown Trees');
ylabel('Out-of-Bag Classification Error');

%ROC Analysis Of Models on Titanic Dataset

%For Random Forest

%Find postion of survived
surv_pos = find(strcmp('1',rfmdl.ClassNames));
[Yfit,Sfit] = oobPredict(rfmdl);
[fpr,tpr,t,auc] = perfcurve(rfmdl.Y,Sfit(:,surv_pos),'1');
auc_rf = auc
figure;
plot(fpr,tpr)
xlabel('False Positive Rate');
ylabel('True Positive Rate');
hold on

%For Classification Tree
ctree = ClassificationTree.fit([age,class,gender],survived);
surv_pos = find(ctree.ClassNames==1);;
[~,score_nb] = resubPredict(ctree);
[fpr,tpr,t,auc] = perfcurve(ctree.Y,score_nb(:,surv_pos),'1');
auc_classification = auc
plot(fpr,tpr)

% %For KNN
hold on
KNN = ClassificationKNN.fit([age,class,gender],survived,'NumNeighbors',6);
surv_pos = find(KNN.ClassNames==1);
[~,score_nb] = resubPredict(KNN);
[fpr,tpr,t,auc] = perfcurve(KNN.Y,score_nb(:,surv_pos),'1');
auc_KNN = auc
plot(fpr,tpr)

hold on
%Logistic Regression
mdl =fitglm([age,gender,titanic.pclass],survived,'Distribution','binomial','Link','logit');
scores = mdl.Fitted.Probability;
[fpr,tpr,t,auc] = perfcurve(survived,scores,'1');
auc_logistic = auc
plot(fpr,tpr);
legend("Random Forest","Classfication Tree","KNN","Logistic Regression"); 
title("Area Under the Curve Graph For 4 Models");
%%
%Question 4
red = readtable("winequality-red.csv");
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
r_vars = [red_fixed,red_volatile,red_citric,red_sugar,red_chlorides,red_sulphur,red_total,red_density,red_ph,red_sulphates,red_alcohol];

%Build Forest
rfmdl = TreeBagger(50,r_vars,red_quality ,'OOBPrediction','On',...
    'Method','classification','OOBPredictorImportance','On');

%Get minimum number of leafs
leaf = [1 5 10 20 50 100];
col = 'rgbcmy';
figure
for i=1:length(leaf)
    h = TreeBagger(50,r_vars,red_quality,'method','r','oobpred','on','minleaf',leaf(i));
    plot(oobError(h),col(i));
    hold on;
end
xlabel('Number of Grown Trees');
ylabel('Mean Squared Error');
title("Graph of Mean Square Error vs Number of Grown Trees");
legend({'1' '5' '10' '20' '50' '100'},'Location','NorthEast');
hold off;
%View Tree
view(rfmdl.Trees{1},"Mode","Graph");
error = oobError(rfmdl);

%Linear Model Accuracy (MSE)
linearmdl = fitlm(r_vars,red_quality)
accuracy_linearmdl_mse = 100-(linearmdl.MSE*100)

%KNN Accuracy (MSE)
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

accuracy_KNNminMSE = 100-(((min(RMSE))^2)*100)

%lasso
[rB,rFitInfo] = lasso(r_vars,red_quality,'CV',10,"PredictorNames",lasso_rows);
red_idxLambdaMinMSE = rFitInfo.IndexMinMSE;
red_minMSEModelPredictors = FitInfo.PredictorNames(rB(:,red_idxLambdaMinMSE)~=0)
%correlation matrix
rows =["FixedAcidity";"VolatileAcidity";"CitricAcid";"ResidualSugar";"Chlorides";"FreeSulphurDioxide";"TotalSulphurDioxide";"Density";"pH";"Sulphates";"Alcohol";"Quality"];
vars = [red_fixed,red_volatile,red_citric,red_sugar,red_chlorides,red_sulphur,red_total,red_density,red_ph,red_sulphates,red_alcohol,red_quality];
R = corrcoef(vars);
red_corr = array2table(R,"RowNames",rows,"VariableNames",rows);
red_corr(:,1:11) = [] 
%Random Forest Accuracy (MSE)
accuracy_rf_mse = 100- (min(error)*100)
optimum = find(error == min(error))

figure;
plot(oobError(rfmdl));
xlabel('Number of Grown Trees');
ylabel('Out-of-Bag Classification Error');
title("Graph of Classification Error vs Number of Grown Trees");

%Draw Bar Graph
figure;
x = categorical({'Fixed Acidity','Volatile Acidity','Citric Acid','Residual Sugar','Chlorides','Free Sulphur Dioxide','Total Sulphur Dioxide','Density','pH','Sulphates','Alcohol'});
bar(x,rfmdl.OOBPermutedVarDeltaError);
ylabel("Out-Of-Bag Feature Importance");
xlabel("Features");
title("Importance of Predictor Variables");