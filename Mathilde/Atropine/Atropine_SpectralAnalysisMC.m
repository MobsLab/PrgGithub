%% input dir
DirAtropine = PathForExperimentsAtropine_MC('Atropine');
DirBaseline = PathForExperimentsAtropine_MC('Baseline');
% DirAtropineTG = PathForExperiments_TG('atropine_Atropine');
% DirBaselineTG = PathForExperiments_TG('atropine_Baseline');

% DirAtropine = MergePathForExperiment(DirAtropineMC, DirAtropineTG);
% DirBaseline = MergePathForExperiment(DirBaselineMC, DirBaselineTG);


%% get the data
for i=1:length(DirBaseline.path)
    cd(DirBaseline.path{i}{1});
    a{i} = load('SleepScoring_OBGamma.mat', 'Wake', 'REMEpoch', 'SWSEpoch','ThetaEpoch');
    REMEp_Baseline{i} = a{i}.REMEpoch;
    SWSEp_Baseline{i} = a{i}.SWSEpoch;
    WakeEp_Baseline{i} = a{i}.Wake;
    ThetaEpoch_Baseline{i} = a{i}.ThetaEpoch;
    durtotal_Baseline = max([max(End(a{i}.Wake)),max(End(a{i}.SWSEpoch))]);
    Epoch1_Baseline{i} = intervalSet(0,durtotal_Baseline/2);
    Epoch2_Baseline{i} = intervalSet(durtotal_Baseline/2,durtotal_Baseline);
    
%         load('PFCx_deep_Low_Spectrum.mat');
            load('Bulb_deep_Low_Spectrum.mat');
%     load('dHPC_deep_Low_Spectrum.mat');
    spectre_Baseline = tsd(Spectro{2}*1E4,Spectro{1});
    frequence_Baseline = Spectro{3};
    Spectro_Baseline{i}  = spectre_Baseline;
    frq_Baseline{i}  = frequence_Baseline;
    
    clear Wake REMEpoch SWSEpoch Spectro
end

for j=1:length(DirAtropine.path)
    cd(DirAtropine.path{j}{1});
    b{j} = load('SleepScoring_OBGamma.mat', 'Wake', 'REMEpoch', 'SWSEpoch', 'ThetaEpoch');
        REMEp_Atropine{j} = b{j}.REMEpoch;
    SWSEp_Atropine{j} = b{j}.SWSEpoch;
    WakeEp_Atropine{j} = b{j}.Wake;
    ThetaEpoch_Atropine{j} = b{j}.ThetaEpoch;
    durtotal_Atropine = max([max(End(b{j}.Wake)),max(End(b{j}.SWSEpoch))]);
    Epoch1_Atropine{j} = intervalSet(0,durtotal_Atropine/2);
    Epoch2_Atropine{j} = intervalSet(durtotal_Atropine/2,durtotal_Atropine);
%         load('PFCx_deep_Low_Spectrum.mat');
            load('Bulb_deep_Low_Spectrum.mat');
%     load('dHPC_deep_Low_Spectrum.mat');
    spectre_Atropine = tsd(Spectro{2}*1E4,Spectro{1});
    frequence_Atropine = Spectro{3};
    Spectro_Atropine{j} = spectre_Atropine;
    frq_Atropine{j} = frequence_Atropine;

    clear Wake REMEpoch SWSEpoch Spectro
end


%% calculate mean spectrum for each mouse
for i=1:length(DirBaseline.path)
    SpectreBaseline_mean(i,:)=mean(10*(Data(Spectro_Baseline{i})),1);
    SpectreBaseline_BeforeInj_mean(i,:)=mean(10*(Data(Restrict(Spectro_Baseline{i},Epoch1_Baseline{i}))),1);
    SpectreBaseline_AfterInj_mean(i,:)=mean(10*(Data(Restrict(Spectro_Baseline{i},Epoch2_Baseline{i}))),1);
    SpectreBaseline_Wake_BeforeInj_mean(i,:)=mean(10*(Data(Restrict(Spectro_Baseline{i},and(Epoch1_Baseline{i},WakeEp_Baseline{i})))),1);
    SpectreBaseline_Wake_AfterInj_mean(i,:)=mean(10*(Data(Restrict(Spectro_Baseline{i},and(Epoch2_Baseline{i},WakeEp_Baseline{i})))),1);
    SpectreBaseline_SWS_BeforeInj_mean(i,:)=mean(10*(Data(Restrict(Spectro_Baseline{i},and(Epoch1_Baseline{i},SWSEp_Baseline{i})))),1);
    SpectreBaseline_SWS_AfterInj_mean(i,:)=mean(10*(Data(Restrict(Spectro_Baseline{i},and(Epoch2_Baseline{i},SWSEp_Baseline{i})))),1);
    SpectreBaseline_REM_BeforeInj_mean(i,:)=mean(10*(Data(Restrict(Spectro_Baseline{i},and(Epoch1_Baseline{i},REMEp_Baseline{i})))),1);
    SpectreBaseline_REM_AfterInj_mean(i,:)=mean(10*(Data(Restrict(Spectro_Baseline{i},and(Epoch2_Baseline{i},REMEp_Baseline{i})))),1);
%     SpectreBaseline_Wake_BeforeInj_mean(i,:)=mean(10*(Data(Restrict(Spectro_Baseline{i},and(Epoch1_Baseline{i},and(WakeEp_Baseline{i},ThetaEpoch_Baseline{i}))))),1);
%     SpectreBaseline_Wake_AfterInj_mean(i,:)=mean(10*(Data(Restrict(Spectro_Baseline{i},and(Epoch2_Baseline{i},and(WakeEp_Baseline{i},ThetaEpoch_Baseline{i}))))),1);
end

for j=1:length(DirAtropine.path)
    SpectreAtropine_mean(j,:)=mean(10*(Data(Spectro_Atropine{j})),1);
    SpectreAtropine_BeforeInj_mean(j,:)=mean(10*(Data(Restrict(Spectro_Atropine{j},Epoch1_Atropine{j}))),1);
    SpectreAtropine_AfterInj_mean(j,:)=mean(10*(Data(Restrict(Spectro_Atropine{j},Epoch2_Atropine{j}))),1);
    SpectreAtropine_Wake_BeforeInj_mean(j,:)=mean(10*(Data(Restrict(Spectro_Atropine{j},and(Epoch1_Atropine{j},WakeEp_Atropine{j})))),1);
    SpectreAtropine_Wake_AfterInj_mean(j,:)=mean(10*(Data(Restrict(Spectro_Atropine{j},and(Epoch2_Atropine{j},WakeEp_Atropine{j})))),1);
    SpectreAtropine_SWS_BeforeInj_mean(j,:)=mean(10*(Data(Restrict(Spectro_Atropine{j},and(Epoch1_Atropine{j},SWSEp_Atropine{j})))),1);
    SpectreAtropine_SWS_AfterInj_mean(j,:)=mean(10*(Data(Restrict(Spectro_Atropine{j},and(Epoch2_Atropine{j},SWSEp_Atropine{j})))),1);
    SpectreAtropine_REM_BeforeInj_mean(j,:)=mean(10*(Data(Restrict(Spectro_Atropine{j},and(Epoch1_Atropine{j},REMEp_Atropine{j})))),1);
    SpectreAtropine_REM_AfterInj_mean(j,:)=mean(10*(Data(Restrict(Spectro_Atropine{j},and(Epoch2_Atropine{j},REMEp_Atropine{j})))),1);
%     SpectreAtropine_Wake_BeforeInj_mean(j,:)=mean(10*(Data(Restrict(Spectro_Atropine{j},and(Epoch1_Atropine{j},and(WakeEp_Atropine{j},ThetaEpoch_Atropine{j}))))),1);
%     SpectreAtropine_Wake_AfterInj_mean(j,:)=mean(10*(Data(Restrict(Spectro_Atropine{j},and(Epoch2_Atropine{j},and(WakeEp_Atropine{j},ThetaEpoch_Atropine{j}))))),1);
end

% % calculate std
% SpectreBaseline_std = std(SpectreBaseline_mean);
% SpectreBaseline_BeforeInj_std = std(SpectreBaseline_BeforeInj_mean);
% SpectreBaseline_AfterInj_std = std(SpectreBaseline_AfterInj_mean);
% SpectreAtropine_std = std(SpectreAtropine_mean);
% SpectreAtropine_BeforeInj_std = std(SpectreAtropine_BeforeInj_mean);
% SpectreAtropine_AfterInj_std = std(SpectreAtropine_AfterInj_mean);

% calculate SEM
SpectreBaseline_SEM = std(SpectreBaseline_mean)/sqrt(length(SpectreBaseline_mean));
SpectreBaseline_BeforeInj_SEM = std(SpectreBaseline_BeforeInj_mean)/sqrt(length(SpectreBaseline_BeforeInj_mean));
SpectreBaseline_AfterInj_SEM = std(SpectreBaseline_AfterInj_mean)/sqrt(length(SpectreBaseline_AfterInj_mean));
SpectreBaseline_Wake_BeforeInj_SEM = std(SpectreBaseline_Wake_BeforeInj_mean)/sqrt(length(SpectreBaseline_Wake_BeforeInj_mean));
SpectreBaseline_Wake_AfterInj_SEM = std(SpectreBaseline_Wake_AfterInj_mean)/sqrt(length(SpectreBaseline_Wake_AfterInj_mean));
SpectreBaseline_SWS_BeforeInj_SEM = std(SpectreBaseline_SWS_BeforeInj_mean)/sqrt(length(SpectreBaseline_SWS_BeforeInj_mean));
SpectreBaseline_SWS_AfterInj_SEM = std(SpectreBaseline_SWS_AfterInj_mean)/sqrt(length(SpectreBaseline_SWS_AfterInj_mean));
SpectreBaseline_REM_BeforeInj_SEM = std(SpectreBaseline_REM_BeforeInj_mean)/sqrt(length(SpectreBaseline_REM_BeforeInj_mean));
SpectreBaseline_REM_AfterInj_SEM = std(SpectreBaseline_REM_AfterInj_mean)/sqrt(length(SpectreBaseline_REM_AfterInj_mean));

SpectreAtropine_SEM = std(SpectreAtropine_mean)/sqrt(length(SpectreAtropine_mean));
SpectreAtropine_BeforeInj_SEM = std(SpectreAtropine_BeforeInj_mean)/sqrt(length(SpectreAtropine_BeforeInj_mean));
SpectreAtropine_AfterInj_SEM = std(SpectreAtropine_AfterInj_mean)/sqrt(length(SpectreAtropine_AfterInj_mean));
SpectreAtropine_Wake_BeforeInj_SEM = std(SpectreAtropine_Wake_BeforeInj_mean)/sqrt(length(SpectreAtropine_Wake_BeforeInj_mean));
SpectreAtropine_Wake_AfterInj_SEM = std(SpectreAtropine_Wake_AfterInj_mean)/sqrt(length(SpectreAtropine_Wake_AfterInj_mean));
SpectreAtropine_SWS_BeforeInj_SEM = std(SpectreAtropine_SWS_BeforeInj_mean)/sqrt(length(SpectreAtropine_SWS_BeforeInj_mean));
SpectreAtropine_SWS_AfterInj_SEM = std(SpectreAtropine_SWS_AfterInj_mean)/sqrt(length(SpectreAtropine_SWS_AfterInj_mean));
SpectreAtropine_REM_BeforeInj_SEM = std(SpectreAtropine_REM_BeforeInj_mean)/sqrt(length(SpectreAtropine_REM_BeforeInj_mean));
SpectreAtropine_REM_AfterInj_SEM = std(SpectreAtropine_REM_AfterInj_mean)/sqrt(length(SpectreAtropine_REM_AfterInj_mean));

%%
figure,
subplot(231), shadedErrorBar(frq_Baseline{1}, mean(SpectreBaseline_Wake_BeforeInj_mean), SpectreBaseline_Wake_BeforeInj_SEM,'k',1), hold on
shadedErrorBar(frq_Atropine{1}, mean(SpectreAtropine_Wake_BeforeInj_mean), SpectreAtropine_Wake_BeforeInj_SEM,'r',1)
xlim([0 20])
% ylim([0 7e5])
xlabel('Frequency(Hz)')
title('after injection')
title('Wake before injection')
subplot(232), shadedErrorBar(frq_Baseline{1}, mean(SpectreBaseline_SWS_BeforeInj_mean), SpectreBaseline_SWS_BeforeInj_SEM,'k',1), hold on
shadedErrorBar(frq_Atropine{1}, mean(SpectreAtropine_SWS_BeforeInj_mean), SpectreAtropine_SWS_BeforeInj_SEM,'r',1)
xlim([0 20])
% ylim([0 7e5])
xlabel('Frequency(Hz)')
title('after injection')
title('NREM before injection')
subplot(233), shadedErrorBar(frq_Baseline{1}, mean(SpectreBaseline_REM_BeforeInj_mean), SpectreBaseline_REM_BeforeInj_SEM,'k',1), hold on
shadedErrorBar(frq_Atropine{1}, mean(SpectreAtropine_REM_BeforeInj_mean), SpectreAtropine_REM_BeforeInj_SEM,'r',1)
xlim([0 20])
% ylim([0 7e5])
xlabel('Frequency(Hz)')
title('after injection')
title('REM before injection')
subplot(234), shadedErrorBar(frq_Baseline{1}, mean(SpectreBaseline_Wake_AfterInj_mean), SpectreBaseline_Wake_AfterInj_SEM,'k',1), hold on
shadedErrorBar(frq_Atropine{1}, mean(SpectreAtropine_Wake_AfterInj_mean), SpectreAtropine_Wake_AfterInj_SEM,'r',1)
xlim([0 20])
% ylim([0 7e5])
xlabel('Frequency(Hz)')
title('after injection')
title('Wake after injection')
subplot(235), shadedErrorBar(frq_Baseline{1}, mean(SpectreBaseline_SWS_AfterInj_mean), SpectreBaseline_SWS_AfterInj_SEM,'k',1), hold on
shadedErrorBar(frq_Atropine{1}, mean(SpectreAtropine_SWS_AfterInj_mean), SpectreAtropine_SWS_AfterInj_SEM,'r',1)
xlim([0 20])
% ylim([0 7e5])
xlabel('Frequency(Hz)')
title('after injection')
title('NREM after injection')
subplot(236), shadedErrorBar(frq_Baseline{1}, mean(SpectreBaseline_REM_AfterInj_mean), SpectreBaseline_REM_AfterInj_SEM,'k',1), hold on
shadedErrorBar(frq_Atropine{1}, mean(SpectreAtropine_REM_AfterInj_mean), SpectreAtropine_REM_AfterInj_SEM,'r',1)
xlim([0 20])
% ylim([0 7e5])
xlabel('Frequency(Hz)')
title('after injection')
title('REM after injection')

%%
% DirFigure='/home/mobschapeau/Desktop/mathilde/atropine/';
% cd(DirFigure);
% savefig(fullfile('AnalyseSpectrales_HPC_MathildeMice'))

%% figure for each individual mouse

for k=1:length(DirBaselineMC.path)
    figure
    subplot(121), hold on,
    plot(frq_Baseline{k},mean(10*(Data(Restrict(Spectro_Baseline{k},Epoch1_Baseline{k})))),'k','linewidth',2), ylabel('Power (a.u)')
    plot(frq_Atropine{k},mean(10*(Data(Restrict(Spectro_Atropine{k},Epoch1_Atropine{k})))),'r','linewidth',2)
    legend( 'Saline','Atropine')
    xlabel('Frequency')
    title(strcat('PFC before injection M',num2str(DirBaselineMC.nMice{k})))
    subplot(122), hold on,
    plot(frq_Baseline{k},mean(10*(Data(Restrict(Spectro_Baseline{k},Epoch2_Baseline{k})))),'k','linewidth',2), ylabel('Power (a.u)')
    plot(frq_Atropine{k},mean(10*(Data(Restrict(Spectro_Atropine{k},Epoch2_Atropine{k})))),'r','linewidth',2)
    legend( 'Saline','Atropine')
    xlabel('Frequency')
    title(strcat('PFC after injection M',num2str(DirBaselineMC.nMice{k})))
end