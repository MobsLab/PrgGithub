% GenerateIDLocalDown
% 18.08.2017 KJ
%
% Compute and plot description figures of a sleep record
% Informations about neuronal silences  
%
%


%% params

Struct = 'PFCx';
binsize = 10; %10ms
thresh0 = 0.7;
minDownDur = 70;
maxDownDur = 500;
mergeGap = 10; % merge
predown_size = 50;
met_window = 500;
nb_tetrode = 3;

%Correlo
smoothing = 1;
binsize_cc = 100; %10ms
nbins_cc = 100;
%Density
windowsize = 60E4; %60s
y_rec1 = [0 0 1.5 1.5];
y_rec2 = [0 0 1.5 1.5];
%ISI
step=100;
edges=0:step:2000;

%% Load

load StateEpochSB SWSEpoch Wake

disp('Loading SpikeData.mat...')
load SpikeData S tetrodeChannels TT

disp('Getting InfoLFP...')
load LFPData/InfoLFP InfoLFP
chans=InfoLFP.channel(strcmp(InfoLFP.structure,Struct));
disp(['    channels for ',Struct,': ',num2str(chans)])

load IntervalSession
sessions{1}=Session1;sessions{2}=Session2;sessions{3}=Session3;sessions{4}=Session4;sessions{5}=Session5;


%% Epochs
start_time = TimeDebRec(1,1)*3600 + TimeDebRec(1,2)*60 + TimeDebRec(1,3); %start time in sec
start_time = start_time*1E4;

night_duration = End(sessions{5});
intervals_start = 0:windowsize:night_duration;

x_intervals = (intervals_start + windowsize/2 + start_time)/(3600E4);
x_rec1 = [Start(sessions{2}) End(sessions{2}) End(sessions{2}) Start(sessions{2})];
x_rec1 = (x_rec1 + start_time)/(3600E4);
x_rec2 = [Start(sessions{4}) End(sessions{4}) End(sessions{4}) Start(sessions{4})];
x_rec2 = (x_rec2 + start_time)/(3600E4);


%% Global Down states 
try
    eval('load SpikesToAnalyse/PFCx_down')
catch
    try
        eval('load SpikesToAnalyse/PFCx_Neurons')
    catch
        try
            eval('load SpikesToAnalyse/PFCx_MUA')
        catch
            number=[];
        end
    end
end
NumNeurons=number;
clear number
T=PoolNeurons(S,NumNeurons);
clear ST
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q=MakeQfromS(ST,binsize*10);
Qsws = Restrict(Q, SWSEpoch);
fr_global_sws = round(mean(full(Data(Qsws)), 1)*100,2); % firing rate for a bin of 10ms
GlobalDown = FindDown2_KJ(Qsws, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size);
center_globaldown = (Start(GlobalDown) + End(GlobalDown)) / 2;


%% Down states for each tetrode
if exist('tetrodeChannels','var') && exist('TT','var')
    % find tetrodes from PFCx
    num_tetrode = [];
    lfp_tetrode = [];
    
    for cc=1:length(chans)
        for tt=1:length(tetrodeChannels)
            if ismember(chans(cc), tetrodeChannels{tt})
                num_tetrode = [num_tetrode, tt];
            end
        end
    end
    num_tetrode = unique(num_tetrode);
    num_tetrode = num_tetrode(1:nb_tetrode);
    
    %loop over tetrodes
    for tt=1:length(num_tetrode)
        
        clear Q Qsws DownSws T 
        %select neurons from the tetrode
        numNeurons = [];
        for i=1:length(S);
            if TT{i}(1)==num_tetrode(tt)
                numNeurons = [numNeurons i];
            end
        end
        
        %create a MUA tsd, with the number of spikes per bin
        nb_neurons(tt) = length(numNeurons);
        T=PoolNeurons(S,numNeurons);
        clear ST
        ST{1}=T;
        try
            ST=tsdArray(ST);
        end
        Q=MakeQfromS(ST,binsize*10);
        %Restrict to period
        Qsws = Restrict(Q, SWSEpoch);
        %Firing
        firingRates_sws{tt} = round(mean(full(Data(Qsws)), 1)*100,2); % firing rate for a bin of 10ms
        
        %Down
        DownSws = FindDown2_KJ(Qsws, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size);
        TetDown{tt} = DownSws;
        
        %select a channel
        lfp_tetrode = [lfp_tetrode tetrodeChannels{num_tetrode(tt)}(1)];
        
    end
    
else
    disp('No neuron found')
    numNeurons = [];
    num_tetrode = [];
    lfp_tetrode = [];
end


%% Find Semi Local Down
% a semi local down is a down that is not global
for tt=1:length(TetDown)
    
    intv_tet = [Start(TetDown{tt}) End(TetDown{tt})];
    
    [~, intervals_global,~] = InIntervals(center_globaldown, intv_tet);
    intervals_global(intervals_global==0) = [];
    intervals_global = unique(intervals_global);
    intervals_local = ~ismember(1:length(intv_tet), intervals_global);

    SemiLocalDown{tt} = intervalSet(intv_tet(intervals_local,1), intv_tet(intervals_local,2));
    
end


%% Find Local Down
% down appearing on just one tetrode
for tt=1:length(SemiLocalDown)
    
    %center of semi local down for this tetrode
    center_tet = (Start(SemiLocalDown{tt}) + End(SemiLocalDown{tt}))/2;
    
    % intervals gathering all the semi local down from other tetrodes
    other_semilocal = [];
    for i=1:length(SemiLocalDown)
        if i~=tt
            if isempty(other_semilocal)
                other_semilocal = SemiLocalDown{i};
            else
                other_semilocal = or(SemiLocalDown{i},other_semilocal);
            end
        end
    end
    intv_other = [Start(other_semilocal) End(other_semilocal)];
    
    [status, ~,~] = InIntervals(center_tet, intv_other);
    LocalDown{tt} = subset(SemiLocalDown{tt},find(~status));
    
end


%% intersection between Locals
for tt1=1:length(SemiLocalDown)
    for tt2=tt1:length(SemiLocalDown)
        nb_intersect(tt1,tt2) = length(Start(intersect(SemiLocalDown{tt1},SemiLocalDown{tt2})));
    end
end


%% Correlogram
for tt1 = 1:length(SemiLocalDown)
    for tt2 = 1:length(SemiLocalDown)
        Cc_SemiLocal{tt1,tt2} = CrossCorr(ts(Start(SemiLocalDown{tt1})), ts(Start(SemiLocalDown{tt2})), binsize_cc, nbins_cc);
        Cc_Local{tt1,tt2} = CrossCorr(ts(Start(LocalDown{tt1})), ts(Start(LocalDown{tt2})), binsize_cc, nbins_cc);
        if tt1==tt2
            %semi local
            y = Data(Cc_SemiLocal{tt1,tt2});
            x = Range(Cc_SemiLocal{tt1,tt2});
            y(x==0) = 0;
            Cc_SemiLocal{tt1,tt2} = tsd(x,y);
            %local
            y = Data(Cc_Local{tt1,tt2});
            x = Range(Cc_Local{tt1,tt2});
            y(x==0) = 0;
            Cc_Local{tt1,tt2} = tsd(x,y);
            
            
        end
    end
end


%% Density
for tt = 1:length(LocalDown)
    local_down_density{tt} = zeros(length(intervals_start),1);
    semilocal_down_density{tt} = zeros(length(intervals_start),1);
    
    for i=1:length(intervals_start)
        intv = intervalSet(intervals_start(i),intervals_start(i) + windowsize);
        local_down_density{tt}(i) = length(Restrict(ts(Start(LocalDown{tt})),intv))/60; %per sec
        semilocal_down_density{tt}(i) = length(Restrict(ts(Start(SemiLocalDown{tt})),intv))/60; %per sec
    end
    
    local_down_density{tt} = Smooth(local_down_density{tt}, smoothing);
    semilocal_down_density{tt} = Smooth(semilocal_down_density{tt}, smoothing);
end



%% ISI
for tt = 1:length(LocalDown)
    center_locals = (Start(LocalDown{tt}) + End(LocalDown{tt}))/2;
    h_locals = histogram(diff(center_locals/10), edges);
    isi.local.x{tt} = h_locals.BinEdges(1:end-1);
    isi.local.y{tt} = h_locals.Values; close
end

for tt = 1:length(SemiLocalDown)
    center_locals = (Start(SemiLocalDown{tt}) + End(SemiLocalDown{tt}))/2;
    h_locals = histogram(diff(center_locals/10), edges);
    isi.semilocal.x{tt} = h_locals.BinEdges(1:end-1);
    isi.semilocal.y{tt} = h_locals.Values; close
end


%% Table data
for tt1 = 1:length(SemiLocalDown)
    for tt2 = 1:length(SemiLocalDown) 
        data_table(tt1,tt2) = nb_intersect(tt1,tt2);
        if nb_intersect(tt1,tt2)==0
            data_table(tt1,tt2) = nb_intersect(tt2,tt1);
        end
    end
end
for tt=1:length(LocalDown)
    data_table(tt,tt) = length(Start(LocalDown{tt}));
end
row_table = cell(0);
column_table = cell(0);
for tt=1:length(LocalDown)
    row_table{end+1} = ['TT ' num2str(tt)];
    column_table{end+1} = ['TT ' num2str(tt)];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Color',[1 1 1],'units','normalized','outerposition',[0 0 1 1]);
textbox_dim = [0.05 0.8 0.2 0.18];
table_dim = [0.3 0.87 0.2 0.1];

%CC
for tt1 = 1:length(SemiLocalDown)
    for tt2 = 1:length(SemiLocalDown)
        x_ax = 0.05 + (tt1-1) * 0.15; 
        y_ax = 0.80 - tt2 * 0.25; 
        CC_axes{tt1,tt2} = axes('position', [x_ax y_ax 0.13 0.20]);
    end
end

%Density
for tt = 1:length(local_down_density)
    y_ax = 0.8 - tt * 0.25; 
    Density_Axes{tt} = axes('position', [0.52 y_ax 0.15 0.20]);
end

%ISI
for tt = 1:length(isi.local.x)
    y_ax = 0.8 - tt * 0.25; 
    ISI_local_Axes{tt} = axes('position', [0.71 y_ax 0.12 0.20]);
    y_ax = 0.8 - tt * 0.25;  
    ISI_semilocal_Axes{tt} = axes('position', [0.85 y_ax 0.12 0.20]);
end


%% Textbox
textbox_str = {[num2str(sum(nb_neurons)) ' neurons -- FR = ' num2str(fr_global_sws) 'Hz']}; 
for tt=1:length(nb_neurons)
    textbox_str{end+1} = ['Tetrode ' num2str(tt) ' : ' num2str(nb_neurons(tt)) ' neurons -- FR = ' num2str(firingRates_sws{tt}) 'Hz'];
end
textbox_str{end+1} = [num2str(length(center_globaldown)) ' global Down'];

annotation(gcf,'textbox',...
    textbox_dim,...
    'String',textbox_str,...
    'LineWidth',1,...
    'HorizontalAlignment','left',...
    'FontWeight','bold',...
    'FitBoxToText','off');


%% Table
tableau = uitable(gcf,'Data',data_table,'units','normalized','position',table_dim);
tableau.ColumnName = column_table;
tableau.RowName = row_table;


%% CrossCorrelogram
for tt1 = 1:length(SemiLocalDown)
    for tt2 = 1:length(SemiLocalDown)
        axes(CC_axes{tt1,tt2});
        x = Range(Cc_SemiLocal{tt1,tt2})/10;
        plot(x, Smooth(Data(Cc_SemiLocal{tt1,tt2}),smoothing), 'color','k'), hold on
        plot(Range(Cc_Local{tt1,tt2})/10, Smooth(Data(Cc_Local{tt1,tt2}),smoothing), 'color','b'), hold on
        line([0 0], get(gca,'ylim'), 'color', [0.75 0.75 0.75]);
        xlim([min(x) max(x)]);
        
        if tt1==1
            ylabel(['TT ' num2str(tt2)]);
        end
        if tt2==1
            title(['TT ' num2str(tt1)]);
        end
        
    end
end

%% Density
for tt = 1:length(local_down_density)
    axes(Density_Axes{tt});
    plot(x_intervals, local_down_density{tt},'-','color', 'b', 'Linewidth', 1), hold on
    plot(x_intervals, semilocal_down_density{tt},'-','color', 'k', 'Linewidth', 1), hold on    
    hold on, patch(x_rec1, y_rec1, [0.75 0.75 0.75], 'EdgeColor', 'None', 'FaceAlpha', 0.2);
    hold on, patch(x_rec2, y_rec2, [0.75 0.75 0.75], 'EdgeColor', 'None', 'FaceAlpha', 0.2);
    xlim([floor(min(x_intervals)) ceil(max(x_intervals))]);
    if tt==1
        title('Down Density');
    end
    if tt==3
        xlabel('Time(h)');
    end
end

%% ISI
for tt = 1:length(ISI_local_Axes)
    axes(ISI_local_Axes{tt});
    bar(isi.local.x{tt}, isi.local.y{tt}), hold on
    xlim([0 max(edges)]);
    ylabel(['TT ' num2str(tt)]);
    
    if tt==1
        title('ISI Local Silences');
    end
end


for tt = 1:length(ISI_semilocal_Axes)
    axes(ISI_semilocal_Axes{tt});
    bar(isi.semilocal.x{tt}, isi.semilocal.y{tt}), hold on
    xlim([0 max(edges)]);
    
    if tt==1
        title('ISI Semi-Local Silences');
    end
end








