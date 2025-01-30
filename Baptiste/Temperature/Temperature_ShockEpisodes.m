% Data acquisition around an event 
%  
% Possible for :
% - Freezing onset/offset
% - shock zone freezing onset/offset
% - safe zone freezing onset/offset
% - eyelidshock / PAG stimulations (stim).
% - Wake/NREM, NREM/REM transitions
%
% if sessions are analyzed for temperature : put IsTemp='Yes'
% if mice have EKG : put IsHR='Yes'
%
% example : Episodes= Temperature_ShockEpisodes(667,Folderlist,'Stim','Yes');

function Episodes = Temperature_ShockEpisodes(Mouse_name,FolderList,ChosenEpoch,Window,IsTemp,IsHR,IsSpeed,IsRespi,IsOBSpectrum)

Window=Window*1e4;

Mouse_name={['M' num2str(Mouse_name)]};
try % tries for sleep analysis, got to remove ?
    FreezeEpoch=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'Epoch','epochname','freezeepoch');
    ZoneEpoch=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'Epoch','epochname','zoneepoch');
end
try
    SleepEpoch=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'epoch','epochname','sleepstates');
    SleepEpoch{3} = dropShortIntervals(SleepEpoch{3}, 7e4);
    if Window==10e4
        SleepEpoch{1} = dropShortIntervals(SleepEpoch{1}, 10e4);
        SleepEpoch{2} = dropShortIntervals(SleepEpoch{2}, 10e4);
        SleepEpoch{3} = dropShortIntervals(SleepEpoch{3}, 10e4);
    elseif Window==30
        SleepEpoch{1} = dropShortIntervals(SleepEpoch{1}, 30e4);
    elseif Window==300e4
        SleepEpoch{1} = dropShortIntervals(SleepEpoch{1}, 300e4);
    else
        disp('ERROR')
    end
end

switch ChosenEpoch
    case 'FreezingOnset'
        StartShockEpoch=Start(FreezeEpoch);
    case 'ShockOnset'
        StartShockEpoch=Start(and(FreezeEpoch,ZoneEpoch{1}));
    case 'SafeOnset'
        StartShockEpoch=Start(and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{5})));
    case 'FreezingOffset'
        StartShockEpoch=Stop(FreezeEpoch);
    case 'ShockOffset'
        StartShockEpoch=Stop(and(FreezeEpoch,ZoneEpoch{1}));
    case 'SafeOffset'
        StartShockEpoch=Stop(and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{5})));
    case 'Stim'
        StimEpoch=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'Epoch','epochname','stimepoch');
        StartShockEpoch=Start(StimEpoch);
    case 'Wake_NREM'
        [aft_cell,bef_cell]=transEpoch(SleepEpoch{2},SleepEpoch{1});
        StartShockEpoch=Start(bef_cell{1,2});
    case  'NREM_REM'
        [aft_cell,bef_cell]=transEpoch(SleepEpoch{2},SleepEpoch{3});
        StartShockEpoch=Start(bef_cell{1,2});
    case  'REM_NREM'
        [aft_cell,bef_cell]=transEpoch(SleepEpoch{2},SleepEpoch{3});
        StartShockEpoch=Start(bef_cell{2,1});
    case  'NREM_Wake'
        [aft_cell,bef_cell]=transEpoch(SleepEpoch{2},SleepEpoch{1});
        StartShockEpoch=Start(bef_cell{2,1});
    case  'REM_Wake'
        [aft_cell,bef_cell]=transEpoch(SleepEpoch{3},SleepEpoch{1});
        StartShockEpoch=Start(bef_cell{2,1});
    otherwise
        disp('ERROR')
end

if ~isempty(StartShockEpoch)
    
    switch IsTemp
        case 'Yes'
            TTempConcat=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'tailtemperature');
            MTempConcat=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'masktemperature');
            rg_TTemp=Range(TTempConcat); dt_TTemp=Data(TTempConcat);
            dt_MTemp=Data(MTempConcat);
            for ep=1:length(StartShockEpoch)
                ShockTTempEp(:,ep)=(rg_TTemp>StartShockEpoch(ep)-Window)&(rg_TTemp<StartShockEpoch(ep)+Window);
                ShockMTempEp(:,ep)=(rg_TTemp>StartShockEpoch(ep)-Window)&(rg_TTemp<StartShockEpoch(ep)+Window);
                ShockTTempEp2(1:length(dt_TTemp(ShockTTempEp(:,ep))),ep)=dt_TTemp(ShockTTempEp(:,ep));
                ShockMTempEp2(1:length(dt_MTemp(ShockMTempEp(:,ep))),ep)=dt_MTemp(ShockMTempEp(:,ep));
                data_number(ep)=length(dt_TTemp(ShockTTempEp(:,ep)));
            end
            ShockTTempEp2(ShockTTempEp2==0)=NaN;
            ShockMTempEp2(ShockMTempEp2==0)=NaN;
            Episodes.TTemp=ShockTTempEp2;
            Episodes.MTemp=ShockMTempEp2;
            norm_value=100;
            clear ShockTempEpInterp;
            for sess=1:size(ShockTTempEp2,2)
                try ShockTTempEpInterp(:,sess)  = interp1(linspace(0,1,data_number(sess)),ShockTTempEp2(1:data_number(sess),sess),linspace(0,1,norm_value));
                catch ShockTTempEpInterp(:,sess)  = nan(norm_value,1);
                end
            end
            clear ShockMTempEpInterp;
            for sess=1:size(ShockMTempEp2,2)
                try ShockMTempEpInterp(:,sess)  = interp1(linspace(0,1,data_number(sess)),ShockMTempEp2(1:data_number(sess),sess),linspace(0,1,norm_value));
                catch ShockMTempEpInterp(:,sess)  = nan(norm_value,1);
                end
            end
            Episodes.TTemp_Interp=ShockTTempEpInterp;
            Episodes.MTemp_Interp=ShockMTempEpInterp;
        case 'No'
        otherwise
            disp('ERROR')
    end
    
    
    switch IsHR
        case 'Yes'
            HeartRateConcat=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'heartrate');
            HRVarConcat=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'heartratevar');
            rg_HR=Range(HeartRateConcat); dt_HR=Data(HeartRateConcat);
            rg_HRVar=Range(HRVarConcat); dt_HRVar=Data(HRVarConcat);
            for ep=1:length(StartShockEpoch)
                ShockHREp(:,ep)=(rg_HR>StartShockEpoch(ep)-Window)&(rg_HR<StartShockEpoch(ep)+Window);
                ShockHRVarEp(:,ep)=(rg_HRVar>StartShockEpoch(ep)-Window)&(rg_HRVar<StartShockEpoch(ep)+Window);
                ShockHREp2(1:length(dt_HR(ShockHREp(:,ep))),ep)=dt_HR(ShockHREp(:,ep));
                ShockHRVarEp2(1:length(dt_HRVar(ShockHRVarEp(:,ep))),ep)=dt_HRVar(ShockHRVarEp(:,ep));
            end
            ShockHREp2(ShockHREp2==0)=NaN;
            ShockHRVarEp2(ShockHRVarEp2==0)=NaN;
            Episodes.HR=ShockHREp2;
            Episodes.HRVar=ShockHRVarEp2;
            clear HRShockEpInterp;
            norm_value=100;
            for sess=1:size(ShockHREp,2)
                try ShockHREpInterp(:,sess)  = interp1(linspace(0,1,sum(ShockHREp(:,sess)>0)),ShockHREp2(1:sum(ShockHREp(:,sess)>0),sess),linspace(0,1,norm_value));
                catch ShockHREpInterp(:,sess)  =nan(norm_value,1);
                end
            end
            clear HRVarShockEpInterp;
            for sess=1:size(ShockHRVarEp,2)
                try ShockHRVarEpInterp(:,sess)  = interp1(linspace(0,1,sum(ShockHRVarEp(:,sess)>0)),ShockHRVarEp2(1:sum(ShockHRVarEp(:,sess)>0),sess),linspace(0,1,norm_value));
                catch ShockHRVarEpInterp(:,sess)  =nan(norm_value,1);
                end
            end
            Episodes.HR_Interp=ShockHREpInterp;
            Episodes.HRVar_Interp=ShockHRVarEpInterp;
        case 'No'
        otherwise
            disp('ERROR')
    end
    
    switch IsSpeed
        case 'Yes'
            SpeedConcat=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'speed');
            rg_Speed=Range(SpeedConcat); dt_Speed=Data(SpeedConcat);
            for ep=1:length(StartShockEpoch)
                SpeedEp(:,ep)=(rg_Speed>StartShockEpoch(ep)-Window)&(rg_Speed<StartShockEpoch(ep)+Window);
                SpeedEp2(1:length(dt_Speed(SpeedEp(:,ep))),ep)=dt_Speed(SpeedEp(:,ep));
             end
            SpeedEp2(SpeedEp2==0)=NaN;
            Episodes.Speed=SpeedEp2;
            clear SpeedInterp;
            for sess=1:size(SpeedEp,2)
                try SpeedInterp(:,sess)  = interp1(linspace(0,1,sum(SpeedEp(:,sess)>0)),SpeedEp2(1:sum(SpeedEp(:,sess)>0),sess),linspace(0,1,norm_value));
                catch SpeedInterp(:,sess)  =nan(norm_value,1);
                end
            end
            Episodes.Speed_Interp=SpeedInterp;
        case 'No'
        otherwise
            disp('ERROR')
    end
    
     switch IsRespi
        case 'Yes'
            RespiConcat=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'instfreq','suffix_instfreq','B');
            rg_Respi=Range(RespiConcat); dt_Respi=Data(RespiConcat);
            for ep=1:length(StartShockEpoch)
                ShockRespiEp(:,ep)=(rg_Respi>StartShockEpoch(ep)-Window)&(rg_Respi<StartShockEpoch(ep)+Window);
                ShockRespiEp2(1:length(dt_Respi(ShockRespiEp(:,ep))),ep)=dt_Respi(ShockRespiEp(:,ep));
            end
            ShockRespiEp2(ShockRespiEp2==0)=NaN;
            Episodes.Respi=ShockRespiEp2;
            for sess=1:size(ShockRespiEp,2)
                ShockRespiEpInterp(:,sess)  = interp1(linspace(0,1,sum(ShockRespiEp(:,sess)>0)),ShockRespiEp2(1:sum(ShockRespiEp(:,sess)>0),sess),linspace(0,1,norm_value));
            end
            Episodes.Respi_Interp=ShockRespiEpInterp;
         case 'No'
         otherwise
             disp('ERROR')
     end
     
     switch IsOBSpectrum
         case 'Yes'
             OBSpecConcat=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'spectrum','prefix','B_Low');
             rg_Spectro=Range(OBSpecConcat); dt_Spectro=Data(OBSpecConcat);
             for ep=1:length(StartShockEpoch)
                 ShockSpectroEp(:,ep)=(rg_Spectro>StartShockEpoch(ep)-Window)&(rg_Spectro<StartShockEpoch(ep)+Window);
                 ShockSpectroEp2{ep}=dt_Spectro(ShockSpectroEp(:,ep),:);
                 RespiFrom_OB{ep}=RespiratoryRythmFromSpectrum_BM(zscore(ShockSpectroEp2{ep}')');
             end
             Episodes.Spectro=ShockSpectroEp2;
             for sess=1:length(ShockSpectroEp2)
                 for col=1:size(ShockSpectroEp2{sess},2)
                     ShockSpectroEpInterp{sess}(:,col) = interp1(linspace(0,1,size(ShockSpectroEp2{sess},1)),ShockSpectroEp2{sess}(:,col),linspace(0,1,norm_value));
                 end
             end
             for sess=1:size(RespiFrom_OB,2)
                From_OBInterp(:,sess)  = interp1(linspace(0,1,sum(ShockSpectroEp(:,sess)>0)),RespiFrom_OB{sess},linspace(0,1,norm_value));
            end
            Episodes.RespiOB_Interp=From_OBInterp;
             Episodes.Spectro_Interp=ShockSpectroEpInterp;
         case 'No'
         otherwise
             disp('ERROR')
     end
     
 

    AccConcat=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'accelero');
    
    
    clear ShockTempEp2; clear ShockRespiEp2; clear ShockHREp2; clear ShockSpectroEp2;
    clear ShockTempEp; clear ShockRespiEp; clear ShockHREp; clear ShockSpectroEp;
    % Get Data during the right period
    rg_Acc=Range(AccConcat); dt_Acc=Data(AccConcat);
    for ep=1:length(StartShockEpoch)
        AccEp(:,ep)=(rg_Acc>StartShockEpoch(ep)-Window)&(rg_Acc<StartShockEpoch(ep)+Window);
        % ShockSpectroEp(:,ep)=(rg_Spectro>StartShockEpoch(ep)-Window)&(rg_Spectro<StartShockEpoch(ep)+Window);
        % ShockSpectroEp2{ep}=dt_Spectro(ShockSpectroEp(:,ep),:);
        AccEp2(1:length(dt_Acc(AccEp(:,ep))),ep)=dt_Acc(AccEp(:,ep));
    end
    
    
    AccEp2(AccEp2==0)=NaN;
    
    Episodes.Acc=AccEp2;
    %Episodes.ShockSpectroEp=ShockSpectroEp2;
    
    norm_value=100;
    clear AccInterp;
    for sess=1:size(AccEp,2)
        try AccInterp(:,sess)  = interp1(linspace(0,1,sum(AccEp(:,sess)>0)),AccEp2(1:sum(AccEp(:,sess)>0),sess),linspace(0,1,norm_value));
        catch AccInterp(:,sess)  =nan(norm_value,1);
        end
    end
    %clear ShockSpectroEpInterp;
    %for sess=1:length(ShockSpectroEp2)
    %   for col=1:size(ShockSpectroEp2{sess},2)
    %        ShockSpectroEpInterp{sess}(:,col)  = interp1(linspace(0,1,size(ShockSpectroEp2{sess},1)),ShockSpectroEp2{sess}(:,col),linspace(0,1,norm_value));
    %   end
    %end
    
    
    %Episodes.ShockSpectroEpInterp=ShockSpectroEpInterp;
    Episodes.Acc_Interp=AccInterp;
    
    
else
    Episodes=[];
end

end






