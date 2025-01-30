clear all

% Paramters
BurstNum = [2,3,4,5];
InterBurstInterval = [0.2:0.05:1]; % in seconds
t_mergeEp=3; % in seconds
t_dropEp=1; % in seconds
Binsize = 1*1e4;
min_delta_duration = 75*10; % same as Marie's paper
% Data location
Dir=PathForExperimentsSleepRipplesSpikes('Basal');

for k = 1:length(Dir.path)
    
    cd(Dir.path{k})
    disp(Dir.path{k})
    
    % Load LFP to get time right
    load('LFPData/LFP1.mat')
    AllTime = tsd(Range(LFP),[1:length(Range(LFP))]');
    tps = Range(LFP);
    
    % Get the neurons from the PFCx
    load('SpikeData.mat')
    [numNeurons, numtt, TT] = GetSpikesFromStructure('PFCx','remove_MUA',1);
    try,S = tsdArray(S);end
    S = S(numNeurons);
    S{1} = tsd([0;Range(S{1});max(Range(LFP))],[0;Range(S{1});max(Range(LFP))]);
    Q = MakeQfromS(S,Binsize);
    
    % Arrange everything (downstates and sleep epochs) with the right bins
    load('DownState.mat')
    
    % Downs
    timeEvents = Data(Restrict(AllTime,down_PFCx));
    binsEvents = tsdArray(tsd([0;tps(timeEvents);max(Range(LFP))],[0;tps(timeEvents);max(Range(LFP))]));
    QEvents = MakeQfromS(binsEvents,Binsize);
    QDown = tsd(Range(QEvents),Data(QEvents)/2500); % divide by number of bins in 2seconds
    DatQ = Data(Q);
    for sp = 1:length(numNeurons)
        DatQ(:,sp) = DatQ(:,sp)./(1-Data(QDown));
    end
    Q_downcorr = tsd(Range(Q),DatQ);
    
    load('FeaturesScoring.mat')

        
    for ibi = 1:length(InterBurstInterval)
        for bnum = 1:length(BurstNum)
                        
            [Epoch, NameEpoch] = SubstagesScoring_VaryN3Definition(featuresNREM, NoiseEpoch, InterBurstInterval(ibi),BurstNum(bnum));

    
            EpochOfInterest = Epoch(1:5);
            
            for ep = 1:5
                TotDur{k}(ibi,bnum,ep) = sum(Stop(EpochOfInterest{ep},'s')-Start(EpochOfInterest{ep},'s'));
                timeEvents = Data(Restrict(AllTime,EpochOfInterest{ep}));
                binsEvents = tsdArray(tsd([0;tps(timeEvents);max(Range(LFP))],[0;tps(timeEvents);max(Range(LFP))]));
                QEvents = MakeQfromS(binsEvents,Binsize);
                dat_temp = Data(QEvents)/(1250*Binsize/1e4);
                tps_temp = Range(QEvents);
                tps_temp(dat_temp<0.75) = [];
                CleanedEpoch.(NameEpoch{ep}) = intervalSet(tps_temp,tps_temp+Binsize);
                Vals.(NameEpoch{ep}) = Data(Restrict(Q,CleanedEpoch.(NameEpoch{ep})));
                Tps.(NameEpoch{ep}) = Range(Restrict(Q,CleanedEpoch.(NameEpoch{ep})));
                Vals_downcorr.(NameEpoch{ep}) = Data(Restrict(Q_downcorr,CleanedEpoch.(NameEpoch{ep})));
            end
            
            
            [Acc_all,Acc_ConfMat,MeanW] = MultiClassBinaryDecoder_SB(Vals,'permutnum',100,'dorand',0,'testonfr',0);
            [Acc_all_downcorr,Acc_ConfMat_downcorr,MeanW_downcorr] = MultiClassBinaryDecoder_SB(Vals_downcorr,'permutnum',100,'dorand',0,'testonfr',0);
            [Acc_all_Rand,Acc_ConfMat_Rand,MeanW_Rand] = MultiClassBinaryDecoder_SB(Vals,'permutnum',100,'dorand',1,'testonfr',0);
            [Acc_all_FRContr,Acc_ConfMat_FRContr,MeanW_FRContr] = MultiClassBinaryDecoder_SB(Vals,'permutnum',100,'dorand',0,'testonfr',1);
            
            
            FinalAccuracy{k}(ibi,bnum) = (nanmean(Acc_ConfMat(2,3,:))+nanmean(Acc_ConfMat(3,2,:)))/2;
            FinalAccuracy_downcorr{k}(ibi,bnum) = (nanmean(Acc_ConfMat_downcorr(2,3,:))+nanmean(Acc_ConfMat_downcorr(3,2,:)))/2;
            FinalAccuracy_Rand{k}(ibi,bnum) = (nanmean(Acc_ConfMat_Rand(2,3,:))+nanmean(Acc_ConfMat_Rand(3,2,:)))/2;
            FinalAccuracy_FR{k}(ibi,bnum) = (nanmean(Acc_ConfMat_FRContr(2,3,:))+nanmean(Acc_ConfMat_FRContr(3,2,:)))/2;

            SignifAccuracy{k}(ibi,bnum) = sum(squeeze((Acc_ConfMat(2,3,:)+Acc_ConfMat(3,2,:))/2)>squeeze((Acc_ConfMat_Rand(2,3,:)+Acc_ConfMat_Rand(3,2,:))/2))/100;
            SignifAccuracy_downcorr{k}(ibi,bnum) = sum(squeeze((Acc_ConfMat_downcorr(2,3,:)+Acc_ConfMat_downcorr(3,2,:))/2)>squeeze((Acc_ConfMat_Rand(2,3,:)+Acc_ConfMat_Rand(3,2,:))/2))/100;
            
            ConfusionMat{k}(ibi,bnum,:,:) = squeeze(nanmean(Acc_ConfMat,3));
            ConfusionMat_downcorr{k}(ibi,bnum,:,:) = squeeze(nanmean(Acc_ConfMat_downcorr,3));
            
        end            
    end
    
end
save('DecodeN2N3DifferentPArams.mat','ConfusionMat_downcorr','ConfusionMat','TotDur','FinalAccuracy','FinalAccuracy_downcorr','FinalAccuracy_Rand','FinalAccuracy_FR','SignifAccuracy_downcorr','SignifAccuracy')


GoodMice = [1:16,19];
clf
for k = 1:length(GoodMice)
    subplot(4,5,k)
    imagesc(BurstNum,InterBurstInterval,FinalAccuracy{GoodMice(k)}.*(SignifAccuracy{GoodMice(k)}>0.95))
    caxis([0.4 0.7])
    colorbar
    title([Dir.name{GoodMice(k)}])
    hold on,plot(2,0.7,'.k','MarkerSize',30)
    hold on,plot(2,0.7,'w*')
    PeakAccuracy(k) = max(max(FinalAccuracy{GoodMice(k)}.*(SignifAccuracy{GoodMice(k)}>0.95)));
    IsSig(k,:,:) = FinalAccuracy{GoodMice(k)}.*(SignifAccuracy{GoodMice(k)}>0.95);
end
IsSig(IsSig==0)=NaN;

clf
for k = 1:length(GoodMice)
    subplot(4,5,k)
    imagesc(BurstNum,InterBurstInterval,FinalAccuracy_downcorr{GoodMice(k)}.*(SignifAccuracy_downcorr{GoodMice(k)}>0.95))
    caxis([0.4 0.7])
    colorbar
    title([Dir.name{GoodMice(k)}])
    hold on,plot(2,0.7,'.k','MarkerSize',30)
    hold on,plot(2,0.7,'w*')
        IsSig_downcorr(k,:,:) = FinalAccuracy_downcorr{GoodMice(k)}.*(SignifAccuracy_downcorr{GoodMice(k)}>0.95);

end
IsSig_downcorr(IsSig_downcorr==0)=NaN;

figure
clf
for k = 1:length(GoodMice)
    subplot(4,5,k)
    imagesc(BurstNum,InterBurstInterval,squeeze((TotDur{GoodMice(k)}(:,:,2)./(TotDur{GoodMice(k)}(:,:,2)+TotDur{GoodMice(k)}(:,:,3)))))
    colorbar
    clim([0.2 1])

    title([Dir.name{GoodMice(k)}])
    hold on,plot(2,0.7,'w*')
    AvTot(k,:,:) = squeeze((TotDur{GoodMice(k)}(:,:,2)./(TotDur{GoodMice(k)}(:,:,2)+TotDur{GoodMice(k)}(:,:,3))));
end

clf
imagesc(BurstNum,InterBurstInterval,100*squeeze(nanmean(AvTot,1)))
Mat = 100*squeeze(nanmean(AvTot,1))';
for k = 1:length(BurstNum)
    for kk = 1:length(InterBurstInterval)
        text(BurstNum(k),InterBurstInterval(kk),num2str(Mat(k,kk)))
    end
end
colorbar
title('% of N2 in N2/N3')
hold on,plot(2,0.7,'.k','MarkerSize',30)
hold on,plot(2,0.7,'w*')
clim([0 100])
xlabel('Delta waves in burst')
ylabel('Inter delta interval for burst')
set(gca,'FontSize',12,'linewidth',2)


figure
subplot(221)
imagesc(BurstNum,InterBurstInterval,squeeze(nanmean(IsSig,1)))
colorbar
title('Average accuracy')
hold on,plot(2,0.7,'.k','MarkerSize',30)
hold on,plot(2,0.7,'w*')
clim([0.3 0.7])
xlabel('Delta waves in burst')
ylabel('Inter delta interval for burst')
set(gca,'FontSize',12,'linewidth',2)



subplot(222)
imagesc(BurstNum,InterBurstInterval,100-100*squeeze(sum(isnan(IsSig),1))/length(GoodMice))
colorbar
title('% of nights with sig decoding')
hold on,plot(2,0.7,'.k','MarkerSize',30)
hold on,plot(2,0.7,'w*')
clim([0 100])
xlabel('Delta waves in burst')
ylabel('Inter delta interval for burst')
set(gca,'FontSize',12,'linewidth',2)



subplot(223)
imagesc(BurstNum,InterBurstInterval,squeeze(nanmean(IsSig_downcorr,1)))
colorbar
title('Average accuracy')
hold on,plot(2,0.7,'.k','MarkerSize',30)
hold on,plot(2,0.7,'w*')
clim([0.3 0.7])
xlabel('Delta waves in burst')
ylabel('Inter delta interval for burst')
set(gca,'FontSize',12,'linewidth',2)



subplot(224)
imagesc(BurstNum,InterBurstInterval,100-100*squeeze(sum(isnan(IsSig_downcorr),1))/length(GoodMice))
colorbar
title('% of nights with sig decoding')
hold on,plot(2,0.7,'.k','MarkerSize',30)
hold on,plot(2,0.7,'w*')
clim([0 100])
xlabel('Delta waves in burst')
ylabel('Inter delta interval for burst')
set(gca,'FontSize',12,'linewidth',2)


