% 'SoundHab' 'SoundCond' 'SoundTest' 'SoundTestPlethysmo'
clear all
Sessions = {'SoundHab' ,'SoundTest', 'SoundTestPlethysmo'};

for ss = 3
    
    Dir=PathForExperimentsMtzlProject(Sessions{ss})
    
    for d = 1:length(Dir.path)
        clf
        cd(Dir.path{d}{1})
        disp(Dir.path{d}{1})
        clear FreezeEpoch FreezeAccEpoch
        load('behavResources.mat')
        if exist('FreezeAccEpoch','var')>0
            FreezeEpoch = FreezeAccEpoch;
        end
        load('LFPData/LFP32.mat')
        FilLFP=FilterLFP((LFP),[1 30],1024);
        load('BreathingInfo.mat')
        [M,T] = PlotRipRaw(FilLFP,Range(Restrict(Breathtsd,FreezeAccEpoch),'s'),1000,0,0);
        try, BreathShapeFz(d,:) = M(:,2);
        catch
            BreathShapeFz(d,:) = nan(1,2501);
        end
        
        TidVolFz(d,:) = nanmean(Data(Restrict(TidalVolumtsd,FreezeAccEpoch)));
        BreathingFrezFz(d,:) = nanmean(Data(Restrict(Frequecytsd,FreezeAccEpoch)));
        TotEpoch = intervalSet(0,max(Range(MovAcctsd)));
        TotEpoch = TotEpoch-BreathNoiseEpoch
        [M,T] = PlotRipRaw(FilLFP,Range(Restrict(Breathtsd,TotEpoch - FreezeAccEpoch),'s'),1000,0,0);
        BreathShapeNoFz(d,:) = M(:,2);
        TidVolNoFz(d,:) = nanmean(Data(Restrict(TidalVolumtsd,TotEpoch - FreezeAccEpoch)));
        BreathingFrezNoFz(d,:) = nanmean(Data(Restrict(Frequecytsd,TotEpoch - FreezeAccEpoch)));
        
        BadBreathingDetecttion = thresholdIntervals(Frequecytsd,0.5,'Direction','Below');
        Frequecytsd = Restrict(Frequecytsd,TotEpoch-BadBreathingDetecttion);
        
        [Y,X] = hist(Data(Frequecytsd),[0:0.1:15]);
        BreathDistrib_All(d,:) = Y/sum(Y);
        
        [Y,X] = hist(Data(Restrict(Frequecytsd,FreezeEpoch)),[0:0.1:15]);
        BreathDistrib_Fz(d,:) = Y/sum(Y);
        
        [Y,X] = hist(Data(Restrict(Frequecytsd,TotEpoch - FreezeEpoch)),[0:0.1:15]);
        BreathDistrib_NoFz(d,:) =  Y/sum(Y);
        
        BreathDistrib_All(d,:) = hist(Data(Frequecytsd),[0:0.1:15]);
        BreathDistrib_Fz(d,:) = hist(Data(Restrict(Frequecytsd,FreezeAccEpoch)),[0:0.1:15]);
        BreathDistrib_NoFz(d,:) = hist(Data(Restrict(Frequecytsd,TotEpoch - FreezeAccEpoch)),[0:0.1:15]);
        
        load('Respi_Low_Spectrum.mat')
        sptsd=tsd(Spectro{2}*1e4,(Spectro{1}));
        LowFreqBand = tsd(Spectro{2}*1e4,nanmean(Spectro{1}(:,1:10)')');
        NoisyEpoch = thresholdIntervals(LowFreqBand,prctile(Data(LowFreqBand),90),'Direction','Above');
        TotEpoch = TotEpoch-NoisyEpoch;
        Spectro_All(d,:) =mean(Data(Restrict(sptsd,TotEpoch)));
        Spectro_All_Fz(d,:) = mean(Data(Restrict(sptsd,FreezeAccEpoch)));
        Spectro_NoFz(d,:) = mean(Data(Restrict(sptsd,TotEpoch - FreezeAccEpoch)));
        
        
    end
end

obxmice = 6:10;
shammice = 1:5;
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

%%

Colors_Boxplot = [0.6,1,0.6;0.6,0.6,1];

figure
subplot(311)
plot([-5 -4],[-5 -4],'color',Colors_Boxplot(1,:)*0.8,'linewidth',1.5),hold on
plot([-5 -4],[-5 -4],'color',Colors_Boxplot(2,:)*0.8,'linewidth',1.5)
for k = 6:9
stairs([0:0.1:15],BreathDistrib_All(k,:),'color',Colors_Boxplot(1,:)*0.8,'linewidth',1.5), hold on
end
for k = 1:5
stairs([0:0.1:15],BreathDistrib_All(k,:),'color',Colors_Boxplot(2,:)*0.8,'linewidth',1.5), hold on
end
xlim([0 15])
xlabel('Frequency (Hz)')
ylabel('counts')
title('Whole session')
legend('SAL','MTZL')
box off
set(gca,'Linewidth',1.5,'FontSize',12)
subplot(312)
for k = 6:9
stairs([0:0.1:15],BreathDistrib_Fz(k,:),'color',Colors_Boxplot(1,:)*0.8,'linewidth',1.5), hold on
end
for k = 1:5
stairs([0:0.1:15],BreathDistrib_Fz(k,:),'color',Colors_Boxplot(2,:)*0.8,'linewidth',1.5), hold on
end
xlabel('Frequency (Hz)')
ylabel('counts')
title('Freezing')
box off
set(gca,'Linewidth',1.5,'FontSize',12)
subplot(313)
for k = 6:9
stairs([0:0.1:15],BreathDistrib_NoFz(k,:),'color',Colors_Boxplot(1,:)*0.8,'linewidth',1.5), hold on
end
for k = 1:5
stairs([0:0.1:15],BreathDistrib_NoFz(k,:),'color',Colors_Boxplot(2,:)*0.8,'linewidth',1.5), hold on
end
xlabel('Frequency (Hz)')
ylabel('counts')
title('Active')
box off
set(gca,'Linewidth',1.5,'FontSize',12)

figure
plot([-5 -4],[-5 -4],'color',Colors_Boxplot(1,:)*0.8,'linewidth',1.5),hold on
plot([-5 -4],[-5 -4],'color',Colors_Boxplot(2,:)*0.8,'linewidth',1.5)
plot(Spectro{3},log(Spectro_All(6:9,:)),'color',Colors_Boxplot(1,:)*0.8,'linewidth',1.5), hold on
plot(Spectro{3},log(Spectro_All(1:5,:)),'color',Colors_Boxplot(2,:)*0.8,'linewidth',1.5)
xlabel('Frequency (Hz)')
ylabel('Power')
title('Whole session')
legend('SAL','MTZL')
box off
set(gca,'Linewidth',1.5,'FontSize',12)
xlim([0 20])


figure
subplot(121)
stairs([0:0.1:15],nanmean(BreathDistrib_NoFz(1:5,:)),'color',Colors_Boxplot(1,:)*0.8,'linewidth',1.5), hold on
stairs([0:0.1:15],nanmean(BreathDistrib_NoFz(6:end,:)),'color',Colors_Boxplot(2,:)*0.8,'linewidth',1.5), hold on
subplot(122)
stairs([0:0.1:15],nanmean(BreathDistrib_Fz(1:5,:)),'color',Colors_Boxplot(1,:)*0.8,'linewidth',1.5), hold on
stairs([0:0.1:15],nanmean(BreathDistrib_Fz(6:end,:)),'color',Colors_Boxplot(2,:)*0.8,'linewidth',1.5), hold on

figure
subplot(3,2,1)
PlotErrorBarN_KJ([TidVolFz(6:end),TidVolFz(1:5)],'newfig',0,'paired',0)
title('Fz')
ylabel('Tidal vol')
set(gca,'XTick',[1:2],'XTickLabel',{'Sal','Mtzl'})
subplot(3,2,2)
PlotErrorBarN_KJ([TidVolNoFz(6:end),TidVolNoFz(1:5)],'newfig',0,'paired',0)
title('NoFz')
ylabel('Tidal vol')
set(gca,'XTick',[1:2],'XTickLabel',{'Sal','Mtzl'})
subplot(3,2,3)
PlotErrorBarN_KJ([BreathingFrezFz(6:end),BreathingFrezFz(1:5)],'newfig',0,'paired',0)
title('Fz')
ylabel('Breath Freq (Hz)')
set(gca,'XTick',[1:2],'XTickLabel',{'Sal','Mtzl'})
subplot(3,2,4)
PlotErrorBarN_KJ([BreathingFrezNoFz(6:end),BreathingFrezNoFz(1:5)],'newfig',0,'paired',0)
title('NoFz')
ylabel('Breath Freq (Hz)')
set(gca,'XTick',[1:2],'XTickLabel',{'Sal','Mtzl'})
subplot(3,2,5)
[hl,hp]=boundedline(M(:,1),nanmean(BreathShapeFz(6:9,:)),stdError(BreathShapeFz(6:9,:)),'alpha','g','transparency',0.2);hold on
[hl,hp]=boundedline(M(:,1),nanmean(BreathShapeFz(1:5,:)),stdError(BreathShapeFz(1:5,:)),'alpha','b','transparency',0.2);
title(' Fz')
xlabel('Time to breath (s)')
ylabel('uVolts (from plethysmo)')
xlim([-0.5 0.5])
subplot(3,2,6)
[hl,hp]=boundedline(M(:,1),nanmean(BreathShapeNoFz(6:9,:)),stdError(BreathShapeNoFz(6:9,:)),'alpha','g','transparency',0.2);hold on
[hl,hp]=boundedline(M(:,1),nanmean(BreathShapeNoFz(1:5,:)),stdError(BreathShapeNoFz(1:5,:)),'alpha','b','transparency',0.2);
title('No Fz')
xlabel('Time to breath (s)')
xlim([-0.5 0.5])
ylabel('uVolts (from plethysmo)')
