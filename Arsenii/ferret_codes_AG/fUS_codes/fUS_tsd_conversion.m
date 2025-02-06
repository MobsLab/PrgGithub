slots = {'C', 'D', 'F', 'E', 'G', 'H'};
sessions = {[1], [1 2], [1 2], [1 2], [2], [1 2]};

datapath = '/home/arsenii/data5/Arsenii/React_Passive_AG/fUS/Processed_Data/Edel';


time = linspace(1,9750*1e4/2.5, 9750);


for slot_count = 1:length(slots)
    slot_code = slots{slot_count};
    addpath(genpath([datapath '/' slot_code]))
    cd([datapath '/' slot_code]);
    disp(['processing ' slot_code])
    
    load('data_cat.mat')
    load('exp_info.mat')
    load('params.mat')
    
    fileList = dir(fullfile(pwd, 'masks*'));
    load(fileList(1).name)
    
    allVars = who;
    clear tissueVars
    tissueVars = allVars(contains(allVars, 'tissue_mask'));
    tissue_mask = eval(tissueVars{1});
    clear far_out_Vars
    far_out_Vars = allVars(contains(allVars, 'far_out_mask'));
    far_out_mask = eval(far_out_Vars{1});
    
  %%  
    for sess = sessions{slot_count}
        
        if sess == 1
            ACx_mask = eval(['ACx_mask' '_m']);
            Hpc_mask = eval(['Hpc_mask' '_m']);
        elseif sess == 2
            ACx_mask = eval(['ACx_mask' '_n']);
            Hpc_mask = eval(['Hpc_mask' '_n']);
        end
        
        fUS_ACx{sess} = data_cat(:, :, :, sess) .* ACx_mask;
        mean_data_ACx{sess} = squeeze(mean(fUS_ACx{sess}, 1:2));
        fUS_ACx_tsd{sess} = tsd(time', mean_data_ACx{sess});
        
        fUS_Hpc{sess} = data_cat(:, :, :, sess) .* Hpc_mask;
        mean_data_Hpc{sess} = squeeze(mean(fUS_Hpc{sess}, 1:2));
        fUS_Hpc_tsd{sess} = tsd(time', mean_data_Hpc{sess});
        
        fUS_tissue{sess} = data_cat(:, :, :, sess) .* tissue_mask;
        mean_data_tissue{sess} = squeeze(mean(fUS_tissue{sess}, 1:2));
        fUS_tissue_tsd{sess} = tsd(time', mean_data_tissue{sess});
        
        fUS_far_out{sess} = data_cat(:, :, :, sess) .* far_out_mask;
        mean_data_far_out{sess} = squeeze(mean(fUS_far_out{sess}, 1:2));
        fUS_far_out_tsd{sess} = tsd(time', mean_data_far_out{sess});
    end
    save([datapath, '/fUS_data_' slot_code], 'data_cat', 'exp_info', 'params', 'fUS_ACx_tsd', 'fUS_Hpc_tsd', 'fUS_tissue_tsd', 'fUS_far_out_tsd', 'ACx_mask_m',  'ACx_mask_n',  'Hpc_mask_m',  'Hpc_mask_n',  'tissue_mask',  'far_out_mask', '-v7.3')
end

