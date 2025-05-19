clear all
Dir.path{1} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAstro_Mouse242_20150509_EXT+24h-envB_BULB-Mouse-242-09052015\BULB-Mouse-242-09052015';
Dir.path{2} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse248_20150326-EXT-24h-envC\20150326-EXT-24h-envC';
Dir.path{3} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse244_20150506-EXT-24h-envC\20150506-EXT-24h-envC';
Dir.path{4} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse244_20150507-EXT-24h-envB\20150507-EXT-24h-envB';
Dir.path{5} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse243_20150506-EXT-24h-envC\20150506-EXT-24h-envC';
Dir.path{6} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse243_20150507-EXT-24h-envB\20150507-EXT-24h-envB';
Dir.path{7} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse253_20150703-EXT-24h-envC_FEAR-Mouse-253-03072015\FEAR-Mouse-253-03072015';
Dir.path{8} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse254_20150703-EXT-24h-envC\20150703-EXT-24h-envC';
Dir.path{9} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse258_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
Dir.path{10} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse259_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
Dir.path{11} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse299_20151217-EXT-24h-envC\20151217-EXT-24h-envC';
Dir.path{12} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse394_FEAR-Mouse-394-EXT-24-envBraye_161020_163239_\FEAR-Mouse-394-EXT-24-envBraye_161020_163239';
Dir.path{13} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse395_FEAR-Mouse-395-EXT-24-envBraye_161020_155350_\FEAR-Mouse-395-EXT-24-envBraye_161020_155350';
Dir.path{14} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse402_FEAR-Mouse-402-EXT-24-envB_raye_161026_164106_\FEAR-Mouse-402-EXT-24-envB_raye_161026_164106';
Dir.path{15} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse403_FEAR-Mouse-403-EXT-24-envB_raye_161026_171611_\FEAR-Mouse-403-EXT-24-envB_raye_161026_171611';
Dir.path{16} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse450_FEAR-Mouse-450-EXT-24-envB_161026_174952_\FEAR-Mouse-450-EXT-24-envB_161026_174952';
Dir.path{17} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse451_FEAR-Mouse-451-EXT-24-envB_161026_182307_\FEAR-Mouse-451-EXT-24-envB_161026_182307';

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
        
        PhaseDat = (Restrict(PhaseInterpol,FreezeEpoch));
        
        for lg = 1:min([floor((length(PhaseDat)/1250)/2),20])
            PhaseDattemp = Data(PhaseDat);
            PhaseDattemp = tsd([1:1250*2*lg]/(1250*1E-4),PhaseDattemp(1:1250*2*lg));
            
            for f = 1:length(Freq)
                
                for ph = 1:length(PhaseShift)
                    phzr = PhFinal{f}{ph}(1:length(Data(PhaseDattemp)))';
                    
                    AllPhaseDiff = mod(phzr-Data(PhaseDattemp),2*pi);
                    
                    LightOnEp = thresholdIntervals(tsd(Range(PhaseDattemp),phzr),pi,'Direction','Above');
                    InPhaseEp = and(thresholdIntervals(PhaseDattemp,0.75*pi,'Direction','Above'),thresholdIntervals(PhaseDattemp,1.25*pi,'Direction','Below'));
                    
                    PercLightOn{d}{f}(ph,lg) = length(Data(Restrict(PhaseDattemp,and(LightOnEp,InPhaseEp))))./length(Data(Restrict(PhaseDattemp,LightOnEp)));
                    
                    PhaseTight{d}{f}(ph,lg) = sqrt(sum(cos(AllPhaseDiff)).^2+sum(sin(AllPhaseDiff)).^2)/length(AllPhaseDiff);
                    lg
                end
            end
        end
        
        
    end
        
end

for f = 1:length(Freq)
    PercLightOn_All{f} = [];
end
for f = 1:length(Freq)
    
    for d = 1:length(Dir.path)
        try
            if size(PercLightOn{d}{f},2)==20
                PercLightOn_All{f} = [PercLightOn_All{f};PercLightOn{d}{f}];
                
            end
        end
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


