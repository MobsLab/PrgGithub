%%ClusterLayerUsingDeltaWavesOneNight
% 29.07.2019 KJ
%
%   
%
% see
%   ClusterLayerUsingDeltaWaves
%


clear

%params
durations   = [100 200] * 10; 
binsize_met  = 5; %for mETAverage  
nbBins_met   = 240; %for mETAverage 
preripples_window = 4000; %400ms

    
%% load data

% Epoch
[NREM, ~, Wake, TotalNoiseEpoch] = GetSleepScoring;
NREM = NREM-TotalNoiseEpoch;
    
%PFC channels
load('IdFigureData2.mat', 'channel_curves', 'structures_curves', 'peak_value')
idx = find(strcmpi(structures_curves,'PFCx'));
channel_curves = channel_curves(idx);
peak_value = peak_value(idx);
    
load('ChannelsToAnalyse/PFCx_locations.mat','channels')
for ch=1:length(channels)
    peak_value_new(ch) = peak_value(channel_curves==channels(ch));
end
peak_value = peak_value_new;
    
%LFP 
Signals = cell(0);
for ch=1:length(channels)
    load(['LFPData/LFP' num2str(channels(ch))], 'LFP')
    Signals{ch} = LFP; clear LFP
end   


%down
load('DownState.mat', 'down_PFCx')
Down = down_PFCx;
start_down = Start(Down);
center_down = (End(Down) + Start(Down))/2;
down_durations = End(Down) - Start(Down);
selected_down = start_down(down_durations>durations(1) & down_durations<durations(2));

%Delta detection per channel
deltas_ch = cell(0); selected_deltachan = cell(0);
for ch=1:length(channels)
    name_var = ['delta_ch_' num2str(channels(ch))];
    load('DeltaWavesChannels.mat', name_var)
    eval(['deltas = ' name_var ';'])

    %Restrict    
    deltas_ch{ch} = and(deltas, NREM);
    st_deltachan{ch} = Start(deltas_ch{ch});
    delta_durations = End(deltas_ch{ch}) - Start(deltas_ch{ch});
    selected_deltachan{ch} = st_deltachan{ch}(delta_durations>durations(1) & delta_durations<durations(2));
end

%deltas max
load('DeltaWaves.mat', 'deltamax_PFCx')
st_deltamax = Start(deltamax_PFCx);
delta_durations = End(deltamax_PFCx) - Start(deltamax_PFCx);
selected_deltamax = st_deltamax(delta_durations>durations(1) & delta_durations<durations(2));

%deltas
load('DeltaWaves.mat', 'deltas_PFCx')
start_delta = Start(deltas_PFCx);
center_delta = (End(deltas_PFCx) + Start(deltas_PFCx))/2;
delta_durations = End(deltas_PFCx) - Start(deltas_PFCx);
selected_delta = start_delta(delta_durations>durations(1) & delta_durations<durations(2));


%ripples
[tRipples, ~] = GetRipples;
ripples_tmp = Range(Restrict(tRipples, NREM));

%ripples without down before
preripples_intv = [ripples_tmp-preripples_window  ripples_tmp];
[~,interval,~] = InIntervals(center_down, preripples_intv);
interval(interval==0)=[];
interval=unique(interval);
ripples_alone = ripples_tmp(~ismember(1:length(ripples_tmp),interval));




%% Meancurves
%down
for ch=1:length(channels)
    [m,~,tps] = mETAverage(selected_down, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
    meancurves.down{ch}(:,1) = tps; meancurves.down{ch}(:,2) = m;
end
%delta_PFCx
for ch=1:length(channels)
    [m,~,tps] = mETAverage(selected_delta, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
    meancurves.deltas{ch}(:,1) = tps; meancurves.deltas{ch}(:,2) = m;
end
%delta_channels
for ch=1:length(channels)
    [m,~,tps] = mETAverage(selected_deltachan{ch}, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
    meancurves.deltachan{ch}(:,1) = tps; meancurves.deltachan{ch}(:,2) = m;
end
%ripples
for ch=1:length(channels)
    [m,~,tps] = mETAverage(ripples_alone, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
    meancurves.ripples{ch}(:,1) = tps; meancurves.ripples{ch}(:,2) = m;
end



%% features

fn = fieldnames(meancurves);
for k=1:numel(fn)
    meandatacurves = meancurves.(fn{k});

    %features extraction
    X = nan(length(channels),2);
    for ch=1:length(channels)
            x = meandatacurves{ch}(:,1);
            y = meandatacurves{ch}(:,2);
            %postive deflection
            if sum(y(x>0 & x<=150))>0
                x1 = x>0 & x<=200;
                x2 = x>150 & x<=350;
                feat1 = max(y(x1));
                feat2 = min(y(x2));
            %negative deflection
            else
                x1 = x>0 & x<=250;
                x2 = x>200 & x<=350;
                feat1 = min(y(x1));
                feat2 = max(y(x2));
            end

        X(ch,:) = [feat1 feat2];
    end

    Xfeatures.(fn{k}) = X;
    
end

%clustering
X = Xfeatures.down;
clusterX = nan(length(X),1);

xp = X(:,1);
yp = X(:,2);
cond{1} = yp>(0.8*xp+200);
cond{2} = yp<=(0.8*xp+200) & yp>(0.8*xp-900);
cond{3} = yp<=(0.8*xp-900) & yp>(0.8*xp-1600);
cond{4} = yp<=(0.8*xp-1600) & yp>(0.7*xp-2140);
cond{5} = yp<=(0.7*xp-2140);
for i=1:length(cond)
    clusterX(cond{i}) = i;
end
nb_clusters = length(unique(clusterX));

%colors
colori = distinguishable_colors(nb_clusters);
for i=1:nb_clusters
    colori_cluster{i} = colori(i,:);
end



%% Plot

for k=1:numel(fn)
    
    %
    X = Xfeatures.(fn{k});
    
    subplot(2,2,k), hold on
    gscatter(X(:,1),X(:,2), clusterX, colori);
    xlabel('amplitude 1st extrema'), ylabel('amplitude 2nd extrema')

    title(fn{k});



end



