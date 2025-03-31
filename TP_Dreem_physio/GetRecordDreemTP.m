function [EEG, accelero, breathing, labels_eeg] = GetRecordDreemTP(filename)
%
%    [EEG, accelero, breathing, labels_eeg] = GetRecordDreem(filename)
%
% INPUT:
% - filename                Filename of the hdF5 file
% 
%
% OUTPUT:
% - EEG                     struct - Filtered EEG signals
% - accelero                array - accelerometer signal
% - breathing               array - breathing signal
% - labels_eeg              labels of EEG signals (derivation)
%       
%


%% params
fs_eeg = 250;
fs_accelero = 50;

% EEG labels
labels_eeg{1} = 'CH1 F7-O1';
labels_eeg{2} = 'CH2 F8-O2'; 
labels_eeg{3} = 'CH3 Fp1-F8'; 
labels_eeg{4} = 'CH4 F8-F7'; 
labels_eeg{5} = 'CH5 F8-O1'; 
labels_eeg{6} = 'CH6 F7-O2'; 
labels_eeg{7} = 'CH7 Fp1-F7'; 

%% load

%eeg channels
for ch=1:7
    EEG{ch} = double(h5read(filename,['/eeg' num2str(ch) '/filtered/']));
end

%accelero
Accelero = double(h5read(filename,'/accelerometer_norm/raw/'));

%breathing
respi.x =  double(h5read(filename,'/accelerometer_x/filtered/'));
respi.y =  double(h5read(filename,'/accelerometer_y/filtered/'));
respi.z =  double(h5read(filename,'/accelerometer_z/filtered/'));


%% times
x_EEG = (0:(length(EEG{1})-1))' / fs_eeg;
x_accelero = (0:(length(Accelero)-1))' / fs_accelero;
x_breathing = (0:(length(respi.x)-1))' / fs_accelero;


%% Signals (EEG - accelero - breathing) 

%eeg
for ch=1:length(EEG)
    EEG{ch} = [x_EEG, EEG{ch}];
end

%accelero
accelero = [x_accelero, Accelero];

%breathing
norm_breathing = respi.x + respi.y + respi.z;
breathing = [x_breathing, norm_breathing];

end


