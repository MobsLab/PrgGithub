%% ParcourSlowWaveProportionsEvolution
% 
% 23/06/2020  LP
%
% Script to get event info about the proportions of SW types 3/4/6, for NREM,
% during begin / middle / end of each session (session divided in nb_periods = 3
% periods) + LFP begin vs end + MUA begin vs end
%
% Output Structures :
%   - SlowWaves3, SlowWaves4, SlowWaves6
%
% SEE : 
% QuantifSlowWaveProportionsEvolution

clear

Dir = PathForExperimentsSlowWavesLP_HardDrive ;
FileToSave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/ParcourSlowWaveProportionsEvolution.mat' ; 
nb_periods = 18 ; % must be a multiple of 3

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
    
        % LOAD SPIKE DATA :

    load('SpikeData.mat')
    num=GetSpikesFromStructure('PFCx');
    S=S(num); % S tsdArray des spikes des neurones du PFC uniquement 
    Q=MakeQfromS(tsdArray(PoolNeurons(S,1:length(S))),20); % MakeQfromS(S,bin) = Spike Train Binning (time histogram of firing rate, time bin in same unit as S)
    q=full(Data(Q));
    Qs=tsd(Range(Q),q(:,1));

    
    % LOAD SW :
    load('SlowWaves2Channels_LP.mat')
    % all_slowwaves_ts = {slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type5.deep_peaktimes,slowwave_type6.deep_peaktimes,slowwave_type7.sup_peaktimes,slowwave_type8.sup_peaktimes} ;
    % all_colors = {[1 0.6 0],[1 0.4 0],[1 0 0.4],[0.6 0.2 0.6],[0.2 0.4 0.6],[0 0.6 0.4],[0.2 0.4 0],[0 0.2 0]} ; 
    all_slowwaves_ts = {slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type6.deep_peaktimes} ;
    all_colors = {[1 0 0.4],[0.6 0.2 0.6],[0 0.6 0.4]} ; 
    all_names = {'SlowWaves3','SlowWaves4','SlowWaves6'} ;

    
        % LOAD EPOCHS :
    load('SleepSubstages.mat')
    SWS = Epoch{strcmpi(NameEpoch,'SWS')} ;
    load NoiseHomeostasisLP TotalNoiseEpoch % noise
    cleanSWS = diff(SWS,TotalNoiseEpoch) ; 
    REM = Epoch{strcmpi(NameEpoch,'REM')} ;
    WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;

    load('BehavResources.mat','NewtsdZT') ; 
    
    
    % ------------------------------------------ Extract Info ------------------------------------------ :
    
    
    
    %% For each SLOW WAVE TYPE : 


    for type = 1:length(all_slowwaves_ts) % for each slow wave type
        
        nb_events = [] ; 
        nb_events_t = [] ; 
        
        sw = all_slowwaves_ts{type} ;
        sw = Restrict(sw,cleanSWS) ; 
        [periods_sw, periods_is] = SplitSessionEvents_LP(sw,nb_periods,cleanSWS) ; % Get events in each period of the session
        
        for per = 1:nb_periods
            nb_events(per) = length(periods_sw{per}) ; 
            period_midtimes = (Start(subset(periods_is,per)) + End(subset(periods_is,per))) / 2 ; 
            nb_events_t(per) = (period_midtimes + min(Data(NewtsdZT)))/3600E4 ;  %convert time to ZT
        end
        
        
        % -------- Get number of events in begin (first 1/3 of session) and in end periods (last 1/3 of session) -------- :
        nb_events_begin = mean(nb_events(1:nb_periods/3));
        nb_events_end = mean(nb_events(nb_periods*2/3+1:end));
        
        
        % -------- Get LFP and MUA around events, for begin and end -------- :
        
        period_names = {'begin','end'} ; 
        
        for per = 1:2 % for begin and for end periods
            events_ts_periodcell = periods_sw(nb_periods*(per-1)/3+1:nb_periods*per/3) ; % cell with ts of slow waves for this type, for begin or end periods only

            % Get ts with all events for this period :
            events_t = [] ; 
            for k = 1:length(events_ts_periodcell)
                events_t = [events_t ; Range(events_ts_periodcell{k})] ; 
            end
            
            % Get LFP profile :
            [mdeep,s,t_lfp]=mETAverage(events_t,Range(LFPdeep),Data(LFPdeep),1,1000); % deep PFCx
            [msup,s,t_lfp]=mETAverage(events_t,Range(LFPsup),Data(LFPsup),1,1000); % sup PFCx

            % Get mean Firing Rate :
            [m,s,t_mua]=mETAverage(events_t,Range(Qs),Data(Qs),2,500);
 
            % Store as tsd : 
            eval(['LFPdeep_' period_names{per} '= mdeep ; '])
            eval(['LFPsup_' period_names{per} '= msup ; '])
            eval(['MUA_' period_names{per} '= m ; '])

        end
        
        
        
        % -------- Store info for this slow wave type in a structure -------- : 
        
        nb_events = nb_events' ; 
        nb_events_t = nb_events_t' ;
        
        eval([all_names{type} '.nb_events{p} = nb_events ;'])
        eval([all_names{type} '.nb_events_ZT{p} = nb_events_t ;']) 
        
        eval([all_names{type} '.nb_events_begin{p} = nb_events_begin ;'])
        eval([all_names{type} '.nb_events_end{p} = nb_events_end ;'])
        
        eval([all_names{type} '.LFPdeep_begin{p} = LFPdeep_begin ;'])
        eval([all_names{type} '.LFPdeep_end{p} = LFPdeep_end ;'])
        eval([all_names{type} '.LFPsup_begin{p} = LFPsup_begin ;'])
        eval([all_names{type} '.LFPsup_end{p} = LFPsup_end ;'])
        eval([all_names{type} '.LFPt{p} = t_lfp ;'])
        
        eval([all_names{type} '.MUA_begin{p} = MUA_begin ;'])
        eval([all_names{type} '.MUA_end{p} = MUA_end ;'])
        eval([all_names{type} '.MUA_t{p} = t_mua ;'])
        
    end

    
    % ------ Get Relative Proportions ------ : 
    
    % Get total number of events : 
    tot_nb_events = repmat(0,length(nb_events),1) ; 
    for type=1:length(all_names)
        eval(['tot_nb_events = tot_nb_events + ' all_names{type} '.nb_events{p} ; '])
    end
    
    % Get proportions :
    for type=1:length(all_names)
        eval(['prop = ' all_names{type} '.nb_events{p} ./ tot_nb_events * 100 ;'])
        eval([all_names{type} '.prop_events{p} = prop ;'])
        prop_diff = nanmean(prop(nb_periods*2/3+1:end)) - nanmean(prop(1:nb_periods/3)) ; 
        eval([all_names{type} '.prop_events_diff{p} = prop_diff ;'])
        
    end
    
end

% SAVE .mat FILE with extracted data for all sessions and all slow wave types : 

save(FileToSave,'Info_res','SlowWaves3','SlowWaves4','SlowWaves6') ; 


    
    
    
    
    
    
    