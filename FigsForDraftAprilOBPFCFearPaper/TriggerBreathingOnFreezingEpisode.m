clear all,% close all
%% INITIATION
FreqRange=[3,6];
[params,movingwin,suffix]=SpectrumParametersML('low');
tps=[0.05:0.05:1];
timeatTransition=5;
timebefprop=0.3;
timebefxpos=timebefprop./(1+timebefprop*2);
Convto1ML=277139.48707754;

%% DATA LOCALISATION
Dir=PathForExperimentFEAR('Fear-electrophy-plethysmo');
for m=1:6
    cd(Dir.path{m})
    load('BreathingInfo.mat')
    load('behavResources.mat')
    
    %% Go to file location
    clear Spec_H Spec_B FreqBand NewMat TotalNoiseEpoch NoFreezeEpoch FreezeEpoch FreezeAccEpoch FreqBand
    clear Movtsd MovAcctsd
    
    %% load data
    % Epochs
    load('behavResources.mat')
    load('StateEpochSB.mat')
    if exist('FreezeAccEpoch')
        FreezeEpoch=FreezeAccEpoch;
    end
    TotEpoch=intervalSet(0,max(Range(Movtsd)));
    FreezeEpoch=and(FreezeEpoch,TotEpoch);
    FreezeEpoch=dropShortIntervals(FreezeEpoch,timeatTransition*1e4);
    FreezeEpochBis=FreezeEpoch;
    for fr_ep=1:length(Start(FreezeEpoch))
        LitEp=subset(FreezeEpoch,fr_ep);
        NotLitEp=FreezeEpoch-LitEp;
        StopEp=intervalSet(Stop(LitEp)-timeatTransition*1e4,Stop(LitEp)+timeatTransition*1e4);
        if not(isempty(Data(Restrict(Movtsd,and(NotLitEp,StopEp)))))
            FreezeEpochBis=FreezeEpochBis-LitEp;
        end
    end
    FreezeEpoch=CleanUpEpoch(FreezeEpochBis);
    
    % OB and HPC Spectra
    load('B_Low_Spectrum.mat')
    Sptsd_B=tsd(Spectro{2}*1e4,Spectro{1});
    load('Respi_Low_Spectrum.mat')
    Sptsd_R=tsd(Spectro{2}*1e4,Spectro{1});
    
    load('BreathingInfo.mat')
    
    Top95=prctile(Data(TidalVolumtsd),95);
    TidalNoise=thresholdIntervals(TidalVolumtsd,Top95);
    TidalVolumtsd=tsd(Range(TidalVolumtsd),Data(TidalVolumtsd)/Convto1ML);
    NoisyTimes = Range(Restrict(TidalVolumtsd,TidalNoise));
    NoisyInd = ismember(Range(TidalVolumtsd),NoisyTimes);
    dat = Data(TidalVolumtsd); dat(NoisyInd) = NaN;
    TidalVolumtsd = tsd(Range(TidalVolumtsd),dat);
    Pressuretsd = tsd(Range(TidalVolumtsd),(Data(TidalVolumtsd).*Data(Frequecytsd)));
    
    % Spikes
    clear S ProjFR SumFR VectFr
    load('SpikeData.mat')
    if not(sum(size(S))) ==0
        Q = MakeQfromS(S,0.5e4);
        SumFR = tsd(Range(Q),full(sum(Data(Q)')'));
        VectFr = nanmean(Data(Restrict(Q,FreezeEpoch))) - nanmean(Data(Restrict(Q,TotEpoch-FreezeEpoch)));
        ProjFR = tsd(Range(Q),full((Data(Q)*VectFr')));
        %% get the bias and the error rate
    end
    
    for ep=1:length(Start(FreezeEpoch))-1
        ActualEpoch=subset(FreezeEpoch,ep);
        Dur{m}(ep)=Stop(ActualEpoch,'s')-Start(ActualEpoch,'s');
        
        %% Look at Normalized periods
        % define epoch
        timebef=Dur{m}(ep)*timebefprop; % period before and after is 30% acutal period
        LittleEpoch=intervalSet(Start(ActualEpoch)-timebef*1e4,Stop(ActualEpoch)+timebef*1e4);
        
        % spectra + power
        % OB
        Spec_B=Data(Restrict(Sptsd_B,(LittleEpoch)));
        FreqBand=nanmean(Spec_B(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))');
        % interpolate
        FreqBandPower_AllMice_normPer_B{m}(ep,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],FreqBand,tps); hold on
        for sp=1:length(Spectro{3})
            Spectro_AllMice_normPer_B{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec_B(:,sp),tps); hold on
        end
        Spec_R=Data(Restrict(Sptsd_R,(LittleEpoch)));
        for sp=1:length(Spectro{3})
            Spectro_AllMice_normPer_R{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec_R(:,sp),tps); hold on
        end
        
        
        %% PFC --> Add
        %% HPC --> Add
        %% classify neurons
        
        % RespiFreq
        Mov=Data(Restrict(Frequecytsd,LittleEpoch));
        InstRespiFreq_AllMice_normPer{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
        
        % TidVolume
        Mov=Data(Restrict(TidalVolumtsd,LittleEpoch));
        InstTidVolume_AllMice_normPer{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
        
        % Pressure
        Mov=Data(Restrict(Pressuretsd,LittleEpoch));
        InstPressure_AllMice_normPer{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
                
        % Movement
        Mov=Data(Restrict(Movtsd,LittleEpoch));
        InstSpeed_AllMice_normPer{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
        
        if exist('MovAcctsd')
            % acceleration
            Mov=Data(Restrict(MovAcctsd,LittleEpoch));
            InstAcc_AllMice_normPer{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
        end
        
        if exist('ProjFR')
            % spikes - overall FR
            Spk = Data(Restrict(SumFR,LittleEpoch));
            InstSpiking_AllMice_normPer{m}(ep,:)=interp1([1/length(Spk):1/length(Spk):1],Spk,tps); hold on
            
            % spikes - projected onto freezing axis
            Spk = Data(Restrict(ProjFR,LittleEpoch));
            InstProjSpiking_AllMice_normPer{m}(ep,:)=interp1([1/length(Spk):1/length(Spk):1],Spk,tps); hold on
        end
        
        %% Look at onset periods
        % define epoch
        LittleEpoch=intervalSet(Start(ActualEpoch)-(timeatTransition-1)*1e4,Start(ActualEpoch)+timeatTransition*1e4);
        
        % spectra + power - OB
        Spec_B=Data(Restrict(Sptsd_B,LittleEpoch));
        FreqBand=nanmean(Spec_B(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))');
        % interpolate
        FreqBandPower_AllMice_Onset_B{m}(ep,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],FreqBand,tps); hold on
        for sp=1:length(Spectro{3})
            Spectro_AllMice_Onset_B{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec_B(:,sp),tps); hold on
        end
        Spec_R=Data(Restrict(Sptsd_R,(LittleEpoch)));
        for sp=1:length(Spectro{3})
            Spectro_AllMice_Onset_R{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec_R(:,sp),tps); hold on
        end
        
        % RespiFreq
        Mov=Data(Restrict(Frequecytsd,LittleEpoch));
        InstRespiFreq_AllMice_Onset{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
        
        % TidVolume
        Mov=Data(Restrict(TidalVolumtsd,LittleEpoch));
        InstTidVolume_AllMice_Onset{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
        
        % Pressure
        Mov=Data(Restrict(Pressuretsd,LittleEpoch));
        InstPressure_AllMice_Onset{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
                
        % Movement
        Mov=Data(Restrict(Movtsd,(LittleEpoch)));
        InstSpeed_AllMice_Onset{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
        
        if exist('MovAcctsd')
            % acceleration
            Mov=Data(Restrict(MovAcctsd,LittleEpoch));
            InstAcc_AllMice_Onset{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
        end
        
        if exist('ProjFR')
            % spikes - overall FR
            Spk = Data(Restrict(SumFR,LittleEpoch));
            InstSpiking_AllMice_Onset{m}(ep,:)=interp1([1/length(Spk):1/length(Spk):1],Spk,tps); hold on
            
            % spikes - projected onto freezing axis
            Spk = Data(Restrict(ProjFR,LittleEpoch));
            InstProjSpiking_AllMice_Onset{m}(ep,:)=interp1([1/length(Spk):1/length(Spk):1],Spk,tps); hold on
        end
        
        
        %% Look at offset periods
        % define epoch
        LittleEpoch=intervalSet(Stop(ActualEpoch)-timeatTransition*1e4,Stop(ActualEpoch)+(timeatTransition-1)*1e4);
        
        % spectra + power - OB
        Spec_B=Data(Restrict(Sptsd_B,(LittleEpoch)));
        FreqBand=nanmean(Spec_B(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))');
        % interpolate
        FreqBandPower_AllMice_Offset_B{m}(ep,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],FreqBand,tps); hold on
        for sp=1:length(Spectro{3})
            Spectro_AllMice_Offset_B{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec_B(:,sp),tps); hold on
        end
        Spec_R=Data(Restrict(Sptsd_R,(LittleEpoch)));
        for sp=1:length(Spectro{3})
            Spectro_AllMice_Offset_R{m}(ep,sp,:)=interp1([1/length(FreqBand):1/length(FreqBand):1],Spec_R(:,sp),tps); hold on
        end
        
        % RespiFreq
        Mov=Data(Restrict(Frequecytsd,LittleEpoch));
        InstRespiFreq_AllMice_Offset{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
        
        % TidVolume
        Mov=runmean(Data(Restrict(TidalVolumtsd,LittleEpoch)),3);
        InstTidVolume_AllMice_Offset{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
        
        % Pressure
        Mov=Data(Restrict(Pressuretsd,LittleEpoch));
        InstPressure_AllMice_Offset{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
        
        
        % Movement
        Mov=Data(Restrict(Movtsd,(LittleEpoch)));
        InstSpeed_AllMice_Offset{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
        
        if exist('MovAcctsd')
            % acceleration
            Mov=Data(Restrict(MovAcctsd,LittleEpoch));
            InstAcc_AllMice_Offset{m}(ep,:)=interp1([1/length(Mov):1/length(Mov):1],Mov,tps); hold on
        end
        
        if exist('ProjFR')
            % spikes - overall FR
            Spk = Data(Restrict(SumFR,LittleEpoch));
            InstSpiking_AllMice_Offset{m}(ep,:)=interp1([1/length(Spk):1/length(Spk):1],Spk,tps); hold on
            
            % spikes - projected onto freezing axis
            Spk = Data(Restrict(ProjFR,LittleEpoch));
            InstProjSpiking_AllMice_Offset{m}(ep,:)=interp1([1/length(Spk):1/length(Spk):1],Spk,tps); hold on
        end
        
    end
end
tpsrealigned=tps*10-5-0.2;

% ValTypes = {'InstAccNorm','InstSpeedNorm','AlInstRespNorm','InstTidVolumeNorm','PowHzNorm','InstSpikeNorm','InstSpikeProjNorm','PressureNorm'}
clear AllVals
for m=1:6
    AllVals.AlInstRespNorm(m,:) = nanmean(InstRespiFreq_AllMice_normPer{m});
    AllVals.InstSpeedNorm(m,:) = nanmean(InstSpeed_AllMice_normPer{m});
    AllVals.InstTidVolumeNorm(m,:) = (nanmean(InstTidVolume_AllMice_normPer{m}));
    AllVals.PowHzNorm(m,:) = nanmean(FreqBandPower_AllMice_normPer_B{m});
        AllVals.PressureNorm(m,:) = nanmean(InstPressure_AllMice_normPer{m});

    if not(isempty(InstAcc_AllMice_normPer{m}))
        AllVals.InstAccNorm(m,:) = nanmean(InstAcc_AllMice_normPer{m});
    else
        AllVals.InstAccNorm(m,:) = nan(1,length(tpsrealigned));
    end
    
    if not(isempty(InstSpiking_AllMice_normPer{m}))
        AllVals.InstSpikeNorm(m,:) = ZScoreWiWindowSB(nanmean(InstSpiking_AllMice_normPer{m}),[1:5]);
    else
        AllVals.InstSpikeNorm(m,:) = nan(1,length(tpsrealigned));
    end
    
    
    if not(isempty(InstProjSpiking_AllMice_normPer{m}))
        AllVals.InstSpikeProjNorm(m,:) = ZScoreWiWindowSB(nanmean(InstProjSpiking_AllMice_normPer{m}),[1:5]);
    else
        AllVals.InstSpikeProjNorm(m,:) = nan(1,length(tpsrealigned));
    end
    
end


ValTypes = {'AlInstRespNorm','InstTidVolumeNorm','PressureNorm','PowHzNorm'}
figure
for v = 1:4
subplot(4,2,1+(v-1)*2)
boundedline([-0.45:0.1:1.45],nanmean((AllVals.(ValTypes{v})')'),stdError((AllVals.(ValTypes{v})')'))
line([0 0],ylim,'color','k','linestyle',':','linewidth',2)
line([1.1 1.1],ylim,'color','k','linestyle',':','linewidth',2)
% set(gca,'XTick',[])
title(ValTypes{v})
xlim([-0.5 1.5])
subplot(4,2,2+(v-1)*2)
boundedline([-0.45:0.1:1.45],nanmean(nanzscore(AllVals.(ValTypes{v})')'),stdError(nanzscore(AllVals.(ValTypes{v})')'))
line([0 0],ylim,'color','k','linestyle',':','linewidth',2)
line([1.1 1.1],ylim,'color','k','linestyle',':','linewidth',2)
% set(gca,'XTick',[])
title(ValTypes{v})
xlim([-0.5 1.5])
end
figure
for v = 1:4
subplot(4,1,v)
(ZScoreWiWindowSB(AllVals.(ValTypes{v}),[1:5])line([0 0],ylim,'color','k','linestyle',':','linewidth',2)
line([1.1 1.1],ylim,'color','k','linestyle',':','linewidth',2)
set(gca,'XTick',[])
title(ValTypes{v})
xlim([-0.4 1.5])
end

figure

for v = 1:8
subplot(8,1,v)
boundedline([-0.4:0.1:1.5],nanmean((AllVals.(ValTypes{v})')'),stdError((AllVals.(ValTypes{v})')'))
line([0 0],ylim,'color','k','linestyle',':','linewidth',2)
line([1.1 1.1],ylim,'color','k','linestyle',':','linewidth',2)
set(gca,'XTick',[])
title(ValTypes{v})
xlim([-0.4 1.5])
end

figure
subplot(711)
plot(tpsrealigned,zscore(InstRespNorm'),'k')
subplot(712)
plot(tpsrealigned,zscore(InstSpeedNorm'),'k')
subplot(713)
plot(tpsrealigned,zscore(InstTidVolumeNorm'),'k')
subplot(714)
plot(tpsrealigned,zscore(PowHzNorm'),'k')


figure
subplot(411)
boundedline([-0.4:0.1:1.5],nanmean(zscore(InstRespNorm')'),stdError(zscore(InstRespNorm')'))
line([0 0],ylim,'color','k','linestyle',':','linewidth',2)
line([1.1 1.1],ylim,'color','k','linestyle',':','linewidth',2)
set(gca,'XTick',[])
title('Respiration Frequency')
subplot(412)
boundedline([-0.4:0.1:1.5],nanmean(zscore(InstSpeedNorm')'),stdError(zscore(InstSpeedNorm')'))
line([0 0],ylim,'color','k','linestyle',':','linewidth',2)
line([1.1 1.1],ylim,'color','k','linestyle',':','linewidth',2)
set(gca,'XTick',[])
title('Speed')
subplot(413)
boundedline([-0.4:0.1:1.5],nanmean(zscore(InstTidVolumeNorm')'),stdError(zscore(InstTidVolumeNorm')'))
line([0 0],ylim,'color','k','linestyle',':','linewidth',2)
line([1.1 1.1],ylim,'color','k','linestyle',':','linewidth',2)
set(gca,'XTick',[])
title('Respiration tidal volume')
subplot(414)
boundedline([-0.4:0.1:1.5],nanmean(zscore(PowHzNorm')'),stdError(zscore(PowHzNorm')'))
line([0 0],ylim,'color','k','linestyle',':','linewidth',2)
line([1.1 1.1],ylim,'color','k','linestyle',':','linewidth',2)
set(gca,'XTick',[])
title('OB 4 HZ Power')

figure
for m=1:6
    InstRespOff(m,:) = nanmean(InstRespiFreq_AllMice_Offset{m});
    InstSpeedOff(m,:) = nanmean(InstSpeed_AllMice_Offset{m});
    InstTidVolumeOff(m,:) = nanmean(InstTidVolume_AllMice_Offset{m});
    PowHzOff(m,:) = nanmean(FreqBandPower_AllMice_Offset_B{m});
end
subplot(422)
boundedline(tpsrealigned,nanmean(zscore(InstRespOff')'),stdError(zscore(InstRespOff')'))
title('Respiration Frequency')
subplot(424)
boundedline(tpsrealigned,nanmean(zscore(InstSpeedOff')'),stdError(zscore(InstSpeedOff')'))
title('Speed')
subplot(426)
boundedline(tpsrealigned,nanmean(zscore(InstTidVolumeOff')'),stdError(zscore(InstTidVolumeOff')'))
title('Respiration tidal volume')
subplot(428)
boundedline(tpsrealigned,nanmean(zscore(PowHzOff')'),stdError(zscore(PowHzOff')'))
title('OB 4 HZ Power')


for m=1:6
    InstRespOn(m,:) = nanmean(InstRespiFreq_AllMice_Onset{m});
    InstSpeedOn(m,:) = nanmean(InstSpeed_AllMice_Onset{m});
    InstTidVolumeOn(m,:) = nanmean(InstTidVolume_AllMice_Onset{m});
    PowHzOn(m,:) = nanmean(FreqBandPower_AllMice_Onset_B{m});
end

subplot(421)
boundedline(tpsrealigned,nanmean(zscore(InstRespOn')'),stdError(zscore(InstRespOn')'))
subplot(423)
boundedline(tpsrealigned,nanmean(zscore(InstSpeedOn')'),stdError(zscore(InstSpeedOn')'))
subplot(425)
boundedline(tpsrealigned,nanmean(zscore(InstTidVolumeOn')'),stdError(zscore(InstTidVolumeOn')'))
subplot(427)
boundedline(tpsrealigned,nanmean(zscore(PowHzOn')'),stdError(zscore(PowHzOn')'))

figure
subplot(411)
plot([0:.1],[0:0.1],'b'),hold on
plot([0:.1],[0:0.1],'r'),hold on
boundedline(tpsrealigned,nanmean(zscore(InstRespOn')'),stdError(zscore(InstRespOn')')),hold on
boundedline(tpsrealigned,fliplr(nanmean(zscore(InstRespOff')')),fliplr(stdError(zscore(InstRespOff')')),'r')
line([0 0],ylim,'color','k','linestyle',':','linewidth',2)
legend('on','off')
title('Respiration Frequency')
subplot(412)
boundedline(tpsrealigned,nanmean(zscore(InstSpeedOn')'),stdError(zscore(InstSpeedOn')')),hold on
boundedline(tpsrealigned,fliplr(nanmean(zscore(InstSpeedOff')')),fliplr(stdError(zscore(InstSpeedOff')')),'r')
line([0 0],ylim,'color','k','linestyle',':','linewidth',2)
title('Speed')
subplot(413)
boundedline(tpsrealigned,nanmean(zscore(InstTidVolumeOn')'),stdError(zscore(InstTidVolumeOn')')),hold on
boundedline(tpsrealigned,fliplr(nanmean(zscore(InstTidVolumeOff')')),fliplr(stdError(zscore(InstTidVolumeOff')')),'r')
line([0 0],ylim,'color','k','linestyle',':','linewidth',2)
title('Respiration tidal volume')
subplot(414)
boundedline(tpsrealigned,nanmean(zscore(PowHzOn')'),stdError(zscore(PowHzOn')')),hold on
boundedline(tpsrealigned,fliplr(nanmean(zscore(PowHzOff')')),fliplr(stdError(zscore(PowHzOff')')),'r')
line([0 0],ylim,'color','k','linestyle',':','linewidth',2)
title('OB 4 HZ Power')

for m=1:6
AllSpecOff(m,:,:) = squeeze(nanmean(Spectro_AllMice_Offset_R{m},1))./nanmean(Spectro_AllMice_Offset_R{m}(:));
AllSpecOn(m,:,:) = squeeze(nanmean(Spectro_AllMice_Onset_R{m},1))./nanmean(Spectro_AllMice_Onset_R{m}(:));
AllSpecNorm(m,:,:) = squeeze(nanmean(Spectro_AllMice_normPer_R{m},1))./nanmean(Spectro_AllMice_normPer_R{m}(:));
end
    imagesc(Spectro{3},Spectro{3},squeeze(nanmean(AllSpecNorm,1))), axis xy


