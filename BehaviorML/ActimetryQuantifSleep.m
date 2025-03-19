function ActimetryQuantifSleep
%
% other related scripts and functions :
%   - AnalyseActimeterML.m
%   - ActimetrySleepScorCompar.m
%   - ActiToData.m
%   - PoolDataActi.m
%   - GetAllDataActi.m
%   - an_actiML.m


















%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% OLD CODE
if 0
    %% indicate Folder
    if isempty(strfind(pwd,'/'));mark='\'; else, mark='/';end
    
    if ~exist('dirname','var')
        dirname=uigetdir(pwd,'get session folder e.g SLEEPActi-20150620-0002');
        while dirname~=0 & isnan(str2double(dirname(end-3:end)))
            dirname=uigetdir(pwd,'get session folder e.g SLEEPActi-20150620-0002');
        end
    end
    num=dirname(end-3:end);
    
    %% Get scor Data
    disp(' '); disp(dirname)
    try
        load([dirname,mark,'TsdData.mat'],'DataScor','DataScor2','tpsEnd','nameLabel');
        DataScor; tpsEnd;DataScor2;
        disp('DataScor loaded from TsdData.mat')
    catch
        clear DataScor tpsEnd
        nameLabel=[];
        for i=1:12
            if i<10, char_i=['0',num2str(i)]; else, char_i=num2str(i);end
            try
                disp(['Cage #',char_i,': loading ',num,'-cage',char_i,'-scoring.dat'])
                temp=load([dirname,mark,num,'-cage',char_i,mark,num,'-cage',char_i,'-scoring.dat']);
                
                if ~exist('DataScor','var')
                    DataScor=nan(size(temp,1),12);
                end
                
                DataScor(:,i)=temp(:,2);
                DataScor2(:,i)=temp(:,1);
                % get time of recording
                if ~exist('tpsEnd','var')
                    list=dir([dirname,mark,num,'-cage',char_i,mark,num,'-cage',char_i,'-scoring.dat']);
                    ld=list.date;
                    disp(['    Time of recording = ',ld])
                    ind=strfind(ld,':');
                    TimeEndRec=[str2num(ld(ind(1)-2:ind(1)-1)),...
                        str2num(ld(ind(1)+1:ind(2)-1)),str2num(ld(ind(2)+1:end))];
                    tpsEnd=TimeEndRec(1)*3600+TimeEndRec(2)*60+TimeEndRec(2);
                end
                nameLabel=[nameLabel,{['#',char_i]}];
                
            catch
                disp('    -> Problem'); keyboard
            end
        end
        save([dirname,mark,'TsdData.mat'],'DataScor','DataScor2','tpsEnd','nameLabel');
    end
    
    %% plot
    disp(' ')
    disp('Plotting scoring...')
    figure('Color',[1 1 1]),
    set(gcf,'Unit','Normalized','Position',[0.2 0.4 0.3 0.4])
    for i=1:12
        subplot(1,2,1)
        hold on, plot([tpsEnd-size(DataScor2,1)+1:1:tpsEnd]/3600,3*(i-1)+DataScor2(:,i))
        subplot(1,2,2)
        hold on, plot([0:size(DataScor2,1)-1]/60,3*(i-1)+DataScor2(:,i))
    end
    
    subplot(1,2,1),
    xl=([floor((tpsEnd-size(DataScor2,1)+1)/3600):4:ceil(tpsEnd/3600)]);
    if length(xl)<2
        xl=([floor((tpsEnd-size(DataScor2,1)+1)/3600):1:ceil(tpsEnd/3600)]);
    end
    xlim([min(xl) max(xl)]);
    
    set(gca,'YTick',0:3:3*12-1)
    set(gca,'YTickLabel',nameLabel)
    ylabel('NumMouse')
    
    set(gca,'XTick',xl)
    set(gca,'XTickLabel',mod(xl,24))
    xlabel('Time of recording (hr)')
    
    subplot(1,2,2)
    xlabel('Time of recording (min)')
    title(dirname)
    
    set(gca,'YTick',0:3:3*12-1)
    set(gca,'YTickLabel',nameLabel)
    ylabel('NumMouse')
    
    
    %% analyse Per mouse
    valDrop=10; %duration in s
    
    figure('Color',[1 1 1]),
    set(gcf,'Unit','Normalized','Position',[0.2 0.3 0.3 0.5])
    
    AllData=nan(1000,2*12);
    MeanDataTime=nan(2*12,length(xl));
    
    for i=1:12
        try
            tsd_ActiScor=tsd([1:1:size(DataScor,1)]'*1E4,DataScor(:,i));
            SleepEp=thresholdIntervals(tsd_ActiScor,0,'Direction','Below');
            %         SleepEp=mergeCloseIntervals(SleepEp,valDrop*1E4);
            %         SleepEp=dropShortIntervals(SleepEp,valDrop*1E4);
            %         SleepEp=mergeCloseIntervals(SleepEp,valDrop*1E4);
            SleepDur=Stop(SleepEp,'s')-Start(SleepEp,'s');
            
            WakeEp=thresholdIntervals(tsd_ActiScor,0,'Direction','Above');
            WakeDur=Stop(WakeEp,'s')-Start(WakeEp,'s');
            
            AllData(1:length(SleepDur),i)=SleepDur;
            AllData(1:length(SleepDur),12+i)=WakeDur;
            
            % evol dur SWSboot over time
            for ll=1:length(xl)
                ind=find(Start(SleepEp,'s')>=(ll-1)*3600 & Stop(SleepEp,'s')<ll*3600);
                MeanDataTime(i,ll)=nanmean(SleepDur(ind));
                MeanDataTime(12+i,ll)=nanmean(WakeDur(ind));
            end
            
        end
    end
    
    %% PLOT Data boxplot
    
    disp('Plotting Sleep and Wake duration per mouse...')
    
    subplot(3,4,1), boxplot(AllData(:,1:12));
    set(gca,'XTick',[1:12])
    set(gca,'XTickLabel',nameLabel)
    xlabel('Num mouse')
    ylim([0 500])
    ylabel('Sleep episod duration (s)')
    %ylabel(['Sleep episod duration (s), drop <',num2str(valDrop),'s'])
    
    subplot(3,4,3), boxplot(AllData(:,13:24));
    set(gca,'XTick',[1:12])
    set(gca,'XTickLabel',nameLabel)
    xlabel('Num mouse')
    ylim([0 500])
    ylabel('Wake episod duration (s)')
    
    
    %% evol dur SWSboot over time ErrorBarN all mice
    
    disp('Plotting Sleep and Wake duration over time...')
    
    subplot(3,4,2), PlotErrorBarN(MeanDataTime(1:12,:),0);
    set(gca,'XTick',[1:length(xl)])
    set(gca,'XTickLabel',mod(xl,24))
    xlabel('Time of recording (hr)')
    ylabel('Sleep episod duration (s)')
    %ylabel(['Sleep episod duration (s), drop <',num2str(valDrop),'s'])
    % disp result
    subplot(3,4,4), PlotErrorBarN(MeanDataTime(13:24,:),0);
    set(gca,'XTick',[1:length(xl)])
    set(gca,'XTickLabel',mod(xl,24))
    xlabel('Time of recording (hr)')
    ylabel('Wake episod duration (s)')
    
    %% plot histograms of Sleep durations
    
    subplot(3,4,[5,6,9,10]),
    % hist(AllData(:,1:12),10)
    for i=1:12
        [h(i,:),b]=hist(AllData(:,i),0:50);
        [hw(12+i,:),bw]=hist(AllData(:,12+i),0:50);
    end
    subplot(3,4,[5,6,9,10]), imagesc(1:12,b,h'),
    axis xy, ylim([0 48]), caxis([0 5])
    ylabel('Sleep episod duration (s)');
    xlabel('Num mouse');
    title(dirname)
    
    subplot(3,4,[7,8,11,12]), imagesc(1:12,bw,hw(13:24,:)'),
    axis xy, ylim([0 48]), caxis([0 5])
    ylabel('Wake episod duration (s)');
    xlabel('Num mouse');
    
    % figure, plot(b,smooth(sum(h),2),'k')
    % xlim([0 48])
    
    %% saving row data in tsd format
    disp(' ')
    tempdirname=dirname;
    try
        disp('Getting row data...')
        eval(['load(''',dirname,mark,'TsdData.mat'');'])
        dirname=tempdirname;
        Acti01;evtScoring01;
        disp('Row data have been loaded from TsdData.mat.')
    catch
        disp(['loading ',num,'-time.dat'])
        time=load([dirname,mark,num,'-time.dat']);
        for i=1:12
            if i<10, char_i=['0',num2str(i)]; else, char_i=num2str(i);end
            try
                disp(['Cage #',char_i,': loading ',num,'-cage',char_i,'-signal.dat'])
                temp=load([dirname,mark,num,'-cage',char_i,mark,num,'-cage',char_i,'-signal.dat']);
                
                temptsd=tsd(time*1E4,temp);
                eval(['Acti',char_i,'=temptsd;'])
                eval(['save(''',dirname,mark,'TsdData.mat'',','''-append'',','''Acti',char_i,''');']);
                
                disp(['         loading ',num,'-cage',char_i,'-evt.dat'])
                evt=load([dirname,mark,num,'-cage',char_i,mark,num,'-cage',char_i,'-evt.dat']);
                if isempty(evt), disp('         No event'), evt=[0 0 0];end
                
                % see /media/DataMOBsRAID/ProjetSLEEPActi/SWConsts.m
                ind=find(ismember(evt(:,2),[-2,-1,1,2])); % EVT_WAKE_UP_CORR = 2; EVT_FALL_ASLEEP_CORR = -2;
                eval(['evtScoring',char_i,'=tsd(evt(ind,1)*1E4,evt(ind,2));']); % EVT_WAKE_UP = 1; EVT_FALL_ASLEEP = -1;
                
                eval(['evtSound',char_i,'=tsd(evt(evt(:,2)==10 | evt(:,2)==11, 1)*1E4, evt(evt(:,2)==10 | evt(:,2)==11, 2));']);% EVT_SOUND_STOP = 10; EVT_SOUND = 11;
                eval(['evtStim',char_i,'= ts(evt(evt(:,2)==13,1)*1E4);% EVT_SOUND_TRAIN = 13;']);%EVT_SOUND_OSC = 12;
                eval(['evtcalib',char_i,'= tsd(evt(evt(:,2)==14,1)*1E4,evt(evt(:,2)==14,3));']);% EVT_SOUND_STIM = 14;
                
                eval(['save(''',dirname,mark,'TsdData.mat'',''-append'',''evtScoring',char_i,...
                    ''',''evtSound',char_i,''',''evtStim',char_i,''',''evtcalib',char_i,''');']);
                
            catch
                disp('    -> Problem');
            end
        end
    end
    
    %% Look at row data
    disp('Plotting row data and scoring... ')
    figure('Color',[1 1 1]), numf=gcf;
    set(gcf,'Unit','Normalized','Position',[0.2 0.4 0.3 0.4])
    
    
    for i=1:12
        if i<10, char_i=['0',num2str(i)]; else, char_i=num2str(i);end
        try
            eval(['temptsd=Acti',char_i,';'])
            time=Range(temptsd,'s');
            temp=Data(temptsd);
            HilTsd=tsd(Range(temptsd),abs(hilbert(Data(temptsd))));
            
            % display
            figure(numf)
            hold on, plot(time,3*(i-1)+rescale(temp,-1,1));
            ind=[1:size(DataScor(:,i),1)];
            hold on, plot(ind-1,3*(i-1)+DataScor(ind,i),'r')
            hold on, plot(ind-1,3*(i-1)+DataScor2(ind,i),'g')
            
            
            % Look at evt Calibration
            try
                eval(['TempCalib=evtcalib',char_i,';'])
                rg=Range(TempCalib,'s');dt=Data(TempCalib);
                for ci=1:length(rg)
                    line([1 1]*rg(ci),[-1 1]+3*(i-1),'Color','k')
                    text(rg(ci),3*(i-1)+1,num2str(dt(ci)),'Color','k');
                end
                Udt=unique(dt);
                
                figure('Color',[1 1 1]), numf2=gcf;
                set(gcf,'Unit','Normalized','Position',[0.1 0.3 0.4 0.8])
                for u=1:length(Udt)
                    subplot(2,6,u),hold on,
                    ind=find(dt==Udt(u));
                    for ci=1:length(ind)
                        I=intervalSet(1E4*(rg(ind(ci))-10),1E4*(rg(ind(ci))+15));
                        plot([1:length(Restrict(temptsd,I))]*mean(diff(Range(temptsd,'s')))-10,(ci-1)*2+Data(Restrict(temptsd,I)))
                        ylim([0 30])
                        line([0 0],[0 30],'Color',[0.5 0.5 0.5])
                    end
                    ylabel(['Amplitude = ',num2str(Udt(u))]); xlabel('Time (s)')
                    title(['Cage#',char_i]);xlim([-10,15]);
                    
                end
            end
            %saveFigure(numf2,['ActiCalib-cage',char_i],dirname)
        catch
            disp(['    -> Problem cage #',char_i]); keyboard
        end
        
    end
    figure(numf)
    xlabel('Time of recording (s)')
    title(dirname)
    
    set(gca,'YTick',0:3:3*12-1)
    set(gca,'YTickLabel',nameLabel)
    ylabel('NumMouse')
    
    %% compare with electrophy
    if 1
        res=pwd;
        cd /media/DataMOBsRAID/ProjetSLEEPActi/Electrophy/Mouse242-15052015/
        figure('Color',[1 1 1]),
        set(gcf,'Unit','Normalized','Position',[0.2 0.4 0.3 0.4])
        
        load('StateEpoch.mat','REMEpoch','SWSEpoch');
        SleepEp=or(REMEpoch,SWSEpoch);
        SleepDur1=Stop(SleepEp,'s')-Start(SleepEp,'s');
        %subplot(1,3,1), hist(SleepDur1,0:40:800); title('SleepScoringML')
        
        load('StateEpochSB.mat','REMEpoch','SWSEpoch');
        SleepEp=or(REMEpoch,SWSEpoch);
        SleepDur2=Stop(SleepEp,'s')-Start(SleepEp,'s');
        %subplot(1,3,2), hist(SleepDur2,1:40:800); title('SleepScoringSB')
        
        load('Actimeter.mat','ActiScoring');
        tsd_ActiScor=tsd([1:1:size(ActiScoring,1)]'*1E4,ActiScoring(:,2));
        SleepEp=thresholdIntervals(tsd_ActiScor,0,'Direction','Below');
        SleepDur3=Stop(SleepEp,'s')-Start(SleepEp,'s');
        %subplot(1,3,3), hist(SleepDur3,0:40:800); title('SleepScoringAD')
        
        SleepDur=nan(max([length(SleepDur1),length(SleepDur2),length(SleepDur3)]),3);
        SleepDur(1:length(SleepDur1),1)=SleepDur1;
        SleepDur(1:length(SleepDur2),2)=SleepDur2;
        SleepDur(1:length(SleepDur3),3)=SleepDur3;
        
        subplot(1,2,1),hist(SleepDur,10);
        legend({'SleepScoringML','SleepScoringSB','SleepScoringAD'})
        ylabel('Sleep duration (s)')
        title(pwd)
        
        subplot(1,2,2),boxplot(SleepDur);
        set(gca,'XTick',1:3)
        set(gca,'XTickLabel',{'SleepScoringML','SleepScoringSB','SleepScoringAD'})
        ylabel('Sleep duration (s)')
        cd(res)
    end
end