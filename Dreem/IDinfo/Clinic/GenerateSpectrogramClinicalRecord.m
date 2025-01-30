% GenerateSpectrogramClinicalRecord
% 13.03.2017 KJ
%
%
% infos = GenerateSpectrogramClinicalRecord(filereference)
%
% infos = GenerateSpectrogramClinicalRecord(p, Dir)
%
%
% OPTIONAL ARGUMENT:
% - toSave              (optional) 1 to save the data, 0 otherwise
%                       default 1
% - toPlot              (optional) 1 to plot the figure, 0 otherwise
%                       default 0
%
% OUTPUT:
% - params_specg        struct - params of the spectrogram computation
%
%
% INFOS
%   Compute and eventually save spectral data from clinical records
% 
%
% SEE 
%   ParcoursGenerateSpectrogramClinicalRecord
%
%



function params_specg = GenerateSpectrogramClinicalRecord(filereference,Dir,varargin)

%% CHECK INPUTS

if nargin < 1,
  error('Incorrect number of parameters.');
end

if ~exist('Dir','var')
    Dir = ListOfClinicalTrialDreem('all');
    p = find(cell2mat(Dir.filereference)==filereference);
else
    p = filereference;
end


%% params
params.channels_frontal = [1 2 7 10];

%spectrogram params
params.movingwin_specg = [3 0.2];
params_specg.fpass = [0.4 30];
params_specg.tapers = [3 5];
params_specg.Fs = 250;


%% load data
[signals, ~, ~, name_channel, ~, ~] = GetRecordClinic(Dir.filename{p});
% infos.name_channel = {'FP1-M1','FP2-M2','FP2-FP1','FP1-FPz','REF O1','REF C3','REF F3','REF O2','REF C4','REF F4','REF E1','REF E2','REF ECG','REF EMG'};
params.channel_specg = [1 2 3 4 7 10 6 9 5 8];

%% Spectrogram
figure, hold on
a=0;
for ch=params.channel_specg
    a=a+1;
    subplot(5,2,a), hold on
    signal_specg = ResampleTSD(signals{ch}, params_specg.Fs);
    [Specg,t_spg,f_spg] = mtspecgramc(Data(signal_specg), params.movingwin_specg, params_specg);
    
    imagesc(t_spg/3600, f_spg, log(Specg)'), hold on
    axis xy, ylabel('frequency'), hold on
    set(gca,'Yticklabel',5:5:25);
    title(name_channel{ch})
end
suplabel(['Spectrogram - subject ' num2str(Dir.subject{p}) ' - night ' num2str(Dir.night{p}) ' - ' Dir.condition{p} ' - ' Dir.date{p}], 't');


end


