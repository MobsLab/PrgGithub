% WaveletVsMTFourrierSleep
% 20.10.2017 KJ
%
% Compare scalogram and spectrogram during sleep
%
%
%


clear

%% Load data

%LFP
load ChannelsToAnalyse/PFCx_deltadeep
eval(['load LFPData/LFP',num2str(channel)])
PFCsup=LFP;
clear LFP

load ChannelsToAnalyse/PFCx_deltasup
eval(['load LFPData/LFP',num2str(channel)])
PFCdeep=LFP;
clear LFP

load ChannelsToAnalyse/dHPC_rip
eval(['load LFPData/LFP',num2str(channel)])
HPC=LFP;
clear LFP

load ChannelsToAnalyse/Bulb_deep
eval(['load LFPData/LFP',num2str(channel)])
Bulb=LFP;
clear LFP

%StateEpoch
load StateEpochSB SWSEpoch Wake REM
%Substages
load NREMepochsML.mat op NamesOp Dpfc Epoch noise
[EP,NamesEP]=DefineSubStages(op,noise);
N1=EP{1}; N2=EP{2}; N3=EP{3}; REM=EP{4}; WAKE=EP{5}; SWS=EP{6}; swaOB=EP{8};
Rec=or(or(SWS,REM),WAKE);
Epochs={N1,N2,N3,REM,WAKE};
num_substage=[2 1.5 1 3 4]; %ordinate in graph

indtime=min(Start(Rec)):500:max(Stop(Rec));
timeTsd=tsd(indtime,zeros(length(indtime),1));
SleepStages=zeros(1,length(Range(timeTsd)))+4.5;
rg=Range(timeTsd);
sample_size = median(diff(rg))/10; %in ms
for ep=1:length(Epochs)
    idx=ismember(rg,Range(Restrict(timeTsd,Epochs{ep})))==1;
    SleepStages(idx)=num_substage(ep);
end
SleepStages=tsd(rg,SleepStages');



%% Signal restricted and downsample
new_fs = 500;
intv = intervalSet(4000E4,5400E4);

Signals = {PFCsup, PFCdeep, HPC, Bulb};
name_signals = {'PFCx sup', 'PFCx deep', 'HPC', 'Bulb deep'};

for i=1:length(Signals)
    Signals{i} = ResampleTSD(Restrict(Signals{i}, intv), new_fs);
end
SleepStages_intv = Restrict(SleepStages, intv);
rg = Range(SleepStages_intv);
start_sleepstage = rg(1);


%% Scalograms and spectrogram, with hypnogram

%Scalogram Parameters
OptionScalo.Fs=new_fs; % sampling rate of LFP
OptionScalo.NumOctaves=10;
OptionScalo.VoicesPerOctave=48;

%Spectrogram Parameters
movingwin_specg = [3 0.2];
OptionSpecg.fpass = [0.4 80];
OptionSpecg.tapers = [3 5];
OptionSpecg.Fs = 250;


for i=1:length(Signals)
    
    %scalogram
    [Wavelet.scalog, Wavelet.freq,Wavelet.coi, Wavelet.OutParams] = cwt_SB(Data(Signals{i}), OptionScalo.Fs, 'NumOctaves', OptionScalo.NumOctaves, 'VoicesPerOctave', OptionScalo.VoicesPerOctave);
    % get ints phase and peak freq
    [val, ind] = max(abs(Wavelet.scalog));
    LocalFreq.WV = tsd(Wavelet.OutParams.t*1e4,Wavelet.freq(ind));
    idx = sub2ind(size(Wavelet.scalog),ind,1:length(ind));
    LocalPhase.WV = tsd(Wavelet.OutParams.t*1e4,angle(Wavelet.scalog(idx))');
    
    %spectrogram multitaper
    [Multitaper.specg, Multitaper.t, Multitaper.freq] = mtspecgramc(Data(Signals{i}), movingwin_specg, OptionSpecg);
    
    
    %% plot
    figure('Color',[1 1 1],'units','normalized','outerposition',[0 0 1 1]);
    Scalo_Axes = axes('position', [0.05 0.68 0.9 0.3]);
    Spectro_Axes = axes('position', [0.05 0.35 0.9 0.3]);
    Hypno_axes = axes('position', [0.05 0.02 0.865 0.3]);
    
    %scalogram
    axes(Scalo_Axes);
    plotscalogramfreq_SB(Wavelet.OutParams.FourierFactor, Wavelet.OutParams.sigmaT, Wavelet.scalog, Wavelet.freq, Wavelet.OutParams.t, Wavelet.OutParams.normalizedfreq)
    set(gca, 'Xticklabel',{}), xlabel('');
    title('Morse wavelet scalogram'),
    
    %spectrogram
    axes(Spectro_Axes);
    imagesc(Multitaper.t/60, Multitaper.freq, log(Multitaper.specg)'), hold on
    axis xy, ylabel('frequency'), hold on
    colorbar, 
    set(gca,'Yticklabel',5:5:35, 'Xticklabel',{},'xlim',[0 max(Multitaper.t/60)]);
    title('Chronux multi-taper spectrogram'),
    
    %hypnogram
    axes(Hypno_axes);
    ylabel_substage = {'N3','N2','N1','REM','WAKE'};
    ytick_substage = [1 1.5 2 3 4]; %ordinate in graph
    colori = {[0.5 0.3 1], [1 0.5 1], [0.8 0 0.7], [0.1 0.7 0], [0.5 0.2 0.1]}; %substage color
    plot((Range(SleepStages_intv,'s')-start_sleepstage/1E4)/60, Data(SleepStages_intv),'k'), hold on,
    for ep=1:length(Epochs)
        plot((Range(Restrict(SleepStages_intv,Epochs{ep}),'s')-start_sleepstage/1E4)/60 ,Data(Restrict(SleepStages_intv,Epochs{ep})),'.','Color',colori{ep}), hold on,
    end
    xlim([0 max(Range(SleepStages_intv,'s')-start_sleepstage/1E4)/60]), ylim([0.5 5]), set(gca,'Ytick',ytick_substage,'YTickLabel',ylabel_substage), hold on,
    title('Hypnogram'); xlabel('Time (min)')
    
    
    suplabel('', 't');
    
end






