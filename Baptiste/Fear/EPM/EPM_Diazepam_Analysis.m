%% EPM 30 min

clear all
Base = '/media/mobsmorty/DataMOBs119/EPM/27102020_Dzp/FEAR-Mouse-1087-27102020-EPM';
AllMice = 0:14;
Sal_30 = [13,4,5,6,7,8,9];
Dzp_30 = [14,0,1,2,3,10,11,12];
%Sal_30 = [7,8,9];
%Dzp_30 = [10,11,12];

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
    load('Temperature.mat', 'Temp')
    MeanTemp_Sal(s)=nanmean(Data(Temp.MouseTemperatureTSD));
    
    MeanDurOpen_Sal(s)=nanmean(Stop(ZoneEpoch{1},'s')-Start(ZoneEpoch{1},'s'));
    MeanDurClosed_Sal(s)=nanmean(Stop(ZoneEpoch{2},'s')-Start(ZoneEpoch{2},'s'));
    
end

for s = 1 :length(Dzp_30)
    if Dzp_30(s)<10
        cd([Base '_0' num2str(Dzp_30(s))])
    else
        cd([Base '_' num2str(Dzp_30(s))])
    end
    load('behavResources.mat')
    
    TimeOpen_Dzp(s) = sum(Stop(ZoneEpoch{1},'s')-Start(ZoneEpoch{1},'s'));
    TimeClosed_Dzp(s) = sum(Stop(ZoneEpoch{2},'s')-Start(ZoneEpoch{2},'s'));
    TimeCenter_Dzp(s)= sum(Stop(ZoneEpoch{3},'s')-Start(ZoneEpoch{3},'s'));
    
    NumEntry_Dzp(s)= length(Start(ZoneEpoch{1},'s'));
    Tot_Arm_Entries_Dzp(s)=length(Start(ZoneEpoch{1},'s'))+length(Start(ZoneEpoch{2},'s'));
    
    MeanSpeed_Dzp(s)=nanmean(Data(Vtsd));
    
    MeanDurOpen_Dzp(s)=nanmean(Stop(ZoneEpoch{1},'s')-Start(ZoneEpoch{1},'s'));
    MeanDurClosed_Dzp(s)=nanmean(Stop(ZoneEpoch{2},'s')-Start(ZoneEpoch{2},'s'));
    
end

figure
subplot(241)
PlotErrorBarN_BM({TimeOpen_Sal./(300),TimeOpen_Dzp./(300)},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','DZP'})
title('proportionnal time in open arms')
ylabel('%')
subplot(242)
PlotErrorBarN_BM({TimeClosed_Sal./(300),TimeClosed_Dzp./(300)},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','DZP'})
title('proportionnal time in closed arms')
ylabel('%')
subplot(243)
PlotErrorBarN_BM({TimeCenter_Sal./(300),TimeCenter_Dzp./(300)},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','DZP'})
title('proportionnal time in center')
ylabel('%')
subplot(244)
PlotErrorBarN_BM({MeanSpeed_Sal,MeanSpeed_Dzp},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','DZP'})
title('MeanSpeed')
ylabel('cm/s')

subplot(245)
PlotErrorBarN_BM({NumEntry_Sal,NumEntry_Dzp},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','DZP'})
title('open arms entries')
ylabel('#')
subplot(246)
PlotErrorBarN_BM({Tot_Arm_Entries_Sal,Tot_Arm_Entries_Dzp},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','DZP'})
title('all arm entries')
ylabel('#')
subplot(247)
PlotErrorBarN_BM({MeanDurOpen_Sal,MeanDurOpen_Dzp},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','DZP'})
title('mean duration in open arm')
ylabel('s')
subplot(248)
PlotErrorBarN_BM({MeanDurClosed_Sal,MeanDurClosed_Dzp},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','DZP'})
title('mean duration in closed arm')
ylabel('s')



%%

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


for s = 1 :length(Dzp_30)
    
    if Dzp_30(s)<10
        cd([Base '_0' num2str(Dzp_30(s))])
    else
        cd([Base '_' num2str(Dzp_30(s))])
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
    
    TimeinOA_Dzp(s,1)=TimeinOA1+TimeinOA2;
    TimeinOA_Dzp(s,2)=TimeinOA_Dzp(s,1)/300;
    
end


figure
PlotErrorBarN_KJ({TimeinOA_Sal(:,2),TimeinOA_Dzp(:,2)},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','DZP'})
title('proportionnal time in open arms')
ylabel('%')

