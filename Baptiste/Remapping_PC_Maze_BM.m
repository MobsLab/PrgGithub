
clear all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data

MiceNumber = [905,911,994,1161,1162,1168,1186,1230,1239];
Session_type={'TestPre','TestPost'};

% Parameters
SpeedLim = 2; % To define movepoch
window_around_rip = [0.05 0.05]; % in s, size of windows around ripples
Binsize=.005e4; % sof spikres
Lims = [0.3,0.7]; % definition of shock and safe zone
SessDefinePlaceCell = 3; % Use habituation to define if place cell or not
SpatialInfoThresh = 1; % Spatial info threshold to define if place cell or not

% Initialization
FR_Ripples_all=[];
FR_PreRipples_all=[];
for sess=1:length(Session_type); FR_mov_all{sess} = []; end


% Plotting
Cols = {[0 0 1],[.85, .325, .1],[.3 .3 .3],[1 0 0],[.5 .2 .55],[.2 .8 .2]};
Legends = {'Hab1','Hab2','Hab','Cond','PreRipples','Ripples'};
X_plo=[1:6];
Cols2 = {[1 .5 .5],[.5 .5 .5],[.5 .5 1]};
Legends2 = {'Shock','Mid','Safe'};
X2_plo=[1:3];



%% Get the place fields
for sess=1:length(Session_type)
    disp(Session_type{sess})
    for mm=1:length(MiceNumber)
        disp(num2str(MiceNumber(mm)))
        
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
        
        AfterStimEpoch = intervalSet(Start(StimEpoch) , Start(StimEpoch)+.1e4);          % if you put AfterStimEpoch = ...+3e4, no significativity
        TotalNoiseEpoch = or(TotalNoiseEpoch , AfterStimEpoch);
        
        % movepohc : above threshold speed
        MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
        MovEpoch = mergeCloseIntervals(MovEpoch,2*1e4)-FreezeEpoch;
        MovEpoch = MovEpoch-TotalNoiseEpoch;
        
        % get the spatial firing maps
        for neur=1:length(Spikes)
            try
                if max(size(Restrict(Spikes{neur},MovEpoch)))>10 % Only use cells with at least 20 spikes in move epoch
                    
                    [map_mov{sess}{mm}{neur}, mapNS_mov{sess}{mm}{neur}, stats{sess}{mm}{neur}, px{sess}{mm}{neur}, py{sess}{mm}{neur}, FR_mov{sess}{mm}(neur)] = ...
                        PlaceField_DB(Spikes{neur}, Xtsd, Ytsd , 'PlotResults' , 0 , 'PlotPoisson' ,0 , 'epoch' , MovEpoch);
                    close
                    
                    if isempty(stats{sess}{mm}{neur}.spatialInfo)
                        stats{sess}{mm}{neur}.spatialInfo = 0;
                    end
                    
                    SpatialInfo{sess}{mm}(neur) = stats{sess}{mm}{neur}.spatialInfo;
                    
                    % Get only bins the mice has actually visited
                    map_temp = mapNS_mov{sess}{mm}{neur}.rate;
                    pos_temp = mapNS_mov{sess}{mm}{neur}.time;
                    map_temp = map_temp(8:56,8:56);
                    pos_temp = pos_temp(8:56,8:56);
                    map_temp(pos_temp==0) = NaN;
                    maze_lin=linspace(0,1,size(map_temp,1));
                    clear U, U=find(not(isnan(map_temp)));
                else
                    FR_mov{sess}{mm}(neur) = NaN;
                    SpatialInfo{sess}{mm}(neur) = 0;
                    LinearizeFiring_binned{sess}{mm}(neur,:) = nan(1,100);
                    map_mov{sess}{mm}{neur}.rate = [];
                    map_mov{sess}{mm}{neur}.time = [];
                    map_mov{sess}{mm}{neur}.count = [];
                    mapNS_mov{sess}{mm}{neur}.rate = [];
                    mapNS_mov{sess}{mm}{neur}.time = [];
                    stats{sess}{mm}{neur} = 0;
                end
            catch
                FR_mov{sess}{mm}(neur) = NaN;
                SpatialInfo{sess}{mm}(neur) = 0;
                LinearizeFiring_binned{sess}{mm}(neur,:) = nan(1,100);
                map_mov{sess}{mm}{neur}.rate = [];
                map_mov{sess}{mm}{neur}.time = [];
                map_mov{sess}{mm}{neur}.count = [];
                mapNS_mov{sess}{mm}{neur}.rate = [];
                mapNS_mov{sess}{mm}{neur}.time = [];
                stats{sess}{mm}{neur} = 0;
            end
        end
    end
end




%%
clear Corr_PC_map Corr_PC_map_indiv Corr_PC_map_all
n=1;
for mm=1:length(MiceNumber)
    disp(num2str(MiceNumber(mm)))
    
    for cell=1:length(mapNS_mov{1}{mm})
        try
            if stats{1}{mm}{cell}.spatialInfo>1
                Corr_PC_map(n,:,:) = mapNS_mov{2}{mm}{cell}.rate-mapNS_mov{1}{mm}{cell}.rate;
                n=n+1;
            end
        end
    end
    for cell=1:length(mapNS_mov{1}{mm})
        try
            if stats{1}{mm}{cell}.spatialInfo>1
                Corr_PC_map_indiv{mm}(cell,:,:) = mapNS_mov{2}{mm}{cell}.rate-mapNS_mov{1}{mm}{cell}.rate;
            end
        end
    end
    Corr_PC_map_indiv{mm}(Corr_PC_map_indiv{mm}==0) = NaN;
    Corr_PC_map_all(mm,:,:) = squeeze(nanmean(Corr_PC_map_indiv{mm}));
end
Corr_PC_map(Corr_PC_map==0)=NaN;


figure
subplot(121)
data = smooth2a(squeeze(nanmean(Corr_PC_map)),2,2);
[nr,nc] = size(data);
pcolor([data nan(nr,1); nan(1,nc+1)]), axis xy
colormap redblue,  shading flat, axis off, axis square
c=colorbar; c.Label.String ='Change (Hz)'; 
title('PC map TestPost-TestPre, n=159 units')

subplot(122)
data = smooth2a(squeeze(nanmean(Corr_PC_map)),2,2);
[nr,nc] = size(data);
pcolor([data nan(nr,1); nan(1,nc+1)]), axis xy
colormap redblue,  shading flat, axis off, axis square
c=colorbar; c.Label.String ='Change (Hz)'; caxis([-.05 .05])



figure
data = smooth2a(squeeze(nanmean(Corr_PC_map_all)),2,2);
[nr,nc] = size(data);
pcolor([data nan(nr,1); nan(1,nc+1)]), axis xy
colormap redblue,  shading flat, axis off, axis square
c=colorbar; c.Label.String ='Change (Hz)';
title('PC map TestPost-TestPre, n=9 mice')



figure
for i=1:n
    subplot(5,10,i)
    imagesc(linspace(0,1,62) , linspace(0,1,62) , squeeze(Corr_PC_map(i,:,:))), axis xy
    axis square, caxis([-1 1])
end

for i=1:n
    A = squeeze(Corr_PC_map(i,:,:));
    GainShockMinusSafe(i) = nansum(nansum(A(1:40,1:30)))-nansum(nansum(A(1:40,31:62)));
end


figure
for mm=1:length(MiceNumber)
    subplot(3,3,mm)
    imagesc(linspace(0,1,62) , linspace(0,1,62) , squeeze(nanmean(Corr_PC_map_indiv{mm}(:,:,:))))
    axis square
end


Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock gain','Safe gain'};

figure;
s=subplot(121);
MakeSpreadAndBoxPlot3_SB({GainShockMinusSafe(GainShockMinusSafe>0)...
    GainShockMinusSafe(GainShockMinusSafe<0)},Cols,X,Legends,'showpoints',1,'paired',0);
symlog(s,'y'), grid off, ylim([-3.3 3.3]), ylabel('firing rate gain (log scale)'), hline(0,'--k')
makepretty_BM2

subplot(122)
b1=bar([1],[sum(GainShockMinusSafe>0)]); hold on
b1.FaceColor = [1 .5 .5];
b2=bar([2],[sum(GainShockMinusSafe<0)]);
b2.FaceColor = [.5 .5 1];
ylabel('number of cells'), xticks([1 2]), xticklabels({'Shock gain','Safe gain'}), xtickangle(45)
makepretty

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% old
for mm=1:length(MiceNumber)
    disp(num2str(MiceNumber(mm)))
    
    for cell=1:length(mapNS_mov{1}{mm})
        if and(stats{1}{mm}{cell}.spatialInfo>1)
            try
                Corr_PC_map{mm}(cell,:,:) = mapNS_mov{2}{mm}{cell}.rate-mapNS_mov{1}{mm}{cell}.rate;
                %             norm_val = max(abs(squeeze(Corr_PC_map{mm}(cell,:))));
                %             normM{mm}(cell,:,:) = squeeze(Corr_PC_map{mm}(cell,:,:))./norm_val;
                Corr_PC_map{mm}(Corr_PC_map{mm}==0) = NaN;
                minVal = min(squeeze(Corr_PC_map{mm}(cell,:)));
                maxVal = max(squeeze(Corr_PC_map{mm}(cell,:)));
                normM{mm}(cell,:,:) = 2*((squeeze(Corr_PC_map{mm}(cell,:,:))-minVal)/(maxVal-minVal))-1;
            end
        end
    end
    %     normM{mm}(normM{mm}==0) = NaN;
    %     ChangeAll(mm,:,:) = squeeze(nanmean(normM{mm}(:,:,:)));
end


figure
for mm=1:length(MiceNumber)
    subplot(3,3,mm)
    imagesc(linspace(0,1,62) , linspace(0,1,62) , squeeze(nanmean(normM{mm}(:,:,:))))
    axis square
    caxis([-1 1])
end

figure
data = smooth2a(squeeze(nanmean(ChangeAll)),2,2);
[nr,nc] = size(data);
pcolor([data nan(nr,1); nan(1,nc+1)]), axis xy
colormap redblue,  shading flat, axis off, axis square
c=colorbar; c.Labels.String='change in '
caxis([-1 1])


