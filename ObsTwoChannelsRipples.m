
function [M1,M2,maps,data,stats,maps2,data2,stats2,maps2b,data2b,stats2b,ripEvt,ripEvt2,ripples,ripples2]=ObsTwoChannelsRipples(LFP,v,Epoch,v2,vnoise)

paramRip=[3 5];

det=0;


try
    vnoise;
catch
    vnoise=0;
end


if vnoise==0

    FilRip=FilterLFP(Restrict(LFP{v},Epoch),[130 200],96);
    rgFil=Range(FilRip,'s');
    %keyboard
    filtered=[rgFil-rgFil(1) Data(FilRip)];
    %filtered=[Range(FilRip,'s') Data(FilRip)];
    [ripples,stdev,noise] = FindRipples(filtered,'thresholds',paramRip);

else

    NoiseRip=FilterLFP(Restrict(LFP{vnoise},Epoch),[130 200],96);
    rgNoise=Range(NoiseRip,'s');
    filteredNoise=[rgNoise-rgNoise(1) Data(NoiseRip)];

    FilRip=FilterLFP(Restrict(LFP{v},Epoch),[130 200],96);
    rgFil=Range(FilRip,'s');
    filtered=[rgFil-rgFil(1) Data(FilRip)];

    [ripples,stdev,noise] = FindRipples(filtered,'thresholds',paramRip,'noise',filteredNoise);

end

[maps,data,stats] = RippleStats(filtered,ripples);
PlotRippleStats(ripples,maps,data,stats)

%----------------------------------------------------------------------------------------------


if vnoise==0
    
    FilRip2=FilterLFP(Restrict(LFP{v2},Epoch),[130 200],96);
    rgFil2=Range(FilRip2,'s');
    filtered2=[rgFil2-rgFil2(1) Data(FilRip2)];
    [ripples2,stdev2,noise2] = FindRipples(filtered2,'thresholds',paramRip);
    
else  

    FilRip2=FilterLFP(Restrict(LFP{v2},Epoch),[130 200],96);
    rgFil2=Range(FilRip2,'s');
    filtered2=[rgFil2-rgFil2(1) Data(FilRip2)];
    [ripples2,stdev2,noise2] = FindRipples(filtered2,'thresholds',paramRip,'noise',filteredNoise);
    
end


 
 
%filtered=[Range(FilRip,'s') Data(FilRip)];


[maps2,data2,stats2] = RippleStats(filtered2,ripples2);
PlotRippleStats(ripples2,maps2,data2,stats2)

[maps2b,data2b,stats2b] = RippleStats(filtered2,ripples);
PlotRippleStats(ripples,maps2b,data2b,stats2b)


%----------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------


% Pre-post comparison
figure;PlotDistribution2({data.peakAmplitude data2.peakAmplitude},{data.peakFrequency data2.peakFrequency});
legend(num2str(v),num2str(v2));xlabel('Amplitude');ylabel('Frequency');
%DBInsertFigure(gcf,'SPWR-Sleep-008-20070425-01','frequency-amplitude-post','Ripple frequency and amplitude, before and after stimulations','channel 14',{'PlotDistribution2'});
figure;PlotDistribution2({data.duration data2.duration},{data.peakFrequency data2.peakFrequency});
legend(num2str(v),num2str(v2));xlabel('Duration');ylabel('Frequency');
%DBInsertFigure(gcf,'SPWR-Sleep-008-20070425-01','frequency-duration-post','Ripple frequency and duration, before and after stimulations','channel 14',{'PlotDistribution2'});


% Pre-post comparison
figure;PlotDistribution2({data.peakAmplitude data2b.peakAmplitude},{data.peakFrequency data2b.peakFrequency});
legend(num2str(v),[num2str(v2),'ripp',num2str(v)]);xlabel('Amplitude');ylabel('Frequency');
%DBInsertFigure(gcf,'SPWR-Sleep-008-20070425-01','frequency-amplitude-post','Ripple frequency and amplitude, before and after stimulations','channel 14',{'PlotDistribution2'});
figure;PlotDistribution2({data.duration data2b.duration},{data.peakFrequency data2b.peakFrequency});
legend(num2str(v),[num2str(v2),'ripp',num2str(v)]);xlabel('Duration');ylabel('Frequency');
%DBInsertFigure(gcf,'SPWR-Sleep-008-20070425-01','frequency-duration-post','Ripple frequency and duration, before and after stimulations','channel 14',{'PlotDistribution2'});



% Pre-post comparison
figure;PlotDistribution2({data2.peakAmplitude data2b.peakAmplitude},{data2.peakFrequency data2b.peakFrequency});
legend(num2str(v2),[num2str(v2),'ripp',num2str(v)]);xlabel('Amplitude');ylabel('Frequency');
%DBInsertFigure(gcf,'SPWR-Sleep-008-20070425-01','frequency-amplitude-post','Ripple frequency and amplitude, before and after stimulations','channel 14',{'PlotDistribution2'});
figure;PlotDistribution2({data2.duration data2b.duration},{data2.peakFrequency data2b.peakFrequency});
legend(num2str(v2),[num2str(v2),'ripp',num2str(v)]);xlabel('Duration');ylabel('Frequency');
%DBInsertFigure(gcf,'SPWR-Sleep-008-20070425-01','frequency-duration-post','Ripple frequency and duration, before and after stimulations','channel 14',{'PlotDistribution2'});




%----------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------




        FilRip2=FilterLFP(Restrict(LFP{v2},Epoch),[130 200],96);
        rgFil2=Range(FilRip2,'s');
        filtered2=[rgFil2-rgFil2(1) Data(FilRip2)];
        
        
        
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
        rgg3=Range(Restrict(FilRip2,subset(ripEvt,k)),'s');
        hold on, plot(rgg3-rgg3(1),5*Data(Restrict(FilRip2,subset(ripEvt,k))),'b','linewidth',2)
        rgg4=Range(Restrict(LFP{v2},subset(ripEvt,k)),'s');
        plot(rgg4-rgg4(1),Data(Restrict(LFP{v2},subset(ripEvt,k))),'k','linewidth',3)
        pause(1)

    end
  
end



 ripEvt=intervalSet((ripples(:,2)+rgFil(1)-0.1)*1E4,(ripples(:,2)+rgFil(1)+0.1)*1E4);
 ripEvt2=intervalSet((ripples2(:,2)+rgFil2(1)-0.1)*1E4,(ripples2(:,2)+rgFil2(1)+0.1)*1E4);

 
 %ripples(:,1:3)=ripples(:,1:3)+rgFil(1);
 %ripples2(:,1:3)=ripples2(:,1:3)+rgFil2(1);
 
    M1=PlotRipRaw(LFP{v},ripples);
    M2=PlotRipRaw(LFP{v2},ripples);
    
    
    
    
    