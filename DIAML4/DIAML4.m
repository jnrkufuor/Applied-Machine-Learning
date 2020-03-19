
%%
%Ernest Kufuor Jr
%DIAML Assignment 5
%Question 3
diabetes = readtable("Diabetes_Data.xlsx");

rows =["AGE";"SEX";"BMI";"BP";"S1";"S2";"S3";"S4";"S5";"S6"];
vars = [diabetes.AGE,diabetes.SEX,diabetes.BMI,diabetes.BP,diabetes.S1,diabetes.S2,diabetes.S3,diabetes.S4,diabetes.S5,diabetes.S6];
R = corrcoef(vars);
CorrMatrix = array2table(R,"RowNames",rows,"VariableNames",rows)
imagesc(R)
colorbar
xticklabels({"AGE","SEX","BMI","BP","S1","S2","S3","S4","S5","S6"});
yticklabels({"AGE","SEX","BMI","BP","S1","S2","S3","S4","S5","S6"});
title("Heatmap of Correlation Coefficients of Diabeties Predictor Variables");
predictors = [diabetes.AGE,diabetes.SEX,diabetes.BMI,diabetes.BP,diabetes.S1,diabetes.S2,diabetes.S3,diabetes.S4,diabetes.S5,diabetes.S6];
y = diabetes.Y;
multivariate_mdl= fitlm(predictors,y)
stepwise(predictors,y)
%%
%Question 4
titanic = readtable("titanic3.csv");
survived = titanic.survived;
survivors= size(find(survived==1));
passenger_survivors=(find(survived==1));
survivor_age=titanic.age(find(survived==1));
survivor_sex = titanic.sex(find(survived==1));
survivor_class=titanic.pclass(find(survived==1));
passengers = size(survived);
p_survived = survivors(1)/passengers(1)

p_survived_1_class= length(find(survivor_class==1))/length(find(titanic.pclass==1));
p_survived_2_class= length(find(survivor_class==2))/length(find(titanic.pclass==2));
p_survived_3_class= length(find(survivor_class==3))/length(find(titanic.pclass==3));

p_survived_male= length(find(survivor_sex=="male"))/length(find(titanic.sex=="male"));
p_survived_female= length(find(survivor_sex=="female"))/length(find(titanic.sex=="female"));

p_survived_0_10= length(find(survivor_age > 0 & survivor_age <= 10))/length(find(titanic.age > 0 & titanic.age <= 10));
p_survived_10_20= length(find(survivor_age > 10 & survivor_age <= 20))/length(find(titanic.age > 10 & titanic.age <= 20));
p_survived_20_30= length(find(survivor_age > 20 & survivor_age <= 30))/length(find(titanic.age > 20 & titanic.age <= 30));
p_survived_30_40= length(find(survivor_age > 30 & survivor_age <= 40))/length(find(titanic.age > 30 & titanic.age <= 40));
p_survived_40_50= length(find(survivor_age > 40 & survivor_age <= 50))/length(find(titanic.age > 40 & titanic.age <= 50));
p_survived_50_60= length(find(survivor_age > 50 & survivor_age <= 60))/length(find(titanic.age > 50 & titanic.age <= 60));
p_survived_60_70= length(find(survivor_age > 60 & survivor_age <= 70))/length(find(titanic.age > 60 & titanic.age <= 70));
p_survived_70_80= length(find(survivor_age > 70 & survivor_age <= 80))/length(find(titanic.age > 70 & titanic.age <= 80));

probabilities = [p_survived_1_class,p_survived_2_class,p_survived_3_class,p_survived_male,p_survived_female,p_survived_0_10,p_survived_10_20,p_survived_20_30,p_survived_30_40,p_survived_40_50,p_survived_50_60,p_survived_60_70,p_survived_70_80];
vars =["First_Class_Survivors";"Second_Class_Survivors";"Third_Class_Survivors";"Male_Survivors";"Female_Survivors";"x0_10";"x10_20";"x20_30";"x30_40";"x40_50";"x50_60";"x60_70";"x70_80"];
table = array2table(probabilities',"RowNames",vars,"VariableNames","Probability")

male_indices = find(titanic.sex=="male");
female_indices = find(titanic.sex=="female");
gender = titanic.sex;
gender(male_indices)={0};
gender(female_indices)={1};
gender = cell2mat(gender);

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


