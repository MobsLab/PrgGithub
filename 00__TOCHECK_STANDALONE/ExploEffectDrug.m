%ExploEffectDrug


tic

%--------------------------------------------------------------------------
try
    PreviousSleepStage;
catch
    PreviousSleepStage=0;
end
ParamDetection=1.5; % plus grand que 2 -> plus slelectif sur les spindles / plus petit que 2 -> plus selectif sur le delta
%--------------------------------------------------------------------------



load('LFPData/InfoLFP.mat')

disp(' ')


try 
         channel;
    
catch
    
    disp('Choix automatique')
        if 0
                goodPfc=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
                goodDepth=InfoLFP.depth(strcmp(InfoLFP.structure,'PFCx'));

                try
                channel=goodPfc(find(goodDepth==-1));
                channel(1);
                catch
                    try
                        channel=goodPfc(find(goodDepth==0));
                        channel(1);
                    catch
                        channel=goodPfc(1);
                        disp('channel for Pfc not optimal ')
                    end
                end

        else

                load('ChannelsToAnalyse/PFCx_deep.mat')

        end

end

disp(['Channel for Pfc: ',num2str(channel)])
disp(' ')

eval(['load(''LFPData/LFP',num2str(channel),'.mat'')'])
eval(['load(''SpectrumDataL/Spectrum',num2str(channel),'.mat'')'])


%--------------------------------------------------------------------------

load behavResources
st2=Start(CPEpoch,'s');
st1=Start(VEHEpoch,'s');

load StateEpoch SWSEpoch NoiseEpoch GndNoiseEpoch REMEpoch MovEpoch
% 
% SWSEpoch=SWSEpoch-GndNoiseEpoch;
% SWSEpoch=SWSEpoch-NoiseEpoch;
% try
% SWSEpoch=SWSEpoch-WeirdNoiseEpoch;
% end
% 
% REMEpoch=REMEpoch-GndNoiseEpoch;
% REMEpoch=REMEpoch-NoiseEpoch;
% try
% REMEpoch=REMEpoch-WeirdNoiseEpoch;
% end
% 

limLFP=8000;
AmplitudeNoiseEpoch1=thresholdIntervals(LFP,limLFP,'Direction','Above');
AmplitudeNoiseEpoch2=thresholdIntervals(LFP,-limLFP,'Direction','Below');
AmplitudeNoiseEpoch=or(AmplitudeNoiseEpoch1,AmplitudeNoiseEpoch2);
AmplitudeNoiseEpoch=intervalSet(Start(AmplitudeNoiseEpoch)-1*1E4,End(AmplitudeNoiseEpoch)+1*1E4);
AmplitudeNoiseEpoch=mergeCloseIntervals(AmplitudeNoiseEpoch,0.5);


SWSEpoch=SWSEpoch-GndNoiseEpoch;
SWSEpoch=SWSEpoch-NoiseEpoch;
try
SWSEpoch=SWSEpoch-AmplitudeNoiseEpoch;
end
try
SWSEpoch=SWSEpoch-WeirdNoiseEpoch;
end

REMEpoch=REMEpoch-GndNoiseEpoch;
REMEpoch=REMEpoch-NoiseEpoch;
try
REMEpoch=REMEpoch-AmplitudeNoiseEpoch;
end
try
REMEpoch=REMEpoch-WeirdNoiseEpoch;
end



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



if PreviousSleepStage
    try
        load SleepStages SleepStages spindles REMEpoch SWSEpoch S12 S34 S5 WholeEpoch SleepEpoch WakeEpoch channel AmplitudeNoiseEpoch ParamDetection
        SleepStages;
        disp('Use previous sleep stages')
    catch
        [S12,S4,S5,REMEpoch,WakeEpoch,SleepStages,spindles]=FindSleepStage(LFP,ParamDetection);
    end

else
    
    [S12,S34,S5,REMEpoch,WakeEpoch,SleepStages,spindles]=FindSleepStage(LFP,ParamDetection);
   res=pwd;
le=length(res);
try
    
    if channel>10
    eval(['SaveRippleEvents(''',res(le-21:end),'.evt.s',num2str(channel),''',[spindles(:,1:2) spindles(:,2)],',num2str(channel),')']) 
        else
    eval(['SaveRippleEvents(''',res(le-21:end),'.evt.s0',num2str(channel),''',[spindles(:,1:2) spindles(:,2)],',num2str(channel),')'])    
        end
    catch
    disp('Abort saving evt file (already exists)')    
    end

end



%--------------------------------------------------------------------------

rg=Range(LFP);

WholeEpoch=intervalSet(rg(1),rg(end));
WakeEpoch=WholeEpoch-SleepEpoch;

WholeEpoch=WholeEpoch-GndNoiseEpoch;
WholeEpoch=WholeEpoch-NoiseEpoch;
try
WholeEpoch=WholeEpoch-AmplitudeNoiseEpoch;
end
try
WholeEpoch=WholeEpoch-WeirdNoiseEpoch;
end
WholeEpoch=mergeCloseIntervals(WholeEpoch,0.0001);


WakeEpoch=WakeEpoch-GndNoiseEpoch;
WakeEpoch=WakeEpoch-NoiseEpoch;
try
WakeEpoch=WakeEpoch-AmplitudeNoiseEpoch;
end
try
WakeEpoch=WakeEpoch-WeirdNoiseEpoch;
end
WakeEpoch=mergeCloseIntervals(WakeEpoch,0.0001);

if PreviousSleepStage==0;
eval(['save SleepStages',num2str(channel),' SleepStages spindles REMEpoch SWSEpoch S12 S34 S5 WholeEpoch SleepEpoch WakeEpoch channel AmplitudeNoiseEpoch ParamDetection'])
save SleepStages SleepStages spindles REMEpoch SWSEpoch S12 S34 S5 WholeEpoch SleepEpoch WakeEpoch channel AmplitudeNoiseEpoch ParamDetection
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

[MeanEffect,spindles, spi]=CompareSpindlesPowerDrug(LFP, SWSEpoch, CPEpoch,VEHEpoch,spindles);



figure('color',[1 1 1])
subplot(2,4,1:4),
hold on, plot(Range(SleepStages,'s'),Data(SleepStages),'k')
hold on, plot(Range(SleepStages,'s'),Data(SleepStages),'k.')
hold on, plot(Range(Restrict(SleepStages,REMEpoch),'s'),Data(Restrict(SleepStages,REMEpoch)),'r.')%o','markerfacecolor','r')
hold on, plot(Range(Restrict(SleepStages,S12),'s'),Data(Restrict(SleepStages,S12)),'b.')%o','markerfacecolor','b')
hold on, plot(Range(Restrict(SleepStages,S34),'s'),Data(Restrict(SleepStages,S34)),'y.')%o','markerfacecolor','y')
hold on, plot(Range(Restrict(SleepStages,S5),'s'),Data(Restrict(SleepStages,S5)),'c.')%o','markerfacecolor','c')
hold on, line([st1(1) st1(1)],[-1 5],'color','b','linewidth',2)
hold on, line([st2(1) st2(1)],[-1 5],'color','b','linewidth',2)


res=pwd;
le=length(res);
title([res(le-10:le),', Channel: ',num2str(channel),' ',InfoLFP.structure{InfoLFP.channel==channel}])




Sptsd=tsd(t*1E4,Sp);

noiseSpectrumvalue=mean(Sp(:,find(f>0&f<2))');
NoiseSpectrum=tsd(t*1E4,noiseSpectrumvalue');
NoNoiseSpectrumEpoch=thresholdIntervals(NoiseSpectrum,1E7,'Direction','Below');
Sptsd=Restrict(Sptsd,NoNoiseSpectrumEpoch);


subplot(2,4,5),
hold on, plot(f,mean(Data(Restrict(Sptsd,S12))),'--','color',[0.7 0.7 0.7])
hold on, plot(f,mean(Data(Restrict(Sptsd,and(PreEpoch,S12)))),'k','linewidth',2)
hold on, plot(f,mean(Data(Restrict(Sptsd,and(VEHEpoch,S12)))),'b','linewidth',2)
hold on, plot(f,mean(Data(Restrict(Sptsd,and(CPEpoch,S12)))),'r','linewidth',2)
title(['Pfc, CP, S12'])


subplot(2,4,6),
hold on, plot(f,mean(Data(Restrict(Sptsd,S34))),'--','color',[0.7 0.7 0.7])
hold on, plot(f,mean(Data(Restrict(Sptsd,and(PreEpoch,S34)))),'k','linewidth',2)
hold on, plot(f,mean(Data(Restrict(Sptsd,and(VEHEpoch,S34)))),'b','linewidth',2)
hold on, plot(f,mean(Data(Restrict(Sptsd,and(CPEpoch,S34)))),'r','linewidth',2)
title(['Pfc, CP, S34'])


subplot(2,4,7),
hold on, plot(f,mean(Data(Restrict(Sptsd,S5))),'--','color',[0.7 0.7 0.7])
hold on, plot(f,mean(Data(Restrict(Sptsd,and(PreEpoch,S5)))),'k','linewidth',2)
hold on, plot(f,mean(Data(Restrict(Sptsd,and(VEHEpoch,S5)))),'b','linewidth',2)
hold on, plot(f,mean(Data(Restrict(Sptsd,and(CPEpoch,S5)))),'r','linewidth',2)
title(['Pfc, CP, S5'])


subplot(2,4,8),
hold on, plot(f,mean(Data(Restrict(Sptsd,REMEpoch))),'--','color',[0.7 0.7 0.7])
hold on, plot(f,mean(Data(Restrict(Sptsd,and(PreEpoch,REMEpoch)))),'k','linewidth',2)
hold on, plot(f,mean(Data(Restrict(Sptsd,and(VEHEpoch,REMEpoch)))),'b','linewidth',2)
hold on, plot(f,mean(Data(Restrict(Sptsd,and(CPEpoch,REMEpoch)))),'r','linewidth',2)
title(['Pfc, CP, REM'])





Mat(1,:)=f;
Mat(2,:)=mean(Data(Restrict(Sptsd,S12)));
Mat(3,:)=mean(Data(Restrict(Sptsd,and(PreEpoch,S12))));
Mat(4,:)=mean(Data(Restrict(Sptsd,and(VEHEpoch,S12))));
Mat(5,:)=mean(Data(Restrict(Sptsd,and(CPEpoch,S12))));

Mat(6,:)=mean(Data(Restrict(Sptsd,S34)));
Mat(7,:)=mean(Data(Restrict(Sptsd,and(PreEpoch,S34))));
Mat(8,:)=mean(Data(Restrict(Sptsd,and(VEHEpoch,S34))));
Mat(9,:)=mean(Data(Restrict(Sptsd,and(CPEpoch,S34))));

try
Mat(10,:)=mean(Data(Restrict(Sptsd,REMEpoch)));
Mat(11,:)=mean(Data(Restrict(Sptsd,and(PreEpoch,REMEpoch))));
Mat(12,:)=mean(Data(Restrict(Sptsd,and(VEHEpoch,REMEpoch))));
Mat(13,:)=mean(Data(Restrict(Sptsd,and(CPEpoch,REMEpoch))));
end

save MeanEffect MeanEffect Mat
eval(['save MeanEffect',num2str(channel),' MeanEffect Mat'])
    
toc



% ki=ki+1; subplot(3,1,1), plot(f,mean(Data(Restrict(Sptsd,subset(SpiEpoch,ki)))),'r','linewidth',2)
% subplot(3,1,2), imagesc(10*log10(Data(Restrict(Sptsd,subset(SpiEpoch,ki))))'), axis xy
% subplot(3,1,3),plot(Range(Restrict(LFP,subset(SpiEpoch,ki)),'s'),Data(Restrict(LFP,subset(SpiEpoch,ki))),'k'), rg=Range(Restrict(LFP,subset(SpiEpoch,ki)),'s'); xlim([rg(1) rg(end)])


