% PlotExampleSpectrogramVC
% 07.07.2017 KJ
%
% Plot spectrogram example from Dreem 
%
%   see 
%       GenerateSpectrogramClinicalRecord_VC 
%



clear

%% params
params.movingwin_specg = [3 0.2];
params_specg.fpass = [0.4 30];
params_specg.tapers = [3 5];
params_specg.Fs = 250;
normalizing = 0;


%% Load data

%files
filereferences = [28188, 28450, 28169];
for i=1:length(filereferences)
    filenames{i}= [FolderClinicRecords num2str(filereferences(i)) '.h5'];
end
p=1;

%load
[signals, ~, ~, name_channel, ~, ~] = GetRecordClinic(filenames{p});
[index_dreem, index_psg, ~, ~] = GetVirtualChannels(filereferences(p));
% VIRTUAL CHANNEL SIGNAL 
[signals_dreem_vc, signals_psg_vc, ~, ~] = ComputeDataVirtualChannel(signals, index_dreem, index_psg, name_channel);


%% Spectrogram
[Sp_dreem,t_dreem,f_dreem] = mtspecgramc(Data(signals_dreem_vc), params.movingwin_specg, params_specg);
[Sp_psg,t_psg,f_psg] = mtspecgramc(Data(signals_psg_vc), params.movingwin_specg, params_specg);

%% Normalize
if normalizing
    Sp_dreem_z = zscore(Sp_dreem);
    Sp_psg_z = zscore(Sp_psg);
else
    Sp_dreem_z = log10(Sp_dreem);
    Sp_psg_z = log10(Sp_psg);
end

%% Spectrogram
figure('Color',[1 1 1],'units','normalized','outerposition',[0 0 1 1]);
Dreem_Axes = axes('position', [0.05 0.5 0.9 0.39]);
Actiwave_Axes = axes('position', [0.05 0.05 0.9 0.39]);

%dreem
axes(Dreem_Axes);
imagesc(t_dreem/3600, f_dreem, Sp_dreem_z'), hold on
axis xy, ylabel('frequency'), hold on
set(gca,'Yticklabel',5:5:35);
colorbar,
caxis([-2 2]);
title('DREEM Virtual Channel')
%actiwave
axes(Actiwave_Axes);
imagesc(t_psg/3600, f_psg, Sp_psg_z'), hold on
axis xy, ylabel('frequency'), xlabel('time (h)'), hold on
set(gca,'Yticklabel',5:5:35);
colorbar,
caxis([-2 2]);
title('Actiwave Virtual Channel')

%main title
suplabel(['Spectrogram - record ' num2str(filereferences(p))], 't');





