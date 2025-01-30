% ProcessingTP_AllDreemRecords
% 15.01.2023 KJ
%
%

clear


%% init - 
% insert the path to the folder with downloaded data (input folder)
folder_input = '/Users/gallopin/Enseignement/Travaux_Pratiques/TP_DREEM/2023_2024/TP_dreem_preprocessing/input_data';
% insert the path to the folder that will receive processed data (output folder)
folder_output = '/Users/gallopin/Enseignement/Travaux_Pratiques/TP_DREEM/2023_2024/TP_dreem_preprocessing/output_data';
% insert the path to the nuits_tp_dreem Excel file
nuits_tp_file = '/Users/gallopin/Enseignement/Travaux_Pratiques/TP_DREEM/2023_2024/TP_dreem_preprocessing/nuits_tp_dreem.xlsx';

%% Check files
% list of h5 files available in the input folder
record_list = [];
filelist = dir(fullfile(folder_input, '*.h5'));
for i=1:length(filelist)
    record_reference = str2double(filelist(i).name(1:end-3));
    record_list = [record_list ; record_reference];
end

% list of txt files available in the input folder
hypnogram_list = [];
filelist = dir(fullfile(folder_input, '*.txt'));
for i=1:length(filelist)
    record_reference = str2double(filelist(i).name(1:end-3));
    hypnogram_list = [hypnogram_list ; record_reference];
end

% check if 2 lists above are the same
if ~isequal(sort(record_list), sort(hypnogram_list))
    difference = setdiff(record_list, hypnogram_list);
    if ~isempty(difference)
        disp("This record references have .h5 files but no .txt files:")
        disp(difference)
    end
    difference = setdiff(hypnogram_list, record_list);
    if ~isempty(difference)
        disp("This record references have .txt files but no .h5 files:")
        disp(difference)
    end

end

% keep only the records that have h5 and hypnogram files
records = intersect(record_list, hypnogram_list);

% read the excel file - to find the best channel
table_nuits_tp = readtable(nuits_tp_file);
index_to_keep = ismember(table_nuits_tp.Ref, records);
table_nuits_tp = table_nuits_tp(index_to_keep,:);


%% loop over records
for p=1:length(records)
%     try
        disp(' ')
        disp('****************************************************************')
        disp(records(p))
        
        clearvars -except folder_input folder_output records record_list hypnogram_list table_nuits_tp p


        %params
        fs_eeg = 250; %250Hz
        

        %% init
        filerec = fullfile(folder_input, [num2str(records(p)) '.h5']);
        filehypno = fullfile(folder_input, [num2str(records(p)) '.txt']);

        % folder to put the data of the record
        record_output_folder = fullfile(folder_output, num2str(records(p)));
        mkdir(record_output_folder);


        %% Hypnogram
        [Hypnogram, StageEpochs] = ParseHypnogramFromText(filehypno);

        Hypnogram(Hypnogram==0) = 5; %wake
        Hypnogram(:,3) = Hypnogram(:,1);
        Hypnogram(:,1) = (0:size(Hypnogram,1)-1)*30;
        Hypnogram(:,2) = (1:size(Hypnogram,1))*30;

        %stage epoch
        SleepStage = [];
        st_epoch = 0;
        for i=2:size(Hypnogram,1)
             if Hypnogram(i,3)~=Hypnogram(i-1,3)
                newStage = [st_epoch Hypnogram(i-1,2) Hypnogram(i-1,3)];
                SleepStage = [SleepStage ; newStage];
                st_epoch = Hypnogram(i,1);
             end
        end

        %save in xls
        filexlsx = fullfile(record_output_folder, [num2str(records(p)) '_hypnogram.xlsx']);
        writematrix(Hypnogram, filexlsx);
        filexlsx = fullfile(record_output_folder, [num2str(records(p)) '_sleepstage.xlsx']);
        writematrix(SleepStage, filexlsx);
        
        %NREM
        NREM = or(or(StageEpochs{2}, StageEpochs{3}), StageEpochs{1}); 


        %% EEG & breathing
        best_channel = table_nuits_tp.BestChannel(ismember(table_nuits_tp.Ref, records(p)));

        [eeg, accelero, breathing, labels_eeg] = GetRecordDreemTP(filerec);
        eeg = eeg([1 2 5 6]);
        labels_eeg = labels_eeg([1 2 5 6]);

        eeg_best = eeg{best_channel};
        tEEG = tsd(eeg_best(:,1)*1e4, eeg_best(:,2));

        %breathing
        breathing(:,2) = breathing(:,2) * 1000; %rescale

        %% spectro
        spectro_file = fullfile(record_output_folder, [num2str(records(p)) '_spectrogram.mat']);
        if exist(spectro_file,'file')~=2
            %params
            params.fpass  = [0.4 40];
            params.tapers = [3 5];
            movingwin     = [3 0.2];
            params.Fs     = 250;

            [spectrogram, times_spectro, freq_spectro] = mtspecgramc(eeg_best(:,2), movingwin, params);

            label = labels_eeg{best_channel}; channel = ['CH' num2str(best_channel)];
            save(spectro_file,'spectrogram', 'times_spectro', 'freq_spectro', 'label','params','movingwin', 'channel', '-v7.3')
        end

        %% slow waves
        sw_file = fullfile(record_output_folder, ['SlowWaves_' num2str(records(p)) '.mat']);
        if exist(sw_file,'file')==2
            load(sw_file);
        else
            SlowWaveEpochs= and(FindSlowWaves(tEEG), NREM);
            save(sw_file,'SlowWaveEpochs')
        end
        slowwaves_start = Start(SlowWaveEpochs)/1e4;
        slowwaves_duration = (End(SlowWaveEpochs) - Start(SlowWaveEpochs))/1e4;

        %% spindles
        spi_file = fullfile(record_output_folder, ['Spindles_' num2str(records(p)) '.mat']);
        if exist(spi_file,'file')==2
            load(spi_file);
        else
            params_spi.noise_epoch = or(StageEpochs{5}, StageEpochs{6});
            try 
                SpindlesEpoch = and(FindSpindlesDreem(tEEG,'method','mensen','params',params_spi), NREM);
            catch
                SpindlesEpoch = intervalSet([],[]);
            end

            save(spi_file,'SpindlesEpoch')
        end
        spindles_start = Start(SpindlesEpoch)/1e4;
        spindles_duration = (End(SpindlesEpoch) - Start(SpindlesEpoch))/1e4;


        %% Process Hypnogram for ID info
        % load
        N1=StageEpochs{1}; 
        N2=StageEpochs{2}; 
        N3=StageEpochs{3}; 
        REM=StageEpochs{4}; 
        WAKE=StageEpochs{5}; 

        % Sleep Stages
        Rec=or(or(or(N1,or(N2,N3)),REM),WAKE);
        Epochs={N1,N2,N3,REM,WAKE};
        num_substage=[2 1.5 1 3 4]; %ordinate in graph
        indtime=min(Start(Rec)):1E4:max(Stop(Rec));
        timeTsd=tsd(indtime,zeros(length(indtime),1));
        SleepStages=zeros(1,length(Range(timeTsd)))+4.5;
        rg=Range(timeTsd);
        sample_size = median(diff(rg))/10; %in ms

        time_stages = zeros(1,5);
        meanDuration_sleepstages = zeros(1,5);
        for ep=1:length(Epochs)
            idx=find(ismember(rg,Range(Restrict(timeTsd,Epochs{ep})))==1);
            SleepStages(idx)=num_substage(ep);
            time_stages(ep) = length(idx) * sample_size;
            meanDuration_sleepstages(ep) = mean(diff([0;find(diff(idx)~=1);length(idx)])) * sample_size;
        end

        SleepStages=tsd(rg,SleepStages');

        percentvalues_NREM = zeros(1,3);
        for ep=1:3
            percentvalues_NREM(ep) = time_stages(ep)/sum(time_stages(1:3));
        end
        percentvalues_NREM = round(percentvalues_NREM*100,2);

        %to plot
        t_hypno = Range(SleepStages)/1e4;
        y_hypno = Data(SleepStages);

        %% save in h5
        record_name = fullfile(record_output_folder, [num2str(records(p)) '_signals.mat']);
        hypno_name = fullfile(record_output_folder, [num2str(records(p)) '_hypno.mat']);

        save(record_name, '-v7.3', 'eeg', 'labels_eeg', 'breathing')
        save(record_name, '-append', 'slowwaves_start', 'slowwaves_duration', 'spindles_start', 'spindles_duration');
        save(hypno_name, 'Hypnogram', 'SleepStage', 't_hypno', 'y_hypno')
% 
%     catch
%         disp('error for this record')
%     end

end


