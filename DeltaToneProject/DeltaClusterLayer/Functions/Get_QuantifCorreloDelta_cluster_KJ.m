%%Get_QuantifCorreloDelta_cluster_KJ
% 15.03.2018 KJ
%
% Qiantification of the peak of the correlogram Down-Delta, for each clusters
%
% [peak_data, legend_curve] = Get_QuantifCorreloDelta_cluster_KJ(night, clusters, nb_clusters)
%
% INPUT:
% - nights              = (struct) nights_path + channels 
% - clusters            = clusters of each night 
%
% OUTPUT:
% - peak_data          = (struct) mean LFP on Down staesfor each clusters
% - legend_curve        = legend
%
%   see 
%       LFPlayerInfluenceOnDetectionMouse
%


function [peak_correlogram, legend_corr] = Get_QuantifCorreloDelta_cluster_KJ(night, clusters, nb_clusters)


%% CHECK INPUTS

if nargin < 2 
  error('Incorrect number of parameters.');
elseif nargin < 3
    nb_clusters = max(clusters);
end

load(fullfile(FolderDeltaDataKJ,'DeltaSingleChannelAnalysisCrossCorr.mat'))

night_path = unique(night(:,1));
night_path(night_path>length(singcor_res.rip_down.x))=[];


%% down state correlogram
peak_ripdown = [];
for n=1:length(night_path)
    p = night_path(n);
    try
        x_sig = singcor_res.rip_down.x{p};
        y_sig = singcor_res.rip_down.y{p};
        peak_ripdown(p) = max(y_sig(x_sig>0));
    catch
        peak_ripdown(p) = nan;
    end
end
%save
peak_ripdown(peak_ripdown==0 | isnan(peak_ripdown))=[];
peak_data.down = peak_ripdown;


%% loop on clusters
for k=1:nb_clusters
    
    idx_curves = find(clusters==k);        
    for i=idx_curves'
        p = night(i,1);
        ch = night(i,2);
        idx = find(ismember(night, [p ch], 'rows'));
        if ~isempty(idx)
            try
                x_sig = singcor_res.rip_delta.x{p,ch};
                y_sig = singcor_res.rip_delta.y{p,ch};
                peak_rip(idx) = max(y_sig(x_sig>0));
            catch
                peak_rip(idx) = nan;
            end
        end
    end  
end


%% multi layer correlogram
k = nb_clusters+1;
peak_ripmulti = [];
for n=1:length(night_path)
    p = night_path(n);
    ch = length(singcor_res.channels{p});
    try
        x_sig = singcor_res.rip_delta.x{p,ch};
        y_sig = singcor_res.rip_delta.y{p,ch};
        peak_ripmulti(p) = max(y_sig(x_sig>0));
    catch
        peak_ripmulti(p) = nan;
    end
end
peak_ripmulti(peak_ripmulti==0 | isnan(peak_ripmulti))=[];


%% Regroup by clusters and add data of multi layer

for i=1:nb_clusters
    peak_data.delta{i} = peak_rip(clusters==i);
end
peak_data.delta{end+1} = peak_ripmulti;


%legend
for i=1:nb_clusters
    legend_corr{i} = num2str(i);
end
legend_corr{end+1} = '2-layers';
legend_corr{end+1} = 'down';


%% all
peak_correlogram = [peak_data.delta peak_data.down];



end






