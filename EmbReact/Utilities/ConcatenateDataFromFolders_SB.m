
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
%   - InstPhase : suffix_instfreq indicates which structure you want, PT
%   - Position : tsd with 2-D data of x and y positions
%   - AlignedPosition :tsd with 2-D data of x and y positions aligend to
%   the UMaze
%   will be used by default unless specified in method input 'argument'
%   - HeartRate
%   - Ripples : gets timing of ripples
%   - ripples_all : all ripples features (frequency, duration,...)
%   - ripples_density
%   - SpikePhase : loads 'InstFreqAndPhase_BNeuronPhaseLocking' type files,
%   - timesessions
%   - deltawaves : gets epochs of delta wave times (start and stop)
%   suffix_spikephase indicates which structure
%   - TailTemperature
%   - emg
%   - heart_times
%   - respi_freq_bm
%   -'respi_freq_bm_sametps','heartrate_sametps','heartratevar_sametps','ob_high_sametps','ripples_density_sametps
%   : same as the above but with same sampling (1s bins)
%   - escape_latency
% - ob_gamma_freq
% - ob_gamma_power
% - hpc_theta_freq
% - hpc_theta_power
% - sleepstates_accelero
% - ob_gamma_ratio
% - trackingnans

function OutPutVar=ConcatenateDataFromFolders_SB(FolderList,TypeVariable,varargin)

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
        case 'method_instphase'
            method_instphase = varargin{i+1};
        case 'method_instfreq'
            method_instfreq = varargin{i+1};
        case 'method'
            method_instfreq = varargin{i+1};
        case 'suffix_spikephase'
            suffix_spikephase = varargin{i+1};
        case 'spec_chan_num'
            spec_chan_num = varargin{i+1};
        case 'window_time'
            window_time = varargin{i+1};
            
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
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
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
        
        
    case 'respi_isi'
        
        tps = 0;
        OutPutVar.PP = tsd([],[]);
        OutPutVar.PT = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('LFPData/LFP0.mat')% use LFP to get precise end time
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            load(['And_B.mat'],'AllPeaks')
            AllPeaks(end+1,:) = nan(1,3);
            
            JustPk = AllPeaks(AllPeaks(:,2)==1,:);
            NextTr =AllPeaks (find(AllPeaks(:,2)==1)+1,:);
            OutPutVar.PP = tsd([Range(OutPutVar.PP);JustPk(1:end-2,1)*1e4+tps],[Data(OutPutVar.PP);mean(abs(diff(JustPk(1:end-2,1))));abs(diff(JustPk(1:end-2,1)))]);
            OutPutVar.PT = tsd([Range(OutPutVar.PT);JustPk(1:end-2,1)*1e4+tps],[Data(OutPutVar.PT);abs(JustPk(1:end-2,1) - NextTr(1:length(JustPk(1:end-2,1)))')]);
            tps = tps +tpsmax;
        end
        
        
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
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            
            if not(isempty(strfind(suffix_instfreq,'Loc')))
                if exist(['InstFreqAndPhase_' suffix_instfreq,'.mat'])==0
                    if exist(['InstFreqAndPhase_' suffix_instfreq,'_left.mat'])>0
                        suffix_instfreq = [suffix_instfreq '_left'];
                        
                    elseif exist(['InstFreqAndPhase_' suffix_instfreq,'_right.mat'])>0
                        suffix_instfreq = [suffix_instfreq '_right'];
                    end
                end
            end
            
            
            load(['InstFreqAndPhase_' suffix_instfreq,'.mat'],'LocalFreq')
            try
                rg = Range(LocalFreq.(method_instfreq));
                dt = Data(LocalFreq.(method_instfreq));
            catch
                rg=[];
                dt=[];
            end
            
                    try
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            catch
                keyboard
            end
            
            tps = tps +tpsmax;
        end
    case 'instphase'
        
        if not(exist('suffix_instphase'))
            error('suffix  of inst phase is missing as required input');
        end
        
        if not(exist('method_instphase'))
            method_instfreq = 'PT';
        end
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
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
            try
                rg = Range(LocalPhase.(method_instfreq));
                dt = Data(LocalPhase.(method_instfreq));
            catch
                rg=[];
                dt=[];
            end
            
            try
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            catch
                keyboard
            end
            
            tps = tps +tpsmax;
        end
        
        %         switch method_instfreq
        %             case 'WV'
        %                 SamplingRate = median(diff(Range(OutPutVar,'s')));
        %                 Ratio = floor(0.2/SamplingRate);
        %                 try
        %                     rg = Range(OutPutVar);
        %                     dt = movmedian(Data(OutPutVar),Ratio);
        %             OutPutVar = tsd([Range(OutPutVar);rg(1:Ratio:end)+tps],[Data(OutPutVar);dt(1:Ratio:end)]);
        %                 catch
        %                     rg=[];
        %                     dt=[];
        %             OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
        %                 end
        %         end
        
        
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
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
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
                    try
                        load('LFPData/LFP0.mat')
                    catch
                        load('ChannelsToAnalyse/Bulb_deep.mat')
                        load(['LFPData/LFP' num2str(channel) '.mat'])
                    end
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    
                    try
                        load('behavResources_SB.mat','Behav')
                        load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch')
                    catch
                        try
                            load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch')
                        catch
                            TotalNoiseEpoch = intervalSet([],[]);
                            SleepyEpoch = intervalSet([],[]);
                        end
                    end
                    
                    try
                        TTLInfo.Epoch=intervalSet(Start(TTLInfo.StimEpoch),Stop(TTLInfo.StimEpoch)+0.2*1e4);
                    catch
                        TTLInfo.StimEpoch=intervalSet(0,0.1);
                    end
                    try
                        RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
                    catch
                        RemovEpoch=or(TTLInfo.StimEpoch,TotalNoiseEpoch);
                    end
                    
                    try
                        if isfield(Behav,'FreezeAccEpoch') % choose first accelero
                            FzEpTemp=Behav.FreezeAccEpoch;
                        elseif isfield(Behav,'FreezeEpoch')
                            FzEpTemp=Behav.FreezeEpoch;
                        else
                            FzEpTemp = intervalSet(0,0.1*1e4);
                        end
                    catch
                        load('behavResources.mat', 'FreezeAccEpoch')
                        FzEpTemp = FreezeAccEpoch;
                    end
                    FzEpTemp=FzEpTemp-RemovEpoch;
                    FzEpTemp = and(FzEpTemp,intervalSet(0,tpsmax));
                    
                    OutPutVar=intervalSet([Start(OutPutVar);Start(FzEpTemp)+tps],...
                        [Stop(OutPutVar);Stop(FzEpTemp)+tps]);
                    tps=tps + tpsmax;
                end
                
                
            case 'fz_epoch_withsleep_withnoise'
                OutPutVar = intervalSet([],[]);
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    cd(FolderList{ff})
                    try
                        load('LFPData/LFP0.mat')
                    catch
                        load('ChannelsToAnalyse/Bulb_deep.mat')
                        load(['LFPData/LFP' num2str(channel) '.mat'])
                    end
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    
                    load('behavResources_SB.mat','Behav')
                    
                    if isfield(Behav,'FreezeAccEpoch')
                        FzEpTemp=Behav.FreezeAccEpoch;
                    elseif isfield(Behav,'FreezeEpoch')
                        FzEpTemp=Behav.FreezeEpoch;
                    else
                        FzEpTemp = intervalSet(0,0.1*1e4);
                    end
                    FzEpTemp = and(FzEpTemp,intervalSet(0,tpsmax));
                    
                    OutPutVar=intervalSet([Start(OutPutVar);Start(FzEpTemp)+tps],...
                        [Stop(OutPutVar);Stop(FzEpTemp)+tps]);
                    tps=tps + tpsmax;
                end
                
                
            case 'fz_epoch_withsleep'
                OutPutVar = intervalSet([],[]);
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    cd(FolderList{ff})
                    try
                        load('LFPData/LFP0.mat')
                    catch
                        load('ChannelsToAnalyse/Bulb_deep.mat')
                        load(['LFPData/LFP' num2str(channel) '.mat'])
                    end
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    
                    load('behavResources_SB.mat','Behav')
                    load('StateEpochSB.mat','TotalNoiseEpoch')
                    
                    try
                        TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch),Stop(TTLInfo.StimEpoch)+0.2*1e4);
                    catch
                        TTLInfo.StimEpoch=intervalSet(0,0.1);
                    end
                    try
                        RemovEpoch=or(TTLInfo.StimEpoch,TotalNoiseEpoch);
                    end
                    
                    if isfield(Behav,'FreezeAccEpoch')
                        FzEpTemp=Behav.FreezeAccEpoch;
                    elseif isfield(Behav,'FreezeEpoch')
                        FzEpTemp=Behav.FreezeEpoch;
                    else
                        FzEpTemp = intervalSet(0,0.1*1e4);
                    end
                    FzEpTemp=FzEpTemp-RemovEpoch;
                    FzEpTemp = and(FzEpTemp,intervalSet(0,tpsmax));
                    
                    OutPutVar=intervalSet([Start(OutPutVar);Start(FzEpTemp)+tps],...
                        [Stop(OutPutVar);Stop(FzEpTemp)+tps]);
                    tps=tps + tpsmax;
                end
                
                
            case 'freezeepoch_withnoise'
                OutPutVar = intervalSet([],[]);
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    cd(FolderList{ff})
                    try
                        load('LFPData/LFP0.mat')
                    catch
                        load('ChannelsToAnalyse/Bulb_deep.mat')
                        load(['LFPData/LFP' num2str(channel) '.mat'])
                    end
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    
                    load('behavResources_SB.mat','Behav')
                    load('StateEpochSB.mat','SleepyEpoch')
                    
                    try
                        RemovEpoch=SleepyEpoch;
                    catch
                        RemovEpoch=intervalSet(0,0.1*1e4);
                    end
                    
                    if isfield(Behav,'FreezeAccEpoch') % choose first accelero
                        FzEpTemp=Behav.FreezeAccEpoch;
                    elseif isfield(Behav,'FreezeEpoch')
                        FzEpTemp=Behav.FreezeEpoch;
                    else
                        FzEpTemp = intervalSet(0,0.1*1e4);
                    end
                    FzEpTemp=FzEpTemp-RemovEpoch;
                    FzEpTemp = and(FzEpTemp,intervalSet(0,tpsmax));
                    
                    OutPutVar=intervalSet([Start(OutPutVar);Start(FzEpTemp)+tps],...
                        [Stop(OutPutVar);Stop(FzEpTemp)+tps]);
                    tps=tps + tpsmax;
                end
                
                
            case 'freeze_epoch_camera'
                OutPutVar = intervalSet([],[]);
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    cd(FolderList{ff})
                    try
                        load('LFPData/LFP0.mat')
                        tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    catch
                        try
                            load('ChannelsToAnalyse/Bulb_deep.mat')
                            load(['LFPData/LFP' num2str(channel) '.mat'])
                            tpsmax = max(Range(LFP));
                        catch
                            load('behavResources.mat', 'Xtsd')
                            tpsmax = max(Range(Xtsd));
                        end
                    end
                    
                    try
                        load('behavResources.mat', 'FreezeEpoch')
                        FreezeEpoch;
                    catch
                        load('behavResources_SB.mat', 'Behav')
                        FreezeEpoch = Behav.FreezeEpoch;
                    end
                    try
                        load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch','Epoch')
                    catch
                        TotalNoiseEpoch=intervalSet([],[]);
                    end
                    try
                        TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch),Stop(TTLInfo.StimEpoch)+0.2*1e4);
                    catch
                        TTLInfo.StimEpoch=intervalSet(0,0.1);
                    end
                    try
                        RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
                    catch
                        try
                            RemovEpoch=or(TTLInfo.StimEpoch,TotalNoiseEpoch);
                        catch
                            RemovEpoch=TotalNoiseEpoch;
                        end
                    end
                    
                    FzEpTemp = FreezeEpoch-RemovEpoch;
                    
                    OutPutVar=intervalSet([Start(OutPutVar);Start(FzEpTemp)+tps],...
                        [Stop(OutPutVar);Stop(FzEpTemp)+tps]);
                    tps=tps + tpsmax;
                end
                
                
            case 'zoneepoch'
                
                for ff=1:length(FolderList)
                    
                    cd(FolderList{ff})
                    
                    try
                        load('LFPData/LFP0.mat')
                    catch
                        load('ChannelsToAnalyse/Bulb_deep.mat')
                        load(['LFPData/LFP' num2str(channel) '.mat'])
                    end
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    
                    try
                        load('behavResources_SB.mat')
                        Behav.ZoneEpoch;
                    catch
                        load('behavResources.mat','ZoneEpoch')
                        Behav.ZoneEpoch=ZoneEpoch;
                    end
                    
                    if ff ==1
                        for ep=1:5
                            OutPutVar{ep} = intervalSet([],[]);
                        end
                        tps = 0; % this variable counts the total time of all concatenated data
                    end
                    
                    try
                        load('StateEpochSB.mat','TotalNoiseEpoch')
                        TotalNoiseEpoch;
                    catch
                        TotalNoiseEpoch=intervalSet([],[]);
                    end
                    
                    if isempty(TTLInfo.StimEpoch)
                        TTLInfo.StimEpoch=intervalSet(0,0.1*1e4);
                    elseif not(isempty(Start(TTLInfo.StimEpoch)))
                        try
                            TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch),Stop(TTLInfo.StimEpoch)+0.2*1e4);
                        catch
                            TTLInfo.StimEpoch=intervalSet(0,0.1*1e4);
                        end
                    else
                        TTLInfo.StimEpoch=intervalSet(0,0.1*1e4);
                    end
                    RemovEpoch=or(TTLInfo.StimEpoch,TotalNoiseEpoch);
                    
                    if isfield(Behav,'ZoneEpoch')
                        for ep=1:min([length(Behav.ZoneEpoch),5])
                            OutPutVar{ep} = intervalSet([Start(OutPutVar{ep});Start(Behav.ZoneEpoch{ep}-RemovEpoch)+tps],...
                                [Stop(OutPutVar{ep});Stop(Behav.ZoneEpoch{ep}-RemovEpoch)+tps]);
                        end
                    end
                    tps=tps + tpsmax;
                end
                
                
            case 'zoneepoch_erc'
                
                for ff=1:length(FolderList)
                    cd(FolderList{ff})
                    load('LFPData/LFP0.mat')
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    
                    load('behavResources_SB.mat')
                    
                    if ff ==1
                        for ep=1:9
                            OutPutVar{ep} = intervalSet([],[]);
                        end
                        tps = 0; % this variable counts the total time of all concatenated data
                        
                    end
                    
                    %                         load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch','Epoch')
                    %                         try,TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch),Stop(TTLInfo.StimEpoch)+0.2*1e4);
                    %                         catch, TTLInfo.StimEpoch=intervalSet(0,0.1); end
                    %                         RemovEpoch=or(TTLInfo.StimEpoch,TotalNoiseEpoch);
                    %
                    if isfield(Behav,'ZoneEpoch')
                        
                        for ep=1:min([length(Behav.ZoneEpoch),9])
                            %                                 OutPutVar{ep} = intervalSet([Start(OutPutVar{ep});Start(Behav.ZoneEpoch{ep}-RemovEpoch)+tps],...
                            %                                     [Stop(OutPutVar{ep});Stop(Behav.ZoneEpoch{ep}-RemovEpoch)+tps]);
                            OutPutVar{ep} = intervalSet([Start(OutPutVar{ep});Start(Behav.ZoneEpoch{ep})+tps],...
                                [Stop(OutPutVar{ep});Stop(Behav.ZoneEpoch{ep})+tps]);
                            
                            
                        end
                    end
                    tps=tps + tpsmax;
                end
                
                
            case 'zoneepoch_behav' % same as zone epoch but noise was not removed
                
                for ff=1:length(FolderList)
                    
                    cd(FolderList{ff})
                    try
                        load('LFPData/LFP0.mat')
                    catch
                        load('ChannelsToAnalyse/Bulb_deep.mat')
                        load(['LFPData/LFP' num2str(channel) '.mat'])
                    end
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    
                    try
                        load('behavResources_SB.mat','Behav')
                        Behav.ZoneEpoch;
                    catch
                        load('behavResources.mat','ZoneEpoch')
                        Behav.ZoneEpoch = ZoneEpoch;
                    end
                    
                    if ff ==1
                        for ep=1:5
                            OutPutVar{ep} = intervalSet([],[]);
                        end
                        tps = 0; % this variable counts the total time of all concatenated data
                    end
                    
                    for ep=1:min([length(Behav.ZoneEpoch),5])
                        OutPutVar{ep} = intervalSet([Start(OutPutVar{ep});Start(Behav.ZoneEpoch{ep})+tps],...
                            [Stop(OutPutVar{ep});Stop(Behav.ZoneEpoch{ep})+tps]);
                    end
                    tps=tps + tpsmax;
                end
                
                
            case 'noiseepoch'
                
                OutPutVar = intervalSet([],[]);
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    
                    cd(FolderList{ff})
                    try
                        load('LFPData/LFP0.mat')
                    catch
                        load('ChannelsToAnalyse/Bulb_deep.mat')
                        load(['LFPData/LFP' num2str(channel) '.mat'])
                    end
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    
                    clear SleepyEpoch TotalNoiseEpoch
                    try
                        load('behavResources_SB.mat','TotalNoiseEpoch')
                        TotalNoiseEpoch;
                    catch
                        try
                            load('behavResources.mat','TotalNoiseEpoch')
                            TotalNoiseEpoch;
                        catch
                            try
                                load('StateEpochSB.mat','TotalNoiseEpoch')
                                TotalNoiseEpoch;
                            catch
                                try
                                    load('SleepScoring_OBGamma.mat', 'TotalNoiseEpoch')
                                    TotalNoiseEpoch;
                                catch
                                    try
                                        load('StateEpochSBAllOB.mat', 'TotalNoiseEpoch')
                                        TotalNoiseEpoch;
                                    catch
                                        try
                                            load('SleepScoring_Accelero.mat', 'TotalNoiseEpoch')
                                            TotalNoiseEpoch;
                                        catch
                                            TotalNoiseEpoch = intervalSet([],[]);
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
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
                        try % add by BM for convenience
                            load('behavResources_SB.mat')
                        catch
                            load('behavResources.mat')
                        end
                        try
                            load('StateEpochSB.mat','TotalNoiseEpoch','SWSEpoch','REMEpoch','Wake')
                            SWSEpoch;
                        catch
                            try
                                load('SleepScoring_OBGamma.mat','TotalNoiseEpoch','SWSEpoch','REMEpoch','Wake')
                            catch
                                load('StateEpochSBAllOB.mat','SWSEpoch','REMEpoch','Wake','TotalNoiseEpoch')
                            end
                        end
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
                
            case 'sleepstates_accelero'
                
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
                        try % add by BM for convenience
                            load('SleepScoring_Accelero.mat','SWSEpoch','REMEpoch','Wake','TotalNoiseEpoch')
                        end
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
                        
                    end
                end
                
            case 'NREMsubstages'
                
                OutPutVar{1} = intervalSet([],[]); % N1
                OutPutVar{2} = intervalSet([],[]); % N2
                OutPutVar{3} = intervalSet([],[]); % N3
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    cd(FolderList{ff})
                    load('LFPData/LFP0.mat')
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    
                    load('ExpeInfo.mat')
                    
                    if ExpeInfo.SleepSession
                        try % add by BM for convenience
                            load('behavResources_SB.mat')
                        catch
                            load('behavResources.mat')
                        end
                        load('SleepSubstages.mat')
                        load('StateEpochSB.mat','TotalNoiseEpoch')
                        N1Epoch = Epoch{1}-TotalNoiseEpoch;
                        N2Epoch = Epoch{2}-TotalNoiseEpoch;
                        N3Epoch = Epoch{3}-TotalNoiseEpoch;
                        
                        OutPutVar{1}=intervalSet([Start(OutPutVar{1});Start(N1Epoch)+tps],...
                            [Stop(OutPutVar{1});Stop(N1Epoch)+tps]);
                        OutPutVar{2}=intervalSet([Start(OutPutVar{2});Start(N2Epoch)+tps],...
                            [Stop(OutPutVar{2});Stop(N2Epoch)+tps]);
                        OutPutVar{3}=intervalSet([Start(OutPutVar{3});Start(N3Epoch)+tps],...
                            [Stop(OutPutVar{3});Stop(N3Epoch)+tps]);
                        
                        tps=tps + tpsmax;
                    else
                        disp('no sleep session')
                    end
                end
                
                
            case 'blockedepoch'
                
                OutPutVar = intervalSet([],[]);
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    
                    cd(FolderList{ff})
                    try
                        load('LFPData/LFP0.mat')
                    catch
                        load('ChannelsToAnalyse/Bulb_deep.mat')
                        load(['LFPData/LFP' num2str(channel) '.mat'])
                    end
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    load('ExpeInfo.mat')
                    if ~isfield(ExpeInfo,'SessionNumber')
                        ExpeInfo.SessionNumber=1;
                    end
                    try
                        load('behavResources_SB.mat')
                    catch
                        load('behavResources.mat')
                    end
                    
                    if not(isempty(findstr(ExpeInfo.SessionType, 'Blocked')))
                        if max(Range(LFP,'s'))>300
                            BlockedEpoch = intervalSet(0,300e4);
                        else
                            BlockedEpoch = intervalSet(0,max(Range(LFP)));
                        end
                        
                    elseif and(or(not(isempty(findstr(ExpeInfo.SessionType, 'Habituation24HPre_PreDrug'))),...
                            not(isempty(findstr(ExpeInfo.SessionType, 'Habituation_PreDrug')))),...
                            ExpeInfo.SessionNumber==1)
                        
                        if max(Range(LFP,'s'))>300
                            BlockedEpoch = intervalSet(5*60e4,15*60e4);
                        else
                            BlockedEpoch = intervalSet(0,max(Range(LFP)));
                        end
                        
                    elseif and(or(not(isempty(findstr(ExpeInfo.SessionType, 'Habituation24HPre_PreDrug'))),...
                            not(isempty(findstr(ExpeInfo.SessionType, 'Habituation_PreDrug')))),...
                            ExpeInfo.SessionNumber==2)
                        
                        if max(Range(LFP,'s'))>300
                            BlockedEpoch = intervalSet(3*60e4,15*60e4);
                        else
                            BlockedEpoch = intervalSet(0,max(Range(LFP)));
                        end
                        
                    else
                        BlockedEpoch = intervalSet([],[]);
                    end
                    
                    
                    OutPutVar=intervalSet([Start(OutPutVar);Start(BlockedEpoch)+tps],...
                        [Stop(OutPutVar);Stop(BlockedEpoch)+tps]);
                    
                    tps=tps + tpsmax;
                    
                end
                
                
            case 'stimepoch'
                OutPutVar = intervalSet([],[]);
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    
                    cd(FolderList{ff})
                    try
                        load('LFPData/LFP0.mat')
                    catch
                        load('ChannelsToAnalyse/Bulb_deep.mat')
                        load(['LFPData/LFP' num2str(channel) '.mat'])
                    end
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    
                    clear SleepyEpoch
                    try
                        load('behavResources_SB.mat')
                        if not(isfield(TTLInfo,'StimEpoch'))
                            TTLInfo.StimEpoch=intervalSet([],[]);
                        elseif isempty(TTLInfo.StimEpoch)
                            TTLInfo.StimEpoch=intervalSet([],[]);
                        end
                    catch
                        disp('Problem !!!! no behavResources_SB.mat')
                        try
                            load('behavResources.mat', 'StimEpoch')
                            StimEpoch;
                            TTLInfo.StimEpoch=StimEpoch;
                        catch
                            load('behavResources.mat', 'TTLInfo')
                        end
                    end
                    
                    OutPutVar=intervalSet([Start(OutPutVar);Start(TTLInfo.StimEpoch)+tps],...
                        [Stop(OutPutVar);Start(TTLInfo.StimEpoch)+.2*1e4+tps]); % change by BM on 02/03/2023 because duration of stim is the one of TTL before around 10ms
                    tps=tps + tpsmax;
                    
                end
                
            case 'stimepoch2'
                OutPutVar = intervalSet([],[]);
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    
                    cd(FolderList{ff})
                    load('LFPData/LFP0.mat')
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    
                    load('behavResources_SB.mat')
                    if or(sum(Start(TTLInfo.StimEpoch2)>480e4)>1 , sum(Start(TTLInfo.StimEpoch2)<0)>1)
                        %                         keyboard
                        % little correction due to some stims time<0
                        load('behavResources.mat', 'TTLInfo')
                        St = Start(TTLInfo.StimEpoch2);
                        St(St<0)=NaN;
                        Sto = Stop(TTLInfo.StimEpoch2);
                        Sto(Sto<0)=NaN;
                        TTLInfo.StimEpoch2 = intervalSet(St , Sto);
                        save('behavResources.mat','TTLInfo','-append')
                        save('behavResources_SB.mat','TTLInfo','-append')
                        
                    elseif not(isfield(TTLInfo,'StimEpoch2'))
                        TTLInfo.StimEpoch2=intervalSet([],[]);
                    elseif isempty(TTLInfo.StimEpoch)
                        TTLInfo.StimEpoch2=intervalSet([],[]);
                    end
                    
                    OutPutVar=intervalSet([Start(OutPutVar);Start(TTLInfo.StimEpoch2)+tps],...
                        [Stop(OutPutVar);Stop(TTLInfo.StimEpoch2)+tps]);
                    tps=tps + tpsmax;
                    
                end
                
                
            case 'vhc_stim'
                OutPutVar = intervalSet([],[]);
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    
                    cd(FolderList{ff})
                    load('LFPData/LFP0.mat')
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    
                    try
                        load('behavResources_SB.mat','TTLInfo')
                        TTLInfo.StimEpoch2;
                    catch
                        try
                            load('behavResources.mat','TTLInfo')
                            TTLInfo.StimEpoch2;
                        catch
                            load('behavResources.mat','StimEpoch2')
                            TTLInfo.StimEpoch2 = StimEpoch2;
                        end
                    end
                    
                    OutPutVar=intervalSet([Start(OutPutVar);Start(TTLInfo.StimEpoch2)+tps],...
                        [Stop(OutPutVar);Stop(TTLInfo.StimEpoch2)+tps]);
                    tps=tps + tpsmax;
                    
                end
                
                
            case 'afterstimepoch'
                OutPutVar = intervalSet([],[]);
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    
                    cd(FolderList{ff})
                    try
                        load('LFPData/LFP0.mat')
                    catch
                        load('ChannelsToAnalyse/Bulb_deep.mat')
                        load(['LFPData/LFP' num2str(channel) '.mat'])
                    end
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    
                    clear SleepyEpoch
                    try
                        load('behavResources_SB.mat')
                    catch
                        try
                            load('behavResources.mat')
                            TTLInfo.StimEpoch = StimEpoch;
                        catch
                            TTLInfo.StimEpoch = intervalSet([],[]);
                        end
                    end
                    if not(isfield(TTLInfo,'StimEpoch'))
                        TTLInfo.StimEpoch=intervalSet([],[]);
                    elseif isempty(TTLInfo.StimEpoch)
                        TTLInfo.StimEpoch=intervalSet([],[]);
                    end
                    
                    OutPutVar=intervalSet([Start(OutPutVar);Stop(TTLInfo.StimEpoch)+2e3+tps],...
                        [Stop(OutPutVar);Stop(TTLInfo.StimEpoch)+5.2e4+tps]);
                    tps=tps + tpsmax;
                    
                end
                
                
            case 'sessiontype'
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    
                    cd(FolderList{ff})
                    try
                        load('LFPData/LFP0.mat')
                    catch
                        load('ChannelsToAnalyse/Bulb_deep.mat')
                        load(['LFPData/LFP' num2str(channel) '.mat'])
                    end
                    
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
                
            case 'sleepyepoch'
                OutPutVar = intervalSet([],[]);
                tps = 0; % this variable counts the total time of all concatenated data
                
                for ff=1:length(FolderList)
                    
                    cd(FolderList{ff})
                    try
                        load('LFPData/LFP0.mat')
                    catch
                        load('ChannelsToAnalyse/Bulb_deep.mat')
                        load(['LFPData/LFP' num2str(channel) '.mat'])
                    end
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    
                    clear SleepyEpoch
                    load('StateEpochSB.mat','SleepyEpoch','TotalNoiseEpoch')
                    
                    Sleepy_Epoch = SleepyEpoch-TotalNoiseEpoch;
                    OutPutVar=intervalSet([Start(OutPutVar);Start(Sleepy_Epoch)+tps],...
                        [Stop(OutPutVar);Stop(Sleepy_Epoch)+tps]);
                    
                    tps=tps + tpsmax;
                    
                end
                
                
            case 'tot_epoch'
                
                tps = 0; % this variable counts the total time of all concatenated data
                OutPutVar = intervalSet([],[]);
                
                for ff=1:length(FolderList)
                    cd(FolderList{ff})
                    try
                        load('LFPData/LFP0.mat')
                    catch
                        load('ChannelsToAnalyse/Bulb_deep.mat')
                        load(['LFPData/LFP' num2str(channel) '.mat'])
                    end
                    tpsmax = max(Range(LFP)); % use LFP to get precise end time
                    TotEpoch = intervalSet(0,max(Range(LFP)));
                    
                    OutPutVar=intervalSet([Start(OutPutVar);Start(TotEpoch)+tps],...
                        [Stop(OutPutVar);Stop(TotEpoch)+tps]);
                    tps=tps + tpsmax;
                end
                
        end % end of epoch loop
        
    case 'linearposition'
        
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            
            load('behavResources_SB.mat','Behav')
            if not(isfield(Behav,'LinearDist'))
                Behav.LinearDist = tsd([0,max(Range(LFP))],[NaN;NaN]);
            end
            Behav.LinearDist = Restrict(Behav.LinearDist,intervalSet(0,tpsmax));
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
            try
                load('LFPData/LFP0.mat')
            catch
                try
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(['LFPData/LFP' num2str(channel) '.mat'])
                catch
                    load('behavResources.mat', 'Xtsd')
                    LFP=Xtsd;
                end
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            TotEpoch = intervalSet(0,max(Range(LFP)));
            
            try
                load('behavResources_SB.mat','Behav')
                Speed = Behav.Vtsd;
            catch
                try
                    load('behavResources.mat','Vtsd')
                    Speed = Vtsd;
                catch
                    try
                        load('behavResources.mat','V')
                        Speed = V;
                    catch
                        load('behavResources.mat','Movtsd')
                        Speed = Movtsd;
                        
                        
                    end
                end
            end
            try
                rg = Range(Restrict(Speed,TotEpoch));
                dt = Data(Restrict(Speed,TotEpoch));
                %OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                OutPutVar = tsd([Range(OutPutVar) ; (rg(1)-(rg(1)/10))+tps ; rg+tps],[dt(1) ; Data(OutPutVar);dt]); % added by BM on 23/11/2021
            catch
                keyboard
                OutPutVar = tsd([Range(OutPutVar);[0:1e4:Stop(TotEpoch)]'+tps],[Data(OutPutVar);[0:1e4:Stop(TotEpoch)]'*NaN]);
            end
            tps=tps + tpsmax;
        end
        
    case 'trackingnans'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            try
                load('LFPData/LFP0.mat')
            catch
                try
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(['LFPData/LFP' num2str(channel) '.mat'])
                catch
                    load('behavResources.mat', 'Xtsd')
                    LFP=Xtsd;
                end
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            TotEpoch = intervalSet(0,max(Range(LFP)));
            
            
            load('behavResources.mat','PosMat')
            PosMattsd = tsd(PosMat(:,1)*1e4,double(isnan(PosMat(:,4))));
            
            % Align with speed
            try
                load('behavResources_SB.mat','Behav')
                Speed = Behav.Vtsd;
            catch
                try
                    load('behavResources.mat','Vtsd')
                    Speed = Vtsd;
                catch
                    try
                        load('behavResources.mat','V')
                        Speed = V;
                    catch
                        load('behavResources.mat','Movtsd')
                        Speed = Movtsd;
                    end
                end
            end
            PosMattsd = Restrict(PosMattsd,ts(Range(Speed)));

            try
                rg = Range(Restrict(PosMattsd,TotEpoch));
                dt = Data(Restrict(PosMattsd,TotEpoch));
                %OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                OutPutVar = tsd([Range(OutPutVar) ; (rg(1)-(rg(1)/10))+tps ; rg+tps],[dt(1) ; Data(OutPutVar);dt]); % added by BM on 23/11/2021
            catch
                keyboard
                OutPutVar = tsd([Range(OutPutVar);[0:1e4:Stop(TotEpoch)]'+tps],[Data(OutPutVar);[0:1e4:Stop(TotEpoch)]'*NaN]);
            end
            tps=tps + tpsmax;
        end
        
    case 'jumps'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = intervalSet([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            
            load('behavResources_SB.mat','Behav')
            if isfield(Behav,'JumpEpoch')
                
                OutPutVar=intervalSet([Start(OutPutVar);Start(Behav.JumpEpoch)+tps],...
                    [Stop(OutPutVar);Stop(Behav.JumpEpoch)+tps]);
            end
            tps=tps + tpsmax;
        end
        
        
    case 'position'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
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
            try
                load('LFPData/LFP0.mat')
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                TotEpoch = intervalSet(0,max(Range(LFP)));
            catch % add by BM on 09/08/2023
                load('behavResources.mat', 'Xtsd')
                tpsmax = max(Range(Xtsd)); % use LFP to get precise end time
                TotEpoch = intervalSet(0,max(Range(Xtsd)));
            end
            
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
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            TotEpoch = intervalSet(0,max(Range(LFP)));
            
            try
                load('behavResources_SB.mat','Behav')
                Accelero = Behav.MovAcctsd;
                if isempty(Accelero)
                    error
                end
            catch
                try
                    load('behavResources.mat', 'MovAcctsd')
                    Accelero = MovAcctsd;
                    if isempty(Accelero)
                        error
                    end
                catch
                    try
                        load('behavResources.mat', 'Movtsd')
                        Accelero = Movtsd;
                    catch
                        Accelero = tsd([],[]);
                    end
                end
            end
            rg = Range(Restrict(Accelero,TotEpoch));
            dt = Data(Restrict(Accelero,TotEpoch));
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            
            tps=tps + tpsmax;
        end
        
    case 'heart_times'
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            if exist('HeartBeatInfo.mat')>0
                try
                    load('LFPData/LFP0.mat')
                catch
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(['LFPData/LFP' num2str(channel) '.mat'])
                end
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                
                load('HeartBeatInfo.mat')
                rg = Range(EKG.HBTimes);
                dt = Data(EKG.HBTimes);
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                tps=tps + tpsmax;
            end
        end
        
        
    case 'heart_isi'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            if exist('HeartBeatInfo.mat')>0
                try
                    load('LFPData/LFP0.mat')
                catch
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(['LFPData/LFP' num2str(channel) '.mat'])
                end
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                
                load('HeartBeatInfo.mat')
                rg = Range(EKG.HBTimes);
                dt = Data(EKG.HBTimes);
                ISI = [mean(diff(dt));diff(dt)]/1E4;
                ISI(ISI>0.3) = NaN;
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);ISI]);
                tps=tps + tpsmax;
            end
        end
        
        
    case 'heartrate'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            if exist('HeartBeatInfo.mat')>0
                try
                    load('LFPData/LFP0.mat')
                catch
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(['LFPData/LFP' num2str(channel) '.mat'])
                end
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                
                load('HeartBeatInfo.mat')
                rg = Range(EKG.HBRate);
                dt = Data(EKG.HBRate);
                
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                tps=tps + tpsmax;
                %             else
                %                 keyboard
            end
        end
        
        
    case 'heartrate_evenbad'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            if exist('HeartBeatInfo.mat')>0
                try
                    load('LFPData/LFP0.mat')
                catch
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(['LFPData/LFP' num2str(channel) '.mat'])
                end
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                load('HeartBeatInfo.mat')
                rg = Range(EKG.HBRate);
                dt = Data(EKG.HBRate);
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                tps=tps + tpsmax;
            elseif  exist('HeartBeatInfoBad.mat')>0
                try
                    load('LFPData/LFP0.mat')
                catch
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(['LFPData/LFP' num2str(channel) '.mat'])
                end
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                
                load('HeartBeatInfoBad.mat')
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
                dt = movstd(Data(EKG.HBRate),5);
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                tps=tps + tpsmax;
            end
        end
        
        
    case 'ripples'
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            if exist('SWR.mat')>0
                
                try
                    load('LFPData/LFP0.mat')
                catch
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(['LFPData/LFP' num2str(channel) '.mat'])
                end
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                
                load('SWR.mat')
                tRipples = ts(ripples(:,2)*1e4);
                
                rg = Range(tRipples);
                OutPutVar = ts([Range(OutPutVar);rg+tps]);
                tps=tps + tpsmax;
            end
        end
        
        
    case 'ripples_sleep_thr'
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            if exist('RipplesSleepThresh.mat')>0
                
                try
                    load('LFPData/LFP0.mat')
                catch
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(['LFPData/LFP' num2str(channel) '.mat'])
                end
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                
                load('RipplesSleepThresh.mat')
                tRipples = ts(RipplesR(:,2)*10);
                
                rg = Range(tRipples);
                OutPutVar = ts([Range(OutPutVar);rg+tps]);
                tps=tps + tpsmax;
            end
        end
        
        
    case 'ripples_thr'
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            if exist('Ripples.mat')>0
                
                try
                    load('LFPData/LFP0.mat')
                catch
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(['LFPData/LFP' num2str(channel) '.mat'])
                end
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                
                load('Ripples.mat')
                tRipples = ts(RipplesR(:,2)*10);
                
                rg = Range(tRipples);
                OutPutVar = ts([Range(OutPutVar);rg+tps]);
                tps=tps + tpsmax;
            end
        end
        
        
    case 'ripples_epoch'
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = intervalSet([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            if exist('SWR.mat')>0
                
                try
                    load('LFPData/LFP0.mat')
                catch
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(['LFPData/LFP' num2str(channel) '.mat'])
                end
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                
                load('SWR.mat', 'RipplesEpoch')
                
                OutPutVar=intervalSet([Start(OutPutVar);Start(RipplesEpoch)+tps],...
                    [Stop(OutPutVar);Stop(RipplesEpoch)+tps]);
                tps=tps + tpsmax;
            end
        end
        
        
    case 'ripples_all'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            if exist('SWR.mat')>0
                try
                    load('LFPData/LFP0.mat')
                catch
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(['LFPData/LFP' num2str(channel) '.mat'])
                end
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                
                load('SWR.mat')
                rg = Range(tRipples);
                dt = ripples;
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);[dt(:,1:3).*1e4+tps dt(:,4:6)]]);
                tps=tps + tpsmax;
            end
        end
        
        
        
    case 'spindles'
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            if exist('Spindles.mat')>0
                
                load('LFPData/LFP0.mat')
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                
                [tSpindles, SpindlesEpoch] = GetSpindles;
                
                rg = Range(tSpindles);
                OutPutVar = ts([Range(OutPutVar);rg+tps]);
                tps=tps + tpsmax;
            end
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
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            tps = tps +tpsmax;
            OutPutVar(ff) = tps;
        end
        
        
    case 'tailtemperature'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            try cd([FolderList{ff} 'Temperature'])
                if exist('Temperature.mat')>0
                    load('Temperature.mat')
                    rg = Range(Temp.TailTemperatureTSD);
                    dt = Data(Temp.TailTemperatureTSD);
                    OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                    tps=tps + tpsmax;
                end
            catch
            end
        end
        
    case 'roomtemperature'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('LFPData/LFP0.mat')
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            try cd([FolderList{ff} '/Temperature'])
                if exist('Temperature.mat')>0
                    load('Temperature.mat')
                    rg = Range(Temp.RoomTemperatureTSD);
                    dt = Data(Temp.RoomTemperatureTSD);
                    OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                    tps=tps + tpsmax;
                end
            catch
            end
        end
        
    case 'masktemperature'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('LFPData/LFP0.mat')
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            try cd([FolderList{ff} '/Temperature'])
                if exist('Temperature.mat')>0
                    load('Temperature.mat')
                    rg = Range(Temp.MouseTemperatureTSD);
                    dt = Data(Temp.MouseTemperatureTSD);
                    OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                    tps=tps + tpsmax;
                end
            catch
            end
        end
        
    case 'tailtemperatureint'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('LFPData/LFP0.mat')
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            try cd([FolderList{ff} '/Temperature'])
                if exist('Temperature.mat')>0
                    load('Temperature.mat')
                    rg = Range(Temp.TailTemperatureintTSD);
                    dt = Data(Temp.TailTemperatureintTSD);
                    OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                    tps=tps + tpsmax;
                end
            catch
            end
        end
        
    case 'risk_assessment'
        
        OutPutVar = intervalSet([],[]);
        tps = 0; % this variable counts the total time of all concatenated data
        
        for ff=1:length(FolderList)
            
            cd(FolderList{ff})
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            load('ExpeInfo.mat')
            load('behavResources_SB.mat')
            try
                if not(isempty(Behav.RAUser.ToShock))
                    OutPutVar=intervalSet([Start(OutPutVar);Start(Behav.RAEpoch.ToShock)+tps],...
                        [Stop(OutPutVar);Stop(Behav.RAEpoch.ToShock)+tps]);
                end
                tps=tps + tpsmax;
            end
        end
        
    case 'ra_grade'
        
        OutPutVar = [];
        
        for ff=1:length(FolderList)
            
            cd(FolderList{ff})
            load('behavResources_SB.mat')
            if not(isempty(Behav.RAUser.ToShock))
                OutPutVar=[OutPutVar;Behav.RAUser.ToShock'];
            end
        end
        
    case 'emg_pect'
        
        OutPutVar = tsd([],[]);
        tps = 0; % this variable counts the total time of all concatenated data
        try, chan_numb = Get_chan_numb_BM(FolderList{1} , 'EKG'); end
        
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
                FilLFP=FilterLFP(EMG_TSD , [50 300] , 1024);
                EMG_TSD=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(3/median(diff(Range(FilLFP,'s'))))));
                
                rg = Range(EMG_TSD);
                dt = Data(EMG_TSD);
                
                %                 OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                OutPutVar = tsd([Range(OutPutVar);rg(1:10:end)+tps],[Data(OutPutVar);dt(1:10:end)]); % add on 04/05/2024 because too heavy
                tps=tps + tpsmax;
            end
        end
        
        
    case 'emg_neck'
        
        OutPutVar = tsd([],[]);
        tps = 0; % this variable counts the total time of all concatenated data
        try; chan_numb = Get_chan_numb_BM(FolderList{1} , 'EMG'); end
        
        for ff=1:length(FolderList)
            try
                cd(FolderList{ff})
                load(['LFPData/LFP' num2str(chan_numb) '.mat'])
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                TotEpoch = intervalSet(0,tpsmax);
                
                EMG_TSD = Restrict(LFP, TotEpoch);
                FilLFP=FilterLFP(EMG_TSD , [50 300] , 1024);
                EMG_TSD=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(.5/median(diff(Range(FilLFP,'s'))))));
                
                rg = Range(EMG_TSD);
                dt = Data(EMG_TSD);
                
                OutPutVar = tsd([Range(OutPutVar);rg(1:10:end)+tps],[Data(OutPutVar);dt(1:10:end)]);
                tps=tps + tpsmax;
            end
        end
        
        
    case 'emg_any'
        
        OutPutVar = tsd([],[]);
        tps = 0; % this variable counts the total time of all concatenated data
        try
            chan_numb = Get_chan_numb_BM(FolderList{1} , 'EMG');
            neck=1;
        catch
            chan_numb = Get_chan_numb_BM(FolderList{1} , 'EKG');
            neck=0;
        end
        
        for ff=1:length(FolderList)
            try
                cd(FolderList{ff})
                load(['LFPData/LFP' num2str(chan_numb) '.mat'])
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                TotEpoch = intervalSet(0,tpsmax);
                
                if neck==0
                    load('HeartBeatInfo.mat')
                    Before_HeartBeat = ts(Range(EKG.HBTimes)-100);
                    After_HeartBeat = ts(Range(EKG.HBTimes)+100);
                    
                    HeartBeat_Epoch=intervalSet(Before_HeartBeat,After_HeartBeat);
                    EMG_Epoch = TotEpoch-HeartBeat_Epoch;
                end
                
                EMG_TSD = Restrict(LFP, EMG_Epoch);
                FilLFP=FilterLFP(EMG_TSD , [50 300] , 1024);
                EMG_TSD=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(.5/median(diff(Range(FilLFP,'s'))))));
                
                rg = Range(EMG_TSD);
                dt=Data(EMG_TSD);
                
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                tps=tps + tpsmax;
            end
        end
        
        
    case 'respi_freq_bm'
        
        OutPutVar = tsd([],[]);
        tps = 0; % this variable counts the total time of all concatenated data
        
        for ff=1:length(FolderList)
            try
                cd(FolderList{ff})
                try
                    load('LFPData/LFP0.mat')
                catch
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(['LFPData/LFP' num2str(channel) '.mat'])
                end
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                
                load('B_Low_Spectrum.mat')
                Spectrum_Frequency = ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1});
                
                rg = Range(Spectrum_Frequency);
                dt=Data(Spectrum_Frequency);
                
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                tps=tps + tpsmax;
            end
        end
        
        
    case 'respivar'
        
        OutPutVar = tsd([],[]);
        tps = 0; % this variable counts the total time of all concatenated data
        
        for ff=1:length(FolderList)
            try
                cd(FolderList{ff})
                try
                    load('LFPData/LFP0.mat')
                catch
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(['LFPData/LFP' num2str(channel) '.mat'])
                end
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                TotEpoch = intervalSet(0,tpsmax);
                
                load('B_Low_Spectrum.mat')
                Spectrum_Frequency=ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1});
                
                rg = Range(Spectrum_Frequency);
                dt_pre=Data(Spectrum_Frequency);
                
                [ MovPerc ] = running_percentile_BM(dt_pre, 100, 95);
                dt_pre(dt_pre>MovPerc)=NaN; % Remove high respi values consequences of bad detection
                dt = movstd(dt_pre,5);
                
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                tps=tps + tpsmax;
            end
        end
        
        
    case 'respi_peak'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        try; chan_numb = Get_chan_numb_BM(FolderList{1} , 'bulb_deep'); end
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            if exist('InstFreqAndPhase_B.mat')>0
                load(['LFPData/LFP' num2str(chan_numb) '.mat'])
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                
                load('InstFreqAndPhase_B.mat', 'AllPeaks')
                
                Peak_or_Through = ts(AllPeaks(2:2:end,1)*1e4);
                Through_or_Peak = ts(AllPeaks(1:2:end,1)*1e4);
                
                LFP_Peak_or_Through = nanmean(Data(Restrict(LFP , Peak_or_Through)));
                LFP_Through_or_Peak = nanmean(Data(Restrict(LFP , Through_or_Peak)));
                
                if LFP_Peak_or_Through>LFP_Through_or_Peak
                    rg = AllPeaks(2:6:end,1)*1e4;
                else
                    rg = AllPeaks(1:6:end,1)*1e4;
                end
                
                OutPutVar = ts([Range(OutPutVar);rg+tps]);
                tps=tps + tpsmax;
            end
        end
        
        
    case 'respi_freq_bm_sametps'
        
        OutPutVar = tsd([],[]);
        tps = 0; % this variable counts the total time of all concatenated data
        
        for ff=1:length(FolderList)
            try
                cd(FolderList{ff})
                try
                    load('LFPData/LFP0.mat')
                catch
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(['LFPData/LFP' num2str(channel) '.mat'])
                end
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                TotEpoch = intervalSet(0,tpsmax);
                
                load('B_Low_Spectrum.mat')
                Spectrum_Frequency=ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1});
                
                Spectrum_Frequency = Restrict(Spectrum_Frequency,ts([1e4:1e4:tpsmax-1e4]));
                
                rg = Range(Spectrum_Frequency);
                dt = Data(Spectrum_Frequency);
                
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                tps=tps + tpsmax;
            end
        end
        
        
    case 'heartrate_sametps'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            
            % get ts
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            TotEpoch = intervalSet(0,tpsmax);
            
            load('B_Low_Spectrum.mat')
            Spectrum_Frequency=ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1});
            
            Spectrum_Frequency = Restrict(Spectrum_Frequency,ts([1e4:1e4:tpsmax-1e4]));
            Ts_Sample = ts(Range(Spectrum_Frequency));
            
            if exist('HeartBeatInfo.mat')>0
                
                load('HeartBeatInfo.mat')
                EKG.HBRate = Restrict(EKG.HBRate,Ts_Sample);
                
                rg = Range(Ts_Sample);
                dt = Data(EKG.HBRate);
                
                if length(dt)~= length(Range(Ts_Sample))
                    keyboard
                end
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                tps=tps + tpsmax;
            else
                
                rg = Range(Ts_Sample);
                dt = Range(Ts_Sample)*NaN;
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                tps=tps + tpsmax;
                
            end
        end
        
        
    case 'heartratevar_sametps'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            % get ts
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            TotEpoch = intervalSet(0,tpsmax);
            
            load('B_Low_Spectrum.mat')
            Spectrum_Frequency=ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1});
            
            Spectrum_Frequency = Restrict(Spectrum_Frequency,ts([1e4:1e4:tpsmax-1e4]));
            Ts_Sample = ts(Range(Spectrum_Frequency));
            
            if exist('HeartBeatInfo.mat')>0
                
                load('HeartBeatInfo.mat')
                rg = Range(EKG.HBRate);
                dt = movstd(Data(EKG.HBRate),5);
                
                HBVar = tsd(rg,dt);
                HBVar = Restrict(HBVar,Ts_Sample);
                rg = Range(Ts_Sample);
                dt = Data(HBVar);
                if length(dt)~= length(Range(Ts_Sample))
                    keyboard
                end
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                tps=tps + tpsmax;
                
            else
                
                rg = Range(Ts_Sample);
                dt = Range(Ts_Sample)*NaN;
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                tps=tps + tpsmax;
                
            end
        end
        
        
    case 'ob_high_power_sametps'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            
            % get ts
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            TotEpoch = intervalSet(0,tpsmax);
            
            load('B_Low_Spectrum.mat')
            Spectrum_Frequency=ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1});
            
            Spectrum_Frequency = Restrict(Spectrum_Frequency,ts([1e4:1e4:tpsmax-1e4]));
            Ts_Sample = ts(Range(Spectrum_Frequency));
            
            load('B_High_Spectrum.mat')
            
            rg = Spectro{2}'*1e4;
            dt = runmean(nanmean(Spectro{1}(:,find(Spectro{3}>50,1,'first'):find(Spectro{3}>80,1,'first')),2),100);
            
            OBVar = tsd(rg,dt);
            OBVar = Restrict(OBVar,Ts_Sample);
            rg = Range(Ts_Sample);
            dt = Data(OBVar);
            if length(dt)~= length(Range(Ts_Sample))
                keyboard
            end
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            tps = tps +tpsmax;
        end
        
        
    case 'ob_high_freq_sametps'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            
            % get ts
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            TotEpoch = intervalSet(0,tpsmax);
            
            load('B_Low_Spectrum.mat')
            Spectrum_Frequency=ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1});
            
            Spectrum_Frequency = Restrict(Spectrum_Frequency,ts([1e4:1e4:tpsmax-1e4]));
            Ts_Sample = ts(Range(Spectrum_Frequency));
            
            load('B_High_Spectrum.mat')
            
            rg = Spectro{2}'*1e4;
            [val,ind] = max(Spectro{1}(:,find(Spectro{3}>50,1,'first'):find(Spectro{3}>80,1,'first')),[],2);
            dt = movmedian(ind,100);
            OBVar = tsd(rg,dt);
            OBVar = Restrict(OBVar,Ts_Sample);
            rg = Range(Ts_Sample);
            dt = Data(OBVar);
            if length(dt)~= length(Range(Ts_Sample))
                keyboard
            end
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            tps = tps +tpsmax;
        end
        
        
    case 'ob_gamma_freq'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            
            % get ts
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            
            load('B_High_Spectrum.mat')
            [Spectrum_Frequency , ~] = ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1} , 'frequency_band' , [50 80] , 'bin_size' , 50);
            
            rg = Range(Spectrum_Frequency);
            dt = Data(Spectrum_Frequency);
            
            OutPutVar = tsd([Range(OutPutVar);rg(1:10:end)+tps],[Data(OutPutVar);dt(1:10:end)]); % add by BM on 05/05/2024 because too heavy
            tps=tps + tpsmax;
        end
        
        
    case 'ob_gamma_power'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            
            % get ts
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            
            try
                load('StateEpochSB.mat', 'smooth_ghi')
                smooth_ghi;
            catch
                load('SleepScoring_OBGamma.mat', 'SmoothGamma')
                smooth_ghi = SmoothGamma;
            end
            
            rg = Range(smooth_ghi);
            dt = Data(smooth_ghi);
            
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            tps=tps + tpsmax;
        end
        
        
    case 'ob_gamma_ratio'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            
            % get ts
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            
            load('B_High_Spectrum.mat')
            %             [~ , Power] = ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1} , 'frequency_band' , [50 80] , 'bin_size' , 50);
            fthe = [find(Spectro{3}<60,1,'last'):find(Spectro{3}<80,1,'last')];
            fall = [find(Spectro{3}<30,1,'last'):find(Spectro{3}<50,1,'last')];
            %             fall = [find(Spectro{3}<40,1,'last'):(length(Spectro{3}))];
            datSpec = nansum(Spectro{1}(:,fthe),2)./nansum(Spectro{1}(:,fall),2);
            
            rg = (Spectro{2}*1e4)';
            dt = datSpec;
            
            
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            tps=tps + tpsmax;
        end
        
        
    case 'hpc_theta_freq'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            
            % get ts
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            
            load('H_Low_Spectrum.mat')
            [Spectrum_Frequency , ~] = ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1} , 'frequency_band' , [5 8]);
            
            rg = Range(Spectrum_Frequency);
            dt = Data(Spectrum_Frequency);
            
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            tps=tps + tpsmax;
        end
        
        
    case 'hpc_freq'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            
            % get ts
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            
            load('H_Low_Spectrum.mat')
            [Spectrum_Frequency , ~] = ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1});
            
            rg = Range(Spectrum_Frequency);
            dt = Data(Spectrum_Frequency);
            
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            tps=tps + tpsmax;
        end
        
        
    case 'hpc_theta_power'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            
            % get ts
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            
            load('H_Low_Spectrum.mat')
            fthe = [find(Spectro{3}<5,1,'last'):find(Spectro{3}<8,1,'last')];
            fall = [find(Spectro{3}<2,1,'last'):(length(Spectro{3}))];
            datSpec = nansum(Spectro{1}(:,fthe),2)./nansum(Spectro{1}(:,fall),2);
            
            rg = (Spectro{2}*1e4)';
            dt = datSpec;
            
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            tps=tps + tpsmax;
        end
        
        
    case 'hpc_theta_delta'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            
            % get ts
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            
            load('H_Low_Spectrum.mat')
            fthe = [find(Spectro{3}<5,1,'last'):find(Spectro{3}<8,1,'last')];
            fall = [find(Spectro{3}<1.5,1,'last'):find(Spectro{3}<5,1,'last')];
            datSpec = nanmean(Spectro{1}(:,fthe),2)./nanmean(Spectro{1}(:,fall),2);
            
            rg = (Spectro{2}*1e4)';
            dt = datSpec;
            
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            tps=tps + tpsmax;
        end
        
        
    case 'pfc_delta_power'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            
            % get ts
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            
            try
                load('PFCx_Low_Spectrum.mat')
                fthe = [find(Spectro{3}<.5,1,'last'):find(Spectro{3}<4,1,'last')];
                fall = [find(Spectro{3}<2,1,'last'):(length(Spectro{3}))];
                datSpec = nanmean(Spectro{1}(:,fthe),2)./nanmean(Spectro{1}(:,fall),2);
                
                rg = (Spectro{2}*1e4)';
                dt = datSpec;
            catch
                rg = [];
                dt = [];
            end
            
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            tps=tps + tpsmax;
        end
        
        
        
        %     case 'ob_gamma_freq'
        %
        %         OutPutVar = tsd([],[]);
        %         tps = 0; % this variable counts the total time of all concatenated data
        %
        %         for ff=1:length(FolderList)
        %             try
        %                 cd(FolderList{ff})
        %                 load('LFPData/LFP0.mat')
        %                 tpsmax = max(Range(LFP)); % use LFP to get precise end time
        %
        %                 load('B_Middle_Spectrum.mat')
        %                 Spectrum_Frequency=ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1} , 21 , 30);
        %
        %                 rg = Range(Spectrum_Frequency);
        %                 dt=Data(Spectrum_Frequency);
        %
        %                 OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
        %                 tps=tps + tpsmax;
        %             end
        %         end
        %
        %
        %     case 'ob_gamma_power'
        %
        %         OutPutVar = tsd([],[]);
        %         tps = 0; % this variable counts the total time of all concatenated data
        %
        %         for ff=1:length(FolderList)
        %             try
        %                 cd(FolderList{ff})
        %                 chan_numb = Get_chan_numb_BM(FolderList{ff} , 'bulb_deep');
        %
        %                 load(['LFPData/LFP' num2str(chan_numb) '.mat'])
        %                 tpsmax = max(Range(LFP)); % use LFP to get precise end time
        %
        %                 FilGamma = FilterLFP(LFP,[50 70],1024); % filtering
        %                 tEnveloppeGamma = tsd(Range(LFP), abs(hilbert(Data(FilGamma))) ); %tsd: hilbert transform then enveloppe% smooth gamma power
        %                 SmoothGamma = tsd(Range(tEnveloppeGamma), runmean(Data(tEnveloppeGamma) , ceil(.5/median(diff(Range(tEnveloppeGamma,'s'))))));
        %
        %                 rg = Range(SmoothGamma);
        %                 dt=Data(SmoothGamma);
        %
        %                 OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
        %                 tps=tps + tpsmax;
        %             end
        %         end
        
        
    case 'ripples_density'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            
            % get ts
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            TotEpoch = intervalSet(0,tpsmax);
            
            load('B_Low_Spectrum.mat')
            Spectrum_Frequency=ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1});
            
            Spectrum_Frequency = Restrict(Spectrum_Frequency,ts([1e4:1e4:tpsmax-1e4]));
            Ts_Sample = ts(Range(Spectrum_Frequency));
            
            
            if exist('SWR.mat')>0
                
                load('SWR.mat')
                
                [Y,X] = hist(Range(tRipples,'s'),[0:1:max(Range(LFP,'s'))]);
                Y = runmean(Y,3); % smooth to get a  better idea of ripple density
                Dat = tsd(X'*1E4,Y');
                Dat = Restrict(Dat,Ts_Sample);
                
                rg = Range(Ts_Sample);
                dt = Data(Dat);
                if length(dt)~= length(Range(Ts_Sample))
                    keyboard
                end
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                tps=tps + tpsmax;
                
            else
                
                rg = Range(Ts_Sample);
                dt = Range(Ts_Sample)*NaN;
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                tps=tps + tpsmax;
            end
        end
        
        
    case 'accelero_sametps'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            
            % get ts
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            TotEpoch = intervalSet(0,tpsmax);
            
            load('B_Low_Spectrum.mat')
            Spectrum_Frequency=ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1});
            
            Spectrum_Frequency = Restrict(Spectrum_Frequency,ts([1e4:1e4:tpsmax-1e4]));
            Ts_Sample = ts(Range(Spectrum_Frequency));
            
            try
                load('behavResources_SB.mat','Behav')
                if isfield(Behav,'MovAcctsd')
                    rg = Range(Ts_Sample);
                    dt = Data(Restrict(Behav.MovAcctsd,Ts_Sample));
                    OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                else
                    rg = Range(Ts_Sample);
                    dt = Range(Ts_Sample)*NaN;
                    OutPutVar = tsd([Range(OutPutVar);rg'+tps],[Data(OutPutVar);dt*NaN]);
                end
            catch
                load('behavResources.mat', 'MovAcctsd')
                rg = Range(Ts_Sample);
                dt = Data(Restrict(MovAcctsd,Ts_Sample));
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            end
            
            tps=tps + tpsmax;
        end
        
        
    case 'hpc_lowtheta_samteps'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            
            % get ts
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            TotEpoch = intervalSet(0,tpsmax);
            
            load('B_Low_Spectrum.mat')
            Spectrum_Frequency=ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1});
            
            Spectrum_Frequency = Restrict(Spectrum_Frequency,ts([1e4:1e4:tpsmax-1e4]));
            Ts_Sample = ts(Range(Spectrum_Frequency));
            
            try
                load('H_Low_Spectrum.mat')
                fthe = [find(Spectro{3}<5,1,'last'):find(Spectro{3}<8,1,'last')];
                fall = [find(Spectro{3}<2,1,'last'):(length(Spectro{3}))];
                datSpec = nanmean(Spectro{1}(:,fthe),2)./nanmean(Spectro{1}(:,fall),2);
                
                Thettsd = tsd(Spectro{2}*1e4,datSpec);
                load('behavResources_SB.mat','Behav')
                rg = Range(Ts_Sample);
                dt = Data(Restrict(Thettsd,Ts_Sample));
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            catch
                rg = Range(Ts_Sample);
                dt = Range(Ts_Sample)*NaN;
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt*NaN]);
            end
            
            tps=tps + tpsmax;
        end
        
        
    case 'linpos_sampetps'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            
            % get ts
            try
                load('LFPData/LFP0.mat')
            catch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP' num2str(channel) '.mat'])
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            TotEpoch = intervalSet(0,tpsmax);
            
            load('B_Low_Spectrum.mat')
            Spectrum_Frequency=ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1});
            
            Spectrum_Frequency = Restrict(Spectrum_Frequency,ts([1e4:1e4:tpsmax-1e4]));
            Ts_Sample = ts(Range(Spectrum_Frequency));
            
            load('behavResources_SB.mat','Behav')
            if not(isfield(Behav,'LinearDist'))
                Behav.LinearDist = tsd([0,max(Range(LFP))],[NaN;NaN]);
            end
            Behav.LinearDist = Restrict(Behav.LinearDist,intervalSet(0,tpsmax));
            dt = Data(Restrict(Behav.LinearDist,Ts_Sample));
            rg = Range(Ts_Sample);
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            
            tps=tps + tpsmax;
        end
        
        
    case 'before_stim_epoch'
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = intervalSet([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            if exist('behavResources_SB.mat')>0
                
                load('LFPData/LFP0.mat')
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                
                load('behavResources_SB.mat', 'TTLInfo')
                
                % 100 ms before stim 100 ms stim after
                OutPutVar=intervalSet([Start(OutPutVar);Start(TTLInfo.StimEpoch2)-1e3+tps],...
                    [Stop(OutPutVar);Start(TTLInfo.StimEpoch2)+1e3+tps]);
                tps=tps + tpsmax;
            end
        end
        
        
    case 'around_ripples_epoch'
        if not(exist('window_time'))
            error('window_time is missing as required input');
        end
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = intervalSet([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            if exist('behavResources_SB.mat')>0
                
                try
                    load('LFPData/LFP0.mat')
                catch
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(['LFPData/LFP' num2str(channel) '.mat'])
                end
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                
                load('SWR.mat', 'ripples')
                ripples_temp = ripples;
                % put in comment by BM on 28/01/2024
                %                 ripples_temp = ripples_temp((ripples_temp(:,3)-ripples_temp(:,1))>.025 , :); % consider only ripples if more than 25ms
                
                OutPutVar=intervalSet([Start(OutPutVar);ripples_temp(:,2)*1e4 - window_time*1e4 + tps],...   % window_time (in sec) after & before ripples
                    [Stop(OutPutVar);ripples_temp(:,2)*1e4 + window_time*1e4 + tps]);
                tps=tps + tpsmax;
            end
        end
        
        
    case 'start_ripples_epoch'
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = intervalSet([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            if exist('behavResources_SB.mat')>0
                
                load('LFPData/LFP0.mat')
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                
                load('SWR.mat', 'ripples')
                
                % 50 ms before ripples begin 100 ms stim after
                OutPutVar=intervalSet([Start(OutPutVar);ripples(:,1)*1e4-.05e4+tps],...
                    [Stop(OutPutVar);ripples(:,3)*1e4+.05e4+tps]);
                tps=tps + tpsmax;
            end
        end
        
        
    case 'escape_latency'
        
        OutPutVar = [];
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            if exist('behavResources_SB.mat')>0
                
                load('behavResources_SB.mat', 'Behav')
                dt = Behav.Latency_BM(1);
                OutPutVar = [OutPutVar ; dt];
            end
        end
        
        
    case 'position_behav'
        
        OutPutVar = tsd([],[]);
        tps = 0; % this variable counts the total time of all concatenated data
        
        for ff=1:length(FolderList)
            try
                cd(FolderList{ff})
                chan_numb = Get_chan_numb_BM(FolderList{ff} , 'bulb_deep');
                
                
                load(['LFPData/LFP' num2str(chan_numb) '.mat'])
                tpsmax = max(Range(LFP)); % use LFP to get precise end time
                
                FilGamma = FilterLFP(LFP,[50 70],1024); % filtering
                tEnveloppeGamma = tsd(Range(LFP), abs(hilbert(Data(FilGamma))) ); %tsd: hilbert transform then enveloppe% smooth gamma power
                SmoothGamma = tsd(Range(tEnveloppeGamma), runmean(Data(tEnveloppeGamma) , ceil(.5/median(diff(Range(tEnveloppeGamma,'s'))))));
                
                rg = Range(SmoothGamma);
                dt=Data(SmoothGamma);
                
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
                tps=tps + tpsmax;
            end
        end
        
        
    case 'imdiff'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('LFPData/LFP0.mat')
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            
            load('behavResources.mat','Imdifftsd')
            
                % Align with speed
            try
                load('behavResources_SB.mat','Behav')
                Speed = Behav.Vtsd;
            catch
                try
                    load('behavResources.mat','Vtsd')
                    Speed = Vtsd;
                catch
                    try
                        load('behavResources.mat','V')
                        Speed = V;
                    catch
                        load('behavResources.mat','Movtsd')
                        Speed = Movtsd;
                    end
                end
            end
Imdifftsd = Restrict(Imdifftsd,ts(Range(Speed)));
            
            rg = Range(Imdifftsd);
            dt = Data(Imdifftsd);
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            tps=tps + tpsmax;
        end
        
        
    case 'smooth_gamma'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            load('LFPData/LFP0.mat')
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            
            load('StateEpochSB.mat', 'smooth_ghi')
            
            rg = Range(smooth_ghi);
            dt = Data(smooth_ghi);
            OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            tps=tps + tpsmax;
        end
        
        
    case 'sz_entries'
        
        OutPutVar = [];
        
        for ff=1:length(FolderList)
            try
                cd(FolderList{ff})
                try
                    load('behavResources_SB.mat', 'Behav')
                    ZoneEpoch = Behav.ZoneEpoch;
                catch
                    load('behavResources.mat', 'ZoneEpoch')
                end
                
                chan_numb = Get_chan_numb_BM(FolderList{ff} , 'bulb_deep');
                load(['LFPData/LFP' num2str(chan_numb) '.mat'])
                TotEpoch = intervalSet(0,max(Range(LFP)));
                
                % freeze
                try
                    FreezeEpoch = Behav.FreezeAccEpoch;
                catch
                    load('behavResources.mat', 'FreezeEpoch')
                end
                ActiveEpoch = TotEpoch-FreezeEpoch;
                
                % blocked
                load('ExpeInfo.mat')
                if not(isempty(findstr(ExpeInfo.SessionType, 'Blocked')))
                    BlockedEpoch=intervalSet(0,300e4);
                    
                elseif and(or(not(isempty(findstr(ExpeInfo.SessionType, 'Habituation24HPre_PreDrug'))),...
                        not(isempty(findstr(ExpeInfo.SessionType, 'Habituation_PreDrug')))),...
                        ExpeInfo.SessionNumber==1)
                    
                    BlockedEpoch = intervalSet(5*60e4,15*60e4);
                    
                elseif and(or(not(isempty(findstr(ExpeInfo.SessionType, 'Habituation24HPre_PreDrug'))),...
                        not(isempty(findstr(ExpeInfo.SessionType, 'Habituation_PreDrug')))),...
                        ExpeInfo.SessionNumber==2)
                    
                    BlockedEpoch = intervalSet(3*60e4,15*60e4);
                    
                else
                    BlockedEpoch = intervalSet(0,0);
                end
                UnblockedEpoch = TotEpoch-BlockedEpoch;
                
                ShockZone = and(ZoneEpoch{1} , and(ActiveEpoch , UnblockedEpoch));
                StaShock = Start(ShockZone); StoShock = Stop(ShockZone);
                
                % zone epoch only considered if longer than 1s and merge with 1s
                clear ind_to_use_shock
                ind_to_use_shock = StoShock(1:end-1)==StaShock(2:end);
                StaShock = StaShock([true ; ~ind_to_use_shock]);
                StoShock = StoShock([~ind_to_use_shock ; true]);
                ShockZoneEpoch_Corrected = intervalSet(StaShock , StoShock);
                ShockZoneEpoch_Corrected = dropShortIntervals(ShockZoneEpoch_Corrected,1e4);
                ShockZoneEpoch_Corrected = mergeCloseIntervals(ShockZoneEpoch_Corrected,1e4);
                SZ_Entries = length(Start(ShockZoneEpoch_Corrected));
                
                OutPutVar = [OutPutVar SZ_Entries];
            end
        end
        
        
    case 'xalignedposition'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            try
                load('LFPData/LFP0.mat')
            catch
                try
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(['LFPData/LFP' num2str(channel) '.mat'])
                catch
                    load('behavResources.mat', 'Xtsd')
                    LFP=Xtsd;
                end
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            TotEpoch = intervalSet(0,max(Range(LFP)));
            
            try
                load('behavResources_SB.mat','Behav')
                Xtsd = Behav.AlignedXtsd;
            catch
                error
                
            end
            try
                rg = Range(Restrict(Xtsd,TotEpoch));
                dt = Data(Restrict(Xtsd,TotEpoch));
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            catch
                keyboard
                OutPutVar = tsd([Range(OutPutVar);[0:1e4:Stop(TotEpoch)]'+tps],[Data(OutPutVar);[0:1e4:Stop(TotEpoch)]'*NaN]);
            end
            tps=tps + tpsmax;
        end
        
        
    case 'yalignedposition'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            try
                load('LFPData/LFP0.mat')
            catch
                try
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(['LFPData/LFP' num2str(channel) '.mat'])
                catch
                    load('behavResources.mat', 'Ytsd')
                    LFP=Xtsd;
                end
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            TotEpoch = intervalSet(0,max(Range(LFP)));
            
            try
                load('behavResources_SB.mat','Behav')
                Ytsd = Behav.AlignedYtsd;
            catch
                error
                
            end
            try
                rg = Range(Restrict(Ytsd,TotEpoch));
                dt = Data(Restrict(Ytsd,TotEpoch));
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            catch
                keyboard
                OutPutVar = tsd([Range(OutPutVar);[0:1e4:Stop(TotEpoch)]'+tps],[Data(OutPutVar);[0:1e4:Stop(TotEpoch)]'*NaN]);
            end
            tps=tps + tpsmax;
        end
        
    case 'xposition'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            try
                load('LFPData/LFP0.mat')
            catch
                try
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(['LFPData/LFP' num2str(channel) '.mat'])
                catch
                    load('behavResources.mat', 'Xtsd')
                    LFP=Xtsd;
                end
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            TotEpoch = intervalSet(0,max(Range(LFP)));
            
            try
                load('behavResources_SB.mat','Behav')
                Xtsd = Behav.Xtsd;
            catch
                error
                
            end
            try
                rg = Range(Restrict(Xtsd,TotEpoch));
                dt = Data(Restrict(Xtsd,TotEpoch));
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            catch
                keyboard
                OutPutVar = tsd([Range(OutPutVar);[0:1e4:Stop(TotEpoch)]'+tps],[Data(OutPutVar);[0:1e4:Stop(TotEpoch)]'*NaN]);
            end
            tps=tps + tpsmax;
        end
        
        
    case 'yposition'
        
        tps = 0; % this variable counts the total time of all concatenated data
        OutPutVar = tsd([],[]);
        for ff=1:length(FolderList)
            cd(FolderList{ff})
            try
                load('LFPData/LFP0.mat')
            catch
                try
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    load(['LFPData/LFP' num2str(channel) '.mat'])
                catch
                    load('behavResources.mat', 'Xtsd')
                    LFP=Xtsd;
                end
            end
            tpsmax = max(Range(LFP)); % use LFP to get precise end time
            TotEpoch = intervalSet(0,max(Range(LFP)));
            
            try
                load('behavResources_SB.mat','Behav')
                Ytsd = Behav.Ytsd;
            catch
                error
                
            end
            try
                rg = Range(Restrict(Ytsd,TotEpoch));
                dt = Data(Restrict(Ytsd,TotEpoch));
                OutPutVar = tsd([Range(OutPutVar);rg+tps],[Data(OutPutVar);dt]);
            catch
                keyboard
                OutPutVar = tsd([Range(OutPutVar);[0:1e4:Stop(TotEpoch)]'+tps],[Data(OutPutVar);[0:1e4:Stop(TotEpoch)]'*NaN]);
            end
            tps=tps + tpsmax;
        end
        
end
end




