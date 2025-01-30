clear all

Dir.path{1} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse248_20150326-EXT-24h-envC\20150326-EXT-24h-envC';
Dir.path{2} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse244_20150507-EXT-24h-envB\20150507-EXT-24h-envB';
Dir.path{3} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse244_20150507-EXT-24h-envB\20150507-EXT-24h-envB';
Dir.path{4} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse243_20150507-EXT-24h-envB\20150507-EXT-24h-envB';
Dir.path{5} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse253_20150703-EXT-24h-envC_FEAR-Mouse-253-03072015\FEAR-Mouse-253-03072015';
Dir.path{6} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse254_20150703-EXT-24h-envC\20150703-EXT-24h-envC';
Dir.path{7} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse258_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
Dir.path{8} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse259_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
Dir.path{9} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse299_20151217-EXT-24h-envC\20151217-EXT-24h-envC';
Dir.path{10} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse394_FEAR-Mouse-394-EXT-24-envBraye_161020_163239_\FEAR-Mouse-394-EXT-24-envBraye_161020_163239';
Dir.path{11} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse395_FEAR-Mouse-395-EXT-24-envBraye_161020_155350_\FEAR-Mouse-395-EXT-24-envBraye_161020_155350';
Dir.path{12} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse402_FEAR-Mouse-402-EXT-24-envB_raye_161026_164106_\FEAR-Mouse-402-EXT-24-envB_raye_161026_164106';
Dir.path{13} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse403_FEAR-Mouse-403-EXT-24-envB_raye_161026_171611_\FEAR-Mouse-403-EXT-24-envB_raye_161026_171611';
Dir.path{14} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse450_FEAR-Mouse-450-EXT-24-envB_161026_174952_\FEAR-Mouse-450-EXT-24-envB_161026_174952';
Dir.path{15} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse451_FEAR-Mouse-451-EXT-24-envB_161026_182307_\FEAR-Mouse-451-EXT-24-envB_161026_182307';

TimeLim = 10;
ep=1;
for k = 1:length(Dir.path)
    cd(Dir.path{k})
    
    if exist('SpikeData.mat')>0
        clear FreezeAccEpoch Kappa mu pval S
        
        load('behavResources.mat')
        if exist('FreezeAccEpoch')
            FreezeEpoch = FreezeAccEpoch;
        end
        TotEpoch = intervalSet(0,max(Range(Movtsd)));
        
        
        clear Spectro Sptsd Coh t f
        %         load('B_Low_Spectrum.mat')
        
        [Coh,t,f] = LoadCohgramML('Bulb_deep','PFCx_deep');
        Spectro{1} = Coh; Spectro{2} = t; Spectro{3}=f;
        
        Sptsd = tsd(Spectro{2}*1E4,(Spectro{1}));
        
        AllDur = Stop(FreezeEpoch,'s') - Start(FreezeEpoch,'s');
        LongFreezeCoh(k,:) = nanmean(Data(Restrict(Sptsd,subset(FreezeEpoch,find(AllDur>TimeLim)))));
        ShortFreezeCoh(k,:) = nanmean(Data(Restrict(Sptsd,subset(FreezeEpoch,find(AllDur<TimeLim)))));
        
        load('B_Low_Spectrum.mat')
        Sptsd = tsd(Spectro{2}*1E4,(Spectro{1}));
        Dat = Data(Sptsd);
        Renorm = 1;%nanmean(nanmean(Dat(:,30:end)));
        LongFreezeSpec(k,:) = nanmean(Data(Restrict(Sptsd,subset(FreezeEpoch,find(AllDur>TimeLim)))))./Renorm;
        ShortFreezeSpec(k,:) = nanmean(Data(Restrict(Sptsd,subset(FreezeEpoch,find(AllDur<TimeLim)))))./Renorm;
        
        load('PFCx_Low_Spectrum.mat')
        Sptsd = tsd(Spectro{2}*1E4,(Spectro{1}));
                Dat = Data(Sptsd);
        Renorm = 1;%nanmean(nanmean(Dat(:,30:end)));
        LongFreezeSpecP(k,:) = nanmean(Data(Restrict(Sptsd,subset(FreezeEpoch,find(AllDur>TimeLim)))))./Renorm;
        ShortFreezeSpecP(k,:) = nanmean(Data(Restrict(Sptsd,subset(FreezeEpoch,find(AllDur<TimeLim)))))./Renorm;
        
    end
    
end


figure
errorbar(Spectro{3},nanmean(ShortFreezeSpecP),stdError(ShortFreezeSpecP))
hold on
errorbar(Spectro{3},nanmean(LongFreezeSpecP),stdError(LongFreezeSpecP))
legend('Short','Long')
xlabel('Frequency(Hz)')
makepretty
title('PFC')

figure
errorbar(Spectro{3},nanmean(ShortFreezeSpec),stdError(ShortFreezeSpec))
hold on
errorbar(Spectro{3},nanmean(LongFreezeSpec),stdError(LongFreezeSpec))
legend('Short','Long')
xlabel('Frequency(Hz)')
title('OB')
makepretty



MiceNoLong = [4,5];
LongFreezeSpec(MiceNoLong,:) = [];
ShortFreezeSpec(MiceNoLong,:) = [];

figure
clf
hold on
g=shadedErrorBar(Spectro{3},nanmean(LongFreezeSpec),stdError(LongFreezeSpec));
g.patch.FaceColor = [185 229 256]/256;
g.edge(1).Color = [185 229 256]/256;
g.edge(2).Color = [185 229 256]/256;
g.mainLine.Color= [185 229 256]/256;
g.mainLine.LineWidth = 3;
g.patch.FaceAlpha= 0.7;

g=shadedErrorBar(Spectro{3},nanmean(ShortFreezeSpec),stdError(ShortFreezeSpec));
g.patch.FaceColor = [160 180 239]/256;
g.edge(1).Color = [160 180 239]/256;
g.edge(2).Color = [160 180 239]/256;
g.mainLine.Color= [160 180 239]/256;
g.mainLine.LineWidth = 3;
g.patch.FaceAlpha= 0.5;
xlabel('Frequency (Hz)')
ylabel('Power - log scale')
set(gca, 'FontSize', 25);
box off
set(gca,'Linewidth',2)


Lims = [find(Spectro{3}>3,1,'first'):find(Spectro{3}>5.5,1,'first')];
OtherFreq=[1:length(Spectro{3})];OtherFreq(ismember(OtherFreq,Lims))=[];


SNR_Short = nanmean(log(ShortFreezeSpec(:,Lims)'))./nanmean(log(ShortFreezeSpec(:,OtherFreq)'));
SNR_Long = nanmean(log(LongFreezeSpec(:,Lims)'))./nanmean(log(LongFreezeSpec(:,OtherFreq)'));

figure
MakeSpreadAndBoxPlot_SB({SNR_Short,SNR_Long},{[160 180 239]/256,[185 229 256]/256},...
    [1,2],{'Short','Long'},1)
[h,p,stat] = signrank(SNR_Short,SNR_Long)

ylabel('SNR 3-6Hz')
set(get(gca, 'XLabel'), 'FontSize', 16);
set(get(gca, 'YLabel'), 'FontSize', 16);
set(gca, 'FontSize', 15);
box off
set(gca,'Linewidth',2)
xlim([0.5 2.5])
ylim([1.1 1.35])

set(gca, 'FontSize', 25);
