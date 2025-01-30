clear all,% close all
%% PARAMETERS
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
Structures={'H','B','PFCx'};

%% DATA LOCALISATION
[Dir,KeepFirstSessionOnly]=GetRightSessionsFor4HzPaper('CtrlRipplesOnly_BothExt');
SaveFolder='/media/DataMOBsRAIDN/SophieFigures/2TypesFreezing_DifferentTasks/';
% 
% for mm = 1: length(Dir.name)
%     
%     
%     %% Go to file location
%     disp(Dir.path{mm})
%     cd(Dir.path{mm})
%     clear Spec_H Spec_B FreqBand NewMat TotalNoiseEpoch NoFreezeEpoch FreezeEpoch FreezeAccEpoch FreqBand
%     clear Movtsd MovAcctsd
%     
%     
%     %% Calculate instantaneous frequency
%     % HPC
%     try
%         clear channel LFP LFPdowns
%         try,load('ChannelsToAnalyse/dHPC_rip.mat'), catch,
%             try,
%                 load('ChannelsToAnalyse/dHPC_deep.mat'),
%             catch
%                 load('ChannelsToAnalyse/dHPC_sup.mat'),
%             end
%         end
%         load(['LFPData/LFP',num2str(channel),'.mat'])
%         tps=Range((LFP));
%         vals=Data((LFP));
%         LFPdowns=tsd(tps(1:Options.WVDownsample:end),vals(1:Options.WVDownsample:end));
%         AllLFP.H=LFPdowns;
%     end
%     
%     % Olfactory bulb
%     clear channel LFP LFPdowns
%     load('ChannelsToAnalyse/Bulb_deep.mat')
%     load(['LFPData/LFP',num2str(channel),'.mat'])
%     tps=Range((LFP));
%     vals=Data((LFP));
%     LFPdowns=tsd(tps(1:Options.WVDownsample:end),vals(1:Options.WVDownsample:end));
%     AllLFP.B=LFPdowns;
%     
%     
%     % Prefrontal cortex
%     try
%         clear channel LFP LFPdowns
%         load('ChannelsToAnalyse/PFCx_deep.mat')
%         load(['LFPData/LFP',num2str(channel),'.mat'])
%         tps=Range((LFP));
%         vals=Data((LFP));
%         LFPdowns=tsd(tps(1:Options.WVDownsample:end),vals(1:Options.WVDownsample:end));
%         AllLFP.PFCx=LFPdowns;
%         clear channel LFP LFPdowns
%     end
%     
%     rmpath([dropbox '/Kteam/PrgMatlab/chronux2/spectral_analysis/continuous/'])
%     
%     % Get local phase and amplitude with two methods
%     for struc = 1:length(Structures)
%         clear Wavelet val ind LocalFreq LocalPhase AllPeaks tpstemp
%         % Wavelet method
%         [Wavelet.spec,Wavelet.freq,Wavelet.coi,Wavelet.OutParams]=cwt_SB(Data(AllLFP.(Structures{struc})),Options.Fs/Options.WVDownsample,'NumOctaves',Options.NumOctaves,...
%             'VoicesPerOctave',Options.VoicesPerOctave,'TimeBandwidth',Options.TimeBandWidth);
%         Wavelet.spec=Wavelet.spec(find(Wavelet.freq<Options.FreqLim(2),1,'first'):find(Wavelet.freq>Options.FreqLim(1),1,'last'),:);
%         Wavelet.freq=Wavelet.freq(find(Wavelet.freq<Options.FreqLim(2),1,'first'):find(Wavelet.freq>Options.FreqLim(1),1,'last'));
%         [val,ind]=max(abs(Wavelet.spec));
%         LocalFreq.WV=tsd(Wavelet.OutParams.t*1e4,Wavelet.freq(ind));
%         idx=sub2ind(size(Wavelet.spec),ind,1:length(ind));
%         LocalPhase.WV=tsd(Wavelet.OutParams.t*1e4,angle(Wavelet.spec(idx))');
%         % Peak-Trough method
%         AllPeaks=FindPeaksForFrequency(AllLFP.(Structures{struc}),Options1,0);
%         AllPeaks(:,3)=[0:pi:pi*(length(AllPeaks)-1)];
%         Y=interp1(AllPeaks(:,1),AllPeaks(:,3),Range(AllLFP.(Structures{struc}),'s'));
%         if AllPeaks(1,2)==1
%             LocalPhase.PT=tsd(Range(AllLFP.(Structures{struc})),mod(Y,2*pi));
%         else
%             LocalPhase.PT=tsd(Range(AllLFP.(Structures{struc})),mod(Y+pi,2*pi));
%         end
%         tpstemp=AllPeaks(2:2:end,1);
%         LocalFreq.PT=tsd(tpstemp(1:end-1)*1e4,1./diff(AllPeaks(2:2:end,1)));
%         save(['InstFreqAndPhase_',Structures{struc},'.mat'],'LocalFreq','LocalPhase','AllPeaks','Options','Wavelet','-v7.3')
%         
%         % Figure
%         fig=figure;fig.Position=[1 1 800 500];
%         subplot(211)
%         plotscalogramfreq_SB(Wavelet.OutParams.FourierFactor,Wavelet.OutParams.sigmaT,Wavelet.spec,Wavelet.freq,Wavelet.OutParams.t,Wavelet.OutParams.normalizedfreq)
%         caxis([0 1000])
%         colorbar off
%         subplot(212)
%         plot(Range(LocalFreq.WV,'s')/60,(Data(LocalFreq.WV)),'k'),hold on
%         plot(Range(LocalFreq.PT,'s')/60,(Data(LocalFreq.PT)),'r')
%         ylim([0 16]),xlim([0 max(Range(LocalFreq.PT,'s')/60)])
%         legend('WV','PT')
%         RemParams=Wavelet.OutParams;
%         saveas(fig.Number,['InstantaneousFrequencyEstimate_',Structures{struc},'.png'])
%         close all
%     end
%     
%     
% end


%% Look at the freezing parameters
close all
for mm = 1: length(Dir.name)
    
    
    %% Go to file location
    disp(Dir.path{mm})
    cd(Dir.path{mm})
    clear Spec_H Spec_B FreqBand NewMat TotalNoiseEpoch NoFreezeEpoch FreezeEpoch FreezeAccEpoch FreqBand
    clear Movtsd MovAcctsd
    
    % Epochs
    load('behavResources.mat')
    if exist('FreezeAccEpoch')
        FreezeEpoch=FreezeAccEpoch;
    end
    
    
    load('InstFreqAndPhase_B.mat')
    OBFreq = LocalFreq;
    
    load('InstFreqAndPhase_H.mat')
    HPCFreq = LocalFreq;
    
    try
        load('Ripples.mat')
        [Y,X] = hist(Start(RipplesEpochR,'s'),Range(OBFreq.PT,'s'));
        Riptsd = tsd(Range(OBFreq.PT),Y');
    catch
        Riptsd = tsd(0,0);
        
    end
    
    figure
    subplot(411)
    plot(movmedian(Data((OBFreq.PT)),10))
    yyaxis right
    bar(movmean(Data(Riptsd),10))
    ylim([0 0.5])
    
    subplot(412)
    load('B_Low_Spectrum.mat')
    OB_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
    imagesc(Range((OB_Sptsd),'s'),Spectro{3},log(Data((OB_Sptsd))')), axis xy
    grid minor
    subplot(413)
    try
        load('H_Low_Spectrum.mat')
    catch
        load('ChannelsToAnalyse/dHPC_rip.mat')
        LowSpectrumSB([cd filesep],channel,'H')
        load('H_Low_Spectrum.mat')
        
    end
    
    HPC_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
    imagesc(Range((HPC_Sptsd),'s'),Spectro{3},log(Data((HPC_Sptsd))')), axis xy
    grid minor
    SpLow = Spectro{3};
    subplot(414)
    plot(Data((MovAccSmotsd)))
    
    
    try
        load('H_VHigh_Spectrum.mat')
    catch
        load('ChannelsToAnalyse/dHPC_rip.mat')
        VeryHighSpectrum([cd filesep],channel,'H')
        load('H_VHigh_Spectrum.mat')
        
    end
    HPC_Hi_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
    HPC_Hi_Sptsd = Restrict(HPC_Hi_Sptsd,Range(OB_Sptsd));
    OB_Sptsd = Restrict(OB_Sptsd,Range(HPC_Hi_Sptsd));
    OB_Sptsd = tsd(Range(HPC_Hi_Sptsd),Data(OB_Sptsd)),
    HPC_Sptsd = Restrict(HPC_Sptsd,Range(HPC_Hi_Sptsd));
    HPC_Sptsd = tsd(Range(HPC_Hi_Sptsd),Data(HPC_Sptsd)),
    
    SpHigh = Spectro{3};
    
    figure
    subplot(2,2,1)
    imagesc(SpLow,SpLow,corr(log(Data(Restrict(OB_Sptsd,FreezeEpoch))),log(Data(Restrict(OB_Sptsd,FreezeEpoch)))))
    axis square
    axis xy
    xlim([0 15]),ylim([0 15])
    subplot(2,2,2)
    imagesc(SpLow,SpLow,corr(log(Data(Restrict(HPC_Sptsd,FreezeEpoch))),log(Data(Restrict(HPC_Sptsd,FreezeEpoch)))))
    axis square
    axis xy
    xlim([0 15]),ylim([0 15])
    subplot(2,2,3)
    imagesc(SpLow,SpLow,corr(log(Data(Restrict(OB_Sptsd,FreezeEpoch))),log(Data(Restrict(HPC_Sptsd,FreezeEpoch)))))
    axis square
    axis xy
    xlim([0 15]),ylim([0 15])
    subplot(2,2,4)
    imagesc(SpLow,SpHigh,corr(log(Data(Restrict(OB_Sptsd,FreezeEpoch))),log(Data(Restrict(HPC_Hi_Sptsd,FreezeEpoch)))))
    axis square
    axis xy
    xlim([0 15])
    
    
    
    
end


[Dir,KeepFirstSessionOnly]=GetRightSessionsFor4HzPaper('CtrlAllData_BothExt');
for mm = 1: length(Dir.name)
    
    
    %% Go to file location
    disp(Dir.path{mm})
    cd(Dir.path{mm})
    clear Spec_H Spec_B FreqBand NewMat TotalNoiseEpoch NoFreezeEpoch FreezeEpoch FreezeAccEpoch FreqBand
    clear Movtsd MovAcctsd
    
    % Epochs
    load('behavResources.mat')
    if exist('FreezeAccEpoch')
        FreezeEpoch=FreezeAccEpoch;
    end
 
   
    figure
    subplot(211)
    load('B_Low_Spectrum.mat')
    OB_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
    imagesc(Range((OB_Sptsd),'s'),Spectro{3},log(Data((OB_Sptsd))')), axis xy
    grid minor
    subplot(212)
    plot(Data((MovAccSmotsd)))
    
    
  
    
    
    
    
end
