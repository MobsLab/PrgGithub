clear all

Dir.path{1} ='/media/nas4/SophieToCopy/_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse248_20150326-EXT-24h-envC/20150326-EXT-24h-envC';
Dir.path{2} ='/media/nas4/SophieToCopy/_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse244_20150507-EXT-24h-envB/20150507-EXT-24h-envB';
Dir.path{3} ='/media/nas4/SophieToCopy/_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse244_20150507-EXT-24h-envB/20150507-EXT-24h-envB';
Dir.path{4} ='/media/nas4/SophieToCopy/_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse243_20150507-EXT-24h-envB/20150507-EXT-24h-envB';
Dir.path{5} ='/media/nas4/SophieToCopy/_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse253_20150703-EXT-24h-envC_FEAR-Mouse-253-03072015/FEAR-Mouse-253-03072015';
Dir.path{6} ='/media/nas4/SophieToCopy/_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse254_20150703-EXT-24h-envC/20150703-EXT-24h-envC';
Dir.path{7} ='/media/nas4/SophieToCopy/_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse258_20151204-EXT-24h-envC/20151204-EXT-24h-envC';
Dir.path{8} ='/media/nas4/SophieToCopy/_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse259_20151204-EXT-24h-envC/20151204-EXT-24h-envC';
Dir.path{9} ='/media/nas4/SophieToCopy/_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse299_20151217-EXT-24h-envC/20151217-EXT-24h-envC';
Dir.path{10} ='/media/nas4/SophieToCopy/_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse394_FEAR-Mouse-394-EXT-24-envBraye_161020_163239_/FEAR-Mouse-394-EXT-24-envBraye_161020_163239';
Dir.path{11} ='/media/nas4/SophieToCopy/_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse395_FEAR-Mouse-395-EXT-24-envBraye_161020_155350_/FEAR-Mouse-395-EXT-24-envBraye_161020_155350';
Dir.path{12} ='/media/nas4/SophieToCopy/_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse402_FEAR-Mouse-402-EXT-24-envB_raye_161026_164106_/FEAR-Mouse-402-EXT-24-envB_raye_161026_164106';
Dir.path{13} ='/media/nas4/SophieToCopy/_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse403_FEAR-Mouse-403-EXT-24-envB_raye_161026_171611_/FEAR-Mouse-403-EXT-24-envB_raye_161026_171611';
Dir.path{14} ='/media/nas4/SophieToCopy/_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse450_FEAR-Mouse-450-EXT-24-envB_161026_174952_/FEAR-Mouse-450-EXT-24-envB_161026_174952';
Dir.path{15} ='/media/nas4/SophieToCopy/_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse451_FEAR-Mouse-451-EXT-24-envB_161026_182307_/FEAR-Mouse-451-EXT-24-envB_161026_182307';

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
        
        clear Spec
        Lims = [find(Spectro{3}>2,1,'first'):find(Spectro{3}>6,1,'first')];
        for ep1 = 1:length(Start(FreezeEpoch))
            LitEp = subset(FreezeEpoch,ep1);
            Spec = nanmean(Data(Restrict(Sptsd,LitEp)));
            PowRatio.TotalEp(ep) = nanmean(Spec(Lims));%/nanmean(Spec(Lims(end):end));
            Dur(ep) = Stop(LitEp,'s') - Start(LitEp,'s');
            
            LitEp = intervalSet(Stop(subset(FreezeEpoch,ep1))-2*1E4,Stop(subset(FreezeEpoch,ep1)));
            Spec = nanmean(Data(Restrict(Sptsd,LitEp)));
            PowRatio.End(ep) = nanmean(Spec(Lims));%/nanmean(Spec(Lims(end):end));
            
            LitEp = intervalSet(Start(subset(FreezeEpoch,ep1)),Start(subset(FreezeEpoch,ep1))+2*1E4);
            Spec = nanmean(Data(Restrict(Sptsd,LitEp)));
            PowRatio.Start(ep) = nanmean(Spec(Lims));%/nanmean(Spec(Lims(end):end));
            
            LitEp = intervalSet(Start(subset(FreezeEpoch,ep1))-3*1E4,Start(subset(FreezeEpoch,ep1)));
            Spec = nanmean(Data(Restrict(Sptsd,LitEp)));
            PowRatio.Before(ep) = nanmean(Spec(Lims));%/nanmean(Spec(Lims(end):end));
            MouseID(ep) = k;
            
            ep = ep+1;
            
        end
        
        
    end
    
end

plot(log(Dur(Dur>3)),(PowRatio.End(Dur>3)-PowRatio.Start(Dur>3)),'.')