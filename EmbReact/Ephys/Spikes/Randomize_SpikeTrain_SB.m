% Randomize_SpikeTrain_SB
% 07.12.2017 (SB)
%
% AllSpikesRand_ts = Randomize_SpikeTrain_SB(S,TotEpoch,numBootstrap,varargin)
% 
% Input: 
%   - S : ts of spike times
%   - TotEpoch : Epoch to use for resampling (NO NOISE)
%   - num_bootstraps :  number of randomizations to perform
%   - RandType (optional) : type of randomization procedure
%           isi_shuffle : shuffle the ISIs (breaks long term temp
%           structure)
%           split_mix : takes random point in data, splits in two and flips
%           the two halves 
%
% Output : 
%   - AllSpikesRand_ts : cell array of ts of randomized spike times
%




function AllSpikesRand_ts = Randomize_SpikeTrain_SB(S,TotEpoch,num_bootstraps,varargin)

%% Initiation
% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'randtype'
            randtype = varargin{i+1};
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

if not(exist(randtype))
    randtype='isi_shuffle';
end

% Get function to take fist spike

SpikeRate = FiringRateEpoch(S,TotEpoch);
DistFirstSpike  = makedist('Exponential','mu',SpikeRate);


% Map the spikes onto a continuous time frame that includes only epochs of
% interest

% These start and stop times are not consecutive
StartTime = Start(TotEpoch);
StopTime = Stop(TotEpoch);
Dur = StopTime - StartTime;
% These start and stop times are consecutive
NewStopTime = cumsum(Dur);
NewStartTime = cumsum(Dur)-Dur;

% Get spikes from each epoch and put them into the artifical consecutive
% epochs
AllSpikes_Consec = [];
for ep = 1 : length(Start(TotEpoch))
    LitEp = subset(TotEpoch,ep);
    SpikeTimes_temp=Range(Restrict(S,LitEp));
    SpikeTimes_temp = SpikeTimes_temp-StartTime(ep)+NewStartTime(ep);
    AllSpikes_Consec = [AllSpikes_Consec ;SpikeTimes_temp];
end

ISI=diff(AllSpikes_Consec);
for ep = 1 : length(NewStartTime)
    NewLitEp{ep} = intervalSet(NewStartTime(ep),NewStopTime(ep));
end
    
for k= 1 : num_bootstraps
    
    % Now randomize
    
    
    switch(lower(randtype))
        case 'isi_shuffle'
            % shuffle ISI
            ISI_rand=ISI(randperm(length(ISI)));
            FirstSpike = random(DistFirstSpike);
            Rand_Spikes=cumsum([FirstSpike;ISI_rand]);
        case 'split_mix'
            % keep all temporal structure but randomly cut in half
            randtime = rand(1)*max(NewStopTime);
            Rand_Spikes = sort(mod(AllSpikes_Consec+randtime,max(NewStopTime)));
    end
    
    
    Rand_Spikes_ts=ts(Rand_Spikes);
    
    % Get spikes from each  artifical consecutive epochs and put back to
    % real epochs

    AllSpikesRand= [];
    
    for ep = 1 : length(NewStartTime)
        SpikeTimes_temp=Range(Restrict(Rand_Spikes_ts,NewLitEp{ep}));
        SpikeTimes_temp = SpikeTimes_temp-NewStartTime(ep)+StartTime(ep);
        AllSpikesRand = [AllSpikesRand ;SpikeTimes_temp];
    end
    
    
    % Make output : tsd of randomized spike times
    
    AllSpikesRand_ts{k} = ts(AllSpikesRand);
    
end

