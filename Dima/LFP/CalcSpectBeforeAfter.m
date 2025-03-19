%% Parameters
Mice_to_analyze = 742;

% Get directories
Dir_Pre = PathForExperimentsERC_Dima('TestPrePooled');
Dir_Pre = RestrictPathForExperiment(Dir_Pre,'nMice', Mice_to_analyze);
Dir_Post = PathForExperimentsERC_Dima('TestPostPooled');
Dir_Post = RestrictPathForExperiment(Dir_Post,'nMice', Mice_to_analyze);

[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high

%% Load Data
% Zone Epoch
a = load([Dir_Pre.path{1}{1} 'behavResources.mat'],'ZoneEpoch', 'FreezeAccEpoch', 'ImmobEpoch');
ZoneEpoch_pre = a.ZoneEpoch; FreezeAccEpoch_pre = a.FreezeAccEpoch; ImmobEpoch_pre  = a.ImmobEpoch;
b = load([Dir_Post.path{1}{1} 'behavResources.mat'],'ZoneEpoch', 'FreezeAccEpoch', 'ImmobEpoch');
ZoneEpoch_post = b.ZoneEpoch; FreezeAccEpoch_post = b.FreezeAccEpoch; ImmobEpoch_post = b.ImmobEpoch;
clear a b

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
% Pre HPC
if exist ([Dir_Pre.path{1}{1} 'SpectrumDataL/Spectrum' num2str(channel_hpc) '.mat'], 'file') == 2
    Spec_hpc_pre = load([Dir_Pre.path{1}{1} 'SpectrumDataL/Spectrum' num2str(channel_hpc) '.mat'], 'Sp', 't', 'f');
    disp(['SpectrumDataL/Spectrum' num2str(channel_hpc),' in TestPRE  ... loaded']);
    Sp_hpc_pre=Spec_hpc_pre.Sp; t_hpc_pre=Spec_hpc_pre.t; f_hpc_pre=Spec_hpc_pre.f; Sptsd_hpc_pre=tsd(t_hpc_pre*1E4,Sp_hpc_pre);
    clear Spec_hpc_pre
else
    LFP_hpc_pre = load([Dir_Pre.path{1}{1} 'LFPData/LFP' num2str(channel_hpc) '.mat']);
    [Sp,t,f]=mtspecgramc(Data(LFP_hpc_pre.LFP),movingwin,params);
    if exist([Dir_Pre.path{1}{1} 'SpectrumDataL/'], 'dir') == 7
        save([Dir_Pre.path{1}{1} 'SpectrumDataL/Spectrum' num2str(channel_hpc) '.mat'], 'Sp', 't', 'f', 'params', 'movingwin', 'suffix');
    else
        mkdir([Dir_Pre.path{1}{1} 'SpectrumDataL/']);
        save([Dir_Pre.path{1}{1} 'SpectrumDataL/Spectrum' num2str(channel_hpc) '.mat'], 'Sp', 't', 'f', 'params', 'movingwin', 'suffix');
    end
    disp(['SpectrumDataL/Spectrum' num2str(channel_hpc),' in TestPRE  ... calculated']);
    Sp_hpc_pre=Sp; t_hpc_pre=t; f_hpc_pre=f; Sptsd_hpc_pre=tsd(t_hpc_pre*1E4,Sp_hpc_pre);
    clear Sp t f
end

%Pre OB
if exist ([Dir_Pre.path{1}{1} 'SpectrumDataL/Spectrum' num2str(channel_ob) '.mat'], 'file') == 2
    Spec_ob_pre = load([Dir_Pre.path{1}{1} 'SpectrumDataL/Spectrum' num2str(channel_ob) '.mat'], 'Sp', 't', 'f');
    disp(['SpectrumDataL/Spectrum' num2str(channel_ob),' in TestPRE  ... loaded']);
    Sp_ob_pre=Spec_ob_pre.Sp; t_ob_pre=Spec_ob_pre.t; f_ob_pre=Spec_ob_pre.f; Sptsd_ob_pre=tsd(t_ob_pre*1E4,Sp_ob_pre);
    clear Spec_ob_pre
else
    LFP_ob_pre = load([Dir_Pre.path{1}{1} 'LFPData/LFP' num2str(channel_ob) '.mat']);
    [Sp,t,f]=mtspecgramc(Data(LFP_ob_pre.LFP),movingwin,params);
    if exist([Dir_Pre.path{1}{1} 'SpectrumDataL/'], 'dir') == 7
        save([Dir_Pre.path{1}{1} 'SpectrumDataL/Spectrum' num2str(channel_ob) '.mat'], 'Sp', 't', 'f', 'params', 'movingwin', 'suffix');
    else
        mkdir([Dir_Pre.path{1}{1} 'SpectrumDataL/']);
        save([Dir_Pre.path{1}{1} 'SpectrumDataL/Spectrum' num2str(channel_ob) '.mat'], 'Sp', 't', 'f', 'params', 'movingwin', 'suffix');
    end
    disp(['SpectrumDataL/Spectrum' num2str(channel_ob),' in TestPRE  ... calculated']);
    Sp_ob_pre=Sp; t_ob_pre=t; f_ob_pre=f; Sptsd_ob_pre=tsd(t_ob_pre*1E4,Sp_ob_pre);
    clear Sp t f
end


% Post HPC
if exist ([Dir_Post.path{1}{1} 'SpectrumDataL/Spectrum' num2str(channel_hpc) '.mat'], 'file') == 2
    Spec_hpc_post = load([Dir_Post.path{1}{1} 'SpectrumDataL/Spectrum' num2str(channel_hpc) '.mat'], 'Sp', 't', 'f');
    disp(['SpectrumDataL/Spectrum' num2str(channel_hpc),' in TestPOST  ... loaded']);
    Sp_hpc_post=Spec_hpc_post.Sp; t_hpc_post=Spec_hpc_post.t; f_hpc_post=Spec_hpc_post.f; Sptsd_hpc_post=tsd(t_hpc_post*1E4,Sp_hpc_post);
    clear Spec_hpc_post
else
    LFP_hpc_post = load([Dir_Post.path{1}{1} 'LFPData/LFP' num2str(channel_hpc) '.mat']);
    [Sp,t,f]=mtspecgramc(Data(LFP_hpc_post.LFP),movingwin,params);
    if exist([Dir_Post.path{1}{1} 'SpectrumDataL/'], 'dir') == 7
        save([Dir_Post.path{1}{1} 'SpectrumDataL/Spectrum' num2str(channel_hpc) '.mat'], 'Sp', 't', 'f', 'params', 'movingwin', 'suffix');
    else
        mkdir([Dir_Post.path{1}{1} 'SpectrumDataL/']);
        save([Dir_Post.path{1}{1} 'SpectrumDataL/Spectrum' num2str(channel_hpc) '.mat'], 'Sp', 't', 'f', 'params', 'movingwin', 'suffix');
    end
    disp(['SpectrumDataL/Spectrum' num2str(channel_hpc),' in TestPOST  ... calculated']);
    Sp_hpc_post=Sp; t_hpc_post=t; f_hpc_post=f; Sptsd_hpc_post=tsd(t_hpc_post*1E4,Sp_hpc_post);
    clear Sp t f
end

% Post OB
if exist ([Dir_Post.path{1}{1} 'SpectrumDataL/Spectrum' num2str(channel_ob) '.mat'], 'file') == 2
    Spec_ob_post = load([Dir_Post.path{1}{1} 'SpectrumDataL/Spectrum' num2str(channel_ob) '.mat'], 'Sp', 't', 'f');
    disp(['SpectrumDataL/Spectrum' num2str(channel_ob),' in TestPOST  ... loaded']);
    Sp_ob_post=Spec_ob_post.Sp; t_ob_post=Spec_ob_post.t; f_ob_post=Spec_ob_post.f; Sptsd_ob_post=tsd(t_ob_post*1E4,Sp_ob_post);
    clear Spec_ob_post
else
    LFP_ob_post = load([Dir_Post.path{1}{1} 'LFPData/LFP' num2str(channel_ob) '.mat']);
    [Sp,t,f]=mtspecgramc(Data(LFP_ob_post.LFP),movingwin,params);
    if exist([Dir_Post.path{1}{1} 'SpectrumDataL/'], 'dir') == 7
        save([Dir_Post.path{1}{1} 'SpectrumDataL/Spectrum' num2str(channel_ob) '.mat'], 'Sp', 't', 'f', 'params', 'movingwin', 'suffix');
    else
        mkdir([Dir_Post.path{1}{1} 'SpectrumDataL/']);
        save([Dir_Post.path{1}{1} 'SpectrumDataL/Spectrum' num2str(channel_ob) '.mat'], 'Sp', 't', 'f', 'params', 'movingwin', 'suffix');
    end
    disp(['SpectrumDataL/Spectrum' num2str(channel_ob),' in TestPOST  ... calculated']);
    Sp_ob_post=Sp; t_ob_post=t; f_ob_post=f; Sptsd_ob_post=tsd(t_ob_post*1E4,Sp_ob_post);
    clear Sp t f
end

%% Figure
% figure for hpc
fig_hpc = figure('units', 'normalized', 'outerposition', [0 1 1 1]);

subplot(521)
imagesc(t_hpc_pre,f_hpc_pre,10*log10(Sp_hpc_pre'))
axis xy
colormap jet
title('Pre')

subplot(522)
imagesc(t_hpc_post,f_hpc_post,10*log10(Sp_hpc_post'))
axis xy
colormap jet
title('Post')

subplot(523)
imagesc(Range(Restrict(Sptsd_hpc_pre, ZoneEpoch_pre{1}),'s'),f_hpc_pre,10*log10(Data(Restrict(Sptsd_hpc_pre,ZoneEpoch_pre{1})))');
axis xy
colormap jet
title('Shock in Pre')

subplot(525)
imagesc(Range(Restrict(Sptsd_hpc_pre, ZoneEpoch_pre{2}),'s'),f_hpc_pre,10*log10(Data(Restrict(Sptsd_hpc_pre,ZoneEpoch_pre{2})))');
axis xy
colormap jet
title('Safe in Pre')

subplot(524)
imagesc(Range(Restrict(Sptsd_hpc_post, ZoneEpoch_post{1}),'s'),f_hpc_pre,10*log10(Data(Restrict(Sptsd_hpc_post,ZoneEpoch_post{1})))');
axis xy
colormap jet
title('Shock in Post')

subplot(526)
imagesc(Range(Restrict(Sptsd_hpc_post, ZoneEpoch_post{2}),'s'),f_hpc_pre,10*log10(Data(Restrict(Sptsd_hpc_post,ZoneEpoch_post{2})))');
axis xy
colormap jet
title('Safe in Post')

subplot(527)
imagesc(Range(Restrict(Sptsd_hpc_pre, FreezeAccEpoch_pre),'s'),f_hpc_pre,10*log10(Data(Restrict(Sptsd_hpc_pre,FreezeAccEpoch_pre)))');
axis xy
colormap jet
title('Freezing in Pre')

subplot(529)
imagesc(Range(Restrict(Sptsd_hpc_pre, ImmobEpoch_pre),'s'),f_hpc_pre,10*log10(Data(Restrict(Sptsd_hpc_pre,ImmobEpoch_pre)))');
axis xy
colormap jet
title('Immobility in Pre')

subplot(528)
imagesc(Range(Restrict(Sptsd_hpc_post, FreezeAccEpoch_post),'s'),f_hpc_pre,10*log10(Data(Restrict(Sptsd_hpc_post,FreezeAccEpoch_post)))');
axis xy
colormap jet
title('Freezing in Post')

subplot(5,2,10)
imagesc(Range(Restrict(Sptsd_hpc_post, ImmobEpoch_post),'s'),f_hpc_pre,10*log10(Data(Restrict(Sptsd_hpc_post,ImmobEpoch_post)))');
axis xy
colormap jet
title('Immobility in Post')

mtit(fig_hpc, 'Hippocampus');

% figure for ob
fig_ob = figure('units', 'normalized', 'outerposition', [0 1 1 1]);

subplot(521)
imagesc(t_ob_pre,f_ob_pre,10*log10(Sp_ob_pre'))
axis xy
colormap jet
title('Pre')

subplot(522)
imagesc(t_ob_post,f_ob_post,10*log10(Sp_ob_post'))
axis xy
colormap jet
title('Post')

subplot(523)
imagesc(Range(Restrict(Sptsd_ob_pre, ZoneEpoch_pre{1}),'s'),f_ob_pre,10*log10(Data(Restrict(Sptsd_ob_pre,ZoneEpoch_pre{1})))');
axis xy
colormap jet
title('Shock in Pre')

subplot(525)
imagesc(Range(Restrict(Sptsd_ob_pre, ZoneEpoch_pre{2}),'s'),f_ob_pre,10*log10(Data(Restrict(Sptsd_ob_pre,ZoneEpoch_pre{2})))');
axis xy
colormap jet
title('Safe in Pre')

subplot(524)
imagesc(Range(Restrict(Sptsd_ob_post, ZoneEpoch_post{1}),'s'),f_ob_pre,10*log10(Data(Restrict(Sptsd_ob_post,ZoneEpoch_post{1})))');
axis xy
colormap jet
title('Shock in Post')

subplot(526)
imagesc(Range(Restrict(Sptsd_ob_post, ZoneEpoch_post{2}),'s'),f_ob_pre,10*log10(Data(Restrict(Sptsd_ob_post,ZoneEpoch_post{2})))');
axis xy
colormap jet
title('Safe in Post')

subplot(527)
imagesc(Range(Restrict(Sptsd_ob_pre, FreezeAccEpoch_pre),'s'),f_ob_pre,10*log10(Data(Restrict(Sptsd_ob_pre,FreezeAccEpoch_pre)))');
axis xy
colormap jet
title('Freezing in Pre')

subplot(529)
imagesc(Range(Restrict(Sptsd_ob_pre, ImmobEpoch_pre),'s'),f_ob_pre,10*log10(Data(Restrict(Sptsd_ob_pre,ImmobEpoch_pre)))');
axis xy
colormap jet
title('Immobility in Pre')

subplot(528)
imagesc(Range(Restrict(Sptsd_ob_post, FreezeAccEpoch_post),'s'),f_ob_pre,10*log10(Data(Restrict(Sptsd_ob_post,FreezeAccEpoch_post)))');
axis xy
colormap jet
title('Freezing in Post')

subplot(5,2,10)
imagesc(Range(Restrict(Sptsd_ob_post, ImmobEpoch_post),'s'),f_ob_pre,10*log10(Data(Restrict(Sptsd_ob_post,ImmobEpoch_post)))');
axis xy
colormap jet
title('Immobility in Post')

mtit(fig_ob, 'Olfactory Bulb');

%% Clear
clear