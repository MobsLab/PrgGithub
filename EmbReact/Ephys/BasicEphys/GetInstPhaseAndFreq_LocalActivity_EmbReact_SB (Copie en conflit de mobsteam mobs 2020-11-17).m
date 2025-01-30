clear Options Options1
Options.Fs=1250; % sampling rate of LFP
Options.FilBand=[1 15]; % band limits
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


AllCombi=combnk(1:3,2);
for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            %             try
            if not(Dir.ExpeInfo{d}{dd}.nmouse==117)
                clear AllLFP
                cd(Dir.path{d}{dd})
                load('ExpeInfo.mat')
                
                disp((Dir.path{d}{dd}))
                AllLFP=struct;
                if not(isfield(ExpeInfo,'IsBilateral'))
                    ExpeInfo.IsBilateral=0;
                end
                if ExpeInfo.IsBilateral==0
                    %% Load relevant LFPs
                    clear channel LFP LFPdowns
                    if exist('LFPData/LocalHPCActivity.mat')>0
                        load('LFPData/LocalHPCActivity.mat')
                        tps=Range((LFP));
                        vals=Data((LFP));
                        LFPdowns=tsd(tps(1:Options.WVDownsample:end),vals(1:Options.WVDownsample:end));
                        AllLFP.H_Loc=LFPdowns;
                    end
                    
                    clear channel LFP LFPdowns
                    if exist('LFPData/LocalOBActivity.mat')>0
                        load('LFPData/LocalOBActivity.mat')
                        tps=Range((LFP));
                        vals=Data((LFP));
                        LFPdowns=tsd(tps(1:Options.WVDownsample:end),vals(1:Options.WVDownsample:end));
                        AllLFP.B_Loc=LFPdowns;
                    end
                else
                    if exist('ChannelsToAnalyse/dHPC_local_left.mat')>0
                        load('ChannelsToAnalyse/dHPC_local_left.mat')
                        if not(isempty(channel))
                            load(['LFPData/LFP',num2str(channel(1)),'.mat']); LFP1=LFP;
                            load(['LFPData/LFP',num2str(channel(2)),'.mat']); LFP2=LFP;
                            LFP=tsd(Range(LFP),Data(LFP1)-Data(LFP2));
                            save('LFPData/LocalHPC_left_Activity.mat','LFP','channel')
                            tps=Range((LFP));
                            vals=Data((LFP));
                            LFPdowns=tsd(tps(1:Options.WVDownsample:end),vals(1:Options.WVDownsample:end));
                            AllLFP.H_Loc_left=LFPdowns;
                            clear LFP LFP1 LFP2 channel
                        end
                    end
                    
                    if exist('ChannelsToAnalyse/dHPC_local_right.mat')>0
                        load('ChannelsToAnalyse/dHPC_local_right.mat')
                        if not(isempty(channel))
                            load(['LFPData/LFP',num2str(channel(1)),'.mat']); LFP1=LFP;
                            load(['LFPData/LFP',num2str(channel(2)),'.mat']); LFP2=LFP;
                            LFP=tsd(Range(LFP),Data(LFP1)-Data(LFP2));
                            save('LFPData/LocalHPC_right_Activity.mat','LFP','channel')
                            tps=Range((LFP));
                            vals=Data((LFP));
                            LFPdowns=tsd(tps(1:Options.WVDownsample:end),vals(1:Options.WVDownsample:end));
                            AllLFP.H_Loc_right=LFPdowns;
                            clear LFP LFP1 LFP2 channel
                        end
                    end
                    
                    if exist('ChannelsToAnalyse/Bulb_loc_left.mat')>0
                        load('ChannelsToAnalyse/Bulb_loc_left.mat')
                        if not(isempty(channel))
                            load(['LFPData/LFP',num2str(channel(1)),'.mat']); LFP1=LFP;
                            load(['LFPData/LFP',num2str(channel(2)),'.mat']); LFP2=LFP;
                            LFP=tsd(Range(LFP),Data(LFP1)-Data(LFP2));
                            save('LFPData/LocalBulb_left_Activity.mat','LFP','channel')
                            tps=Range((LFP));
                            vals=Data((LFP));
                            LFPdowns=tsd(tps(1:Options.WVDownsample:end),vals(1:Options.WVDownsample:end));
                            AllLFP.B_Loc_left=LFPdowns;
                            clear LFP LFP1 LFP2 channel
                        end
                    end
                    
                    if exist('ChannelsToAnalyse/Bulb_loc_right.mat')>0
                        load('ChannelsToAnalyse/Bulb_loc_right.mat')
                        if not(isempty(channel))
                            load(['LFPData/LFP',num2str(channel(1)),'.mat']); LFP1=LFP;
                            load(['LFPData/LFP',num2str(channel(2)),'.mat']); LFP2=LFP;
                            LFP=tsd(Range(LFP),Data(LFP1)-Data(LFP2));
                            save('LFPData/LocalBulb_right_Activity.mat','LFP','channel')
                            tps=Range((LFP));
                            vals=Data((LFP));
                            LFPdowns=tsd(tps(1:Options.WVDownsample:end),vals(1:Options.WVDownsample:end));
                            AllLFP.B_Loc_right=LFPdowns;
                            clear LFP LFP1 LFP2 channel
                        end
                    end
                    
                end
                
                Structures=fieldnames(AllLFP);
                
                %%Get local phase and amplitude with two methods
                for struc=1:length(Structures)
                    %                     if exist(['InstFreqAndPhase_',Structures{struc},'.mat'])>0
                    %                         LoadedOption=load(['InstFreqAndPhase_',Structures{struc},'.mat'],'Options');
                    %                         if not(isfield(LoadedOption.Options,'TimeBandWidth'))
                    disp('Doing calcultion')
                    
                    clear Wavelet val ind LocalFreq LocalPhase AllPeaks tpstemp
                    % Wavelet method
                    [Wavelet.spec,Wavelet.freq,Wavelet.coi,Wavelet.OutParams]=cwt_SB(Data(AllLFP.(Structures{struc})),Options.Fs/Options.WVDownsample,...
                        'NumOctaves',Options.NumOctaves,'VoicesPerOctave',Options.VoicesPerOctave,'TimeBandwidth',Options.TimeBandWidth);
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
                    %                         end
                    %                     end
                end
                
                clear AllLFP RemParams
            end
            
            %             catch
            %                 disp('problem')
            %             end
        end
    end
end