function AUC = Grid_Search_KNN_REVISED(Xtrain,Ytrain,Xval,Yval,x)

model = fitcknn(Xtrain,Ytrain,'NumNeighbors',x.n,...
    'Distance',char(x.dst),'DistanceWeight',char(x.dstwgt),...
    'NSMethod','exhaustive');
[~,scores] = predict(model,Xval);
[~,~,~,AUC] = perfcurve(Yval,scores(:,2),1);
end

