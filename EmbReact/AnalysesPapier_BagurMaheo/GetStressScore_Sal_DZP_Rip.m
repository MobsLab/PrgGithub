function StressScore = GetStressScore_Sal_DZP_Rip
VarToUse = [1:4];

%% Get data
VarNames = {'Prop wake','Prop REM','HR','Thigmo'};
AllDat.Sal{1} = GetStressScoreValuesSaline_UMaze;
[AllDat.DZP{1},AllDat.DZP{2}] = GetStressScoreValuesDZP_UMaze;
[AllDat.Rip{1},AllDat.Rip{2}] = GetStressScoreValuesRippleCtrlInhib_UMaze;
GroupNames = fieldnames(AllDat);

%% Choose which variables to include
for group = 1:length(GroupNames)
    for subgroup = 1:length(AllDat.Sal)
        AllDat.(GroupNames{group}){subgroup} = AllDat.(GroupNames{group}){subgroup}(VarToUse,:);
    end
end
VarNames = VarNames(VarToUse);

%% Get PCA from saline animals
AllDat.Sal{1} = AllDat.Sal{1}(:,sum(isnan(AllDat.Sal{1}))==0);
StdTouse = nanstd(AllDat.Sal{1}')';
MnTouse = nanmean(AllDat.Sal{1}')';
AllDat.Sal{1} = (AllDat.Sal{1} - repmat(MnTouse,1,size(AllDat.Sal{1},2)))./repmat(StdTouse,1,size(AllDat.Sal{1},2));
[EigVect,EigVals]=PerformPCA(AllDat.Sal{1});


%% Apply to each gruop
for group = 1:length(GroupNames)
    for subgroup = 1:length(AllDat.(GroupNames{group}))
        % Define std and mean on contorl group for z-score
        StdTouse = nanstd([AllDat.(GroupNames{group}){1}]')';
        MnTouse = nanmean([AllDat.(GroupNames{group}){1}]')';
        
        AllDat_all = (AllDat.(GroupNames{group}){subgroup} - repmat(MnTouse,1,size(AllDat.(GroupNames{group}){subgroup} ,2)))./repmat(StdTouse,1,size(AllDat.(GroupNames{group}){subgroup} ,2));
        for mm = 1:size(AllDat.(GroupNames{group}){subgroup} ,2)
            StressScore.(GroupNames{group}){subgroup}(mm) = nanmean(EigVect(:,1)'.*AllDat_all(:,mm)');
        end
    end
end
