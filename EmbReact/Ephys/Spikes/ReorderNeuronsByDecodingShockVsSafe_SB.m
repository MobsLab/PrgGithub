clear all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
MiceNumber=[490,507,508,509,510,512,514];

% Everything Together
SessionType{1} =  GetRightSessionsUMaze_SB('AllFreezingSessions');
Name{1} = 'AllCondSessions';

WndwSz = 0.5*1e4;
Recalc = 0;

if Recalc
for mm=1:length(MiceNumber)
    mm
    clear Dir
    Dir = GetAllMouseTaskSessions(MiceNumber(mm));
    x1 = strfind(Dir,'UMazeCond');
    ToKeep = find(~cellfun(@isempty,x1));
    Dir = Dir(ToKeep);
    
    MouseByMouse.FR{mm} = [];
    MouseByMouse.LinPos{mm} = [];
    MouseByMouse.OBFreq{mm} = [];
    MouseByMouse.HPCPower{mm} = [];
    MouseByMouse.RippleDensity{mm} = [];
    MouseByMouse.HR{mm} = [];
    MouseByMouse.HRVar{mm} = [];
    MouseByMouse.RipplePower{mm}= [];
    
    
    for d=1:length(Dir)
        
        cd(Dir{d})
        disp(Dir{d})
        
        clear TTLInfo Behav SleepyEpoch TotalNoiseEpoch
        load('behavResources_SB.mat')
        load('ExpeInfo.mat')
        
        % Get epochs
        load('StateEpochSB.mat','SleepyEpoch')
        load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch')
        TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch)-0.5*1e4,Stop(TTLInfo.StimEpoch)+2.5*1e4);
        RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
        TotalEpoch = intervalSet(0,max(Range(Behav.Vtsd)));
        if isfield(Behav,'FreezeAccEpoch')
            if not(isempty(Behav.FreezeAccEpoch))
                Behav.FreezeEpoch = Behav.FreezeAccEpoch;
            end
        end
        CleanFreezeEpoch  = Behav.FreezeEpoch-RemovEpoch;
        
        % Get all the data types
        % OB frequency
        clear LocalFreq
        load('InstFreqAndPhase_B.mat','LocalFreq')
        % smooth the estimates
        WVBinsize = length(Range(LocalFreq.WV))./length(Range(Behav.LinearDist));
        LocalFreq.WV = tsd(Range(LocalFreq.WV),movmedian(Data(LocalFreq.WV),ceil(WVBinsize)*2));
        LocalFreq.PT = tsd(Range(LocalFreq.PT),movmedian(Data(LocalFreq.PT),4));
        
        % Ripple density
        clear RipplesEpochR RipPower
        if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
            load('Ripples.mat')
            load('H_VHigh_Spectrum.mat')
            RipPower = nanmean(Spectro{1}(:,find(Spectro{3}>150,1,'first'):find(Spectro{3}>220,1,'first'))')./nanmean(Spectro{1}(:,find(Spectro{3}>0,1,'first'):find(Spectro{3}>150,1,'first'))');
            RipPower=tsd(Spectro{2}*1e4,RipPower');
            
        else
            RipplesEpochR = [];
        end
        
        % Heart rate and heart rate variability in and out of freezing
        clear EKG HRVar
        if exist('HeartBeatInfo.mat')>0
            load('HeartBeatInfo.mat')
            HRVar = tsd(Range(EKG.HBRate),movstd(Data(EKG.HBRate),5));
        end
        
        % Spikes
        load('SpikeData.mat')
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx')
        S = S(numNeurons);
        
        
        % HPC spec
        clear Sp
        if exist('ChannelsToAnalyse/dHPC_deep.mat')>0
            [Sp,t,f]=LoadSpectrumML('dHPC_deep');
        elseif exist('ChannelsToAnalyse/dHPC_sup.mat')>0
            [Sp,t,f]=LoadSpectrumML('dHPC_sup');
        elseif  exist('ChannelsToAnalyse/dHPC_rip.mat')>0
            [Sp,t,f]=LoadSpectrumML('dHPC_rip');
        end
        Sptsd=tsd(t*1e4,Sp);
        PowerThetaTemp = nanmean(Sp(:,find(f<5.5,1,'last'):find(f<7.5,1,'last'))')';
        PowerThetaTemp = interp1(Range(Sptsd),PowerThetaTemp,Range(Behav.Vtsd));
        ThetaPowerSlow = PowerThetaTemp;
        
        PowerThetaTemp = nanmean(Sp(:,find(f<10,1,'last'):find(f<15,1,'last'))')';
        PowerThetaTemp = interp1(Range(Sptsd),PowerThetaTemp,Range(Behav.Vtsd));
        ThetaPowerFast = PowerThetaTemp;
        
        PowerThetaSlow = tsd(Range(Behav.Vtsd),ThetaPowerSlow./ThetaPowerFast);
        
        
        % Get periods one by one
        if not(isempty(Start(CleanFreezeEpoch)))
            if sum(Stop(CleanFreezeEpoch)-Start(CleanFreezeEpoch))>WndwSz
                
                for s=1:length(Start(CleanFreezeEpoch))
                    dur=(Stop(subset(CleanFreezeEpoch,s))-Start(subset(CleanFreezeEpoch,s)));
                    Str=Start(subset(CleanFreezeEpoch,s));
                    
                    if  dur<(WndwSz*2-0.5*1e4) & dur>(WndwSz-0.5*1e4)
                        LitEpoch = subset(CleanFreezeEpoch,s);
                        
                        MouseByMouse.LinPos{mm} = [MouseByMouse.LinPos{mm},nanmean(Data(Restrict(Behav.LinearDist,LitEpoch)))];
                        MouseByMouse.OBFreq{mm} = [MouseByMouse.OBFreq{mm},(nanmedian(Data(Restrict(LocalFreq.WV,LitEpoch)))+nanmedian(Data(Restrict(LocalFreq.PT,LitEpoch))))/2];
                        MouseByMouse.HPCPower{mm} = [MouseByMouse.HPCPower{mm},nanmean(Data(Restrict(PowerThetaSlow,LitEpoch)))];
                        if not(isempty(RipplesEpochR)),
                            MouseByMouse.RippleDensity{mm} = [MouseByMouse.RippleDensity{mm},length(Start(and(RipplesEpochR,LitEpoch)))./sum(Stop(LitEpoch,'s')-Start(LitEpoch,'s'))];
                            MouseByMouse.RipplePower{mm} = [MouseByMouse.RipplePower{mm},nanmean(Data(Restrict(RipPower,LitEpoch)))];
                            
                        else
                            MouseByMouse.RippleDensity{mm} = [MouseByMouse.RippleDensity{mm},NaN];
                            MouseByMouse.RipplePower{mm} = [MouseByMouse.RipplePower{mm},NaN];
                        end
                        
                        if exist('HeartBeatInfo.mat')>0
                            
                            MouseByMouse.HR{mm} = [MouseByMouse.HR{mm},nanmean(Data(Restrict(EKG.HBRate,LitEpoch)))];
                            MouseByMouse.HRVar{mm} = [MouseByMouse.HRVar{mm},nanmean(Data(Restrict(HRVar,LitEpoch)))];
                        else
                            MouseByMouse.HR{mm} = [MouseByMouse.HR{mm},NaN];
                            MouseByMouse.HRVar{mm} = [MouseByMouse.HRVar{mm},NaN];
                        end
                        
                        % Spikes
                        clear FiringRates
                        for i=1:length(S)
                            FiringRates(i) = length(Restrict(S{i},LitEpoch)) / sum(Stop(LitEpoch,'s')-Start(LitEpoch,'s'));
                        end
                        MouseByMouse.FR{mm} = [MouseByMouse.FR{mm},FiringRates'];
                        
                        
                    else
                        numbins=round(dur/WndwSz);
                        epdur=dur/numbins;
                        for nn=1:numbins
                            LitEpoch = intervalSet(Str+epdur*(nn-1),Str+epdur*(nn));
                            
                            MouseByMouse.LinPos{mm} = [MouseByMouse.LinPos{mm},nanmean(Data(Restrict(Behav.LinearDist,LitEpoch)))];
                            MouseByMouse.OBFreq{mm} = [MouseByMouse.OBFreq{mm},(nanmedian(Data(Restrict(LocalFreq.WV,LitEpoch)))+nanmedian(Data(Restrict(LocalFreq.PT,LitEpoch))))/2];
                            MouseByMouse.HPCPower{mm} = [MouseByMouse.HPCPower{mm},nanmean(Data(Restrict(PowerThetaSlow,LitEpoch)))];
                            if not(isempty(RipplesEpochR)),
                                MouseByMouse.RippleDensity{mm} = [MouseByMouse.RippleDensity{mm},length(Start(and(RipplesEpochR,LitEpoch)))./sum(Stop(LitEpoch,'s')-Start(LitEpoch,'s'))];
                                MouseByMouse.RipplePower{mm} = [MouseByMouse.RipplePower{mm},nanmean(Data(Restrict(RipPower,LitEpoch)))];
                                
                            else
                                MouseByMouse.RippleDensity{mm} = [MouseByMouse.RippleDensity{mm},NaN];
                                MouseByMouse.RipplePower{mm} = [MouseByMouse.RipplePower{mm},NaN];
                                
                            end
                            
                            if exist('HeartBeatInfo.mat')>0
                                
                                MouseByMouse.HR{mm} = [MouseByMouse.HR{mm},nanmean(Data(Restrict(EKG.HBRate,LitEpoch)))];
                                MouseByMouse.HRVar{mm} = [MouseByMouse.HRVar{mm},nanmean(Data(Restrict(HRVar,LitEpoch)))];
                            else
                                MouseByMouse.HR{mm} = [MouseByMouse.HR{mm},NaN];
                                MouseByMouse.HRVar{mm} = [MouseByMouse.HRVar{mm},NaN];
                                
                            end
                            
                            % Spikes
                            clear FiringRates
                            for i=1:length(S)
                                FiringRates(i) = length(Restrict(S{i},LitEpoch)) / (Stop(LitEpoch,'s')-Start(LitEpoch,'s'));
                            end
                            MouseByMouse.FR{mm} = [MouseByMouse.FR{mm},FiringRates'];
                            
                            
                        end
                        
                    end
                end
            end
        end
        
    end
end
cd('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD')
save(['OverallInfoPhysioSpikes',num2str(WndwSz/1e4),'.mat'],'MouseByMouse','MiceNumber','-v7.3')
else
    cd('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD')
   load(['OverallInfoPhysioSpikes',num2str(WndwSz/1e4),'.mat'])
end

clf
for mm=1:7
    subplot(5,2,[1,3,5])
    [vals,ind] = sort(MouseByMouse.OBFreq{mm});
    dat = sortrows([MouseByMouse.OBFreq{mm};nanzscore(MouseByMouse.FR{mm}')']');
    dat(:,1) = [];
    imagesc(corr(dat',dat'))
    clim([-0.4 0.4])
    title('Sorted by OB freq')
    subplot(5,2,7)
    plot(sort(MouseByMouse.OBFreq{mm}))
    ylabel('OB Freq')
    ylim([1 7])
    subplot(5,2,9)
    plot((MouseByMouse.LinPos{mm}(ind)))
    ylabel('LinPos')
    ylim([0 1])
    
    subplot(5,2,[1,3,5]+1)
    [vals,ind] = sort(MouseByMouse.LinPos{mm});
    dat = sortrows([MouseByMouse.LinPos{mm};nanzscore(MouseByMouse.FR{mm}')']');
    dat(:,1) = [];
    imagesc(corr(dat',dat'))
    clim([-0.4 0.4])
    title('Sorted by LinPos')
    subplot(5,2,8)
    plot((MouseByMouse.OBFreq{mm}(ind)))
    ylabel('OB Freq')
    ylim([1 7])
    subplot(5,2,10)
    ylabel('LinPos')
    plot(sort(MouseByMouse.LinPos{mm}))
    ylim([0 1])
    pause
end

figure
clear ShockFzsize  SafeFzsize W Score AllDatProj AllDatProjRand ScoreRand
for mm=1:7
    ShockFzsize(mm) = sum(MouseByMouse.LinPos{mm}<0.4);
    SafeFzsize(mm) = sum(MouseByMouse.LinPos{mm}>0.6);
    
    BinsToUse = floor(min(min([ShockFzsize(mm),SafeFzsize(mm)]))/2);
    
    RemTrialSafe{mm} = nan(length(MouseByMouse.LinPos{mm}),1000);
    RemTrialShock{mm} = nan(length(MouseByMouse.LinPos{mm}),1000);
    FRZ = nanzscore(MouseByMouse.FR{mm}')';
    for perm = 1:1000
                
        ShockBins = find(MouseByMouse.LinPos{mm}<0.4);
        ShockBinsToUse = ShockBins(randperm(length(ShockBins),BinsToUse*2));
        ShockSideFrTrain = [FRZ(:,ShockBinsToUse(BinsToUse+1:end))];
        ShockSideFrTest = [FRZ(:,ShockBinsToUse(1:BinsToUse))];
        
        SafeBins = find(MouseByMouse.LinPos{mm}>0.6);
        SafeBinsToUse = SafeBins(randperm(length(SafeBins),BinsToUse*2));
        SafeSideFrTrain = [FRZ(:,SafeBinsToUse(BinsToUse+1:end))];
        SafeSideFrTest = [FRZ(:,SafeBinsToUse(1:BinsToUse))];
        
        
        W{mm}(perm,:) = (nanmean(ShockSideFrTrain')-nanmean(SafeSideFrTrain'));
        Bias = (nanmean(ShockSideFrTrain'*W{mm}(perm,:)') + nanmean(SafeSideFrTrain'*W{mm}(perm,:)'))/2;
        
        for trial = 1 : BinsToUse
            ShockGuess(trial) = ShockSideFrTest(:,trial)'*W{mm}(perm,:)'>Bias;
            SafeGuess(trial) = SafeSideFrTest(:,trial)'*W{mm}(perm,:)'<Bias;
            RemTrialSafe{mm}(SafeBinsToUse(trial),perm) = SafeGuess(trial);
            RemTrialShock{mm}(ShockBinsToUse(trial),perm) = ShockGuess(trial);
        end
        
        Score(mm,perm) = (nanmean(ShockGuess)+nanmean(SafeGuess))/2;
        AllDatProj{mm}(perm,:)=MouseByMouse.FR{mm}'*W{mm}(perm,:)';

        % Random
        ShockBinsRand = [ShockBinsToUse(BinsToUse+1:end),SafeBinsToUse(BinsToUse+1:end)];
        SafeBinsRand = [SafeBinsToUse(BinsToUse),ShockBinsToUse(BinsToUse+1:end)];
        SafeBinsRand = SafeBinsRand(randperm(length(SafeBinsRand)));
        ShockBinsRand = ShockBinsRand(randperm(length(ShockBinsRand)));

        ShockSideFrTrain = [FRZ(:,ShockBinsRand(BinsToUse+1:end))];
        ShockSideFrTest = [FRZ(:,ShockBinsRand(1:BinsToUse))];
                
        SafeSideFrTrain = [FRZ(:,SafeBinsRand(BinsToUse+1:end))];
        SafeSideFrTest = [FRZ(:,SafeBinsRand(1:BinsToUse))];
        
        WRand{mm}(perm,:) = (nanmean(ShockSideFrTrain')-nanmean(SafeSideFrTrain'));
        Bias = (nanmean(ShockSideFrTrain'*WRand{mm}(perm,:)') + nanmean(SafeSideFrTrain'*WRand{mm}(perm,:)'))/2;
        
        for trial = 1 : BinsToUse
            ShockGuess(trial) = ShockSideFrTest(:,trial)'*W{mm}(perm,:)'>Bias;
            SafeGuess(trial) = SafeSideFrTest(:,trial)'*W{mm}(perm,:)'<Bias;
            RemTrialSafeRand{mm}(SafeBinsToUse(trial),perm) = SafeGuess(trial);
            RemTrialShockRand{mm}(ShockBinsToUse(trial),perm) = ShockGuess(trial);
        end
        
        ScoreRand(mm,perm) = (nanmean(ShockGuess)+nanmean(SafeGuess))/2;
        AllDatProjRand{mm}(perm,:)=MouseByMouse.FR{mm}'*WRand{mm}(perm,:)';


    end
end


% figure for decoding
figure
clf
Cols = {[0.6 0.6 0.6],[1 0.6 0.6]};
A = {nanmean(Score'),nanmean(Score')};
UpLim = median(prctile(ScoreRand',97.5))-nanmean(ScoreRand(:));
LowLim = nanmean(ScoreRand(:)) - median(prctile(ScoreRand',2.5));
shadedErrorBar([0.5 1.5],[1 1]*nanmean(ScoreRand(:)),[UpLim UpLim;LowLim LowLim])
hold on
MakeSpreadAndBoxPlot_SB(A,Cols,1:2,{})
xlim([0.5 1.5])
ylim([0 1])


figure
AllSafeTrialsErrRate = [];
AllShockTrialsErrRate = [];
AllW = [];

for mm=1:7
    AllSafeTrialsErrRate = [AllSafeTrialsErrRate,nanmean(RemTrialSafe{mm}')];
    AllShockTrialsErrRate = [AllShockTrialsErrRate,nanmean(RemTrialShock{mm}')];
    AllW = [AllW,nanmean(W{mm})];

end


cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD/PFCUnitFiringOBFrequency
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')
load('PFCUnitFiringOnOBFrequencyAllSessSpeedCorrBroadFreqNoSleep.mat')
% load('PFCUnitFiringOnOBFrequencyFreezing.mat')
figure
if size(MeanSpk{mm},2)==60
FreqLims=[2:0.15:11];
else
FreqLims=[2.5:0.15:6];
end
% FreqLims=[2.5:0.15:6];

%% Just the sig units
GoodNeur = [];
PNeur = [];
RNeur = [];
AllSpk=[];
AllW = [];
AllWS = [];

for mm=1:length(MiceNumber)
    for sp=1:length(RSpk{mm})
        if IsPFCNeuron{mm}(sp)==1
            
            if RSpk{mm}(sp)>prctile(RSpk_btstrp{mm}(sp,:),97.5)
                GoodNeur = [GoodNeur,1];
            elseif RSpk{mm}(sp)<prctile(RSpk_btstrp{mm}(sp,:),2.5);
                GoodNeur = [GoodNeur,-1];
            else
                GoodNeur = [GoodNeur,0];
            end
            PNeur = [PNeur,PSpk{mm}(sp)];
            RNeur = [RNeur,RSpk{mm}(sp)];

        end
    end
    AllW = [AllW,nanmean(W{mm})];
    AllWS = [AllWS,nanstd(W{mm})];

    AllSpk =[AllSpk;(MeanSpk{mm}(find(IsPFCNeuron{mm}),:))];

end
% AllSpk = AllSpk(:,5:28);
figure
A = nanzscore(AllSpk(find(AllW<-0.5),:)');
[val,ind] = max(A);
ind1 = ind;
A = sortrows([ind;A]');
A = A(:,2:end);
subplot(121)
imagesc(FreqLims,1:size(A,1),SmoothDec(A,[0.1 2]))
clim([-1.5 1.5])
title('Safe')
B = nanzscore(AllSpk(AllW>0.5,:)');
[val,ind] = max(B);
B = sortrows([ind;B]');
B = B(:,2:end);
subplot(122)
imagesc(FreqLims,1:size(B,1),SmoothDec(B,[0.1 2]))
clim([-1.5 1.5])
title('Shock')

figure
subplot(121)
nhist({FreqLims(ind1),FreqLims(ind)},'noerror','binfactor',2,'samebins')
subplot(122)
A = {FreqLims(ind1),FreqLims(ind)};
Cols = {[0.6 0.6 0.6],[1 0.6 0.6]};
MakeSpreadAndBoxPlot_SB(A,Cols,1:2,{})
[p1,h] = ranksum(FreqLims(ind1),FreqLims(ind));
sigstar_DB({[1,2]},p1)


% figure
% A = nanzscore(AllSpk(find(AllW<-0.5),:)');
% [val,ind] = max(A);
% ind1 = ind;
% A = sortrows([RemInd1;A]');
% A = A(:,2:end);
% subplot(121)
% imagesc(FreqLims,1:size(A,1),SmoothDec(A,[0.1 2]))
% clim([-1.5 1.5])
% title('Safe')
% B = nanzscore(AllSpk(AllW>0.5,:)');
% [val,ind] = max(B);
% B = sortrows([RemInd2;B]');
% B = B(:,2:end);
% subplot(122)
% imagesc(FreqLims,1:size(B,1),SmoothDec(B,[0.1 2]))
% clim([-1.5 1.5])
% title('Shock')
% 
