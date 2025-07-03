function [spikephase,spikefreq] = PFC_DataSpikePhaseLocking(Parameter, Period,Opts)

%% Inputs
% Parameter : which paramater to study
%   - HR : phase locking to heart beats
%   - BR : phase locking to breathing
%
% Period : which period in time
%   - Freezing : all freezing from the umaze conditionning
%   - Sleep : all sleep periods
%   - Wake : all wake
%   - Wake_Explo : all wake periods that do not involve freezing
%   - Habituation : All periods before fear so hab and test pre
%   - Conditionning : All the conditionning
%   - Conditionning_NoFreeze  : All the conditionning, no freezing
%   - Habituation_NoFreeze  : Habituation, no freezing
%   - Umaze_NoFreeze : UMaze (pre, cond, post), no freezing
%   - All
%   - Wake_Home : wake in home cage
%
%   BinNumbser: Number of bins to split paramter into
%   Opts.TempBinsize: size of binnignfor spikes

%%

% Basic parameters


% Right parameter
switch Parameter
    
    case 'BR'
        MinLim = 2.5;
        MaxLim = 12;
        MiceNumber=[490,507,508,509,510,512,514];
        
    case 'HR'
        MinLim = 8;
        MaxLim = 14;
        MiceNumber=[507,508,509,510];
    
end

for mm = 1:length(MiceNumber)
    
    % Right periods
    switch Period
        case 'Freezing'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'UMazeCond');
            ToKeep = find(not(cellfun(@isempty,x1)));
            FolderList = FolderList(ToKeep);
            JustFreez = 1; % will just keep freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 0;
            RemoveFreez = 0;
            
        case 'All_Home'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'Sleep');
            ToKeep = find(not(cellfun(@isempty,x1)));
            FolderList = FolderList(ToKeep);
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will just keep sleep from sleep sessions
            RemoveSleep = 0;
            RemoveFreez = 0;
            
        case 'Sleep'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'Sleep');
            ToKeep = find(not(cellfun(@isempty,x1)));
            FolderList = FolderList(ToKeep);
            JustFreez = 0; % will ignore freezing
            JustSleep = 1; % will just keep sleep from sleep sessions
            RemoveSleep = 0;
            RemoveFreez = 0;
            
        case 'Wake_Home'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'Sleep');
            ToKeep = find(not(cellfun(@isempty,x1)));
            FolderList = FolderList(ToKeep);
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will just keep sleep from sleep sessions
            RemoveSleep = 1;
            RemoveFreez = 0;
            
        case 'Wake'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'EPM');
            x2 = strfind(FolderList,'Sound');
            ToKeep = find((cellfun(@isempty,x1)) & (cellfun(@isempty,x2)) );
            FolderList = FolderList(ToKeep);
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 1;
            RemoveFreez = 0;
            
        case 'Wake_Explo'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'EPM');
            x2 = strfind(FolderList,'Sound');
            ToKeep = find((cellfun(@isempty,x1)) & (cellfun(@isempty,x2)) );
            FolderList = FolderList(ToKeep);
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 1;
            RemoveFreez = 1;
            
        case 'All'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'EPM');
            x2 = strfind(FolderList,'Sound');
            ToKeep = find((cellfun(@isempty,x1)) & (cellfun(@isempty,x2)) );
            FolderList = FolderList(ToKeep);
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 0;
            RemoveFreez = 0;
            
        case 'Habituation'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'Habituation');
            x2 = strfind(FolderList,'TestPre');
            ToKeep = [find(~cellfun(@isempty,x1)),find(~cellfun(@isempty,x2))];
            FolderList = FolderList(ToKeep);
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 1;
            RemoveFreez = 0;
            
        case 'Conditionning'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'UMazeCond/Cond');
            ToKeep = find(~cellfun(@isempty,x1));
            FolderList = FolderList(ToKeep);
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 1;
            RemoveFreez = 0;
            
        case 'Conditionning_NoFreeze'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'UMazeCond/Cond');
            ToKeep = find(~cellfun(@isempty,x1));
            FolderList = FolderList(ToKeep);
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 1;
            RemoveFreez = 1;
            
        case 'Habituation_NoFreeze'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'Habituation');
            x2 = strfind(FolderList,'TestPre');
            ToKeep = [find(~cellfun(@isempty,x1)),find(~cellfun(@isempty,x2))];
            FolderList = FolderList(ToKeep);
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 1;
            RemoveFreez = 1;
            
        case 'Umaze_NoFreeze'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'Habituation');
            x2 = strfind(FolderList,'TestPre');
            x3 = strfind(FolderList,'UMazeCond/Cond');
            x4 = strfind(FolderList,'TestPost');
            ToKeep = [find(~cellfun(@isempty,x1)),find(~cellfun(@isempty,x2)),...
                find(~cellfun(@isempty,x3)),find(~cellfun(@isempty,x3))];
            FolderList = FolderList(ToKeep);
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 1;
            RemoveFreez = 1;

        case 'Sound_Hab'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'SoundHab');
            ToKeep = find(~cellfun(@isempty,x1));
            FolderList = FolderList(ToKeep);
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 1;
            RemoveFreez = 0;

 case 'EPM'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'EPM');
            ToKeep = find(~cellfun(@isempty,x1));
            FolderList = FolderList(ToKeep);
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 1;
            RemoveFreez = 0;
            
    end
    
    % Deal with time
    % OB Spectrum - everything is realigned to this
    OBSpec_concat=ConcatenateDataFromFolders_SB(FolderList,'spectrum','prefix','B_Low');    
    TimeBins = Range(OBSpec_concat);
    if Opts.TempBinsize>(median(diff(TimeBins/1e4))+0.01) % to take care of rounding error
        SubSample = ceil(Opts.TempBinsize/median(diff(TimeBins/1e4)));
    else
        SubSample = 1;
    end
    TempBinsize = median(diff(TimeBins/1e4)*SubSample);
    TimeBins = TimeBins(1:SubSample:end);
    
    % Get concatenated variables
    % Spikes
    S_concat=ConcatenateDataFromFolders_SB(FolderList,'spikes');
    % NoiseEpoch
    NoiseEp_concat=ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','noiseepoch');
    TotalEpoch = intervalSet(0,max(TimeBins));
    TotalEpoch = TotalEpoch - NoiseEp_concat;
    
    if JustFreez
        % Freezing epoch
        FzEp_concat = ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','freezeepoch');
        TotalEpoch = and(TotalEpoch,FzEp_concat);
    elseif RemoveFreez
        % Freezing epoch
        FzEp_concat = ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','freezeepoch');
        TotalEpoch = TotalEpoch - FzEp_concat;
    end
    
    if JustSleep
        % Sleep epoch
        Sleepstate=ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','sleepstates');
        TotalEpoch = TotalEpoch - Sleepstate{1}; % remove wake
    elseif RemoveSleep
        % Sleep epoch
        Sleepstate=ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','sleepstates');
        TotalEpoch = and(TotalEpoch,Sleepstate{1}); % just the wake
    end
    
    % Main body parameter
    switch Parameter
        case 'BR'
            % InstFreq -  OB
            instfreq_concat_PT=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','B','method','PT');
            % smooth according to timebin
            instfreq_concat_PT  = ReSampleDataInTime_ForPFCInterTuning(instfreq_concat_PT,SubSample,TimeBins,Opts.TempBinsize);
            instfreq_concat_WV=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','B','method','WV');
            % smooth according to timebin
            instfreq_concat_WV  = ReSampleDataInTime_ForPFCInterTuning(instfreq_concat_WV,SubSample,TimeBins,Opts.TempBinsize);
            % Sort out big errors in frequency estimate
            y = Data(instfreq_concat_WV);
            y(y>15)=NaN;
            y=naninterp(y);
            instfreq_concat_WV = tsd(TimeBins,y);
            % averge the two methods
            instfreq_concat_Both = tsd(TimeBins,nanmean([Data(instfreq_concat_WV),Data(instfreq_concat_PT)]')');
            spikephase{mm} =ConcatenateDataFromFolders_SB(FolderList, 'spikephase','suffix_spikephase','B');

            for sp = 1:length(spikephase{mm}.WV)
                spikephase{mm}.PT{sp}.Transf = Restrict(spikephase{mm}.PT{sp}.Transf,TotalEpoch);
                spikephase{mm}.WV{sp}.Transf = Restrict(spikephase{mm}.WV{sp}.Transf,TotalEpoch);
                spikephase{mm}.PT{sp}.Nontransf = Restrict(spikephase{mm}.PT{sp}.Nontransf,TotalEpoch);
                spikephase{mm}.WV{sp}.Nontransf = Restrict(spikephase{mm}.WV{sp}.Nontransf,TotalEpoch);
                spikefreq{mm}{sp} = Restrict(instfreq_concat_Both,ts(Range(spikephase{mm}.WV{sp}.Transf)));
            end
            
           
            
        case 'HR'
            %  heartrate
            heartrate = ConcatenateDataFromFolders_SB(FolderList,'heartrate');
            % smooth according to timebin
            heartrate  = ReSampleDataInTime_ForPFCInterTuning(heartrate,SubSample,TimeBins,Opts.TempBinsize);
            spikephase{mm} =ConcatenateDataFromFolders_SB(FolderList, 'spikephase_EKG');
            for sp = 1:length(spikephase{mm})
                spikephase{mm}{sp}.Transf = Restrict(spikephase{mm}{sp}.Transf,TotalEpoch);
                spikephase{mm}{sp}.Nontransf = Restrict(spikephase{mm}{sp}.Nontransf,TotalEpoch);
                spikefreq{mm}{sp} = Restrict(heartrate,ts(Range(spikephase{mm}{sp}.Transf)));
            end
            
    end
    
    
    end
    

end