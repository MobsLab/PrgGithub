clear all
[Dir_CD1_CD1cage,Dir_CD1_C57cage,Dir_Sleep_CD1InCage,Dir_Sleep_CD1NOTInCage,Dir_Sleep_Ctrl,...
    Info_CD1_CD1cage,Info_CD1_C57cage,Info_Sleep_CD1InCage,Info_Sleep_CD1NOTInCage,Info_Sleep_Ctrl] = Get_SD_Path_UmazeComp;

%% need to add baseline mice to see if they are freezing more or less than after SDS
AllDir = {Dir_CD1_CD1cage,Dir_CD1_C57cage,Dir_Sleep_CD1InCage,Dir_Sleep_CD1NOTInCage,Dir_Sleep_Ctrl};
GroupNames = {'CD1_Exp','C57_Exp','C57_Sleep','CD1_Sleep','Ctrl_Sleep'};

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
rmpath([dropbox '/Kteam/PrgMatlab/chronux2/spectral_analysis/continuous/'])


%% Get data SDS mice
for dirnum  = 3:length(AllDir)
    for dd = 1:length(AllDir{dirnum})
        for ddd = 1:length(AllDir{dirnum}{dd}.path)
            ddd
            % Get data
            cd(AllDir{dirnum}{dd}.path{ddd}{1});
            go = 0;
            if (exist('InstFreqAndPhase_B.mat'))
                Info = dir('InstFreqAndPhase_B.mat');
                Y = datevec(Info.datenum);
                if Y(1)<2024
                   go = 1; 
                end
            else
                go=1;
            end
            
            if go==1
                %% Load relevant LFPs
                
                
                clear channel LFP
                load('ChannelsToAnalyse/Bulb_deep.mat')
                load(['LFPData/LFP',num2str(channel),'.mat'])
                tps=Range((LFP));
                vals=Data((LFP));
                LFPdowns=tsd(tps(1:Options.WVDownsample:end),vals(1:Options.WVDownsample:end));
                AllLFP.B=LFPdowns;
                
                if max(tps)/1e4>60
                    
                    %%Get local phase and amplitude with two methods
                    for struc=1:length(Structures)
                        clear Wavelet val ind LocalFreq LocalPhase AllPeaks tpstemp
                        % Wavelet method
                        [Wavelet.spec,Wavelet.freq,Wavelet.coi,Wavelet.OutParams]=cwt_SB_Mat2024(Data(AllLFP.(Structures{struc})),Options.Fs/Options.WVDownsample,'NumOctaves',Options.NumOctaves,...
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
                        plotscalogramfreq_SB(Wavelet.OutParams.FourierFactor,Wavelet.OutParams.sigmaT,Wavelet.spec,Wavelet.freq,Wavelet.OutParams.t,'true')
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
                end
                
            end
        end
    end
end