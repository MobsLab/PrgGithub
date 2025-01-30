clear all
SessTypes = {'UMazeCond','UMazeCond_EyeShock','UMazeCondBlockedShock_EyeShock','UMazeCondBlockedSafe_EyeShock','ExtinctionBlockedShock_EyeShock','ExtinctionBlockedSafe_EyeShock'};
for ss = 1:6
    Dir{ss}=PathForExperimentsEmbReact(SessTypes{ss});
end

DurMergeMin=4*1e4;


load('/media/DataMOBsRAID/ProjectEmbReact/Mouse431/20160803/ProjetctEmbReact_M431_20160803_Cond/Cond10/B_Low_Spectrum.mat')
f = Spectro{3};

for d = 1:length(Dir)
    
    for mm = 1:length(Dir{d}.path)
        
        try
            SpecOB = ConcatenateDataFromFolders_SB(Dir{d}.path{mm},'spectrum','prefix','B_Low');
            StimEpoch = ConcatenateDataFromFolders_SB(Dir{d}.path{mm},'epoch','epochname','stimepoch');
            NoiseEpoch = ConcatenateDataFromFolders_SB(Dir{d}.path{mm},'epoch','epochname','noiseepoch');
            LinPos = ConcatenateDataFromFolders_SB(Dir{d}.path{mm},'linearposition');
            FreezeEpoch = ConcatenateDataFromFolders_SB(Dir{d}.path{mm},'epoch','epochname','freezeepoch');
            
        
        FreezeEpoch = FreezeEpoch - or(StimEpoch,NoiseEpoch);
        FreezeEpoch=dropShortIntervals(FreezeEpoch,DurMergeMin);
        
        
        BefFreezeEpoch = intervalSet(Start(FreezeEpoch)-DurMergeMin,Start(FreezeEpoch));
        clear FzPer
        for t = 1:length(Start(BefFreezeEpoch))
            FzPer(t) = sum(Stop(and(subset(BefFreezeEpoch,t),FreezeEpoch),'s')-Start(and(subset(BefFreezeEpoch,t),FreezeEpoch),'s'));
        end
        FreezeEpoch_Start = subset(FreezeEpoch,find(FzPer<0.5));
        FreezeEpoch_Start_Shock = and(FreezeEpoch_Start,thresholdIntervals(LinPos,0.4,'Direction','Below'));
        FreezeEpoch_Start_Safe = and(FreezeEpoch_Start,thresholdIntervals(LinPos,0.6,'Direction','Above'));

        AfterFreezeEpoch = intervalSet(Stop(FreezeEpoch),Stop(FreezeEpoch)+DurMergeMin);
        clear FzPer
        for t = 1:length(Start(BefFreezeEpoch))
            FzPer(t) = sum(Stop(and(subset(AfterFreezeEpoch,t),FreezeEpoch),'s')-Start(and(subset(AfterFreezeEpoch,t),FreezeEpoch),'s'));
        end
        FreezeEpoch_Stop = subset(FreezeEpoch,find(FzPer<0.5));
        FreezeEpoch_Stop_Shock = and(FreezeEpoch_Stop,thresholdIntervals(LinPos,0.4,'Direction','Below'));
        FreezeEpoch_Stop_Safe = and(FreezeEpoch_Stop,thresholdIntervals(LinPos,0.6,'Direction','Above'));
        
        ValSpec = Data(SpecOB);
        ValSpec = nanmean(nanmean(ValSpec(25:end,:)));
        [AvSpec.Start.Shock{d}{mm},S,tps]=AverageSpectrogram(SpecOB,f,ts(Start(FreezeEpoch_Start_Shock)),200,40,0,0,0);
        AvSpec.Start.Shock{d}{mm} = AvSpec.Start.Shock{d}{mm}./ValSpec;
        
        [AvSpec.Stop.Shock{d}{mm},S,tps]=AverageSpectrogram(SpecOB,f,ts(Stop(FreezeEpoch_Stop_Shock)),200,40,0,0,0);
        AvSpec.Stop.Shock{d}{mm} = AvSpec.Stop.Shock{d}{mm}./ValSpec;
        
        [AvSpec.Start.Safe{d}{mm},S,tps]=AverageSpectrogram(SpecOB,f,ts(Start(FreezeEpoch_Start_Safe)),200,40,0,0,0);
        AvSpec.Start.Safe{d}{mm} = AvSpec.Start.Safe{d}{mm}./ValSpec;
        
        [AvSpec.Stop.Safe{d}{mm},S,tps]=AverageSpectrogram(SpecOB,f,ts(Stop(FreezeEpoch_Stop_Safe)),200,40,0,0,0);
        AvSpec.Stop.Safe{d}{mm} = AvSpec.Stop.Safe{d}{mm}./ValSpec;
        
        disp('done')
                clf,subplot(221),imagesc(tps/1e3,f,log(AvSpec.Start.Shock{d}{mm})), axis xy
                subplot(222),imagesc(tps/1e3,f,log(AvSpec.Stop.Shock{d}{mm})), axis xy
                subplot(223),imagesc(tps/1e3,f,log(AvSpec.Start.Safe{d}{mm})), axis xy
                subplot(224),imagesc(tps/1e3,f,log(AvSpec.Stop.Safe{d}{mm})), axis xy
                keyboard
        end
    end
end




AllSpec.Start.Safe = zeros(261,41);
AllSpec.Stop.Safe = zeros(261,41);
AllSpec.Start.Shock = zeros(261,41);
AllSpec.Stop.Shock = zeros(261,41);

for d = 1:length(Dir)
    
    for mm = 1:length(Dir{d}.path)
        
        try,
            if not(isempty(AvSpec.Start.Safe{d}{mm}))
                if sum(sum(isnan(AvSpec.Start.Safe{d}{mm}))) == 0
                    AllSpec.Start.Safe = AllSpec.Start.Safe + AvSpec.Start.Safe{d}{mm};
                end
            end
        end
        
        try
            if not(isempty(AvSpec.Stop.Safe{d}{mm}))
                if sum(sum(isnan(AvSpec.Stop.Safe{d}{mm}))) == 0
                    AllSpec.Stop.Safe = AllSpec.Stop.Safe + AvSpec.Stop.Safe{d}{mm};
                end
            end
        end
        
        try
            if not(isempty(AvSpec.Start.Shock{d}{mm}))
                if sum(sum(isnan(AvSpec.Start.Shock{d}{mm}))) == 0
                    AllSpec.Start.Shock = AllSpec.Start.Shock + AvSpec.Start.Shock{d}{mm};
                end
            end
        end
        
        try
            if not(isempty(AvSpec.Stop.Shock{d}{mm}))
                if sum(sum(isnan(AvSpec.Stop.Shock{d}{mm}))) == 0
                    AllSpec.Stop.Shock = AllSpec.Stop.Shock +  AvSpec.Stop.Shock{d}{mm};
                end
            end
        end
    end
end

clf,
subplot(221),imagesc(tps/1e3,f,log(AllSpec.Start.Shock)), axis xy
line([0 0],ylim,'linewidth',2,'color','w')
box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
ylabel('Frequency (Hz)')
xlabel('Time to freeze start (s)')
title('Shock')
clim([1.5 5.2])

subplot(222),imagesc(tps/1e3,f,log(AllSpec.Stop.Shock)), axis xy
line([0 0],ylim,'linewidth',2,'color','w')
box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
ylabel('Frequency (Hz)')
xlabel('Time to freeze stop (s)')
title('Shock')
clim([1.5 5.2])

subplot(223),imagesc(tps/1e3,f,log(AllSpec.Start.Safe)), axis xy
line([0 0],ylim,'linewidth',2,'color','w')
box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
ylabel('Frequency (Hz)')
xlabel('Time to freeze start (s)')
title('Safe')
clim([2.5 5.3])

subplot(224),imagesc(tps/1e3,f,log(AllSpec.Stop.Safe)), axis xy
line([0 0],ylim,'linewidth',2,'color','w')
box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
ylabel('Frequency (Hz)')
xlabel('Time to freeze stop (s)')
title('Safe')
clim([2.5 5.3])

% 
% for d = 1:length(Dir)
%     
%     for mm = 1:length(Dir{d}.path)
%         
%         try,
% imagesc(tps/1e3,f,log(AvSpec.Start.Safe{d}{mm})), axis xy
% pause
%         end
%     end
% end