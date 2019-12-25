function bestparameter = Grid_Search_tree_REVISED(Xtrain,Ytrain,Xval,Yval,x)

model = fitctree(Xtrain,Ytrain,'MinLeafSize',hyperparameter);
[~,scores] = predict(model,Xval);
[~,~,~,performance] = perfcurve(Yval,scores(:,2),1);
end
