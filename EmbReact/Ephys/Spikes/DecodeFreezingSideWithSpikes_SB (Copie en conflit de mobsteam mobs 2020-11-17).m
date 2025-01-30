clear all, close all
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

for m= 1:length(MiceNumber)
MouseByMouse.RipplePower{m} = nanzscore(MouseByMouse.RipplePower{m}')';
end

clf
for mm= 1:MiceNumber
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
DecodingLimits = [0.4,0.6]; MiceNumber = 7;
% DecodingLimits = [0.2,0.8]; MiceNumber = 5;

for mm=1:MiceNumber
    ShockFzsize(mm) = sum(MouseByMouse.LinPos{mm}<DecodingLimits(1));
    SafeFzsize(mm) = sum(MouseByMouse.LinPos{mm}>DecodingLimits(2));

    BinsToUse = floor(min(min([ShockFzsize(mm),SafeFzsize(mm)]))/2);
    
    RemTrialSafe{mm} = nan(length(MouseByMouse.LinPos{mm}),1000);
    RemTrialShock{mm} = nan(length(MouseByMouse.LinPos{mm}),1000);
    FRZ = nanzscore(MouseByMouse.FR{mm}')';
 if BinsToUse>1
    for perm = 1:500
                
        ShockBins = find(MouseByMouse.LinPos{mm}<DecodingLimits(1));
        ShockBinsToUse = ShockBins(randperm(length(ShockBins),BinsToUse*2));
        ShockSideFrTrain = [FRZ(:,ShockBinsToUse(BinsToUse+1:end))];
        ShockSideFrTest = [FRZ(:,ShockBinsToUse(1:BinsToUse))];
        
        SafeBins = find(MouseByMouse.LinPos{mm}>DecodingLimits(2));
        SafeBinsToUse = SafeBins(randperm(length(SafeBins),BinsToUse*2));
        SafeSideFrTrain = [FRZ(:,SafeBinsToUse(BinsToUse+1:end))];
        SafeSideFrTest = [FRZ(:,SafeBinsToUse(1:BinsToUse))];
        
        
        W{mm}(perm,:) = (nanmean(ShockSideFrTrain')-nanmean(SafeSideFrTrain'));
        W{mm}(perm,:) = W{mm}(perm,:)./norm(W{mm}(perm,:));
        
        Bias = (nanmean(ShockSideFrTrain'*W{mm}(perm,:)') + nanmean(SafeSideFrTrain'*W{mm}(perm,:)'))/2;
        clear ShockGuess SafeGuess
        for trial = 1 : BinsToUse
            ShockGuess(trial) = ShockSideFrTest(:,trial)'*W{mm}(perm,:)'>Bias;
            SafeGuess(trial) = SafeSideFrTest(:,trial)'*W{mm}(perm,:)'<Bias;
            RemTrialSafe{mm}(SafeBinsToUse(trial),perm) = SafeGuess(trial);
            RemTrialShock{mm}(ShockBinsToUse(trial),perm) = ShockGuess(trial);
        end
        
        Score(mm,perm) = (nanmean(ShockGuess)+nanmean(SafeGuess))/2;
        AllDatProj{mm}(perm,:)=FRZ'*W{mm}(perm,:)'-Bias;

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
        WRand{mm}(perm,:) = WRand{mm}(perm,:)./norm(W{mm}(perm,:));
        Bias = (nanmean(ShockSideFrTrain'*WRand{mm}(perm,:)') + nanmean(SafeSideFrTrain'*WRand{mm}(perm,:)'))/2;
        clear ShockGuess SafeGuess
        for trial = 1 : BinsToUse
            ShockGuess(trial) = ShockSideFrTest(:,trial)'*WRand{mm}(perm,:)'>Bias;
            SafeGuess(trial) = SafeSideFrTest(:,trial)'*WRand{mm}(perm,:)'<Bias;
            RemTrialSafeRand{mm}(SafeBinsToUse(trial),perm) = SafeGuess(trial);
            RemTrialShockRand{mm}(ShockBinsToUse(trial),perm) = ShockGuess(trial);
        end
        
        ScoreRand(mm,perm) = (nanmean(ShockGuess)+nanmean(SafeGuess))/2;
        AllDatProjRand{mm}(perm,:)=FRZ'*WRand{mm}(perm,:)'-Bias;
    end

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



AllSafeTrialsErrRate = [];
AllShockTrialsErrRate = [];
AllW = [];

for mm=1:MiceNumber
    AllSafeTrialsErrRate = [AllSafeTrialsErrRate,nanmean(RemTrialSafe{mm}')];
    AllShockTrialsErrRate = [AllShockTrialsErrRate,nanmean(RemTrialShock{mm}')];
    AllW = [AllW,nanmean(W{mm})];

end


LinPos = [];
DataPCATogether = [];
for m= 1:MiceNumber
    
    DataPCATogether = [DataPCATogether;[MouseByMouse.OBFreq{(m)}',log(MouseByMouse.HPCPower{(m)})',MouseByMouse.HR{(m)}',...
        MouseByMouse.HRVar{(m)}',(MouseByMouse.RippleDensity{(m)}')]];
    LinPos = [LinPos,MouseByMouse.LinPos{(m)}];
    
end
dat = (nanzscore(DataPCATogether));
DecodeBrainState = nanmean(dat(find(LinPos<0.2),:))-nanmean(dat(find(LinPos>0.8),:));

Side = {'Safe','Shock'};
Resp = {'Wrong','Right'};
Variable = {'OBFreq','HPCPower','HR','HRVar','RippleDensity','LinPos'};
clear ParamsErr
for ss = 1:length(Side)
    for rr = 1:length(Resp)
        for var = 1 :length(Variable)
            ParamsErr.Safe.Right.(Variable{var}) = [];
            ParamsErr.Shock.Right.(Variable{var}) = [];
            
            ParamsErr.Safe.Wrong.(Variable{var}) = [];
            ParamsErr.Shock.Wrong.(Variable{var}) = [];
        end
    end
end


for mm= 1:MiceNumber
    for var = 1 :length(Variable)
        ParamsErr.Safe.Right.(Variable{var}) = [ParamsErr.Safe.Right.(Variable{var}),MouseByMouse.(Variable{var}){mm}((nanmean(RemTrialSafe{mm}')>0.9))];
        ParamsErr.Shock.Right.(Variable{var}) = [ParamsErr.Shock.Right.(Variable{var}),MouseByMouse.(Variable{var}){mm}((nanmean(RemTrialShock{mm}')>0.9))];
        
        ParamsErr.Safe.Wrong.(Variable{var}) = [ParamsErr.Safe.Wrong.(Variable{var}),MouseByMouse.(Variable{var}){mm}((nanmean(RemTrialSafe{mm}')<0.3))];
        ParamsErr.Shock.Wrong.(Variable{var}) = [ParamsErr.Shock.Wrong.(Variable{var}),MouseByMouse.(Variable{var}){mm}((nanmean(RemTrialShock{mm}')<0.3))];
    end
end

for ss = 1:length(Side)
    for rr = 1:length(Resp)
            DataPCA.(Side{ss}).(Resp{rr}) = [ParamsErr.(Side{ss}).(Resp{rr}).OBFreq',log(ParamsErr.(Side{ss}).(Resp{rr}).HPCPower)',ParamsErr.(Side{ss}).(Resp{rr}).HR',...
                ParamsErr.(Side{ss}).(Resp{rr}).HRVar',ParamsErr.(Side{ss}).(Resp{rr}).RippleDensity'];
    end
end

Mn = nanmean([DataPCA.Shock.Right;DataPCA.Shock.Wrong;DataPCA.Safe.Right;DataPCA.Safe.Wrong]);
Std =  nanstd([DataPCA.Shock.Right;DataPCA.Shock.Wrong;DataPCA.Safe.Right;DataPCA.Safe.Wrong]);
for ss = 1:length(Side)
    for rr = 1:length(Resp)
        for var = 1 :length(Variable)-1
            DataPCA.(Side{ss}).(Resp{rr})(:,var) = (DataPCA.(Side{ss}).(Resp{rr})(:,var) - Mn(var))./Std(var)
        end
    end
end

figure
clf
DecodeBrainState = nanmean(dat(find(LinPos<0.4),:))-nanmean(dat(find(LinPos>0.6),:));
subplot(221)
coeff(:,1) = DecodeBrainState;
A = {DataPCA.Safe.Right*coeff(:,1),DataPCA.Safe.Wrong*coeff(:,1),DataPCA.Shock.Right*coeff(:,1),DataPCA.Shock.Wrong*coeff(:,1)};
Cols = [UMazeColors('Safe');UMazeColors('Safe')*0.4;UMazeColors('Shock');UMazeColors('Shock')*0.4];
violin(A,'mc',[],'facecolor',Cols,'medc','k')
violin(A,'mc',[],'facecolor',Cols,'medc','k')
set(gca,'XTick',[1:4],'XTickLabel',{'Safe-Corr','Safe-Err','Shock-Corr','Shock-Err'})
xtickangle(45)
[p2,h] = ranksum(DataPCA.Shock.Right*coeff(:,1),DataPCA.Shock.Wrong*coeff(:,1));
[p1,h] = ranksum(DataPCA.Safe.Right*coeff(:,1),DataPCA.Safe.Wrong*coeff(:,1));
sigstar_DB({[1,2],[3,4]},[p1,p2])
legend off
ylabel('Proj - physio')

subplot(222)
A = {ParamsErr.Safe.Right.LinPos,ParamsErr.Safe.Wrong.LinPos,ParamsErr.Shock.Right.LinPos,ParamsErr.Shock.Wrong.LinPos};
violin(A,'mc',[],'facecolor',Cols,'medc','k')
violin(A,'mc',[],'facecolor',Cols,'medc','k')
set(gca,'XTick',[1:4],'XTickLabel',{'Safe-Corr','Safe-Err','Shock-Corr','Shock-Err'})
xtickangle(45)
[p2,h] = ranksum(ParamsErr.Shock.Right.LinPos,ParamsErr.Shock.Wrong.LinPos);
[p1,h] = ranksum(ParamsErr.Safe.Right.LinPos,ParamsErr.Safe.Wrong.LinPos);
sigstar_DB({[1,2],[3,4]},[p1,p2])
legend off
ylabel('Lin Pos')
set(gca,'LineWidth',2,'FontSize',15), box off

subplot(212)
Val = [];
for mm= 1:MiceNumber
    Val = [Val,nanmean(AllDatProj{mm})];
end
scatter(LinPos,dat*DecodeBrainState',30,'filled','k'), hold on
scatter(LinPos,dat*DecodeBrainState',20,Val,'filled')
colormap(redblue)
set(gca,'LineWidth',2,'FontSize',15), box off

xlabel('Lin Pos')
ylabel('Proj - physio')
colorbar
set(gca,'LineWidth',2,'FontSize',15), box off




figure
Val = [];
for mm= 1:MiceNumber
    Val = [Val,nanzscore(nanmean(AllDatProj{mm})')'];
end
ObFreq = DataPCATogether(:,1) ;

ToDel = find(isnan(ObFreq) |  isnan(Val') | isnan(LinPos'));
ObFreq(ToDel) = [];
Val(ToDel) = [];
LinPos(ToDel) = [];
figure
subplot(131)
scatter(ObFreq(LinPos<0.2 | LinPos>0.8),Val(LinPos<0.2 | LinPos>0.8),20,LinPos(LinPos<0.2 | LinPos>0.8))
clim([0 1])
subplot(132)
scatter(ObFreq(LinPos>0.2 & LinPos<0.8),Val(LinPos>0.2 & LinPos<0.8),20,LinPos(LinPos>0.2 & LinPos<0.8))
clim([0 1])
subplot(133)
scatter(LinPos,Val,20,ObFreq)
clim([2 7])
figure
scatter(LinPos,ObFreq,20,Val)

figure
Cols = {UMazeColors('Safe');UMazeColors('Safe')*0.4;UMazeColors('Shock');UMazeColors('Shock')*0.4};
for var = 1 :length(Variable)
    
    subplot(2,3,var)
    A = {ParamsErr.Safe.Right.(Variable{var}),ParamsErr.Safe.Wrong.(Variable{var}),ParamsErr.Shock.Right.(Variable{var}),ParamsErr.Shock.Wrong.(Variable{var})};
    PlotErrorBarN_KJ(A,'newfig',0,'paired',0,'showPoints',0,'ShowSigstar','none')
%     MakeSpreadAndBoxPlot_SB(A,Cols,1:4,{'Safe-Corr','Safe-Err','Shock-Corr','Shock-Err'},0)
   set(gca,'XTick',[1:4],'XTickLabel',{'Safe-Corr','Safe-Err','Shock-Corr','Shock-Err'})
   xtickangle(45)
    [p2,h] = ranksum(ParamsErr.Shock.Right.(Variable{var}),ParamsErr.Shock.Wrong.(Variable{var}));
    [p1,h] = ranksum(ParamsErr.Safe.Right.(Variable{var}),ParamsErr.Safe.Wrong.(Variable{var}));
    [p3,h] = ranksum(ParamsErr.Safe.Right.(Variable{var}),ParamsErr.Shock.Right.(Variable{var}));

    sigstar_DB({[1,2],[3,4],[1,3]},[p1,p2,p3])
    legend off
    ylabel(Variable{var})
    set(gca,'LineWidth',2,'FontSize',15), box off
end



figure
FreqVals = [2:0.2:6];
clear Val
for mm= 1:MiceNumber

for k = 1 :length(FreqVals)-1
    ind = find(MouseByMouse.OBFreq{mm}>FreqVals(k) & MouseByMouse.OBFreq{mm}<FreqVals(k+1)) ;
    if not(isempty(ind))
    Val(mm,k) = nanmean(nanmean((AllDatProj{mm}(:,ind))));
    else
       Val(mm,k) = NaN; 
    end
end

end

errorbar(FreqVals(1:end-1),nanmean(nanzscore(Val')'),stdError(nanzscore(Val')'),'k','linewidth',3)
xlabel('OB freq')
ylabel('PFC unit projection')
set(gca,'LineWidth',2,'FontSize',15), box off


figure
LinPosVals = [0:0.1 :1];
clear Val
for mm= 1:MiceNumber

for k = 1 :length(LinPosVals)-1
    ind = find(MouseByMouse.LinPos{mm}>LinPosVals(k) & MouseByMouse.LinPos{mm}<LinPosVals(k+1)) ;
    if not(isempty(ind))
    Val(mm,k) = nanmean(nanmean((AllDatProj{mm}(:,ind))));
    else
       Val(mm,k) = NaN; 
    end
end

end

errorbar(LinPosVals(1:end-1),nanmean(nanzscore(Val')'),stdError(nanzscore(Val')'),'k','linewidth',3)
xlabel('Position')
ylabel('PFC unit projection')
set(gca,'LineWidth',2,'FontSize',15), box off

figure
FreqVals = [-2.5:0.25:2];
clear Val
for m= 1:MiceNumber
    DataPCATogether = nanzscore([MouseByMouse.OBFreq{(m)}',log(MouseByMouse.HPCPower{(m)})',MouseByMouse.HR{(m)}',...
        MouseByMouse.HRVar{(m)}',(MouseByMouse.RippleDensity{(m)}')]);

    Proj = DataPCATogether*DecodeBrainState';
    nanmin(Proj)
    nanmax(Proj)
    for k = 1 :length(FreqVals)-1
        ind = find(Proj>FreqVals(k) & Proj<FreqVals(k+1)) ;
        if not(isempty(ind))
            Val(m,k) = nanmean(nanmean((AllDatProj{m}(:,ind))));
        else
            Val(m,k) = NaN;
        end
    end
    
end

errorbar(FreqVals(1:end-1),nanmean(nanzscore(Val')'),stdError(nanzscore(Val')'),'k','linewidth',3)
xlabel('Physiological markers projection')
ylabel('PFC unit projection')
set(gca,'LineWidth',2,'FontSize',15), box off


% Show some examples of projections
subplot(121)
m=1;scatter(MouseByMouse.OBFreq{(m)},nanmean(AllDatProj{m}),15,MouseByMouse.LinPos{m},'filled'),colormap(fliplr(redblue)),clim([0 1])
set(gca,'LineWidth',2,'FontSize',15), box off
ylabel('PFC SU projection')
xlabel('OB Freq')

subplot(122)
m=2;scatter(MouseByMouse.OBFreq{(m)},nanmean(AllDatProj{m}),15,MouseByMouse.LinPos{m},'filled'),colormap(fliplr(redblue)),clim([0 1])
ylim([-6 4])
set(gca,'LineWidth',2,'FontSize',15), box off
ylabel('PFC SU projection')
xlabel('OB Freq')
%%
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD/PFCUnitFiringOBFrequency
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')
load('PFCUnitFiringOnOBFrequencyAllSessSpeedCorrBroadFreqNoSleep.mat')
FreqLims=[2:0.15:11];
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

subplot(131)
AllSpk = nanzscore(AllSpk')';
ToUse = abs(GoodNeur)>0;
plot(RNeur(ToUse),AllW(ToUse),'.','MarkerSize',20)
ylim([-2 2])
xlim([-0.35 0.35])
[R,P] = corrcoef(RNeur(ToUse),AllW(ToUse))
title(['Corr: R=' num2str(R(1,2)) ' P=' num2str(P(1,2))])
xlabel('Freq Corr - R'), ylabel('Decoding Weight')
set(gca,'LineWidth',2,'FontSize',15), box off

subplot(132)
AllWCorr = AllW(abs(GoodNeur)>0);
Dat=nanzscore(AllSpk(abs(GoodNeur)>0,:)')';
% AllWCorr = AllW;
%  Dat=nanzscore(AllSpk')';
AllWCorr(find(sum(isnan(Dat)'))) = [];
Dat(find(sum(isnan(Dat)')),:) = [];
[EigVect,EigVals]=PerformPCA(Dat);
plot(EigVect(:,1),AllWCorr,'.','MarkerSize',20)
ylim([-2 2])
xlim([-0.35 0.35])
[R,P] = corrcoef(EigVect(:,1),AllWCorr)
title(['Corr: R=' num2str(R(1,2)) ' P=' num2str(P(1,2))])
xlabel('PCA1 val'), ylabel('Decoding Weight')
set(gca,'LineWidth',2,'FontSize',15), box off

subplot(133)
Cols = {UMazeColors('Shock'),UMazeColors('Safe')}
A = {RNeur(abs(GoodNeur)>0 & AllW>0.5),RNeur(abs(GoodNeur)>0 & AllW<-0.5)};
MakeSpreadAndBoxPlot_SB(A,Cols,1:2)

[p,h] = ranksum(RNeur(abs(GoodNeur)>0 & AllW>0.5),RNeur(abs(GoodNeur)>0 & AllW<-0.5))
sigstar_DB({[1,2]},[p])
set(gca,'LineWidth',2,'FontSize',15,'XTick',[1,2],'XTickLabel',{'Shock Pref','Safe Pref'}), box off
ylabel('Freq Corr - R')


%% Compare with overall position
for mm = 1:length(MiceNumber)
    PosTemp = AllSess.MouseByMouse.UMazeCond.LinPos{mm};
    ProjTemp = nanzscore(AllSess.MouseByMouse.UMazeCond.FR{mm}')*nanmean(W{mm})';
    scatter(PosTemp,ProjTemp,15,AllSess.MouseByMouse.UMazeCond.IsFz{mm},'filled')
    %     pause
    ind = find(AllSess.MouseByMouse.UMazeCond.IsFz{1}>0.9);
    hold on
    PosTemp = PosTemp(ind);
    ProjTemp = ProjTemp(ind)';
    ind = find(isnan(PosTemp) | isnan(ProjTemp));
    PosTemp(ind)= [];
    ProjTemp(ind) = [];
    [R,P] = corrcoef(PosTemp,ProjTemp);
    Rrem(mm) = R(1,2);
    Prem(mm) = P(1,2);
    %     clf
end




%% Restrict to mice with enough data to train on extreemes

figure
clear ShockFzsize  SafeFzsize W Score AllDatProj AllDatProjRand ScoreRand
for mm=1:3
    ShockFzsize(mm) = sum(MouseByMouse.LinPos{mm}<0.2);
    SafeFzsize(mm) = sum(MouseByMouse.LinPos{mm}>0.8);

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
MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
xlim([0.5 1.5])
ylim([0 1])


figure
AllSafeTrialsErrRate = [];
AllShockTrialsErrRate = [];
AllW = [];

for mm=1:3
    AllSafeTrialsErrRate = [AllSafeTrialsErrRate,nanmean(RemTrialSafe{mm}')];
    AllShockTrialsErrRate = [AllShockTrialsErrRate,nanmean(RemTrialShock{mm}')];
    AllW = [AllW,nanmean(W{mm})];

end


LinPos = [];
DataPCATogether = [];
for m= 1:3
    
    DataPCATogether = [DataPCATogether;[MouseByMouse.OBFreq{(m)}',log(MouseByMouse.HPCPower{(m)})',MouseByMouse.HR{(m)}',...
        MouseByMouse.HRVar{(m)}',MouseByMouse.RipplePower{(m)}']];
    LinPos = [LinPos,MouseByMouse.LinPos{(m)}];
    
end
dat = (nanzscore(DataPCATogether));
DecodeBrainState = nanmean(dat(find(LinPos<0.4),:))-nanmean(dat(find(LinPos>0.6),:));

Side = {'Safe','Shock'};
Resp = {'Wrong','Right'};
Variable = {'OBFreq','HPCPower','HR','HRVar','RipplePower','LinPos'};
clear ParamsErr
for ss = 1:length(Side)
    for rr = 1:length(Resp)
        for var = 1 :length(Variable)
            ParamsErr.Safe.Right.(Variable{var}) = [];
            ParamsErr.Shock.Right.(Variable{var}) = [];
            
            ParamsErr.Safe.Wrong.(Variable{var}) = [];
            ParamsErr.Shock.Wrong.(Variable{var}) = [];
        end
    end
end

clf
for mm=1:3
    for var = 1 :length(Variable)
        ParamsErr.Safe.Right.(Variable{var}) = [ParamsErr.Safe.Right.(Variable{var}),MouseByMouse.(Variable{var}){mm}((nanmean(RemTrialSafe{mm}')>0.9))];
        ParamsErr.Shock.Right.(Variable{var}) = [ParamsErr.Shock.Right.(Variable{var}),MouseByMouse.(Variable{var}){mm}((nanmean(RemTrialShock{mm}')>0.9))];
        
        ParamsErr.Safe.Wrong.(Variable{var}) = [ParamsErr.Safe.Wrong.(Variable{var}),MouseByMouse.(Variable{var}){mm}((nanmean(RemTrialSafe{mm}')<0.3))];
        ParamsErr.Shock.Wrong.(Variable{var}) = [ParamsErr.Shock.Wrong.(Variable{var}),MouseByMouse.(Variable{var}){mm}((nanmean(RemTrialShock{mm}')<0.3))];
    end
end

for ss = 1:length(Side)
    for rr = 1:length(Resp)
            DataPCA.(Side{ss}).(Resp{rr}) = [ParamsErr.(Side{ss}).(Resp{rr}).OBFreq',log(ParamsErr.(Side{ss}).(Resp{rr}).HPCPower)',ParamsErr.(Side{ss}).(Resp{rr}).HR',...
                ParamsErr.(Side{ss}).(Resp{rr}).HRVar',ParamsErr.(Side{ss}).(Resp{rr}).RipplePower'];
    end
end

Mn = nanmean([DataPCA.Shock.Right;DataPCA.Shock.Wrong;DataPCA.Safe.Right;DataPCA.Safe.Wrong]);
Std =  nanstd([DataPCA.Shock.Right;DataPCA.Shock.Wrong;DataPCA.Safe.Right;DataPCA.Safe.Wrong]);
for ss = 1:length(Side)
    for rr = 1:length(Resp)
        for var = 1 :length(Variable)-1
            DataPCA.(Side{ss}).(Resp{rr})(:,var) = (DataPCA.(Side{ss}).(Resp{rr})(:,var) - Mn(var))./Std(var)
        end
    end
end
figure
clf
DecodeBrainState = nanmean(dat(find(LinPos<0.4),:))-nanmean(dat(find(LinPos>0.6),:));
subplot(221)
coeff(:,1) = DecodeBrainState;
A = {DataPCA.Safe.Right*coeff(:,1),DataPCA.Safe.Wrong*coeff(:,1),DataPCA.Shock.Right*coeff(:,1),DataPCA.Shock.Wrong*coeff(:,1)};
Cols = [UMazeColors('Safe');UMazeColors('Safe')*0.4;UMazeColors('Shock');UMazeColors('Shock')*0.4];
violin(A,'mc',[],'facecolor',Cols,'medc','k')
violin(A,'mc',[],'facecolor',Cols,'medc','k')
set(gca,'XTick',[1:4],'XTickLabel',{'Safe-Corr','Safe-Err','Shock-Corr','Shock-Err'})
xtickangle(45)
[p2,h] = ranksum(DataPCA.Shock.Right*coeff(:,1),DataPCA.Shock.Wrong*coeff(:,1));
[p1,h] = ranksum(DataPCA.Safe.Right*coeff(:,1),DataPCA.Safe.Wrong*coeff(:,1));
sigstar_DB({[1,2],[3,4]},[p1,p2])
legend off
ylabel('Proj - physio')

subplot(222)
A = {ParamsErr.Safe.Right.LinPos,ParamsErr.Safe.Wrong.LinPos,ParamsErr.Shock.Right.LinPos,ParamsErr.Shock.Wrong.LinPos};
violin(A,'mc',[],'facecolor',Cols,'medc','k')
violin(A,'mc',[],'facecolor',Cols,'medc','k')
set(gca,'XTick',[1:4],'XTickLabel',{'Safe-Corr','Safe-Err','Shock-Corr','Shock-Err'})
xtickangle(45)
[p2,h] = ranksum(ParamsErr.Shock.Right.LinPos,ParamsErr.Shock.Wrong.LinPos);
[p1,h] = ranksum(ParamsErr.Safe.Right.LinPos,ParamsErr.Safe.Wrong.LinPos);
sigstar_DB({[1,2],[3,4]},[p1,p2])
legend off
ylabel('Lin Pos')
set(gca,'LineWidth',2,'FontSize',15), box off

subplot(212)
Val = [];
for mm=1:3
    Val = [Val,nanmean(AllDatProj{mm})];
end
scatter(LinPos,dat*DecodeBrainState',30,'filled','k'), hold on
scatter(LinPos,dat*DecodeBrainState',20,Val,'filled')
colormap(redblue)
set(gca,'LineWidth',2,'FontSize',15), box off

clear Val
for mm=1:3

for k = 1 :10
    ind = find(MouseByMouse.LinPos{mm}>(k-1)/10 & MouseByMouse.LinPos{mm}<(k)/10) ;
    if not(isempty(ind))
    Val(mm,k) = nanmean(nanmean((AllDatProj{mm}(:,ind))));
    else
       Val(mm,k) = NaN; 
    end
end
end
xlabel('Lin Pos')
ylabel('Proj - physio')
colorbar
set(gca,'LineWidth',2,'FontSize',15), box off

figure
for var = 1 :length(Variable)
    
    subplot(2,3,var)
    A = {ParamsErr.Safe.Right.(Variable{var}),ParamsErr.Safe.Wrong.(Variable{var}),ParamsErr.Shock.Right.(Variable{var}),ParamsErr.Shock.Wrong.(Variable{var})};
    violin(A,'mc',[],'facecolor',Cols,'medc','k')
    violin(A,'mc',[],'facecolor',Cols,'medc','k')
    set(gca,'XTick',[1:4],'XTickLabel',{'Safe-Corr','Safe-Err','Shock-Corr','Shock-Err'})
    xtickangle(45)
    [p2,h] = ranksum(ParamsErr.Shock.Right.(Variable{var}),ParamsErr.Shock.Wrong.(Variable{var}));
    [p1,h] = ranksum(ParamsErr.Safe.Right.(Variable{var}),ParamsErr.Safe.Wrong.(Variable{var}));
    sigstar_DB({[1,2],[3,4]},[p1,p2])
    legend off
    ylabel(Variable{var})
    set(gca,'LineWidth',2,'FontSize',15), box off
end




%%% Make the error figrue for phD

clf
subplot(211)

SafeRate = nanmean([AllSafeTrialsErrRate;1-AllShockTrialsErrRate]);

Lims = [0,0.2;0.2,0.4;0.6,0.8;0.8,1];
for l = 1:length(Lims)
    SafeRateAv(l) = 100*nanmean(SafeRate(LinPos>Lims(l,1) & LinPos<Lims(l,2)));
end
g=bar([SafeRateAv;100-SafeRateAv]','stacked');
g(1).FaceColor = UMazeColors('safe');
g(2).FaceColor = UMazeColors('shock');
set(gca,'XTick',[1:4],'XTickLabel',{'Sk','Sk-center','Sf-Center','Sf'})
box off
set(gca,'FontSize',15,'linewidth',2)
xlim([0.5 4.5])
ylabel('% Classified safe / shock')


AllSafeTrialsErrRate = [];
AllShockTrialsErrRate = [];
AllW = [];
LinPos = [];
DataPCATogether = [];
for mm=1:MiceNumber
    AllSafeTrialsErrRate = [AllSafeTrialsErrRate,nanmean(RemTrialSafe{mm}')];
    AllShockTrialsErrRate = [AllShockTrialsErrRate,nanmean(RemTrialShock{mm}')];
    AllW = [AllW,nanmean(W{mm})];
    DataPCATogether = [DataPCATogether;[MouseByMouse.OBFreq{(mm)}',log(MouseByMouse.HPCPower{(mm)})',MouseByMouse.HR{(mm)}',...
        MouseByMouse.HRVar{(mm)}',(MouseByMouse.RippleDensity{(mm)}')]];
    LinPos = [LinPos,MouseByMouse.LinPos{mm}];
    
end

dat = (nanzscore(DataPCATogether));
DecodeBrainState = nanmean(dat(find(LinPos<0.2),:))-nanmean(dat(find(LinPos>0.8),:));

Side = {'Safe','Shock'};
Resp = {'Wrong','Right'};
Variable = {'OBFreq','HPCPower','HR','HRVar','RippleDensity','LinPos'};
clear ParamsErr
for ss = 1:length(Side)
    for rr = 1:length(Resp)
        for var = 1 :length(Variable)
            ParamsErr.Safe.Right.(Variable{var}) = [];
            ParamsErr.Shock.Right.(Variable{var}) = [];
            
            ParamsErr.Safe.Wrong.(Variable{var}) = [];
            ParamsErr.Shock.Wrong.(Variable{var}) = [];
        end
    end
end


for mm= 1:MiceNumber
    for var = 1 :length(Variable)
        ParamsErr.Safe.Right.(Variable{var}) = [ParamsErr.Safe.Right.(Variable{var}),MouseByMouse.(Variable{var}){mm}((nanmean(RemTrialSafe{mm}')>0.9))];
        ParamsErr.Shock.Right.(Variable{var}) = [ParamsErr.Shock.Right.(Variable{var}),MouseByMouse.(Variable{var}){mm}((nanmean(RemTrialShock{mm}')>0.9))];
        
        ParamsErr.Safe.Wrong.(Variable{var}) = [ParamsErr.Safe.Wrong.(Variable{var}),MouseByMouse.(Variable{var}){mm}((nanmean(RemTrialSafe{mm}')<0.3))];
        ParamsErr.Shock.Wrong.(Variable{var}) = [ParamsErr.Shock.Wrong.(Variable{var}),MouseByMouse.(Variable{var}){mm}((nanmean(RemTrialShock{mm}')<0.3))];
    end
end

for ss = 1:length(Side)
    for rr = 1:length(Resp)
        DataPCA.(Side{ss}).(Resp{rr}) = [ParamsErr.(Side{ss}).(Resp{rr}).OBFreq',log(ParamsErr.(Side{ss}).(Resp{rr}).HPCPower)',ParamsErr.(Side{ss}).(Resp{rr}).HR',...
            ParamsErr.(Side{ss}).(Resp{rr}).HRVar',ParamsErr.(Side{ss}).(Resp{rr}).RippleDensity'];
    end
end

Mn = nanmean([DataPCA.Shock.Right;DataPCA.Shock.Wrong;DataPCA.Safe.Right;DataPCA.Safe.Wrong]);
Std =  nanstd([DataPCA.Shock.Right;DataPCA.Shock.Wrong;DataPCA.Safe.Right;DataPCA.Safe.Wrong]);
for ss = 1:length(Side)
    for rr = 1:length(Resp)
        for var = 1 :length(Variable)-1
            DataPCA.(Side{ss}).(Resp{rr})(:,var) = (DataPCA.(Side{ss}).(Resp{rr})(:,var) - Mn(var))./Std(var)
        end
    end
end


subplot(212)
A = {ParamsErr.Shock.Right.OBFreq,ParamsErr.Shock.Wrong.OBFreq,ParamsErr.Safe.Wrong.OBFreq,ParamsErr.Safe.Right.OBFreq};
Cols = [UMazeColors('Shock');UMazeColors('Shock')*0.7;UMazeColors('Safe')*0.7;UMazeColors('Safe')];
violin(A,'mc',[],'facecolor',Cols,'medc','k')
violin(A,'mc',[],'facecolor',Cols,'medc','k')
set(gca,'XTick',[1:4],'XTickLabel',{'Shock-Corr','Shock-Err','Safe-Err','Safe-Corr'})
[p1,h,stats] = ranksum(A{1},A{2})
[p2,h,stats] = ranksum(A{3},A{4})
sigstar_DB({[1,2],[3,4]},[p1,p2])
legend off
ylabel('OB Freq')
box off
set(gca,'FontSize',15,'linewidth',2)

figure
clear coeff
coeff(:,1) = DecodeBrainState(2:end);
A = {DataPCA.Shock.Right(:,2:end)*coeff(:,1),DataPCA.Shock.Wrong(:,2:end)*coeff(:,1),DataPCA.Safe.Wrong(:,2:end)*coeff(:,1),DataPCA.Safe.Right(:,2:end)*coeff(:,1)};
Cols = [UMazeColors('Shock');UMazeColors('Shock')*0.7;UMazeColors('Safe')*0.7;UMazeColors('Safe')];
violin(A,'mc',[],'facecolor',Cols,'medc','k')
violin(A,'mc',[],'facecolor',Cols,'medc','k')
set(gca,'XTick',[1:4],'XTickLabel',{'Shock-Corr','Shock-Err','Safe-Err','Safe-Corr'})
[p1,h,stats] = ranksum(A{1},A{2});
[p2,h,stats] = ranksum(A{3},A{4});
sigstar_DB({[1,2],[3,4]},[p1,p2])
legend off
ylabel('Proj - physio')
box off
set(gca,'FontSize',15,'linewidth',2)

