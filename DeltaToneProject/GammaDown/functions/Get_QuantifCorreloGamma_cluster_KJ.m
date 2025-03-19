%%Get_QuantifCorreloGamma_cluster_KJ
% 24.04.2018 KJ
%
% Quantification of the peak of the correlogram Down-Gamma, for each clusters
%
% [peak_data, legend_curve] = Get_QuantifCorreloGamma_cluster_KJ(night, clusters, nb_clusters)
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
%       Get_QuantifCorreloDelta_cluster_KJ GammaDownChannelAnalysisCrossCorr
%


function [peak_correlogram, legend_corr] = Get_QuantifCorreloGamma_cluster_KJ(night, clusters, nb_clusters)


%% CHECK INPUTS

if nargin < 2 
  error('Incorrect number of parameters.');
elseif nargin < 3
    nb_clusters = max(clusters);
end

load(fullfile(FolderDeltaDataKJ,'GammaDownChannelAnalysisCrossCorr.mat'))

night_path = unique(night(:,1));
night_path(night_path>length(gammacorr_res.rip_down.x))=[];


%% down state correlogram
peak_ripdown = [];
for n=1:length(night_path)
    p = night_path(n);
    try
        x_sig = gammacorr_res.rip_down.x{p};
        y_sig = gammacorr_res.rip_down.y{p};
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
                x_sig = gammacorr_res.rip_gamma.x{p,ch};
                y_sig = gammacorr_res.rip_gamma.y{p,ch};
                peak_rip(idx) = max(y_sig(x_sig>0));
            catch
                peak_rip(idx) = nan;
            end
        end
    end  
end


%% Regroup by clusters and add data of multi layer

for i=1:nb_clusters
    peak_data.gamma{i} = peak_rip(clusters==i);
end

%legend
for i=1:nb_clusters
    legend_corr{i} = num2str(i);
end
legend_corr{end+1} = 'down';


%% all
peak_correlogram = [peak_data.gamma peak_data.down];



end






