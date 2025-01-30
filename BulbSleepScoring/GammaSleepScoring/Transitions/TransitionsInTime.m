
clear all, close all
m=1;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M60/20130415/';
m=2;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M82/20130730/';
m=3;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M83/20130729/';
m=4;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M123/LPSD1/';
m=5;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M51/09112012/';
m=6;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M61/20130415/';
m=7;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M147/';
m=8;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M148/20140828/';
m=9;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M243/01042015/';
m=10;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M244/09042015/';
m=11;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M251/21052015/';
m=12;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M252/21052015/';
m=13;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M178/';



% To execute
MatX=[-0.7:3.2/99:2.5];
MatY=[-1.5:3.5/99:2];
clear Tot TotTh
 binsz=0.5;
 totdur=100;
%  binsz=60;
%  totdur=20000;
smoofact=1;
Titres={'AutoCorr StoS','AutoCorr WtoW','AutoCorr WtoS','AutoCorr StoW','CrossCorr StoW and StoW','CrossCorr WtoW and WtoS','CrossCorr WtoS and StoW',...
    'All trans from wake','All trans from sleep','All trans'}
Fs = 1/binsz;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = totdur/binsz;             % Length of signal
t = (0:L-1)*T;        % Time vector
f = Fs*(0:(L/2))/L;
nummouse=0;
for mm=1:m
    mm
    tic
    
    for i=1:4
        Points{i}=[];
    end
    cd(filename2{mm})
    %     load('MapsTransitionProba.mat')
    load('StateEpochSB.mat','SWSEpoch','Wake','sleepper','NoiseEpoch','GndNoiseEpoch','gamma_thresh','smooth_ghi')%     %Find transition zone
%     Wake=Or(Wake,NoiseEpoch);
%     Wake=Or(Wake,GndNoiseEpoch);
    try
        load('TransLims.mat')
    catch
        load(' TransLims.mat')
    end
  %  if max(Stop(SWSEpoch,'s'))>60*60*6 | max(Stop(Wake,'s'))>60*60*6
        mm
        nummouse=nummouse+1;
        Wake=thresholdIntervals(smooth_ghi,gamma_thresh,'Direction','Above');
        SWSEpoch=thresholdIntervals(smooth_ghi,gamma_thresh,'Direction','Below');

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
        PostSpecPer=dropShortIntervals(temp,3e4);
        [C,B]=CrossCorr(Start(temp),Start(temp),binsz*1e3,totdur/binsz);
        C=runmean(C,smoofact);
%        C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
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
        PostSpecPer=dropShortIntervals(temp,3e4);
        [C,B]=CrossCorr(Start(temp),Start(temp),binsz*1e3,totdur/binsz);
        C=runmean(C,smoofact);
%        C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
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
        PostSpecPer=dropShortIntervals(temp,3e4);
        [C,B]=CrossCorr(Start(temp),Start(temp),binsz*1e3,totdur/binsz);
        C=runmean(C,smoofact);
%        C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
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
        PostSpecPer=dropShortIntervals(temp,3e4);
        [C,B]=CrossCorr(Start(temp),Start(temp),binsz*1e3,totdur/binsz);
        C=runmean(C,smoofact);
%        C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
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
        [C,B]=CrossCorr(Start(temp2),Start(temp),binsz*1e3,totdur/binsz);
        C=runmean(C,smoofact);
%        C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
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
        [C,B]=CrossCorr(Start(temp2),Start(temp),binsz*1e3,totdur/binsz);
        C=runmean(C,smoofact);
%        C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
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
%        C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
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
%        C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
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
%        C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
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
%        C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
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
close all
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
figure(100)
for k=1:10
    subplot(5,2,k)
    g=shadedErrorBar(f,(mean(reshape([TotFF{k,:}],length(P1),nummouse)')),[stdError(((reshape([TotFF{k,:}],length(P1),nummouse)')))])
    title(Titres{k})
end
%
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