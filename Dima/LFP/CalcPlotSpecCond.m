%%% th headers


%% Parameters
Mice_to_analyze = 712;

% Get directories
Dir_Pre = PathForExperimentsERC_Dima('TestPrePooled');
Dir_Pre = RestrictPathForExperiment(Dir_Pre,'nMice', Mice_to_analyze);
Dir_Cond = PathForExperimentsERC_Dima('Cond');
Dir_Cond = RestrictPathForExperiment(Dir_Cond,'nMice', Mice_to_analyze);

[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high

%% Load Data
% Zone Epoch
for i = 1:length(Dir_Cond.path{1})
    a{i} = load([Dir_Cond.path{1}{i} 'behavResources.mat'],'ZoneEpoch', 'FreezeAccEpoch', 'ImmobEpoch', 'TTLInfo', 'Ytsd');
    ZoneEpoch{i} = a{i}.ZoneEpoch; FreezeAccEpoch{i} = a{i}.FreezeAccEpoch; ImmobEpoch{i}  = a{i}.ImmobEpoch; TTLInfo{i} = a{i}.TTLInfo;
    Ytsd{i}=a{i}.Ytsd;
end
clear a

%% Concatenate behavioral variables
% Calculate duration, find the first timestamp ('offset') and number of indices for each test
% find also last timestaps for each session ('lasttime')
for i = 1:length(Dir_Cond.path{1})
    TimeTemp{i} = Range(Ytsd{i});
    duration(i) = TimeTemp{i}(end) - TimeTemp{i}(1);
    offset(i) = TimeTemp{i}(1);
    lind(i) = length(TimeTemp{i});
    lasttime(i) = TimeTemp{i}(end);
end

for i=1:length(Dir_Cond.path{1})
    LFPduration(i) = TTLInfo{i}.StopSession-TTLInfo{i}.StartSession;
    LFPoffset(i) = TTLInfo{i}.StartSession;
end

% Concatenate TTLInfo
for i = 1:length(Dir_Cond.path{1})
    StartStimTemp{i} = Start(TTLInfo{i}.StimEpoch);
    EndStimTemp{i} = End(TTLInfo{i}.StimEpoch);
end

for i = 1:(length(Dir_Cond.path{1})-1)
    StartStimTemp{i+1} = StartStimTemp{i+1} + sum(LFPduration(1:i)) + LFPoffset(i+1);
    EndStimTemp{i+1} = EndStimTemp{i+1} + sum(LFPduration(1:i)) + LFPoffset(i+1);
end
StartStim = StartStimTemp{1};
EndStim = EndStimTemp{1};
for i = 2:length(Dir_Cond.path{1})
    StartStim = [StartStim; StartStimTemp{i}];
    EndStim = [EndStim; EndStimTemp{i}];
end
StimEpoch = intervalSet(StartStim, EndStim);

% Concatenate ZoneEpoch (type tsa * 7 - number of Zones)
for i = 1:length(Dir_Cond.path{1})
    for k = 1:7
        ZoneEpochTempStart{i}{k} = Start(ZoneEpoch{i}{k});
        ZoneEpochTempEnd{i}{k} = End(ZoneEpoch{i}{k});
    end
end

for i = 1:length(Dir_Cond.path{1})-1
    for k=1:7
        ZoneEpochTempStart{i+1}{k} = ZoneEpochTempStart{i+1}{k} + sum(duration(1:i)) + offset(i+1);
        ZoneEpochTempEnd{i+1}{k} = ZoneEpochTempEnd{i+1}{k} + sum(duration(1:i)) + offset(i+1);
    end
end
for k=1:7
    ZoneEpochStart{k} = [ZoneEpochTempStart{1}{k}; ZoneEpochTempStart{2}{k}; ZoneEpochTempStart{3}{k}; ZoneEpochTempStart{4}{k}];
    ZoneEpochEnd{k} = [ZoneEpochTempEnd{1}{k}; ZoneEpochTempEnd{2}{k}; ZoneEpochTempEnd{3}{k}; ZoneEpochTempEnd{4}{k}];
end
for k=1:7
    ZoneEpoch{k} = intervalSet(ZoneEpochStart{k}, ZoneEpochEnd{k});
end

% Concatenate FreezeAccEpoch
for i = 1:length(Dir_Cond.path{1})
    StartFreezeTemp{i} = Start(FreezeAccEpoch{i});
    EndFreezeTemp{i} = End(FreezeAccEpoch{i});
end

for i = 1:(length(Dir_Cond.path{1})-1)
    StartFreezeTemp{i+1} = StartFreezeTemp{i+1} + sum(LFPduration(1:i)) + LFPoffset(i+1);
    EndFreezeTemp{i+1} = EndFreezeTemp{i+1} + sum(LFPduration(1:i)) + LFPoffset(i+1);
end
StartFreeze = StartFreezeTemp{1};
EndFreeze = EndFreezeTemp{1};
for i = 2:length(Dir_Cond.path)
    StartFreeze = [StartFreeze; StartFreezeTemp{i}];
    EndFreeze = [EndFreeze; EndFreezeTemp{i}];
end
FreezeAccEpoch = intervalSet(StartFreeze, EndFreeze);


% Concatenate ImmobEpoch
for i = 1:length(Dir_Cond.path{1})
    StartImmobTemp{i} = Start(ImmobEpoch{i});
    EndImmobTemp{i} = End(ImmobEpoch{i});
end

for i = 1:(length(Dir_Cond.path{1})-1)
    StartImmobTemp{i+1} = StartImmobTemp{i+1} + sum(LFPduration(1:i)) + LFPoffset(i+1);
    EndImmobTemp{i+1} = EndImmobTemp{i+1} + sum(LFPduration(1:i)) + LFPoffset(i+1);
end
StartImmob = StartImmobTemp{1};
EndImmob = EndImmobTemp{1};
for i = 2:length(Dir_Cond.path{1})
    StartImmob = [StartImmob; StartImmobTemp{i}];
    EndImmob = [EndImmob; EndImmobTemp{i}];
end
ImmobEpoch = intervalSet(StartImmob, EndImmob);

%% Load Spectrum
% HPC channel
if exist([Dir_Pre.path{1}{1} 'ChannelsToAnalyse/dHPC_rip.mat'],'file')==2
    ch=load([Dir_Pre.path{1}{1} 'ChannelsToAnalyse/dHPC_rip.mat']);
    channel_hpc=ch.channel;
elseif exist([Dir_Pre.path{1}{1} 'ChannelsToAnalyse/dHPC_deep.mat'],'file')==2
    ch=load([Dir_Pre.path{1}{1} 'ChannelsToAnalyse/dHPC_deep.mat']);
    channel_hpc=ch.channel;
else
    error('No HPC channel, cannot proceed');
end
clear ch

% OB channel
if exist([Dir_Pre.path{1}{1} 'ChannelsToAnalyse/Bulb_deep.mat'],'file')==2
    ch=load([Dir_Pre.path{1}{1} 'ChannelsToAnalyse/Bulb_deep.mat']);
    channel_ob=ch.channel;
elseif exist([Dir_Pre.path{1}{1} 'ChannelsToAnalyse/Bulb_sup.mat'],'file')==2
    ch=load([Dir_Pre.path{1}{1} 'ChannelsToAnalyse/Bulb_sup.mat']);
    channel_ob=ch.channel;
else
    error('No OB channel, cannot proceed');
end
clear ch

% Load Spectrum or make the spectrum
% HPC
if exist ([Dir_Cond.path{1}{1}(1:end-6) 'SpectrumDataL/Spectrum' num2str(channel_hpc) '.mat'], 'file') == 2
    Spec_hpc = load([Dir_Cond.path{1}{1}(1:end-6) 'SpectrumDataL/Spectrum' num2str(channel_hpc) '.mat'], 'Sp', 't', 'f');
    disp(['SpectrumDataL/Spectrum' num2str(channel_hpc),' in Cond  ... loaded']);
    Sp_hpc=Spec_hpc.Sp; t_hpc=Spec_hpc.t; f_hpc=Spec_hpc.f; Sptsd_hpc=tsd(t_hpc*1E4,Sp_hpc);
    clear Spec_hpc
else
    LFP_hpc = ConcatenateDataFromFolders_SB(Dir_Cond.path{1}, 'lfp', 'channumber', channel_hpc);
    [Sp,t,f]=mtspecgramc(Data(LFP_hpc),movingwin,params);
    if exist([Dir_Cond.path{1}{1}(1:end-6) 'SpectrumDataL/'], 'dir') == 7
        save([Dir_Cond.path{1}{1}(1:end-6) 'SpectrumDataL/Spectrum' num2str(channel_hpc) '.mat'], 'Sp', 't', 'f', 'params', 'movingwin', 'suffix');
    else
        mkdir([Dir_Cond.path{1}{1}(1:end-6) 'SpectrumDataL/']);
        save([Dir_Cond.path{1}{1}(1:end-6) 'SpectrumDataL/Spectrum' num2str(channel_hpc) '.mat'], 'Sp', 't', 'f', 'params', 'movingwin', 'suffix');
    end
    disp(['SpectrumDataL/Spectrum' num2str(channel_hpc),' in Cond  ... calculated']);
    Sp_hpc=Sp; t_hpc=t; f_hpc=f; Sptsd_hpc=tsd(t_hpc*1E4,Sp_hpc);
    clear Sp t f
end

% OB
if exist ([Dir_Cond.path{1}{1}(1:end-6) 'SpectrumDataL/Spectrum' num2str(channel_ob) '.mat'], 'file') == 2
    Spec_ob = load([Dir_Cond.path{1}{1}(1:end-6) 'SpectrumDataL/Spectrum' num2str(channel_ob) '.mat'], 'Sp', 't', 'f');
    disp(['SpectrumDataL/Spectrum' num2str(channel_ob),' in Cond  ... loaded']);
    Sp_ob=Spec_ob.Sp; t_ob=Spec_ob.t; f_ob=Spec_ob.f; Sptsd_ob=tsd(t_ob*1E4,Sp_ob);
    clear Spec_ob
else
    LFP_ob = ConcatenateDataFromFolders_SB(Dir_Cond.path{1}, 'lfp', 'channumber', channel_ob);
    [Sp,t,f]=mtspecgramc(Data(LFP_ob),movingwin,params);
    if exist([Dir_Cond.path{1}{1}(1:end-6) 'SpectrumDataL/'], 'dir') == 7
        save([Dir_Cond.path{1}{1}(1:end-6) 'SpectrumDataL/Spectrum' num2str(channel_ob) '.mat'], 'Sp', 't', 'f', 'params', 'movingwin', 'suffix');
    else
        mkdir([Dir_Cond.path{1}{1}(1:end-6) 'SpectrumDataL/']);
        save([Dir_Cond.path{1}{1}(1:end-6) 'SpectrumDataL/Spectrum' num2str(channel_ob) '.mat'], 'Sp', 't', 'f', 'params', 'movingwin', 'suffix');
    end
    disp(['SpectrumDataL/Spectrum' num2str(channel_ob),' in Cond  ... calculated']);
    Sp_ob=Sp; t_ob=t; f_ob=f; Sptsd_ob=tsd(t_ob*1E4,Sp_ob);
    clear Sp t f
end


%% Figure
% figure for hpc
fig_hpc = figure('units', 'normalized', 'outerposition', [0 1 1 1]);

subplot(321)
imagesc(t_hpc,f_hpc,10*log10(Sp_hpc'))
axis xy
colormap jet
title('AllConditioning')

subplot(323)
imagesc(Range(Restrict(Sptsd_hpc, ZoneEpoch{1}),'s'),f_hpc,10*log10(Data(Restrict(Sptsd_hpc,ZoneEpoch{1})))');
axis xy
colormap jet
title('Shock')

subplot(324)
imagesc(Range(Restrict(Sptsd_hpc, ZoneEpoch{2}),'s'),f_hpc,10*log10(Data(Restrict(Sptsd_hpc,ZoneEpoch{2})))');
axis xy
colormap jet
title('Safe')

subplot(325)
imagesc(Range(Restrict(Sptsd_hpc, FreezeAccEpoch),'s'),f_hpc,10*log10(Data(Restrict(Sptsd_hpc,FreezeAccEpoch)))');
axis xy
colormap jet
title('Freezing')

subplot(326)
imagesc(Range(Restrict(Sptsd_hpc, ImmobEpoch),'s'),f_hpc,10*log10(Data(Restrict(Sptsd_hpc,ImmobEpoch)))');
axis xy
colormap jet
title('Immobility')

mtit(fig_hpc, 'Hippocampus');

% figure for ob
fig_ob = figure('units', 'normalized', 'outerposition', [0 1 1 1]);

subplot(321)
imagesc(t_ob,f_ob,10*log10(Sp_ob'))
axis xy
colormap jet
title('Pre')

subplot(323)
imagesc(Range(Restrict(Sptsd_ob, ZoneEpoch{1}),'s'),f_ob,10*log10(Data(Restrict(Sptsd_ob,ZoneEpoch{1})))');
axis xy
colormap jet
title('Shock')

subplot(324)
imagesc(Range(Restrict(Sptsd_ob, ZoneEpoch{2}),'s'),f_ob,10*log10(Data(Restrict(Sptsd_ob,ZoneEpoch{2})))');
axis xy
colormap jet
title('Safe')

subplot(325)
imagesc(Range(Restrict(Sptsd_ob, FreezeAccEpoch),'s'),f_ob,10*log10(Data(Restrict(Sptsd_ob,FreezeAccEpoch)))');
axis xy
colormap jet
title('Freezing')

subplot(326)
imagesc(Range(Restrict(Sptsd_ob, ImmobEpoch),'s'),f_ob,10*log10(Data(Restrict(Sptsd_ob,ImmobEpoch)))');
axis xy
colormap jet
title('Immobility')

mtit(fig_ob, 'Olfactory Bulb');

%% Clear
clear