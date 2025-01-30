clear all
Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');

for d = 1:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        disp(Dir.path{d}{dd})
        load('LFPData/InfoLFP.mat')
        channel_accelero = InfoLFP.channel(strcmp(InfoLFP.structure,'Accelero'));
        load('BreathingInfo_ZeroCross.mat')
        stPeak=Range(Peaktsd);
        stPeak = stPeak(1:50:end);
        stTrough=Range(Troughtsd);
        stTrough = stTrough(1:50:end);
        TotalEpoch = intervalSet(0,max([stTrough;stPeak])+5*1e4);
        
        stPeak = ts(stPeak);
        stTrough = ts(stTrough);

        for k  = 1 : length(channel_accelero)
            
            load(['CleanedAcc/Acc',num2str(channel_accelero(k)),'.mat'])
            stPeakRes = Restrict(stPeak,TotalEpoch-NoiseAccEpoch);
            [MAcc,TAccPeak] = PlotRipRaw(LFPClean,Range(stPeakRes)/1e4,3000,0,0);
            save(['NeuronResponseToMovement/AcceleroTriggeredOnBreathPeakCh',num2str(channel_accelero(k)),'.mat'],'TAccPeak','stPeakRes')
            
            stTroughRes = Restrict(stTrough,TotalEpoch-NoiseAccEpoch);
            [MAcc,TAccTrough] = PlotRipRaw(LFPClean,Range(stTroughRes)/1e4,3000,0,0);
            save(['NeuronResponseToMovement/AcceleroTriggeredOnBreathTroughCh',num2str(channel_accelero(k)),'.mat'],'TAccTrough','stTroughRes')
            clear TAccTrough   TAccPeak
        end
    end
end

clear all
Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');
num = 1;
for d = 1:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        disp(Dir.path{d}{dd})
        load('LFPData/InfoLFP.mat')
        channel_accelero = InfoLFP.channel(strcmp(InfoLFP.structure,'Accelero'));
        load('SleepScoring_Accelero.mat','ImmobilityEpoch')
        
        for k  = 1 : length(channel_accelero)
            load(['NeuronResponseToMovement/AcceleroTriggeredOnBreathPeakCh',num2str(channel_accelero(k)),'.mat'],'TAccPeak','stPeakRes')
            Peaktsd = tsd(Range(stPeakRes),TAccPeak);
            Peaktsd = Restrict(Peaktsd,ImmobilityEpoch);
            AllRespPeak{k}{num}= Data(Peaktsd);
            load(['NeuronResponseToMovement/AcceleroTriggeredOnBreathTroughCh',num2str(channel_accelero(k)),'.mat'],'TAccTrough','stTroughRes')
            Troughtsd = tsd(Range(stTroughRes),TAccTrough);
            Troughtsd = Restrict(Troughtsd,ImmobilityEpoch);
            AllRespTrough{k}{num}= Data(Troughtsd);            
        end
        Type{num} = Dir.ExpeInfo{d}{dd}.DrugInjected;
        num = num+1;
    end
end


figure
plo = 0;
for chan  =1:3
    MovTrough.Saline = [];
    MovTrough.MTZL = [];
    MovPeak.Saline = [];
    MovPeak.MTZL = [];
    chan
    for nn = 1:num-1
        
        switch Type{nn}
            case 'METHIMAZOLE'
                
                vals = nanmean(AllRespTrough{chan}{nn}(:,1:500)');
                A = (AllRespTrough{chan}{nn}(find(vals>prctile(vals,10) & vals<prctile(vals,90)),:)')';
                A = A-repmat(nanmean(A'),7501,1)';
                MovTrough.MTZL = [MovTrough.MTZL;A];
                
                if plo
                    subplot(211)
                    imagesc(A)
                    clim([-100 100])
                    title(num2str(nn))
                end
                
                vals = nanmean(AllRespPeak{chan}{nn}(:,1:500)');
                A = (AllRespPeak{chan}{nn}(find(vals>prctile(vals,10) & vals<prctile(vals,90)),:)')';
                A = A-repmat(nanmean(A'),7501,1)';
                MovPeak.MTZL = [MovPeak.MTZL;A];
                
                if plo
                    subplot(212)
                    imagesc(A)
                    clim([-100 100])
                    pause
                    clf
                end
                
            otherwise
                vals = nanmean(AllRespTrough{chan}{nn}(:,1:500)');
                A = (AllRespTrough{chan}{nn}(find(vals>prctile(vals,10) & vals<prctile(vals,90)),:)')';
                A = A-repmat(nanmean(A'),7501,1)';
                MovTrough.Saline = [MovTrough.Saline;A];
                
                if plo
                    subplot(211)
                    imagesc(A)
                    clim([-100 100])
                    title(num2str(nn))
                end
                
                vals = nanmean(AllRespPeak{chan}{nn}(:,1:500)');
                A = (AllRespPeak{chan}{nn}(find(vals>prctile(vals,10) & vals<prctile(vals,90)),:)')';
                A = A-repmat(nanmean(A'),7501,1)';
                MovPeak.Saline = [MovPeak.Saline;A];
                
                if plo
                    subplot(212)
                    imagesc(A)
                    clim([-100 100])
                    pause
                    clf
                end
        end
        
    end
    
    subplot(2,3,chan)
    imagesc(MovPeak.Saline)
    clim([-100 100])
    
    
    subplot(2,3,chan+3)
    imagesc(MovPeak.MTZL)
    clim([-100 100])
    
    
    %     subplot(221)
    %     plot([-3:1/1250:3],nanmean(MovTrough.MTZL),'r')
    %     hold on
    %     plot([-3:1/1250:3],nanmean(MovTrough.Saline),'k')
    %     AmpMTZL = max(MovTrough.MTZL')-min(MovTrough.MTZL');
    %     AmpSAL = max(MovTrough.Saline')-min(MovTrough.Saline');
    %     xlim([-0.5 0.5])
    %     subplot(222)
    %     MakeSpreadAndBoxPlot_SB({AmpSAL,AmpMTZL},{[0.8 0.8 0.8],[1 0.4 0.4]},[1 2],{'CTRL','MTZL'})
    %
    %
    %     subplot(223)
    %     plot([-3:1/1250:3],nanmean(MovPeak.MTZL),'r')
    %     hold on
    %     plot([-3:1/1250:3],nanmean(MovPeak.Saline),'k')
    %     AmpMTZL = max(MovPeak.MTZL')-min(MovPeak.MTZL');
    %     AmpSAL = max(MovPeak.Saline')-min(MovPeak.Saline');
    %     xlim([-0.5 0.5])
    %     subplot(224)
    %     MakeSpreadAndBoxPlot_SB({AmpSAL,AmpMTZL},{[0.8 0.8 0.8],[1 0.4 0.4]},[1 2],{'CTRL','MTZL'})
    %     pause
    %     clf
    %
end


%%%
clear all
Dir1 = PathForExperimentsMtzlProject('SoundTestPlethysmo');
Dir2 = PathForExperimentsMtzlProject('SoundTest_Plethysmo_NoInjection');
Dir3 = PathForExperimentsMtzlProject('SoundTest_Plethysmo_PostMTZL')
Dir4 = PathForExperimentsMtzlProject('SoundTest_Plethysmo_PreMTZL')
Dir12 = MergePathForExperiment(Dir1,Dir2);
Dir34 = MergePathForExperiment(Dir3,Dir4);
Dir = MergePathForExperiment(Dir12,Dir34);

for d = 1:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        
        cd(Dir.path{d}{dd})
        disp(Dir.path{d}{dd})
        load('LFPData/InfoLFP.mat')
        channel_accelero = InfoLFP.channel(strcmp(InfoLFP.structure,'Accelero'));
        GetBreathingInfoZeroCross_SB
        load('BreathingInfo_ZeroCross.mat')
        stPeak=Range(Peaktsd);
        stTrough=Range(Troughtsd);
        mkdir('NeuronResponseToMovement')
        for k  = 1 : length(channel_accelero)
            
            load(['CleanedAcc/Acc',num2str(channel_accelero(k)),'.mat'])
            [MAcc,TAccPeak] = PlotRipRaw(LFPClean,stPeak/1e4,3000,0,0);
            save(['NeuronResponseToMovement/AcceleroTriggeredOnBreathPeakCh',num2str(channel_accelero(k)),'.mat'],'MAcc','TAccPeak','stPeak')
            [MAcc,TAccTrough] = PlotRipRaw(LFPClean,stTrough/1e4,3000,0,0);
            save(['NeuronResponseToMovement/AcceleroTriggeredOnBreathTroughCh',num2str(channel_accelero(k)),'.mat'],'MAcc','TAccTrough','stTrough')
            clear TAccTrough   TAccPeak
        end
    end
end

clear all
Dir1 = PathForExperimentsMtzlProject('SoundTestPlethysmo');
Dir2 = PathForExperimentsMtzlProject('SoundTest_Plethysmo_NoInjection');
Dir3 = PathForExperimentsMtzlProject('SoundTest_Plethysmo_PostMTZL')
Dir4 = PathForExperimentsMtzlProject('SoundTest_Plethysmo_PreMTZL')
Dir12 = MergePathForExperiment(Dir1,Dir2);
Dir34 = MergePathForExperiment(Dir3,Dir4);
Dir = MergePathForExperiment(Dir12,Dir34);

num = 1;
for d = 1:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        disp(Dir.path{d}{dd})
        try
        load('LFPData/InfoLFP.mat')
        channel_accelero = InfoLFP.channel(strcmp(InfoLFP.structure,'Accelero'));
        
        for k  = 1 : length(channel_accelero)
            load(['NeuronResponseToMovement/AcceleroTriggeredOnBreathPeakCh',num2str(channel_accelero(k)),'.mat'],'TAccPeak')
            AllRespPeak{k}(num,:)= nanmean(zscore(TAccPeak')');
            load(['NeuronResponseToMovement/AcceleroTriggeredOnBreathTroughCh',num2str(channel_accelero(k)),'.mat'],'TAccTrough')
            AllRespTrough{k}(num,:)= nanmean(zscore(TAccTrough')');
            
            
        end
        Type{num} = Dir.ExpeInfo{d}{dd}.DrugInjected;
        num = num+1;
        end
    end
end



for chan  =1:3
    MovTrough.Saline = [];
    MovTrough.MTZL = [];
    MovPeak.Saline = [];
    MovPeak.MTZL = [];
    
    for nn = 1:num-1
        
        switch Type{nn}
            case 'METHIMAZOLE'
                MovTrough.MTZL = [MovTrough.MTZL;(AllRespTrough{chan}(nn,3500:4000))];
                MovPeak.MTZL = [MovTrough.MTZL;(AllRespPeak{chan}(nn,3500:4000))];
                
            otherwise
                MovTrough.Saline = [MovTrough.Saline;(  AllRespTrough{chan}(nn,3500:4000))];
                MovPeak.Saline = [MovTrough.Saline;(  AllRespPeak{chan}(nn,3500:4000))];
                
        end
        
    end
    subplot(221)
    plot([-0.2:1/1250:0.2],nanmean(MovTrough.MTZL),'r')
    hold on
    plot([-0.2:1/1250:0.2],nanmean(MovTrough.Saline),'k')
    AmpMTZL = max(MovTrough.MTZL')-min(MovTrough.MTZL');
    AmpSAL = max(MovTrough.Saline')-min(MovTrough.Saline');
    subplot(222)
    MakeSpreadAndBoxPlot_SB({AmpSAL,AmpMTZL},{[0.8 0.8 0.8],[1 0.4 0.4]},[1 2],{'CTRL','MTZL'})
    
    subplot(223)
    plot([-0.2:1/1250:0.2],nanmean(MovPeak.MTZL),'r')
    hold on
    plot([-0.2:1/1250:0.2],nanmean(MovPeak.Saline),'k')
    AmpMTZL = max(MovPeak.MTZL')-min(MovPeak.MTZL');
    AmpSAL = max(MovPeak.Saline')-min(MovPeak.Saline');
    subplot(224)
    MakeSpreadAndBoxPlot_SB({AmpSAL,AmpMTZL},{[0.8 0.8 0.8],[1 0.4 0.4]},[1 2],{'CTRL','MTZL'})
    
    pause
    clf
    
end
