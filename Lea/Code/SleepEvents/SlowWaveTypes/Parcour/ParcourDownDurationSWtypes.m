
%% ParcourDownDurationSWtypes
%
% 29/06/2020  LP
%
% -> script to get duration of down states
% associated to different SW types (SW3, 4, or 6)
% -> for whole session, for begin (1st half), and for end (2nd half)
% -> store data of all sessions in a structure



clear

Dir = PathForExperimentsSlowWavesLP_HardDrive ;
FileToSave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/ParcourDownDurationSWtypes.mat' ; 



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
    load('DownState.mat')

    % LOAD EPOCHS :
    load('SleepSubstages.mat')
    SWS = Epoch{strcmpi(NameEpoch,'SWS')} ;
    load NoiseHomeostasisLP TotalNoiseEpoch % noise
    cleanSWS = diff(SWS,TotalNoiseEpoch) ; 


    % CHOOSE SW : 
    events_list = {slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type6.deep_peaktimes} ; 
    events_names_list = {'sw3','sw4','sw6'} ; % names of the structures to store data


% ------------------------------------------ Get Down State Duration Data ------------------------------------------ :


    for type = 1:length(events_list)

        events = events_list{type} ; 
        events_name = events_names_list{type} ; 


        % ----------- Get SW ------------ :
        [periods_sw, periods_is] = SplitSessionEvents_LP(events,2,cleanSWS) ;
        sw_begin = periods_sw{1} ; 
        sw_end = periods_sw{2} ; 
        sw = ts([Range(sw_begin);Range(sw_end)]) ; 

        % ----------- Plot histogram of down duration for each group (all/begin/end) ------------ :

        all_sw = {sw, sw_begin, sw_end} ; 
        all_sw_names = {'_all', '_begin', '_end'} ; 


        for k=1:length(all_sw)

            sw = all_sw{k} ; 

            % Get co-occurring down states :
            [co_evt,co_down] = EventsInIntervals_LP(sw,alldown_PFCx) ;
            % Get data :
            duration = Data(length(co_down))/10 ; % all durations, in ms
            counts = histcounts(Data(length(co_down))/10,0:20:440) ; % histogram counts, with fixed bins
            mean_duration = nanmean(Data(length(co_down))) / 10 ; % mean duration
            
            % Store data in a structure :
            eval(['DownDuration.' events_name '.duration' all_sw_names{k} '{p} = duration ;'])
            eval(['DownDuration.' events_name '.histduration' all_sw_names{k} '{p} = counts ;'])
            eval(['DownDuration.' events_name '.meanduration' all_sw_names{k} '{p} = mean_duration ;'])
            eval(['DownDuration.' events_name '.histbins{p} = 0:20:440 ;'])
        end

    end
    
end


% SAVE .mat FILE with extracted data for all sessions and all slow wave types : 

save(FileToSave,'detection_parameters','Info_res','DownDuration') ; 
