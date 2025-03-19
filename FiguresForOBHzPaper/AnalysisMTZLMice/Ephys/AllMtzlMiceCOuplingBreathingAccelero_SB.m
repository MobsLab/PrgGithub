clear all,
Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');
ZscoreThreshPoss = [1,1.5,2];
for zrt = 3
    
    ZscoreThresh = ZscoreThreshPoss(zrt)
    for d = 1:length(Dir.path)
        for dd = 1:length(Dir.path{d})
            cd(Dir.path{d}{dd})
            disp(Dir.path{d}{dd})
            load('LFPData/InfoLFP.mat')
            channel_accelero = InfoLFP.channel(strcmp(InfoLFP.structure,'Accelero'));
            
            for k  = 1 : length(channel_accelero)
                fig = figure;
                load(['CleanedAcc/Acc',num2str(channel_accelero(k)),'.mat'])
                load(['LFPData/LFP',num2str(channel_accelero(k)),'.mat'])
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
                save(['NeuronResponseToMovement/MovementEvents_ZScore',strrep(num2str(ZscoreThresh),'.',','),'chan',num2str(channel_accelero(k)),'.mat'],'AccBurst','TAcc','TBr','BreathingPhase')
                subplot(221)
                imagesc(MBr(:,1),1:length(st),zscore(TAcc')')
                clim([-2 2])
                title('All Accelero events')
                subplot(222)
                imagesc(MBr(:,1),1:length(st),zscore(TBr')')
                clim([-2 2])
                title('All Breathing responses')
                subplot(223)
                plot(MAcc(:,1),MAcc(:,2))
                title('Average accelero respons')
                xlim([-3 3])
                subplot(224)
                plot(MBr(:,1),MBr(:,2))
                title('Average breathing phase')
                xlim([-3 3])
                saveas(fig.Number,['NeuronResponseToMovement/MovementEvents_ZScore',strrep(num2str(ZscoreThresh),'.',','),'chan',num2str(channel_accelero(k)),'.png'])
                clear AccBurst TBr st LFPClean LFPCleanZ
                close all
            end
        end
    end
end

clear all
%% Look at figure
Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');
ZscoreThreshPoss = [1,1.5,2];
for z = 1
    clear AllBreath AllMov AllMovPhase Type
    num =1;
    ZscoreThresh = ZscoreThreshPoss(z);
    for d = 1:length(Dir.path)
        for dd = 1:length(Dir.path{d})
            cd(Dir.path{d}{dd})
            disp(Dir.path{d}{dd})
            
            load('LFPData/InfoLFP.mat')
            channel_accelero = InfoLFP.channel(strcmp(InfoLFP.structure,'Accelero'));
            load('ExpeInfo.mat')
            load('LFPData/LFP0.mat')
            
            for k = 1:3
                load(['NeuronResponseToMovement/MovementEvents_ZScore',strrep(num2str(ZscoreThresh),'.',','),'chan',num2str(channel_accelero(k)),'.mat'],'TBr','TAcc','BreathingPhase','AccBurst')
                load(['CleanedAcc/Acc',num2str(channel_accelero(k)),'.mat'],'NoiseAccEpoch')
                load('LFPData/LFP0.mat')
                AllBreath{num,k} = TBr;
                AllMov{num,k} = TAcc;
                AllMovPhase{num,k} = BreathingPhase;
                Type{num,k} = Dir.ExpeInfo{d}{dd}.DrugInjected;
                
                load('SleepScoring_Accelero.mat','ImmobilityEpoch')
                ImmobilityEpoch = mergeCloseIntervals(ImmobilityEpoch,4*60*1e4);
                ImmobilityEpoch = dropShortIntervals(ImmobilityEpoch,4*60*1e4);

                if sum(Stop(NoiseAccEpoch,'s')-Start(NoiseAccEpoch,'s'))==0
                    EpisodeDur{num,k} = max(Range(LFP,'s'));
                else
                    EpisodeDur{num,k} = sum(Stop(ImmobilityEpoch,'s')-Start(ImmobilityEpoch,'s'));
                end
                
                for sec = 1:10
                    st = Start(and(mergeCloseIntervals(AccBurst,sec*1e4),ImmobilityEpoch));
                    NumEpisodes{num,k}(sec,:) = length(st);
                end
                
            end
            num = num+1;
        end
    end
end


for chan = 1:3
    Mov.Saline = [];
    Mov.MTZL = [];
    Breath.Saline = [];
    Breath.MTZL = [];
    BreathMean.Saline = [];
    BreathMean.MTZL = [];
    BreathPhase.Saline = zeros(size(AllMovPhase{1,1},1),size(AllMovPhase{1,1},2));
    BreathPhase.MTZL = zeros(size(AllMovPhase{1,1},1),size(AllMovPhase{1,1},2));
    NumEvents.Saline = [];
    NumEvents.MTZL = [];
    
    for nn = 1:num-1
        
        switch Type{nn}
            case 'METHIMAZOLE'
                Breath.MTZL = [Breath.MTZL,AllBreath{nn,chan}'];
                Mov.MTZL = [Mov.MTZL,AllMov{nn,chan}'];
                BreathMean.MTZL = [BreathMean.MTZL;nanmean(AllBreath{nn,chan})];
                temp = AllMovPhase{nn,chan}; temp = temp./sum(sum(AllMovPhase{nn,chan}));
                BreathPhase.MTZL = BreathPhase.MTZL+temp;
                    NumEvents.MTZL = [NumEvents.MTZL,PropInImmobPeriod{nn,chan}];

            otherwise
                Mov.Saline = [Mov.Saline,AllMov{nn,chan}'];
                Breath.Saline = [Breath.Saline,AllBreath{nn,chan}'];
                BreathMean.Saline = [BreathMean.Saline;nanmean(AllBreath{nn,chan})];
                temp = AllMovPhase{nn,chan}; temp = temp./sum(sum(AllMovPhase{nn,chan}));
                BreathPhase.Saline = BreathPhase.Saline+temp;
                NumEvents.Saline = [NumEvents.Saline,PropInImmobPeriod{nn,chan}];

        end
        
    end
    
    subplot(3,3,(chan-1)*3+1)
    shadedErrorBar([-3:1/1250:3],nanmean(BreathMean.Saline),stdError(BreathMean.Saline))
    hold on
    shadedErrorBar([-3:1/1250:3],nanmean(BreathMean.MTZL),stdError(BreathMean.MTZL),'r')
    subplot(3,3,(chan-1)*3+2)
    BreathPhase.Saline(:,1) = [];
    BreathPhase.Saline(:,end) = [];
    
    imagesc([-5:1/1250:5],[0:0.1:2*pi],BreathPhase.Saline')
    clim([0.0004 0.001])
    xlim([-3 3])
    subplot(3,3,(chan-1)*3+3)
    BreathPhase.MTZL(:,1) = [];
    BreathPhase.MTZL(:,end) = [];
    imagesc([-5:1/1250:5],[0:0.1:2*pi],BreathPhase.MTZL')
    clim([0.0004 0.001])
    xlim([-3 3])
end

% Final Figure

chan = 1
Mov.Saline = [];
Mov.MTZL = [];
Breath.Saline = [];
Breath.MTZL = [];
BreathMean.Saline = [];
BreathMean.MTZL = [];
BreathPhase.Saline = zeros(size(AllMovPhase{1,1},1),size(AllMovPhase{1,1},2));
BreathPhase.MTZL = zeros(size(AllMovPhase{1,1},1),size(AllMovPhase{1,1},2));
NumEvents.Saline = [];
NumEvents.MTZL = [];

for nn = 1:num-1
    
    switch Type{nn}
        case 'METHIMAZOLE'
            Breath.MTZL = [Breath.MTZL,AllBreath{nn,chan}'];
            Mov.MTZL = [Mov.MTZL,AllMov{nn,chan}'];
            BreathMean.MTZL = [BreathMean.MTZL;nanmean(AllBreath{nn,chan})];
            temp = AllMovPhase{nn,chan}; temp = temp./sum(sum(AllMovPhase{nn,chan}));
            BreathPhase.MTZL = BreathPhase.MTZL+temp;
            NumEvents.MTZL = [NumEvents.MTZL,NumEpisodes{nn,chan}(5,:)./EpisodeDur{nn,chan}];
            
        otherwise
            Mov.Saline = [Mov.Saline,AllMov{nn,chan}'];
            Breath.Saline = [Breath.Saline,AllBreath{nn,chan}'];
            BreathMean.Saline = [BreathMean.Saline;nanmean(AllBreath{nn,chan})];
            temp = AllMovPhase{nn,chan}; temp = temp./sum(sum(AllMovPhase{nn,chan}));
            BreathPhase.Saline = BreathPhase.Saline+temp;
            NumEvents.Saline = [NumEvents.Saline,NumEpisodes{nn,chan}(5,:)./EpisodeDur{nn,chan}];
            
    end
    
end

clf
subplot(2,2,1)
shadedErrorBar([-3:1/1250:3],runmean(nanmean(BreathMean.MTZL),50),runmean(stdError(BreathMean.MTZL),50),'r')
hold on
shadedErrorBar([-3:1/1250:3],runmean(nanmean(BreathMean.Saline),50),runmean(stdError(BreathMean.Saline),50))
xlabel('Time to movement (s)')
ylabel('Breathing phase (rad)')
ylim([2 4.5])
xlim([-3 3])
box off
set(gca,'FontSize',20,'Linewidth',2)

subplot(2,2,2)
MakeSpreadAndBoxPlot_SB({NumEvents.Saline*1600,NumEvents.MTZL*1600},{[0.8 0.8 0.8],[1 0.4 0.4]},[1 2],{'CTRL','MTZL'})
ylabel('Events per hour')
[p,h] = ranksum(NumEvents.Saline,NumEvents.MTZL);
H = sigstar({{1,2}},p);set(H(2),'FontSize',20)
ylim([0 60])


subplot(2,2,3)
BreathPhase.Saline(:,1) = [];
BreathPhase.Saline(:,end) = [];
imagesc([-5:1/1250:5],[0:0.1:2*pi],BreathPhase.Saline')
clim([0.0004 0.001])
xlim([-3 3])
set(gca,'FontSize',20,'Linewidth',2)
ylabel('Phase (rad)')
box off
set(gca,'FontSize',20,'Linewidth',2)
xlabel('Time to movement (s)')
title('SAL')

subplot(2,2,4)
BreathPhase.MTZL(:,1) = [];
BreathPhase.MTZL(:,end) = [];
imagesc([-5:1/1250:5],[0:0.1:2*pi],BreathPhase.MTZL')
clim([0.0004 0.001])
xlim([-3 3])
set(gca,'FontSize',20,'Linewidth',2)
ylabel('Phase (rad)')
box off
set(gca,'FontSize',20,'Linewidth',2)
xlabel('Time to movement (s)')
title('MTZL')



clf
chan = 1
Mov.Saline = [];
Mov.MTZL = [];
Breath.Saline = [];
Breath.MTZL = [];
BreathMean.Saline = [];
BreathMean.MTZL = [];
BreathPhase.Saline = zeros(size(AllMovPhase{1,1},1),size(AllMovPhase{1,1},2));
BreathPhase.MTZL = zeros(size(AllMovPhase{1,1},1),size(AllMovPhase{1,1},2));
NumEvents.Saline = [];
NumEvents.MTZL = [];

for nn = 1:num-1
    
    switch Type{nn}
        case 'METHIMAZOLE'
            
            for sec = 1:10
                val(sec) = NumEpisodes{nn,chan}(sec,:)./EpisodeDur{nn,chan};
            end
            
            NumEvents.MTZL = [NumEvents.MTZL;val];
            
        otherwise
            for sec = 1:10
                val(sec) = NumEpisodes{nn,chan}(sec,:)./EpisodeDur{nn,chan};
            end
            
            NumEvents.Saline = [NumEvents.Saline;val];
            
    end
    
end
plot(NumEvents.MTZL','r')
hold on
plot(NumEvents.Saline','k')

