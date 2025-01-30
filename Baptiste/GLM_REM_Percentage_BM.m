
GetEmbReactMiceFolderList_BM
Mouse=Mouse([1:9 11:18]);
[TSD_DATA , Epoch1 , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,'slbs','accelero');

clear REM_Percentage REM_Percentage_All REM_Time REM_Time_All REM_Cumulated_Percentage_All REM_Start REM_Start_All REM_MeanDur REM_MeanDur_All
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    %     SleepDur = sum(Stop(Sleep)-Start(Sleep))/60e4; % in min
    %     Time_bin = SleepDur/100;
    R = Range(TSD_DATA.accelero.tsd{mouse,3});
    bin_size = 100;
    bin_to_use = round(length(R)/bin_size);
    for i=1:bin_size
        if i==1
            Interval_to_use = intervalSet(R(1),R(bin_to_use))-Epoch1{mouse,2};
        elseif i==bin_size
            Interval_to_use = intervalSet(R(bin_to_use*(bin_size-1)),R(end))-Epoch1{mouse,2};
        else
            Interval_to_use = intervalSet(R(bin_to_use*(i-1)),R(bin_to_use*i))-Epoch1{mouse,2};
        end
        
        REM_Percentage.(Mouse_names{mouse})(i) = sum(Stop(and(Epoch1{mouse,5} , Interval_to_use))-Start(and(Epoch1{mouse,5} , Interval_to_use)))/sum(Stop(and(Epoch1{mouse,3} , Interval_to_use))-Start(and(Epoch1{mouse,3} , Interval_to_use)));
        REM_Time.(Mouse_names{mouse})(i) = sum(Stop(and(Epoch1{mouse,5} , Interval_to_use))-Start(and(Epoch1{mouse,5} , Interval_to_use)));
        REM_Start.(Mouse_names{mouse})(i) = length(Start(and(Epoch1{mouse,5} , Interval_to_use)));
        REM_MeanDur.(Mouse_names{mouse})(i) = nanmean(Stop(and(Epoch1{mouse,5} , Interval_to_use))-Start(and(Epoch1{mouse,5} , Interval_to_use)));
    end
    REM_MeanDur_Evolution.(Mouse_names{mouse})=Stop(Epoch1{mouse,5})-Start(Epoch1{mouse,5});
    REM_MeanDur_Evolution_Norm.(Mouse_names{mouse})=interp1(linspace(0,1,length(REM_MeanDur_Evolution.(Mouse_names{mouse}))) , REM_MeanDur_Evolution.(Mouse_names{mouse})' , linspace(0,1,100));
    
    clear Interval_to_use Wake bin_to_use R
    REM_Percentage_All(mouse,:) = REM_Percentage.(Mouse_names{mouse});
    REM_Time_All(mouse,:) = REM_Time.(Mouse_names{mouse});
    REM_Start_All(mouse,:) = REM_Start.(Mouse_names{mouse});
    REM_MeanDur_All(mouse,:) = REM_MeanDur.(Mouse_names{mouse});
    REM_MeanDur_Evolution_Norm_All(mouse,:) = REM_MeanDur_Evolution_Norm.(Mouse_names{mouse});
end
REM_MeanDur_All(REM_MeanDur_All==0)=NaN;
REM_MeanDur_All=REM_MeanDur_All/1e4;


for mouse=1:length(Mouse)
    for i=1:bin_size
        REM_Cumulated_Percentage_All(mouse,i) = sum(REM_Time_All(mouse,1:i))/sum(REM_Time_All(mouse,:));
    end
end

X=[1:bin_size];
Y=1./(1+exp(-.065*(X-50)))-0.04;
Y2=0.14*(1-0.71*exp(-0.13*X));

% REM percentage along sleep and cumulated REM percent
figure
subplot(121)
Conf_Inter=nanstd(REM_Percentage_All)/sqrt(size(REM_Percentage_All,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(REM_Percentage_All);
shadedErrorBar([1:bin_size],runmean(Mean_All_Sp,5),runmean(Conf_Inter,5),'-k',1); hold on;
xlabel('normalized sleep time'); ylabel('% REM'); makepretty
plot(X,Y2,'r','Linewidth',2)
f=get(gca,'Children'); legend([f(1),f(3)],'A(1-B*exp(-C*t) fit','Data');
title('REM percentage evolution along sleep')

subplot(122)
Conf_Inter=nanstd(REM_Cumulated_Percentage_All)/sqrt(size(REM_Cumulated_Percentage_All,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(REM_Cumulated_Percentage_All);
shadedErrorBar([1:bin_size],Mean_All_Sp,Conf_Inter,'-k',1); hold on;
plot(X,X/100,'--r','Linewidth',2)
set(gca, 'XScale', 'log');
plot(X,Y,'r','Linewidth',2)
xlabel('normalized sleep time'); ylabel('% cumulated REM'); makepretty
ylim([-0.1 1])
title('REM percentage cumulated evolution along sleep')


% REM starts & mean duration
figure
subplot(121)
Conf_Inter=nanstd(REM_Start_All)/sqrt(size(REM_Start_All,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(REM_Start_All);
shadedErrorBar([1:bin_size],runmean(Mean_All_Sp,5),runmean(Conf_Inter,5),'-k',1); hold on;
xlabel('normalized sleep time'); ylabel('#'); makepretty
title('REM episodes start')

subplot(122)
Conf_Inter=nanstd(REM_MeanDur_All)/sqrt(size(REM_MeanDur_All,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(REM_MeanDur_All);
shadedErrorBar([1:bin_size],runmean(Mean_All_Sp,5),runmean(Conf_Inter,5),'-k',1); hold on;
xlabel('normalized sleep time'); ylabel('time (s)'); makepretty
title('REM mean duration')

% division by REM episodes
figure
subplot(122)
Conf_Inter=nanstd(REM_MeanDur_Evolution_Norm_All)/sqrt(size(REM_MeanDur_Evolution_Norm_All,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(REM_MeanDur_Evolution_Norm_All);
shadedErrorBar([1:bin_size],runmean(Mean_All_Sp,5)/1e4,runmean(Conf_Inter,5)/1e4,'-k',1); hold on;
xlabel('normalized REM ep'); ylabel('time (s)'); makepretty
title('REM mean duration')



%% Large binning
clear REM_Percentage2 REM_Percentage2_All REM_Time2 REM_Time2_All REM_Cumulated_Percentage_All REM_MeanDur2 REM_MeanDur2_All REM_Start2 REM_Start2_All
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    %     SleepDur = sum(Stop(Sleep)-Start(Sleep))/60e4; % in min
    %     Time_bin = SleepDur/100;
    R = Range(TSD_DATA.accelero.tsd{mouse,3});
    bin_size2 = 20;
    bin_to_use = round(length(R)/bin_size2);
    for i=1:bin_size2
        if i==1
            Interval_to_use = intervalSet(R(1),R(bin_to_use))-Epoch1{mouse,2};
        elseif i==bin_size2
            Interval_to_use = intervalSet(R(bin_to_use*(bin_size2-1)),R(end))-Epoch1{mouse,2};
        else
            Interval_to_use = intervalSet(R(bin_to_use*(i-1)),R(bin_to_use*i))-Epoch1{mouse,2};
        end
        
        REM_Percentage2.(Mouse_names{mouse})(i) = sum(Stop(and(Epoch1{mouse,5} , Interval_to_use))-Start(and(Epoch1{mouse,5} , Interval_to_use)))/sum(Stop(and(Epoch1{mouse,3} , Interval_to_use))-Start(and(Epoch1{mouse,3} , Interval_to_use)));
        REM_Time2.(Mouse_names{mouse})(i) = sum(Stop(and(Epoch1{mouse,5} , Interval_to_use))-Start(and(Epoch1{mouse,5} , Interval_to_use)));
        REM_Start2.(Mouse_names{mouse})(i) = length(Start(and(Epoch1{mouse,5} , Interval_to_use)));
        REM_MeanDur2.(Mouse_names{mouse})(i) = nanmean(Stop(and(Epoch1{mouse,5} , Interval_to_use))-Start(and(Epoch1{mouse,5} , Interval_to_use)));
    end
    clear Interval_to_use Wake bin_to_use R
    REM_Percentage2_All(mouse,:) = REM_Percentage2.(Mouse_names{mouse});
    REM_Time2_All(mouse,:) = REM_Time2.(Mouse_names{mouse});
    REM_Start2_All(mouse,:) = REM_Start2.(Mouse_names{mouse});
    REM_MeanDur2_All(mouse,:) = REM_MeanDur2.(Mouse_names{mouse});
end
REM_MeanDur2_All(REM_MeanDur2_All==0)=NaN;
REM_MeanDur2_All=REM_MeanDur2_All/1e4;


figure
subplot(121)
Conf_Inter=nanstd(REM_Start2_All)/sqrt(size(REM_Start2_All,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(REM_Start2_All);
shadedErrorBar([1:bin_size2],runmean(Mean_All_Sp,2),runmean(Conf_Inter,2),'-k',1); hold on;
xlabel('normalized sleep time');  ylabel('#'); makepretty
title('REM episodes start')

subplot(122)
Conf_Inter=nanstd(REM_MeanDur2_All)/sqrt(size(REM_MeanDur2_All,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(REM_MeanDur2_All);
shadedErrorBar([1:bin_size2],runmean(Mean_All_Sp,2),runmean(Conf_Inter,2),'-k',1); hold on;
xlabel('normalized sleep time');  ylabel('time (s)'); makepretty
title('REM mean duration')
