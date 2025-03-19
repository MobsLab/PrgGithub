
clear all
Dir = PathForExperimentsERC('UMazePAG');
% mice_PAG_neurons = [905,906,911,994,1161,1162,1168,1182,1186,1230,1239];
mice_PAG_neurons = [905,911,994,1161,1162,1168,1186,1230,1239];
mm=1;

SpeedLim = 2;
window_around_rip = [0.05 0.05];
FR_Ripples_all=[];
FR_PreRipples_all=[];
Session_type={'Hab1','Hab2','Hab','Cond','SleepPre','SleepPost'};
for sess=1:length(Session_type); FR_mov_all{sess} = []; end

Cols = {[0 0 1],[.85, .325, .1],[.3 .3 .3],[1 0 0],[.5 .2 .55],[.2 .8 .2]};
Legends = {'Hab1','Hab2','Hab','Cond','PreRipples','Ripples'};
X=[1:6];

Cols2 = {[1 .5 .5],[.5 .5 1]};
Legends2 = {'Shock','Safe'};
X2=[1:2];

Binsize=.005e4;
figure


for ff = 1:length(Dir.name)
    if ismember(eval(Dir.name{ff}(6:end)),mice_PAG_neurons)
        mm
        
        cd(Dir.path{ff}{1})
        disp(Dir.path{ff}{1})
        
        clear Ripples FreezeEpoch LinPos StimEpoch NoiseEpoch Vtsd Q Spikes
        load('behavResources.mat'), LinPos = LinearDist;
        load('SpikeData.mat')
        [numNeurons, numtt, TT]=GetSpikesFromStructure('dHPC');
        Spikes = S(numNeurons);
        load('SWR.mat', 'tRipples')
        
        Q = MakeQfromS(Spikes,Binsize); % data from the conditionning session
        Q = tsd(Range(Q),nanzscore(full(Data(Q))));
        
        AfterStimEpoch = intervalSet(Start(StimEpoch) , Start(StimEpoch)+.1e4);          % if you put AfterStimEpoch = ...+3e4, no significativity
        if mm==8, StimEpoch = intervalSet([],[]); end
        try
            TotalNoiseEpoch = or(StimEpoch , NoiseEpoch);
        catch
            try
                TotalNoiseEpoch = NoiseEpoch;
            catch
                TotalNoiseEpoch = intervalSet([],[]);
            end
        end
        TotalNoiseEpoch = or(TotalNoiseEpoch , AfterStimEpoch);
        
        for sess=1:2
            try
                Epoch_to_use{1} = SessionEpoch.Hab;
            catch
                Epoch_to_use{1} = or(SessionEpoch.Hab1 , SessionEpoch.Hab2);
            end
            Epoch_to_use{2} = SessionEpoch.Cond1;
            for ss = 2:5
                try, Epoch_to_use{2} = or(Epoch_to_use{2},SessionEpoch.(['Cond' num2str(ss)])); end
            end
            
            MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
            MovEpoch = mergeCloseIntervals(MovEpoch,2*1e4)-FreezeEpoch;
            MovEpoch = MovEpoch-TotalNoiseEpoch;
            
            i=1;
            for neur=1:length(Spikes)
                try
                    [map_mov{sess}{mm}{neur}, mapNS_mov{sess}{mm}{neur}, stats{sess}{mm}{neur}, px{sess}{mm}{neur}, py{sess}{mm}{neur}, FR_pre{sess}{mm}(neur)] = PlaceField_DB(Spikes{neur}, Xtsd,...
                        Ytsd , 'PlotResults' , 0 , 'PlotPoisson' ,0 , 'epoch' , and(MovEpoch , Epoch_to_use{sess}));
                    if ~isempty(stats{sess}{mm}{neur})
                        if stats{sess}{mm}{neur}.spatialInfo>1
                            Place_Cells{sess}{mm}(i) = neur;
                            FR_mov{sess}{mm}(i) = FR_pre{sess}{mm}(neur);
                            i=i+1;
                        end
                    end
                end
            end
        end
        
        EPOCH = Epoch_to_use{2};
        
        Q_Study = Restrict(Q , EPOCH);
        Spikes_Study = Restrict(Spikes , EPOCH);
        Ripples_Study = Restrict(tRipples , EPOCH);
        
%         R=Range(Ripples_Study);
        %     Ripples = Restrict(Ripples , intervalSet(R(1) , R(1)+3600e4)); % to restrict to 1st hour of sleep
%         Ripples_Epoch = mergeCloseIntervals(intervalSet(Range(Ripples_Study)-window_around_rip(1)*1e4,Range(Ripples_Study)+window_around_rip(2)*1e4),0.1*1e4);
%         Ripples_Epoch = Ripples_Epoch-TotalNoiseEpoch;
        
%         Pre_Ripples_Epoch = mergeCloseIntervals(intervalSet(Range(Ripples_Study)-2*1e4,Range(Ripples_Study)-1.9*1e4),0.1*1e4);
%         Pre_Ripples_Epoch = Pre_Ripples_Epoch-TotalNoiseEpoch;
        
        

FreezeSafe = and(thresholdIntervals(LinPos,0.6,'Direction','Above') , FreezeEpoch);
Ripples_Epoch = mergeCloseIntervals(intervalSet(Range(Ripples_Study)-window_around_rip(1)*1e4,Range(Ripples_Study)+window_around_rip(2)*1e4),0.1*1e4);
Ripples_FreezeSafe = and(Ripples_Epoch , FreezeSafe);
Ripples_Epoch = Ripples_FreezeSafe-TotalNoiseEpoch;

Ripples_ts_FreezeSafe = Restrict(Ripples_Study , FreezeSafe-TotalNoiseEpoch);

Pre_Ripples_Epoch = mergeCloseIntervals(intervalSet(Range(Ripples_Study)-2*1e4,Range(Ripples_Study)-1.75*1e4),0.1*1e4);
Pre_Ripples_FreezeSafe = and(Pre_Ripples_Epoch , FreezeSafe)-Ripples_FreezeSafe;
Pre_Ripples_Epoch = Pre_Ripples_FreezeSafe-TotalNoiseEpoch;


        
        
        i=1;
        for neur=1:length(Spikes)
            try
                [~, ~, ~, ~, ~, FR_Ripples{mm}(i), ~, ~, ~] = PlaceField_DB(Spikes{neur}, Xtsd, Ytsd , 'PlotResults' , 0 , 'PlotPoisson' ,0 ,...
                    'epoch' , Ripples_Epoch);
            end
            try
                [~, ~, ~, ~, ~, FR_PreRipples{mm}(i), ~, ~, ~] = PlaceField_DB(Spikes{neur}, Xtsd, Ytsd , 'PlotResults' , 0 , 'PlotPoisson' ,0 ,...
                    'epoch' , Pre_Ripples_Epoch);
            end
            
            Spikes_FR_Pre_Ripples_Epoch{mm}(neur) = length(Restrict(Spikes{neur},Pre_Ripples_Epoch))./(sum(DurationEpoch(Pre_Ripples_Epoch))/1e4);
            Spikes_FR_Ripples_Epoch{mm}(neur) = length(Restrict(Spikes{neur},Ripples_Epoch))./(sum(DurationEpoch(Ripples_Epoch))/1e4);
            
            clear D; D=Data(Q);
            Q_neur{neur} = tsd(Range(Q) , D(:,neur));
            [M,T] = PlotRipRaw(Q_neur{neur},Range(Ripples_ts_FreezeSafe,'s'),1e3,0,0);
            MeanFR_AroundRip{mm}(neur,:) = M(:,2);
            
            i=i+1;
        end
        
        try, FR_Ripples_all = [FR_Ripples_all ; FR_Ripples{mm}']; end
        try, FR_PreRipples_all = [FR_PreRipples_all ; FR_PreRipples{mm}']; end
        Duration_epoch(5,mm) = sum(DurationEpoch(Ripples_Epoch))/1e4;
        Duration_epoch(6,mm) = sum(DurationEpoch(Pre_Ripples_Epoch))/1e4;
        
        mm=mm+1;
    end
end


MeanFR_AroundRip_all=[]; MeanFR_AroundRip_all2=[];
l=linspace(0,1,49);
clear HistData_FR FR_mov_corrected
for sess=1:2
    m=1;
    for mm=1:length(mice_PAG_neurons)
        n=1;
        for neur=Place_Cells{1}{mm}%1:length(stats{sess}{mm})%
            if and(~isempty(mapNS_mov{1}{mm}{neur}) , ~isempty(mapNS_mov{2}{mm}{neur}))
                U1 = find(mapNS_mov{1}{mm}{neur}.rate~=0); U2 = find(mapNS_mov{2}{mm}{neur}.rate~=0);
                if and(~isempty(U1) , ~isempty(U2))
                    
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
                        %                             FR_mov_corrected{sess}(m) = FR_mov_all{sess}(neur);
                        
                        if sess==2
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
    for sess=1:length(Session_type)
        [~,b{sess}]=max(HistData_FR{sess}'); [~,d{sess}]=sort(b{sess});
    end
end







figure
subplot(151), sess=2;
imagesc( linspace(0,1,100) , [1:size(HistData_FR{sess},1)] ,runmean([HistData_FR{sess}(d{2},:)]',2)')
caxis([0 .05])
xlabel('linear UMaze distance'), ylabel('HPC neurons no')
hline(20,'--w'), hline(size(MeanFR_AroundRip_all,1)-40,'--w')
makepretty_BM
colormap viridis
freezeColors

subplot(152)
imagesc(linspace(-250,250,size(MeanFR_AroundRip_all,2)) , [1:size(MeanFR_AroundRip_all,1)] , MeanFR_AroundRip_all(d{2},150:250))
xlabel('time around ripple (ms)'), yticklabels({''}), caxis([-.15 1]), xticks([-250 0 250])
makepretty_BM
hline(20,'--w'), hline(size(MeanFR_AroundRip_all,1)-40,'--w'), 
colormap viridis
freezeColors

subplot(2,5,3)
Data_to_use = MeanFR_AroundRip_all(d{2}(1:20),180:220);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
h=shadedErrorBar(linspace(-.2,.2,41) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) ,'-r',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=[.7 .3 .3]; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = MeanFR_AroundRip_all(d{2}(end-40:end),180:220);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
h=shadedErrorBar(linspace(-.2,.2,41) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) ,'-r',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=[.3 .3 .7]; h.edge(1).Color=color; h.edge(2).Color=color;
ylim([0 .5]), ylabel('Firing rate (zscore)'), xlabel('time around ripple (s)')
f=get(gca,'Children'); legend([f([5 1])],'Shock','Safe');
makepretty_BM
v=vline(0,'--r'); set(v,'LineWidth',2);

subplot(2,5,8)
makepretty_BM
MakeSpreadAndBoxPlot3_SB({nanmean(MeanFR_AroundRip_all(d{2}(1:20),[190:210])') nanmean(MeanFR_AroundRip_all(d{2}(end-40:end),[190:210])')},Cols2,X2,Legends2,'showpoints',1,'paired',0)
ylabel('Firing rate around ripples (zscore)')

subplot(4,5,[4 5 9 10 14 15])
col(:,1) = linspace(1,.5,size(MeanFR_AroundRip_all,1));
col(:,2) = ones(1,size(MeanFR_AroundRip_all,1))*0.5;
col(:,3) = linspace(.5,1,size(MeanFR_AroundRip_all,1));
[f,g]=max(HistData_FR{sess}(d{2},:)');
[c,e]=max(zscore(MeanFR_AroundRip_all(d{2},[190:207])'));
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
    M(i) =mean(g(find(and(e>(i-1)*2,e<=i*2)))/100);
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






%% other way
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
    
    % Sleep Pre
    clear Ripples FreezeEpoch LinPos StimEpoch NoiseEpoch Vtsd Spikes Q
    load(['RippleReactInfo_NewRipples_SleepPre_Mouse',num2str(MiceNumber(mm)),'.mat'])
    
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
    
    TotEpoch = intervalSet(0,max(Range(Vtsd)));
    
    Ripples_Epoch = mergeCloseIntervals(intervalSet(Range(Ripples)-window_around_rip(1)*1e4,Range(Ripples)+window_around_rip(2)*1e4),0.1*1e4);
    Ripples_Epoch = Ripples_Epoch-TotalNoiseEpoch;
    
    Ripples_ts = Restrict(Ripples , TotEpoch-TotalNoiseEpoch);

    Pre_Ripples_Epoch = mergeCloseIntervals(intervalSet(Range(Ripples)-2*1e4,Range(Ripples)-1.75*1e4),0.1*1e4);
    Pre_Ripples_Epoch = Pre_Ripples_Epoch-TotalNoiseEpoch;
    
    i=1;
    for neur=1:length(Spikes)
        try
            [~, ~, ~, ~, ~, FR_Ripples{mm}(i), ~, ~, ~] = PlaceField_DB(Spikes{neur}, Xtsd, Ytsd , 'PlotResults' , 0 , 'PlotPoisson' ,0 ,...
                'epoch' , Ripples_Epoch);
        end
        try
            [~, ~, ~, ~, ~, FR_PreRipples{mm}(i), ~, ~, ~] = PlaceField_DB(Spikes{neur}, Xtsd, Ytsd , 'PlotResults' , 0 , 'PlotPoisson' ,0 ,...
                'epoch' , Pre_Ripples_Epoch);
        end
        
        Spikes_FR_Pre_Ripples_FreezeSafe{mm}(neur) = length(Restrict(Spikes{neur},Pre_Ripples_Epoch))./(sum(DurationEpoch(Pre_Ripples_Epoch))/1e4);
        Spikes_FR_Ripples_FreezeSafe{mm}(neur) = length(Restrict(Spikes{neur},Ripples_Epoch))./(sum(DurationEpoch(Ripples_Epoch))/1e4);
        
        clear D; D=Data(Q);
        Q_neur{neur} = tsd(Range(Q) , D(:,neur));
        [M,T] = PlotRipRaw(Q_neur{neur},Range(Ripples_ts,'s'),1e3,0,0);
        MeanFR_AroundRip{mm}(neur,:) = M(:,2);
        
        i=i+1;
    end
    
    try, FR_Ripples_all = [FR_Ripples_all ; FR_Ripples{mm}']; end
    try, FR_PreRipples_all = [FR_PreRipples_all ; FR_PreRipples{mm}']; end
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
    for sess=1:length(Session_type)
        [~,b{sess}]=max(HistData_FR{sess}'); [~,d{sess}]=sort(b{sess});
    end
end
