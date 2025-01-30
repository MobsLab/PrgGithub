clear all
FolderName = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/StabilityPFC/';
BinSizes = [0.05,0.1,0.2,0.5]*1e4;
MinDur = [6,8,10]*1e4;

Titles = {'EPM','UMazeFz','UMazeMv','UMazeAll'};

MiceNumber=[490,507,508,509,510,512,514];
figure(1)


NumBins = 10;
MinDur = 4*1e4;
Binsize = 0.1*1e4;

clear AllCorrFzOnly AllCorr FromStart FromStop

for mm = 1 : length(MiceNumber)
    
    Dir = GetAllMouseTaskSessions(MiceNumber(mm));
    Dir = Dir(find(~((cellfun(@isempty,strfind(Dir,'UMazeCond'))))));
    
    % epochs
    NoiseEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','noiseepoch');
    FreezeEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','freezeepoch');
    StimEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','stimepoch');
    ZoneEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','zoneepoch');
    
    Vtsd = ConcatenateDataFromFolders_SB(Dir,'speed');
    Postsd = ConcatenateDataFromFolders_SB(Dir,'position');
    
    LinPos = ConcatenateDataFromFolders_SB(Dir,'linearposition');
    
    % Spikes
    Spikes = ConcatenateDataFromFolders_SB(Dir,'Spikes');
    cd(Dir{1})
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx','remove_MUA',1);
    Spikes = Spikes(numNeurons);
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    Q = tsd(Range(Q),zscore(Data(Q)));
    
    FreezeEpochToUse{1} = and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above'));
    FreezeEpochToUse{1} = dropShortIntervals(FreezeEpochToUse{1},MinDur);
    FreezeEpochToUse{2} = and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below'));
    FreezeEpochToUse{2} = dropShortIntervals(FreezeEpochToUse{2},MinDur);
    FreezeEpochToUse{3} = dropShortIntervals(FreezeEpoch,8*1e4);
    
    
    clear Vect
    for sd = 1:3
        for ep = 1:length(Start(FreezeEpochToUse{sd}))-1
            LittleEpoch = intervalSet(subset(FreezeEpochToUse{sd},ep));
            dur = Stop(LittleEpoch)-Start(LittleEpoch);
            blockdur = dur/NumBins;
            
            for i = 1:NumBins+4
                Little_LitteEoch = intervalSet(Start(LittleEpoch)+(i-3)*blockdur,Start(LittleEpoch)+(i-2)*blockdur);
                Vect{sd}(ep,i,:) = full(nanmean(Data(Restrict(Q,Little_LitteEoch))));
            end
        end
    end
    
    clear AllCorr
    for sd = 1:3
        for ep = 1:size(Vect{sd},1)
            AllCorr(ep,:,:) = corr(squeeze(Vect{sd}(ep,:,:))');
        end
        subplot(4,3,sd)
        imagesc(squeeze(nanmean(AllCorr))-diag(diag(squeeze(nanmean(AllCorr)))))
        %                 clim([-0.4 0.8])
        AveragedCorr{sd}{mm} = squeeze(nanmean(AllCorr))-diag(diag(squeeze(nanmean(AllCorr))));

        
    end
    
    clear Corr MeanCorr
    for sd = 1:3
        for tps = 1:size(Vect{sd},2)
            for ep = 1:size(Vect{sd},1)
                for ep2 = 1:size(Vect{sd},1)
                    R = corrcoef(squeeze(Vect{sd}(ep,tps,:))',squeeze(Vect{sd}(ep2,tps,:))');
                    Corr(ep,ep2) =R(1,2) ;
                end
            end
            Corr = Corr - diag(diag(Corr));
            MeanCorr(tps) = nanmean(Corr(:));
        end
        subplot(4,3,sd+3)
        plot(MeanCorr)
        TimeCorr{sd}{mm} = MeanCorr;

    end
    
    
    
    clear Corr MeanCorr
    for sd = 1:3
        for tps = 1:size(Vect{sd},2)
            for tps2 = 1:size(Vect{sd},2)
                for ep = 1:size(Vect{sd},1)
                    for ep2 = 1:size(Vect{sd},1)
                        R = corrcoef(squeeze(Vect{sd}(ep,tps,:))',squeeze(Vect{sd}(ep2,tps2,:))');
                        Corr(ep,ep2) =R(1,2) ;
                    end
                end
                Corr = Corr - diag(diag(Corr));
                MeanCorr(tps,tps2) = nanmean(Corr(:));
            end
        end
        subplot(4,3,sd+6)
        imagesc(MeanCorr)
        TimeByTimeCorr{sd}{mm} = MeanCorr;

    end
    
    clear Corr MeanCorr
    for sd = 1:3
        subplot(4,3,sd+9)
        imagesc(corr(squeeze(nanmean(Vect{sd},1))')'-diag(diag(corr(squeeze(nanmean(Vect{sd},1))')')))
        AveragedCorr{sd}{mm} = corr(squeeze(nanmean(Vect{sd},1))')'-diag(diag(corr(squeeze(nanmean(Vect{sd},1))')'));
    end
    
    saveas(1,[FolderName,'M',num2str(mm),'NormFreezingCorr.png'])
    clf
    
end
cd FolderName
saveas('CorrmatNormFreezing.mat','AveragedCorr','TimeByTimeCorr','TimeCorr','AveragedCorr')