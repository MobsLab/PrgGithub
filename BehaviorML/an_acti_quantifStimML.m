%  an_actiML_quantifStimML.m
%
% other related scripts and functions :
%   - AnalyseActimeterML.m
%   - ActimetrySleepScorCompar.m
%   - ActiToData.m
%   - PoolDataActi.m
%   - ActimetryQuantifSleep.m
%   - GetAllDataActi.m
%   - an_actiML.m
%   - an_acti_delayML.m
%   - an_acti_StatDistribML.m
%   - an_actiML_quantifSleep.m

disp('an_actiML_quantifStimML.m')


%% INPUTS
res='/media/DataMOBsRAID/ProjetSLEEPActi/Analysis';

numBatch=1;
if numBatch==1
    name='an_acti_Expe1_09to141.mat'; % from an_actiML.m
elseif numBatch==2
    name='an_acti_Expe2_00to04.mat'; % from an_actiML.m
end

cd(res);
if isempty(strfind(res,'/')), mark='\'; else, mark='/';end


PeriodDay=[10.5,17.5]; % btw 10h30 & 17h30

%% groups of mice
% mice
if numBatch==1
    channelID=[1 2 6 10, 3 7 8 12]; % best mouse
    GpW=[1 2 6 10]; % wake conditioning
    GpS=[3 4 7 8 12];% sleep conditioning
elseif numBatch==2
    channelID=[ 2 5 8, 1 4 7 11]; % ordered
    GpW=[2 5 8]; % wake conditioning
    GpS=[1 4 7 11];% sleep conditioning
end

gpMice=nan(1,length(channelID));
for id=1:length(channelID)
    gpMice(id)=ismember(channelID(id),GpW);
end
% gpMice sleep = 0; gpMice wake = 1 


%% Acquisition identities
ID_name={'BASAL','COND','TEST0','TEST','TESTfin'};
if numBatch==1
    ID_Basal=[29 31 32 34 40 43 60 70 81 91 101 111 121 131 141];% BASAL
    
    ID_Test0 = [36 37 38];% TEST 0
    ID_Test = [59 69 80 90 100 110 120 130];% TEST
    ID_TestF = 140;% TESTFINAL
    
    ID_Cond=[47 48 52 55 57,    61 63 65 67,    71 73 76 78,...
        82 84 86 88,    92 94 96 98,    102 104 106 108,...
        112 114 116 118,    122 124 126 128,   132 134 136 138]; % COND
    
elseif numBatch==2
    ID_Basal=[7 8 14 18 19 21 24 ];% BASAL
    
    ID_Test0 = [17 20 23];% TEST 0
    ID_Test = [33 ];% TEST
    ID_TestF = [];% TESTFINAL
    
    ID_Cond=[25 27 29 31]; % COND
end

%% LOAD ANALYSIS
temp=load(name);
Info_sleepWake=temp.Info_sleepWake;
SWdur=temp.sleepWakeDuration;
Stim_ts=temp.Stim_ts;
CatEvent=temp.CatEvent;
           
%% Order expe
IDacq=[temp.expe', nan(length(temp.expe),1)];
IDacq(ismember(IDacq(:,1),ID_Basal),2)=0;
IDacq(ismember(IDacq(:,1),ID_Cond),2)=1;
IDacq(ismember(IDacq(:,1),ID_Test0),2)=2;
IDacq(ismember(IDacq(:,1),ID_Test),2)=3;
IDacq(ismember(IDacq(:,1),ID_TestFin),2)=4;


%% remove data for lost mice
lostmice=[1,103; 2,107; 3,135; 5,33; 11,95]; %last good rec
for i=1:size(lostmice,1)
    SWdur(Info_sleepWake(:,1)>lostmice(i,2),lostmice(i,1))=nan;
    
    temp=Stim_ts{lostmice(i,1)};
    am=min(Info_sleepWake(Info_sleepWake(:,1)>lostmice(i,2),3));
    Stim_ts{lostmice(i,1)}=Restrict(temp,intervalSet(min(Range(temp)),am*1E4));
end
     


%% Quantif Number of Stim
nbsound=nan(size(IDacq,1),length(channelID));
rg=Range(CatEvent,'s');
dt=Data(CatEvent);
for i=1:size(IDacq,1)
    tmin=min(rg(dt==IDacq(i,1)));
    tmax=max(rg(dt==IDacq(i,1)));
    try
        for id =1:length(channelID)
            nbsound(i,id)=length(Restrict(Stim_ts{channelID(id)},intervalSet(tmin*1E4,tmax*1E4)));
        end
    end
end  
    
%% separate by phase of learning

figure('Color',[1 1 1]), hold on,
Uid=unique(IDacq(~isnan(IDacq(:,2)),2));
for u=1:length(Uid)
    subplot(1,length(Uid),u)
    tempMat=nbsound(IDacq(:,2)==Uid(u),:);
    imagesc(1:length(channelID),1:size(tempMat,1),tempMat); axis xy
    title(ID_name{Uid(u)+1})
    colorbar('location','SouthOutside')
    ylim([0 37]); xlabel('# Mouse');ylabel('# session')
    caxis([0 150])
    set(gca,'xtick',1:length(channelID))
    for o=1:length(channelID), stringID{o}=num2str(channelID(o));end
    set(gca,'xticklabel',stringID)
    
    set(gca,'ytick',1:size(tempMat,1))
    tempIDacq=IDacq(IDacq(:,2)==Uid(u),1);
    for i=1:size(tempMat,1), stringacq{i}=num2str(tempIDacq(i));end
     set(gca,'yticklabel',stringacq)
end
   

%% Quantif %sleep for all sessions
Bl=4; %BlockToAnalyse;
valmax=40;
figure('Color',[1 1 1]), hold on,
meanProp=nan(12,length(Uid));
for id =1:12
    ploTemp=nan(valmax,length(Uid));
    for u=1:length(Uid)
        ind=IDacq(IDacq(:,2)==Uid(u),1);
        ind2=find(ismember(Info_sleepWake(:,1),ind) & Info_sleepWake(:,5)==Bl);
        ploTemp(1:length(ind2),u)=SWdur(ind2,id);
    end
    subplot(3,4,id)
    PlotErrorBarN(ploTemp,0,0);
    title(['Mouse #',num2str(id)])
    ylim([0 100]);
    if mod(id,4)==1, ylabel(['% sleep ',num2str(4*(Bl-1)),'h-',num2str(4*Bl),'h']);end
    set(gca,'xtick',1:length(Uid))
    set(gca,'xticklabel',ID_name)
    
    meanProp(id,:)=nanmean(ploTemp);
end

%%
figure('Color',[1 1 1]),
subplot(2,2,1)% sleep group
PlotErrorBarN(meanProp(channelID(gpMice==0),:),0,1)
set(gca,'xtick',1:length(Uid))
set(gca,'xticklabel',ID_name)
ylim([50 80]);ylabel(['% sleep ',num2str(4*(Bl-1)),'h-',num2str(4*Bl),'h']);
title(['% sleep pooled per session type (SLEEP group: n=',num2str(length(find(gpMice==0))),')'])
m1=nanmean(meanProp(channelID(gpMice==0),:));
s1=sem(meanProp(channelID(gpMice==0),:));
m1n=nanmean(log10(meanProp(channelID(gpMice==0),:)./(meanProp(channelID(gpMice==0),1)*ones(length(Uid),1)')));
s1n=sem(log10(meanProp(channelID(gpMice==0),:)./(meanProp(channelID(gpMice==0),1)*ones(length(Uid),1)')));

subplot(2,2,3)% wake group
PlotErrorBarN(meanProp(channelID(gpMice==1),:),0,1)
set(gca,'xtick',1:length(Uid))
set(gca,'xticklabel',ID_name)
ylim([50 80]);ylabel(['% sleep ',num2str(4*(Bl-1)),'h-',num2str(4*Bl),'h']);
title(['% sleep pooled per session type (WAKE group: n=',num2str(length(find(gpMice==1))),')'])
m2=nanmean(meanProp(channelID(gpMice==1),:));
s2=sem(meanProp(channelID(gpMice==1),:));
m2n=nanmean(log10(meanProp(channelID(gpMice==1),:)./(meanProp(channelID(gpMice==1),1)*ones(length(Uid),1)')));
s2n=sem(log10(meanProp(channelID(gpMice==1),:)./(meanProp(channelID(gpMice==1),1)*ones(length(Uid),1)')));

% pool errorbar
subplot(2,2,2), hold on
errorbar(1:length(Uid),m1,s1,'r','Linewidth',2)
errorbar(1:length(Uid),m2,s2,'b','Linewidth',2)
ylim([50 80]);ylabel(['% sleep ',num2str(4*(Bl-1)),'h-',num2str(4*Bl),'h']);
set(gca,'xtick',1:length(Uid)); set(gca,'xticklabel',ID_name); 
legend([{['Sleep Cond (n=',num2str(length(find(gpMice==0))),')']},{['Wake Cond (n=',num2str(length(find(gpMice==1))),')']}])
title('% sleep pooled per session type');

% pool errorbar normalized
subplot(2,2,4), hold on
errorbar(1:length(Uid),m1n,s1n,'r','Linewidth',2)
errorbar(1:length(Uid),m2n,s2n,'b','Linewidth',2)
ylabel(['log10 normed % sleep ',num2str(4*(Bl-1)),'h-',num2str(4*Bl),'h']);
set(gca,'xtick',1:length(Uid)); set(gca,'xticklabel',ID_name); 
title('% sleep pooled per session type, Normed by Basal session');
    


%% Check no stim during Basal
% cd /media/DataMOBsRAID/ProjetSLEEPActi/Analysis
% disp('loading an_acti_Expe1_09to141.mat');load('an_acti_Expe1_09to141.mat')

%%
ID_Basal=[29 31 32 34 40 60 70 81 91 101 111 121 131 141]; %43?
rg=Range(Stim_ts{1},'s');
figure, plot(rg,1:length(rg),'.'), hold on,
for i=1:length(Info_sleepWake(:,3)), line(Info_sleepWake(i,3)*[1 1],[0 3000],'Color',[0.5 0.5 0.5]);end
for i=1:length(ID_Basal), line(Info_sleepWake(min(find(Info_sleepWake(:,1)==ID_Basal(i))),3)*[1 1],[0 3000],'Color','r');end




