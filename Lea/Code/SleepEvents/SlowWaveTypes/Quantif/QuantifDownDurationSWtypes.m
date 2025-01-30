
%% QuantifDownDurationSWtypes
%
% 29/06/2020  LP
%
% -> script to plot histograms of down state duration for down states
% associated to different SW types (SW3, 4, or 6)
% -> for whole session, for begin (1st half), and for end (2nd half)
%

%% LOAD DATA :

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
events_names_list = {'SW3','SW4','SW6'} ; 


%% PLOT HISTOGRAMS :

figure, 

xl = [0 450] ; 
yl = [0 1000] ; 


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
    all_sw_names = {'all', 'begin', 'end'} ; 


    for k=1:length(all_sw)

        sw = all_sw{k} ; 

        % Get co-occurring down states :
        [co_evt,co_down] = EventsInIntervals_LP(sw,alldown_PFCx) ;
        % Plot histogram of slow waves duration :
        subplot(length(events_list),3,(type-1)*3+k),
        
        histogram(Data(length(co_down))/10,0:20:440) ;
        %ylim(yl) ; 
        xlabel('down state duration (ms)') ; title([events_name ' : ' all_sw_names{k} sprintf(' (%.2e events)',length(Start(co_down)))]) 
        
        % get mean value : 
        mean_duration = nanmean(Data(length(co_down))) / 10 ; 
        l = xline(mean_duration,'-','Color',[0.8 0.05 0.2]) ; legend(l,sprintf('mean = %.2g ms', mean_duration)) ; legend boxoff ;
    end

end
