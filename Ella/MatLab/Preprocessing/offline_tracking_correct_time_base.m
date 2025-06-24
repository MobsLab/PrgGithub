function offline_tracking_correct_time_base(root_dir, original_mat, offline_mat)
    % Default filenames
    if nargin < 2
        original_mat = 'behavResources_Online.mat';
    end
    if nargin < 3
        offline_mat = 'behavResources.mat';
    end

    % Find folders containing both mat files
    folders = find_matching_folders(root_dir, original_mat, offline_mat);
    % if exist(fullfile(root_dir, original_mat), 'file') && exist(fullfile(root_dir, offline_mat), 'file')
    %     folders = {root_dir};
    % else
    %     warning('Could not find required .mat files in: %s', root_dir);
    %     folders = {};
    % end


    for i = 1:length(folders)
        folder = folders{i};
        fprintf('Processing folder: %s\n', folder);
        reply = input(sprintf('Do you want to process this folder? (y/n) [%s]: ', folder), 's');
        if ~strcmpi(reply, 'y')
            fprintf('Skipping folder: %s\n\n', folder);
            continue;
        end

        %% Load Online Data (time vector and needed variables)
        online_vars = {'PosMat', 'GotFrame', 'Zone', 'ZoneLabels', 'th_immob', 'thtps_immob', 'Ratio_IMAonREAL'};
        online = load(fullfile(folder, original_mat), online_vars{:});

        %% Load Offline Data (behavior resources)
        offline_path = fullfile(folder, offline_mat);
        offline = load(offline_path);

        %% Determine of compute time vector
        got_frame = online.GotFrame == 1;
        extracted_time = online.PosMat(got_frame, 1);
        
        if ~isempty(extracted_time)
            new_posmat_time = extracted_time;            % in seconds
            new_time = extracted_time * 1e4;             % for tsd (in 0.1 ms)
        else
            warning('GotFrame contained no usable timestamps. Generating synthetic time with final PosMat time at 900 s.');
        
            n_samples = size(offline.PosMat, 1);          % number of frames
            final_time_sec = 900;                         % target end time
            dt = final_time_sec / (n_samples - 1);        % inferred time step in seconds
            new_posmat_time = (0:n_samples-1)' * dt;      % in seconds
            new_time = new_posmat_time * 1e4;             % for tsd
        end

        %% Backup original behavResources.mat
        backup_path = fullfile(folder, 'behavResources_Offline.mat');
        if ~exist(backup_path, 'file')
            copyfile(offline_path, backup_path);
            fprintf('Backed up original to %s\n', backup_path);
        end

        %% Update PosMat time vector
        if isfield(offline, 'PosMat')
            offline.PosMat(:, 1) = new_posmat_time;
        end

        %% Replace time in all tsd variables
        vars = fieldnames(offline);
        for j = 1:length(vars)
            val = offline.(vars{j});
            if isa(val, 'tsd')
                fprintf('Processing tsd: %s\n', vars{j});
                data = Data(val);
                
                if strcmp(vars{j}, 'Vtsd')  % Special case for Vtsd
                    if length(data) == length(new_time) - 1
                        offline.(vars{j}) = tsd(new_time(1:end-1), data);
                    else
                        warning('Skipping Vtsd: length mismatch.');
                    end
                elseif length(data) == length(new_time)
                    offline.(vars{j}) = tsd(new_time, data);
                else
                    warning('Skipping %s due to length mismatch.', vars{j});
                end
            end
        end

        %% Use variables from online mat
        if isfield(online, 'Zone')
            Zone = online.Zone;
        else
            warning('Zone not found in online file. Skipping folder.');
            continue;
        end
        
        if isfield(online, 'th_immob')
            th_immob = online.th_immob;
        else
            warning('th_immob not found. Using default value 20.');
            th_immob = 20;
        end
        
        if isfield(online, 'thtps_immob')
            thtps_immob = online.thtps_immob;
        else
            warning('thtps_immob not found. Using default value 2.');
            thtps_immob = 2;
        end
        
        if isfield(online, 'Ratio_IMAonREAL')
            Ratio_IMAonREAL = online.Ratio_IMAonREAL;
        else
            warning('Ratio_IMAonREAL not found.');
        end


        %% Recompute FreezeEpoch from Imdifftsd
        Imdifftsd = offline.Imdifftsd;
        FreezeEpoch = thresholdIntervals(Imdifftsd, th_immob, 'Direction', 'Below');
        FreezeEpoch = mergeCloseIntervals(FreezeEpoch, 0.3 * 1e4);
        FreezeEpoch = dropShortIntervals(FreezeEpoch, thtps_immob * 1e4);
        offline.FreezeEpoch = FreezeEpoch;

        %% Recompute ZoneEpochs from Xtsd and Ytsd
        Xtsd = offline.Xtsd;
        Ytsd = offline.Ytsd;
        Xtemp = Data(Xtsd);
        T1 = Range(Xtsd);

        XXX = floor(Data(Xtsd) * Ratio_IMAonREAL);
        XXX(isnan(XXX)) = 240;
        YYY = floor(Data(Ytsd) * Ratio_IMAonREAL);
        YYY(isnan(YYY)) = 320;

        for t = 1:length(Zone)
            ZoneIndices{t} = find(diag(Zone{t}(XXX, YYY)));
            Xtemp2 = zeros(size(Xtemp));
            Xtemp2(ZoneIndices{t}) = 1;
            temp_tsd = tsd(T1, Xtemp2);
            ZoneEpoch{t} = thresholdIntervals(temp_tsd, 0.5, 'Direction', 'Above');
        end

        offline.ZoneEpoch = ZoneEpoch;

        %% Save updated offline structure back to behavResources.mat
        save(offline_path, '-struct', 'offline', '-v7');
        fprintf('Updated and saved: %s\n\n', offline_path);
    end
end

function folders = find_matching_folders(root_dir, original_mat, offline_mat)
    folders = {};
    all_dirs = strsplit(genpath(root_dir), pathsep);
    for i = 1:length(all_dirs)
        d = all_dirs{i};
        if isempty(d), continue; end
        if exist(fullfile(d, original_mat), 'file') && exist(fullfile(d, offline_mat), 'file')
            folders{end+1} = d;
        end
    end
end

