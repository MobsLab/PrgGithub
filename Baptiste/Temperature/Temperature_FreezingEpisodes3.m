

function Episodes = Temperature_FreezingEpisodes3(Mouse_name,FolderList,ChosenEpoch,margins,IsTTemp,IsMTemp,IsSpeed,IsHR,IsRespi,IsOBSpectrum,IsLocalAnalysis)

Mouse_name={['M' num2str(Mouse_name)]};

% Data Pre/Post
% Accelerometer/Speed/Temperature/Respi/HeartRate

% For sleep epoch
try
    SleepEpoch=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'epoch','epochname','sleepstates');
    if margins==10
        SleepEpoch{1} = dropShortIntervals(SleepEpoch{1}, 10e4);
        SleepEpoch{2} = dropShortIntervals(SleepEpoch{2}, 10e4);
        SleepEpoch{3} = dropShortIntervals(SleepEpoch{3}, 10e4);
    else
        disp('ERROR')
    end
end

switch ChosenEpoch
    case 'Fz'
        Epoch_of_Interest=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'Epoch','epochname','freezeepoch');
    case 'Shock'
        Epoch_of=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'Epoch','epochname','freezeepoch');
        ZoneEpoch=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'Epoch','epochname','zoneepoch');
        Epoch_of_Interest=and(Epoch_of,ZoneEpoch{1});
    case 'Safe'
        Epoch_of=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'Epoch','epochname','freezeepoch');
        ZoneEpoch=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'Epoch','epochname','zoneepoch');
        Epoch_of_Interest=and(Epoch_of,or(ZoneEpoch{2},ZoneEpoch{5}));
    case 'NREM_REM_NREM'
        [aft_cell,bef_cell]=transEpoch(SleepEpoch{3},SleepEpoch{2});
        Epoch_of_Interest=and(aft_cell{1,2},bef_cell{1,2});
    case 'REM_NREM_REM'
        [aft_cell,bef_cell]=transEpoch(SleepEpoch{2},SleepEpoch{3});
        Epoch_of_Interest=and(aft_cell{1,2},bef_cell{1,2});
    otherwise
        disp('ERROR')
end

StartFzEpoch=Start(Epoch_of_Interest);
StopFzEpoch=Stop(Epoch_of_Interest);

% Keeping only episodes > 5s
%InfTo5s=find((StopFzEpoch-StartFzEpoch)<5e4);
%StartFzEpoch(InfTo5s)=0;
%StopFzEpoch(InfTo5s)=0;
%StartFzEpoch=StartFzEpoch(StartFzEpoch~=0);
%StopFzEpoch=StopFzEpoch(StopFzEpoch~=0);


if isempty(StartFzEpoch)
    Episodes=[];
else
    
    OnsetFreeze=StartFzEpoch/1e4;
    OffsetFreeze=StopFzEpoch/1e4;
    
    % Accelero
    try
        AccConcat=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'accelero');
    catch
        AccConcat=tsd([1e3:1005]',[1e3:1005]');
    end
    % Accelero Pre
    [M_Acc_Pre,T_Acc_Pre] = PlotRipRaw(AccConcat,OnsetFreeze, margins*1e3);
    close
    if ~isempty(M_Acc_Pre)
        T_Acc_Pre(T_Acc_Pre==0)=NaN;
        if length(OnsetFreeze)==1
            sess=1;
            T_Acc_Pre_Interp(sess,:)=interp1(linspace(0,1,size(T_Acc_Pre,1)),T_Acc_Pre(:,sess),linspace(0,1,margins*20));
        else
            for sess=1:size(T_Acc_Pre,1)
                T_Acc_Pre_Interp(sess,:)=interp1(linspace(0,1,size(T_Acc_Pre,2)),T_Acc_Pre(sess,:),linspace(0,1,margins*20));
            end
        end
        Episodes.Acc_Pre_Interp=T_Acc_Pre_Interp(:,1:margins*10);
    else
        Episodes.Acc_Pre_Interp=[];
    end
    % Accelero Post
    [M_Acc_Post,T_Acc_Post] = PlotRipRaw(AccConcat,OffsetFreeze, margins*1e3);
    close
    if ~isempty(M_Acc_Post)
        T_Acc_Post(T_Acc_Post==0)=NaN;
        if length(OnsetFreeze)==1
            sess=1;
            T_Acc_Post_Interp(sess,:)=interp1(linspace(0,1,size(T_Acc_Post,1)),T_Acc_Post(:,sess),linspace(0,1,margins*20));
        else
            for sess=1:size(T_Acc_Post,1)
                T_Acc_Post_Interp(sess,:)=interp1(linspace(0,1,size(T_Acc_Post,2)),T_Acc_Post(sess,:),linspace(0,1,margins*20));
            end
        end
        Episodes.Acc_Post_Interp=T_Acc_Post_Interp(:,margins*10+1:margins*20);
    else
        Episodes.Acc_Post_Interp=[];
    end
    
    rg_Acc=Range(AccConcat); dt_Acc=Data(AccConcat);
    %Data for a session
    for ep=1:length(StartFzEpoch)
        % Accelero
        AccEptrue(:,ep)=(rg_Acc>StartFzEpoch(ep))&(rg_Acc<StopFzEpoch(ep));
        AccEp(1:length(dt_Acc(AccEptrue(:,ep))),ep)=dt_Acc(AccEptrue(:,ep));
        
        sess_length(ep)= StopFzEpoch(ep)-StartFzEpoch(ep);
    end
    
    AccEp(AccEp==0)=NaN;
    Episodes.AccEp=AccEp;
    
    norm_value=margins*10;
    for sess=1:size(AccEp,2)
        try AccEpInterp(:,sess)  = interp1(linspace(0,1,sum(AccEp(:,sess)>0)),AccEp(1:sum(AccEp(:,sess)>0),sess),linspace(0,1,norm_value));
        catch AccEpInterp(:,sess)  =nan(norm_value,1);
        end
    end
    Episodes.AccTogether=[Episodes.Acc_Pre_Interp AccEpInterp'  Episodes.Acc_Post_Interp];
    
    
    % ------------------------------------------------------------------------------------------------------------------------------------------------------
    switch IsTTemp
        case 'Yes'
            
            % Tail Temp Pre
            try
                TTempData=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'tailtemperature');
                %RoomFear=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'roomtemperature');
                %TTempData=tsd([Range(TailFear)],[Data(TailFear)-0.804.*Data(RoomFear)]);
            catch
                TTempData=tsd([1e3:1005]',[1e3:1005]');
            end
            [M_TTemp_Pre,T_TTemp_Pre] = PlotRipRaw(TTempData,OnsetFreeze, margins*1e3);
            close
            if ~isempty(M_TTemp_Pre)
                T_TTemp_Pre(T_TTemp_Pre==0)=NaN;
                if length(OnsetFreeze)==1
                    sess=1;
                    T_TTemp_Pre_Interp(sess,:)=interp1(linspace(0,1,size(T_TTemp_Pre,1)),T_TTemp_Pre(:,sess),linspace(0,1,margins*20));
                else
                    for sess=1:size(T_TTemp_Pre,1)
                        T_TTemp_Pre_Interp(sess,:)=interp1(linspace(0,1,size(T_TTemp_Pre,2)),T_TTemp_Pre(sess,:),linspace(0,1,margins*20));
                    end
                end
                Episodes.TTemp_Pre_Interp=T_TTemp_Pre_Interp(:,1:margins*10);
            else
                Episodes.TTemp_Pre_Interp=[];
            end
            
            % Tail Temp Post
            [M_TTemp_Post,T_TTemp_Post] = PlotRipRaw(TTempData,OffsetFreeze, margins*1e3);
            close
            if ~isempty(M_TTemp_Post)
                T_TTemp_Post(T_TTemp_Post==0)=NaN;
                if length(OnsetFreeze)==1
                    sess=1;
                    T_TTemp_Post_Interp(sess,:)=interp1(linspace(0,1,size(T_TTemp_Post,1)),T_TTemp_Post(:,sess),linspace(0,1,margins*20));
                else
                    for sess=1:size(T_TTemp_Post,1)
                        T_TTemp_Post_Interp(sess,:)=interp1(linspace(0,1,size(T_TTemp_Post,2)),T_TTemp_Post(sess,:),linspace(0,1,margins*20));
                    end
                end
                Episodes.TTemp_Post_Interp=T_TTemp_Post_Interp(:,margins*10+1:margins*20);
            else
                Episodes.TTemp_Post_Interp=[];
            end
            
            data_number=[];
            rg_Temp=Range(TTempData);  dt_TTemp=Data(TTempData);
            for ep=1:length(StartFzEpoch)
                % Temperature
                TempFzEpTrue(:,ep)=(rg_Temp>StartFzEpoch(ep))&(rg_Temp<StopFzEpoch(ep));
                TTempFzEp(1:length(dt_TTemp(TempFzEpTrue(:,ep))),ep)=dt_TTemp(TempFzEpTrue(:,ep));
                
                data_number(ep)=length(dt_TTemp(TempFzEpTrue(:,ep)));
            end
            
            TTempFzEp(TTempFzEp==0)=NaN;
            
            Episodes.TTempEp = TTempFzEp;
            Episodes.sess_length=sess_length;
            
            for sess=1:size(TTempFzEp,2)
                try TTempFzEpInterp(:,sess)  = interp1(linspace(0,1,data_number(sess)),TTempFzEp(1:data_number(sess),sess),linspace(0,1,norm_value));
                catch TTempFzEpInterp(:,sess)  =nan(norm_value,1);
                end
            end
            Episodes.TTempTogether=[Episodes.TTemp_Pre_Interp TTempFzEpInterp'  Episodes.TTemp_Post_Interp];
            
        case 'No'
        otherwise
            disp('ERROR')
    end
    
    %------------------------------------------------------------------------------------------------------------------------------
    switch IsMTemp
        case 'Yes'
            
            % Mask Temp Pre
            try
                MTempData=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'masktemperature');
                %RoomFear=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'roomtemperature');
                %MTempData=tsd([Range(MaskFear)],[Data(MaskFear)-0.804.*Data(RoomFear)]);
            catch
                MTempData=tsd([1e3:1005]',[1e3:1005]');
            end
            [M_MTemp_Pre,T_MTemp_Pre] = PlotRipRaw(MTempData,OnsetFreeze, margins*1e3);
            close
            if ~isempty(M_MTemp_Pre)
                T_MTemp_Pre(T_MTemp_Pre==0)=NaN;
                if length(OnsetFreeze)==1
                    sess=1;
                    T_MTemp_Pre_Interp(sess,:)=interp1(linspace(0,1,size(T_MTemp_Pre,1)),T_MTemp_Pre(:,sess),linspace(0,1,margins*20));
                else
                    for sess=1:size(T_MTemp_Pre,1)
                        T_MTemp_Pre_Interp(sess,:)=interp1(linspace(0,1,size(T_MTemp_Pre,2)),T_MTemp_Pre(sess,:),linspace(0,1,margins*20));
                    end
                end
                Episodes.MTemp_Pre_Interp=T_MTemp_Pre_Interp(:,1:margins*10);
            else
                Episodes.MTemp_Pre_Interp=[];
            end
            
            % Mask Temp Post
            [M_MTemp_Post,T_MTemp_Post] = PlotRipRaw(MTempData,OffsetFreeze, margins*1e3);
            close
            if ~isempty(M_MTemp_Pre)
                T_MTemp_Post(T_MTemp_Post==0)=NaN;
                if length(OnsetFreeze)==1
                    sess=1;
                    T_MTemp_Post_Interp(sess,:)=interp1(linspace(0,1,size(T_MTemp_Post,1)),T_MTemp_Post(:,sess),linspace(0,1,margins*20));
                else
                    for sess=1:size(T_MTemp_Post,1)
                        T_MTemp_Post_Interp(sess,:)=interp1(linspace(0,1,size(T_MTemp_Post,2)),T_MTemp_Post(sess,:),linspace(0,1,margins*20));
                    end
                end
                Episodes.MTemp_Post_Interp=T_MTemp_Post_Interp(:,margins*10+1:margins*20);
            else
                Episodes.MTemp_Post_Interp=[];
            end
            
            data_number=[];
            rg_Temp=Range(MTempData);  dt_MTemp=Data(MTempData);
            for ep=1:length(StartFzEpoch)
                % Temperature
                TempFzEpTrue(:,ep)=(rg_Temp>StartFzEpoch(ep))&(rg_Temp<StopFzEpoch(ep));
                MTempFzEp(1:length(dt_MTemp(TempFzEpTrue(:,ep))),ep)=dt_MTemp(TempFzEpTrue(:,ep));
                
                data_number(ep)=length(dt_TTemp(TempFzEpTrue(:,ep)));
            end
            
            
            MTempFzEp(MTempFzEp==0)=NaN;
            
            Episodes.sess_length=sess_length;
            Episodes.MTempEp = MTempFzEp;
            
            for sess=1:size(MTempFzEp,2)
                try MTempFzEpInterp(:,sess)  = interp1(linspace(0,1,data_number(sess)),MTempFzEp(1:data_number(sess),sess),linspace(0,1,norm_value));
                catch MTempFzEpInterp(:,sess)  =nan(norm_value,1);
                end
            end
            Episodes.MTempTogether=[Episodes.MTemp_Pre_Interp MTempFzEpInterp'  Episodes.MTemp_Post_Interp];
            
        case 'No'
        otherwise
            disp('ERROR')
    end
    
    %---------------------------------------------------------------------------------------------------------------
    switch IsSpeed
        case 'Yes'
            
            SpeedConcat=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'speed');
            % Speed Pre
            [M_Speed_Pre,T_Speed_Pre] = PlotRipRaw(SpeedConcat,OnsetFreeze, margins*1e3);
            close
            T_Speed_Pre(T_Speed_Pre==0)=NaN;
            if length(OnsetFreeze)==1
                sess=1;
                T_Speed_Pre_Interp(sess,:)=interp1(linspace(0,1,size(T_Speed_Pre,1)),T_Speed_Pre(:,sess),linspace(0,1,margins*20));
            else
                for sess=1:size(T_Speed_Pre,1)
                    T_Speed_Pre_Interp(sess,:)=interp1(linspace(0,1,size(T_Speed_Pre,2)),T_Speed_Pre(sess,:),linspace(0,1,margins*20));
                end
            end
            Episodes.Speed_Pre_Interp=T_Speed_Pre_Interp(:,1:margins*10);
            
            % Speed Post
            [M_Speed_Post,T_Speed_Post] = PlotRipRaw(SpeedConcat,OffsetFreeze, margins*1e3);
            close
            T_Speed_Post(T_Speed_Post==0)=NaN;
            if length(OnsetFreeze)==1
                sess=1;
                T_Speed_Post_Interp(sess,:)=interp1(linspace(0,1,size(T_Speed_Post,1)),T_Speed_Post(:,sess),linspace(0,1,margins*20));
            else
                for sess=1:size(T_Speed_Post,1)
                    T_Speed_Post_Interp(sess,:)=interp1(linspace(0,1,size(T_Speed_Post,2)),T_Speed_Post(sess,:),linspace(0,1,margins*20));
                end
            end
            Episodes.Speed_Post_Interp=T_Speed_Post_Interp(:,margins*10+1:margins*20);
            
            dt_V=Data(SpeedConcat); dt_V(end+1:end+length(FolderList.(Mouse_name{1})))=dt_V(end-length(FolderList.(Mouse_name{1}))+1:end);
            %Data for a session
            for ep=1:length(StartFzEpoch)
                %Speed
                TempFzEpTrue(:,ep)=(rg_Temp>StartFzEpoch(ep))&(rg_Temp<StopFzEpoch(ep));
                SpeedEp(1:length(dt_V(TempFzEpTrue(:,ep))),ep)=dt_V(TempFzEpTrue(:,ep));
            end
            
            
            SpeedEp(SpeedEp==0)=NaN;
            
            Episodes.SpeedEp=SpeedEp;
            
            for sess=1:size(SpeedEp,2)
                try SpeedEpInterp(:,sess)  = interp1(linspace(0,1,sum(SpeedEp(:,sess)>0)),SpeedEp(1:sum(SpeedEp(:,sess)>0),sess),linspace(0,1,norm_value));
                catch SpeedEpInterp(:,sess)  =nan(norm_value,1);
                end
            end
            Episodes.SpeedTogether=[Episodes.Speed_Pre_Interp SpeedEpInterp'  Episodes.Speed_Post_Interp];
            
        case 'No'
        otherwise
            disp('ERROR')
    end
    
    %-------------------------------------------------------------------------------------------------------------------------------------
    switch IsHR
        case 'Yes'
            
            % Heart Rate Pre
            HRConcat=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'heartrate');
            if length(HRConcat)==0
                Episodes.HR_Pre_Interp=nan(size(Episodes.Acc_Post_Interp,1),300);
            else
                [M_HR_Pre,T_HR_Pre] = PlotRipRaw(HRConcat,OnsetFreeze, margins*1e3);
                close
                T_HR_Pre(T_HR_Pre==0)=NaN;
                if length(OnsetFreeze)==1
                    sess=1;
                    T_HR_Pre_Interp(sess,:)=interp1(linspace(0,1,size(T_HR_Pre,1)),T_HR_Pre(:,sess),linspace(0,1,margins*20));
                else
                    for sess=1:size(T_HR_Pre,1)
                        try T_HR_Pre_Interp(sess,:)=interp1(linspace(0,1,size(T_HR_Pre,2)),T_HR_Pre(sess,:),linspace(0,1,margins*20));
                        catch T_HR_Pre_Interp(:,sess)  =nan(size(Episodes.Acc_Post_Interp,1),1);
                        end
                    end
                end
                Episodes.HR_Pre_Interp=T_HR_Pre_Interp(:,1:margins*10);
            end
            
            % Heart Rate Post
            if length(HRConcat)==0
                Episodes.HR_Post_Interp=nan(size(Episodes.Acc_Post_Interp,1),300);
            else
                [M_HR_Post,T_HR_Post] = PlotRipRaw(HRConcat,OffsetFreeze, margins*1e3);
                close
                T_HR_Post(T_HR_Post==0)=NaN;
                if length(OnsetFreeze)==1
                    sess=1;
                    T_HR_Post_Interp(sess,:)=interp1(linspace(0,1,size(T_HR_Post,1)),T_HR_Post(:,sess),linspace(0,1,margins*20));
                else
                    for sess=1:size(T_HR_Post,1)
                        try T_HR_Post_Interp(sess,:)=interp1(linspace(0,1,size(T_HR_Post,2)),T_HR_Post(sess,:),linspace(0,1,margins*20));
                        catch T_HR_Post_Interp(:,sess)  =nan(size(Episodes.Acc_Post_Interp,1),1);
                        end
                    end
                end
                Episodes.HR_Post_Interp=T_HR_Post_Interp(:,margins*10+1:margins*20);
            end
            
            %-----------------------------------
            
            % HR Var Pre
            HRVarConcat=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'heartratevar');
            if length(HRVarConcat)==0
                Episodes.HRVar_Pre_Interp=nan(size(Episodes.Acc_Post_Interp,1),300);
            else
                [M_HRVar_Pre,T_HRVar_Pre] = PlotRipRaw(HRVarConcat,OnsetFreeze, margins*1e3);
                close
                T_HRVar_Pre(T_HRVar_Pre==0)=NaN;
                if length(OnsetFreeze)==1
                    sess=1;
                    T_HRVar_Pre_Interp(sess,:)=interp1(linspace(0,1,size(T_HRVar_Pre,1)),T_HRVar_Pre(:,sess),linspace(0,1,margins*20));
                else
                    for sess=1:size(T_HRVar_Pre,1)
                        try T_HRVar_Pre_Interp(sess,:)=interp1(linspace(0,1,size(T_HRVar_Pre,2)),T_HRVar_Pre(sess,:),linspace(0,1,margins*20));
                        catch T_HRVar_Pre_Interp(:,sess)  =nan(size(Episodes.Acc_Post_Interp,1),1);
                        end
                    end
                end
                Episodes.HRVar_Pre_Interp=T_HRVar_Pre_Interp(:,1:margins*10);
            end
            
            % Heart Rate Post
            if length(HRVarConcat)==0
                Episodes.HRVar_Post_Interp=nan(size(Episodes.Acc_Post_Interp,1),300);
            else
                [M_HRVar_Post,T_HRVar_Post] = PlotRipRaw(HRVarConcat,OffsetFreeze, margins*1e3);
                close
                T_HRVar_Post(T_HRVar_Post==0)=NaN;
                if length(OnsetFreeze)==1
                    sess=1;
                    T_HRVar_Post_Interp(sess,:)=interp1(linspace(0,1,size(T_HRVar_Post,1)),T_HRVar_Post(:,sess),linspace(0,1,margins*20));
                else
                    for sess=1:size(T_HRVar_Post,1)
                        try T_HRVar_Post_Interp(sess,:)=interp1(linspace(0,1,size(T_HRVar_Post,2)),T_HRVar_Post(sess,:),linspace(0,1,margins*20));
                        catch T_HRVar_Post_Interp(:,sess)  =nan(size(Episodes.Acc_Post_Interp,1),1);
                        end
                    end
                end
                Episodes.HRVar_Post_Interp=T_HRVar_Post_Interp(:,margins*10+1:margins*20);
            end
            
            rg_HR=Range(HRConcat); dt_HR=Data(HRConcat);
            rg_HRVar=Range(HRVarConcat); dt_HRVar=Data(HRVarConcat);
            %Data for a session
            for ep=1:length(StartFzEpoch)
                % Heart Rate
                HREptrue(:,ep)=(rg_HR>StartFzEpoch(ep))&(rg_HR<StopFzEpoch(ep));
                HREp(1:length(dt_HR(HREptrue(:,ep))),ep)=dt_HR(HREptrue(:,ep));
                % Heart Rate Variability
                HRVarEptrue(:,ep)=(rg_HRVar>StartFzEpoch(ep))&(rg_HRVar<StopFzEpoch(ep));
                HRVarEp(1:length(dt_HRVar(HRVarEptrue(:,ep))),ep)=dt_HRVar(HRVarEptrue(:,ep));
            end
            
            HREp(HREp==0)=NaN;
            HRVarEp(HRVarEp==0)=NaN;
            Episodes.HREp = HREp;
            Episodes.HRVarEp = HRVarEp;
            
            
            for sess=1:size(HREp,2)
                try HREpInterp(:,sess)  = interp1(linspace(0,1,sum(HREp(:,sess)>0)),HREp(1:sum(HREp(:,sess)>0),sess),linspace(0,1,norm_value));
                catch HREpInterp(:,sess)  =nan(norm_value,1);
                end
                try HRVarEpInterp(:,sess)  = interp1(linspace(0,1,sum(HRVarEp(:,sess)>0)),HRVarEp(1:sum(HRVarEp(:,sess)>0),sess),linspace(0,1,norm_value));
                catch HRVarEpInterp(:,sess)  =nan(norm_value,1);
                end
            end
            Episodes.HRTogether=[Episodes.HR_Pre_Interp HREpInterp'  Episodes.HR_Post_Interp];
            Episodes.HRVarTogether=[Episodes.HRVar_Pre_Interp HRVarEpInterp'  Episodes.HRVar_Post_Interp];
            
        case 'No'
        otherwise
            disp('ERROR')
    end
    
    
    switch IsRespi
        case 'Yes'
            
            RespiConcat=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'instfreq','suffix_instfreq','B','method','PT');
            % Respi Pre
            [M_Respi_Pre,T_Respi_Pre] = PlotRipRaw(RespiConcat,OnsetFreeze, margins*1e3);
            close
            T_Respi_Pre(T_Respi_Pre==0)=NaN;
            if length(OnsetFreeze)==1
                sess=1;
                T_Respi_Pre_Interp(sess,:)=interp1(linspace(0,1,size(T_Respi_Pre,1)),T_Respi_Pre(:,sess),linspace(0,1,margins*20));
            else
                for sess=1:size(T_Respi_Pre,1)
                    T_Respi_Pre_Interp(sess,:)=interp1(linspace(0,1,size(T_Respi_Pre,2)),T_Respi_Pre(sess,:),linspace(0,1,margins*20));
                end
            end
            Episodes.Respi_Pre_Interp=T_Respi_Pre_Interp(:,1:margins*10);
            
            % Respi Post
            [M_Respi_Post,T_Respi_Post] = PlotRipRaw(RespiConcat,OffsetFreeze, margins*1e3);
            close
            T_Respi_Post(T_Respi_Post==0)=NaN;
            if length(OnsetFreeze)==1
                sess=1;
                T_Respi_Post_Interp(sess,:)=interp1(linspace(0,1,size(T_Respi_Post,1)),T_Respi_Post(:,sess),linspace(0,1,margins*20));
            else
                for sess=1:size(T_Respi_Post,1)
                    T_Respi_Post_Interp(sess,:)=interp1(linspace(0,1,size(T_Respi_Post,2)),T_Respi_Post(sess,:),linspace(0,1,margins*20));
                end
            end
            Episodes.Respi_Post_Interp=T_Respi_Post_Interp(:,margins*10+1:margins*20);
            
            rg_Respi=Range(RespiConcat); dt_Respi=Data(RespiConcat);
            %Data for a session
            for ep=1:length(StartFzEpoch)
                % Respi
                RespiEptrue(:,ep)=(rg_Respi>StartFzEpoch(ep))&(rg_Respi<StopFzEpoch(ep));
                RespiEp(1:length(dt_Respi(RespiEptrue(:,ep))),ep)=dt_Respi(RespiEptrue(:,ep));
            end
            
            
            RespiEp(RespiEp==0)=NaN;
            Episodes.RespiEp = RespiEp;
            
            for sess=1:size(RespiEp,2)
                try RespiEpInterp(:,sess)  = interp1(linspace(0,1,sum(RespiEp(:,sess)>0)),RespiEp(1:sum(RespiEp(:,sess)>0),sess),linspace(0,1,norm_value));
                catch RespiEpInterp(:,sess)  =nan(norm_value,1);
                end
            end
            Episodes.RespiTogether=[Episodes.Respi_Pre_Interp RespiEpInterp'  Episodes.Respi_Post_Interp];
            
        case 'No'
        otherwise
            disp('ERROR')
    end
    
    
    switch IsOBSpectrum
        case 'Yes'
            
            OBSpecConcat=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'spectrum','prefix','B_Low');
            rg_Spectro=Range(OBSpecConcat); dt_Spectro=Data(OBSpecConcat);
            % OB Spectrum
            for ep=1:length(StartFzEpoch)
                Spectro_PreTrue(:,ep)=(rg_Spectro>StartFzEpoch(ep)-3e5)&(rg_Spectro<StartFzEpoch(ep));
                Spectro_Pre{ep}=dt_Spectro(Spectro_PreTrue(:,ep),:);
                Spectro_PostTrue(:,ep)=(rg_Spectro>StopFzEpoch(ep))&(rg_Spectro<StopFzEpoch(ep)+3e5);
                Spectro_Post{ep}=dt_Spectro(Spectro_PostTrue(:,ep),:);
            end
            clear ShockSpectroEpInterp;
            norm_value=margins*10;
            for sess=1:length(Spectro_Pre)
                for col=1:size(Spectro_Pre{sess},2)
                    if isempty(Spectro_Pre{sess})
                        Spectro_PostInterp{sess}(:,col)  = interp1(linspace(0,1,size(Spectro_Post{sess},1)),Spectro_Post{sess}(:,col),linspace(0,1,norm_value));
                        Spectro_PreInterp{sess} = nan(1,size(Spectro_PreInterp{sess-1},2));
                    elseif isempty(Spectro_Post{sess})
                        Spectro_PreInterp{sess}(:,col)  = interp1(linspace(0,1,size(Spectro_Pre{sess},1)),Spectro_Pre{sess}(:,col),linspace(0,1,norm_value));
                        Spectro_PostInterp{sess} = nan(1,size(Spectro_PostInterp{sess-1},2));
                    else
                        Spectro_PreInterp{sess}(:,col)  = interp1(linspace(0,1,size(Spectro_Pre{sess},1)),Spectro_Pre{sess}(:,col),linspace(0,1,norm_value));
                        Spectro_PostInterp{sess}(:,col)  = interp1(linspace(0,1,size(Spectro_Post{sess},1)),Spectro_Post{sess}(:,col),linspace(0,1,norm_value));
                    end
                end
            end
            
            for ep=1:length(StartFzEpoch)
                % Spectro
                SpectroEptrue(:,ep)=(rg_Spectro>StartFzEpoch(ep))&(rg_Spectro<StopFzEpoch(ep));
                SpectroEp{ep}=dt_Spectro(SpectroEptrue(:,ep),:);
            end
            
            
            Episodes.Spectro=SpectroEp;
            
            for sess=1:length(SpectroEp)
                if isempty(SpectroEp{sess})
                    SpectroEpInterp{sess} = nan(1,size(SpectroEp{sess-1},2));
                elseif size(SpectroEp{sess},1)==1
                    SpectroEpInterp{sess}=SpectroEp{sess}.*ones(norm_value,size(SpectroEp{sess},2));
                else
                    for col=1:size(SpectroEp{sess},2)
                        SpectroEpInterp{sess}(:,col)  = interp1(linspace(0,1,size(SpectroEp{sess},1)),SpectroEp{sess}(:,col),linspace(0,1,norm_value));
                    end
                end
            end
            
            for ep=1:length(Episodes.Spectro)
                Episodes.SpectroTogether{ep}=[Spectro_PreInterp{ep} ; SpectroEpInterp{ep} ; Spectro_PostInterp{ep}];
            end
            
        case 'No'
        otherwise
            disp('ERROR')
    end
    
    %-------------------------------------------------------------------------------------------------------------------------------------
    %-------------------------------------------------------------------------------------------------------------------------------------
    
    % deleting too long episodes
    %ind=find(sess_length>3e5);
    %TempFzEp(:,ind)=NaN;
    
try
    % Stim
    % tried with Concatenate_SB on 16/09
    StimEpoch=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'Epoch','epochname','stimepoch');
    StartStim=Start(StimEpoch);
    for stim=1:length(StartStim)
        for ep=1:length(StartFzEpoch)
            if StartStim(stim)>(StartFzEpoch(ep)-3e5)&StartStim(stim)<(StopFzEpoch(ep)+3e5)
                StimTimeToStart(stim)=StartFzEpoch(ep)-StartStim(stim);
                StimTimeToStop(stim)=StopFzEpoch(ep)-StartStim(stim);
            end
        end
    end
    
    if logical(exist('StimTimeToStart'))
        Episodes.StimTimeToStart=StimTimeToStart;
        Episodes.StimTimeToStop=StimTimeToStop;
    end
catch 
end


    switch IsLocalAnalysis
        case 'Yes'
            
            try
                % Local std
                clear int; clear data_numb;
                for i=1:size(TTempFzEp,2)
                    int=[TTempFzEp(~isnan(TTempFzEp(:,i)),i) ; T_TTemp_Post(i,:)'];
                    Episodes.Together_RealTime(1:length(int),i)=int;
                    data_numb(ep)=sum(~ isnan(TTempFzEp(:,i)));
                end
                Episodes.Together_RealTime=[T_TTemp_Pre' ; Episodes.Together_RealTime];
                Episodes.Together_RealTime(Episodes.Together_RealTime==0)=NaN;
                
                
                for ep=1:size(Episodes.Together_RealTime,2)
                    for i=6:length(Episodes.Together_RealTime(:,ep))-5
                        Episodes.local_stdRealTime(i,ep)=nanstd(Episodes.Together_RealTime(i-5:i+5,ep));
                        data_numb(ep)=sum(~ isnan(TTempFzEp(:,ep)));
                    end
                end
                Episodes.local_stdRealTime(end+5,1)=0;
                Episodes.local_stdRealTime(Episodes.local_stdRealTime==0)=NaN;
                
                %Put the before/FzEp/aftervalues in specific arrays
                Episodes.local_stdBef=Episodes.local_stdRealTime(1:size(T_TTemp_Pre',1),:);
                Episodes.local_stdBef(Episodes.local_stdBef==0)=NaN;
                for ep=1:size(Episodes.Together_RealTime,2)
                    int=Episodes.local_stdRealTime([size(T_TTemp_Pre',1)+1:size(T_TTemp_Pre',1)+data_numb(ep)],ep);
                    Episodes.local_stdFzEp(1:length(int),ep)=int;
                end
                Episodes.local_stdFzEp(Episodes.local_stdFzEp==0)=NaN;
                for ep=1:size(Episodes.Together_RealTime,2)
                    int=Episodes.local_stdRealTime([size(T_TTemp_Pre',1)+data_numb(ep):size(T_TTemp_Pre',1)+data_numb(ep)+size(T_TTemp_Post',1)],ep);
                    Episodes.local_stdAft(1:length(int),ep)=int;
                end
                Episodes.local_stdAft(Episodes.local_stdAft==0)=NaN;
                
                %data interpolation
                norm_value=margins*10;
                norm_value_bef=10*margins;
                norm_value_aft=10*margins;
                clear Episodes.local_stdFzEpInterp; clear Episodes.local_stdBefInterp; clear Episodes.local_stdAftInterp;
                for sess=1:size(Episodes.local_stdFzEp,2)
                    try Episodes.local_stdFzEpInterp(:,sess)  = interp1(linspace(0,1,data_number(sess)),Episodes.local_stdFzEp(1:data_number(sess),sess),linspace(0,1,norm_value));
                    catch Episodes.local_stdFzEpInterp(:,sess)  = nan(norm_value,1);
                    end
                    try Episodes.local_stdBefInterp(:,sess)  = interp1(linspace(0,1,size(T_TTemp_Pre,2)), Episodes.local_stdBef(1:size(T_TTemp_Pre,2),sess)',linspace(0,1,norm_value_bef));
                    catch Episodes.local_stdBefInterp(:,sess)  = nan(norm_value,1);
                    end
                    try Episodes.local_stdAftInterp(:,sess)  = interp1(linspace(0,1,size(T_TTemp_Post,2)), Episodes.local_stdAft(1:size(T_TTemp_Post,2),sess)',linspace(0,1,norm_value_aft));
                    catch Episodes.local_stdAftInterp(:,sess)  =nan(norm_value,1);
                    end
                end
                
                %gathering data
                Episodes.stdTogether= [ Episodes.local_stdBefInterp ; Episodes.local_stdFzEpInterp ; Episodes.local_stdAftInterp(1:295,:)];
                Episodes.Mean_local_stdFzEpandMargins=nanmean(Episodes.stdTogether');
            catch
            end
            
        case 'No'
        otherwise
            disp('ERROR')
    end
    
end
end







