%BilanEffectCannab

try
    structu;
catch
 structu='Pfc'
%structu='Par';
%structu='Aud';
end
try
    HighLow;
catch
    %HighLow='H';
    HighLow='L'
end

for i=1:4
    for j=1:4
    for y=1:4
    listLFPGood{i,j,y}=1:3;
    end
end
end


if 0

%listLFPGood(numStruct,numHighLow,MiceNum)=
   listLFPGood{1,1,1}=1:3; % Pfc, 'H', mice'
   listLFPGood{1,1,2}=1:3; % Pfc, 'H', mice'
   listLFPGood{1,1,3}=1:3; % Pfc, 'H', mice'
   
   listLFPGood{2,1,1}=2; % Par, 'H', mice'
   listLFPGood{2,1,2}=2; % Par, 'H', mice'
   listLFPGood{2,1,3}=1; % Par, 'H', mice'
   
   listLFPGood{1,2,1}=3; % Pfc, 'L', mice'
   listLFPGood{1,2,2}=2; % Pfc, 'L', mice'
   listLFPGood{1,2,3}=2; % Pfc, 'L', mice'
 
   listLFPGood{2,2,1}=1; % Par, 'L', mice'
   listLFPGood{2,2,2}=1; % Par, 'L', mice'
   listLFPGood{2,2,3}=2; % Par, 'L', mice'
   
end





%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetCannabinoids\Mouse052\20130122\BULB-Mouse-52-22012013  %dKO

a=1;


[M1RipPre{1,a},M2RipPre{1,a},M3RipPre{1,a},M1RipPost{1,a},M2RipPost{1,a},M3RipPost{1,a},M1SpiPre{1,a},M2SpiPre{1,a},M3SpiPre{1,a},M1SpiPost{1,a},M2SpiPost{1,a},M3SpiPost{1,a},M1PowPre{1,a},M2PowPre{1,a},M3PowPre{1,a},M1PowPost{1,a},M2PowPost{1,a},M3PowPost{1,a}]=RipPowerModulationSpi(structu,HighLow);
title('Can')
[CPrePfc{1,a},BPrePfc{1,a},CPostPfc{1,a},BPostPfc{1,a},NPre{1,a},NPost{1,a},N2Pre{1,a},N2Post{1,a}]=BilanCrossCorrSpindles(0,structu,'Hpc',HighLow);

% 
% M1RipPre{2,a}=M1RipPre{1,a};
% M2RipPre{2,a}=M2RipPre{1,a};
% M3RipPre{2,a}=M3RipPre{1,a};
% M1RipPost{2,a}=M1RipPost{1,a};
% M2RipPost{2,a}=M2RipPost{1,a};
% M3RipPost{2,a}=M3RipPost{1,a};
% M1SpiPre{2,a}=M1SpiPre{1,a};
% M2SpiPre{2,a}=M2SpiPre{1,a};
% M3SpiPre{2,a}=M3SpiPre{1,a};
% M1SpiPost{2,a}=M1SpiPost{1,a};
% M2SpiPost{2,a}=M2SpiPost{1,a};
% M3SpiPost{2,a}=M3SpiPost{1,a};
% M1PowPre{2,a}=M1PowPre{1,a};
% M2PowPre{2,a}=M2PowPre{1,a};
% M3PowPre{2,a}=M3PowPre{1,a};
% M1PowPost{2,a}=M1PowPost{1,a};
% M2PowPost{2,a}=M2PowPost{1,a};
% M3PowPost{2,a}=M3PowPost{1,a};
% 
% CPrePfc{2,a}=CPrePfc{1,a};
% BPrePfc{2,a}=BPrePfc{1,a};
% CPostPfc{2,a}=CPostPfc{1,a};
% BPostPfc{2,a}=BPostPfc{1,a};
% NPre{2,a}=NPre{1,a};
% NPost{2,a}=NPost{1,a};
% N2Pre{2,a}=N2Pre{1,a};
% N2Post{2,a}=N2Post{1,a};



cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetCannabinoids\Mouse051\20130110\BULB-Mouse-51-10012013   %wt
a=1;


[M1RipPre{2,a},M2RipPre{2,a},M3RipPre{2,a},M1RipPost{2,a},M2RipPost{2,a},M3RipPost{2,a},M1SpiPre{2,a},M2SpiPre{2,a},M3SpiPre{2,a},M1SpiPost{2,a},M2SpiPost{2,a},M3SpiPost{2,a},M1PowPre{2,a},M2PowPre{2,a},M3PowPre{2,a},M1PowPost{2,a},M2PowPost{2,a},M3PowPost{2,a}]=RipPowerModulationSpi(structu,HighLow);
title('Can')
[CPrePfc{2,a},BPrePfc{2,a},CPostPfc{2,a},BPostPfc{2,a},NPre{2,a},NPost{2,a},N2Pre{2,a},N2Post{2,a}]=BilanCrossCorrSpindles(0,structu,'Hpc',HighLow);
% 
% M1RipPre{2,a}=M1RipPre{1,a};
% M2RipPre{2,a}=M2RipPre{1,a};
% M3RipPre{2,a}=M3RipPre{1,a};
% M1RipPost{2,a}=M1RipPost{1,a};
% M2RipPost{2,a}=M2RipPost{1,a};
% M3RipPost{2,a}=M3RipPost{1,a};
% M1SpiPre{2,a}=M1SpiPre{1,a};
% M2SpiPre{2,a}=M2SpiPre{1,a};
% M3SpiPre{2,a}=M3SpiPre{1,a};
% M1SpiPost{2,a}=M1SpiPost{1,a};
% M2SpiPost{2,a}=M2SpiPost{1,a};
% M3SpiPost{2,a}=M3SpiPost{1,a};
% M1PowPre{2,a}=M1PowPre{1,a};
% M2PowPre{2,a}=M2PowPre{1,a};
% M3PowPre{2,a}=M3PowPre{1,a};
% M1PowPost{2,a}=M1PowPost{1,a};
% M2PowPost{2,a}=M2PowPost{1,a};
% M3PowPost{2,a}=M3PowPost{1,a};
% 
% CPrePfc{2,a}=CPrePfc{1,a};
% BPrePfc{2,a}=BPrePfc{1,a};
% CPostPfc{2,a}=CPostPfc{1,a};
% BPostPfc{2,a}=BPostPfc{1,a};
% NPre{2,a}=NPre{1,a};
% NPost{2,a}=NPost{1,a};
% N2Pre{2,a}=N2Pre{1,a};
% N2Post{2,a}=N2Post{1,a};



cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetCannabinoids\Mouse047\20130111\BULB-Mouse-47-11012013  %dKO
a=2;


[M1RipPre{1,a},M2RipPre{1,a},M3RipPre{1,a},M1RipPost{1,a},M2RipPost{1,a},M3RipPost{1,a},M1SpiPre{1,a},M2SpiPre{1,a},M3SpiPre{1,a},M1SpiPost{1,a},M2SpiPost{1,a},M3SpiPost{1,a},M1PowPre{1,a},M2PowPre{1,a},M3PowPre{1,a},M1PowPost{1,a},M2PowPost{1,a},M3PowPost{1,a}]=RipPowerModulationSpi(structu,HighLow);
title('Can')
[CPrePfc{1,a},BPrePfc{1,a},CPostPfc{1,a},BPostPfc{1,a},NPre{1,a},NPost{1,a},N2Pre{1,a},N2Post{1,a}]=BilanCrossCorrSpindles(0,structu,'Hpc',HighLow);


M1RipPre{2,a}=M1RipPre{2,1};
M2RipPre{2,a}=M2RipPre{2,1};
M3RipPre{2,a}=M3RipPre{2,1};
M1RipPost{2,a}=M1RipPost{2,1};
M2RipPost{2,a}=M2RipPost{2,1};
M3RipPost{2,a}=M3RipPost{2,1};
M1SpiPre{2,a}=M1SpiPre{2,1};
M2SpiPre{2,a}=M2SpiPre{2,1};
M3SpiPre{2,a}=M3SpiPre{2,1};
M1SpiPost{2,a}=M1SpiPost{2,1};
M2SpiPost{2,a}=M2SpiPost{2,1};
M3SpiPost{2,a}=M3SpiPost{2,1};
M1PowPre{2,a}=M1PowPre{2,1};
M2PowPre{2,a}=M2PowPre{2,1};
M3PowPre{2,a}=M3PowPre{2,1};
M1PowPost{2,a}=M1PowPost{2,1};
M2PowPost{2,a}=M2PowPost{2,1};
M3PowPost{2,a}=M3PowPost{2,1};

CPrePfc{2,a}=CPrePfc{2,1};
BPrePfc{2,a}=BPrePfc{2,1};
CPostPfc{2,a}=CPostPfc{2,1};
BPostPfc{2,a}=BPostPfc{2,1};
NPre{2,a}=NPre{2,1};
NPost{2,a}=NPost{2,1};
N2Pre{2,a}=N2Pre{2,1};
N2Post{2,a}=N2Post{2,1};


cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetCannabinoids\Mouse054\20130314\BULB-Mouse-54-14032013  %dKO
a=3;


[M1RipPre{1,a},M2RipPre{1,a},M3RipPre{1,a},M1RipPost{1,a},M2RipPost{1,a},M3RipPost{1,a},M1SpiPre{1,a},M2SpiPre{1,a},M3SpiPre{1,a},M1SpiPost{1,a},M2SpiPost{1,a},M3SpiPost{1,a},M1PowPre{1,a},M2PowPre{1,a},M3PowPre{1,a},M1PowPost{1,a},M2PowPost{1,a},M3PowPost{1,a}]=RipPowerModulationSpi(structu,HighLow);
title('Can')
[CPrePfc{1,a},BPrePfc{1,a},CPostPfc{1,a},BPostPfc{1,a},NPre{1,a},NPost{1,a},N2Pre{1,a},N2Post{1,a}]=BilanCrossCorrSpindles(0,structu,'Hpc',HighLow);

% M1RipPre{2,a}=M1RipPre{1,a};
% M2RipPre{2,a}=M2RipPre{1,a};
% M3RipPre{2,a}=M3RipPre{1,a};
% M1RipPost{2,a}=M1RipPost{1,a};
% M2RipPost{2,a}=M2RipPost{1,a};
% M3RipPost{2,a}=M3RipPost{1,a};
% M1SpiPre{2,a}=M1SpiPre{1,a};
% M2SpiPre{2,a}=M2SpiPre{1,a};
% M3SpiPre{2,a}=M3SpiPre{1,a};
% M1SpiPost{2,a}=M1SpiPost{1,a};
% M2SpiPost{2,a}=M2SpiPost{1,a};
% M3SpiPost{2,a}=M3SpiPost{1,a};
% M1PowPre{2,a}=M1PowPre{1,a};
% M2PowPre{2,a}=M2PowPre{1,a};
% M3PowPre{2,a}=M3PowPre{1,a};
% M1PowPost{2,a}=M1PowPost{1,a};
% M2PowPost{2,a}=M2PowPost{1,a};
% M3PowPost{2,a}=M3PowPost{1,a};
% 
% CPrePfc{2,a}=CPrePfc{1,a};
% BPrePfc{2,a}=BPrePfc{1,a};
% CPostPfc{2,a}=CPostPfc{1,a};
% BPostPfc{2,a}=BPostPfc{1,a};
% NPre{2,a}=NPre{1,a};
% NPost{2,a}=NPost{1,a};
% N2Pre{2,a}=N2Pre{1,a};
% N2Post{2,a}=N2Post{1,a};


M1RipPre{2,a}=M1RipPre{2,1};
M2RipPre{2,a}=M2RipPre{2,1};
M3RipPre{2,a}=M3RipPre{2,1};
M1RipPost{2,a}=M1RipPost{2,1};
M2RipPost{2,a}=M2RipPost{2,1};
M3RipPost{2,a}=M3RipPost{2,1};
M1SpiPre{2,a}=M1SpiPre{2,1};
M2SpiPre{2,a}=M2SpiPre{2,1};
M3SpiPre{2,a}=M3SpiPre{2,1};
M1SpiPost{2,a}=M1SpiPost{2,1};
M2SpiPost{2,a}=M2SpiPost{2,1};
M3SpiPost{2,a}=M3SpiPost{2,1};
M1PowPre{2,a}=M1PowPre{2,1};
M2PowPre{2,a}=M2PowPre{2,1};
M3PowPre{2,a}=M3PowPre{2,1};
M1PowPost{2,a}=M1PowPost{2,1};
M2PowPost{2,a}=M2PowPost{2,1};
M3PowPost{2,a}=M3PowPost{2,1};

CPrePfc{2,a}=CPrePfc{2,1};
BPrePfc{2,a}=BPrePfc{2,1};
CPostPfc{2,a}=CPostPfc{2,1};
BPostPfc{2,a}=BPostPfc{2,1};
NPre{2,a}=NPre{2,1};
NPost{2,a}=NPost{2,1};
N2Pre{2,a}=N2Pre{2,1};
N2Post{2,a}=N2Post{2,1};








%------------------------------
%Analysis
%------------------------------


if structu=='Pfc'
    numStruct=1;
elseif structu=='Par'
    numStruct=2;
elseif structu=='aud'
    numStruct=3;
end

if HighLow=='H';
    numHighLow=1;
else
    numHighLow=2;
end


params.fpass=[0 20];
params.tapers=[1,2];


if HighLow=='L';
freq=[5 10];
else
freq=[10 14];
end

clear BilanLPS
id=325:925;
%LPS
it=1;
figure('color',[1 1 1]), 
subplot(3,1,1),hold on,title('Post')
for i=1:4
    if ismember(1,listLFPGood{numStruct,numHighLow,i})
try
val1=M1PowPre{2,i};
params.Fs=1/median(diff(val1(:,1)));
% [S1,f1]=mtspectrumc(zscore(val1(id,2)),params);
[S1,f1]=mtspectrumc((val1(id,2)-mean(val1(id,2))),params);
plot(f1,S1,'k')
BilanLPS(it,1)=mean(S1(find(f1>freq(1)&f1<freq(2))));
end
try
    val2=M1PowPost{2,i};
params.Fs=1/median(diff(val2(:,1)));
% [S2,f2]=mtspectrumc(zscore(val2(id,2)),params);
[S2,f2]=mtspectrumc((val2(id,2)-mean(val2(id,2))),params);
plot(f2,S2,'r')
BilanLPS(it,2)=mean(S2(find(f2>freq(1)&f2<freq(2))));
end
it=it+1;
end
end

subplot(3,1,2),hold on
for i=1:4
        if ismember(2,listLFPGood{numStruct,numHighLow,i})
            try
val1=M2PowPre{2,i};
params.Fs=1/median(diff(val1(:,1)));
% [S1,f1]=mtspectrumc(zscore(val1(id,2)),params);
[S1,f1]=mtspectrumc((val1(id,2)-mean(val1(id,2))),params);
plot(f1,S1,'k')
BilanLPS(it,1)=mean(S1(find(f1>freq(1)&f1<freq(2))));
catch
BilanLPS(it,1)=nan;     
end
try
val2=M2PowPost{2,i};
params.Fs=1/median(diff(val2(:,1)));
% [S2,f2]=mtspectrumc(zscore(val2(id,2)),params);
[S2,f2]=mtspectrumc((val2(id,2)-mean(val2(id,2))),params);
plot(f2,S2,'r')
BilanLPS(it,2)=mean(S2(find(f2>freq(1)&f2<freq(2))));
end
    it=it+1;
        end
end

subplot(3,1,3),hold on
for i=1:4
    if ismember(3,listLFPGood{numStruct,numHighLow,i})
    try
val1=M3PowPre{2,i};
params.Fs=1/median(diff(val1(:,1)));
% [S1,f1]=mtspectrumc(zscore(val1(id,2)),params);
[S1,f1]=mtspectrumc((val1(id,2)-mean(val1(id,2))),params);
  plot(f1,S1,'k')
  BilanLPS(it,1)=mean(S1(find(f1>freq(1)&f1<freq(2))));
    end
    try
        
val2=M3PowPost{2,i};
params.Fs=1/median(diff(val2(:,1)));
% [S2,f2]=mtspectrumc(zscore(val2(id,2)),params);
[S2,f2]=mtspectrumc((val2(id,2)-mean(val2(id,2))),params);
plot(f2,S2,'r')
BilanLPS(it,2)=mean(S2(find(f2>freq(1)&f2<freq(2))));
    end
    it=it+1;
    end
end



%control

it=1;
figure('color',[1 1 1]), 
subplot(3,1,1),hold on,title('Pre')
for i=1:4
        if ismember(1,listLFPGood{numStruct,numHighLow,i})
try
val1=M1PowPre{1,i};
params.Fs=1/median(diff(val1(:,1)));
% [S1,f1]=mtspectrumc(zscore(val1(id,2)),params);
[S1,f1]=mtspectrumc((val1(id,2)-mean(val1(id,2))),params);
plot(f1,S1,'k')
BilanCtrl(it,1)=mean(S1(find(f1>freq(1)&f1<freq(2))));

end
try
    val2=M1PowPost{1,i};
params.Fs=1/median(diff(val2(:,1)));
% [S2,f2]=mtspectrumc(zscore(val2(id,2)),params);
[S2,f2]=mtspectrumc((val2(id,2)-mean(val2(id,2))),params);
plot(f2,S2,'r')
BilanCtrl(it,2)=mean(S2(find(f2>freq(1)&f2<14)));

end
it=it+1;
        end
end

clear val1
clear val2

subplot(3,1,2),hold on
for i=1:4
        if ismember(2,listLFPGood{numStruct,numHighLow,i})
    try
val1=M2PowPre{1,i};
params.Fs=1/median(diff(val1(:,1)));
% [S1,f1]=mtspectrumc(zscore(val1(id,2)),params);
[S1,f1]=mtspectrumc((val1(id,2)-mean(val1(id,2))),params);
plot(f1,S1,'k')
BilanCtrl(i,1)=mean(S1(find(f1>freq(1)&f1<freq(2))));
    end
    try
val2=M2PowPost{1,i};
params.Fs=1/median(diff(val2(:,1)));
% [S2,f2]=mtspectrumc(zscore(val2(id,2)),params);
[S2,f2]=mtspectrumc((val2(id,2)-mean(val2(id,2))),params);
plot(f2,S2,'r')
BilanCtrl(i,2)=mean(S2(find(f2>freq(1)&f2<freq(2))));
    end
    it=it+1;
        end
end

clear val1
clear val2

subplot(3,1,3),hold on
for i=1:4
        if ismember(3,listLFPGood{numStruct,numHighLow,i})
    try
val1=M3PowPre{1,i};
params.Fs=1/median(diff(val1(:,1)));
% [S1,f1]=mtspectrumc(zscore(val1(id,2)),params);
[S1,f1]=mtspectrumc((val1(id,2)-mean(val1(id,2))),params);
  plot(f1,S1,'k')
  BilanCtrl(i,1)=mean(S1(find(f1>freq(1)&f1<freq(2))));
    end
    try
        
val2=M3PowPost{1,i};
params.Fs=1/median(diff(val2(:,1)));
% [S2,f2]=mtspectrumc(zscore(val2(id,2)),params);
[S2,f2]=mtspectrumc((val2(id,2)-mean(val2(id,2))),params);
plot(f2,S2,'r')
BilanCtrl(i,2)=mean(S2(find(f2>freq(1)&f2<freq(2))));
    end
it=it+1;
        end
end

PlotErrorBar4(BilanCtrl(:,1),BilanCtrl(:,2),BilanLPS(:,1),BilanLPS(:,2))
title(['Modulation of Hpc Ripples Power by ',structu,' Spindles'])
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})

[p,t,st,Pt,group]=CalculANOVA(BilanCtrl(:,1),BilanCtrl(:,2),BilanLPS(:,1),BilanLPS(:,2));
p12=Pt(1);
p34=Pt(2);
p13=Pt(3);
p24=Pt(4);
p14=Pt(5);
p23=Pt(6);
title(['Modulation of Hpc Ripples Power by ',structu,' Spindles, p12 ',num2str(floor(p12*100)/100),', p34 ',num2str(floor(p34*100)/100),', p13 ',num2str(floor(p13*100)/100),', p24 ',num2str(floor(p13*100)/100),', p14 ',num2str(floor(p14*100)/100),', p23 ',num2str(floor(p23*100)/100)])
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})


clear BilanCrossCtrl
clear BilanCrossLPS
clear NumEventsStruct1Ctrl
clear NumEventsStruct1LPS
clear NumEventsStruct2Ctrl
clear NumEventsStruct2LPS


smo=3;
for i=1:4
for j=1:4    
for k=1:4        
for l=1:4
    try
    CPrePfc{i,j}{k,l}=smooth(CPrePfc{i,j}{k,l},smo);
    CPostPfc{i,j}{k,l}=smooth(CPostPfc{i,j}{k,l},smo);
    end
end
end
end
end


lim=0.5;
%1 Pfc
%2 Par
it=1;
for i=1:4
 b=3;
    for a=listLFPGood{numStruct,numHighLow,i}
        try
idbef=find(BPrePfc{1,i}{a,b}>-lim*1E3&BPrePfc{1,i}{a,b}<0);
idaft=find(BPrePfc{1,i}{a,b}>0&BPrePfc{1,i}{a,b}<lim*1E3);
BilanCrossCtrl(it,1)=nanmean(CPrePfc{1,i}{a,b}(idbef,:)-CPrePfc{1,i}{a,b}(idaft,:));
BilanCrossCtrl(it,2)=nanmean(CPostPfc{1,i}{a,b}(idbef,:)-CPostPfc{1,i}{a,b}(idaft,:));

idbef=find(BPostPfc{2,i}{a,b}>-lim*1E3&BPostPfc{2,i}{a,b}<0);
idaft=find(BPostPfc{2,i}{a,b}>0&BPostPfc{2,i}{a,b}<lim*1E3);
BilanCrossLPS(it,1)=nanmean(CPrePfc{2,i}{a,b}(idbef,:)-CPrePfc{2,i}{a,b}(idaft,:));
BilanCrossLPS(it,2)=nanmean(CPostPfc{2,i}{a,b}(idbef,:)-CPostPfc{2,i}{a,b}(idaft,:));

NumEventsStruct1Ctrl(it,1)=NPre{1,i}{a};
NumEventsStruct1Ctrl(it,2)=NPost{1,i}{a};
NumEventsStruct1LPS(it,1)=NPre{2,i}{a};
NumEventsStruct1LPS(it,2)=NPost{2,i}{a};

NumEventsStruct2Ctrl(it,1)=N2Pre{1,i}{a};
NumEventsStruct2Ctrl(it,2)=N2Post{1,i}{a};
NumEventsStruct2LPS(it,1)=N2Pre{2,i}{a};
NumEventsStruct2LPS(it,2)=N2Post{2,i}{a};

it=it+1;

%         end
    end
    end
end

PlotErrorBar4(NumEventsStruct1Ctrl(:,1),NumEventsStruct1Ctrl(:,2),NumEventsStruct1LPS(:,1),NumEventsStruct1LPS(:,2))
title(['Frequency of Spindles in ',structu])
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})

[p,t,st,Pt,group]=CalculANOVA(NumEventsStruct1Ctrl(:,1),NumEventsStruct1Ctrl(:,2),NumEventsStruct1LPS(:,1),NumEventsStruct1LPS(:,2));
p12=Pt(1);
p34=Pt(2);
p13=Pt(3);
p24=Pt(4);
p14=Pt(5);
p23=Pt(6);
title(['Frequency of Spindles in ',structu,', p12 ',num2str(floor(p12*100)/100),', p34 ',num2str(floor(p34*100)/100),', p13 ',num2str(floor(p13*100)/100),', p24 ',num2str(floor(p13*100)/100),', p14 ',num2str(floor(p14*100)/100),', p23 ',num2str(floor(p23*100)/100)])
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})


PlotErrorBar4(NumEventsStruct2Ctrl(:,1),NumEventsStruct2Ctrl(:,2),NumEventsStruct2LPS(:,1),NumEventsStruct2LPS(:,2))
title(['Frequency of Ripples'])
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})

[p,t,st,Pt,group]=CalculANOVA(NumEventsStruct2Ctrl(:,1),NumEventsStruct2Ctrl(:,2),NumEventsStruct2LPS(:,1),NumEventsStruct2LPS(:,2));
p12=Pt(1);
p34=Pt(2);
p13=Pt(3);
p24=Pt(4);
p14=Pt(5);
p23=Pt(6);
title(['Frequency of Ripples, p12 ',num2str(floor(p12*100)/100),', p34 ',num2str(floor(p34*100)/100),', p13 ',num2str(floor(p13*100)/100),', p24 ',num2str(floor(p13*100)/100),', p14 ',num2str(floor(p14*100)/100),', p23 ',num2str(floor(p23*100)/100)])
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})


PlotErrorBar4(BilanCrossCtrl(:,1),BilanCrossCtrl(:,2),BilanCrossLPS(:,1),BilanCrossLPS(:,2))
title(['Modulation of Hpc Ripples Occurence by ',structu,' Spindles'])
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})

[p,t,st,Pt,group]=CalculANOVA(BilanCrossCtrl(:,1),BilanCrossCtrl(:,2),BilanCrossLPS(:,1),BilanCrossLPS(:,2));
p12=Pt(1);
p34=Pt(2);
p13=Pt(3);
p24=Pt(4);
p14=Pt(5);
p23=Pt(6);
title(['Modulation of Hpc Ripples Occurence by ',structu,' Spindles, p12 ',num2str(floor(p12*100)/100),', p34 ',num2str(floor(p34*100)/100),', p13 ',num2str(floor(p13*100)/100),', p24 ',num2str(floor(p13*100)/100),', p14 ',num2str(floor(p14*100)/100),', p23 ',num2str(floor(p23*100)/100)])
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})






BCtrl=BilanCrossCtrl;
id1=find(isnan(BilanCrossCtrl(:,1)));
id2=find(isnan(BilanCrossCtrl(:,2)));
BCtrl(id1,:)=[];
id2=find(isnan(BCtrl(:,2)));
BCtrl(id2,:)=[];

BLPS=BilanCrossLPS;
id1=find(isnan(BilanCrossLPS(:,1)));
id2=find(isnan(BilanCrossLPS(:,2)));
BLPS(id1,:)=[];
id2=find(isnan(BLPS(:,2)));
BLPS(id2,:)=[];
PlotErrorBar4(BCtrl(:,1),BCtrl(:,2),BLPS(:,1),BLPS(:,2))
title(['Modulation of Hpc Ripples Occurence by ',structu,' Spindles (Normalized)'])
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})


BCtrl1=BilanCrossCtrl;
BCtrl1(BCtrl1<0)=nan;
BLPS1=BilanCrossLPS;
BLPS1(BLPS1<0)=nan;
PlotErrorBar4(BCtrl1(:,1),BCtrl1(:,2),BLPS1(:,1),BLPS1(:,2))
title(['Modulation of Hpc Ripples Occurence by ',structu,' Spindles (Corrected)'])
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})

[p,t,st,Pt,group]=CalculANOVA(BCtrl1(:,1),BCtrl1(:,2),BLPS1(:,1),BLPS1(:,2));
p12=Pt(1);
p34=Pt(2);
p13=Pt(3);
p24=Pt(4);
p14=Pt(5);
p23=Pt(6);
title(['Modulation of Hpc Ripples Occurence by ',structu,' Spindles, p12 ',num2str(floor(p12*100)/100),', p34 ',num2str(floor(p34*100)/100),', p13 ',num2str(floor(p13*100)/100),', p24 ',num2str(floor(p13*100)/100),', p14 ',num2str(floor(p14*100)/100),', p23 ',num2str(floor(p23*100)/100)])
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})




% PlotErrorBar4(M1RipPre{1,1}(:,4),M1RipPost{1,1}(:,4),nan,M1RipPost{2,1}(:,4))
% PlotErrorBar4(M1RipPre{1,2}(:,4),M1RipPost{1,2}(:,4),M1RipPre{2,2}(:,4),M1RipPost{2,2}(:,4))
% PlotErrorBar4(M1RipPre{1,3}(:,4),M1RipPost{1,3}(:,4),M1RipPre{2,3}(:,4),M1RipPost{2,3}(:,4))

idripp=96:106;
for i=1:4
    try
MeanRipCtrl(i,1)=max(M1RipPre{1,i}(idripp,2))-min(M1RipPre{1,i}(idripp,2));
    catch
 MeanRipCtrl(i,1)=nan;       
    end
try
    MeanRipCtrl(i,2)=max(M1RipPost{1,i}(idripp,2))-min(M1RipPost{1,i}(idripp,2));
catch
    MeanRipCtrl(i,2)=nan;
end
try
MeanRipLPS(i,1)=max(M1RipPre{2,i}(idripp,2))-min(M1RipPre{2,i}(idripp,2));
catch
    MeanRipLPS(i,1)=nan; 
end
MeanRipLPS(i,2)=max(M1RipPost{2,i}(idripp,2))-min(M1RipPost{2,i}(idripp,2));
end
PlotErrorBar4(MeanRipCtrl(:,1),MeanRipCtrl(:,2),MeanRipLPS(:,1),MeanRipLPS(:,2))
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})
title('Amplitude Ripples')


% MeanSpi1Ctrl(i,1)
% test=M1SpiPre{1,1}{listLFPGood{numStruct,numHighLow,1}}(id,2));
% max(test)-min(test);

limstd=1.5;
idSPii=400:800;
it=1;
for i=1:4
    for j=1:length(listLFPGood{numStruct,numHighLow,i})
if ismember(1,listLFPGood{numStruct,numHighLow,i})
    
                clear temp
                try
                    temp=(M1SpiPre{1,i}{listLFPGood{numStruct,numHighLow,i}(j)}(idSPii,:));
                    if max(temp(:,3))<max(temp(:,2))*limstd;
                    MeanSpi1Ctrl(it,1)=max(temp(:,2))-min(temp(:,2));
                    else
                    MeanSpi1Ctrl(it,1)=nan;    
                    end
                catch
                MeanSpi1Ctrl(it,1)=nan;        
                end
                
                clear temp
                try
                    temp=(M1SpiPost{1,i}{listLFPGood{numStruct,numHighLow,i}(j)}(idSPii,:));
                    if max(temp(:,3))<max(temp(:,2))*limstd;
                    MeanSpi1Ctrl(it,2)=max(temp(:,2))-min(temp(:,2));
                    else
                    MeanSpi1Ctrl(it,2)=nan;    
                    end
                catch
                MeanSpi1Ctrl(it,2)=nan;   
                end
                
                clear temp
                try
                    temp=(M1SpiPre{2,i}{listLFPGood{numStruct,numHighLow,i}(j)}(idSPii,:));
                    if max(temp(:,3))<max(temp(:,2))*limstd;
                    MeanSpi1LPS(it,1)=max(temp(:,2))-min(temp(:,2));
                    else
                     MeanSpi1LPS(it,1)=nan;   
                    end
                catch
                MeanSpi1LPS(it,1)=nan;    
                end
                
                clear temp
                try
                    temp=(M1SpiPost{2,i}{listLFPGood{numStruct,numHighLow,i}(j)}(idSPii,:));
                    if max(temp(:,3))<max(temp(:,2))*limstd;
                    MeanSpi1LPS(it,2)=max(temp(:,2))-min(temp(:,2));
                    else
                    MeanSpi1LPS(it,2)=nan; 
                    end
                catch
                MeanSpi1LPS(it,2)=nan;    
                end
                clear temp
                it=it+1;
                
elseif ismember(2,listLFPGood{numStruct,numHighLow,i})
                clear temp
                try   
                    temp=(M2SpiPre{1,i}{listLFPGood{numStruct,numHighLow,i}(j)}(idSPii,:));
                    if max(temp(:,3))<max(temp(:,2))*limstd;
                    MeanSpi1Ctrl(it,1)=max(temp(:,2))-min(temp(:,2));
                    else
                    MeanSpi1Ctrl(it,1)=nan;    
                    end
                catch
                MeanSpi1Ctrl(it,1)=nan;        
                end
                
                clear temp
                try
                    temp=(M2SpiPost{1,i}{listLFPGood{numStruct,numHighLow,i}(j)}(idSPii,:));
                    if max(temp(:,3))<max(temp(:,2))*limstd;
                    MeanSpi1Ctrl(it,2)=max(temp(:,2))-min(temp(:,2));
                    else
                    MeanSpi1Ctrl(it,2)=nan;
                    end
                    
                catch
                MeanSpi1Ctrl(it,2)=nan;   
                end
                
                clear temp
                try
                    temp=(M2SpiPre{2,i}{listLFPGood{numStruct,numHighLow,i}(j)}(idSPii,:));
                    if max(temp(:,3))<max(temp(:,2))*limstd;
                    MeanSpi1LPS(it,1)=max(temp(:,2))-min(temp(:,2));
                    else
                    MeanSpi1LPS(it,1)=nan;
                    end
                     
                catch
                MeanSpi1LPS(it,1)=nan;    
                end
                
                clear temp
                try
                    temp=(M2SpiPost{2,i}{listLFPGood{numStruct,numHighLow,i}(j)}(idSPii,:));
                    if max(temp(:,3))<max(temp(:,2))*limstd;
                    MeanSpi1LPS(it,2)=max(temp(:,2))-min(temp(:,2));
                    else
                    MeanSpi1LPS(it,2)=nan; 
                    end
                catch
                MeanSpi1LPS(it,2)=nan;     
                end
                clear temp
                it=it+1;

elseif ismember(3,listLFPGood{numStruct,numHighLow,i})
                clear temp
                try 
                    temp=(M3SpiPre{1,i}{listLFPGood{numStruct,numHighLow,i}(j)}(idSPii,:));
                    if max(temp(:,3))<max(temp(:,2))*limstd;
                    MeanSpi1Ctrl(it,1)=max(temp(:,2))-min(temp(:,2));
                    else
                    MeanSpi1Ctrl(it,1)=nan;     
                    end
                catch
                MeanSpi1Ctrl(it,1)=nan;        
                end
                
                clear temp
                try
                    temp=(M3SpiPost{1,i}{listLFPGood{numStruct,numHighLow,i}(j)}(idSPii,:));
                    if max(temp(:,3))<max(temp(:,2))*limstd;
                    MeanSpi1Ctrl(it,2)=max(temp(:,2))-min(temp(:,2));
                    else
                    MeanSpi1Ctrl(it,2)=nan;     
                    end
                catch
                 MeanSpi1Ctrl(it,2)=nan;   
                end
                
                clear temp
                try
                    temp=(M3SpiPre{2,i}{listLFPGood{numStruct,numHighLow,i}(j)}(idSPii,:));
                    if max(temp(:,3))<max(temp(:,2))*limstd;
                    MeanSpi1LPS(it,1)=max(temp(:,2))-min(temp(:,2));
                    else
                    MeanSpi1LPS(it,1)=nan;     
                    end
                catch
                MeanSpi1LPS(it,1)=nan;    
                end
                
                clear temp
                try
                    temp=(M3SpiPost{2,i}{listLFPGood{numStruct,numHighLow,i}(j)}(idSPii,:));
                    if max(temp(:,3))<max(temp(:,2))*limstd;
                    MeanSpi1LPS(it,2)=max(temp(:,2))-min(temp(:,2));
                    else
                    MeanSpi1LPS(it,2)=nan;  
                    end
                catch
                MeanSpi1LPS(it,2)=nan;    
                end
                
                it=it+1;
                clear temp
end
    end
end

PlotErrorBar4(MeanSpi1Ctrl(:,1),MeanSpi1Ctrl(:,2),MeanSpi1LPS(:,1),MeanSpi1LPS(:,2))
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})
title(['Amplitude Spindles ',structu])

PlotErrorBar4(MeanSpi1Ctrl(:,1)./MeanSpi1Ctrl(:,1),MeanSpi1Ctrl(:,2)./MeanSpi1Ctrl(:,1),MeanSpi1LPS(:,1)./MeanSpi1Ctrl(:,1),MeanSpi1LPS(:,2)./MeanSpi1Ctrl(:,1))
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})
title(['Amplitude Spindles ',structu])

MeanSpi1Ctrl

MeanSpi1LPS

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


cd \\NASDELUXE\DataMOBs\ProjetLPS

if 0
if structu=='Pfc'& HighLow=='L';
        save DataNoelliaCrossCorr1 % 
    elseif structu=='Par'& HighLow=='L';
    save DataNoelliaCrossCorr2 % structu='Par';, HighLow='L';
    elseif structu=='Pfc'& HighLow=='H';
    save DataNoelliaCrossCorr3 % struct='Pfc';, HighLow='H';
    elseif structu=='Par'& HighLow=='H';
    save DataNoelliaCrossCorr4 % structu='Par';, HighLow='H';
    elseif structu=='Aud'& HighLow=='L';
    save DataNoelliaCrossCorr5 % structu='Par';, HighLow='H';
    elseif structu=='Aud'& HighLow=='H';
    save DataNoelliaCrossCorr6 % structu='Par';, HighLow='H';
end
end


% 
% it=1;
% for i=1:3
% for a=1:3
%     for b=1:3
% idbef=find(BPrePar{1,i}{a,b}>-1E3&BPrePar{1,i}{a,b}<0);
% idaft=find(BPrePar{1,i}{a,b}>0&BPrePar{1,i}{a,b}<1E3);
% BilanCrossCtrlPar(it,1)=nanmean(CPrePar{1,i}{a,b}(idbef,:));
% BilanCrossLPSPar(it,1)=nanmean(CPrePar{1,i}{a,b}(idaft,:));
% 
% idbef=find(BPostPar{1,i}{a,b}>-1E3&BPostPar{1,i}{a,b}<0);
% idaft=find(BPostPar{1,i}{a,b}>0&BPostPar{1,i}{a,b}<1E3);
% BilanCrossCtrlPar(it,2)=nanmean(CPostPar{1,i}{a,b}(idbef,:));
% BilanCrossLPSPar(it,2)=nanmean(CPostPar{1,i}{a,b}(idaft,:));
%    it=it+1;
%     end
% end
% end
% 
% PlotErrorBar4(BilanCrossCtrlPar(:,1),BilanCrossCtrlPar(:,2),BilanCrossLPSPar(:,1),BilanCrossLPSPar(:,2))
% title('Modulation of Hpc Ripples Occurence by Par Spindles')
% set(gca,'xtick',[1:4])
% set(gca,'xticklabel',{'Veh Pre','LPS Pre','Veh Post','LPS Post'})
