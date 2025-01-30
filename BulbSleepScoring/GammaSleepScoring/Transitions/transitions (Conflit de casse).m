
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

%% To execute
 MatX=[-0.7:3.2/99:2.5];
 MatY=[-1.5:3.5/99:2];
for mm=1:m
    mm
    cd(filename2{mm})
    load('MapsTransitionProba.mat')
    load('StateEpochSB.mat')
    %Find transition zone
    temp=nanmean(Val{4}');
    [C,I]=min(temp(20:80));
    I=I+19;
    Lim2=find(temp(I:end)>0.9,1,'first')+I;
    Lim1=find(temp(1:I)>0.9,1,'last');
    %     plot(temp)
    %     hold on
    %     plot(Lim1,temp(Lim1),'*r')
    %     plot(Lim2,temp(Lim2),'*r')
    % pause
    % hold off
    X1=exp(MatX(Lim1)+nanmean(log(Data(Restrict(smooth_ghi,SWSEpoch)))));
    X2=exp(MatX(Lim2)+nanmean(log(Data(Restrict(smooth_ghi,SWSEpoch)))));
    TransitionEpoch1=thresholdIntervals(smooth_ghi,X1,'Direction','Above');
    TransitionEpoch2=thresholdIntervals(smooth_ghi,X2,'Direction','Below');
    TransitionEpoch=And(TransitionEpoch1,TransitionEpoch2);
    WakeBeg=Restrict(ts(Start(TransitionEpoch)),Wake);
    [a,bWkBe]=intersect(Range(ts(Start(TransitionEpoch))),Range(WakeBeg));
    SleepBeg=Restrict(ts(Start(TransitionEpoch)),SWSEpoch);
    [a,bSlBe]=intersect(Range(ts(Start(TransitionEpoch))),Range(SleepBeg));
    SleepEnd=Restrict(ts(Stop(TransitionEpoch)),SWSEpoch);
    [a,bSlEn]=intersect(Range(ts(Start(TransitionEpoch))),Range(SleepBeg));
    WakeEnd=Restrict(ts(Stop(TransitionEpoch)),Wake);
    [a,bWkEn]=intersect(Range(ts(Start(TransitionEpoch))),Range(SleepBeg));


end

