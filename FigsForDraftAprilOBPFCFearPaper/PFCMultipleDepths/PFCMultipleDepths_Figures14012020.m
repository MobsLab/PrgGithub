clear all
DataLocationPFCMultipleDepths

windowsize=1600; %in ms

binsize  = 5; %for mETAverage
nbBins = windowsize / binsize; %for mETAverage

AllEpochNames = {'Fz','NoFz','N1','N2','N3','REM','WAKE'};

for ep = 1:length(AllEpochNames)
    OBSpec.(AllEpochNames{ep}) = [];
    PFCSpec.(AllEpochNames{ep}) = [];
    PFCCoh.(AllEpochNames{ep}) = [];
    PFCTrigOnOB.(AllEpochNames{ep}) = [];
end

AllDelta = [];
AllDown = [];
MouseNum = [];
DeltaPeak = [];
MiceToUse = [6,7,8];
for m=MiceToUse
    
    
    cd(Filename{m}{1})
    % get OB channel
    if m ==7
        channel = 1;
    else
        clear channel
        load('ChannelsToAnalyse/Bulb_deep.mat')
    end
    
    cd(SleepSession{m})
    disp(SleepSession{m})
    
    % Deltas
    load('MeanSignals_Down_Delta_ForOBVolCond.mat')
    
    AllDelta = [AllDelta;MeanSig_delta];
    if not(isempty(MeanSig_down))
        AllDown = [AllDown;MeanSig_down];
    else
        AllDown = [AllDown;MeanSig_delta*NaN];
    end
    
    [val,ind] = max(abs(MeanSig_delta(:,150:186))');
    DeltaPeak = [DeltaPeak; MeanSig_delta(sub2ind(size(MeanSig_delta),1:size(MeanSig_delta,1),ind+150))'];
    
    MouseNum = [MouseNum;m*ones(size(MeanSig_delta,1),1)];
    
    % load spectra for sleep
    clear Sptsd Coh AllLFP
    [Sp,t,f] = LoadSpectrumML(channel,pwd,'low');
    Sptsd.OB  = tsd(t*1e4,Sp);
    for cc=1:size(AllChans{m},2)
        [Sp,t,f] = LoadSpectrumML(AllChans{m}(cc),pwd,'low');
        Sptsd.(['PFC',num2str(cc)])= tsd(t*1e4,Sp);
        
        [Sp,t,f] = LoadCohgramML(channel,AllChans{m}(cc),pwd,'low');
        Coh.(['PFC',num2str(cc)])= tsd(t*1e4,Sp);
    end
    
    
    load('SleepSubstages.mat')
    
    % load phases to trigger
    clear AllPeaks AllLFP
    load(['MiniMaxiLFP/MiniMaxiLFP_BulbDeep.mat'],'channel','AllPeaks')
    troughs = ts(AllPeaks(AllPeaks(:,2)<0,1)*1E4);
    
    for cc=1:size(AllChans{m},2)
        load(['LFPData/LFP',num2str(AllChans{m}(cc)),'.mat'])
        AllLFP{cc} = LFP;
        
    end
    
    fld = fieldnames(Sptsd);
    
    for st = 1:5
        OBSpec.(NameEpoch{st}) = [OBSpec.(NameEpoch{st});nanmean(Data(Restrict(Sptsd.(fld{1}),Epoch{st})))];
        
        for fl = 2:length(fld)
            PFCSpec.(NameEpoch{st}) = [PFCSpec.(NameEpoch{st});nanmean(Data(Restrict(Sptsd.(fld{fl}),Epoch{st})))];
            PFCCoh.(NameEpoch{st}) = [PFCCoh.(NameEpoch{st});nanmean(Data(Restrict(Coh.(fld{fl}),Epoch{st})))];
            
            [mn,~,tps] = mETAverage(Range(Restrict(troughs,Epoch{st})), Range(LFP), Data(AllLFP{fl-1}), binsize, nbBins);
            
            PFCTrigOnOB.(NameEpoch{st}) = [PFCTrigOnOB.(NameEpoch{st});mn'];
        end
    end
    
    
    
    
    
    %% FREEZING
    OBSpec_Fz_temp = [];
    OBSpec_NoFz_temp = [];
    
    PFCSpec_Fz_temp = cell(1,length(fld)-1);
    PFCCoh_Fz_temp = cell(1,length(fld)-1);
    PFCSpec_NoFz_temp = cell(1,length(fld)-1);
    PFCCoh_NoFz_temp = cell(1,length(fld)-1);
    
    PFCTrigOnOB_NoFz_temp = cell(1,length(fld)-1);
    PFCTrigOnOB_Fz_temp = cell(1,length(fld)-1);
    
    clear Sptsd Coh
    
    for ff=1:length(Filename{m})
        cd(Filename{m}{ff})
        disp(Filename{m}{ff})
        clear Sptsd Coh AllLFP
        
        % load spectra
        [Sp,t,f] = LoadSpectrumML(channel,pwd,'low');
        Sptsd.OB  = tsd(t*1e4,Sp);
        for cc=1:size(AllChans{m},2)
            [Sp,t,f] = LoadSpectrumML(AllChans{m}(cc),pwd,'low');
            Sptsd.(['PFC',num2str(cc)])= tsd(t*1e4,Sp);
            
            [Sp,t,f] = LoadCohgramML(channel,AllChans{m}(cc),pwd,'low');
            Coh.(['PFC',num2str(cc)])= tsd(t*1e4,Sp);
        end
        
        % load phases to trigger
        clear AllPeaks
        load(['MiniMaxiLFP/MiniMaxiLFP_BulbDeep.mat'],'channel','AllPeaks')
        troughs = ts(AllPeaks(AllPeaks(:,2)<0,1)*1E4);
        
        for cc=1:size(AllChans{m},2)
            load(['LFPData/LFP',num2str(AllChans{m}(cc)),'.mat'])
            AllLFP{cc} = LFP;
            
        end
        
        % get epochs
        clear Behav FreezeAccEpoch MovAcctsd NoFzEp FzEp
        if exist('behavResources_SB.mat')>0
            load('behavResources_SB.mat')
            FzEp = Behav.FreezeAccEpoch;
            NoFzEp = intervalSet(0,max(Range(Behav.MovAcctsd))) - FzEp;
            
            if not(isempty(strfind(Filename{m}{ff},'UMazeCond')))
                FzEp = and(FzEp,or(Behav.ZoneEpoch{1},Behav.ZoneEpoch{4}));
            end
        else
            load('behavResources.mat')
            FzEp = FreezeAccEpoch;
            NoFzEp = intervalSet(0,max(Range(MovAcctsd))) - FzEp;
        end
        
        fld = fieldnames(Sptsd);
        OBSpec_Fz_temp = [OBSpec_Fz_temp;(Data(Restrict(Sptsd.(fld{1}),FzEp)))];
        OBSpec_NoFz_temp = [OBSpec_NoFz_temp;(Data(Restrict(Sptsd.(fld{1}),NoFzEp)))];
        
        for fl = 2:length(fld)
            PFCSpec_Fz_temp{fl-1} = [PFCSpec_Fz_temp{fl-1};(Data(Restrict(Sptsd.(fld{fl}),FzEp)))];
            PFCCoh_Fz_temp{fl-1} = [PFCCoh_Fz_temp{fl-1};(Data(Restrict(Coh.(fld{fl}),FzEp)))];
            PFCSpec_NoFz_temp{fl-1} = [PFCSpec_NoFz_temp{fl-1};(Data(Restrict(Sptsd.(fld{fl}),NoFzEp)))];
            PFCCoh_NoFz_temp{fl-1} = [PFCCoh_NoFz_temp{fl-1};(Data(Restrict(Coh.(fld{fl}),NoFzEp)))];
            
            [mn,~,tps] = mETAverage(Range(Restrict(troughs,FzEp)), Range(LFP), Data(AllLFP{fl-1}), binsize, nbBins);
            PFCTrigOnOB_Fz_temp{fl-1} = [PFCTrigOnOB_Fz_temp{fl-1};mn'];
            
            [mn,~,tps] = mETAverage(Range(Restrict(troughs,NoFzEp)), Range(LFP), Data(AllLFP{fl-1}), binsize, nbBins);
            PFCTrigOnOB_NoFz_temp{fl-1} = [PFCTrigOnOB_NoFz_temp{fl-1};mn'];
            
            
        end
        
    end
    
    OBSpec.Fz = [OBSpec.Fz;nanmean(OBSpec_Fz_temp)];
    OBSpec.NoFz = [OBSpec.NoFz;nanmean(OBSpec_NoFz_temp)];
    
    for fl = 2:length(fld)
        PFCSpec.Fz = [PFCSpec.Fz;nanmean(PFCSpec_Fz_temp{fl-1})];
        PFCCoh.Fz = [PFCCoh.Fz;nanmean(PFCCoh_Fz_temp{fl-1})];
        PFCTrigOnOB.Fz = [PFCTrigOnOB.Fz;nanmean(PFCTrigOnOB_Fz_temp{fl-1})];
        PFCSpec.NoFz = [PFCSpec.NoFz;nanmean(PFCSpec_NoFz_temp{fl-1})];
        PFCCoh.NoFz = [PFCCoh.NoFz;nanmean(PFCCoh_NoFz_temp{fl-1})];
        PFCTrigOnOB.NoFz = [PFCTrigOnOB.NoFz;nanmean(PFCTrigOnOB_NoFz_temp{fl-1})];
        
        
    end
    
end

[val,ind] = sort(DeltaPeak);

% Show what we're using to order the channels
figure
clf
subplot(121)
cols = distinguishable_colors(max(MouseNum))';
for i = 1:11
    plot(tps-5,AllDelta(i,:),'linewidth',2,'color',cols(:,(i)))
    hold on
end

for i = 1:size(AllDelta,1)
plot(tps,AllDelta(i,:),'linewidth',2,'color',cols(:,MouseNum(i)))
hold on
end
xlim([-500 500])
set(gca,'FontSize',12,'FontWeight','bold','linewidth',2), box off
xlabel('Time to delta(ms)')
ylabel('Amplitude')
legend({'M1','M2','M3','M4','M5','M6','M7','M8','M9','M10','M11'})

subplot(122)
imagesc(tps,1:size(AllDelta,1),AllDelta(ind,:))
xlim([-500 500])
set(gca,'FontSize',12,'FontWeight','bold','linewidth',2), box off
xlabel('Time to delta(ms)')
ylabel('Tetrode - ordered by delta peak')
yyaxis right
plot(MouseNum(ind)*20-400,1:size(AllDelta,1),'o-','color','w','linewidth',3)
set(gca,'YTickLabel',[])
box off

%% PFC TriggeredONOB
figure
clf
for ep = 1:length(AllEpochNames)
 if ep<3
    subplot(3,3,ep)
    else
            subplot(3,3,ep+1)
 end
 imagesc(tps,1:size(AllDelta,1),PFCTrigOnOB.(AllEpochNames{ep})(ind,:))
    Vals(ep,:) = max(PFCTrigOnOB.(AllEpochNames{ep})(ind,:)')-min(PFCTrigOnOB.(AllEpochNames{ep})(ind,:)');
    clim([-1.3 0.7]*1E3)
    title(AllEpochNames{ep})
    set(gca,'FontSize',12,'FontWeight','bold','linewidth',2), box off
    xlabel('Time to OB trough(ms)')
    ylabel('Ordered tetrode num ')
    xlim([-500 500])

end

clf
for ep = 1:length(AllEpochNames)
    
    if ep<3
    subplot(3,3,ep)
    else
            subplot(3,3,ep+1)
    end
    scatter(DeltaPeak(ind),Vals(ep,:),20,'filled')
    [R,P] = corrcoef(DeltaPeak(ind)',Vals(ep,:));
    text(-800,1700,strcat('P=',num2str(round(P(1,2)*1000)/1000)))
    text(-800,1500,strcat('R=',num2str(round(R(1,2)*1000)/1000)))
    ylim([0 2000])
      title(AllEpochNames{ep})
      set(gca,'FontSize',12,'FontWeight','bold','linewidth',2), box off
xlabel('Delta Peak Val')
ylabel('Amp PFC triggered on OB')
end

%% PFC coherence
figure
clf
for ep = 1:length(AllEpochNames)
 if ep<3
    subplot(3,3,ep)
    else
            subplot(3,3,ep+1)
 end
 imagesc(f,1:size(AllDelta,1),PFCCoh.(AllEpochNames{ep})(ind,:))
  %  Vals(ep,:) = max(PFCTrigOnOB.(AllEpochNames{ep})(ind,:)')-min(PFCTrigOnOB.(AllEpochNames{ep})(ind,:)');
   % clim([-1.3 0.7]*1E3)
    title(AllEpochNames{ep})
    set(gca,'FontSize',12,'FontWeight','bold','linewidth',2), box off
    xlabel('Frequency (Hz)')
    ylabel('Ordered tetrode num ')

end

clf
for ep = 1:length(AllEpochNames)
    
    if ep<3
    subplot(3,3,ep)
    else
            subplot(3,3,ep+1)
    end
    scatter(DeltaPeak(ind),Vals(ep,:),20,'filled')
    [R,P] = corrcoef(DeltaPeak(ind)',Vals(ep,:));
    text(-800,1700,strcat('P=',num2str(round(P(1,2)*1000)/1000)))
    text(-800,1500,strcat('R=',num2str(round(R(1,2)*1000)/1000)))
    ylim([0 2000])
      title(AllEpochNames{ep})
      set(gca,'FontSize',12,'FontWeight','bold','linewidth',2), box off
xlabel('Delta Peak Val')
ylabel('Amp PFC triggered on OB')
end


figure
subplot(122)
for ep = 1:length(AllEpochNames)
plot(f,nanmean(PFCCoh.(AllEpochNames{ep})),'linewidth',3)
hold on
end
set(gca,'FontSize',12,'FontWeight','bold','linewidth',2), box off
xlabel('Frequency (Hz)')
ylabel('PFC-OB coherence')
subplot(121)
for ep = 1:length(AllEpochNames)
plot(f,nanmean(OBSpec.(AllEpochNames{ep})),'linewidth',3)
hold on
end
set(gca,'FontSize',12,'FontWeight','bold','linewidth',2), box off
xlabel('Frequency (Hz)')
ylabel('OB power')
legend(AllEpochNames(3:5))

figure
subplot(122)
for ep = 3:5
plot(f,nanmean(PFCCoh.(AllEpochNames{ep})),'linewidth',3)
hold on
end
set(gca,'FontSize',12,'FontWeight','bold','linewidth',2), box off
xlabel('Frequency (Hz)')
ylabel('PFC-OB coherence')
subplot(121)
for ep = 3:5
plot(f,nanmean(OBSpec.(AllEpochNames{ep})),'linewidth',3)
hold on
end
set(gca,'FontSize',12,'FontWeight','bold','linewidth',2), box off
xlabel('Frequency (Hz)')
ylabel('OB power')
legend(AllEpochNames(3:5))


clf
for ep = 1:length(AllEpochNames)
    subplot(3,3,ep)
    imagesc(sortrows([DeltaPeak,PFCCoh.(AllEpochNames{ep})]))
    clim([0.3 0.9])
    title(AllEpochNames{ep})
end



clf
for ep = 1:length(AllEpochNames)
    subplot(3,3,ep)
    Mat = sortrows([DeltaPeak,log(PFCSpec.(AllEpochNames{ep}))]);
    imagesc(Mat(:,2:end))
    %clim([0.3 0.9])
    title(AllEpochNames{ep})
end


for ep = 1:length(AllEpochNames)

A = sortrows([DeltaPeak,PFCCoh.(AllEpochNames{ep})]);
A = A(:,2:end);
A(17,:)=A(17,:)*NaN;
A(27,:)=A(27,:)*NaN;
A(34,:)=A(34,:)*NaN;
A=nanmean(A(:,30:70)');
A(isnan(A)) = [];
plot(A,'*-')
hold on

end
legend(AllEpochNames)






clf
for ep = 1:length(AllEpochNames)
    
    if ep<3
        subplot(3,3,ep)
    else
        subplot(3,3,ep+1)
    end
    A = PFCCoh.(AllEpochNames{ep});
    A=nanmean(A(:,20:70)');
    
    
    scatter(DeltaPeak,A,20,'filled')
    [R,P] = corrcoef(DeltaPeak',A');
    title(AllEpochNames{ep})
        ylim([0.4 1.1])

    text(-800,1.05,strcat('P=',num2str(round(P(1,2)*1000)/1000)))
    text(-800,1.0,strcat('R=',num2str(round(R(1,2)*1000)/1000)))
    title(AllEpochNames{ep})
    set(gca,'FontSize',12,'FontWeight','bold','linewidth',2), box off
    xlabel('Delta Peak Val')
    ylabel('OB-FC coherence')
end


% By mouse

clf
for ep = 1:length(AllEpochNames)
    
    if ep<3
        subplot(3,3,ep)
    else
        subplot(3,3,ep+1)
    end
    A = PFCCoh.(AllEpochNames{ep});
    A=nanmean(A(:,20:70)');
    
    
    scatter(DeltaPeak,A,20,MouseNum,'filled')
    [R,P] = corrcoef(DeltaPeak',A');
    title(AllEpochNames{ep})
        ylim([0.4 1.1])

    text(-800,1.05,strcat('P=',num2str(round(P(1,2)*1000)/1000)))
    text(-800,1.0,strcat('R=',num2str(round(R(1,2)*1000)/1000)))
    title(AllEpochNames{ep})
    set(gca,'FontSize',12,'FontWeight','bold','linewidth',2), box off
    xlabel('Delta Peak Val')
    ylabel('OB-FC coherence')
end

clf
num = 1;

for mm = 1:11
    
    if sum((MouseNum==mm))>4
        subplot(6,3,(num-1)*3+1)
        plot(tps,AllDelta(MouseNum==mm,:),'linewidth',2)
                      set(gca,'FontSize',12,'FontWeight','bold','linewidth',2), box off
  xlim([-500 500])
        ylim([-1000 2000])
        ep=1
        subplot(6,3,(num-1)*3+2)
        A = PFCCoh.(AllEpochNames{ep});
        A=nanmean(A(:,20:70)');
        
        
        scatter(DeltaPeak(MouseNum==mm),A(MouseNum==mm),20,'filled')
        [R,P] = corrcoef(DeltaPeak',A');
        title(AllEpochNames{ep})
        keyboard
        % text(-800,1.05,strcat('P=',num2str(round(P(1,2)*1000)/1000)))
        % text(-800,1.0,strcat('R=',num2str(round(R(1,2)*1000)/1000)))
        title(AllEpochNames{ep})
        set(gca,'FontSize',12,'FontWeight','bold','linewidth',2), box off
        xlabel('Delta Peak Val')
        ylabel('OB-FC Coh')
        
        ep=5
        subplot(6,3,(num-1)*3+3)
        A = PFCCoh.(AllEpochNames{ep});
        A=nanmean(A(:,20:70)');
        
        
        scatter(DeltaPeak(MouseNum==mm),A(MouseNum==mm),20,'filled')
        [R,P] = corrcoef(DeltaPeak',A');
        title(AllEpochNames{ep})
        
        % text(-800,1.05,strcat('P=',num2str(round(P(1,2)*1000)/1000)))
        % text(-800,1.0,strcat('R=',num2str(round(R(1,2)*1000)/1000)))
        title(AllEpochNames{ep})
        set(gca,'FontSize',12,'FontWeight','bold','linewidth',2), box off
        xlabel('Delta Peak Val')
        ylabel('OB-FC Coh')
        
        num = num+1;
    end
end


clf
for ep = 1:length(AllEpochNames)
    
    if ep<3
        subplot(3,3,ep)
    else
        subplot(3,3,ep+1)
    end
    A = PFCCoh.(AllEpochNames{ep});
    A=nanmax(A(:,20:70)');
    
    ATemp = A;
    DeltaPeakTemps = DeltaPeak;
    ATemp(MouseNum==7)=[];
    DeltaPeakTemps(MouseNum==7)=[];
    
    scatter(DeltaPeakTemps,ATemp,20,'filled')
    [R,P] = corrcoef(DeltaPeakTemps',ATemp');
    title(AllEpochNames{ep})
        ylim([0.4 1.1])

    text(-800,1.05,strcat('P=',num2str(round(P(1,2)*1000)/1000)))
    text(-800,1.0,strcat('R=',num2str(round(R(1,2)*1000)/1000)))
    title(AllEpochNames{ep})
    set(gca,'FontSize',12,'FontWeight','bold','linewidth',2), box off
    xlabel('Delta Peak Val')
    ylabel('OB-FC coherence')
end


subplot(121)
for ep = 1:length(AllEpochNames)

plot(nanmean(PFCCoh.(AllEpochNames{ep})),'linewidth',3)
ValP(ep) = max(nanmean(PFCCoh.(AllEpochNames{ep})));

hold on
end



subplot(122)
for ep = 1:length(AllEpochNames)

plot(nanmean(OBSpec.(AllEpochNames{ep})),'linewidth',3)
ValOB(ep) = max(nanmean(OBSpec.(AllEpochNames{ep})));
hold on
end









figure
clf
for ep = 1:length(AllEpochNames)
 if ep<3
    subplot(3,3,ep)
    else
            subplot(3,3,ep+1)
 end
 imagesc(f,1:size(AllDelta,1),log(OBSpec.(AllEpochNames{ep})((MouseNum(ind)),:)))

end


%% mice for review

figure
for i =6:8
    
    subplot(2,3,i-5)
    plot(AllDelta(MouseNum==i,:)')
    
    subplot(2,3,i+3-5)
    %     plot(log(PFCSpec.Fzrz(MouseNum==i,:)'))
    
    A = PFCCoh.Fz;
    A=nanmax(A(:,20:70)');
    
    ATemp = A;
    DeltaPeakTemps = DeltaPeak;
    ATemp = ATemp(MouseNum==i);
    DeltaPeakTemps = DeltaPeakTemps(MouseNum==i);
    
    scatter(DeltaPeakTemps,ATemp,20,'filled')
    [R,P] = corrcoef(DeltaPeakTemps',ATemp');
end



for m =1:length(MiceToUse)
    cd(SleepSession{MiceToUse(m)})
    clear    LFP_temp channelOB channelHPC
    
    load(['LFPData/LFP',num2str(ChansToUse(m,1))],'LFP');
    LFP_temp{1}=ResampleTSD(LFP,params.Fs);
    
    
    load(['LFPData/LFP',num2str(ChansToUse(m,2))],'LFP');
    LFP_temp{2}=ResampleTSD(LFP,params.Fs);
    
    LFPLocal = tsd(Range(LFP_temp{1}),Data(LFP_temp{1})-Data(LFP_temp{2}));
    
    
    load('ChannelsToAnalyse/Bulb_deep.mat')
    load(['LFPData/LFP',num2str(channel)],'LFP');
    channelOB =channel;
    LFP_temp{3}=ResampleTSD(LFP,params.Fs);
    
    try
        load('ChannelsToAnalyse/dHPC_deep.mat')
    catch
        load('ChannelsToAnalyse/dHPC_rip.mat')
    end
    load(['LFPData/LFP',num2str(channel)],'LFP');
    LFP_temp{4}=ResampleTSD(LFP,params.Fs);
    channelHPC =channel;
    
    % Local OB
    [Coh,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPLocal),Data(LFP_temp{3}),movingwin,params);
    save(['CohgramDataL/CohgramLocPFC_',num2str(channelOB)],'-v7.3','S12','phi','Coh','t','f','params','movingwin');
    
    % Local HPC
    [Coh,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPLocal),Data(LFP_temp{4}),movingwin,params);
    save(['CohgramDataL/CohgramLocPFC_',num2str(channelHPC)],'-v7.3','S12','phi','Coh','t','f','params','movingwin');
    
    % HPC
    LoadCohgramML(channelHPC,ChansToUse(m,1),pwd,'low');
    LoadCohgramML(channelHPC,ChansToUse(m,2),pwd,'low');
    
    
    
end

% wake
ChansToUse = [2,5;3,4;1,6];
MiceToUse = [6,7,8];
[params,movingwin,suffix]=SpectrumParametersML('low');

for m =1:length(MiceToUse)
    cd(Filename{MiceToUse(m)}{1})
    clear    LFP_temp channelOB channelHPC
    
    load(['LFPData/LFP',num2str(AllChans{MiceToUse(m)}(ChansToUse(m,1)))],'LFP');
    LFP_temp{1}=ResampleTSD(LFP,params.Fs);
    
    
    load(['LFPData/LFP',num2str(AllChans{MiceToUse(m)}(ChansToUse(m,2)))],'LFP');
    LFP_temp{2}=ResampleTSD(LFP,params.Fs);
    
    LFPLocal = tsd(Range(LFP_temp{1}),Data(LFP_temp{1})-Data(LFP_temp{2}));
    
    
    load('ChannelsToAnalyse/Bulb_deep.mat')
    load(['LFPData/LFP',num2str(channel)],'LFP');
    channelOB =channel;
    LFP_temp{3}=ResampleTSD(LFP,params.Fs);
    
    try
        load('ChannelsToAnalyse/dHPC_deep.mat')
    catch
        load('ChannelsToAnalyse/dHPC_rip.mat')
    end
    load(['LFPData/LFP',num2str(channel)],'LFP');
    LFP_temp{4}=ResampleTSD(LFP,params.Fs);
    channelHPC =channel;
    
    % Local OB
    [Coh,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPLocal),Data(LFP_temp{3}),movingwin,params);
    save(['CohgramDataL/CohgramLocPFC_',num2str(channelOB)],'-v7.3','S12','phi','Coh','t','f','params','movingwin');
    
    % Local HPC
    [Coh,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPLocal),Data(LFP_temp{4}),movingwin,params);
    save(['CohgramDataL/CohgramLocPFC_',num2str(channelHPC)],'-v7.3','S12','phi','Coh','t','f','params','movingwin');
    
    % HPC
    LoadCohgramML(channelHPC,AllChans{MiceToUse(m)}(ChansToUse(m,1)),pwd,'low');
    LoadCohgramML(channelHPC,AllChans{MiceToUse(m)}(ChansToUse(m,2)),pwd,'low');
    
    
    
end



AllDelta = [];
AllDown = [];
MouseNum = [];
DeltaPeak = [];

for m=1:length(MiceToUse)
    
        
    cd(SleepSession{MiceToUse(m)})
    disp(SleepSession{m})
    
    % Deltas
    load('MeanSignals_Down_Delta_ForOBVolCond.mat')
    
    AllDelta = [AllDelta;MeanSig_delta];
    if not(isempty(MeanSig_down))
        AllDown = [AllDown;MeanSig_down];
    else
        AllDown = [AllDown;MeanSig_delta*NaN];
    end
    MouseNum = [MouseNum;m*ones(size(MeanSig_delta,1),1)];

    
    [val,ind] = max(abs(MeanSig_delta(:,150:186))');
    DeltaPeak = [DeltaPeak; MeanSig_delta(sub2ind(size(MeanSig_delta),1:size(MeanSig_delta,1),ind+150))'];

end




% Figure
for m =1:length(MiceToUse)
    cd(Filename{MiceToUse(m)}{1})
    clear    LFP_temp channelOB channelHPC
    
    
    load('ChannelsToAnalyse/Bulb_deep.mat')
    channelOB =channel;
    
    try
        load('ChannelsToAnalyse/dHPC_deep.mat')
    catch
        load('ChannelsToAnalyse/dHPC_rip.mat')
    end
    channelHPC =channel;
    
    % Local OB
    load(['CohgramDataL/CohgramLocPFC_',num2str(channelOB)]);
    Ctsd_OBLocal= tsd(t*1e4,Coh);
    try
        load(['CohgramDataL/Cohgram',num2str(channelOB),'_',num2str(AllChans{MiceToUse(m)}(ChansToUse(m,1))),'.mat']);
    catch
        load(['CohgramDataL/Cohgram',num2str(AllChans{MiceToUse(m)}(ChansToUse(m,1))),'_',num2str(channelOB),'.mat']);
    end
    Ctsd_OB1= tsd(t*1e4,Coh);
    try
        load(['CohgramDataL/Cohgram',num2str(channelOB),'_',num2str(AllChans{MiceToUse(m)}(ChansToUse(m,2))),'.mat']);
    catch
        load(['CohgramDataL/Cohgram',num2str(AllChans{MiceToUse(m)}(ChansToUse(m,2))),'_',num2str(channelOB),'.mat']);
    end
    Ctsd_OB2= tsd(t*1e4,Coh);
    
    % Local HPC
    load(['CohgramDataL/CohgramLocPFC_',num2str(channelHPC)])
    Ctsd_HPCLocal= tsd(t*1e4,Coh);
    try
        load(['CohgramDataL/Cohgram',num2str(channelHPC),'_',num2str(AllChans{MiceToUse(m)}(ChansToUse(m,1))),'.mat']);
    catch
        load(['CohgramDataL/Cohgram',num2str(AllChans{MiceToUse(m)}(ChansToUse(m,1))),'_',num2str(channelHPC),'.mat']);
    end
    Ctsd_HPC1= tsd(t*1e4,Coh);
    try
        load(['CohgramDataL/Cohgram',num2str(channelHPC),'_',num2str(AllChans{MiceToUse(m)}(ChansToUse(m,2))),'.mat']);
    catch
        load(['CohgramDataL/Cohgram',num2str(AllChans{MiceToUse(m)}(ChansToUse(m,2))),'_',num2str(channelHPC),'.mat']);
    end
    Ctsd_HPC2= tsd(t*1e4,Coh);
    
    load('behavResources_SB.mat')
    MeanCtsd_OBLocal(m,:) = nanmean(Data(Restrict(Ctsd_OBLocal,Behav.FreezeAccEpoch)));
    MeanCtsd_OB1(m,:) = nanmean(Data(Restrict(Ctsd_OB1,Behav.FreezeAccEpoch)));
    MeanCtsd_OB2(m,:) = nanmean(Data(Restrict(Ctsd_OB2,Behav.FreezeAccEpoch)));
    
    MeanCtsd_HPCLocal(m,:) = nanmean(Data(Restrict(Ctsd_HPCLocal,Behav.FreezeAccEpoch)));
    MeanCtsd_HPC1(m,:) = nanmean(Data(Restrict(Ctsd_HPC1,Behav.FreezeAccEpoch)));
    MeanCtsd_HPC2(m,:) = nanmean(Data(Restrict(Ctsd_HPC2,Behav.FreezeAccEpoch)));
    
    
    
end


figure
subplot(121)
plot(f,mean(MeanCtsd_OB1),'k','linewidth',3)
hold on
plot(f,mean(MeanCtsd_OB2),'color',[0.8 0.8 0.8],'linewidth',3)
plot(f,mean(MeanCtsd_OBLocal),'r','linewidth',3)
ylim([0.4 0.8])
legend('Deep','Sup','Diff')
xlabel('Frequency (Hz)')
ylabel('Coherence')
title('PFC - OB')
set(gca,'FontSize',20,'linewidth',2)
box off
subplot(122)
plot(f,mean(MeanCtsd_HPC1),'k','linewidth',3)
hold on
plot(f,mean(MeanCtsd_HPC2),'color',[0.8 0.8 0.8],'linewidth',3)
plot(f,mean(MeanCtsd_HPCLocal),'r','linewidth',3)
ylim([0.4 0.8])
xlabel('Frequency (Hz)')
ylabel('Coherence')
title('PFC - HPC')
set(gca,'FontSize',20,'linewidth',2)
box off


figure
subplot(121)
g = shadedErrorBar(f,mean(MeanCtsd_OB1),stdError(MeanCtsd_OB1));
hold on
g = shadedErrorBar(f,mean(MeanCtsd_OB2),stdError(MeanCtsd_OB2));
g = shadedErrorBar(f,mean(MeanCtsd_OBLocal),stdError(MeanCtsd_OBLocal));

plot(f,mean(MeanCtsd_OB1),'k','linewidth',2)
hold on
plot(f,mean(MeanCtsd_OB2),'color',[0.8 0.8 0.8],'linewidth',2)
plot(f,mean(MeanCtsd_OBLocal),'r','linewidth',2)
ylim([0.4 0.8])
legend('Deep','Sup','Diff')
xlabel('Frequency (Hz)')
ylabel('Coherence')
title('PFC - OB')
set(gca,'FontSize',20,'linewidth',2)
box off
subplot(122)
plot(f,mean(MeanCtsd_HPC1),'k','linewidth',2)
hold on
plot(f,mean(MeanCtsd_HPC2),'color',[0.8 0.8 0.8],'linewidth',2)
plot(f,mean(MeanCtsd_HPCLocal),'r','linewidth',2)
ylim([0.4 0.8])
xlabel('Frequency (Hz)')
ylabel('Coherence')
title('PFC - HPC')
set(gca,'FontSize',20,'linewidth',2)
box off




for mm = MiceToUse
    
    subplot(2,3,mm-5)
    plot(tps,AllDelta(MouseNum==mm,:),'linewidth',2)
    set(gca,'FontSize',12,'FontWeight','bold','linewidth',2), box off
    xlim([-500 500])
    ylim([-1000 2000])
    
    subplot(2,3,mm-5+3)
    A = PFCCoh.Fz;
    A=nanmean(A(:,20:70)');
    
    scatter(DeltaPeak(MouseNum==mm),A(MouseNum==mm),50,lines(sum(MouseNum==mm)),'filled')
    [R,P] = corrcoef(DeltaPeak(MouseNum==mm),A(MouseNum==mm));
    xlabel('Delta peak')
    ylabel('PFC-OB Coherence')
    xlim([-1000 2000])
    % ylim([0.5 0.85])
    set(gca,'FontSize',12,'FontWeight','bold','linewidth',2), box off
    title(num2str(R(1,2)))
    P(1,2)
end


