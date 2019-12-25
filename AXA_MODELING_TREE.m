%% Initialisation
clear
clc
load('..\Cedric\Data_Preprocessed.mat');
load('opt_nn_model.mat');
%% Drop data that is insignificant according to 
[b,se,pval,inmodel] = stepwisefit(Data_Preprocessed,Status);
pos_sign_var = find(pval<0.05);
Data_Preprocessed = Data_Preprocessed(:,pos_sign_var);

%% Create train and validation data
Xtrain = Data_Preprocessed(train_Ind,:);
Xval = Data_Preprocessed(val_Ind,:);

Ytrain = Status(train_Ind,:);
Yval = Status(val_Ind,:);

%% Building a kNN model
%Optimise the hyperparameters
rng default
tic
nn_model = fitcknn(Xtrain,Ytrain,'OptimizeHyperparameters',...
    {'Distance','NumNeighbors','DistanceWeight'},'HyperparameterOptimizationOptions',...
    struct('AcquisitionFunctionName','expected-improvement-plus','ShowPlots',true,'Verbose',0,...
    'Repartition',false,'Optimizer','gridsearch'));
toc
save('opt_nn_model.mat','nn_model');
%%
[labels,scores] = predict(nn_model,Xval);
[~,~,~,AUC] = perfcurve(Yval,scores(:,2),1);
%Select best parameters
%define cross-validation sets
c = cvpartition(size(Xtrain,1),'KFold',10);
%substract optimal hyperparameters from optimalised model
dst = nn_model.Distance;
dstwgt = nn_model.DistanceWeight;
num = nn_model.NumNeighbors;
%define function that outputs AUC using given model
fun = @(XT,yT,Xt,yt)NN(XT,yT,Xt,yt,dst,dstwgt,num);
[fs,history] = sequentialfs(fun,Xtrain,Ytrain,'cv',c);
pos_fs = find(fs == 1);
Data_Preprocessed = Data_Preprocessed(:,pos_fs);
%NN-model
knn_model = fitcknn(Xtrain,Ytrain,'Distance',dst,'NumNeighbors',num,'DistanceWeight',dstwgt);
[labels,scores] = predict(knn_model,Xval);
[X,Y,~,AUC] = perfcurve(Yval,scores(:,2),1);
%% Building an ensemble model
%Optimise the hyperparameters

rng default
ensemble = fitcensemble(Xtrain,Ytrain,'OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
    'expected-improvement-plus','ShowPlots',true,'Verbose',0,...
    'Repartition',false,'Optimizer','gridsearch'));

[labels,scores] = predict(ensemble,Xval);
[~,~,~,AUC] = perfcurve(Yval,scores(:,2),1);
[confmat,order] = confusionmat(Yval,labels);
%
t = templateTree('MinLeafSize',5);
tic
ensemble_model = fitcensemble(Xtrain,Ytrain,'Method','RUSBoost',...
    'NumLearningCycles',1000,'Learners',t,'LearnRate',0.1,'nprint',100);
toc
[labels,scores] = predict(ensemble_model,Xval);
[~,~,~,AUC] = perfcurve(Yval,scores(:,2),1);
[confmat,order] = confusionmat(Yval,labels);

%% Building a Support Vector Machine
tic
svm_model = fitcsvm(Xtrain,Ytrain,'KernelFunction','gaussian','ClassNames',[0,1]);
toc
[labels,scores] = predict(svm_model,Xval);
[~,~,~,AUC] = perfcurve(Yval,scores(:,2),1);
[confmat,order] = confusionmat(Yval,labels);

%% Building a bagged tree model
t = templateTree('MinLeafSize',5);
num = optimizableVariable('n',[1,400],'Type','integer');
tic
fun = @(x)-TreeBaggerBay(x.n,Xtrain,Ytrain,Xval,Yval);
toc
results = bayesopt(fun,[num],'Verbose',0,...
                'AcquisitionFunctionName','expected-improvement-plus');
z = results.XAtMinObjective.n;
bagger_model = TreeBagger(z,Xtrain,Ytrain);
[labels,scores] = predict(bagger_model,Xval);
[~,~,~,AUC] = perfcurve(Yval,scores(:,2),1);
[confmat,order] = confusionmat(Yval,str2num(cell2mat(labels)));

%% Building a LM model
logic_model = glmfit(Xtrain,Ytrain,'binomial','link','logit');
labels = glmval(logic_model,Xval,'logit');
[~,~,~,AUC] = perfcurve(Yval,scores(:,2),1);
[confmat,order] = confusionmat(Yval,labels);