storage = '/media/nas7/React_Passive_AG/OBG/Labneh/freely-moving';
cd(storage)
folders = dir(storage);

for i = 1:length(folders)
    if folders(i).isdir && ~ismember(folders(i).name, {'.', '..'})
        % Construct the full folder path
        folder_path = fullfile(storage, folders(i).name);
        
        % Navigate to this folder
        cd(folder_path);
        
        % Update 'ExpeInfo' file within the current folder
        try
            load('ExpeInfo.mat')
            disp(ExpeInfo.ChannelToAnalyse)
            ExpeInfo.ChannelToAnalyse.ThetaREM = 1;
            save('ExpeInfo', 'ExpeInfo', '-append');
        catch
            warning('Failed to update ExpeInfo in folder: %s', folder_path);
        end
        
        % Check if 'ChannelsToAnalyse' folder exists within the current folder
        channels_folder = fullfile(folder_path, 'ChannelsToAnalyse');
        
        if exist(channels_folder, 'dir')
            cd(channels_folder);
            
            % Update 'ThetaREM' channel file
            try
                channel = 1;
                save('ThetaREM', 'channel');
            catch
                warning('Failed to save ThetaREM in folder: %s', channels_folder);
            end
        else
            warning('ChannelsToAnalyse folder does not exist in: %s', folder_path);
        end
        
        % Clear variables specific to the current folder processing
        clearvars ExpeInfo channel folder_path channels_folder;
        
        % Return to the main storage directory for the next iteration
        cd(storage);    
    end
end




