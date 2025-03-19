% MakeSpectrogramDreemRecord
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


function [Spectros, labels] = MakeSpectrogramDreemRecord(filereference,Dir,varargin)


% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'savefolder'
            savefolder = varargin{i+1};
        case 'channels'
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
    disp('')
    disp('need a folder to save data')
    return
end
if ~exist('recompute','var')
    recompute = 0;
end


%params
params.fpass  = [0.4 40];
params.tapers = [3 5];
movingwin     = [3 0.2];
params.Fs     = 250;

mkdir(savefolder);


%% compute
%Get record
[signals, ~, ~, ~, labels] = GetRecordDreem(Dir.filename{p});

%for each channels
for ch=1:length(signals)
    
    savefile = fullfile(savefolder,num2str(Dir.filereference{p}),['Spectro_' num2str(Dir.filereference{p}) '_ch_' num2str(ch) '.mat']);
    
    if recompute || exist(savefile,'file')~=2
        [Sp,t,f] = mtspecgramc(Data(signals{ch}), movingwin, params);
        Spectro  = {Sp,t,f};
        
        label=labels{ch}; channel=num2str(ch);
        mkdir(fullfile(savefolder, num2str(Dir.filereference{p})));
        save(savefile,'Spectro','labels','params','movingwin', 'channel', '-v7.3')
    end

end






end







