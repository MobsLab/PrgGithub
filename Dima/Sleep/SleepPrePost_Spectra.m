Mice_to_analyze = [712 753 797 798];
average = 1;   % Show one mouse (0) ot the average (1)

% Get directories
Dir_Pre = PathForExperimentsERC_Dima('PreSleep');
Dir_Pre = RestrictPathForExperiment(Dir_Pre,'nMice', Mice_to_analyze);
Dir_Post = PathForExperimentsERC_Dima('PostSleep');
Dir_Post = RestrictPathForExperiment(Dir_Post,'nMice', Mice_to_analyze);

[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high


%% PreSleep
for i=1:length(Dir_Pre.path)
    load([Dir_Pre.path{i}{1} 'ChannelsToAnalyse/dHPC_deep.mat']);
    
if exist ([Dir_Pre.path{i}{1} 'SpectrumDataL/Spectrum' num2str(channel) '.mat'], 'file') == 2
    Sp_pre{i} = load([Dir_Pre.path{i}{1} 'SpectrumDataL/Spectrum' num2str(channel) '.mat'], 'Sp', 't', 'f', 'Sptsd');
    disp(['SpectrumDataL/Spectrum' num2str(channel),' in PreSleep  ... loaded']);    
else
    load([Dir_Pre.path{i}{1} 'LFPData/LFP' num2str(channel) '.mat']);
    [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
    Sptsd=tsd(t*1E4,Sp);
    if exist([Dir_Pre.path{i}{1} 'SpectrumDataL/'], 'dir') == 7
        save([Dir_Pre.path{i}{1} 'SpectrumDataL/Spectrum' num2str(channel) '.mat'], 'Sp', 't', 'f', 'Sptsd', 'params', 'movingwin', 'suffix');
    else
        mkdir([Dir_Pre.path{i}{1} 'SpectrumDataL/']);
        save([Dir_Pre.path{i}{1} 'SpectrumDataL/Spectrum' num2str(channel) '.mat'], 'Sp', 't', 'f', 'Sptsd', 'params', 'movingwin', 'suffix');
    end
    disp(['SpectrumDataL/Spectrum' num2str(channel),' in PreSleep  ... calculated']);
    Sp_pre{i}.Sp=Sp; Sp_pre{i}.t=t; Sp_pre{i}.f=f; Sp_pre{i}.Sptsd=Sptsd;
    clear Sp t f Sptsd
end

    load([Dir_Pre.path{i}{1} 'SleepScoring_OBGamma.mat'], 'Sleep', 'Wake', 'SWSEpoch', 'REMEpoch');
    Sp_pre{i}.Sleep=Sleep; Sp_pre{i}.Wake=Wake; Sp_pre{i}.SWSEpoch=SWSEpoch; Sp_pre{i}.REMEpoch=REMEpoch;
    clear Sleep Wake SWSEpoch REMEpoch

    AvSpREM_pre(i,1:length(Sp_pre{i}.f)) = mean(Data(Restrict(Sp_pre{i}.Sptsd, Sp_pre{i}.REMEpoch)),1);
    AvSpSWS_pre(i,1:length(Sp_pre{i}.f)) = mean(Data(Restrict(Sp_pre{i}.Sptsd, Sp_pre{i}.SWSEpoch)),1);
end





%% PostSleep

for i=1:length(Dir_Post.path)
    load([Dir_Post.path{i}{1} 'ChannelsToAnalyse/dHPC_deep.mat']);
    
if exist ([Dir_Post.path{i}{1} 'SpectrumDataL/Spectrum' num2str(channel) '.mat'], 'file') == 2
    Sp_Post{i} = load([Dir_Post.path{i}{1} 'SpectrumDataL/Spectrum' num2str(channel) '.mat'], 'Sp', 't', 'f', 'Sptsd');
    disp(['SpectrumDataL/Spectrum' num2str(channel),' in PostSleep  ... loaded']);    
else
    load([Dir_Post.path{i}{1} 'LFPData/LFP' num2str(channel) '.mat']);
    [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
    Sptsd=tsd(t*1E4,Sp);
    if exist([Dir_Post.path{i}{1} 'SpectrumDataL/'], 'dir') == 7
        save([Dir_Post.path{i}{1} 'SpectrumDataL/Spectrum' num2str(channel) '.mat'], 'Sp', 't', 'f', 'Sptsd', 'params', 'movingwin', 'suffix');
    else
        mkdir([Dir_Post.path{i}{1} 'SpectrumDataL/']);
        save([Dir_Post.path{i}{1} 'SpectrumDataL/Spectrum' num2str(channel) '.mat'], 'Sp', 't', 'f', 'Sptsd', 'params', 'movingwin', 'suffix');
    end
    disp(['SpectrumDataL/Spectrum' num2str(channel),' in PostSleep  ... calculated']);
    Sp_Post{i}.Sp=Sp; Sp_Post{i}.t=t; Sp_Post{i}.f=f; Sp_Post{i}.Sptsd=Sptsd;
    clear Sp t f Sptsd Sleep Wake SWSEpoch REMEpoch
end
    
    load([Dir_Post.path{i}{1} 'SleepScoring_OBGamma.mat'], 'Sleep', 'Wake', 'SWSEpoch', 'REMEpoch');
    Sp_Post{i}.Sleep=Sleep; Sp_Post{i}.Wake=Wake; Sp_Post{i}.SWSEpoch=SWSEpoch; Sp_Post{i}.REMEpoch=REMEpoch;
    clear Sleep Wake SWSEpoch REMEpoch
    
    AvSpREM_post(i,1:length(Sp_Post{i}.f)) = mean(Data(Restrict(Sp_Post{i}.Sptsd, Sp_Post{i}.REMEpoch)),1);
    AvSpSWS_post(i,1:length(Sp_Post{i}.f)) = mean(Data(Restrict(Sp_Post{i}.Sptsd, Sp_Post{i}.SWSEpoch)),1);
end


%% Figure

figure('units', 'normalized', 'outerposition', [0 1 0.5 0.8])
shadedErrorBar(Sp_pre{1}.f,mean(AvSpSWS_pre, 1),stdError(AvSpSWS_pre),{'b' 'LineWidth',3}, 1)
hold on
shadedErrorBar(Sp_Post{1}.f,mean(AvSpSWS_post, 1),stdError(AvSpSWS_post),{'r' 'LineWidth',3},1)
set(gca, 'FontSize', 14, 'FontWeight',  'bold')
ylabel('Power (a.u.)')
xlabel('Frequency')


figure('units', 'normalized', 'outerposition', [0 1 0.5 0.8])
shadedErrorBar(Sp_pre{1}.f,mean(AvSpREM_pre, 1),stdError(AvSpREM_pre),{'b' 'LineWidth',3}, 1)
hold on
shadedErrorBar(Sp_Post{1}.f,mean(AvSpREM_post, 1),stdError(AvSpREM_post),{'r' 'LineWidth',3},1)
set(gca, 'FontSize', 14, 'FontWeight',  'bold')
ylabel('Power (a.u.)')
xlabel('Frequency')