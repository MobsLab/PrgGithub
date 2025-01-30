clear all

Dir.path{1} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse244_20150506-EXT-24h-envC\20150506-EXT-24h-envC';
Dir.path{2} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse253_20150703-EXT-24h-envC_FEAR-Mouse-253-03072015\FEAR-Mouse-253-03072015';
Dir.path{3} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse254_20150703-EXT-24h-envC\20150703-EXT-24h-envC';
Dir.path{4} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse258_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
Dir.path{5} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse259_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
Dir.path{6} = 'D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse299_20151217-EXT-24h-envC\20151217-EXT-24h-envC';
Dir.path{7} = 'D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse394_FEAR-Mouse-394-EXT-24-envBraye_161020_163239_\FEAR-Mouse-394-EXT-24-envBraye_161020_163239';
Dir.path{8} = 'D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse395_FEAR-Mouse-395-EXT-24-envBraye_161020_155350_\FEAR-Mouse-395-EXT-24-envBraye_161020_155350';
Dir.path{9} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse402_FEAR-Mouse-402-EXT-24-envB_raye_161026_164106_\FEAR-Mouse-402-EXT-24-envB_raye_161026_164106';
Dir.path{10} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse403_FEAR-Mouse-403-EXT-24-envB_raye_161026_171611_\FEAR-Mouse-403-EXT-24-envB_raye_161026_171611';
Dir.path{11} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse450_FEAR-Mouse-450-EXT-24-envB_161026_174952_\FEAR-Mouse-450-EXT-24-envB_161026_174952';
Dir.path{12} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse451_FEAR-Mouse-451-EXT-24-envB_161026_182307_\FEAR-Mouse-451-EXT-24-envB_161026_182307';
Dir.path{13} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse248_20150326-EXT-24h-envC\20150326-EXT-24h-envC';

DirB.path{1} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse291_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
DirB.path{2} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse297_20151217-EXT-24h-envC\20151217-EXT-24h-envC';
DirB.path{3} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse298_20151217-EXT-24h-envC\20151217-EXT-24h-envC';




for mm = 1:length(Dir.path)
    cd(Dir.path{mm})
    
    clear FreezeAccEpoch FreezeEpoch LFP FilLFP S AllPeaks
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
    
    %GetPeakToPeakCycles
    % Add the amplitude
    for k = 1:length(AllPeaks)
        AllPeaks(k,3) = DatLFP(find(uint64(tpsLFP)==uint64(AllPeaks(k,1)*1E4)));
    end
    
    for zscr = 1:2
        
        for trp = 1:2
            if trp ==1
                TroughOrPeak = -1; % -1 for trough, 1 for peak
            else
                TroughOrPeak = 1; % -1 for trough, 1 for peak
            end
            PeakTs = ts(AllPeaks(AllPeaks(3:end-2,2)==TroughOrPeak,1)*1E4); % exclude first and last peak so that there are no edge problems
            tps = Range(PeakTs);
            PeakDurTsd = tsd(diff(Range(PeakTs))+tps(1:end-1),diff(Range(PeakTs,'s')));
            Amp = abs(AllPeaks(find(AllPeaks(3:end-2,2)==TroughOrPeak),3)-AllPeaks(find(AllPeaks(3:end-2,2)==TroughOrPeak)+1,3));
            PeakAmptsd = tsd(diff(Range(PeakTs))+tps(1:end-1),Amp(1:end-1));
            
            % Get population vector for each cycle
            Q = MakeQfromS(S,0.01*1E4);
            tpPk = Range(PeakTs);
            clear CycleQ
            for tr = 1:length(Range(PeakTs))-1
                LittleEpoch = intervalSet(tpPk(tr),tpPk(tr+1));
                CycleQ(tr,:) = nanmean(full(Data(Restrict(Q,LittleEpoch))));
                NumBins(tr) = size(full(Data(Restrict(Q,LittleEpoch))),1);
            end
            
            if zscr ==1
                CycleQtsd = tsd(tpPk(1:end-1),(CycleQ));
            else
                CycleQtsd = tsd(tpPk(1:end-1),zscore(CycleQ));
            end
            
            figure(1+trp)
            clf
            for f = 1:5
                try
                    if f==1
                        % Just get the heart of freezin
                        FreezeEpochCareful = intervalSet(Start(FreezeEpoch)+2E4,Stop(FreezeEpoch));
                        FreezeEpochCareful = dropShortIntervals(FreezeEpochCareful,2.5*1E4);
                        FreezeEpochCareful = intervalSet(Start(FreezeEpochCareful),Stop(FreezeEpochCareful)-2*1E4);
                        FreezeEpochCareful = dropShortIntervals(FreezeEpochCareful,2.5*1E4);
                        Titre = 'FreezingMid';
                    elseif f==2
                        % Just get the edges of freezing
                        FreezeEpochCareful = or(intervalSet(Start(FreezeEpoch),Start(FreezeEpoch)+2E4),intervalSet(Stop(FreezeEpoch)-2E4,Stop(FreezeEpoch)));
                        Titre = 'FreezingStartStop';
                        
                    elseif f==3
                        % Just get the edges of freezing
                        FreezeEpochCareful = intervalSet(Start(FreezeEpoch),Start(FreezeEpoch)+2E4);
                        Titre = 'FreezingStart';
                    elseif f==4
                        % Just get the edges of freezing
                        FreezeEpochCareful = intervalSet(Stop(FreezeEpoch)-2E4,Stop(FreezeEpoch));
                        Titre = 'FreezingStop';
                        
                        
                    elseif f==5
                        % Use all freezing
                        FreezeEpochCareful = FreezeEpoch;
                        Titre = 'AllFreezing';
                    end
                    
                    CycleQData = corr(Data(Restrict(CycleQtsd,FreezeEpochCareful))');
                    clear CorrTime
                    for k = 5:size(CycleQData,1)-5
                        CorrTime(k-4,:) = full(CycleQData(k,k-4:k+4));
                    end
                    
                    DurData = Data(Restrict(PeakDurTsd,FreezeEpochCareful));
                    PkData = Data(Restrict(PeakAmptsd,FreezeEpochCareful));
                    PkData = PkData(5:size(CycleQData,1)-5);
                    DurData = DurData(5:size(CycleQData,1)-5);
                    
                    [val,ind] = sort(PkData);
                    GoodGuys = find(1./DurData<6);
                    
                    rmpath(genpath('C:\Users\sbagur\Dropbox\Kteam\PrgMatlab\Fra\@intervalset'))
                    subplot(5,3,(f-1)*3+1)
                    imagesc(smooth2a(CorrTime(ind(GoodGuys),:),4,1))
                    caxis([0.3 1])
                    colormap(redblue)
                    title(Titre)
                    
                    subplot(5,3,(f-1)*3+2)
                    HighAmp = CorrTime(find(PkData>prctile(PkData,90)),:);
                    LowAmp = CorrTime(find(PkData<prctile(PkData,10)),:);
                    errorbar([-4:4],nanmean(HighAmp),stdError(HighAmp),'r')
                    hold on
                    errorbar([-4:4],nanmean(LowAmp),stdError(LowAmp),'b')
                    %             legend('HiAmp','LowAmp')
                    ylim([0.3 1])
                    
                    subplot(5,3,(f-1)*3+3)
                    plot(PkData(:),min(CorrTime(:,:)'),'.')
                    [R,P] = corrcoef(min(CorrTime(:,:)'),PkData(:))
                    title(['R= ' num2str(R(1,2)) ' P=' num2str(P(1,2))])
                    addpath(genpath('C:\Users\sbagur\Dropbox\Kteam\PrgMatlab\Fra\@intervalset'))
                    RemHighAmp{f} = nanmean(HighAmp);
                    RemLowAmp{f} = nanmean(LowAmp);
                catch
                    RemHighAmp{f} = NaN;
                    RemLowAmp{f} = NaN;
                end
            end
            rmpath(genpath('C:\Users\sbagur\Dropbox\Kteam\PrgMatlab\Fra\@intervalset'))
            saveas(1+trp,['D:\SophieToCopy\Figures\CorrLink4Hz_' num2str(mm) '_' num2str(trp) '_Z' num2str(zscr) '.png'])
            addpath(genpath('C:\Users\sbagur\Dropbox\Kteam\PrgMatlab\Fra\@intervalset'))
            save(['Corr4HzPowerCycleByCycle_' num2str(trp) '_Z' num2str(zscr) '.mat'],'RemHighAmp','RemLowAmp')
            
%             CycleQData = tsd(Range(CycleQtsd),corr(Data((CycleQtsd))')');
%             clear MatStart
%             FreezeEpochtp = dropShortIntervals(FreezeEpoch,3*1E4);
%             FreezeEpochtp = mergeCloseIntervals(FreezeEpochtp,3*1E4);
%             for k = 1:length(Start(FreezeEpochtp))-1
%                 LitEp = subset(FreezeEpochtp,k);
%                 LitEp = intervalSet(Start(LitEp)-3*1E4,Start(LitEp));
%                 LitDat = Data(Restrict(CycleQtsd,LitEp));
%                 LitDatBeg  = LitDat(end-7:end,:);
%                 
%                 LitEp = subset(FreezeEpochtp,k);
%                 LitEp = intervalSet(Start(LitEp),Start(LitEp)+3*1E4);
%                 LitDat = Data(Restrict(CycleQtsd,LitEp));
%                 LitDatEnd  = LitDat(1:8,:);
%                 
%                 MatStart(k,:,:) = corr([LitDatBeg;LitDatEnd]');
%             end
%             
%             clear MatStop
%             FreezeEpochtp = dropShortIntervals(FreezeEpoch,3*1E4);
%             FreezeEpochtp = mergeCloseIntervals(FreezeEpochtp,3*1E4);
%             for k = 1:length(Start(FreezeEpochtp))-1
%                 LitEp = subset(FreezeEpochtp,k);
%                 LitEp = intervalSet(Stop(LitEp)-3*1E4,Stop(LitEp));
%                 LitDat = Data(Restrict(CycleQtsd,LitEp));
%                 LitDatBeg  = LitDat(end-7:end,:);
%                 
%                 LitEp = subset(FreezeEpochtp,k);
%                 LitEp = intervalSet(Stop(LitEp),Stop(LitEp)+3*1E4);
%                 LitDat = Data(Restrict(CycleQtsd,LitEp));
%                 LitDatEnd  = LitDat(1:8,:);
%                 
%                 MatStop(k,:,:) = corr([LitDatBeg;LitDatEnd]');
%             end
%             rmpath(genpath('C:\Users\sbagur\Dropbox\Kteam\PrgMatlab\Fra\@intervalset'))
%             figure(4+trp)
%             clf
%             subplot(121)
%             A = squeeze(nanmean(MatStart,1));
%             A (1:1+size(A,1):end) = NaN;
%             imagesc(A)
%             %         caxis([0.3 0.8])
%             axis square
%             subplot(122)
%             A = squeeze(nanmean(MatStop,1));
%             A (1:1+size(A,1):end) = NaN;
%             imagesc(A)
%             %         caxis([0.3 0.8])
%             colormap redblue
%             axis square
%             saveas(4+trp,['D:\SophieToCopy\Figures\CorrTime_' num2str(mm) '_' num2str(trp) '_Z' num2str(zscr) '.png'])
%             addpath(genpath('C:\Users\sbagur\Dropbox\Kteam\PrgMatlab\Fra\@intervalset'))
%             save(['CorrMatFzStartFzStop_Z' num2str(zscr) '.mat'],'MatStart','MatStop')
        end
        
    end
end

MinCorr = min(CorrTime');

clf
for k = 1:length(Start(FreezeEpoch))
    LitEp = subset(FreezeEpoch,k);
    %     scatter(Data(Restrict(PeakAmptsd,LitEp)),Data(Restrict(PeakDurTsd,LitEp)),15,abs(Range((Restrict(PeakDurTsd,LitEp)))-Stop(LitEp)),'filled')
    plot(abs(Range((Restrict(PeakAmptsd,LitEp)))-Start(LitEp))/1E4,Data(Restrict(PeakDurTsd,LitEp)),'k.')
    hold on
end



%% Expl of funny corr between average firing rate and bin width
for k = 20:50
    for x = 1:(18*k)
        plot(x/(18*k),k,'.')
        hold on
    end
end


Titre = {'FreezingMid','FreezingStartStop','FreezingStart','FreezingStop','AllFreezing'};

for trp = 1:2
    figure
    
    for zscr = 1:2
        for f = 1:5
            RemHighAmpAll = [];
            RemLowAmpAll = [];
            
            for mm = 1:length(Dir.path)
                
                cd(Dir.path{mm})
                
                load(['Corr4HzPowerCycleByCycle_' num2str(trp) '_Z' num2str(zscr) '.mat'],'RemHighAmp','RemLowAmp')
                
                RemHighAmpAll = [RemHighAmpAll;RemHighAmp{f}];
                RemLowAmpAll = [RemLowAmpAll;RemLowAmp{f}];
                
            end
            subplot(2,5,f+5*(zscr-1))
            errorbar([-4:4],nanmean(RemHighAmpAll),stdError(RemHighAmpAll),'r'), hold on
            errorbar([-4:4],nanmean(RemLowAmpAll),stdError(RemLowAmpAll),'b')
            title(Titre{f})
            ylabel('Corr')
            xlabel('Cycles')
            makepretty
        end
    end
end
