%% ParcourInfo_AllSlowWaveTypes
% 
% 19/05/2020  LP
%
% Script to get event info for all 2-channel slow wave types, 
% for all sessions, stored in structures. 
% -> 1 structure per slow wave type (8 types in total)
%
% Info for : 
% -> LFP
% -> mean spiking rate around slow waves
% -> cross-correlogram with down states, with ripples
% -> Wake/NREM/REM repartition
%
% Output Structures :
%   - SlowWaves1, SlowWaves2, ..., SlowWaves8,DiffDeltaWaves
%
% SEE : 
% ParcourMakeSlowWavesOn2Channels_LP() 
% PlotInfo_AllSlowWaveTypes
% ParcourInfo_AllSlowWaveTypes_MeanPlot

clear

Dir = PathForExperimentsSlowWavesLP_HardDrive ;
FileToSave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/ParcourInfo_AllSlowWaveTypes.mat' ; 


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

    % LOAD LFP :
        % PFCx deep :
    load('ChannelsToAnalyse/PFCx_deep')
    load(['LFPData/LFP',num2str(channel)])
    LFPdeep = LFP;
    ChannelDeep = channel ;
        % PFCx sup :
    load('ChannelsToAnalyse/PFCx_sup')
    load(['LFPData/LFP',num2str(channel)])
    LFPsup = LFP;
    ChannelSup = channel ;
        % OB deep :
    load('ChannelsToAnalyse/Bulb_deep')
    load(['LFPData/LFP',num2str(channel)])
    LFPobdeep = LFP;
    ChannelOBdeep = channel ;
        % List with all LFP
    all_LFP = {LFPdeep,LFPsup,LFPobdeep} ; 
    all_LFP_legend = {'PFCx deep','PFCx sup','OB deep'} ;
    clear LFP channel



    % LOAD EVENTS : 
        % 2-Channel Slow Waves : 
    load('SlowWaves2Channels_LP.mat')
        % Other events :
    load('DownState.mat')
    load('DeltaWaves.mat','alldeltas_PFCx')
        downstates_ts = ts((Start(alldown_PFCx)+End(alldown_PFCx))/2) ; % convert to ts with mid time
        diffdelta_ts = ts((Start(alldeltas_PFCx)+End(alldeltas_PFCx))/2) ; % convert to ts with mid time (differential Delta = as computed by KJ)

    all_slowwaves = {slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type5.deep_peaktimes,slowwave_type6.deep_peaktimes,slowwave_type7.sup_peaktimes,slowwave_type8.sup_peaktimes,diffdelta_ts} ;
    all_slowwaves_names = {'SlowWaves1','SlowWaves2','SlowWaves3','SlowWaves4','SlowWaves5','SlowWaves6','SlowWaves7','SlowWaves8','DiffDeltaWaves'} ;
        
    try 
        load('Ripples.mat','tRipples')
    catch 
        load('Ripples.mat','Ripples')
        tRipples = ts(Ripples) ; 
    end


    % LOAD SPIKE DATA :
    load('SpikeData.mat')
    num=GetSpikesFromStructure('PFCx');
    S=S(num); % S tsdArray des spikes des neurones du PFC uniquement 
    Q=MakeQfromS(tsdArray(PoolNeurons(S,1:length(S))),20); % MakeQfromS(S,bin) = Spike Train Binning (time histogram of firing rate, time bin in same unit as S)
    q=full(Data(Q));
    Qs=tsd(Range(Q),q(:,1));
    

    % LOAD SUBSTAGES : 
    load('SleepSubstages.mat') ; 
        REM = Epoch{strcmpi(NameEpoch,'REM')} ;
        WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;
        SWS= Epoch{strcmpi(NameEpoch,'SWS')} ;
    substages_list = {WAKE,SWS,REM} ; 
    substages_names = {'Wake', 'NREM', 'REM'} ;
        
        
%% For each SLOW WAVE TYPE : 

    for type = 1:length(all_slowwaves) % for each slow wave type
         
    
    %% --------------------------- LFP around events : SlowWavesX.LFPprofiles --------------------------- :
   
        
        % LFP PFC deep : 
        [m,s,t]=mETAverage(Range(all_slowwaves{type}),Range(LFPdeep),Data(LFPdeep),1,1000);  
        eval([all_slowwaves_names{type} '.LFPprofiles.t{p}= t ;']) ; % store plotting time
        eval([all_slowwaves_names{type} '.LFPprofiles.PFCdeep{p}= m ;']) ; % store LFP profile
        
         % LFP PFC sup : 
        [m,s,t]=mETAverage(Range(all_slowwaves{type}),Range(LFPsup),Data(LFPsup),1,1000);  
        eval([all_slowwaves_names{type} '.LFPprofiles.PFCsup{p}= m ;']) ; % store LFP profile
        
        % LFP OB deep : 
        [m,s,t]=mETAverage(Range(all_slowwaves{type}),Range(LFPobdeep),Data(LFPobdeep),1,1000);  
        eval([all_slowwaves_names{type} '.LFPprofiles.OBdeep{p}= m ;']) ; % store LFP profile
        
    

    %% --------------------------- Spiking Rate around events : SlowWavesX.SpikingRate --------------------------- :
    
         [m,s,t]=mETAverage(Range(all_slowwaves{type}),Range(Qs),Data(Qs),1,1000);  
         eval([all_slowwaves_names{type} '.SpikingRate.t{p}= t ;']) ; % store plotting time
         eval([all_slowwaves_names{type} '.SpikingRate.rate{p}= m ;']) ; % store spiking rate 
         eval([all_slowwaves_names{type} '.SpikingRate.z_rate{p}= zscore(m) ;']) ; % store z-scored spiking rate 
           
        % For NREM restricted slow waves : 
         NREMsw = Restrict(all_slowwaves{type},SWS); 
         [m,s,t]=mETAverage(Range(NREMsw),Range(Qs),Data(Qs),1,1000);  
         eval([all_slowwaves_names{type} '.nremSpikingRate.t{p}= t ;']) ; % store plotting time
         eval([all_slowwaves_names{type} '.nremSpikingRate.rate{p}= m ;']) ; % store spiking rate 
         eval([all_slowwaves_names{type} '.nremSpikingRate.z_rate{p}= zscore(m) ;']) ; % store z-scored spiking rate 
     
      %% --------------------------- CrossCorrelogram with Down States : SlowWavesX.CrossCorrDown --------------------------- :

         [C,B]=CrossCorr(Range(all_slowwaves{type}),(Start(alldown_PFCx)+End(alldown_PFCx))/2,10,100);
         eval([all_slowwaves_names{type} '.CrossCorrDown.t{p}= B ;']) ; % store plotting time
         eval([all_slowwaves_names{type} '.CrossCorrDown.crosscorr{p}= C ;']) ; % store spiking rate 
         eval([all_slowwaves_names{type} '.CrossCorrDown.z_crosscorr{p}= zscore(C) ;']) ; % store z-scored spiking rate 
       
         % Proportion of SW with down State Co-occurrence % : 
         cooccur_delay = 100 ; % in ms. 
         [co, cot] = EventsCooccurrence(all_slowwaves{type},ts((Start(alldown_PFCx)+End(alldown_PFCx))/2), [cooccur_delay cooccur_delay]) ; 
         cooccur_prop = sum(co) / length(co) ; % prop of slow waves which peak is less than 100ms before or after down state middle
         eval([all_slowwaves_names{type} '.CrossCorrDown.cooccurprop{p}= cooccur_prop ;']) ; 
         eval([all_slowwaves_names{type} '.CrossCorrDown.cooccur_delay{p}= cooccur_delay ;']) ;
         
         % prop of Down states co-occurring with SW : 
         [co, cot] = EventsCooccurrence(ts((Start(alldown_PFCx)+End(alldown_PFCx))/2),all_slowwaves{type}, [cooccur_delay cooccur_delay]) ; 
         cooccur_prop = sum(co) / length(co) ; % prop of slow waves which peak is less than 100ms before or after down state middle
         eval([all_slowwaves_names{type} '.CrossCorrDown.downcooccurprop{p}= cooccur_prop ;']) ; 
         
         
         % NREM-restricted cross-correlograms : 
         NREMsw = Restrict(all_slowwaves{type},SWS); 
         [C,B]=CrossCorr(Range(NREMsw),(Start(alldown_PFCx)+End(alldown_PFCx))/2,10,100);
         eval([all_slowwaves_names{type} '.nremCrossCorrDown.t{p}= B ;']) ; % store plotting time
         eval([all_slowwaves_names{type} '.nremCrossCorrDown.crosscorr{p}= C ;']) ; % store spiking rate 
         eval([all_slowwaves_names{type} '.nremCrossCorrDown.z_crosscorr{p}= zscore(C) ;']) ; % store z-scored spiking rate 
       
         
         
      %% --------------------------- CrossCorrelogram with Ripples : SlowWavesX.CrossCorrRipples --------------------------- :

         [C,B]=CrossCorr(Range(all_slowwaves{type}),Range(tRipples),10,100);
         eval([all_slowwaves_names{type} '.CrossCorrRipples.t{p}= B ;']) ; % store plotting time
         eval([all_slowwaves_names{type} '.CrossCorrRipples.crosscorr{p}= C ;']) ; % store spiking rate 
         eval([all_slowwaves_names{type} '.CrossCorrRipples.z_crosscorr{p}= zscore(C) ;']) ; % store z-scored spiking rate 
       
       
         
     %% --------------------------- Stage Occurrence (Wake/REM/NREM) : SlowWavesX.StageOccurrence --------------------------- :

        % for each stage :
        for k = 1:length(substages_list) 
            stage_events = belong(substages_list{k},Range(all_slowwaves{type})) ; 
            stage_prop = sum(stage_events) / length(stage_events) *100 ; % proportion of events starting during this stage
            eval([all_slowwaves_names{type} '.StageOccurrence.prop' substages_names{k} '{p}= stage_prop ;']) ; % store plotting time
        end
          
         
         
    end   
     
     
end    



% SAVE .mat FILE with extracted data for all sessions and all slow wave types : 

save(FileToSave,'detection_parameters','Info_res','SlowWaves1','SlowWaves2','SlowWaves3','SlowWaves4','SlowWaves5','SlowWaves6','SlowWaves7','SlowWaves8','DiffDeltaWaves') ; 
