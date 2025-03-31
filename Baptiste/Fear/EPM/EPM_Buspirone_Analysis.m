%% EPM 30 min

clear all
Base = '/media/mobsmorty/DataMOBs119/EPM/17072020_Bus/FEAR-Mouse-1066-17072020-EPM';
AllMice = 0:37;
Sal_30 = [37,1,3,4,5,9,10,15];% 11 has problem
Bus_30 = [0,2,6,7,8,12,13,14,16,17];

for s = 1 :length(Sal_30)
    if Sal_30(s)<10
        cd([Base '_0' num2str(Sal_30(s))])
    else
        cd([Base '_' num2str(Sal_30(s))])
    end
    load('behavResources.mat')
    
    TimeOpen_Sal(s) = sum(Stop(ZoneEpoch{1},'s')-Start(ZoneEpoch{1},'s'));
    TimeClosed_Sal(s) = sum(Stop(ZoneEpoch{2},'s')-Start(ZoneEpoch{2},'s'));
    TimeCenter_Sal(s)= sum(Stop(ZoneEpoch{3},'s')-Start(ZoneEpoch{3},'s'));
    
    NumEntry_Sal(s)= length(Start(ZoneEpoch{1},'s'));
    Tot_Arm_Entries_Sal(s)=length(Start(ZoneEpoch{1},'s'))+length(Start(ZoneEpoch{2},'s'));
    
    MeanSpeed_Sal(s)=nanmean(Data(Vtsd));
    
    MeanDurOpen_Sal(s)=nanmean(Stop(ZoneEpoch{1},'s')-Start(ZoneEpoch{1},'s'));
    MeanDurClosed_Sal(s)=nanmean(Stop(ZoneEpoch{2},'s')-Start(ZoneEpoch{2},'s'));
    
end

for s = 1 :length(Bus_30)
    if Bus_30(s)<10
        cd([Base '_0' num2str(Bus_30(s))])
    else
        cd([Base '_' num2str(Bus_30(s))])
    end
    load('behavResources.mat')
    
    TimeOpen_Bus(s) = sum(Stop(ZoneEpoch{1},'s')-Start(ZoneEpoch{1},'s'));
    TimeClosed_Bus(s) = sum(Stop(ZoneEpoch{2},'s')-Start(ZoneEpoch{2},'s'));
    TimeCenter_Bus(s)= sum(Stop(ZoneEpoch{3},'s')-Start(ZoneEpoch{3},'s'));
    
    NumEntry_Bus(s)= length(Start(ZoneEpoch{1},'s'));
    Tot_Arm_Entries_Bus(s)=length(Start(ZoneEpoch{1},'s'))+length(Start(ZoneEpoch{2},'s'));
    
    MeanSpeed_Bus(s)=nanmean(Data(Vtsd));
    
    MeanDurOpen_Bus(s)=nanmean(Stop(ZoneEpoch{1},'s')-Start(ZoneEpoch{1},'s'));
    MeanDurClosed_Bus(s)=nanmean(Stop(ZoneEpoch{2},'s')-Start(ZoneEpoch{2},'s'));
    
end

figure
subplot(241)
PlotErrorBarN_BM({TimeOpen_Sal./(300),TimeOpen_Bus./(300)},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Bus'})
title('proportionnal time in open arms')
ylabel('%')
subplot(242)
PlotErrorBarN_BM({TimeClosed_Sal./(300),TimeClosed_Bus./(300)},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Bus'})
title('proportionnal time in closed arms')
ylabel('%')
subplot(243)
PlotErrorBarN_BM({TimeCenter_Sal./(300),TimeCenter_Bus./(300)},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Bus'})
title('proportionnal time in center')
ylabel('%')
subplot(244)
PlotErrorBarN_BM({MeanSpeed_Sal,MeanSpeed_Bus},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Bus'})
title('MeanSpeed')
ylabel('cm/s')

subplot(245)
PlotErrorBarN_BM({NumEntry_Sal,NumEntry_Bus},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Bus'})
title('open arms entries')
ylabel('#')
subplot(246)
PlotErrorBarN_BM({Tot_Arm_Entries_Sal,Tot_Arm_Entries_Bus},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Bus'})
title('all arm entries')
ylabel('#')
subplot(247)
PlotErrorBarN_BM({MeanDurOpen_Sal,MeanDurOpen_Bus},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Bus'})
title('mean duration in open arm')
ylabel('s')
subplot(248)
PlotErrorBarN_BM({MeanDurClosed_Sal,MeanDurClosed_Bus},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Bus'})
title('mean duration in closed arm')
ylabel('s')


%% EPM 4h
clear all
Base = '/media/mobsmorty/DataMOBs119/EPM/17072020_Bus/FEAR-Mouse-1066-17072020-EPM';
Sal_4h = [18,19,22,23,24,28,29,30,34];
Bus_4h = [20,21,25,26,27,31,32,33,35,36];

for s = 1 :length(Sal_4h )
    if Sal_4h (s)<10
        cd([Base '_0' num2str(Sal_4h (s))])
    else
        cd([Base '_' num2str(Sal_4h (s))])
    end
    load('behavResources.mat')
    
    TimeOpen_Sal(s) = sum(Stop(ZoneEpoch{1},'s')-Start(ZoneEpoch{1},'s'));
    TimeClosed_Sal(s) = sum(Stop(ZoneEpoch{2},'s')-Start(ZoneEpoch{2},'s'));
    TimeCenter_Sal(s)= sum(Stop(ZoneEpoch{3},'s')-Start(ZoneEpoch{3},'s'));
    
    NumEntry_Sal(s)= length(Start(ZoneEpoch{1},'s'));
    Tot_Arm_Entries_Sal(s)=length(Start(ZoneEpoch{1},'s'))+length(Start(ZoneEpoch{2},'s'));
    
    MeanSpeed_Sal(s)=nanmean(Data(Vtsd));
    
    MeanDurOpen_Sal(s)=nanmean(Stop(ZoneEpoch{1},'s')-Start(ZoneEpoch{1},'s'));
    MeanDurClosed_Sal(s)=nanmean(Stop(ZoneEpoch{2},'s')-Start(ZoneEpoch{2},'s'));
    
end

for s = 1 :length(Bus_4h)
    if Bus_4h(s)<10
        cd([Base '_0' num2str(Bus_4h(s))])
    else
        cd([Base '_' num2str(Bus_4h(s))])
    end
    load('behavResources.mat')
    
    TimeOpen_Bus(s) = sum(Stop(ZoneEpoch{1},'s')-Start(ZoneEpoch{1},'s'));
    TimeClosed_Bus(s) = sum(Stop(ZoneEpoch{2},'s')-Start(ZoneEpoch{2},'s'));
    TimeCenter_Bus(s)= sum(Stop(ZoneEpoch{3},'s')-Start(ZoneEpoch{3},'s'));
    
    NumEntry_Bus(s)= length(Start(ZoneEpoch{1},'s'));
    Tot_Arm_Entries_Bus(s)=length(Start(ZoneEpoch{1},'s'))+length(Start(ZoneEpoch{2},'s'));
    
    MeanSpeed_Bus(s)=nanmean(Data(Vtsd));
    
    MeanDurOpen_Bus(s)=nanmean(Stop(ZoneEpoch{1},'s')-Start(ZoneEpoch{1},'s'));
    MeanDurClosed_Bus(s)=nanmean(Stop(ZoneEpoch{2},'s')-Start(ZoneEpoch{2},'s'));
    
end

figure
subplot(241)
PlotErrorBarN_BM({TimeOpen_Sal./(300),TimeOpen_Bus./(300)},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Bus'})
title('proportionnal time in open arms')
ylabel('%')
subplot(242)
PlotErrorBarN_BM({TimeClosed_Sal./(300),TimeClosed_Bus./(300)},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Bus'})
title('proportionnal time in closed arms')
ylabel('%')
subplot(243)
PlotErrorBarN_BM({TimeCenter_Sal./(300),TimeCenter_Bus./(300)},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Bus'})
title('proportionnal time in center')
ylabel('%')
subplot(244)
PlotErrorBarN_BM({MeanSpeed_Sal,MeanSpeed_Bus},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Bus'})
title('MeanSpeed')
ylabel('cm/s')

subplot(245)
PlotErrorBarN_BM({NumEntry_Sal,NumEntry_Bus},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Bus'})
title('open arms entries')
ylabel('#')
subplot(246)
PlotErrorBarN_BM({Tot_Arm_Entries_Sal,Tot_Arm_Entries_Bus},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Bus'})
title('all arm entries')
ylabel('#')
subplot(247)
PlotErrorBarN_BM({MeanDurOpen_Sal,MeanDurOpen_Bus},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Bus'})
title('mean duration in open arm')
ylabel('s')
subplot(248)
PlotErrorBarN_BM({MeanDurClosed_Sal,MeanDurClosed_Bus},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Bus'})
title('mean duration in closed arm')
ylabel('s')

%% Baptiste way

for s = 1 :length(Sal_30)
    
    if Sal_30(s)<10
        cd([Base '_0' num2str(Sal_30(s))])
    else
        cd([Base '_' num2str(Sal_30(s))])
    end
    load('behavResources.mat')
    
    % Open arm time
    clear DataXtsd RangeXtsd DataYtsd AboveLine1Logical AboveLine2Logical
    DataXtsd=Data(Xtsd); RangeXtsd=Range(Xtsd);
    DataYtsd=Data(Ytsd);
    AboveLine1Logical=DataXtsd<(DataYtsd-12);
    XtsdOA1=tsd(RangeXtsd(AboveLine1Logical),DataXtsd(AboveLine1Logical))  ;
    YtsdOA1=tsd(RangeXtsd(AboveLine1Logical),DataYtsd(AboveLine1Logical));
    
    c=RangeXtsd(AboveLine1Logical);
    c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
    TimeinOA1(s)=sum(c(c(:,2)<800,2))/1e4;
    
    AboveLine2Logical=DataXtsd>(DataYtsd-5);
    XtsdOA2=tsd(RangeXtsd(AboveLine2Logical),DataXtsd(AboveLine2Logical))  ;
    YtsdOA2=tsd(RangeXtsd(AboveLine2Logical),DataYtsd(AboveLine2Logical));
    
    clear c; c=RangeXtsd(AboveLine2Logical);
    c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
    TimeinOA2(s)=sum(c(c(:,2)<800,2))/1e4;
    
    TimeinOA(s)=TimeinOA1(s)+TimeinOA2(s);
    
    % Open arm time
    clear DataXtsd RangeXtsd DataYtsd AboveLine1Logical AboveLine2Logical TimeinOA1 TimeinOA2
    DataXtsd=Data(Xtsd); RangeXtsd=Range(Xtsd);
    DataYtsd=Data(Ytsd);
    AboveLine1Logical=DataXtsd<(DataYtsd-12);
    XtsdOA1=tsd(RangeXtsd(AboveLine1Logical),DataXtsd(AboveLine1Logical))  ;
    YtsdOA1=tsd(RangeXtsd(AboveLine1Logical),DataYtsd(AboveLine1Logical));
    
    c=RangeXtsd(AboveLine1Logical);
    c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
    TimeinOA1=sum(c(c(:,2)<800,2))/1e4;
    
    AboveLine2Logical=DataXtsd>(DataYtsd-5);
    XtsdOA2=tsd(RangeXtsd(AboveLine2Logical),DataXtsd(AboveLine2Logical))  ;
    YtsdOA2=tsd(RangeXtsd(AboveLine2Logical),DataYtsd(AboveLine2Logical));
    
    clear c; c=RangeXtsd(AboveLine2Logical);
    c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
    TimeinOA2=sum(c(c(:,2)<800,2))/1e4;
    
    TimeinOA_Sal(s,1)=TimeinOA1+TimeinOA2;
    TimeinOA_Sal(s,2)=TimeinOA_Sal(s,1)/300;
    
end


for s = 1 :length(Bus_30)
    
    if Bus_30(s)<10
        cd([Base '_0' num2str(Bus_30(s))])
    else
        cd([Base '_' num2str(Bus_30(s))])
    end
    load('behavResources.mat')
    
    % Open arm time
    clear DataXtsd RangeXtsd DataYtsd AboveLine1Logical AboveLine2Logical
    DataXtsd=Data(Xtsd); RangeXtsd=Range(Xtsd);
    DataYtsd=Data(Ytsd);
    AboveLine1Logical=DataXtsd<(DataYtsd-12);
    XtsdOA1=tsd(RangeXtsd(AboveLine1Logical),DataXtsd(AboveLine1Logical))  ;
    YtsdOA1=tsd(RangeXtsd(AboveLine1Logical),DataYtsd(AboveLine1Logical));
    
    c=RangeXtsd(AboveLine1Logical);
    c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
    TimeinOA1(s)=sum(c(c(:,2)<800,2))/1e4;
    
    AboveLine2Logical=DataXtsd>(DataYtsd-5);
    XtsdOA2=tsd(RangeXtsd(AboveLine2Logical),DataXtsd(AboveLine2Logical))  ;
    YtsdOA2=tsd(RangeXtsd(AboveLine2Logical),DataYtsd(AboveLine2Logical));
    
    clear c; c=RangeXtsd(AboveLine2Logical);
    c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
    TimeinOA2(s)=sum(c(c(:,2)<800,2))/1e4;
    
    TimeinOA(s)=TimeinOA1(s)+TimeinOA2(s);
    
    % Open arm time
    clear DataXtsd RangeXtsd DataYtsd AboveLine1Logical AboveLine2Logical TimeinOA1 TimeinOA2
    DataXtsd=Data(Xtsd); RangeXtsd=Range(Xtsd);
    DataYtsd=Data(Ytsd);
    AboveLine1Logical=DataXtsd<(DataYtsd-12);
    XtsdOA1=tsd(RangeXtsd(AboveLine1Logical),DataXtsd(AboveLine1Logical))  ;
    YtsdOA1=tsd(RangeXtsd(AboveLine1Logical),DataYtsd(AboveLine1Logical));
    
    c=RangeXtsd(AboveLine1Logical);
    c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
    TimeinOA1=sum(c(c(:,2)<800,2))/1e4;
    
    AboveLine2Logical=DataXtsd>(DataYtsd-5);
    XtsdOA2=tsd(RangeXtsd(AboveLine2Logical),DataXtsd(AboveLine2Logical))  ;
    YtsdOA2=tsd(RangeXtsd(AboveLine2Logical),DataYtsd(AboveLine2Logical));
    
    clear c; c=RangeXtsd(AboveLine2Logical);
    c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
    TimeinOA2=sum(c(c(:,2)<800,2))/1e4;
    
    TimeinOA_Bus(s,1)=TimeinOA1+TimeinOA2;
    TimeinOA_Bus(s,2)=TimeinOA_Bus(s,1)/300;
    
end


figure
PlotErrorBarN_KJ({TimeinOA_Sal(:,2),TimeinOA_Bus(:,2)},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','BUS'})
title('proportionnal time in open arms')
ylabel('%')



for s = 1 :length(Sal_4h)
    
    if Sal_4h(s)<10
        cd([Base '_0' num2str(Sal_4h(s))])
    else
        cd([Base '_' num2str(Sal_4h(s))])
    end
    load('behavResources.mat')
    
    % Open arm time
    clear DataXtsd RangeXtsd DataYtsd AboveLine1Logical AboveLine2Logical
    DataXtsd=Data(Xtsd); RangeXtsd=Range(Xtsd);
    DataYtsd=Data(Ytsd);
    AboveLine1Logical=DataXtsd<(DataYtsd-12);
    XtsdOA1=tsd(RangeXtsd(AboveLine1Logical),DataXtsd(AboveLine1Logical))  ;
    YtsdOA1=tsd(RangeXtsd(AboveLine1Logical),DataYtsd(AboveLine1Logical));
    
    c=RangeXtsd(AboveLine1Logical);
    c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
    TimeinOA1(s)=sum(c(c(:,2)<800,2))/1e4;
    
    AboveLine2Logical=DataXtsd>(DataYtsd-5);
    XtsdOA2=tsd(RangeXtsd(AboveLine2Logical),DataXtsd(AboveLine2Logical))  ;
    YtsdOA2=tsd(RangeXtsd(AboveLine2Logical),DataYtsd(AboveLine2Logical));
    
    clear c; c=RangeXtsd(AboveLine2Logical);
    c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
    TimeinOA2(s)=sum(c(c(:,2)<800,2))/1e4;
    
    TimeinOA(s)=TimeinOA1(s)+TimeinOA2(s);
    
    % Open arm time
    clear DataXtsd RangeXtsd DataYtsd AboveLine1Logical AboveLine2Logical TimeinOA1 TimeinOA2
    DataXtsd=Data(Xtsd); RangeXtsd=Range(Xtsd);
    DataYtsd=Data(Ytsd);
    AboveLine1Logical=DataXtsd<(DataYtsd-12);
    XtsdOA1=tsd(RangeXtsd(AboveLine1Logical),DataXtsd(AboveLine1Logical))  ;
    YtsdOA1=tsd(RangeXtsd(AboveLine1Logical),DataYtsd(AboveLine1Logical));
    
    c=RangeXtsd(AboveLine1Logical);
    c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
    TimeinOA1=sum(c(c(:,2)<800,2))/1e4;
    
    AboveLine2Logical=DataXtsd>(DataYtsd-5);
    XtsdOA2=tsd(RangeXtsd(AboveLine2Logical),DataXtsd(AboveLine2Logical))  ;
    YtsdOA2=tsd(RangeXtsd(AboveLine2Logical),DataYtsd(AboveLine2Logical));
    
    clear c; c=RangeXtsd(AboveLine2Logical);
    c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
    TimeinOA2=sum(c(c(:,2)<800,2))/1e4;
    
    TimeinOA_Sal4h(s,1)=TimeinOA1+TimeinOA2;
    TimeinOA_Sal4h(s,2)=TimeinOA_Sal4h(s,1)/300;
    
end


for s = 1 :length(Bus_4h)
    
    if Bus_4h(s)<10
        cd([Base '_0' num2str(Bus_4h(s))])
    else
        cd([Base '_' num2str(Bus_4h(s))])
    end
    load('behavResources.mat')
    
    % Open arm time
    clear DataXtsd RangeXtsd DataYtsd AboveLine1Logical AboveLine2Logical
    DataXtsd=Data(Xtsd); RangeXtsd=Range(Xtsd);
    DataYtsd=Data(Ytsd);
    AboveLine1Logical=DataXtsd<(DataYtsd-12);
    XtsdOA1=tsd(RangeXtsd(AboveLine1Logical),DataXtsd(AboveLine1Logical))  ;
    YtsdOA1=tsd(RangeXtsd(AboveLine1Logical),DataYtsd(AboveLine1Logical));
    
    c=RangeXtsd(AboveLine1Logical);
    c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
    TimeinOA1(s)=sum(c(c(:,2)<800,2))/1e4;
    
    AboveLine2Logical=DataXtsd>(DataYtsd-5);
    XtsdOA2=tsd(RangeXtsd(AboveLine2Logical),DataXtsd(AboveLine2Logical))  ;
    YtsdOA2=tsd(RangeXtsd(AboveLine2Logical),DataYtsd(AboveLine2Logical));
    
    clear c; c=RangeXtsd(AboveLine2Logical);
    c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
    TimeinOA2(s)=sum(c(c(:,2)<800,2))/1e4;
    
    TimeinOA(s)=TimeinOA1(s)+TimeinOA2(s);
    
    % Open arm time
    clear DataXtsd RangeXtsd DataYtsd AboveLine1Logical AboveLine2Logical TimeinOA1 TimeinOA2
    DataXtsd=Data(Xtsd); RangeXtsd=Range(Xtsd);
    DataYtsd=Data(Ytsd);
    AboveLine1Logical=DataXtsd<(DataYtsd-12);
    XtsdOA1=tsd(RangeXtsd(AboveLine1Logical),DataXtsd(AboveLine1Logical))  ;
    YtsdOA1=tsd(RangeXtsd(AboveLine1Logical),DataYtsd(AboveLine1Logical));
    
    c=RangeXtsd(AboveLine1Logical);
    c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
    TimeinOA1=sum(c(c(:,2)<800,2))/1e4;
    
    AboveLine2Logical=DataXtsd>(DataYtsd-5);
    XtsdOA2=tsd(RangeXtsd(AboveLine2Logical),DataXtsd(AboveLine2Logical))  ;
    YtsdOA2=tsd(RangeXtsd(AboveLine2Logical),DataYtsd(AboveLine2Logical));
    
    clear c; c=RangeXtsd(AboveLine2Logical);
    c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
    TimeinOA2=sum(c(c(:,2)<800,2))/1e4;
    
    TimeinOA_Bus4h(s,1)=TimeinOA1+TimeinOA2;
    TimeinOA_Bus4h(s,2)=TimeinOA_Bus4h(s,1)/300;
    
end


figure
PlotErrorBarN_KJ({TimeinOA_Sal4h(:,2),TimeinOA_Bus4h(:,2)},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','BUS'})
title('proportionnal time in open arms')
ylabel('%')

