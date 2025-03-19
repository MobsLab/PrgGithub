%% input dir : 
DirBasal_dreadd = PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirBasal_atrop = PathForExperimentsAtropine_MC('BaselineSleep');
DirBasal1 = MergePathForExperiment(DirBasal_dreadd,DirBasal_opto);
DirBasal2 = MergePathForExperiment(DirBasal_SD,DirBasal_atrop);
DirMyBasal = MergePathForExperiment(DirBasal1,DirBasal2);
DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');

DirBasal = MergePathForExperiment(DirMyBasal,DirLabBasal);


%% input dir
DirSaline = PathForExperiments_DREADD_MC('OneInject_Nacl');
DirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');

DirSaline = RestrictPathForExperiment(DirSaline, 'nMice', [1105 1106 1148 1149]);
DirCNO = RestrictPathForExperiment(DirCNO, 'nMice', [1105 1106 1148 1149]);



%saline PFC experiment
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
%saline VLPO experiment
DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
%merge saline path
DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);


DirCNO = PathForExperimentsAtropine_MC('Atropine');
% 


%% get the data baseline
for k=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{k}{1});
    f{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    % separate recording before/after injection
    durtotal_basal{k} = max([max(End(f{k}.Wake)),max(End(f{k}.SWSEpoch))]);
    Epoch1_basal{k} = intervalSet(0,durtotal_basal{k}/2);
    Epoch2_basal{k} = intervalSet(durtotal_basal{k}/2,durtotal_basal{k});
    
    try
    g{k} = load('behavResources.mat', 'Vtsd');
    % threshold on speed to get period of high/low activity
    thresh_basal{k} = mean(Data(g{k}.Vtsd))+std(Data(g{k}.Vtsd));
    highMov_basal{k} = thresholdIntervals(g{k}.Vtsd, thresh_basal{k}, 'Direction', 'Above');
    lowMov_basal{k} = thresholdIntervals(g{k}.Vtsd, thresh_basal{k}, 'Direction', 'Below');
    
    % calculate duration of wake with high/low activity
    [durWake1,durTWake1]=DurationEpoch(and(f{k}.Wake,and(Epoch1_basal{k},lowMov_basal{k})));
    durWake_pre_lowMov_basal(k) = durTWake1;
    [durWake2,durTWake2]=DurationEpoch(and(f{k}.Wake,and(Epoch1_basal{k},highMov_basal{k})));
    durWake_pre_highMov_basal(k) = durTWake2;
    [durWake3,durTWake3]=DurationEpoch(and(f{k}.Wake,and(Epoch2_basal{k},lowMov_basal{k})));
    durWake_post_lowMov_basal(k) = durTWake3;
    [durWake4,durTWake4]=DurationEpoch(and(f{k}.Wake,and(Epoch2_basal{k},highMov_basal{k})));
    durWake_post_highMov_basal(k) = durTWake4;
    
                [durWake5,durTWake5]=DurationEpoch(and(f{k}.Wake,Epoch1_basal{k}));
    durWake_pre_basal(k) = durTWake5;
            [durWake6,durTWake6]=DurationEpoch(and(f{k}.Wake,Epoch2_basal{k}));
    durWake_post_basal(k) = durTWake6;


    % duration NREM before/after injection
    [durSWS1,durTSWS1]=DurationEpoch(and(f{k}.SWSEpoch,Epoch1_basal{k}));
    durSWS_pre_basal(k) = durTSWS1;
    [durSWS2,durTSWS2]=DurationEpoch(and(f{k}.SWSEpoch,Epoch2_basal{k}));
    durSWS_post_basal(k) = durTSWS2;
    % duration REM before/after injection
    [durREM1,durTREM1]=DurationEpoch(and(f{k}.REMEpoch,Epoch1_basal{k}));
    durREM_pre_basal(k) = durTREM1;
    [durREM2,durTREM2]=DurationEpoch(and(f{k}.REMEpoch,Epoch2_basal{k}));
    durREM_post_basal(k) = durTREM2;
    % total duration before/after
    durTOT_pre_basal(k) = durWake_pre_lowMov_basal(k)+durWake_pre_highMov_basal(k)+durSWS_pre_basal(k)+durREM_pre_basal(k);
    durTOT_post_basal(k) = durWake_post_lowMov_basal(k)+durWake_post_highMov_basal(k)+durSWS_post_basal(k)+durREM_post_basal(k);

    % calculate percentage of wake with high/low activity
    Perc_Wake_pre_lowMov_basal(k) = durWake_pre_lowMov_basal(k)/durTOT_pre_basal(k)*100; Perc_Wake_pre_lowMov_basal(Perc_Wake_pre_lowMov_basal==0)=NaN;
    Perc_Wake_pre_highMov_basal(k) = durWake_pre_highMov_basal(k)/durTOT_pre_basal(k)*100; Perc_Wake_pre_highMov_basal(Perc_Wake_pre_highMov_basal==0)=NaN;
    Perc_Wake_post_lowMov_basal(k) = durWake_post_lowMov_basal(k)/durTOT_post_basal(k)*100; Perc_Wake_post_lowMov_basal(Perc_Wake_post_lowMov_basal==0)=NaN;
    Perc_Wake_post_highMov_basal(k) = durWake_post_highMov_basal(k)/durTOT_post_basal(k)*100; Perc_Wake_post_highMov_basal(Perc_Wake_post_highMov_basal==0)=NaN;
    
        Perc_Wake_pre_basal(k) = durWake_pre_basal(k)/durTOT_pre_basal(k)*100; Perc_Wake_pre_basal(Perc_Wake_pre_basal==0)=NaN;
    Perc_Wake_post_basal(k) = durWake_post_basal(k)/durTOT_post_basal(k)*100; Perc_Wake_post_basal(Perc_Wake_post_basal==0)=NaN;
    end
end


%% get the data saline
for i=1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    a{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    % separate recording before/after injection
    durtotal_sal{i} = max([max(End(a{i}.Wake)),max(End(a{i}.SWSEpoch))]);
    Epoch1_sal{i} = intervalSet(0,durtotal_sal{i}/2);
    Epoch2_sal{i} = intervalSet(durtotal_sal{i}/2,durtotal_sal{i});
    
    b{i} = load('behavResources.mat', 'Vtsd');
    % threshold on speed to get period of high/low activity
    thresh_sal{i} = mean(Data(b{i}.Vtsd))+std(Data(b{i}.Vtsd));
    highMov_sal{i} = thresholdIntervals(b{i}.Vtsd, thresh_sal{i}, 'Direction', 'Above');
    lowMov_sal{i} = thresholdIntervals(b{i}.Vtsd, thresh_sal{i}, 'Direction', 'Below');
    
    % calculate duration of wake with high/low activity
    [durWake1,durTWake1]=DurationEpoch(and(a{i}.Wake,and(Epoch1_sal{i},lowMov_sal{i})));
    durWake_pre_lowMov_sal(i) = durTWake1;
    [durWake2,durTWake2]=DurationEpoch(and(a{i}.Wake,and(Epoch1_sal{i},highMov_sal{i})));
    durWake_pre_highMov_sal(i) = durTWake2;
    [durWake3,durTWake3]=DurationEpoch(and(a{i}.Wake,and(Epoch2_sal{i},lowMov_sal{i})));
    durWake_post_lowMov_sal(i) = durTWake3;
    [durWake4,durTWake4]=DurationEpoch(and(a{i}.Wake,and(Epoch2_sal{i},highMov_sal{i})));
    durWake_post_highMov_sal(i) = durTWake4;
    
            [durWake5,durTWake5]=DurationEpoch(and(a{i}.Wake,Epoch1_sal{i}));
    durWake_pre_sal(i) = durTWake5;
            [durWake6,durTWake6]=DurationEpoch(and(a{i}.Wake,Epoch2_sal{i}));
    durWake_post_sal(i) = durTWake6;
    
    % duration NREM before/after injection
    [durSWS1,durTSWS1]=DurationEpoch(and(a{i}.SWSEpoch,Epoch1_sal{i}));
    durSWS_pre_sal(i) = durTSWS1;
    [durSWS2,durTSWS2]=DurationEpoch(and(a{i}.SWSEpoch,Epoch2_sal{i}));
    durSWS_post_sal(i) = durTSWS2;
    % duration REM before/after injection
    [durREM1,durTREM1]=DurationEpoch(and(a{i}.REMEpoch,Epoch1_sal{i}));
    durREM_pre_sal(i) = durTREM1;
    [durREM2,durTREM2]=DurationEpoch(and(a{i}.REMEpoch,Epoch2_sal{i}));
    durREM_post_sal(i) = durTREM2;
    % total duration before/after
    durTOT_pre_sal(i) = durWake_pre_lowMov_sal(i)+durWake_pre_highMov_sal(i)+durSWS_pre_sal(i)+durREM_pre_sal(i);
    durTOT_post_sal(i) = durWake_post_lowMov_sal(i)+durWake_post_highMov_sal(i)+durSWS_post_sal(i)+durREM_post_sal(i);

    % calculate percentage of wake with high/low activity
    Perc_Wake_pre_lowMov_sal(i) = durWake_pre_lowMov_sal(i)/durTOT_pre_sal(i)*100; Perc_Wake_pre_lowMov_sal(Perc_Wake_pre_lowMov_sal==0)=NaN;
    Perc_Wake_pre_highMov_sal(i) = durWake_pre_highMov_sal(i)/durTOT_pre_sal(i)*100; Perc_Wake_pre_highMov_sal(Perc_Wake_pre_highMov_sal==0)=NaN;
    Perc_Wake_post_lowMov_sal(i) = durWake_post_lowMov_sal(i)/durTOT_post_sal(i)*100; Perc_Wake_pre_highMov_sal(Perc_Wake_pre_highMov_sal==0)=NaN;
    Perc_Wake_post_highMov_sal(i) = durWake_post_highMov_sal(i)/durTOT_post_sal(i)*100; Perc_Wake_post_highMov_sal(Perc_Wake_post_highMov_sal==0)=NaN;
    
    Perc_Wake_pre_sal(i) = durWake_pre_sal(i)/durTOT_pre_sal(i)*100; Perc_Wake_pre_sal(Perc_Wake_pre_sal==0)=NaN;
    Perc_Wake_post_sal(i) = durWake_post_sal(i)/durTOT_post_sal(i)*100; Perc_Wake_post_sal(Perc_Wake_post_sal==0)=NaN;
end

%% get data CNO
for j=1:length(DirCNO.path)
    cd(DirCNO.path{j}{1});
    d{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    % separate recording before/after injection
    durtotal_cno{j} = max([max(End(d{j}.Wake)),max(End(d{j}.SWSEpoch))]);
    Epoch1_cno{j} = intervalSet(0,durtotal_cno{j}/2);
    Epoch2_cno{j} = intervalSet(durtotal_cno{j}/2,durtotal_cno{j});
    
    % threshold on speed to get period of high/low activity
    e{j} = load('behavResources.mat', 'Vtsd');
    thresh_cno{j} = mean(Data(e{j}.Vtsd))+std(Data(e{j}.Vtsd));
    highMov_cno{j} = thresholdIntervals(e{j}.Vtsd, thresh_cno{j}, 'Direction', 'Above');
    lowMov_cno{j} = thresholdIntervals(e{j}.Vtsd, thresh_cno{j}, 'Direction', 'Below');

    % calculate duration of wake with high/low activity
    [durWake1,durTWake1]=DurationEpoch(and(d{j}.Wake,and(Epoch1_cno{j},lowMov_cno{j})));
    durWake_pre_lowMov_cno(j) = durTWake1;
    [durWake2,durTWake2]=DurationEpoch(and(d{j}.Wake,and(Epoch1_cno{j},highMov_cno{j})));
    durWake_pre_highMov_cno(j) = durTWake2;
    [durWake3,durTWake3]=DurationEpoch(and(d{j}.Wake,and(Epoch2_cno{j},lowMov_cno{j})));
    durWake_post_lowMov_cno(j) = durTWake3;
    [durWake4,durTWake4]=DurationEpoch(and(d{j}.Wake,and(Epoch2_cno{j},highMov_cno{j})));
    durWake_post_highMov_cno(j) = durTWake4;
    
    [durWake5,durTWake5]=DurationEpoch(and(d{j}.Wake,Epoch1_cno{j}));
    durWake_pre_cno(j) = durTWake5;
    [durWake6,durTWake6]=DurationEpoch(and(d{j}.Wake,Epoch2_cno{j}));
    durWake_post_cno(j) = durTWake6;
    
    % duration NREM before/after injection
    [durSWS1,durTSWS1]=DurationEpoch(and(d{j}.SWSEpoch,Epoch1_cno{j}));
    durSWS_pre_cno(j) = durTSWS1;
    [durSWS2,durTSWS2]=DurationEpoch(and(d{j}.SWSEpoch,Epoch2_cno{j}));
    durSWS_post_cno(j) = durTSWS2;
    % duration REM before/after injection
    [durREM1,durTREM1]=DurationEpoch(and(d{j}.REMEpoch,Epoch1_cno{j}));
    durREM_pre_cno(j) = durTREM1;
    [durREM2,durTREM2]=DurationEpoch(and(d{j}.REMEpoch,Epoch2_cno{j}));
    durREM_post_cno(j) = durTREM2;
    % total duration before/after
    durTOT_pre_cno(j) = durWake_pre_lowMov_cno(j)+durWake_pre_highMov_cno(j)+durSWS_pre_cno(j)+durREM_pre_cno(j);
    durTOT_post_cno(j) = durWake_post_lowMov_cno(j)+durWake_post_highMov_cno(j)+durSWS_post_cno(j)+durREM_post_cno(j);

    % calculate percentage of wake with high/low activity
    Perc_Wake_pre_lowMov_cno(j) = durWake_pre_lowMov_cno(j)/durTOT_pre_cno(j)*100; Perc_Wake_pre_lowMov_cno(Perc_Wake_pre_lowMov_cno==0)=NaN;
    Perc_Wake_pre_highMov_cno(j) = durWake_pre_highMov_cno(j)/durTOT_pre_cno(j)*100; Perc_Wake_pre_highMov_cno(Perc_Wake_pre_highMov_cno==0)=NaN;
    Perc_Wake_post_lowMov_cno(j) = durWake_post_lowMov_cno(j)/durTOT_post_cno(j)*100; Perc_Wake_post_lowMov_cno(Perc_Wake_post_lowMov_cno==0)=NaN;
    Perc_Wake_post_highMov_cno(j) = durWake_post_highMov_cno(j)/durTOT_post_cno(j)*100; Perc_Wake_post_highMov_cno(Perc_Wake_post_highMov_cno==0)=NaN;
    
        Perc_Wake_pre_cno(j) = durWake_pre_cno(j)/durTOT_pre_cno(j)*100; Perc_Wake_pre_cno(Perc_Wake_pre_cno==0)=NaN;
    Perc_Wake_post_cno(j) = durWake_post_cno(j)/durTOT_post_cno(j)*100; Perc_Wake_post_cno(Perc_Wake_post_cno==0)=NaN;
end

%% figure
figure, subplot(221), PlotErrorBarN_KJ({Perc_Wake_pre_lowMov_sal Perc_Wake_pre_lowMov_cno},'newfig',0,'paired',0);
title('WAKE lowMov PRE inj')
ylim([0 48])
ylabel('Percentage (%)')
makepretty
subplot(222), PlotErrorBarN_KJ({Perc_Wake_post_lowMov_sal Perc_Wake_post_lowMov_cno},'newfig',0,'paired',0);
title('WAKE lowMov POST inj')
ylim([0 48])
ylabel('Percentage (%)')
makepretty
subplot(223), PlotErrorBarN_KJ({Perc_Wake_pre_highMov_sal Perc_Wake_pre_highMov_cno},'newfig',0,'paired',0);
title('WAKE highMov PRE inj')
ylim([0 48])
ylabel('Percentage (%)')
makepretty
subplot(224), PlotErrorBarN_KJ({Perc_Wake_post_highMov_sal Perc_Wake_post_highMov_cno},'newfig',0,'paired',0);
title('WAKE highMov POST inj')
ylim([0 48])
ylabel('Percentage (%)')
makepretty


%%
col_pre_basal = [0.8 0.8 0.8];
col_post_basal = [0.8 0.8 0.8];

% col_pre_saline = [1 0.6 0.6]; %%rose
% col_post_saline = [1 0.6 0.6];
% col_pre_cno = [1 0 0]; %rouge
% col_post_cno = [1 0 0];

col_pre_saline = [0.3 0.3 0.3]; %vert
col_post_saline = [0.3 0.3 0.3];
col_pre_cno = [0.4 1 0.2]; %vert
col_post_cno = [0.4 1 0.2];


figure, 
subplot(131),
MakeBoxPlot_MC({Perc_Wake_pre_basal Perc_Wake_pre_sal Perc_Wake_pre_cno Perc_Wake_post_basal Perc_Wake_post_sal Perc_Wake_post_cno} ,...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);

subplot(132),
MakeBoxPlot_MC({Perc_Wake_pre_lowMov_basal Perc_Wake_pre_lowMov_sal Perc_Wake_pre_lowMov_cno Perc_Wake_post_lowMov_basal Perc_Wake_post_lowMov_sal Perc_Wake_post_lowMov_cno} ,...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);


subplot(133), 
MakeBoxPlot_MC({Perc_Wake_pre_highMov_basal Perc_Wake_pre_highMov_sal Perc_Wake_pre_highMov_cno Perc_Wake_post_highMov_basal Perc_Wake_post_highMov_sal Perc_Wake_post_highMov_cno} ,...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);

