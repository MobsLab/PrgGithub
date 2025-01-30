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

neur = 1;
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
        load('NeuronLFPCoupling_OB4HzPaper\AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat','pval','Kappa','mu')
        load('NeuronLFPCoupling_OB4HzPaper\AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat')
        load('NeuronLFPCoupling\FzNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat','pval','Kappa','mu')
        pval = pval.Real;
        Kappa = Kappa.Real;
        mu = mu.Real;

        for num = 1:length(S)
            [StartRespErr, B] = CrossCorrBootStrap(Start(FreezeEpoch),Range(S{num}),20,250);
            [StopRespErr, B] = CrossCorrBootStrap(Stop(FreezeEpoch),Range(S{num}),20,250);
            StartResp(neur,:) = (nanmean(StartRespErr,1));
            StopResp(neur,:) = (nanmean(StopRespErr,1));
            
            
            
            CleanFreezEpoch = (FreezeEpoch - intervalSet(Start(FreezeEpoch),Start(FreezeEpoch)+1E4));
            CleanNoFreezEpoch = (TotEpoch-FreezeEpoch)-intervalSet(Stop(FreezeEpoch),Stop(FreezeEpoch)+1E4);
            [FRNoFr,MeanNoFz(neur)] = FiringRateEpoch(S{num},CleanNoFreezEpoch);
            [FRFr,MeanFz(neur)] = FiringRateEpoch(S{num},CleanFreezEpoch);
            PFzNoFz(neur) = ranksum(FRFr,FRNoFr);
            
            [OnsetFR,~] = FiringRateEpoch(S{num},intervalSet(Start(FreezeEpoch),Start(FreezeEpoch)+1E4));
            [OffsetFR,~] = FiringRateEpoch(S{num},intervalSet(Stop(FreezeEpoch),Stop(FreezeEpoch)+1E4));
            POnset(neur,:) = [ranksum(OnsetFR,FRNoFr),ranksum(OnsetFR,FRFr)];
            POffset(neur,:) = [ranksum(OffsetFR,FRNoFr),ranksum(OffsetFR,FRFr)];

            
            KappaNeur(neur) = Kappa{num};
            PhaseNeur(neur) = mu{num};
            PValNeur(neur) = pval{num};
            
            DatMat(neur,:) = [StartResp(neur,:),StopResp(neur,:)];
            MeanNoFzLoc(neur) = nanmean(DatMat(neur,[1:50,450:500]));
            MeanFzLoc(neur) = nanmean(DatMat(neur,150:350));
            Skeletton = [ones(1,125)*MeanNoFzLoc(neur),ones(1,252)*MeanFzLoc(neur),ones(1,125)*MeanNoFzLoc(neur)];
            DatMatCl(neur,:) =  DatMat(neur,:)-Skeletton;
            PhasicFreezing = (DatMat(neur,:)-Skeletton);
            StrtPhasicFreezing = PhasicFreezing(125:250);
            StpPhasicFreezing = PhasicFreezing(375:end);
            
            for k = 1:1000
                rgSrt(k) = range(cumsum(zscore(StrtPhasicFreezing(randperm(length(StrtPhasicFreezing))))));
                rgStp(k) = range(cumsum(zscore(StpPhasicFreezing(randperm(length(StpPhasicFreezing))))));
            end
            rgSrt_real(neur) = range(cumsum(zscore(StrtPhasicFreezing)))>prctile(rgSrt,99);
            rgStp_real(neur) = range(cumsum(zscore(StpPhasicFreezing)))>prctile(rgStp,99);
            
%             Look if average zscore is above threshold (1.96)
            StrtPhasicFreezing = (zscore(PhasicFreezing(1:end)));
            [val,ind] = max(abs(StrtPhasicFreezing(125:175)));
            MaxSrt(neur) = StrtPhasicFreezing(ind+125);

            StpPhasicFreezing = (zscore(PhasicFreezing(1:end)));
            [val,ind] = max(abs(StpPhasicFreezing(375:425)));
            MaxStp(neur) = StpPhasicFreezing(ind+375);
            
%             Look if prctile zscore is above threshold (1.96)
            PhasicFreezingErr = [StartRespErr,StopRespErr] - repmat(Skeletton,1000,1);
            StrtPhasicFreezing = (zscore(PhasicFreezingErr(:,1:250)')');
            StrtPhasicFreezingHi = prctile(StrtPhasicFreezing,95);
            StrtPhasicFreezingLo = prctile(StrtPhasicFreezing,5);
            MaxSrtPrcHi(neur) = min(StrtPhasicFreezingHi(125:175));
            MaxSrtPrcLo(neur) = max(StrtPhasicFreezingLo(125:175));

            StpPhasicFreezing = (zscore(PhasicFreezingErr(:,250:end)')');
            StpPhasicFreezingHi = prctile(StpPhasicFreezing,95);
            StpPhasicFreezingLo = prctile(StpPhasicFreezing,5);
            MaxStpPrcHi(neur) = min(StpPhasicFreezingHi(125:175));
            MaxStpPrcLo(neur) = max(StpPhasicFreezingLo(125:175));

            
            NumFzEp(neur) = length(Start(FreezeEpoch));
            neur = neur+1;
        end
        
        
    end
    
end
%  look at 3 types of response
clear DatMatCl
for neur = 1:size(DatMat,1)
    MeanNoFzNew(neur) = nanmean(DatMat(neur,1:50));
    MeanFzNew(neur) = nanmean(DatMat(neur,150:250));
    Skeletton = [ones(1,125)*MeanNoFzNew(neur),ones(1,252)*MeanFzNew(neur),ones(1,125)*MeanNoFzNew(neur)];
    DatMatCl(neur,:) =  DatMat(neur,:)-Skeletton;
end
DatMatClZ = zscore(DatMatCl')';

%Use the cumsum method
InhibNeur_Start = (rgSrt_real==1 & MaxSrt<-1.5);
ExcitNeur_Start = (rgSrt_real==1 & MaxSrt>1.5);
InhibNeur_Stop = (rgStp_real==1 & MaxStp<-1.5);
ExcitNeur_Stop = (rgStp_real==1 & MaxStp>1.5);

%Use the statistical significance
InhibNeur_Start = (POnset(:,1)<0.05 & POnset(:,2)<0.05 & MaxSrt'<0);
ExcitNeur_Start = (POnset(:,1)<0.05 & POnset(:,2)<0.05 & MaxSrt'>0);
InhibNeur_Stop = ((POffset(:,1)<0.05 & POffset(:,2)<0.05) & MaxStp'<0);
ExcitNeur_Stop = ((POffset(:,1)<0.05 & POffset(:,2)<0.05) & MaxStp'>0)
InhibNeur_Fz = ((PFzNoFz<0.05) & MeanNoFz>MeanFz);
ExcitNeur_Fz = ((PFzNoFz<0.05) & MeanNoFz<MeanFz)




figure
bar(1,nanmean(ExcitNeur_Start)*100,'FaceColor','b')
hold on
bar(2,nanmean(InhibNeur_Start)*100,'FaceColor',[0.4 0.4 1])
bar(4,nanmean(ExcitNeur_Stop)*100,'FaceColor','r')
bar(5,nanmean(InhibNeur_Stop)*100,'FaceColor',[1 0.4 0.4])
ylabel('% Modulated neurons')
makepretty
set(gca,'XTick',[1,2,4,5],'XTickLabel',{'Excit','Inhib','Excit','Inhib'})
ylim([0 15])

figure
subplot(121)
plot([B]/1E3,runmean(nanmean((DatMatCl(ExcitNeur_Start,1:251)')'),2),'linewidth',4,'color',[0 0 1])
hold on
plot([B]/1E3,runmean(nanmean((DatMatCl(InhibNeur_Start,1:251)')'),2),'linewidth',4,'color',[0.4 0.4 1])
ylim([-8 8])
xlim([-2.5 2.5])
xlabel('Time to freeze start (s)')
title('Onset')
makepretty
subplot(122)
plot([B]/1E3,runmean(nanmean((DatMatCl(ExcitNeur_Stop,252:end)')'),2),'linewidth',4,'color',[1 0 0])
hold on
plot([B]/1E3,runmean(nanmean((DatMatCl(InhibNeur_Stop,252:end)')'),2),'linewidth',4,'color',[1 0.4 0.4])
title('Offset')
ylim([-8 8])
xlim([-2.5 2.5])
xlabel('Time to freeze stop (s)')
makepretty


figure
GoodNeurons = find(InhibNeur_Stop | ExcitNeur_Stop);
DatMatClZRed  = DatMatClZ(GoodNeurons,:);
[val,ind] = sort(MaxStp(GoodNeurons));
imagesc(DatMatClZRed(ind,:)), caxis([-2 2])

figure
[val,ind] = sort(MaxStp(:));
imagesc(DatMatClZ(ind,:)), caxis([-2 2])


neur = 1;
for k = 1:length(DirB.path)
    cd(DirB.path{k})
    
    if exist('SpikeData.mat')>0
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
        load('SpikeData.mat')
        try,S = S(numNeurons);end
        clear FreezeAccEpoch
        load('behavResources.mat')
        if exist('FreezeAccEpoch')
            FreezeEpoch = FreezeAccEpoch;
        end
        TotEpoch = intervalSet(0,max(Range(Movtsd)));
        
        for num = 1:length(S)
            [StartRespErr, B] = CrossCorrBootStrap(Start(FreezeEpoch),Range(S{num}),20,250);
            [StopRespErr, B] = CrossCorrBootStrap(Stop(FreezeEpoch),Range(S{num}),20,250);
            StartRespB(neur,:) = (nanmean(StartRespErr,1));
            StopRespB(neur,:) = (nanmean(StopRespErr,1));
            
            
            
            
            CleanFreezEpoch = (FreezeEpoch - intervalSet(Start(FreezeEpoch),Start(FreezeEpoch)+1E4));
            CleanNoFreezEpoch = (TotEpoch-FreezeEpoch)-intervalSet(Stop(FreezeEpoch),Stop(FreezeEpoch)+1E4);
            [FRNoFr,MeanNoFzB(neur)] = FiringRateEpoch(S{num},CleanNoFreezEpoch);
            [FRFr,MeanFzB(neur)] = FiringRateEpoch(S{num},CleanFreezEpoch);
            PFzNoFzB(neur) = ranksum(FRFr,FRNoFr);
            
            [OnsetFR,~] = FiringRateEpoch(S{num},intervalSet(Start(FreezeEpoch),Start(FreezeEpoch)+1E4));
            [OffsetFR,~] = FiringRateEpoch(S{num},intervalSet(Stop(FreezeEpoch),Stop(FreezeEpoch)+1E4));
            POnsetB(neur,:) = [ranksum(OnsetFR,FRNoFr),ranksum(OnsetFR,FRFr)];
            POffsetB(neur,:) = [ranksum(OffsetFR,FRNoFr),ranksum(OffsetFR,FRFr)];

            
            DatMatB(neur,:) = [StartRespB(neur,:),StopRespB(neur,:)];
            MeanNoFzLocB(neur) = nanmean(DatMatB(neur,[1:50,450:500]));
            MeanFzLocB(neur) = nanmean(DatMatB(neur,150:350));
            Skeletton = [ones(1,125)*MeanNoFzLocB(neur),ones(1,252)*MeanFzLocB(neur),ones(1,125)*MeanNoFzLocB(neur)];
            DatMatClB(neur,:) =  DatMatB(neur,:)-Skeletton;
            PhasicFreezing = (DatMatB(neur,:)-Skeletton);
            StrtPhasicFreezing = PhasicFreezing(125:250);
            StpPhasicFreezing = PhasicFreezing(375:end);
            
            
            for k = 1:1000
                rgSrt(k) = range(cumsum(zscore(StrtPhasicFreezing(randperm(length(StrtPhasicFreezing))))));
                rgStp(k) = range(cumsum(zscore(StpPhasicFreezing(randperm(length(StpPhasicFreezing))))));
            end
            rgSrt_realB(neur) = range(cumsum(zscore(StrtPhasicFreezing)))>prctile(rgSrt,99);
            rgStp_realB(neur) = range(cumsum(zscore(StpPhasicFreezing)))>prctile(rgStp,99);
            
%             Look if average zscore is above threshold (1.96)
            StrtPhasicFreezing = (zscore(PhasicFreezing(1:end)));
            [val,ind] = max(abs(StrtPhasicFreezing(125:175)));
            MaxSrtB(neur) = StrtPhasicFreezing(ind+125);

            StpPhasicFreezing = (zscore(PhasicFreezing(1:end)));
            [val,ind] = max(abs(StpPhasicFreezing(375:425)));
            MaxStpB(neur) = StpPhasicFreezing(ind+375);
            
            neur = neur+1;
        end
    end
    
end


% Use zscore cumsum
InhibNeur_StartB = (rgSrt_realB==1 & MaxSrtB<-1.5);
ExcitNeur_StartB = (rgSrt_realB==1 & MaxSrtB>1.5);

InhibNeur_StopB = (rgStp_realB==1 & MaxStpB<-1.5);
ExcitNeur_StopB = (rgStp_realB==1 & MaxStpB>1.5);


% Use the statistical significance
InhibNeur_StartB = (POnsetB(:,1)<0.05 & POnsetB(:,2)<0.05 & MaxSrtB'<0);
ExcitNeur_StartB = (POnsetB(:,1)<0.05 & POnsetB(:,2)<0.05 & MaxSrtB'>0);
InhibNeur_StopB = ((POffsetB(:,1)<0.05 & POffsetB(:,2)<0.05) & MaxStpB'<0);
ExcitNeur_StopB = ((POffsetB(:,1)<0.05 & POffsetB(:,2)<0.05) & MaxStpB'>0)
InhibNeur_FzB = ((PFzNoFzB<0.05) & MeanNoFzB>MeanFzB);
ExcitNeur_FzB = ((PFzNoFzB<0.05) & MeanNoFzB<MeanFzB)


figure
bar(1,nanmean(ExcitNeur_StartB)*100,'FaceColor','b')
hold on
bar(2,nanmean(InhibNeur_StartB)*100,'FaceColor',[0.4 0.4 1])
bar(4,nanmean(ExcitNeur_StopB)*100,'FaceColor','r')
bar(5,nanmean(InhibNeur_StopB)*100,'FaceColor',[1 0.4 0.4])
ylabel('% Modulated neurons')
makepretty
set(gca,'XTick',[1,2,4,5],'XTickLabel',{'Excit','Inhib','Excit','Inhib'})
ylim([0 15])



% Get rid of too low firing neurons

KappaNeur(find(nanmean(StartResp')<0.1))=[];
PValNeur(find(nanmean(StartResp')<0.1))=[];
MeanNoFz(find(nanmean(StartResp')<0.1))=[];
MeanFz(find(nanmean(StartResp')<0.1))=[];
PhaseNeur(find(nanmean(StartResp')<0.1))=[];;
MI = (MeanNoFz-MeanFz)./ (MeanNoFz+MeanFz);
MIB = (MeanNoFzB-MeanFzB)./ (MeanNoFzB+MeanFzB);


DatMatClBZ = zscore(DatMatClB')';
DatMatClZ = zscore(DatMatCl')';


%  CTrls vs OBX
ValsToSortOn = nanmean(abs(DatMatClZ(:,125:175)'));
ValsToSortBON = nanmean(abs(DatMatClBZ(:,125:175)'));
ValsToSortOff = nanmean(abs(DatMatClZ(:,375:425)'));
ValsToSortBOff = nanmean(abs(DatMatClBZ(:,375:425)'));
makepretty
ValsToSortBON(ValsToSortBON<0.1) = [];
ValsToSortBOff(ValsToSortBOff<0.1) = [];

figure
MakeSpreadAndBoxPlot_SB({ValsToSortOn,ValsToSortBON,ValsToSortOff,ValsToSortBOff},{[0.5 0.5 1],[0.2 0.2 1],[1 0.5 0.5],[1 0.2 0.2]},[1,2.5,5,6.5],{'Ctrl','OBX','Ctrl','OBX'},1)
clear p
[p(1),h] = ranksum((ValsToSortOn),(ValsToSortBON));
[p(2),h] = ranksum((ValsToSortOff),(ValsToSortBOff));
sigstar({{1,2.5},{5,6.5}},p)
ylabel('Response magnitude')
makepretty
ylim([0 2.1])

% Mod Non Mod
DatMatClZ(find(nanmean(StartResp')<0.1),:)=[];
ValsToSortOnMod = nanmean(abs(DatMatClZ([PValNeur.Transf]<0.05,125:175)'));
ValsToSortOffMod = nanmean(abs(DatMatClZ([PValNeur.Transf]<0.05,375:425)'));
ValsToSortOnNonMod = nanmean(abs(DatMatClZ([PValNeur.Transf]>0.05,125:175)'));
ValsToSortOffNonMod = nanmean(abs(DatMatClZ([PValNeur.Transf]>0.05,375:425)'));

figure
MakeSpreadAndBoxPlot_SB({ValsToSortOnNonMod,ValsToSortOnMod,ValsToSortOffNonMod,ValsToSortOffMod},{[0.5 0.5 1],[0.2 0.2 1],[1 0.5 0.5],[1 0.2 0.2]},[1,2.5,5,6.5],{'NonMod','Mod','NonMod','Mod'},1)
clear p
[p(1),h] = ranksum((ValsToSortOnMod),(ValsToSortOnNonMod));
[p(2),h] = ranksum((ValsToSortOffMod),(ValsToSortOffNonMod));
sigstar({{1,2.5},{5,6.5}},p)
ylabel('Response magnitude')
makepretty
ylim([0 2.1])



InhibNeur_Start = (POnset(:,1)<0.05 & POnset(:,2)<0.05 & MaxSrt'<0);
ExcitNeur_Start = (POnset(:,1)<0.05 & POnset(:,2)<0.05 & MaxSrt'>0);
InhibNeur_Stop = ((POffset(:,1)<0.05 & POffset(:,2)<0.05) & MaxStp'<0);
ExcitNeur_Stop = ((POffset(:,1)<0.05 & POffset(:,2)<0.05) & MaxStp'>0);

InhibNeur_Start(find(nanmean(StartResp')<0.1))=[];
ExcitNeur_Start(find(nanmean(StartResp')<0.1))=[];
InhibNeur_Stop(find(nanmean(StartResp')<0.1))=[];
ExcitNeur_Stop(find(nanmean(StartResp')<0.1))=[];




ValsToSortOn = nanmean((DatMatClZ(:,125:175)'));
ValsToSortOff = nanmean((DatMatClZ(:,375:425)'));

