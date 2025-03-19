%  an_actiML_quantifSleep.m
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
%   - an_acti_quantifStimML.m

disp('an_actiML_quantifSleep.m')

%% inputs

folderAnaly='/media/DataMOBsRAID/ProjetSLEEPActi/Analysis';

numBatch=1;
if numBatch==1
	res='/media/DataMOBsRAID/ProjetSLEEPActi/DataExpe1';
	expe=[9:22,24:87,89:140]; %23 does not exists % before test with Leo/Gaetan (18-08-2015), last values were 24:76
elseif numBatch==2
    res='/media/DataMOBsRAID/ProjetSLEEPActi/DataExpe2';
    expe=0:1:4;
end
channelID=1:12;

block=4; % block de 4h
descardblock=2; % discard if block <2hr (pas de chevauchement de block)
dosav=1;
doerase=0;
cd(res);
if isempty(strfind(res,'/')), mark='\'; else, mark='/';end


%% GET EXISTING EXPE
name=sprintf('an_acti_QuantifSleep_Expe%01d_%02dto%02d.mat', [numBatch,expe(1),expe(end)]);
disp(' ')
if doerase
    doexpe=expe;
else
    
    namedir=dir(folderAnaly);
    for i=3:length(namedir)
        if length(namedir(i).name)>31 && strcmp(namedir(i).name(1:31),name(1:31)) 
            disp(['Completing from ',namedir(i).name ,' (force erase via inputs)']);
            temp=load([folderAnaly,mark,namedir(i).name]);
        end
    end
    if exist('temp','var') && temp.expe(end) < expe(end) && isequal(temp.channelID,channelID)
        doexpe=expe(~ismember(expe,temp.expe));
        disp(['   adding rec ',sprintf(' %02d',doexpe)])
    elseif exist('temp','var') && isequal(temp.expe,expe) && isequal(temp.channelID,channelID)
        doexpe=[];dosav=0;
        disp([name,' already exists.. loading'])
        load([folderAnaly,mark,name]);
    else
        doexpe=expe;
    end
end

%% DURATION OF EXPERIMENT

disp(' ')
if ~isempty(doexpe)
    disp(['Defining duration of experiments from #',num2str(expe(1)),' to #',num2str(expe(end))])
    
    % first rec
    a = Activity_linux(numBatch,expe(1), 1);
    d=dir([a.dataDir,num2str(a.numBatch),'/',a.dataFileName_time]);
    %Day_start=datenum(d.date);
    date_start=datevec(d.date);
    dur_firstRec=length(a.activity);
    StartExpe_hr=mod(date_start(4:6)*[1 1/60 1/3600]'-dur_firstRec/3600,24);
    dur_firstblock=StartExpe_hr-block*floor(StartExpe_hr/block);
    
    % first rec
    a = Activity_linux(numBatch,expe(1), 1);
    firstRec.d=dir([a.dataDir,num2str(a.numBatch),'/',a.dataFileName_time]);
    %Day_start=datenum(d.date);
    firstRec.date=datevec(firstRec.d.date);
    firstRec.dur=length(a.activity);
    firstRec.hr=mod(firstRec.date(4:6)*[1 1/60 1/3600]'-firstRec.dur/3600,24);
    firstRec.delay=firstRec.hr-block*floor(firstRec.hr/block);
    
    
    % last rec
    a = Activity_linux(numBatch,expe(end), 1);
    LastRec.d=dir([a.dataDir,num2str(a.numBatch),'/',a.dataFileName_time]);
    LastRec.date=datevec(LastRec.d.date);
    
    % LengthExpe
    LengthExpe=etime(LastRec.date,firstRec.date)+firstRec.dur; %en seconde
    n_block=ceil(LengthExpe/(block*3600))+1;
    
    
    % predefine
    sleepDuration=[];
    wakeDuration=[];
    
    Info_sleepWake=nan(n_block,5);
    Scor_tsd={}; Scor_tsd=tsdArray(Scor_tsd);
    Stim_ts={}; Stim_ts=tsdArray(Stim_ts);
    
    if ~isequal(doexpe,expe)
        sleepDuration(1:size(temp.sleepDuration,1),:)=temp.sleepDuration;
        wakeDuration(1:size(temp.wakeDuration,1),:)=temp.wakeDuration;
        Info_sleepWake(1:size(temp.Info_sleepWake,1),:)=temp.Info_sleepWake;

    end
    
end
disp(['Experiment lasted ~',num2str(ceil(LengthExpe/3600)),'hr (',...
    num2str(n_block),' blocks of ',num2str(block),'hr)'])
disp(' ')



%% LOAD ALL EXPERIMENTS
% initiate
h = waitbar(0,'Loading Expe');
r=0;
for i=1:length(doexpe)
    acqID=doexpe(i);
    
    for id =1:length(channelID)
        
        % %%%%%%%%%%%%%%%%%%%%%%%%%%% Load data %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if strcmp(mark,'/')
            a = Activity_linux(numBatch,acqID, channelID(id));
        else
            a = Activity(acqID, channelID(id));
        end
        [sleepScoring, timeStamps] = a.computeSleepScoring();
        
        % problem scoring..
        ind0=find(sleepScoring==0);
        for i0=2:length(ind0)
            sleepScoring(ind0(i0))=sleepScoring(ind0(i0)-1);
        end
        
        chgstate=diff(sleepScoring);
        mat=[[find(chgstate==-2)';find(chgstate==2)'],... % [-2=wake->sleep, 2=sleep->wake]
            [zeros(length( find(chgstate==-2)),1);ones(length( find(chgstate==2)),1)]];
        mat=sortrows(mat,1);% 1 =Wakes up; 0= falls asleep
        matdif=[mat(2:end,1),diff(mat)];%-1=duration wake; 1=duration sleep
        
        
        % %%%%%%%%%%%%%%%%%%%%% moment of recording %%%%%%%%%%%%%%%%%%%%%%%
        d=dir([a.dataDir,num2str(a.numBatch),'/',a.dataFileName_time]);
        date_a=datevec(d.date);
        WD=weekday(datenum(d.date));
        dur_Rec=length(a.activity);
        
        FromStart=etime(date_a,firstRec.date)+firstRec.dur;% day of recording
        t_start=FromStart-dur_Rec;
        Lastblock_hr=mod(date_a(4:6)*[1 1/60 1/3600]',24);
        % %%%%%%%%%%%%%%%%%%%% subdivide into blocks %%%%%%%%%%%%%%%%%%%%%%
        
        Lastblock_deb=floor((firstRec.delay+FromStart/3600)/block)+1; % time block of the day
        Lastblock_rest=rem(floor(Lastblock_hr*3600),block*3600);
        
        firstblock_deb=floor((firstRec.delay+(FromStart-dur_Rec)/3600)/block)+1; % time block of the day
        ind_block=Lastblock_deb:-1:firstblock_deb;
        %disp(ind_block)
        
        for b=1:length(ind_block)
            
            tmin=max(1,dur_Rec-Lastblock_rest-(b-1)*block*3600+1);
            % restrict to part of recording
            if b==1
                tmax=dur_Rec;
            else
                tmax=dur_Rec-Lastblock_rest-(b-2)*block*3600;
            end
            
            % get ratio Sleep/wake
            try
                
                temp_sleepdur= matdif(matdif(:,1)>tmin & matdif(:,1)<tmax & matdif(:,3)==1,1:2);
                temp_sleepdur=[mod(Lastblock_hr-dur_Rec/3600+temp_sleepdur(:,1)/3600,24),temp_sleepdur(:,2)];
                
                temp_wakedur= matdif(matdif(:,1)>tmin & matdif(:,1)<tmax & matdif(:,3)==-1,1:2);
                temp_wakedur=[mod(Lastblock_hr-dur_Rec/3600+temp_wakedur(:,1)/3600,24),temp_wakedur(:,2)];
                
                sleepdur=[ones(size(temp_sleepdur,1),1)*[channelID(id),ind_block(b)],temp_sleepdur];
                wakedur=[ones(size(temp_wakedur,1),1)*[channelID(id),ind_block(b)],temp_wakedur];   
                
                sleepDuration=[sleepDuration;sleepdur];
                wakeDuration=[wakeDuration;wakedur];
                
                if ~isnan(Info_sleepWake(ind_block(b),4))
                    % last rec for this block
                    dur1 = Info_sleepWake(ind_block(b),4);
                    % new rec for this block
                    dur2 = tmax-tmin;
                    Info_sleepWake(ind_block(b),4:5)=[dur1+dur2,1+mod(floor(Lastblock_hr/block)-b+1,24/block)] ;
                else
                    Info_sleepWake(ind_block(b),4:5)=[tmax-tmin,1+mod(floor(Lastblock_hr/block)-b+1,24/block)] ;
                end
                
                
                Info_sleepWake(ind_block(b),1:3)=[doexpe(i),WD,t_start] ;
            catch
                disp('PROBLEM');keyboard;
            end
        end
        
        
        % advance waitbar
        rtp= r + (FromStart/LengthExpe-r)*id/length(channelID);
        waitbar(rtp,h,['Loading Expe ',num2str(floor(100*rtp)),'%']);
    end
    
    % advance waitbar
    r= FromStart/LengthExpe;
   
end
close (h);

%% SAVE
if dosav
    disp(' '); disp(['Saving in ',name])
    save([folderAnaly,mark,name],'sleepDuration','wakeDuration','Info_sleepWake','Stim_ts','Scor_tsd',...
        'expe','channelID','block','firstRec','LastRec','LengthExpe','n_block');
end


%% discard lost mice
% [#Mouse LastRec]
disp('Removing lost mice from analysis');
LostMat=[5,33; 11,95; 1,103; 2,107];
for i=1:length(LostMat)
    indlost=find(Info_sleepWake(:,1)>LostMat(i,2));
    sleepDuration(sleepDuration(:,1)==LostMat(i,1)& ismember(sleepDuration(:,2),indlost),:)=[];
    wakeDuration(wakeDuration(:,1)==LostMat(i,1)& ismember(wakeDuration(:,2),indlost),:)=[];
end        

%% Histograms of duration, per mice
colori=colormap('jet');
S_mean=nan(length(channelID),48);
W_mean=nan(length(channelID),48);
S_med=nan(length(channelID),48);
W_med=nan(length(channelID),48);

figure('Color',[1 1 1]), numF1=gcf;
set(gcf,'Unit','normalized','Position',[0.1 0.6 0.6 0.8]),
figure('Color',[1 1 1]), numF2=gcf;
for id =1:length(channelID)
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    % <<<<<<<<<<<<<<<<<<<   sleep   <<<<<<<<<<<<<<<<<<
    clear temph temp
    temp=sleepDuration(sleepDuration(:,1)==channelID(id),:);
    
    % ------------ distribution log sleepDuration -------------------------
    figure(numF2), subplot(1,2,1), hold on,
    h=hist(temp(:,4),10:3:310);
    plot(10:3:310,SmoothDec(10*log10(h),2),'Color',colori(5*id,:),'Linewidth',2)
    if id==1, ylabel('# sleep episod'); xlabel('log Sleep duration');end
    
    % ------------------ distribution sleepDuration -----------------------
    figure(numF1)
    subplot(4,length(channelID),id), hold on,
    hist(temp(:,4),10:3:310);
    xlim([10 300]), ylim([0 500])
    if id==1, ylabel('# sleep episod');end
    if id==floor(length(channelID)/2),xlabel('Sleep duration (s)'); end
    title(['Mouse #',num2str(channelID(id))])
    % add indiv mean & median values
    line([mean(temp(:,4)),mean(temp(:,4))],[0 400],'Color','r'); 
    text(mean(temp(:,4))+5,400,{[num2str(floor(mean(temp(:,4)))),'s']},'Color','r')
    line([median(temp(:,4)),median(temp(:,4))],[0 500],'Color','m'); 
    text(median(temp(:,4))+5,500,{[num2str(floor(median(temp(:,4)))),'s']},'Color','m')
    
    % -------------- Correlation time of day sleepDuration ----------------
    subplot(4,length(channelID),length(channelID)+id), hold on,
    plot([temp(:,3);24+temp(:,3)],[temp(:,4);temp(:,4)],'.k')
    line([8,8,20,20],[800,0, 0 800],'Color',[0.5 0.5 0.5])
    line([8+24,8+24,24+20,24+20],[800 0 0 800],'Color',[0.5 0.5 0.5])
    xlim([0 48]), ylim([0 800])
    if id==1, title('sleep duration depending of day time');ylabel('sleep duration (s)');end
    if id==floor(length(channelID)/2),xlabel('day time (hr)'); end
    % add mean/med values
    for h=1:24
        temph(h,1)=mean(temp(temp(:,3)>h-1 & temp(:,3)<h,4));
        temph(h,2)=median(temp(temp(:,3)>h-1 & temp(:,3)<h,4));
    end
    plot([1:2*24]-1,[temph(:,1);temph(:,1)],'-r')
    plot([1:2*24]-1,[temph(:,2);temph(:,2)],'-m')
    S_mean(id,:)=[temph(:,1);temph(:,1)];
    S_med(id,:)=[temph(:,2);temph(:,2)];
    
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    % <<<<<<<<<<<<<<<<<<<   wake   <<<<<<<<<<<<<<<<<<
    clear temph temp
    temp=wakeDuration(wakeDuration(:,1)==channelID(id),:);
    
    % ------------------ distribution wakeDuration ------------------------ 
    subplot(4,length(channelID),2*length(channelID)+id), hold on,
    hist(temp(:,4),10:3:310);
    xlim([10 300]), ylim([0 1000])
    if id==1, ylabel('# wake episod');end
    if id==floor(length(channelID)/2),xlabel('wake duration (s)'); end
    % add indiv mean & median values
    line([mean(temp(:,4)),mean(temp(:,4))],[0 800],'Color','r'); 
    text(mean(temp(:,4))+5,800,{[num2str(floor(mean(temp(:,4)))),'s']},'Color','r')
    line([median(temp(:,4)),median(temp(:,4))],[0 1000],'Color','m'); 
    text(median(temp(:,4))+5,1000,{[num2str(floor(median(temp(:,4)))),'s']},'Color','m')
    
    % -------------- Correlation time of day wakeDuration -----------------
    subplot(4,length(channelID),3*length(channelID)+id), hold on,
    plot([temp(:,3);24+temp(:,3)],[temp(:,4);temp(:,4)],'.k')
    line([8,8,20,20],[3500,0, 0 3500],'Color',[0.5 0.5 0.5])
    line([8+24,8+24,24+20,24+20],[3500 0 0 3500],'Color',[0.5 0.5 0.5])
    xlim([0 48]), ylim([0 3500])
    if id==1, title('wake duration depending of day time');ylabel('wake duration (s)');end
    if id==floor(length(channelID)/2),xlabel('day time (hr)'); end
    % add mean/med values
    for h=1:24
        temph(h,1)=mean(temp(temp(:,3)>h-1 & temp(:,3)<h,4));
        temph(h,2)=median(temp(temp(:,3)>h-1 & temp(:,3)<h,4));
    end
    plot([1:2*24]-1,[temph(:,1);temph(:,1)],'-r')
    plot([1:2*24]-1,[temph(:,2);temph(:,2)],'-m')
    W_mean(id,:)=[temph(:,1);temph(:,1)];
    W_med(id,:)=[temph(:,2);temph(:,2)];
    
    % ------------ distribution log WakeDuration -------------------------
    figure(numF2), subplot(1,2,2), hold on,
    h=hist(temp(:,4),10:3:310);
    plot(10:3:310,SmoothDec(10*log10(h),2),'Color',colori(5*id,:),'Linewidth',2)
    if id==1, ylabel('# Wake episod'); xlabel('log Wake duration');end
    
end

%% DIFFERENTIATE GROUPS
GpW=[1 2 6 10]; % wake conditioning
GpS=[3 4 7 8 12];% sleep conditioning
gpMice=nan(1,length(grouped));
clear orderID
a=0;
for g=1:length(channelID)
   gpMice(g)=ismember(channelID(g),GpW)+2*ismember(channelID(g),GpS);
end
% ---------------------------------------
%% errorbar plots
figure('Color',[1 1 1])
set(gcf,'Unit','normalized','Position',[0.1 0.6 0.4 0.6]),

% sleep
subplot(2,3,1),hold on,
errorbar([1:2*24],mean(S_mean,1),sem(S_mean),'r','Linewidth',2)
errorbar([1:2*24],mean(S_med,1),sem(S_med),'m','Linewidth',2)
line([8,8,20,20],[130,0, 0 130],'Color',[0.5 0.5 0.5],'Linewidth',2)
line([8+24,8+24,24+20,24+20],[130 0 0 130],'Color',[0.5 0.5 0.5],'Linewidth',2)
title(['Sleep duration across daytime (n=',num2str(length(channelID)),')'])
ylabel('Sleep duration (s)'), xlim([1 48]), ylim([20 130])

% wake
subplot(2,3,4),hold on,
errorbar([1:2*24],mean(W_mean,1),sem(W_mean),'r','Linewidth',2)
errorbar([1:2*24],mean(W_med,1),sem(W_med),'m','Linewidth',2)
line([8,8,20,20],[500,0, 0 500],'Color',[0.5 0.5 0.5],'Linewidth',2)
line([8+24,8+24,24+20,24+20],[500 0 0 500],'Color',[0.5 0.5 0.5],'Linewidth',2)
title(['Wake duration across daytime (n=',num2str(length(channelID)),')'])
ylabel('Wake duration (s)')
legend({'mean','median'})
xlabel('day time (hr)'), xlim([1 48]), ylim([20 500])

% indiv values
leg=[];
for id =1:length(channelID)
    subplot(2,3,2),hold on,
    plot([1:2*24],S_med(id,:),'Color',colori(5*id,:));xlim([1 48]), ylim([20 130])
    leg=[leg,{['#',num2str(channelID(id))]}];
    subplot(2,3,5),hold on,
    plot([1:2*24],W_mean(id,:),'Color',colori(5*id,:));xlim([1 48]), ylim([20 500])
end
legend(leg);xlabel('day time (hr)')
title(['MEAN Wake duration across daytime (n=',num2str(length(channelID)),')'])
subplot(2,3,2);title(['MEAN Sleep duration across daytime (n=',num2str(length(channelID)),')'])


% separate groups
% sleep
subplot(2,3,3),hold on,
errorbar([1:2*24],mean(S_mean(gpMice==2,:),1),sem(S_mean(gpMice==2,:)),'r','Linewidth',2)
errorbar([1:2*24],mean(S_mean(gpMice==1,:),1),sem(S_mean(gpMice==1,:)),'b','Linewidth',2)
errorbar([1:2*24],mean(S_med(gpMice==2,:),1),sem(S_med(gpMice==2,:)),'m')
errorbar([1:2*24],mean(S_med(gpMice==1,:),1),sem(S_med(gpMice==1,:)),'c')
line([8,8,20,20],[500,0, 0 500],'Color',[0.5 0.5 0.5],'Linewidth',2)
line([8+24,8+24,24+20,24+20],[500 0 0 500],'Color',[0.5 0.5 0.5],'Linewidth',2)
title(['sleep duration across daytime (n=',num2str(length(channelID)),')'])
ylabel('sleep duration (s)'), xlim([1 48]), ylim([20 130])

subplot(2,3,6),hold on,
errorbar([1:2*24],mean(W_mean(gpMice==2,:),1),sem(W_mean(gpMice==2,:)),'r','Linewidth',2)
errorbar([1:2*24],mean(W_mean(gpMice==1,:),1),sem(W_mean(gpMice==1,:)),'b','Linewidth',2)
errorbar([1:2*24],mean(W_med(gpMice==2,:),1),sem(W_med(gpMice==2,:)),'m')
errorbar([1:2*24],mean(W_med(gpMice==1,:),1),sem(W_med(gpMice==1,:)),'c')
line([8,8,20,20],[500,0, 0 500],'Color',[0.5 0.5 0.5],'Linewidth',2)
line([8+24,8+24,24+20,24+20],[500 0 0 500],'Color',[0.5 0.5 0.5],'Linewidth',2)
title(['MEAN Wake duration across daytime (n=',num2str(length(channelID)),')'])
ylabel('MEAN wake duration (s)')
legend([{['MEAN Sleep cond (n=',num2str(sum(gpMice==2)),')']},{['MEAN Wake cond (n=',num2str(sum(gpMice==1)),')']},...
    {['MED Sleep cond (n=',num2str(sum(gpMice==2)),')']},{['MED Wake cond (n=',num2str(sum(gpMice==1)),')']}])
xlabel('day time (hr)'), xlim([1 48]), ylim([20 500])




%% Histograms of sleep duration, all mice, per hour
figure('Color',[1 1 1])
set(gcf,'Unit','normalized','Position',[0.1 0.6 0.4 0.6]),
for h=1:24
    subplot(4,6,h), hold on,
    temp=sleepDuration(sleepDuration(:,3)>h-1 & sleepDuration(:,3)<h,4);
    hist(temp,10:3:310);
    line([mean(temp),mean(temp)],[0 400],'Color','r','Linewidth',2); 
    text(mean(temp)+5,400,{['mean=',num2str(floor(mean(temp))),'s']},'Color','r')
    line([median(temp),median(temp)],[0 500],'Color','m','Linewidth',2); ylim([0 500])
    text(median(temp)+5,500,{['med=',num2str(floor(median(temp))),'s']},'Color','m')
    title(['day time ',num2str(h-1),'h-',num2str(h),'h']);xlim([10 300])
end


%% Histograms of wake duration, all mice, per hour
figure('Color',[1 1 1])
set(gcf,'Unit','normalized','Position',[0.1 0.6 0.4 0.6]),
for h=1:24
    subplot(4,6,h), hold on,
    temp=wakeDuration(wakeDuration(:,3)>h-1 & wakeDuration(:,3)<h,4);
    hist(temp,10:3:310);
    line([mean(temp),mean(temp)],[0 800],'Color','r','Linewidth',2); 
    text(mean(temp)+5,800,{['mean=',num2str(floor(mean(temp))),'s']},'Color','r')
    line([median(temp),median(temp)],[0 1000],'Color','m','Linewidth',2); ylim([0 1000])
    text(median(temp)+5,1000,{['med=',num2str(floor(median(temp))),'s']},'Color','m')
    title(['day time ',num2str(h-1),'h-',num2str(h),'h']);xlim([10 300])
end

%% DISPLAY RATIO PER BLOCK

figure('Color',[1 1 1])
set(gcf,'Unit','normalized','Position',[0.1 0.6 0.6 0.4]),
leg=[];
for id =1:length(orderID)
    subplot(2,1,1), hold on,
    plot(sleepDuration(sleepDuration(:,1)==orderID(id),4),...
        '.-','Color',colori(5*id,:),'Linewidth',2)
    subplot(2,1,2), hold on,
    plot(wakeDuration(wakeDuration(:,1)==orderID(id),4),...
        '.-','Color',colori(5*id,:),'Linewidth',2)
    leg=[leg,{['Mouse #',num2str(orderID(id))]} ];
end

a=(mod(floor(firstRec.hr/block),24/block))*block;
subplot(2,1,1), hold on,
for i=1:24/block:n_block
    line([1 1]*(i-1)*block-firstRec.delay,[0 300],'Color',[0.5 0.5 0.5])
end
ylim([0 300]); xlim([-4 size(sleepDuration,1)*4])
ylabel([appendix(2:end),' duration of sleep (s)'])

subplot(2,1,2), hold on,
for i=1:24/block:n_block
    line([1 1]*(i-1)*block-firstRec.delay,[0 500],'Color',[0.5 0.5 0.5])
end
ylim([0 500])
legend([leg,{[num2str(a),'h']}],'Location','BestOutside')
xlabel('# block'), xlim([-4 size(sleepDuration,1)*4])
ylabel([appendix(2:end),' duration of wake (s)'])

%% similarities of blocks across mice

figure('Color',[1 1 1]),
set(gcf,'Unit','normalized','Position',[0.03 0.6 0.55 0.21]),
for id =1:length(orderID)
    
    Mat=nan(ceil(size(sleepDuration,1)*block/24),24/block);
    for i=1:24/block
        temp=sleepDuration(i:24/block:end,orderID(id));
        Mat(1:length(temp),i)=temp;
    end
    subplot(1,length(orderID),id),
    imagesc(Mat'); axis xy
    title(['Mouse #',num2str(orderID(id))])
    if id==1, ylabel('# block of the day');end
    if id==floor(length(orderID)/2), xlabel('Day of expe (Look at similarities of blocks across mice)');end
end

%% evolution during expe across blocks
figure('Color',[1 1 1]), numf(2)=gcf;
set(gcf,'Unit','normalized','Position',[0.03 0.6 0.55 0.21]),
for i=1:24/block
    Mat=nan(ceil(size(sleepDuration,1)*block/24),length(orderID));
    for id =1:length(orderID)
        temp=sleepDuration(i:24/block:end,orderID(id));
        Mat(1:length(temp),id)=temp;
    end
    subplot(1,24/block+1,i),
    imagesc(Mat); caxis([0 100]);%axis xy
    title(['block #',num2str(i)])
    if i==1, ylabel('Day of expe');end
    if i==floor(12/block), xlabel('# Mouse');end
    set(gca,'xtick',1:length(orderID))
    for o=1:length(orderID), stringID{o}=num2str(orderID(o));end
    set(gca,'xticklabel',stringID)
end
subplot(1,24/block+1,24/block+1),imagesc(Mat(1,1)); caxis([0 100]); colorbar


%% evolution during expe across blocks
figure('Color',[1 1 1]), numf(2)=gcf;
set(gcf,'Unit','normalized','Position',[0.03 0.6 0.55 0.21]),

for i=1:n_block
    line([1 1]*(i-1)*block-firstRec.delay,[-2 4*id],'Color',colori(1+mod(i,24/block)*10,:))
end
xlim([-firstRec.delay-1, n_block*block+1])
for id =1:length(orderID)
    hold on, plot(Range(Scor_tsd{id},'s')/3600,4*(id-1)+Data(Scor_tsd{id}),'k'), ylim([-2 4*id])
    hold on, plot(Range(Stim_ts{id},'s')/3600,4*(id-1)+zeros(length(Stim_ts{id}),1),'.r')
end
clear leg
a=(mod(floor(firstRec.hr/block),24/block))*block;
for i=1:24/block
    leg{i}=([num2str(a),'h']);
    a=mod(a+block,24);
end
legend(leg)



