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


tps=[0.05:0.05:1];
timeatTransition=3;
Binsize=0.2*1E4;

for DoMod = [2,1,0]
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
        load('NeuronLFPCoupling\FzNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat','pval')
        
        
        TotEpoch=intervalSet(0,max(Range(Movtsd)));
        FreezeEpoch=and(FreezeEpoch,TotEpoch);
        FreezeEpoch=dropShortIntervals(FreezeEpoch,5*1e4);
        %     FreezeEpoch=dropLongIntervals(FreezeEpoch,10*1e4);
        FreezeEpochBis=FreezeEpoch;
        
        % keep only well separated epochs
        for fr_ep=1:length(Start(FreezeEpoch))
            LitEp=subset(FreezeEpoch,fr_ep);
            NotLitEp=FreezeEpoch-LitEp;
            StopEp=intervalSet(Stop(LitEp)-timeatTransition*1e4,Stop(LitEp)+timeatTransition*1e4);
            if not(isempty(Data(Restrict(Movtsd,and(NotLitEp,StopEp)))))
                FreezeEpochBis=FreezeEpochBis-LitEp;
            end
        end
        FreezeEpoch=CleanUpEpoch(FreezeEpochBis);
        
        load('SpikeData.mat')
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
        S = S(numNeurons);
        % Only mod units
        [dur,durT]=DurationEpoch(FreezeEpoch);
        clear FR
        for s = 1:length(S)
            FR(s)=length(Range(Restrict(S{s},FreezeEpoch)))/(durT/1E4);
        end
        
        if DoMod==1
            NumGoodNeur = ([cellfun(@(x) x.Transf,pval.Real)]<0.05 & FR>0.1);
        elseif DoMod==2
            NumGoodNeur = ([cellfun(@(x) x.Transf,pval.Real)]>-1 & FR>0.1);
        else
            NumGoodNeur = ([cellfun(@(x) x.Transf,pval.Real)]>0.05 & FR>0.1);
        end
        
        if sum(NumGoodNeur)>4 & length(Start(FreezeEpoch))>2
            
            clear Spectro Sptsd
            load('B_Low_Spectrum.mat')
            Sptsd = tsd(Spectro{2}*1E4,Spectro{1});

            S = S(NumGoodNeur);
            Lims = [find(Spectro{3}>3,1,'first'):find(Spectro{3}>6,1,'first')];
            Q = MakeQfromS(S,Binsize);
            DatQ = Data(Q);
            Q = tsd(Range(Q),zscore(DatQ));
            FR = FR(NumGoodNeur);
                        
            clear MatStart DataStart Spec PowRatio Dur
            for k = 1:length(Start(FreezeEpoch))-1
                LitEp = subset(FreezeEpoch,k);
                Spec(k,:) = nanmean(Data(Restrict(Sptsd,LitEp)));
                PowRatio(k) = nanmean(Spec(k,Lims))/nanmean( Spec(k,:));
                Dur(k) = Stop(LitEp,'s') - Start(LitEp,'s');
                LitEp = intervalSet(Start(LitEp)-3*1E4,Start(LitEp));
                LitDat = Data(Restrict(Q,LitEp));
                LitDatBeg  = LitDat(end-13:end,:);
                
                LitEp = subset(FreezeEpoch,k);
                LitEp = intervalSet(Start(LitEp),Start(LitEp)+3*1E4);
                LitDat = Data(Restrict(Q,LitEp));
                LitDatEnd  = LitDat(1:14,:);
                
                DataStart(k,:,:) = full(([LitDatBeg;LitDatEnd]'));
                MatStart(k,:,:) = full(corr([LitDatBeg;LitDatEnd]'));
            end
            
            clear MatStop DataStop
            for k = 1:length(Start(FreezeEpoch))-1
                LitEp = subset(FreezeEpoch,k);
                LitEp = intervalSet(Stop(LitEp)-3*1E4,Stop(LitEp));
                LitDat = Data(Restrict(Q,LitEp));
                LitDatBeg  = LitDat(end-13:end,:);
                
                LitEp = subset(FreezeEpoch,k);
                LitEp = intervalSet(Stop(LitEp),Stop(LitEp)+3*1E4);
                LitDat = Data(Restrict(Q,LitEp));
                LitDatEnd  = LitDat(1:14,:);
                
                MatStop(k,:,:) = full(corr([LitDatBeg;LitDatEnd]'));
                DataStop(k,:,:) = full(([LitDatBeg;LitDatEnd]'));
                
            end
            
            
            %% Look at Normalized periods
            clear DataRem CorrRem
            for k = 1:length(Start(FreezeEpoch))-1
                ActualEpoch = subset(FreezeEpoch,k);
                
                % define epoch
                timebef = 4; % now use 5s always
                % timebef=Dur{m}(ep)*timebefprop; % period before and after is 30% acutal period
                LittleEpoch=intervalSet(Start(ActualEpoch),Stop(ActualEpoch));
                LittleEpochPre=intervalSet(Start(ActualEpoch)-timebef*1e4,Start(ActualEpoch));
                LittleEpochPost=intervalSet(Stop(ActualEpoch),Stop(ActualEpoch)+timebef*1e4);
                
                TempData = full(Data(Restrict(Q,LittleEpoch)));
                TempData = interp1([1/size(TempData,1):1/size(TempData,1):1],TempData,tps);
                
                TempDataPre=full(Data(Restrict(Q,LittleEpochPre)));
                TempDataPre = interp1([1/size(TempDataPre,1):1/size(TempDataPre,1):1],TempDataPre,[0.1:0.1:1]);
                
                TempDataPost=full(Data(Restrict(Q,LittleEpochPost)));
                TempDataPost = interp1([1/size(TempDataPost,1):1/size(TempDataPost,1):1],TempDataPost,[0.1:0.1:1]);
                
                CorrRem(k,:,:) = corr([TempDataPre',TempData',TempDataPost']);
                DataRem(k,:,:) = ([TempDataPre',TempData',TempDataPost']);
                
            end
        
        
              if DoMod==1
                  save(['CorrMatFzStartFzStopModNeur.mat'],'MatStart','MatStop','CorrRem','DataRem','DataStart','DataStop','FR','Spec','PowRatio','Dur')
              elseif DoMod==2
                  save(['CorrMatFzStartFzStopAllModNeur.mat'],'MatStart','MatStop','CorrRem','DataRem','DataStart','DataStop','FR','Spec','PowRatio','Dur')
              else
                  save(['CorrMatFzStartFzStopNonModNeur.mat'],'MatStart','MatStop','CorrRem','DataRem','DataStart','DataStop','FR','Spec','PowRatio','Dur')
              end
              
            clear MatStart MatStop CorrRem
        else
            disp('not enought neurons')
            if DoMod
                delete(['CorrMatFzStartFzStopModNeur.mat'])
            else
                delete(['CorrMatFzStartFzStopNonModNeur.mat'])
            end
            
        end
    end
end


AvByMouse = 0;

nmouse = 1;
clear MatStartAll MatStopAll  CorrRemAll
AllDataRenorm = [];
AllDataStart = [];
AllDataStop = [];
AllFR = [];

for mm = 1:length(Dir.path)
    cd(Dir.path{mm})
    if exist('CorrMatFzStartFzStopModNeur.mat')>0
        load(['CorrMatFzStartFzStopModNeur.mat'],'MatStart','MatStop','CorrRem','DataRem','DataStart','DataStop','FR')
        MatStartAll(nmouse,:,:) = squeeze(nanmean(MatStart,1));
        MatStopAll(nmouse,:,:) = squeeze(nanmean(MatStop,1));
        CorrRemAll(nmouse,:,:) = squeeze(nanmean(CorrRem,1));
        AllDataRenorm = [AllDataRenorm;squeeze(nanmean(DataRem,1))];
        AllDataStart = [AllDataStart;squeeze(nanmean(DataStart,1))];
        AllDataStop = [AllDataStop;squeeze(nanmean(DataStop,1))];
        AllFR = [AllFR,FR];
        nmouse = nmouse+1;
    end
end

subplot(231)
if AvByMouse
    A = squeeze(nanmean(MatStartAll,1));
else
    A = corr(AllDataStart);
end
A (1:1+size(A,1):end) = NaN;
imagesc([-3:0.1:3],[-3:0.1:3],A)
line(xlim,[0 0],'color','k')
line([0 0],ylim,'color','k')
line([0 3],[2.8 2.8],'color','c','linewidth',5)
axis square, axis xy
if AvByMouse,caxis([-0.08 0.3]),else, caxis([-1 1]),end
xlabel('Time to freeze start')


subplot(232)
if AvByMouse
    A = squeeze(nanmean(MatStopAll,1));
else
    A = corr(AllDataStop);
end
A (1:1+size(A,1):end) = NaN;
imagesc([-3:0.1:3],[-3:0.1:3],A)
line(xlim,[0 0],'color','k')
line([0 0],ylim,'color','k')
axis square, axis xy
line([-3 0],[2.8 2.8],'color','c','linewidth',5)
if AvByMouse,caxis([-0.08 0.3]),else, caxis([-1 1]),end
xlabel('Time to freeze stop')

subplot(233)
if AvByMouse
    A = squeeze(nanmean(CorrRemAll,1));
else
    A = corr(AllDataRenorm);
end
A (1:1+size(A,1):end) = NaN;
imagesc(A)
set(gca,'XTick',[10 30],'YTick',[10 30],'XTickLabel',{'0','1'},'YTickLabel',{'0','1'})
axis square, axis xy
line([10 30],[40 40],'color','c','linewidth',5)
line([10 10],ylim,'color','k')
line(xlim,[10 10],'color','k')
line([30 30],ylim,'color','k')
line(xlim,[30 30],'color','k')
if AvByMouse,caxis([-0.08 0.3]),else, caxis([-1 1]),end
xlabel('Norm freezing episode (0-1)')

nmouse = 1;
clear MatStartAll MatStopAll  CorrRemAll
AllDataRenormNM= [];
AllDataStartNM = [];
AllDataStopNM = [];
AllFRNM = [];
for mm = 1:length(Dir.path)
    cd(Dir.path{mm})
    if exist('CorrMatFzStartFzStopNonModNeur.mat')>0
        load(['CorrMatFzStartFzStopNonModNeur.mat'],'MatStart','MatStop','CorrRem','DataRem','DataStart','DataStop','FR')
        MatStartAll(nmouse,:,:) = squeeze(nanmean(MatStart,1));
        MatStopAll(nmouse,:,:) = squeeze(nanmean(MatStop,1));
        CorrRemAll(nmouse,:,:) = squeeze(nanmean(CorrRem,1));
        AllDataRenormNM = [AllDataRenormNM;squeeze(nanmean(DataRem,1))];
        AllDataStartNM = [AllDataStartNM;squeeze(nanmean(DataStart,1))];
        AllDataStopNM = [AllDataStopNM;squeeze(nanmean(DataStop,1))];
        AllFRNM = [AllFRNM,FR];
        nmouse = nmouse+1;
    end
end

subplot(234)
if AvByMouse
    A = squeeze(nanmean(MatStartAll,1));
else
    A = corr(AllDataStartNM);
end
A (1:1+size(A,1):end) = NaN;
imagesc([-3:0.1:3],[-3:0.1:3],A)
line(xlim,[0 0],'color','k')
line([0 0],ylim,'color','k')
line([0 3],[2.8 2.8],'color','c','linewidth',5)
axis square, axis xy
if AvByMouse,caxis([-0.08 0.3]),else, caxis([-1 1]),end
xlabel('Time to freeze start')


subplot(235)
if AvByMouse
    A = squeeze(nanmean(MatStopAll,1));
else
    A = corr(AllDataStopNM);
end
A (1:1+size(A,1):end) = NaN;
imagesc([-3:0.1:3],[-3:0.1:3],A)
line(xlim,[0 0],'color','k')
line([0 0],ylim,'color','k')
axis square, axis xy
line([-3 0],[2.8 2.8],'color','c','linewidth',5)
if AvByMouse,caxis([-0.08 0.3]),else, caxis([-1 1]),end
xlabel('Time to freeze stop')

subplot(236)
if AvByMouse,
    A = squeeze(nanmean(CorrRemAll,1));
else
    A = corr(AllDataRenormNM);
end
A (1:1+size(A,1):end) = NaN;
imagesc(A)
set(gca,'XTick',[10 30],'YTick',[10 30],'XTickLabel',{'0','1'},'YTickLabel',{'0','1'})
axis square, axis xy
line([10 30],[40 40],'color','c','linewidth',5)
line([10 10],ylim,'color','k')
line(xlim,[10 10],'color','k')
line([30 30],ylim,'color','k')
line(xlim,[30 30],'color','k')
if AvByMouse,caxis([-0.08 0.3]),else, caxis([-1 1]),end
xlabel('Norm freezing episode (0-1)')


%%
AvByMouse = 0;

nmouse = 1;
clear MatStartAll MatStopAll  CorrRemAll
AllDataRenorm = [];
AllDataStart = [];
AllDataStop = [];
AllFR = [];
AllPow = [];
AllDur = [];
TimeLim = 20;
for mm = 1:length(Dir.path)
    cd(Dir.path{mm})
    if exist('CorrMatFzStartFzStopAllModNeur.mat')>0
        load(['CorrMatFzStartFzStopAllModNeur.mat'],'MatStart','MatStop','CorrRem','DataRem','DataStart','DataStop','FR','PowRatio','Dur')
        MatStartAllStr(nmouse,:,:) = squeeze(nanmean(MatStart(zscore(PowRatio)>0  & Dur<TimeLim,:,:),1));
        MatStopAllStr(nmouse,:,:) = squeeze(nanmean(MatStop(zscore(PowRatio)>0  & Dur<TimeLim,:,:),1));
        CorrRemAllStr(nmouse,:,:) = squeeze(nanmean(CorrRem(zscore(PowRatio)>0  & Dur<TimeLim,:,:),1));
        MatStartAllWk(nmouse,:,:) = squeeze(nanmean(MatStart(zscore(PowRatio)<0  & Dur<TimeLim,:,:),1));
        MatStopAllWk(nmouse,:,:) = squeeze(nanmean(MatStop(zscore(PowRatio)<0  & Dur<TimeLim,:,:),1));
        CorrRemAllWk(nmouse,:,:) = squeeze(nanmean(CorrRem(zscore(PowRatio)<0  & Dur<TimeLim,:,:),1));
        
        AllDataRenorm = [AllDataRenorm;squeeze(nanmean(DataRem,1))];
        AllDataStart = [AllDataStart;squeeze(nanmean(DataStart,1))];
        AllDataStop = [AllDataStop;squeeze(nanmean(DataStop,1))];
        AllFR = [AllFR,FR];
        AllPow = [AllPow,zscore(PowRatio)];
        AllDur = [AllDur,Dur];
        
        nmouse = nmouse+1;
    end
end

subplot(321)
imagesc(squeeze(nanmean(MatStartAllWk,1)))
axis square, axis xy
caxis([-0.2 0.4])
title('Start - weak 4Hz')
subplot(322)
imagesc(squeeze(nanmean(MatStartAllStr,1)))
caxis([-0.2 0.4])
axis square, axis xy
title('Start - strong 4Hz')

subplot(323)
imagesc(squeeze(nanmean(MatStopAllWk,1)))
axis square, axis xy
caxis([-0.2 0.4])
title('Stop - weak 4Hz')
subplot(324)
imagesc(squeeze(nanmean(MatStopAllStr,1)))
caxis([-0.2 0.4])
axis square, axis xy
title('Stop - strong 4Hz')

subplot(325)
imagesc(squeeze(nanmean(CorrRemAllWk,1)))
axis square, axis xy
caxis([-0.2 0.4])
title('Norm - weak 4Hz')
subplot(326)
imagesc(squeeze(nanmean(CorrRemAllStr,1)))
caxis([-0.2 0.4])
axis square, axis xy
title('Norm - strong 4Hz')

