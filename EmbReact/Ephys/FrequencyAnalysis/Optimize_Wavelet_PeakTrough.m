clear all

% Parameters to test for wavelets
ParamsToCheck.TimeBandWidth = [5,10,15,20,30,40,80,100];

% Parameters to test for peak trough
ParamsToCheck.StdLimsHigh = [0.5,0.4,0.3,0.2,0.15]; % Std for first round of peak detection
ParamsToCheck.StdLimsLow = [0.15,0.1,0.05,0.01]; % Std for second round of peak detection

% Parameters to keep : Options for WV and Options1 for Peak/Trough
Options.Fs = 1250; % sampling rate of LFP
Options.FilBand = [1 20]; % band to filter LFP
Options.NumOctaves = 6; % WV param, defiens min adn max frequency
Options.VoicesPerOctave = 48; % WV param defines sampling of frequency bands
Options.FreqLim = [1.5,15]; % After calculate WV is restricted to these bands to get peak
Options.WVDownsample = 10; % LFP is downsamples before calculation
Options1 = Options;
Options1.Fs = Options.Fs/Options.WVDownsample;
Options1.TimeLim=0.05; % in second, minimum distance between two minima or


ChannelTypes = {'Bulb','HPC_deep','HPC_sup'};
SessNames = {'SleepPreUMaze','UMazeCond'};


for ss=1:length(SessNames)
    Dir = PathForExperimentsEmbReact(SessNames{ss});
    for dd=1:length(Dir.path)
        if ismember(Dir.ExpeInfo{dd}{1}.nmouse,[507,508,509])
            for ddd=1:length(Dir.path{dd})
                cd(Dir.path{dd}{ddd})
                disp(Dir.path{dd}{ddd})
                if Dir.ExpeInfo{dd}{1}.nmouse==507
                    channel=0;save('ChannelsToAnalyse/dHPC_deep.mat','channel'); clear channel
                end
                
                % Load the channels to be used
                clear ch
                load('ChannelsToAnalyse/Bulb_deep.mat')
                ch.Bulb = channel;
                load('ChannelsToAnalyse/dHPC_deep.mat')
                ch.HPC_deep = channel;
                try
                    load('ChannelsToAnalyse/dHPC_rip.mat')
                    ch.HPC_sup = channel;
                catch
                    load('ChannelsToAnalyse/dHPC_sup.mat')
                    ch.HPC_sup = channel;
                end
                
                for chan=1:length(ChannelTypes)
                    
                    clear LocalFreq LocalPhase
                    %% Load LFP and downsample
                    load(['LFPData/LFP',num2str(ch.(ChannelTypes{chan})),'.mat'])
                    tps = Range((LFP));
                    vals = Data((LFP));
                    LFPdowns = tsd(tps(1:Options.WVDownsample:end),vals(1:Options.WVDownsample:end));
                    
                    FilLFP=FilterLFP(LFP,[1 15],1024);
                    tps = Range((FilLFP));
                    vals = Data((FilLFP));
                    LFPdownsFil = tsd(tps(1:Options.WVDownsample:end),vals(1:Options.WVDownsample:end));
                    datToGetPeakValues=Data(LFPdownsFil);
                    std1=nanstd(Data(LFPdownsFil));
                    
                    %% Peak and trough
                    clear AllPeaks
                    for par1 = 1:length(ParamsToCheck.StdLimsHigh)
                        for par2 = 1:length(ParamsToCheck.StdLimsLow)
                            % insert the parameters to test
                            Options1.std = [ParamsToCheck.StdLimsHigh(par1) ParamsToCheck.StdLimsLow(par2)];
                            
                            % run the function
                            AllPeaks = FindPeaksForFrequency(LFPdowns,Options1,0);
                            
                            % interpolate to creat continuous function
                            AllPeaks(:,3) = [0:pi:pi*(length(AllPeaks)-1)];
                            Y = interp1(AllPeaks(:,1),AllPeaks(:,3),Range(LFPdowns,'s'));
                            
                            % Set values between 0 and 2*pi depending on whetehr it
                            % starts with a peak or a trough
                            if AllPeaks(1,2)==1
                                LocalPhase.PT{par1,par2} = tsd(Range(LFPdowns),mod(Y,2*pi));
                            else
                                LocalPhase.PT{par1,par2} = tsd(Range(LFPdowns),mod(Y+pi,2*pi));
                            end
                            
                            % Frequency is times between two peaks
                            tpstemp = AllPeaks(2:2:end,1);
                            LocalFreq.PT{par1,par2} = tsd(tpstemp(1:end-1)*1e4,1./diff(AllPeaks(2:2:end,1)));
                            
                            phasedat=sin(mod(Data(LocalPhase.PT{par1,par2})-pi/2,2*pi)-pi);
                            tps=Range(LocalPhase.PT{par1,par2},'s');
                            val=interp1(AllPeaks(:,1),abs(datToGetPeakValues(ceil(AllPeaks(:,1)*125))),tps);
                            std2=nanstd(val(:).*phasedat(:));
                            PT_Reconstruction=val(:).*phasedat(:)*(std1/std2);
                            PT_Error.(ChannelTypes{chan})(par1,par2)=nansum((PT_Reconstruction-Data(LFPdownsFil)).^2)./nansum((Data(LFPdownsFil)).^2);
                        end
                    end
                    
                    %% Wavelet method
                    clear Wavelet
                    for par1 = 1:length(ParamsToCheck.TimeBandWidth)
                        % insert the parameters to test
                        Options.TimeBandWidth=ParamsToCheck.TimeBandWidth(par1);
                        
                        % run the function
                        [Wavelet.spec,Wavelet.freq,Wavelet.coi,Wavelet.OutParams]=cwt_SB(Data(LFPdowns),Options.Fs/Options.WVDownsample,'NumOctaves',Options.NumOctaves,'VoicesPerOctave',...
                            Options.VoicesPerOctave,'TimeBandwidth',Options.TimeBandWidth);
                        
                        % Restrict to freq in Options.FreqLim
                        Wavelet.spec=Wavelet.spec(find(Wavelet.freq<Options.FreqLim(2),1,'first'):find(Wavelet.freq>Options.FreqLim(1),1,'last'),:);
                        Wavelet.freq=Wavelet.freq(find(Wavelet.freq<Options.FreqLim(2),1,'first'):find(Wavelet.freq>Options.FreqLim(1),1,'last'));
                        
                        % Get instantaneous frequency defined as peak frequnency
                        [val,ind]=max(abs(Wavelet.spec));
                        LocalFreq.WV{par1}=tsd(Wavelet.OutParams.t*1e4,Wavelet.freq(ind));
                        idx=sub2ind(size(Wavelet.spec),ind,1:length(ind));
                        
                        % Get instantaneous phase
                        LocalPhase.WV{par1}=tsd(Wavelet.OutParams.t*1e4,angle(Wavelet.spec(idx))');
                        
                        % Error of signal reconstruction using instanenous phase and amp
                        phasedat=sin(mod(Data(LocalPhase.WV{par1})-pi/2,2*pi)-pi);
                        std2=nanstd(val(:).*phasedat(:));
                        WV_Reconstruction=val(:).*phasedat(:)*(std1/std2);
                        WV_Error.(ChannelTypes{chan})(par1)=nansum((WV_Reconstruction-Data(LFPdownsFil)).^2)./nansum((Data(LFPdownsFil)).^2);
                    end
                    
                    
                    %% Error between the two methods
                    for par1_PT = 1:length(ParamsToCheck.StdLimsHigh)
                        for par2_PT = 1:length(ParamsToCheck.StdLimsLow)
                            for par1_WV = 1:length(ParamsToCheck.TimeBandWidth)
                                WV=mod(Data(LocalPhase.WV{par1_WV})-pi/2,2*pi)-pi;
                                PT=mod(Data(LocalPhase.PT{par1_PT,par2_PT})-pi/2,2*pi)-pi;
                                tps=Range(LocalPhase.PT{par1_PT,par2_PT});
                                Err=sqrt(diff(unwrap(WV)-unwrap(PT)).^2)./(sqrt(diff(unwrap(WV)).^2)+sqrt(diff(unwrap(PT)).^2))/2;
                                Errtsd=tsd(tps(2:end),Err);
                                ErrorEpoch=thresholdIntervals(Errtsd,0.15);
                                ErrorEpoch=dropShortIntervals(ErrorEpoch,0.05*1e4);
                                WVvsPT_Error.(ChannelTypes{chan})(par1_PT,par2_PT,par1_WV)=nanmean(Err);
                                if not(isempty(Stop(ErrorEpoch)))
                                    WVvsPT_Error_Dur.(ChannelTypes{chan})(par1_PT,par2_PT,par1_WV)=sum(Stop(ErrorEpoch)-Start(ErrorEpoch))/1e4;
                                end
                            end
                        end
                    end
                end
                
                save('CalcPhaseParameterSearch.mat','WVvsPT_Error_Dur','WV_Error','PT_Error','WVvsPT_Error')
                clear WVvsPT_Error_Dur WV_Error PT_Error
            end
        end
    end
end


%% Look at results
ChannelTypes = {'Bulb','HPC_deep','HPC_sup'};
SessNames = {'SleepPreUMaze','UMazeCond'};
MiceList = [507,508,509];

for ss=1;%:length(SessNames)
    Dir = PathForExperimentsEmbReact(SessNames{ss});
    for dd=1:length(Dir.path)
        if ismember(Dir.ExpeInfo{dd}{1}.nmouse,MiceList)
            for ddd=1:length(Dir.path{dd})
                cd(Dir.path{dd}{ddd})
                disp(Dir.path{dd}{ddd})
                load('CalcPhaseParameterSearch.mat')
                for chan=1:length(ChannelTypes)
                    
                    AllWV_Error.(ChannelTypes{chan})(find(MiceList==Dir.ExpeInfo{dd}{1}.nmouse),:) = WV_Error.(ChannelTypes{chan});
                    AllPT_Error.(ChannelTypes{chan})(find(MiceList==Dir.ExpeInfo{dd}{1}.nmouse),:,:) = PT_Error.(ChannelTypes{chan});
                    AllPTvsWV_Error_TB.(ChannelTypes{chan})(find(MiceList==Dir.ExpeInfo{dd}{1}.nmouse),:) = squeeze(WVvsPT_Error.(ChannelTypes{chan})(3,3,:));
                    AllPTvsWV_ErrorBis_Hi.(ChannelTypes{chan})(find(MiceList==Dir.ExpeInfo{dd}{1}.nmouse),:) = squeeze(WVvsPT_Error.(ChannelTypes{chan})(:,3,2));
                    AllPTvsWV_ErrorBis_Lo.(ChannelTypes{chan})(find(MiceList==Dir.ExpeInfo{dd}{1}.nmouse),:) = squeeze(WVvsPT_Error.(ChannelTypes{chan})(3,:,2));

                end
            end
        end
    end
end

figure
Chan_Cols={'b','r','m'};
for chan=1:length(ChannelTypes)
    errorbar(ParamsToCheck.TimeBandWidth,mean(AllWV_Error.(ChannelTypes{chan})),stdError(AllWV_Error.(ChannelTypes{chan})),'color',Chan_Cols{chan},'linewidth',2), hold on
end
xlabel('TimeBandWidth')
ylabel('Sqred errror')

figure
subplot(121)
for chan=1:length(ChannelTypes)
    PT_averaged_High=zscore(squeeze([mean(AllPT_Error.(ChannelTypes{chan}),3)])')';
    errorbar(ParamsToCheck.StdLimsHigh,mean(PT_averaged_High),stdError(PT_averaged_High),'color',Chan_Cols{chan},'linewidth',2), hold on
end
xlabel('High Lim')
ylabel('Sqred errror')

subplot(122)
for chan=1:length(ChannelTypes)
    PT_averaged_Low=zscore(squeeze([mean(AllPT_Error.(ChannelTypes{chan}),2)])')';
    errorbar(ParamsToCheck.StdLimsLow,mean(PT_averaged_Low),stdError(PT_averaged_Low),'color',Chan_Cols{chan},'linewidth',2), hold on
end
xlabel('Low Lim')

figure
subplot(121)
for chan=1:length(ChannelTypes)
    PT_averaged_High=(squeeze([mean(AllPT_Error.(ChannelTypes{chan}),3)])')';
    errorbar(ParamsToCheck.StdLimsHigh,mean(PT_averaged_High),stdError(PT_averaged_High),'color',Chan_Cols{chan},'linewidth',2), hold on
end
xlabel('High Lim')
ylabel('Sqred errror')

subplot(122)
for chan=1:length(ChannelTypes)
    PT_averaged_Low=(squeeze([mean(AllPT_Error.(ChannelTypes{chan}),2)])')';
    errorbar(ParamsToCheck.StdLimsLow,mean(PT_averaged_Low),stdError(PT_averaged_Low),'color',Chan_Cols{chan},'linewidth',2), hold on
end
xlabel('Low Lim')




figure
subplot(121)
for chan=1:length(ChannelTypes)
    errorbar(ParamsToCheck.TimeBandWidth,mean(AllPTvsWV_Error_TB.(ChannelTypes{chan})),stdError(AllPTvsWV_Error_TB.(ChannelTypes{chan})),'color',Chan_Cols{chan},'linewidth',2), hold on
end
subplot(222)
for chan=1:length(ChannelTypes)
    errorbar(ParamsToCheck.StdLimsHigh,mean(zscore(AllPTvsWV_ErrorBis_Hi.(ChannelTypes{chan})')'),stdError(zscore(AllPTvsWV_ErrorBis_Hi.(ChannelTypes{chan})')'),'color',Chan_Cols{chan},'linewidth',2), hold on
end
subplot(224)
for chan=1:length(ChannelTypes)
    errorbar(ParamsToCheck.StdLimsLow,mean(zscore(AllPTvsWV_ErrorBis_Lo.(ChannelTypes{chan})')'),stdError(zscore(AllPTvsWV_ErrorBis_Lo.(ChannelTypes{chan})')'),'color',Chan_Cols{chan},'linewidth',2), hold on
end

figure
for chan=1:length(ChannelTypes)
    errorbar(ParamsToCheck.StdLimsHigh,mean((AllPTvsWV_ErrorBis_Hi.(ChannelTypes{chan})')'),stdError((AllPTvsWV_ErrorBis_Hi.(ChannelTypes{chan})')'),'color',Chan_Cols{chan},'linewidth',2), hold on
end

