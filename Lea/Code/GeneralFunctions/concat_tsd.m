
%% concat_tsd() function :
%
% 10/04/2020 LP
%
% Function : Concatenate tsd, after sorting timestamps and data
% accordingly.
%
% ----------------- INPUTS ----------------- :
%   - tsd1
%   - tsd2
%
% ----------------- OUTPUTS ----------------- :
%   - final_tsd (contenation of tsd1 and tsd2, ordered according timestamps)
%   - sorted_idx1 (true when value from tsd1 in final tsd, false when from
%   tsd2)
%

function [final_tsd, sorted_idx1] = concat_tsd(tsd1,tsd2)
    
    all_t = [Range(tsd1);Range(tsd2)] ; % concatenate timestamps
    all_data = [Data(tsd1);Data(tsd2)] ; % concatenate data
    
    [t_sorted, sort_idx] = sort(all_t) ; % sort timestamps
    sorted_data = all_data(sort_idx) ; % sort data accordingly
    final_tsd = tsd(t_sorted,sorted_data); 
    
    % Get info about final order (and tsd1 vs tsd2 indices in final_tsd) :
    all_idx1 = [repmat(1,1,length(Data(tsd1))),repmat(0,1,length(Data(tsd2)))] ; 
    sorted_idx1 = all_idx1(sort_idx) ; 
    
end

