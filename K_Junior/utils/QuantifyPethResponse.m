%%QuantifyPethResponse
% 16.04.2018 KJ
%
% Classify the responses of neurons to a series of events (stimuli)
%
% function [responses, time_responses] = QuantifyPethResponse(S, tEvents, varargin)
%
% INPUT:
% - S                           struct of tsd - spike data
% - tEvents                     ts of events (e.g tones, stim...)     
%
% - binsize (optional)          = binsize for the PETH 
%                               (default 5ms)
% - smoothing (optional)        = smoothing value for kernel smooth 
%                               (default 1)
% - window (optional)           = response window, where the neural response is expected  
%                               (default >0 ms)
% - Epoch (optional)            = epoch on which MUA is restricted 
%                               (default no restrict)
%
%
%
% OUTPUT:
% - responses             = list of responses, for each neurons 
%                           (-1 for inhibited, 1 for excitated, 0 for null)
%
%
%   see 
%       
%


function responses = QuantifyPethResponse(S, tEvents, varargin)


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
        case 'binsize'
            binsize = varargin{i+1};
            if binsize<=0
                error('Incorrect value for property ''binsize''.');
            end
        case 'smoothing'
            smoothing = varargin{i+1};
            if smoothing<0
                error('Incorrect value for property ''smoothing''.');
            end
        case 'window'
            window = varargin{i+1};
        case 'Epoch'
            Epoch = varargin{i+1};
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('binsize','var')
    binsize=2;
end
if ~exist('smoothing','var')
    smoothing=1;
end
if ~exist('window','var')
    window=[0 150];
end

nb_bins = 500;
nb_perm = 1000;


%% Events
if exist('Epoch','var')
    tEvents = Restrict(tEvents, Epoch);
end
event_tmp = Range(tEvents);


%% z-scored correlograms
for i=1:length(S)

    %Correlogram for each neuron
    [Cevents{i}, xc] = CrossCorr(event_tmp, Range(PoolNeurons(S,i)), binsize,nb_bins);
    %zscore
    Cevents{i} = zscore(Cevents{i});
    %smooth
    sCevents{i} = smooth(Cevents{i}, smoothing);
    
    %window
    idxW = xc>=window(1) & xc<=window(2);
    
    % Cumsum of shuffle sPETH
    for n=1:nb_perm
        shuffleC{i}(n,:) = cumsum(sCevents{i}(randperm(length(sCevents{i}))));
        %max - min
        Sdiff{i}(n) = max(shuffleC{i}(n,:)) - min(shuffleC{i}(n,:));
        %mean of the derivative just after the sound
        Sderiv{i}(n) = mean(diff(shuffleC{i}(n,idxW)));
    end
    
    %percentile
    perc_sdiff(i,1) = prctile(Sdiff{i},95);
    perc_sderiv(i,1) = prctile(Sderiv{i},92);
    
    %value for real PETH
    realC{i}   = cumsum(sCevents{i});
    Rdiff(i,1) = max(realC{i}) - min(realC{i});
    Rderiv(i,1) = mean(diff(realC{i}(idxW)));
    
end


%% response of neurons
responses = zeros(length(S),1);

responsive_neurons = unique(find((Rdiff>perc_sdiff & Rderiv>perc_sderiv) | Rdiff>1.3*perc_sdiff));

for i=1:length(responsive_neurons)
    n = responsive_neurons(i);
    responses(n) = sign(mean(diff(realC{n}(xc>0&xc<150))));
end


end



