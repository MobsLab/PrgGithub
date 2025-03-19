% ClinicRasterSlowWaveToneBis
% 11.01.2017 KJ
%
% Raster plot of the EEG, synchronized on tones
% -> Format data 
%
%   see 
%       ClinicRasterSlowWaveTone ClinicRasterSlowWaveTonePlot
%

%load
clear
eval(['load ' FolderPrecomputeDreem 'ClinicRasterSlowWaveTone.mat'])

%params
conditionsWithTones = {'Random','UpPhase'};
thresh_delay_tone = 6E4; %6sec - maximum delay between a slow wave and the next tone, for the raster

%% concatenate data except raster
rank_tones = [];
slowwave_delay = [];
slowwave_induced = [];
sleepstage_tone = [];

for p=1:length(raster_res.filename)
    if any(strcmpi(raster_res.condition{p}, conditionsWithTones))
        rank_tones = [rank_tones ; raster_res.rank_tones{p}];
        slowwave_delay = [slowwave_delay ; raster_res.delay_slowwave_tone{p}];
        slowwave_induced = [slowwave_induced ; raster_res.induce_slow_wave{p}];
        sleepstage_tone = [sleepstage_tone ; raster_res.sleepstage_tone{p}'];
    end
end


%% concatenate raster

%
fs=250;
correct_size_raster = (t_after - t_before)*fs/1E4;

for ch=1:length(channels)
    global_raster{ch} = [];
    for p=1:length(raster_res.filename)
        if any(strcmpi(raster_res.condition{p}, conditionsWithTones))
            raster_tsd = raster_res.raster{p,ch};
            raster_mat = Data(raster_tsd);
            
            %check size of raster
            if size(raster_mat,1)==correct_size_raster
                raster_x{ch} = Range(raster_tsd);
            else
               
                raster_mat = [raster_mat; raster_mat(end,:)]; %if one line is missing, we had one line at the end
            end
            
            if isempty(global_raster{ch})
                global_raster{ch} = raster_mat';
            else
                global_raster{ch} = [global_raster{ch} ; raster_mat'];
            end
        end
    end

end


%sort by delay
[sort_delay_sw,idx_sw_delay] = sort(slowwave_delay,'ascend');
idx_sw_delay(sort_delay_sw>thresh_delay_tone)=[];
sort_delay_sw(sort_delay_sw>thresh_delay_tone)=[];

for ch=1:length(channels)
    raster_matrix{ch} = global_raster{ch}(idx_sw_delay,:);
    raster_time{ch} = raster_x{ch};
end
slowwave_delay = sort_delay_sw;
slowwave_induced = slowwave_induced(idx_sw_delay);
sleepstage_tone = sleepstage_tone(idx_sw_delay);

%% saving data
cd(FolderPrecomputeDreem)
save ClinicRasterSlowWaveToneBis.mat raster_matrix raster_time rank_tones slowwave_delay slowwave_induced sleepstage_tone 
save ClinicRasterSlowWaveToneBis.mat -append sleepstage_ind channels sw_detection_channel labels t_before t_after 





