clear all,

Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');

% Get the accelero channel with the least noise
for d = 1:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        
        load('LFPData/InfoLFP.mat')
        channel_accelero = InfoLFP.channel(strcmp(InfoLFP.structure,'Accelero'));
        
        for k  = 1 : length(channel_accelero)
            
            load(['CleanedAcc/Acc',num2str(channel_accelero(k)),'.mat'],'NoiseAccEpoch')
            DurNoise(dd,k) = sum(Stop(NoiseAccEpoch,'s')-Start(NoiseAccEpoch,'s'));
        end
    end
    [~,Channel(d)] = min(nansum(DurNoise,1));
    Channel(d) = channel_accelero(Channel(d));
end

fig = figure(2);
ZscoreThresh = 1.5;
for d = 1:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        disp(Dir.path{d}{dd})
        load(['CleanedAcc/Acc',num2str(Channel(d)),'.mat'])
        load(['LFPData/LFP',num2str(Channel(d)),'.mat'])
        LFPClean2 = FilterLFP(LFPClean,[52,500],1024);
        LFPClean1 = FilterLFP(LFPClean,[0.1,48],1024);
        LFPClean = tsd(Range(LFPClean),Data(LFPClean1)+Data(LFPClean2));
        LFPCleanZ = tsd(Range(LFPClean),zscore(Data(LFPClean)-movmean(Data(LFPClean),1250*60)));
        AccBurst = thresholdIntervals(LFPCleanZ,ZscoreThresh,'Direction','Above');
        AccBurst = mergeCloseIntervals(AccBurst,1*1e4);
        AccBurst = dropShortIntervals(AccBurst,1*1e4);
        AccBurst = dropLongIntervals(AccBurst,5*1e4);
        load('BreathingInfo_ZeroCross.mat')
        AllPeaks=[0:2*pi:2*pi*(length(Data(Breathtsd))-1)];
        Y=interp1(Range(Breathtsd,'s'),AllPeaks,Range(LFP,'s'));
        PhaseInterpol=tsd(Range(LFP),mod(Y,2*pi));
        st=Start(AccBurst);
        [MAcc,TAcc] = PlotRipRaw(LFPClean,st/1e4,3000,0,0);
        [MBr,TBr] = PlotRipRaw(PhaseInterpol,st/1e4,3000,0,0);
        
        for i=-5*10:5*10
            [BreathingPhase(i+5*10+1,:),b]=hist(Data(Restrict(PhaseInterpol,intervalSet(Start(AccBurst)+(i-1)*1E3,Start(AccBurst)+i*1E3))),[0.05:0.1:6.25]);
        end
        
        mkdir('NeuronResponseToMovement')
        save(['NeuronResponseToMovement/MovementEvents_ZScore',strrep(num2str(ZscoreThresh),'.',','),'.mat'],'AccBurst','TAcc','TBr','BreathingPhase')
%         subplot(221)
%         imagesc(MBr(:,1),1:length(st),zscore(TAcc')')
%         clim([-2 2])
%         title('All Accelero events')
%         subplot(222)
%         imagesc(MBr(:,1),1:length(st),zscore(TBr')')
%         clim([-2 2])
%         title('All Breathing responses')
%         subplot(223)
%         plot(MAcc(:,1),MAcc(:,2))
%         title('Average accelero respons')
%         xlim([-3 3])
%         subplot(224)
%         plot(MBr(:,1),MBr(:,2))
%         title('Average breathing phase')
%         xlim([-3 3])
%         saveas(fig.Number,['NeuronResponseToMovement/MovementEvents_ZScore,strrep(num2str(ZscoreThresh),'.',','),'.png'])
%         %         pause
%         clf
        clear AccBurst TBr st LFPClean LFPCleanZ
    end
end

num =1;
for d = 1:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        load('ExpeInfo.mat')
        load('NeuronResponseToMovement/MovementEvents_ZScore2.mat')
        AllBreath{num} = TBr;
        AllMov{num} = TAcc;
        AllMovPhase{num} = BreathingPhase;
        Type{num} = Dir.ExpeInfo{d}{dd}.DrugInjected;
        num = num+1;
    end
end

figure
for nn = 1:num-1
subplot(3,3,nn)
imagesc(AllMovPhase{nn}(:,2:end-1)')
title(Type{nn})
end


Mov.Saline = [];
Mov.MTZL = [];
Breath.Saline = [];
Breath.MTZL = [];
BreathMean.Saline = [];
BreathMean.MTZL = [];
for nn = 1:num-1
    
    switch Type{nn}
        case 'METHIMAZOLE'
            Breath.MTZL = [Breath.MTZL,AllBreath{nn}'];
            Mov.MTZL = [Mov.MTZL,AllMov{nn}'];
            BreathMean.MTZL = [BreathMean.MTZL;nanmean(AllBreath{nn})];
            
        otherwise
            Mov.Saline = [Mov.Saline,AllMov{nn}'];
            Breath.Saline = [Breath.Saline,AllBreath{nn}'];
            BreathMean.Saline = [BreathMean.Saline;nanmean(AllBreath{nn})];
            
    end
    
end



