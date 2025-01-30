%%ScriptMakeIDTetrodeLocalDown
% 06.09.2019 KJ
%
% Infos
%   create ID figures on tetrodes for lacal down analysis
%
% see
%

clear
Dir = PathForExperimentsLocalDeltaDown;
Dir = PathForExperimentsTonesLocalDown;
Dir = PathForExperimentsShamLocalDown;

for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p


    %params
    binsize_mua = 5*10; %5ms
    minDurationDown = 75;
    windowsize_density = 60e4; %60s  
    t_before = -0.5e4;
    t_after = 0.5e4;
    binsize_met = 5;
    nbBins_met  = 300;
    binsize_cc = 5; %10ms
    nb_binscc = 200;


    %% load

    %night duration and tsd zt
    load('behavResources.mat', 'NewtsdZT')
    load('IdFigureData2.mat', 'night_duration')

    %NREM
    [NREM, ~, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;

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
    nb_tetrodes = length(numbers);
    NeuronTetrodes = numbers;
    tetrodeChannelsCell = channels;
    tetrodeChannels = [];
    for tt=1:nb_tetrodes
        tetrodeChannels(tt) = channels_pfc(ismember(channels_pfc,tetrodeChannelsCell{tt}));
    end
    %pyr or int
    try
        load('NeuronClassification', 'UnitID')
    catch
        load('WFIdentit', 'UnitID')
    end

    %hemisphere and spikes
    if exist('SpikesToAnalyse/PFCx_r_Neurons.mat','file')==2
        hsp = 1;
        load('SpikesToAnalyse/PFCx_r_Neurons.mat')
        neurons_right = number;
        MUA_r = MakeQfromS(S(neurons_right), binsize_mua);
        MUA_r = tsd(Range(MUA_r), sum(full(Data(MUA_r)),2));

        load('SpikesToAnalyse/PFCx_l_Neurons.mat')
        neurons_left = number;
        MUA_l = MakeQfromS(S(neurons_left), binsize_mua);
        MUA_l = tsd(Range(MUA_l), sum(full(Data(MUA_l)),2));

        %down
        GlobalDown_r = FindDownKJ(MUA_r, 'low_thresh', 0.5, 'minDuration', minDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
        GlobalDown_r = and(GlobalDown_r,NREM);
        st_down_r = Start(GlobalDown_r);

        GlobalDown_l = FindDownKJ(MUA_l, 'low_thresh', 0.5, 'minDuration', minDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
        GlobalDown_l = and(GlobalDown_l,NREM);
        st_down_l = Start(GlobalDown_l);

        %infos
        fr.nrem.all = mean(Data(Restrict(MUA_r,NREM)))*(1e4/binsize_mua);
        fr.nrem.all = mean(Data(Restrict(MUA_r,Wake)))*(1e4/binsize_mua);
        Qfr = MakeQfromS(S(neurons_right), 60e4);
        Fr_all.t = Range(Qfr);
        Fr_all.y = sum(full(Data(Qfr)),2)/60;

        %homeostasis
        [~, ~, Hstat.global_r] = DensityOccupation_KJ(GlobalDown_r, 'homeostat',1, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
        [~, ~, Hstat.global_l] = DensityOccupation_KJ(GlobalDown_l, 'homeostat',1, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);

    else
        hsp=0;
        load('SpikesToAnalyse/PFCx_Neurons.mat')
        all_neurons = number;
        MUA = MakeQfromS(S(all_neurons), binsize_mua);
        MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));
        %down
        GlobalDown = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
        GlobalDown = and(GlobalDown,NREM);
        st_down = Start(GlobalDown);

        %infos
        fr.nrem.all = mean(Data(Restrict(MUA,NREM)))*(1e4/binsize_mua);
        fr.wake.all = mean(Data(Restrict(MUA,Wake)))*(1e4/binsize_mua);
        Qfr = MakeQfromS(S(all_neurons), 60e4);
        Fr.all.t = Range(Qfr);
        Fr.all.y = sum(full(Data(Qfr)),2)/60;

        %homeostasis
        [~, ~, Hstat.global] = DensityOccupation_KJ(GlobalDown, 'homeostat',2, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);

    end


    %% for each tetrodes
    for tt=1:nb_tetrodes


        %% hemisphere - for homeostasis
        if hsp %both hemisphere
            if ~exist('InfoLFP','var')
                load('LFPData/InfoLFP.mat')
            end
            hemisphere = lower(InfoLFP.hemisphere{InfoLFP.channel==tetrodeChannels(tt)}(1));
            if strcmpi(hemisphere,'r')
                Hstat.global = Hstat.global_r;
                global_neurons = neurons_right;
                %global firing rates
                fr.nrem.all = mean(Data(Restrict(MUA_r,NREM)))*(1e4/binsize_mua);
                fr.wake.all = mean(Data(Restrict(MUA_r,Wake)))*(1e4/binsize_mua);
                %down
                st_down = Start(GlobalDown_r);
            elseif strcmpi(hemisphere,'l')
                Hstat.global = Hstat.global_r;
                global_neurons = neurons_left;
                %global firing rates
                fr.nrem.all = mean(Data(Restrict(MUA_l,NREM)))*(1e4/binsize_mua);
                fr.wake.all = mean(Data(Restrict(MUA_l,Wake)))*(1e4/binsize_mua);
                %down
                st_down = Start(GlobalDown_l);
            end
        else
            global_neurons = all_neurons;
            %global firing rates
            fr.nrem.all = mean(Data(Restrict(MUA,NREM)))*(1e4/binsize_mua);
            fr.wake.all = mean(Data(Restrict(MUA,Wake)))*(1e4/binsize_mua);
            %down
            st_down = Start(GlobalDown);
        end

        %firing rate vector
        Qfr = MakeQfromS(S(global_neurons), 60e4);
        Fr.all.t = Range(Qfr);
        Fr.all.y = sum(full(Data(Qfr)),2)/60;


        %% local down states
        local_neurons{tt} = NeuronTetrodes{tt};
        %MUA & down
        MUA_local{tt} = MakeQfromS(S(local_neurons{tt}), binsize_mua);
        MUA_local{tt} = tsd(Range(MUA_local{tt}), sum(full(Data(MUA_local{tt})),2));
        AllDown_local{tt} = FindDownKJ(MUA_local{tt}, 'low_thresh', 0.5, 'minDuration', minDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
        AllDown_local{tt} = and(AllDown_local{tt},NREM);


        %% infos
        channels_pfc = tetrodeChannelsCell{tt}; 
        nb_neurons_tet.all(tt) = length(local_neurons{tt});
        nb_neurons_tet.int(tt) = sum(UnitID(local_neurons{tt})<0);
        nb_neurons_tet.pyr(tt) = sum(UnitID(local_neurons{tt})>0);

        fr.nrem.local{tt} = mean(Data(Restrict(MUA_local{tt},NREM)))*(1e4/binsize_mua);
        fr.wake.local{tt} = mean(Data(Restrict(MUA_local{tt},Wake)))*(1e4/binsize_mua);
        Qfr = MakeQfromS(S(local_neurons{tt}), 60e4);
        Fr.local.t{tt} = Range(Qfr);
        Fr.local.y{tt} = sum(full(Data(Qfr)),2)/60;

        textbox_str = {Dir.name{p}, Dir.date{p}, ['Tetrode ' num2str(tt)], ['channel ' num2str(tetrodeChannelsCell{tt})], ...
                        [num2str(nb_neurons_tet.all(tt)) ' neurons'], ...
                        [num2str(nb_neurons_tet.pyr(tt)) ' pyramidal(s)'], ...
                        [num2str(nb_neurons_tet.int(tt)) ' interneuron(s)'],...
                        ['FR (SWS) = ' num2str(fr.nrem.local{tt}) ' Hz ( ' num2str(fr.nrem.local{tt}/nb_neurons_tet.all(tt)) ' Hz)'],...
                        ['FR (Wake) = ' num2str(fr.wake.local{tt}) ' Hz ( ' num2str(fr.wake.local{tt}/nb_neurons_tet.all(tt)) ' Hz)']};


        %% down distrib
        thresh0 = 0.7;
        maxDownDur = 1000;
        mergeGap = 0; % merge
        predown_size = 0;
        duration_bins = 0:10:1500; %duration bins for downstates

        DownNrem = FindDownKJ(Restrict(MUA_local{tt}, NREM), 'low_thresh', thresh0, 'minDuration', 0,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size);
        downSws_dur = (End(DownNrem) - Start(DownNrem)) / 10; %ms
        DownWake = FindDownKJ(Restrict(MUA_local{tt}, Wake), 'low_thresh', thresh0, 'minDuration', 0,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size);
        downWake_dur = (End(DownWake) - Start(DownWake)) / 10; %ms

        nbDown.nrem = zeros(1, length(duration_bins));
        nbDown.wake = zeros(1, length(duration_bins));
        for j=1:length(duration_bins)
            binvalue = duration_bins(j);
            nbDown.nrem(j) = sum(downSws_dur==binvalue);
            nbDown.wake(j) = sum(downWake_dur==binvalue);
        end


        %% distinguish local and global
        intv = [Start(AllDown_local{tt})-2*binsize_mua*10 End(AllDown_local{tt} )];
        [~,intervals,~] = InIntervals(st_down, intv);
        intervals(intervals==0)=[];
        intervals = setdiff(1:length(Start(AllDown_local{tt})), unique(intervals));
        Down_local{tt} = subset(AllDown_local{tt}, intervals);
        st_localdown{tt} = Start(Down_local{tt});
        center_localdown{tt} = (Start(Down_local{tt}) + End(Down_local{tt})) /2;

        %local homeostasis
        [~, ~, Hs] = DensityOccupation_KJ(Down_local{tt}, 'homeostat',2, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
        Hstat.local.x_intervals{tt} = Hs.x_intervals;
        Hstat.local.y_density{tt}   = Hs.y_density;
        Hstat.local.x_peaks{tt}  = Hs.x_peaks;
        Hstat.local.y_peaks{tt}  = Hs.y_peaks;
        Hstat.local.p1{tt}   = Hs.p1;
        Hstat.local.reg1{tt} = Hs.reg1;  
        Hstat.local.p2{tt}   = Hs.p2;
        Hstat.local.reg2{tt} = Hs.reg2;


        %% local delta
        %load
        load('DeltaWavesChannels.mat', ['delta_ch_' num2str(tetrodeChannels(tt))])
        eval(['a = delta_ch_' num2str(tetrodeChannels(tt)) ';'])
        deltawaves{tt} = a;
        st_deltawaves{tt} = Start(deltawaves{tt});
        center_deltawaves{tt} = (Start(deltawaves{tt}) + End(deltawaves{tt})) /2;

        %down and other
        intv = [st_deltawaves{tt}-500 st_deltawaves{tt}+1500];
        [~,intervals,~] = InIntervals(st_down, intv);
        intervals(intervals==0)=[];
        intervals = unique(intervals);
        global_delta{tt} = st_deltawaves{tt}(intervals); %with a global down states
        other_delta{tt}  = st_deltawaves{tt}(setdiff(1:length(st_deltawaves{tt}),intervals)'); %no global down states
        other_deltacenter{tt}  = center_deltawaves{tt}(setdiff(1:length(st_deltawaves{tt}),intervals)'); %center


        %% mean Mua and raster and cross corr
        [m,~,tps] = mETAverage(other_delta{tt}, Range(MUA_local{tt}), Data(MUA_local{tt}), binsize_met, nbBins_met);
        met_mua{tt}(:,1) = tps; met_mua{tt}(:,2) = m;

        raster_local{tt} = RasterMatrixKJ(MUA_local{tt}, ts(other_delta{tt}), t_before, t_after);

        [crosscorr.y{tt}, crosscorr.x{tt}] = CrossCorr(other_deltacenter{tt}, center_localdown{tt}, binsize_cc, nb_binscc);


        %% Plot
        figure, hold on

        %table
        subplot(2,6,1), hold on
        textbox_dim = get(subplot(2,6,1),'position');
        delete(subplot(2,6,1))

        annotation(gcf,'textbox',...
        textbox_dim,...
        'String',textbox_str,...
        'LineWidth',1,...
        'HorizontalAlignment','center',...
        'FontWeight','bold',...
        'FitBoxToText','off');


        %down distrib
        subplot(2,6,2), hold on
        plot(duration_bins, nbDown.nrem ,'r'), hold on
        plot(duration_bins, nbDown.wake ,'k'), hold on
        set(gca,'xscale','log','yscale','log'), hold on
        set(gca,'ylim',[1 1E6],'xlim',[10 1500]), hold on
        set(gca,'xtick',[10 50 100 200 500 1500]), hold on
        legend('NREM','Wake'), xlabel('down duration (ms)'), ylabel('number of down')

        %firing rate evolution
        subplot(2,6,[3 4]), hold on
        hold on, plot(Fr.local.t{tt}, Fr.local.y{tt}, 'k'),


        % mean MUA on delta
        subplot(2,6,7), hold on
        plot(met_mua{tt}(:,1), met_mua{tt}(:,2), 'color','k', 'linewidth',2);
        ylimax = get(gca,'ylim'); ylimax(1)=0; ylim(ylimax);
        xlim([-500 500]),
        line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
        xlabel('time from delta waves (ms)'), ylabel('mean MUA amplitude')

        % cross-corr
        subplot(2,6,8), hold on
        smoothing = 0;
        hold on, h(1)=plot(crosscorr.x{tt}, Smooth(crosscorr.y{tt},smoothing), 'color','k', 'linewidth',2);
        xlim([-500 500]),
        line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
        xlabel('time from delta (ms)'), ylabel('down frequency')

        % MUA raster
        subplot(2,6,[9 10]), hold on
        %Mat sorted 
        Mat = Data(raster_local{tt})';
        x_tmp = Range(raster_local{tt});
        vmean = mean(Mat(:,x_tmp>0&x_tmp<0.1e4),2);
        [~, idxMat] = sort(vmean);
        Mat = Mat(idxMat,:);

        imagesc(x_tmp/1E4, 1:size(Mat,1), Mat), hold on
        axis xy, hold on
        line([0 0], ylim,'Linewidth',2,'color','k'), hold on
        set(gca,'YLim', [0 size(Mat,1)], 'xlim', [-0.5 0.5]);
        xlabel('time from delta waves (ms)'), title('MUA tetrode')
        ylabel('# deltas local'),

        c = caxis;
        c(2) = c(2)+1;
        caxis(c);


        % global down homeostasis
        subplot(2,6,[5 6]), hold on
        hold on, plot(Hstat.global.x_intervals, Hstat.global.y_density,'b')
        hold on, plot(Hstat.global.x_intervals, Hstat.global.reg1,'k.')
        hold on, scatter(Hstat.global.x_peaks, Hstat.global.y_peaks,'r')
        title(['Global down states (p= ' num2str(Hstat.global.p1) ')']);
        % local down homeostasis
        subplot(2,6,[11 12]), hold on
        hold on, plot(Hstat.local.x_intervals{tt}, Hstat.local.y_density{tt},'b')
        hold on, plot(Hstat.local.x_intervals{tt}, Hstat.local.reg1{tt},'k.')
        hold on, scatter(Hstat.local.x_peaks{tt}, Hstat.local.y_peaks{tt},'r')
        title(['local down states (p= ' num2str(Hstat.local.p1{tt}) ')']);


        %save figure
        filename_fig = ['FigureLocalDown_' Dir.name{p}  '_' Dir.date{p} '_tet_' num2str(tt)];
        filename_png = [filename_fig  '.png'];
        folderfig = fullfile(FolderFigureDelta,'LabMeeting','20191202','FigureLocalDown');
        filename_png = fullfile(folderfig,filename_png);
        saveas(gcf,filename_png,'png')
        close all

    end


end




