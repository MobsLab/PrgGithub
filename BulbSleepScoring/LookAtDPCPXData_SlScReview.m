clear all
mm=1;
FileName{mm,1} = '/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130415/BULB-Mouse-61-15042013';
FileName{mm,2} = '/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130416/BULB-Mouse-61-16042013';
FileName{mm,3} = '/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130422/BULB-Mouse-61-22042013';
mm=2;
FileName{mm,1} = '/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013';
FileName{mm,2} = '/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130416/BULB-Mouse-60-16042013';
FileName{mm,3} = '/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130422/BULB-Mouse-60-22042013';
mm=3;
FileName{mm,1} = '/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130729/BULB-Mouse-82-29072013';
FileName{mm,2} = NaN;
FileName{mm,3} = '/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130730/BULB-Mouse-82-30072013';
mm=4;
FileName{mm,1} = '/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse083/20130723/BULB-Mouse-83-23072013';
FileName{mm,2} = '/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse083/20130729/BULB-Mouse-83-29072013';
FileName{mm,3} = '/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse083/20130730/BULB-Mouse-83-30072013';
Hours = [11:18];

for mm=1:4
    for z=1:3
        if not(isnan(FileName{mm,z}))
            cd(FileName{mm,z})
            FileName{mm,z}
            clear ZTEpoch SWSEpoch Wake REMEpoch LFP tsdZT DPCPXEpoch VEHEpoch Sp f t Deltsd
            load('behavResources.mat','tsdZT','DPCPXEpoch','VEHEpoch')
            load('StateEpoch.mat','REMEpoch','MovEpoch','SWSEpoch','NoiseEpoch')
            MovEpoch =or(MovEpoch,NoiseEpoch);
            load('ChannelsToAnalyse/PFCx_deep.mat')
            load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
            Deltsd = tsd(t*1e4,Sp(:,find(f<2,1,'last'):find(f<5,1,'last')));
            for k = 1:length(Hours)-1
                ZTEpoch = thresholdIntervals(tsdZT,Hours(k)*3600,'Direction','Above');
                ZTEpoch = and(ZTEpoch,thresholdIntervals(tsdZT,Hours(k+1)*3600,'Direction','Below'));
                PerLength(mm,z,k) = length(Range(Restrict(tsdZT,ZTEpoch)));
                QtyWake(mm,z,k)= length(Range(Restrict(tsdZT,and(ZTEpoch,MovEpoch))));
                QtySWS(mm,z,k)= length(Range(Restrict(tsdZT,and(ZTEpoch,SWSEpoch))));
                QtyREM(mm,z,k)= length(Range(Restrict(tsdZT,and(ZTEpoch,REMEpoch))));
                SWA(mm,z,k)= mean(mean(Data(Restrict(Deltsd,and(ZTEpoch,SWSEpoch)))));
            end
            if z==3
                DPCPXTime(mm)=min(Data(Restrict(tsdZT,DPCPXEpoch)));
                VEHTime(mm)=min(Data(Restrict(tsdZT,VEHEpoch)));

            end
        else
            PerLength(mm,z,k) =NaN;
            QtyWake(mm,z,k)= NaN;
            QtySWS(mm,z,k)= NaN;
            QtyREM(mm,z,k)= NaN;
            SWA(mm,z,k) = NaN;
        end
    end
end

QtyWake(QtyWake==0)=NaN;
QtySWS(QtySWS==0)=NaN;
QtyREM(QtyREM==0)=NaN;
SWA(SWA==0)=NaN;

figure
subplot(411)
errorbar(Hours(1:end-1),nanmean(squeeze(QtyWake(:,1,:))),stdError(squeeze(QtyWake(:,1,:))),'k')
hold on
errorbar(Hours(1:end-1),nanmean(squeeze(QtyWake(:,2,:))),stdError(squeeze(QtyWake(:,2,:))),'k')
errorbar(Hours(1:end-1),nanmean(squeeze(QtyWake(:,3,:))),stdError(squeeze(QtyWake(:,3,:))),'r')
subplot(412)
errorbar(Hours(1:end-1),nanmean(squeeze(QtySWS(:,1,:))),stdError(squeeze(QtySWS(:,1,:))),'k')
hold on
errorbar(Hours(1:end-1),nanmean(squeeze(QtySWS(:,2,:))),stdError(squeeze(QtySWS(:,2,:))),'k')
errorbar(Hours(1:end-1),nanmean(squeeze(QtySWS(:,3,:))),stdError(squeeze(QtySWS(:,3,:))),'r')
subplot(413)
errorbar(Hours(1:end-1),nanmean(squeeze(QtyREM(:,1,:))),stdError(squeeze(QtyREM(:,1,:))),'k')
hold on
errorbar(Hours(1:end-1),nanmean(squeeze(QtyREM(:,2,:))),stdError(squeeze(QtyREM(:,2,:))),'k')
errorbar(Hours(1:end-1),nanmean(squeeze(QtyREM(:,3,:))),stdError(squeeze(QtyREM(:,3,:))),'r')
subplot(414)
errorbar(Hours(1:end-1),nanmean(squeeze(SWA(:,1,:))),stdError(squeeze(SWA(:,1,:))),'k')
hold on
errorbar(Hours(1:end-1),nanmean(squeeze(SWA(:,2,:))),stdError(squeeze(SWA(:,2,:))),'k')
errorbar(Hours(1:end-1),nanmean(squeeze(SWA(:,3,:))),stdError(squeeze(SWA(:,3,:))),'r')

figure

FilDelta=FilterLFP(LFP,[2 5],1024);
HilDelta=hilbert(Data(FilDelta));
H=abs(HilDelta);
H(H<100)=100;

DeltaPowtsd_NoDrugs = tsd(Range(LFP),H);