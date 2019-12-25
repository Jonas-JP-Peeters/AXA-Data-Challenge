function AUC = NN(XT,yT,Xt,yt,dst,dstwgt,num)
nn_model = fitcknn(XT,yT,'Distance',dst,'DistanceWeight',dstwgt,'NumNeighbors',num);
[~,scores] = predict(nn_model,Xt);
[~,~,~,AUC] = perfcurve(yt,scores(:,2),1);
end

