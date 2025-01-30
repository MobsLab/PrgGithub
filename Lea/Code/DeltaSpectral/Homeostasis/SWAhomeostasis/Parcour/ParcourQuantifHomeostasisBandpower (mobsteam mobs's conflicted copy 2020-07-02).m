
%% ParcourQuantifHomeostasisBandpower
%
% 15/04/2020 LP
%
% Store homeostasis info of each session in a structure. 
% "Homeostasis" computed here through linear regression of local maxima 
% on prefrontal cortex and olfactory bulb bandpower.  
% 
% -> Global fit on whole session or multiple fits on separate sleep episodes 
% (when wake duration > multifit_thresh) 
%
% SEE : QuantifHomeostasisBandpower ParcourQuantifHomeostasisBandpowerPlot


% ----------------------------------------- ACCESS DATA ----------------------------------------- :
clear

% Dir = PathForExperimentsBasalSleepSpike2_HardDrive ;
Dir = PathForExperimentsSlowWavesLP_HardDrive ;


% --------------------------------------- SET PARAMETERS --------------------------------------- :

freqband_list = {[0.5 4],[0.75 1.75],[2.5 3.5]} ; % in Hz
freqband_choice = 3 ; 
multifit_thresh = 'none' ; % wake duration (in minutes) between separate sleep episodes if multifit. 'none' for 1 or 2 fits.
twofit_duration = 3 ; % duration of the 1st of two fits, in hours. / 'none' for 1 fit. 
merge_closewake = 1 ; % minimal sleep duration (in minutes) to consider a wake period as "interrupted", for multiple fits 
% (ie. do not take into account sleep when shorther than this duration for the detection of wake episodes) 
windowsize = 60 ; % duration of sliding window, in seconds

after_REM1 = false ; % true -> fit only after 1st episode of REM


%% GET BANDPOWER HOMEOSTASIS FOR ALL SESSIONS


freqband = freqband_list{freqband_choice} ; % in Hz

for p=1:length(Dir.path)
    
    clearvars -except Dir p Homeo_res  windowsize freqband multifit_thresh twofit_duration merge_closewake after_REM1 freqband_choice
    
    disp(' ')
    disp('****************************************************************')
    disp(['File ' num2str(p) '/' num2str(length(Dir.path)) ])
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    
    % Store Session Info :
    Homeo_res.path{p}   = Dir.path{p};
    Homeo_res.manipe{p} = Dir.manipe{p};
    Homeo_res.name{p}   = Dir.name{p};
    

% ------------------------------------------ Load Data ------------------------------------------ :
    
   
    % LFP CHANNELS : 
    
        load('ChannelsToAnalyse/PFCx_deep')
    ChannelDeep = channel ;
    clear channel

        load('ChannelsToAnalyse/PFCx_sup')
    ChannelSup = channel ;
    clear channel

        load('ChannelsToAnalyse/Bulb_deep')
    ChannelOBdeep = channel ;
    clear channel

    
    % SUBSTAGES
    load('SleepSubstages.mat')
    SWS = Epoch{strcmpi(NameEpoch,'SWS')} ;
    REM = Epoch{strcmpi(NameEpoch,'REM')} ;
    % + remove noise : 
    load NoiseHomeostasisLP TotalNoiseEpoch
    cleanSWS = diff(SWS,TotalNoiseEpoch) ; % remove noise from SWS epoch

    % Zeitgeber TIME
    load('behavResources.mat', 'NewtsdZT')
   
    
% ------------------------------------------ Get SWA Homeostasis ------------------------------------------ :
    

    struct_names = {'PFCsup', 'PFCdeep', 'OBdeep'} ;
    struct_channels = {ChannelSup, ChannelDeep, ChannelOBdeep} ; 
    
    
    % FOR EACH STRUCTURE :
    
    for q=1:length(struct_names)
        
        % Get time of 1st REM episode if fit only after 1st REM episode
        if after_REM1
            fit_start = getfield(Start(REM),{1}) ;
        else
            fit_start = 0;
        end 
        
        [t_swa, y_swa, Homeo_data] = GetSWAchannel_LP(struct_channels{q},'multifit_thresh',multifit_thresh,'twofit_duration',twofit_duration,'merge_closewake',merge_closewake,'epoch',cleanSWS,'fit_start',fit_start,'freqband',freqband,'windowsize',windowsize,'plot',0) ;     
        
        
         % => Store all data in structure :
         
         % Global Fit :
        eval(['Homeo_res.' struct_names{q} '.time{p} = Homeo_data.GlobalFit.time ;']) % timestamps of quantif
        eval(['Homeo_res.' struct_names{q} '.data{p} = Homeo_data.GlobalFit.data;']) % data of quantif
        eval(['Homeo_res.' struct_names{q} '.idx_localmax{p} = Homeo_data.GlobalFit.idx_localmax;']) % indices of local maxima
        eval(['Homeo_res.' struct_names{q} '.reg_coeff{p} = Homeo_data.GlobalFit.reg_coeff;']) % Linear Reg Coefficient
        eval(['Homeo_res.' struct_names{q} '.R2{p} = Homeo_data.GlobalFit.R2;']) % Determination Coeff

        % Two Fits or Multiple Fits : 
        if multifit_thresh == 'none'
            
            if twofit_duration ~= 'none'
                eval(['Homeo_res.' struct_names{q} '.twofitidx_localmax{p} = Homeo_data.TwoFit.idx_localmax;']) % indices of local maxima for each (non-global) fit
                eval(['Homeo_res.' struct_names{q} '.twofitreg_coeff{p} = Homeo_data.TwoFit.reg_coeff;']) % Linear Reg Coefficient for each (non-global) fit
                eval(['Homeo_res.' struct_names{q} '.twofitR2{p} = Homeo_data.TwoFit.R2;']) % Determination Coeff for each (non-global) fit    
            end
 
        else % if multifit 
        eval(['Homeo_res.' struct_names{q} '.multiidx_localmax{p} = Homeo_data.MultiFit.idx_localmax;']) % indices of local maxima for each (non-global) fit
        eval(['Homeo_res.' struct_names{q} '.multireg_coeff{p} = Homeo_data.MultiFit.reg_coeff;']) % Linear Reg Coefficient for each (non-global) fit
        eval(['Homeo_res.' struct_names{q} '.multiR2{p} = Homeo_data.MultiFit.R2;']) % Determination Coeff for each (non-global) fit 
        eval(['Homeo_res.' struct_names{q} '.multiR2global{p} = Homeo_data.MultiFit.R2global;']) % Determination Coeff for global fit restricted on each sleep episode   
        end
        
    end 
    
end


% ----------------- Save structure and data in a file ------------------ :

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/DeltaSpectral/Data')
catch  cd([FolderDataLP_DeltaSpectral 'Data/'])
end    

% -- Define description for filename -- :

if multifit_thresh == 'none' % if one or two fits : 
    if twofit_duration == 'none' % 1 fit
        description = 'globalfit' ; 
    else % 2 fits
        description = ['twofit_' num2str(twofit_duration)]
    end
else % multifit
    description = ['multifit_' num2str(multifit_thresh)]
end 

if after_REM1 
    description = [description '_afterREM1']
end

% Frequency Choice : 
description = [ description '_freqband' num2str(freqband_choice)] ;

% -- Save File -- : 
eval( ['save ParcourQuantifHomeostasisBandpower_' description '.mat Homeo_res windowsize freqband multifit_thresh twofit_duration merge_closewake after_REM1']) ;

