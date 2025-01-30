function [maps,data,stats,maps2,data2,stats2]=CompareRipplesTwoEpochs(LFP,Epoch1,Epoch2)

paramRip=[3 5];

FilRip=FilterLFP(Restrict(LFP,Epoch1),[130 200],512);
rgFil=Range(FilRip,'s');
filtered=[rgFil-rgFil(1) Data(FilRip)];
[ripples,stdev,noise] = FindRipples(filtered,'thresholds',paramRip);

FilRip2=FilterLFP(Restrict(LFP,Epoch2),[130 200],512);
rgFil2=Range(FilRip2,'s');
filtered2=[rgFil2-rgFil2(1) Data(FilRip2)];
[ripples2,stdev2,noise2] = FindRipples(filtered2,'thresholds',paramRip);



[maps,data,stats] = RippleStats(filtered,ripples);
PlotRippleStats(ripples,maps,data,stats);


[maps2,data2,stats2] = RippleStats(filtered2,ripples2);
PlotRippleStats(ripples2,maps2,data2,stats2);

figure;PlotDistribution2({data.peakAmplitude data2.peakAmplitude},{data.peakFrequency data2.peakFrequency});
legend('Epoch1','Epoch2');xlabel('Amplitude');ylabel('Frequency');
%DBInsertFigure(gcf,'SPWR-Sleep-008-20070425-01','frequency-amplitude-post','Ripple frequency and amplitude, before and after stimulations','channel 14',{'PlotDistribution2'});
figure;PlotDistribution2({data.duration data2.duration},{data.peakFrequency data2.peakFrequency});
legend('Epoch1','Epoch2');xlabel('Duration');ylabel('Frequency');
%DBInsertFigure(gcf,'SPWR-Sleep-008-20070425-01','frequency-duration-post','Ripple frequency and duration, before and after stimulations','channel 14',{'PlotDistribution2'});
