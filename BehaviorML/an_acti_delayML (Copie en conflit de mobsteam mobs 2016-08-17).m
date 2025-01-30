%an_acti_delayML.m

% other related scripts and functions :
%   - AnalyseActimeterML.m
%   - ActimetrySleepScorCompar.m
%   - ActiToData.m
%   - PoolDataActi.m
%   - ActimetryQuantifSleep.m
%   - GetAllDataActi.m
%   - an_actiML.m
%   - an_actiML_quantifSleep.m
%   - an_acti_StatDistribML.m
disp('an_acti_delayML.m')

PeriodDay=[9.5,18]; % btw 9h30 & 18h

%% Acquisition identities

numBatch=1;
if numBatch==1
    channelID=[1 2 6 10, 3 7 8 12]; % best mouse
    
    ID_Basal=[29 31 32 34 40 43 60 70 81 91 101 111 121 131 141];% BASAL
    
    ID_Test0 = [36 37 38];% TEST 0
    ID_Test = [59 69 80 90 100 110 120 130];% TEST
    ID_TestF = 140;% TESTFINAL
    
    ID_Cond=[47 48 52 55 57,    61 63 65 67,    71 73 76 78,...
        82 84 86 88,    92 94 96 98,    102 104 106 108,...
        112 114 116 118,    122 124 126 128,   132 134 136 138]; % COND
    
    GpW=[1 2 6 10]; % wake conditioning
    GpS=[3 4 7 8 12];% sleep conditioning
    
    Problems=[11 95;... % do not take mouse#11 from recording 0095.
        1 103;
        2 107];
    
elseif numBatch==2
%     channelID=[1 4 7 11, 2 5 8]; % ordered
%     ID_Basal=[7 8 14 18 19 21 24 34 44];% BASAL
%     ID_Test0 = [17 20 23];% TEST 0
%     ID_Test = [33 43 54];% TEST
%     ID_TestF = [];% TESTFINAL
%     ID_Cond=[25 27 29 31,...
%         25 27 29 41,...
%         45 47 50 52]; % COND

    channelID=1:12; % ordered
    ID_Basal=[65 67 69 71 81 91];
    
    ID_Test0 = [66 68 70];% TEST 0
    ID_Test = [80 90 100];% TEST
    ID_TestF = [];% TESTFINAL
    
    ID_Cond=[72 74 76 78, 82 84 86 88, 92 94 96 98]; % COND
   
    GpW=[2 3 5 8 9 12]; % wake conditioning
    GpS=[1 4 6 7 10 11];% sleep conditioning 
    
    Problems=[1 101]; % do not take mouse#1 after recording 0100.
end
%% Order 
IDacq =sort([ID_Basal,ID_Cond,ID_Test0,ID_Test,ID_TestF])';
IDacq=[IDacq,zeros(length(IDacq),1)];% Basal=0
IDacq(ismember(IDacq(:,1),ID_Test0),2)=1;% Test0=1
IDacq(ismember(IDacq(:,1),ID_Test),2)=2;% Test=2
IDacq(ismember(IDacq(:,1),ID_Cond),2)=3;% Cond=3

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% groups of mice
gpMice=nan(1,length(channelID));
for id=1:length(channelID)
    gpMice(id)=ismember(channelID(id),GpW);
end
% gpMice sleep = 0; gpMice wake = 1 

%% Analyname
res='/media/DataMOBsRAID/ProjetSLEEPActi/Analysis';

cd(res);
if isempty(strfind(res,'/')), mark='\'; else, mark='/';end
analyname=sprintf('an_acti_delay_Expe%d_%dto%d.mat',numBatch,min(IDacq(:,1)),max(IDacq(:,1)));


%% Compute
try
    clear MAT
    load([res,mark,analyname])
    MAT;
    disp([analyname,' already exists... loading...'])
    
catch
    
    MAT=[];
    for i=1:size(IDacq,1)
        
        clear a d date_a dur_Rec hr_startRec
        
        for id =1:length(channelID)
            
            if ~isempty(Problems) && ismember(channelID(id),Problems(:,1))...
                    && IDacq(i,1)>Problems(Problems(:,1)==channelID(id),2)
                %evt_stimTimeStamps =[];
                disp(sprintf('discarding SLEEPActi  %04d-cage%02d/%04d-cage%02d1-signal.dat',...
                    IDacq(i,1),channelID(id),IDacq(i,1),channelID(id)));
            else
                %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                % Load data
                if strcmp(mark,'/')
                    a = Activity_linux(numBatch,IDacq(i,1), channelID(id));
                else
                    a = Activity(IDacq(i,1), channelID(id));
                end
                
                %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                % get info of recording
                if ~exist('hr_startRec','var')
                    d=dir([a.dataDir,num2str(a.numBatch),'/',a.dataFileName_time]);
                    date_a=datevec(d.date);
                    dur_Rec=length(a.activity);
                    hr_startRec=mod(date_a(4:6)*[1 1/60 1/3600]'-dur_Rec/3600,24);
                end
                
                %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                % Get the sleep scoring
                %(smoothed scoring with corrected beginning and ending of events)
                [sleepScoring, timeStamps] = a.computeSleepScoring();

                %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                % get time of sound stim
                % discard lost mice
                
                if IDacq(i,2)==0 %basal
                    fprintf('BASAL: Simulate a probe test.\n');
                    % get epochs corresponding to PeriodDay
                    ind1=find(abs(mod(hr_startRec+timeStamps/3600,24)-PeriodDay(1))< 1/3600);
                    ind2=find(abs(mod(hr_startRec+timeStamps/3600,24)-PeriodDay(2))< 1/3600);
                    % get start and stop if inside PeriodDay
                    if isempty(ind1) && hr_startRec>PeriodDay(1) && hr_startRec<PeriodDay(2), ind1=1;end
                    hrfin=mod(hr_startRec+timeStamps(end)/3600,24);
                    if isempty(ind2) && hrfin>PeriodDay(1) && hrfin<PeriodDay(2), ind2=length(timeStamps);end
                    
                    ind1(diff(ind1)==1)=[]; ind2(diff(ind2)==1)=[];
                    if ind1(1)>ind2(1), ind1=[1,ind1];end
                    if ind2(end)<ind1(end), ind2=[ind2,length(timeStamps)];end
                    evt_stimTimeStamps=[];
                    for nd=1:length(ind1)
                        evt_temp= getStimulationAsAProbeTest(sleepScoring(ind1(nd):ind2(nd)), a.activity(ind1(nd):ind2(nd)),...
                        timeStamps(ind1(nd):ind2(nd))-timeStamps(ind1(nd)), a.SWc)'+timeStamps(ind1(nd));
                        evt_stimTimeStamps=[evt_stimTimeStamps;evt_temp];
                    end
                    
                else
                    evt_stimTimeStamps = a.timeStamps_evt(a.evts == a.SWc.EVT_SOUND_STIM);
                end
                %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                chgState=find(diff(sleepScoring)~=0);
                delay_chg=nan(length(evt_stimTimeStamps),2);
                for e=1:length(evt_stimTimeStamps)
                    try delay_chg(e,1)=max(chgState(chgState < evt_stimTimeStamps(e)));end
                    try delay_chg(e,2)=min(chgState(chgState > evt_stimTimeStamps(e)));end
                end
                
                %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                % create tempMAT and add to MAT
                tempMAT = ones(length(evt_stimTimeStamps),1)*[IDacq(i,:) hr_startRec channelID(id)];
                tempMAT = [tempMAT , evt_stimTimeStamps, sleepScoring(evt_stimTimeStamps)', delay_chg];
                
                MAT=[MAT; tempMAT];
            end
        end
    end
    
    % save
    disp(['...Saving in ',analyname])
    save(analyname,'MAT','channelID','IDacq');
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% Restrict period of analysis
ind=find(mod(MAT(:,3)+MAT(:,5)/3600,24) > PeriodDay(2) | mod(MAT(:,3)+MAT(:,5)/3600,24) < PeriodDay(1));
MAT(ind,:)=[];
numSessions=[IDacq(IDacq(:,2)~=3,1);IDacq(IDacq(:,2)==3,1)];

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% effect of delay to trigger stim
delays=[20 60 ];%300];
Mat_W=[];
Mat_S=[];
for id=1:length(channelID)
    
    mean_W=nan(length(delays),length(numSessions));
    std_W=mean_W; mean_S=mean_W; std_S=mean_W;
    
    for n=1:length(numSessions)
        temp=MAT(MAT(:,1)==numSessions(n) & MAT(:,4)==channelID(id) , :);
        tW=temp(temp(:,6)==1,:); % snd when awake (sleep cond)
        tS=temp(temp(:,6)==-1,:);% snd when sleeping (wake cond)
        
        % [ hr_of_the_day, delay sound-change, delay lastchange-sound ]
        d_snd_W=[tS(:,3)+tS(:,5)/3600, tS(:,8)-tS(:,5), tS(:,5)-tS(:,7)];
        d_snd_S=[tW(:,3)+tW(:,5)/3600, tW(:,8)-tW(:,5), tW(:,5)-tW(:,7)];
        
        
        if IDacq(IDacq(:,1)==numSessions(n),2)==3
            
            Mat_W=[Mat_W; [ones(size(d_snd_W,1),1)*[channelID(id),numSessions(n),...
                IDacq(IDacq(:,1)==numSessions(n),2)],d_snd_W(:,3),d_snd_W(:,2) ]];
            
            Mat_S=[Mat_S; [ones(size(d_snd_S,1),1)*[channelID(id),numSessions(n),...
                IDacq(IDacq(:,1)==numSessions(n),2)],d_snd_S(:,3),d_snd_S(:,2) ]];
            
        else
            for d=1:length(delays)
                d_W= d_snd_W( abs(d_snd_W(:,3)-delays(d))< 3, : );
                d_S= d_snd_S( abs(d_snd_S(:,3)-delays(d))< 3, : );
                 
                Mat_W=[Mat_W; [ones(size(d_W,1),1)*[channelID(id),numSessions(n),...
                    IDacq(IDacq(:,1)==numSessions(n),2),delays(d)],d_W(:,2) ]];
            
                Mat_S=[Mat_S; [ones(size(d_S,1),1)*[channelID(id),numSessions(n),...
                    IDacq(IDacq(:,1)==numSessions(n),2),delays(d)],d_S(:,2) ]];
               
            end
        end
    end
end  

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% plot indiv data with PlotErrorBarN 
plotindiv=0;
A={'b','t','T'};
colori={'r','b'}; % red for sleep conditioning, blue for wake
if plotindiv
    for id=1:length(channelID)
        figure('Color',[1 1 1]);
        for d=1:length(delays)
            AW=nan(100,sum(IDacq(:,2)~=3)); AS=AW;
            for n=1:sum(IDacq(:,2)~=3)
                ind=find(Mat_W(:,1)==channelID(id) & Mat_W(:,2)==numSessions(n) ...
                    & Mat_W(:,3)~=3 & Mat_W(:,4)==delays(d));
                AW(1:length(ind),n)=Mat_W(ind,5);
                
                ind=find(Mat_S(:,1)==channelID(id) & Mat_S(:,2)==numSessions(n) ...
                    & Mat_S(:,3)~=3 & Mat_S(:,4)==delays(d));
                AS(1:length(ind),n)=Mat_S(ind,5);
            end
            
            subplot(2,length(delays),d), hold on,
            PlotErrorBarN(AS,0,0); ylabel('tdelta snd -> sleep'); ylim([0,(d-1)*300+400])
            hold on, plot(1:sum(IDacq(:,2)~=3),nanmedian(AS),'r','Linewidth',2)
            
            subplot(2,length(delays),length(delays)+d), hold on,
            PlotErrorBarN(AW,0,0); ylabel('tdelta snd -> wake'); ylim([0,400])
            hold on, plot(1:sum(IDacq(:,2)~=3),nanmedian(AW),'r','Linewidth',2)
            
            for i=1:2
                subplot(2,length(delays),(i-1)*length(delays)+d), hold on,
                title(sprintf('#%d Delay %d',channelID(id),delays(d)));
                xlim([0 sum(IDacq(:,2)~=3)+1])
                
                set(gca,'Xtick',1:sum(IDacq(:,2)~=3))
                set(gca,'XtickLabel',A(IDacq(IDacq(:,2)~=3,2)+1))
            end
        end
    end
end
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% plot indiv data  of delay to trigger stim
orderID=[GpW GpS];
figure('Color',[1 1 1],'Unit','normalized','Position',[0.1 0.1 0.4 0.7]);
clrmp=colormap('jet');
for id=1:length(orderID)
    for d=1:length(delays)
        AW=nan(2,length(numSessions)); AS=AW;
        
        for n=1:length(numSessions)
            if n>sum(IDacq(:,2)~=3)
                indW=find(Mat_W(:,1)==orderID(id) & Mat_W(:,2)==numSessions(n));
                indS=find(Mat_S(:,1)==orderID(id) & Mat_S(:,2)==numSessions(n));
            else
                indW=find(Mat_W(:,1)==orderID(id) & Mat_W(:,2)==numSessions(n) & Mat_W(:,4)==delays(d));
                indS=find(Mat_S(:,1)==orderID(id) & Mat_S(:,2)==numSessions(n) & Mat_S(:,4)==delays(d));
            end
            AW(1,n)=nanmean(Mat_W(indW,5));
            AW(2,n)=nanstd(Mat_W(indW,5));
            
            AS(1,n)=nanmean(Mat_S(indS,5));
            AS(2,n)=nanstd(Mat_S(indS,5));
        end
        
        subplot(2,length(delays)+1,d), hold on,
        errorbar(1:sum(IDacq(:,2)~=3),AS(1,1:sum(IDacq(:,2)~=3)),AS(2,1:sum(IDacq(:,2)~=3)),...
            'Color',clrmp(ceil(id*64/(length(channelID)+1)),:))
        title(sprintf('Delay %d',delays(d)));xlim([0 sum(IDacq(:,2)~=3)+1])
        
        subplot(2,length(delays)+1,length(delays)+1+d), hold on,
        errorbar(1:sum(IDacq(:,2)~=3),AW(1,1:sum(IDacq(:,2)~=3)),AW(2,1:sum(IDacq(:,2)~=3)),...
            'Color',clrmp(ceil(id*64/(length(orderID)+1)),:))
        title(sprintf('Delay %d',delays(d)));xlim([0 sum(IDacq(:,2)~=3)+1])
        
    end
    ylabel('tdelta snd -> wake')
    subplot(2,length(delays)+1,d),ylabel('tdelta snd -> sleep');
    
    % add conditioning days
    subplot(2,length(delays)+1,length(delays)+1), hold on,
    ind=sum(IDacq(:,2)~=3)+1:length(numSessions);
    errorbar(ind-min(ind),AS(1,ind),AS(2,ind),'Color',clrmp(ceil(id*64/(length(orderID)+1)),:))
    title('COND (Wake grp)');ylabel('tdelta snd -> sleep');
    
    subplot(2,length(delays)+1,2*length(delays)+2), hold on,
    errorbar(ind-min(ind),AW(1,ind),AW(2,ind),'Color',clrmp(ceil(id*64/(length(orderID)+1)),:))
    title('COND (Sleep grp)');ylabel('tdelta snd -> wake')
end
for d=1:length(delays)
    for i=1:2
        subplot(2,length(delays)+1,(i-1)*(length(delays)+1)+d),
        indB=find(ismember(numSessions,IDacq(IDacq(:,2)==0,1)));%basal
        plot(indB,min(ylim)+zeros(length(indB),1),'o','Color',[0.5 0.5 0.5]);
        indB=find(ismember(numSessions,IDacq(IDacq(:,2)==1,1)));%test0
        plot(indB,min(ylim)+zeros(length(indB),1),'o','Color','m');
        indB=find(ismember(numSessions,IDacq(IDacq(:,2)==2,1)));%test
        plot(indB,min(ylim)+zeros(length(indB),1),'o','Color','r');
    end
end
for id=1:length(orderID), leg{id}=sprintf('#%d',orderID(id));end
legend([leg,'Basal','test0','test'])

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% display
figure('Color',[1 1 1],'Unit','normalized','Position',[0.1 0.1 0.4 0.7]);

for d=1:length(delays)
    AW=nan(length(channelID),length(numSessions));
    AWstd=AW; AS=AW;ASstd=AW;
    for id=1:length(channelID)
        for n=1:length(numSessions)
            if n>sum(IDacq(:,2)~=3)
                indW=find(Mat_W(:,1)==channelID(id) & Mat_W(:,2)==numSessions(n));
                indS=find(Mat_S(:,1)==channelID(id) & Mat_S(:,2)==numSessions(n));
            else
                indW=find(Mat_W(:,1)==channelID(id) & Mat_W(:,2)==numSessions(n) & Mat_W(:,4)==delays(d));
                indS=find(Mat_S(:,1)==channelID(id) & Mat_S(:,2)==numSessions(n) & Mat_S(:,4)==delays(d));
            end
            AW(id,n)=nanmean(Mat_W(indW,5));
            AWstd(id,n)=nanstd(Mat_W(indW,5));
            
            AS(id,n)=nanmean(Mat_S(indS,5));
            ASstd(id,n)=nanstd(Mat_S(indS,5));
        end
    end
    
    for g=1:2
        for n=1:length(numSessions)
            semW(n)=sem(AW(~isnan(AW(:,n)) & gpMice'==g-1,n));
            semS(n)=sem(AS(~isnan(AS(:,n)) & gpMice'==g-1,n));
        end
        
        subplot(2,length(delays)+1,d), hold on,
        errorbar(1:sum(IDacq(:,2)~=3),nanmean(AS(gpMice==g-1,1:sum(IDacq(:,2)~=3)),1),...
            semS(1:sum(IDacq(:,2)~=3)),'.-','Color',colori{g},'Linewidth',2)
        title(['Delay ',num2str(delays(d))])
        ylabel('tdelta snd -> sleep'); ylim([0 (d-1)*200+250]); xlim([0 sum(IDacq(:,2)~=3)+1])
        
        subplot(2,length(delays)+1,length(delays)+1+d), hold on,
        errorbar(1:sum(IDacq(:,2)~=3),nanmean(AW(gpMice==g-1,1:sum(IDacq(:,2)~=3)),1),...
            semW(1:sum(IDacq(:,2)~=3)),'.-','Color',colori{g},'Linewidth',2)
        title(['Delay ',num2str(delays(d))]);
        ylabel('tdelta snd -> wake'); ylim([50 200]); xlim([0 sum(IDacq(:,2)~=3)+1])
        
        % add conditioning days
        subplot(2,length(delays)+1,length(delays)+1), hold on,
        ind=sum(IDacq(:,2)~=3)+1:length(numSessions);
        errorbar(ind-min(ind),nanmean(AS(gpMice==g-1,ind),1),semS(ind),'Color',colori{g},'Linewidth',2)
        title(['COND (wake grp: #',sprintf(' %d',channelID(gpMice==1)),')']);ylabel('tdelta snd -> sleep');
        
        subplot(2,length(delays)+1,2*length(delays)+2), hold on,
        errorbar(ind-min(ind),nanmean(AW(gpMice==g-1,ind),1),semW(ind),'Color',colori{g},'Linewidth',2)
        title(['COND (sleep grp: #',sprintf(' %d',channelID(gpMice==0)),')']);ylabel('tdelta snd -> wake')
        
    end
    for i=1:2
        subplot(2,length(delays)+1,(i-1)*(length(delays)+1)+d),
        indB=find(ismember(numSessions,IDacq(IDacq(:,2)==0,1)));%basal
        plot(indB,min(ylim)+zeros(length(indB),1),'o','Color',[0.5 0.5 0.5]);
        indB=find(ismember(numSessions,IDacq(IDacq(:,2)==1,1)));%test0
        plot(indB,min(ylim)+zeros(length(indB),1),'o','Color','m');
        indB=find(ismember(numSessions,IDacq(IDacq(:,2)==2,1)));%test
        plot(indB,min(ylim)+zeros(length(indB),1),'o','Color','r');
        xlabel('# test trials')
    end
end
legend({'SLEEPgrp','WAKEgrp','BASAL','TEST0','TEST'})

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% Evolution for each mouse,Pooled delay, normalized     
Mat_W=nan(length(channelID),length(numSessions));
Mat_S=Mat_W;
    
for id=1:length(channelID)
    
    for n=1:length(numSessions)
        temp=MAT(MAT(:,1)==numSessions(n) & MAT(:,4)==channelID(id) , :);
        tW=temp(temp(:,6)==1,:);
        tS=temp(temp(:,6)==-1,:);
        
        % [ hr_of_the_day, delay sound-change, delay lastchange-sound ]
        d_snd_W=tS(:,8)-tS(:,5);
        d_snd_S=tW(:,8)-tW(:,5);
        
        Mat_W(id,n)=nanmean(d_snd_W);
        Mat_S(id,n)=nanmean(d_snd_S);
    end
end

% display
figure('Color',[1 1 1]); 

W=10*log10(Mat_W./ (nanmean(Mat_W,2)*ones(1,length(numSessions))));
S=10*log10(Mat_S./ (nanmean(Mat_S,2)*ones(1,length(numSessions))));

for id=1:length(channelID)
    subplot(2,2,1),hold on,
    plot(1:length(numSessions),Mat_W(id,:),'.-','Color',colori{gpMice(id)+1},'Linewidth',2);
    plot(find(IDacq(2,:)==3),Mat_W(id,find(IDacq(2,:)==3)),'ok','MarkerFaceColor',colori{gpMice(id)+1})
    ylabel('tdelta (s)');title('snd -> wake')
    subplot(2,2,3),hold on,
    plot(1:length(numSessions),Mat_S(id,:),'.-','Color',colori{gpMice(id)+1},'Linewidth',2)
    plot(find(IDacq(2,:)==3),Mat_S(id,find(IDacq(2,:)==3)),'ok','MarkerFaceColor',colori{gpMice(id)+1})
    ylabel('tdelta (s)');title('snd -> sleep')
    
    subplot(2,2,2),hold on,
    plot(1:length(numSessions),W(id,:),'.-','Color',colori{gpMice(id)+1},'Linewidth',2);
    plot(find(IDacq(2,:)==3),W(id,find(IDacq(2,:)==3)),'ok','MarkerFaceColor',colori{gpMice(id)+1})
    ylabel('10*log(tdelta) NORM');title('snd -> wake')
    subplot(2,2,4),hold on,
    plot(1:length(numSessions),S(id,:),'.-','Color',colori{gpMice(id)+1},'Linewidth',2)
    plot(find(IDacq(2,:)==3),S(id,find(IDacq(2,:)==3)),'ok','MarkerFaceColor',colori{gpMice(id)+1})
    ylabel('10*log(tdelta) NORM');title('snd -> sleep')
    
end

%% Compute Sem
for n=1:length(numSessions)
    semW0(n)=sem(Mat_W(~isnan(Mat_W(:,n)) & gpMice'==0,n));
    semS0(n)=sem(Mat_S(~isnan(Mat_S(:,n)) & gpMice'==0,n));
    semW1(n)=sem(Mat_W(~isnan(Mat_W(:,n)) & gpMice'==1,n));
    semS1(n)=sem(Mat_S(~isnan(Mat_S(:,n)) & gpMice'==1,n));
    
    
    semW0norm(n)=sem(W(~isnan(W(:,n)) & gpMice'==0,n));
    semS0norm(n)=sem(S(~isnan(S(:,n)) & gpMice'==0,n));
    semW1norm(n)=sem(W(~isnan(W(:,n)) & gpMice'==1,n));
    semS1norm(n)=sem(S(~isnan(S(:,n)) & gpMice'==1,n));
end
        
%%
% display
figure('Color',[1 1 1]);

subplot(2,2,1), hold on,
% errorbar(1:length(numSessions),nanmean(Mat_S(gpMice==0,:),1),std(Mat_S(gpMice==0,:)),'.-r','Linewidth',2)
% errorbar(1:length(numSessions),nanmean(Mat_S(gpMice==1,:),1),std(Mat_S(gpMice==1,:)),'.-b','Linewidth',2)
errorbar(1:length(numSessions),nanmean(Mat_S(gpMice==0,:),1),semS0,'.-r','Linewidth',2)
errorbar(1:length(numSessions),nanmean(Mat_S(gpMice==1,:),1),semS1,'.-b','Linewidth',2)
title('Delay snd -> sleep')
ylabel('tdelta (s) btw snd & sleep')
 ylim([0 400]); xlim([0 length(numSessions)])
 
subplot(2,2,3), hold on,
% errorbar(1:length(numSessions),nanmean(Mat_W(gpMice==0,:),1),std(Mat_W(gpMice==0,:)),'.-r','Linewidth',2)
% errorbar(1:length(numSessions),nanmean(Mat_W(gpMice==1,:),1),std(Mat_W(gpMice==1,:)),'.-b','Linewidth',2)
errorbar(1:length(numSessions),nanmean(Mat_W(gpMice==0,:),1),semW0,'.-r','Linewidth',2)
errorbar(1:length(numSessions),nanmean(Mat_W(gpMice==1,:),1),semW1,'.-b','Linewidth',2)
title('Delay snd -> wake')
ylabel('tdelta (s) btw snd & wake')
xlabel('# test trials') 
ylim([0 400]); xlim([0 length(numSessions)])

subplot(2,2,2), hold on,
% errorbar(1:length(numSessions),nanmean(Mat_S(gpMice==0,:),1),std(Mat_S(gpMice==0,:)),'.-r','Linewidth',2)
% errorbar(1:length(numSessions),nanmean(Mat_S(gpMice==1,:),1),std(Mat_S(gpMice==1,:)),'.-b','Linewidth',2)
errorbar(1:length(numSessions),nanmean(S(gpMice==0,:),1),semS0norm,'.-r','Linewidth',2)
errorbar(1:length(numSessions),nanmean(S(gpMice==1,:),1),semS1norm,'.-b','Linewidth',2)
title('Delay snd -> sleep')
ylabel('10*log(tdelta) NORM within mouse')
xlim([0 length(numSessions)])
 
subplot(2,2,4), hold on,
% errorbar(1:length(numSessions),nanmean(Mat_W(gpMice==0,:),1),std(Mat_W(gpMice==0,:)),'.-r','Linewidth',2)
% errorbar(1:length(numSessions),nanmean(Mat_W(gpMice==1,:),1),std(Mat_W(gpMice==1,:)),'.-b','Linewidth',2)
errorbar(1:length(numSessions),nanmean(W(gpMice==0,:),1),semW0norm,'.-r','Linewidth',2)
errorbar(1:length(numSessions),nanmean(W(gpMice==1,:),1),semW1norm,'.-b','Linewidth',2)
title('Delay snd -> wake')
ylabel('10*log(tdelta) NORM within mouse')
xlabel('# test trials') 
xlim([0 length(numSessions)])
legend([{['Cond sleep (n=',num2str(length(find(gpMice==0))),', #',sprintf(' %d',channelID(gpMice==0)),')']},...
    {['Cond wake (n=',num2str(sum(gpMice)),', #',sprintf(' %d',channelID(gpMice==1)),')']},'Basal Expe'])








