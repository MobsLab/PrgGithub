% Fonction pour assigner les états aux bins
function state_bins = assign_bins(intervals, time_bins)
    state_bins = zeros(1, length(time_bins) - 1);
    for i = 1:size(intervals, 1)
        start_bin = find(time_bins >= intervals(i, 1), 1, 'first');
        end_bin = find(time_bins <= intervals(i, 2), 1, 'last');
        if ~isempty(start_bin) && ~isempty(end_bin)
            state_bins(start_bin:end_bin) = 1;
        end
    end
end