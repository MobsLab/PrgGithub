function [numNeurons, numtt, TT]=GetSpikesFromStructure(Struct, varargin)

%
% inputs:
% Struct = structure e.g.'PFCx' 'Bulb' ...

% res (optional):           directory, default is current directory
% remove_MUA (optional):    1 to remove clusters MUA (clusters 1),1 by default     
% hemisphere (optional):    'right' or 'left'  
% verbose (optional):       1 to display logs, 0 otherwise

%
% outputs:
% S:                tsd array containing spikes, from SpikeData.mat
% numNeurons:       num of neurons of S corresponding to Struct
% numtt:            #tetrodes corresponding to Struct


%% CHECK INPUTS

if nargin < 1 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'res'
            res = varargin{i+1};
        case 'remove_mua'
            remove_MUA = varargin{i+1};
            if remove_MUA~=0 && remove_MUA ~=1
                error('Incorrect value for property ''remove_MUA''.');
            end
        case 'hemisphere'
            hemisphere = varargin{i+1};
            if ~isstring_FMAToolbox(hemisphere, 'right' , 'left', 'r', 'l')
                error('Incorrect value for property ''optiontest''.');
            end
        case 'verbose'
            verbose = varargin{i+1};
            if verbose~=0 && verbose ~=1
                error('Incorrect value for property ''verbose''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('res','var')
    res=pwd;
end
if ~exist('remove_MUA','var')
    remove_MUA=1;
end
if ~exist('verbose','var')
    verbose=1;
end

%load Data
eval(['load(''',res,'/SpikeData.mat'',''tetrodeChannels'',''TT'');'])
nb_neurons_total = length(TT);


%% Getting channels for structure
eval(['load(''',res,'/LFPData/InfoLFP.mat'',''InfoLFP'');'])
idx_struct = strcmpi(InfoLFP.structure,Struct);
if exist('hemisphere','var')
    idx_hemisphere = strcmpi(InfoLFP.hemisphere, hemisphere(1));
    idx_struct = idx_struct .* idx_hemisphere;
end

chans=InfoLFP.channel(idx_struct==1);
if size(chans,1)>1
    chans = chans';
end
if verbose
    disp(['    channels for ',Struct,': ',num2str(chans)])
end


%% find corresponding neurons
if exist('tetrodeChannels','var') && exist('TT','var')
    numtt = [];
    for cc=1:length(chans)
        for tt=1:length(tetrodeChannels)
            if any(tetrodeChannels{tt}==chans(cc))
                numtt = [numtt,tt];
            end
        end
    end
    numtt = unique(numtt);
    
    numNeurons = [];
    for i=1:nb_neurons_total
        if ismember(TT{i}(1), numtt) 
            if remove_MUA && TT{i}(2)>1
                numNeurons = [numNeurons, i];
            elseif remove_MUA==0
                numNeurons = [numNeurons, i];
            end
        end
    end
    if verbose
        disp(['    ', num2str(length(numNeurons)), ' neurons found from tetrodes ', num2str(unique(numtt))])
    end
else
    if verbose
        disp('No neuron found')
    end
    numNeurons = [];
    numtt = [];
end

end
 