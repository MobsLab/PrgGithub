
function MakeInstFreqForSession_BM


% Structures={'H','B','PFCx'};
Structures={'B'};
% Structures={'Respi'}; % Added by Ella
AllCombi=combnk(1:3,2);

if (exist('InstFreqAndPhase.mat'))>0
    movefile('InstFreqAndPhase.mat','InstFreqAndPhase_B.mat')
    movefile('InstantaneousFrequencyEstimate.png','InstantaneousFrequencyEstimate_B.png')
end
Docalc=1;
clear Options


if Docalc
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
    
    %% Load relevant LFPs
    clear channel LFP LFPdowns
    try
        load('ChannelsToAnalyse/Respi.mat')
    catch
        load('ChannelsToAnalyse/Bulb_deep.mat')
    end
%     load('ChannelsToAnalyse/Respi.mat') % Added by Ella
    load(['LFPData/LFP',num2str(channel),'.mat'])
    tps=Range((LFP));
    vals=Data((LFP));
    LFPdowns=tsd(tps(1:Options.WVDownsample:end),vals(1:Options.WVDownsample:end));
    AllLFP.B=LFPdowns;
%     AllLFP.Respi=LFPdowns; % Added by Ella
    
    rmpath([dropbox '/Kteam/PrgMatlab/chronux2/spectral_analysis/continuous/'])
    
    %%Get local phase and amplitude with two methods
    for struc=1:length(Structures)
        clear Wavelet val ind LocalFreq LocalPhase AllPeaks tpstemp

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
        save(['InstFreqAndPhase_',Structures{struc},'.mat'],'LocalFreq','LocalPhase','AllPeaks','Options','-v7.3')
        
        % Figure
        fig=figure;fig.Position=[1 1 800 500];
        plot(Range(LocalFreq.PT,'s')/60,(Data(LocalFreq.PT)),'r')
        ylim([0 16]),xlim([0 max(Range(LocalFreq.PT,'s')/60)])
        legend('PT')
        saveas(fig.Number,['InstantaneousFrequencyEstimate_',Structures{struc},'.png'])
        close all
    end
    
    clear AllLFP RemParams
end



