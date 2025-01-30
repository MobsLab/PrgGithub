clear all
FolderName = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/PopulationCodingAcrossTasks/';
BinSizes = [0.05,0.1,0.2,0.5]*1e4;
MinDur = [6,8,10]*1e4;

Titles = {'EPM','UMazeFz','UMazeMv','UMazeAll'};

MiceNumber=[490,507,508,509,510,512,514];
figure(1)
figure(2)

for BS = 1:length(BinSizes)
    for MD = 1:length(MinDur)
        
        Binsize = BinSizes(BS);
        Mindur = MinDur(MD);
        
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
            
            
            FreezeEpochToUse{1} = and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above'));
            FreezeEpochToUse{1} = dropShortIntervals(FreezeEpochToUse{1},Mindur);
            FreezeEpochToUse{2} = and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below'));
            FreezeEpochToUse{2} = dropShortIntervals(FreezeEpochToUse{2},Mindur);
            FreezeEpochToUse{3} = dropShortIntervals(FreezeEpoch,8*1e4);
            
            for sd = 1:3
                for ep = 1:length(Start(FreezeEpochToUse{sd}))-1
                    BegEpoch = intervalSet(Start(subset(FreezeEpochToUse{sd},ep))-2*1e4,Start(subset(FreezeEpochToUse{sd},ep))+Mindur/2);
                    EndEpoch = intervalSet(Stop(subset(FreezeEpochToUse{sd},ep))-Mindur/2,Stop(subset(FreezeEpochToUse{sd},ep))+2*1e4);
                    AllCorr{mm}{sd}(ep,:,:) = full(corr(zscore([Data(Restrict(Q,BegEpoch))',Data(Restrict(Q,EndEpoch))']')'));
                    
                    BegEpoch = intervalSet(Start(subset(FreezeEpochToUse{sd},ep)),Start(subset(FreezeEpochToUse{sd},ep))+Mindur/2);
                    EndEpoch = intervalSet(Stop(subset(FreezeEpochToUse{sd},ep))-Mindur/2,Stop(subset(FreezeEpochToUse{sd},ep)));
                    AllCorrFzOnly{mm}{sd}(ep,:,:) = full(corr(zscore([Data(Restrict(Q,BegEpoch))',Data(Restrict(Q,EndEpoch))']')'));
                end
            end
            
            
            for sd = 1:3
                FromStart{mm}{sd} = nan(Mindur/Binsize,Mindur/Binsize);
                
                temp = zeros(Mindur/Binsize,Mindur/Binsize);
                tempcount = zeros(Mindur/Binsize,Mindur/Binsize);
                
                for ep = 1:length(Start(FreezeEpochToUse{sd}))-1
                    Epoch = intervalSet(Start(subset(FreezeEpochToUse{sd},ep)),Stop(subset(FreezeEpochToUse{sd},ep)));
                    tempMat = (full(corr(zscore([Data(Restrict(Q,Epoch))']')')));
                    % correlation from start of freezing
                    for i = 1:min([length(tempMat),Mindur/Binsize])
                        if (i-(Mindur/2)/Binsize)<=0 & (length(tempMat)-(i+(Mindur/2)/Binsize))<0
                            line = [nan(1,abs(i-(Mindur/2)/Binsize)),tempMat(i,max([i-(Mindur/2)/Binsize,1]):min([i+(Mindur/2)/Binsize,length(tempMat)])),nan(1,abs(i+(Mindur/2)/Binsize-length(tempMat)))];
                            temp(i,:) = nansum([temp(i,:);line]);
                            tempcount(i,:) = tempcount(i,:) + not(isnan(line));
                            
                        elseif (i-(Mindur/2)/Binsize)<=0 & (length(tempMat)-(i+(Mindur/2)/Binsize))>=0
                            line = [nan(1,abs(i-(Mindur/2)/Binsize)),tempMat(i,max([i-(Mindur/2)/Binsize,1]):min([i+(Mindur/2)/Binsize,length(tempMat)]))];
                            temp(i,:) = nansum([temp(i,:);line]);
                            tempcount(i,:) = tempcount(i,:) + not(isnan(line));
                            
                        elseif (i-(Mindur/2)/Binsize)>0 & (length(tempMat)-(i+(Mindur/2)/Binsize))<0
                            line = [tempMat(i,max([i-(Mindur/2)/Binsize+1,1]):min([i+(Mindur/2)/Binsize,length(tempMat)])),nan(1,abs(i+(Mindur/2)/Binsize-length(tempMat)))];
                            temp(i,:) = nansum([temp(i,:);line]);
                            tempcount(i,:) = tempcount(i,:) + not(isnan(line));
                            
                        elseif (i-(Mindur/2)/Binsize)>0 & (length(tempMat)-(i+(Mindur/2)/Binsize))>=0
                            line = [tempMat(i,max([i-(Mindur/2)/Binsize+1,1]):min([i+(Mindur/2)/Binsize,length(tempMat)]))];
                            temp(i,:) = nansum([temp(i,:);line]);
                            tempcount(i,:) = tempcount(i,:) + not(isnan(line));
                            
                        end
                        
                    end
                end
                
                FromStart{mm}{sd} = temp./tempcount;
                FromStart{mm}{sd}(:,10) = NaN;
                
                
                % From end
                FromStop{mm}{sd} = nan(Mindur/Binsize,Mindur/Binsize);
                % put the matrix back to front so that the same code runs for
                % freezing stop
                
                temp = zeros(Mindur/Binsize,Mindur/Binsize);
                tempcount = zeros(Mindur/Binsize,Mindur/Binsize);
                
                for ep = 1:length(Start(FreezeEpochToUse{sd}))-1
                    Epoch = intervalSet(Start(subset(FreezeEpochToUse{sd},ep)),Stop(subset(FreezeEpochToUse{sd},ep)));
                    tempMat = (full(corr(zscore([Data(Restrict(Q,Epoch))']')')));
                    tempMat = fliplr(fliplr(tempMat)');
                    
                    % correlation from start of freezing
                    for i = 1:min([length(tempMat),Mindur/Binsize])
                        
                        if (i-(Mindur/2)/Binsize)<=0 & (length(tempMat)-(i+(Mindur/2)/Binsize))<0
                            line = [nan(1,abs(i-(Mindur/2)/Binsize)),tempMat(i,max([i-(Mindur/2)/Binsize,1]):min([i+(Mindur/2)/Binsize,length(tempMat)])),nan(1,abs(i+(Mindur/2)/Binsize-length(tempMat)))];
                            temp(i,:) = nansum([temp(i,:);line]);
                            tempcount(i,:) = tempcount(i,:) + not(isnan(line));
                            
                        elseif (i-(Mindur/2)/Binsize)<=0 & (length(tempMat)-(i+(Mindur/2)/Binsize))>=0
                            line = [nan(1,abs(i-(Mindur/2)/Binsize)),tempMat(i,max([i-(Mindur/2)/Binsize,1]):min([i+(Mindur/2)/Binsize,length(tempMat)]))];
                            temp(i,:) = nansum([temp(i,:);line]);
                            tempcount(i,:) = tempcount(i,:) + not(isnan(line));
                            
                        elseif (i-(Mindur/2)/Binsize)>0 & (length(tempMat)-(i+(Mindur/2)/Binsize))<0
                            line = [tempMat(i,max([i-(Mindur/2)/Binsize+1,1]):min([i+(Mindur/2)/Binsize,length(tempMat)])),nan(1,abs(i+(Mindur/2)/Binsize-length(tempMat)))];
                            temp(i,:) = nansum([temp(i,:);line]);
                            tempcount(i,:) = tempcount(i,:) + not(isnan(line));
                            
                        elseif (i-(Mindur/2)/Binsize)>0 & (length(tempMat)-(i+(Mindur/2)/Binsize))>=0
                            line = [tempMat(i,max([i-(Mindur/2)/Binsize+1,1]):min([i+(Mindur/2)/Binsize,length(tempMat)]))];
                            temp(i,:) = nansum([temp(i,:);line]);
                            tempcount(i,:) = tempcount(i,:) + not(isnan(line));
                            
                        end
                        
                    end
                end
                
                FromStop{mm}{sd} = temp./tempcount;
                FromStop{mm}{sd}(:,10) = NaN;
                
                
            end
            
        end
        cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/StabilityPFC
        save(['CorrMatTime_BinSz=' num2str(Binsize/1e4) 'Dur' num2str(Mindur/1e4) '.mat'],'AllCorr','AllCorrFzOnly','FromStart','FromStop')
        disp('saved')
    end
end




figure
clear MByM
for sd = 1:3
    for mm = 1 : length(MiceNumber)
%         subplot(3,length(MiceNumber),(sd-1)*length(MiceNumber)+mm)
%         imagesc(SmoothDec(squeeze(nanmean(AllCorrFzOnly{mm}{sd},1)),[0.1 0.1]))
%         clim([-0.1 0.1])
        try
            MByM(mm,:,:) = squeeze(nanmean(AllCorr{mm}{sd},1));
        catch
            MByM(mm,:,:) = nan(length(AllCorr{1}{1}),length(AllCorr{1}{1}));
        end
    end
    AvM{sd} = squeeze(nanmean(MByM,1));
end

tps = [1,20,50,80,100];
TpsLabels = {'2sbef','Start','Start+3s/Stop-3s','Stop','2aft'}
Titles = {'Safe Fz','Shock Fz'};
for sd = 1:2
    subplot(2,2,sd)
    imagesc(tps,tps,SmoothDec(AvM{sd},[0.5 0.5]))
    %     imagesc(AvM{sd})
    clim([-0.07 0.07])
    set(gca,'XTick',tps,'XTickLabel',TpsLabels,'YTick',tps,'YTickLabel',TpsLabels)
    line([20 20],ylim,'color','k','linewidth',2)
    line([80 80],ylim,'color','k','linewidth',2)
    line(xlim,[20 20],'color','k','linewidth',2)
    line(xlim,[80 80],'color','k','linewidth',2)
    title(Titles{sd})
end


clear MByM
for sd = 1:3
    for mm = 1 : length(MiceNumber)
%         subplot(3,length(MiceNumber),(sd-1)*length(MiceNumber)+mm)
%         imagesc(SmoothDec(squeeze(nanmean(AllCorrFzOnly{mm}{sd},1)),[0.1 0.1]))
%         clim([-0.1 0.1])
        try
            MByM(mm,:,:) = squeeze(nanmean(AllCorrFzOnly{mm}{sd},1));
        catch
            MByM(mm,:,:) = nan(length(AllCorrFzOnly{1}{1}),length(AllCorrFzOnly{1}{1}));
        end
    end
    AvM{sd} = squeeze(nanmean(MByM,1));
end


tps = [1,30,60];
TpsLabels = {'Start','Start+3s/Stop-3s','Stop'}
Titles = {'Safe Fz','Shock Fz'};
for sd = 1:2
    subplot(2,2,sd+2)
    imagesc(tps,tps,SmoothDec(AvM{sd},[0.5 0.5]))
    %     imagesc(AvM{sd})
    clim([-0.07 0.07])
    set(gca,'XTick',tps,'XTickLabel',TpsLabels,'YTick',tps,'YTickLabel',TpsLabels)
    title(Titles{sd})
end

figure
for mm = 1 : length(MiceNumber)
    for sd = 1:3
        subplot(3,length(MiceNumber),(sd-1)*length(MiceNumber)+mm)
        imagesc(FromStart{mm}{sd})
        clim([-0.1 0.1])
    end
end


figure
clear AllMiceStart AllMiceStop
for sd = 1:2
    for mm = 1 : length(MiceNumber)
        subplot(4,length(MiceNumber),(sd-1)*length(MiceNumber)+mm)
        imagesc((FromStart{mm}{sd}))
        clim([-0.1 0.1])
        colormap((redblue')')
        AllMiceStart{sd}(mm,:,:) = FromStart{mm}{sd};
    end
end


for sd = 1:2
    for mm = 1 : length(MiceNumber)
        subplot(4,length(MiceNumber),(sd+2-1)*length(MiceNumber)+mm)
        imagesc(fliplr(FromStop{mm}{sd}))
        clim([-0.1 0.1])
        colormap((redblue')')
        axis xy
            AllMiceStop{sd}(mm,:,:) = FromStop{mm}{sd};

    end
    
end

tpsY = [0:0.1:6];
tpsX = [-3:0.1:3];
figure
subplot(2,2,1)
imagesc(tpsX,tpsY,squeeze(nanmean(AllMiceStart{1})))
clim([-0.1 0.1])
colormap((redblue')')
title('Safe side')
ylabel('Time from freezing start')
xlabel('Time (s)')

subplot(2,2,2)
imagesc(tpsX,tpsY,squeeze(nanmean(AllMiceStart{2})))
clim([-0.1 0.1])
colormap((redblue')')
title('Shock side')
ylabel('Time from freezing start')
xlabel('Time (s)')

subplot(2,2,3)
imagesc(tpsX,tpsY,fliplr(squeeze(nanmean(AllMiceStop{1}))))
clim([-0.1 0.1])
colormap((redblue')')
title('Safe side')
axis xy
ylabel('Time from freezing stop')
xlabel('Time (s)')

subplot(2,2,4)
imagesc(tpsX,tpsY,fliplr(squeeze(nanmean(AllMiceStop{2}))))
clim([-0.1 0.1])
colormap((redblue')')
title('Shock side')
axis xy
ylabel('Time from freezing stop')
xlabel('Time (s)')

% trying some stuff
FreezeEpochToUse{1} = and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above'));
FreezeEpochToUse{1} = dropShortIntervals(FreezeEpochToUse{1},Mindur);
FreezeEpochToUse{2} = and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below'));
FreezeEpochToUse{2} = dropShortIntervals(FreezeEpochToUse{2},Mindur);
FreezeEpochToUse{3} = dropShortIntervals(FreezeEpoch,Mindur);

Binsize = 1*1e4;
Q = MakeQfromS(Spikes(numNeurons),Binsize);
Q = Restrict(Q,intervalSet(0,2500*1e4));
fr = (full(nanmean(Data(Q))));
Q = tsd(Range(Q),zscore(Data(Q)));
Qt = Restrict(Q,FreezeEpochToUse{1});
spk = Data(Qt)';
Qt = Restrict(Q,FreezeEpochToUse{2});
spk = [spk,Data(Qt)'];
imagesc(corr(spk(fr>0.1,:)))
colorbar
clim([-1 1])
