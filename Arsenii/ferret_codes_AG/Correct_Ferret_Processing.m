function Correct_Ferret_Processing(directory, sessions)
% channels = [6,12,15,17,18,19,21,23,31,65,111,112]; % Shropshire 
% channels = [1 11 21 13]; % AuCx OB HPC PFC for Brynza
channels = [24 25 26 27 28 36 37 42]; % AuCx OB HPC PFC for Edel

% Define the storage path
cd(directory)

% Get the list of folders in the storage directory
folders = dir(directory);

%% Loop through each folder inside 'directory'
for i = 1:length(folders)
    tic
    
    % Only proceed if it's a directory and not '.' or '..'
    if folders(i).isdir && ~ismember(folders(i).name, {'.', '..'}) && ismember(folders(i).name, sessions)
         
        
        %% Construct the full folder path
        folder_path = fullfile(directory, folders(i).name);
        
        % Navigate to this folder
        cd(folder_path);
        disp(folder_path)
        
        % Correct the time according to the wrong sampling rate (recorded at 30 kHz, but should be 20 kHz)
        
        %% LFP
        uncor_LFP = load([folder_path '/LFPData/LFP0.mat']);
        uncor_LFP = uncor_LFP.LFP;
        r1 = Range(uncor_LFP, 's');
        disp(['uncorrected LFP value: ' num2str(r1(end)/60) ])
        
        for lfp=channels
            disp(['Resampling LFP#' num2str(lfp)])
            % for lfp=[24:27 32:34]
            
            load(['LFPData/LFP' num2str(lfp) '.mat'])
            
%             R = Range(LFP);

            R = Range(LFP)*(2/3);
            % R = Range(LFP)*(3/2);
            
            LFP = tsd(R , Data(LFP));
            disp(['LFP# ' num2str(lfp) ' new size is ' num2str(R(end)/6e5)])
            save(['LFPData/LFP' num2str(lfp) '.mat'],'LFP', '-v7.3')
            
        end
        
        %% MovAcctsd
        load('behavResources.mat', 'MovAcctsd')
        clear R
        R = Range(MovAcctsd)*(2/3);
        
        MovAcctsd = tsd(R , Data(MovAcctsd));
        
        disp(['MovAcctsd new size is ' num2str(R(end)/6e5)])
        save('behavResources.mat', 'MovAcctsd', '-append', '-v7.3')
        
        %% Spectra
        
        % OB
        clear Spectro
        disp('Calculating OB UltraLow')
        load('B_UltraLow_Spectrum.mat')
        Spectro{2}=Spectro{2}*(2/3);
        s = Spectro{2}; disp([num2str(s(end)/60)]); clear s
        save('B_UltraLow_Spectrum.mat','Spectro','ch', '-v7.3')
        
        clear Spectro
        disp('Calculating OB Low')
        load('B_Low_Spectrum.mat')
        Spectro{2}=Spectro{2}*(2/3);
        s = Spectro{2}; disp([num2str(s(end)/60)]); clear s
        save('B_Low_Spectrum.mat','Spectro','ch', '-v7.3')
        
        clear Spectro
        disp('Calculating OB Mid')
        load('B_Middle_Spectrum.mat')
        Spectro{2}=Spectro{2}*(2/3);
        s = Spectro{2}; disp([num2str(s(end)/60)]); clear s
        save('B_Middle_Spectrum.mat','Spectro','ch', '-v7.3')
        
        clear Spectro
        disp('Calculating OB High')
        load('B_High_Spectrum.mat')
        Spectro{2}=Spectro{2}*(2/3);
        s = Spectro{2}; disp([num2str(s(end)/60)]); clear s
        save('B_High_Spectrum.mat','Spectro','ch', '-v7.3')
        
        % HPC
        clear Spectro
        disp('Calculating HPC Low')
        load('H_Low_Spectrum.mat')
        Spectro{2}=Spectro{2}*(2/3);
        s = Spectro{2}; disp([num2str(s(end)/60)]); clear s
        save('H_Low_Spectrum.mat','Spectro','ch', '-v7.3')
        
        clear Spectro
        disp('Calculating HPC Mid')
        load('H_Middle_Spectrum.mat')
        Spectro{2}=Spectro{2}*(2/3);
        s = Spectro{2}; disp([num2str(s(end)/60)]); clear s
        save('H_Middle_Spectrum.mat','Spectro','ch', '-v7.3')
        
        
%         % PFC
%         clear Spectro
%         disp('Calculating PFC Low')
%         load('PFCx_Low_Spectrum.mat')
%         Spectro{2}=Spectro{2}*(2/3);
%         s = Spectro{2}; disp([num2str(s(end)/60)]); clear s
%         save('PFCx_Low_Spectrum.mat','Spectro','ch', '-v7.3')
%         
%         clear Spectro
%         disp('Calculating PFC Mid')
%         load('PFCx_Middle_Spectrum.mat')
%         Spectro{2}=Spectro{2}*(2/3);
%         s = Spectro{2}; disp([num2str(s(end)/60)]); clear s
%         save('PFCx_Middle_Spectrum.mat','Spectro','ch', '-v7.3')
%         
%         
%         % AuCx
%         clear Spectro
%         disp('Calculating AuCx Low')
%         load('AuCx_Low_Spectrum.mat')
%         Spectro{2}=Spectro{2}*(2/3);
%         s = Spectro{2}; disp([num2str(s(end)/60)]); clear s
%         save('AuCx_Low_Spectrum.mat','Spectro','ch', '-v7.3')
%         
%         clear Spectro
%         disp('Calculating AuCx Mid')
%         load('AuCx_Middle_Spectrum.mat')
%         Spectro{2}=Spectro{2}*(2/3);
%         s = Spectro{2}; disp([num2str(s(end)/60)]); clear s
%         save('AuCx_Middle_Spectrum.mat','Spectro','ch', '-v7.3')
             
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


