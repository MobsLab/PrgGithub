%PlotBilanRipPowerModulationSpi

structu
HighLow

if 0
  listLFPGood{1,1,1}=3; %[1]; % Pfc, 'H', mice'
   listLFPGood{1,1,2}=2; %[2]; % Pfc, 'H', mice'
   listLFPGood{1,1,3}=1; %[1]; % Pfc, 'H', mice'
   
   listLFPGood{2,1,1}=1; %2 % Par, 'H', mice'
   listLFPGood{2,1,2}=1; %3 % Par, 'H', mice'
   listLFPGood{2,1,3}=1:3; %2 % Par, 'H', mice'
   
   listLFPGood{1,2,1}=1:3; % Pfc, 'L', mice'
   listLFPGood{1,2,2}=[1:2]; % Pfc, 'L', mice'
   listLFPGood{1,2,3}=3; % Pfc, 'L', mice'
 
   listLFPGood{2,2,1}=0; % Par, 'L', mice'
   listLFPGood{2,2,2}=1:3; % Par, 'L', mice'
   listLFPGood{2,2,3}=1; % Par, 'L', mice'
end


if 1
   listLFPGood{1,2,1}=[1:2]; % Pfc, 'L', mice'
   listLFPGood{1,2,2}=[1:2]; % Pfc, 'L', mice'
   listLFPGood{1,2,3}=[1:2]; % Pfc, 'L', mice'
  
end


%------------------------------
%Analysis
%------------------------------

params.fpass=[0 20];
params.tapers=[1,2];


if HighLow=='L';
freq=[5 10];
else
freq=[10 14];
end

clear BilanCtrl
clear BilanLPS
id=325:925;

%LPS
it=1;
figure('color',[1 1 1]), 
subplot(3,1,1),hold on,title('Post')
for i=1:3
    if ismember(1,listLFPGood{numStruct,numHighLow,i})
try
val1=M1PowPre{2,i};
params.Fs=1/median(diff(val1(:,1)));
[S1,f1]=mtspectrumc(zscore(val1(id,2)),params);
% [S1,f1]=mtspectrumc((val1(id,2)-mean(val1(id,2))),params);
plot(f1,S1,'k')
BilanLPS(it,1)=mean(S1(find(f1>freq(1)&f1<freq(2))));
end
try
    val2=M1PowPost{2,i};
params.Fs=1/median(diff(val2(:,1)));
[S2,f2]=mtspectrumc(zscore(val2(id,2)),params);
% [S2,f2]=mtspectrumc((val2(id,2)-mean(val2(id,2))),params);
plot(f2,S2,'r')
BilanLPS(it,2)=mean(S2(find(f2>freq(1)&f2<freq(2))));
end
it=it+1;
end
end

subplot(3,1,2),hold on
for i=1:3
        if ismember(2,listLFPGood{numStruct,numHighLow,i})
            try
val1=M2PowPre{2,i};
params.Fs=1/median(diff(val1(:,1)));
[S1,f1]=mtspectrumc(zscore(val1(id,2)),params);
% [S1,f1]=mtspectrumc((val1(id,2)-mean(val1(id,2))),params);
plot(f1,S1,'k')
BilanLPS(it,1)=mean(S1(find(f1>freq(1)&f1<freq(2))));
catch
BilanLPS(it,1)=nan;     
end
try
val2=M2PowPost{2,i};
params.Fs=1/median(diff(val2(:,1)));
[S2,f2]=mtspectrumc(zscore(val2(id,2)),params);
% [S2,f2]=mtspectrumc((val2(id,2)-mean(val2(id,2))),params);
plot(f2,S2,'r')
BilanLPS(it,2)=mean(S2(find(f2>freq(1)&f2<freq(2))));
end
    it=it+1;
        end
end

subplot(3,1,3),hold on
for i=1:3
    if ismember(3,listLFPGood{numStruct,numHighLow,i})
    try
val1=M3PowPre{2,i};
params.Fs=1/median(diff(val1(:,1)));
[S1,f1]=mtspectrumc(zscore(val1(id,2)),params);
% [S1,f1]=mtspectrumc((val1(id,2)-mean(val1(id,2))),params);
  plot(f1,S1,'k')
  BilanLPS(it,1)=mean(S1(find(f1>freq(1)&f1<freq(2))));
    end
    try
        
val2=M3PowPost{2,i};
params.Fs=1/median(diff(val2(:,1)));
[S2,f2]=mtspectrumc(zscore(val2(id,2)),params);
% [S2,f2]=mtspectrumc((val2(id,2)-mean(val2(id,2))),params);
plot(f2,S2,'r')
BilanLPS(it,2)=mean(S2(find(f2>freq(1)&f2<freq(2))));
    end
    it=it+1;
    end
end

BilanLPS(BilanLPS==0)=nan;

%control

it=1;
figure('color',[1 1 1]), 
subplot(3,1,1),hold on,title('Pre')
for i=1:3
        if ismember(1,listLFPGood{numStruct,numHighLow,i})
try
val1=M1PowPre{1,i};
params.Fs=1/median(diff(val1(:,1)));
[S1,f1]=mtspectrumc(zscore(val1(id,2)),params);
% [S1,f1]=mtspectrumc((val1(id,2)-mean(val1(id,2))),params);
plot(f1,S1,'k')
BilanCtrl(it,1)=mean(S1(find(f1>freq(1)&f1<freq(2))));

end
try
    val2=M1PowPost{1,i};
params.Fs=1/median(diff(val2(:,1)));
[S2,f2]=mtspectrumc(zscore(val2(id,2)),params);
% [S2,f2]=mtspectrumc((val2(id,2)-mean(val2(id,2))),params);
plot(f2,S2,'r')
BilanCtrl(it,2)=mean(S2(find(f2>freq(1)&f2<freq(2))));

end
it=it+1;
        end
end

clear val1
clear val2

subplot(3,1,2),hold on
for i=1:3
        if ismember(2,listLFPGood{numStruct,numHighLow,i})
    try
val1=M2PowPre{1,i};
params.Fs=1/median(diff(val1(:,1)));
[S1,f1]=mtspectrumc(zscore(val1(id,2)),params);
% [S1,f1]=mtspectrumc((val1(id,2)-mean(val1(id,2))),params);
plot(f1,S1,'k')
BilanCtrl(it,1)=mean(S1(find(f1>freq(1)&f1<freq(2))));
    end
    try
val2=M2PowPost{1,i};
params.Fs=1/median(diff(val2(:,1)));
[S2,f2]=mtspectrumc(zscore(val2(id,2)),params);
% [S2,f2]=mtspectrumc((val2(id,2)-mean(val2(id,2))),params);
plot(f2,S2,'r')
BilanCtrl(it,2)=mean(S2(find(f2>freq(1)&f2<freq(2))));
    end
    it=it+1;
        end
end

clear val1
clear val2

subplot(3,1,3),hold on
for i=1:3
        if ismember(3,listLFPGood{numStruct,numHighLow,i})
    try
    val1=M3PowPre{1,i};
    params.Fs=1/median(diff(val1(:,1)));
    [S1,f1]=mtspectrumc(zscore(val1(id,2)),params);
%     [S1,f1]=mtspectrumc((val1(id,2)-mean(val1(id,2))),params);
    plot(f1,S1,'k')
    BilanCtrl(it,1)=mean(S1(find(f1>freq(1)&f1<freq(2))));
    end
    
    try
    val2=M3PowPost{1,i};
    params.Fs=1/median(diff(val2(:,1)));
    [S2,f2]=mtspectrumc(zscore(val2(id,2)),params);
%     [S2,f2]=mtspectrumc((val2(id,2)-mean(val2(id,2))),params);
    plot(f2,S2,'r')
    BilanCtrl(it,2)=mean(S2(find(f2>freq(1)&f2<freq(2))));
    end
    
    it=it+1;
    
        end
end

BilanCtrl(BilanCtrl==0)=nan;

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
title(['Modulation of Hpc Ripples Power by ',structu,' Spindles, p12 ',num2str(floor(p12*100)/100),', p34 ',num2str(floor(p34*100)/100),', p13 ',num2str(floor(p13*100)/100),', p24 ',num2str(floor(p24*100)/100),', p14 ',num2str(floor(p14*100)/100),', p23 ',num2str(floor(p23*100)/100)])
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})


clear BilanCrossCtrl
clear BilanCrossLPS
clear NumEventsStruct1Ctrl
clear NumEventsStruct1LPS
clear NumEventsStruct2Ctrl
clear NumEventsStruct2LPS


smo=3;
for i=1:3
for j=1:3    
for k=1:3        
for l=1:3  
    try
    CPrePfc{i,j}{k,l}=smooth(CPrePfc{i,j}{k,l},smo);
    CPostPfc{i,j}{k,l}=smooth(CPostPfc{i,j}{k,l},smo);
    end
end
end
end
end


lim=0.75;
%1 Pfc
%2 Par
it=1;
for i=1:3
 b=3;
    for a=listLFPGood{numStruct,numHighLow,i}
         try
idaft=find((BPrePfc{2,i}{a,b}>-2.5*1E3&BPrePfc{2,i}{a,b}<-1.5)|BPrePfc{1,i}{a,b}>1.5*1E3&BPrePfc{1,i}{a,b}<2.5);
idbef=find(BPrePfc{2,i}{a,b}>-lim*1E3&BPrePfc{2,i}{a,b}<0);
% idbef=find(BPrePfc{1,i}{a,b}>0&BPrePfc{1,i}{a,b}<lim*1E3);
BilanCrossCtrl(it,1)=nanmean(CPrePfc{1,i}{a,b}(idbef,:))-nanmean(CPrePfc{1,i}{a,b}(idaft,:));
BilanCrossCtrl(it,2)=nanmean(CPostPfc{1,i}{a,b}(idbef,:))-nanmean(CPostPfc{1,i}{a,b}(idaft,:));

idaft=find((BPostPfc{2,i}{a,b}>-2.5*1E3&BPostPfc{2,i}{a,b}<-1.5)|BPostPfc{2,i}{a,b}>1.5*1E3&BPostPfc{2,i}{a,b}<2.5);
idbef=find(BPostPfc{2,i}{a,b}>-lim*1E3&BPostPfc{2,i}{a,b}<0);
% idbef=find(BPostPfc{2,i}{a,b}>0&BPostPfc{2,i}{a,b}<lim*1E3);
BilanCrossLPS(it,1)=nanmean(CPrePfc{2,i}{a,b}(idbef,:))-nanmean(CPrePfc{2,i}{a,b}(idaft,:));
BilanCrossLPS(it,2)=nanmean(CPostPfc{2,i}{a,b}(idbef,:))-nanmean(CPostPfc{2,i}{a,b}(idaft,:));

try
    NumEventsStruct1Ctrl(it,1)=NPre{1,i}{a};
catch
    NumEventsStruct1Ctrl(it,1)=nan;
end
try
    NumEventsStruct1Ctrl(it,2)=NPost{1,i}{a};
    catch
    NumEventsStruct1Ctrl(it,2)=nan;
end
try
    NumEventsStruct1LPS(it,1)=NPre{2,i}{a};
    catch
    NumEventsStruct1LPS(it,1)=nan;
end
try
    NumEventsStruct1LPS(it,2)=NPost{2,i}{a};
catch
    NumEventsStruct1LPS(it,2)=nan;
end
try
    NumEventsStruct2Ctrl(it,1)=N2Pre{1,i}{a};
catch
    NumEventsStruct2Ctrl(it,1)=nan;
end
try
    NumEventsStruct2Ctrl(it,2)=N2Post{1,i}{a};
    catch
    NumEventsStruct2Ctrl(it,2)=nan;
end
try
    NumEventsStruct2LPS(it,1)=N2Pre{2,i}{a};
    catch
    NumEventsStruct2LPS(it,1)=nan;
end
try
    NumEventsStruct2LPS(it,2)=N2Post{2,i}{a};
catch
    NumEventsStruct2LPS(it,2)=nan;
end
it=it+1;

%         end
         end
    end
end


NumEventsStruct1Ctrl(NumEventsStruct1Ctrl==0)=nan;
NumEventsStruct2Ctrl(NumEventsStruct2Ctrl==0)=nan;
NumEventsStruct1LPS(NumEventsStruct1LPS==0)=nan;
NumEventsStruct2LPS(NumEventsStruct2LPS==0)=nan;

% PlotErrorBar4(NumEventsStruct1Ctrl(:,1),NumEventsStruct1Ctrl(:,2),NumEventsStruct1LPS(:,1),NumEventsStruct1LPS(:,2))
% title(['Frequency of Spindles in ',structu])
% set(gca,'xtick',[1:4])
% set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})

[p,t,st,Pt,group]=CalculANOVA(NumEventsStruct1Ctrl(:,1),NumEventsStruct1Ctrl(:,2),NumEventsStruct1LPS(:,1),NumEventsStruct1LPS(:,2));
p12=Pt(1);
p34=Pt(2);
p13=Pt(3);
p24=Pt(4);
p14=Pt(5);
p23=Pt(6);
title(['Frequency of Spindles in ',structu,', p12 ',num2str(floor(p12*100)/100),', p34 ',num2str(floor(p34*100)/100),', p13 ',num2str(floor(p13*100)/100),', p24 ',num2str(floor(p24*100)/100),', p14 ',num2str(floor(p14*100)/100),', p23 ',num2str(floor(p23*100)/100)])
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})


% PlotErrorBar4(NumEventsStruct2Ctrl(:,1),NumEventsStruct2Ctrl(:,2),NumEventsStruct2LPS(:,1),NumEventsStruct2LPS(:,2))
% title(['Frequency of Ripples'])
% set(gca,'xtick',[1:4])
% set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})

[p,t,st,Pt,group]=CalculANOVA(NumEventsStruct2Ctrl(:,1),NumEventsStruct2Ctrl(:,2),NumEventsStruct2LPS(:,1),NumEventsStruct2LPS(:,2));
p12=Pt(1);
p34=Pt(2);
p13=Pt(3);
p24=Pt(4);
p14=Pt(5);
p23=Pt(6);
title(['Frequency of Ripples, p12 ',num2str(floor(p12*100)/100),', p34 ',num2str(floor(p34*100)/100),', p13 ',num2str(floor(p13*100)/100),', p24 ',num2str(floor(p24*100)/100),', p14 ',num2str(floor(p14*100)/100),', p23 ',num2str(floor(p23*100)/100)])
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})


% PlotErrorBar4(BilanCrossCtrl(:,1),BilanCrossCtrl(:,2),BilanCrossLPS(:,1),BilanCrossLPS(:,2))
% title(['Modulation of Hpc Ripples Occurence by ',structu,' Spindles'])
% set(gca,'xtick',[1:4])
% set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})

[p,t,st,Pt,group]=CalculANOVA(BilanCrossCtrl(:,1),BilanCrossCtrl(:,2),BilanCrossLPS(:,1),BilanCrossLPS(:,2));
p12=Pt(1);
p34=Pt(2);
p13=Pt(3);
p24=Pt(4);
p14=Pt(5);
p23=Pt(6);
title(['Modulation of Hpc Ripples Occurence by ',structu,' Spindles, p12 ',num2str(floor(p12*100)/100),', p34 ',num2str(floor(p34*100)/100),', p13 ',num2str(floor(p13*100)/100),', p24 ',num2str(floor(p24*100)/100),', p14 ',num2str(floor(p14*100)/100),', p23 ',num2str(floor(p23*100)/100)])
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
% PlotErrorBar4(BCtrl1(:,1),BCtrl1(:,2),BLPS1(:,1),BLPS1(:,2))
% title(['Modulation of Hpc Ripples Occurence by ',structu,' Spindles (Corrected)'])
% set(gca,'xtick',[1:4])
% set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})

[p,t,st,Pt,group]=CalculANOVA(BCtrl1(:,1),BCtrl1(:,2),BLPS1(:,1),BLPS1(:,2));
p12=Pt(1);
p34=Pt(2);
p13=Pt(3);
p24=Pt(4);
p14=Pt(5);
p23=Pt(6);
title(['Modulation of Hpc Ripples Occurence by ',structu,' Spindles, p12 ',num2str(floor(p12*100)/100),', p34 ',num2str(floor(p34*100)/100),', p13 ',num2str(floor(p13*100)/100),', p24 ',num2str(floor(p24*100)/100),', p14 ',num2str(floor(p14*100)/100),', p23 ',num2str(floor(p23*100)/100)])
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})




% PlotErrorBar4(M1RipPre{1,1}(:,4),M1RipPost{1,1}(:,4),nan,M1RipPost{2,1}(:,4))
% PlotErrorBar4(M1RipPre{1,2}(:,4),M1RipPost{1,2}(:,4),M1RipPre{2,2}(:,4),M1RipPost{2,2}(:,4))
% PlotErrorBar4(M1RipPre{1,3}(:,4),M1RipPost{1,3}(:,4),M1RipPre{2,3}(:,4),M1RipPost{2,3}(:,4))

clear MeanRipCtrl
clear MeanRipLPS

idripp=96:106;
for i=1:3
    try
MeanRipCtrl(i,1)=max(M1RipPre{1,i}(idripp,2))-min(M1RipPre{1,i}(idripp,2));
    catch
 MeanRipCtrl(i,1)=nan;       
    end
MeanRipCtrl(i,2)=max(M1RipPost{1,i}(idripp,2))-min(M1RipPost{1,i}(idripp,2));
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

MRc=MeanRipCtrl;
id1=find(isnan(MeanRipCtrl(:,1)));
id2=find(isnan(MeanRipCtrl(:,2)));
MRc(id1,:)=[];
id2=find(isnan(MRc(:,2)));
MRc(id2,:)=[];

MRl=MeanRipLPS;
id1=find(isnan(MeanRipLPS(:,1)));
id2=find(isnan(MeanRipLPS(:,2)));
MRl(id1,:)=[];
id2=find(isnan(MRl(:,2)));
MRl(id2,:)=[];
PlotErrorBar4(MRc(:,1),MRc(:,2),MRl(:,1),MRl(:,2))
set(gca,'xtick',[1:4])
title('Amplitude Ripples Corrected')



% MeanSpi1Ctrl(i,1)
% test=M1SpiPre{1,1}{listLFPGood{numStruct,numHighLow,1}}(id,2));
% max(test)-min(test);

clear MeanSpi1Ctrl
clear MeanSpi1LPS

it=1;
for i=1:3
    for j=1:length(listLFPGood{numStruct,numHighLow,i})
if ismember(1,listLFPGood{numStruct,numHighLow,i})
    
                try
                clear temp
                temp=(M1SpiPre{1,i}{listLFPGood{numStruct,numHighLow,i}(j)}(:,2));
                MeanSpi1Ctrl(it,1)=max(temp)-min(temp);
                catch
                MeanSpi1Ctrl(it,1)=nan;        
                end
                clear temp
                try
                temp=(M1SpiPost{1,i}{listLFPGood{numStruct,numHighLow,i}(j)}(:,2));
                MeanSpi1Ctrl(it,2)=max(temp)-min(temp);
                catch
                MeanSpi1Ctrl(it,2)=nan;    
                end
                clear temp
                try
                temp=(M1SpiPre{2,i}{listLFPGood{numStruct,numHighLow,i}(j)}(:,2));
                MeanSpi1LPS(it,1)=max(temp)-min(temp);
                catch
                MeanSpi1LPS(it,1)=nan;    
                end
                clear temp
                try
                temp=(M1SpiPost{2,i}{listLFPGood{numStruct,numHighLow,i}(j)}(:,2));
                MeanSpi1LPS(it,2)=max(temp)-min(temp);
                catch
                MeanSpi1LPS(it,2)=nan;    
                end
%                 [it i]
                it=it+1;
                
elseif ismember(2,listLFPGood{numStruct,numHighLow,i})
                try
                    clear temp
                temp=(M2SpiPre{1,i}{listLFPGood{numStruct,numHighLow,i}(j)}(:,2));
                MeanSpi1Ctrl(it,1)=max(temp)-min(temp);
                catch
                MeanSpi1Ctrl(it,1)=nan;        
                end
                clear temp
                temp=(M2SpiPost{1,i}{listLFPGood{numStruct,numHighLow,i}(j)}(:,2));
                MeanSpi1Ctrl(it,2)=max(temp)-min(temp);
                try
                temp=(M2SpiPre{2,i}{listLFPGood{numStruct,numHighLow,i}}(:,2));
                MeanSpi1LPS(it,1)=max(temp)-min(temp);
                catch
                MeanSpi1LPS(it,1)=nan;    
                end
                clear temp
                try
                temp=(M2SpiPost{2,i}{listLFPGood{numStruct,numHighLow,i}(j)}(:,2));
                MeanSpi1LPS(it,2)=max(temp)-min(temp);
                catch
                MeanSpi1LPS(it,2)=nan;     
                end
%                 [it i]
                it=it+1;

elseif ismember(3,listLFPGood{numStruct,numHighLow,i})
                try
                    clear temp
                temp=(M3SpiPre{1,i}{listLFPGood{numStruct,numHighLow,i}(j)}(:,2));
                MeanSpi1Ctrl(it,1)=max(temp)-min(temp);
                catch
                MeanSpi1Ctrl(it,1)=nan;        
                end
                clear temp
                try
                temp=(M3SpiPost{1,i}{listLFPGood{numStruct,numHighLow,i}(j)}(:,2));
                MeanSpi1Ctrl(it,2)=max(temp)-min(temp);
                catch
                MeanSpi1Ctrl(it,2)=nan;    
                end
                    clear temp
                
                try
                temp=(M3SpiPre{2,i}{listLFPGood{numStruct,numHighLow,i}(j)}(:,2));
                MeanSpi1LPS(it,1)=max(temp)-min(temp);
                catch
                MeanSpi1LPS(it,1)=nan;    
                end
                clear temp
                try
                temp=(M3SpiPost{2,i}{listLFPGood{numStruct,numHighLow,i}(j)}(:,2));
                MeanSpi1LPS(it,2)=max(temp)-min(temp);
                catch
                MeanSpi1LPS(it,2)=nan;    
                end
%                 [it i]
                it=it+1;
                clear temp
end
    end
end
% 
% PlotErrorBar4(MeanSpi1Ctrl(:,1),MeanSpi1Ctrl(:,2),MeanSpi1LPS(:,1),MeanSpi1LPS(:,2))
% set(gca,'xtick',[1:4])
% set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})
% title(['Amplitude Spindles ',structu])


[p,t,st,Pt,group]=CalculANOVA(MeanSpi1Ctrl(:,1),MeanSpi1Ctrl(:,2),MeanSpi1LPS(:,1),MeanSpi1LPS(:,2));
p12=Pt(1);
p34=Pt(2);
p13=Pt(3);
p24=Pt(4);
p14=Pt(5);
p23=Pt(6);
title(['Amplitude Spindles ',structu,', p12 ',num2str(floor(p12*100)/100),', p34 ',num2str(floor(p34*100)/100),', p13 ',num2str(floor(p13*100)/100),', p24 ',num2str(floor(p24*100)/100),', p14 ',num2str(floor(p14*100)/100),', p23 ',num2str(floor(p23*100)/100)])
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})




clear id1
clear id2
MSc=MeanSpi1Ctrl;
id1=find(isnan(MeanSpi1Ctrl(:,1)));
id2=find(isnan(MeanSpi1Ctrl(:,2)));
MSc(id1,:)=[];
id2=find(isnan(MSc(:,2)));
MSc(id2,:)=[];

clear id1
clear id2
MSl=MeanSpi1LPS;
id1=find(isnan(MeanSpi1LPS(:,1)));
id2=find(isnan(MeanSpi1LPS(:,2)));
MSl(id1,:)=[];
id2=find(isnan(MSl(:,2)));
MSl(id2,:)=[];

PlotErrorBar4(MSc(:,1),MSc(:,2),MSl(:,1),MSl(:,2))
set(gca,'xtick',[1:4])
title(['Amplitude Spindles ',structu,' corrected'])
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Veh Pre','Veh Post','LPS Pre','LPS Post'})

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


cd \\NASDELUXE\DataMOBs\ProjetLPS

if 0
if structu=='Pfc'& HighLow=='L';
        save DataNoelliaCrossCorr1 % 
    elseif structu=='Par'& HighLow=='L';
    save DataNoelliaCrossCorr2 % struct='Par';, HighLow='L';
    elseif structu=='Pfc'& HighLow=='H';
    save DataNoelliaCrossCorr3 % struct='Pfc';, HighLow='H';
    elseif structu=='Par'& HighLow=='H';
    save DataNoelliaCrossCorr4 % struct='Par';, HighLow='H';
    elseif structu=='Aud'& HighLow=='L';
    save DataNoelliaCrossCorr5 % struct='Par';, HighLow='H';
    elseif structu=='Aud'& HighLow=='H';
    save DataNoelliaCrossCorr6 % struct='Par';, HighLow='H';
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
