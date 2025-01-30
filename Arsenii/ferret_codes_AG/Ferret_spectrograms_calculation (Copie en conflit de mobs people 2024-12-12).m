function Ferret_spectrograms_calculation(directory)
channels = [65 21 18 12]; % Shropshire % channels = [1 11 21 13]; % AuCx OB HPC PFC for Brynza
% Define the storage path
cd(directory)

% Get the list of folders in the storage directory
folders = dir(directory);

%% Loop through each folder inside 'filename'
for i = 1:length(folders)
    tic
    % Only proceed if it's a directory and not '.' or '..'
    if folders(i).isdir && ~ismember(folders(i).name, {'.', '..', '20241126_LSP'})
        
        %% Construct the full folder path
        folder_path = fullfile(directory, folders(i).name);
        
        % Navigate to this folder
        cd(folder_path);
        disp(folder_path)
        
        %% Auditory cortex spectrograms
        if ~(exist('AuCx_Low_Spectrum.mat', 'file') == 2)
            LowSpectrumSB(pwd, channels(1),'AuCx');
            disp('AuCx_Low done');
        else
            disp('AuCx_Low already exists');
        end
        
        if ~(exist('AuCx_Middle_Spectrum.mat', 'file') == 2)
            MiddleSpectrum_BM(pwd, channels(1) ,'AuCx');
            disp('AuCx_Middle done');
        else
            disp('AuCx_Middle already exists');
        end
        
        %% Olfactory Bulb spectrograms
        if ~(exist('B_UltraLow_Spectrum.mat', 'file') == 2)
            UltraLowSpectrumBM(pwd, channels(2),'B');
            disp('B_UltraLow done');
        else
            disp('B_UltraLow already exists');
        end
        
        if ~(exist('B_Low_Spectrum.mat', 'file') == 2)
            LowSpectrumSB(pwd, channels(2),'B');
            disp('B_Low done');
        else
            disp('B_Low already exists');
        end
        
        if ~(exist('B_Middle_Spectrum.mat', 'file') == 2)
            MiddleSpectrum_BM(pwd, channels(2),'B');
            disp('B_Middle done');
        else
            disp('B_Middle already exists');
        end
        
        if ~(exist('B_High_Spectrum.mat', 'file') == 2)
            HighSpectrum(pwd, channels(2),'B');
            disp('B_High done');
        else
            disp('B_High already exists');
        end
        
        %% Hippocampus spectrograms
        if ~(exist('H_Low_Spectrum.mat', 'file') == 2)
            LowSpectrumSB(pwd, channels(3),'H');
            disp('H_Low done');
        else
            disp('H_Low already exists');
        end
        
        if ~(exist('H_Middle_Spectrum.mat', 'file') == 2)
            MiddleSpectrum_BM(pwd, channels(3),'H');
            disp('H_Middle done');
        else
            disp('H_Middle already exists');
        end
        
        %% PFCx spectrograms
        if ~(exist('PFCx_Low_Spectrum.mat', 'file') == 2)
            LowSpectrumSB(pwd, channels(4),'PFCx');
            disp('PFCx_Low done');
        else
            disp('PFCx_Low already exists');
        end
        
        if ~(exist('PFCx_Middle_Spectrum.mat', 'file') == 2)
            MiddleSpectrum_BM(pwd, channels(4),'PFCx');
            disp('PFCx_Middle done');
        else
            disp('PFCx_Middle already exists');
        end
    end
    disp([num2str(round(toc/60)) 'm'])
end
