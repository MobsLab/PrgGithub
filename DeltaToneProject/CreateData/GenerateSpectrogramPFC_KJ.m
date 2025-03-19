%%GenerateSpectrogramPFC_KJ
%
% 26.02.2018 KJ
%
%


%% load data

%LFP 
Signals = cell(0);
load('ChannelsToAnalyse/PFCx_locations.mat','channels')

for ch=1:length(channels)
    load(['LFPData/LFP' num2str(channels(ch))], 'LFP')
    Signals{ch} = LFP; clear LFP
end


%% spectrogram
mkdir('Spectra')

params.fpass  = [0.1 48];
params.tapers = [3 5];
movingwin     = [3 0.2];
params.Fs     = 1250;

%for each location of PFCx
for ch=1:length(Signals)
    
    [Sp,t,f]=mtspecgramc(Data(Signals{ch}),movingwin,params);
    Spectro={Sp,t,f};
    
    savefolder = fullfile('Spectra', ['Specg_ch' num2str(channels(ch))]);
    channel =  channels(ch);
    save(savefolder,'Spectro','params','movingwin', 'channel', '-v7.3')

end




