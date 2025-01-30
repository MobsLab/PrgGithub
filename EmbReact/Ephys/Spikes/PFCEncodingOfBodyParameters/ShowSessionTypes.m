clear all
MiceNumber=[490,507,508,509,510,512,514];

for mm = 1:length(MiceNumber)
    
    
    FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
    
    
    % Get concatenated variables
    
    % OB Spectrum - everything is realigned to this
    OBSpec_concat=ConcatenateDataFromFolders_SB(FolderList,'spectrum','prefix','B_Low');
    % NoiseEpoch
    FzEp_concat = ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','freezeepoch');
    Sleepstate=ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','sleepstates');
    SessEpoch = ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','sessiontype');
    
    
    SessEpoch.UMazeCond = or(or(SessEpoch.UMazeCond{1},SessEpoch.UMazeCond{2}),or(SessEpoch.UMazeCond{3},SessEpoch.UMazeCond{4}));
    
    
    
    instfreq_concat_PT=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','B','method','PT');
    y=interp1(Range(instfreq_concat_PT),Data(instfreq_concat_PT),Range(OBSpec_concat));
    instfreq_concat_PT = tsd(Range(OBSpec_concat),y);
    instfreq_concat_WV=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','B','method','WV');
    instfreq_concat_WV=Restrict(instfreq_concat_WV,ts(Range(OBSpec_concat)));
    y=interp1(Range(instfreq_concat_WV),Data(instfreq_concat_WV),Range(OBSpec_concat));
    y(y>15)=NaN;
    y=naninterp(y);
    instfreq_concat_WV = tsd(Range(OBSpec_concat),y);
    instfreq_concat_Both = tsd(Range(OBSpec_concat),nanmean([Data(instfreq_concat_WV),Data(instfreq_concat_PT)]')');
    
    
    % InstFreq - heartrate and heart rate variability
    clear heartrate
    try
        heartrate = ConcatenateDataFromFolders_SB(FolderList,'heartrate');
        y=interp1(Range(heartrate),Data(heartrate),Range(OBSpec_concat));
        y = naninterp(y);
        heartrate = tsd(Range(OBSpec_concat),y);
    catch
        heartrate = tsd(0,0);
    end
    
    % Time spent freezing
    ScaryEnv = or(or(or(SessEpoch.EPM{1},SessEpoch.UMazeCond),SessEpoch.SoundCond{1}),SessEpoch.SoundTest{1});
    TimeSpent(mm,1) = length(Range(Restrict(OBSpec_concat,and(ScaryEnv,FzEp_concat))));
    OB_hist{mm}{1} = Data(Restrict(instfreq_concat_Both,and(ScaryEnv,FzEp_concat)));
    EKG_hist{mm}{1} = Data(Restrict(heartrate,and(ScaryEnv,FzEp_concat)));
    % Time safe new environment
    NewEnv = or(SessEpoch.Habituation{1},SessEpoch.SoundHab{1});
    TimeSpent(mm,2) = length(Range(Restrict(OBSpec_concat,NewEnv)));
    OB_hist{mm}{2} = Data(Restrict(instfreq_concat_Both,NewEnv));
    EKG_hist{mm}{2} = Data(Restrict(heartrate,NewEnv));
    % Time safe home cage
    HomeCage = or(or(or(SessEpoch.SleepPre{1},SessEpoch.SleepPost{1}),SessEpoch.SleepPreSound{1}),SessEpoch.SleepPostSound{1});
    TimeSpent(mm,3) = length(Range(Restrict(OBSpec_concat,and(HomeCage,Sleepstate{1}))));
    OB_hist{mm}{3} = Data(Restrict(instfreq_concat_Both,and(HomeCage,Sleepstate{1})));
    EKG_hist{mm}{3} = Data(Restrict(heartrate,and(HomeCage,Sleepstate{1})));
    % Time scary env
    ScaryEnv = or(or(or(SessEpoch.EPM{1},SessEpoch.UMazeCond),SessEpoch.SoundCond{1}),SessEpoch.SoundTest{1});
    TimeSpent(mm,4) = length(Range(Restrict(OBSpec_concat,ScaryEnv)));
    OB_hist{mm}{4} = Data(Restrict(instfreq_concat_Both,ScaryEnv));
    EKG_hist{mm}{4} = Data(Restrict(heartrate,ScaryEnv));
    % Time sleeping - NREM
    TimeSpent(mm,5) = length(Range(Restrict(OBSpec_concat,Sleepstate{2})));
    OB_hist{mm}{5} = Data(Restrict(instfreq_concat_Both,Sleepstate{2}));
    EKG_hist{mm}{5} = Data(Restrict(heartrate,Sleepstate{2}));
    % Time sleeping - REM
    TimeSpent(mm,6) = length(Range(Restrict(OBSpec_concat,Sleepstate{3})));
    OB_hist{mm}{6} = Data(Restrict(instfreq_concat_Both,Sleepstate{3}));
    EKG_hist{mm}{6} = Data(Restrict(heartrate,Sleepstate{3}));
    
    
end


cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_BodyTuningCurves
load('DesciprtionOfDataSet.mat')

% put both types of sleep together
TimeSpent(:,5) = TimeSpent(:,5)+TimeSpent(:,6);
TimeSpent(:,6) = [];
States = {'Fz','Explo-Ne','Home-Wk','Explo-Av','Home-Slp'};
Order = [3,5,2,4,1];

figure
pie(nanmean(TimeSpent(:,Order)),[0,0,0,1,1])
colormap(viridis)
legend(States(Order))

figure

clear HR_histogram OB_histogram
for mm = 1:length(MiceNumber)
    % put both types of sleep together
    OB_hist{mm}{5} = cat(1,OB_hist{mm}{6},OB_hist{mm}{5});
    EKG_hist{mm}{5} = cat(1,EKG_hist{mm}{6},EKG_hist{mm}{5});
    
    for st = 1:5
        [Y,X] = hist(OB_hist{mm}{st},[1:0.2:13]);
        OB_histogram{st}(mm,:) = Y/sum(Y);
        EKG_hist{mm}{st}(EKG_hist{mm}{st}<4) = [];
        [Y,X] = hist(EKG_hist{mm}{st},[4:0.2:15]);
        HR_histogram{st}(mm,:) = Y/sum(Y);
    end
    
    
end

figure
subplot(121)
hold on
set(gca,'colororder',viridis(5))
cellfun(@(x) plot([1:0.2:13],nanmean(x)),OB_histogram(Order))
makepretty
xlabel('BR (Hz)')
xlim([0 15])

subplot(122)
hold on
set(gca,'colororder',viridis(5))
cellfun(@(x) plot([4:0.2:15],nanmean(x)),HR_histogram(Order))
makepretty
xlabel('HR (Hz)')
xlim([4 15])
legend(States(Order))
