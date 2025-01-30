clear all, close all
m=1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M147';
% filename{m,2}=7;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M148/20140828/';
% filename{m,2}=7;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M177';
% filename{m,2}=9;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M178';
% filename{m,2}=18;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-23022014/M177';
% filename{m,2}=9;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-23022014/M178';
% filename{m,2}=18;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M258/20151112/';
% filename{m,2}=18;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M259/20151112/';

size_occ=100;
tot_occ=zeros(size_occ,size_occ);
inpercent=[0:0.05:1];
MatX=[-2:8/99:6];
MatY=[-2:4/99:2];

clear Tot TotTh
binsz=0.5;
totdur=200;
smoofact=2;
Titres={'AutoCorr StoS','AutoCorr WtoW','AutoCorr WtoS','AutoCorr StoW','CrossCorr StoS and StoW','CrossCorr WtoW and WtoS','CrossCorr WtoS and StoW',...
    'All trans from wake','All trans from sleep','All trans'}
Fs = 1/binsz;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = totdur/binsz;             % Length of signal
t = (0:L-1)*T;        % Time vector
f = Fs*(0:(L/2))/L;
nummouse=0;
for mm=1:7
    mm
    tic
    
    for i=1:4
        Points{i}=[];
    end
    cd(filename{mm})
    load('StateEpochEMGSB.mat','SWSEpoch','Wake','sleepper','NoiseEpoch','GndNoiseEpoch')%     %Find transition zone
    load('TransLimsEMG.mat')
    
    %  if max(Stop(SWSEpoch,'s'))>60*60*6 | max(Stop(Wake,'s'))>60*60*6
    mm
    nummouse=nummouse+1;
    
    WakeBeg=Restrict(ts(Start(TransitionEpoch)),Wake);
    [a,bWkBe]=intersect(Range(ts(Start(TransitionEpoch))),Range(WakeBeg));
    WakeEnd=Restrict(ts(Stop(TransitionEpoch)),Wake);
    [a,bWkEn]=intersect(Range(ts(Stop(TransitionEpoch))),Range(WakeEnd));
    SleepBeg=Restrict(ts(Start(TransitionEpoch)),SWSEpoch);
    [a,bSlBe]=intersect(Range(ts(Start(TransitionEpoch))),Range(SleepBeg));
    SleepEnd=Restrict(ts(Stop(TransitionEpoch)),SWSEpoch);
    [a,bSlEn]=intersect(Range(ts(Stop(TransitionEpoch))),Range(SleepEnd));
    
    %Sleep to Sleep
    num=1;
    temp=(subset(TransitionEpoch,(intersect(bSlBe,bSlEn))));%temp=mergeCloseIntervals(temp,1e4);
    [Yd{mm,num},Xd{mm,num}]=hist((Stop(temp)-Start(temp))/1e4,50);
    Dur{mm,num}=sum((Stop(temp)-Start(temp))/1e4);
    PostSpecPer=dropShortIntervals(temp,3e4);
    [C,B]=CrossCorr(Start(temp),Start(temp),binsz*1e3,totdur/binsz);
    C=runmean(C,smoofact);
    C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
    Y = fft(C);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    figure(nummouse);
    subplot(5,2,num)
    plot(B/1e3,(C/sum(C)))
    title(Titres{1})
    xlim([-totdur/2 totdur/2])
    figure(nummouse+13);
    subplot(5,2,num)
    P1(1)=0;
    plot(f,P1)
    title(Titres{1})
    Tot{1,nummouse}=C/sum(C);
    TotFF{num,nummouse}=P1;
    
    % Wake to Wake
    num=2;
    temp=(subset(TransitionEpoch,(intersect(bWkBe,bWkEn))));%temp=mergeCloseIntervals(temp,1e4);
    [Yd{mm,num},Xd{mm,num}]=hist((Stop(temp)-Start(temp))/1e4,50);
    Dur{mm,num}=sum((Stop(temp)-Start(temp))/1e4);
    PostSpecPer=dropShortIntervals(temp,3e4);
    [C,B]=CrossCorr(Start(temp),Start(temp),binsz*1e3,totdur/binsz);
    C=runmean(C,smoofact);
    C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
    Y = fft(C);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    figure(nummouse);
    subplot(5,2,num)
    plot(B/1e3,(C/sum(C)))
    title(Titres{num})
    xlim([-totdur/2 totdur/2])
    figure(nummouse+13);
    subplot(5,2,num)
    P1(1)=0;
    plot(f,P1)
    title(Titres{num})
    Tot{num,nummouse}=C/sum(C);
    TotFF{num,nummouse}=P1;
    
    %Wk to Sleep
    num=3;
    temp=(subset(TransitionEpoch,(intersect(bWkBe,bSlEn))));%temp=mergeCloseIntervals(temp,1e4);
    [Yd{mm,num},Xd{mm,num}]=hist((Stop(temp)-Start(temp))/1e4,50);
    Dur{mm,num}=sum((Stop(temp)-Start(temp))/1e4);
    PostSpecPer=dropShortIntervals(temp,3e4);
    [C,B]=CrossCorr(Start(temp),Start(temp),binsz*1e3,totdur/binsz);
    C=runmean(C,smoofact);
    C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
    Y = fft(C);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    figure(nummouse);
    subplot(5,2,num)
    plot(B/1e3,(C/sum(C)))
    title(Titres{num})
    xlim([-totdur/2 totdur/2])
    figure(nummouse+13);
    subplot(5,2,num)
    P1(1)=0;
    plot(f,P1)
    title(Titres{num})
    Tot{num,nummouse}=C/sum(C);
    TotFF{num,nummouse}=P1;
    
    %Sleep to Wk
    num=4;
    temp=(subset(TransitionEpoch,(intersect(bSlBe,bWkEn))));%temp=mergeCloseIntervals(temp,1e4);
    [Yd{mm,num},Xd{mm,num}]=hist((Stop(temp)-Start(temp))/1e4,50);
    Dur{mm,num}=sum((Stop(temp)-Start(temp))/1e4);
    PostSpecPer=dropShortIntervals(temp,3e4);
    [C,B]=CrossCorr(Start(temp),Start(temp),binsz*1e3,totdur/binsz);
    C=runmean(C,smoofact);
    C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
    Y = fft(C);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    figure(nummouse);
    subplot(5,2,num)
    plot(B/1e3,(C/sum(C)))
    title(Titres{num})
    xlim([-totdur/2 totdur/2])
    figure(nummouse+13);
    subplot(5,2,num)
    P1(1)=0;
    plot(f,P1)
    title(Titres{num})
    Tot{num,nummouse}=C/sum(C);
    TotFF{num,nummouse}=P1;
    
    %Sleep to Sleep wi Sleep to Wake
    num=5;
    temp=(subset(TransitionEpoch,(intersect(bSlBe,bSlEn))));%temp=mergeCloseIntervals(temp,1e4);
    temp2=(subset(TransitionEpoch,(intersect(bSlBe,bWkEn))));%temp2=mergeCloseIntervals(temp2,1e4);
    [C,B]=CrossCorr(Start(temp),Start(temp2),binsz*1e3,totdur/binsz);
    C=runmean(C,smoofact);
    C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
    Y = fft(C);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    figure(nummouse);
    subplot(5,2,num)
    plot(B/1e3,(C/sum(C)))
    title(Titres{num})
    xlim([-totdur/2 totdur/2])
    figure(nummouse+13);
    subplot(5,2,num)
    P1(1)=0;
    plot(f,P1)
    title(Titres{num})
    Tot{num,nummouse}=C/sum(C);
    TotFF{num,nummouse}=P1;
    
    %Wake to wake wi wake to sleep
    num=6;
    temp=(subset(TransitionEpoch,(intersect(bWkBe,bWkEn))));%temp=mergeCloseIntervals(temp,1e4);
    temp2=(subset(TransitionEpoch,(intersect(bWkBe,bSlEn))));%temp2=mergeCloseIntervals(temp2,1e4);
    [C,B]=CrossCorr(Start(temp),Start(temp2),binsz*1e3,totdur/binsz);
    C=runmean(C,smoofact);
    C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
    Y = fft(C);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    figure(nummouse);
    subplot(5,2,num)
    plot(B/1e3,(C/sum(C)))
    title(Titres{num})
    xlim([-totdur/2 totdur/2])
    figure(nummouse+13);
    subplot(5,2,num)
    P1(1)=0;
    plot(f,P1)
    title(Titres{num})
    Tot{num,nummouse}=C/sum(C);
    TotFF{num,nummouse}=P1;
    
    %wake to sleep wi sleep to wake
    num=7;
    temp=(subset(TransitionEpoch,(intersect(bWkBe,bSlEn))));%temp=mergeCloseIntervals(temp,1e4);
    temp2=(subset(TransitionEpoch,(intersect(bSlBe,bWkEn))));%temp2=mergeCloseIntervals(temp2,1e4);
    [C,B]=CrossCorr(Start(temp),Start(temp2),binsz*1e3,totdur/binsz);
    C=runmean(C,smoofact);
    C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
    Y = fft(C);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    figure(nummouse);
    subplot(5,2,num)
    plot(B/1e3,(C/sum(C)))
    title(Titres{num})
    xlim([-totdur/2 totdur/2])
    figure(nummouse+13);
    subplot(5,2,num)
    P1(1)=0;
    plot(f,P1)
    title(Titres{num})
    Tot{num,nummouse}=C/sum(C);
    TotFF{num,nummouse}=P1;
    
    % All transitions autocorr : w/w and w/s
    num=8;
    temp=(subset(TransitionEpoch,(intersect(bWkBe,bWkEn))));%temp=mergeCloseIntervals(temp,1e4);
    temp2=(subset(TransitionEpoch,(intersect(bWkBe,bSlEn))));%temp2=mergeCloseIntervals(temp2,1e4);
    a=sort([Start(temp)/1e4;Start(temp2)/1e4]);
    [C,B]=CrossCorr(a*1e4,a*1e4,binsz*1e3,totdur/binsz);
    C=runmean(C,smoofact);
    C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
    Y = fft(C);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    figure(nummouse);
    subplot(5,2,num)
    plot(B/1e3,(C/sum(C)))
    title(Titres{num})
    xlim([-totdur/2 totdur/2])
    figure(nummouse+13);
    subplot(5,2,num)
    P1(1)=0;
    plot(f,P1)
    title(Titres{num})
    Tot{num,nummouse}=C/sum(C);
    TotFF{num,nummouse}=P1;
    
    
    % All transitions autocorr : s/s and s/w
    num=9;
    temp=(subset(TransitionEpoch,(intersect(bSlBe,bSlEn))));%temp=mergeCloseIntervals(temp,1e4);
    temp2=(subset(TransitionEpoch,(intersect(bSlBe,bWkEn))));%temp2=mergeCloseIntervals(temp2,1e4);
    a=sort([Start(temp)/1e4;Start(temp2)/1e4]);
    [C,B]=CrossCorr(a*1e4,a*1e4,binsz*1e3,totdur/binsz);
    C=runmean(C,smoofact);
    C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
    Y = fft(C);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    figure(nummouse);
    subplot(5,2,num)
    plot(B/1e3,(C/sum(C)))
    title(Titres{num})
    xlim([-totdur/2 totdur/2])
    figure(nummouse+13);
    subplot(5,2,num)
    P1(1)=0;
    plot(f,P1)
    title(Titres{num})
    Tot{num,nummouse}=C/sum(C);
    TotFF{num,nummouse}=P1;
    
    % All transitions autocorr : s/s and s/w
    num=10;
    temp=(subset(TransitionEpoch,(intersect(bSlBe,bSlEn))));%temp=mergeCloseIntervals(temp,1e4);
    temp2=(subset(TransitionEpoch,(intersect(bSlBe,bWkEn))));%temp2=mergeCloseIntervals(temp2,1e4);
    temp3=(subset(TransitionEpoch,(intersect(bWkBe,bWkEn))));%temp3=mergeCloseIntervals(temp3,1e4);
    temp4=(subset(TransitionEpoch,(intersect(bWkBe,bSlEn))));%temp4=mergeCloseIntervals(temp4,1e4);
    a=sort([Start(temp)/1e4;Start(temp2)/1e4;Start(temp3)/1e4;Start(temp4)/1e4]);
    [C,B]=CrossCorr(a*1e4,a*1e4,binsz*1e3,totdur/binsz);
    C=runmean(C,smoofact);
    C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
    Y = fft(C);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    figure(nummouse);
    subplot(5,2,num)
    plot(B/1e3,(C/sum(C)))
    title(Titres{num})
    xlim([-totdur/2 totdur/2])
    figure(nummouse+13);
    subplot(5,2,num)
    P1(1)=0;
    plot(f,P1)
    title(Titres{num})
    Tot{num,nummouse}=C/sum(C);
    TotFF{num,nummouse}=P1;
    %  end
end
% close all
figure
%a: duration of events
%b : % of events
%c : % of transition zone time
clear a
for mm=1:7
    a(mm,1)=sum(Xd{mm,1}.*Yd{mm,1}/sum(Yd{mm,1}));
    a(mm,2)=sum(Xd{mm,2}.*Yd{mm,2}/sum(Yd{mm,2}));
    a(mm,3)=sum(Xd{mm,3}.*Yd{mm,3}/sum(Yd{mm,3}));
    a(mm,4)=sum(Xd{mm,4}.*Yd{mm,4}/sum(Yd{mm,4}));
    b(mm,:)=sum(reshape([Yd{mm,:}],50,4))./sum(sum(reshape([Yd{mm,:}],50,4)));
    c(mm,:)=(reshape([Dur{mm,:}],1,4))./sum(sum(reshape([Dur{mm,:}],1,4)));
end
figure
subplot(131)
PlotErrorBar(a,0)
set(gca,'XTick',[1:4],'XTickLabel',{'StoS','WtoW','WtoS','StoW'})
title('Av trans event duration')
subplot(132)
PlotErrorBar(b,0)
set(gca,'XTick',[1:4],'XTickLabel',{'StoS','WtoW','WtoS','StoW'})
title('% of total events')
subplot(133)
PlotErrorBar(c,0)
set(gca,'XTick',[1:4],'XTickLabel',{'StoS','WtoW','WtoS','StoW'})
title('% of total event time')
%
% Y = fft(runmean(X,2));
%
%
% plot(f,P1)
%
figure(99)
for k=1:10
    subplot(5,2,k)
    g=shadedErrorBar(B/1e3,(mean(reshape([Tot{k,:}],length(C),nummouse)')),[stdError(((reshape([Tot{k,:}],length(C),nummouse)')))])
    title(Titres{k})
end
% figure(100)
% for k=1:10
%     subplot(5,2,k)
%     g=shadedErrorBar(f,(mean(reshape([TotFF{k,:}],length(P1),nummouse)')),[stdError(((reshape([TotFF{k,:}],length(P1),nummouse)')))])
%     title(Titres{k})
% end
% %
% figure,bar([1,2],[nanmean([TotTh{1,:}]),nanmean([TotTh{4,:}])],'k')
% hold on
% plot(1,[TotTh{1,:}],'ko','MarkerSize',6)
% plot(1,[TotTh{1,:}],'w.','MarkerSize',5)
% plot(2,[TotTh{4,:}],'ko','MarkerSize',6)
% plot(2,[TotTh{4,:}],'w.','MarkerSize',5)
% line([[TotTh{1,:}]'*0+1,[TotTh{4,:}]'*0+2]',[[TotTh{1,:}]',[TotTh{4,:}]']','color','b')
% [h,p]=ttest([TotTh{1,:}],[TotTh{4,:}]);
% title(num2str(p))
% set(gca,'XTick',[1,2],'XTicklabel',{'StoS','StoW'})
% xlim([0.5 2.5])
% ylabel('Thet to Del ratio')
%
% figure,bar([1,2],[nanmean([TotTh{2,:}]),nanmean([TotTh{3,:}])],'k')
% hold on
% plot(1,[TotTh{2,:}],'ko','MarkerSize',6)
% plot(1,[TotTh{2,:}],'w.','MarkerSize',5)
% plot(2,[TotTh{3,:}],'ko','MarkerSize',6)
% plot(2,[TotTh{3,:}],'w.','MarkerSize',5)
% line([[TotTh{2,:}]'*0+1,[TotTh{3,:}]'*0+2]',[[TotTh{2,:}]',[TotTh{3,:}]']','color','b')
% [h,p]=ttest([TotTh{2,:}],[TotTh{3,:}]);
% title(num2str(p))
% set(gca,'XTick',[1,2],'XTicklabel',{'WtoW','WtoS'})
% xlim([0.5 2.5])
% ylabel('Thet to Del ratio')