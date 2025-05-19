

load('/media/nas7/ProjetEmbReact/DataEmbReact/HR_end_task.mat')

%% correlation HR end task and stress score
clear all

Drug_Group={'Eyelid'};
Group = 22;
for group=1:length(Drug_Group)
    Mouse = Drugs_Groups_UMaze_BM(Group(group));
    Session_type={'Cond'}; sess=1;
    [OutPutData{group} , Epoch1 , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'heartrate');
    Session_type={'sleep_pre'}; sess=1;
    [OutPutData2{group} , Epoch2 , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'heartrate');
end


Drug_Group={'RipControl','RipInhib'};
Group = [7 8];
for group=1:length(Drug_Group)
    Mouse = Drugs_Groups_UMaze_BM(Group(group));
    Session_type={'Cond'}; sess=1;
    [OutPutData{group} , Epoch1 , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),'heartrate');
    Session_type={'sleep_pre'}; sess=1;
    [OutPutData2{group} , Epoch2 , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),'heartrate');
end


Drug_Group={'Saline','DZP'};
Group = [13 15];
for group=1:length(Drug_Group)
    Mouse = Drugs_Groups_UMaze_BM(Group(group));
    Session_type={'Cond'}; sess=1;
    [OutPutData{group} , Epoch1 , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),'heartrate');
    Session_type={'sleep_pre'}; sess=1;
    [OutPutData2{group} , Epoch2 , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),'heartrate');
end
        
%%
for group=1:length(Drug_Group)
    Mouse = Drugs_Groups_UMaze_BM(Group(group));
    for mouse=1:length(Mouse)
        max_time = max(Range(OutPutData{group}.heartrate.tsd{mouse,1}));
        FiveMin_Before_end = intervalSet(max_time-5*60e4 , max_time);
        HR_Bef_end_tot{group}(mouse) = nanmean(Data(Restrict(OutPutData{group}.heartrate.tsd{mouse,1} , FiveMin_Before_end)));
        HR_Bef_end_Fz{group}(mouse) = nanmean(Data(Restrict(OutPutData{group}.heartrate.tsd{mouse,6} , FiveMin_Before_end)));
        HR_Bef_end_Act{group}(mouse) = nanmean(Data(Restrict(OutPutData{group}.heartrate.tsd{mouse,4} , FiveMin_Before_end)));
        
        HR_Wake_FirstHour_SleepPre{group}(mouse) = nanmean(Data(Restrict(OutPutData2{group}.heartrate.tsd{mouse,2} , intervalSet(0,60*60e4))));
        
        disp(mouse)
    end
end

load('PC_values.mat', 'PCVal')

%% figures
figure
PlotCorrelations_BM(HR_Bef_end_Act-HR_Wake_FirstHour_SleepPre , PCVal)
axis square
xlabel('HR end task, Fz safe'), ylabel('stress score')
makepretty




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




Cols = {[.3, .745, .93],[.85, .325, .098]};
X = [1:2];
Legends = {'Saline','DZP'};

Cols = {[.65, .75, 0],[.63, .08, .18]};
X = [1:2];
Legends = {'RipControl','RipInhib'};


figure
MakeSpreadAndBoxPlot3_SB({HR_Bef_end_Act{1}-HR_Wake_FirstHour_SleepPre{1} HR_Bef_end_Act{2}-HR_Wake_FirstHour_SleepPre{2}},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('HR end task, Active')
makepretty_BM2



figure
MakeSpreadAndBoxPlot3_SB(HR_Bef_end_Act,Cols,X,Legends,'showpoints',1,'paired',0);





Cols = {[.3 .3 .3],[.6 .6 .6]};
X = [1:2];
Legends = {'Homecage','Cond'};


figure
MakeSpreadAndBoxPlot3_SB({HR_Wake_FirstHour_SleepPre{1} HR_Bef_end_Act{1}},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('HR active (Hz)')
makepretty_BM2







