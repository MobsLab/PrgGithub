% IsmemberTetrodeTemplatesPhy - process results from phy GUI (NPY files)
%
%  USAGE
%
%    idx_templates = IsmemberTetrodeTemplatesKS(tetrode_channels, pc_feature_ind)
%
%    tetrode_channels       list of channels of the tetrode
%    pc_feature_ind         for each templates, the principal channels of the projection 
%
%  OUTPUT
%
%    idx_templates          logical vector - indices of the templates of linked to the tetrode
%
%  SEE
%
%


function idx_templates = IsmemberTetrodeTemplatesPhy(tetrode_channels, pc_feature_ind, channel_map)
    
    %init
    nb_electrode = length(tetrode_channels);
    nb_pc = size(pc_feature_ind,2);
    pc_feature_ind = sort(pc_feature_ind,2);
    
    %real channel number in pc_feature_ind
    temp = pc_feature_ind;
    for i=1:length(channel_map)
        temp(pc_feature_ind==i-1)=channel_map(i);
    end
    pc_feature_ind = temp;
    
    %threshold of channels matching to assign a row to a tetrode
    if nb_electrode>2
        thresh_nb_channel = nb_electrode-1;
    else
        thresh_nb_channel = nb_electrode;
    end
    
    %match
    idx_templates = false(size(pc_feature_ind,1),1);
    for i=1:size(pc_feature_ind,1)
        idx_templates(i) = length(intersect(tetrode_channels, pc_feature_ind(i,:))) >= thresh_nb_channel;
    end
        
end