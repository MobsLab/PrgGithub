function [Pre_Occup_Shock_mean, Pre_Occup_Shock_std, Cond_Occup_Shock_mean, ...
    Cond_Occup_Shock_std, Post_Occup_Shock_mean, Post_Occup_Shock_std, ...
    Pre_Occup_Safe_mean, Pre_Occup_Safe_std, Cond_Occup_Safe_mean, ...
    Cond_Occup_Safe_std, Post_Occup_Safe_mean, Post_Occup_Safe_std, ...
    p_pre_post] = GetShockZoneOcupancies(a, id_Pre, id_Cond, id_Post, varargin)
%GETSHOCKZONEOCUPANCIES Calculate average occupancy in safe zone vs shock
%zone

%   args:
%       a: a cell array containing behavResources for each session
%       id_Pre: id of Pre sessions
%       id_Cond: id of Cond sessions
%       id_Post: id of Post sessions
%       varargin: optional arguments
%           'extended': if true, calculate occupancy in extended safe zone 
%   returns:
%       Pre_Occup_Shock_mean: mean occupancy in shock zone during Pre
%       Pre_Occup_Shock_std: std occupancy in shock zone during Pre
%       Cond_Occup_Shock_mean: mean occupancy in shock zone during Cond 
%       Cond_Occup_Shock_std: std occupancy in shock zone during Cond
%       Post_Occup_Shock_mean: mean occupancy in shock zone during Post
%       Post_Occup_Shock_std: std occupancy in shock zone during Post
%       Pre_Occup_Safe_mean: mean occupancy in safe zone during Pre
%       Pre_Occup_Safe_std: std occupancy in safe zone during Pre
%       Cond_Occup_Safe_mean: mean occupancy in safe zone during Cond
%       Cond_Occup_Safe_std: std occupancy in safe zone during Cond
%       Post_Occup_Safe_mean: mean occupancy in safe zone during Post
%       Post_Occup_Safe_std: std occupancy in safe zone during Post
%       p_pre_post: p value of Wilcoxon signed rank test between Pre and
%       PostTest
%
%   Example:
%       [Pre_Occup_Shock_mean, Pre_Occup_Shock_std, Cond_Occup_Shock_mean,
%       Cond_Occup_Shock_std, Post_Occup_Shock_mean, Post_Occup_Shock_std,
%       Pre_Occup_Safe_mean, Pre_Occup_Safe_std, Cond_Occup_Safe_mean,
%       Cond_Occup_Safe_std, Post_Occup_Safe_mean, Post_Occup_Safe_std,
%       p_pre_post] = GetShockZoneOcupancies(a,id_Pre, id_Cond, id_Post);

p = inputParser;
addParameter(p, 'extended', false, @islogical);
parse(p, varargin{:});
extended = p.Results.extended;

%% Calculate average occupancy
% Calculate occupancy de novo
try
    for k=1:length(id_Pre)
        for t=1:length(a.behavResources(id_Pre(k)).Zone)
            Pre_Occup(k,t)=size(a.behavResources(id_Pre(k)).ZoneIndices{t},1)./...
                size(Data(a.behavResources(id_Pre(k)).Xtsd),1);
        end
    end
    for k=1:length(id_Cond)
        for t=1:length(a.behavResources(id_Cond(k)).Zone)
            Cond_Occup(k,t)=size(a.behavResources(id_Cond(k)).ZoneIndices{t},1)./...
                size(Data(a.behavResources(id_Cond(k)).Xtsd),1);
        end
    end
    for k=1:length(id_Post)
        for t=1:length(a.behavResources(id_Post(k)).Zone)
            Post_Occup(k,t)=size(a.behavResources(id_Post(k)).ZoneIndices{t},1)./...
                size(Data(a.behavResources(id_Post(k)).Xtsd),1);
        end
    end
catch
    for k=1:length(id_Pre)
        for t=1:length(a.behavResources(id_Pre(k)).Zone)
            Pre_Occup(k,t)=size(a.behavResources(id_Pre(k)).ZoneIndices{t},1)./...
                size(Data(a.behavResources(id_Pre(k)).AlignedXtsd),1);
        end
    end
    for k=1:length(id_Cond)
        for t=1:length(a.behavResources(id_Cond(k)).Zone)
            Cond_Occup(k,t)=size(a.behavResources(id_Cond(k)).ZoneIndices{t},1)./...
                size(Data(a.behavResources(id_Cond(k)).AlignedXtsd),1);
        end
    end
    for k=1:length(id_Post)
        for t=1:length(a.behavResources(id_Post(k)).Zone)
            Post_Occup(k,t)=size(a.behavResources(id_Post(k)).ZoneIndices{t},1)./...
                size(Data(a.behavResources(id_Post(k)).AlignedXtsd),1);
        end
    end
end

%% beforehand, check that the indices didnt change (not coherent between a.behavResources(idx).ZoneLabels and a.ZoneNames)
if ~strcmp(a.behavResources(id_Post(k)).ZoneLabels{1}, 'Shock')
    error('Wrong shock zones definition')
end
if ~strcmp(a.behavResources(id_Post(k)).ZoneLabels{2}, 'NoShock')
    error('Wrong safe zones definition')
end

Pre_Occup_Shock = squeeze(Pre_Occup(:,1));
Cond_Occup_Shock = squeeze(Cond_Occup(:,1));
Post_Occup_Shock = squeeze(Post_Occup(:,1));

Pre_Occup_Safe = squeeze(Pre_Occup(:,2));
Cond_Occup_Safe = squeeze(Cond_Occup(:,2));
Post_Occup_Safe = squeeze(Post_Occup(:,2));

if extended
    if ~strcmp(a.behavResources(id_Post(k)).ZoneLabels{5}, 'CentreNoShock')
        error('Wrong centre no shock zones definition')
    end
    if ~strcmp(a.behavResources(id_Post(k)).ZoneLabels{3}, 'Centre')
        error('Wrong centre no shock zones definition')
    end
    if length(a.behavResources(id_Post(k)).ZoneLabels)==9
        if ~strcmp(a.behavResources(id_Post(k)).ZoneLabels{8}, 'FarShock')
            error('Wrong centre no shock zones definition')
        end
        if ~strcmp(a.behavResources(id_Post(k)).ZoneLabels{9}, 'FarNoShock')
            error('Wrong centre no shock zones definition')
        end
    end

    Pre_Occup_Safe = Pre_Occup_Safe + squeeze(Pre_Occup(:,5)) + squeeze(Pre_Occup(:,3));
    if length(a.behavResources(id_Post(k)).ZoneLabels)==9
        Pre_Occup_Safe = Pre_Occup_Safe + squeeze(Pre_Occup(:,8)) + squeeze(Pre_Occup(:,9));
    end
    Cond_Occup_Safe = Cond_Occup_Safe + squeeze(Cond_Occup(:,5)) + squeeze(Cond_Occup(:,3));
    if length(a.behavResources(id_Post(k)).ZoneLabels)==9
         Cond_Occup_Safe = Cond_Occup_Safe + squeeze(Cond_Occup(:,8)) + squeeze(Cond_Occup(:,9));
    end
    Post_Occup_Safe = Post_Occup_Safe + squeeze(Post_Occup(:,5))+ squeeze(Post_Occup(:,3));
    if length(a.behavResources(id_Post(k)).ZoneLabels)==9
       Post_Occup_Safe = Post_Occup_Safe + squeeze(Post_Occup(:,8)) + squeeze(Post_Occup(:,9));
    end
end

Pre_Occup_Shock_mean = mean(Pre_Occup_Shock,2);
Pre_Occup_Shock_std = std(Pre_Occup_Shock,0,2);
Cond_Occup_Shock_mean = mean(Cond_Occup_Shock,2);
Cond_Occup_Shock_std = std(Cond_Occup_Shock,0,2);
Post_Occup_Shock_mean = mean(Post_Occup_Shock,2);
Post_Occup_Shock_std = std(Post_Occup_Shock,0,2);

Pre_Occup_Safe_mean = mean(Pre_Occup_Safe,2);
Pre_Occup_Safe_std = std(Pre_Occup_Safe,0,2);
Cond_Occup_Safe_mean = mean(Cond_Occup_Safe,2);
Cond_Occup_Safe_std = std(Cond_Occup_Safe,0,2);
Post_Occup_Safe_mean = mean(Post_Occup_Safe,2);
Post_Occup_Safe_std = std(Post_Occup_Safe,0,2);

% Wilcoxon signed rank task between Pre and PostTest
p_pre_post = signrank(Pre_Occup_Shock_mean, Post_Occup_Shock_mean);
end

