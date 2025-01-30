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

% Structures={'H','B','PFCx'};
Structures={'H'};
AllCombi=combnk(1:3,2);
for ss=1:length(SessNames)%:-1:1
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            try
                if not(Dir.ExpeInfo{d}{dd}.nmouse==117)
                    cd(Dir.path{d}{dd})
                    if (Dir.ExpeInfo{d}{dd}.nmouse==MouseToDo) %& exist(['InstFreqAndPhase_',Structures{1},'.mat'])==0
                        
                        if (exist('InstFreqAndPhase.mat'))>0
                            movefile('InstFreqAndPhase.mat','InstFreqAndPhase_B.mat')
                            movefile('InstantaneousFrequencyEstimate.png','InstantaneousFrequencyEstimate_B.png')
                        end
                        Docalc=1;
                        clear Options
%                         if exist('InstFreqAndPhase_B.mat')>0
%                             load('InstFreqAndPhase_B.mat','Options')
%                             if not(isfield(Options,'TimeBandWidth'))
%                                 Docalc=1;
%                             end
%                         else
%                             Docalc=1;
%                         end
                        
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
                            
                            
                            disp((Dir.path{d}{dd}))
                            
                            %% Load relevant LFPs
                            clear channel LFP LFPdowns
                            try,load('ChannelsToAnalyse/dHPC_rip.mat'), catch,
                                try,
                                    load('ChannelsToAnalyse/dHPC_deep.mat'),
                                catch
                                    load('ChannelsToAnalyse/dHPC_sup.mat'),
                                end
                            end
                            load(['LFPData/LFP',num2str(channel),'.mat'])
                            tps=Range((LFP));
                            vals=Data((LFP));
                            LFPdowns=tsd(tps(1:Options.WVDownsample:end),vals(1:Options.WVDownsample:end));
                            AllLFP.H=LFPdowns;
                            
                            clear channel LFP LFPdowns
                            load('ChannelsToAnalyse/Bulb_deep.mat')
                            load(['LFPData/LFP',num2str(channel),'.mat'])
                            tps=Range((LFP));
                            vals=Data((LFP));
                            LFPdowns=tsd(tps(1:Options.WVDownsample:end),vals(1:Options.WVDownsample:end));
                            AllLFP.B=LFPdowns;
                            
                            clear channel LFP LFPdowns
                            load('ChannelsToAnalyse/PFCx_deep.mat')
                            load(['LFPData/LFP',num2str(channel),'.mat'])
                            tps=Range((LFP));
                            vals=Data((LFP));
                            LFPdowns=tsd(tps(1:Options.WVDownsample:end),vals(1:Options.WVDownsample:end));
                            AllLFP.PFCx=LFPdowns;
                            clear channel LFP LFPdowns
                            
                            rmpath([dropbox '/Kteam/PrgMatlab/chronux2/spectral_analysis/continuous/'])
                            
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
                            
                            
%                             %% Calculate all coherence pairs
%                             for comb=1:length(AllCombi)
%                                 [Wavelet.Coherence,Wavelet.CrossSpec,Wavelet.freq,~] = wcoherence_SB(Data(AllLFP.(Structures{AllCombi(comb,1)})),Data(AllLFP.(Structures{AllCombi(comb,2)})),Options.Fs/Options.WVDownsample,'NumOctaves',Options.NumOctaves,'VoicesPerOctave',Options.VoicesPerOctaveCoherence);
%                                 Wavelet.OutParams=RemParams;
%                                 figure,plotscalogramfreq_SB(Wavelet.OutParams.FourierFactor,Wavelet.OutParams.sigmaT,Wavelet.Coherence,Wavelet.freq,Wavelet.OutParams.t,Wavelet.OutParams.normalizedfreq)
%                                 save(['WaveletCoherence',Structures{AllCombi(comb,1)},'_',Structures{AllCombi(comb,2)},'.mat'],'LocalFreq','Options','Wavelet','-v7.3')
%                                 clear Wavelet
%                             end
%                             
                            clear AllLFP RemParams
                        end
                    end
                end
                addpath([dropbox '/Kteam/PrgMatlab/chronux2/spectral_analysis/continuous/'])
                
            catch
                disp('problem')
                keyboard
            end
        end
    end
end