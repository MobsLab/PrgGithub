%%ParcoursDownNormalizedSpikeActivity
% 20.09.2018 KJ
%
%
%   Look at the spiking activity of neurons inside down states
%
% see
%   NeuronsResponseToDown_KJ2
%


clear

Dir = PathForExperimentsSleepRipplesSpikes('all');
Dir = CheckPathForExperiment_KJ(Dir);


% get data for each record
for p=1:length(Dir.path)
% p=2;
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p downspk_res
    
    downspk_res.path{p}   = Dir.path{p};
    downspk_res.manipe{p} = Dir.manipe{p};
    downspk_res.name{p}   = Dir.name{p};
    downspk_res.date{p}   = Dir.date{p};
    
    %params
    binsize_cc = 5;
    nbins_cc = 200;
    minDuration = 0.075e4; %200ms
    maxDuration = 30e4;
    
    
    %% load
    
    %Spikes of PFCx
    load('SpikeData.mat', 'S')
    load('SpikesToAnalyse/PFCx_Neurons.mat', 'number')
    NumNeurons = number;
    S = S(NumNeurons);
    
    % Substages
    try
        load('SleepSubstages.mat', 'Epoch')
        N1 = Epoch{1}; N2 = Epoch{2}; N3 = Epoch{3}; REM = Epoch{4}; Wake = Epoch{5}; NREM = Epoch{7};
    catch
        clear op NamesOp Dpfc Epoch noise
        load NREMepochsML.mat op NamesOp Dpfc Epoch noise
        disp('Loading epochs from NREMepochsML.m')
        [Substages,NamesSubstages]=DefineSubStages(op,noise);
        N1 = Substages{1}; N2 = Substages{2}; N3 = Substages{3}; REM = Substages{4}; Wake = Substages{5}; NREM = Substages{7};
    end
    N2N3 = or(N2,N3); NREM = or(N1,N2N3);
    
    % Down
    load('DownState.mat', 'down_PFCx')
    st_down  = Start(down_PFCx);
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropShortIntervals(up_PFCx, minDuration);
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration);
    
    up_N2 = and(up_PFCx,N2);
    up_N3 = and(up_PFCx,N3);
    up_N2N3 = and(up_PFCx,N2N3);
    
    period{1} = up_N2; period{2} = up_N3; period{3} = up_N2N3;
    labels{1} = 'n2'; labels{1} = 'n3'; labels{1} = 'n2n3';
    
    
    %% Spike activity in up states
    
    for s=1:length(period)
        st_up  = Start(period{s});
        end_up = End(period{s});
        
        downspk_res.upTotDur{p}(s) = tot_length(period{s});
        
        for k=1:length(S)
            spike_tmp{k} = Range(Restrict(S{k}, period{s}));
            downspk_res.nb_spike{p}(k) = length(spike_tmp{k});

            downspk_res.st_bef{p}{k} = nan(length(spike_tmp{k}), 1);
            downspk_res.end_aft{p}{k}   = nan(length(spike_tmp{k}), 1);
            for i=1:length(spike_tmp{k})
                try
                    tmp_bef = st_up(find(st_up<spike_tmp{k}(i),1,'last'));
                    downspk_res.st_bef{p}{k}(i) = spike_tmp{k}(i) - tmp_bef;
                end
                try
                    tmp_aft = end_up(find(end_up>spike_tmp{k}(i),1));
                    downspk_res.end_aft{p}{k}(i) = tmp_aft - spike_tmp{k}(i); 
                end
            end
        end
    end
    
    
    
end

%saving data
cd(FolderDeltaDataKJ)
save ParcoursDownNormalizedSpikeActivity.mat downspk_res binsize_cc nbins_cc minDuration maxDuration




