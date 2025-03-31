function OutMat=ZScoreWiWindow(InMat,Win)

mu=mean(InMat(:,Win),2);
sigma=std(InMat(:,Win)')';
OutMat = bsxfun(@minus,InMat, mu);
OutMat = bsxfun(@rdivide, OutMat, sigma);



end