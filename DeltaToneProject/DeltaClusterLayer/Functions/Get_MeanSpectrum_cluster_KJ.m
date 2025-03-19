%%Get_MeanSpectrum_cluster_KJ
% 14.03.2018 KJ
%
% Mean spectrum for each clusters
%
% [meanspectrum, legend_curve, substages] = Get_MeanSpectrum_cluster_KJ(night, clusters, nb_clusters)
%
% INPUT:
% - nights              = (struct) nights_path + channels 
% - clusters            = clusters of each night
% - curves_struct       = (struct) contains spectral data  
% - substages           = substage(s) list  (1 to 5) 
% - normalization       = method to mormalize the spectrum : 'log_sp' or 'f_sp' or 'norm_f_sp'
%
% OUTPUT:
% - meanspectrum        = (struct) mean LFP on Down staesfor each clusters
% - legend_curve        = legend
%
%
%   see 
%       LFPlayerInfluenceOnDetection
%


function [meanspectrum, legend_curve] = Get_MeanSpectrum_cluster_KJ(night, clusters, curves_struct, substages, normalization, nb_clusters)


%% CHECK INPUTS

if nargin < 5
  error('Incorrect number of parameters.');
elseif nargin < 6
    nb_clusters = max(clusters);
end


%% loop on clusters

for k=1:nb_clusters
    
    idx_curves = find(clusters==k);
    spectra_k = [];
    
    %cluster legend
    legend_curve{k}=num2str(k);
    
    for i=idx_curves'
        p = night(i,1);
        ch = night(i,2);
        
        %Spectrum for each substages
        for sub=substages 
            freq_sub      = curves_struct{p}{ch,sub}(:,1);
            spectrum_sub  = curves_struct{p}{ch,sub}(:,2);
            
            if strcmpi(normalization,'log_sp')
                norm_spectrum = 10 * log10(spectrum_sub);
            elseif strcmpi(normalization,'f_sp')
                norm_spectrum = freq_sub .* spectrum_sub;
            elseif strcmpi(normalization,'norm_f_sp')
                norm_spectrum = freq_sub .* spectrum_sub;
                norm_spectrum = norm_spectrum / max(norm_spectrum);
            end
            spectra_k = [spectra_k norm_spectrum];
        end
    end
    
    %save
    if ~isempty(spectra_k)
        meanspectrum.x{k} = freq_sub;
        meanspectrum.y{k} = mean(spectra_k,2);    
    else
        meanspectrum.x{k} = [];
        meanspectrum.y{k} = [];
    end
end


end


