%%FindExampleLocalDown1
% 13.09.2019 KJ
%
% Infos
%   Examples figures as in Sirota 2005, but with :
%       - 1 local down states many global
%       - 1 global and many local
%       - half half
%   
%
% see
%     
%
%


clear

%% load

Dir = PathForExperimentsLocalDeltaDown;
p=4;
Dir.tetrodes{p} = [1 2 3];

    
disp(' ')
disp('****************************************************************')
cd(Dir.path{p})
disp(pwd)

clearvars -except Dir p
    
%params
binsize_mua = 2;
factorLFP = 0.195;


%NREM
[NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
NREM = CleanUpEpoch(NREM - TotalNoiseEpoch,1);

%PFC
load('ChannelsToAnalyse/PFCx_locations.mat')
channels_pfc = channels;
    
%Spikes
load('SpikeData.mat', 'S');
if ~isa(S,'tsdArray')
    S = tsdArray(S);
end
%Spike tetrode
load('SpikesToAnalyse/PFCx_tetrodes.mat')
NeuronTetrodes = numbers;
tetrodeChannelsCell = channels;
tetrodeChannels = [];
for tt=1:length(tetrodeChannelsCell)
    tetrodeChannels(tt) = channels_pfc(ismember(channels_pfc,tetrodeChannelsCell{tt}));
end
%only good tetrodes
tetrodeChannels =  tetrodeChannels(Dir.tetrodes{p});
NeuronTetrodes =  NeuronTetrodes(Dir.tetrodes{p});
tetrodeChannelsCell =  tetrodeChannelsCell(Dir.tetrodes{p});
nb_tetrodes = length(Dir.tetrodes{p});

all_neurons = [];
%select neurons
for tt=1:nb_tetrodes
    Stet{tt} = S(NeuronTetrodes{tt});
end


%LFP PFCx
labels_ch = cell(0);
PFC = cell(0);
for ch=1:length(tetrodeChannels)
    load(['LFPData/LFP' num2str(tetrodeChannels(ch)) '.mat'])
    PFC{ch} = LFP;
    clear LFP

    labels_ch{ch} = ['Ch ' num2str(tetrodeChannels(ch))];
end


%% delta and down

%down
load('DownState.mat', 'down_PFCx')
GlobalDown = and(down_PFCx,NREM);
load('LocalDownState.mat', 'localdown_PFCx')
AllDown_local = localdown_PFCx(Dir.tetrodes{p});

%deltas
for tt=1:nb_tetrodes
    AllDown_local{tt} = and(AllDown_local{tt},NREM);
    
    %distinguish local and global
    [~, ~, ~, idAlocal, ~] = GetIntersectionsEpochs(AllDown_local{tt}, GlobalDown);
    LocalDown{tt} = subset(AllDown_local{tt}, setdiff(1:length(Start(AllDown_local{tt})), idAlocal)');

    load('DeltaWavesChannels.mat', ['delta_ch_' num2str(tetrodeChannels(tt))])
    eval(['a = delta_ch_' num2str(tetrodeChannels(tt)) ';'])
    DeltaWavesTT{tt} = a;

    %global delta and other delta
    [~,GlobalDelta{tt}, ~,idGlobDelta,~] = GetIntersectionsEpochs(DeltaWavesTT{tt}, GlobalDown);
    OtherDelta{tt} = subset(DeltaWavesTT{tt}, setdiff(1:length(Start(DeltaWavesTT{tt})),idGlobDelta)');

    %Local delta and fake delta
    [~,LocalDelta{tt}, ~,idLocDelta,~] = GetIntersectionsEpochs(OtherDelta{tt}, LocalDown{tt});
    FakeDelta{tt} = subset(OtherDelta{tt}, setdiff(1:length(Start(OtherDelta{tt})),idLocDelta)');
end


%% Find good moments


%good 
goodlocal_1 = Start(LocalDelta{1});
goodlocal_2 = Start(LocalDelta{3});


%find examples in same window
maxdistance = 2e4; %2s
mindistance = 0.4e4; %2s
list_example = [];
for i=1:length(goodlocal_1)
    idx = find(abs(goodlocal_2 - goodlocal_1(i))<= maxdistance & abs(goodlocal_2 - goodlocal_1(i))>=mindistance);
    list_example = [list_example ; [repmat(i,length(idx),1) idx]];
end



%% Plot

%params plot
alpha = 0.2;
colorGlobal = 'b';
colorLocal = [0.8 0.8 0.8];
gap = [0,0];
offset = 0:2000:10000;

BarHeight = 1;
BarFraction = 0.8;
LineWidth = 4;

%colors
dc = distinguishable_colors(nb_tetrodes);

colorRaster = cell(length(S),1);
for tt=1:nb_tetrodes
    colori{tt} = dc(tt,:);
end


for j=1000:10:1500

    %Epoch of example
    starttime = min(goodlocal_1(list_example(j,1)),goodlocal_2(list_example(j,2))) - 2e4;
    endtime = starttime + 3e4;
    LitEpoch = intervalSet(starttime,endtime);

    %delta waves
    GlobalExample = and(GlobalDelta{1},LitEpoch);
    st_global  = Start(GlobalExample,'ms');
    end_global = End(GlobalExample,'ms');
    
    for tt=1:nb_tetrodes
        LocalExample = and(LocalDelta{tt},LitEpoch);
        st_local{tt}  = Start(LocalExample,'ms');
        end_local{tt} = End(LocalExample,'ms');
    end

    
    % figure
    figure, hold on
    subtightplot(2,1,1,gap), hold on
    %PFC

    for tt=1:length(PFC)
        Signal = Restrict(PFC{tt},LitEpoch);
        plot(Range(Signal,'ms'),Data(Signal) + offset(tt), 'color',colori{tt},'linewidth',2)
    end
    %options
    xlim([starttime endtime]/10),
    YL=ylim;
    for tt=1:nb_tetrodes
        for i=1:length(st_local{tt})
            x_rec = [st_local{tt}(i) end_local{tt}(i) end_local{tt}(i) st_local{tt}(i)];
            y_rec = [YL(1) YL(1) YL(2) YL(2)];
            pa=patch(x_rec,y_rec,colorLocal);
            set(pa,'FaceAlpha',alpha,'EdgeColor','w');
        end
    end
    for i=1:length(st_global)
        x_rec = [st_global(i) end_global(i) end_global(i) st_global(i)];
        y_rec = [YL(1) YL(1) YL(2) YL(2)];
        pa=patch(x_rec,y_rec,colorGlobal);
        set(pa,'FaceAlpha',alpha,'EdgeColor','w');
    end

    set(gca, 'xtick',[],'ytick',[])
    set(gca,'xcolor','w','ycolor','w')


    
    % Raster
    k=0;
    for tt=1:nb_tetrodes
        Sexmpl = Restrict(Stet{tt},LitEpoch);
        subtightplot(2,1,2,gap), hold on
        for n=1:length(Sexmpl)
          k = k+1;  
          sp = Range(Sexmpl{n}, 'ms');
          sx = [sp sp repmat(NaN, length(sp), 1)];
          sy = repmat([(k*BarHeight) (k*BarHeight + BarHeight *BarFraction) NaN], length(sp), 1);
          sx = reshape(sx', 1, length(sp)*3);
          sy = reshape(sy', 1, length(sp)*3);

          line(sx, sy, 'Color', colori{tt}, 'LineWidth', LineWidth);
          set(gca, 'ylim', [1 length(Sexmpl)+1]);

          hold on

        end
    end
    set(gca, 'ylim', [1 k+1], 'xlim', [starttime endtime]/10);

    for tt=1:nb_tetrodes
        for i=1:length(st_local{tt})
            x_rec = [st_local{tt}(i) end_local{tt}(i) end_local{tt}(i) st_local{tt}(i)];
            y_rec = [YL(1) YL(1) YL(2) YL(2)];
            pa=patch(x_rec,y_rec,colorLocal);
            set(pa,'FaceAlpha',alpha,'EdgeColor','w');
        end
    end
    for i=1:length(st_global)
        x_rec = [st_global(i) end_global(i) end_global(i) st_global(i)];
        y_rec = [YL(1) YL(1) YL(2) YL(2)];
        pa=patch(x_rec,y_rec,colorGlobal);
        set(pa,'FaceAlpha',alpha,'EdgeColor','w');
    end
    set(gca, 'xtick',[],'ytick',[])
    set(gca,'xcolor','w','ycolor','w')


    %scale bar
    line([endtime-0.25e4 endtime-0.05e4]/10,[3 3], 'color','k','LineWidth', 3)
    text((endtime-0.15e4)/10,2, '200 ms', 'HorizontalAlignment','center')
    
end













