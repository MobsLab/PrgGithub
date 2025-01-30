clear all
[Dir,KeepFirstSessionOnly,CtrlEphys]=GetRightSessionsFor4HzPaper('CtrlAllData');
dt = 0.0008;
t = [0:dt:800];
PhaseShift = [0:pi/5:2*pi-pi/5];
Freq = [4,13];


for f = 1:length(Freq)
    
    for ph = 1:length(PhaseShift)
        
        Signal = sin(t*2*pi*Freq(f)+PhaseShift(ph));
        zr = hilbert(Signal);
        phzr = atan2(imag(zr), real(zr));
        phzr(phzr < 0) = phzr(phzr < 0) + 2 * pi;
        PhFinal{f}{ph} = phzr;
    end
end

for d = 1:length(Dir.path)
    try
        cd(Dir.path{d})
        disp(Dir.path{d})
        
        clear PhaseInterpol FreezeEpoch AllPeaks
        load('FilteredLFP/MiniMaxiLFPOB1.mat')
        load('behavResources.mat')
        Peaktsd  = tsd(AllPeaks(:,1)*1E4,AllPeaks(:,2));
        
        for k = 1:length(Start(FreezeEpoch))
            
            PhaseDat = (Restrict(PhaseInterpol,subset(FreezeEpoch,k)));
            
            FreezeDur{d}(k) = sum(Stop(subset(FreezeEpoch,k))-Start(subset(FreezeEpoch,k)));
            
            AvFreq{d}{f}(k) =  0.5*1E4*length(Data(Restrict(Peaktsd,(subset(FreezeEpoch,k)))))./FreezeDur{d}(k) ;
            
            for f = 1:length(Freq)
                
                for ph = 1:length(PhaseShift)
                    
                    phzr = PhFinal{f}{ph}(1:length(PhaseDat))';
                    
                    AllPhaseDiff = mod(phzr-Data(PhaseDat),2*pi);
                    
                    LightOnEp = thresholdIntervals(tsd(Range(PhaseDat),phzr),pi,'Direction','Above');
                    InPhaseEp = and(thresholdIntervals(PhaseDat,pi,'Direction','Above'),thresholdIntervals(PhaseDat,1.5*pi,'Direction','Below'));
                    
                    PercLightOn{d}{f}(ph,k) = length(Data(Restrict(PhaseDat,and(LightOnEp,InPhaseEp))))./length(Data(Restrict(PhaseDat,LightOnEp)));
                    
                    PercLightOnRand{d}{f}(ph,k) = length(Data(Restrict(PhaseDat,(InPhaseEp))))./length(Data((PhaseDat)));
                    
                    
                    
                    PhaseTight{d}{f}(ph,k) = sqrt(sum(cos(AllPhaseDiff)).^2+sum(sin(AllPhaseDiff)).^2)/length(AllPhaseDiff);
                    
                end
                
            end
            
        end
    catch
        disp('error')
        
    end
end

for f = 1:length(Freq)
    PhaseError{f} = [];
    PercLightOn_All{f} = [];
    PercLightOnRand_All{f} = [];
    EpDur{f} = [];
    Freq_All{f}= [];
end
FreezeLength = [3:3:60];

for d = 1:length(Dir.path)
    
    for f = 1:length(Freq)
        for k = 1:size(PercLightOn{d}{f},2)
            
            PhaseError{f} = [PhaseError{f},nanstd(PercLightOn{d}{f}(:,k))];
            PercLightOn_All{f} = [PercLightOn_All{f},nanmean(PercLightOn{d}{f}(:,k))];
            PercLightOnRand_All{f} = [PercLightOnRand_All{f},nanmean(PercLightOnRand{d}{f}(:,k))];
            Freq_All{f} = [Freq_All{f},AvFreq{d}{3}(k)];
            
            EpDur{f} = [EpDur{f},FreezeDur{d}(k)];

            
        end
        
    end
end




EpDurRg = logspace(0.5,2.2,15)*1E4;
clear  AvOver StdOver AvOverRand AvFreqVals
for e = 1:length(EpDurRg)-1
    for f = 1:length(Freq)
        
        AvOver(e,f) = nanmean(PercLightOn_All{f}(EpDur{f}>EpDurRg(e) & EpDur{f}<EpDurRg(e+1)));
        StdOver(e,f) = nanmean(PhaseError{f}(EpDur{f}>EpDurRg(e) & EpDur{f}<EpDurRg(e+1)));
        AvOverRand(e,f) = nanmean(PercLightOnRand_All{f}(EpDur{f}>EpDurRg(e) & EpDur{f}<EpDurRg(e+1)));
        AvFreqVals(e,f) = nanmean(Freq_All{f}(EpDur{f}>EpDurRg(e) & EpDur{f}<EpDurRg(e+1)));
    end
end

clf
for f = 1:3
    errorbar(EpDurRg(1:end-1)/1E4,AvOver(:,f),StdOver(:,f),'linewidth',3)
    hold on
end
line(xlim,[1 1]*0.23,'color','k','linewidth',3)
set(gca,'FontSize',12,'FontWeight','bold','linewidth',2), box off
xlabel('Duration of freezing episode (s)')
ylabel('% stims in phase')
ylim([0.1 0.4])
legend('4Hz','10Hz','13Hz','rand')



figure
subplot(211)
PlotErrorBarN_KJ(PercLightOn_All,'newfig',0,'showPoints',0)
line(xlim,[1 1]*0.237,'color','k','linewidth',3)
ylabel('% stims in phase')
subplot(212)
PlotErrorBarN_KJ(PhaseError,'newfig',0,'showPoints',0)
set(gca,'FontSize',12,'FontWeight','bold','linewidth',2,'XTick',[1:3],'XTickLabel',{'4Hz','10Hz','13Hz'}), box off
ylabel('std depending on initial phase')


