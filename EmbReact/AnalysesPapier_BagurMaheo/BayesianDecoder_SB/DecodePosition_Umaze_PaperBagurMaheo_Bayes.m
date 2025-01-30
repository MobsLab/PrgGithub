clear all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data

% Session identity
MiceNumber = [905,911,994,1161,1162,1168,1186,1230,1239];
Session_type={'Hab1','Hab2','Hab','Cond'};
mm = 3; % This seems to be the best mouse
sess = 3;

% Parameters
SpeedLim = 2; % To define movepoch
Binsize = 0.1*1e4; % temporal binsize for decoding
SpatialBins = 20;
curvexy = [.15 .15 .85 .85; 0 .96 .96 0]';



%% Get the firing maps
% load data
clear Ripples FreezeEpoch LinPos StimEpoch NoiseEpoch Vtsd Spikes Q
load(['RippleReactInfo_NewRipples_' Session_type{sess} '_Mouse',num2str(MiceNumber(mm)),'.mat'])

% define epochs to analyse place fields
% Noise epoch = noise defined on LFP + 0.1s after aversive stimulation
try
    TotalNoiseEpoch = or(StimEpoch , NoiseEpoch);
catch
    try
        TotalNoiseEpoch = NoiseEpoch;
    catch
        TotalNoiseEpoch = intervalSet([],[]);
    end
end

AfterStimEpoch = intervalSet(Start(StimEpoch) , Start(StimEpoch)+.1e4);
TotalNoiseEpoch = or(TotalNoiseEpoch , AfterStimEpoch);

% move epoch : above threshold speed
MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
MovEpoch = mergeCloseIntervals(MovEpoch,2*1e4)-FreezeEpoch;
MovEpoch = MovEpoch-TotalNoiseEpoch;

X_Pos = Data(Restrict(Xtsd,MovEpoch));
Y_Pos = Data(Restrict(Ytsd,MovEpoch));
mapxy=[X_Pos';Y_Pos']';
[xy,distance,t] = distance2curve(curvexy,mapxy,'linear');
LinPos_tsd = tsd(Range(Restrict(Xtsd,MovEpoch)),t);
LinearizePos_time = hist(t,linspace(0,1,SpatialBins))*median(diff(Range(Restrict(Xtsd,MovEpoch),'s')));

% calculate spatial firing maps
for neur=1:length(Spikes)
    
    if max(size(Restrict(Spikes{neur},MovEpoch)))>10 % Only use cells with at least 10 spikes in move epoch
        X_OnSpikes = Data(Restrict(Xtsd,ts(Range(Restrict(Spikes{neur},MovEpoch)))));
        Y_OnSpikes = Data(Restrict(Ytsd,ts(Range(Restrict(Spikes{neur},MovEpoch)))));
        mapxy=[X_OnSpikes';Y_OnSpikes']';
        [xy,distance,t] = distance2curve(curvexy,mapxy,'linear');
        LinearizeFiring_binned1(neur,:) = hist(t,linspace(0,1,SpatialBins));
        
        
        [map_mov{neur}, mapNS_mov{neur}, stats{neur}, px{neur}, py{neur}, FR_mov(neur)] = PlaceField_DB(Spikes{neur}, Xtsd,...
            Ytsd , 'PlotResults' , 0 , 'PlotPoisson' ,0 , 'epoch' , MovEpoch);
        
        if isempty(stats{neur}.spatialInfo)
            stats{neur}.spatialInfo = 0;
        end
        
        SpatialInfo(neur) = stats{neur}.spatialInfo;
        
        % Get only bins the mice has actually visited
        map_temp = mapNS_mov{neur}.rate;
        pos_temp = mapNS_mov{neur}.time;
        map_temp = map_temp(8:56,8:56);
        pos_temp = pos_temp(8:56,8:56);
        map_temp(pos_temp==0) = NaN;
        maze_lin=linspace(0,1,size(map_temp,1));
        clear U, U=find(not(isnan(map_temp)));
        
        % linearize
        [Y,X] = ind2sub(size(map_temp) , U);
        [~,~,lin_proj] = distance2curve([.15 .15 .85 .85; 0 .96 .96 0]',[maze_lin(X);maze_lin(Y)]','linear');
        [C,~,IC] = unique(lin_proj);
        
        % Mean firing rate for each level visited
        for j=1:length(C)
            LinFiring_temp(j,:) = [C(j) nanmean(map_temp(U(IC==j)))];
        end
        [~,order]=sort(LinFiring_temp(:,1));
        LinFiring_temp = LinFiring_temp(order,:);
        
        % bin regularly thorughout the maze
        for bin=1:SpatialBins
            ind=find(and(LinFiring_temp(:,1)>=((bin-1)/SpatialBins) , LinFiring_temp(:,1)<(bin/SpatialBins)));
            if ~isempty(ind)
                LinearizeFiring_binned(neur,bin) = nanmean(LinFiring_temp(ind,2));
            end
        end
        
        LinearizeFiring_binned(neur,:) = LinearizeFiring_binned(neur,:);
    else
        FR_mov(neur) = NaN;
        SpatialInfo(neur) = 0;
        LinearizeFiring_binned(neur,:) = nan(1,SpatialBins);
        LinearizeFiring_binned1(neur,:) = nan(1,SpatialBins);
        map_mov{neur}.rate = [];
        map_mov{neur}.time = [];
        map_mov{neur}.count = [];
        mapNS_mov{neur}.rate = [];
        mapNS_mov{neur}.time = [];
        stats{neur} = 0;
    end
end

% Get rid of NaN cells
BadGuys = find(sum(isnan(LinearizeFiring_binned)'));
LinearizeFiring_binned(BadGuys,:) = [];
LinearizeFiring_binned1(BadGuys,:) = [];

LinearizeFiring_binned1_norm = LinearizeFiring_binned1./repmat(LinearizePos_time,size(LinearizeFiring_binned1,1),1);
LinearizeFiring_binned1_norm(:,1) = 0;

%% Check we have a representation of the position
figure
imagesc(corr(smooth2a(zscore(LinearizeFiring_binned1_norm')',0,1)))


% Get data for decoding
Q = MakeQfromS(Restrict(Spikes,MovEpoch),Binsize); % data from the conditionning session
data_decoder = full(Data(Q)'/(Binsize/1e4));
data_decoder(BadGuys,:) = [];
% Check overal match of firing rates - imperfect alignement is due to
% irregular position sampling, probably have to come back to this
plot(nanmean(data_decoder'),nanmean(LinearizeFiring_binned1_norm'),'.')
 h = gca;
xlim(max([abs(h.XLim),abs(h.YLim)]).*[0.001 1])
ylim(max([abs(h.XLim),abs(h.YLim)]).*[0.001 1])
line(xlim,ylim,'color','k')
axis square

% Do decoding
for bin = 1:size(data_decoder,2)
    for neur = 1:size(LinearizeFiring_binned1_norm,1)
        % Expected spike count
        lam = LinearizeFiring_binned1_norm(neur,:);
        %Actual spike count
        r = (data_decoder(neur,bin));
        % Probability of the given neuron's spike count given tuning curve (assuming poisson distribution)
        probs(neur,:) = exp(-lam).*(lam.^r/factorial(r));
        
    end
    probs_final(bin,:) = prod(probs).* LinearizePos_time;
end
[val,ind] = max(probs_final');
% Can't use empty bins
ind(nansum(data_decoder)==0) = NaN;
     
plot(ind,Data(Restrict(LinPos_tsd,Range(Q))),'.')
