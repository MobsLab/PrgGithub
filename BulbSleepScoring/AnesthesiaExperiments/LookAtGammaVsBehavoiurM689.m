clear all
% Get Data
SetCurrentSession
MakeData_Main_SB

% Get Stim Times
load('/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M668/VoltagesM668.mat')
load('LFPData/DigInfo1.mat')
StimEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above')
StimVolt = Voltage;
size(Start(StimEpoch))
save('behavResources.mat','StimEpoch','StimVolt','-append')

% Get Spectra
try
    load('ChannelsToAnalyse/dHPC_deep.mat')
    chH=channel;
catch
    try
        load('ChannelsToAnalyse/dHPC_rip.mat')
        chH=channel;
    catch
        chH=input('please give hippocampus channel for theta ');
    end
end

try
    load('ChannelsToAnalyse/Bulb_deep.mat')
    chB=channel;
catch
    chB=input('please give olfactory bulb channel ');
end

HighSpectrum([cd filesep],chB,'B');
disp('Bulb Spectrum done')
LowSpectrumSB([cd filesep],chH,'H');
disp('Hpc spectrum done')

 % Find Noise
 Epoch=FindNoiseEpoch([cd filesep],chH,0);


% Heart Rate
clear channel LFP TotalNoiseEpoch
load('ChannelsToAnalyse/EKG.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
load('StateEpochSB.mat','TotalNoiseEpoch')
Options=struct;
[Times,Template,HearRate,GoodEpoch]=DetectHeartBeats_EmbReact_SB(LFP,TotalNoiseEpoch,Options,0);
EKG.HBTimes=ts(Times);
EKG.HBShape=Template;
EKG.DetectionOptions=Options;
EKG.HBRate=HearRate;
EKG.GoodEpoch=GoodEpoch;
save('HeartBeatInfo.mat','EKG')


% gamma vals

%% Initiation
% load OB LFP
load(strcat('LFPData/LFP',num2str(chB),'.mat'));
% params
smootime=3;

%% find gamma epochs
% get instantaneous gamma power
FilGamma=FilterLFP(LFP,[50 70],1024);
HilGamma=hilbert(Data(FilGamma));
H=abs(HilGamma);
tot_ghi=Restrict(tsd(Range(LFP),H),Epoch);

% smooth gamma power
smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
save('StateEpochSB','smooth_ghi','-v7.3','-append');

%% Stim Responses
UniqueVoltage = unique(StimVolt);
StartTimes = Start(StimEpoch,'s');
load('behavResources.mat')
cols = summer(length(UniqueVoltage));
figure
for k = 1:length(UniqueVoltage)
    [M{k},T]=PlotRipRaw(MovAcctsd,StartTimes(find(StimVolt==UniqueVoltage(k))),1*1000,0,0);
    plot(M{k}(:,1),M{k}(:,2),'linewidth',2,'color',cols(k,:)), hold on
end
box off
line([0 0],ylim,'color','k')


%
Vals = {'08','10','12','15','18'};
cols2 = jet(length(Vals));
cols = summer(length(UniqueVoltage));
BaselineEpoch = intervalSet(0,10*60*1e4);
for v = 1:length(Vals)
    cd(['/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M668/Isoflurane_',Vals{v}])
    load('behavResources.mat')
    UniqueVoltage = unique(StimVolt);
    StartTimes = Start(StimEpoch,'s');
    figure(1)
    subplot(1,5,v)
    for k = 1:length(UniqueVoltage)
        [M{k},T]=PlotRipRaw(MovAcctsd,StartTimes(find(StimVolt==UniqueVoltage(k))),1*1000,0,0);
        plot(M{k}(:,1),M{k}(:,2),'linewidth',2,'color',cols(k,:)), hold on
        Peak(v,k) = max(M{k}(:,2));
        PeakStd(v,k) = stdError(max(T'));
        MeanVal(v,k) = nanmean(M{k}(51:70,2));
        MeanValStd(v,k) = stdError(nanmean(T(:,51:70)));

    end
    box off
    ylim([0 4*1e8])
    line([0 0],ylim,'color','k')
    
    load('StateEpochSB.mat')
    figure(2)
    plot(Range(Restrict(smooth_ghi,BaselineEpoch),'s'),Data(Restrict(smooth_ghi,BaselineEpoch)),'color',cols2(v,:)), hold on
    MeanGamma(v) = nanmean(Data(Restrict(smooth_ghi,BaselineEpoch)));
    StdGamma(v) = std(Data(Restrict(smooth_ghi,BaselineEpoch)));

end

figure
subplot(131)
for v = 1:length(Vals)
errorbar(UniqueVoltage,MeanVal(v,:),MeanValStd(v,:),'linewidth',2,'color',cols2(v,:)), hold on
end

subplot(132)
for v = 1:length(Vals)
errorbar(UniqueVoltage,Peak(v,:),PeakStd(v,:),'linewidth',2,'color',cols2(v,:)), hold on
end

subplot(133)
errorbar([0.8,1,1.2,1.5,1.8],MeanGamma,StdGamma,'linewidth',2,'color','k'), hold on

figure
for v = 1:length(Vals)
subplot(5,1,v)
plot(MeanGamma,MeanVal(v,:),'*')
end

figure
errorbar([0.8,1,1.2,1.5,1.8],MeanGamma,,StdGamma)



%% Wake up
cd /media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M668/Isoflurane_WakeUP
load('behavResources.mat')
UniqueVoltage = unique(StimVolt);
StartTimes = Start(StimEpoch,'s');
cols = summer(length(UniqueVoltage));
[M,T]=PlotRipRaw(MovAcctsd,StartTimes,1*1000,0,0);
PeakWakeUp= (max(T'));
MeanWakeUp = nanmean(T(:,51:70)');
load('StateEpochSB.mat')
figure(55)
subplot(311)
plot(Range((smooth_ghi),'s'),Data((smooth_ghi))), hold on
for v = 1:length(Vals)
line(xlim,[1 1]*MeanGamma(v),'linewidth',2,'color',cols2(v,:))    
end
subplot(312)
plot(StartTimes(1:2:end),PeakWakeUp(1:2:end),'linewidth',3)
hold on
plot(StartTimes(2:2:end),PeakWakeUp(2:2:end),'linewidth',3)
for v = 1:length(Vals)
line(xlim,[1 1]*Peak(v,3),'linewidth',2,'color',cols2(v,:))    
end
subplot(313)
plot(Range((MovAcctsd),'s'),Data((MovAcctsd))), hold on

    
    
    
    