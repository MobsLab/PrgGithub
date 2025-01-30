%an_acti_StatDistribML.m

disp('an_acti_delayML.m')

PeriodDay=[10.5,17.5]; % btw 10h30 & 17h30
nsim=20;
%% Acquisition identities

% mice%  an_actiML_quantifSleep.m
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
channelID=[1 2 6 10, 3 7 8 12]; % best mouse

% BASAL
ID_Basal=[29 31 32 34 40 43 60 70 81 91 101 111 121 131];%

% TEST
ID_Test = [59 69 80 90 100 110 120];

% TEST 0
ID_Test0 = [36 37 38];

% COND
ID_Cond=[47 48 52 55 57,...
    61 63 65 67,...
    71 73 76 78,...
    82 84 86 88,...
    92 94 96 98,...
    102 104 106 108,...
    %112 114 116 118,...
    %122 124 126 128,...
    ];

%% Order 

IDacq = [ID_Test0 ; ones(1,length(ID_Test0))];
IDacq = [ IDacq , [ID_Test; 1+ones(1,length(ID_Test))] ];
IDacq = [ IDacq , [ID_Basal; 2+ones(1,length(ID_Basal))] ];
IDacq=sortrows(IDacq',1)';

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% groups of mice

GpW=[1 2 6 10]; % wake conditioning
GpS=[3 4 7 8 12];% sleep conditioning
gpMice=nan(1,length(channelID));
for id=1:length(channelID)
    gpMice(id)=ismember(channelID(id),GpW);
end
% gpMice sleep = 0; gpMice wake = 1 

%% Analyname
res='/media/DataMOBsRAID/ProjetSLEEPActi/Analysis';

numBatch=1;
cd(res);
if isempty(strfind(res,'/')), mark='\'; else, mark='/';end
analyname=['an_acti_StatDistrib_Expe',num2str(numBatch),'.mat'];


%% Compute distrib simulation on BASAL
try
    clear simuBasal
    load([res,mark,analyname])
    simuBasal;
    disp([analyname,' already exists... loading...'])
    
catch
    
    for id =1:length(channelID)
        simuBasal{id,1}=nan(1000,length(ID_Basal));
        simuBasal{id,2}=nan(1000,length(ID_Basal));
    end
    for i=1:length(ID_Basal)
        
        clear a d date_a dur_Rec hr_startRec
        
        for id =1:length(channelID)
            
            %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            % Load data
            if strcmp(mark,'/')
                a = Activity_linux(numBatch,ID_Basal(i), channelID(id));
            else
                a = Activity(ID_Basal(i), channelID(id));
            end
            
            %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            % get info of recording
            if id==1
                d=dir([a.dataDir,num2str(a.numBatch),'/',a.dataFileName_time]);
                date_a=datevec(d.date);
                dur_Rec=length(a.activity);
                hr_startRec=mod(date_a(4:6)*[1 1/60 1/3600]'-dur_Rec/3600,24);
            end
            
            %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            % Get the sleep scoring
            %(smoothed scoring with corrected beginning and ending of events)
            [sleepScoring, timeStamps] = a.computeSleepScoring();
            
            chgState=find(diff(sleepScoring)~=0);
            
            %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            % get time of sound stim
            % discard lost mice
            simS=[];simW=[];
            for si=1:nsim
                evt_stimTimeStamps = getStimulationAsAProbeTest(sleepScoring, a.activity, timeStamps, a.SWc)';
                if ~isempty(evt_stimTimeStamps)%  an_actiML_quantifSleep.m
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
                delay_chg=nan(length(evt_stimTimeStamps),1);
                for e=1:length(evt_stimTimeStamps)
                    try delay_chg(e)=min(chgState(chgState > evt_stimTimeStamps(e)));end
                end
                temp=[hr_startRec+evt_stimTimeStamps/3600,sleepScoring(evt_stimTimeStamps)', delay_chg-evt_stimTimeStamps];
                simS=[simS;temp(temp(:,1)> PeriodDay(1) & temp(:,1)< PeriodDay(2)...
                    & temp(:,2)==1 & temp(:,3)>10 , 3)]; % delay before sleep
                simW=[simW;temp(temp(:,1)> PeriodDay(1) & temp(:,1)< PeriodDay(2)...
                    & temp(:,2)==-1 & temp(:,3)>10 , 3)];% delay before wake
                end
            end
            
            tempMATS=simuBasal{id,1};
            try tempMATS(1:length(simS),i)=simS;end
            tempMATW=simuBasal{id,2};
            try tempMATW(1:length(simW),i)=simW;end
            simuBasal(id,1:2)={tempMATS,tempMATW};
            
        end
    end
    
    % save
    disp(['...Saving in ',analyname])
    save(analyname,'simuBasal','channelID','ID_Basal');
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% Restrict period of analysis

x_hist=1:20:400;
%x_hist=1:100:500;
hs=nan(length(channelID),length(x_hist));
h=nan(length(channelID),length(x_hist));
colori=colormap('jet');leg=[];

figure('Color',[1 1 1])
for id =1:length(channelID)
    clear tempMATS tempMATW
    tempMATS = simuBasal{id,1};
    tempMATW = simuBasal{id,2};
    
    subplot(2,2,1), hold on
    hs(id,:)=hist(tempMATS(~isnan(tempMATS)),x_hist);
    %plot(x_hist, hs(id,:),'.-','Color',colori(7*id,:))
    plot(x_hist, cumsum(hs(id,:)),'.-','Color',colori(7*id,:))
    ylabel('nb of occurance')
    xlabel('delay snd->sleep')
    xlim([10 max(x_hist)-10])
    
    subplot(2,2,2), hold on
    h(id,:)=hist(tempMATW(~isnan(tempMATW)),x_hist);
    %plot(x_hist, h(id,:),'.-','Color',colori(7*id,:))
    plot(x_hist, cumsum(h(id,:)),'.-','Color',colori(7*id,:))
    
    leg=[leg,{['#',num2str(channelID(id))]}];
    xlabel('delay snd->wake')
    xlim([10 max(x_hist)-10])
end
subplot(2,2,1), legend(leg)
title(['Repartition of latence snd-> wake and snd->sleep in BASAL expe (simulation x',num2str(nsim),' for each)'])

subplot(2,2,3),hold on
errorbar(x_hist, nanmean(hs(gpMice==0,:),1),sem(hs(gpMice==0,:)),'.-r','Linewidth',2)
errorbar(x_hist, nanmean(hs(gpMice==1,:),1),sem(hs(gpMice==1,:)),'.-b','Linewidth',2)
xlim([10 max(x_hist)-10])
xlabel('delay snd->sleep')
ylabel('nb of occurance')
legend([{['Cond sleep (n=',num2str(length(find(gpMice==0))),', #',sprintf(' %d',channelID(gpMice==0)),')']},...
    {['Cond wake (n=',num2str(sum(gpMice)),', #',sprintf(' %d',channelID(gpMice==1)),')']}])

subplot(2,2,4),hold on
errorbar(x_hist, nanmean(h(gpMice==0,:),1),sem(h(gpMice==0,:)),'.-r','Linewidth',2)
errorbar(x_hist, nanmean(h(gpMice==1,:),1),sem(h(gpMice==1,:)),'.-b','Linewidth',2)
xlim([10 max(x_hist)-10])
xlabel('delay snd->wake')

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% compare with test
temp=load([res,mark,'an_acti_delay.mat']);
disp('an_acti_delay.mat already exists... loading...')

TS=nan(length(channelID)*length(IDacq),2+length(x_hist));
TW=nan(length(channelID)*length(IDacq),2+length(x_hist));
for id =1:length(channelID)
    for i=1:length(IDacq)
        if IDacq(2,i)==1 ||  IDacq(2,i)==2
            indS=find(temp.MAT(:,1)==IDacq(1,i) & temp.MAT(:,6)==1 & temp.MAT(:,4)==channelID(id)); % delay before sleep
            indW=find(temp.MAT(:,1)==IDacq(1,i) & temp.MAT(:,6)==-1 & temp.MAT(:,4)==channelID(id)); % delay before wake
            tempS=temp.MAT(indS,8)-temp.MAT(indS,5);
            tempW=hist(temp.MAT(indW,8)-temp.MAT(indW,5),x_hist);
            
            TS((id-1)*length(IDacq)+i,1:2)=[channelID(id),IDacq(1,i)];
            TS((id-1)*length(IDacq)+i,3:length(x_hist)+2)=tempS;
            TW((id-1)*length(IDacq)+i,1:2)=[channelID(id),IDacq(1,i)];
            TW((id-1)*length(IDacq)+i,3:length(x_hist)+2)=tempW;
        end
    end
end
%
  figure('Color',[1 1 1])
for id =1:length(channelID)
    subplot(2,length(channelID),id), hold on
    plot(TS(find(TS(:,1)==channelID(id)),3:end),'Color',colori(7*id,:))
    subplot(2,length(channelID),length(channelID)+id), hold on
    plot(TW(find(TW(:,1)==channelID(id)),3:end),'Color',colori(7*id,:))
end
    
    
    
    
    
    
    