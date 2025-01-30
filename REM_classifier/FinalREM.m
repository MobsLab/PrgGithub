%load Bulb Spectrum
% load LFPH --> for theta
% create sptsd
%load StateEpoch

% clear all 
% close all
% load('SpectrumREM_bulb_high.mat')
% load('StateEpoch.mat')
% fB=f;
% try 
% sptsd=tsd(t*10000,Sp);
% catch
% sptsd=tsd(t*10000,Sp2);
% end
% 
% TotalEpoch=intervalSet(t(1)*1e4,1e4*t(end));
% Epoch=TotalEpoch-GndNoiseEpoch-NoiseEpoch;
% 
% Spectr=Restrict(sptsd,Epoch);
% startg=find(fB<50,1,'last');
% stopg=find(fB>70,1,'first');
% a=Data(Spectr);
% 
% tot_ghi=tsd(Range(Restrict(Spectr,Epoch)),sum(a(:,startg:stopg)')');
% 
% tot_ghi=Restrict(tot_ghi,Epoch);
% smooth_ghi=tsd(Range(tot_ghi),smooth(Data(tot_ghi),500));
% 
% Peaks=[];
% Peaktd=[];
% for k=1:length(Start(Epoch))
%     data=smooth(Data(Restrict(smooth_ghi,subset(Epoch,k))),500)';
%     td=Range(Restrict(smooth_ghi,subset(Epoch,k)))';
%     
%     de = diff(data);
%     de1 = [de 0];
%     de2 = [0 de];
%     
%     %finding peaks
%     PeaksIdx = find(de1 < 0 & de2 > 0);
%     
%     Peaks = [Peaks data(PeaksIdx)];
%     Peaktd=[Peaktd td(PeaksIdx)];
%     
% end
% Peakstsd=tsd(Peaktd',Peaks');
% 
% % y=75000;
% % y=120000;
% % peak_thresh=y;
% Peaks_REM_tsd=tsd(Peaktd(Peaks<peak_thresh)',Peaks(Peaks<peak_thresh)');
% Peaks_wake_tsd=tsd(Peaktd(Peaks>peak_thresh)',Peaks(Peaks>peak_thresh)');
% 
% Peaktd(2,:)=Peaks>peak_thresh;
% actval=Peaktd(2,1);
% if actval==1
%     startwake=Peaktd(1,1);
%     wakenum=1;
% else startsleep=Peaktd(1,1);
%      lastsleep=0;
%  wakenum=0;
% end
%  sleepper=intervalSet(0,0);
%  wakeper=intervalSet(0,0);
% Epochbeg=Start(Epoch);
% Epochend=End(Epoch);
% for k=2:length(Peaktd)
%  a=find(Epochend>Peaktd(1,k),1,'first');
% 
%     if actval==1
%         if Peaktd(2,k)==1
%             lastwake=Peaktd(1,k);
%             wakenum=wakenum+1;
%             actval=1;
%         else
%             wakeper=Or(wakeper,intervalSet(startwake,Peaktd(1,k)));
%             startsleep=Peaktd(1,k);
%             lastsleep=Peaktd(1,k);
%             actval=0;
%         end
%     else
%         if Peaktd(2,k)==0
%             lastsleep=Peaktd(1,k);
%                             actval=0;
%         else
%             
%             if abs(min(lastsleep-startsleep,lastsleep-Epochbeg(a))) > 2*1e4
%                 sleepper=Or(sleepper,intervalSet(startsleep,lastsleep));
%                 wakenum=1;
%                 startwake=Peaktd(1,k);
%                                actval=1;
% 
%             else
%                wakeper=Or(wakeper,intervalSet(startsleep,Peaktd(1,k)));
%                wakenum=wakenum+1;
%                startwake=startsleep;
%                lastwake=Peaktd(1,k);
%                actval=1;
%             end
%         end
%     end
% end


% 51
channels=[18,19,17,29,30,31,24,25,26,23,27,28,13,2,6,0,11];
RequiredStdFactorTab=[1,1.5,2.5,3];
for RequiredStdFactor=RequiredStdFactorTab
    mkdir(strcat('BULB-Mouse-51-10012013_',num2str(RequiredStdFactor)))
for c=1:length(channels)
load(strcat('/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013/LFPData/LFP',num2str(channels(c)),'.mat'))

LFPH=ResampleTSD(LFP,250);
t=Range(LFPH,'s');

TotalEpoch=intervalSet(t(1)*1e4,1e4*t(end));
Epoch=TotalEpoch-GndNoiseEpoch-NoiseEpoch;

pasTheta=100; %Down sampling for theta band
        ThetaI=[10 15];

FilTheta=FilterLFP(LFPH,[5 10],1024);
FilDelta=FilterLFP(LFPH,[3 6],1024);
HilTheta=hilbert(Data(FilTheta));
HilDelta=hilbert(Data(FilDelta));
H=abs(HilDelta);
H(H<100)=100;
ThetaRatio=abs(HilTheta)./H;
rgThetaRatio=Range(FilTheta,'s');

ThetaRatio=SmoothDec(ThetaRatio(1:pasTheta:end),50);
rgThetaRatio=rgThetaRatio(1:pasTheta:end);
ThetaRatioTSD=tsd(rgThetaRatio*1E4,ThetaRatio);
ThetaThresh=mean(Data(ThetaRatioTSD))+RequiredStdFactor*std(Data(ThetaRatioTSD));
ThetaEpoch=thresholdIntervals(ThetaRatioTSD,ThetaThresh,'Direction','Above');
ThetaEpoch=mergeCloseIntervals(ThetaEpoch,ThetaI(1)*1E4);
ThetaEpoch=dropShortIntervals(ThetaEpoch,ThetaI(2)*1E4);

% ThetaRatio=Smooth(ThetaRatio,5000);
% rgThetaRatio=rgThetaRatio;
% tot_td=tsd(rgThetaRatio*1E4,ThetaRatio);
% tot_td=Restrict(tot_td,Epoch);
% m=mean(Data(tot_td));
% s=std(Data(tot_td));
% NewEpoch=thresholdIntervals(tot_td,m+1.5*s);
% NewEpoch=mergeCloseIntervals(NewEpoch,5e4);
% interEpoch=intervalSet(0,0);
% for k=1:length(Start(NewEpoch))
%     if abs(Start(subset(NewEpoch,k))-Stop(subset(NewEpoch,k)))>20000;
%         interEpoch=or(interEpoch,subset(NewEpoch,k));
%     end
% end
% thetaEpoch=interEpoch;



    MyREMEpoch=and(thetaEpoch,sleepper);
    
  clear event1
                beginning=Start(sleepper);
                ending=Stop(sleepper);
                
                for i=1:length(start(sleepper))
                    event1.time(2*i-1)=beginning(i)/1e4;
                    event1.time(i*2)=ending(i)/1e4;
                    event1.description{2*i-1}='start';
                    event1.description{i*2}='stop';
                end
                try
                SaveEvents(strcat('SleepPer.evt.f09'),event1)
                end
%                 SaveEvents(strcat('/media/USBDisk1/REM/BULB-Mouse-51-10012013_bis/LocalREM.evt.Rma'),event1)
                
    save(strcat('/media/USBDisk1/REM/BULB-Mouse-51-10012013_',num2str(RequiredStdFactor),'/LocalREM-', num2str(channels(c))),'MyREMEpoch');
                end
end
end

% inarow=2;
% suite=1;
% change=0;
% sleepper=intervalSet(0,0);
% wakeper=intervalSet(0,0);
% clear init endit
% % 1 is wake, 0 is sleep
% for k=2:length(Peaktd)
%     
%     if actval==Peaktd(2,k)
%         suite=suite+1;
%         change=0;
%         if suite==inarow;
%             init=Peaktd(1,k-inarow+1);
%         end
%     else
%         change=change+1;
%         if change==inarow
%             suite=inarow;
%             endit=Peaktd(1,k-inarow);
%             if actval==0
%                 sleepper=Or(sleepper,intervalSet(init,endit));
%             elseif actval==1
%                 wakeper=OR(wakeper,intervalSet(init,endit));
%             end
%             actval=Peaktd(2,k);
%             init=Peaktd(1,k-inarow+1);
%             change=0;
%         end
%     end
% %     keyboard
% end
% 

