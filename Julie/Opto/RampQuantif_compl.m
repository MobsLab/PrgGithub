% RampQuantif_compl.m
% 29.09.2016
% to average the figure produced by RampQuantif.m
cd /media/DataMobs31/OPTO_CHR2_DATA/Mouse-390/20160919-stim_opto-rampe/FEAR-Mouse-390-19092016
res=pwd;
load power_freq_ramp

[MedianFreqTSorted,IX]=sort(MedianFreqT);
[n,xout]=hist(MedianFreqT,[0:0.5:20]);

for i=1:length(structlist)
    Mfreq=[];
    Mpower=[];
    Spower=[];
    for k=1:(length(MedianFreqT)-1)
        Xoutk=(MedianFreqT>xout(k)&MedianFreqT<xout(k+1));
        Mfreq=[Mfreq;nanmean(MedianFreqT(Xoutk))];
        Mpower=[Mpower;nanmean(PowerInStimFqT(i,Xoutk))];
        Spower=[Spower;nanstd(PowerInStimFqT(i,Xoutk))];

    end
    MeanFreq{i,1}=Mfreq;
    MeanPower{i,1}=Mpower;
    StdPower{i,1}=Spower;
end
% figure, plot(Mfreq,Mpower,'*')
% hold on, plot(Mfreq(~isnan(Mpower)),Mpower(~isnan(Mpower)))
% figure,shadedErrorBar(Mfreq(~isnan(Mpower)),Mpower(~isnan(Mpower)),Spower(~isnan(Mpower)),'-r')
% 
% 


figure('Position',[2087 129  1223  758]), subplot(1,2,1),hold on
for i=1:length(structlist)
    plot(MeanFreq{i,1}(~isnan(Mpower)),MeanPower{i,1}(~isnan(Mpower)),'LineWidth',1,'Color', coloriT{i})
end

legend(structlist);
xlabel('stimulation frequencies'), ylabel('power')
title('raw values')

i=1;
shadedErrorBar(MeanFreq{i,1}(~isnan(Mpower)),MeanPower{i,1}(~isnan(Mpower)),StdPower{i,1}(~isnan(Mpower)),'-b',1)
i=2;
shadedErrorBar(MeanFreq{i,1}(~isnan(Mpower)),MeanPower{i,1}(~isnan(Mpower)),StdPower{i,1}(~isnan(Mpower)),'-r',1)
i=3;
shadedErrorBar(MeanFreq{i,1}(~isnan(Mpower)),MeanPower{i,1}(~isnan(Mpower)),StdPower{i,1}(~isnan(Mpower)),'-b',1)
i=4;
shadedErrorBar(MeanFreq{i,1}(~isnan(Mpower)),MeanPower{i,1}(~isnan(Mpower)),StdPower{i,1}(~isnan(Mpower)),'-r',1)
i=5;
shadedErrorBar(MeanFreq{i,1}(~isnan(Mpower)),MeanPower{i,1}(~isnan(Mpower)),StdPower{i,1}(~isnan(Mpower)),'-c',1)
i=6;
shadedErrorBar(MeanFreq{i,1}(~isnan(Mpower)),MeanPower{i,1}(~isnan(Mpower)),StdPower{i,1}(~isnan(Mpower)),'-g',1)
i=7;
shadedErrorBar(MeanFreq{i,1}(~isnan(Mpower)),MeanPower{i,1}(~isnan(Mpower)),StdPower{i,1}(~isnan(Mpower)),'-g',1)

for i=1:length(structlist)
    MeanPowerNorm{i,1}=MeanPower{i,1}/nanmax(MeanPower{i,1});
    StdPowerNorm{i,1}=StdPower{i,1}/nanmax(MeanPower{i,1});
end

 subplot(1,2,2),hold on
for i=1:length(structlist)
    plot(MeanFreq{i,1}(~isnan(Mpower)),MeanPowerNorm{i,1}(~isnan(Mpower)),'LineWidth',2,'Color', coloriT{i})
end


legend(structlist);
xlabel('stimulation frequencies'), ylabel('power')
title('normalized')

saveas(gcf,'Power_frequency_ramp_avg.fig')
saveFigure(gcf,'Power_frequency_ramp_avg',res)
i=1;
shadedErrorBar(MeanFreq{i,1}(~isnan(Mpower)),MeanPowerNorm{i,1}(~isnan(Mpower)),StdPowerNorm{i,1}(~isnan(Mpower)),'-b',1)
i=2;
shadedErrorBar(MeanFreq{i,1}(~isnan(Mpower)),MeanPowerNorm{i,1}(~isnan(Mpower)),StdPowerNorm{i,1}(~isnan(Mpower)),'-r',1)
i=3;
shadedErrorBar(MeanFreq{i,1}(~isnan(Mpower)),MeanPowerNorm{i,1}(~isnan(Mpower)),StdPowerNorm{i,1}(~isnan(Mpower)),'-b',1)
i=4;
shadedErrorBar(MeanFreq{i,1}(~isnan(Mpower)),MeanPowerNorm{i,1}(~isnan(Mpower)),StdPowerNorm{i,1}(~isnan(Mpower)),'-r',1)
i=5;
shadedErrorBar(MeanFreq{i,1}(~isnan(Mpower)),MeanPowerNorm{i,1}(~isnan(Mpower)),StdPowerNorm{i,1}(~isnan(Mpower)),'-c',1)
i=6;
shadedErrorBar(MeanFreq{i,1}(~isnan(Mpower)),MeanPowerNorm{i,1}(~isnan(Mpower)),StdPowerNorm{i,1}(~isnan(Mpower)),'-g',1)
i=7;
shadedErrorBar(MeanFreq{i,1}(~isnan(Mpower)),MeanPowerNorm{i,1}(~isnan(Mpower)),StdPowerNorm{i,1}(~isnan(Mpower)),'-g',1)
