%EffectStimOnFiringRateDetail

voieRipples=3;
numNeuron=12;

load behavResources
load LFPData
load PlaceCellTrig
load StimMFB
load SpikeData
load Waveforms

sPl=Range(Restrict(S{PlaceCellTrig},SleepEpoch));

% 
% FilRip=FilterLFP(Restrict(LFP{voieLFP},Epoch),[130 200],96);
% rgFil=Range(FilRip,'s');
% filtered=[rgFil-rgFil(1) Data(FilRip)];
% [ripples,stdev,noise] = FindRipples(filtered,'thresholds',[LowThRip HighThRip],'restrict',[debPeriodRip finPeriodRip]);
% [maps,data,stats] = RippleStats(filtered,ripples);
% PlotRippleStats(ripples,maps,data,stats)
% 
% ripEvt=intervalSet((ripples(:,2)-0.1)*1E4,(ripples(:,2)+0.1)*1E4);


ripples=ObsRipples(LFP, voieRipples,[3 5]);
riptime=ts(ripples(:,2)*1E4);
rg=Range(LFP{voieRipples});



figure('color',[1 1 1]), [fh,sq1,sweeps1] = RasterPETH(S{numNeuron}, Restrict(burst,SleepEpoch), -1000,+1000,'BinSize',10);
title('place cell trigger for ICRS centered to ICRS during sleep')

figure('color',[1 1 1]), [fh,sq2,sweeps2] = RasterPETH(S{numNeuron}, ts(Range(riptime)+rg(1)), -1000,+1000,'BinSize',10);
title('place cell trigger for ICRS centered to ripples without stim during sleep')


for id=1:length(S)

    wfo=PlotWaveforms(W,PlaceCellTrig,SleepEpoch);close
    LargeSpk=squeeze(wfo(:,nchannelSpk,:));
    [BE,id]=sort(LargeSpk(:,14));
    try
        nb=200;
        sPl2=sort(sPl(id(nb:end-nb)));
    end

    bu=Range(Restrict(burst,SleepEpoch));
    Qs = MakeQfromS(tsdArray({PoolNeurons(S,a)}),10);
    ratek=Qs;
    rate = Data(ratek);
    ratek = tsd(Range(ratek),rate(:,1));
    figure('color',[1 1 1]), [fh, rasterAx, histAx, matVal] = ImagePETH(ratek, ts(bu), -2000, +2000,'BinSize',50);close
    figure('color',[1 1 1]), [fh, rasterAx, histAx, matVal2] = ImagePETH(ratek, ts(sPl), -2000, +2000,'BinSize',50);title('Spikes'),close
    figure('color',[1 1 1]), [fh, rasterAx, histAx, matVal3] = ImagePETH(ratek, ts(sPl2), -2000, +2000,'BinSize',50);title('Spikes corrected'),close
    wfobu=PlotWaveforms(W,id,intervalSet(Range(bu),Range(bu)+250*1E4));close
    wfot=PlotWaveforms(W,id,SleepEpoch);close

    figure('color',[1 1 1]), hold on
    plot(Range(matVal,'ms'),mean(Data(matVal)'))
    plot(Range(matVal,'ms'),mean(Data(matVal2)'),'r')
    plot(Range(matVal,'ms'),mean(Data(matVal3)'),'m')

    pas=2;

    figure('color',[1 1 1])
    a=1;
    for i=1:size(wfobu,2)
        subplot(size(wfobu,2),2,a),hold on
        plot(mean(squeeze(wfobu(:,i,:))),'k','linewidth',2)
        plot(mean(squeeze(wfobu(:,i,:)))-std((squeeze(wfobu(:,i,:)))),'color',[0.7 0.7 0.7])
        plot(mean(squeeze(wfobu(:,i,:)))+std(squeeze(wfobu(:,i,:))),'color',[0.7 0.7 0.7])

        subplot(size(wfobu,2),2,a+1),hold on
        plot((squeeze(wfobu(1:pas:end,i,:)))','k')

        a=a+2;
    end


    figure('color',[1 1 1])
    a=1;
    for i=1:size(wfot,2)
        subplot(size(wfot,2),2,a),hold on
        plot(mean(squeeze(wfot(:,i,:))),'k','linewidth',2)
        plot(mean(squeeze(wfot(:,i,:)))-std((squeeze(wfot(:,i,:)))),'color',[0.7 0.7 0.7])
        plot(mean(squeeze(wfot(:,i,:)))+std(squeeze(wfot(:,i,:))),'color',[0.7 0.7 0.7])

        subplot(size(wfot,2),2,a+1),hold on
        plot((squeeze(wfot(1:pas:end,i,:)))','k')

        a=a+2;
    end

end

