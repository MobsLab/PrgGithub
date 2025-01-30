Dir = PathForExperimentsSlowWavesLP_HardDrive ;
cd(Dir.path{10})



% ------------------------------------------ Load Data ------------------------------------------ :


% LFP :

load('ChannelsToAnalyse/PFCx_deep')
load(['LFPData/LFP',num2str(channel)])
LFPdeep = LFP;
ChannelDeep = channel ;

load('ChannelsToAnalyse/PFCx_sup')
load(['LFPData/LFP',num2str(channel)])
LFPsup = LFP;
ChannelSup = channel ;

load('ChannelsToAnalyse/Bulb_deep')
load(['LFPData/LFP',num2str(channel)])
LFPOBdeep = LFP;
ChannelOBdeep = channel ;
clear LFP channel


% EVENTS

load("DownState.mat", 'alldown_PFCx')
load("DeltaWaves.mat", 'alldeltas_PFCx')
load('Ripples.mat')
downstates_ts = ts((Start(alldown_PFCx)+End(alldown_PFCx))/2) ; % convert to ts with mid time
diffdelta_ts = ts((Start(alldeltas_PFCx)+End(alldeltas_PFCx))/2) ; % convert to ts with mid time (differential Delta = as computed by KJ)


% 2-Channel Slow Waves : 
load('SlowWaves2Channels_LP.mat')
    % Data : 

% SUBSTAGES :
% Clean SWS Epoch
load('SleepSubstages.mat')
SWS = Epoch{strcmpi(NameEpoch,'SWS')} ;
load NoiseHomeostasisLP TotalNoiseEpoch % noise
cleanSWS = diff(SWS,TotalNoiseEpoch) ; 
% REM & Wake Epochs
REM = Epoch{strcmpi(NameEpoch,'REM')} ;
WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;
% Zeitgeber time
load('behavResources.mat', 'NewtsdZT')



% ------------------------------------------ PARAMETERS ------------------------------------------ :



% -------------- Choose Parameters -------------- :

windowsize = 60 ; % duration of sliding window, in seconds (/!\ no overlap)

merge_closewake = 1 ; % minimal sleep duration (in minutes) to consider a wake period as "interrupted", for multiple fits 
% (ie. do not take into account sleep when shorther than this duration for the detection of wake episodes) 

afterREM1 = false ; % if true, quantif only after the 1st REM episode 

artefact_thresh = 'none' ; % removes values higher from analysis (considered as artefacts), in % of mean NREM value. Else = 'none';

events_subset = 'all' ; 
% 'all' (keep all events), 'downcooccur' (only events co-occuring with down states) or 'notdowncooccur' (only events NOT co-occuring with down states) 
% 'nexttodown' (only events co-occuring < 300ms from down state middle) or 'notnexttodown' (only events not co-occuring < 300ms from down state middle)



% -------------- Sliding timeWindows (no overlap) -------------- :

t = Range(LFPdeep)/(1E4) ;
window_starts = t(1):windowsize:(t(end)-windowsize) ;
all_timewindows = intervalSet(window_starts*1E4, (window_starts+windowsize)*1E4) ;

    % Restrict timewindows to SWS :
    epoch = cleanSWS ;
    epoch_timewindows = intersect(all_timewindows,epoch) ;
    epoch_timewindows = dropShortIntervals(epoch_timewindows,3e4) ; % drop intervals shorter than 3s
    
                    % To check length of timewindows :  figure, histogram(Data(length(epoch_timewindows))/(1e4),20)
          
  
    % Get starting time for fits :
    if afterREM1 
        fit_start = getfield(Start(REM),{1}) ; 
    else
        fit_start = 0 ;
    end
  
    
% --- Out of epoch intervals (to assign NaN values)--- :

session = intervalSet(t(1)*1e4,t(end)*1e4); % whole session
outofepoch = diff(session,epoch_timewindows);

    % If out of epoch is not empty : 
    if mean(length(outofepoch)) ~= 0 
        outofepoch_timewindows = intersect(all_timewindows,outofepoch) ; %timewindows out of epoch
        outofepoch_timewindows_middle = Start(outofepoch_timewindows) + Data(length(outofepoch_timewindows))/2 ;
        outofepoch_tsd = tsd(outofepoch_timewindows_middle,repmat(NaN,[length(Start(outofepoch_timewindows)),1])); % NaN for each timewindow out of epoch
    else
        disp('Warning : out of epoch is empty.') 
        swa_tsd = mean_bandpow ;
    end   
     
%% EVENT DENSITY HOMEOSTASIS 


fit_colors = {[0.8 0.6 0.2],[0.8 0.4 0.4]} ;
LFP_colors = {[0.25 0.7 0.9],[0 0.25 0.65],[1 0.7 0.1]} ;



% -------------- All Events -------------- : 

% For 3 separate plots : 
event_ts = slowwave_type3.deep_peaktimes ; 


% -------------- PLOT -------------- : 

% ------ Select events depending on 'events_subset' parameter ------ :    

switch events_subset
    case 'all'
    case 'downcooccur'          % only keep events which cooccur with down states
        [co_evt, co_ix] = Restrict(event_ts,alldown_PFCx) ;
        event_ts = co_evt ; 
    case 'notdowncooccur'       % only keep events which DO NOT cooccur with down states
        [co_evt, co_ix] = Restrict(event_ts,alldown_PFCx) ;
        notco_ix = repmat(1,length(Range(event_ts)),1) ; 
        notco_ix(co_ix) = 0 ; notco_ix = find(notco_ix) ; 
        event_ts = subset(event_ts,notco_ix) ;    
    case 'nexttodown'           % only keep events which are next to down states (< 300ms)
        [co,cot] = EventsCooccurrence(event_ts,downstates_ts,[300 300]) ; 
        event_ts = cot ; 
    case 'notnexttodown'        % only keep events which are NOT next to down states (< 300ms)
        [co,cot] = EventsCooccurrence(event_ts,downstates_ts,[300 300]) ; 
        evt_t = Range(event_ts) ; 
        event_ts = ts(evt_t(~co)) ; 
end


% ------ Get Event Density during Epoch ------ :

evt_density = EventsDensity_LP(event_ts,epoch_timewindows, 'union', 0) ;
% normalize event_density by mean density on entire epoch
mean_evt_density = EventsDensity_LP(event_ts,epoch_timewindows, 'union', 1) ;
evt_density = tsd(Range(evt_density),Data(evt_density)/mean_evt_density*100) ; % expressed as a percentage of mean event density during whole epoch (SWS)

% ------ Assign 'NaN' value out of Epoch ------ : 

% If out of epoch is not empty : 
if mean(length(outofepoch)) ~= 0 
    % Concatenate epoch data with out of epoch NaNs : 
    evt_density = concat_tsd(evt_density,outofepoch_tsd) ; 
end

% ------ Get rid of aberrant values (> artefact_thresh %) ------ :     

if  artefact_thresh ~= 'none' 
    evt_density_t = Range(evt_density) ; evt_density_y = Data(evt_density) ; 
    artefacts = (evt_density_y>artefact_thresh) ; 
    evt_density = tsd(evt_density_t(~artefacts), evt_density_y(~artefacts)) ; 
end




% ------ Plot Event Homeostasis ------ :     

xl = [9.8,18.4] ; 
figure,

% Global Fit & Multiple Fits

    subplot(3,1,[1 2 ]),

    [GlobalFit, TwoFit] = Homeostasis2Fit_LP(evt_density,'plot',1,'newfig',0,'ZTtime',NewtsdZT,'fit_start',fit_start) ; % Get homeostasis data (and plot) for multiple fits
    title(['Slow Waves 3 (Windowsize: ' num2str(windowsize) 's, ' sprintf('%.3e',length(Range(event_ts))) ' events)'],'FontSize',12) ;
    xlabel('') ; ylabel('Normalized Event Density') ;
    ylim([0 350]) ; xlim(xl) ; 


% Hypnogram

    subplot(3,1,3),
    plot_hypnogLP('ZTtime',NewtsdZT,'NREMsubstages',0,'Colors',{[0 0.5 0.75],[0.6 0.2 0.6],[0.1 0.7 0.2]},'newfig',0)
    xlim(xl) ; xlabel('ZT Time (hours)') ;
    
 set(gcf,'Position',[1 1 550 425]) ;    
   
 
 
 % Save : 
 PathToSave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/M2ReportFigures/' ; 
% Save figure : 
% print([PathToSave 'DensityHomeoExample1'], '-dpng', '-r300') ; 
    
    
    
    
    
    
    
    