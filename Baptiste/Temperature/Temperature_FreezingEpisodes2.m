function Episodes = Temperature_FreezingEpisodes2(Mouse_name,FolderList,ChosenEpoch,tsd_used,margins,ZonesTemperatu)

Mouse_name={['M' num2str(Mouse_name)]};

switch ChosenEpoch
    case 'Fz'
        StartFzEpoch=Start(ZonesTemperatu.Tail_Room.(Mouse_name{1}).FreezeEpoch);
        StopFzEpoch=Stop(ZonesTemperatu.Tail_Room.(Mouse_name{1}).FreezeEpoch);
    case 'Shock'
        StartFzEpoch=Start(and(ZonesTemperatu.Tail_Room.(Mouse_name{1}).FreezeEpoch,or(ZonesTemperatu.Tail_Room.(Mouse_name{1}).ZoneEpoch{1},ZonesTemperatu.Tail_Room.(Mouse_name{1}).ZoneEpoch{4})));
        StopFzEpoch=Stop(and(ZonesTemperatu.Tail_Room.(Mouse_name{1}).FreezeEpoch,or(ZonesTemperatu.Tail_Room.(Mouse_name{1}).ZoneEpoch{1},ZonesTemperatu.Tail_Room.(Mouse_name{1}).ZoneEpoch{4})));
    case 'Safe'
        StartFzEpoch=Start(and(ZonesTemperatu.Tail_Room.(Mouse_name{1}).FreezeEpoch,or(ZonesTemperatu.Tail_Room.(Mouse_name{1}).ZoneEpoch{2},ZonesTemperatu.Tail_Room.(Mouse_name{1}).ZoneEpoch{5})));
        StopFzEpoch=Stop(and(ZonesTemperatu.Tail_Room.(Mouse_name{1}).FreezeEpoch,or(ZonesTemperatu.Tail_Room.(Mouse_name{1}).ZoneEpoch{2},ZonesTemperatu.Tail_Room.(Mouse_name{1}).ZoneEpoch{5})));
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
        TempData=ZonesTemperatu.Tail_Room.(Mouse_name{1});
    case 'Body_Room'
    case 'Mouse_Room'
    otherwise
        disp('ERROR')
end

if isempty(StartFzEpoch)
    Episodes=[];
else
    
    missed_sessions = {}; data_number=[]; data_number_bef=[]; data_number_aft=[];
    clear TempFzEp;  clear TempMarginsBef; clear TempMarginsAft;
    clear TempFzEpTrue; clear TempMarginsBefTrue; clear TempMarginsAftTrue;
    clear FzEpRg; clear MarginsBefRg; clear MarginsAftRg;
    clear SpeedEp; clear SpeedBef; clear SpeedAft;
    clear AccEp; clear AccBef; clear AccAft;
    clear AccEpTrue; clear AccBefTrue; clear AccAftTrue;
    clear rg; clear dt; clear dt_V; clear rg_Acc; clear dt_Acc

    % Speed and Accelero tsd
    SpeedConcat=ConcatenateDataFromFolders_BM(FolderList.(Mouse_name{1}).Fear,'speed');
    AccConcat=ConcatenateDataFromFolders_BM(FolderList.(Mouse_name{1}).Fear,'accelero');
    
    rg=Range(ZonesTemperatu.Tail_Room.(Mouse_name{1}).Fear);
    dt=Data(ZonesTemperatu.Tail_Room.(Mouse_name{1}).Fear);
    dt_V=Data(SpeedConcat); dt_V(end+1:end+length(FolderList.(Mouse_name{1}).Fear))=ones(length(FolderList.(Mouse_name{1}).Fear),1);
    rg_Acc=Range(AccConcat); dt_Acc=Data(AccConcat);
    %Data for a session
    for ep=1:length(StartFzEpoch)
        % episode logical ranks
        TempFzEpTrue(:,ep)=(rg>StartFzEpoch(ep))&(rg<StopFzEpoch(ep));
        TempBefTrue(:,ep)=rg>(StartFzEpoch(ep)-margins*10e3)&rg<(StartFzEpoch(ep));
        TempAftTrue(:,ep) = rg>(StopFzEpoch(ep))&rg<(StopFzEpoch(ep)+30*10e3);
        data_number(ep)=length(dt(TempFzEpTrue(:,ep)));
        data_number_bef(ep)=length(dt(TempBefTrue(:,ep)));
        data_number_aft(ep)=length(dt(TempAftTrue(:,ep)));
        
        % Temperature
        TempFzEp(1:length(dt(TempFzEpTrue(:,ep))),ep)=dt(TempFzEpTrue(:,ep));
        TempMarginsBef(1:length(dt(TempBefTrue(:,ep))),ep)=dt(TempBefTrue(:,ep));
        TempMarginsAft(1:length(dt(TempAftTrue(:,ep))),ep)=dt(TempAftTrue(:,ep));
        
        %Range
        FzEpRg(1:length(dt(TempFzEpTrue(:,ep))),ep)=rg(TempFzEpTrue(:,ep));
        MarginsBefRg(1:length(dt(TempBefTrue(:,ep))),ep)=rg(TempBefTrue(:,ep));
        MarginsAftRg(1:length(dt(TempAftTrue(:,ep))),ep)=rg(TempAftTrue(:,ep));
        
        %Speed
        SpeedEp(1:length(dt_V(TempFzEpTrue(:,ep))),ep)=dt_V(TempFzEpTrue(:,ep));
        SpeedBef(1:length(dt_V(TempBefTrue(:,ep))),ep)=dt_V(TempBefTrue(:,ep));
        SpeedAft(1:length(dt_V(TempAftTrue(:,ep))),ep)=dt_V(TempAftTrue(:,ep));
        
        % episode Accelero logical ranks
        AccEptrue(:,ep)=(rg_Acc>StartFzEpoch(ep))&(rg_Acc<StopFzEpoch(ep));
        AccBefTrue(:,ep)=rg_Acc>(StartFzEpoch(ep)-margins*10e3)&rg_Acc<(StartFzEpoch(ep));
        AccAftTrue(:,ep)=rg_Acc>(StopFzEpoch(ep))&rg_Acc<(StopFzEpoch(ep)+5*10e3);
        
        AccEp(1:length(dt_Acc(AccEptrue(:,ep))),ep)=dt_Acc(AccEptrue(:,ep));
        AccBef(1:length(dt_Acc(AccBefTrue(:,ep))),ep)=dt_Acc(AccBefTrue(:,ep));
        AccAft(1:length(dt_Acc(AccAftTrue(:,ep))),ep)=dt_Acc(AccAftTrue(:,ep));
        
        sess_length(ep)= StopFzEpoch(ep)-StartFzEpoch(ep);
        %sess_length is the duration of each freezing episodes
    end
    
    % Stim, put the time before freezing epoch in an array
    StimEpoch=ConcatenateDataFromFolders_BM(FolderList.(Mouse_name{1}).Fear,'Epoch','epochname','stimepoch');
    StartStim=Start(StimEpoch);
    for stim=1:length(StartStim)
        for ep=1:size(MarginsBefRg,2)
            EndOfArrayBef=MarginsBefRg(MarginsBefRg(:,ep)~=0,ep);
            EndOfArrayAft=MarginsAftRg(MarginsAftRg(:,ep)~=0,ep);
            EndOfArray=FzEpRg(FzEpRg(:,ep)~=0,ep);
            if isempty(EndOfArray); EndOfArray=1; end
            if StartStim(stim)>MarginsBefRg(1,ep)&StartStim(stim)<EndOfArrayBef(end)
                Episodes.FindStimBef(ep)=EndOfArrayBef(end)-StartStim(stim);
            elseif StartStim(stim)>MarginsAftRg(1,ep)&StartStim(stim)<EndOfArrayAft(end)
                Episodes.FindStimAft(ep)=EndOfArrayAft(end)-StartStim(stim);
            elseif FzEpRg(1,ep)>0&StartStim(stim)>FzEpRg(1,ep)&StartStim(stim)<EndOfArray(end)
                Episodes.FindStim(ep)=EndOfArray(end)-StartStim(stim);
            end
        end
    end
  %  if ~isempty(Episodes.FindStim)
 %       Episodes.FindStim=Episodes.FindStim(Episodes.FindStim~=0);
 %   end
    
    
    if isempty(TempMarginsBef)
        Episodes=[];
    else
        % deleting too long episodes
        ind=find(sess_length>300000);
        TempFzEp(:,ind)=NaN;
        
        TempFzEp(TempFzEp==0)=NaN;
        TempMarginsBef(TempMarginsBef==0)=NaN;
        TempMarginsAft(TempMarginsAft==0)=NaN;
        
        Episodes.sess_length=sess_length;
        
        %data interpolation
        norm_value=100;
        norm_value_bef=10*margins;
        norm_value_aft=300;
        clear TempFzEpInterp; clear TempMarginsBefInterp; clear TempMarginsAftInterp;
        clear SpeedAftInter; clear SpeedBefInter; clear SpeedEpInter;
        
        for sess=1:size(TempFzEp,2)
            % Temperature
            try TempFzEpInterp(:,sess)  = interp1(linspace(0,1,data_number(sess)),TempFzEp(1:data_number(sess),sess),linspace(0,1,norm_value));
            catch TempFzEpInterp(:,sess)  =nan(norm_value,1);
            end
            try TempMarginsBefInterp(:,sess)  = interp1(linspace(0,1,data_number_bef(sess)),TempMarginsBef(1:data_number_bef(sess),sess),linspace(0,1,norm_value_bef));
            catch TempMarginsBefInterp(:,sess)  = nan(norm_value,1);
            end
            try TempMarginsAftInterp(:,sess)  = interp1(linspace(0,1,data_number_aft(sess)),TempMarginsAft(1:data_number_aft(sess),sess),linspace(0,1,norm_value_aft));
            catch TempMarginsAftInterp(:,sess)  =nan(norm_value_aft,1);
            end
            %Speed
            try SpeedAftInterp(:,sess)  = interp1(linspace(0,1,data_number_aft(sess)),SpeedAft(1:data_number_aft(sess),sess),linspace(0,1,norm_value_aft));
            catch SpeedAftInterp(:,sess)  =nan(norm_value_aft,1);
            end
            try SpeedEpInterp(:,sess)  = interp1(linspace(0,1,data_number(sess)),SpeedEp(1:data_number(sess),sess),linspace(0,1,norm_value));
            catch SpeedEpInterp(:,sess)  =nan(norm_value,1);
            end
            try SpeedBefInterp(:,sess)  = interp1(linspace(0,1,data_number_bef(sess)),SpeedBef(1:data_number_bef(sess),sess),linspace(0,1,norm_value_bef));
            catch SpeedBefInterp(:,sess)  =nan(norm_value,1);
            end
            % Accelero
            try AccAftInterp(:,sess)  = interp1(linspace(0,1,sum(AccAft(:,sess)>0)),AccAft(1:sum(AccAft(:,sess)>0),sess),linspace(0,1,norm_value_aft));
            catch AccAftInterp(:,sess)  =nan(norm_value_aft,1);
            end
            try AccEpInterp(:,sess)  = interp1(linspace(0,1,sum(AccEp(:,sess)>0)),AccEp(1:sum(AccEp(:,sess)>0),sess),linspace(0,1,norm_value));
            catch AccEpInterp(:,sess)  =nan(norm_value,1);
            end
            try AccBefInterp(:,sess)  = interp1(linspace(0,1,data_number_bef(sess)),AccBef(1:data_number_bef(sess),sess),linspace(0,1,norm_value_bef));
            catch AccBefInterp(:,sess)  =nan(norm_value,1);
            end
        end
        AccAftInterp(AccAftInterp==0)=NaN;
        SpeedAftInterp(SpeedAftInterp==0)=NaN;
        TempMarginsAftInterp(TempMarginsAftInterp==0)=NaN;
        
        % Real time analysis
        Episodes.TempBefRealTime = TsdToRealTime_BM(MarginsBefRg,TempMarginsBef,margins);
        Episodes.TempAftRealTime = TsdToRealTime_BM(MarginsAftRg,TempMarginsAft,5);
        Episodes.TempFreezingNormalized=nanmean(TempFzEpInterp');
        Episodes.TempRealTime=[Episodes.TempBefRealTime Episodes.TempFreezingNormalized Episodes.TempAftRealTime];
        
        Episodes.freezing_episodes=TempFzEp;
        Episodes.freezing_episodesRg=FzEpRg;
        
        %gathering data
        Episodes.Together= [TempMarginsBefInterp; TempFzEpInterp;TempMarginsAftInterp];
        Episodes.meanFzEpandMargins=nanmean(Episodes.Together');
        Episodes.SpeedTogether=[SpeedBefInterp ; SpeedEpInterp ; SpeedAftInterp];
        Episodes.AccTogether=[AccBefInterp ; AccEpInterp ; AccAftInterp];
        Episodes.RgTogether=[MarginsBefRg ; FzEpRg ; MarginsAftRg];
        
        %Making an array with all data in real time (only take non NaN values for
        %Freezing Episodes)
        for i=1:size(TempFzEp,2)
            int=[TempFzEp(~isnan(TempFzEp(:,i)),i) ; TempMarginsAft(:,i)];
            Episodes.Together_RealTime(1:length(int),i)=int;
            data_numb(ep)=sum(~ isnan(TempFzEp(:,i)));
        end
        Episodes.Together_RealTime=[TempMarginsBef ; Episodes.Together_RealTime];
        Episodes.Together_RealTime(Episodes.Together_RealTime==0)=NaN;
        
        %Making std on this array
        for ep=1:size(Episodes.Together_RealTime,2)
            for i=6:length(Episodes.Together_RealTime(:,ep))-5
                Episodes.local_stdRealTime(i,ep)=nanstd(Episodes.Together_RealTime(i-5:i+5,ep));
                data_numb(ep)=sum(~ isnan(TempFzEp(:,ep)));
            end
        end
        Episodes.local_stdRealTime(end+5,1)=0;
        Episodes.local_stdRealTime(Episodes.local_stdRealTime==0)=NaN;
        
        %Put the before/FzEp/aftervalues in specific arrays
        Episodes.local_stdBef=Episodes.local_stdRealTime(1:size(TempMarginsBef,1),:);
        Episodes.local_stdBef(Episodes.local_stdBef==0)=NaN;
        for ep=1:size(Episodes.Together_RealTime,2)
            int=Episodes.local_stdRealTime([size(TempMarginsBef,1)+1:size(TempMarginsBef,1)+data_numb(ep)],ep);
            Episodes.local_stdFzEp(1:length(int),ep)=int;
        end
        Episodes.local_stdFzEp(Episodes.local_stdFzEp==0)=NaN;
        for ep=1:size(Episodes.Together_RealTime,2)
            int=Episodes.local_stdRealTime([size(TempMarginsBef,1)+data_numb(ep):size(TempMarginsBef,1)+data_numb(ep)+size(TempMarginsAft,1)],ep);
            Episodes.local_stdAft(1:length(int),ep)=int;
        end
        Episodes.local_stdAft(Episodes.local_stdAft==0)=NaN;
        
        %data interpolation
        norm_value=100;
        norm_value_bef=10*margins;
        norm_value_aft=300;
        clear Episodes.local_stdFzEpInterp; clear Episodes.local_stdBefInterp; clear Episodes.local_stdAftInterp;
        for sess=1:size(Episodes.local_stdFzEp,2)
            try Episodes.local_stdFzEpInterp(:,sess)  = interp1(linspace(0,1,data_number(sess)),Episodes.local_stdFzEp(1:data_number(sess),sess),linspace(0,1,norm_value));
            catch Episodes.local_stdFzEpInterp(:,sess)  = nan(norm_value,1);
            end
            try Episodes.local_stdBefInterp(:,sess)  = interp1(linspace(0,1,data_number_bef(sess)), Episodes.local_stdBef(1:data_number_bef(sess),sess),linspace(0,1,norm_value_bef));
            catch Episodes.local_stdBefInterp(:,sess)  = nan(norm_value,1);
            end
            try Episodes.local_stdAftInterp(:,sess)  = interp1(linspace(0,1,data_number_aft(sess)), Episodes.local_stdAft(1:data_number_aft(sess),sess),linspace(0,1,norm_value_aft));
            catch Episodes.local_stdAftInterp(:,sess)  =nan(norm_value,1);
            end
        end
        
        %gathering data
        Episodes.stdTogether= [ Episodes.local_stdBefInterp; Episodes.local_stdFzEpInterp; Episodes.local_stdAftInterp(1:95,:)];
        Episodes.Mean_local_stdFzEpandMargins=nanmean(Episodes.stdTogether');
        
        %real time errorbar
        for i=1:300
            Episodes.Errorbar(i)=1.96*(nanstd(Episodes.Together(i,:)))/sqrt(size(TempMarginsBef,2));
        end

    end
end
end