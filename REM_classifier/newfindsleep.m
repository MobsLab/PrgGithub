%%% 
%NEW SLEEP SCORE
%%%
clear all
close all
disp('Sleep Scoring using gamma in olfactory bulb')
scrsz = get(0,'ScreenSize');
load('LFPData/LFP1.mat');
r=Range(LFP);
TotalEpoch=intervalSet(0*1e4,r(end));

mindur=3; %abs cut off for events;
ThetaI=[4 10]; %merge and drop


WantGamEp=0;
WantGamEp=input('Do you want a special threshold finding ? y=1/n=0');
if WantGamEp
    beginEp=input('Start time in sec');
    endEp=input('End time in sec');
    GamEp=intervalSet(beginEp*1e4,endEp*1e4);
else
    GamEp=TotalEpoch;
end

    


%% Find ThetaEpochs

pasTheta=100; 
params.Fs=1250;
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;
params.fpass=[0 20];
movingwin=[3 0.2];
params.tapers=[3 5];



disp('Theta Epochs');
chH=input('please give hippocampus channel');
load(strcat('LFPData/LFP',num2str(chH),'.mat'));

try
    SpH=Spectro{1};
    tH=Spectro{2};
    fH=Spectro{3};
    disp('... Using already existing parameters for spectrogramm.');
catch
     
    disp('... Calculating parameters for spectrogramm.');
    [SpH,tH,fH]=mtspecgramc(Data(LFP),movingwin,params);
    Spectro={SpH,tH,fH};
    save('StateEpoch.mat','Spectro','chH')
end



% Display Data

figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3)/4 scrsz(4)/1]),Gf=gcf;
subplot(6,5,1:4),imagesc(tH,fH,10*log10(SpH)'), axis xy, caxis([20 65]);
title('Spectrogramm');
subplot(6,5,11:14),imagesc(tB,fB,10*log10(SpB)'), axis xy, caxis([20 65]);



% find theta epochs

disp(' ');
try
    ThetaRatioTSD;
    ThetaEpoch;
    disp('... Theta Epochs already exists, skipping this step.');
catch
    disp('... Creating Theta Epochs ');
    FilTheta=FilterLFP(LFP,[5 10],1024);
    FilDelta=FilterLFP(LFP,[3 6],1024);
    HilTheta=hilbert(Data(FilTheta));
    HilDelta=hilbert(Data(FilDelta));
    H=abs(HilDelta);
    H(H<100)=100;
    ThetaRatio=abs(HilTheta)./H;
    rgThetaRatio=Range(FilTheta,'s');
    ThetaRatio=SmoothDec(ThetaRatio(1:pasTheta:end),50);
    rgThetaRatio=rgThetaRatio(1:pasTheta:end);
    ThetaRatioTSD=tsd(rgThetaRatio*1E4,ThetaRatio);
    
    rat_theta=Data((ThetaRatioTSD));
[Y,X]=hist(rat_theta,100);
mX=max(X);
mx=min(X);
X=X-mx;
X=X*15e4/mX;
tseries=timeseries(Y,X);
time=[0:100:15e4];
thts=resample(tseries,time);
X=thts.time;
z=thts.Data;
 for t=1:length(z)
     Y(t)=z(1,1,t);
 end
smo=20;
fil=FilterLFP(tsd(sort(X)',smooth(Y',smo)),[0.001 0.5]);
d=diff(Data(fil));
fild=Data(fil);
filr=Range(fil);
% figure, plot(filr(2:end),d)
a=find(d<0);
da=diff(a);
Theta_Thresh_norm=filr(a(find(da~=1,1,'first'))+1);
ThetaThresh=filr(a(find(da~=1,1,'first'))+1)*mX/15e4+mx;

  
        ThetaEpoch=thresholdIntervals(ThetaRatioTSD,ThetaThresh,'Direction','Above');
        ThetaEpoch=mergeCloseIntervals(ThetaEpoch,ThetaI(1)*1E4);
        ThetaEpoch=dropShortIntervals(ThetaEpoch,ThetaI(2)*1E4);
        figure(Gf), 
        [Y,X]=hist(rat_theta,100);
        subplot(6,5,[5,10]), plot(X,Y,'linewidth',3)
        line([ThetaThresh ThetaThresh],[0 max(Y)],'linewidth',4,'color','r')
        subplot(6,5,6:9), plot(Range(Restrict(ThetaRatioTSD,ThetaEpoch),'s'),Data(Restrict(ThetaRatioTSD,ThetaEpoch)),'r.');
        hold on, plot(Range(ThetaRatioTSD,'s'),Data(ThetaRatioTSD),'k','linewidth',3);  xlim([0,max(Range(ThetaRatioTSD,'s'))]);

        
%         xlim([0 mX*15e4])
       
    end

    save('StateEpoch','ThetaEpoch', 'ThetaRatioTSD','ThetaI','ThetaThresh','Theta_Thresh_norm','-append');


disp('Noise Epoch determination')

%% Noisy Epoch in LFP
disp(' ');
try
    NoiseEpoch;
    GndNoiseEpoch;
        disp('... Noisy Epochs in LFP already exist, skipping this step.');
catch
    disp('... Finding Noisy Epochs in LFP.');
    NoiseThresh=3E5;
    GndNoiseThresh=1E6;
    Ok='n';
    while Ok~='y'
        
        figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)/2]), Nf=gcf;
        imagesc(tH,fH,10*log10(SpH)'), axis xy, caxis([20 65]);
       title('Spectrogramm : determine noise periods');        
        
        if Ok~='m'
            Okk='n'; % high frequency noise
            figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)/2]),hf=gcf;
            while Okk~='y'
                
                HighSp=SpH(:,fH<=20 & fH>=18);
                subplot(2,1,1), hold off,
                imagesc(tH,fH(fH<=20 & fH>=18),10*log10(HighSp)'), axis xy,caxis([20 65]);
                
                NoiseTSD=tsd(tH*1E4,mean(HighSp,2));
                NoiseEpoch=thresholdIntervals(NoiseTSD,NoiseThresh,'Direction','Above');
                
                hold on, plot(Range(NoiseTSD,'s'),Data(NoiseTSD)/max(Data(NoiseTSD))+19,'b')
                hold on, plot(Range(Restrict(NoiseTSD,NoiseEpoch),'s'),Data(Restrict(NoiseTSD,NoiseEpoch))/max(Data(NoiseTSD))+19,'*w')
                title(['18-20Hz Spectrogramm, determined High Noise Epochs are in white (total=',num2str(floor(10*sum(Stop(NoiseEpoch,'s')-Start(NoiseEpoch,'s')))/10),'s)']);
                Okk=input('--- Are you satisfied with High Noise Epochs (y/n)? ','s');
                if Okk~='y', NoiseThresh=input('Give a new High Noise Threshold (Default=3E5) : '); end
            end
            
            Okk='n'; % low frequency noise (grounding issue)
            while Okk~='y'
                LowSp=SpH(:,fH<=2);
                subplot(2,1,2), hold off,
                imagesc(tH,fH(fH<=2),10*log10(LowSp)'), axis xy,caxis([20 65]);
                
                GndNoiseTSD=tsd(tH*1E4,mean(LowSp,2));
                GndNoiseEpoch=thresholdIntervals(GndNoiseTSD,GndNoiseThresh,'Direction','Above');
                
                hold on, plot(Range(GndNoiseTSD,'s'),Data(GndNoiseTSD)/max(Data(GndNoiseTSD))+1,'b')
                hold on, plot(Range(Restrict(GndNoiseTSD,GndNoiseEpoch),'s'),Data(Restrict(GndNoiseTSD,GndNoiseEpoch))/max(Data(GndNoiseTSD))+1,'*w')
                title(['0-2Hz Spectrogramm, determined Ground Noise Epochs are in white (total=',num2str(floor(10*sum(Stop(GndNoiseEpoch,'s')-Start(GndNoiseEpoch,'s')))/10),'s)']);
                Okk=input('--- Are you satisfied with Ground Noise Epochs (y/n)? ','s');
                if Okk~='y', GndNoiseThresh=input('Give a new Ground Noise Threshold (Default=1E6) : '); end
            end

            AddOk=input('Do you want to add a WeirdNoiseEpoch (y/n)? ','s');
            if AddOk=='y', disp('Enter start and stop time (s) of WeirdNoise')
                disp('(e.g. [1,200, 400,500] to put 1-200s and 400-500s periods into noise)')
                WeirdNoise=input(': ');
                try WeirdNoiseEpoch=intervalSet(WeirdNoise(1:2:end)*1E4,WeirdNoise(2:2:end)*1E4);
                catch, keyboard; end
            else WeirdNoiseEpoch=intervalSet([],[]); 
            end
            
            
        else
            % high frequency noise
            NoiseEpoch=input('Enter start and stop time of high noise periods : ');
            keyboard
            if length(NoiseEpoch)/2~=floor(length(NoiseEpoch))/2, disp('Problem: not same number of starts and ends! '); Ok='n';end
            NoiseEpoch=NoiseEpoch*1E4;
%             NoiseEpoch(NoiseEpoch>max(Range(Mmov)))=max(Range(Mmov));
            NoiseEpoch(NoiseEpoch<0)=0;
            NoiseEpoch=intervalSet(NoiseEpoch(1:2:end),NoiseEpoch(2:2:end));
            
            % low frequency noise (grounding issue)
            GndNoiseEpoch=input('Enter start and stop time of ground noise periods (very low frequencies) : ');
            keyboard
            if length(GndNoiseEpoch)/2~=floor(length(GndNoiseEpoch))/2, disp('Problem: not same number of starts and ends! '); Ok='n';end
            GndNoiseEpoch=GndNoiseEpoch*1E4;
            GndNoiseEpoch(GndNoiseEpoch<0)=0;
            GndNoiseEpoch=intervalSet(GndNoiseEpoch(1:2:end),GndNoiseEpoch(2:2:end));
        end
            
        if isempty(Start(NoiseEpoch))==0, hold on, line([Start(NoiseEpoch,'s') Start(NoiseEpoch,'s')]',[0 20],'color','k');end
        if isempty(Start(GndNoiseEpoch))==0,hold on, line([Start(GndNoiseEpoch,'s') Start(GndNoiseEpoch,'s')]',[0 20],'color','b');end
        if isempty(Start(WeirdNoiseEpoch))==0,hold on, line([Start(WeirdNoiseEpoch,'s') Start(WeirdNoiseEpoch,'s')]',[0 20],'color','c');end
        disp(['total noise time = ',num2str(sum(Stop(or(or(NoiseEpoch,GndNoiseEpoch),WeirdNoiseEpoch),'s')-Start(or(or(NoiseEpoch,GndNoiseEpoch),WeirdNoiseEpoch),'s'))),'s.'])
        Ok=input('--- Are you satisfied with all Noise Epochs (y/n)? ','s');
        close(hf)
        close(Nf)
    end
    
end
save('StateEpoch','NoiseEpoch','GndNoiseEpoch','NoiseThresh', 'GndNoiseThresh');
Epoch=TotalEpoch-GndNoiseEpoch-NoiseEpoch;

%% Sleep Wake periods

disp('Finding Wake and Sleep periods')
chB=input('please give bulb channel');


load(strcat('LFPData/LFP',num2str(chB),'.mat'))
display('calculating Bulb spectrum...')

params.Fs=1/median(diff(Range(LFP,'s')));
params.err=[1 0.0500];
params.pad=2;
params.trialave=0;
params.fpass=[20 100];
params.tapers=[1 2];
movingwin=[0.1 0.005];


suffix='H';

[SpB,tB,fB]=mtspecgramc(Data((Restrict(LFP,Epoch))),movingwin,params);
save('StateEpoch.mat','SpB','tB','fB','chB','-append')


    sptsd=tsd(tB*10000,SpB);

sptsd=Restrict(sptsd,Epoch);
startg=find(fB<50,1,'last');
stopg=find(fB>70,1,'first');
startg2=find(fB<25,1,'last');
stopg2=find(fB>45,1,'first');

spdat=Data(sptsd);

tot_ghi=tsd(Range(Restrict(sptsd,Epoch)),sum(spdat(:,startg:stopg)')');
tot_ghi2=tsd(Range(Restrict(sptsd,Epoch)),sum(spdat(:,startg2:stopg2)')');

tot_ghi=Restrict(tot_ghi,Epoch);
smooth_ghi=tsd(Range(tot_ghi),smooth(Data(tot_ghi),500));
tot_ghi2=Restrict(tot_ghi2,Epoch);
smooth_ghi2=tsd(Range(tot_ghi2),smooth(Data(tot_ghi2),500));


a=percentile(Data(smooth_ghi),0.99);
sm_ghi=Data(Restrict(smooth_ghi,GamEp));
smooth_ghi_new_range=sm_ghi(sm_ghi<a);
[Y,X]=hist(smooth_ghi_new_range,1000);
mX=max(X);
mx=min(X);
X=X-mx;
X=X*15e4/mX;
tseries=timeseries(Y,X);
time=[0:100:15e4];
rsts=resample(tseries,time);
X=rsts.time;
z=rsts.Data;
 for t=1:length(z)
     Y(t)=z(1,1,t);
 end
smo=20;
fil=FilterLFP(tsd(sort(X)',smooth(Y',smo)),[0.001 1]);
d=diff(Data(fil));
fild=Data(fil);
filr=Range(fil);
% figure, plot(filr(2:end),d)
a=find(d<0);
da=diff(a);
peak_thresh=filr(a(find(da~=1,1,'first'))+1)*mX/15e4+mx;
peak_thresh_norm=filr(a(find(da~=1,1,'first'))+1);
sleepper=thresholdIntervals(smooth_ghi,peak_thresh,'Direction','Below');
sleepper=mergeCloseIntervals(sleepper,mindur*1e4);
sleepper=dropShortIntervals(sleepper,mindur*1e4);

figure(Gf), 
subplot(6,5,11:14)
imagesc(tB,fB,10*log10(SpB)'), axis xy, caxis([20 75]);
subplot(6,5,16:19), plot(Range(Restrict(smooth_ghi,sleepper),'s'),Data(Restrict(smooth_ghi,sleepper)),'r.');
        hold on, plot(Range(smooth_ghi,'s'),Data(smooth_ghi),'k','linewidth',2);  xlim([0,max(Range(smooth_ghi,'s'))]);
 
subplot(6,5,[15,20])
[Y,X]=hist(smooth_ghi_new_range,1000);
plot(X,Y,'linewidth',3)
       
% hold on, plot(X,smooth(Y',smo),'k'),plot(Range(fil),Data(fil),'r','linewidth',2)
        line([peak_thresh peak_thresh],[0 max(Y)],'linewidth',4,'color','r')



    

tep=Start(ThetaEpoch);
tep2=Stop(ThetaEpoch);
sep=Stop(sleepper);
for t=1:length(Start(ThetaEpoch))
    t1=ts(tep(t));
    t2=Restrict(t1,sleepper);
     if length(t2)~=0
         t3=tep2(t);
         [dur,num]=min(abs(sep-t3));
            if dur<5*1e4
                sep(num)=t3;
            end
     end
end
sleepper=intervalSet(Start(sleepper),sep);

sep=Start(sleepper);
for t=1:length(Start(ThetaEpoch))
    t1=ts(tep2(t));
    t2=Restrict(t1,sleepper);
     if length(t2)~=0
         t3=tep2(t);
         [dur,num]=min(abs(sep-t3));
            if dur<5*1e4
                sep(num)=t3;
            end
     end
end
sleepper=intervalSet(sep,Stop(sleepper));

wakeper=Epoch-sleepper;
wakeper=dropShortIntervals(wakeper,mindur*1e4); % wake per near noise
TotSleep=sleepper;
TotWake=wakeper;

mw_dur=5; %max length of microarousal
sl_dur=15; %min duration of sleep around microarousal
ms_dur=10; % max length of microsleep
wa_dur=20; %min duration of wake around microsleep

%we're going to presume that the noise during waking is waking so as to
%find microarousals etc
noiswakeper=TotalEpoch-sleepper; noiswakeper=CleanUpEpoch(noiswakeper);
noiswakeper=dropShortIntervals(noiswakeper,mindur*1e4); % wake per near noise
MicroWake=SandwichEpoch(noiswakeper,sleepper,mw_dur*1e4,sl_dur*1e4);
MicroSleep=SandwichEpoch(sleepper,noiswakeper,ms_dur*1e4,wa_dur*1e4);
noiswakeper=noiswakeper-MicroWake;
sleepper=sleepper-MicroSleep;
strWake=getshortintervals(noiswakeper,mw_dur*1e4);
strSleep=getshortintervals(sleepper,ms_dur*1e4);
MicroWake=MicroWake-NoiseEpoch-GndNoiseEpoch;
strWake=strWake-NoiseEpoch;
strWake=strWake-GndNoiseEpoch;
Wake=wakeper-strWake;
Wake=Wake-MicroWake;
Sleep=sleepper-strSleep;

REMEpoch=and(Sleep,ThetaEpoch);  
SWSEpoch=Sleep-REMEpoch;
[aft_cell,bef_cell]=transEpoch(wakeper,REMEpoch);
disp(strcat('wake to REM transitions :',num2str(size(start(aft_cell{1,2}),1))))



save('StateEpoch.mat','ThetaEpoch', 'ThetaRatioTSD','ThetaI','ThetaThresh','REMEpoch','SWSEpoch','peak_thresh','peak_thresh_norm','smooth_ghi','Sleep','Wake','strWake','strSleep','MicroSleep','MicroWake','-append');

[aft_cell,bef_cell]=transEpoch(Or(NoiseEpoch,GndNoiseEpoch),Sleep);
nsleep=And(aft_cell{1,2},bef_cell{1,2});
disp(strcat('noise periods during sleep :',num2str(size(start(nsleep)/1e4,1))))



[av(1),stan(1),tot(1)]=EpochInfo(SWSEpoch);
[av(2),stan(2),tot(2)]=EpochInfo(REMEpoch);
[av(3),stan(3),tot(3)]=EpochInfo(Wake);
[av(4),stan(4),tot(4)]=EpochInfo(MicroSleep);
[av(5),stan(5),tot(5)]=EpochInfo(strSleep);
[av(6),stan(6),tot(6)]=EpochInfo(MicroWake);
[av(7),stan(7),tot(7)]=EpochInfo(strWake);

figure(Gf)
subplot(6,5,26:27)
line([1 1], [0 tot(1)/1e4],'color',[0 0.2 0.8],'linewidth',25)
line([2 2], [0 tot(2)/1e4],'color',[0.8 0.2 0.1],'linewidth',25)
line([3 3], [0 tot(3)/1e4],'color',[0.2 0.2 0.2],'linewidth',25)
line([5 5], [0 tot(4)/1e4],'color',[0 0.2 0.8],'linewidth',25)
line([6 6], [0 tot(5)/1e4],'color',[0 0.2 0.8],'linewidth',25)
line([7 7], [0 tot(6)/1e4],'color',[0.2 0.2 0.2],'linewidth',25)
line([8 8], [0 tot(7)/1e4],'color',[0.2 0.2 0.2],'linewidth',25)
xlim([0 9])
set(gca,'XTick',[1:8],'XTickLabel',{'SWS','REM','Wake',' ', 'Msleep','Strsleep','MWake','StrWake'})
title('total duration')

subplot(6,5,29:30)
line([1 1], [0 av(1)],'color',[0 0.2 0.8],'linewidth',25)
hold on
errorbar(1,av(1),stan(1))
line([2 2], [0 av(2)],'color',[0.8 0.2 0.1],'linewidth',25)
errorbar(2,av(2),stan(2))
line([3 3], [0 av(3)],'color',[0.2 0.2 0.2],'linewidth',25)
errorbar(3,av(3),stan(3))
line([5 5], [0 av(4)],'color',[0 0.2 0.8],'linewidth',25)
errorbar(5,av(4),stan(4))
line([6 6], [0 av(5)],'color',[0 0.2 0.8],'linewidth',25)
errorbar(6,av(5),stan(5))
line([7 7], [0 av(6)],'color',[0.2 0.2 0.2],'linewidth',25)
errorbar(7,av(6),stan(6))
line([8 8], [0 av(7)],'color',[0.2 0.2 0.2],'linewidth',25)
errorbar(8,av(7),stan(7))
xlim([0 9])
set(gca,'XTick',[1:8],'XTickLabel',{'SWS','REM','Wake',' ', 'Msleep','Strsleep','MWake','StrWake'})
title('average Epoch duration')

subplot(6,5,21:24)
plot(Range(Restrict(LFP,SWSEpoch),'s'),Data(Restrict(LFP,SWSEpoch)),'color',[0 0.2 0.8])
hold on
plot(Range(Restrict(LFP,REMEpoch),'s'),Data(Restrict(LFP,REMEpoch)),'color',[0.8 0.2 0.1])
plot(Range(Restrict(LFP,Wake),'s'),Data(Restrict(LFP,Wake)),'color',[0.2 0.2 0.2])
plot(Range(Restrict(LFP,MicroSleep),'s'),Data(Restrict(LFP,MicroSleep)),'color',[0 0.2 0.8])
plot(Range(Restrict(LFP,strSleep),'s'),Data(Restrict(LFP,strSleep)),'color',[0 0.2 0.8])
plot(Range(Restrict(LFP,MicroWake),'s'),Data(Restrict(LFP,MicroWake)),'color',[0.2 0.2 0.2])
plot(Range(Restrict(LFP,strWake),'s'),Data(Restrict(LFP,strWake)),'color',[0.2 0.2 0.2])
xlim([0 r(end)/1e4])

saveas(Gf,'SleepScoring.fig')
saveas(Gf,'SleepScoring.png')


%     clear event1
%     beginning=Start(REMEpoch);
%     ending=Stop(REMEpoch);
%     
%     for i=1:length(start(REMEpoch))
%         event1.time(2*i-1)=beginning(i)/1e4;
%         event1.time(i*2)=ending(i)/1e4;
%         event1.description{2*i-1}='start';
%         event1.description{i*2}='stop';
%     end
%     try
%         SaveEvents(strcat('SleepPer.evt.R00'),event1)
%     end
%     
%         clear event1
%     beginning=Start(SWSEpoch);
%     ending=Stop(SWSEpoch);
%     
%     for i=1:length(start(SWSEpoch))
%         event1.time(2*i-1)=beginning(i)/1e4;
%         event1.time(i*2)=ending(i)/1e4;
%         event1.description{2*i-1}='start';
%         event1.description{i*2}='stop';
%     end
%     try
%         SaveEvents(strcat('SleepPer.evt.S00'),event1)
%     end
%     