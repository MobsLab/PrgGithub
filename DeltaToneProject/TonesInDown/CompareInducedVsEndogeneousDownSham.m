%%CompareInducedVsEndogeneousDownSham
% 18.05.2018 KJ
%
%
% see
%   Fig3CompareInducedVsEndogeneousDown CompareInducedVsEndogeneousDown
%



clear

Dir=PathForExperimentsBasalSleepSpike;
Dir=RestrictPathForExperiment(Dir, 'nMice', [243,244,403,451]);

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p comparesham_res rastersham_res
    
    comparesham_res.path{p}   = Dir.path{p};
    comparesham_res.manipe{p} = Dir.manipe{p};
    comparesham_res.name{p}   = Dir.name{p};
    comparesham_res.date{p}   = Dir.date{p};
    
    %params
    t_start      = -1e4; %1s
    t_end        = 1e4; %1s
    intv_success = 0.2e4;
    binsize_mua = 2; %2ms
    
    %sham
    load('ShamSleepEventRandom.mat', 'SHAMtime')
    sham_tmp = Range(SHAMtime);

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
    comparesham_res.fr{p} = mean(Data(MUA)) / (binsize_mua/1000);
    comparesham_res.nb{p} = nb_neurons;
    
    
    %% Tones in or out

    %Down with or without
    intv_post_sham = [sham_tmp sham_tmp+intv_success];
    [status,~,~] = InIntervals(st_down, intv_post_sham);
    downSham = subset(down_PFCx, find(status));
    downEndogen = subset(down_PFCx, find(~status));
    
    st_inducedsham  =  Start(downSham);
    end_inducedsham =  End(downSham);
    st_endogen  =  Start(downEndogen);
    end_endogen =  End(downEndogen);
    
    
    %% durations
    comparesham_res.sham.duration{p} = end_inducedsham - st_inducedsham; 
    comparesham_res.endogen.duration{p} = end_endogen - st_endogen; 
    
    
    %% MUA around down states
    rastersham_res.sham.rasters.pre{p}  = RasterMatrixKJ(MUA, ts(st_inducedsham), t_start, t_end);
    rastersham_res.sham.rasters.post{p} = RasterMatrixKJ(MUA, ts(end_inducedsham), t_start, t_end);
    rastersham_res.endogen.rasters.pre{p}  = RasterMatrixKJ(MUA, ts(st_endogen), t_start, t_end);
    rastersham_res.endogen.rasters.post{p} = RasterMatrixKJ(MUA, ts(end_endogen), t_start, t_end);
    

    %% ISI
    
    %induced
    isi_down1 = nan(length(st_inducedsham),1);
    isi_down2 = nan(length(st_inducedsham),1);
    for t=1:length(st_inducedsham)
        next_down = st_down(find(st_down>end_inducedsham(t), 2));
        try
            isi_down1(t) = next_down(1) - end_inducedsham(t);
        end
        try
            isi_down2(t) = next_down(2) - end_inducedsham(t);
        end    
    end
    
    comparesham_res.sham.isi1{p}  = isi_down1;
    comparesham_res.sham.isi2{p}  = isi_down2;
    
    
    %endogeneous (first remove endogeneous followed by induced down for ISI)
    st_endogen_ok = [];
    end_endogen_ok = [];
    for t=1:length(st_endogen)
        next_induced = st_inducedsham(find(st_inducedsham>end_endogen(t), 1));
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
    
    comparesham_res.endogen.isi1{p}  = isi_down1;
    comparesham_res.endogen.isi2{p}  = isi_down2;
    
        
end


%saving data
cd(FolderDeltaDataKJ)
save CompareInducedVsEndogeneousDownSham.mat -v7.3 comparesham_res rastersham_res binsize_mua intv_success


