%FigureSpikeRipplesPoster

%cd /media/DISK_1/Dropbox/Kteam/ProjetSommeil/Figures/BilaManipesSleepMarch2012/figuresposterED3C


load behavResources
load SpikeData
load LFPData

Epoch=SleepEpoch;

st=Range(stim,'s');
bu = burstinfo(st,0.5);
burst=tsd(bu.t_start*1E4,bu.i_start);
idburst=bu.i_start;
save StimMFB stim burst idburst



StimEpoch=intervalSet(Range(burst)-500,Range(burst)+2000);
LFP2=Restrict(LFP, SleepEpoch-StimEpoch);

close all
ripples=ObsRipples(LFP2, 3,[3 5]);

riptime=ts(ripples(:,2)*1E4);

rg=Range(LFP2{3});

idburst=[[1:100],[250:400],[550:807]];

bu2=Range(burst);
bu2=bu2(idburst);
burst2=ts(bu2);


figure('color',[1 1 1]), [fh,sq1,sweeps1] = RasterPETH(S{12}, Restrict(burst2,SleepEpoch), -1000,+1000,'BinSize',10);
title('place cell trigger for ICRS centered to ICRS during sleep')

figure('color',[1 1 1]), [fh,sq2,sweeps2] = RasterPETH(S{12}, ts(Range(riptime)+rg(1)), -1000,+1000,'BinSize',10);
title('place cell trigger for ICRS centered to ripples without stim during sleep')



figure('color',[1 1 1]), [fh,sq3,sweeps3] = RasterPETH(S{41}, Restrict(burst2,SleepEpoch), -1000,+1000,'BinSize',10);
title('interneuron centered to ICRS during sleep')

figure('color',[1 1 1]), [fh,sq4,sweeps4] = RasterPETH(S{41}, ts(Range(riptime)+rg(1)), -1000,+1000,'BinSize',10);
title('interneuron centered to ripples without stim during sleep')



figure('color',[1 1 1]), [fh,sq5,sweeps5] = RasterPETH(S{24}, ts(Range(riptime)+rg(1)), -1000,+1000,'BinSize',10);
title('pyramidal neuron centered to ripples without stim during sleep')

figure('color',[1 1 1]), [fh,sq6,sweeps6] = RasterPETH(S{24}, Restrict(burst2,SleepEpoch), -1000,+1000,'BinSize',10);
title('pyramidal neuron centered to ICRS during sleep')



figure('color',[1 1 1]), 
subplot(3,1,1), hold on
plot(Data(sq1)/length(sweeps1),'k','linewidth',2)
plot(Data(sq2)/length(sweeps2),'r','linewidth',2)
subplot(3,1,2), hold on
plot(Data(sq3)/length(sweeps3),'k','linewidth',2)
plot(Data(sq4)/length(sweeps4),'r','linewidth',2)
subplot(3,1,3), hold on
plot(Data(sq5)/length(sweeps5),'k','linewidth',2)
plot(Data(sq6)/length(sweeps6),'r','linewidth',2)

rgg=Range(riptime);

for i=1:length(rgg)
    tref(i)=rgg(i)+rand(1)*3E2-3E2/2;
end
figure('color',[1 1 1]), [fh,sq7,sweeps7] = RasterPETH(S{41}, ts(tref+rg(1)), -1000,+1000,'BinSize',10);
figure('color',[1 1 1]), 
hold on
plot(Data(sq3)/length(sweeps3),'k','linewidth',2)
plot(Data(sq4)/length(sweeps4),'g','linewidth',2)
plot(Data(sq7)/length(sweeps7),'r','linewidth',2)

figure('color',[1 1 1]), 
hold on
plot(Data(sq4)/length(sweeps4),'color',[0.6 0.6 0.6],'linewidth',2)
plot(Data(sq7)/length(sweeps7),'r','linewidth',2)

fir=Data(sq3)/length(sweeps3);
figure('color',[1 1 1]), plot(fir,'k','linewidth',2)
hold on, plot(101:length(fir),fir(end-100:-1:1),'r','linewidth',2)

figure('color',[1 1 1]), 
hold on
plot(Data(sq3)/length(sweeps3),'k','linewidth',2)
plot(Data(sq7)/length(sweeps7),'r','linewidth',2)


load Waveforms
PlotWaveforms(W,24);
PlotWaveforms(W,41);
PlotWaveforms(W,12);

PlotWaveforms(W,41,SleepEpoch-StimEpoch);
PlotWaveforms(W,41,StimEpoch);


if 0

        a=1;
        for i=1:20
        try
        eval(['saveFigure(',num2str(i),',''FigureMouse290207caracRipplesn',num2str(a),''',''/media/DISK_1/Dropbox/Kteam/ProjetSommeil/Figures/BilaManipesSleepMarch2012/figuresposterED3C'')'])
        a=a+1;
        end
        end


end