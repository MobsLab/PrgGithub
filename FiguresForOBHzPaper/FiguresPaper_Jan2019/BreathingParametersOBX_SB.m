% 'SoundHab' 'SoundCond' 'SoundTest' 'SoundTestPlethysmo'
clear all

Dir=PathForExperimentFEAR('ManipDec14Bulbectomie');
Dir=RestrictPathForExperiment(Dir,'Session','EXT-Pleth-pleth');

for d = 1:length(Dir.path)
    clf
    clear FreezeEpoch
    cd(Dir.path{d})
    disp(Dir.path{d})
    load('LFPData/InfoLFP.mat')
    
    channel = InfoLFP.channel(find(~cellfun(@isempty,strfind(InfoLFP.structure,'respi'))));
    load(['LFPData/LFP',num2str(channel),'.mat'])
    MouseGroup{d} = Dir.group{d};
    
    try, load('Behavior.mat');catch,load('behavResources.mat'); end
    FreezeEpoch = mergeCloseIntervals(FreezeEpoch,2*1e4);
    FreezeEpoch = dropShortIntervals(FreezeEpoch,2*1e4);
    
    FilLFP=FilterLFP((LFP),[1 30],1024);
    load('BreathingInfo.mat')
    [M,T] = PlotRipRaw(FilLFP,Range(Restrict(Breathtsd,FreezeEpoch),'s'),1000,0,0);
    try, BreathShapeFz(d,:) = M(:,2);
    catch
        BreathShapeFz(d,:) = nan(1,2501);
    end
    
    TidVolFz(d,:) = nanmean(Data(Restrict(TidalVolumtsd,FreezeEpoch)));
    BreathingFrezFz(d,:) = nanmean(Data(Restrict(Frequecytsd,FreezeEpoch)));
    TotEpoch = intervalSet(0,max(Range(Movtsd)));
    TotEpoch = TotEpoch-BreathNoiseEpoch
    [M,T] = PlotRipRaw(FilLFP,Range(Restrict(Breathtsd,TotEpoch - FreezeEpoch),'s'),1000,0,0);
    BreathShapeNoFz(d,:) = M(:,2);
    TidVolNoFz(d,:) = nanmean(Data(Restrict(TidalVolumtsd,TotEpoch - FreezeEpoch)));
    BreathingFrezNoFz(d,:) = nanmean(Data(Restrict(Frequecytsd,TotEpoch - FreezeEpoch)));
    
    BadBreathingDetecttion = thresholdIntervals(Frequecytsd,0.5,'Direction','Below');
    Frequecytsd = Restrict(Frequecytsd,TotEpoch-BadBreathingDetecttion);
    
    [Y,X] = hist(Data(Frequecytsd),[0:0.1:15]);
    BreathDistrib_All(d,:) = Y/sum(Y);
    
    [Y,X] = hist(Data(Restrict(Frequecytsd,FreezeEpoch)),[0:0.1:15]);
    BreathDistrib_Fz(d,:) = Y/sum(Y);
    
    [Y,X] = hist(Data(Restrict(Frequecytsd,TotEpoch - FreezeEpoch)),[0:0.1:15]);
    BreathDistrib_NoFz(d,:) =  Y/sum(Y);
    
    load('Respi_Low_Spectrum.mat')
    sptsd=tsd(Spectro{2}*1e4,(Spectro{1}));
    LowFreqBand = tsd(Spectro{2}*1e4,nanmean(Spectro{1}(:,1:10)')');
    NoisyEpoch = thresholdIntervals(LowFreqBand,prctile(Data(LowFreqBand),90),'Direction','Above');
    TotEpoch = TotEpoch-NoisyEpoch;
    Spectro_All(d,:) =mean(Data(Restrict(sptsd,TotEpoch)));
    Spectro_All_Fz(d,:) = mean(Data(Restrict(sptsd,FreezeEpoch)));
    Spectro_NoFz(d,:) = mean(Data(Restrict(sptsd,TotEpoch - FreezeEpoch)));
    
    
end

obxmice = find(~cellfun(@isempty,strfind(Dir.group,'OBX')));
shammice = find(~cellfun(@isempty,strfind(Dir.group,'CTRL')));shammice(2) = [];
Colors_Boxplot = [[0.8 0.8 0.8];[1 0.4 0.4]]

% distibution breaths
figure
subplot(121)
stairs([0:0.1:15],nanmean(BreathDistrib_NoFz(shammice,:)),'color',Colors_Boxplot(1,:)*0.8,'linewidth',1.5), hold on
stairs([0:0.1:15],nanmean(BreathDistrib_NoFz(obxmice,:)),'color',Colors_Boxplot(2,:)*0.8,'linewidth',1.5), hold on
subplot(122)
stairs([0:0.1:15],nanmean(BreathDistrib_Fz(shammice,:)),'color',Colors_Boxplot(1,:)*0.8,'linewidth',1.5), hold on
stairs([0:0.1:15],nanmean(BreathDistrib_Fz(obxmice,:)),'color',Colors_Boxplot(2,:)*0.8,'linewidth',1.5), hold on

% tidal volume
Vals = {TidVolFz(shammice),TidVolFz(obxmice),TidVolNoFz(shammice),TidVolNoFz(obxmice)};
Legends = {'Sham','OBX','Sham','OBX'};
X = [1 2 4 5];
Cols = {[0.8 0.8 0.8],[0.8 0.8 0.8],[1 0.4 0.4],[1 0.4 0.4]}
figure
MakeSpreadAndBoxPlot_SB(Vals,Cols,X,Legends)
ylabel('Tidal volume')

% shape
figure
subplot(121)
[hl,hp]=boundedline(M(:,1),nanmean(BreathShapeFz(shammice,:)),stdError(BreathShapeFz(shammice,:)),'alpha','g','transparency',0.2);hold on
set(hl,'Color',Cols{1}*0.7,'linewidth',2)
set(hp,'FaceColor',Cols{1})
[hl,hp]=boundedline(M(:,1),nanmean(BreathShapeFz(obxmice,:)),stdError(BreathShapeFz(obxmice,:)),'alpha','b','transparency',0.2);
set(hl,'Color',Cols{3}*0.7,'linewidth',2)
set(hp,'FaceColor',Cols{3})
title(' Fz')
xlabel('Time to breath (s)')
ylabel('uVolts (from plethysmo)')
xlim([-0.5 0.5])
subplot(122)
[hl,hp]=boundedline(M(:,1),nanmean(BreathShapeNoFz(shammice,:)),stdError(BreathShapeNoFz(shammice,:)),'alpha','g','transparency',0.2);hold on
set(hl,'Color',Cols{1}*0.7,'linewidth',2)
set(hp,'FaceColor',Cols{1})
[hl,hp]=boundedline(M(:,1),nanmean(BreathShapeNoFz(obxmice,:)),stdError(BreathShapeNoFz(obxmice,:)),'alpha','b','transparency',0.2);
set(hl,'Color',Cols{3}*0.7,'linewidth',2)
set(hp,'FaceColor',Cols{3})
title('No Fz')
xlabel('Time to breath (s)')
xlim([-0.5 0.5])
ylabel('uVolts (from plethysmo)')


PlotErrorBarN_KJ({TidVolFz(shammice),TidVolFz(obxmice)},'newfig',0,'paired',0)


Colors_Boxplot = [0.6,1,0.6;0.6,0.6,1];

figure
subplot(311)
plot([-5 -4],[-5 -4],'color',Colors_Boxplot(1,:)*0.8,'linewidth',1.5),hold on
plot([-5 -4],[-5 -4],'color',Colors_Boxplot(2,:)*0.8,'linewidth',1.5)
for k = 1:length(shammice)
    stairs([0:0.1:15],BreathDistrib_All(shammice(k),:),'color',Colors_Boxplot(1,:)*0.8,'linewidth',1.5), hold on
end
for k = 1:length(obxmice)
    stairs([0:0.1:15],BreathDistrib_All(obxmice(k),:),'color',Colors_Boxplot(2,:)*0.8,'linewidth',1.5), hold on
end
xlim([0 15])
xlabel('Frequency (Hz)')
ylabel('counts')
title('Whole session')
legend('SHAM','BBX')
box off
set(gca,'Linewidth',1.5,'FontSize',12)
subplot(312)
for k = 1:length(shammice)
    stairs([0:0.1:15],BreathDistrib_Fz(shammice(k),:),'color',Colors_Boxplot(1,:)*0.8,'linewidth',1.5), hold on
end
for k = 1:length(obxmice)
    stairs([0:0.1:15],BreathDistrib_Fz(obxmice(k),:),'color',Colors_Boxplot(2,:)*0.8,'linewidth',1.5), hold on
end

xlabel('Frequency (Hz)')
ylabel('counts')
title('Freezing')
box off
set(gca,'Linewidth',1.5,'FontSize',12)

subplot(313)
for k = 1:length(shammice)
    stairs([0:0.1:15],BreathDistrib_NoFz(shammice(k),:),'color',Colors_Boxplot(1,:)*0.8,'linewidth',1.5), hold on
end
for k = 1:length(obxmice)
    stairs([0:0.1:15],BreathDistrib_NoFz(obxmice(k),:),'color',Colors_Boxplot(2,:)*0.8,'linewidth',1.5), hold on
end

xlabel('Frequency (Hz)')
ylabel('counts')
title('Active')
box off
set(gca,'Linewidth',1.5,'FontSize',12)

figure
subplot(121)
stairs([0:0.1:15],nanmean(BreathDistrib_NoFz(shammice,:)),'color',Colors_Boxplot(1,:)*0.8,'linewidth',1.5), hold on
stairs([0:0.1:15],nanmean(BreathDistrib_NoFz(obxmice,:)),'color',Colors_Boxplot(2,:)*0.8,'linewidth',1.5), hold on
subplot(122)
stairs([0:0.1:15],nanmean(BreathDistrib_Fz(shammice,:)),'color',Colors_Boxplot(1,:)*0.8,'linewidth',1.5), hold on
stairs([0:0.1:15],nanmean(BreathDistrib_Fz(obxmice,:)),'color',Colors_Boxplot(2,:)*0.8,'linewidth',1.5), hold on


figure
plot([-5 -4],[-5 -4],'color',Colors_Boxplot(1,:)*0.8,'linewidth',1.5),hold on
plot([-5 -4],[-5 -4],'color',Colors_Boxplot(2,:)*0.8,'linewidth',1.5)
plot(Spectro{3},log(Spectro_All(shammice,:)),'color',Colors_Boxplot(1,:)*0.8,'linewidth',1.5), hold on
plot(Spectro{3},log(Spectro_All(obxmice,:)),'color',Colors_Boxplot(2,:)*0.8,'linewidth',1.5)
xlabel('Frequency (Hz)')
ylabel('Power')
title('Whole session')
legend('SAL','MTZL')
box off
set(gca,'Linewidth',1.5,'FontSize',12)
xlim([0 20])

figure
subplot(3,2,1)
PlotErrorBarN_KJ({TidVolFz(shammice),TidVolFz(obxmice)},'newfig',0,'paired',0)
title('Fz')
ylabel('Tidal vol')
set(gca,'XTick',[1:2],'XTickLabel',{'SHAM','OBX'})
subplot(3,2,2)
PlotErrorBarN_KJ({TidVolNoFz(shammice),TidVolNoFz(obxmice)},'newfig',0,'paired',0)
title('NoFz')
ylabel('Tidal vol')
set(gca,'XTick',[1:2],'XTickLabel',{'SHAM','OBX'})
subplot(3,2,3)
PlotErrorBarN_KJ({BreathingFrezFz(shammice),BreathingFrezFz(obxmice)},'newfig',0,'paired',0)
title('Fz')
ylabel('Breath Freq (Hz)')
set(gca,'XTick',[1:2],'XTickLabel',{'SHAM','OBX'})
subplot(3,2,4)
PlotErrorBarN_KJ({BreathingFrezNoFz(shammice),BreathingFrezNoFz(obxmice)},'newfig',0,'paired',0)
title('NoFz')
ylabel('Breath Freq (Hz)')
set(gca,'XTick',[1:2],'XTickLabel',{'SHAM','OBX'})
subplot(3,2,5)
[hl,hp]=boundedline(M(:,1),nanmean(BreathShapeFz(shammice,:)),stdError(BreathShapeFz(shammice,:)),'alpha','g','transparency',0.2);hold on
[hl,hp]=boundedline(M(:,1),nanmean(BreathShapeFz(obxmice,:)),stdError(BreathShapeFz(obxmice,:)),'alpha','b','transparency',0.2);
title(' Fz')
xlabel('Time to breath (s)')
ylabel('uVolts (from plethysmo)')
xlim([-0.5 0.5])
subplot(3,2,6)
[hl,hp]=boundedline(M(:,1),nanmean(BreathShapeNoFz(shammice,:)),stdError(BreathShapeNoFz(shammice,:)),'alpha','g','transparency',0.2);hold on
[hl,hp]=boundedline(M(:,1),nanmean(BreathShapeNoFz(obxmice,:)),stdError(BreathShapeNoFz(obxmice,:)),'alpha','b','transparency',0.2);
title('No Fz')
xlabel('Time to breath (s)')
xlim([-0.5 0.5])
ylabel('uVolts (from plethysmo)')


%%%
%
%
%
%
% for d = 2:length(Dir.path)
%     clf
%     cd(Dir.path{d})
%     disp(Dir.path{d})
%     load('LFPData/InfoLFP.mat')
%
%     channel = InfoLFP.channel(find(~cellfun(@isempty,strfind(InfoLFP.structure,'respi'))));
%     mkdir('ChannelsToAnalyse')
%     save('ChannelsToAnalyse/Respi.mat','channel')
%
%     load(['LFPData/LFP',num2str(channel),'.mat'])
%     FilLFP=FilterLFP((LFP),[1 30],1024);
%
%     % Breathing Noise
%     BreathNoiseEpoch=thresholdIntervals(FilLFP,3000);
%     BreathNoiseEpoch=mergeCloseIntervals(BreathNoiseEpoch,5*1e4);
%     BreathNoiseEpoch2=thresholdIntervals(FilLFP,-3000,'Direction','Below');
%     BreathNoiseEpoch2=mergeCloseIntervals(BreathNoiseEpoch2,5*1e4);
%     BreathNoiseEpoch=or(BreathNoiseEpoch,BreathNoiseEpoch2);
%
%     % Get Breathing Frequency
%     zr = hilbert(-Data(FilLFP));
%     phzr = atan2(imag(zr), real(zr));
%     phzr(phzr < 0) = phzr(phzr < 0) + 2 * pi;
%     phaseTsd = tsd(Range(FilLFP), phzr);
%     Ep=thresholdIntervals(phaseTsd,0.1,'Direction','Below');
%     % this parameter used to be 40 by default but if breathing parameters
%     % are too different it needs to be adjusted
%     Ep2=thresholdIntervals(FilLFP,-40,'Direction','Below');
%     Ep=and(Ep,Ep2);
%     Ep=mergeCloseIntervals(Ep,0.05*1e4);
%     BreathTimes=Start(Ep,'s');
%     Breathtsd=ts(BreathTimes*1e4);
%     FrequencyVal=1./diff(BreathTimes);
%     FrequencyTime=BreathTimes(1:end-1);
%     FreqInt=interp1(FrequencyTime,FrequencyVal,[min(FrequencyTime):0.05:max(FrequencyTime)]);
%     Frequecytsd=tsd([min(FrequencyTime):0.05:max(FrequencyTime)]*1e4,FreqInt');
%
%     % Calculate tidal volume
%     % integer between two zerocross
%     for ii=2:length(BreathTimes)-1
%         try
%             LitEp=intervalSet(max(BreathTimes(ii)*1e4-1*1e4,0),BreathTimes(ii)*1e4);
%             LitDat=Data(Restrict(FilLFP,LitEp));
%             LitTps=Range(Restrict(FilLFP,LitEp));
%             Strtime=LitTps(find(LitDat>0,1,'last'));
%             LitEp=intervalSet(BreathTimes(ii)*1e4,BreathTimes(ii)*1e4+1*1e4);
%             LitDat=Data(Restrict(FilLFP,LitEp));
%             LitTps=Range(Restrict(FilLFP,LitEp));
%             Stptime=LitTps(find(LitDat>0,1,'first'));
%             IntegerBetwZC(ii)=-trapz(Data(Restrict(FilLFP,intervalSet(Strtime,Stptime))));
%         catch
%             IntegerBetwZC(ii)=NaN;
%         end
%     end
%
%     TidalVal=IntegerBetwZC(2:end);
%     TidTime=BreathTimes(2:end-1)';
%     TidInt=interp1(TidTime,TidalVal,[min(FrequencyTime):0.05:max(FrequencyTime)]);
%     TidalVolumtsd=tsd([min(FrequencyTime):0.05:max(FrequencyTime)]*1e4,TidInt');
%     fig=figure(4);
%     subplot(411)
% %     imagesc(Spectro{2},Spectro{3},log(Spectro{1}')), axis xy
%     hold on
%     [hl,hp]=boundedline(Range(Frequecytsd,'s'),runmean(Data(Frequecytsd),10),ones(2,length(Data(Frequecytsd)))','alpha','k','transparency',0.2);
%     delete(hl)
%     subplot(412)
%     plot(Range(TidalVolumtsd,'s'),Data(TidalVolumtsd))
%     ylim([0 3e4])
%     subplot(413)
%     plot(Range(FilLFP,'s'),Data(FilLFP),'k'), hold on
%     plot(Range(Restrict(FilLFP,Ep),'s'),Data(Restrict(FilLFP,Ep)),'r')
%     line([Range((Breathtsd),'s') Range((Breathtsd),'s')]',[Range((Breathtsd),'s')*0+min(ylim) Range((Breathtsd),'s')*0+max(ylim)]'),'k'
%     xlim([0 20]+800)
%     ylim([-500 500])
%     subplot(414)
%     plot(Range(FilLFP,'s'),Data(FilLFP),'k'), hold on
%     plot(Range(Restrict(FilLFP,BreathNoiseEpoch),'s'),Data(Restrict(FilLFP,BreathNoiseEpoch)),'r')
%     ylim([-1e3 1e3])
%     %     pause
%     saveas(fig,'BreathingAnalysis.png')
%     clf
%     save('BreathingInfo.mat','Frequecytsd','Breathtsd','TidalVolumtsd','BreathNoiseEpoch')
%     clear Frequecytsd Breathtsd TidalVolumtsd IntegerBetwZC TidalVal TidTime TidInt FrequencyVal FrequencyTime FreqInt FilLFP BreathTimes BreathNoiseEpoch BreathNoiseEpoch2
% end