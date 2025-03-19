
%  an_acti_processML2.m
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
%   - an_acti_processML.m

%% inputs
PeriodDay=[10.5,19]; % btw 10h30 & 19h for Expe1, 9h30 & 18h for Expe2
hON=[8,9]; % in MATinfo(:,1);

%% Acquisition identities

[MATinfo,nameAcq]=getActiID;


%% Analyname
res='/media/DataMOBsRAID/ProjetSLEEPActi/Analysis';
cd(res);
analyname='an_acti_GeneralSleep.mat';


%% Compute
temp_i=[0 0];
MAT=[];MATscor=[];
for i=1:size(MATinfo,1);
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
        
        %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        % Get duraion of Sleep and Wake episods
        chgState=find(diff(sleepScoring)~=0);
        delay_chg=[timeStamps(chgState(1:end-1)+1)' sleepScoring(chgState(1:end-1)+1)' diff(timeStamps(chgState))'];
        % start time of WAKE(1)/SLEEP(-1) and duration
     
        %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        % create tempMAT and add to MAT
        if ~isempty(delay_chg)
            tempMAT = ones(size(delay_chg,1),1)*[temp_i hr_startRec MATinfo(i,6)];
            tempMAT = [tempMAT , delay_chg];
            MAT=[MAT; tempMAT];
        end
        MATscor=[MATscor;tempMATscor];
    catch
        keyboard
    end
end
% save
disp(['...Saving in ',analyname])
save(analyname,'MAT','MATinfo','MATscor');


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<  add night after COND <<<<<<<<<<<<<<<<<<<<<<<<<<<
% night afer conditioning, = 5
for num=1:length(unique(MATinfo(:,1)))
    val=unique(MATinfo(MATinfo(:,3)==3 & MATinfo(:,1)==num,2));
    MATinfo(ismember(MATinfo(:,2),val+1) & MATinfo(:,1)==num & isnan(MATinfo(:,3)),3)=5;
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<  Display ALL day <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
numMice=unique(MATinfo(:,6))';
numMice=[numMice;nan(3,length(numMice))];
for mi=1:size(numMice,2)
    numMice(2,mi)=unique(MATinfo(MATinfo(:,6)==numMice(1,mi),5));
    numMice(3,mi)=unique(MATinfo(MATinfo(:,6)==numMice(1,mi),1));
    numMice(4,mi)=unique(MATinfo(MATinfo(:,6)==numMice(1,mi),4));
end
numMice=sortrows(numMice',2);
nameGroup={'S','W'};colorgp={'r','b'};

figure('Color',[1 1 1])
for mi=1:length(numMice)
    typ=0; %BASAL
    numExpe=unique(MATinfo(MATinfo(:,6)==numMice(mi,1) & MATinfo(:,3)==typ,2));
    
    Aw=nan(length(numExpe),2);As=Aw;
    for n=1:length(numExpe)
        t=mod(MAT(:,3)+MAT(:,5)/3600,24);
        i_w=find(MAT(:,4)==numMice(mi,1) & MAT(:,2)==numExpe(n) ...
            & t>PeriodDay(1) & t<PeriodDay(2) & MAT(:,6)==1);
        i_s=find(MAT(:,4)==numMice(mi,1) & MAT(:,2)==numExpe(n) ...
            & t>PeriodDay(1) & t<PeriodDay(2) & MAT(:,6)==-1);
        
        Aw(n,1:2)=[nanmean(MAT(i_w,7)),nanstd(MAT(i_w,7))/sqrt(length(i_w))];
        As(n,1:2)=[nanmean(MAT(i_s,7)),nanstd(MAT(i_s,7))/sqrt(length(i_s))];
    end
    subplot(4,ceil(length(numMice)/4),mi), hold on
    errorbar(Aw(:,1),Aw(:,2),'+k')
    bar(Aw(:,1))
    title(sprintf('# %d',numMice(mi,1)),'Color',colorgp{numMice(mi,2)+1})
end



