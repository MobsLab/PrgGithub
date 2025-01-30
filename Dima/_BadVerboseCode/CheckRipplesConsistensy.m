%% Parameters
Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir, 'nMice', [797 798 828 861 882 905 906 911 912]);

durations = [-60 60]/1000;

%% Get Data
for i = 1:length(Dir.path)
        Rip{i} = load([Dir.path{i}{1} 'Ripples.mat'], 'ripples');
        Session{i} = load([Dir.path{i}{1} 'behavResources.mat'], 'SessionEpoch');
end

%% Do restrictions

for i = 1:length(Dir.path)
    RipplesTS = ts(Rip{i}.ripples(:,2)*1e4);
    
    RipplesPreSleep{i} = Restrict(RipplesTS,Session{i}.SessionEpoch.PreSleep);
    
    Cond = or(Session{i}.SessionEpoch.Cond1,Session{i}.SessionEpoch.Cond2);
    Cond = or(Cond,Session{i}.SessionEpoch.Cond3);
    Cond = or(Cond,Session{i}.SessionEpoch.Cond4);
    RipplesCond{i} = Restrict(RipplesTS,Cond);
    
    RipplesPostSleep{i} = Restrict(RipplesTS,Session{i}.SessionEpoch.PostSleep);
    
    TestPost = or(Session{i}.SessionEpoch.TestPost1,Session{i}.SessionEpoch.TestPost2);
    TestPost = or(TestPost,Session{i}.SessionEpoch.TestPost3);
    TestPost = or(TestPost,Session{i}.SessionEpoch.TestPost4);
    RipplesPostTests{i} = Restrict(RipplesTS,TestPost);    
end


%% Plot

for j = 1:length(Dir.path)
    load([Dir.path{j}{1} '/ChannelsToAnalyse/dHPC_rip.mat']);
    load([Dir.path{j}{1} '/LFPData/LFP' num2str(channel) '.mat']);
    
    f = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
    
    
    %%%%% ---------------- PreSleep ---------------------------------
    %params
    samplingRate = round(1/median(diff(Range(LFP,'s'))));
    nBins = floor(samplingRate*diff(durations)/2)*2+1;
    %events
    events_tmp = Data(RipplesPreSleep{j})/1e4;
    %signals
    rg = Range(LFP)/1e4;
    LFP_signal = [rg-rg(1) Data(LFP)];
    % Sync
    [r,i] = Sync(LFP_signal,events_tmp,'durations',durations);
    T = SyncMap(r,i,'durations',durations,'nbins',nBins,'smooth',0);
    % result
    %nbin
    if size(T,2)>nBins
        nBins=nBins+1;
    elseif size(T,2)<nBins
        nBins=nBins-1;
    end
    %result
    try
        M=[((1:nBins)'-ceil(nBins/2))/nBins*diff(durations)' mean(T)' std(T)' stdError(T)'];
    catch
        M=[];
        disp('error')
    end
    subplot(241)
    hold on
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),T,'k');
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(T),'r','linewidth',2);
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(T)+std(T),'r--');
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(T)-std(T),'r--');
    title(['Ripples (raw data) n=' num2str(size(events_tmp,1)) ' - PreSleep'])
    xlim(durations)
    %
    subplot(245)
    hold on
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations), zscore(T')', 'k');
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations), mean(zscore(T')'), 'r', 'linewidth',2);
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations), mean(zscore(T')')+std(zscore(T')'), 'r--');
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations), mean(zscore(T')')-std(zscore(T')'), 'r--');
    title(['Ripples (zscored) n=' num2str(size(events_tmp,1)) ' - PreSleep'])
    xlim(durations)
    
    clear samplingRate nBins events_tmp rg LFP_signal r T i M
    
    
    %%%%% ---------------- Cond ---------------------------------
    %params
    samplingRate = round(1/median(diff(Range(LFP,'s'))));
    nBins = floor(samplingRate*diff(durations)/2)*2+1;
    %events
    events_tmp = Data(RipplesCond{j})/1e4;
    %signals
    rg = Range(LFP)/1e4;
    LFP_signal = [rg-rg(1) Data(LFP)];
    % Sync
    [r,i] = Sync(LFP_signal,events_tmp,'durations',durations);
    T = SyncMap(r,i,'durations',durations,'nbins',nBins,'smooth',0);
    % result
    %nbin
    if size(T,2)>nBins
        nBins=nBins+1;
    elseif size(T,2)<nBins
        nBins=nBins-1;
    end
    %result
    try
        M=[((1:nBins)'-ceil(nBins/2))/nBins*diff(durations)' mean(T)' std(T)' stdError(T)'];
    catch
        M=[];
        disp('error')
    end
    subplot(242)
    hold on
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),T,'k');
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(T),'r','linewidth',2);
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(T)+std(T),'r--');
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(T)-std(T),'r--');
    title(['Ripples (raw data) n=' num2str(size(events_tmp,1)) ' - Cond'])
    xlim(durations)
    %
    subplot(246)
    hold on
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations), zscore(T')', 'k');
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations), mean(zscore(T')'), 'r', 'linewidth',2);
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations), mean(zscore(T')')+std(zscore(T')'), 'r--');
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations), mean(zscore(T')')-std(zscore(T')'), 'r--');
    title(['Ripples (zscored) n=' num2str(size(events_tmp,1)) ' - Cond'])
    xlim(durations)
    
    clear samplingRate nBins events_tmp rg LFP_signal r T i M
    
    
    %%%%% ---------------- PostSleep ---------------------------------
    %params
    samplingRate = round(1/median(diff(Range(LFP,'s'))));
    nBins = floor(samplingRate*diff(durations)/2)*2+1;
    %events
    events_tmp = Data(RipplesPostSleep{j})/1e4;
    %signals
    rg = Range(LFP)/1e4;
    LFP_signal = [rg-rg(1) Data(LFP)];
    % Sync
    [r,i] = Sync(LFP_signal,events_tmp,'durations',durations);
    T = SyncMap(r,i,'durations',durations,'nbins',nBins,'smooth',0);
    % result
    %nbin
    if size(T,2)>nBins
        nBins=nBins+1;
    elseif size(T,2)<nBins
        nBins=nBins-1;
    end
    %result
    try
        M=[((1:nBins)'-ceil(nBins/2))/nBins*diff(durations)' mean(T)' std(T)' stdError(T)'];
    catch
        M=[];
        disp('error')
    end
    subplot(243)
    hold on
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),T,'k');
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(T),'r','linewidth',2);
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(T)+std(T),'r--');
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(T)-std(T),'r--');
    title(['Ripples (raw data) n=' num2str(size(events_tmp,1)) ' - PostSleep'])
    xlim(durations)
    %
    subplot(247)
    hold on
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations), zscore(T')', 'k');
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations), mean(zscore(T')'), 'r', 'linewidth',2);
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations), mean(zscore(T')')+std(zscore(T')'), 'r--');
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations), mean(zscore(T')')-std(zscore(T')'), 'r--');
    title(['Ripples (zscored) n=' num2str(size(events_tmp,1)) ' - PostSleep'])
    xlim(durations)
    
    clear samplingRate nBins events_tmp rg LFP_signal r T i M
    
    %%%%% ---------------- PostTests ---------------------------------
    %params
    samplingRate = round(1/median(diff(Range(LFP,'s'))));
    nBins = floor(samplingRate*diff(durations)/2)*2+1;
    %events
    events_tmp = Data(RipplesPostTests{j})/1e4;
    %signals
    rg = Range(LFP)/1e4;
    LFP_signal = [rg-rg(1) Data(LFP)];
    % Sync
    [r,i] = Sync(LFP_signal,events_tmp,'durations',durations);
    T = SyncMap(r,i,'durations',durations,'nbins',nBins,'smooth',0);
    % result
    %nbin
    if size(T,2)>nBins
        nBins=nBins+1;
    elseif size(T,2)<nBins
        nBins=nBins-1;
    end
    %result
    try
        M=[((1:nBins)'-ceil(nBins/2))/nBins*diff(durations)' mean(T)' std(T)' stdError(T)'];
    catch
        M=[];
        disp('error')
    end
    subplot(244)
    hold on
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),T,'k');
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(T),'r','linewidth',2);
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(T)+std(T),'r--');
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(T)-std(T),'r--');
    title(['Ripples (raw data) n=' num2str(size(events_tmp,1)) ' - PostTests'])
    xlim(durations)
    %
    subplot(248)
    hold on
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations), zscore(T')', 'k');
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations), mean(zscore(T')'), 'r', 'linewidth',2);
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations), mean(zscore(T')')+std(zscore(T')'), 'r--');
    plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations), mean(zscore(T')')-std(zscore(T')'), 'r--');
    title([' Ripples (zscored) n=' num2str(size(events_tmp,1)) ' - PostTests'])
    xlim(durations)
    
    clear samplingRate nBins events_tmp rg LFP_signal r T i M LFP channel
    
    mtit(f, Dir.name{j},'zoff', 0.05, 'yoff', 0.001, 'fontsize',16);
    
end