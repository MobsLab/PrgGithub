%% QUANTIFY BANDPOWER HOMEOSTASIS (Local Maxima) during sleep
%
% 14/02/2020 LP
%
% Script to quantify and plot homeostasis on one session. 
%
% Quantif on local maxima (linear regresion with time),
% for bandpower timecourse (PFCx, OB) 
%   -> 1 fit : linear regression on whole SWS  
%   -> Multifit : linear regression for each sleep episode separated by a
%   long wake periods (wake duration > wake_thresh). 
%
% Restriction to SWS epoch by keeping only parts of the timewindows which
% fall in the SWS epoch.
%
%
% SEE : QuantifHomeostasisBandpower_old

% ------------------------------------- Choose Sleep Session ------------------------------------- :

%clear
% session = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243' ;
% cd(session)


% ------------------------------------------ Load Data ------------------------------------------ :

% Load channels : 

load('ChannelsToAnalyse/PFCx_deep')
ChannelDeep = channel ;
clear channel

load('ChannelsToAnalyse/PFCx_sup')
ChannelSup = channel ;
clear channel

load('ChannelsToAnalyse/Bulb_deep')
ChannelOBdeep = channel ;
clear channel



% Clean SWS Epoch
load('SleepSubstages.mat')
SWS = Epoch{strcmpi(NameEpoch,'SWS')} ;
REM = Epoch{strcmpi(NameEpoch,'REM')} ;
load NoiseHomeostasisLP TotalNoiseEpoch % noise
cleanSWS = diff(SWS,TotalNoiseEpoch) ; 


% Zeitgeber time
load('behavResources.mat', 'NewtsdZT')


% ------------------------------------------ PARAMETERS ------------------------------------------ :


% --- Choose Parameters --- :

wake_thresh = 'none' ; % wake duration (in minutes) between separate sleep episodes / 'none' for 1 or 2 fits
twofit_duration = 3 ; % duration of the 1st of two fits, in hours. / 'none' for 1 fit. 
windowsize = 60 ; % duration of sliding window, in seconds (/!\ no overlap)
freqband = [0.5 4] ; % in Hz
after_REM1 = false ; % true if fit only after 1st episode of REM


%% BANDPOWER HOMEOSTASIS 

figure,
struct_names = {'PFCx sup', 'PFCx deep', 'OB deep'} ;
struct_channels = {ChannelSup, ChannelDeep, ChannelOBdeep} ; 

subplot_list = {1 11 12};
fit_colors = {[0.8 0.6 0.2],[0.8 0.4 0.4]} ;


% Get time of 1st REM episode if fit only after 1st REM episode
if after_REM1
    fit_start = getfield(Start(REM),{1}) ;
else
    fit_start = 0;
end 


% FOR EACH STRUCTURE :

% ---- Plot homeostasis ---- : 

for q=1:length(struct_names)
    
    i = subplot_list{q} ;
    subplot(9,2,[i:2:i+4]) ; 
    [t_swa, y_swa, Homeo_res] = GetSWAchannel_LP(struct_channels{q},'multifit_thresh',wake_thresh,'twofit_duration',twofit_duration,'merge_closewake',1,'epoch',cleanSWS,'fit_start',fit_start,'freqband',freqband,'windowsize',windowsize,'plot',1,'newfig',0) ;     
    xlim([t_swa(1),t_swa(end)]); xlabel('') ;
    title(struct_names{q}) ; 
end  

xl_plot = [t_swa(1),t_swa(end)];

% ---- Plot histograms ---- : 

subplot(9,2,7),
plot_hypnogLP('newfig',0) ; xlabel('ZT Time (hours)') ; xlim(xl_plot) ; 
subplot(9,2,[17]),
plot_hypnogLP('newfig',0) ; xlabel('ZT Time (hours)') ; xlim(xl_plot) ; 
subplot(9,2,[18]),
plot_hypnogLP('newfig',0) ; xlabel('ZT Time (hours)') ; xlim(xl_plot) ; 
    


% Title of the whole figure :
subplot(2,2,2),
text(0.5,0.8,'Bandpower Homeostasis','FontSize',30,'HorizontalALignment','center'), axis off
text(0.5,0.6,sprintf('Frequency Band : %g - %g Hz',freqband(1),freqband(2)),'FontSize',20,'HorizontalALignment','center'), axis off
text(0.5,0.45,['Windowsize : ' num2str(windowsize) 's'],'FontSize',20,'HorizontalALignment','center'), axis off
if wake_thresh ~= 'none' 
    text(0.5,0.3,['Multifit Wake Threshold : ' num2str(wake_thresh) 'min'],'FontSize',20,'HorizontalALignment','center'), axis off
end
