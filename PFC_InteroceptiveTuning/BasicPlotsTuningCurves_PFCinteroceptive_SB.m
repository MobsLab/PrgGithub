function [TrainTuning,CVTuning,AllP,AllMI,AllMI_Norm,fignum] = BasicPlotsTuningCurves_PFCinteroceptive_SB(Parameter,Period,Region,TempBinsize,BinNumber,PlotOrNot)

% Load data
switch Region
    case 'PFC'
        SaveFolder = '/media/DataMOBsRAIDN/PFC_InteroceptiveTuning/PFCTuningByVarAndPeriod';
    case 'HPC'
        SaveFolder = '/media/DataMOBsRAIDN/PFC_InteroceptiveTuning/HPCTuningByVarAndPeriod';
    case'Vis'
        SaveFolder = '/media/DataMOBsRAIDN/PFC_InteroceptiveTuning/VisualTuningByVarAndPeriod';
end

load([SaveFolder,filesep,Parameter,'Tuning_',Period,'_',Region,'_',num2str(TempBinsize),'s_',num2str(BinNumber),'ParamBinNumber.mat'])


% Get all tuning curves
TrainTuning = [];
CVTuning = [];
AllP = [];
AllMI = [];
AllMI_Norm = [];
for sess = 1:length(TuningCurves)
    for neur = 1:length(TuningCurves{sess})
        TrainTuning = [TrainTuning;TuningCurves{sess}{neur}.HalfAn_STD];
        CVTuning = [CVTuning;TuningCurves{sess}{neur}.HalfCV];
        AllP = [AllP,TuningCurves{sess}{neur}.AnovaInfo];
        AllMI = [AllMI,MutInfo{sess}{neur}.MIPerSec];
        for i = 1:100, MIRand(i) = MutInfo_rand {sess}{neur}(i).MIPerSec; end
        AllMI_Norm = [AllMI_Norm,(MutInfo{sess}{neur}.MIPerSec - mean(MIRand))/std(MIRand)];
        
    end
end

if PlotOrNot
disp([num2str(nanmean(AllP<0.01)*100) '% significant PFC neurons'])
TrainTuningSig = TrainTuning(AllP<0.01,:);
CVTuningSig = CVTuning(AllP<0.01,:);

[val,ind] = max(TrainTuningSig');
[~,ind] = sort(ind);

fignum{1} = figure;
subplot(121)
imagesc(Opts.ParamBinLims,1:length(ind),smooth2a(nanzscore(TrainTuningSig(ind,:)')',0,1))
xlabel(Parameter)
ylabel('Neuron number')
title('Ordering set')
makepretty
subplot(122)
imagesc(Opts.ParamBinLims,1:length(ind),smooth2a(nanzscore(CVTuningSig(ind,:)')',0,1))
xlabel(Parameter)
ylabel('Neuron number')
title('CV set')
makepretty

fignum{2} = figure;
RSAMAtrix = corr(nanzscore(TrainTuningSig')',nanzscore(CVTuningSig')','rows','pairwise');
subplot(211)
imagesc(Opts.ParamBinLims,Opts.ParamBinLims,RSAMAtrix)
caxis([-1 1])
colormap(redblue)
set(gca,'XTick',Opts.ParamBinLims,'YTick',Opts.ParamBinLims)
axis square
ylabel(Parameter)
xlabel(Parameter)

makepretty
subplot(212)
clear PopTuning
for or = 1:length(RSAMAtrix)
    PopTuning(or,:) = circshift(RSAMAtrix(or,:),3-or);
end
plot(PopTuning')
xlabel(Parameter)
ylabel('Pop correlation')
ylim([-1 1])
makepretty

fignum{3} = figure;
subplot(311)
pie([nanmean(AllP<0.05),1-nanmean(AllP<0.05)])
colormap(bone)
subplot(312)
nhist(AllMI)
xlim([-0.1 1])
xlabel('MI per sec')
makepretty
subplot(313)
nhist(AllMI_Norm)
xlabel('MI per sec - norm')
makepretty
xlim([-4 8])

else
fignum = [];
end