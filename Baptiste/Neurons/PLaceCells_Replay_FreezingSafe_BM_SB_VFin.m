
clear all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data

MiceNumber = [905,911,994,1161,1162,1168,1186,1230,1239];
% MiceNumber = [911,994,1161,1162]; % use these mice to analyse shock
% freezing
Session_type={'Hab1','Hab2','Hab','Cond'};

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
                    
                    
                    [map_mov{sess}{mm}{neur}, mapNS_mov{sess}{mm}{neur}, stats{sess}{mm}{neur}, px{sess}{mm}{neur}, py{sess}{mm}{neur}, FR_mov{sess}{mm}(neur)] = PlaceField_DB(Spikes{neur}, Xtsd,...
                        Ytsd , 'PlotResults' , 0 , 'PlotPoisson' ,0 , 'epoch' , MovEpoch);
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
                    for bin=1:100
                        ind=find(and(LinFiring_temp(:,1)>=((bin-1)/100) , LinFiring_temp(:,1)<(bin/100)));
                        if ~isempty(ind)
                            LinearizeFiring_binned{sess}{mm}(neur,bin) = nanmean(LinFiring_temp(ind,2));
                        end
                    end
                    
                    LinearizeFiring_binned{sess}{mm}(neur,:) = LinearizeFiring_binned{sess}{mm}(neur,:)./sum(LinearizeFiring_binned{sess}{mm}(neur,:));
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
        
        % Distribution of linearized positions
        LinPos_Mov{sess}{mm} = Restrict(LinPos , MovEpoch);
        h=histogram(Data(LinPos_Mov{sess}{mm}),'BinLimits',[0 1],'NumBins',100);
        HistData_LinPos{sess}(mm,:)= h.Values./sum(h.Values);
        
        % Duration of different epochs
        try, FR_mov_all{sess} = [FR_mov_all{sess} ; FR_mov{sess}{mm}']; end
        Duration_epoch(sess,mm) = sum(DurationEpoch(MovEpoch))/1e4;
        
        % Overall firing rate
        clear Ra, Ra = Range(Vtsd);
        for neur=1:length(Spikes)
            if sess==5
                Spikes_FR_all{sess}{mm}(neur) = length(Spikes{neur})./((Ra(end)-Ra(1))/1e4);
            else
                Spikes_FR_all{sess}{mm}(neur) = length(Restrict(Spikes{neur},MovEpoch))./(sum(DurationEpoch(MovEpoch))/1e4);
            end
        end
    end
end

%% Get ripples triggered activity
clear FR_Ripples FR_PreRipples MeanFR_AroundRip

for mm=1:length(MiceNumber)
    disp(['RipAct ' num2str(MiceNumber(mm))])
    
    % Only for cond
    clear Ripples FreezeEpoch LinPos StimEpoch NoiseEpoch Vtsd Spikes Q
    load(['RippleReactInfo_NewRipples_Cond_Mouse',num2str(MiceNumber(mm)),'.mat'])
    
    Q = MakeQfromS(Spikes,Binsize); % data from the conditionning session
    Q = tsd(Range(Q),nanzscore(full(Data(Q))));
    
    % define epochs to analyse ripple activity
    % Noise epoch = noise defined on LFP + 0.1s after aversive stimulation     try
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
    TotalNoiseEpoch = or(or(StimEpoch , NoiseEpoch) , AfterStimEpoch);
    
    % Only use safe side ripples
    FreezeSafe = and(thresholdIntervals(LinPos,0.6,'Direction','Above') , FreezeEpoch);
%     FreezeSafe = FreezeEpoch;
    Ripples_Epoch = mergeCloseIntervals(intervalSet(Range(Ripples)-window_around_rip(1)*1e4,Range(Ripples)+window_around_rip(2)*1e4),0.1*1e4);
    Ripples_FreezeSafe = and(Ripples_Epoch , FreezeSafe);
    Ripples_FreezeSafe = Ripples_FreezeSafe-TotalNoiseEpoch;
    length(Start(Ripples_FreezeSafe))

    
    Ripples_ts_FreezeSafe = Restrict(Ripples , FreezeSafe-TotalNoiseEpoch);
    
    Pre_Ripples_Epoch = mergeCloseIntervals(intervalSet(Range(Ripples)-2*1e4,Range(Ripples)-1.75*1e4),0.1*1e4);
    Pre_Ripples_FreezeSafe = and(Pre_Ripples_Epoch , FreezeSafe)-Ripples_FreezeSafe;
    Pre_Ripples_FreezeSafe = Pre_Ripples_FreezeSafe-TotalNoiseEpoch;
    
    % Firing rate around ripples
    for neur=1:length(Spikes)
        lEpoch = sum(End(Ripples_FreezeSafe, 's') - Start(Ripples_FreezeSafe, 's'));
        FR_Ripples{mm}(neur) =  length(Range(Restrict(Spikes{neur},Ripples_FreezeSafe)))/lEpoch;
        
        lEpoch = sum(End(Pre_Ripples_FreezeSafe, 's') - Start(Pre_Ripples_FreezeSafe, 's'));
        FR_PreRipples{mm}(neur) =  length(Range(Restrict(Spikes{neur},Pre_Ripples_FreezeSafe)))/lEpoch;
        
        clear D; D=Data(Q);
        Q_neur{neur} = tsd(Range(Q) , D(:,neur));
        [M,T] = PlotRipRaw(Q_neur{neur},Range(Ripples_ts_FreezeSafe,'s'),1e3,0,0);
        MeanFR_AroundRip{mm}(neur,:) = M(:,2);
        
    end
    
    LinPos_Rip{mm} = Restrict(LinPos , Ripples_FreezeSafe);
    h=histogram(Data(LinPos_Rip{mm}),'BinLimits',[0 1],'NumBins',100);
    HistData_LinPos{5}(mm,:)= h.Values./sum(h.Values);
    LinPos_PreRip{mm} = Restrict(LinPos , Pre_Ripples_FreezeSafe);
    h=histogram(Data(LinPos_PreRip{mm}),'BinLimits',[0 1],'NumBins',100);
    HistData_LinPos{6}(mm,:)= h.Values./sum(h.Values);
    
    try, FR_Ripples_all = [FR_Ripples_all ; FR_Ripples{mm}']; end
    try, FR_PreRipples_all = [FR_PreRipples_all ; FR_PreRipples{mm}']; end
    Duration_epoch(5,mm) = sum(DurationEpoch(Ripples_FreezeSafe))/1e4;
    Duration_epoch(6,mm) = sum(DurationEpoch(Pre_Ripples_FreezeSafe))/1e4;
    
end


%% Create pseudo-population with only place cells

MeanFR_AroundRip_all=[];
FR_PreRipples = [];
FR_Ripples = [];


for sess=1:length(Session_type)
    LinFiring_AllPlaceCells{sess} = [];
    PeakLoc{sess} = [];
    PlaceCellpeak_2D{sess} = [];
    PlaceCellpeak_1D{sess} = [];
    PlaceCellMap{sess} = nan(1,62,62);
    
    for mm=1:length(MiceNumber)
        for neur=1:length(SpatialInfo{sess}{mm})
            IsDefined = and(and(~isempty(mapNS_mov{1}{mm}{neur}) , ~isempty(mapNS_mov{2}{mm}{neur})) , and(~isempty(mapNS_mov{3}{mm}{neur}) , ~isempty(mapNS_mov{4}{mm}{neur})));
            if IsDefined
                U1 = find(mapNS_mov{1}{mm}{neur}.rate~=0); U2 = find(mapNS_mov{2}{mm}{neur}.rate~=0);
                U3 = find(mapNS_mov{3}{mm}{neur}.rate~=0); U4 = find(mapNS_mov{4}{mm}{neur}.rate~=0);
                IsFiring = and(and(~isempty(U1) , ~isempty(U2)) , and(~isempty(U3) , ~isempty(U4)));
                if IsFiring
                    if SpatialInfo{SessDefinePlaceCell}{mm}(neur)>SpatialInfoThresh
                        % 1D
                        LinFiring_AllPlaceCells{sess} = [LinFiring_AllPlaceCells{sess};LinearizeFiring_binned{sess}{mm}(neur,:)];
                        [~,ind] = max(LinFiring_AllPlaceCells{sess}(end,:)');
                        PlaceCellpeak_1D{sess}(end+1)  = ind/100;
                        % 2D
                        PeakLoc{sess} = [PeakLoc{sess}, [stats{sess}{mm}{neur}.x(1);stats{sess}{mm}{neur}.y(1)]];
                        [~,~,lin_proj] = distance2curve([.15 .15 .85 .85; 0 .96 .96 0]',[maze_lin(stats{sess}{mm}{neur}.x(1)-7);maze_lin(stats{sess}{mm}{neur}.y(1)-7)]','linear');
                        PlaceCellpeak_2D{sess} = [PlaceCellpeak_2D{sess},lin_proj];
                        
                        PlaceCellMap{sess}(end+1,:,:) = map_mov{sess}{mm}{neur}.rate;
                        
                        % Get ripples firing rate
                        if sess==4
                            FR_PreRipples = [FR_PreRipples,FR_PreRipples_all(neur)];
                            FR_Ripples = [FR_Ripples,FR_Ripples_all(neur)];
                            MeanFR_AroundRip_all = [MeanFR_AroundRip_all ; MeanFR_AroundRip{mm}(neur,:)];
                        end
                        
                        
                    end
                end
            end
        end
    end
    PlaceCellMap{sess}(1,:,:) = [];
end

% order the cells by peak
for sess=1:length(Session_type)
    [~,PlaceCellOrder_1D{sess}]=sort(PlaceCellpeak_1D{sess});
    [~,PlaceCellOrder_2D{sess}]=sort(PlaceCellpeak_2D{sess});
end




%% figures
% 1) example
sess=4;
for mm=1:length(stats{3})
    for neur = 1:length(SpatialInfo{sess}{mm})
        clf
        if SpatialInfo{sess}{mm}(neur)>1
            subplot(3,1,1:2)
            imagesc(map_mov{sess}{mm}{neur}.rate(8:56,8:56)), axis xy
            title([num2str(round(stats{sess}{mm}{neur}.spatialInfo,2)) ' / ' num2str(round(stats{sess}{mm}{neur}.sparsity,2)) ' / ' num2str(round(stats{sess}{mm}{neur}.specificity,2)) ' / ' num2str(neur)])
            sizeMap=50; Maze_Frame_BM, hold on
            a=area([19 32],[37 37]);
            a.FaceColor=[1 1 1];
            a.LineWidth=1e-6;
            hold on
            plot(stats{sess}{mm}{neur}.x(1)-8,stats{sess}{mm}{neur}.y(1)-8,'.','MarkerSize',30)
            subplot(313)
            plot([0.01:0.01:1],LinearizeFiring_binned{sess}{mm}(neur,:))
            [v,ind] = max(LinearizeFiring_binned{sess}{mm}(neur,:)');
            hold on
            plot(ind/100,0.2,'b.')
            [~,~,lin_proj] = distance2curve([.15 .15 .85 .85; 0 .96 .96 0]',[maze_lin(stats{sess}{mm}{neur}.x(1)-7);maze_lin(stats{sess}{mm}{neur}.y(1)-7)]','linear');
            plot(lin_proj,0.6,'r.')
            ylim([0 1])
            xlabel('linearized maze distance'), ylabel('firing rate (#/s)')
            makepretty_BM
            pause
        end
    end
end


% Plot juste the shock cells
figure
ShockPlaceFields = find( PlaceCellpeak_2D{4}<0.4);
for ii = 1:length(ShockPlaceFields)
    subplot(3,4,ii)
    imagesc(squeeze(PlaceCellMap{4}(ShockPlaceFields(ii),8:56,8:56)))
    axis xy
    sizeMap=50; Maze_Frame_BM, hold on
    a=area([19 32],[37 37]);
    a.FaceColor=[1 1 1];
    a.LineWidth=1e-6;
    %     plot( LinFiring_AllPlaceCells{sess}(ShockPlaceFields(ii),:))
    
end

% % 2) epoch for PC identification
figure
MakeSpreadAndBoxPlot_BM({Duration_epoch(1,:) Duration_epoch(2,:) Duration_epoch(3,:) Duration_epoch(4,:) Duration_epoch(6,:) Duration_epoch(5,:)}...
    , {[0 0 1],[.85, .325, .1],[.3 .3 .3],[1 0 0],[.5 .2 .55],[.2 .8 .2]},[1:6],{'Hab1','Hab2','Hab','Cond','PreRipples','Ripples'},1,0)
ylabel('duration of epochs (s)')

%
% % 3) Hab1 & Hab2
% 1D
sess1 = 1; sess2 = 2;
LinSess1 = LinFiring_AllPlaceCells{sess1};
LinSess2 = LinFiring_AllPlaceCells{sess2};
CellPeak1 = PlaceCellpeak_1D{sess1};
CellPeak2 = PlaceCellpeak_1D{sess2};
CellOrder1 = PlaceCellOrder_1D{sess1};
CellOrder2 = PlaceCellOrder_1D{sess2};
SessNames = {Session_type{sess1},Session_type{sess2}};
MakeFigure_CompareMappingEpochs_SBBM(LinSess1,LinSess2,CellPeak1,CellPeak2,CellOrder1,CellOrder2,SessNames)
%2 D
CellPeak1 = PlaceCellpeak_2D{sess1};
CellPeak2 = PlaceCellpeak_2D{sess2};
CellOrder1 = PlaceCellOrder_2D{sess1};
CellOrder2 = PlaceCellOrder_2D{sess2};
MakeFigure_CompareMappingEpochs_SBBM(LinSess1,LinSess2,CellPeak1,CellPeak2,CellOrder1,CellOrder2,SessNames)

% % 3) Hab & Cond
sess1 = 3; sess2 = 4;
% 1D ordering
LinSess1 = LinFiring_AllPlaceCells{sess1};
LinSess2 = LinFiring_AllPlaceCells{sess2};
CellPeak1 = PlaceCellpeak_1D{sess1};
CellPeak2 = PlaceCellpeak_1D{sess2};
CellOrder1 = PlaceCellOrder_1D{sess1};
CellOrder2 = PlaceCellOrder_1D{sess2};
SessNames = {Session_type{sess1},Session_type{sess2}};
MakeFigure_CompareMappingEpochs_SBBM(LinSess1,LinSess2,CellPeak1,CellPeak2,CellOrder1,CellOrder2,SessNames)
% 2D ordering
CellPeak1 = PlaceCellpeak_2D{sess1};
CellPeak2 = PlaceCellpeak_2D{sess2};
CellOrder1 = PlaceCellOrder_2D{sess1};
CellOrder2 = PlaceCellOrder_2D{sess2};
MakeFigure_CompareMappingEpochs_SBBM(LinSess1,LinSess2,CellPeak1,CellPeak2,CellOrder1,CellOrder2,SessNames)


%% look at link with ripples
% 1D ordering
% OrderToUse = PlaceCellOrder_1D{4};
% PeakToUse = PlaceCellpeak_1D{4};
% 2D ordering
OrderToUse = PlaceCellOrder_2D{4};
PeakToUse = PlaceCellpeak_2D{4};

% Classify cell locations
ShockCells = 1: sum(PeakToUse<Lims(1));
SafeCells = length(OrderToUse)-sum(PeakToUse>Lims(2)):length(OrderToUse);
MidCells = 1: length(OrderToUse<Lims(1));
MidCells(ismember(MidCells,ShockCells)) = [];
MidCells(ismember(MidCells,SafeCells)) = [];
% Get Ripple variables
RippleAmp = nanmean(MeanFR_AroundRip_all(OrderToUse,[190:210])');
[~,RippleTiming]=max(zscore(MeanFR_AroundRip_all(OrderToUse,[190:210])'));
RippleTiming = (RippleTiming/length([190:210]) - 0.5)*100; % Convert to ms, centered on ripple middle

% Use weighted mean and not peak for timing estimate
% W = ([190:210] - 200)*0.05;
% for ii = 1:length(OrderToUse)
%     A = MeanFR_AroundRip_all(OrderToUse(ii),[190:210]);
%     A = (A-min(A))/sum(A-min(A));
%     Wmean(ii) = ((190+(nanmean([1:21].*A)*21))-200)*0.05;
% %     plot(W,A)
% %     hold on
% %     plot(Wmean(ii),0,'*')
% %     pause
% %     clf
% end
%
% RippleTiming = Wmean*1e2;
% RippleTiming(abs(RippleTiming)>20) = NaN;

figure
subplot(141), sess=4;
imagesc( linspace(0,1,100) , [1:size(LinFiring_AllPlaceCells{sess},1)] ,runmean(LinFiring_AllPlaceCells{sess}(OrderToUse,:)',2)')
% imagesc( linspace(0,1,100) , [1:size(LinFiring_AllPlaceCells{sess},1)] , LinFiring_AllPlaceCells{sess}(OrderToUse,:))
caxis([0 .05])
xlabel('linear UMaze distance'), ylabel('HPC neurons no')
hline(max(ShockCells),'--w'), hline(min(SafeCells),'--w')
makepretty_BM
freezeColors

subplot(142)
imagesc(linspace(-250,250,size(MeanFR_AroundRip_all,2)) , [1:size(MeanFR_AroundRip_all,1)] , MeanFR_AroundRip_all(OrderToUse,150:250))
xlabel('time around ripple (ms)'), yticklabels({''}), caxis([-.15 1]), xticks([-250 0 250])
makepretty_BM
hline(max(ShockCells),'--w'), hline(min(SafeCells),'--w')
colormap viridis
freezeColors

subplot(243)
% Mid
Data_to_use = MeanFR_AroundRip_all(OrderToUse(MidCells),150:250);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
h=shadedErrorBar(linspace(-.2,.2,size(Data_to_use,2)) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) ,'-r',1); hold on;
color= [.5 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=[.3 .3 .7]; h.edge(1).Color=color; h.edge(2).Color=color;
% SHock
Data_to_use = MeanFR_AroundRip_all(OrderToUse(ShockCells),150:250);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
h=shadedErrorBar(linspace(-.2,.2,size(Data_to_use,2)) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) ,'-r',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=[.7 .3 .3]; h.edge(1).Color=color; h.edge(2).Color=color;
% Safe
Data_to_use = MeanFR_AroundRip_all(OrderToUse(SafeCells),150:250);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
h=shadedErrorBar(linspace(-.2,.2,size(Data_to_use,2)) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) ,'-r',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=[.3 .3 .7]; h.edge(1).Color=color; h.edge(2).Color=color;
ylim([0 .5]), ylabel('Firing rate (zscore)'), xlabel('time around ripple (s)')
f=get(gca,'Children'); legend([f([9 5 1])],'Shock','Safe','Mid');
makepretty_BM
set(f([9 5 1]),'Linewidth',3)
v=vline(0,'--k'); set(v,'LineWidth',2);


subplot(247)
makepretty_BM
MakeSpreadAndBoxPlot3_SB({RippleAmp(ShockCells),RippleAmp(MidCells),RippleAmp(SafeCells)},Cols2,X2_plo,Legends2,'showpoints',1,'paired',0)
ylabel('Firing rate around ripples (zscore)')

subplot(2,4,4)
clear col
col(:,1) = linspace(1,.5,size(MeanFR_AroundRip_all,1));
col(:,2) = ones(1,size(MeanFR_AroundRip_all,1))*0.5;
col(:,3) = linspace(.5,1,size(MeanFR_AroundRip_all,1));

for i=[ShockCells, SafeCells]
    plot(RippleAmp(i) ,PeakToUse(OrderToUse(i)) , '.' , 'MarkerSize' , 30 , 'Color' , [col(i,:)]), hold on
end
for i=MidCells
    plot(RippleAmp(i) ,PeakToUse(OrderToUse(i)) , '.' , 'MarkerSize' , 30 , 'Color' , [.5 .5 .5]), hold on
end
set(gca,'YDir','Reverse')

figure, [R,P,a,b,LINE]=PlotCorrelations_BM(RippleAmp,PeakToUse(OrderToUse), 'method' , 'pearson'); close
% Average position by time block
clear M
RippleBins = [min(RippleAmp):range(RippleAmp)/10:max(RippleAmp)];
for i=1:length(RippleBins)-1
    PosByRippleAmp(i) = mean(PeakToUse(find(and(RippleAmp>RippleBins(i),RippleAmp<=RippleBins(i+1)))));
end
plot(RippleBins(1:end-1),PosByRippleAmp,'color','k','linewidth',3)

xlabel('firing frequency in ripples (a.u.)'), ylabel('linearized distance')
f=get(gca,'Children'); legend([f(1)],['R = ' num2str(R) '     P = ' num2str(P)]);


subplot(2,4,8)
clear col
col(:,1) = linspace(1,.5,size(MeanFR_AroundRip_all,1));
col(:,2) = ones(1,size(MeanFR_AroundRip_all,1))*0.5;
col(:,3) = linspace(.5,1,size(MeanFR_AroundRip_all,1));

for i=[ShockCells, SafeCells]
    plot(RippleTiming(i) ,PeakToUse(OrderToUse(i)) , '.' , 'MarkerSize' , 30 , 'Color' , [col(i,:)]), hold on
end
for i=MidCells
    plot(RippleTiming(i) ,PeakToUse(OrderToUse(i)) , '.' , 'MarkerSize' , 30 , 'Color' , [.5 .5 .5]), hold on
end
set(gca,'YDir','Reverse')


figure, [R,P,a,b,LINE] =PlotCorrelations_BM(RippleTiming,PeakToUse(OrderToUse), 'method' , 'pearson'); close
% Average position by time block
clear M
RippleBins = [-50:10:50];
for i=1:length(RippleBins)-1
    PosByRippleTiming(i) = mean(PeakToUse(find(and(RippleTiming>RippleBins(i),RippleTiming<=RippleBins(i+1)))));
end
plot(RippleBins(1:end-1)+5,PosByRippleTiming,'color','k','linewidth',3)

xlabel('time in ripples (ms)'), ylabel('linearized distance')
f=get(gca,'Children'); legend([f(1)],['R = ' num2str(R) '     P = ' num2str(P)]);





