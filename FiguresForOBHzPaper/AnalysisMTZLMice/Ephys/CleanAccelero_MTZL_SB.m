clear all,

%Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');
Dir1 = PathForExperimentsMtzlProject('SoundTestPlethysmo');
Dir2 = PathForExperimentsMtzlProject('SoundTest_Plethysmo_NoInjection');
Dir3 = PathForExperimentsMtzlProject('SoundTest_Plethysmo_PostMTZL')
Dir4 = PathForExperimentsMtzlProject('SoundTest_Plethysmo_PreMTZL')
Dir12 = MergePathForExperiment(Dir1,Dir2);
Dir34 = MergePathForExperiment(Dir3,Dir4);
Dir = MergePathForExperiment(Dir12,Dir34);


fig = figure(1);
for d = 22:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        foldername =  [cd filesep];
        
        % Get noisy accelerometer epochs
        load([foldername 'LFPData/InfoLFP.mat'])
        channel_accelero = InfoLFP.channel(strcmp(InfoLFP.structure,'Accelero'));
        mkdir('CleanedAcc')
        
        for k  = 1 : length(channel_accelero)
            disp(num2str(k))
            load([foldername 'LFPData/LFP' num2str(channel_accelero(k)) '.mat'], 'LFP');
            TotalEpoch = intervalSet(0,max(Range(LFP)));
            FilLFP = FilterLFP(LFP,[0.1 20],1024);
            Newtdsd = tsd(Range(FilLFP),abs([0;diff((Data(FilLFP)))]));
            NoiseAccEpoch = thresholdIntervals(Newtdsd,2,'Direction','Below');
            NoiseAccEpoch = dropShortIntervals(NoiseAccEpoch,5*60*1e4);
            NoiseAccEpoch = mergeCloseIntervals(NoiseAccEpoch,5*1e4);
            
            
            LFPClean = Restrict(LFP,TotalEpoch-NoiseAccEpoch);
            a = Data(LFPClean);
            a(a<prctile(Data(LFPClean),0.1))=NaN;
            a(a>prctile(Data(LFPClean),99.95))=NaN;
            if isnan(a(end))
                a(end) = a(find(not(isnan(a)),1,'last'));
            end
            if isnan(a(1))
                a(1) = a(find(not(isnan(a)),1,'first'));
            end
            
            aint = naninterp(a);
            LFPClean = tsd(Range(LFPClean),aint);
            LFPClean = tsd(Range(LFPClean),Data(LFPClean)-movmean(Data(LFPClean),1250*60));
            subplot(3,1,k)
            plot(Range(LFP),Data(LFP)), hold on
            plot(Range(LFPClean),Data(LFPClean))
            title([num2str(sum(Stop(NoiseAccEpoch,'s')-Start(NoiseAccEpoch,'s'))) ' s noise'])
            
            save(['CleanedAcc/Acc' num2str(channel_accelero(k)) '.mat'],'LFPClean','NoiseAccEpoch')
            clear NoiseAccEpoch LFPClean
        end
        saveas(fig.Number,'CleanedAcc/OverviewAccCleaning.png')
        clf
        
        
    end
end




