%% Data set for testing past entropy
cd /media/DISK_1/Dropbox/Kteam/PrgMatlab/MuTE_onlineVersion/exampleToolbox/TestRandData
clear data temp
% tps=[2:2:2000];
% data(1,:)=sin(tps);
% data(2,:)=sin(tps)+0.01*rand(1,1000);
% data(3,:)=sin(tps)+0.5*rand(1,1000);
% data(4,:)=sin(tps)+rand(1,1000);
% data(5,:)=sin(tps)+2*rand(1,1000);
data(1,:)=rand(1,1000);
data(2,:)=smooth(rand(1,1000),4);
data(3,:)=smooth(rand(1,1000),10);
Rvals=[3.4,3.6,3.7,3.8,3.9];
for r=1:5
temp(1,1)=0.1;
for k=2:1500
    temp(k)=Rvals(r)*(1-temp(k-1))*temp(k-1);
end
data(3+r,:)=temp(end-999:end);
end
for r=1:5
temp(1,1)=0.1;
for k=2:1500
    temp(k)=Rvals(r)*(1-temp(k-1))*temp(k-1)+(0.5-rand)*0.02;
end
data(8+r,:)=temp(end-999:end);
end
for r=1:5
temp(1,1)=0.1;
for k=2:1500
    temp(k)=Rvals(r)*(1-temp(k-1))*temp(k-1)+(0.5-rand)*0.04;
end
data(13+r,:)=temp(end-999:end);
end
data=zscore(data')';
save('Data1.mat','data')

%%
clear output
QuantLevels=[10];
TempOrder=[10,20];
for q=1:length(QuantLevels)
    for t=1:length(TempOrder)
output{t,q}=MainBinueSelfEntropy(size(data,1),'/media/DISK_1/Dropbox/Kteam/PrgMatlab/MuTE_onlineVersion/exampleToolbox/TestRandData/',QuantLevels(q),TempOrder(t));
    end
end



clf
hold on
for r=2.5:0.005:3.9
data(6,1)=0.1;
for k=2:1000
data(6,k)=r*(1-data(6,k-1))*data(6,k-1);
end
plot(r*ones(1,500),data(6,501:end),'.')
end