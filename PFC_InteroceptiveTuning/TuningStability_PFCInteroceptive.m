close all
clear all
cd /media/DataMOBsRAIDN/PFC_InteroceptiveTuning
load('TuningInfoallStructures.mat')
Regions = {'HPC','PFC'};
Variables = {'HR','BR','speed','position'};
SaveFigFolder = '/media/DataMOBsRAIDN/PFC_InteroceptiveTuning/Figures/Stability';
for reg = 1:2
    fig = figure;
    for var = 1:length(Variables)
        SigNeur = AllP.(Regions{reg}).Habituation.(Variables{var})<0.05 & AllP.(Regions{reg}).Conditionning.(Variables{var})<0.05;
        
        subplot(4,3,1+3*(var-1))
        [val,ind1] = max(TrainTuning.(Regions{reg}).Habituation.(Variables{var})(SigNeur,:)');
        [val,ind2] = max(CVTuning.(Regions{reg}).Habituation.(Variables{var})(SigNeur,:)');
        BestFreq.(Regions{reg}){var}.Hab = (ind1 + ind2)/2;
        imagesc(corr(nanzscore(TrainTuning.(Regions{reg}).Habituation.(Variables{var})(SigNeur,:)')',nanzscore(CVTuning.(Regions{reg}).Habituation.(Variables{var})(SigNeur,:)')'))
        colormap(redblue)
        caxis([-1 1])
        axis square
        if var ==1
            title('Hab / Hab')
        end
        ylabel(Variables{var})
        
        subplot(4,3,2+3*(var-1))
        [val,ind1] = max(TrainTuning.(Regions{reg}).Conditionning.(Variables{var})(SigNeur,:)');
        [val,ind2] = max(CVTuning.(Regions{reg}).Conditionning.(Variables{var})(SigNeur,:)');
        BestFreq.(Regions{reg}){var}.Cond = (ind1 + ind2)/2;
        imagesc(corr(nanzscore(TrainTuning.(Regions{reg}).Conditionning.(Variables{var})(SigNeur,:)')',nanzscore(CVTuning.(Regions{reg}).Conditionning.(Variables{var})(SigNeur,:)')'))
        colormap(redblue)
        caxis([-1 1])
        if var ==1
            title('Cond / Cond')
        end
        axis square
        
        subplot(4,3,3+3*(var-1))
        imagesc(corr(nanzscore(TrainTuning.(Regions{reg}).Habituation.(Variables{var})(SigNeur,:)')',nanzscore(CVTuning.(Regions{reg}).Conditionning.(Variables{var})(SigNeur,:)')'))
        colormap(redblue)
        caxis([-1 1])
        axis square
        if var ==1
            title('Hab / Cond')
        end
    end
    saveas(fig.Number,[SaveFigFolder filesep 'StabilityAnalysis_HabVsCond_',Regions{reg},'.png'])
end

for reg = 1:2
    for var = 1:length(Variables)
        [R,P(reg,var)] = corr(BestFreq.(Regions{reg}){var}.Cond',BestFreq.(Regions{reg}){var}.Hab','type','Pearson');
    end
end


close all
clear all
cd /media/DataMOBsRAIDN/PFC_InteroceptiveTuning
load('TuningInfoallStructures.mat')
Regions = {'HPC','PFC'};
Variables = {'HR','BR','speed','position'};
SaveFigFolder = '/media/DataMOBsRAIDN/PFC_InteroceptiveTuning/Figures/Stability';
for reg = 1:2
    fig = figure;
    for var = 1:length(Variables)
        SigNeur = AllP.(Regions{reg}).Habituation_NoFreeze.(Variables{var})<0.05 & AllP.(Regions{reg}).Conditionning_NoFreeze.(Variables{var})<0.05;
        
        subplot(4,3,1+3*(var-1))
        [val,ind1] = max(TrainTuning.(Regions{reg}).Habituation_NoFreeze.(Variables{var})(SigNeur,:)');
        [val,ind2] = max(CVTuning.(Regions{reg}).Habituation_NoFreeze.(Variables{var})(SigNeur,:)');
        BestFreq.(Regions{reg}){var}.Hab = (ind1 + ind2)/2;
        imagesc(corr(nanzscore(TrainTuning.(Regions{reg}).Habituation_NoFreeze.(Variables{var})(SigNeur,:)')',nanzscore(CVTuning.(Regions{reg}).Habituation_NoFreeze.(Variables{var})(SigNeur,:)')'))
        colormap(redblue)
        caxis([-1 1])
        axis square
        if var ==1
            title('Hab / Hab')
        end
        ylabel(Variables{var})
        
        subplot(4,3,2+3*(var-1))
        [val,ind1] = max(TrainTuning.(Regions{reg}).Conditionning_NoFreeze.(Variables{var})(SigNeur,:)');
        [val,ind2] = max(CVTuning.(Regions{reg}).Conditionning_NoFreeze.(Variables{var})(SigNeur,:)');
        BestFreq.(Regions{reg}){var}.Cond = (ind1 + ind2)/2;
        imagesc(corr(nanzscore(TrainTuning.(Regions{reg}).Conditionning_NoFreeze.(Variables{var})(SigNeur,:)')',nanzscore(CVTuning.(Regions{reg}).Conditionning_NoFreeze.(Variables{var})(SigNeur,:)')'))
        colormap(redblue)
        caxis([-1 1])
        if var ==1
            title('Cond / Cond')
        end
        axis square
        
        subplot(4,3,3+3*(var-1))
        imagesc(corr(nanzscore(TrainTuning.(Regions{reg}).Habituation_NoFreeze.(Variables{var})(SigNeur,:)')',nanzscore(CVTuning.(Regions{reg}).Conditionning_NoFreeze.(Variables{var})(SigNeur,:)')'))
        colormap(redblue)
        caxis([-1 1])
        axis square
        if var ==1
            title('Hab / Cond')
        end
    end
    saveas(fig.Number,[SaveFigFolder filesep 'StabilityAnalysis_HabVsCondnoFz_',Regions{reg},'.png'])
end

for reg = 1:2
    for var = 1:length(Variables)
        [R,P(reg,var)] = corr(BestFreq.(Regions{reg}){var}.Cond',BestFreq.(Regions{reg}){var}.Hab','type','Pearson');
    end
end



%%
clear all
cd /media/DataMOBsRAIDN/PFC_InteroceptiveTuning
load('TuningInfoallStructures.mat')
Regions = {'HPC','PFC'};
Variables = {'HR','BR'};
SaveFigFolder = '/media/DataMOBsRAIDN/PFC_InteroceptiveTuning/Figures/Stability';

for reg = 1:2
    fig = figure;
    for var = 1:length(Variables)
        SigNeur = AllP.(Regions{reg}).Sleep.(Variables{var})<0.05 & AllP.(Regions{reg}).Wake.(Variables{var})<0.05;
        
        subplot(2,3,1+3*(var-1))
        [val,ind1] = max(TrainTuning.(Regions{reg}).Sleep.(Variables{var})(SigNeur,:)');
        [val,ind2] = max(CVTuning.(Regions{reg}).Sleep.(Variables{var})(SigNeur,:)');
        BestFreq.(Regions{reg}){var}.Sleep = (ind1 + ind2)/2;
        imagesc(corr(nanzscore(TrainTuning.(Regions{reg}).Sleep.(Variables{var})(SigNeur,:)')',nanzscore(CVTuning.(Regions{reg}).Sleep.(Variables{var})(SigNeur,:)')'))
        colormap(redblue)
        caxis([-1 1])
        axis square
        if var ==1
            title('Sleep / Sleep')
        end
        ylabel(Variables{var})
        
        subplot(2,3,2+3*(var-1))
        [val,ind1] = max(TrainTuning.(Regions{reg}).Wake.(Variables{var})(SigNeur,:)');
        [val,ind2] = max(CVTuning.(Regions{reg}).Wake.(Variables{var})(SigNeur,:)');
        BestFreq.(Regions{reg}){var}.Wake = (ind1 + ind2)/2;
        imagesc(corr(nanzscore(TrainTuning.(Regions{reg}).Wake.(Variables{var})(SigNeur,:)')',nanzscore(CVTuning.(Regions{reg}).Wake.(Variables{var})(SigNeur,:)')'))
        colormap(redblue)
        caxis([-1 1])
        if var ==1
            title('Wake / Wake')
        end
        axis square
        
        subplot(2,3,3+3*(var-1))
        imagesc(corr(nanzscore(TrainTuning.(Regions{reg}).Sleep.(Variables{var})(SigNeur,:)')',nanzscore(CVTuning.(Regions{reg}).Wake.(Variables{var})(SigNeur,:)')'))
        colormap(redblue)
        caxis([-1 1])
        axis square
        if var ==1
            title('Sleep / Wake')
        end
    end
        saveas(fig.Number,[SaveFigFolder filesep 'StabilityAnalysis_SleepVsWake_',Regions{reg},'.png'])
end


for reg = 1:2
    for var = 1:length(Variables)
        [R,P(reg,var)] = corr(BestFreq.(Regions{reg}){var}.Sleep',BestFreq.(Regions{reg}){var}.Wake','type','Pearson');
    end
end

