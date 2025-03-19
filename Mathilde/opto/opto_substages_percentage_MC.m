

%% dir
DirCtrl = PathForExperiments_Opto_MC('PFC_Control_20Hz');
DirCtrl = RestrictPathForExperiment(DirCtrl, 'nMice', [1075 1111 1112 1180 1181]);

DirOpto = PathForExperiments_Opto_MC('PFC_Stim_20Hz');

% DirOpto = RestrictPathForExperiment(DirOpto, 'nMice', [675 733 1074 1136 1076 1137 1109]);%648
DirOpto = RestrictPathForExperiment(DirOpto, 'nMice', [675 733 1074 1076 1136 1137]);%648

%% BASELINE
for i=1:length(DirCtrl.path)
    cd(DirCtrl.path{i}{1});

    if exist('SleepSubstages.mat')==2
        a{i} = load('SleepSubstages.mat','Epoch');
    %%rename epoch
    SWSEpoch{i} = a{i}.Epoch{7}; Wake{i} = a{i}.Epoch{4}; REMEpoch{i} = a{i}.Epoch{5};
    N1{i} = a{i}.Epoch{1}; N2{i} = a{i}.Epoch{2}; N3{i} = a{i}.Epoch{3}; %TOTsleep{i} = a{i}.Epoch{10};
    
    TOTsleep{i} = or(REMEpoch{i},SWSEpoch{i});
    
    %%separate day in different periods
    durtotal{i} = max([max(End(Wake{i})),max(End(SWSEpoch{i}))]);

    
    %%Number of bouts pre injection
    numN1_basal(i)=length(length(and(N1{i},TOTsleep{i})));
    numN2_basal(i)=length(length(and(N2{i},TOTsleep{i})));
    numN3_basal(i)=length(length(and(N3{i},TOTsleep{i})));
    numREM_basal(i)=length(length(and(REMEpoch{i},TOTsleep{i})));


    %%Mean duration of bouts pre injection
    durN1_basal(i)=mean(End(and(N1{i},TOTsleep{i}))-Start(and(N1{i},TOTsleep{i})))/1E4;
    durN2_basal(i)=mean(End(and(N2{i},TOTsleep{i}))-Start(and(N2{i},TOTsleep{i})))/1E4;
    durN3_basal(i)=mean(End(and(N3{i},TOTsleep{i}))-Start(and(N3{i},TOTsleep{i})))/1E4;
    durREM_basal(i)=mean(End(and(REMEpoch{i},TOTsleep{i}))-Start(and(REMEpoch{i},TOTsleep{i})))/1E4;

    
            path_mice_to_check{i} = DirCtrl.path{i}{1};
    Restemp_basal{i}=ComputeSleepSubStagesPercentagesWithoutWake_MC(a{i}.Epoch,0);
    % Res(1,:) donne le N1
    % Res(2,:) donne le N2
    % Res(3,:) donne le N3
    % Res(4,:) donne le WAKE
    % Res(5,:) donne le REM
    %
    % Res(x,1) all recording
    % Res(x,2) first half / pre injection
    % Res(x,3) second half / post injection
    % Res(x,4) restricted to 3 hours post injection
    
    %%percentage pre injection
    percN1_basal(i) = Restemp_basal{i}(1,2); percN1_basal(percN1_basal==0)=NaN;
    percN2_basal(i) = Restemp_basal{i}(2,2); percN2_basal(percN2_basal==0)=NaN;
    percN3_basal(i) = Restemp_basal{i}(3,2); percN3_basal(percN3_basal==0)=NaN;
    percREM_basal(i) = Restemp_basal{i}(5,2); percREM_basal(percREM_basal==0)=NaN;


    else
        
        
        %%Number of bouts pre injection
    numN1_basal(i)=NaN;
    numN2_basal(i)=NaN;
    numN3_basal(i)=NaN;
    numREM_basal(i)=NaN;

    %%Mean duration of bouts pre injection
    durN1_basal(i)=NaN;
    durN2_basal(i)=NaN;
    durN3_basal(i)=NaN;
    durREM_basal(i)=NaN;

        
    
    
    end    
end




%% opto
for k=1:length(DirOpto.path)
    cd(DirOpto.path{k}{1});
    c{k} = load('SleepSubstages.mat','Epoch');
    %%rename epoch
    SWSEpoch{k} = c{k}.Epoch{7}; Wake{k} = c{k}.Epoch{4}; REMEpoch{k} = c{k}.Epoch{5};
    N1{k} = c{k}.Epoch{1}; N2{k} = c{k}.Epoch{2}; N3{k} = c{k}.Epoch{3}; %TOTsleep{k} = c{k}.Epoch{10};
    TOTsleep{k} = or(REMEpoch{k},SWSEpoch{k});
    
    %%separate day in different periods
    durtotal{k} = max([max(End(Wake{k})),max(End(SWSEpoch{k}))]);

    
    %%Number of bouts pre injection
    numN1_opto(k)=length(length(and(N1{k},TOTsleep{k})));
    numN2_opto(k)=length(length(and(N2{k},TOTsleep{k})));
    numN3_opto(k)=length(length(and(N3{k},TOTsleep{k})));
    numREM_opto(k)=length(length(and(REMEpoch{k},TOTsleep{k})));


    

    %%Mean duration of bouts pre injection
    durN1_otpo(k)=mean(End(and(N1{k},TOTsleep{k}))-Start(and(N1{k},TOTsleep{k})))/1E4;
    durN2_opto(k)=mean(End(and(N2{k},TOTsleep{k}))-Start(and(N2{k},TOTsleep{k})))/1E4;
    durN3_opto(k)=mean(End(and(N3{k},TOTsleep{k}))-Start(and(N3{k},TOTsleep{k})))/1E4;
    durREM_otpo(k)=mean(End(and(REMEpoch{k},TOTsleep{k}))-Start(and(REMEpoch{k},TOTsleep{k})))/1E4;

    %%percentage
    Restemp_cno{k}=ComputeSleepSubStagesPercentagesWithoutWake_MC(c{k}.Epoch,0);
    % Res(1,:) donne le N1
    % Res(2,:) donne le N2
    % Res(3,:) donne le N3
    % Res(4,:) donne le WAKE
    % Res(5,:) donne le REM
    %
    % Res(x,1) all recording
    % Res(x,2) first half / pre injection
    % Res(x,3) second half / post injection
    % Res(x,4) restricted to 3 hours post injection
    
    %%percentage pre injection
    percN1_opto(k) = Restemp_cno{k}(1,2);
    percN2_opto(k) = Restemp_cno{k}(2,2);
    percN3_opto(k) = Restemp_cno{k}(3,2);
    percREM_opto(k) = Restemp_cno{k}(5,2);


end

%%




%% figure (boxplot)
%%
col_pre_basal = [0.8 0.8 0.8];
col_pre_cno = [0 .6 .8]; %bleu


% col_pre_basal = [0.8 0.8 0.8];
% col_post_basal = [0.8 0.8 0.8];
% col_pre_saline = [1 0.6 0.6]; %%rose
% col_post_saline = [1 0.6 0.6];
% col_pre_cno = [1 0 0]; %rouge
% col_post_cno = [1 0 0];



figure
%%percentage
ax(1)=subplot(331),MakeBoxPlot_MC({percN1_basal percN1_opto},...
    {col_pre_basal col_pre_cno},[1:2],{},1,0);
xticks([1 2]); xticklabels({'Ctrl','ChR2'})
ylabel('N1 percentage (%)')
makepretty
ax(2)=subplot(332),MakeBoxPlot_MC({percN2_basal percN2_opto},...
    {col_pre_basal col_pre_cno},[1:2],{},1,0);
xticks([1 2]); xticklabels({'Ctrl','ChR2'})
ylabel('N2 percentage (%)')
makepretty
ax(3)=subplot(333),MakeBoxPlot_MC({percN3_basal percN3_opto},...
    {col_pre_basal col_pre_cno},[1:2],{},1,0);
xticks([1 2]); xticklabels({'Ctrl','ChR2'})
ylabel('N3 percentage (%)')
makepretty
%%number
ax(4)=subplot(334),MakeBoxPlot_MC({numN1_basal numN1_opto},...
    {col_pre_basal col_pre_cno},[1:2],{},1,0);
xticks([1 2]); xticklabels({'Ctrl','ChR2'})
ylabel('# N1')
makepretty
ax(5)=subplot(335),MakeBoxPlot_MC({numN2_basal numN2_opto},...
    {col_pre_basal col_pre_cno},[1:2],{},1,0);
xticks([1 2]); xticklabels({'Ctrl','ChR2'})
ylabel('# N2')
makepretty
ax(6)=subplot(336),MakeBoxPlot_MC({numN3_basal numN3_opto},...
    {col_pre_basal col_pre_cno},[1:2],{},1,0);
xticks([1 2]); xticklabels({'Ctrl','ChR2'})
ylabel('# N3')
makepretty
%%duration
ax(7)=subplot(337),MakeBoxPlot_MC({durN1_basal durN1_otpo},...
    {col_pre_basal col_pre_cno},[1:2],{},1,0);
xticks([1 2]); xticklabels({'Ctrl','ChR2'})
ylabel('Mean duration of N1 (s)')
makepretty
ax(8)=subplot(338),MakeBoxPlot_MC({durN2_basal durN2_opto},...
    {col_pre_basal col_pre_cno},[1:2],{},1,0);
xticks([1 2]); xticklabels({'Ctrl','ChR2'})
ylabel('Mean duration of N2 (s)')
makepretty
ax(9)=subplot(339),MakeBoxPlot_MC({durN3_basal durN3_opto},...
    {col_pre_basal col_pre_cno},[1:2],{},1,0);
xticks([1 2]); xticklabels({'Ctrl','ChR2'})
ylabel('Mean duration of N3 (s)')
makepretty

