%% Parameters
% Directory to save and name of the figure to save
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/';
fig_post = 'FRduringRipples';
% Before Vtsd correction == 1
old = 0;
sav = 0;
% Numbers of mice to run analysis on
Mice_to_analyze = [797 798 828 861 882 905 906 911 912 977 994];

% Get directories
Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);

%% Get data

for i = 1:length(Dir.path)
    beh{i} = load([Dir.path{i}{1} '/behavResources.mat'], 'SessionEpoch');
    rip{i} = load([Dir.path{i}{1} '/Ripples.mat'], 'ripples');
    spikes{i} = load([Dir.path{i}{1} '/SpikeData.mat'], 'S', 'BasicNeuronInfo');
end

%% Calculate

for i=1:length(Dir.path)
    % Create interval for the ripples
    RipIS{i}=intervalSet(rip{i}.ripples(:,1)*1E4, rip{i}.ripples(:,3)*1E4);
    RipSt{i} = Start(RipIS{i});
    % Get spikes
    SS{i} = spikes{i}.S(spikes{i}.BasicNeuronInfo.idx_SUA);
    
    %%% PreSleep
    RipISPre{i} = and(RipIS{i},beh{i}.SessionEpoch.PreSleep);
    
    clear temp
    for j=1:length(SS{i})
        temp = Restrict(SS{i}{j}, RipISPre{i});
        PREFR_rip{i}(j) = length(temp) / (sum(End(RipISPre{i} ) - Start(RipISPre{i}))/1e4);
    end

    NoRip = beh{i}.SessionEpoch.PreSleep-RipISPre{i};
    
    clear temp
    
    for j=1:length(SS{i})
        temp{j} = Restrict(SS{i}{j}, NoRip);
    end
    
    PREFR_norip{i} = GetFiringRate(temp);
    
    
    %%% PostSleep
    RipISPost{i} = and(RipIS{i},beh{i}.SessionEpoch.PostSleep);
    
    clear temp
    for j=1:length(SS{i})
        temp = Restrict(SS{i}{j}, RipISPost{i});
        POSTFR_rip{i}(j) = length(temp) / (sum(End(RipISPost{i} ) - Start(RipISPost{i}))/1e4);
    end
    
    NoRip = beh{i}.SessionEpoch.PostSleep-RipISPost{i};
    
    clear temp
    for j=1:length(SS{i})
        temp{j} = Restrict(SS{i}{j}, NoRip);
    end
    
    POSTFR_norip{i} = GetFiringRate(temp); 
    
    
end
%% Average
for i = 1:length(Dir.path)
    PREFR_ripMean(i) = mean(PREFR_rip{i});
    PREFR_noripMean(i) = mean(PREFR_norip{i});
    
    POSTFR_ripMean(i) = mean(POSTFR_rip{i});
    POSTFR_noripMean(i) = mean(POSTFR_norip{i});
end
%% Figure


figure('units', 'normalized', 'outerposition', [0 1 0.5 0.8])
subplot(121)
[p,h,her] = PlotErrorBarN_DB([PREFR_noripMean; PREFR_ripMean]', 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints', 1);
set(gca,'Xtick',[1:2],'XtickLabel',{'OutOfRipples', 'DuringRipples'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(h, 'LineWidth', 3);
set(her, 'LineWidth', 3);
ylabel('Firing rate (Hz)');
title('PreSleep', 'FontSize', 14);
subplot(122)
[p,h,her] = PlotErrorBarN_DB([POSTFR_noripMean; POSTFR_ripMean]', 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints', 1);
set(gca,'Xtick',[1:2],'XtickLabel',{'OutOfRipples', 'DuringRipples'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(h, 'LineWidth', 3);
set(her, 'LineWidth', 3);
ylabel('Time (s)');
title('PostSleep', 'FontSize', 14);

%% Trigger FR on ripples

for i=1:length(Dir.path)
    % Create big interval for the ripples
    RipISBIG{i}=intervalSet((rip{i}.ripples(:,1)-0.05)*1E4, (rip{i}.ripples(:,3)+0.05)*1E4);
    
    %%% PreSleep
    RipISBIGPre{i} = and(RipISBIG{i},beh{i}.SessionEpoch.PreSleep);
     
    QQ{i} = MakeQfromS(SS{i},100);
    
    dat = mean(full(Data(QQ{i})),2);
    tt = full(Range(QQ{i}));
    [r,g] = Sync([tt/1e4 dat],Start(RipIS{i})/1e4,'durations',[-0.5 0.5]);
    T{i}= SyncMap(r,g,'durations',[-0.5 0.5],'nbins',100,'smooth',0);
        
end

for i=1:length(Dir.path)
    TT(i,1:100) = mean(T{i});
end


%% Plot
fh = figure('units', 'normalized', 'outerposition', [0 0 0.65 0.65]);
hold on
plot(((1:100)'-ceil(100/2))/100*diff([-0.5 0.5]),mean(TT),'k','linewidth',3);
plot(((1:100)'-ceil(100/2))/100*diff([-0.5 0.5]),mean(TT)+std(TT),'r--');
plot(((1:100)'-ceil(100/2))/100*diff([-0.5 0.5]),mean(TT)-std(TT),'r--');
% ylim([0 0.04])
xlabel('Time (s)')
ylabel('Mean FR of all SUA (Hz)')
title('Firing rate triggered on the start of the ripple')
line([0 0], ylim,'color', 'k','linewidth',2)

% saveas