function Episodes = Temperature_FreezingEpisodes(Mouse_name,FolderList,ChosenEpoch,tsd_used,margins)

Mouse_name={['M' num2str(Mouse_name)]};

switch ChosenEpoch
    case 'Fz'
        ChosenEpoch='Behav.FreezeAccEpoch';
    case 'Safe'
        ChosenEpoch='and(Behav.FreezeAccEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))';
    case 'Shock'
        ChosenEpoch='and(Behav.FreezeAccEpoch,or(Behav.ZoneEpoch{1},Behav.ZoneEpoch{4}))';
    case 'Fz1'
        ChosenEpoch='and(Behav.FreezeAccEpoch,Behav.ZoneEpoch{1})';
    case 'Fz2'
        ChosenEpoch='and(Behav.FreezeAccEpoch,Behav.ZoneEpoch{2})';
    case 'Fz4'
        ChosenEpoch='and(Behav.FreezeAccEpoch,Behav.ZoneEpoch{4})';
    case 'Fz5'
        ChosenEpoch='and(Behav.FreezeAccEpoch,Behav.ZoneEpoch{5})';
    otherwise
        disp('ERROR')
end

switch tsd_used
    case 'Body'
        tsd_used='Temp.BodyTemperatureTSD';
    case 'Tail'
        tsd_used='Temp.TailTemperatureTSD ' ;
    case 'Room'
        tsd_used='Temp.RoomTemperatureTSD';
    case 'Mouse'
        tsd_used='Temp.MouseTemperatureTSD';
    case 'Tail_Room'
        tsd_used='tsd([Range(Temp.TailTemperatureTSD)],[Data(Temp.TailTemperatureTSD)-0.804.*Data(Temp.RoomTemperatureTSD)])';
    case 'Body_Room'
        tsd_used='tsd([Range(Temp.TailTemperatureTSD)],[Data(Temp.BodyTemperatureTSD)-0.561.*Data(Temp.RoomTemperatureTSD)])';
    case 'Mouse_Room'
        tsd_used='tsd([Range(Temp.TailTemperatureTSD)],[Data(Temp.MouseTemperatureTSD)-0.381.*Data(Temp.RoomTemperatureTSD)])';
    otherwise
        disp('ERROR')
end

MeanTailTempFzEp=[]; MeanTailTempMarginsBef=[]; MeanTailTempMarginsAft=[]; sess_length=[];
AllSpeedEp=[]; AllSpeedBef=[]; AllSpeedAft=[]; 
AllAccEp=[]; AllAccBef=[]; AllAccAft=[];
missed_sessions = {}; data_number=[]; data_number_bef=[]; data_number_aft=[];
AllRgEp=[]; AllRgBef=[]; AllRgAft=[];
for ff=1:length(FolderList.(Mouse_name{1}).Fear)
    clear FzEp;  clear MarginsBef; clear MarginsAft;
    clear FzEp2; clear MarginsBef2; clear MarginsAft2;
    clear FzEpRg; clear MarginsBefRg; clear MarginsAftRg;
    clear SpeedEp; clear SpeedBef; clear SpeedAft;
    clear AccEp; clear AccBef; clear AccAft;
    clear AccEp2; clear AccBef2; clear AccAft2;
    try cd([FolderList.(Mouse_name{1}).Fear{ff}  '/Temperature'])
        
        load('behavResources_SB.mat')
        load('Temperature.mat')
        % Making Vtsd as long as Xtsd
        DataSpeed=Data(Behav.Vtsd);
        DataSpeed(end+1)=DataSpeed(end);
        RangeSpeed=Range(Behav.Vtsd);
        RangeSpeed(end+1)=RangeSpeed(end)+1;
        Behav.Vtsd=tsd(RangeSpeed,DataSpeed);
        
        StartFzEpoch=Start(eval(ChosenEpoch));
        StopFzEpoch=Stop(eval(ChosenEpoch));
        
        rg=Range(eval(tsd_used)); dt=Data(eval(tsd_used));
        dt_V=Data(Behav.Vtsd);
        rg_Acc=Range(Behav.MovAcctsd); dt_Acc=Data(Behav.MovAcctsd);
        %Data for a session
        if ~isempty(StartFzEpoch)
            for ep=1:length(StartFzEpoch)
                % episode logical ranks
                FzEp(:,ep)=(rg>StartFzEpoch(ep))&(rg<StopFzEpoch(ep));
                MarginsBef(:,ep)=rg>(StartFzEpoch(ep)-margins*10e3)&rg<(StartFzEpoch(ep));
                MarginsAft(:,ep) = rg>(StopFzEpoch(ep))&rg<(StopFzEpoch(ep)+5*10e3);
                data_number=[data_number length(dt(FzEp(:,ep)))];
                data_number_bef=[data_number_bef length(dt(MarginsBef(:,ep)))];
                data_number_aft=[data_number_aft length(dt(MarginsAft(:,ep)))];
                
                % Temperature
                FzEp2(1:length(dt(FzEp(:,ep))),ep)=dt(FzEp(:,ep));
                MarginsBef2(1:length(dt(MarginsBef(:,ep))),ep)=dt(MarginsBef(:,ep));
                MarginsAft2(1:length(dt(MarginsAft(:,ep))),ep)=dt(MarginsAft(:,ep));
                
                %Range
                FzEpRg(1:length(dt(FzEp(:,ep))),ep)=rg(FzEp(:,ep));
                MarginsBefRg(1:length(dt(MarginsBef(:,ep))),ep)=rg(MarginsBef(:,ep));
                MarginsAftRg(1:length(dt(MarginsAft(:,ep))),ep)=rg(MarginsAft(:,ep));
                
                %Speed
                SpeedEp(1:length(dt_V(FzEp(:,ep))),ep)=dt_V(FzEp(:,ep));
                SpeedBef(1:length(dt_V(MarginsBef(:,ep))),ep)=dt_V(MarginsBef(:,ep));
                SpeedAft(1:length(dt_V(MarginsAft(:,ep))),ep)=dt_V(MarginsAft(:,ep));
                
                % episode Accelero logical ranks
                AccEp(:,ep)=(rg_Acc>StartFzEpoch(ep))&(rg_Acc<StopFzEpoch(ep));
                AccBef(:,ep)=rg_Acc>(StartFzEpoch(ep)-margins*10e3)&rg_Acc<(StartFzEpoch(ep));
                AccAft(:,ep)=rg_Acc>(StopFzEpoch(ep))&rg_Acc<(StopFzEpoch(ep)+5*10e3);
                
                AccEp2(1:length(dt_Acc(AccEp(:,ep))),ep)=dt_Acc(AccEp(:,ep));
                AccBef2(1:length(dt_Acc(AccBef(:,ep))),ep)=dt_Acc(AccBef(:,ep));
                AccAft2(1:length(dt_Acc(AccAft(:,ep))),ep)=dt_Acc(AccAft(:,ep));
                
                sess_length= [sess_length StopFzEpoch(ep)-StartFzEpoch(ep)];
                %sess_length is the duration of each freezing episodes
            end
            
            % Stim, put the time before freezing epoch in an array
            StartStim=Start(TTLInfo.StimEpoch);
            for stim=1:length(StartStim)
                for ep=1:size(MarginsBefRg,2)
                    EndOfArray=MarginsBefRg(MarginsBefRg(:,ep)~=0,ep);
                    if StartStim(stim)>MarginsBefRg(1,ep)&StartStim(stim)<EndOfArray(end)
                        Episodes.FindStim(ff,ep)=EndOfArray(end)-StartStim(stim);
                    end
                end
            end
            
            %Data for all sessions
            MeanTailTempFzEp(1:size(FzEp2,1),end+1:end+size(FzEp2,2))=FzEp2;
            MeanTailTempMarginsBef(1:size(MarginsBef2,1),end+1:end+size(MarginsBef2,2))=MarginsBef2;
            MeanTailTempMarginsAft(1:size(MarginsAft2,1),end+1:end+size(MarginsAft2,2))=MarginsAft2;
            
            AllSpeedEp(1:size(SpeedEp,1),end+1:end+size(SpeedEp,2))=SpeedEp;
            AllSpeedBef(1:size(SpeedBef,1),end+1:end+size(SpeedBef,2))=SpeedBef;
            AllSpeedAft(1:size(SpeedAft,1),end+1:end+size(SpeedAft,2))=SpeedAft;
            
            AllAccEp(1:size(AccEp2,1),end+1:end+size(AccEp2,2))=AccEp2;
            AllAccBef(1:size(AccBef2,1),end+1:end+size(AccBef2,2))=AccBef2;
            AllAccAft(1:size(AccAft2,1),end+1:end+size(AccAft2,2))=AccAft2;
            
            AllRgEp(1:size(FzEpRg,1),end+1:end+size(FzEpRg,2))=FzEpRg;
            AllRgBef(1:size(MarginsBefRg,1),end+1:end+size(MarginsBefRg,2))=MarginsBefRg;
            AllRgAft(1:size(MarginsAftRg,1),end+1:end+size(MarginsAftRg,2))=MarginsAftRg;
            
        else
        end
        
    catch missed_sessions{ff}=FolderList.(Mouse_name{1}).Fear{ff};
    end
end


if isempty(MeanTailTempMarginsBef)
    Episodes=[];
else
    % deleting too long episodes
    ind=find(data_number>6*size(MeanTailTempMarginsBef,1));
    MeanTailTempFzEp(:,ind)=NaN;
    
    MeanTailTempFzEp(MeanTailTempFzEp==0)=NaN;
    MeanTailTempMarginsBef(MeanTailTempMarginsBef==0)=NaN;
    MeanTailTempMarginsAft(MeanTailTempMarginsAft==0)=NaN;
    
    %delete episodes with full nan or one value
    %n=0;
    %for sess=1:size(MeanTailTempFzEp,2)-n
    % if sum(isnan(MeanTailTempFzEp(:,sess-n)))-length(MeanTailTempFzEp(:,sess-n))>-2
    %      MeanTailTempFzEp(:,sess-n) = [];
    %   MeanTailTempMarginsBef(:,sess-n)= [];
    %MeanTailTempMarginsAft(:,sess-n)= [];
    %sess_length(sess-n)= [];
    %data_number(sess-n)=[];
    %n=n+1;
    %  end
    %end
    
    Episodes.sess_length=sess_length;
    
    %data interpolation
    norm_value=100;
    norm_value_bef=10*margins;
    norm_value_aft=50;
    clear MeanTailTempFzEp2; clear MeanTailTempMarginsBef2; clear MeanTailTempMarginsAft2;
    for sess=1:size(MeanTailTempFzEp,2)
        try MeanTailTempFzEp2(:,sess)  = interp1(linspace(0,1,data_number(sess)),MeanTailTempFzEp(1:data_number(sess),sess),linspace(0,1,norm_value));
        catch MeanTailTempFzEp2(:,sess)  =nan(norm_value,1);
        end
        try MeanTailTempMarginsBef2(:,sess)  = interp1(linspace(0,1,data_number_bef(sess)),MeanTailTempMarginsBef(1:data_number_bef(sess),sess),linspace(0,1,norm_value_bef));
        catch MeanTailTempMarginsBef2(:,sess)  = nan(norm_value,1);
        end
        % Freezing Episodes before the end
        if data_number_aft(sess)~=0
            try
                MeanTailTempMarginsAft2(:,sess)  = interp1(linspace(0,1,data_number_aft(sess)),MeanTailTempMarginsAft(1:data_number_aft(sess),sess),linspace(0,1,norm_value_aft));
                AllSpeedAft2(:,sess)  = interp1(linspace(0,1,data_number_aft(sess)),AllSpeedAft(1:data_number_aft(sess),sess),linspace(0,1,norm_value_aft));
                AllAccAft2(:,sess)  = interp1(linspace(0,1,sum(AllAccAft(:,sess)>0)),AllAccAft(1:sum(AllAccAft(:,sess)>0),sess),linspace(0,1,norm_value_aft));
            catch
                MeanTailTempMarginsAft2(:,sess)  =nan(norm_value_aft,1);
                AllSpeedAft2(:,sess)  =nan(norm_value_aft,1);
                AllAccAft2(:,sess)  =nan(norm_value_aft,1);
            end
                else
                    MeanTailTempMarginsAft2(:,sess)  =nan(norm_value_aft,1);
                    AllSpeedAft2(:,sess)  =nan(norm_value_aft,1);
                    AllAccAft2(:,sess)  =nan(norm_value_aft,1);
            end
            
            try AllSpeedEp2(:,sess)  = interp1(linspace(0,1,data_number(sess)),AllSpeedEp(1:data_number(sess),sess),linspace(0,1,norm_value));
            catch AllSpeedEp2(:,sess)  =nan(norm_value,1);
            end
            try AllSpeedBef2(:,sess)  = interp1(linspace(0,1,data_number_bef(sess)),AllSpeedBef(1:data_number_bef(sess),sess),linspace(0,1,norm_value_bef));
            catch AllSpeedBef2(:,sess)  =nan(norm_value,1);
            end
            try AllAccEp2(:,sess)  = interp1(linspace(0,1,sum(AllAccEp(:,sess)>0)),AllAccEp(1:sum(AllAccEp(:,sess)>0),sess),linspace(0,1,norm_value));
            catch AllAccEp2(:,sess)  =nan(norm_value,1);
            end
            try AllAccBef2(:,sess)  = interp1(linspace(0,1,data_number_bef(sess)),AllAccBef(1:data_number_bef(sess),sess),linspace(0,1,norm_value_bef));
            catch AllAccBef2(:,sess)  =nan(norm_value,1);
            end
        end
        AllAccAft2(AllAccAft2==0)=NaN;
        AllSpeedAft2(AllSpeedAft2==0)=NaN;
        MeanTailTempMarginsAft2(MeanTailTempMarginsAft2==0)=NaN;
        
        % Real time analysis
        Episodes.TempBefRealTime = TsdToRealTime_BM(AllRgBef,MeanTailTempMarginsBef,margins);
        Episodes.TempAftRealTime = TsdToRealTime_BM(AllRgAft,MeanTailTempMarginsAft,5);
        Episodes.TempFreezingNormalized=nanmean(MeanTailTempFzEp2');
        Episodes.TempRealTime=[Episodes.TempBefRealTime Episodes.TempFreezingNormalized Episodes.TempAftRealTime];
        
        Episodes.freezing_episodes=MeanTailTempFzEp;
        Episodes.freezing_episodesRg=AllRgEp;
        
        %gathering data
        Episodes.Together= [MeanTailTempMarginsBef2; MeanTailTempFzEp2;MeanTailTempMarginsAft2];
        Episodes.meanFzEpandMargins=nanmean(Episodes.Together');
        Episodes.SpeedTogether=[AllSpeedBef2 ; AllSpeedEp2 ; AllSpeedAft2];
        Episodes.AccTogether=[AllAccBef2 ; AllAccEp2 ; AllAccAft2];
        Episodes.RgTogether=[AllRgBef ; AllRgEp ; AllRgAft];
        
        %Making an array with all data in real time (only take non NaN values for
        %Freezing Episodes)
        for i=1:size(MeanTailTempFzEp,2)
            int=[MeanTailTempFzEp(~isnan(MeanTailTempFzEp(:,i)),i) ; MeanTailTempMarginsAft(:,i)];
            Episodes.Together_RealTime(1:length(int),i)=int;
            data_numb(ep)=sum(~ isnan(MeanTailTempFzEp(:,i)));
        end
        Episodes.Together_RealTime=[MeanTailTempMarginsBef ; Episodes.Together_RealTime];
        Episodes.Together_RealTime(Episodes.Together_RealTime==0)=NaN;
        
        %Making std on this array
        for ep=1:size(Episodes.Together_RealTime,2)
            for i=6:length(Episodes.Together_RealTime(:,ep))-5
                Episodes.local_stdRealTime(i,ep)=nanstd(Episodes.Together_RealTime(i-5:i+5,ep));
                data_numb(ep)=sum(~ isnan(MeanTailTempFzEp(:,ep)));
            end
        end
        Episodes.local_stdRealTime(end+5,1)=0;
        Episodes.local_stdRealTime(Episodes.local_stdRealTime==0)=NaN;
        
        %Put the before/FzEp/aftervalues in specific arrays
        Episodes.local_stdBef=Episodes.local_stdRealTime(1:size(MeanTailTempMarginsBef,1),:);
        Episodes.local_stdBef(Episodes.local_stdBef==0)=NaN;
        for ep=1:size(Episodes.Together_RealTime,2)
            int=Episodes.local_stdRealTime([size(MeanTailTempMarginsBef,1)+1:size(MeanTailTempMarginsBef,1)+data_numb(ep)],ep);
            Episodes.local_stdFzEp(1:length(int),ep)=int;
        end
        Episodes.local_stdFzEp(Episodes.local_stdFzEp==0)=NaN;
        for ep=1:size(Episodes.Together_RealTime,2)
            int=Episodes.local_stdRealTime([size(MeanTailTempMarginsBef,1)+data_numb(ep):size(MeanTailTempMarginsBef,1)+data_numb(ep)+size(MeanTailTempMarginsAft,1)],ep);
            Episodes.local_stdAft(1:length(int),ep)=int;
        end
        Episodes.local_stdAft(Episodes.local_stdAft==0)=NaN;
        
        %data interpolation
        norm_value=100;
        clear Episodes.local_stdFzEp2; clear Episodes.local_stdBef2; clear Episodes.local_stdAft2;
        for sess=1:size(Episodes.local_stdFzEp,2)
            try Episodes.local_stdFzEp2(:,sess)  = interp1(linspace(0,1,sum(Episodes.local_stdFzEp(:,sess)>0)),Episodes.local_stdFzEp(1:sum(Episodes.local_stdFzEp(:,sess)>0),sess),linspace(0,1,norm_value));
            catch Episodes.local_stdFzEp2(:,sess)  = nan(norm_value,1);
            end
            try Episodes.local_stdBef2(:,sess)  = interp1(linspace(0,1,sum( Episodes.local_stdBef(:,sess)>0)), Episodes.local_stdBef(1:sum( Episodes.local_stdBef(:,sess)>0),sess),linspace(0,1,norm_value));
            catch Episodes.local_stdBef2(:,sess)  = nan(norm_value,1);
            end
            try Episodes.local_stdAft2(:,sess)  = interp1(linspace(0,1,sum( Episodes.local_stdAft(:,sess)>0)), Episodes.local_stdAft(1:sum( Episodes.local_stdAft(:,sess)>0),sess),linspace(0,1,norm_value));
            catch Episodes.local_stdAft2(:,sess)  =nan(norm_value,1);
            end
        end
        
        %gathering data
        Episodes.stdTogether= [ Episodes.local_stdBef2; Episodes.local_stdFzEp2; Episodes.local_stdAft2(1:95,:)];
        Episodes.Mean_local_stdFzEpandMargins=nanmean(Episodes.stdTogether');
        
        %real time errorbar
        for i=1:300
            Episodes.Errorbar(i)=1.96*(nanstd(Episodes.Together(i,:)))/sqrt(size(MeanTailTempMarginsBef,2));
        end
    end
end
