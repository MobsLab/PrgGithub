function DeltaRhythmsModulationSleep(struct,crossco,detail)

res=pwd;
load([res,'/newDelta',struct])
smo=2;

figure, hist(tDelta,1000)
title([struct,'delta occurence across all recording time'])

%--------------------------------------------------------------------------
% Delta during all SWS, and between begin/end of SWS
%--------------------------------------------------------------------------
% compared Delta AutoCorrelograms
num=2000;
tot=length(tDelta);
sbin=80;
nbin=200;
smo=1;

[C,B]=CrossCorr(tDelta,tDelta,sbin,nbin); C(B==0)=0;
a=mean(C)+1.5*std(C);
RhythmEpochs=thresholdIntervals(tsd(B/1E3,C),a,'Direction','Above');
RhythmTime=Start(RhythmEpochs)+(End(RhythmEpochs)-Start(RhythmEpochs))/2;
figure, subplot(2,1,1)
hold on, plot(B/1E3,smooth(C,smo))
%hold on, plot(RhythmTime,0.9,'ko','markerfacecolor','b')
%hold on, line([-8 8],[a a]);
hold on, title([struct,' Delta - all SWS epoch'])

[C1,B1]=CrossCorr(tDelta(1:num),tDelta(1:num),sbin,nbin); C1(B1==0)=0;
a1=mean(C1)+1.5*std(C1);
RhythmEpochs1=thresholdIntervals(tsd(B1/1E3,C1),a1,'Direction','Above');
RhythmTime1=Start(RhythmEpochs1)+(End(RhythmEpochs1)-Start(RhythmEpochs1))/2;

[C2,B2]=CrossCorr(tDelta(tot-num:tot),tDelta(tot-num:tot),sbin,nbin); C2(B2==0)=0;
a2=mean(C2)+1.5*std(C2);
RhythmEpochs2=thresholdIntervals(tsd(B2/1E3,C2),a2,'Direction','Above');
RhythmTime2=Start(RhythmEpochs2)+(End(RhythmEpochs2)-Start(RhythmEpochs2))/2;

hold on, subplot(2,1,2)
hold on, plot(B1/1E3,smooth(C1,smo),'k'), hold on, plot(B2/1E3,smooth(C2,smo),'r')
hold on, title(['nDelta=',num2str(num),' - SWS begin(k) vs SWS end(r)'])
%hold on, line([-8 8],[a1 a1])
%hold on, line([-8 8],[a2 a2])
%hold on, plot(RhythmTime1,a1,'ko','markerfacecolor','k')
%hold on, plot(RhythmTime2,a2,'ko','markerfacecolor','r')

% Ctsd=tsd(B*10,C);
% fil=FilterLFP(Ctsd,[0.5 4],26);
% hold on, plot(B/1E3,Data(fil),'r')

if crossco==1
% compared Delta CrossCorrelograms
num=1000;
sbin=20;
nbin=100;
load([res,'/newDeltaPaCx'])
tDeltaPaCx=tDelta;
totPa=length(tDelta);
load([res,'/newDeltaMoCx'])
tDeltaMoCx=tDelta;
totMo=length(tDelta);
load([res,'/newDeltaPFCx'])
tDeltaPFCx=tDelta;
totPF=length(tDelta);

[C,B]=CrossCorr(tDeltaPaCx,tDeltaPFCx,sbin,nbin); 
figure, subplot(2,1,1)
hold on, plot(B/1E3,smooth(C,smo))
hold on, title([' Delta PaCx vs PFCx - all SWS epoch'])
[C1,B1]=CrossCorr(tDeltaPaCx(1:num),tDeltaPFCx(1:num),sbin,nbin); 
[C2,B2]=CrossCorr(tDeltaPaCx(totPa-num:totPa),tDeltaPFCx(totPF-num:totPF),sbin,nbin); 
hold on, subplot(2,1,2)
hold on, plot(B1/1E3,smooth(C1,smo),'k'), hold on, plot(B2/1E3,smooth(C2,smo),'r')
hold on, title(['nDelta=',num2str(num),' - SWS begin(k) vs SWS end(r)'])

[C,B]=CrossCorr(tDeltaPaCx,tDeltaMoCx,sbin,nbin); 
figure, subplot(2,1,1)
hold on, plot(B/1E3,smooth(C,smo))
hold on, title([' Delta PaCx vs MoCx - all SWS epoch'])
[C1,B1]=CrossCorr(tDeltaPaCx(1:num),tDeltaMoCx(1:num),sbin,nbin); 
[C2,B2]=CrossCorr(tDeltaPaCx(totPa-num:totPa),tDeltaMoCx(totMo-num:totMo),sbin,nbin); 
hold on, subplot(2,1,2)
hold on, plot(B1/1E3,smooth(C1,smo),'k'), hold on, plot(B2/1E3,smooth(C2,smo),'r')
hold on, title(['nDelta=',num2str(num),' - SWS begin(k) vs SWS end(r)'])

[C,B]=CrossCorr(tDeltaPFCx,tDeltaMoCx,sbin,nbin); 
figure, subplot(2,1,1)
hold on, plot(B/1E3,smooth(C,smo))
hold on, title([' Delta PFCx vs MoCx - all SWS epoch'])
[C1,B1]=CrossCorr(tDeltaPFCx(1:num),tDeltaMoCx(1:num),sbin,nbin); 
[C2,B2]=CrossCorr(tDeltaPFCx(totPF-num:totPF),tDeltaMoCx(totMo-num:totMo),sbin,nbin); 
hold on, subplot(2,1,2)
hold on, plot(B1/1E3,smooth(C1,smo),'k'), hold on, plot(B2/1E3,smooth(C2,smo),'r')
hold on, title(['nDelta=',num2str(num),' - SWS begin(k) vs SWS end(r)'])
end
%--------------------------------------------------------------------------
% Discriminate intra Sleep Periods
%--------------------------------------------------------------------------
if detail==1
    % compared Delta AutoCorrelograms
    num=1000;
    tot=length(tDelta);
    % choose t1 and t2
    Delta=ts(tDelta);
    % first sleep episode
    Epoch1=intervalSet(1.5E7,2.6E7);
    Epoch2=intervalSet(7.4E7,8.4E7);
    t1=Range(Restrict(Delta,Epoch1));
    t2=Range(Restrict(Delta,Epoch2));
    % last sleep episode
    Epoch3=intervalSet(2.4E8,2.7E8);
    Epoch4=intervalSet(2.75E8,2.95E8);
    t3=Range(Restrict(Delta,Epoch3));
    t4=Range(Restrict(Delta,Epoch4));
    sbin=80;
    nbin=200;
    smo=2;
    
    [C,B]=CrossCorr(tDelta,tDelta,sbin,nbin); C(B==0)=0;
    figure, subplot(4,1,1)
    hold on, plot(B/1E3,smooth(C,smo))
    hold on, title([struct,' Delta - all SWS epoch'])
    [C1,B1]=CrossCorr(tDelta(1:num),tDelta(1:num),sbin,nbin); C1(B1==0)=0;
    [C2,B2]=CrossCorr(tDelta(tot-num:tot),tDelta(tot-num:tot),sbin,nbin); C2(B2==0)=0;
    hold on, subplot(4,1,2)
    hold on, plot(B1/1E3,smooth(C1,smo),'k'), hold on, plot(B2/1E3,smooth(C2,smo),'r')
    hold on, title(['nDelta=',num2str(num),' - SWS begin(k) vs SWS end(r)'])
    [C1,B1]=CrossCorr(t1,t1,sbin,nbin); C1(B1==0)=0;
    [C2,B2]=CrossCorr(t2,t2,sbin,nbin); C2(B2==0)=0;
    hold on, subplot(4,1,3)
    hold on, plot(B1/1E3,smooth(C1,smo),'k'), hold on, plot(B2/1E3,smooth(C2,smo),'r')
    hold on, title(['begin versus end of first sleep episode'])
    [C3,B3]=CrossCorr(t3,t3,sbin,nbin); C3(B3==0)=0;
    [C4,B4]=CrossCorr(t4,t4,sbin,nbin); C4(B4==0)=0;
    hold on, subplot(4,1,4)
    hold on, plot(B3/1E3,smooth(C3,smo),'k'), hold on, plot(B4/1E3,smooth(C4,smo),'r')
    hold on, title(['begin versus end of last sleep episode'])
end
