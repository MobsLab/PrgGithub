function Correct_Ferret_Processing(directory)
% channels = [65 21 18 12]; % Shropshire % channels = [1 11 21 13]; % AuCx OB HPC PFC for Brynza
% Define the storage path
cd(directory)

% Get the list of folders in the storage directory
folders = dir(directory);

%% Loop through each folder inside 'directory'
for i = 1:length(folders)
    tic
    
    % Only proceed if it's a directory and not '.' or '..'
    if folders(i).isdir && ~ismember(folders(i).name, {'.', '..', '20241126_LSP'})
        
        %% Construct the full folder path
        folder_path = fullfile(directory, folders(i).name);
        
        % Navigate to this folder
        cd(folder_path);
        disp(folder_path)
        
        % Correct the time according to the wrong sampling rate (recorded at 30 kHz, but should be 20 kHz)
        
        %% LFP
        for lfp=[6,12,15,17,18,19,21,23,31,65]
            disp(['Resampling LFP#' num2str(lfp)])
            % for lfp=[24:27 32:34]
            
            load(['LFPData/LFP' num2str(lfp) '.mat'])
            
            R = Range(LFP)*(2/3);
            % R = Range(LFP)*(3/2);
            
            LFP = tsd(R , Data(LFP));
            save(['LFPData/LFP' num2str(lfp) '.mat'],'LFP', '-v7.3')
            
        end
        
        %% MovAcctsd
        load('behavResources.mat', 'MovAcctsd')
        
        R = Range(MovAcctsd)*(2/3);
        
        MovAcctsd = tsd(R , Data(MovAcctsd));
        save('behavResources.mat', 'MovAcctsd', '-append', '-v7.3')
        
        %% Spectra        
        % OB
        disp('Calculating OB UltraLow')
        load('B_UltraLow_Spectrum.mat')
        Spectro{2}=Spectro{2}*(2/3);
        save('B_UltraLow_Spectrum.mat','Spectro','ch', '-v7.3')
        
        disp('Calculating OB Low')
        load('B_Low_Spectrum.mat')
        Spectro{2}=Spectro{2}*(2/3);
        save('B_Low_Spectrum.mat','Spectro','ch', '-v7.3')
        
        disp('Calculating OB Mid')
        load('B_Middle_Spectrum.mat')
        Spectro{2}=Spectro{2}*(2/3);
        save('B_Middle_Spectrum.mat','Spectro','ch', '-v7.3')
        
        disp('Calculating OB High')
        load('B_High_Spectrum.mat')
        Spectro{2}=Spectro{2}*(2/3);
        save('B_High_Spectrum.mat','Spectro','ch', '-v7.3')
        
        % HPC
        disp('Calculating HPC Low')
        load('H_Low_Spectrum.mat')
        Spectro{2}=Spectro{2}*(2/3);
        save('H_Low_Spectrum.mat','Spectro','ch', '-v7.3')
        
        disp('Calculating HPC Mid')
        load('H_Middle_Spectrum.mat')
        Spectro{2}=Spectro{2}*(2/3);
        save('H_Middle_Spectrum.mat','Spectro','ch', '-v7.3')
        
        
        % PFC
        disp('Calculating PFC Low')
        load('PFCx_Low_Spectrum.mat')
        Spectro{2}=Spectro{2}*(2/3);
        save('PFCx_Low_Spectrum.mat','Spectro','ch', '-v7.3')
        
        disp('Calculating PFC Mid')
        load('PFCx_Middle_Spectrum.mat')
        Spectro{2}=Spectro{2}*(2/3);
        save('PFCx_Middle_Spectrum.mat','Spectro','ch', '-v7.3')
        
        
        % AuCx
        disp('Calculating AuCx Low')
        load('AuCx_Low_Spectrum.mat')
        Spectro{2}=Spectro{2}*(2/3);
        save('AuCx_Low_Spectrum.mat','Spectro','ch', '-v7.3')
        
        disp('Calculating AuCx Mid')
        load('AuCx_Middle_Spectrum.mat')
        Spectro{2}=Spectro{2}*(2/3);
        save('AuCx_Middle_Spectrum.mat','Spectro','ch', '-v7.3')
        
        %% part of another script that seem to do the same thing
        % cd('./LFPData')
        %
        % load(['LFP26.mat'])
        %
        % R = Range(LFP);
        % ind1 = (1:3:length(R));
        % ind2 = (2:3:length(R));
        % ind_sort = sort([ind1 ind2]);
        % R_corr = R(1:length([ind1 ind2]));
        %
        % % Correct LFP channels
        % for chan=[24:29]
        %
        %     load(['LFP' num2str(chan) '.mat'])
        %     D = Data(LFP);
        %     LFP = tsd(R_corr , D(ind_sort));
        %     save(['LFP' num2str(chan) '.mat'],'LFP')
        %
        % end
        %
        % % Correct accelero channels
        % for chan=[32:34]
        %
        %     load(['LFP' num2str(chan) '.mat'])
        %     D = Data(LFP);
        %     LFP = tsd(R_corr , D(ind_sort));
        %     save(['LFP' num2str(chan) '.mat'],'LFP')
        %
        % end
        %
        % FinalFolder = cd;
        % is_OpenEphys = false;
        % MakeData_Accelero(FinalFolder)
        
    end
    disp([num2str(round(toc/60)) 'm'])
end
end


