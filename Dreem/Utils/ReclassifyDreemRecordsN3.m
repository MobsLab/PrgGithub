%%ReclassifyDreemRecordsN3
% 28.03.2018 KJ
%
%   NewHypnogram = ReclassifyDreemRecordsN3(signals,StageEpochs, SlowWavesEpochs, varargin)
%
%
% INPUT:
% - StageEpochs             struct - structure of Sleep Epoch
% - SlowWavesEpochs         intervalSet - slow waves intervals
%
% (OPTIONAL)
% - threshold               threshold (between 0 and 1) for the classification of N3
%
%%
% OUTPUT:
% - NewHypnogram:           tsd - phase of the signal
%
%
%       see 
%

function NewHypnogram = ReclassifyDreemRecordsN3(StageEpochs, SlowWavesEpochs, varargin)


%% CHECK INPUTS

if nargin < 2 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'threshold'
            threshold = varargin{i+1};
            if threshold<=0
                error('Incorrect value for property ''threshold''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
        
    end
end

if ~exist('threshold','var')
    threshold = 0.1; % 10% of the epoch for the negative part of slow waves
end
epochsize = 30e4;


%% Divide stage epoch in 30s epochs
for st=1:length(StageEpochs)
    new_starts = [];
    
    durations = End(StageEpochs{st}) - Start(StageEpochs{st});
    st_epoch = Start(StageEpochs{st});
    
    for i=1:length(st_epoch)
        nb_newepoch = durations(i) / epochsize;
        for k=1:nb_newepoch
            new_starts = [new_starts st_epoch(i)+(k-1)*epochsize];
        end
    end
    
    Hypnogram{st} = intervalSet(new_starts ,new_starts + epochsize);

end


%% look for slowwaves in each substages
for st=1:length(Hypnogram)
    newStartHyp{st} = [];
end

for st=1:length(Hypnogram)
    for i=1:length(Start(Hypnogram{st}))
        subEpoch = subset(Hypnogram{st}, i);
        
        if tot_length(and(subEpoch,SlowWavesEpochs))>threshold*epochsize
            newStartHyp{3} = [newStartHyp{3} Start(subEpoch)];
        else
            if st~=3
                newStartHyp{st} = [newStartHyp{st} Start(subEpoch)];
            else
                newStartHyp{2} = [newStartHyp{2} Start(subEpoch)];
            end
        end
        
    end
end


for st=1:length(Hypnogram)
    newStartHyp{st} = sort(newStartHyp{st});
    NewHypnogram{st} = intervalSet(newStartHyp{st} ,newStartHyp{st} + epochsize);
end


end





