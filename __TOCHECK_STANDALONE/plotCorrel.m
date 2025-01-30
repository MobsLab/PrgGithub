function [Matric,R]=plotCorrel(A,B,th,smo,siz)


%  
%  
%  load RAssemblies2701highPPC
%  list=find(pfPhHT(:,2)>1|(pfPhHT(:,2)<1&log(FiRa(:,2)./FiRa(:,3))>-0.3));
%  A=pfPhHT(list,2);B=log(FiRa(list,2)./FiRa(list,3));
%  plotCorrel(A,B,10,4);


try
siz;
catch
siz=50;
end

tsa1=tsd([1:size(A,1)],A);
tsa2=tsd([1:size(A,1)],B);


[r,p,var,Maz,Miz]=PlotCorrelationDensity(tsa1,tsa2,th,'lop',siz);
set(gcf,'position',[84 146 560 795])

figure('color',[1 1 1]), imagesc(Miz(:,:,1)), axis xy

Maz=[zeros(5,siz);Maz;zeros(5,siz)];

R=Miz(:,:,1);
R=SmoothDec(R,[smo,smo]);

MeanMaz=(mean(SmoothDec(Maz,[smo,smo])'))';

IM=MeanMaz*ones(1,siz);

if 0
figure('color',[1 1 1]), imagesc(SmoothDec(Maz,[smo/2, smo])./IM), axis xy
end
Matric=SmoothDec(Maz,[smo/2, smo])./IM;
