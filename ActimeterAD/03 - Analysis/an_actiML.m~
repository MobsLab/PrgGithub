%  an_actiML.m
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
%   - an_actiML_quantifStimML.m

disp('an_actiML.m')

%% inputs
folderAnaly='/media/DataMOBsRAID/ProjetSLEEPActi/Analysis';

numBatch=2;
if numBatch==1
	res='/media/DataMOBsRAID/ProjetSLEEPActi/DataExpe1';
	expe=[9:22,24:87,89:141]; %23 does not exists 
    grouped=[ 1 2 5 6 9 10, 3 4 7 8 11 12]; 
    %expe=[29 31 32 34 40 60 70 81 91 101 111 121 131 ];
elseif numBatch==2
    res='/media/DataMOBsRAID/ProjetSLEEPActi/DataExpe2';
    grouped=[2 3 5 8 9 12, 1 4 6 7 10 11]; 
    %expe=0:1:54;
    expe=58:100;
end
channelID=1:12;
%channelID=1;

hON=9;
block=1; % block de 4h
descardblock=2; % discard if block <2hr (pas de chevauchement de block)
dosav=1;
doerase=0;
cd(res);
if isempty(strfind(res,'/')), mark='\'; else, mark='/';end


%% GET EXISTING EXPE
name=sprintf('an_acti_Expe%01d_%02dto%02d.mat', [numBatch,expe(1),expe(end)]);
disp(' ')
if doerase
    doexpe=expe;
else
    clear temp
    namedir=dir(folderAnaly);
    for i=3:length(namedir)
        if length(namedir(i).name)>18 && strcmp(namedir(i).name(1:18),name(1:18)) 
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
    
%     % first rec
%     a = Activity_linux(numBatch,expe(1), 1);
%     d=dir([a.dataDir,num2str(a.numBatch),'/',a.dataFileName_time]);
%     %Day_start=datenum(d.date);
%     date_start=datevec(d.date);
%     dur_firstRec=length(a.activity);
%     StartExpe_hr=mod(date_start(4:6)*[1 1/60 1/3600]'-dur_firstRec/3600,24);
%     dur_firstblock=StartExpe_hr-block*floor(StartExpe_hr/block);
%     
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
    sleepWakeDuration=nan(n_block,length(channelID));
    Info_sleepWake=nan(n_block,5); %[expe,weekday,tFROMstart,Recduration,hrBlock]
    Scor_tsd={}; Scor_tsd=tsdArray(Scor_tsd);
    Stim_ts={}; Stim_ts=tsdArray(Stim_ts);
    
    if ~isequal(doexpe,expe)
        sleepWakeDuration(1:size(temp.sleepWakeDuration,1),:)=temp.sleepWakeDuration;
        Info_sleepWake(1:size(temp.Info_sleepWake,1),:)=temp.Info_sleepWake;
        Scor_tsd=temp.Scor_tsd;
        Stim_ts=temp.Stim_ts;
    end
    
end
disp(['Experiment lasted ~',num2str(ceil(LengthExpe/3600)),'hr (',...
    num2str(n_block),' blocks of ',num2str(block),'hr)'])
disp(' ')



%% LOAD ALL EXPERIMENTS
% initiate
h = waitbar(0,'Loading Expe');
r=0;
CatEvent=tsd([],[]);
for i=1:length(doexpe)
    acqID=doexpe(i);
    
    for id =1:length(channelID)
        
        % %%%%%%%%%%%%%%%%%%%%%%%%%%% Load data %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if strcmp(mark,'/')
            a = Activity_linux(numBatch,acqID, channelID(id));
        else
            a = Activity(acqID, channelID(id));
        end
        evt_stimTimeStamps = a.timeStamps_evt(a.evts == a.SWc.EVT_SOUND_STIM);
        
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
            
            tmin=max(0,dur_Rec-Lastblock_rest-(b-1)*block*3600)+1;
            % restrict to part of recording
            if b==1
                tmax=dur_Rec;
            else
                tmax=dur_Rec-Lastblock_rest-(b-2)*block*3600;
            end
            
            % get ratio Sleep/wake
            try
                sleepdur= a.durationOf(a.SWc.IS_SLEEPING, 'm', tmin:tmax);
                wakedur= a.durationOf(a.SWc.IS_AWAKE, 'm', tmin:tmax);
                
                if ~isnan(sleepWakeDuration(ind_block(b),id))
                    % last rec for this block
                    dur1 = Info_sleepWake(ind_block(b),4);
                    val1 = sleepWakeDuration(ind_block(b),id);
                    % new rec for this block
                    dur2 = tmax-tmin+1;
                    val2 = 100*sleepdur/(sleepdur+wakedur);
                    % waited mean
                    sleepWakeDuration(ind_block(b),id) = val1*dur1/(dur1+dur2)+val2*dur2/(dur1+dur2);
                    tempdur=dur1+dur2;
                else
                    sleepWakeDuration(ind_block(b),id) = 100*sleepdur/(sleepdur+wakedur); % sleep
                    tempdur=tmax-tmin+1;
                end
                if id==1
                    Info_sleepWake(ind_block(b),1:5)=[doexpe(i),WD,t_start,tempdur,1+mod(floor(Lastblock_hr/block)-b+1,24/block)] ;
                end
            catch
                disp('PROBLEM');keyboard;
            end
        end
        
        % %%%%%%%%%%%%%%%%%%%%% sleepScoring ts %%%%%%%%%%%%%%%%%%%%%%%%%%%
        clear sleepScoring timeStamps tempTsd
        [sleepScoring, timeStamps] = a.computeSleepScoring();
        tempTsd=tsd((t_start+timeStamps')*1E4, sleepScoring');
        try
            idTsd=Scor_tsd{id};
        catch
            idTsd=tsd([],[]);
        end
        % sort before tsd
        mat=[[Range(idTsd);Range(tempTsd)],[Data(idTsd);Data(tempTsd)]];
        mat=sortrows(mat,1);
        rgdb=find(diff(mat(:,1))==0);
        mat(rgdb,:)=[];
        Scor_tsd{id}=tsd(mat(:,1),mat(:,2));
        if ~isempty(rgdb), disp(['problem -> Overlaping recording (',num2str(length(rgdb)),'s)??']);end
        
        % %%%%%%%%%%%%%%%%%%%%% sound stim evts %%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Get timestamps of triggered sounds
        
        tempTs=ts((t_start+evt_stimTimeStamps')*1E4);
        try
            idTs=Stim_ts{id};
        catch
            idTs=ts([]);
        end
        Stim_ts{id}=ts(sort([Range(idTs);Range(tempTs)]));
        
        % advance waitbar
        rtp= r + (FromStart/LengthExpe-r)*id/length(channelID);
        waitbar(rtp,h,['Loading Expe ',num2str(floor(100*rtp)),'%']);
    end
    
    if i==1
        CatEvent=tsd([t_start+1;FromStart]*1E4,[acqID;acqID]);
    else
        try
            CatEvent=[CatEvent;tsd([max(max(Range(CatEvent,'s')),t_start);floor(FromStart)]*1E4,[acqID;acqID])];
        catch
            keyboard
        end
    end
    % advance waitbar
    r= FromStart/LengthExpe;
   
end
close (h);

%% SAVE
if dosav
    disp(' '); disp(['Saving in ',name])
    save([folderAnaly,mark,name],'sleepWakeDuration','Info_sleepWake','Stim_ts','Scor_tsd',...
        'expe','channelID','block','firstRec','LastRec','LengthExpe','n_block','CatEvent');
end

%% DISPLAY SLEEP % PER BLOCK
clear orderID
a=0;for g=1:length(grouped), if ismember(grouped(g),channelID), a=a+1; orderID(a)=grouped(g);end;end
%orderID=[1 2 6 10, 3 4 7 8 12];
figure('Color',[1 1 1])
set(gcf,'Unit','normalized','Position',[0.1 0.6 0.6 0.7]),
colori=colormap('jet');
a=(mod(floor(firstRec.hr/block),24/block))*block;

leg=[];
for id =1:length(orderID)
    hold on,
    temp=sleepWakeDuration(:,orderID(id));
    plot(([1:length(temp)]-1)*block,100*id +temp,...
        '.-','Color',colori(5*id,:))
    leg=[leg,{['Mouse #',num2str(orderID(id))]} ];
end

for i=1:n_block
    if Info_sleepWake(i,5)==hON+12
        line([1 1]*(i-1)*block+0.5,[0 (length(orderID)+1)*100],'Color',[0.5 0.5 0.5])
    elseif Info_sleepWake(i,5)==hON
        line([1 1]*(i-1)*block+0.5,[0 (length(orderID)+1)*100],'Color',[0.9 0.9 0.9])
    %else
        %line([1 1]*(i-1)*block,[0 100],'Color',[0.9 0.9 0.9])
    end
end

for id =1:length(orderID)
    line(xlim,100*id*[1 1],'Color',[0.9 0.9 0.9],'LineStyle',':')
end

legend([leg,{sprintf('%dh',hON+12)},{sprintf('%dh',hON)}],'Location','BestOutside')
xlabel('# block'), xlim([-block size(sleepWakeDuration,1)*block])
ylabel('% sleep')

%% DISPLAY SLEEP % PER BLOCK AVERAGED ON MICE

figure('Color',[1 1 1],'Unit','normalized','Position',[0.1 0.6 0.6 0.4]),

subplot(4,6,1:6)
Mn=nanmean(sleepWakeDuration,2);
Sd=nanstd(sleepWakeDuration')';
plot(([1:length(temp)]-1)*block,Mn,'k','Linewidth',2)
hold on, plot(([1:length(temp)]-1)*block,Mn+Sd,'k')
hold on, plot(([1:length(temp)]-1)*block,Mn-Sd,'k')
title('Activity across experiment,averaged on all 12 mice'); ylim([0 100])

subplot(4,6,7:12)
%
Mn=nanmean(sleepWakeDuration(:,orderID(1:6)),2);
Sd=nanstd(sleepWakeDuration(:,orderID(1:6))')';
plot(([1:length(temp)]-1)*block,Mn,'Linewidth',2)
hold on, plot(([1:length(temp)]-1)*block,Mn+Sd)
hold on, plot(([1:length(temp)]-1)*block,Mn-Sd)
%
Mn=nanmean(sleepWakeDuration(:,orderID(7:12)),2);
Sd=nanstd(sleepWakeDuration(:,orderID(7:12))')';
plot(([1:length(temp)]-1)*block,Mn,'r','Linewidth',2)
hold on, plot(([1:length(temp)]-1)*block,Mn+Sd,'r')
hold on, plot(([1:length(temp)]-1)*block,Mn-Sd,'r')
title('Activity across experiment,averaged on all 12 mice')
legend({'WAKE cond','','','SLEEP cond','',''}); ylim([0 100])

for id =1:length(orderID)
    Mn=nan(1,24);Sd=Mn;
    for i=1:24
        Mn(i)=nanmean(sleepWakeDuration(Info_sleepWake(:,5)==i,orderID(id)));
        Sd(i)=nanstd(sleepWakeDuration(Info_sleepWake(:,5)==i,orderID(id)));
    end
    subplot(4,6,12+id)
    plot(1:48,[Mn,Mn],'.-k','Linewidth',2)
    hold on, plot(1:48,[Mn+Sd,Mn+Sd],'k')
    hold on, plot(1:48,[Mn-Sd,Mn-Sd],'k')
    ylim([0,100]); title(sprintf('Mouse #%d',orderID(id)))
    for i=1:4, line(hON*[1 1]+12*(i-1)+0.5,[0 100],'Color',[0.5 0.5 0.5]);end
    hold on, line([0 9.5],[100 100],'Color',[0.5 0.5 0.5],'Linewidth',5)
    hold on, line([21.5 24+9.5],[100 100],'Color',[0.5 0.5 0.5],'Linewidth',5)
    hold on, line([24+21.5 48],[100 100],'Color',[0.5 0.5 0.5],'Linewidth',5)
    
    if id>6
        set(gca,'Xtick',[9.5:12:48])
        set(gca,'XtickLabel',{'9hON','21hOFF','ON','OFF'});
    else,  set(gca,'Xtick',[])
    end
end
%%
for i=1:n_block
    if Info_sleepWake(i,5)==hON+12
        line([1 1]*(i-1)*block+0.5,[0 (length(orderID)+1)*100],'Color',[0.5 0.5 0.5])
    elseif Info_sleepWake(i,5)==hON
        line([1 1]*(i-1)*block+0.5,[0 (length(orderID)+1)*100],'Color',[0.9 0.9 0.9])
    %else
        %line([1 1]*(i-1)*block,[0 100],'Color',[0.9 0.9 0.9])
    end
end

for id =1:length(orderID)
    line(xlim,100*id*[1 1],'Color',[0.9 0.9 0.9],'LineStyle',':')
end

legend([leg,{sprintf('%dh',hON+12)},{sprintf('%dh',hON)}],'Location','BestOutside')
xlabel('# block'), xlim([-block size(sleepWakeDuration,1)*block])
ylabel('% sleep')




%% similarities of blocks across mice

figure('Color',[1 1 1],'Unit','normalized','Position',[0.03 0.6 0.55 0.21]),
for id =1:length(orderID)
    
    Mat=nan(ceil(size(sleepWakeDuration,1)*block/24),24/block);
    for i=1:24/block
        temp=sleepWakeDuration(i:24/block:end,orderID(id));
        Mat(1:length(temp),i)=temp;
    end
    subplot(1,length(orderID),id),
    imagesc(Mat'); axis xy
    title(['Mouse #',num2str(orderID(id))])
    if id==1, ylabel('# block of the day');end
    if id==floor(length(orderID)/2), xlabel('Day of expe (Look at similarities of blocks across mice)');end
    a=2:6:24; set(gca,'Ytick',a); for i=1:length(a), tik{i}=sprintf('%d',Info_sleepWake(a(i),5));end
    set(gca,'YtickLabel',tik);
end

%% evolution during expe across blocks
figure('Color',[1 1 1]), numf(2)=gcf;
set(gcf,'Unit','normalized','Position',[0.03 0.6 0.55 0.21]),
for i=1:24/block
    Mat=nan(ceil(size(sleepWakeDuration,1)*block/24),length(orderID));
    for id =1:length(orderID)
        temp=sleepWakeDuration(i:24/block:end,orderID(id));
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
set(gcf,'Unit','normalized','Position',[0.03 0.6 0.55 0.35]),

for i=1:4/block:n_block
    line([1 1]*(i-1)*block-firstRec.delay,[-2 4*id],'Color',colori(floor(64/24*(1+mod(i,24/block))),:))
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
legend(leg(1:4/block:end)), xlabel('Time (h)')
set(gca,'Ytick',block*[0:1:length(orderID)-1])
set(gca,'YtickLabel',stringID)
ylabel('WAKE GROUP               SLEEP GROUP')

%% Quantif Number of Stim
xtemp=0;durtemp=0;
rg=Range(CatEvent,'s');
dt=Data(CatEvent);

for i=1:n_block
    if i==1
        tmin=0;
        tmax=Info_sleepWake(1,4);
    else
        tmin=(i-2)*block*3600+Info_sleepWake(1,4);
        tmax=(i-1)*block*3600+Info_sleepWake(1,4);
    end
    
    for id =1:length(orderID)
        nbsound(id,i)=length(Restrict(Stim_ts{id},intervalSet(tmin*1E4,tmax*1E4)));
    end
end

%% display per block
figure('Color',[1 1 1]), hold on,
imagesc(1:length(orderID),1:n_block,nbsound'); axis xy, caxis([0 200])
set(gca,'xtick',1:length(orderID))
set(gca,'xticklabel',stringID)
ylim([0 n_block+1]); xlim([0.5,12.5])
for i=1:n_block, if Info_sleepWake(i,5)==6, line([0.5,12.5],0.5+[i i],'Color','k');end;end
colorbar;caxis([0 20*block]); line(floor(length(orderID)/2)*[1 1]+0.5,ylim,'Color','w')
title('Nb of auditory Stim per block (black lines = midnight)')
xlabel('#Mouse WAKE GROUP                  #Mouse SLEEP GROUP'); ylabel(['# block of ',num2str(block),'h'])

%% pool blocks of the same day
chgDay=find(Info_sleepWake(:,5)==1);
if chgDay(1)~=1, chgDay=[1;chgDay];end
if chgDay(end)~=6, chgDay=[chgDay;length(Info_sleepWake(:,5))];end

MatSW=nan(length(chgDay)-1,length(orderID));
for i=1:length(chgDay)-1
    MatSW(i,:)=sum(nbsound(:,chgDay(i):chgDay(i+1)),2)';
end

figure('Color',[1 1 1]), hold on,
imagesc(1:length(orderID),1:length(chgDay)-1,MatSW); axis xy,caxis([0 180])
set(gca,'xtick',1:length(orderID))
set(gca,'xticklabel',stringID)
line(floor(length(orderID)/2)*[1 1]+0.5,ylim,'Color','w')
ylim([0.5 length(chgDay)-1.5]);  xlim([0.5,12.5]);colorbar
title('Nb of auditory Stim per day')
xlabel('#Mouse WAKE GROUP                #Mouse SLEEP GROUP');ylabel('# Day')


