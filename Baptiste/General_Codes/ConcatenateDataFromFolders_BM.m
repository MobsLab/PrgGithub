% FolderList : list of folders that will be used in order
%
% TypeVariable:
%   - LFP : then provide which 'ChanNumber' as extra argument
%   - Spectrum : then provide the 'Prefix' as extra argument
%   - Epoch : provide the 'epochname' as extra argument; noise and stims will
%   always be removed
%   - Spikes : gets all spikes
%   - LinearPosition
%   - InstFreq : suffix_instfreq indicates which structure you want, PT
%   - Position : tsd with 2-D data of x and y positions
%   - AlignedPosition :tsd with 2-D data of x and y positions aligend to
%   the UMaze
%   will be used by default unless specified in method input 'argument'
%   - HeartRate
%   - Ripples : gets timing of ripplesf
%   - SpikePhase : loads 'InstFreqAndPhase_BNeuronPhaseLocking' type files,
%   - timesessions
%   - deltawaves : gets epochs of delta wave times (start and stop)
%   suffix_spikephase indicates which structure
%   - TailTemperature


function OutPutVar=ConcatenateDataFromFolders_BM(FolderList,TypeVariable,varargin)

%% Initiation

% Check number of parameters
if nargin < 2 || mod(length(varargin),2) ~= 0
    error('Incorrect number of parameters (type ''help <a href="matlab:help FindRipplesKJ">FindRipplesKJ</a>'' for details).');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property (type ''help <a href="matlab:help FindRipplesKJ">FindRipplesKJ</a>'' for details).']);
    end
    switch(lower(varargin{i}))
        case 'channumber'
            channumber =  varargin{i+1};
        case 'prefix'
            prefix = varargin{i+1};
        case 'epochname'
            epochname = varargin{i+1};
        case 'suffix_instfreq'
            suffix_instfreq = varargin{i+1};
        case 'suffix_instphase'
            suffix_instphase = varargin{i+1};
        case 'method'
            method_instfreq = varargin{i+1};
        case 'suffix_spikephase'
            suffix_spikephase = varargin{i+1};
        case 'spec_chan_num'
            spec_chan_num = varargin{i+1};
            
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help <a href="matlab:help FindRipplesKJ">FindRipplesKJ</a>'' for details).']);
    end
end


%% Different types of concatenation

switch(lower(TypeVariable))
    case 'lfp'
        if not(exist('channumber'))
            error('channumber is missing as required input');
        end
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load(['LFPData/LFP',num2str(channumber),'.mat'])
            rg = Range(LFP);
            dt = Data(LFP);
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            tps = max(Range(OutPutVar));
        end
        
    case 'spectrum'
        if not(exist('prefix')) & not(exist('spec_chan_num'))
            error('prefix  of spectrum is missing as required input');
        end
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('LFPData/LFP0.mat')% use LFP to get precise end time
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            if exist('prefix')>0
                load([prefix,'_Spectrum.mat'])
                rg = Spectro{2}'*1e4;
                dt = Spectro{1};
            elseif exist('spec_chan_num')>0
                load(['SpectrumDataL/Spectrum',spec_chan_num,'.mat'])
                rg = t'*1e4;
                dt = Sp;
            end
            
            
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            tps = tps +tpsmax;
        end
        
    case 'spikes'
        
        tps = 0; % this variable counts the total time of all concatenated data
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('SpikeData.mat')
            load('LFPData/LFP0.mat')
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            
            
            for sp=1:length(S)
                if ff==1
                    OutPutVar{sp}=S{sp};
                else
                    OutPutVar{sp}=ts([Range(OutPutVar{sp});Range(S{sp})+tps]);
                end
            end
            tps=tps + tpsmax;
        end
        OutPutVar = tsdArray(OutPutVar);
        
    case 'instfreq'
        
        if not(exist('suffix_instfreq'))
            error('suffix  of inst freq is missing as required input');
        end
        
        if not(exist('method_instfreq'))
            method_instfreq = 'PT';
        end
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('LFPData/LFP0.mat')% use LFP to get precise end time
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            
            method_instfreq = 'PT';
            load(['InstFreqAndPhase_B.mat'],'LocalFreq')
            rg = Range(LocalFreq.(method_instfreq));
            dt = Data(LocalFreq.(method_instfreq));
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            tps = tps +tpsmax;
        end
        
        switch method_instfreq
            case 'WV'
                SamplingRate = median(diff(Range(OutPutVar,'s')));
                Ratio = floor(0.2/SamplingRate);
                rg = Range(OutPutVar);
                dt = movmedian(Data(OutPutVar),Ratio);
                OutPutVar = tsd(rg(1:Ratio:end),dt(1:Ratio:end));
        end
        
    case 'instphase'
        
        if not(exist('suffix_instphase'))
            error('suffix  of inst phase is missing as required input');
        end
        
        if not(exist('method_instphase'))
            method_instphase = 'PT';
        end
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('LFPData/LFP0.mat')% use LFP to get precise end time
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            
            if not(isempty(strfind(suffix_instphase,'Loc')))
                if exist(['InstFreqAndPhase_' suffix_instphase,'.mat'])==0
                    if exist(['InstFreqAndPhase_' suffix_instphase,'_left.mat'])>0
                        suffix_instphase = [suffix_instphase '_left'];
                        
                    elseif exist(['InstFreqAndPhase_' suffix_instphase,'_right.mat'])>0
                        suffix_instphase = [suffix_instphase '_right'];
                    end
                end
            end
            
            
            load(['InstFreqAndPhase_' suffix_instphase,'.mat'],'LocalPhase')
            rg = Range(LocalPhase.(method_instphase));
            dt = Data(LocalPhase.(method_instphase));
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            tps = tps +tpsmax;
        end
        
        switch method_instphase
            case 'WV'
                SamplingRate = median(diff(Range(OutPutVar,'s')));
                Ratio = floor(0.2/SamplingRate);
                rg = Range(OutPutVar);
                dt = movmedian(Data(OutPutVar),Ratio);
                OutPutVar = tsd(rg(1:Ratio:end),dt(1:Ratio:end));
        end
        
    case 'wavelet_spec'
        
        if not(exist('prefix'))
            error('prefix  of spectrum is missing as required input');
        end
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('LFPData/LFP0.mat')
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            load(['InstFreqAndPhase_',prefix,'.mat'])
            datatemp = movmedian(abs(Wavelet.spec)',10)';
            datatemp = datatemp(:,1:20:end);
            tpstemp = Wavelet.OutParams.t;
            tpstemp = tpstemp(1:20:end);
            
            OutPutVar = tsd([Range(OutPutVar);tpstemp'*1e4+tps],[Data(OutPutVar);datatemp']);
            tps = tps +tpsmax;
        end
        
        
    case 'epoch'
        
        switch epochname
            
            case 'freezeepoch'
                OutPutVar = intervalSet([],[]);
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    cd(FolderList{ff})
                    load('LFPData/LFP0.mat')
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    
                    load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch','Epoch')
                    
                    load('behavResources_SB.mat','Behav')
                    try,TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch),Stop(TTLInfo.StimEpoch)+0.2*1e4);
                    catch, TTLInfo.StimEpoch=intervalSet(0,0.1); end
                    RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
                    
                    if isfield(Behav,'FreezeAccEpoch')
                        FzEpTemp=Behav.FreezeAccEpoch;
                    else
                        FzEpTemp=Behav.FreezeEpoch;
                    end
                    FzEpTemp=FzEpTemp-RemovEpoch;
                    
                    OutPutVar=intervalSet([Start(OutPutVar);Start(FzEpTemp)+tps],...
                        [Stop(OutPutVar);Stop(FzEpTemp)+tps]);
                    tps=tps + tpsmax;
                    
                end
                
                
            case 'freezeepoch_noSleepy'
                OutPutVar = intervalSet([],[]);
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    cd(FolderList{ff})
                    load('LFPData/LFP0.mat')
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    
                    load('behavResources_SB.mat','Behav')
                    
                    if not(isempty(Behav.FreezeAccEpoch))
                        FzEpTemp=Behav.FreezeAccEpoch;
                    else
                        FzEpTemp=Behav.FreezeEpoch;
                    end
                    
                    OutPutVar=intervalSet([Start(OutPutVar);Start(FzEpTemp)+tps],...
                        [Stop(OutPutVar);Stop(FzEpTemp)+tps]);
                    tps=tps + tpsmax;
                    
                end
                
                
            case 'freezeepoch_noSB'
                OutPutVar = intervalSet([],[]);
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    cd(FolderList{ff})
                    load('LFPData/LFP0.mat')
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    
                    load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch','Epoch')
                    
                    cd(FolderList{ff})
                    
                    load('behavResources.mat','FreezeEpoch')
                    try,TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch),Stop(TTLInfo.StimEpoch)+0.2*1e4);
                    catch, TTLInfo.StimEpoch=intervalSet(0,0.1); end
                    RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
                    
                    if not(isempty(FreezeEpoch))
                        FzEpTemp=FreezeEpoch;
                    else
                        FzEpTemp=FreezeEpoch;
                    end
                    FzEpTemp=FzEpTemp-RemovEpoch;
                    
                    OutPutVar=intervalSet([Start(OutPutVar);Start(FzEpTemp)+tps],...
                        [Stop(OutPutVar);Stop(FzEpTemp)+tps]);
                    tps=tps + tpsmax;
                    
                end
                
            case 'zoneepoch'
                
                
                for ff=1:length(FolderList)
                    try
                        cd(FolderList{ff})
                        load('LFPData/LFP0.mat')
                        tpsmax = max(Range(LFP)); % use LFP to get precise end time
                        
                        load('behavResources_SB.mat')
                        
                        if ff ==1
                            for ep=1:5
                                OutPutVar{ep} = intervalSet([],[]);
                            end
                            tps = 0; % this variable counts the total time of all concatenated data
                            
                        end
                        
                        load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch','Epoch')
                        try,TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch),Stop(TTLInfo.StimEpoch)+0.2*1e4);
                        catch, TTLInfo.StimEpoch=intervalSet(0,0.1); end
                        RemovEpoch=or(TTLInfo.StimEpoch,TotalNoiseEpoch);
                        
                        if isfield(Behav,'ZoneEpoch')
                            
                            for ep=1:min([length(Behav.ZoneEpoch),5])
                                OutPutVar{ep} = intervalSet([Start(OutPutVar{ep});Start(Behav.ZoneEpoch{ep}-RemovEpoch)+tps],...
                                    [Stop(OutPutVar{ep});Stop(Behav.ZoneEpoch{ep}-RemovEpoch)+tps]);
                            end
                        end
                        tps=tps + tpsmax;
                    catch
                        keyboard
                    end
                    
                end
                
            case 'noiseepoch'
                
                OutPutVar = intervalSet([],[]);
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    
                    cd(FolderList{ff})
                    load('LFPData/LFP0.mat')
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    
                    clear SleepyEpoch
                    load('behavResources_SB.mat')
                    load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch','Epoch')
                    if not(exist('SleepyEpoch'))
                        SleepyEpoch = intervalSet(0,0.1);
                    end
                    try,TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch)-0.2*1E4,Stop(TTLInfo.StimEpoch)+0.4*1e4);
                    catch, TTLInfo.StimEpoch=intervalSet(0,0.1); end
                    RemovEpoch=and(or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch),intervalSet(0,tpsmax));
                    
                    OutPutVar=intervalSet([Start(OutPutVar);Start(RemovEpoch)+tps],...
                        [Stop(OutPutVar);Stop(RemovEpoch)+tps]);
                    tps=tps + tpsmax;
                    
                end
                
            case 'noiseepochclosestims'
                
                OutPutVar = intervalSet([],[]);
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    
                    cd(FolderList{ff})
                    load('LFPData/LFP0.mat')
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    
                    clear SleepyEpoch
                    load('behavResources_SB.mat')
                    load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch','Epoch')
                    if not(exist('SleepyEpoch'))
                        SleepyEpoch = intervalSet(0,0.1);
                    end
                    try,TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch),Stop(TTLInfo.StimEpoch)+0.2*1e4);
                    catch, TTLInfo.StimEpoch=intervalSet(0,0.1); end
                    RemovEpoch=and(or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch),intervalSet(0,tpsmax));
                    
                    OutPutVar=intervalSet([Start(OutPutVar);Start(RemovEpoch)+tps],...
                        [Stop(OutPutVar);Stop(RemovEpoch)+tps]);
                    tps=tps + tpsmax;
                    
                end
                
            case 'sleepstates'
                
                OutPutVar{1} = intervalSet([],[]); % Wake
                OutPutVar{2} = intervalSet([],[]); % NREM
                OutPutVar{3} = intervalSet([],[]); % REM
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    cd(FolderList{ff})
                    load('LFPData/LFP0.mat')
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    
                    load('ExpeInfo.mat')
                    
                    if ExpeInfo.SleepSession
                        
                        load('behavResources_SB.mat')
                        load('StateEpochSB.mat','TotalNoiseEpoch','SWSEpoch','REMEpoch','Wake')
                        SWSEpoch = SWSEpoch-TotalNoiseEpoch;
                        REMEpoch = REMEpoch-TotalNoiseEpoch;
                        Wake = Wake-TotalNoiseEpoch;
                        
                        OutPutVar{1}=intervalSet([Start(OutPutVar{1});Start(Wake)+tps],...
                            [Stop(OutPutVar{1});Stop(Wake)+tps]);
                        OutPutVar{2}=intervalSet([Start(OutPutVar{2});Start(SWSEpoch)+tps],...
                            [Stop(OutPutVar{2});Stop(SWSEpoch)+tps]);
                        OutPutVar{3}=intervalSet([Start(OutPutVar{3});Start(REMEpoch)+tps],...
                            [Stop(OutPutVar{3});Stop(REMEpoch)+tps]);
                        
                        tps=tps + tpsmax;
                    else
                        load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch','Epoch')
                        SleepyEpoch = SleepyEpoch-TotalNoiseEpoch;
                        TotalEpoch = intervalSet(0,tpsmax)-TotalNoiseEpoch;
                        
                        OutPutVar{1}=intervalSet([Start(OutPutVar{1});Start(TotalEpoch)+tps],...
                            [Stop(OutPutVar{1});Stop(TotalEpoch)+tps]);
                        OutPutVar{2}=intervalSet([Start(OutPutVar{2});Start(SleepyEpoch)+tps],...
                            [Stop(OutPutVar{2});Stop(SleepyEpoch)+tps]);
                        OutPutVar{3}=intervalSet([Start(OutPutVar{3})],...
                            [Stop(OutPutVar{3})]);
                        tps=tps + tpsmax;
                        
                    end
                end
                
            case 'blockedepoch'
                
                OutPutVar = intervalSet([],[]);
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    
                    cd(FolderList{ff})
                    load('LFPData/LFP0.mat')
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    load('ExpeInfo.mat')
                    load('behavResources_SB.mat')
                    
                    if not(isempty(findstr(ExpeInfo.SessionType, 'Blocked')))
                        
                        OutPutVar=intervalSet([Start(OutPutVar);0+tps],...
                            [Stop(OutPutVar);300*1E4+tps]);
                    end
                    tps=tps + tpsmax;
                    
                end
                
            case 'stimepoch'
                OutPutVar = intervalSet([],[]);
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    
                    cd(FolderList{ff})
                    load('LFPData/LFP0.mat')
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    
                    clear SleepyEpoch
                    load('behavResources_SB.mat')
                    if not(isfield(TTLInfo,'StimEpoch'))
                        TTLInfo.StimEpoch=intervalSet([],[]);
                    elseif isempty(TTLInfo.StimEpoch)
                        TTLInfo.StimEpoch=intervalSet([],[]);
                    end
                    
                    OutPutVar=intervalSet([Start(OutPutVar);Start(TTLInfo.StimEpoch)+tps],...
                        [Stop(OutPutVar);Stop(TTLInfo.StimEpoch)+tps]);
                    tps=tps + tpsmax;
                    
                end
                
            case 'sessiontype'
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    
                    cd(FolderList{ff})
                    load('LFPData/LFP0.mat')
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    load('ExpeInfo.mat')
                    if not(isfield(ExpeInfo,'SessionNumber'))
                        ExpeInfo.SessionNumber = 1;
                    elseif ExpeInfo.SessionNumber==0
                        ExpeInfo.SessionNumber = 1;
                    end
                    OutPutVar.(ExpeInfo.SessionType){ExpeInfo.SessionNumber}=intervalSet(tps,tps+tpsmax);
                    tps=tps + tpsmax;
                    
                end
        end
        
    case 'linearposition'
        
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('LFPData/LFP0.mat')
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            
            load('behavResources_SB.mat','Behav')
            if not(isfield(Behav,'LinearDist'))
                Behav.LinearDist = tsd([0,max(Range(LFP))],[NaN;NaN]);
            end
            
            rg = Range(Behav.LinearDist);
            dt = Data(Behav.LinearDist);
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            tps=tps + tpsmax;
        end
        
    case 'speed'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('LFPData/LFP0.mat')
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            TotEpoch = intervalSet(0,max(Range(LFP)));
            
            load('behavResources_SB.mat','Behav')
            if isfield(Behav,'Vtsd')
                rg = Range(Restrict(Behav.Vtsd,TotEpoch));
                dt = Data(Restrict(Behav.Vtsd,TotEpoch));
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            else
                OutPutVar = tsd([Range(OutPutVar);[0:1e4:Stop(TotEpoch)]'+tps],[Data(OutPutVar);[0:1e4:Stop(TotEpoch)]'*NaN]);
            end
            tps=tps + tpsmax;
        end
        
        
    case 'position'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('LFPData/LFP0.mat')
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            TotEpoch = intervalSet(0,max(Range(LFP)));
            
            load('behavResources_SB.mat','Behav')
            if isfield(Behav,'Xtsd')
                rg = Range(Restrict(Behav.Xtsd,TotEpoch));
                dt = Data(Restrict(Behav.Xtsd,TotEpoch));
                dt2 = Data(Restrict(Behav.Ytsd,TotEpoch));
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);[dt,dt2]]);
            else
                OutPutVar = tsd([Range(OutPutVar);[0:1e4:Stop(TotEpoch)]'+tps],[Data(OutPutVar);[[0:1e4:Stop(TotEpoch)];[0:1e4:Stop(TotEpoch)]]'*NaN]);
            end
            tps=tps + tpsmax;
        end
        
    case 'alignedposition'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('LFPData/LFP0.mat')
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            TotEpoch = intervalSet(0,max(Range(LFP)));
            
            load('behavResources_SB.mat','Behav')
            if isfield(Behav,'AlignedXtsd')
                rg = Range(Restrict(Behav.AlignedXtsd,TotEpoch));
                dt = Data(Restrict(Behav.AlignedXtsd,TotEpoch));
                dt2 = Data(Restrict(Behav.AlignedYtsd,TotEpoch));
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);[dt,dt2]]);
            else
                OutPutVar = tsd([Range(OutPutVar);[0:1e4:Stop(TotEpoch)]'+tps],[Data(OutPutVar);[[0:1e4:Stop(TotEpoch)];[0:1e4:Stop(TotEpoch)]]'*NaN]);
            end
            tps=tps + tpsmax;
        end
        
        
    case 'accelero'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('LFPData/LFP0.mat')
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            TotEpoch = intervalSet(0,max(Range(LFP)));
            
            load('behavResources_SB.mat','Behav')
            if isfield(Behav,'MovAcctsd')
                rg = Range(Restrict(Behav.MovAcctsd,TotEpoch));
                dt = Data(Restrict(Behav.MovAcctsd,TotEpoch));
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            else
                OutPutVar = tsd([Range(OutPutVar);[0:1e4:Stop(TotEpoch)]'+tps],[Data(OutPutVar);[0:1e4:Stop(TotEpoch)]'*NaN]);
            end
            tps=tps + tpsmax;
        end
        
    case 'accelero_on_behav'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('LFPData/LFP0.mat')
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            TotEpoch = intervalSet(0,max(Range(LFP)));
            
            load('behavResources.mat','MovAcctsd')
            if exist('MovAcctsd')
                rg = Range(Restrict(MovAcctsd,TotEpoch));
                dt = Data(Restrict(MovAcctsd,TotEpoch));
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            else
                OutPutVar = tsd([Range(OutPutVar);[0:1e4:Stop(TotEpoch)]'+tps],[Data(OutPutVar);[0:1e4:Stop(TotEpoch)]'*NaN]);
            end
            tps=tps + tpsmax;
        end
        
        
    case 'heartrate'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            if exist('HeartBeatInfo.mat')>0
                load('LFPData/LFP0.mat')
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                
                load('HeartBeatInfo.mat')
                rg = Range(EKG.HBRate);
                dt = Data(EKG.HBRate);
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                tps=tps + tpsmax;
            end
        end
        
    case 'heartbeat'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            if exist('HeartBeatInfo.mat')>0
                load('LFPData/LFP0.mat')
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                
                load('HeartBeatInfo.mat')
                rg = Range(EKG.HBTimes);
                OutPutVar = ts([Range(OutPutVar);rg+tps]);
                tps=tps + tpsmax;
            end
        end
        
    case 'heartratevar'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            if exist('HeartBeatInfo.mat')>0
                load('LFPData/LFP0.mat')
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                
                load('HeartBeatInfo.mat')
                rg = Range(EKG.HBRate);
                dt = Data(EKG.HBRate);
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                tps=tps + tpsmax;
            end
        end
        
        
    case 'sleep_ripples'
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            if exist('Ripples.mat')>0
                
                load('LFPData/LFP0.mat')
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                
                load('Ripples.mat')
                tRipples = ts(RipplesR(:,2)*10);
                
                rg = Range(tRipples);
                OutPutVar = ts([Range(OutPutVar);rg+tps]);
                tps=tps + tpsmax;
            end
        end
        
        
    case 'ripples'
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            
            load('LFPData/LFP0.mat')
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            % Modif SB     5/8/2022 : changed order to prefer SWR.mat to  RipplesSleepThresh
            %             if exist('RipplesSleepThresh.mat')
            %                 load('RipplesSleepThresh.mat')
            %                 tRipples = ts(RipplesR(:,2)*10);
            %             else
            %                 load('SWR.mat')
            %             end
            
            if exist('SWR.mat')
                load('SWR.mat')
            else
                load('RipplesSleepThresh.mat')
                tRipples = ts(RipplesR(:,2)*10);
            end

            rg = Range(tRipples);
            OutPutVar = ts([Range(OutPutVar);rg+tps]);
            tps=tps + tpsmax;
        end
        
        
    case 'deltawaves'
        OutPutVar = intervalSet([],[]);
        tps = 0; % this variable counts the total time of all concatenated data
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            if exist('DeltaWaves.mat')>0
                
                load('LFPData/LFP0.mat')
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                
                load('DeltaWaves.mat')
                
                OutPutVar=intervalSet([Start(OutPutVar);Start(deltas_PFCx)+tps],...
                    [Stop(OutPutVar);Stop(deltas_PFCx)+tps]);
                
                tps=tps + tpsmax;
            end
        end
        
        
    case 'spikephase'
        
        if not(exist('suffix_spikephase'))
            error('structure identity is missing as required input');
        end
        
        
        tps = 0; % this variable counts the total time of all concatenated data
        
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load(['InstFreqAndPhase_',suffix_spikephase,'NeuronPhaseLocking.mat'])
            load('SpikeData.mat')
            load('LFPData/LFP0.mat')
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            
            
            for sp=1:length(S)
                if ff==1
                    OutPutVar.WV{sp}=PhaseSpikes.WV{sp};
                    OutPutVar.PT{sp}=PhaseSpikes.PT{sp};
                else
                    OutPutVar.WV{sp}.Transf = tsd([Range(OutPutVar.WV{sp}.Transf);Range(PhaseSpikes.WV{sp}.Transf)+tps],...
                        [Data(OutPutVar.WV{sp}.Transf);Data(PhaseSpikes.WV{sp}.Transf)]);
                    OutPutVar.WV{sp}.Nontransf = tsd([Range(OutPutVar.WV{sp}.Nontransf);Range(PhaseSpikes.WV{sp}.Nontransf)+tps],...
                        [Data(OutPutVar.WV{sp}.Nontransf);Data(PhaseSpikes.WV{sp}.Nontransf)]);
                    
                    OutPutVar.PT{sp}.Transf = tsd([Range(OutPutVar.PT{sp}.Transf);Range(PhaseSpikes.PT{sp}.Transf)+tps],...
                        [Data(OutPutVar.PT{sp}.Transf);Data(PhaseSpikes.PT{sp}.Transf)]);
                    OutPutVar.PT{sp}.Nontransf = tsd([Range(OutPutVar.PT{sp}.Nontransf);Range(PhaseSpikes.PT{sp}.Nontransf)+tps],...
                        [Data(OutPutVar.PT{sp}.Nontransf);Data(PhaseSpikes.PT{sp}.Nontransf)]);
                end
            end
            tps=tps + tpsmax;
        end
        
    case 'timesessions'
        
        
        
        tps = 0; % this variable counts the total time of all concatenated data
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('LFPData/LFP0.mat')
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            OutPutVar(ff) = tps;
            tps = tps +tpsmax;
        end
        
    case 'tailtemperature'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('LFPData/LFP0.mat')
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            cd([FolderList{ff} '/Temperature'])
            
            load('Temperature.mat')
            load('behavResources_SB')
            if isempty(tpsmax); tpsmax=0; end
            rg = Range(Temp.TailTemperatureTSD);
            dt = Data(Temp.TailTemperatureTSD);
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            tps=tps + tpsmax;
        end
        
    case 'roomtemperature'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('LFPData/LFP0.mat')
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            cd([FolderList{ff} '/Temperature'])
            
            load('Temperature.mat')
            load('behavResources_SB')
            if isempty(tpsmax); tpsmax=0; end
            rg = Range(Temp.RoomTemperatureTSD);
            dt = Data(Temp.RoomTemperatureTSD);
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            tps=tps + tpsmax;
        end
        
        
    case 'masktemperature'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('LFPData/LFP0.mat')
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            cd([FolderList{ff} '/Temperature'])
            
            load('Temperature.mat')
            load('behavResources_SB')
            if isempty(tpsmax); tpsmax=0; end
            rg = Range(Temp.MouseTemperatureTSD);
            dt = Data(Temp.MouseTemperatureTSD);
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            tps=tps + tpsmax;
        end
        
    case 'emg'
        
        OutPutVar = tsd([],[]);
        tps = 0; % this variable counts the total time of all concatenated data
        try; chan_numb = Get_chan_numb_BM(FolderList{1} , 'EKG'); end
        
        for ff=1:length(FolderList)
            try
                cd(FolderList{ff})
                load(['LFPData/LFP' num2str(chan_numb) '.mat'])
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                TotEpoch = intervalSet(0,tpsmax);
                
                load('HeartBeatInfo.mat')
                Before_HeartBeat = ts(Range(EKG.HBTimes)-100);
                After_HeartBeat = ts(Range(EKG.HBTimes)+100);
                
                HeartBeat_Epoch=intervalSet(Before_HeartBeat,After_HeartBeat);
                EMG_Epoch = TotEpoch-HeartBeat_Epoch;
                
                EMG_TSD = Restrict(LFP, EMG_Epoch);
                
                rg = Range(EMG_TSD);
                dt = Data(EMG_TSD);
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                tps=tps + tpsmax;
            end
        end
        
        
    case 'xtsd'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('behavResources.mat', 'Xtsd')
            tpsmax = max(Range(Xtsd)); % use LFP to get precise end time
            TotEpoch = intervalSet(0,max(Range(Xtsd)));
            
            rg = Range(Xtsd);
            dt = Data(Xtsd);
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            
            tps=tps + tpsmax;
        end
        
end




