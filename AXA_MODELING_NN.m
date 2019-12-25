%% Initialisation

clear
clc
load('..\Cedric\Data_Preprocessed.mat');

%Get the amount of observations
amt_obs = size(Data_Preprocessed,1);

%% Drop data that is insignificant according to 
[b,se,pval,inmodel] = stepwisefit(Data_Preprocessed,Status);
pos_sign_var = find(pval<0.05);
Data_Preprocessed = Data_Preprocessed(:,pos_sign_var);

%% Optimise KNN

rng default

Xtrain = Data_Preprocessed(train_Ind,:);
Xval = Data_Preprocessed(val_Ind,:); 

Ytrain = Status(train_Ind,:);
Yval = Status(val_Ind,:);

%Define the variables we want to optimise using Bayesian Optimization
num = optimizableVariable('n',[1,amt_obs],'Type','integer');
dst = optimizableVariable('dst',{'cityblock','euclidean','minkowski','chebychev'},'Type','categorical');
dstwgt = optimizableVariable('dstwgt',{'equal','inverse','squaredinverse'},'Type','categorical');
%c = cvpartition(amt_obs, 'Kfold',100);

%Define the function we want to optimise for
%kfoldLoss minimises cross-validation loss
%fun = @(x)fitcknn(Data_Preprocessed_Selective,Status,'NumNeighbors',x.n,...
%    'Distance',char(x.dst),'DistanceWeight',char(x.dstwgt),...
%    'NSMethod','exhaustive','CVPartition',c));
fun = @(x)-Grid_Search_KNN_REVISED(Xtrain,Ytrain,Xval,Yval,x);

%See which hyperparameters give the best results
results = bayesopt(fun,[num,dst,dstwgt],'Verbose',0,...
    'AcquisitionFunctionName','expected-improvement-plus',...
    'NumSeedPoints',8);

%Get optimal parameters from results
bestparameters = table2cell(results.XAtMinObjective);
Opt_NumNeigh = cell2mat(bestparameters(1));
Opt_Dst = char(string(bestparameters(2)));
Opt_DstWgt = char(string(bestparameters(3)));

%% Dropping independent variables

%MANUAL

%A1_AVG_NEG_SALDO_PRIV_6_AMT (30)
%A1_AVG_POS_SALDO_PRIV_6_AMT (31)
%A1_AVG_POS_SALDO_SAVINGS_6_AMT (32)
%A1_COREPRIV_REFUSE_OPER_6_AMT (33)
%Data_Preprocessed_Selective = [Data_Preprocessed(:,1:29),Data_Preprocessed(:,34:53)];
%Data_Preprocessed_Header_Selective = [Data_Preprocessed_Header(:,1:29),Data_Preprocessed_Header(:,34:53)];

%AUTOMATIC
AUC_old = 0.5-eps;
AUC_new = 0.5;
Drop_Var_Mat = [];
q = size(Data_Preprocessed,2);
Data_Preprocessed_Auto = Data_Preprocessed;
Data_Preprocessed_Header_Auto = Data_Preprocessed_Header;
Header_Dropped = {};
r = 10;
m=1;
while AUC_old < AUC_new || q > 10
    AUC_old = AUC_new;
    AUC_Mat = zeros(1,q);
    for j = 1:1:q
        if j == 1
            %Drop first column
            Data_Preprocessed_Selective = Data_Preprocessed_Auto(:,2:end);
        elseif j == q
            %Drop last column
            Data_Preprocessed_Selective = Data_Preprocessed_Auto(:,1:end-1);
        else
            %Drop j-th column
            Data_Preprocessed_Selective = [Data_Preprocessed_Auto(:,1:j-1),Data_Preprocessed_Auto(:,j+1:end)];
        end
    %AUC_MC_Mat = zeros(1,r);
    %    for n = 1:r
            %% Create train and validation data

            Xtrain = Data_Preprocessed_Selective(train_Ind,:);
            Xval = Data_Preprocessed_Selective(val_Ind,:);

            %% k-Nearest neighbour

            %Predict and calculate AUC and Score
            knn_model = fitcknn(Xtrain,Ytrain,'NumNeighbors',Opt_NumNeigh,...
                'Distance',Opt_Dst,'DistanceWeight',Opt_DstWgt);
            [labels,scores] = predict(knn_model,Xval);
            %Build confusion matrix
            %[confmat,order] = confusionmat(Yval,labels);
            %Calculate AUC
            [X,Y,~,AUC] = perfcurve(Yval,scores(:,2),1);
            %Build ROC curve 
            %plot(X,Y);
            %Calculate accuracy
            %display(AUC)
            %cp = classperf(Yval, labels);
            %accuracy = cp.CorrectRate;
     %       AUC_MC_Mat(n) = AUC
     %   end
    %Use the mean of the Monte Carlo Simulation
    %AUC_MC_Mat_Mean = mean(AUC_MC_Mat);
    %Save AUC in matrix
    AUC_Mat(j) = AUC;
    end
%% Results from dropping variable(s)
    %Find the max AUC for a dropped variable
    AUC_max = max(AUC_Mat);
    pos_max = find(AUC_Mat == AUC_max);
    %pos_max represents the number of the column that was removed and
    %yielded the highers average AUC from all droppable columns
    if AUC_max > AUC_old
    Header_Dropped(m) = Data_Preprocessed_Header_Auto(pos_max);
    %display(["Drop the variable: ", Data_Preprocessed_Header_Auto(pos_max)])
        if pos_max == 1
                %Drop first column
                Data_Preprocessed_Auto = Data_Preprocessed_Auto(:,2:end);
                Data_Preprocessed_Header_Auto = ata_Preprocessed_Header_Auto(:,2:end);
            elseif pos_max == q
                %Drop last column
                Data_Preprocessed_Auto = Data_Preprocessed_Auto(:,1:end-1);
                Data_Preprocessed_Header_Auto = Data_Preprocessed_Header_Auto(:,1:end-1);
            else
                %Drop post_max-th column
                Data_Preprocessed_Auto = [Data_Preprocessed_Auto(:,1:pos_max-1),Data_Preprocessed_Auto(:,pos_max+1:end)];
                Data_Preprocessed_Header_Auto = [Data_Preprocessed_Header_Auto(:,1:pos_max-1),Data_Preprocessed_Header_Auto(:,pos_max+1:end)];
        end
    %Size of matrix after removing a column
    q = size(Data_Preprocessed_Auto,2);
    else break
    end
    %AUC_new represents the highest attained AUC
    AUC_new = AUC_max;
    m=m+1
end

%%Save data
save('Parameters_NN.mat','Header_Dropped','Opt_Dst','Opt_DstWgt','Opt_NumNeigh');