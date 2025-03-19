% DetectSpindles
% 27.06.2017 KJ
%
% Mean curves sync on stimulation time - VIRTUAL CHANNEL DATA
% -> Collect data
%
%   see 
%       swa_SS_Template
%

clear

Dir = ListOfClinicalTrialDreemAnalyse('upphase');
p=2;


%% load data
[signals, stimulations, StageEpochs, name_channel, domain, ~] = GetRecordClinic(Dir.filename{p});
% VIRTUAL CHANNEL SIGNAL
[index_dreem, index_psg, ~, ~] = GetVirtualChannels(Dir.filereference{p});
[signals_dreem_vc, signals_psg_vc, badEpochsDreem, badEpochsPsg] = ComputeDataVirtualChannel(signals, index_dreem, index_psg, name_channel);
rg = Range(signals_dreem_vc);
All_night = intervalSet(rg(1),rg(end));
goodEpochs = All_night - badEpochsDreem;



%% Parameters
epoch_length=30; 
fs=250;         
detection_mode='spindles';
op_thr_sp = 150;
signal_epoch = data_epoching(Data(signals_dreem_vc)',fs*epoch_length);

%% Run event automatic detection
[nbr_sp,pos_sp] = test_process(signal_epoch,fs, Dir.subject{p}, detection_mode,op_thr_sp);
   









