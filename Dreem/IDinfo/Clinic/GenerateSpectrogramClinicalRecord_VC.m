% GenerateSpectrogramClinicalRecord_VC
% 03.07.2017 KJ
%
%
% infos = GenerateSpectrogramClinicalRecord_VC(filereference)
%
% infos = GenerateSpectrogramClinicalRecord_VC(p, Dir)
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
%   Compute and eventually save spectral data from clinical records - VIRTUAL CHANNEL
% 
%
% SEE 
%   ParcoursGenerateSpectrogramClinicalRecord_VC
%
%



function params_specg = GenerateSpectrogramClinicalRecord_VC(filereference,Dir)

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
[index_dreem, index_psg, ~, ~] = GetVirtualChannels(Dir.filereference{p});
% VIRTUAL CHANNEL SIGNAL 
[signals_dreem_vc, signals_psg_vc, ~, ~] = ComputeDataVirtualChannel(signals, index_dreem, index_psg, name_channel);


%% Spectrogram
[Sp_dreem,t_dreem,f_dreem] = mtspecgramc(Data(signals_dreem_vc), params.movingwin_specg, params_specg);
[Sp_psg,t_psg,f_psg] = mtspecgramc(Data(signals_psg_vc), params.movingwin_specg, params_specg);


%% Spectrogram
figure('Color',[1 1 1],'units','normalized','outerposition',[0 0 1 1]);
Dreem_Axes = axes('position', [0.05 0.5 0.9 0.39]);
Actiwave_Axes = axes('position', [0.05 0.05 0.9 0.39]);

%dreem
axes(Dreem_Axes);
imagesc(t_dreem/3600, f_dreem, log(Sp_dreem)'), hold on
axis xy, ylabel('frequency'), hold on
set(gca,'Yticklabel',5:5:35,'xlim',[0 max(t_dreem/3600)]);
colorbar, caxis([-8 8]);
title('DREEM Virtual Channel'),
%actiwave
axes(Actiwave_Axes);
imagesc(t_psg/3600, f_psg, log(Sp_psg)'), hold on
axis xy, ylabel('frequency'), hold on
set(gca,'Yticklabel',5:5:35,'xlim',[0 max(t_psg/3600)]);
colorbar, caxis([-8 8]);
title('Actiwave Virtual Channel'), xlabel('time (h)'),

%main title
%suplabel(['Spectrogram - subject ' num2str(Dir.subject{p}) ' - night ' num2str(Dir.night{p}) ' - ' Dir.condition{p} ' - ' Dir.date{p}], 't');
if strcmpi(Dir.condition{p},'upphase')
    suplabel(['Subject ' num2str(Dir.subject{p}) ' - Ascending phase'], 't');
elseif strcmpi(Dir.condition{p},'upphase')
    suplabel(['Subject ' num2str(Dir.subject{p}) ' - Random phase'], 't');
else
    suplabel(['Subject ' num2str(Dir.subject{p}) ' - ' Dir.condition{p}], 't');
end

end


