% MakeSpindlesDreemRecord
% 19.11.2018 KJ
%
%%INPUT
% 
% 
%%OUTPUT
% 
%
% SEE
%   MakeSlowWavesDreemRecord
%
%


function [SpindlesEpoch, labels] = MakeSpindlesDreemRecord(filereference,Dir,varargin)


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
    savefile = fullfile(savefolder, ['Spindles_' num2str(Dir.filereference{p}) '.mat']);
    if ~recompute && exist(savefile,'file')==2
        load(savefile);
        disp('already computed');
        return
    end
end


%% compute
%Get record
[signals, ~, ~, StageEpochs, labels] = GetRecordDreem(Dir.filename{p});
N2N3 = or(StageEpochs{2}, StageEpochs{3}); 

%Get Quality
[~, NoiseEpoch] = GetDreemQuality(Dir.filereference{p});
NoiseEpoch{5} = NoiseEpoch{1};
NoiseEpoch{6} = NoiseEpoch{2};
signals = signals(1:6);


%find Spindles
for ch=1:length(signals)
    params.noise_epoch = NoiseEpoch{ch};
    SpindlesEpoch{ch} = FindSpindlesDreem(signals{ch},'method','mensen','params',params);
end


%save
if recompute || exist(savefile,'file')~=2
    save(savefile,'SpindlesEpoch','labels')
end

end







