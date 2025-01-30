

function [M1,M2,maps,da,stats,maps2,data2,stats2]=CompTwoEpochWithoutRipples(LFP,v,ripples,ripples2)


freqObs=[130 200];

det=0;
    FilRip=FilterLFP(LFP{v},freqObs,96);
    rgFil=Range(FilRip,'s');
    filtered=[rgFil-rgFil(1) Data(FilRip)];

[maps,da,stats] = RippleStats(filtered,ripples);

PlotRippleStats(ripples,maps,da,stats)

%----------------------------------------------------------------------------------------------

 

    FilRip2=FilterLFP(LFP{v},freqObs,96);
    rgFil2=Range(FilRip2,'s');
    filtered2=[rgFil2-rgFil2(1) Data(FilRip2)];
    


[maps2,data2,stats2] = RippleStats(filtered2,ripples2);
PlotRippleStats(ripples2,maps2,data2,stats2)

%----------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------


% Pre-post comparison
figure;PlotDistribution2({da.peakAmplitude data2.peakAmplitude},{da.peakFrequency data2.peakFrequency});
legend('Epoch1','Epoch2');xlabel('Amplitude');ylabel('Frequency');
title(['voie ',num2str(v)])
%DBInsertFigure(gcf,'SPWR-Sleep-008-20070425-01','frequency-amplitude-post','Ripple frequency and amplitude, before and after stimulations','channel 14',{'PlotDistribution2'});
figure;PlotDistribution2({da.duration data2.duration},{da.peakFrequency data2.peakFrequency});
legend('Epoch1','Epoch2');xlabel('Duration');ylabel('Frequency');
%DBInsertFigure(gcf,'SPWR-Sleep-008-20070425-01','frequency-duration-post','Ripple frequency and duration, before and after stimulations','channel 14',{'PlotDistribution2'});
title(['voie ',num2str(v)])

%----------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------



        
    M1=PlotRipRaw(LFP{v},ripples);title('Epoch1')
    M2=PlotRipRaw(LFP{v},ripples2);title('Epoch2')
    

if det==1
        figure('Color',[1 1 1]),
    num=gcf;
    %for k=40:60
     for k=1:length(Start(ripEvt))   
        %figure(num), clf
        figure('Color',[1 1 1]),
        subplot(2,1,1),
        rgg1=Range(Restrict(FilRip,subset(ripEvt,k)),'s');
        hold on, plot(rgg1-rgg1(1),5*Data(Restrict(FilRip,subset(ripEvt,k))),'r','linewidth',2)
        rgg2=Range(Restrict(LFP{v},subset(ripEvt,k)),'s');
        plot(rgg2-rgg2(1),Data(Restrict(LFP{v},subset(ripEvt,k))),'k','linewidth',3)
        title(num2str(k))

        subplot(2,1,2),
        rgg3=Range(Restrict(FilRip2,subset(ripEvt2,k)),'s');
        hold on, plot(rgg3-rgg3(1),5*Data(Restrict(FilRip2,subset(ripEvt2,k))),'b','linewidth',2)
        rgg4=Range(Restrict(LFP{v},subset(ripEvt2,k)),'s');
        plot(rgg4-rgg4(1),Data(Restrict(LFP{v},subset(ripEvt2,k))),'k','linewidth',3)
        pause(1)

    end
  
end




 

 
 