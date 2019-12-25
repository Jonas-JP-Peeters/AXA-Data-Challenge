function [AUC] = TreeBaggerBay(x,Xtrain,Ytrain,Xval,Yval)
bagger_model = TreeBagger(x,Xtrain,Ytrain);
[~,scores] = predict(bagger_model,Xval);
[~,~,~,AUC] = perfcurve(Yval,scores(:,2),1);
end

