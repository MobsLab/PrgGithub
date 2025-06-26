function info_per_spike = compute_spatial_info(pos, t_pos, spike_times, num_bins)
    
% Bin edges
    pos_min = min(pos);
    pos_max = max(pos);
    edges = linspace(pos_min, pos_max, num_bins+1);
    
    % Assign each position sample to a spatial bin
    pos_bin = discretize(pos, edges);
    
    % Time step of position samples
    dt = median(diff(t_pos)); % assume uniform sampling
    
    % Compute occupancy per bin
    occupancy = accumarray(pos_bin(:), dt, [num_bins 1], @sum, 0);  % in seconds
    total_time = sum(occupancy);
    p_x = occupancy / total_time;  % probability of being in bin x
    
    % Assign spikes to position bins
    spike_pos_idx = interp1(t_pos, 1:length(t_pos), spike_times, 'nearest', 'extrap');
    spike_pos_idx = min(max(spike_pos_idx, 1), length(pos));  % ensure bounds
    spike_bins = pos_bin(spike_pos_idx);
    
    % Spike count per bin
    spike_counts = accumarray(spike_bins(:), 1, [num_bins 1], @sum, 0);
    
    % Firing rate per bin
    lambda_x = spike_counts ./ occupancy;  % spikes/sec
    lambda_x(occupancy == 0) = 0;  % avoid NaNs
    
    % Overall mean firing rate
    lambda = sum(spike_counts) / total_time;
    
    % Skaggs spatial info per spike
    valid = (lambda_x > 0 & p_x > 0);
    info_per_spike = sum(p_x(valid) .* lambda_x(valid) ./ lambda .* ...
                         log2(lambda_x(valid) ./ lambda));