% CreateSyncDownStatesLocal
% 20.09.2019 KJ
%
% Create a tsd with Local Down States sync measures
%
% INPUTS
%
% windowsize (optional):        window on which is computed the synchronisation measures      
%                               (default 10e4)
% timestep (optional):          time between two window consecutive centers
%                               (default 5e4)
% hemisphere (optional):        hemisphere eventually ('l' or 'r'
%                               (default  '')
% tetrodes (optional):          list of selected tetrodes for the sync
%                               (default all)
%
%
%%OUTPUT
% SyncLocalDown:                tsd - sync during night
%
% 
%%SEE 
%   
%
% 



function SyncLocalDown = CreateSyncDownStatesLocal(varargin)

%% Initiation

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'windowsize'
            windowsize = varargin{i+1};
        case 'timestep'
            timestep = varargin{i+1};
        case 'tetrodes'
            idtetrodes = varargin{i+1};
        case 'hemisphere'
            hemisphere = varargin{i+1};
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('windowsize','var')
    windowsize = 10e4;
end
if ~exist('timestep','var')
    timestep = 5e4;
end
if ~exist('hemisphere','var')
    hemisphere = [];
end
if ~exist('idtetrodes','var')
    idtetrodes = [];
end


%% load

%night duration
load('IdFigureData2.mat', 'night_duration')

%Global Down
if ~isempty(hemisphere)
    load('DownState.mat', ['alldown_PFCx_' hemisphere])
    eval(['GlobalDown = alldown_PFCx_' hemisphere ';']);
else
    load('DownState.mat', 'alldown_PFCx')
    GlobalDown = alldown_PFCx;
end


%Local
load('LocalDownState.mat', 'all_local_PFCx')
AllDown_local = all_local_PFCx;
if ~isempty(idtetrodes)
    AllDown_local = AllDown_local(idtetrodes);
end
nb_tetrodes = length(AllDown_local);


%Union
UnionAllDown = intervalSet([],[]);
for tt=1:nb_tetrodes
    UnionAllDown = or(UnionAllDown,AllDown_local{tt});
end
UnionAllDown = CleanUpEpoch(dropLongIntervals(UnionAllDown, 2e4),1); %not more than 2sec


%% Create intervals

%params
hw = windowsize/2; %half window
intervals_start = 0:timestep:(night_duration-hw);
x_density = (intervals_start + hw)';
    
%density
y_inters = zeros(length(intervals_start),1);
y_union  = zeros(length(intervals_start),1);

for t=1:length(intervals_start)
    intv = intervalSet(intervals_start(t)-hw, intervals_start(t)+hw);
    y_inters(t) = tot_length(and(GlobalDown,intv)) / windowsize;
    y_union(t)  = tot_length(and(UnionAllDown,intv)) / windowsize;
end

y_sync = y_inters ./ (y_union+0.001);;
y_sync(y_union==0) = 0;

% tsd
SyncLocalDown = tsd(x_density, y_sync);


end









