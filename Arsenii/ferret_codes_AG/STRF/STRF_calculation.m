function STRF_calculation(directory, onsetFile)
%% COMPUTE SPECTROGRAMS FROM TORC
TORClocation = '/media/nas8/OB_ferret_AG_BM/Shropshire/TORCs/';
spectrograms = [];
TORCfnlst = dir([TORClocation '*448*v501*.wav']);
TORCnb = length(TORCfnlst);
for torcNum = 1:TORCnb
    [stimuli(torcNum).file,Fs] = audioread([TORClocation TORCfnlst(torcNum).name]);
    [result(torcNum).s,result(torcNum).w,result(torcNum).t] = spectrogram(stimuli(torcNum).file,440,[],[],Fs,'yaxis');
end
specDat.spectrograms = permute(reshape(vertcat(result(:).s),  size(result(1).s,1), length(result),[]), [3,1,2]);
specDat.freqs= result(torcNum).w;
specDat.time_vector = result(torcNum).t';
soundDur = length(stimuli(torcNum).file)/Fs;
% Display the spectrogram
for ii = []
    figure;
    imagesc(T, freqs, 10*log10(S_log + eps));  % Convert magnitude to dB
    set(gca, 'YScale', 'log');  % Set y-axis to logarithmic scale
    axis xy;
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title('Spectrogram with Logarithmic Frequency Axis');
    colorbar;
    caxis([-10 10]);  % Color scale from -10 to 10 dB
end

%% BIN SPK
file_stim = dir([directory '/Stimuli/*_TORCs.mat']);
file_spikes = dir([directory '/wave_clus/shropshire*']);
TORCmatfile = [file_stim.folder '/' file_stim.name];
spikeFolder = [file_spikes(2).folder '/' file_spikes(2).name '/'];
[binnedspk,chLST,clLST] = ARS_binspikes(spikeFolder,specDat,TORCmatfile,onsetFile);

%% COMPUTE STRF
strf = STRFfromTORC(binnedspk,specDat);

%% COMPUTE SNR
specDat_t = specDat; spectDat_t.time_vector = (0:0.001:3)';
[binnedspk_1kHz] = ARS_binspikes(spikeFolder,spectDat_t,TORCmatfile,onsetFile);
clear spectDat_t
options.plotMe = 0; options.usefirstcycle = 1; options.onlySNR = 1;
d = permute(binnedspk_1kHz,[4 1 3 2]); clear binnedspk_1kHz

% temp = STRFfromTORC_baphy(d,options);
%ephys_TORC2STRF
% strf.snr = temp.snr;

%% PLOT STRF
clusterN = size(strf.weights,3);
cm = [[linspace(0,1,50)' linspace(0,1,50)' ones(50,1)] ; [ones(50,1) linspace(1,0,50)' linspace(1,0,50)']];
for incre = 0:2
    figure;
    for figNum = 1:21
        subplot(5,5,figNum);
        cnum = incre*25+figNum;
        weights = strf.weights(:,:,cnum);
        weights = weights-median(weights(:));
        imagesc(flipud(squeeze(weights)),max(abs(weights(:)))*[-1 1]);
        % imagesc(flipud(rank1approx));
        if figNum==1
            n_freq = size(strf.weights,1);
            logf_flip = flipud(strf.log_freg');
            set(gca, 'YTick', 1:10:n_freq, 'YTickLabel', round(logf_flip(1:10:n_freq)));
            ylabel('Frequency (Hz)');
            set(gca,'XTickLabel',[]);
        elseif figNum==21
            n_lag = size(strf.weights,2);
            set(gca, 'XTick', 1:10:n_lag, 'XTickLabel', round(strf.lags_ms(1:10:n_lag)));
            xlabel('Lag (ms)');
            set(gca,'YTickLabel',[]);
        else set(gca,'XTickLabel',[]); set(gca,'YTickLabel',[]); end
%         ht=title([sprintf('E.%d C.%.d SNR %.2f',chLST(cnum),clLST(cnum),strf.snr(cnum))],'FontSize',6);
        set(gca,'FontSize',6);
%         set(ht,'Interpreter','none');
    end
    drawnow;
    colormap(cm)
end
end