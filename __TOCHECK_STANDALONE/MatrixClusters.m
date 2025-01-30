function MatrixClusters(S,listNeurones,opt)

try 
    opt;
catch
    opt=1;
end

a=0;
a=a+1;coul(a)='r';
a=a+1;coul(a)='b';
a=a+1;coul(a)='g';
a=a+1;coul(a)='m';
a=a+1;coul(a)='c';
a=a+1;coul(a)='y';
a=a+1;coul(a)='r';
a=a+1;coul(a)='b';
a=a+1;coul(a)='g';
a=a+1;coul(a)='m';
a=a+1;coul(a)='c';
a=a+1;coul(a)='y';

if opt==1
    a=1;b=60;fac=30;
else
    a=10;b=100;fac=500;
end

figure('color',[1 1 1])

for i=1:length(listNeurones)

for j=i:length(listNeurones)
    
[C,B]=CrossCorr(Range(S{listNeurones(i)}),Range(S{listNeurones(j)}),a,b);
if i==j
    C(B==0)=0;
    subplot(length(listNeurones),length(listNeurones),MatXY(i,j,length(listNeurones))), bar(B,C,1,coul(i),'edgeColor',coul(i)), xlim([-fac fac])
else
    subplot(length(listNeurones),length(listNeurones),MatXY(i,j,length(listNeurones))), bar(B,C,1,'k'), xlim([-fac fac])
end
clear B
clear C

end

end



