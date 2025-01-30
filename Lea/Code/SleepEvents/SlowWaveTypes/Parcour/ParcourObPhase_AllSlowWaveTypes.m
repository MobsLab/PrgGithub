%% ParcourObPhase_AllSlowWaveTypes
%
% 02/06/2020  LP
%
% Script to get phase preference for all slow waves relatively to the LFP
% signal from the olfactory bulb.
% -> Store in a .mat file


clear

% For plotting functions :
addpath('/Users/leaprunier/Dropbox/Kteam/PrgMatlab/MatFilesMarie')

Dir = PathForExperimentsSlowWavesLP_HardDrive ;
FileToSave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/ParcourObPhase_AllSlowWaveTypes.mat' ; 


for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    disp(['File ' num2str(p) '/' num2str(length(Dir.path)) ])
    eval(['cd(Dir.path{',num2str(p),'}'')'])

    disp(pwd)
    
    
    % Store Session Info :
    Info_res.path{p}   = Dir.path{p};
    Info_res.manipe{p} = Dir.manipe{p};
    Info_res.name{p}   = Dir.name{p};
    
    
 % ------------------------------------------ Load Data ------------------------------------------ :

    % LOAD EVENTS : 
    load('SlowWaves2Channels_LP.mat')
    all_slowwaves = {slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type5.deep_peaktimes,slowwave_type6.deep_peaktimes,slowwave_type7.sup_peaktimes,slowwave_type8.sup_peaktimes} ;
    load('DownState.mat','alldown_PFCx')
    load('DeltaWaves.mat','alldeltas_PFCx')


    % LOAD SUBSTAGES : 
    load('SleepSubstages.mat') ; 
        REM = Epoch{strcmpi(NameEpoch,'REM')} ;
        WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;
        SWS= Epoch{strcmpi(NameEpoch,'SWS')} ;
        
        
    % LOAD LFP :
    % OB deep :
    load('ChannelsToAnalyse/Bulb_deep')
    load(['LFPData/LFP',num2str(channel)])
    LFPobdeep = LFP;
    ChannelOBdeep = channel ;
    
    
    
 % ------------------------------------------ Get Phase Preference ------------------------------------------ :
    
    tosave = {} ; % to store names of the structures to save
    
 
    % For All Types : 

    for type = 1:length(all_slowwaves),
        
        sw_ts = all_slowwaves{type} ; 
        Fil=FilterLFP(LFPobdeep,[3 5],1024);
        [Ph,phasesandtimes,powerTsd]=CalCulPrefPhase(sw_ts,Fil,'H');
        
        % ---- From 'JustPoltModKB' :
        Ph = Data(Ph{1}) ; 
        nBins = 25 ; 
        if max(Ph)<pi
            Ph=Ph*2*pi;
        end
        [mu, Kappa, pval] = CircularMean(Ph);
        modRatio=Kappa;
        P=pval;
        dB = 2*pi/nBins;
        B = [dB/2:dB:2*pi-dB/2];
        C = hist(Ph,B);
        t=mu;
        t = mod(t+pi,2*pi)-pi;
        vm = von_mises_pdf(B-pi,t+pi,modRatio);
        modT = num2str(round(modRatio*10)/10);	
        probaT = num2str(round(P*100)/100);
        % ----

        eval(['SlowWaves' num2str(type) '.PhasePref{p}= num2str(round(mu*100)/100) ;']) ; % proportion of down states co-occurring with a slow wave (of this type)
        eval(['SlowWaves' num2str(type) '.hist_curve_x{p}= [B B+2*pi] ;']) ;
        eval(['SlowWaves' num2str(type) '.hist_curve_y{p}= 2*nBins*dB*[vm vm] ;']) ;
        
        eval(['SlowWaves' num2str(type) '.modT{p}= modT ;']) ;
        eval(['SlowWaves' num2str(type) '.probaT{p}= probaT ;']) ;
        
        tosave{end+1} = ['SlowWaves' num2str(type)] ; % to store names of all structures
        
    end
end


% SAVE .mat FILE with extracted data for all sessions and all slow wave types : 

struct_names = tosave ;
save(FileToSave,'detection_parameters','Info_res',tosave{:},'struct_names') ; 

        
        
        
        
        
    