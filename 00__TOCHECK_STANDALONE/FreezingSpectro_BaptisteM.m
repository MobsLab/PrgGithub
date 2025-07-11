channel = 30
save('ChannelsToAnalyse/dHPC_deep.mat','channel');

channel = 24
save('ChannelsToAnalyse/Bulb_deep.mat','channel');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function FreezingSpectro_BaptisteM()
clear all
close all
load('behavResources.mat')
th_immob_Acc = 25000000;
thtps_immob = 2;
smoofact_Acc = 30;
NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);
save('behavResources.mat','FreezeAccEpoch','-append')



TotalTime=(tpsCatEvt{2}-tpsCatEvt{1})/1e4;
Dur = sum(Stop(FreezeAccEpoch,'s')-Start(FreezeAccEpoch,'s'));
PercentFz=(Dur/TotalTime)*100;
figure
subplot(4,1,1)
plot(Range(NewMovAcctsd,'s'),Data(NewMovAcctsd))
hold on
plot(Range(Restrict(NewMovAcctsd,FreezeAccEpoch),'s'),Data(Restrict(NewMovAcctsd,FreezeAccEpoch)),'.')
xlim([0 max(Range(NewMovAcctsd,'s'))])
subplot(4,1,2)
[Sp,t,f]=LoadSpectrumML('Bulb_deep',pwd,'low');
imagesc(t,f,log(Sp')),axis xy
xlim([0 max(Range(NewMovAcctsd,'s'))])
title('OB')
subplot(4,1,3)
[Sp,t,f]=LoadSpectrumML('PFCx_deep',pwd,'low');
imagesc(t,f,log(Sp')),axis xy
xlim([0 max(Range(NewMovAcctsd,'s'))])
title('PFC')
subplot(4,1,4)
try
[Sp,t,f]=LoadSpectrumML('dHPC_deep',pwd,'low');
catch
try
[Sp,t,f]=LoadSpectrumML('dHPC_rip',pwd,'low');
catch
[Sp,t,f]=LoadSpectrumML('dHPC_sup',pwd,'low');
end
end
imagesc(t,f,log(Sp')),axis xy
xlim([0 max(Range(NewMovAcctsd,'s'))])
title('HPC')

mkdir('Freezing')
load('ExpeInfo.mat')
CurrentPath=pwd;
FreezingPath=[CurrentPath filesep 'Freezing']
cd(FreezingPath)
saveas(1,strcat('Freezing_',ExpeInfo.SessionType,'.png'))
saveas(1,strcat('Freezing_',ExpeInfo.SessionType,'.fig'))

%      save(['Freezing/',1,'.mat'],'channel');
% 
% saveas(1,'Freezing_TestB_926_D4.png')
% saveas(1,'Freezing_TestB_926_D4.fig')

end