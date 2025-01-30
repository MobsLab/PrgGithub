% MakeSlowWavesDreemRecord
% 27.03.2018 KJ
%
%%INPUT
% 
% 
%%OUTPUT
% 
%
% SEE
%   DreemIDStimImpact
%
%


function [SlowWaveEpochs, labels] = MakeSlowWavesDreemRecord(filereference,Dir,varargin)


% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'savefolder'
            savefolder = varargin{i+1};
        case 'recompute'
            recompute = varargin{i+1};
            if recompute~=0 && recompute ~=1
                error('Incorrect value for property ''recompute''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('Dir','var') || isempty(Dir)
    Dir = ListOfDreemRecordsStimImpact('all');
    p = find(cell2mat(Dir.filereference)==filereference);
else
    p = filereference;
end
if ~exist('savefolder','var')
    savefolder = [];
end
if ~exist('recompute','var')
    recompute = 0;
end

%recompute ?
if ~isempty(savefolder)
    savefile = fullfile(savefolder, ['SlowWaves_' num2str(Dir.filereference{p}) '.mat']);
    if ~recompute && exist(savefile,'file')==2
        load(savefile);
        disp('already computed');
        return
    end
end

%FolderStimImpactPreprocess,'SlowWaves'

%% compute
%Get record
[signals, ~, ~, StageEpochs, labels] = GetRecordDreem(Dir.filename{p});
N2N3 = or(StageEpochs{2}, StageEpochs{3}); 

%find Slow Wave
for ch=1:length(signals)
    SlowWaveEpochs{ch} = and(FindSlowWaves(signals{ch}), N2N3);
end


%save
if recompute || exist(savefile,'file')~=2
    save(savefile,'SlowWaveEpochs','labels')
end

end







