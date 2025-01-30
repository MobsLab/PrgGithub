DirSensoryExpo1SDinStress= PathForExperiments_SD_MC('SensoryExposureCD1cage');
DirSensoryExpo1SDinStress= RestrictPathForExperiment(DirSensoryExpo1SDinStress,'nMice',[1148 1149 1150 1217 1218 1219 1220]);

DirSensoryExpo1SDsafe = PathForExperiments_SD_MC('SensoryExposureCD1cage_PART1');

DirExpo1 = MergePathForExperiment(DirSensoryExpo1SDinStress,DirSensoryExpo1SDsafe)
%% Get DATA 1st expo
figure,
for i = 1:length(DirExpo1.path)
    cd (DirExpo1.path{i}{1}) % à quoi sert {1}
    behav{i} = load ('behavResources.mat');
    load('Bulb_deep_Low_Spectrum.mat');
    
    subplot(11,1,i)
%     plot (Range(behav{i}.MovAcctsd),Data(behav{i}.MovAcctsd));
    hold on, plot (Range(Restrict(behav{i}.MovAcctsd,behav{i}.FreezeAccEpoch)),Data(Restrict(behav{i}.MovAcctsd,behav{i}.FreezeAccEpoch)));
    set(gca,'xticklabels',[])
end