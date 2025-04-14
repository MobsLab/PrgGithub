
clear all

PFC=0;

%% Make data
if PFC
    Session_type={'Cond','Ext','Fear'}; sess=3;
    MiceNumber=[490,507,508,509,514]; % excluded 514, too few ripples
    cd('/home/ratatouille/Dropbox/Mobs_member/BaptisteMaheo/Data/Data_BM/Ripples_Reactivations')
    %     cd ~/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples
else
    MiceNumber = [905,906,911,994,1161,1162,1168,1186,1230,1239]; % no 1182 because problem of stim
    cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data
end

SortByEigVal = 1;
Binsize = 0.1*1e4;
num = 1;


for mm=1:length(MiceNumber)
    mm
    
    clear eigenvalues Spikes StimEpoch Ripples strength templates correlations eigenvectors lambdaMax
    
    if PFC
        load(['RippleReactInfo_NewRipples_SWR_05042024_' Session_type{sess} '_M',num2str(MiceNumber(mm)),'.mat'])
        %         load(['RippleReactInfo_NewRipples_M',num2str(MiceNumber(mm)),'.mat'])
        window_around_rip = [.050 .100];
        window_around_ctrl = [2 1.75];
        shock_lim = .35;
        Sleep = load('~/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples/AllRippleInfo_DiffEpochs.mat','Ripples','Spikes');
    else
        load(['RippleReactInfo_NewRipples_Cond_Mouse',num2str(MiceNumber(mm)),'.mat'])
        window_around_rip = [0.050 0.050];
        window_around_ctrl = [2 1.9];
        shock_lim = .2;
%         Sleep = load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data/AllRippleInfo_DiffEpochs.mat','Ripples','Spikes');
    end
    
    Q = MakeQfromS(Spikes,Binsize); % data from the conditionning session
    Q = tsd(Range(Q),nanzscore(full(Data(Q))));
    
    % Define the template epochs
    StimEpochToRemove = intervalSet(Start(StimEpoch),Start(StimEpoch)+0.2*1e4);
    RipEpochToRemove = intervalSet(Range(Ripples)-window_around_rip(1)*1e4,Range(Ripples)+window_around_rip(2)*1e4);
    TotEpoch = intervalSet(0,max(Range(Vtsd)));
    
        Ripples = Restrict(Ripples,TotEpoch-NoiseEpoch);
        Ripples = Restrict(Ripples , and(thresholdIntervals(LinPos,0.6,'Direction','Above') , FreezeEpoch));

    
    clear Epoch
    Epoch.Shock=thresholdIntervals(LinPos,shock_lim,'Direction','Below')-or(StimEpochToRemove,RipEpochToRemove);
    Epoch.ShockMov=and(MovEpoch,Epoch.Shock);
    Epoch.ShockFreeze=and(FreezeEpoch,Epoch.Shock);
    Epoch.Poststim=intervalSet(Start(StimEpoch),Start(StimEpoch)+2*1e4)-or(StimEpochToRemove,RipEpochToRemove);
    Epoch.PreStim=intervalSet(Start(StimEpoch)-3*1e4,Start(StimEpoch)-1*1e4)-or(StimEpochToRemove,RipEpochToRemove);
    
    Epoch.Safe=thresholdIntervals(LinPos,0.6,'Direction','Above')-or(StimEpochToRemove,RipEpochToRemove);
    Epoch.SafeMov=and(MovEpoch,Epoch.Safe);
    Epoch.SafeFreeze=and(FreezeEpoch,Epoch.Safe);
    Epoch.PostRipples=mergeCloseIntervals(intervalSet(Range(Ripples)-window_around_rip(1)*1e4,Range(Ripples)+window_around_rip(2)*1e4),0.1*1e4)-StimEpochToRemove;
    Epoch.PreRipples=(mergeCloseIntervals(intervalSet(Range(Ripples)-window_around_ctrl(1)*1e4,Range(Ripples)-window_around_ctrl(2)*1e4),0.1*1e4)-StimEpochToRemove)-Epoch.PostRipples;
    
    Rip_number(mm) = length(Range(Ripples));
    Stim_number(mm) = length(Start(StimEpoch));
    FzDur(mm) = sum(DurationEpoch(FreezeEpoch))/60e4;
    
    EpochNames = fieldnames(Epoch);
    
    clear templates correlations eigenvalues eigenvectors lambdaMax DatPoints GlobalCorr
    for k = 1:length(EpochNames)
        QTemplate = Restrict(Q,Epoch.(EpochNames{k}));
        % z-score the template epoch
        QTemplate = tsd(Range(QTemplate),(Data(QTemplate)));
        dat = Data(QTemplate);
        if k== 8
            size(dat)
        end
        BadGuys = find(sum(isnan(Data(QTemplate))));
        for spk = 1:length(BadGuys)
            dat(:,BadGuys(spk)) = zeros(size(dat,1),1);
        end
        DatPoints.(EpochNames{k}) = size(dat,1);
        
        [templates.(EpochNames{k}),correlations.(EpochNames{k}),eigenvalues.(EpochNames{k}),eigenvectors.(EpochNames{k}),lambdaMax.(EpochNames{k})] = ActivityTemplates_SB(dat,0);
    end
    
    
    %% add the templates from sleep
    % PreSleep
%     Q_Sleep_Pre = MakeQfromS(Sleep.Spikes{mm}.SleepPre,Binsize);
%     Epoch.PostRipples_SleepPre = mergeCloseIntervals(intervalSet(Range(Sleep.Ripples.SleepPre{mm})-window_around_ctrl(1)*1e4,Range(Sleep.Ripples.SleepPre{mm})+window_around_ctrl(2)*1e4),0.1*1e4);
%     EpochNames = fieldnames(Epoch);
%     k = length(EpochNames);
%     QTemplate_Sleep = Restrict(Q_Sleep_Pre,Epoch.PostRipples_SleepPre);
%     QTemplate_Sleep = tsd(Range(QTemplate_Sleep),nanzscore(Data(QTemplate_Sleep)));
%     dat = Data(QTemplate_Sleep);
%     BadGuys = find(sum(isnan(Data(QTemplate_Sleep))));
%     for spk = 1:length(BadGuys)
%         dat(:,BadGuys(spk)) = zeros(size(dat,1),1);
%     end
%     DatPoints.(EpochNames{k}) = size(dat,1);
%     
%     [templates.(EpochNames{k}),correlations.(EpochNames{k}),eigenvalues.(EpochNames{k}),eigenvectors.(EpochNames{k}),lambdaMax.(EpochNames{k})] = ActivityTemplates_SB(dat,0);
    
    % Post Sleep
%     Q_Sleep_Post = MakeQfromS(Sleep.Spikes{mm}.SleepPost,Binsize);
%     
%     Epoch.PostRipples_SleepPost = mergeCloseIntervals(intervalSet(Range(Sleep.Ripples.SleepPost{mm})-window_around_ctrl(1)*1e4,Range(Sleep.Ripples.SleepPost{mm})+window_around_ctrl(2)*1e4),0.1*1e4);
%     EpochNames = fieldnames(Epoch);
%     k = length(EpochNames);
%     QTemplate_Sleep = Restrict(Q_Sleep_Post,Epoch.PostRipples_SleepPost);
%     QTemplate_Sleep = tsd(Range(QTemplate_Sleep),nanzscore(Data(QTemplate_Sleep)));
%     dat = Data(QTemplate_Sleep);
%     BadGuys = find(sum(isnan(Data(QTemplate_Sleep))));
%     for spk = 1:length(BadGuys)
%         dat(:,BadGuys(spk)) = zeros(size(dat,1),1);
%     end
%     DatPoints.(EpochNames{k}) = size(dat,1);
%     
%     [templates.(EpochNames{k}),correlations.(EpochNames{k}),eigenvalues.(EpochNames{k}),eigenvectors.(EpochNames{k}),lambdaMax.(EpochNames{k})] = ActivityTemplates_SB(dat,0);
    
    
    
    %% Get the reactivation strength
    % z-score the full data
    QMatch = tsd(Range(Q),(Data(Q))); % Q already zscored
%     QMatch_Pre = tsd(Range(Q_Sleep_Pre),nanzscore(Data(Q_Sleep_Pre)));
%     QMatch_Post = tsd(Range(Q_Sleep_Post),nanzscore(Data(Q_Sleep_Post)));
    
    % Shuffle precise spike timing
    Qdat =  Data(QMatch);
    for spk = 1:size(Qdat,2)
        r(spk) = round(5-rand(1)*10);
        Qdat(:,spk) = circshift(Qdat(:,spk),r(spk));
    end
    QShuff = tsd(Range(QMatch),Qdat);
    
    
    for k = 1:length(EpochNames)
        
        strength = ReactivationStrength_SB((Data(QMatch)),templates.(EpochNames{k}));
        strengthShuff = ReactivationStrength_SB((Data(QShuff)),templates.(EpochNames{k}));
%         strength_PreSleep = ReactivationStrength_SB((Data(QMatch_Pre)),templates.(EpochNames{k}));
%         strength_PostSleep = ReactivationStrength_SB((Data(QMatch_Post)),templates.(EpochNames{k}));
        MnVal{mm}{k} = NaN;
        MdVal{mm}{k} = NaN;
        PeakNum{mm}{k} = NaN;
        
        MnValShuff{mm}{k} = NaN;
        MdValShuff{mm}{k}= NaN;
        PeakNumShuff{mm}{k}  = NaN;
        
        SaveTriggeredStim{mm}{k} = NaN;
        SaveTriggeredStimZ{mm}{k} = NaN;
        SaveTriggeredStimShuff{mm}{k} = NaN;
        SaveTriggeredStimZShuff{mm}{k} = NaN;
        SaveTriggeredRip{mm}{k} = NaN;
        SaveTriggeredRipZ{mm}{k} = NaN;
        SaveTriggeredRipShuff{mm}{k} = NaN;
        SaveTriggeredRipZShuff{mm}{k} = NaN;
        SaveTriggeredRip_Pre{mm}{k} = NaN;
        SaveTriggeredRipZ_Pre{mm}{k} = NaN;
        SaveTriggeredRip_Post{mm}{k} = NaN;
        SaveTriggeredRipZ_Post{mm}{k} = NaN;
        
        
        % mouse 1 component 2 and 3 are good examples (2 is strongly react,
        % 3 shows nothing) -- used in phD
        for comp = 1:size(templates.(EpochNames{k}),3)
            Strtsd = tsd(Range(QMatch),strength(:,comp));
            StrtsdShuff = tsd(Range(QShuff),strengthShuff(:,comp));
            Lim = prctile(Data(StrtsdShuff),99.9);
            
            % Trigger on Stim
%             [M,T] = PlotRipRaw(Strtsd,Start(StimEpoch,'s'),5000,0,0);
%             SaveTriggeredStim{mm}{k}(comp,1:length(M(:,2))) = M(:,2);
%             SaveTriggeredStimZ{mm}{k}(comp,1:length(M(:,2))) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
%             
%             [M,T] = PlotRipRaw(StrtsdShuff,Start(StimEpoch,'s'),5000,0,0);
%             SaveTriggeredStimShuff{mm}{k}(comp,1:length(M(:,2))) = M(:,2);
%             SaveTriggeredStimZShuff{mm}{k}(comp,1:length(M(:,2))) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
%             tpsstim = M(:,1);
%             
%             
%             % Trigger on Random times
%             R=Range(Vtsd);
%             RandTimes = (R(ceil(rand(1,length(Start(StimEpoch))*10).*length(R))))/1e4;
%             
%             [M,T] = PlotRipRaw(Strtsd,RandTimes,5000,0,0);
%             SaveTriggeredRand{mm}{k}(comp,1:length(M(:,2))) = M(:,2);
%             SaveTriggeredRand{mm}{k}(comp,1:length(M(:,2))) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
%             
%             
%             % Trigger on Ripples
%             if not(isempty(Range(Ripples)))
%                 [M,T] = PlotRipRaw(Strtsd,Range(Ripples,'s'),2000,0,0);
%                 SaveTriggeredRip{mm}{k}(comp,1:length(M(:,2))) = M(:,2);
%                 SaveTriggeredRipZ{mm}{k}(comp,1:length(M(:,2))) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
%                 
%                 [M,T] = PlotRipRaw(StrtsdShuff,Range(Ripples,'s'),2000,0,0);
%                 SaveTriggeredRipShuff{mm}{k}(comp,1:length(M(:,2))) = M(:,2);
%                 SaveTriggeredRipZShuff{mm}{k}(comp,1:length(M(:,2))) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
%                 tpsrip = M(:,1);
%             end
%             
%             
%             Strtsd_PreSleep = tsd(Range(QMatch_Pre),strength_PreSleep(:,comp));
%             Strtsd_PostSleep = tsd(Range(QMatch_Post),strength_PostSleep(:,comp));
%             
%             % Trigger on Ripples_sleep pre
%             if not(isempty(Range(Sleep.Ripples.SleepPre{mm})))
%                 [M,T] = PlotRipRaw(Strtsd_PreSleep,Range(Sleep.Ripples.SleepPre{mm},'s'),2000,0,0);
%                 SaveTriggeredRip_Pre{mm}{k}(comp,1:length(M(:,2))) = M(:,2);
%                 SaveTriggeredRipZ_Pre{mm}{k}(comp,1:length(M(:,2))) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
%                 
%             end
%             
%             % Trigger on Ripples_sleep post
%             if not(isempty(Range(Sleep.Ripples.SleepPost{mm})))
%                 [M,T] = PlotRipRaw(Strtsd_PostSleep,Range(Sleep.Ripples.SleepPost{mm},'s'),2000,0,0);
%                 SaveTriggeredRip_Post{mm}{k}(comp,1:length(M(:,2))) = M(:,2);
%                 SaveTriggeredRipZ_Post{mm}{k}(comp,1:length(M(:,2))) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
%             end
            
            
            % Average by epoch
            for kk = 1:length(EpochNames)
                MnVal{mm}{k}(comp,kk) = nanmean(Data(Restrict(Strtsd,Epoch.(EpochNames{kk}))));
                MdVal{mm}{k}(comp,kk) = nanmedian(Data(Restrict(Strtsd,Epoch.(EpochNames{kk}))));
                
                MnValShuff{mm}{k}(comp,kk) = nanmean(Data(Restrict(StrtsdShuff,Epoch.(EpochNames{kk}))));
                MdValShuff{mm}{k}(comp,kk) = nanmedian(Data(Restrict(StrtsdShuff,Epoch.(EpochNames{kk}))));
                if sum(Stop(Epoch.(EpochNames{kk}),'s') - Start(Epoch.(EpochNames{kk}),'s'))>0
                    PeakNumShuff{mm}{k}(comp,kk) = nansum(Data(Restrict(StrtsdShuff,Epoch.(EpochNames{kk})))>Lim)./sum(Stop(Epoch.(EpochNames{kk}),'s') - Start(Epoch.(EpochNames{kk}),'s'));
                    PeakNum{mm}{k}(comp,kk) = nansum(Data(Restrict(Strtsd,Epoch.(EpochNames{kk})))>Lim)./sum(Stop(Epoch.(EpochNames{kk}),'s') - Start(Epoch.(EpochNames{kk}),'s'));
                else
                    PeakNumShuff{mm}{k}(comp,kk) = NaN;
                    PeakNum{mm}{k}(comp,kk) = NaN;
                end
            end
            
            
            %             Link to LinPos
%             LinPos = Restrict(LinPos,ts(Range(Strtsd)));
%             for ii = 1:10
%                 LittleEp = and(and(thresholdIntervals(LinPos,(ii-1)/10,'Direction','Above'),...
%                     thresholdIntervals(LinPos,ii/10,'Direction','Below')),MovEpoch);
%                 MnReactPos_Mov{mm}{k}(comp,ii) = nanmean(Data(Restrict(Strtsd,LittleEp))) ;
%                 
%                 LittleEp = and(and(thresholdIntervals(LinPos,(ii-1)/10,'Direction','Above'),...
%                     thresholdIntervals(LinPos,ii/10,'Direction','Below')),FreezeEpoch);
%                 MnReactPos_Fz{mm}{k}(comp,ii) = nanmean(Data(Restrict(Strtsd,LittleEp))) ;
%             end
            
            if or(or(k==9 , k==10) , or(k==11 , k==12))
                LittleEp = and(thresholdIntervals(LinPos,.2,'Direction','Below'),MovEpoch)-Epoch.(EpochNames{k});
                MnReactPos_Mov_Shock{mm}{k}(comp) = nanmean(Data(Restrict(Strtsd,LittleEp))) ;
                
                LittleEp = and(thresholdIntervals(LinPos,.6,'Direction','Above'),MovEpoch)-Epoch.(EpochNames{k});
                MnReactPos_Mov_Safe{mm}{k}(comp) = nanmean(Data(Restrict(Strtsd,LittleEp))) ;
            end
            
            %% Maze 2D
%             if or(or(k==9 , k==10) , or(k==11 , k==12))
%                 Xtsd = Restrict(Xtsd,ts(Range(Strtsd)));
%                 Ytsd = Restrict(Ytsd,ts(Range(Strtsd)));
%                 for ii = 1:10
%                     for iii = 1:10
%                         LittleEp1 = and(thresholdIntervals(Xtsd,(ii-1)/10,'Direction','Above'),...
%                             thresholdIntervals(Xtsd,ii/10,'Direction','Below'));
%                         LittleEp2 = and(thresholdIntervals(Ytsd,(iii-1)/10,'Direction','Above'),...
%                             thresholdIntervals(Ytsd,iii/10,'Direction','Below'));
%                         LittleEp = and(and(LittleEp1 , LittleEp2) , MovEpoch)-Epoch.(EpochNames{k});
%                         
%                         MnReact2D_Mov{mm}{k}(comp,ii,iii) = nanmean(Data(Restrict(Strtsd,LittleEp))) ;
%                     end
%                 end
%             end
            
        end
    end
    
    
    %% firing rate
%     
%     Q_all = tsd(Range(Q) , nanmean(Data(Q)')');
%     Q_all_Pre = tsd(Range(QMatch_Pre) , nanmean(Data(QMatch_Pre)')');
%     
%     [M,T] = PlotRipRaw(Q_all,Start(StimEpoch,'s'),5000,0,0);
%     Spike_density_stim(mm,:) = M(:,2);
%     
%     [M,T] = PlotRipRaw(Q_all,RandTimes,5000,0,0);
%     Spike_density_rand(mm,:) = M(:,2);
%     
%     [M,T] = PlotRipRaw(Q_all,Range(Ripples,'s'),5000,0,0);
%     try
%         Spike_density_rip(mm,:) = M(:,2);
%     catch
%         Spike_density_rip(mm,:) = NaN;
%     end
%     
%     [M,T] = PlotRipRaw(Q_all_Pre,Range(Sleep.Ripples.SleepPre{mm},'s'),5000,0,0);
%     try
%         Spike_density_rip_SleepPre(mm,:) = M(:,2);
%     catch
%         Spike_density_rip_SleepPre(mm,:) = NaN;
%     end
%     
%     Spike_density_rip_epoch(mm) = nanmean(Data(Restrict(Q_all , Epoch.PostRipples)));
%     Spike_density_ctrl_epoch(mm) = nanmean(Data(Restrict(Q_all , Epoch.PreRipples)));
%     Spike_density_ctrl_epoch_SleepPre(mm) = nanmean(Data(Restrict(Q_all , Epoch.PreRipples)));
%     Spike_density_ctrl_epoch_SleepPre(mm) = nanmean(Data(Restrict(Q_all_Pre , Epoch.PostRipples_SleepPre)));
    
end


%% Triggered events
for k = 1:size(EpochNames,1)
    AllTriggeredStim{k} = [];
    AllTriggeredRand{k} = [];
    AllTriggeredRipples{k} = [];
    AllTriggeredRipples_Pre{k} = [];
    AllTriggeredRipples_Post{k} = [];
end

for mm=1:length(MiceNumber)
    for k = 1:size(EpochNames,1)
        if sum(size(SaveTriggeredStim{mm}{k}))>2
            AllTriggeredStim{k} = [AllTriggeredStim{k};SaveTriggeredStim{mm}{k}];
        end
        if sum(size(SaveTriggeredRand{mm}{k}))>2
            AllTriggeredRand{k} = [AllTriggeredRand{k};SaveTriggeredRand{mm}{k}];
        end
        if sum(size(SaveTriggeredRip{mm}{k}))>2
            AllTriggeredRipples{k} = [AllTriggeredRipples{k};SaveTriggeredRip{mm}{k}];
        end
        if sum(size(SaveTriggeredRip_Pre{mm}{k}))>2
            AllTriggeredRipples_Pre{k} = [AllTriggeredRipples_Pre{k};SaveTriggeredRip_Pre{mm}{k}];
        end
        if sum(size(SaveTriggeredRip_Post{mm}{k}))>2
            AllTriggeredRipples_Post{k} = [AllTriggeredRipples_Post{k};SaveTriggeredRip_Post{mm}{k}];
        end
        
    end
end

AllTrigStim = [];
AllTrigRand = [];
AllTrigRip = [];

for k = 1:size(EpochNames,1)
    AllTrigStim = [AllTrigStim;nanmean((AllTriggeredStim{k}))];
    AllTrigRand = [AllTrigRand;nanmean((AllTriggeredRand{k}))];
    AllTrigRip = [AllTrigRip;nanmean((AllTriggeredRipples{k}))];
end


% shock/safe
AllComp_Shock_rip = [];
AllComp_Safe_rip = [];
AllComp_Shock_ctrl = [];
AllComp_Safe_ctrl = [];
for mm = 1:length(MnReactPos_Mov_Shock)
    AllComp_Shock_rip = [AllComp_Shock_rip;MnReactPos_Mov_Shock{mm}{9}'];
    AllComp_Safe_rip = [AllComp_Safe_rip;MnReactPos_Mov_Safe{mm}{9}'];
    AllComp_Shock_ctrl = [AllComp_Shock_ctrl;MnReactPos_Mov_Shock{mm}{10}'];
    AllComp_Safe_ctrl = [AllComp_Safe_ctrl;MnReactPos_Mov_Safe{mm}{10}'];
end


figure
MakeSpreadAndBoxPlot3_SB({AllComp_Shock_rip./nanmedian(AllComp_Shock_ctrl) AllComp_Safe_rip./nanmedian(AllComp_Safe_ctrl)},{[1 .5 .5],[.5 .5 1]},[1 2],{'Shock','Safe'},'showpoints',0,'paired',1)
ylabel('Activation strength'), set(gca,'YScale','log')
makepretty_BM2

