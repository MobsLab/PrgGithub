%%CompareRippleInducedVsEndogeneousDown
% 18.05.2018 KJ
%
%
% see
%   Fig3CompareInducedVsEndogeneousDown
%



clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p compare_res raster_res
    
    compare_res.path{p}   = Dir.path{p};
    compare_res.manipe{p} = Dir.manipe{p};
    compare_res.name{p}   = Dir.name{p};
    compare_res.date{p}   = Dir.date{p};
    
    %params
    t_start      = -1e4; %1s
    t_end        = 1e4; %1s
    intv_success = 0.2e4;
    binsize_mua = 2; %2ms
    
    %ripples    
    load('Ripples.mat', 'Ripples')
    ripples_tmp = Ripples(:,2)*10;

    %substages
    load('SleepSubstages.mat')
    N2N3 = CleanUpEpoch(or(Epoch{2},Epoch{3}));
    
    
    %% MUA

    %MUA
    [MUA, nb_neurons] = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 

    %Down
    load('DownState.mat', 'down_PFCx')
    st_down   = Start(down_PFCx);
    end_down  = End(down_PFCx);

    %FR and nb_neuron
    compare_res.fr{p} = mean(Data(MUA)) / (binsize_mua/1000);
    compare_res.nb{p} = nb_neurons;
    
    
    %% Ripples in or out

    %Down with or without
    intv_post_ripples = [ripples_tmp ripples_tmp+intv_success];
    [status,~,~] = InIntervals(st_down, intv_post_ripples);
    downInduced = subset(down_PFCx, find(status));
    downEndogen = subset(down_PFCx, find(~status));
    
    st_induced  =  Start(downInduced);
    end_induced =  End(downInduced);
    st_endogen  =  Start(downEndogen);
    end_endogen =  End(downEndogen);
    
    
    %% durations
    compare_res.induced.duration{p} = end_induced - st_induced; 
    compare_res.endogen.duration{p} = end_endogen - st_endogen; 
    
    
    %% MUA around down states
    raster_res.induced.rasters.pre{p}  = RasterMatrixKJ(MUA, ts(st_induced), t_start, t_end);
    raster_res.induced.rasters.post{p} = RasterMatrixKJ(MUA, ts(end_induced), t_start, t_end);
    raster_res.endogen.rasters.pre{p}  = RasterMatrixKJ(MUA, ts(st_endogen), t_start, t_end);
    raster_res.endogen.rasters.post{p} = RasterMatrixKJ(MUA, ts(end_endogen), t_start, t_end);
    

    %% ISI
    
    %induced
    isi_down1 = nan(length(st_induced),1);
    isi_down2 = nan(length(st_induced),1);
    for t=1:length(st_induced)
        next_down = st_down(find(st_down>end_induced(t), 2));
        try
            isi_down1(t) = next_down(1) - end_induced(t);
        end
        try
            isi_down2(t) = next_down(2) - end_induced(t);
        end    
    end
    
    compare_res.induced.isi1{p}  = isi_down1;
    compare_res.induced.isi2{p}  = isi_down2;
    
    
    %endogeneous (first remove endogeneous followed by induced down for ISI)
    st_endogen_ok = [];
    end_endogen_ok = [];
    for t=1:length(st_endogen)
        next_induced = st_induced(find(st_induced>end_endogen(t), 1));
        next_endogen = st_endogen(find(st_endogen>end_endogen(t), 1));
        if next_induced>next_endogen
            st_endogen_ok = [st_endogen_ok st_endogen(t)];
            end_endogen_ok = [end_endogen_ok end_endogen(t)];
        end
    end
    
    isi_down1 = nan(length(st_endogen_ok),1);
    isi_down2 = nan(length(st_endogen_ok),1);
    for t=1:length(st_endogen_ok)
        next_down = st_endogen_ok(find(st_endogen_ok>end_endogen_ok(t), 2));
        try
            isi_down1(t) = next_down(1) - end_endogen_ok(t);
        end
        try
            isi_down2(t) = next_down(2) - end_endogen_ok(t);
        end    
    end
    
    compare_res.endogen.isi1{p}  = isi_down1;
    compare_res.endogen.isi2{p}  = isi_down2;
    
        
end


%saving data
cd(FolderDeltaDataKJ)
save CompareRippleInducedVsEndogeneousDown.mat  -v7.3 compare_res raster_res binsize_mua intv_success


