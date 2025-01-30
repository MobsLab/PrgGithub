% Anova1Data_KJ
% 07.07.2017 KJ
%
% Function formatting data and returning anova stat 
%   [p,tbl,stats] = Anova1Data_KJ(data, group_names, varargin)
%
%%%%%
% INPUT :
%   data:           struct - data used for stat
%   data:           cell arrays - name of the groups
% 
%   to_plot:        bool - 1 to plot, 0 otherwise
%                   (default 1)
%%%%%
%   (OPTIONAL)
%
%%%%%
%   EXAMPLE : 
%
% 
%
% See
%   
%


function [p,tbl,stats] = Anova1Data_KJ(data, group_names, varargin)


%% CHECK INPUTS
if nargin < 1 || mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin),
    if ~ischar(varargin{i}),
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i})),
        case 'to_plot',
            to_plot = varargin{i+1};
            if to_plot~=1 && to_plot~=0
                error('Incorrect value for property ''to_plot''.');
            end
        otherwise,
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
        
    end
end

if ~exist('group_names','var')
    group_names = cell(0);
    for i=1:length(data)
        group_names{end+1} = ['group' num2str(i)];
    end
end
if ~exist('to_plot','var')
    to_plot=1;
end


%% eventually formating A to cell
if ~iscell(data)
    tempA=data; data={};
    for i=1:size(tempA,2)
        data{i}=tempA(:,i);
    end
end


%% data
all_data = [];
group = cell(0);

for gp=1:length(data);
    if size(data{1},1)==1
        all_data = [all_data data{gp}];
    else
        all_data = [all_data; data{gp}];
    end
    nb_data = length(data{gp});
    group(end+1:end+nb_data) = group_names(gp);
end

%% ANOVA
[p,tbl,stats] = anova1(all_data,group);
%[c,~,~,gnames] = multcompare(stats);


end


