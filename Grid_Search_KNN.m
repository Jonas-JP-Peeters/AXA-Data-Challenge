function bestparameter = Grid_Search_KNN(Xtrain,Ytrain,Xval,Yval,minvalue,step,maxvalue,distanceweight)
bestparameter = 0;
bestperformance = 0;


for hyperparameter = [minvalue:step:maxvalue]


	model = fitcknn(Xtrain,Ytrain,'NumNeighbors',hyperparameter,'DistanceWeight',distanceweight);
	[~,scores] = predict(model,Xval);
	[~,~,~,performance] = perfcurve(Yval,scores(:,2),1);
		
if performance > bestperformance


				bestperformance = performance;
				bestparameter = hyperparameter;
end
end
