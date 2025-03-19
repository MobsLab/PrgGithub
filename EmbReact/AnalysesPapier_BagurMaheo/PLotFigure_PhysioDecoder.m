clf
subplot(1,4,1)
plot([0.1:0.1:0.9],testscore,'color',[0.6 0.6 0.6])
hold on
errorbar([0.1:0.1:0.9],nanmean(testscore'),stdError(testscore'),'color','k','linewidth',3)
    ylim([0 1])

subplot(1,4,2)
plot([0.1:0.1:0.9],testscore_shk,'color',[1 0.6 0.6])
hold on
errorbar([0.1:0.1:0.9],nanmean(testscore_shk'),stdError(testscore_shk'),'color','r','linewidth',3)
ylim([0 1])

subplot(1,4,3)
plot([0.1:0.1:0.9],testscore_sf,'color',[0.6 0.6 1])
hold on
errorbar([0.1:0.1:0.9],nanmean(testscore_sf'),stdError(testscore_sf'),'color','b','linewidth',3)
ylim([0 1])

for ii = 1:9
    Proj_shk_all{ii} = [];
    Proj_sf_all{ii} = [];
    for mm = 1:max(MouseId)
        Proj_shk_all{ii} = [Proj_shk_all{ii};proj_test_shk{ii}{mm}];
        Proj_sf_all{ii} = [Proj_sf_all{ii}; proj_test_sf{ii}{mm}];
    end
end

subplot(1,4,4)
nhist({Proj_shk_all{5},Proj_sf_all{5}})

%%

for mm = 1:size(testscore,2)
    for ll = 1:9
        NumBins_sf(mm,ll) = length(proj_test_sf{ll}{mm});
        NumBins_shk(mm,ll) = length(proj_test_shk{ll}{mm});
        NumBins_min(mm,ll) = min([length(proj_test_sf{ll}{mm}),length(proj_test_shk{ll}{mm})]);
    end
end
