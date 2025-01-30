function [RocVal,alpha,beta] = SimpleROCanalysis(data,output)
% Do the ROC analysis 
alpha=[];
beta=[];
minval=min([data]);
maxval=max([data]);

delval=(maxval-minval)/20;
ValsToTest= prctile(data,[1:5:99]);

data1 = data(output>0);
data0 = data(output<1);

for z = ValsToTest
    alpha=[alpha,sum(data0>z)/length(data0)];
    beta=[beta,sum(data1>z)/length(data1)];
end

RocVal=sum(beta-alpha)/length(beta)+0.5;

end