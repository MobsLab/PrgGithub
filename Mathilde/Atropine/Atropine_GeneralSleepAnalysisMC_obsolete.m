
%% input dir
DirAtropineMC = PathForExperimentsAtropine_MC('Atropine');
DirBaselineMC = PathForExperimentsAtropine_MC('BaselineSleep');

DirAtropineTG = PathForExperiments_TG('atropine_Atropine');
DirBaselineTG = PathForExperiments_TG('atropine_Baseline');


% DirAtropine = MergePathForExperiment(DirAtropineMC, DirAtropineTG);

DirBaseline = MergePathForExperiment(DirBaselineMC, DirBaselineTG);

% DirAtropine=PathForExperiments_TG('atropine_Atropine');
%%

ResWakeSal_half1=[];
ResSWSSal_half1=[];
ResREMSal_half1=[];
ResWakeSal_half2=[];
ResSWSsal_half2=[];
ResREMsal_half2=[];
% variables pour les souris salines
for i=1:length(DirBaselineMC.path)
    cd(DirBaselineMC.path{i}{1});
    load SleepScoring_OBGamma REMEpoch SWSEpoch Wake %choose the sleep scoring you want
    
    durtotal=max([max(End(Wake)),max(End(SWSEpoch))]);
    Epoch1=intervalSet(0,durtotal/2); %pour ne considérer que la première moitié de la session (avant injection)
    Epoch2=intervalSet(durtotal/2,durtotal); %pour ne considérer que la deuxième moitié de la session (après injection)
    
    Restemp=ComputeSleepStagesPercAfterInjectionMC(Wake,SWSEpoch,REMEpoch);
    
    ResWakeSal_half1=[ResWakeSal_half1;Restemp(1,2)]; % vecteur avec les % de Wake pour souris salines dans la 1ere moitié de la session
    % (1,:) pour avoir le wake et (x,2) pour avoir la scde moitié de la session
    ResSWSSal_half1=[ResSWSSal_half1;Restemp(2,2)]; % idem NREM
    ResREMSal_half1=[ResREMSal_half1;Restemp(3,2)]; % idem REM
    
    ResWakeSal_half2=[ResWakeSal_half2;Restemp(1,3)]; % vecteur avec les % de Wake pour souris salines dans la 2nde moitié de la session
    % (1,:) pour avoir le wake et (x,3) pour avoir la scde moitié de la session
    ResSWSsal_half2=[ResSWSsal_half2;Restemp(2,3)]; % idem NREM
    ResREMsal_half2=[ResREMsal_half2;Restemp(3,3)]; % idem REM
    
    NbSWSsal_half1(i)=length(length(and(SWSEpoch,Epoch1))); % vecteur avec le nombre d'épisodes de NREM pour les salines AVANT injection
    NbWakeSal_half1(i)=length(length(and(Wake,Epoch1)));
    NbREMsal_half1(i)=length(length(and(REMEpoch,Epoch1)));
    
    NbSWSsal_half2(i)=length(length(and(SWSEpoch,Epoch2))); % vecteur avec le nombre d'épisodes de NREM pour les salines APRES injection
    NbWakeSal_half2(i)=length(length(and(Wake,Epoch2)));
    NbREMsal_half2(i)=length(length(and(REMEpoch,Epoch2)));
    
    durWakeSal_half1(i)=mean(End(and(Wake,Epoch1))-Start(and(Wake,Epoch1)))/1E4; % vecteur avec la durée moyenne des épisodes de Wake pour les salines AVANT injection
    durSWSsal_half1(i)=mean(End(and(SWSEpoch,Epoch1))-Start(and(SWSEpoch,Epoch1)))/1E4;
    durREMsal_half1(i)=mean(End(and(REMEpoch,Epoch1))-Start(and(REMEpoch,Epoch1)))/1E4;
    
    durWakeSal_half2(i)=mean(End(and(Wake,Epoch2))-Start(and(Wake,Epoch2)))/1E4; % vecteur avec la durée moyenne des épisodes de Wake pour les salines APRES injection
    durSWSsal_half2(i)=mean(End(and(SWSEpoch,Epoch2))-Start(and(SWSEpoch,Epoch2)))/1E4;
    durREMsal_half2(i)=mean(End(and(REMEpoch,Epoch2))-Start(and(REMEpoch,Epoch2)))/1E4;
    
    clear Wake REMEpoch SWSEpoch
end

ResWakeAtropine_half1=[];
ResSWSAtropine_half1=[];
ResREMAtropine_half1=[];
ResWakeAtropine_half2=[];
ResSWSAtropine_half2=[];
ResREMAtropine_half2=[];
% variables pour les souris
% atropine
for j=1:length(DirAtropineMC.path)
    cd(DirAtropineMC.path{j}{1});
    load SleepScoring_OBGamma REMEpoch SWSEpoch Wake

    durtotal=max([max(End(Wake)),max(End(SWSEpoch))]);
    Epoch1=intervalSet(0,durtotal/2);
    Epoch2=intervalSet(durtotal/2,durtotal);
    
    Restemp=ComputeSleepStagesPercAfterInjectionMC(Wake,SWSEpoch,REMEpoch);
    
    ResWakeAtropine_half1 = [ResWakeAtropine_half1;Restemp(1,2)];
    ResSWSAtropine_half1 = [ResSWSAtropine_half1;Restemp(2,2)];
    ResREMAtropine_half1 = [ResREMAtropine_half1;Restemp(3,2)];
    
    ResWakeAtropine_half2 = [ResWakeAtropine_half2;Restemp(1,3)];
    ResSWSAtropine_half2 = [ResSWSAtropine_half2;Restemp(2,3)];
    ResREMAtropine_half2 = [ResREMAtropine_half2;Restemp(3,3)];
    
    NbSWSAtropine_half1(j) = length(length(and(SWSEpoch,Epoch1)));
    NbWakeAtropine_half1(j) = length(length(and(Wake,Epoch1)));
    NbREMAtropine_half1(j) = length(length(and(REMEpoch,Epoch1)));
    
    NbSWSAtropine_half2(j) = length(length(and(SWSEpoch,Epoch2)));
    NbWakeAtropine_half2(j) = length(length(and(Wake,Epoch2)));
    NbREMAtropine_half2(j) = length(length(and(REMEpoch,Epoch2)));
    
    durWakeAtropine_half1(j) = mean(End(and(Wake,Epoch1))-Start(and(Wake,Epoch1)))/1E4;
    durSWSAtropine_half1(j) = mean(End(and(SWSEpoch,Epoch1))-Start(and(SWSEpoch,Epoch1)))/1E4;
    durREMAtropine_half1(j) = mean(End(and(REMEpoch,Epoch1))-Start(and(REMEpoch,Epoch1)))/1E4;
    
    durWakeAtropine_half2(j) = mean(End(and(Wake,Epoch2))-Start(and(Wake,Epoch2)))/1E4;
    durSWSAtropine_half2(j) = mean(End(and(SWSEpoch,Epoch2))-Start(and(SWSEpoch,Epoch2)))/1E4;
    durREMAtropine_half2(j) = mean(End(and(REMEpoch,Epoch2))-Start(and(REMEpoch,Epoch2)))/1E4;
    
    clear Wake REMEpoch SWSEpoch
end

%%
% pourcentage
% before injection
figure,subplot(171),PlotErrorBarN_KJ({ResWakeSal_half1(:,1),ResWakeAtropine_half1(:,1)},'newfig',0,'paired',1);
ylim([0,90])
ylabel('Percentage (%)')
xticks([1 2])
xticklabels({'Saline','Atropine'})
title('Wake')
subplot(172),PlotErrorBarN_KJ({ResSWSSal_half1(:,1),ResSWSAtropine_half1(:,1)},'newfig',0,'paired',1);
ylim([0,90])
xticks([1 2])
xticklabels({'Saline','Atropine'})
title('NREM')
subplot(173),PlotErrorBarN_KJ({ResREMSal_half1(:,1),ResREMAtropine_half1(:,1)},'newfig',0,'paired',1);
ylim([0,90])
xticks([1 2])
xticklabels({'Saline','Atropine'})
title('REM')

% after injection
subplot(175),PlotErrorBarN_KJ({ResWakeSal_half2(:,1),ResWakeAtropine_half2(:,1)},'newfig',0,'paired',1);
ylim([0,90])
ylabel('Percentage (%)')
xticks([1 2])
xticklabels({'Saline','Atropine'})
title('Wake')
subplot(176),PlotErrorBarN_KJ({ResSWSsal_half2(:,1),ResSWSAtropine_half2(:,1)},'newfig',0,'paired',1);
ylim([0,90])
xticks([1 2])
xticklabels({'Saline','Atropine'})
title('NREM')
subplot(177),PlotErrorBarN_KJ({ResREMsal_half2(:,1),ResREMAtropine_half2(:,1)},'newfig',0,'paired',1);
ylim([0,90])
xticks([1 2])
xticklabels({'Saline','Atropine'})
title('REM')


%% number of bouts
% mean number of bouts
figure,subplot(171),PlotErrorBarN_KJ({NbWakeSal_half1 NbWakeAtropine_half1},'newfig',0,'paired',1);
xticks([1 2])
xticklabels({'Saline','Atropine'})
ylim([0 900])
ylabel('Number of bouts')
title('Wakefulness')
subplot(172),PlotErrorBarN_KJ({NbSWSsal_half1 NbSWSAtropine_half1},'newfig',0,'paired',1);
xticks([1 2])
xticklabels({'Saline','Atropine'})
ylim([0 900])
title('NREM')
subplot(173),PlotErrorBarN_KJ({NbREMsal_half1 NbREMAtropine_half1},'newfig',0,'paired',1);
xticks([1 2])
xticklabels({'Saline','Atropine'})
ylim([0 900])
title('REM')

subplot(175),PlotErrorBarN_KJ({NbWakeSal_half2 NbWakeAtropine_half2},'newfig',0,'paired',1);
xticks([1 2])
xticklabels({'Saline','Atropine'})
ylim([0 900])
ylabel('Number of bouts')
title('Wakefulness')
subplot(176),PlotErrorBarN_KJ({NbSWSsal_half2 NbSWSAtropine_half2},'newfig',0,'paired',1);
xticks([1 2])
xticklabels({'Saline','Atropine'})
ylim([0 900])
title('NREM')
subplot(177),PlotErrorBarN_KJ({NbREMsal_half2 NbREMAtropine_half2},'newfig',0,'paired',1);
xticks([1 2])
xticklabels({'Saline','Atropine'})
ylim([0 900])
title('REM')


%% bouts duration
% mean duration of bouts
figure,subplot(171),PlotErrorBarN_KJ({durWakeSal_half1 durWakeAtropine_half1},'newfig',0,'paired',1);
xticks([1 2])
xticklabels({'Saline','Atropine'})
ylim([0 140])
ylabel('Duration of bouts')
title('Wakefulness')
subplot(172),PlotErrorBarN_KJ({durSWSsal_half1 durSWSAtropine_half1},'newfig',0,'paired',1);
xticks([1 2])
xticklabels({'Saline','Atropine'})
ylim([0 140])
title('NREM')
subplot(173),PlotErrorBarN_KJ({durREMsal_half1 durREMAtropine_half1},'newfig',0,'paired',1);
xticks([1 2])
xticklabels({'Saline','Atropine'})
ylim([0 140])
title('REM')

subplot(175),PlotErrorBarN_KJ({durWakeSal_half2 durWakeAtropine_half2},'newfig',0,'paired',1);
xticks([1 2])
xticklabels({'Saline','Atropine'})
ylim([0 140])
ylabel('Duration of bouts')
title('Wakefulness')
subplot(176),PlotErrorBarN_KJ({durSWSsal_half2 durSWSAtropine_half2},'newfig',0,'paired',1);
xticks([1 2])
xticklabels({'Saline','Atropine'})
ylim([0 140])
title('NREM')
subplot(177),PlotErrorBarN_KJ({durREMsal_half2 durREMAtropine_half2},'newfig',0,'paired',1);
xticks([1 2])
xticklabels({'Saline','Atropine'})
ylim([0 140])
title('REM')
%%
DirFigure='/home/mobschapeau/Desktop/mathilde/atropine/';
cd(DirFigure);
savefig(fullfile('percent_OBGamma_MathildeMice'))