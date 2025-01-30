clear all

Dir.path{1} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse248_20150326-EXT-24h-envC\20150326-EXT-24h-envC';
Dir.path{2} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse244_20150507-EXT-24h-envB\20150507-EXT-24h-envB';
Dir.path{3} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse244_20150507-EXT-24h-envB\20150507-EXT-24h-envB';
Dir.path{4} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse243_20150506-EXT-24h-envC\20150506-EXT-24h-envC';
Dir.path{5} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse243_20150507-EXT-24h-envB\20150507-EXT-24h-envB';
Dir.path{6} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse253_20150703-EXT-24h-envC_FEAR-Mouse-253-03072015\FEAR-Mouse-253-03072015';
Dir.path{7} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse254_20150703-EXT-24h-envC\20150703-EXT-24h-envC';
Dir.path{8} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse258_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
Dir.path{9} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse259_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
Dir.path{10} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse299_20151217-EXT-24h-envC\20151217-EXT-24h-envC';
Dir.path{11} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse394_FEAR-Mouse-394-EXT-24-envBraye_161020_163239_\FEAR-Mouse-394-EXT-24-envBraye_161020_163239';
Dir.path{12} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse395_FEAR-Mouse-395-EXT-24-envBraye_161020_155350_\FEAR-Mouse-395-EXT-24-envBraye_161020_155350';
Dir.path{13} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse402_FEAR-Mouse-402-EXT-24-envB_raye_161026_164106_\FEAR-Mouse-402-EXT-24-envB_raye_161026_164106';
Dir.path{14} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse403_FEAR-Mouse-403-EXT-24-envB_raye_161026_171611_\FEAR-Mouse-403-EXT-24-envB_raye_161026_171611';
Dir.path{15} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse450_FEAR-Mouse-450-EXT-24-envB_161026_174952_\FEAR-Mouse-450-EXT-24-envB_161026_174952';
Dir.path{16} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse451_FEAR-Mouse-451-EXT-24-envB_161026_182307_\FEAR-Mouse-451-EXT-24-envB_161026_182307';

DirB.path{1} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse291_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
DirB.path{2} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse297_20151217-EXT-24h-envC\20151217-EXT-24h-envC';
DirB.path{3} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse298_20151217-EXT-24h-envC\20151217-EXT-24h-envC';


neur = 0;
for k = 1:length(Dir.path)
    cd(Dir.path{k})
    
    if exist('SpikeData.mat')>0
        
        load('filteredLFP\MiniMaxiLFPOB1.mat')
        load(['LFPData/LFP',num2str(channel),'.mat'])
        FilLFP = FilterLFP(LFP,[1 20],1024);
        DatLFP = Data(FilLFP);
        tpsLFP = Range(FilLFP);
        load('behavResources.mat')
        if exist('FreezeAccEpoch')
            FreezeEpoch = FreezeAccEpoch;
        end
        load('SpikeData.mat')
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
        S = S(numNeurons);
        
        for ph = 1:4
            PhaseEpoch1 = thresholdIntervals(PhaseInterpol,(pi/2)*(ph-1)+0.01,'Direction','Above');
            PhaseEpoch2 = thresholdIntervals(PhaseInterpol,(pi/2)*(ph)-0.01,'Direction','Below');
            PhaseEpoch = and(PhaseEpoch1,PhaseEpoch2);
            SNew = Restrict(S,PhaseEpoch);
            for sp = 1:length(S)
                [StartRespPh(sp+neur,ph,:),B] = CrossCorr(Start(FreezeEpoch),Range(SNew{sp}),20,250);
                [StopRespPh(sp+neur,ph,:),B] = CrossCorr(Stop(FreezeEpoch),Range(SNew{sp}),20,250);
            end
        end
        
        for sp = 1:length(S)
            [StartResp(sp+neur,:), B] = CrossCorr(Start(FreezeEpoch),Range(S{sp}),20,250);
            [StopResp(sp+neur,:), B] = CrossCorr(Stop(FreezeEpoch),Range(S{sp}),20,250);
        end
        
        neur=neur+length(S);
    end
end


DatMat = zscore([StartResp,StopResp]')';
DatMat(find(nanmean(StartResp')<0.1),:) = [];
[EigVect,EigVals]=PerformPCA(DatMat);
[val,ind] = sort(EigVect(:,1));
subplot(3,1,1:2)
imagesc([B;B+5000]/1E3,size(DatMat,2),DatMat(ind,:))
caxis([-3 3])
xlabel('Time to Fz onset(s)')
set(gca,'LineWidth',2,'FontSize',12), box off
subplot(3,1,3)
plot([B;B+5000]/1E3,EigVect(:,1)'*zscore(DatMat')')
hold on
plot([B;B+5000]/1E3,EigVect(:,2)'*zscore(DatMat')')
xlim([-2.5 7.5])
set(gca,'LineWidth',2,'FontSize',12), box off
xlabel('Time to Fz onset(s)')
legend('PC1','PC2')

figure
for k = 1:4
    subplot(2,2,k)
    DatMat = zscore([squeeze(StartRespPh(:,k,:)),squeeze(StopRespPh(:,k,:))]')';
    DatMat(find(nanmean(StartResp')<0.1),:) = [];
    imagesc([B;B+5000]/1E3,size(DatMat,2),DatMat(ind,:))
    caxis([-3 3])
    xlabel('Time to Fz onset(s)')
    set(gca,'LineWidth',2,'FontSize',12), box off
    title(['Phase ' num2str(k)])
end
figure
for k = 1:4
    subplot(2,2,k)
    DatMat = zscore([squeeze(StartRespPh(:,k,:)),squeeze(StopRespPh(:,k,:))]')';
    DatMat(find(nanmean(StartResp')<0.1),:) = [];
    
    plot([B;B+5000]/1E3,smooth(EigVect(:,1)'*zscore(DatMat')',10))
    hold on
    plot([B;B+5000]/1E3,smooth(EigVect(:,2)'*zscore(DatMat')',10))
    xlim([-2.5 7.5])
    set(gca,'LineWidth',2,'FontSize',12), box off
    xlabel('Time to Fz onset(s)')
    legend('PC1','PC2')
    ylim([-10 10])
        title(['Phase ' num2str(k)])

end