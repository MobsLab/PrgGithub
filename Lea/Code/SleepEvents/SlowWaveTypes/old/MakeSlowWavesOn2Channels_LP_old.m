%% MakeSlowWavesOn2Channels_LP()
% 
% 14/05/2020  LP
%
% Function to create or append a 'SlowWaves2Channels_LP.mat' file
% with slow waves (8 combinations) detected on TWO channels.
% -> combination of positive / negative / none 1-channel slow waves
%    on superficial and deep channels 
% -> deep and sup slow waves considered as co-occurring when peaks closer
% than 'cooccur_window' ms (100ms)
% -> slow waves = each type has a structure with : 
%                 - deep_peaktimes & sup_peaktimes :    ts of slow waves peak times (on deep and/or sup slow waves)
%                 - deep_peakamp & sup_peakamp :      tsd of slow waves peak amplitudes (on deep and/or sup slow waves)
%
%
% Slow Wave Types : 
%       1) deepneg-supneg
%       2) deepneg-suppos
%       3) deeppos-supneg 
%       4) deeppos-suppos
%       5) deepneg-øsup
%       6) deeppos-øsup
%       7) ødeep-supneg
%       8) ødeep-suppos
%
%
% ----------------- INPUTS ----------------- :
%
% - deep_ch  :  nº of deep LFP channel used for the detection
%
% - sup_ch  :  nº of sup LFP channel used for the detection
%                           
%
% -- Optional Parameters -- : 
% (as pairs : 'arg_name', arg_value) 
%
%   - 'foldername' :       folder path for the detection of slow waves
%                                   (default = pwd)
%
%   - 'epoch' :            epoch to which the detection is retsricted
%                                   'all', 'sleep', 'SWS'
%                                   (default = 'all') 
%
%   - 'filterfreq' :       frequency range to filter the LFP signal
%                                   before extracting events
%                                   (default = [1 5])
%
%   - 'recompute' :        recompute event if file and variables already
%                                   exist
%                                   (default = 0)
%
%   - 'filename' :         name of .mat file with the events
%                                   (default = 'SlowWaves2Channels_LP') 
%
%   - 'cooccur_delay' :    max duration between sup and deep SW peaks to
%                           be detected as co-occurring slow waves, in ms
%                                   (default = 100)
%
% ----------------- OUTPUTS ----------------- :
%
%                                       none
%
%
% ----------------- Example ----------------- :
%
% Ex.  MakeSlowWavesOn2Channels_LP(ChannelDeep, ChannelSup, 'epoch', 'all','filterfreq', [1 5]);


function MakeSlowWavesOn2Channels_LP(deep_ch,sup_ch, varargin)

%% CHECK INPUTS

if nargin < 2 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list :

for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    
    switch(lower(varargin{i}))
        case 'foldername'
            foldername = varargin{i+1};
        case 'filterfreq'
            filterfreq = varargin{i+1};
        case 'epoch'
            epochname = lower(varargin{i+1});
            if ~isstring_FMAToolbox(epochname, 'all' , 'sws', 'sleep')
                error('Incorrect value for property ''epoch''.');
            end
        case 'recompute'
            recompute = varargin{i+1};
            if recompute~=0 && recompute ~=1
                error('Incorrect value for property ''recompute''.');
            end
        case 'filename'
            filename = varargin{i+1};  
        case 'cooccur_delay'
            cooccur_delay = varargin{i+1};       
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if optional parameters exist and assign default value if not :

if ~exist('foldername','var')
    foldername=pwd;
end
if ~exist('epochname','var')
    epochname='all';
end
if ~exist('filterfreq','var')
    filterfreq = [1 5];
end
if ~exist('filename','var')
    filename = 'SlowWaves2Channels_LP' ;
end
if ~exist('cooccur_delay','var')
    cooccur_delay = 100 ;
end    
%recompute?
if ~exist('recompute','var')
    recompute=0;
end



%check if already exist : return if already exists and recompute = 0
if ~recompute
    if exist('SlowWaves2Channels_LP.mat','file')==2
        disp(['Slow Waves already generated.'])
        return
    end
end


%% PARAMETERS : 

% See in MakeSlowWavesOnChannelsEvent_LP


%% 1-CHANNEL SLOW WAVES DETECTION : 

% Compute 1-channel slow waves if not already done :
MakeSlowWavesOn1Channel_LP(sup_ch, 'foldername',foldername, 'epoch', 'all','filterfreq', [1 5]);
MakeSlowWavesOn1Channel_LP(deep_ch, 'foldername',foldername, 'epoch', 'all','filterfreq', [1 5]);

% Load 1-channel slow waves : 
load('SlowWavesChannels_LP.mat')
eval(['SWdeeppos = slowwave_ch_' num2str(deep_ch) '_pos ;'])
eval(['SWdeepneg = slowwave_ch_' num2str(deep_ch) '_neg ;'])
eval(['SWsuppos = slowwave_ch_' num2str(sup_ch) '_pos ;'])
eval(['SWsupneg = slowwave_ch_' num2str(sup_ch) '_neg ;'])



%% 2-CHANNEL SLOW WAVES SORTING : 

disp('Computing 2-channel slow waves...') ;

% All structures : 
%   - slowwaves_type1
%   - slowwaves_type2
%   - slowwaves_type3
%   - slowwaves_type4
%   - slowwaves_type5
%   - slowwaves_type6
%   - slowwaves_type7
%   - slowwaves_type8

cooccur_window = [cooccur_delay,cooccur_delay] ; % timewindow between sup and deep SW peaks to be considered as co-occurring, in ms


% ----------- Sort by deep slow waves first ----------- :


% Look at whether deep SW peak occurs during a sup SW (interval) :

% Deep NEGATIVE SW (-> types 1/2/5) : 

    % during a sup negative SW (type 1)
    [cooccur, slowwave_type1.deep_peaktimes] = EventsCooccurrence(SWdeepneg.peaktimes,SWsupneg.peaktimes,cooccur_window) ; % find co-occurrence and store deep peaktime for slow wave type 1
    ix_type1 = find(cooccur) ; 
    slowwave_type1.deep_peakamp = subset(SWdeepneg.peakamp,ix_type1) ; % store peak amplitude
    
    % during a sup positive SW (type 2)    
    [cooccur, slowwave_type2.deep_peaktimes] = EventsCooccurrence(SWdeepneg.peaktimes,SWsuppos.peaktimes,cooccur_window) ; 
    ix_type2 = find(cooccur) ; 
    slowwave_type2.deep_peakamp = subset(SWdeepneg.peakamp,ix_type2) ;
    
    % during no sup SW (type 5) 
    ix_type5 = setdiff(1:length(Range(SWdeepneg.peaktimes)),[ix_type1;ix_type2]) ; % ix_type5 = index of deep negative SW which don't occur during a sup SW (all indices minus indices from type 1 and 2)
    slowwave_type5.deep_peakamp = subset(SWdeepneg.peakamp,ix_type5) ; % negative deep SW during no sup SW (index ix_type5)
    slowwave_type5.deep_peaktimes = ts(Range(slowwave_type5.deep_peakamp)) ; 
    
    
      
% Deep POSITIVE SW (-> types 3/4/6) : 

    % during a sup negative SW (type 3 / delta)
    [cooccur, slowwave_type3.deep_peaktimes] = EventsCooccurrence(SWdeeppos.peaktimes,SWsupneg.peaktimes,cooccur_window) ; % find co-occurrence and store deep peaktime for slow wave type 1
    ix_type3 = find(cooccur) ; 
    slowwave_type3.deep_peakamp = subset(SWdeeppos.peakamp,ix_type3) ; % store peak amplitude
    
    % during a sup positive SW (type 4)    
    [cooccur, slowwave_type4.deep_peaktimes] = EventsCooccurrence(SWdeeppos.peaktimes,SWsuppos.peaktimes,cooccur_window) ; 
    ix_type4 = find(cooccur) ; 
    slowwave_type4.deep_peakamp = subset(SWdeeppos.peakamp,ix_type4) ;
    
    % during no sup SW (type 6) 
    ix_type6 = setdiff(1:length(Range(SWdeeppos.peaktimes)),[ix_type3;ix_type4]) ; % ix_type6 = index of deep positive SW which don't occur during a sup SW (all indices minus indices from type 3 and 4)
    slowwave_type6.deep_peakamp = subset(SWdeeppos.peakamp,ix_type6) ; 
    slowwave_type6.deep_peaktimes = ts(Range(slowwave_type6.deep_peakamp)) ; 

 
    
% ----------- Sort by sup slow waves first ----------- :


% Look at whether sup SW peak co-occurs with a deep SW peak, within cooccur_window timewindow :

% Sup NEGATIVE SW (-> types 1/3/7) : 

    % during a deep negative SW (type 1)
    [cooccur, slowwave_type1.sup_peaktimes] = EventsCooccurrence(SWsupneg.peaktimes,SWdeepneg.peaktimes,cooccur_window) ; 
    ix_type1 = find(cooccur) ; 
    slowwave_type1.sup_peakamp = subset(SWsupneg.peakamp,ix_type1) ;
    
    % during a deep positive SW (type 3 / delta)    
    [cooccur, slowwave_type3.sup_peaktimes] = EventsCooccurrence(SWsupneg.peaktimes,SWdeeppos.peaktimes,cooccur_window) ; 
    ix_type3 = find(cooccur) ; 
    slowwave_type3.sup_peakamp = subset(SWsupneg.peakamp,ix_type3) ;
    
    % during no deep SW (type 7) 
    ix_type7 = setdiff(1:length(Range(SWsupneg.peaktimes)),[ix_type1;ix_type3]) ; % ix_type7 = index of sup negative SW which don't occur during a deep SW 
    slowwave_type7.sup_peakamp = subset(SWsupneg.peakamp,ix_type7) ; 
    slowwave_type7.sup_peaktimes = ts(Range(slowwave_type7.sup_peakamp)) ; 
    
    
      
% Sup POSITIVE SW (-> types 2/4/8) : 

    % during a deep negative SW (type 2)
    [cooccur, slowwave_type2.sup_peaktimes] = EventsCooccurrence(SWsuppos.peaktimes,SWdeepneg.peaktimes,cooccur_window) ; 
    ix_type2 = find(cooccur) ; 
    slowwave_type2.sup_peakamp = subset(SWsuppos.peakamp,ix_type2) ;
    
    % during a deep positive SW (type 4)    
    [cooccur, slowwave_type4.sup_peaktimes] = EventsCooccurrence(SWsuppos.peaktimes,SWdeeppos.peaktimes,cooccur_window) ; 
    ix_type4 = find(cooccur) ; 
    slowwave_type4.sup_peakamp = subset(SWsuppos.peakamp,ix_type4) ;
    
    % during no deep SW (type 8) 
    ix_type8 = setdiff(1:length(Range(SWsuppos.peaktimes)),[ix_type2;ix_type4]) ; % ix_type8 = index of sup positive SW which don't occur during a deep SW
    slowwave_type8.sup_peakamp = subset(SWsuppos.peakamp,ix_type8) ; 
    slowwave_type8.sup_peaktimes = ts(Range(slowwave_type8.sup_peakamp)) ; 


%% SAVE OUTPUT 

% Save detection parameters : 
detection_parameters.deepchannel = deep_ch ; 
detection_parameters.supchannel = sup_ch ; 
detection_parameters.cooccur_delay = cooccur_delay ; 

% Save file : 
save(fullfile(foldername,[filename '.mat']), 'slowwave_type1', 'slowwave_type2', 'slowwave_type3', 'slowwave_type4', 'slowwave_type5', 'slowwave_type6', 'slowwave_type7', 'slowwave_type8', 'detection_parameters')
disp('Done') 

end











