%% Initialisation
clear;
clc;
load('BANK_Data_AXA.mat');

%% Data preparation for every explanatory variable
Data_Preprocessed = [];%Contains preprocessed data
Data_Preprocessed_Header = [];%Contains header of preprocessed data

%All mean or mean and zero
mean = 'Mean';
zero = 'Zero';

%status
Status = Data(:,1);
Status = cell2mat(Status);

%applied_amt
applied_amt = Data(:,2);
applied_amt = cell2mat(applied_amt);
applied_amt_P = Preprocessing_Continous(applied_amt,mean);
Data_Preprocessed = [Data_Preprocessed applied_amt_P];
Data_Preprocessed_Header = [Data_Preprocessed_Header {'applied_amt'}];

%A1_AGE
A1_AGE = Data(:,3);
A1_AGE = cell2mat(A1_AGE);
A1_AGE_P = Preprocessing_Continous(A1_AGE,mean);
Data_Preprocessed = [Data_Preprocessed  A1_AGE_P];
Data_Preprocessed_Header = [Data_Preprocessed_Header {'A1_AGE'}];

%Besch_ckp_EE1
Besch_ckp_EE1 = Data(:,4);
Besch_ckp_EE1 = cell2mat(Besch_ckp_EE1);
Besch_ckp_EE1_P = Preprocessing_Continous(Besch_ckp_EE1,mean);
Data_Preprocessed = [Data_Preprocessed  Besch_ckp_EE1_P];
Data_Preprocessed_Header = [Data_Preprocessed_Header {'Besch_ckp_EE1'}];

%MS_Laatst_gerea_LOA_EE1
%    MS_Laatst_gerea_LOA_EE1 = Data(:,5);
%    %Bcs of missing values
%    pos_empty = find(strcmp(MS_Laatst_gerea_LOA_EE1,''));
%    MS_Laatst_gerea_LOA_EE1(pos_empty) = {NaN};
%    MS_Laatst_gerea_LOA_EE1 = cell2mat(MS_Laatst_gerea_LOA_EE1);
%    MS_Laatst_gerea_LOA_EE1_P = Preprocessing_Continous(MS_Laatst_gerea_LOA_EE1,zero);
%    Data_Preprocessed = [Data_Preprocessed  MS_Laatst_gerea_LOA_EE1_P];
%    Data_Preprocessed_Header = [Data_Preprocessed_Header {'MS_Laatst_gerea_LOA_EE1'}];

%Work_Type
Work_Type = Data(:,6);
[Work_Type_P, Work_Type_Cat_P] = Preprocessing_Discrete(Work_Type,'dummy');
Data_Preprocessed = [Data_Preprocessed Work_Type_P];
Data_Preprocessed_Header = [Data_Preprocessed_Header Work_Type_Cat_P];

%MENTION_NEGATIVE
MENTION_NEGATIVE = Data(:,7);
MENTION_NEGATIVE_P = zeros(length(MENTION_NEGATIVE),1);
MENTION_NEGATIVE_P(strcmp(MENTION_NEGATIVE,'1')) = 1;
Data_Preprocessed = [Data_Preprocessed MENTION_NEGATIVE_P];
Data_Preprocessed_Header = [Data_Preprocessed_Header {'MENTION_NEGATIVE'}];

%Mauvaise_Exp_Crd (DROPPED)
%    Mauvaise_Exp_Crd = Data(:,8);
%    Mauvaise_Exp_Crd_P = zeros(length(Mauvaise_Exp_Crd),1);
%    Mauvaise_Exp_Crd_P(strcmp(MENTION_NEGATIVE,'1')) = 1;
%    Data_Preprocessed = [Data_Preprocessed Mauvaise_Exp_Crd_P];
%    Data_Preprocessed_Header = [Data_Preprocessed_Header {'Mauvaise_Exp_Crd'}];

%PrdCd
PrdCd = Data(:,9);
[PrdCd_P, PrdCd_Cat_P] = Preprocessing_Discrete(PrdCd,'dummy');
Data_Preprocessed = [Data_Preprocessed PrdCd_P];
Data_Preprocessed_Header = [Data_Preprocessed_Header PrdCd_Cat_P];

%MS_Ltste_rea_krdopen_EE1
MS_Ltste_rea_krdopen_EE1 = Data(:,10);
pos_empty = find(strcmp(MS_Ltste_rea_krdopen_EE1,''));
MS_Ltste_rea_krdopen_EE1(pos_empty) = {NaN};
MS_Ltste_rea_krdopen_EE1 = cell2mat(MS_Ltste_rea_krdopen_EE1);
MS_Ltste_re_krdopen_EE1_P = Preprocessing_Continous(MS_Ltste_rea_krdopen_EE1,zero);
Data_Preprocessed = [Data_Preprocessed  MS_Ltste_re_krdopen_EE1_P];
Data_Preprocessed_Header = [Data_Preprocessed_Header {'MS_Ltste_rea_krdopen_EE1'}];

%AUTO_FIN
AUTO_FIN = Data(:,11);
pos_empty = find(strcmp(AUTO_FIN,''));
AUTO_FIN(pos_empty) = {NaN};
AUTO_FIN = cell2mat(AUTO_FIN);
AUTO_FIN_P = Preprocessing_Continous(AUTO_FIN,mean);
Data_Preprocessed = [Data_Preprocessed  AUTO_FIN_P];
Data_Preprocessed_Header = [Data_Preprocessed_Header {'AUTO_FIN'}];

%A1_ANNUAL_INCOME_AMT
A1_ANNUAL_INCOME_AMT = Data(:,12);
pos_empty = find(strcmp(A1_ANNUAL_INCOME_AMT,''));
A1_ANNUAL_INCOME_AMT(pos_empty) = {NaN};
A1_ANNUAL_INCOME_AMT = cell2mat(A1_ANNUAL_INCOME_AMT);
A1_ANNUAL_INCOME_AMT_P = Preprocessing_Continous(A1_ANNUAL_INCOME_AMT,mean);
Data_Preprocessed = [Data_Preprocessed  A1_ANNUAL_INCOME_AMT_P];
Data_Preprocessed_Header = [Data_Preprocessed_Header {'A1_ANNUAL_INCOME_AMT'}];

%Client-related variables: column nr.13-31 (continuous + missing values)
%A1_AVG_NEG_SALDO_PRIV_12_AMT
for i = 13:13
    VariableI = Data(:,i);
    pos_empty = find(strcmp(VariableI,''));
    VariableI(pos_empty) = {NaN};
    VariableI = cell2mat(VariableI);
    VariableI_P = Preprocessing_Continous(VariableI,zero);
    Data_Preprocessed = [Data_Preprocessed  VariableI_P];
    Data_Preprocessed_Header = [Data_Preprocessed_Header {Data_Header(i)}];
end
%A1_AVG_POS_SALDO_PRIV_12_AMT & A1_AVG_POS_SALDO_SAVINGS_12_AMT 
for i = 14:15
    VariableI = Data(:,i);
    pos_empty = find(strcmp(VariableI,''));
    VariableI(pos_empty) = {NaN};
    VariableI = cell2mat(VariableI);
    VariableI_P = Preprocessing_Continous(VariableI,mean);
    Data_Preprocessed = [Data_Preprocessed  VariableI_P];
    Data_Preprocessed_Header = [Data_Preprocessed_Header {Data_Header(i)}];
end
%A1_AVG_NEG_SALDO_PRIV_6_AMT & A1_COREPRIV_REFUSE_OPER_12_CNT
for i = 16:17
    VariableI = Data(:,i);
    pos_empty = find(strcmp(VariableI,''));
    VariableI(pos_empty) = {NaN};
    VariableI = cell2mat(VariableI);
    VariableI_P = Preprocessing_Continous(VariableI,zero);
    Data_Preprocessed = [Data_Preprocessed  VariableI_P];
    Data_Preprocessed_Header = [Data_Preprocessed_Header {Data_Header(i)}];
end
%A1_AVG_POS_SALDO_PRIV_6_AMT & A1_AVG_POS_SALDO_SAVINGS_6_AMT
for i = 18:19
    VariableI = Data(:,i);
    pos_empty = find(strcmp(VariableI,''));
    VariableI(pos_empty) = {NaN};
    VariableI = cell2mat(VariableI);
    VariableI_P = Preprocessing_Continous(VariableI,mean);
    Data_Preprocessed = [Data_Preprocessed  VariableI_P];
    Data_Preprocessed_Header = [Data_Preprocessed_Header {Data_Header(i)}];
end
%A1_COREPRIV_REFUSE_OPER_6_CNT -> A1_monthly_repl_income_amt
for i = 20:31
    VariableI = Data(:,i);
    pos_empty = find(strcmp(VariableI,''));
    VariableI(pos_empty) = {NaN};
    VariableI = cell2mat(VariableI);
    VariableI_P = Preprocessing_Continous(VariableI,zero);
    Data_Preprocessed = [Data_Preprocessed  VariableI_P];
    Data_Preprocessed_Header = [Data_Preprocessed_Header {Data_Header(i)}];
end

%account_term_mths_cnt
account_term_mths_cnt = Data(:,32);
account_term_mths_cnt = cell2mat(account_term_mths_cnt);
account_term_mths_cnt_P = Preprocessing_Continous(account_term_mths_cnt,mean);
Data_Preprocessed = [Data_Preprocessed  account_term_mths_cnt_P];
Data_Preprocessed_Header = [Data_Preprocessed_Header {'account_term_mths_cnt'}];

%Product mix variables: column nr. 33-40 (continuous + missing values)
for i = 33:40
    VariableI = Data(:,i);
    pos_empty = find(strcmp(VariableI,''));
    VariableI(pos_empty) = {NaN};
    VariableI = cell2mat(VariableI);
    VariableI_P = Preprocessing_Continous(VariableI,zero);
    Data_Preprocessed = [Data_Preprocessed  VariableI_P];
    Data_Preprocessed_Header = [Data_Preprocessed_Header {Data_Header(i)}];
end

%% Division of data into training and validation data
[train_Ind,val_Ind,test_Ind] = dividerand(length(Data_Preprocessed),.6,.2,.2);

%% Create train and validation data
Xtrain = Data_Preprocessed(train_Ind,:);
Xval = Data_Preprocessed(val_Ind,:);
Xtest = Data_Preprocessed(test_Ind,:);

Ytrain = Status(train_Ind,:);
Yval = Status(val_Ind,:);
Ytest = Status(test_Ind,:);

%% SMOTE
[Xtrain,Ytrain] = SMOTE(Xtrain,Ytrain);
[Xval,Yval] = SMOTE(Xval,Yval);
%   [Xtest,Ytest] = SMOTE(Xtest,Ytest);

%% Duplicate observations w/ Status == 1
%Check # observaties status' with 1 and 0
%sum(Ytrain);
%sum(Yval);
%Find positions
%pos_train_1 = find(Ytrain == 1);
%pos_val_1 = find(Yval == 1);
%Duplicate for Status
%Ytrain = vertcat(Ytrain,Ytrain(pos_train_1));
%Yval = vertcat(Yval,Yval(pos_val_1));
%Duplicate for features
%Xtrain = vertcat(Xtrain,Xtrain(pos_train_1,:));
%Xval = vertcat(Xval,Xval(pos_val_1,:));

%% Save Data_Preprocessed; Data_Preprocessed_Header; train_Ind and val_Ind
save ('Data_Preprocessed_v2.mat', 'Data_Preprocessed', 'Data_Preprocessed_Header',...
    'Xtrain','Ytrain',...
    'Xval','Yval',...
    'Xtest','Ytest',...
    'Status')
%% Calculation of correlations between the explanatory variables
C1 = [applied_amt A1_AGE Besch_ckp_EE1 MS_Laatst_gerea_LOA_EE1 Mauvaise_Exp_Crd_P MS_Ltste_rea_krdopen_EE1 AUTO_FIN A1_ANNUAL_INCOME_AMT account_term_mths_cnt];
Corr_Coeff1 = corrcoef(C1,'rows','pairwise')

%Client-related variables: column nr.12-20 & A1_ANNUAL_INCOME_AMT
C2 = [A1_ANNUAL_INCOME_AMT Data_Preprocessed(:,26:33)];
Corr_Coeff2 = corrcoef(C2,'rows','pairwise')

%Client-related variables: column nr.21-31 & A1_ANNUAL_INCOME_AMT
C3 = [A1_ANNUAL_INCOME_AMT Data_Preprocessed(:,34:44)];
Corr_Coeff3 = corrcoef(C3,'rows','pairwise')

%Product mix variables: column nr.33-40 & A1_ANNUAL_INCOME_AMT
C4 = [A1_ANNUAL_INCOME_AMT Data_Preprocessed(:,46:53)];
Corr_Coeff4 = corrcoef(C4,'rows','pairwise')

