

%% correlation HR end task and stress score

Mouse=Drugs_Groups_UMaze_BM(22);
Session_type={'Cond'}; sess=1;
[OutPutData , Epoch1 , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'heartrate');

Session_type={'sleep_pre'}; sess=1;
[OutPutData2 , Epoch2 , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'heartrate');



for mouse=1:length(Mouse)
    max_time = max(Range(OutPutData.heartrate.tsd{mouse,1}));
    FiveMin_Before_end = intervalSet(max_time-5*60e4 , max_time);
    HR_Bef_end_tot(mouse) = nanmean(Data(Restrict(OutPutData.heartrate.tsd{mouse,1} , FiveMin_Before_end)));
    HR_Bef_end_Fz(mouse) = nanmean(Data(Restrict(OutPutData.heartrate.tsd{mouse,6} , FiveMin_Before_end)));
    HR_Bef_end_Act(mouse) = nanmean(Data(Restrict(OutPutData.heartrate.tsd{mouse,4} , FiveMin_Before_end)));
    
    HR_Wake_FirstHour_SleepPre(mouse) = nanmean(Data(Restrict(OutPutData2.heartrate.tsd{mouse,2} , intervalSet(0,60*60e4))));

    disp(mouse)
end

load('PC_values.mat', 'PCVal')

%% figures
figure
subplot(131)
PlotCorrelations_BM(HR_Bef_end_tot-HR_Wake_FirstHour_SleepPre , PCVal)
axis square
xlabel('HR end task, total'), ylabel('stress score')
makepretty

subplot(132)
PlotCorrelations_BM(HR_Bef_end_Fz-HR_Wake_FirstHour_SleepPre , PCVal)
axis square
xlabel('HR end task, Fz safe'), ylabel('stress score')
makepretty

subplot(133)
PlotCorrelations_BM(HR_Bef_end_Act-HR_Wake_FirstHour_SleepPre , PCVal)
axis square
xlabel('HR end task, Active'), ylabel('stress score')
makepretty


HR_end_task



