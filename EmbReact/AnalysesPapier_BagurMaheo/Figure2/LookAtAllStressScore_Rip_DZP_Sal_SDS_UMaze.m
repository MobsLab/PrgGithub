clear all

%% Get data
VarNames = {'Prop wake','Prop REM','HR','Thigmo'};
AllDatSal = GetStressScoreValuesSaline_UMaze;
[AllDat.DZP{1},AllDat.DZP{2}] = GetStressScoreValuesDZP_UMaze;
[AllDat.Rip{1},AllDat.Rip{2}] = GetStressScoreValuesRippleCtrlInhib_UMaze;
[AllDat.SDS{1},AllDat.SDS{2}] = GetStressScoreValuesSDS_UMaze;
GroupNames = fieldnames(AllDat);

%% Choose which variables to include
VarToUse = [1:4];
AllDatSal = AllDatSal(VarToUse,:);
for group = 1:length(GroupNames)
    for subgroup = 1:2
        AllDat.(GroupNames{group}){subgroup} = AllDat.(GroupNames{group}){subgroup}(VarToUse,:);
    end
end
VarNames = VarNames(VarToUse);

%% Get PCA from saline animals
AllDatSal = AllDatSal(:,sum(isnan(AllDatSal))==0);
StdTouse = nanstd(AllDatSal')';
MnTouse = nanmean(AllDatSal')';
AllDatSal = (AllDatSal - repmat(MnTouse,1,size(AllDatSal,2)))./repmat(StdTouse,1,size(AllDatSal,2));
[EigVect,EigVals]=PerformPCA(AllDatSal);
for mm = 1:size(AllDatSal,2)
    PCVal(mm) = nanmean(EigVect(:,1)'.*AllDatSal(:,mm)');
end
% Plot PCA weights
figure
bar(EigVect(:,1))
set(gca,'XTick',[1:4],'XTickLabel',VarNames)
makepretty
title([num2str(100*EigVals(1)/sum(EigVals)) ' % var'])

%% Apply to each gruop
for group = 1:length(GroupNames)
    for subgroup = 1:2
        % Define std and mean on contorl group for z-score
        StdTouse = nanstd([AllDat.(GroupNames{group}){1}]')';
        MnTouse = nanmean([AllDat.(GroupNames{group}){1}]')';
        
        AllDat_all = (AllDat.(GroupNames{group}){subgroup} - repmat(MnTouse,1,size(AllDat.(GroupNames{group}){subgroup} ,2)))./repmat(StdTouse,1,size(AllDat.(GroupNames{group}){subgroup} ,2));
        for mm = 1:size(AllDat.(GroupNames{group}){subgroup} ,2)
            StressScore.(GroupNames{group}){subgroup}(mm) = nanmean(EigVect(:,1)'.*AllDat_all(:,mm)');
        end
    end
end
%% Plot all stress score params
figure
clear pval stats_out
for group = 1:length(GroupNames)
    for var = 1:length(VarToUse)
        subplot(length(VarToUse)+1,length(GroupNames),group+(length(GroupNames))*(var-1))
        [pvaltemp , statstemp]=MakeSpreadAndBoxPlot2_SB({AllDat.(GroupNames{group}){1}(var,:),AllDat.(GroupNames{group}){2}(var,:)},...
            {},[1,2],{'Ctrl',GroupNames{group}},'paired',0,'showpoints',1);
        ylabel(VarNames{var})
        pval(group,var) = pvaltemp(1,2);
        stats_out(group,var) = statstemp(1,2);
    end
    
    subplot(length(VarToUse)+1,length(GroupNames),group+(length(GroupNames))*(var))
    [pvaltemp , statstemp]=MakeSpreadAndBoxPlot2_SB({StressScore.(GroupNames{group}){1}(:),StressScore.(GroupNames{group}){2}(:)},...
        {},[1,2],{'Ctrl',GroupNames{group}},'paired',0,'showpoints',1);
    pval(group,var+1) = pvaltemp(1,2);
    stats_out(group,var+1) = statstemp(1,2);
    ylabel('Stress Score')
    n_mouse(group) = length(AllDat.(GroupNames{group}){1}(var,:));
end

for var = 1:length(VarToUse)+1
    for group = 1:length(GroupNames)
        subplot(length(VarToUse)+1,length(GroupNames),group+(length(GroupNames))*(var-1))
        YL(group,:) = ylim;
    end
    for group = 1:length(GroupNames)
        subplot(length(VarToUse)+1,length(GroupNames),group+(length(GroupNames))*(var-1))
        ylim([min(YL(:)) max(YL(:))])
    end    
end


%% Relate to heart rate during the task
