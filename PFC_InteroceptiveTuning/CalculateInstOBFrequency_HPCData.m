clear all

% Data location
Dir=PathForExperimentsERC_Dima('UMazePAG');
MiceNumber = [905,911,994,1161,1162,1168,1186,1230,1239];
MiceInDir = cellfun(@(x) eval(x(6:end)),Dir.name);
MiceToKeep = ismember(MiceInDir,MiceNumber);
AllMiceFolders = Dir.path(MiceToKeep);
rmpath('/home/pinky/Documents/PrgGithub/chronux2/spectral_analysis/continuous/')

% Parameters
clear Options
Options.Fs=1250; % sampling rate of LFP
Options.FilBand=[1 15];
Options.std=[0.4 0.1]; % std limits for first and second round of peak
Options.TimeLim=0.08; % in second, minimum distance between two minima or
Options.NumOctaves=8;
Options.VoicesPerOctave=48;
Options.VoicesPerOctaveCoherence=32;
Options.FreqLim=[1.5,30];
Options.WVDownsample=10;
Options.TimeBandWidth=15;
Options1=Options;
Options1.Fs=Options.Fs/Options.WVDownsample;

Structures={'B'};
AllCombi=combnk(1:3,2);
for ss=1:length(AllMiceFolders)
    cd(AllMiceFolders{ss}{1})
    clear channel LFP LFPdowns
    load('ChannelsToAnalyse/Bulb_deep.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    tps=Range((LFP));
    vals=Data((LFP));
    LFPdowns=tsd(tps(1:Options.WVDownsample:end),vals(1:Options.WVDownsample:end));
    AllLFP.B=LFPdowns;
    
    
    
    %%Get local phase and amplitude with two methods
    for struc=1:length(Structures)
        clear Wavelet val ind LocalFreq LocalPhase AllPeaks tpstemp
        % Wavelet method
        [Wavelet.spec,Wavelet.freq,Wavelet.coi,Wavelet.OutParams]=cwt_SB(Data(AllLFP.(Structures{struc})),Options.Fs/Options.WVDownsample,'NumOctaves',Options.NumOctaves,...
            'VoicesPerOctave',Options.VoicesPerOctave,'TimeBandwidth',Options.TimeBandWidth);
        Wavelet.spec=Wavelet.spec(find(Wavelet.freq<Options.FreqLim(2),1,'first'):find(Wavelet.freq>Options.FreqLim(1),1,'last'),:);
        Wavelet.freq=Wavelet.freq(find(Wavelet.freq<Options.FreqLim(2),1,'first'):find(Wavelet.freq>Options.FreqLim(1),1,'last'));
        [val,ind]=max(abs(Wavelet.spec));
        LocalFreq.WV=tsd(Wavelet.OutParams.t*1e4,Wavelet.freq(ind));
        idx=sub2ind(size(Wavelet.spec),ind,1:length(ind));
        LocalPhase.WV=tsd(Wavelet.OutParams.t*1e4,angle(Wavelet.spec(idx))');
        % Peak-Trough method
        AllPeaks=FindPeaksForFrequency(AllLFP.(Structures{struc}),Options1,0);
        AllPeaks(:,3)=[0:pi:pi*(length(AllPeaks)-1)];
        Y=interp1(AllPeaks(:,1),AllPeaks(:,3),Range(AllLFP.(Structures{struc}),'s'));
        if AllPeaks(1,2)==1
            LocalPhase.PT=tsd(Range(AllLFP.(Structures{struc})),mod(Y,2*pi));
        else
            LocalPhase.PT=tsd(Range(AllLFP.(Structures{struc})),mod(Y+pi,2*pi));
        end
        tpstemp=AllPeaks(2:2:end,1);
        LocalFreq.PT=tsd(tpstemp(1:end-1)*1e4,1./diff(AllPeaks(2:2:end,1)));
        save(['InstFreqAndPhase_',Structures{struc},'.mat'],'LocalFreq','LocalPhase','AllPeaks','Options','Wavelet','-v7.3')
        
        % Figure
        fig=figure;fig.Position=[1 1 800 500];
        subplot(211)
        plotscalogramfreq_SB(Wavelet.OutParams.FourierFactor,Wavelet.OutParams.sigmaT,Wavelet.spec,Wavelet.freq,Wavelet.OutParams.t,Wavelet.OutParams.normalizedfreq)
        caxis([0 1000])
        colorbar off
        subplot(212)
        plot(Range(LocalFreq.WV,'s')/60,(Data(LocalFreq.WV)),'k'),hold on
        plot(Range(LocalFreq.PT,'s')/60,(Data(LocalFreq.PT)),'r')
        ylim([0 16]),xlim([0 max(Range(LocalFreq.PT,'s')/60)])
        legend('WV','PT')
        RemParams=Wavelet.OutParams;
        saveas(fig.Number,['InstantaneousFrequencyEstimate_',Structures{struc},'.png'])
        close all
    end
    clear AllLFP RemParams
end
addpath('/home/pinky/Documents/PrgGithub/chronux2/spectral_analysis/continuous/')
