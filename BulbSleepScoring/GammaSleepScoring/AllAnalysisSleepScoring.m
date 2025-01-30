%% Sleep Scoring Analysis
clear all
%% Step 1 : give Data locations
struc={'B','H','Pi','PF','Pa','Amyg','EMG'};

filename{1,1}='/media/DataMOBSSlSc/SleepScoringMice/M60/20130415/';
filename{2,1}=[1,10,NaN,4,13,NaN,NaN];
filename{3,1}=[7,5,3,1,0];

filename{1,2}='/media/DataMOBSSlSc/SleepScoringMice/M82/20130730/';
filename{2,2}=[2,9,NaN,10,7,NaN,NaN];
filename{3,2}=[0,2,4,6,9];

filename{1,3}='/media/DataMOBSSlSc/SleepScoringMice/M83/20130802/';
filename{2,3}=[6,10,NaN,5,13,NaN,NaN];
filename{3,3}=[0,2,4,6];

filename{1,4}='/media/DataMOBSSlSc/SleepScoringMice/M123/31032014/';
filename{2,4}=[15,6,0,4,9,3,NaN];
filename{3,4}=[];

filename{1,5}='/media/DataMOBSSlSc/SleepScoringMice/M124/3103204/LPSD1-Mouse-124-31032014/';
filename{2,5}=[11,2,12,8,4,15,NaN];
filename{3,5}=[11,10];

filename{1,6}='/media/DataMOBSSlSc/SleepScoringMice/M147/';
filename{2,6}=[2,15,1,10,14,5,7];
filename{3,6}=[0,2,4];


filename{1,7}='/media/DataMOBSSlSc/SleepScoringMice/M148/20140828/';
filename{2,7}=[4,11,1,10,14,5,7];
filename{3,7}=[0,2,4];


% filename{1,4}='/media/DataMOBSSlSc/SleepScoringMice/M117/Sleep/';
% filename{2,3}=[5,7,NaN,NaN,NaN,NaN];



smootime=3;
for filenum=1:size(filename,2) 
    filenum
    %% Step 2 : Look at bimodality depending on various parameters
    % All structures, smoothing parameters + OB all channels
   Bimod_S_by_S(filename{1,filenum},filename{2,filenum},struc);
     Bimod_All_OB(filename{1,filenum},smootime,filename{3,filenum});
    %% Step 3 : transition periods
   % EpochTraj(filename{1,filenum});
end

%% COmpare multiple methods
mindur=3;
%% Look at EMG
for filenum=6:7
    cd(filename{1,filenum})
load(strcat('LFPData/LFP',num2str(filename{2,filenum}(end)),'.mat'));
load('StateEpochSB.mat')
load('EMGdata.mat')
% 
emgfigure=figure
% subplot(1,4,1:3)
% plot(Range(smooth_ghi,'s'),Data(smooth_ghi),'color',[0.6 0.6 0.6],'linewidth',2)
% hold on
% plot(Range(EMGsig,'s'),Data(EMGsig),'k','linewidth',2)
% plot([0:max(Range(EMGsig,'s'))],120,'r')
% plot([0:max(Range(EMGsig,'s'))],gamma_thresh,'b')
% subplot(1,4,4)
[y,x]=hist(log(Data(Restrict(EMGsig,Epoch))),500);
plot(x,smooth(y/sum(y),20),'k','linewidth',3); hold on,
[y,x]=hist(log(Data(Restrict(EMGsig,sleepper))),500);
plot(x,smooth(y/sum(y),20),'color',[144 238 144]/255,'linewidth',2);
[y,x]=hist(log(Data(Restrict(EMGsig,Wake))),500);
plot(x,smooth(y/sum(y),20),'color',[0.5 0.5 0.5],'linewidth',2);
saveFigure(emgfigure,'EMGvsOBbis',filename{1,filenum})
saveas(emgfigure,'EMGvsOBbis.fig')
% close all
% thresholds=[80:10:160];
% for th=1:length(thresholds)
% EMGthresh=thresholds(th);
% sleepperEMG=thresholdIntervals(EMGsig,EMGthresh,'Direction','Below');
% sleepperEMG=mergeCloseIntervals(sleepperEMG,mindur*1e4);
% sleepperEMG=dropShortIntervals(sleepperEMG,mindur*1e4);
% sleepperEMG=And(sleepperEMG,Epoch);sleepperEMG=CleanUpEpoch(sleepperEMG);
% sleepper=And(sleepper,Epoch);sleepper=CleanUpEpoch(sleepper);
% 
% % How much of what I say is SWS is EMG-identified as sleep?
% totdur=size(Data(Restrict(smooth_ghi,SWSEpoch)),1);
% tot=size(Data(Restrict(smooth_ghi,And(SWSEpoch,sleepperEMG))),1);
% compar{1}(th,filenum-5)=tot/totdur;
% % How much of what I say is REM is EMG-identified as sleep?
% totdur=size(Data(Restrict(smooth_ghi,REMEpoch)),1);
% tot=size(Data(Restrict(smooth_ghi,And(REMEpoch,sleepperEMG))),1);
% compar{2}(th,filenum-5)=tot/totdur;
% % How much of what EMG says is sleep is OB-identified as sleep?
% totdur=size(Data(Restrict(smooth_ghi,sleepperEMG)),1);
% tot=size(Data(Restrict(smooth_ghi,And(sleepper,sleepperEMG))),1);
% compar{3}(th,filenum-5)=tot/totdur;
% % Look at first and last 3 seconds of SWS
% StSWS=Start(SWSEpoch);
% StpSWS=Stop(SWSEpoch);
% SWSstartEp=intervalSet(StSWS,StSWS+5e4);SWSstartEp=CleanUpEpoch(And(SWSstartEp,SWSEpoch));
% SWSstopEp=intervalSet(StpSWS-5e4,StpSWS);SWSstopEp=CleanUpEpoch(And(SWSstopEp,SWSEpoch));
% totdur=size(Data(Restrict(smooth_ghi,SWSEpoch-sleepperEMG)),1);
% tot=size(Data(Restrict(smooth_ghi,CleanUpEpoch(And(SWSstartEp,SWSEpoch-sleepperEMG)))),1);
% compar{4}(th,filenum-5)=tot/totdur;
% tot=size(Data(Restrict(smooth_ghi,CleanUpEpoch(And(SWSstopEp,SWSEpoch-sleepperEMG)))),1);
% compar{5}(th,filenum-5)=tot/totdur;
% tot=size(Data(Restrict(smooth_ghi,CleanUpEpoch(And(SWSEpoch-DropShortIntervals(SWSEpoch,5*1e4),SWSEpoch-sleepperEMG)))),1);
% compar{6}(th,filenum-5)=tot/totdur;
% % Look at first and last 3 seconds of REM
% StSWS=Start(REMEpoch);
% StpSWS=Stop(REMEpoch);
% SWSstartEp=intervalSet(StSWS,StSWS+5e4);SWSstartEp=CleanUpEpoch(And(SWSstartEp,REMEpoch));
% SWSstopEp=intervalSet(StpSWS-5e4,StpSWS);SWSstopEp=CleanUpEpoch(And(SWSstopEp,REMEpoch));
% totdur=size(Data(Restrict(smooth_ghi,REMEpoch-sleepperEMG)),1);
% tot=size(Data(Restrict(smooth_ghi,CleanUpEpoch(And(SWSstartEp,REMEpoch-sleepperEMG)))),1);
% compar{7}(th,filenum-5)=tot/totdur;
% tot=size(Data(Restrict(smooth_ghi,CleanUpEpoch(And(SWSstopEp,REMEpoch-sleepperEMG)))),1);
% compar{8}(th,filenum-5)=tot/totdur;
% tot=size(Data(Restrict(smooth_ghi,CleanUpEpoch(And(REMEpoch-DropShortIntervals(REMEpoch,5*1e4),REMEpoch-sleepperEMG)))),1);
% compar{9}(th,filenum-5)=tot/totdur;
% % How much of what EMG says is sleep is OB-identified as sleep?
% StSWS=Start(sleepperEMG);
% StpSWS=Stop(sleepperEMG);
% SWSstartEp=intervalSet(StSWS,StSWS+5e4);SWSstartEp=CleanUpEpoch(And(SWSstartEp,sleepperEMG));
% SWSstopEp=intervalSet(StpSWS-5e4,StpSWS);SWSstopEp=CleanUpEpoch(And(SWSstopEp,sleepperEMG));
% totdur=size(Data(Restrict(smooth_ghi,sleepperEMG-sleepper)),1);
% tot=size(Data(Restrict(smooth_ghi,And(SWSstartEp,sleepperEMG-sleepper))),1);
% compar{10}(th,filenum-5)=tot/totdur;
% tot=size(Data(Restrict(smooth_ghi,And(SWSstopEp,sleepperEMG-sleepper))),1);
% compar{11}(th,filenum-5)=tot/totdur;
% tot=size(Data(Restrict(smooth_ghi,CleanUpEpoch(And(sleepperEMG-DropShortIntervals(sleepperEMG,5*1e4),sleepperEMG-sleepper)))),1);
% compar{12}(th,filenum-5)=tot/totdur;
% 
% end
meanEMG(1,filenum-5)=mean(Data(Restrict(EMGsig,sleepper)));
meanEMG(2,filenum-5)=mean(Data(Restrict(EMGsig,Wake)));

end
PlotErrorBarN([(meanEMG(:,1))';(meanEMG(:,2))'])


mindur=3;
th=1;
clear comparbis
%% Look at imdiff
for filenum=1:5
    filenum
    cd(filename{1,filenum})
load(strcat('LFPData/LFP',num2str(filename{2,filenum}(1)),'.mat'));
load('StateEpoch.mat')
load('StateEpochSB.mat')

% How much of what I say is SWS is EMG-identified as sleep?
totdur=size(Data(Restrict(smooth_ghi,SWSEpoch)),1);
tot=size(Data(Restrict(smooth_ghi,And(SWSEpoch,ImmobEpoch))),1);
comparbis{1}(th,filenum)=tot/totdur;
% How much of what I say is REM is EMG-identified as sleep?
totdur=size(Data(Restrict(smooth_ghi,REMEpoch)),1);
tot=size(Data(Restrict(smooth_ghi,And(REMEpoch,ImmobEpoch))),1);
comparbis{2}(th,filenum)=tot/totdur;
% How much of what EMG says is sleep is OB-identified as sleep?
totdur=size(Data(Restrict(smooth_ghi,ImmobEpoch)),1);
tot=size(Data(Restrict(smooth_ghi,And(sleepper,ImmobEpoch))),1);
comparbis{3}(th,filenum)=tot/totdur;
% Look at first and last 3 seconds of SWS
StSWS=Start(SWSEpoch);
StpSWS=Stop(SWSEpoch);
SWSstartEp=intervalSet(StSWS,StSWS+5e4);SWSstartEp=CleanUpEpoch(And(SWSstartEp,SWSEpoch));
SWSstopEp=intervalSet(StpSWS-5e4,StpSWS);SWSstopEp=CleanUpEpoch(And(SWSstopEp,SWSEpoch));
totdur=size(Data(Restrict(smooth_ghi,SWSEpoch-ImmobEpoch)),1);
tot=size(Data(Restrict(smooth_ghi,CleanUpEpoch(And(SWSstartEp,SWSEpoch-ImmobEpoch)))),1);
comparbis{4}(th,filenum)=tot/totdur;
tot=size(Data(Restrict(smooth_ghi,CleanUpEpoch(And(SWSstopEp,SWSEpoch-ImmobEpoch)))),1);
comparbis{5}(th,filenum)=tot/totdur;
tot=size(Data(Restrict(smooth_ghi,CleanUpEpoch(And(SWSEpoch-DropShortIntervals(SWSEpoch,5*1e4),SWSEpoch-ImmobEpoch)))),1);
comparbis{6}(th,filenum)=tot/totdur;
% Look at first and last 3 seconds of REM
StSWS=Start(REMEpoch);
StpSWS=Stop(REMEpoch);
SWSstartEp=intervalSet(StSWS,StSWS+5e4);SWSstartEp=CleanUpEpoch(And(SWSstartEp,REMEpoch));
SWSstopEp=intervalSet(StpSWS-5e4,StpSWS);SWSstopEp=CleanUpEpoch(And(SWSstopEp,REMEpoch));
totdur=size(Data(Restrict(smooth_ghi,REMEpoch-ImmobEpoch)),1);
tot=size(Data(Restrict(smooth_ghi,CleanUpEpoch(And(SWSstartEp,REMEpoch-ImmobEpoch)))),1);
comparbis{7}(th,filenum)=tot/totdur;
tot=size(Data(Restrict(smooth_ghi,CleanUpEpoch(And(SWSstopEp,REMEpoch-ImmobEpoch)))),1);
comparbis{8}(th,filenum)=tot/totdur;
tot=size(Data(Restrict(smooth_ghi,CleanUpEpoch(And(REMEpoch-DropShortIntervals(REMEpoch,5*1e4),REMEpoch-ImmobEpoch)))),1);
comparbis{9}(th,filenum)=tot/totdur;
% How much of what EMG says is sleep is OB-identified as sleep?
StSWS=Start(ImmobEpoch);
StpSWS=Stop(ImmobEpoch);
SWSstartEp=intervalSet(StSWS,StSWS+5e4);SWSstartEp=CleanUpEpoch(And(SWSstartEp,ImmobEpoch));
SWSstopEp=intervalSet(StpSWS-5e4,StpSWS);SWSstopEp=CleanUpEpoch(And(SWSstopEp,ImmobEpoch));
totdur=size(Data(Restrict(smooth_ghi,ImmobEpoch-sleepper)),1);
tot=size(Data(Restrict(smooth_ghi,And(SWSstartEp,ImmobEpoch-sleepper))),1);
comparbis{10}(th,filenum)=tot/totdur;
tot=size(Data(Restrict(smooth_ghi,And(SWSstopEp,ImmobEpoch-sleepper))),1);
comparbis{11}(th,filenum)=tot/totdur;
tot=size(Data(Restrict(smooth_ghi,CleanUpEpoch(And(ImmobEpoch-DropShortIntervals(ImmobEpoch,5*1e4),ImmobEpoch-sleepper)))),1);
comparbis{12}(th,filenum)=tot/totdur;

end
cd('/media/DataMOBSSlSc/SleepScoringMice/Figures/')
save('comparmethods.mat','compar','comparbis','meanEMG')

figure %piecharts
subplot(2,3,1)
pie([nanmean(nanmean(compar{1}(3:7,:))) 1-nanmean(nanmean(compar{1}(3:7,:)))])
subplot(2,3,2)
pie([nanmean(nanmean(compar{2}(3:7,:))) 1-nanmean(nanmean(compar{2}(3:7,:)))])
subplot(2,3,3)
pie([nanmean(nanmean(compar{3}(3:7,:))) 1-nanmean(nanmean(compar{3}(3:7,:)))])
colormap summer

subplot(2,3,4)
pie([nanmean(nanmean(comparbis{1}(1,:))) 1-nanmean(nanmean(comparbis{1}(1,:)))])
subplot(2,3,5)
pie([nanmean(nanmean(comparbis{2}(1,:))) 1-nanmean(nanmean(comparbis{2}(1,:)))])
subplot(2,3,6)
pie([nanmean(nanmean(comparbis{3}(1,:))) 1-nanmean(nanmean(comparbis{3}(1,:)))])
colormap summer
saveas(7,'PiechartFig.fig')
saveas(7,'PiechartFig.png')

figure
for k=4:3:10
subplot(1,3,(k-1)/3)
    pie([nanmean(nanmean(compar{k}(3:7,:))) nanmean(nanmean(compar{k+1}(3:7,:))) nanmean(nanmean(compar{k+2}(3:7,:))) 1-sum([nanmean(nanmean(compar{k}(3:7,:))),nanmean(nanmean(compar{k+1}(3:7,:))),nanmean(nanmean(compar{k+2}(3:7,:)))])])
    if k==4
       legend('Beginning','End','Short','Remainder') 
    end
end
colormap summer

figure
for k=4:3:10
subplot(1,3,(k-1)/3)
    pie([nanmean(nanmean(comparbis{k}(1,:))) nanmean(nanmean(comparbis{k+1}(1,:))) nanmean(nanmean(comparbis{k+2}(1,:))) 1-sum([nanmean(nanmean(comparbis{k}(1,:))),nanmean(nanmean(comparbis{k+1}(1,:))),nanmean(nanmean(comparbis{k+2}(1,:)))])])
    if k==4
       legend('Beginning','End','Short','Remainder') 
    end
end
colormap summer

clf
for filenum=6:7
    cd(filename{1,filenum})
    load('StateEpochSB.mat')
    load('EMGdata.mat')
    figure
    subplot(4,4,[1,5,9])
    [theText, rawN, x] =nhist(log(Data(Restrict(EMGsig,Epoch))),'maxx',max(log(Data(Restrict(EMGsig,Epoch)))),'noerror','xlabel','EMG power','ylabel',[]); axis xy
    view(90,-90)
    subplot(4,4,[14:16])
    [theText, rawN, x] =nhist(log(Data(Restrict(smooth_ghi,Epoch))),'maxx',max(log(Data(Restrict(smooth_ghi,Epoch)))),'noerror','xlabel','Gamma Power','ylabel',[]); axis xy
    subplot(4,4,[2:4,6:8,10:12])
     x=Data(smooth_ghi);
 y=Data(EMGsig);
 plot(log(x(1:1000:end)),log(y(1:1000:end)),'.k','MarkerSize',1)
 hold on,line([log(gamma_thresh),log(gamma_thresh)],[ylim],'color','r','linewidth',3)
 hold on,line([xlim],[log(130),log(130)],'color','r','linewidth',3)
end

    
plot(Range(smooth_ghi,'s'),Data(smooth_ghi),'color',[0.6 0.6 0.6],'linewidth',2)
hold on
plot(Range(EMGsig,'s'),Data(EMGsig),'k','linewidth',2)
plot([0:max(Range(EMGsig,'s'))],120,'r')
plot([0:max(Range(EMGsig,'s'))],gamma_thresh,'b')
plot(totim_diff(:,1),totim_diff(:,2)*500+1500,'r')


figure
for filenum=6:7
    cd(filename{1,filenum})
load(strcat('LFPData/LFP',num2str(filename{2,filenum}(end)),'.mat'));
load('StateEpochSB.mat')
load('EMGdata.mat')

 x=Data(smooth_ghi);
 y=Data(EMGsig);
 subplot(1,2,filenum-5)
 plot(log(x(1:1000:end)),log(y(1:1000:end)),'.k','MarkerSize',1)
 hold on,line([log(gamma_thresh),log(gamma_thresh)],[ylim],'color','r','linewidth',3)
 hold on,line([xlim],[log(130),log(130)],'color','r','linewidth',3)
 title(num2str([sum(x<gamma_thresh&y<130)/length(x), sum(x<gamma_thresh&y>130)/length(x), sum(x>gamma_thresh&y<130)/length(x),sum(x>gamma_thresh&y>130)/length(x)]))
end

%% combine data about bimodality in various structures

overlap=cell(1,7);
ashman=cell(1,7);
smrange=[0.1,0.2,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5];
x=smrange;
limfit=0.9;
for filenum=1:7
      cd(filename{1,filenum})
       load('AllStrucBimod.mat') 
       for s=1:7
           for i=1:length(smfact)
               intvar1(i)=dist{s,i}(1,3);
               intvar2(i)=dist{s,i}(1,4);
               goosdift(i)=rms{s,i}(1,4);

           end
           overlap{1,filenum}(s,:)=intvar1(goodfit>limfit);
           ashman{1,filenum}(s,:)=intvar2(goodfit>limfit);
       end
end
           
           
%% Compare sleep to wake transition times
dt=8*1e-4;
for filenum=1:7
          cd(filename{1,filenum})
load('Trajectories.mat')
    TotDelta{1,1}(filenum,1)=nanmean(delta{1,1});
    TotDelta{1,2}(filenum,1)=nanmean(delta{1,2});
    TotDelta{2,1}(filenum,1)=nanmean(delta{2,1});
    TotDelta{2,2}(filenum,1)=nanmean(delta{2,2});
    TotDelta{3,1}(filenum,1)=nanmean(delta{3,1});
    TotDelta{1,1}(filenum,2)=nanmedian(delta{1,1});
    TotDelta{1,2}(filenum,2)=nanmedian(delta{1,2});
    TotDelta{2,1}(filenum,2)=nanmedian(delta{2,1});
    TotDelta{2,2}(filenum,2)=nanmedian(delta{2,2});
    TotDelta{3,1}(filenum,2)=nanmedian(delta{3,1});
    
    AvTrajG{2,1}(filenum,:)=nanmean(gam{2}{1}(good{2,1},:));
    AvTrajG{2,2}(filenum,:)=nanmean(gam{2}{2}(good{2,2},:));
    AvTrajG{3,1}(filenum,:)=nanmean(gam{3}{1}(good{3,1},:));

    AvTrajT{1,1}(filenum,:)=nanmean(thet{1}{1}(good{1,1},:));
    AvTrajT{1,2}(filenum,:)=nanmean(thet{1}{2}(good{1,2},:));

end

figure
subplot(1,2,1)
PlotErrorBarN([TotDelta{2,1}(:,1), TotDelta{2,2}(:,1),TotDelta{3,1}(:,1)]*dt,0,1,'ranksum',2)
subplot(1,2,2)
plot(timeaxis,nanmean(log(AvTrajG{2,1})),'k','linewidth',2)
hold on
plot(timeaxis,fliplr(nanmean(log(AvTrajG{2,2}))),'r','linewidth',2)
plot(timeaxis,(nanmean(log(AvTrajG{3,1}))),'B','linewidth',2)


figure
subplot(1,2,1)
PlotErrorBarN([TotDelta{1,1}(:,1), TotDelta{1,2}(:,1)],0,1)
subplot(1,2,2)
plot(timeaxis,nanmean(log(AvTrajT{1,1})),'k','linewidth',2)
hold on
plot(timeaxis,fliplr(nanmean(log(AvTrajT{1,2}))),'r','linewidth',2)



%% Get im_diff all together
 load('/media/DataMOBSSlSc/SleepScoringMice/M147/video/BULB-Mouse147-148-04082014-01-to-04-RestImdiff.mat')
 totim_diff=[im_diff(:,1)/2,im_diff(:,2)];
 totend=max(totim_diff(:,1));
 load('/media/DataMOBSSlSc/SleepScoringMice/M147/video/BULB-Mouse147-148-04082014-05-to-08-RestImdiff.mat')
 totim_diff=[[totim_diff(:,1);im_diff(:,1)/2+totend],[totim_diff(:,2);im_diff(:,2)]];
 totend=max(totim_diff(:,1));
load('/media/DataMOBSSlSc/SleepScoringMice/M147/video/BULB-Mouse147-148-04082014-09-to-13-RestImdiff.mat')
 totim_diff=[[totim_diff(:,1);im_diff(:,1)/2+totend],[totim_diff(:,2);im_diff(:,2)]];
 totend=max(totim_diff(:,1));
load('/media/DataMOBSSlSc/SleepScoringMice/M147/video/BULB-Mouse147-148-04082014-14-to-17-RestImdiff.mat')
 totim_diff=[[totim_diff(:,1);im_diff(:,1)/2+totend],[totim_diff(:,2);im_diff(:,2)]];
 totend=max(totim_diff(:,1));
 
 %% Look at speed in different phase space regions
 size_occ=100; 
 totsp_occ=zeros(size_occ,size_occ);
totsp_lfp_occ=zeros(size_occ,size_occ);
 inpercent=[0:0.05:1];
 splfp=figure;
clear Cont
 for filenum=1:7
     filenum
      cd(filename{1,filenum})
     load('StateEpochSB.mat')
     t=Range(smooth_Theta);
     ti=t(5:50:end);
     time=ts(ti);
     theta_new=Restrict(smooth_Theta,time);
     ghi_new=Restrict(smooth_ghi,time);
     ghi_new=tsd(Range(theta_new),Data(ghi_new));
     ghi_new=tsd(Range(ghi_new),log(Data(ghi_new))-nanmean(log(Data(Restrict(ghi_new,SWSEpoch)))));
     theta_new=tsd(Range(theta_new),log(Data(theta_new))-nanmean(log(Data(Restrict(theta_new,SWSEpoch)))));
     TotalEpoch=intervalSet(0,max(ti))-NoiseEpoch-GndNoiseEpoch;
     try
         load('behavRousources.mat','PreEpoch')
         TotalEpoch=And(TotalEpoch,PreEpoch);
     end
     
     
     Epoch3{1}=SWSEpoch;
     Epoch3{2}=REMEpoch;
     Epoch3{3}=Wake;
     %  Get the contours and concentric regions
     for k=1:3
         
         
         intdat_g=Data(Restrict(ghi_new,Epoch3{k}));
         intdat_t=Data(Restrict(theta_new,ts(Range(Restrict(ghi_new,Epoch3{k})))));
         cent=[nanmean(intdat_g),nanmean(intdat_t)];
         distances=(intdat_g-cent(1)).^2/nanmean((intdat_g-cent(1)).^2)+(intdat_t-cent(2)).^2/nanmean((intdat_t-cent(2)).^2);
         dist=tsd(Range(Restrict(ghi_new,Epoch3{k})),distances);
         for i=1:length(inpercent)
             threshold=percentile(distances,inpercent(i));
             SubEpochC{k,i}=thresholdIntervals(dist,threshold,'Direction','Below');
         end
         distances=intdat_g-cent(1);
         dist=tsd(Range(Restrict(ghi_new,Epoch3{k})),distances);
         for i=1:length(inpercent)
             threshold=percentile(distances,inpercent(i));
             SubEpochLG{k,i}=thresholdIntervals(dist,threshold,'Direction','Below');
         end
         distances=intdat_t-cent(2);
         dist=tsd(Range(Restrict(theta_new,Epoch3{k})),distances);
         for i=1:length(inpercent)
             threshold=percentile(distances,inpercent(i));
             SubEpochLT{k,i}=thresholdIntervals(dist,threshold,'Direction','Below');
         end
         intdat_g=Data(Restrict(ghi_new,And(Epoch3{k},SubEpochC{k,length(inpercent)-4})));
         intdat_t=Data(Restrict(theta_new,ts(Range(Restrict(ghi_new,And(Epoch3{k},SubEpochC{k,length(inpercent)-4}))))));
         K=convhull(intdat_g,intdat_t);
         Cont{filenum,k}(1,:)=intdat_g(K);
         Cont{filenum,k}(2,:)=intdat_t(K);
         
     end
     
     %% Weighted by LFP speed
     % 2d plot
%      speed=([0; Data(ghi_new)]-[Data(ghi_new); 0]).^2+([0; Data(theta_new)]-[Data(theta_new); 0]).^2;
%      speed=[NaN;speed(2:end-1)];

clear speed2
for l=5:5:45     
t=Range(smooth_Theta);
     ti=t(5+l:50:end);
     time=ts(ti);
     theta_new=Restrict(smooth_Theta,time);
     ghi_new=Restrict(smooth_ghi,time);
     ghi_new=tsd(Range(theta_new),Data(ghi_new));
     ghi_new=tsd(Range(ghi_new),log(Data(ghi_new))-nanmean(log(Data(Restrict(ghi_new,SWSEpoch)))));
     theta_new=tsd(Range(theta_new),log(Data(theta_new))-nanmean(log(Data(Restrict(theta_new,SWSEpoch)))));
     speed2{l/5}=([0; Data(ghi_new)]-[Data(ghi_new); 0]).^2+([0; Data(theta_new)]-[Data(theta_new); 0]).^2;
       speed2{l/5}=[NaN; speed2{l/5}(2:end-1)];
end
for l=1:9
    b(l)=size(speed2{l},1);
end
clear speed
for l=1:9
    speed(l,:)=speed2{l}(1:min(b));
end
speed=nanmedian(speed);
speed=speed(1:length(Range(ghi_new)));

     LFP_speed=tsd(Range(ghi_new),speed');
     [sp_LFP_occ,x,y] = weight2d(Data(ghi_new),Data(theta_new),size_occ,size_occ,Data(LFP_speed),[-0.5,2.7;-1,2]);
     sp_LFP_occ(isnan(sp_LFP_occ))=0;
     for k=1:100
         sp_LFP_occ(k,:)=runmean(sp_LFP_occ(k,:),2);
     end
     for k=1:100
         sp_LFP_occ(:,k)=runmean(sp_LFP_occ(:,k),2);
     end
    
     
     for k=1:100
         sp_LFP_occ(k,:)=runmean(sp_LFP_occ(k,:),2);
     end
     for k=1:100
         sp_LFP_occ(:,k)=runmean(sp_LFP_occ(:,k),2);
     end
     
     subplot(2,4,filenum)
     imagesc(x,y,(sp_LFP_occ)'), axis xy
     colormap jet
     if filenum>2
     totsp_lfp_occ=totsp_lfp_occ+sp_LFP_occ/sum(sum(sp_LFP_occ));
     end
     % regions around centre
     for k=1:3
         for i=2:length(inpercent)
             speed_LFP_regional{filenum}(k,i)=nanmedian(Data(Restrict(LFP_speed,SubEpochC{k,i}-SubEpochC{k,i-1})));
             speed_LFP_regional{filenum}(k+3,i)=nanmedian(Data(Restrict(LFP_speed,SubEpochLG{k,i}-SubEpochLG{k,i-1})));
             speed_LFP_regional{filenum}(k+6,i)=nanmedian(Data(Restrict(LFP_speed,SubEpochLT{k,i}-SubEpochLT{k,i-1})));
         end
     end
 end
 subplot(2,4,8)
imagesc(x,y,(totsp_lfp_occ)'), axis xy
colormap jet

figure
for L=1:9
    subplot(3,3,L)
    for k=1:7
int(k,:)=speed_LFP_regional{k}(L,:);
end

plot(zscore(int(:,2:end)'))
hold on
plot(nanmean(zscore(int(:,2:end)')'),'linewidth',3)

end