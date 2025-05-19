

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

cd D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse451_FEAR-Mouse-451-EXT-24-envB_161026_182307_\FEAR-Mouse-451-EXT-24-envB_161026_182307
        load('behavResources.mat','BeepTimes')
            timebef = 4; % now use 5s always

Seui = 0.5*1E8
neur = 1;
mouse=1;
for k = 1:length(Dir.path)
    cd(Dir.path{k})
    
    if exist('SpikeData.mat')>0
        try
        clear FreezeAccEpoch Kappa mu pval S MovAcctsd
        load('behavResources.mat')
        if not(exist('FreezeAccEpoch'))
            FreezeAccEpoch = FreezeEpoch;
        end
        
        FreezeAccEpoch =  dropShortIntervals(FreezeAccEpoch,10*1E4);
        TotalEpoch = intervalSet(0,max(Range(MovAcctsd)))
        load('NeuronLFPCoupling_OB4HzPaper\AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat')
        
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
        load('SpikeData.mat')
        S = S(numNeurons);
        BeppEpoch = or(intervalSet(BeepTimes.CSP*1E4-0.5E4,BeepTimes.CSP*1E4+0.5E4),intervalSet(BeepTimes.CSM*1E4-0.5E4,BeepTimes.CSM*1E4+0.5E4));
        Times = Start(BeppEpoch)+0.5E4;
        
        TimesQ =  MakeQfromS(tsdArray(ts(Times)),0.05*1E4);
        tps=[0.05:0.05:1];
        
        
        
        for ep=2:length(Start(FreezeAccEpoch))-2
            ActualEpoch=subset(FreezeAccEpoch,ep);
            Dur=Stop(ActualEpoch,'s')-Start(ActualEpoch,'s');
            %% Look at Normalized periods
            % define epoch
            % timebef=Dur{m}(ep)*timebefprop; % period before and after is 30% acutal period
            LittleEpoch=intervalSet(Start(ActualEpoch),Stop(ActualEpoch));
            LittleEpochPre=intervalSet(Start(ActualEpoch)-timebef*1e4,Start(ActualEpoch));
            LittleEpochPost=intervalSet(Stop(ActualEpoch),Stop(ActualEpoch)+timebef*1e4);
            
            TempData=full(Data(Restrict(TimesQ,LittleEpoch)));
            TempData = interp1([1/length(TempData):1/length(TempData):1],TempData,tps);
            
            TempDataPre=full(Data(Restrict(TimesQ,LittleEpochPre)));
            TempDataPre = interp1([1/length(TempDataPre):1/length(TempDataPre):1],TempDataPre,[0.1:0.1:1]);
            
            TempDataPost=full(Data(Restrict(TimesQ,LittleEpochPost)));
            TempDataPost = interp1([1/length(TempDataPost):1/length(TempDataPost):1],TempDataPost,[0.1:0.1:1]);
            
            Triggered{mouse}(ep-1,:) = [TempDataPre,TempData,TempDataPost];
        end
        k
                        mouse =mouse+1;

        end
    end
end



AllTrig = [];
for mouse = 1:length(Triggered)
AllTrig = [AllTrig,nanmean(Triggered{mouse},1)'];
end

hold on
errorbar([-0.5:0.05:-0.05,tps,1.05:0.05:1.5],nanmean(AllTrig'),stdError(AllTrig'),'linewidth',3)
