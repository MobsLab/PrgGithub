
%% look at place fields
clear all
MiceNumber = [905,911,994,1161,1162,1168,1186,1230,1239];
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data

SpeedLim = 2;
window_around_rip = [0.05 0.05];
FR_Ripples_all=[];
FR_PreRipples_all=[];
Session_type={'Hab1','Hab2','Hab','Cond','SleepPre'};
for sess=1:length(Session_type); FR_mov_all{sess} = []; end

Cols = {[0 0 1],[.85, .325, .1],[.3 .3 .3],[1 0 0],[.5 .2 .55],[.2 .8 .2]};
Legends = {'Hab1','Hab2','Hab','Cond','PreRipples','Ripples'};
X=[1:6];

Cols2 = {[1 .5 .5],[.5 .5 1]};
Legends2 = {'Shock','Safe'};
X2=[1:2];

Binsize=.005e4;


for mm=1:length(MiceNumber)
    % moving epochs
    for sess=1:length(Session_type)
        mm
        
        clear Ripples FreezeEpoch LinPos StimEpoch NoiseEpoch Vtsd Spikes Q
        load(['RippleReactInfo_NewRipples_' Session_type{sess} '_Mouse',num2str(MiceNumber(mm)),'.mat'])
        
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
        
        MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
        MovEpoch = mergeCloseIntervals(MovEpoch,2*1e4)-FreezeEpoch;
        MovEpoch = MovEpoch-TotalNoiseEpoch;
        
        i=1;
        for neur=1:length(Spikes)
            try
                [map_mov{sess}{mm}{neur}, mapNS_mov{sess}{mm}{neur}, stats{sess}{mm}{neur}, px{sess}{mm}{neur}, py{sess}{mm}{neur}, FR_pre{sess}{mm}(neur)] = PlaceField_DB(Spikes{neur}, Xtsd,...
                    Ytsd , 'PlotResults' , 0 , 'PlotPoisson' ,0 , 'epoch' , MovEpoch);
                if ~isempty(stats{sess}{mm}{neur})
                    if stats{sess}{mm}{neur}.spatialInfo>1
                        Place_Cells{sess}{mm}(i) = neur;
                        FR_mov{sess}{mm}(i) = FR_pre{sess}{mm}(neur);
                        i=i+1;
                    end
                end
            end
        end
        
        LinPos_Mov{sess}{mm} = Restrict(LinPos , MovEpoch);
        h=histogram(Data(LinPos_Mov{sess}{mm}),'BinLimits',[0 1],'NumBins',100);
        HistData_LinPos{sess}(mm,:)= h.Values./sum(h.Values);
        
        try, FR_mov_all{sess} = [FR_mov_all{sess} ; FR_mov{sess}{mm}']; end
        Duration_epoch(sess,mm) = sum(DurationEpoch(MovEpoch))/1e4;
        
        % firing rate
        clear Ra, Ra = Range(Vtsd);
        for neur=1:length(Spikes)
            if sess==5
                Spikes_FR_all{sess}{mm}(neur) = length(Spikes{neur})./((Ra(end)-Ra(1))/1e4);
            else
                Spikes_FR_all{sess}{mm}(neur) = length(Restrict(Spikes{neur},MovEpoch))./(sum(DurationEpoch(MovEpoch))/1e4);
            end
        end
        
    end
    
    % Cond
    clear Ripples FreezeEpoch LinPos StimEpoch NoiseEpoch Vtsd Spikes Q
    load(['RippleReactInfo_NewRipples_Cond_Mouse',num2str(MiceNumber(mm)),'.mat'])
    
    Q = MakeQfromS(Spikes,Binsize); % data from the conditionning session
    Q = tsd(Range(Q),nanzscore(full(Data(Q))));
    
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
    
    FreezeSafe = and(thresholdIntervals(LinPos,0.6,'Direction','Above') , FreezeEpoch);
    Ripples_Epoch = mergeCloseIntervals(intervalSet(Range(Ripples)-window_around_rip(1)*1e4,Range(Ripples)+window_around_rip(2)*1e4),0.1*1e4);
    Ripples_FreezeSafe = and(Ripples_Epoch , FreezeSafe);
    Ripples_FreezeSafe = Ripples_FreezeSafe-TotalNoiseEpoch;
    
    Ripples_ts_FreezeSafe = Restrict(Ripples , FreezeSafe-TotalNoiseEpoch);

    Pre_Ripples_Epoch = mergeCloseIntervals(intervalSet(Range(Ripples)-2*1e4,Range(Ripples)-1.75*1e4),0.1*1e4);
    Pre_Ripples_FreezeSafe = and(Pre_Ripples_Epoch , FreezeSafe)-Ripples_FreezeSafe;
    Pre_Ripples_FreezeSafe = Pre_Ripples_FreezeSafe-TotalNoiseEpoch;
    
    i=1;
    for neur=1:length(Spikes)
        try
            [~, ~, ~, ~, ~, FR_Ripples{mm}(i), ~, ~, ~] = PlaceField_DB(Spikes{neur}, Xtsd, Ytsd , 'PlotResults' , 0 , 'PlotPoisson' ,0 ,...
                'epoch' , Ripples_FreezeSafe);
        end
        try
            [~, ~, ~, ~, ~, FR_PreRipples{mm}(i), ~, ~, ~] = PlaceField_DB(Spikes{neur}, Xtsd, Ytsd , 'PlotResults' , 0 , 'PlotPoisson' ,0 ,...
                'epoch' , Pre_Ripples_FreezeSafe);
        end
        
        Spikes_FR_Pre_Ripples_FreezeSafe{mm}(neur) = length(Restrict(Spikes{neur},Pre_Ripples_FreezeSafe))./(sum(DurationEpoch(Pre_Ripples_FreezeSafe))/1e4);
        Spikes_FR_Ripples_FreezeSafe{mm}(neur) = length(Restrict(Spikes{neur},Ripples_FreezeSafe))./(sum(DurationEpoch(Ripples_FreezeSafe))/1e4);
        
        clear D; D=Data(Q);
        Q_neur{neur} = tsd(Range(Q) , D(:,neur));
        [M,T] = PlotRipRaw(Q_neur{neur},Range(Ripples_ts_FreezeSafe,'s'),1e3,0,0);
        MeanFR_AroundRip{mm}(neur,:) = M(:,2);
        
        i=i+1;
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


MeanFR_AroundRip_all=[]; MeanFR_AroundRip_all2=[];
l=linspace(0,1,49);
clear HistData_FR FR_mov_corrected
for sess=1:4%length(Session_type)
    m=1;
    for mm=1:length(MiceNumber)
        n=1;
        for neur=Place_Cells{3}{mm}%1:length(stats{sess}{mm})%
            if and(and(~isempty(mapNS_mov{1}{mm}{neur}) , ~isempty(mapNS_mov{2}{mm}{neur})) , and(~isempty(mapNS_mov{3}{mm}{neur}) , ~isempty(mapNS_mov{4}{mm}{neur})))
                U1 = find(mapNS_mov{1}{mm}{neur}.rate~=0); U2 = find(mapNS_mov{2}{mm}{neur}.rate~=0);
                U3 = find(mapNS_mov{3}{mm}{neur}.rate~=0); U4 = find(mapNS_mov{4}{mm}{neur}.rate~=0);
                if and(and(~isempty(U1) , ~isempty(U2)) , and(~isempty(U3) , ~isempty(U4)))
                    
                    % linearized coordinate Hab
                    clear U, U=find(mapNS_mov{sess}{mm}{neur}.rate~=0);
                    if ~isempty(U) % no spikes
                        
                        [Y,X] = ind2sub(size(mapNS_mov{sess}{mm}{neur}.rate) , U);
                        [~,~,t_hab] = distance2curve([.15 .15 .85 .85; 0 .96 .96 0]',[l(X-7);l(Y-7)]','linear');
                        [C,IA,IC] = unique(t_hab);
                        for j=1:length(C)
                            FiringRATE{sess}{mm}{neur}(j,:) = [C(j) sum(mapNS_mov{sess}{mm}{neur}.rate(U(IC==j)))];
                        end
                        clear a b
                        [a,b]=sort(FiringRATE{sess}{mm}{neur}(:,1));
                        FiringRATE{sess}{mm}{neur}=FiringRATE{sess}{mm}{neur}(b,:);
                        for bin=1:100
                            ind=find(and(FiringRATE{sess}{mm}{neur}(:,1)>=((bin-1)/100) , FiringRATE{sess}{mm}{neur}(:,1)<(bin/100)));
                            if ~isempty(ind)
                                HistData_FR{sess}(m,bin) = sum(FiringRATE{sess}{mm}{neur}(ind,2));
                            end
                        end
                        HistData_FR{sess}(m,:) = HistData_FR{sess}(m,:)./sum(HistData_FR{sess}(m,:));
                        FR_mov_corrected{sess}(m) = FR_mov_all{sess}(neur);
                        
                        if sess==4
                            FR_PreRipples_corrected(m) = FR_PreRipples_all(neur);
                            FR_Ripples_corrected(m) = FR_Ripples_all(neur);
                            MeanFR_AroundRip_all = [MeanFR_AroundRip_all ; MeanFR_AroundRip{mm}(neur,:)];
                            %                                 MeanFR_AroundRip_all2 = [MeanFR_AroundRip_all2 ; MeanFR_AroundRip2{mm}(neur,:)];
                        end
                        
                        m=m+1;
                        n=n+1;
                    end
                end
            end
        end
        disp(mm)
    end
end



try
    clear b d
    for sess=1:4%length(Session_type)
        [~,b{sess}]=max(HistData_FR{sess}'); [~,d{sess}]=sort(b{sess});
    end
end

try
    l=linspace(0,1,49);
    clear HistData_FR FR_mov_corrected
    for sess=1:length(Session_type)
        m=1;
        for mm=1:length(MiceNumber)
            n=1;
            for neur=1:length(stats{sess}{mm})%Place_Cells{1}{mm}%
                if and(and(~isempty(mapNS_mov{1}{mm}{neur}) , ~isempty(mapNS_mov{2}{mm}{neur})) , and(~isempty(mapNS_mov{3}{mm}{neur}) , ~isempty(mapNS_mov{4}{mm}{neur})))
                    U1 = find(mapNS_mov{1}{mm}{neur}.rate~=0); U2 = find(mapNS_mov{2}{mm}{neur}.rate~=0);
                    U3 = find(mapNS_mov{3}{mm}{neur}.rate~=0); U4 = find(mapNS_mov{4}{mm}{neur}.rate~=0);
                    if and(and(~isempty(U1) , ~isempty(U2)) , and(~isempty(U1) , ~isempty(U2)))
                        
                        % linearized coordinate Hab
                        clear U, U=find(mapNS_mov{sess}{mm}{neur}.rate~=0);
                        if ~isempty(U) % no spikes
                            
                            [Y,X] = ind2sub(size(mapNS_mov{sess}{mm}{neur}.rate) , U);
                            [~,~,t_hab] = distance2curve([.15 .15 .85 .85; 0 .96 .96 0]',[l(X-7);l(Y-7)]','linear');
                            [C,IA,IC] = unique(t_hab);
                            for j=1:length(C)
                                FiringRATE{sess}{mm}{neur}(j,:) = [C(j) sum(mapNS_mov{sess}{mm}{neur}.rate(U(IC==j)))];
                            end
                            clear a b
                            [a,b]=sort(FiringRATE{sess}{mm}{neur}(:,1));
                            FiringRATE{sess}{mm}{neur}=FiringRATE{sess}{mm}{neur}(b,:);
                            for bin=1:100
                                ind=find(and(FiringRATE{sess}{mm}{neur}(:,1)>=((bin-1)/100) , FiringRATE{sess}{mm}{neur}(:,1)<(bin/100)));
                                if ~isempty(ind)
                                    HistData_FR{sess}(m,bin) = sum(FiringRATE{sess}{mm}{neur}(ind,2));
                                end
                            end
                            HistData_FR{sess}(m,:) = HistData_FR{sess}(m,:)./sum(HistData_FR{sess}(m,:));
                            
                            FR_mov_corrected{sess}(m) = FR_mov_all{sess}(neur);
                            if sess==4
                                FR_PreRipples_corrected(m) = FR_PreRipples_all(neur);
                                FR_Ripples_corrected(m) = FR_Ripples_all(neur);
                                MeanFR_AroundRip_all = [MeanFR_AroundRip_all ; MeanFR_AroundRip{mm}(neur,:)];
                            end
                        else
                            HistData_FR{sess}(m,:) = 0;
                            FR_mov_corrected{sess}(m) = 0;
                            
                            if sess==4
                                FR_PreRipples_corrected(m) = 0;
                                FR_Ripples_corrected(m) = 0;
                                MeanFR_AroundRip_all = [MeanFR_AroundRip_all ; 0];
                            end
                        end
                        m=m+1;
                        n=n+1;
                    end
                end
            end
            disp(mm)
        end
    end
end

try
    clear b2 d2
    for sess=1:4%length(Session_type)
        [~,b2{sess}]=max(HistData_FR{sess}'); [~,d2{sess}]=sort(b2{sess});
    end
end

for sess=1:length(Session_type)
    m=1;
    for mm=1:length(MiceNumber)
        n=1;
        for neur=Place_Cells{3}{mm}%1:length(stats{sess}{mm})%
            if and(and(~isempty(mapNS_mov{1}{mm}{neur}) , ~isempty(mapNS_mov{2}{mm}{neur})) , and(~isempty(mapNS_mov{3}{mm}{neur}) , ~isempty(mapNS_mov{4}{mm}{neur})))
                U1 = find(mapNS_mov{1}{mm}{neur}.rate~=0); U2 = find(mapNS_mov{2}{mm}{neur}.rate~=0);
                U3 = find(mapNS_mov{3}{mm}{neur}.rate~=0); U4 = find(mapNS_mov{4}{mm}{neur}.rate~=0);
                if and(and(~isempty(U1) , ~isempty(U2)) , and(~isempty(U1) , ~isempty(U2)))
                    
                    HistData_Spikes_PreRipples(m) = Spikes_FR_Pre_Ripples_FreezeSafe{mm}(neur);
                    HistData_Spikes_Ripples(m) = Spikes_FR_Ripples_FreezeSafe{mm}(neur);
                    HistData_Spikes_all{sess}(m) = Spikes_FR_all{sess}{mm}(neur);
                    
                    m=m+1;
                    
                end
            end
        end
    end
end

for sess=1:length(Session_type)
    m=1;
    for mm=1:length(MiceNumber)
        n=1;
        for neur=1:length(Spikes_FR_all{sess}{mm})%
            if and(and(~isempty(mapNS_mov{1}{mm}{neur}) , ~isempty(mapNS_mov{2}{mm}{neur})) , and(~isempty(mapNS_mov{3}{mm}{neur}) , ~isempty(mapNS_mov{4}{mm}{neur})))
                U1 = find(mapNS_mov{1}{mm}{neur}.rate~=0); U2 = find(mapNS_mov{2}{mm}{neur}.rate~=0);
                U3 = find(mapNS_mov{3}{mm}{neur}.rate~=0); U4 = find(mapNS_mov{4}{mm}{neur}.rate~=0);
                if and(and(~isempty(U1) , ~isempty(U2)) , and(~isempty(U1) , ~isempty(U2)))
                    
                    HistData_Spikes_all_allcells{sess}(m) = Spikes_FR_all{sess}{mm}(neur);
                    HistData_Spikes_PreRipples_allcells(m) = Spikes_FR_Pre_Ripples_FreezeSafe{mm}(neur);
                    HistData_Spikes_Ripples_allcells(m) = Spikes_FR_Ripples_FreezeSafe{mm}(neur);
                    m=m+1;
                    
                end
            end
        end
    end
end



%% figures
% 1) example
sess=3; mm=1; neur=1;
figure
subplot(3,1,1:2)
imagesc(map_mov{sess}{mm}{neur}.rate), axis xy
title([num2str(round(stats{sess}{mm}{neur}.spatialInfo,2)) ' / ' num2str(round(stats{sess}{mm}{neur}.sparsity,2)) ' / ' num2str(round(stats{sess}{mm}{neur}.specificity,2)) ' / ' num2str(neur)])
sizeMap=62; Maze_Frame_BM, hold on
a=area([23.5 40],[46 46]);
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;
axis off

subplot(313)
plot(FiringRATE{sess}{mm}{neur}(:,1) , FiringRATE{sess}{mm}{neur}(:,2))
xlabel('linearized maze distance'), ylabel('firing rate (#/s)')
makepretty_BM


% 2) epoch for PC identification
figure
MakeSpreadAndBoxPlot_BM({Duration_epoch(1,:) Duration_epoch(2,:) Duration_epoch(3,:) Duration_epoch(4,:) Duration_epoch(6,:) Duration_epoch(5,:)}...
    , {[0 0 1],[.85, .325, .1],[.3 .3 .3],[1 0 0],[.5 .2 .55],[.2 .8 .2]},[1:6],{'Hab1','Hab2','Hab','Cond','PreRipples','Ripples'},1,0)
ylabel('duration to identify place cells (s)')


% 3) Hab1 & Hab2
figure
subplot(141), sess=1;
imagesc( linspace(0,1,100) , [1:size(HistData_FR{sess},1)] ,runmean([HistData_FR{sess}(d{sess},:)]',2)')
caxis([0 .05])
colormap viridis
ylabel('HPC neurons no'), xlabel('linear UMaze distance')
vline(.2,'--r')
makepretty
title('Hab 1')

subplot(142), sess=2;
imagesc( linspace(0,1,100) , [1:size(HistData_FR{sess},1)] ,runmean([HistData_FR{sess}(d{1},:)]',2)')
caxis([0 .05])
xlabel('linear UMaze distance'), yticklabels({''})
vline(.2,'--r')
makepretty
title('Hab2 on Hab1 order')

subplot(243)
PlotCorrelations_BM(b{1}/100,b{2}/100)
axis square
line([0 1],[0 1],'LineStyle','--','Color','r','LineWidth',2)
xlabel('Place cells peak, Hab1 (linear dist)'), ylabel('Place cells peak, Hab2 (linear dist)')

subplot(247)
imagesc(linspace(0,1,100) , linspace(0,1,100) , SmoothDec(HistData_FR{1}(d{1},:).*HistData_FR{2}(d{1},:),1)), caxis([0 5e-4]), colormap viridis
axis square
line([0 1],[0 1],'LineStyle','--','Color','r','LineWidth',2)
xlabel('Place cells, Hab1 (linear dist)'), ylabel('Place cells, Hab2 (linear dist)')
makepretty

subplot(144)
imagesc(linspace(0,1,100) , [1:size(HistData_FR{2},1)] ,runmean([HistData_FR{2}(d{2},:)]',2)')
caxis([0 .05])
xlabel('linear UMaze distance'), yticklabels({''})
vline(.2,'--r')
makepretty
title('Hab2 on Hab2 order')


% 4) Hab & Cond
figure
subplot(141), sess=3;
imagesc( linspace(0,1,100) , [1:size(HistData_FR{sess},1)] ,runmean([HistData_FR{sess}(d{sess},:)]',2)')
caxis([0 .05])
colormap viridis
ylabel('HPC neurons no'), xlabel('linear UMaze distance')
vline(.2,'--r')
title('Hab')
makepretty

subplot(142), sess=4;
imagesc( linspace(0,1,100) , [1:size(HistData_FR{sess},1)] ,runmean([HistData_FR{sess}(d{3},:)]',2)')
caxis([0 .05])
xlabel('linear UMaze distance'), yticklabels({''})
vline(.2,'--r')
title('Cond on Hab order')
makepretty

subplot(243)
PlotCorrelations_BM(b{3}/100,b{4}/100)
axis square
line([0 1],[0 1],'LineStyle','--','Color','r','LineWidth',2)
xlabel('Place cells peak, Hab (linear dist)'), ylabel('Place cells peak, Cond (linear dist)')

subplot(247)
imagesc(linspace(0,1,100) , linspace(0,1,100) , SmoothDec(HistData_FR{3}(d{3},:).*HistData_FR{4}(d{3},:),1)), caxis([0 5e-4]), colormap viridis
axis square
line([0 1],[0 1],'LineStyle','--','Color','r','LineWidth',2)
xlabel('Place cells, Hab (linear dist)'), ylabel('Place cells, Cond (linear dist)')
makepretty

subplot(144)
imagesc(linspace(0,1,100) , [1:size(HistData_FR{4},1)] ,runmean([HistData_FR{4}(d{4},:)]',2)')
caxis([0 .05])
xlabel('linear UMaze distance'), yticklabels({''})
vline(.2,'--r')
title('Cond on Cond order')
makepretty


% 5) sum up of distributions
figure
[a,b]=max(HistData_FR{3}');
plot([1:length(b)] , runmean(sort(b/100),3) , 'k','LineWidth',3), hold on
[a,b]=max(HistData_FR{4}');
plot([1:length(b)] , runmean(sort(b/100),3) , 'r','LineWidth',3)
hold on
line([0 length(b)],[0 1],'LineStyle','--','Color',[.5 .5 .5],'LineWidth',3)
xlabel('HPC neuron no'), ylabel('linearized Maze distance')
axis square, box off
xlim([0 length(b)])
legend('Habituation','Conditionning','Homogeneous distribution')


% 6) Occupancy
figure
subplot(231)
Data_to_use = HistData_LinPos{1};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,1,100) , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
Data_to_use = HistData_LinPos{2};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,100) , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
color= [.85, .325, .1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
ylabel('occupancy (a.u.)')
f=get(gca,'Children'); legend([f([5 1])],'Hab1','Hab2');
vline(.2,'--r')
makepretty_BM

subplot(232)
Data_to_use = HistData_LinPos{3};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,100) , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
color= [.3 .3 .3]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = HistData_LinPos{4};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,1,100) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
f=get(gca,'Children'); legend([f([5 1])],'Hab','Cond');
vline(.2,'--r')
makepretty_BM
ylim([0 .12])

subplot(233)
Data_to_use = HistData_LinPos{6};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,100) , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
color= [.5 .2 .55]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = HistData_LinPos{5};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,100) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
color= [.2 .8 .2]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
f=get(gca,'Children'); legend([f([5 1])],'PreRipples','Ripples');
vline(.2,'--r')
makepretty_BM
ylim([0 .25])


subplot(234)
plot(linspace(0,1,100) , runmean(sum(HistData_FR{1}),3) , 'b')
hold on
plot(linspace(0,1,100) , runmean(sum(HistData_FR{2}),3) , 'Color' , [.85, .325, .1])
ylabel('PC peak at this location')
makepretty_BM

subplot(235)
plot(linspace(0,1,100) , runmean(sum(HistData_FR{3}),3) , 'Color' , [.3 .3 .3])
hold on
plot(linspace(0,1,100) , runmean(sum(HistData_FR{4}),3) , 'r')
makepretty_BM


% 7) Firing rate
figure
subplot(161), sess=2;
imagesc( linspace(0,1,100) , [1:size(HistData_FR{sess},1)] ,runmean([HistData_FR{sess}(d{3},:)]',2)')
caxis([0 .05])
colormap viridis
ylabel('HPC neurons no'), xlabel('linear UMaze distance')
vline(.2,'--r')
title('Hab2 on Hab order')
makepretty

subplot(162)
plot(FR_mov_corrected{2}(d{3})-FR_mov_corrected{1}(d{3}) , 'Color' , 'k' , 'LineWidth' , 2)
box off
ylabel('firing rate difference (Hab2-Hab1)'), hline(0,'--r')
xlim([0 size(FR_mov_corrected{1},2)]), ylim([-6 6])
camroll(-90)

subplot(163), sess=4;
imagesc( linspace(0,1,100) , [1:size(HistData_FR{sess},1)] ,runmean([HistData_FR{sess}(d{3},:)]',2)')
caxis([0 .05])
colormap viridis
ylabel('HPC neurons no'), xlabel('linear UMaze distance')
vline(.2,'--r')
title('Cond on Hab order')
makepretty

subplot(164)
plot(FR_mov_corrected{4}(d{3})-FR_mov_corrected{3}(d{3}) , 'Color' , 'k' , 'LineWidth' , 2)
box off
ylabel('firing rate difference (Cond-Hab)'), hline(0,'--r')
xlim([0 size(FR_mov_corrected{1},2)]), ylim([-6 6])
camroll(-90)

subplot(165)
plot(FR_Ripples_corrected(d{3})-FR_mov_corrected{4}(d{3}) , 'Color' , 'k' , 'LineWidth' , 2)
box off
ylabel('firing rate difference (Ripples-Cond)'), hline(0,'--r')
xlim([0 size(FR_mov_corrected{1},2)]), ylim([-6 10])
camroll(-90)

subplot(166)
plot(FR_Ripples_corrected(d{3})-FR_PreRipples_corrected(d{3}) , 'Color' , 'k' , 'LineWidth' , 2)
box off
ylabel('firing rate difference (Ripples-PreRipples)'), hline(0,'--r')
xlim([0 size(FR_mov_corrected{1},2)]), ylim([-20 20])
camroll(-90)


% 8) Firing rate in box plot
figure
MakeSpreadAndBoxPlot3_SB({FR_mov_corrected{1} FR_mov_corrected{2} FR_mov_corrected{3} FR_mov_corrected{4} FR_PreRipples_corrected FR_Ripples_corrected} ,...
    Cols,X,Legends,'showpoints',0,'paired',0)
ylabel('Firing rate (a.u.)')


% 9) Shock and safe zone reactivations
[a,b]=max(HistData_FR{3}'); ind_shock_hab=find(b<20); ind_safe_hab=find(b>60);
[a,b]=max(HistData_FR{4}'); ind_shock_cond=find(b<20); ind_safe_cond=find(b>60);

figure
MakeSpreadAndBoxPlot3_SB({FR_Ripples_corrected(ind_shock_hab)./FR_PreRipples_corrected(ind_shock_hab) FR_Ripples_corrected(ind_safe_hab)./FR_PreRipples_corrected(ind_safe_hab)},...
    Cols2,X2,Legends2,'showpoints',1,'paired',0)
set(gca,'Yscale','log')
hline(1,'--r')
ylabel('Ratio reactivation Ripples/PreRipples')


% 10) subsampling shock zone in Hab
edit PlaceCells_Replay_Subsampling_FreezingSafe_BM.m





%% firing rate other way
figure
clear A B C D
A = HistData_Spikes_all{1}./HistData_Spikes_all{5}; %A(C>50)=NaN;
B = HistData_Spikes_all{2}./HistData_Spikes_all{5}; %C(C>50)=NaN;
C = HistData_Spikes_all{3}./HistData_Spikes_all{5}; %C(C>50)=NaN;
D = HistData_Spikes_all{4}./HistData_Spikes_all{5}; %D(D>30)=NaN;

subplot(121)
MakeSpreadAndBoxPlot3_SB({A B C D},{[0 0 1],[.85, .325, .1],[.3 .3 .3],[1 0 0]},[1:4],{'Hab1','Hab2','Hab','Cond'},'showpoints',1,'paired',0)
set(gca,'Yscale','log')
hline(1,'--r'), ylabel('ratio movement/sleep')
title('Place cells')

clear A B C D
A = HistData_Spikes_all_allcells{1}./HistData_Spikes_all_allcells{5}; %A(C>50)=NaN;
B = HistData_Spikes_all_allcells{2}./HistData_Spikes_all_allcells{5}; %C(C>50)=NaN;
C = HistData_Spikes_all_allcells{3}./HistData_Spikes_all_allcells{5}; %C(C>50)=NaN;
D = HistData_Spikes_all_allcells{4}./HistData_Spikes_all_allcells{5}; %D(D>30)=NaN;

subplot(122)
MakeSpreadAndBoxPlot3_SB({A B C D},{[0 0 1],[.85, .325, .1],[.3 .3 .3],[1 0 0]},[1:4],{'Hab1','Hab2','Hab','Cond'},'showpoints',1,'paired',0)
set(gca,'Yscale','log')
hline(1,'--r'), ylabel('ratio movement/sleep')
title('All cells')



figure

clear A B
A = HistData_Spikes_Ripples./HistData_Spikes_all{5}; %A(C>50)=NaN;
B = HistData_Spikes_Ripples_allcells./HistData_Spikes_all_allcells{5}; %C(C>50)=NaN;

MakeSpreadAndBoxPlot3_SB({A B},{[.3 .3 .3],[.6 .6 .6]},[1:2],{'PC','All cells'},'showpoints',1,'paired',0)
set(gca,'Yscale','log')
hline(1,'--r')
ylabel('ratio ripples/sleep')



figure
subplot(321)
Data_to_use = HistData_LinPos{3};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,100) , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
color= [.3 .3 .3]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;

subplot(323)
plot(linspace(0,1,length(HistData_Spikes_all{3})) , HistData_Spikes_all{3}(d{3})./HistData_Spikes_all{5}(d{3}))
set(gca,'Yscale','log')
hline(1,'--r')

subplot(325)
plot(linspace(0,1,length(HistData_Spikes_all_allcells{3})) , HistData_Spikes_all_allcells{3}(d2{3})./HistData_Spikes_all_allcells{5}(d2{3}))
set(gca,'Yscale','log')
hline(1,'--r')


subplot(322)
Data_to_use = HistData_LinPos{4};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,100) , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
color= [1 0 0]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
ylim([0 .15])

subplot(324)
plot(linspace(0,1,length(HistData_Spikes_all{4})) , HistData_Spikes_all{4}(d{3})./HistData_Spikes_all{5}(d{3}))
hold on
plot(linspace(0,1,length(HistData_Spikes_Ripples)) , HistData_Spikes_Ripples(d{3})./HistData_Spikes_all{5}(d{3}))
plot(linspace(0,1,length(HistData_Spikes_Ripples)) , HistData_Spikes_PreRipples(d{3})./HistData_Spikes_all{5}(d{3}))
plot(linspace(0,1,length(HistData_Spikes_Ripples)) , HistData_Spikes_Ripples(d{3})./HistData_Spikes_PreRipples(d{3}))
set(gca,'Yscale','log')
hline(1,'--r')

subplot(326)
plot(linspace(0,1,length(HistData_Spikes_all_allcells{4})) , HistData_Spikes_all_allcells{4}(d2{3})./HistData_Spikes_all_allcells{5}(d2{3}))
hold on
plot(linspace(0,1,length(HistData_Spikes_Ripples_allcells)) , HistData_Spikes_Ripples_allcells(d2{3})./HistData_Spikes_all_allcells{5}(d2{3}))
plot(linspace(0,1,length(HistData_Spikes_Ripples_allcells)) , HistData_Spikes_PreRipples_allcells(d2{3})./HistData_Spikes_all_allcells{5}(d2{3}))
plot(linspace(0,1,length(HistData_Spikes_Ripples_allcells)) , HistData_Spikes_Ripples_allcells(d2{3})./HistData_Spikes_PreRipples_allcells(d2{3}))
set(gca,'Yscale','log')
hline(1,'--r')



figure
clear A B
A = HistData_Spikes_all{4}(d{3}(1:40))./HistData_Spikes_all{5}(d{3}(1:40));
B = HistData_Spikes_all{4}(d{3}(end-80:end))./HistData_Spikes_all{5}(d{3}(end-80:end));

subplot(221)
MakeSpreadAndBoxPlot3_SB({A B},Cols2,X2,Legends2,'showpoints',1,'paired',0)
set(gca,'Yscale','log')
hline(1,'--r')
ylim([1e-2 1e2])

clear A B
A = HistData_Spikes_all_allcells{4}(d2{3}(1:128))./HistData_Spikes_all_allcells{5}(d2{3}(1:128));
B = HistData_Spikes_all_allcells{4}(d2{3}(end-256:end))./HistData_Spikes_all_allcells{5}(d2{3}(end-256:end));

subplot(222)
MakeSpreadAndBoxPlot3_SB({A B},Cols2,X2,Legends2,'showpoints',1,'paired',0)
set(gca,'Yscale','log')
hline(1,'--r')
ylim([1e-2 1e2])


clear A B
A = HistData_Spikes_Ripples(d{3}(1:40))./HistData_Spikes_all{5}(d{3}(1:40)); sum(A==0)/length(A), A(A==0)=NaN;
B = HistData_Spikes_Ripples(d{3}(end-80:end))./HistData_Spikes_all{5}(d{3}(end-80:end)); sum(B==0)/length(B), B(B==0)=NaN;

subplot(223)
MakeSpreadAndBoxPlot3_SB({A B},Cols2,X2,Legends2,'showpoints',1,'paired',0)
set(gca,'Yscale','log')
hline(1,'--r')
ylim([1e-2 1e2])

clear A B
A = HistData_Spikes_Ripples_allcells(d2{3}(1:128))./HistData_Spikes_all_allcells{5}(d2{3}(1:128)); sum(A==0)/length(A), A(A==0)=NaN;
B = HistData_Spikes_Ripples_allcells(d2{3}(end-256:end))./HistData_Spikes_all_allcells{5}(d2{3}(end-256:end)); sum(B==0)/length(B), B(B==0)=NaN;

subplot(224)
MakeSpreadAndBoxPlot3_SB({A B},Cols2,X2,Legends2,'showpoints',1,'paired',0)
set(gca,'Yscale','log')
hline(1,'--r')
ylim([1e-2 1e2])



figure

clear A B C D
A = log10(HistData_Spikes_all{4}(d{3}(1:40))./HistData_Spikes_all{5}(d{3}(1:40)));
B = log10(HistData_Spikes_Ripples(d{3}(1:40))./HistData_Spikes_all{5}(d{3}(1:40))); B(B==-Inf)=NaN;
C = log10(HistData_Spikes_all{4}(d{3}(end-80:end))./HistData_Spikes_all{5}(d{3}(end-80:end)));
D = log10(HistData_Spikes_Ripples(d{3}(end-80:end))./HistData_Spikes_all{5}(d{3}(end-80:end))); D(D==-Inf)=NaN;

subplot(121)
[~,~,a_shock,b_shock]=PlotCorrelations_BM(A , B , 'Color' , [1 .5 .5]);
hold on
[~,~,a_safe,b_safe]=PlotCorrelations_BM(C , D , 'Color' , [.5 .5 1]);
xlim([-2.5 2.5]), ylim([-2.5 2.5]), vline(0), hline(0)
axis square

subplot(122)
PlotCorrelations_BM(HistData_Spikes_all_allcells{4}(d{3})./HistData_Spikes_all_allcells{5}(d{3}) , HistData_Spikes_Ripples_allcells(d{3})./HistData_Spikes_all_allcells{5}(d{3}))
hold on
PlotCorrelations_BM(HistData_Spikes_all_allcells{4}(d2{3}(1:128))./HistData_Spikes_all_allcells{5}(d2{3}(1:128)) , HistData_Spikes_Ripples_allcells(d2{3}(1:128))./HistData_Spikes_all_allcells{5}(d2{3}(1:128)) , 'Color' , 'r')
set(gca,'Yscale','log'), set(gca,'Xscale','log')
axis square



figure
subplot(121)

clear A B
A = log(HistData_Spikes_Ripples(d{3}(1:40))./HistData_Spikes_PreRipples(d{3}(1:40)));
B = log(HistData_Spikes_Ripples(d{3}(end-80:end))./HistData_Spikes_PreRipples(d{3}(end-80:end)));

MakeSpreadAndBoxPlot3_SB({A B},Cols2,X2,Legends2,'showpoints',1,'paired',0)

subplot(122)

clear A B
A = (HistData_Spikes_Ripples(d{3}(1:40))-HistData_Spikes_PreRipples(d{3}(1:40)))./(HistData_Spikes_Ripples(d{3}(1:40))+HistData_Spikes_PreRipples(d{3}(1:40)));
B = (HistData_Spikes_Ripples(d{3}(end-80:end))-HistData_Spikes_PreRipples(d{3}(end-80:end)))./(HistData_Spikes_Ripples(d{3}(end-80:end))+HistData_Spikes_PreRipples(d{3}(end-80:end)));

MakeSpreadAndBoxPlot3_SB({A B},Cols2,X2,Legends2,'showpoints',1,'paired',0)




figure
subplot(121)

clear A B
A = log(HistData_Spikes_PreRipples(d{3}(1:40)));
B = log(HistData_Spikes_Ripples(d{3}(1:40)));

MakeSpreadAndBoxPlot3_SB({A B},Cols2,X2,Legends2,'showpoints',0,'paired',1)


subplot(122)

clear A B
A = log(HistData_Spikes_PreRipples(d{3}(end-80:end)));
B = log(HistData_Spikes_Ripples(d{3}(end-80:end)));

MakeSpreadAndBoxPlot3_SB({A B},Cols2,X2,Legends2,'showpoints',0,'paired',1)




figure
subplot(131), sess=3;
imagesc( linspace(0,1,100) , [1:size(HistData_FR{sess},1)] ,runmean([HistData_FR{sess}(d{sess},:)]',2)')
caxis([0 .05])
colormap viridis
ylabel('HPC neurons no'), xlabel('linear UMaze distance')
vline(.2,'--r')
title('Hab')
makepretty

subplot(132), sess=4;
imagesc( linspace(0,1,100) , [1:size(HistData_FR{sess},1)] ,runmean([HistData_FR{sess}(d{3},:)]',2)')
caxis([0 .05])
xlabel('linear UMaze distance'), yticklabels({''})
vline(.2,'--r')
title('Cond on Hab order')
makepretty

subplot(133), sess=4;
clear A, A = log10(HistData_Spikes_Ripples(d{3})./HistData_Spikes_PreRipples(d{3})); A(or(A==Inf,A==-Inf))=[];
plot(runmean_BM(A,10) , 'Color' , [.4 .5 .6]), hold on
clear A, A = log10(HistData_Spikes_Ripples(d{3})./HistData_Spikes_all{5}(d{3})); A(or(A==Inf,A==-Inf))=[];
plot(runmean_BM(A,10) , 'Color' , [.6 .5 .4])
makepretty_BM
ylabel('firing rate during safe side ripples (log scale)'), hline(0,'--r')
xlim([0 size(FR_mov_corrected{1},2)]), ylim([-.5 1])
camroll(-90)
legend('normalization by pre-ripples epoch','normalization by sleep epoch')





%% Based on cond order
% Place cells
figure
subplot(131), sess=3;
imagesc( linspace(0,1,100) , [1:size(HistData_FR{sess},1)] ,runmean([HistData_FR{sess}(d{4},:)]',2)')
caxis([0 .05])
colormap viridis
ylabel('HPC neurons no'), xlabel('linear UMaze distance')
vline(.2,'--r')
title('Hab')
makepretty

subplot(132), sess=4;
imagesc( linspace(0,1,100) , [1:size(HistData_FR{sess},1)] ,runmean([HistData_FR{sess}(d{4},:)]',2)')
caxis([0 .05])
xlabel('linear UMaze distance'), yticklabels({''})
vline(.2,'--r')
title('Cond on Hab order')
makepretty

subplot(133), sess=4;
clear A, A = log10(HistData_Spikes_Ripples(d{4})./HistData_Spikes_PreRipples(d{4})); A(or(A==Inf,A==-Inf))=[];
plot(runmean_BM(A,10) , 'Color' , [.4 .5 .6]), hold on
clear A, A = log10(HistData_Spikes_Ripples(d{4})./HistData_Spikes_all{5}(d{4})); A(or(A==Inf,A==-Inf))=[];
plot(runmean_BM(A,10) , 'Color' , [.6 .5 .4])
makepretty_BM
ylabel('firing rate during safe side ripples (log scale)'), hline(0,'--r')
xlim([0 size(FR_mov_corrected{1},2)]), ylim([-.5 1])
camroll(-90)
legend('normalization by pre-ripples epoch','normalization by sleep epoch')



figure

subplot(121)

clear A B
A = log10(HistData_Spikes_Ripples(d{4}(1:20))./HistData_Spikes_PreRipples(d{4}(1:20))); A(A==or(Inf,-Inf))=NaN;
B = log10(HistData_Spikes_Ripples(d{4}(end-30:end))./HistData_Spikes_PreRipples(d{4}(end-30:end))); B(B==or(Inf,-Inf))=NaN;

MakeSpreadAndBoxPlot3_SB({A B},Cols2,X2,Legends2,'showpoints',1,'paired',0)
ylabel('firing rate during safe side ripples (log scale)')
title('normalization by pre-ripples epoch')

subplot(122)

clear A B
A = log10(HistData_Spikes_Ripples(d{4}(1:20))./HistData_Spikes_all{5}(d{4}(1:20))); A(A==or(Inf,-Inf))=NaN;
B = log10(HistData_Spikes_Ripples(d{4}(end-30:end))./HistData_Spikes_all{5}(d{4}(end-30:end))); B(B==or(Inf,-Inf))=NaN;

MakeSpreadAndBoxPlot3_SB({A B},Cols2,X2,Legends2,'showpoints',1,'paired',0)
title('normalization by sleep epoch')




% correlations
figure

subplot(131)
clear A B
A = log10(HistData_Spikes_all{4}(d{4})./HistData_Spikes_all{5}(d{4}));
B = log10(HistData_Spikes_Ripples(d{4})./HistData_Spikes_all{5}(d{4}));
ind = or(or(A==Inf,A==-Inf) , or(B==Inf,B==-Inf));
A(ind)=[];
B(ind)=[];

[~,~,a_all,b_all]=PlotCorrelations_BM(A , B , 'Color' , 'k');
axis square
xlabel('firing rate during moving cond'), ylabel('firing rate during safe freezing ripples')
xlim([-2.5 2.5]), ylim([-2.5 2.5])
vline(0,'--r'), hline(0,'--r')


subplot(232)
clear A B
A = log10(HistData_Spikes_all{4}(d{3}(1:20))./HistData_Spikes_all{5}(d{3}(1:20)));
B = log10(HistData_Spikes_Ripples(d{3}(1:20))./HistData_Spikes_all{5}(d{3}(1:20)));
ind = or(or(A==Inf,A==-Inf) , or(B==Inf,B==-Inf));
A(ind)=[];
B(ind)=[];

[~,~,a,b]=PlotCorrelations_BM(A , B , 'Color' , [1 .5 .5]);

clear A B
A = log10(HistData_Spikes_all{4}(d{3}(end-40:end))./HistData_Spikes_all{5}(d{3}(end-40:end)));
B = log10(HistData_Spikes_Ripples(d{3}(end-40:end))./HistData_Spikes_all{5}(d{3}(end-40:end)));
ind = or(or(A==Inf,A==-Inf) , or(B==Inf,B==-Inf));
A(ind)=[];
B(ind)=[];

[~,~,a,b]=PlotCorrelations_BM(A , B , 'Color' , [.5 .5 1]);

xlim([-2.5 2.5]), ylim([-2.5 2.5]), vline(0), hline(0)
axis square
xlabel('firing rate during moving cond'), ylabel('firing rate during safe freezing ripples')
vline(0,'--r'), hline(0,'--r')
title('Shock / Safe identified on Hab sessions')


subplot(235)
clear A B
A = log10(HistData_Spikes_all{4}(d{4}(1:20))./HistData_Spikes_all{5}(d{4}(1:20)));
B = log10(HistData_Spikes_Ripples(d{4}(1:20))./HistData_Spikes_all{5}(d{4}(1:20)));
ind = or(or(A==Inf,A==-Inf) , or(B==Inf,B==-Inf));
A(ind)=[];
B(ind)=[];

[~,~,a_shock,b_shock]=PlotCorrelations_BM(A , B , 'Color' , [1 .5 .5]);

clear A B
A = log10(HistData_Spikes_all{4}(d{4}(end-40:end))./HistData_Spikes_all{5}(d{4}(end-40:end)));
B = log10(HistData_Spikes_Ripples(d{4}(end-40:end))./HistData_Spikes_all{5}(d{4}(end-40:end)));
ind = or(or(A==Inf,A==-Inf) , or(B==Inf,B==-Inf));
A(ind)=[];
B(ind)=[];

[~,~,a_safe,b_safe]=PlotCorrelations_BM(A , B , 'Color' , [.5 .5 1]);

xlim([-2.5 2.5]), ylim([-2.5 2.5]), vline(0), hline(0)
axis square
xlabel('firing rate during moving cond'), ylabel('firing rate during safe freezing ripples')
vline(0,'--r'), hline(0,'--r')
title('Shock / Safe identified on Cond sessions')



subplot(255)
A = log10(HistData_Spikes_all{4}(d{3}(1:40))./HistData_Spikes_all{5}(d{3}(1:40)));
B = log10(HistData_Spikes_all{4}(d{3}(end-80:end))./HistData_Spikes_all{5}(d{3}(end-80:end)));
MakeSpreadAndBoxPlot3_SB({A B},Cols2,X2,Legends2,'showpoints',1,'paired',0)
ylabel('firing rate during moving')

subplot(2,5,10)
A = log10(HistData_Spikes_all{4}(d{4}(1:40))./HistData_Spikes_all{5}(d{4}(1:40)));
B = log10(HistData_Spikes_all{4}(d{4}(end-80:end))./HistData_Spikes_all{5}(d{4}(end-80:end)));
MakeSpreadAndBoxPlot3_SB({A B},Cols2,X2,Legends2,'showpoints',1,'paired',0)
ylabel('firing rate during moving')



% All cells
figure
subplot(131), sess=3;
imagesc( linspace(0,1,100) , [1:size(HistData_FR{sess},1)] ,runmean([HistData_FR{sess}(d2{3},:)]',2)')
caxis([0 .05])
colormap viridis
ylabel('HPC neurons no'), xlabel('linear UMaze distance')
vline(.2,'--r')
title('Hab')
makepretty

subplot(132), sess=4;
imagesc( linspace(0,1,100) , [1:size(HistData_FR{sess},1)] ,runmean([HistData_FR{sess}(d2{3},:)]',2)')
caxis([0 .05])
xlabel('linear UMaze distance'), yticklabels({''})
vline(.2,'--r')
title('Cond on Hab order')
makepretty

subplot(133), sess=4;
clear A, A = log10(HistData_Spikes_Ripples_allcells(d2{3})./HistData_Spikes_PreRipples_allcells(d2{3})); A(or(A==Inf,A==-Inf))=[];
plot(runmean_BM(A,50) , 'Color' , [.4 .5 .6]), hold on
clear A, A = log10(HistData_Spikes_Ripples_allcells(d2{3})./HistData_Spikes_all_allcells{5}(d2{3})); A(or(A==Inf,A==-Inf))=[];
plot(runmean_BM(A,50) , 'Color' , [.6 .5 .4])
makepretty_BM
ylabel('firing rate during safe side ripples (log scale)'), hline(0,'--r')
xlim([0 size(FR_mov_corrected{1},2)]), ylim([-.5 1])
camroll(-90)
legend('normalization by pre-ripples epoch','normalization by sleep epoch')


figure
subplot(131), sess=3;
imagesc( linspace(0,1,100) , [1:size(HistData_FR{sess},1)] ,runmean([HistData_FR{sess}(d2{4},:)]',2)')
caxis([0 .05])
colormap viridis
ylabel('HPC neurons no'), xlabel('linear UMaze distance')
vline(.2,'--r')
title('Hab')
makepretty

subplot(132), sess=4;
imagesc( linspace(0,1,100) , [1:size(HistData_FR{sess},1)] ,runmean([HistData_FR{sess}(d2{4},:)]',2)')
caxis([0 .05])
xlabel('linear UMaze distance'), yticklabels({''})
vline(.2,'--r')
title('Cond on Hab order')
makepretty

subplot(133), sess=4;
clear A, A = log10(HistData_Spikes_Ripples_allcells(d2{4})./HistData_Spikes_PreRipples_allcells(d2{4})); A(or(A==Inf,A==-Inf))=[];
plot(runmean_BM(A,50) , 'Color' , [.4 .5 .6]), hold on
clear A, A = log10(HistData_Spikes_Ripples_allcells(d2{4})./HistData_Spikes_all_allcells{5}(d2{4})); A(or(A==Inf,A==-Inf))=[];
plot(runmean_BM(A,50) , 'Color' , [.6 .5 .4])
makepretty_BM
ylabel('firing rate during safe side ripples (log scale)'), hline(0,'--r')
xlim([0 size(FR_mov_corrected{1},2)]), ylim([-.5 1])
camroll(-90)
legend('normalization by pre-ripples epoch','normalization by sleep epoch')


figure
subplot(121)
clear A B
A = log10(HistData_Spikes_Ripples_allcells(d2{4}(1:60))./HistData_Spikes_PreRipples_allcells(d2{4}(1:60))); A(or(A==Inf,A==-Inf))=[];
B = log10(HistData_Spikes_Ripples_allcells(d2{4}(end-100:end))./HistData_Spikes_PreRipples_allcells(d2{4}(end-100:end))); B(or(B==Inf,B==-Inf))=NaN;
MakeSpreadAndBoxPlot3_SB({A B},Cols2,X2,Legends2,'showpoints',1,'paired',0)
ylabel('firing rate during safe side ripples (log scale)')
title('normalization by pre-ripples epoch')

subplot(122)
clear A B
A = log10(HistData_Spikes_Ripples_allcells(d2{4}(1:60))./HistData_Spikes_all_allcells{5}(d2{4}(1:60))); A(or(A==Inf,A==-Inf))=[];
B = log10(HistData_Spikes_Ripples_allcells(d2{4}(end-100:end))./HistData_Spikes_all_allcells{5}(d2{4}(end-100:end))); B(or(B==Inf,B==-Inf))=NaN;
MakeSpreadAndBoxPlot3_SB({A B},Cols2,X2,Legends2,'showpoints',1,'paired',0)
title('normalization by sleep epoch')


figure

subplot(131)
clear A B
A = log10(HistData_Spikes_all_allcells{4}(d2{4})./HistData_Spikes_all_allcells{5}(d2{4}));
B = log10(HistData_Spikes_Ripples_allcells(d2{4})./HistData_Spikes_all_allcells{5}(d2{4}));
ind = or(or(A==Inf,A==-Inf) , or(B==Inf,B==-Inf));
A(ind)=[];
B(ind)=[];

[~,~,a_all_allcells,b_all_allcells]=PlotCorrelations_BM(A , B , 'Color' , 'k');
axis square
xlabel('firing rate during moving cond'), ylabel('firing rate during safe freezing ripples')
xlim([-2.5 2.5]), ylim([-2.5 2.5])
vline(0,'--r'), hline(0,'--r')


subplot(232)
clear A B
A = log10(HistData_Spikes_all_allcells{4}(d2{3}(1:20))./HistData_Spikes_all_allcells{5}(d2{3}(1:20)));
B = log10(HistData_Spikes_Ripples_allcells(d2{3}(1:20))./HistData_Spikes_all_allcells{5}(d2{3}(1:20)));
ind = or(or(A==Inf,A==-Inf) , or(B==Inf,B==-Inf));
A(ind)=[];
B(ind)=[];

[~,~,a,b]=PlotCorrelations_BM(A , B , 'Color' , [1 .5 .5]);

clear A B
A = log10(HistData_Spikes_all_allcells{4}(d2{3}(end-40:end))./HistData_Spikes_all_allcells{5}(d2{3}(end-40:end)));
B = log10(HistData_Spikes_Ripples_allcells(d2{3}(end-40:end))./HistData_Spikes_all_allcells{5}(d2{3}(end-40:end)));
ind = or(or(A==Inf,A==-Inf) , or(B==Inf,B==-Inf));
A(ind)=[];
B(ind)=[];

[~,~,a,b]=PlotCorrelations_BM(A , B , 'Color' , [.5 .5 1]);

xlim([-2.5 2.5]), ylim([-2.5 2.5]), vline(0), hline(0)
axis square
xlabel('firing rate during moving cond'), ylabel('firing rate during safe freezing ripples')
vline(0,'--r'), hline(0,'--r')
title('Shock / Safe identified on Hab sessions')


subplot(235)
clear A B
A = log10(HistData_Spikes_all_allcells{4}(d2{4}(1:20))./HistData_Spikes_all_allcells{5}(d2{4}(1:20)));
B = log10(HistData_Spikes_Ripples_allcells(d2{4}(1:20))./HistData_Spikes_all_allcells{5}(d2{4}(1:20)));
ind = or(or(A==Inf,A==-Inf) , or(B==Inf,B==-Inf));
A(ind)=[];
B(ind)=[];

[~,~,a_shock,b_shock]=PlotCorrelations_BM(A , B , 'Color' , [1 .5 .5]);

clear A B
A = log10(HistData_Spikes_all_allcells{4}(d2{4}(end-40:end))./HistData_Spikes_all_allcells{5}(d2{4}(end-40:end)));
B = log10(HistData_Spikes_Ripples_allcells(d2{4}(end-40:end))./HistData_Spikes_all_allcells{5}(d2{4}(end-40:end)));
ind = or(or(A==Inf,A==-Inf) , or(B==Inf,B==-Inf));
A(ind)=[];
B(ind)=[];

[~,~,a_safe,b_safe]=PlotCorrelations_BM(A , B , 'Color' , [.5 .5 1]);

xlim([-2.5 2.5]), ylim([-2.5 2.5]), vline(0), hline(0)
axis square
xlabel('firing rate during moving cond'), ylabel('firing rate during safe freezing ripples')
vline(0,'--r'), hline(0,'--r')
title('Shock / Safe identified on Cond sessions')



subplot(255)
A = log10(HistData_Spikes_all_allcells{4}(d2{3}(1:120))./HistData_Spikes_all_allcells{5}(d2{3}(1:120)));
B = log10(HistData_Spikes_all_allcells{4}(d2{3}(end-240:end))./HistData_Spikes_all_allcells{5}(d2{3}(end-240:end)));
MakeSpreadAndBoxPlot3_SB({A B},Cols2,X2,Legends2,'showpoints',1,'paired',0)
ylabel('firing rate during moving')

subplot(2,5,10)
A = log10(HistData_Spikes_all_allcells{4}(d2{4}(1:120))./HistData_Spikes_all_allcells{5}(d2{4}(1:120)));
B = log10(HistData_Spikes_all_allcells{4}(d2{4}(end-240:end))./HistData_Spikes_all_allcells{5}(d2{4}(end-240:end)));
MakeSpreadAndBoxPlot3_SB({A B},Cols2,X2,Legends2,'showpoints',1,'paired',0)
ylabel('firing rate during moving')






%%

figure
subplot(151), sess=4;
imagesc( linspace(0,1,100) , [1:size(HistData_FR{sess},1)] ,HistData_FR{sess}(d{4},:))
caxis([0 .05])
xlabel('linear UMaze distance'), ylabel('HPC neurons no')
hline(20,'--w'), hline(size(MeanFR_AroundRip_all,1)-40,'--w')
makepretty_BM
colormap viridis
freezeColors

subplot(152)
imagesc(linspace(-250,250,size(MeanFR_AroundRip_all,2)) , [1:size(MeanFR_AroundRip_all,1)] , MeanFR_AroundRip_all(d{4},190:207))
xlabel('time around ripple (ms)'), yticklabels({''}), caxis([-.15 1]), xticks([-250 0 250])
makepretty_BM
hline(20,'--w'), hline(size(MeanFR_AroundRip_all,1)-40,'--w'), 
colormap viridis
freezeColors

subplot(253)
Data_to_use = MeanFR_AroundRip_all(d{4}(1:20),180:220);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
h=shadedErrorBar(linspace(-.2,.2,41) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) ,'-r',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=[.7 .3 .3]; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = MeanFR_AroundRip_all(d{4}(end-40:end),180:220);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
h=shadedErrorBar(linspace(-.2,.2,41) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) ,'-r',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=[.3 .3 .7]; h.edge(1).Color=color; h.edge(2).Color=color;
ylim([0 .5]), ylabel('Firing rate (zscore)'), xlabel('time around ripple (s)')
f=get(gca,'Children'); legend([f([5 1])],'Shock','Safe');
makepretty_BM
v=vline(0,'--r'); set(v,'LineWidth',2);

subplot(258)
makepretty_BM
MakeSpreadAndBoxPlot3_SB({nanmean(MeanFR_AroundRip_all(d{4}(1:20),[190:210])') nanmean(MeanFR_AroundRip_all(d{4}(end-40:end),[190:210])')},Cols2,X2,Legends2,'showpoints',1,'paired',0)
ylabel('Firing rate around ripples (zscore)')

subplot(4,5,[4 5 9 10 14 15])
col(:,1) = linspace(1,.5,size(MeanFR_AroundRip_all,1));
col(:,2) = ones(1,size(MeanFR_AroundRip_all,1))*0.5;
col(:,3) = linspace(.5,1,size(MeanFR_AroundRip_all,1));
[f,g]=max(HistData_FR{sess}(d{4},:)');
[c,e]=max(zscore(MeanFR_AroundRip_all(d{4},[190:207])'));
for i=[1:20 90:130]%size(MeanFR_AroundRip_all,1)
    plot((e(i)/18-.5)*100 ,1-g(i)/100 , '.' , 'MarkerSize' , 50 , 'Color' , [col(i,:)]), hold on
end
for i=[21:89]%size(MeanFR_AroundRip_all,1)
    plot((e(i)/18-.5)*100 ,1-g(i)/100 , '.' , 'MarkerSize' , 50 , 'Color' , [.5 .5 .5]), hold on
end
figure, [R,P,a,b,LINE]=PlotCorrelations_BM((e/18-.5)*100 ,g/100, 'method' , 'pearson'); close
l = [xlim ylim]; 
clear M
for i=1:9
    M(i) = mean(g(find(and(e>(i-1)*2,e<=i*2)))/100);
end
M2 = interp1(linspace(0,1,9) , M , linspace(0,1,100));
makepretty_BM
line([LINE(1,1) LINE(1,2)] , [LINE(2,2) LINE(2,1)] , 'Color' , [0 0 0] , 'LineWidth' , 5)
xlabel('time in ripples (ms)'), ylabel('linearized distance')
f=get(gca,'Children'); legend([f(1)],['R = ' num2str(R) '     P = ' num2str(P)]);
yticks([0:.1:1]), yticklabels({'1','0.9','0.8','0.7','0.6','0.5','0.4','0.3','0.2','0.1','0'})

subplot(4,5,19:20)
imagesc(M2)
colormap(col);
xticklabels({''}), yticklabels({''})
caxis([.53 .9050])
xlabel('average decoded position')








