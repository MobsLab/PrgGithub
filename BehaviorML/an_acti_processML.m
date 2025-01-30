%  an_acti_processML.m
%
% other related scripts and functions :
%   - AnalyseActimeterML.m
%   - ActimetrySleepScorCompar.m
%   - ActiToData.m
%   - PoolDataActi.m
%   - ActimetryQuantifSleep.m
%   - GetAllDataActi.m
%   - an_actiML_quantifSleep.m
%   - an_acti_StatDistribML.m
%   - an_acti_delayML.m
%   - an_actiML_quantifStimML.m%
%   - an_actiML.m
%   - an_acti_process2ML.m

%% inputs
PeriodDay=[10.5,19]; % btw 10h30 & 19h for Expe1, 9h30 & 18h for Expe2
hON=[8,9]; % in MATinfo(:,1);

%% Acquisition identities

[MATinfo,nameAcq]=getActiID;


%% Analyname
res='/media/DataMOBsRAID/ProjetSLEEPActi/Analysis';
cd(res);
analyname='an_acti_delay_ALL.mat';



%% Load entire or part, if exists
try
    temp=load(analyname,'MATinfo','MAT','MATscor');
    if isequal(MATinfo,temp.MATinfo)
        disp([analyname,' already exists... loading...'])
        load(analyname);doMat=[];
        MAT=temp.MAT; MATscor=temp.MATscor;
    else
        disp([analyname,' uncomplete... loading partial file...'])
        MAT=temp.MAT;
        indExist=nan(1,size(MATinfo,2));
        MATscor=[];
        for i=1:size(MATinfo,2)
            for j=1:size(temp.MATinfo,2)
                if isequal(temp.MATinfo(j,:),MATinfo(i,:))
                    indExist(i)=j;
                    ti=find(temp.MATscor(:,1)==j);
                    MATscor=[MATscor;[ones(length(ti),1)*i,temp.MATscor(ti,2:end)]];
                end
            end
        end
        doMat=find(isnan(indExist));
    end
catch
    MAT=[];MATscor=[];
    doMat=1:size(MATinfo,1);
end


    
%% Compute
temp_i=[0 0];
for i=doMat
    try
        clear a d date_a dur_Rec hr_startRec
        
        %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        % Load data
        a = Activity_linux(MATinfo(i,1),MATinfo(i,2), MATinfo(i,4));
        
        if ~isequal(temp_i,[MATinfo(i,1),MATinfo(i,2)]), clear hr_startRec;end
        temp_i=[MATinfo(i,1),MATinfo(i,2)];
        
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
        
        
        %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        % Get % of sleep
        % a.durationOf(a.SWc.IS_SLEEPING);
        t_temp=timeStamps'+round(3600*(hr_startRec-hON(MATinfo(i,1))));
        ind=[find(rem(t_temp,3600)==0);max(timeStamps)];

        sleepdur= a.durationOf(a.SWc.IS_SLEEPING, 'm', 1:ind(1)-1);
        tempMATscor=[i,mod(floor(t_temp(1)/3600),24),length(1:ind(1)-1),sleepdur];
        % rest of hour
        for tt=1:length(ind)-1
            sleepdur= a.durationOf(a.SWc.IS_SLEEPING, 'm', ind(tt):ind(tt+1)-1);
            tempMATscor=[tempMATscor;[i,mod(round(t_temp(ind(tt))/3600),24),length(ind(tt):ind(tt+1)-1),sleepdur]];
        end
        
        %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        % get time of sound stim
        % discard lost mice
        
        evt_stimTimeStamps=[];
        if MATinfo(i,3)>0
            evt_stimTimeStamps = a.timeStamps_evt(a.evts == a.SWc.EVT_SOUND_STIM);
        elseif MATinfo(i,3)==0
            fprintf('BASAL: Simulate a probe test.\n');
            % get epochs corresponding to PeriodDay
            PD=PeriodDay-MATinfo(i,1)+1;
            ind1=find(abs(mod(hr_startRec+timeStamps/3600,24)-PD(1))< 1/3600);
            ind2=find(abs(mod(hr_startRec+timeStamps/3600,24)-PD(2))< 1/3600);
            % get start and stop if inside PeriodDay
            if isempty(ind1) && hr_startRec>PD(1) && hr_startRec<PD(2), ind1=1;end
            hrfin=mod(hr_startRec+timeStamps(end)/3600,24);
            if isempty(ind2) && hrfin>PD(1) && hrfin<PD(2), ind2=length(timeStamps);end
            
            ind1(diff(ind1)==1)=[]; ind2(diff(ind2)==1)=[];
            if ind1(1)>ind2(1), ind1=[1,ind1];end
            if ind2(end)<ind1(end), ind2=[ind2,length(timeStamps)];end
            for nd=1:length(ind1)
                if MATinfo(i,3)==0 %basal
                    evt_temp= getStimulationAsAProbeTest(sleepScoring(ind1(nd):ind2(nd)), a.activity(ind1(nd):ind2(nd)),...
                        timeStamps(ind1(nd):ind2(nd))-timeStamps(ind1(nd)), a.SWc)'+timeStamps(ind1(nd));
                    evt_stimTimeStamps=[evt_stimTimeStamps;evt_temp];
                end
            end
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
        if ~isempty(evt_stimTimeStamps)
            tempMAT = ones(length(evt_stimTimeStamps),1)*[temp_i hr_startRec MATinfo(i,6)];
            tempMAT = [tempMAT , evt_stimTimeStamps, sleepScoring(evt_stimTimeStamps)', delay_chg];
            
            MAT=[MAT; tempMAT];
        end
        MATscor=[MATscor;tempMATscor];
    catch
        keyboard
    end
end
% save
if ~isempty(doMat)
    disp(['...Saving in ',analyname])
    save(analyname,'MAT','MATinfo','MATscor');
end
keyboard


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<  add night after COND <<<<<<<<<<<<<<<<<<<<<<<<<<<
% night afer conditioning, = 5
for num=1:length(unique(MATinfo(:,1)))
    val=unique(MATinfo(MATinfo(:,3)==3 & MATinfo(:,1)==num,2));
    MATinfo(ismember(MATinfo(:,2),val+1) & MATinfo(:,1)==num & isnan(MATinfo(:,3)),3)=5;
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<  Display ALL day <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
colori={'b','m','r','g','k','y'};
numMice=unique(MATinfo(:,6))';
numMice(numMice==5)=[];
%numMice=[1:4,6:8,10:17,19,20,23,26,27,30,33,34,36];
numMice=[numMice;nan(3,length(numMice))];
for mi=1:size(numMice,2)
    numMice(2,mi)=unique(MATinfo(MATinfo(:,6)==numMice(1,mi),5));
    numMice(3,mi)=unique(MATinfo(MATinfo(:,6)==numMice(1,mi),1));
    numMice(4,mi)=unique(MATinfo(MATinfo(:,6)==numMice(1,mi),4));
end
numMice=sortrows(numMice',2);
typExpe=unique(MATinfo(~isnan(MATinfo(:,3)),3));
nameGroup={'S','W'};colorgp={'r','b'};

H=unique(MATscor(:,2));
figure('Color',[1 1 1])
stdA={};
for mi=1:length(numMice)
    temp1=nan(length(typExpe),length(H));
    std1=temp1;
    subplot(4,ceil(length(numMice)/4),mi)
    leg={};
    for t=1:length(typExpe)
        ind1=find(MATinfo(:,6)==numMice(mi) & MATinfo(:,3)==typExpe(t));
        temp2=MATscor(find(ismember(MATscor(:,1),ind1)),:);
        temp2=temp2(temp2(:,3)>20*60,:);
        for h=1:length(H)
            val=100*60*temp2(temp2(:,2)==H(h),4)./temp2(temp2(:,2)==H(h),3);
            temp1(t,h)=nanmedian(val);
            std1(t,h)=nanstd(val)/sqrt(length(val));
        end
        hold on, plot(H,temp1(t,:),'Color',colori{t},'Linewidth',2)
        %if t==4,keyboard;end
    end
    stdA(mi,1:2)={std1,temp1};
    gp=unique(MATinfo(MATinfo(:,6)==numMice(mi),5));
    title([nameGroup(gp+1),sprintf(' Mouse #%d',numMice(mi))],'Color',[1-gp 0 gp])
    xlabel('Time from Day Start (h)'); xlim([0,24])
    ylim([0 100])
end

legend({'BASAL','TEST0','TEST','COND','TESTFinal','PostCOND'});
for mi=1:length(numMice)
    subplot(4,ceil(length(numMice)/4),mi)
    for t=1:length(typExpe)
        hold on, plot(H,stdA{mi,2}(t,:)+ stdA{mi,1}(t,:),'Color',colori{t})
        hold on, plot(H,stdA{mi,2}(t,:)- stdA{mi,1}(t,:),'Color',colori{t})
    end
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<< evol of sleep, per expe type <<<<<<<<<<<<<<<<<<<<<<<<<
nameAcq={'BASAL','TEST0','TEST','COND','TESTFinal','PostCOND'};
A=zeros(length(numMice),max(MATinfo(:,2)));
leg={};
for mi=1:length(numMice)
    temp1=MATinfo(MATinfo(:,6)==numMice(mi),2:3);
    temp1=sortrows(temp1,1);
    A(mi,temp1(:,1)+1)=2*temp1(:,2)+2;
    leg{mi}=sprintf('%d',numMice(mi));
end
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.3 0.15 0.3 0.7]), hold on,
imagesc(1:length(numMice),1:max(MATinfo(:,2)),A'); axis xy
for mi=1:length(numMice)-1
    if mi<length(numMice)-1 && numMice(mi+1)< numMice(mi)
        line([mi mi]+0.5,[0 max(MATinfo(:,2))],'color','w','Linewidth',5);
    else
        line([mi mi]+0.5,[0 max(MATinfo(:,2))],'color','w');
    end
end
ylabel('#expe'); xlabel('# mouse'); ylim([0 max(MATinfo(:,2))+1])
set(gca,'Xtick',1:length(numMice));set(gca,'XtickLabel',leg);
colorbar('YTickLabel',['NaN',nameAcq]); 
title('group SLEEP COND                                   group WAKE COND')

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<< get equivalent expe for all batch <<<<<<<<<<<<<<<<<<<<
InfoMiceExpe=[];
for mi=1:length(numMice)
    % days and ExpeType
    temp1=MATinfo(MATinfo(:,6)==numMice(mi),2:3);
    % add TEST0
    Infotemp=temp1(temp1(:,2)==1,:);% test0 days
    Infotemp=[Infotemp,zeros(size(Infotemp,1),1),[1:size(Infotemp,1)]'];
    % TEST
    TestExpe=temp1(temp1(:,2)==2,1); %find test days
    if ~isempty(TestExpe)
        % add BASAL before first test
        temp2=temp1(temp1(:,2)==0 & temp1(:,1)<min(TestExpe),:);
        Infotemp=[Infotemp;[temp2,zeros(size(temp2,1),1),[1:size(temp2,1)]']];
        %
        Expe=[1, TestExpe', max(MATinfo(:,2))];
        for t=2:length(Expe)-1
            % get COND before TEST
            temp2=temp1(temp1(:,2)==3 & temp1(:,1)<Expe(t) & temp1(:,1)>Expe(t-1),:);
            Infotemp=[Infotemp;[temp2,zeros(size(temp2,1),1)+t-1],[1:size(temp2,1)]'];
            % get postCOND before TEST
            temp2=temp1(temp1(:,2)==5 & temp1(:,1)<Expe(t) & temp1(:,1)>Expe(t-1),:);
            Infotemp=[Infotemp;[temp2,zeros(size(temp2,1),1)+t-1],[1:size(temp2,1)]'];
            % get TEST
            Infotemp=[Infotemp;[Expe(t),2,t-1,1]];
            % get BASAL post TEST
            temp2=temp1(temp1(:,2)==0 & temp1(:,1)<Expe(t+1) & temp1(:,1)>Expe(t),:);
            Infotemp=[Infotemp;[temp2,zeros(size(temp2,1),1)+t-1],[1:size(temp2,1)]'];
        end
        InfoMiceExpe=[InfoMiceExpe; [zeros(size(Infotemp,1),1)+numMice(mi),Infotemp]];
    end
end

% Order expe per type and order of occurance
uniqTyp=unique(InfoMiceExpe(:,3));
uniqLink=unique(InfoMiceExpe(:,4));
uniqNum=unique(InfoMiceExpe(:,5));
ALLMat=nan(length(numMice),length(uniqTyp)*length(uniqLink)*length(uniqNum));
ALLMatInfo=nan(3,length(uniqTyp)*length(uniqLink)*length(uniqNum));
for mi=1:length(numMice)
    for t=1:length(uniqTyp)
        for l=1:length(uniqLink)
            for n=1:length(uniqNum)
                ind=find(InfoMiceExpe(:,1)==numMice(mi) & InfoMiceExpe(:,3)==uniqTyp(t) ...
                    & InfoMiceExpe(:,4)==uniqLink(l) & InfoMiceExpe(:,5)==uniqNum(n));
                
                if ~isempty(ind)
                    
                    ind2=(t-1)*length(uniqLink)*length(uniqNum)+(l-1)*length(uniqNum)+n;
                    ALLMat(mi,ind2)=InfoMiceExpe(ind,2);
                
                    if isnan(nanmean(ALLMatInfo(:,ind2)))
                        ALLMatInfo(:,ind2)=[uniqTyp(t);uniqLink(l);uniqNum(n)];
                    end
                
                end
            end
        end
    end
end
% ALLMatInfo : Type Of Expe, #week, num
% for each mouse, ALLMat gives # of equivalent expe
ALLMatInfo(:,isnan(nanmean(ALLMat,1)))=[];
ALLMat(:,isnan(nanmean(ALLMat,1)))=[];

% display actimetry for all Expetype across expe
% order per block/week
ALLM=[ALLMatInfo',ALLMat'];
ALLM=sortrows(ALLM,2)';
ALLMatInfo=ALLM(1:3,:);
ALLMat=ALLM(4:end,:);

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.2 0.15 0.4 0.5]),
for g=1:2
    A=nan(size(ALLMat,2),length(H));
    % get mice of one group
    numg=find(numMice(:,2)==g-1);
    for t=1:size(ALLMat,2) % all expe type
        
        Atemp=nan(length(numg),length(H));
        for mi=1:length(numg)
            numExpe=ALLMat(numg(mi),t);
            ind1=find(MATinfo(:,6)==numMice(numg(mi),1) & MATinfo(:,2)==numExpe);
                %& MATinfo(:,1)==floor(numMice(numg(mi))/13)+1);
            if ~isnan(numExpe) && ~isempty(ind1)
                temp2=MATscor(MATscor(:,1)==ind1,:);
                temp2=temp2(temp2(:,3)>20*60,:);
                for h=1:length(H)
                    Atemp(mi,h)=nanmean(100*60*temp2(temp2(:,2)==H(h),4)./temp2(temp2(:,2)==H(h),3));
                end
                %disp(sprintf('Mouse #%d: expe #%d',numMice(numg(mi)),numExpe));
            end
        end
        A(t,:)=nanmean(Atemp,1);
    end
    
    A(isnan(A))=-20;
    subplot(1,2,g)
    hold on, imagesc(H+0.5,1:size(ALLMat,2),A); axis xy
    xlim([0 24]); caxis([-20 100]); ylim([0,size(ALLMat,2)+1])
    if g==1, title('SLEEP group');else, title('WAKE group');end
    xlabel('Time from LIGHT ONSET (h)'); ylabel('# expe');
    ind2=find(diff(ALLMatInfo(1,:))~=0);
    for i=1:length(ind2), line([0 24],[0 0]+ind2(i)+0.5,'Color','w','Linewidth',2);end
    set(gca,'Ytick',[0,ind2]+diff([0,ind2,size(ALLMat,2)])/2), set(gca,'YtickLabel',nameAcq(ALLMatInfo(1,ind2)+1))
end

%% display actimetry across all experiment (NOT WORKING)

numBlock=unique(ALLMatInfo(2,:));% Week number
a=ones(3,1)*numBlock; a=a(:);
b=[1:3]'*ones(1,length(numBlock));b=b(:);
numExpe=[a,b];


Mat_W=[];
Mat_S=[];
for mi=1:length(numMice)
    a=0;
    for t=1:length(numBlock)
        % get TEST days, and following BASAL
        i_T=find(ALLMatInfo(2,:)==numBlock(t) & ismember(ALLMatInfo(1,:),[1,2]));% TEST
        i_T=i_T(~isnan(ALLMat(mi,i_T)));
        i_B=find(ALLMatInfo(2,:)==numBlock(t) & ALLMatInfo(1,:)==0);% BASAL
        i_B=i_B(~isnan(ALLMat(mi,i_B)));
        if ~isempty(i_B) && ~isempty(i_T)
            i_B=i_B(end-length(i_T)+1:end);
            
            temp=MAT(MAT(:,4)==numMice(mi,1) & ismember(MAT(:,2),[ALLMat(mi,i_T),ALLMat(mi,i_B)]),:);
            tW=temp(temp(:,6)==1,:); % snd when awake (sleep cond)
            tS=temp(temp(:,6)==-1,:);% snd when sleeping (wake cond)
            
            % [ hr_of_the_day, delay sound-change, delay lastchange-sound ]
            d_snd_W=[tS(:,2) tS(:,3)+tS(:,5)/3600, tS(:,8)-tS(:,5), tS(:,5)-tS(:,7)];
            d_snd_S=[tW(:,2) tW(:,3)+tW(:,5)/3600, tW(:,8)-tW(:,5), tW(:,5)-tW(:,7)];
            
            for i=1:length(i_T)
                a=a+1;
                delays=20;
                b=find(numExpe(:,1)==numBlock(t) & numExpe(:,2)==i);
                % TEST
                d_W= d_snd_W(d_snd_W(:,1)==ALLMat(mi,i_T(i)) & abs(d_snd_W(:,4)-delays)< 3, 2:3 );
                d_S= d_snd_S(d_snd_S(:,1)==ALLMat(mi,i_T(i)) & abs(d_snd_S(:,4)-delays)< 3, 2:3 );
                Mat_W=[Mat_W; [ones(size(d_W,1),1)*[numMice(mi,1),ALLMat(mi,i_T(i)),ALLMatInfo(1,i_T(i)),b],d_W(:,2) ]];
                Mat_S=[Mat_S; [ones(size(d_S,1),1)*[numMice(mi,1),ALLMat(mi,i_T(i)),ALLMatInfo(1,i_T(i)),b],d_S(:,2) ]];
                % BASAL
                d_W= d_snd_W(d_snd_W(:,1)==ALLMat(mi,i_B(i)) & abs(d_snd_W(:,4)-delays)< 3, 2:3 );
                d_S= d_snd_S(d_snd_S(:,1)==ALLMat(mi,i_B(i)) & abs(d_snd_S(:,4)-delays)< 3, 2:3 );
                Mat_W=[Mat_W; [ones(size(d_W,1),1)*[numMice(mi,1),ALLMat(mi,i_B(i)),ALLMatInfo(1,i_B(i)),b],d_W(:,2) ]];
                Mat_S=[Mat_S; [ones(size(d_S,1),1)*[numMice(mi,1),ALLMat(mi,i_B(i)),ALLMatInfo(1,i_B(i)),b],d_S(:,2) ]];
            end
        end
    end
end

% display INDIVIDUAL curves
numBlock=unique([Mat_W(:,4);Mat_S(:,4)]);
plotindiv=0;
if plotindiv
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.2 0.15 0.4 0.7]), numF1=gcf;
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.2 0.15 0.4 0.7]), numF2=gcf;
end

A=[];
for mi=1:length(numMice)
    Atemp=nan(length(numBlock),6);
    Stemp=Atemp;
    for t=1:length(numBlock)
        for i=1:3 % BASAL - TEST0 - TEST
            
            % snd->wake
            i_W=find(Mat_W(:,1)==numMice(mi) & Mat_W(:,3)==i-1 & Mat_W(:,4)==numBlock(t));
            if ~isempty(i_W)
                Atemp(t,2*(i-1)+1)=nanmean(Mat_W(i_W,5));
                Stemp(t,2*(i-1)+1)=nanstd(Mat_W(i_W,5))/sqrt(length(i_W));
            end
            
            % snd->sleep
            i_S=find(Mat_S(:,1)==numMice(mi) & Mat_S(:,3)==i-1 & Mat_S(:,4)==numBlock(t));
            if ~isempty(i_S)
                Atemp(t,2*(i-1)+2)=nanmean(Mat_S(i_S,5));
                Stemp(t,2*(i-1)+2)=nanstd(Mat_S(i_S,5))/sqrt(length(i_S));
            end
            
            A=[A;[numMice(mi),numBlock(t),i,Atemp(t,2*(i-1)+1),Atemp(t,2*(i-1)+2)]];
        end
    end
    Stemp(isnan(nanmean(Atemp,2)),:)=[];
    Atemp(isnan(nanmean(Atemp,2)),:)=[];
    
    if plotindiv
        % snd->wake
        figure(numF1), subplot(4,ceil(length(numMice)/4),mi), hold on,
        errorbar(1:size(Atemp,1),Atemp(:,1),Stemp(:,1),'Color','k','Linewidth',2)% BASAL
        errorbar(1:size(Atemp,1),Atemp(:,3),Stemp(:,3),'Color','g','Linewidth',2)% test0 et Test
        errorbar(1:size(Atemp,1),Atemp(:,5),Stemp(:,5),'Color',[1-numMice(mi,2) 0 numMice(mi,2)],'Linewidth',2)% test0 et Test
        title(sprintf(' Mouse #%d',numMice(mi)),'Color',[1-numMice(mi,2) 0 numMice(mi,2)])
        if mi==1,ylabel('Delay Sound -> wake');end; ylim([0 200])
        if mi==length(numMice), legend({'BASAL','TEST0','TEST'});end
        
        % snd->sleep
        figure(numF2), subplot(4,ceil(length(numMice)/4),mi), hold on,
        errorbar(1:size(Atemp,1),Atemp(:,2),Stemp(:,2),'Color','k','Linewidth',2)% BASAL
        errorbar(1:size(Atemp,1),Atemp(:,4),Stemp(:,4),'Color','g','Linewidth',2)% test0 et Test
        errorbar(1:size(Atemp,1),Atemp(:,6),Stemp(:,6),'Color',[1-numMice(mi,2) 0 numMice(mi,2)],'Linewidth',2)% test0 et Test
        title(sprintf(' Mouse #%d',numMice(mi)),'Color',[1-numMice(mi,2) 0 numMice(mi,2)])
        if mi==1, ylabel('Delay Sound -> sleep');end; ylim([0 400])
        if mi==length(numMice), legend({'BASAL','TEST0','TEST'});end
    end    
end
% display pooled per expe
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.2 0.15 0.5 0.5])
colori={'r','b'};
leg={'BASAL',' ','TEST0 / TEST'};
for g=1:2
    % get mice of one group
    numg=numMice(numMice(:,2)==g-1,1);
    
    for i=1:3
        for t=1:length(numBlock)
            ind=find(ismember(A(:,1),numg) & A(:,2)==numBlock(t) & A(:,3)==i);
            temp(1:2,t)=[nanmean(A(ind,4));nanmean(A(ind,5))];
            temp(3,t)=nanstd(A(ind,4))/sqrt(sum(~isnan(A(ind,4))));
            temp(4,t)=nanstd(A(ind,5))/sqrt(sum(~isnan(A(ind,5))));
        end
        subplot(2,4,min(i,2)),
        hold on, errorbar(1:size(temp,2),temp(1,:),temp(3,:),'Color',colori{g},'Linewidth',2)
        title([leg{i},'   Delay sound -> wake']); ylim([60 200])
        subplot(2,4,4+min(i,2)),
        hold on, errorbar(1:size(temp,2),temp(2,:),temp(4,:),'Color',colori{g},'Linewidth',2)
        title([leg{i},'   Delay sound -> sleep']);ylim([0 200])
        
        subplot(2,4,2+g),
        hold on, errorbar(1:size(temp,2),temp(1,:),temp(3,:),'Color',colori{g},'Linewidth',i)
        title([leg{i},'   Delay sound -> wake']);ylim([60 200])
        subplot(2,4,6+g),
        hold on, errorbar(1:size(temp,2),temp(2,:),temp(4,:),'Color',colori{g},'Linewidth',i)
        title([leg{i},'   Delay sound -> sleep']) ;ylim([0 200])
    end
end
legend({'BASAL','TEST0','TEST'})
subplot(2,4,7),legend({'BASAL','TEST0','TEST'})
subplot(2,4,1),legend({'SLEEP grp','WAKE grp'})


%% display normalized result, evolved across expe, pooled per group
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.2 0.15 0.5 0.5])
colori={'r','b'};
leg={'BASAL',' ','TEST0 & TEST'};
for g=1:2
    % get mice of one group
    numg=numMice(numMice(:,2)==g-1,1);
    for i=1:3
        for t=1:length(numBlock)
            mitemp=nan(length(numg),2);
            for mi=1:length(numg)
                %ind1=find(A(:,1)==numg(mi) & A(:,2)==numBlock(t) & A(:,3)==1); namelegadd='each';
                ind1=find(A(:,1)==numg(mi) & A(:,2)==numBlock(1) & A(:,3)==1);namelegadd='first';
                ind2=find(A(:,1)==numg(mi) & A(:,2)==numBlock(t) & A(:,3)==i);
                if ~isempty(ind1) && ~isempty(ind2)
                    %mitemp(mi,1:2)=A(ind2,4:5)./A(ind1,4:5); nameleg=['Normalized TEST/',namelegadd,'BASAL'];
                    mitemp(mi,1:2)=A(ind2,4:5)-A(ind1,4:5); nameleg=['Normalized TEST-',namelegadd,'BASAL'];
                end
            end
            temp(1:2,t)=nanmean(mitemp,1);
            temp(3:4,t)=nanstd(mitemp);
        end
        if i>1
            subplot(2,3,min(i,2)-1),
            hold on, errorbar(1:size(temp,2),temp(1,:),temp(3,:),'Color',colori{g},'Linewidth',2)
            title([leg{i},'   Delay sound -> wake']);%ylim([0 2])
            subplot(2,3,3+min(i,2)-1),
            hold on, errorbar(1:size(temp,2),temp(2,:),temp(4,:),'Color',colori{g},'Linewidth',2)
            title([leg{i},'   Delay sound -> sleep']);%ylim([-1.5 4])
        end
        subplot(2,3,1+g),
        hold on, errorbar(1:size(temp,2),temp(1,:),temp(3,:),'Color',colori{g},'Linewidth',i)
        title([leg{i},'   Delay sound -> wake']); %ylim([0 2])
        subplot(2,3,4+g),
        hold on, errorbar(1:size(temp,2),temp(2,:),temp(4,:),'Color',colori{g},'Linewidth',i)
        title([leg{i},'   Delay sound -> sleep']) ;%ylim([-1.5 4])
    end
    
end
legend({'BASAL','TEST0','TEST'})
subplot(2,3,5),legend({'BASAL','TEST0','TEST'})
subplot(2,3,1),legend({'SLEEP grp',sprintf('n=%d',sum(numMice(:,2)==0)),'WAKE grp',sprintf('n=%d',sum(numMice(:,2)==1))})
ylabel(nameleg)


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% INDIVIDUAL! effect of delay to trigger stim
delays=[20 60 ];%300];
Mat_W=[];
Mat_S=[];

for mi=1:length(numMice)
    numSessions=unique(MATinfo(MATinfo(:,6)==numMice(mi,1),2));
    
    % sort sessions
    temp=nan(length(numSessions),2);
    for n=1:length(numSessions),
        ind=find(MATinfo(:,6)==numMice(mi,1) & MATinfo(:,2)==numSessions(n));
        temp(n,1:2)=[numSessions(n), unique(MATinfo(ind,3))];
    end
    temp=sortrows(temp,2);
    numSessions=temp(:,1);
    
    for n=1:length(numSessions)
        typeExpe=MATinfo(MATinfo(:,6)==numMice(mi,1) & MATinfo(:,2)==numSessions(n),3);
        %if typeExpe==1; keyboard;end
        temp=MAT(MAT(:,2)==numSessions(n) & MAT(:,4)==numMice(mi,1), :);
        tW=temp(temp(:,6)==1,:); % snd when awake (sleep cond)
        tS=temp(temp(:,6)==-1,:);% snd when sleeping (wake cond)
        
        % [ hr_of_the_day, delay sound-change, delay lastchange-sound ]
        d_snd_W=[tS(:,3)+tS(:,5)/3600, tS(:,8)-tS(:,5), tS(:,5)-tS(:,7)];
        d_snd_S=[tW(:,3)+tW(:,5)/3600, tW(:,8)-tW(:,5), tW(:,5)-tW(:,7)];
        
        
        if typeExpe==3 % COND
            
            Mat_W=[Mat_W; [ones(size(d_snd_W,1),1)*[numMice(mi,1),numSessions(n),3],...
                d_snd_W(:,3),d_snd_W(:,2) ]];
            
            Mat_S=[Mat_S; [ones(size(d_snd_S,1),1)*[numMice(mi,1),numSessions(n),3],...
                d_snd_S(:,3),d_snd_S(:,2) ]];
            
        elseif ismember(typeExpe,[0 1 2])
            for d=1:length(delays)
                d_W= d_snd_W( abs(d_snd_W(:,3)-delays(d))< 3, : );
                d_S= d_snd_S( abs(d_snd_S(:,3)-delays(d))< 3, : );
                 
                Mat_W=[Mat_W; [ones(size(d_W,1),1)*[numMice(mi,1),numSessions(n),...
                    typeExpe,delays(d)],d_W(:,2) ]];
            
                Mat_S=[Mat_S; [ones(size(d_S,1),1)*[numMice(mi,1),numSessions(n),...
                    typeExpe,delays(d)],d_S(:,2) ]];
               
            end
        end
    end
end  
%% display
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.05 0.5 0.8]); numF1=gcf;
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.05 0.5 0.8]); numF2=gcf;
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.05 0.5 0.8]); numF3=gcf;

DB=nan(length(numMice),3); DC=DB;
for mi=1:length(numMice)
    % define # session for this mouse
    [numSessions,iA]=unique(Mat_W(Mat_W(:,1)==numMice(mi,1) & Mat_W(:,3)~=3,2));
    temp=[numSessions,iA]; temp=sortrows(temp,2);numSessions=temp(:,1);
    
    A=nan(length(numSessions),5);
    B=nan(length(numSessions),100); C=B;
    for n=1:length(numSessions)
        % delay to WAKE
        indW=find(Mat_W(:,1)==numMice(mi,1) & Mat_W(:,2)==numSessions(n) & Mat_W(:,4)==20);
        B(n,1:length(indW))=Mat_W(indW,5)';
        if ~isempty(indW)
            A(n,2)=nanmean(Mat_W(indW,5));
            if length(indW)>1, A(n,3)=nanstd(Mat_W(indW,5));end
        end
        
        % delay to SLEEP
        indS=find(Mat_S(:,1)==numMice(mi,1) & Mat_S(:,2)==numSessions(n) & Mat_S(:,4)==20);
        C(n,1:length(indS))=Mat_S(indS,5)';
        if ~isempty(indS)
            A(n,4)=nanmean(Mat_S(indS,5));
            if length(indS)>1, A(n,5)=nanstd(Mat_S(indS,5));end
        end
        % type of expe
        try A(n,1)=unique([unique(Mat_W(indW,3)),unique(Mat_S(indS,3))]);end
    end
    
    % plot delay to WAKE
    figure(numF1), subplot(5,ceil(length(numMice)/5),mi), hold on,
    temp=[1:size(B,1)]'*ones(1,size(B,2));
    plot(temp(:),B(:),'.k')
    errorbar(1:length(numSessions),A(:,2),A(:,3),colorgp{numMice(mi,2)+1})
    ylabel('tdelta snd->WAKE'); ylim([min(B(:)),max(B(:))]);
    title(sprintf(' Mouse #%d',numMice(mi)),'Color',[1-numMice(mi,2) 0 numMice(mi,2)])
    plot(find(A(:,1)==0),min(ylim)*ones(length(find(A(:,1)==0)),1),'o','Color',[0.5 0.5 0.5]);
    plot(find(A(:,1)==1),min(ylim)*ones(length(find(A(:,1)==1)),1),'o','Color','m');
    plot(find(A(:,1)==2),min(ylim)*ones(length(find(A(:,1)==2)),1),'o','Color','r');
    
    % plot delay to SLEEP
    figure(numF2), subplot(5,ceil(length(numMice)/5),mi), hold on,
    temp=[1:size(C,1)]'*ones(1,size(C,2));
    plot(temp(:),C(:),'.k')
    errorbar(1:length(numSessions),A(:,4),A(:,5),colorgp{numMice(mi,2)+1})
    ylabel('tdelta snd->SLEEP'); ylim([min(B(:)),max(B(:))]);
    title(sprintf(' Mouse #%d',numMice(mi)),'Color',[1-numMice(mi,2) 0 numMice(mi,2)])
    plot(find(A(:,1)==0),min(ylim)*ones(length(find(A(:,1)==0)),1),'o','Color',[0.5 0.5 0.5]);%basal
    plot(find(A(:,1)==1),min(ylim)*ones(length(find(A(:,1)==1)),1),'o','Color','m');%test0
    plot(find(A(:,1)==2),min(ylim)*ones(length(find(A(:,1)==2)),1),'o','Color','r');%test

    
    % plot effect of conditioning per mouse
    figure(numF3), subplot(5,ceil(length(numMice)/5),mi), hold on,
    typeExpe=unique(A(:,1));
    DBs=nan(1,3); DCs=DBs;
    for ty=1:min(length(typeExpe),3)
        temp=B(A(:,1)==typeExpe(ty),:);
        DB(mi,ty)=nanmean(temp(:));
        DBs(ty)=nanstd(temp(:))/sqrt(length(~isnan(temp(:))));
        temp=C(A(:,1)==typeExpe(ty),:);
        DC(mi,ty)=nanmean(temp(:));
        DCs(ty)=nanstd(temp(:))/sqrt(length(~isnan(temp(:))));
    end
    bar([DB(mi,:);DC(mi,:)]); xlim([0.5 2.5])
    errorbar([0.75 1 1.25; 1.75 2 2.25],[DB(mi,:);DC(mi,:)],[DBs;DCs],'+','Color','k');
    set(gca,'Xtick',1:2)
    set(gca,'XtickLabel',{'snd->WAKE','snd->SLEEP'})
    if rem(mi,5)==1, ylabel('Latency (s)');end
    title(sprintf(' Mouse #%d',numMice(mi)),'Color',[1-numMice(mi,2) 0 numMice(mi,2)])
    
end
legend({'BASAL','TEST0','TEST'})

%% final results
doTEST0=0; 
nameLeg={'BASAL','TEST0','TEST'};
if doTEST0, ind=1:3; else, ind=[1 3];end
figure('Color',[1 1 1])
subplot(2,2,1),p=PlotErrorBarN(DB(numMice(:,2)==1,ind),0,1);
set(gca,'Xtick',1:length(ind)); set(gca,'XtickLabel',nameLeg(ind))
title(sprintf('WAKE group (n=%d, p=%0.3f)',sum(numMice(:,2)==1),p)); 
ylabel('latency snd -> WAKE')

subplot(2,2,2),p=PlotErrorBarN(DC(numMice(:,2)==1,ind),0,1);
set(gca,'Xtick',1:length(ind)); set(gca,'XtickLabel',nameLeg(ind))
title(sprintf('WAKE group (n=%d, p=%0.3f)',sum(numMice(:,2)==1),p)); 
ylabel('latency snd -> SLEEP')

subplot(2,2,3),p=PlotErrorBarN(DB(numMice(:,2)==0,ind),0,1);
set(gca,'Xtick',1:length(ind)); set(gca,'XtickLabel',nameLeg(ind))
title(sprintf('SLEEP group (n=%d, p=%0.3f)',sum(numMice(:,2)==0),p)); 
ylabel('latency snd -> WAKE')

subplot(2,2,4),p=PlotErrorBarN(DC(numMice(:,2)==0,ind),0,1);
set(gca,'Xtick',1:length(ind)); set(gca,'XtickLabel',nameLeg(ind))
title(sprintf('SLEEP group (n=%d, p=%0.3f)',sum(numMice(:,2)==0),p)); 
ylabel('latency snd -> SLEEP')
