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

DirB.path{1} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse291_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
DirB.path{2} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse297_20151217-EXT-24h-envC\20151217-EXT-24h-envC';
DirB.path{3} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse298_20151217-EXT-24h-envC\20151217-EXT-24h-envC';
upneur = 1;
updownneur = 1;
downeur = 1;

for k = 1:length(Dir.path)
    cd(Dir.path{k})
    
    if exist('SpikeData.mat')>0
        clear FreezeAccEpoch Kappa mu pval S
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
        load('SpikeData.mat')
        S = S(numNeurons);
        load('behavResources.mat')
        if exist('FreezeAccEpoch')
            FreezeEpoch = FreezeAccEpoch;
        end
        TotEpoch = intervalSet(0,max(Range(Movtsd)));
        load('NeuronLFPCoupling_OB4HzPaper\AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat')
        
        
        neur = 1;
        clear StartResp StopResp PhaseNeur PValNeur
        for num = 1:length(S)
            [StartResp(neur,:), B] = CrossCorr(Start(FreezeEpoch),Range(S{num}),40,125);
            [StopResp(neur,:), B] = CrossCorr(Stop(FreezeEpoch),Range(S{num}),40,125);
            [~,MeanNoFz(neur)] = FiringRateEpoch(S{num},TotEpoch-FreezeEpoch);
            [~,MeanFz(neur)] = FiringRateEpoch(S{num},FreezeEpoch);
            KappaNeur(neur) = Kappa{num};
            PhaseNeur(neur) = mu{num};
            PValNeur(neur) = pval{num};
            
            neur = neur+1;
        end
        
        DatMat = zscore([StartResp,StopResp]')';
        Val = nanmean(DatMat(:,70:end-70)');
        UpNeur = find(Val>0.3 & [PValNeur.Transf]<0.05);
        DownNeur = find(Val<-0.3 & [PValNeur.Transf]<0.05);
        FreezeEpochSp = dropShortIntervals(FreezeEpoch,4*1E4);
        FreezeEpochSp = intervalSet(Start(FreezeEpochSp)+0.5*1E4,Stop(FreezeEpochSp)-0.5*1E4);
        for kk=1:length(UpNeur)
            for kkk=1:length(UpNeur)
                if kk~=kkk
                    [UpNeurCrossCorr(upneur,:), B] = CrossCorr(Range((S{UpNeur(kk)})),Range((S{UpNeur(kkk)})),5,200);
                    upneur = upneur+1;
                end
            end
        end
        
        for kk=1:length(UpNeur)
            for kkk=1:length(DownNeur)
                [UpDownNeurCrossCorr(updownneur,:), B] = CrossCorr(Range((S{UpNeur(kk)})),Range((S{DownNeur(kkk)})),5,200);
                updownneur = updownneur+1;
                
            end
        end
        
        for kk=1:length(DownNeur)
            for kkk=1:length(DownNeur)
                if kk~=kkk
                    [DownNeurCrossCorr(downeur,:), B] = CrossCorr(Range(S{DownNeur(kk)}),Range(S{DownNeur(kkk)}),5,200);
                    downeur = downeur+1;
                end
            end
        end
        
        
        
    end
    
end