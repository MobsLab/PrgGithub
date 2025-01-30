function [M, M2, M3]=RespiGammaMarie(NameStructure,NameEpoch,ch)

%function [M, M2, M3]=RespiGammaMarie(NameStructure,NameEpoch)
    

%% init
if ~exist('NameStructure','var') 
    NameStructure='PFCx_deep';
end
if ~exist('NameEpoch','var')
    NameEpoch='SWSEpoch';
end
if ~exist('ch','var')
    ch=8;
end

load StateEpoch REMEpoch SWSEpoch MovEpoch NoiseEpoch GndNoiseEpoch
try load('SleepStagesPaCxDeep.mat','S12','S34','WakeEpoch');end
eval(['Epoch=',NameEpoch,'-NoiseEpoch;Epoch=Epoch-GndNoiseEpoch;'])


%% LFP / Respi
load LFPData RespiTSD

try 
    load(['ChannelsToAnalyse/',NameStructure]);
catch
    if strcmp(NameStructure,'Bulb_deep') 
        try load(['SpectrumDataL/','UniqueChannelBulb']); channel=channelToAnalyse;end
    end
end

if exist('channel','var') && ~isempty(channel)
    
    load(['LFPData/LFP',num2str(channel),'.mat'])
    disp(['load(''LFPData/LFP',num2str(channel),'.mat'')'])
    
    [zeroCrossTsd,AmplitudeRespi,zeroCross,zeroMeanValue]=FindZeroCross(RespiTSD,[0 7]);
    
    temp=Range(zeroCrossTsd);
    tdiff=diff(zeroCross);
    if mean(tdiff(1:2:end))<mean(tdiff(2:2:end))
        ParameterRespi=ts(temp(1:2:end));
    else
        ParameterRespi=ts(temp(2:2:end));
    end
    
    td=Range(Restrict(ParameterRespi,Epoch));
    AmpDiff=tsd(td(2:end),diff(td)/10);

    
    smallDiff1=thresholdIntervals(AmpDiff,(ch)*50,'Direction','Below');
    smallDiff2=thresholdIntervals(AmpDiff,(ch-1)*50,'Direction','Above');
    smallDiff=and(smallDiff1,smallDiff2);
    M=PlotRipRaw(RespiTSD,Range(Restrict(AmpDiff,smallDiff),'s'),1000);close
    
    
    Fil=   FilterLFP(LFP,[30 60],256);
    Pow=tsd(Range(Fil),abs(hilbert(Data(Fil))));
    M2=PlotRipRaw(Pow,Range(Restrict(AmpDiff,smallDiff),'s'),1000);close
    
    
    Fil=   FilterLFP(LFP,[60 90],256);
    Pow=tsd(Range(Fil),abs(hilbert(Data(Fil))));
    M3=PlotRipRaw(Pow,Range(Restrict(AmpDiff,smallDiff),'s'),1000);close
    
    %% display
    figure('Color',[1 1 1]),
    subplot(2,1,1), plot(M(:,1),M(:,2),'k','linewidth',3),
    hold on,plot(M2(:,1),rescale(M2(:,2),-0.005,0.015),'r','linewidth',2),
    title(['Respi [',num2str(floor(1E4./([ch,ch-1]*50))/10),']Hz trig Gammma'])
    ylabel('Low [30-60]Hz')
    subplot(2,1,2), plot(M(:,1),M(:,2),'k','linewidth',3),
    hold on, plot(M3(:,1),rescale(M3(:,2),-0.005,0.015),'b','linewidth',2)
    ylabel('High [60-90]Hz')
    xlabel('Time (s)')
    
else
    disp(['No LFP ',NameStructure])
    M=nan;M2=nan; M3=nan;
end


