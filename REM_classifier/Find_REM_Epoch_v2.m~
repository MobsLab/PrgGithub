function [REMEpoch2,tot_td,tot_ghi]=Find_REM_Epoch_v2(sptsdB,LFPH,SureSWS,GndNoiseEpoch,NoiseEpoch,fB)

    tB=Range(LFPH,'s');

TotalEpoch=intervalSet(tB(1)*1e4,1e4*tB(end));
Epoch=TotalEpoch-GndNoiseEpoch-NoiseEpoch;

SpectrB=Restrict(sptsdB,Epoch);
startg=find(fB<50,1,'last');
stopg=find(fB>70,1,'first');
a=Data(SpectrB);
tot_ghi=tsd(Range(Restrict(SpectrB,Epoch)),sum(a(:,startg:stopg)')');


pasTheta=100; %Down sampling for theta band

FilTheta=FilterLFP(LFPH,[5 10],1024);
FilDelta=FilterLFP(LFPH,[3 6],1024);
HilTheta=hilbert(Data(FilTheta));
HilDelta=hilbert(Data(FilDelta));
H=abs(HilDelta);
H(H<100)=100;
ThetaRatio=abs(HilTheta)./H;
rgThetaRatio=Range(FilTheta,'s');
ThetaRatio=Smooth(ThetaRatio,5000);
rgThetaRatio=rgThetaRatio;
tot_td=tsd(rgThetaRatio*1E4,ThetaRatio);
m=max((Data(Restrict(tot_td,SureSWS))));


tot_td=Restrict(tot_td,Epoch);
tot_ghi=Restrict(tot_ghi,Epoch);


% figure(1)
% plot(Range(Restrict(tot_ghi,Epoch)),Data(Restrict(tot_ghi,Epoch)),'b')
% figure(2)
% plot(Range(Restrict(tot_td,Epoch)),Data(Restrict(tot_td,Epoch)),'b')

NewEpoch=thresholdIntervals(tot_td,m);
% NewEpoch=mergeCloseIntervals(NewEpoch,1e5);
interEpoch=intervalSet(0,0);
for k=1:length(Start(NewEpoch))
    if abs(Start(subset(NewEpoch,k))-Stop(subset(NewEpoch,k)))>20000;
        interEpoch=or(interEpoch,subset(NewEpoch,k));
    end
end
mergeEpoch=interEpoch;



New_ghi_int=Restrict(tot_ghi,mergeEpoch);
% figure(1)
% hold on
% plot(Range(Restrict(New_ghi_int,Epoch)),Data(Restrict(New_ghi_int,Epoch)),'r')
% figure(2)
% hold on
% plot(Range(Restrict(tot_td,mergeEpoch)),Data(Restrict(tot_td,mergeEpoch)),'r')
Peaks=[];
Peaktd=[];
for k=1:length(start(mergeEpoch))
    data=smooth(Data(Restrict(New_ghi_int,subset(mergeEpoch,k))),500)';
    td=Range(Restrict(New_ghi_int,subset(mergeEpoch,k)))';
    
    de = diff(data);
    de1 = [de 0];
    de2 = [0 de];
    
    %finding peaks
    PeaksIdx = find(de1 < 0 & de2 > 0);
    
    Peaks = [Peaks data(PeaksIdx)];
    Peaktd=[Peaktd td(PeaksIdx)];
    
end
Peakstsd=tsd(Peaktd',Peaks');
peak_thresh=max((Data(Restrict(tot_ghi,SureSWS))));
Peaks_REM_tsd=tsd(Peaktd(Peaks<peak_thresh)',Peaks(Peaks<peak_thresh)');
MyRemEpoch=intervalSet(0,0);
for k=1:length(start(mergeEpoch))
    
    REMpeaks=size(Data(Restrict(Peaks_REM_tsd,subset(mergeEpoch,k))));
    Wakepeaks=size(Data(Restrict(Peakstsd,subset(mergeEpoch,k))))-size(Data(Restrict(Peaks_REM_tsd,subset(mergeEpoch,k))));
    if Wakepeaks<2
        MyRemEpoch=or(MyRemEpoch,subset(mergeEpoch,k));
    end
end
REMEpoch2=MyRemEpoch;
%       MyRemEpoch=mergeCloseIntervals(MyRemEpoch,5e5);
% REMEpoch2=intervalSet(0,0);
% 
% for k=1:length(start(MyRemEpoch))
%     if abs(start(subset(MyRemEpoch,k))-stop(subset(MyRemEpoch,k)))>20000;
%         REMEpoch2=or(REMEpoch2,subset(MyRemEpoch,k));
%     end
% end

% figure(1)
% hold on
% plot(Range(Restrict(New_ghi_int,REMEpoch2)),Data(Restrict(New_ghi_int,REMEpoch2))/2,'g')
% figure(2)
% hold on
% plot(Range(Restrict(tot_td,REMEpoch2)),Data(Restrict(tot_td,REMEpoch2))/2,'g')

% 
% figure(1)
% hold on
% plot(Range(Restrict(New_ghi_int,REMEpoch)),Data(Restrict(New_ghi_int,REMEpoch))/2-1000,'k')
% figure(2)
% hold on
% plot(Range(Restrict(tot_td,REMEpoch)),Data(Restrict(tot_td,REMEpoch))/2+30,'k')
k
end
