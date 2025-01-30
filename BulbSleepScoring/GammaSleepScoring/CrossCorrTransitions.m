
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
binsz=1;
totdur=200;
smoofact=2;
Titres={'CrossCorr StoW with WtoW','CrossCorr WtoS with WtoW','CrossCorr WtoS with StoW','All trans from wakew i all trans from sleep'}
nummouse=0;
for mm=1:m
    mm
    tic
    
    for i=1:4
        Points{i}=[];
    end
    cd(filename2{mm})
    %     load('MapsTransitionProba.mat')
    %     load('StateEpochSB.mat','SWSEpoch','Wake','smooth_Theta','smooth_ghi','gamma_thresh')%     %Find transition zone
    %     temp=nanmean(Val{4}');
    %     [C,I]=min(temp(20:80));
    %     I=I+19;
    %     Lim2=find(temp(I:end)>0.9,1,'first')+I;
    %     Lim1=find(temp(1:I)>0.9,1,'last');
    %     %     plot(temp)
    %     %     hold on
    %     %     plot(Lim1,temp(Lim1),'*r')
    %     %     plot(Lim2,temp(Lim2),'*r')
    %     % pause
    %     % hold off
    %     X1=exp(MatX(Lim1)+nanmean(log(Data(Restrict(smooth_ghi,SWSEpoch)))));
    %     X2=exp(MatX(Lim2)+nanmean(log(Data(Restrict(smooth_ghi,SWSEpoch)))));
    %     TransitionEpoch1=thresholdIntervals(smooth_ghi,X1,'Direction','Above');
    %     TransitionEpoch2=thresholdIntervals(smooth_ghi,X2,'Direction','Below');
    %     TransitionEpoch=And(TransitionEpoch1,TransitionEpoch2);
    %     WakePer=thresholdIntervals(smooth_ghi,gamma_thresh,'Direction','Above');
    %     SleepPer=thresholdIntervals(smooth_ghi,gamma_thresh,'Direction','Below');
    %     save('TransLims.mat','X1','X2','TransitionEpoch','SleepPer','WakePer')
    
    mm
    nummouse=nummouse+1;
    load('TransLims.mat')
    WakeBeg=Restrict(ts(Start(TransitionEpoch)),WakePer);
    [a,bWkBe]=intersect(Range(ts(Start(TransitionEpoch))),Range(WakeBeg));
    WakeEnd=Restrict(ts(Stop(TransitionEpoch)),WakePer);
    [a,bWkEn]=intersect(Range(ts(Stop(TransitionEpoch))),Range(WakeEnd));
    SleepBeg=Restrict(ts(Start(TransitionEpoch)),SleepPer);
    [a,bSlBe]=intersect(Range(ts(Start(TransitionEpoch))),Range(SleepBeg));
    SleepEnd=Restrict(ts(Stop(TransitionEpoch)),SleepPer);
    [a,bSlEn]=intersect(Range(ts(Stop(TransitionEpoch))),Range(SleepEnd));
    temp=(subset(TransitionEpoch,(intersect(bWkBe,bSlEn))));%temp2=mergeCloseIntervals(temp2,1e4);
    temp2=(subset(TransitionEpoch,(intersect(bSlBe,bWkEn))));%temp2=mergeCloseIntervals(temp2,1e4);
    AllTransStart=Start(or(temp,temp2));
    
    %Sleep to Sleep wi Sleep to Wake
    num=1;
    temp=(subset(TransitionEpoch,(intersect(bSlBe,bSlEn))));%temp=mergeCloseIntervals(temp,1e4);
    temp2=(subset(TransitionEpoch,(intersect(bSlBe,bWkEn))));%temp2=mergeCloseIntervals(temp2,1e4);
    [C,B]=CrossCorr(Start(temp2),Start(temp),binsz*1e3,totdur/binsz);
    C=runmean(C,smoofact);
    %        C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
%     figure(nummouse);
%     subplot(2,2,num)
%     plot(B/1e3,(C/sum(C)))
%     title(Titres{num})
%     xlim([-totdur/2 totdur/2])
    Tot{num,nummouse}=C/sum(C);
    
    % On average how many real transitions are preceded by a false
    % transition
    stp=ts(Stop(temp));
    for k=1:length(Start(temp2))
        NewEp=intervalSet(Start(subset(temp2,k))-5*1e4,(Stop(subset(temp2,k))));
        Size{mm,1}(k,1)=length(Range(Restrict(stp,NewEp)));
        Size{mm,1}(k,2)=(Stop(subset(temp2,k))-Start(subset(temp2,k)))/1e4;
        if not(isempty(AllTransStart(find(AllTransStart>Stop(subset(temp2,k)),1,'first'))))
            Size{mm,1}(k,3)= AllTransStart(find(AllTransStart>Stop(subset(temp2,k)),1,'first'))-Stop(subset(temp2,k));
        end
          if not(isempty(AllTransStart(find(AllTransStart<Start(subset(temp2,k)),1,'last'))))
            Size{mm,1}(k,4)= Start(subset(temp2,k))-AllTransStart(find(AllTransStart<Start(subset(temp2,k)),1,'last'));
        end

    end 
    
    
    %Wake to wake wi wake to sleep
    num=2;
    temp=(subset(TransitionEpoch,(intersect(bWkBe,bWkEn))));%temp=mergeCloseIntervals(temp,1e4);
    temp2=(subset(TransitionEpoch,(intersect(bWkBe,bSlEn))));%temp2=mergeCloseIntervals(temp2,1e4);
    [C,B]=CrossCorr(Start(temp2),Start(temp),binsz*1e3,totdur/binsz);
    C=runmean(C,smoofact);
    %        C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
%     figure(nummouse);
%     subplot(2,2,num)
%     plot(B/1e3,(C/sum(C)))
%     title(Titres{num})
%     xlim([-totdur/2 totdur/2])
    Tot{num,nummouse}=C/sum(C);
    
    % On average how many real transitions are preceded by a false
    % transition
    stp=ts(Stop(temp));
    for k=1:length(Start(temp2))
        NewEp=intervalSet(Start(subset(temp2,k))-5*1e4,(Stop(subset(temp2,k))));
        Size{mm,2}(k,1)=length(Range(Restrict(stp,NewEp)));
        Size{mm,2}(k,2)=(Stop(subset(temp2,k))-Start(subset(temp2,k)))/1e4;
        if not(isempty(AllTransStart(find(AllTransStart>Stop(subset(temp2,k)),1,'first'))))
            Size{mm,2}(k,3)= AllTransStart(find(AllTransStart>Stop(subset(temp2,k)),1,'first'))-Stop(subset(temp2,k));
        end
        if not(isempty(AllTransStart(find(AllTransStart<Start(subset(temp2,k)),1,'last'))))
            Size{mm,2}(k,4)= Start(subset(temp2,k))-AllTransStart(find(AllTransStart<Start(subset(temp2,k)),1,'last'));
        end

    end

    %wake to sleep wi sleep to wake
    num=3;
    temp=(subset(TransitionEpoch,(intersect(bWkBe,bSlEn))));%temp=mergeCloseIntervals(temp,1e4);
    temp2=(subset(TransitionEpoch,(intersect(bSlBe,bWkEn))));%temp2=mergeCloseIntervals(temp2,1e4);
    [C,B]=CrossCorr(Start(temp),Start(temp2),binsz*1e3,totdur/binsz);
    C=runmean(C,smoofact);
    %        C(find(B==0))=0; C(find(B==0)-1)=0;C(find(B==0)+1)=0;;
%     figure(nummouse);
%     subplot(2,2,num)
%     plot(B/1e3,(C/sum(C)))
%     title(Titres{num})
%     xlim([-totdur/2 totdur/2])
    Tot{num,nummouse}=C/sum(C);
    
    
    
    
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
for k=1:3
    subplot(2,2,k)
    g=shadedErrorBar(B/1e3,(mean(reshape([Tot{k,:}],length(C),nummouse)')),[stdError(((reshape([Tot{k,:}],length(C),nummouse)')))])
%     plot(reshape([Tot{k,:}],length(C),nummouse))
    title(Titres{k})
end

a=[];b=[];c=[];d=[];
for mm=1:13
a=[a;Size{mm,2}(:,1)];
b=[b;Size{mm,1}(:,1)];
end

figure
subplot(121)
hist(a)
subplot(122)
hist(b)



a=[];b=[];c=[];d=[];
for mm=1:13
a=[a;Size{mm,2}(:,1)];
b=[b;Size{mm,2}(:,2)];
c=[c;Size{mm,2}(:,3)];
d=[d;Size{mm,2}(:,4)];
end
figure
subplot(131)
[Y,X]=hist(b(a==0),50);
plot(X,Y/sum(Y))
hold on
[Y,X]=hist(b(a~=0),50);
plot(X,Y/sum(Y),'r')
subplot(132)
abis=a;
abis(find(c>4*1e6))=[];
c(find(c>4*1e6))=[];
[Y,X]=hist((c(abis==0)),50);
plot(X,Y/sum(Y))
hold on
[Y,X]=hist((c(abis~=0)),50);
plot(X,Y/sum(Y),'r')
subplot(133)
abis=a;
abis(find(d>1*1e7))=[];
d(find(d>1*1e7))=[];
[Y,X]=hist((d(abis==0)),50);
plot(X,Y/sum(Y))
hold on
[Y,X]=hist((d(abis~=0)),50);
plot(X,Y/sum(Y),'r')
