a=0;
% CHR2 mice
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse496/20170309-EXT-24-laser13/FEAR-Mouse-496-09032017';

a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse497/20170309-EXT-24-laser13/FEAR-Mouse-497-09032017';

a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse540/20170727-EXT24-laser13';

a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse542/20170727-EXT24-laser13';

a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse543/20170727-EXT24-laser13';

a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse613/20171005-EXT-24';

a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse614/20171005-EXT-24';



for a = 1 : length(Dir.path)
    cd(Dir.path{a})
    clear t f Sp Sptsd channel FreezeAccEpoch StimLaserON StimLaserOFF NoiseEpoch
    load('behavResources.mat')
    load('ChannelsToAnalyse/Bulb_deep.mat')
    load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
    load('StateEpoch.mat','NoiseEpoch')
    FreezeAccEpoch = FreezeAccEpoch - NoiseEpoch;
    
    Sptsd = tsd(t*1e4,Sp);
    
    figure
    subplot(211)
    plot(f,nanmean(Data(Restrict(Sptsd,and(FreezeAccEpoch,StimLaserON))))), hold on
    plot(f,nanmean(Data(Restrict(Sptsd,and(FreezeAccEpoch,StimLaserOFF)))))
    makepretty
    Spec.OB.Las(a,:) = nanmean(Data(Restrict(Sptsd,and(FreezeAccEpoch,StimLaserON))));
    Spec.OB.NoLas(a,:) = nanmean(Data(Restrict(Sptsd,and(FreezeAccEpoch,StimLaserOFF))));
    Spec.OB.Las(a,:) =  Spec.OB.Las(a,:)./nanmean(Spec.OB.NoLas(a,15:130));
    Spec.OB.NoLas(a,:) =  Spec.OB.NoLas(a,:)./nanmean(Spec.OB.NoLas(a,15:130));
    
    load('ChannelsToAnalyse/PFCx_deep.mat')
    load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
    Sptsd = tsd(t*1e4,Sp);
    
    
    subplot(212)
    plot(f,nanmean(Data(Restrict(Sptsd,and(FreezeAccEpoch,StimLaserON))))), hold on
    plot(f,nanmean(Data(Restrict(Sptsd,and(FreezeAccEpoch,StimLaserOFF)))))
    makepretty
    
    Spec.PFC.Las(a,:) = nanmean(Data(Restrict(Sptsd,and(FreezeAccEpoch,StimLaserON))));
    Spec.PFC.NoLas(a,:) = nanmean(Data(Restrict(Sptsd,and(FreezeAccEpoch,StimLaserOFF))));
    Spec.PFC.Las(a,:) =  Spec.PFC.Las(a,:)./nanmean(Spec.PFC.NoLas(a,15:130));
    Spec.PFC.NoLas(a,:) =  Spec.PFC.NoLas(a,:)./nanmean(Spec.PFC.NoLas(a,15:130));
    
end

Rg36 = [find(f<3,1,'last');find(f<5,1,'last')];

figure
subplot(221)
H = shadedErrorBar(f,nanmean(Spec.OB.NoLas),std(Spec.OB.NoLas));
hold on
H = shadedErrorBar(f,nanmean(Spec.OB.Las),stdError(Spec.OB.Las));
H.patch.FaceColor = 'b'
H.patch.FaceAlpha = 0.2;
H.mainLine.Color = 'b';
xlabel('Frequency (Hz)')
ylabel('Power (AU)')
title('OB')
ylim([0 7])
box off

subplot(222)
MnValsOB(1,:) = nanmean(Spec.OB.NoLas(:,Rg36),2);
MnValsOB(2,:) = nanmean(Spec.OB.Las(:,Rg36),2);
PlotErrorBarN_KJ(MnValsOB','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'OFF','ON'})
ylabel('4Hz Power')
title('OB')


subplot(223)
H = shadedErrorBar(f,nanmean(Spec.PFC.NoLas),stdError(Spec.PFC.NoLas));
hold on
H = shadedErrorBar(f,nanmean(Spec.PFC.Las),stdError(Spec.PFC.Las));
H.patch.FaceColor = 'b'
H.patch.FaceAlpha = 0.2;
H.mainLine.Color = 'b';
xlabel('Frequency (Hz)')
ylabel('Power (AU)')
title('PFC')
ylim([0 7])
box off

subplot(224)
MnValsOB(1,:) = nanmean(Spec.PFC.NoLas(:,Rg36),2);
MnValsOB(2,:) = nanmean(Spec.PFC.Las(:,Rg36),2);
PlotErrorBarN_KJ(MnValsOB','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'OFF','ON'})
ylabel('4Hz Power')
title('PFC')
