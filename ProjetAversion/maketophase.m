h=figure;
set(h,'color',[1 1 1],'Position',[1 1 1600 600])
base='/media/DataMOBs14/ProjetAversion/Mouse117/25022014/Aversion-Mouse-117-25022014-Sleep-StimdPAG/Sleep_Stims_'
base2='Mouse-117-25022014-Sleep_StimdPAG-';
for k=1:9
    filename{k}=strcat(base,'0',num2str(k),'/',base2,'0',num2str(k),'/');
end
filename{10}=strcat(base,num2str(10),'/',base2,num2str(10),'/');
for k=1:10
    k
    cd (filename{k})
    scrsz = get(0,'ScreenSize');
    try
        load('LFPData/LFP1.mat');
    catch
        load('LFPData/LFP2.mat');
    end
    
    r=Range(LFP);
    TotalEpoch=intervalSet(0*1e4,r(end));
    ThreshEpoch=TotalEpoch;
    mindur=3; %abs cut off for events;
    ThetaI=[4 10]; %merge and drop
    mw_dur=5; %max length of microarousal
    sl_dur=15; %min duration of sleep around microarousal
    ms_dur=10; % max length of microsleep
    wa_dur=20; %min duration of wake around microsleep
    try
        load('StateEpochSB.mat')
        ThreshEpoch=TotalEpoch-StimEpoch;
    end
    
    chH=9;
    chB=8;
    HighBlbSpectrum(filename{k},chB);
    LowHpcSpectrum(filename{k},chH);
    Epoch=FindNoiseEpoch(filename{k},chH)
    ThreshEpoch=And(ThreshEpoch,Epoch);
    ThreshEpoch=CleanUpEpoch(ThreshEpoch);
    CalcTheta(Epoch,ThetaI,chH,filename{k});
    CalcGamma(Epoch,chB,mindur,filename{k});
    load('StateEpochSB.mat')
    ghi_new=Restrict(smooth_ghi,ThreshEpoch);
    theta_new=Restrict(smooth_Theta,ThreshEpoch);
    t=Range(theta_new);
    ti=t(5:5:end);
    ghi_new=Restrict(ghi_new,ts(ti));
    theta_new=Restrict(theta_new,ts(ti));
    try
        stimEpoch=stimEpoch-NoiseEpoch-GndNoiseEpoch;
        stimEpoch=CleanUpEpoch(stimEpoch);
        save('StateEpochSB.mat','stimEpoch','-v7.3','-append')
        clear stimEpoch;
    end
    
    figure(h)
    plot(log(Data(ghi_new)),log(Data(theta_new)),'.','color',[0.2 0.2 0.2],'MarkerSize',5);
    hold on
    pause
end


for k=1:10
    
    
    
legend('SWS','REM','Wake')
l=findobj(gcf,'tag','legend')
a=get(l,'children');
set(a(1),'markersize',20); % This line changes the legend marker size
set(a(4),'markersize',20); % This line changes the legend marker size
set(a(7),'markersize',20); % This line changes the legend marker size



SetCurrentSession
SetCurrentSession('same')
a=GetWideBandData(1);
lfp=tsd(a(:,1)*1e4,a(:,2));
stimEpoch=thresholdIntervals(lfp,10000);
stimEpoch=mergeCloseIntervals(stimEpoch,0.5*1e4);

clf
plot(Range(lfp,'s'),Data(lfp),'b')
hold on
plot(Range(Restrict(lfp,stimEpoch),'s'),Data(Restrict(lfp,stimEpoch)),'r')

save('StateEpochSB.mat','stimEpoch')
