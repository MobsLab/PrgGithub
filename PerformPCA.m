function [EigVect,EigVals]=PerformPCA(DatMat)

%% EigVect(:,n) gives nth eigenvector
% To plot projection: plot(EigVect(:,1)'*DatMat)

% Calculate covariance matrix
Cov=DatMat*transpose(DatMat);

% Diagonalize covariance matrix
[EigVect,E] = eig(Cov);
EigVect=fliplr(EigVect);
diagvals=[1:length(Cov)];
EigVals=fliplr(E([(diagvals-1)*length(Cov)+diagvals]));

end