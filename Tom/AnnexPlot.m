%% Determine Global Tau TimeSinceLastShock 


figure;
cumulTau = zeros(length(coefFinalFullLearnDZP.ExpTSLS.(MiceDZP{1})), 1);
nAddPlot = 1;
for i=1:MiceNumberDZP 
    subplot(ceil((MiceNumberDZP+nAddPlot)/10),10, i) 
    [~, index] = max(coefFinalFullLearnDZP.ExpTSLS.(MiceDZP{i}));
    imagesc(coefFinalFullLearnDZP.ExpTSLS.(MiceDZP{i})), hold on 
    colorbar('southoutside')
    plot(1,index, 'r*')
    title(MiceDZP{i})
    cumulTau = cumulTau + coefFinalFullLearnDZP.ExpTSLS.(MiceDZP{i});
end

subplot(ceil((MiceNumberDZP+nAddPlot)/10),10, (MiceNumberDZP+1))
imagesc(cumulTau), hold on
[~,index] = max(cumulTau);
plot(1,index, 'r*')
title("Cumul")
colorbar

cumulTau2 = zeros(length(coefIntuitiveCES.ExpTSLS.(Mice{1})), 1);
for i=1:MiceNumber 
    subplot(2,MiceNumber+2, i+MiceNumber+2) 
    [valmax, index] = max(coefIntuitiveCES.ExpTSLS.(Mice{i}));
    imagesc(coefIntuitiveCES.ExpTSLS.(Mice{i})/valmax), hold on 
    colorbar('southoutside')
    plot(1,index, 'r*')
    title(Mice{i})
    cumulTau2 = cumulTau2 + coefIntuitiveCES.ExpTSLS.(Mice{i})/valmax;
end

subplot(2,MiceNumber+2, (2*MiceNumber+3):(2*MiceNumber+4))
imagesc(cumulTau2), hold on
[~,index] = max(cumulTau2);
plot(1,index, 'r*')
title("Cumul")
colorbar


Mice = {'M404';'M437';'M439';'M469';'M471';'M483';'M484';'M485';'M490';'M507';...
    'M508';'M509';'M510';'M512';'M514';'M561';'M567';'M568';'M566';'M688';'M739';...
    'M777';'M779';'M849';'M893';'M1096';'M1144';'M1146';'M1171';'M1189';...
    'M1224';'M1225';'M1226';'M1391';'M1392';'M1393';'M1394';'M9184';'M9205';};
MicePAG = {'M404';'M437';'M439';'M469';'M471';'M483';'M484';'M485';'M490';'M507';...
    'M508';'M509';'M510';'M512';'M514'};

figure;
Name = 'AnalysisCorrected' ; 
coefs = coefAnalysisCorrected.SigGT;
GlobalMap = zeros(size(coefs));
GloablMapEquiMouse = zeros(size(coefs));
GlobalMapNormalized = zeros(size(coefs));
GlobalMapPAG = zeros(size(coefs));
GlobalMapEyelid = zeros(size(coefs));
GlobalMapPAGNormalized = zeros(size(coefs));
GlobalMapEyelidNormalized = zeros(size(coefs));
nAddPlot = 7;
Mice = fieldnames(coefs);
MiceNumber = length(Mice);
for i=1:MiceNumber 
    subplot(ceil((MiceNumber+nAddPlot)/10),10,i)
    set(gca,'Yscale','log')
    imagesc(coefs.(Mice{i})), hold on 
    %colorbar('southoutside')
    if i == 1
        title([Mice{i} ' - ' Name])
    else 
        title(Mice{i})
    end 
    [r,c] = find(coefs.(Mice{i}) == max(max(coefs.(Mice{i}))));
    plot(c,r,'r*')
    
    minn = min(min(coefs.(Mice{i})));
    maxx = max(max(coefs.(Mice{i})));
    GlobalMap = GlobalMap + coefs.(Mice{i});
    GloablMapEquiMouse = GloablMapEquiMouse + coefs.(Mice{i}) / maxx;
    GlobalMapNormalized = GlobalMapNormalized + (coefs.(Mice{i}) - minn) / (maxx - minn) ;
    if contains(Mice{i}, MicePAG)  
        GlobalMapPAG = GlobalMapPAG + coefs.(Mice{i}) / maxx;
        GlobalMapPAGNormalized = GlobalMapPAGNormalized + (coefs.(Mice{i}) - minn) / (maxx - minn);
    else 
        GlobalMapEyelid = GlobalMapEyelid + coefs.(Mice{i}) / maxx;
        GlobalMapEyelidNormalized = GlobalMapEyelidNormalized + (coefs.(Mice{i}) - minn) / (maxx - minn);
    end 
end
subplot(ceil((MiceNumber+nAddPlot)/10),10,MiceNumber+1)
imagesc(GlobalMap), hold on 
title('GlobalSum')
[r,c] = find(GlobalMap == max(max(GlobalMap)));
plot(c,r,'r*')

subplot(ceil((MiceNumber+nAddPlot)/10),10,MiceNumber+2)
imagesc(GloablMapEquiMouse), hold on
title({'Global Equi'; 'Mouse'})
[r,c] = find(GloablMapEquiMouse == max(max(GloablMapEquiMouse)));
plot(c,r,'r*')

subplot(ceil((MiceNumber+nAddPlot)/10),10,MiceNumber+3)
imagesc(GlobalMapNormalized), hold on
title('Global Normalized')
[r,c] = find(GlobalMapNormalized == max(max(GlobalMapNormalized)));
plot(c,r,'r*')

subplot(ceil((MiceNumber+nAddPlot)/10),10,MiceNumber+4)
imagesc(GlobalMapPAG), hold on
title('Global Equi PAG')
[r,c] = find(GlobalMapPAG == max(max(GlobalMapPAG)));
plot(c,r,'r*')

subplot(ceil((MiceNumber+nAddPlot)/10),10,MiceNumber+5)
imagesc(GlobalMapPAGNormalized), hold on
title({'Global Normalized'; 'PAG'})
[r,c] = find(GlobalMapPAGNormalized == max(max(GlobalMapPAGNormalized)));
plot(c,r,'r*')

subplot(ceil((MiceNumber+nAddPlot)/10),10,MiceNumber+6)
imagesc(GlobalMapEyelid), hold on
title({'Global Equi'; 'Eyelid'})
[r,c] = find(GlobalMapEyelid == max(max(GlobalMapEyelid)));
plot(c,r,'r*')

subplot(ceil((MiceNumber+nAddPlot)/10),10,MiceNumber+7)
imagesc(GlobalMapEyelidNormalized), hold on
title({'Global Normalized';'Eyelid'})
[r,c] = find(GlobalMapEyelidNormalized == max(max(GlobalMapEyelidNormalized)));
plot(c,r,'r*')


figure;
for i = 1:MiceNumber 
    subplot(ceil((MiceNumber)/10),10,i)
    plot(1:(height(DATAtable.(Mice{i}))-1), diff(DATAtable.(Mice{i}).CumulEntryShockZone)), hold on 
    plot(1:(height(DATAtable.(Mice{i}))-1), diff(DATAtable.(Mice{i}).EyelidNumber))
    title(Mice{i})
end 


%Plot Choice of Tau of ExpTSLS
figure;
coefTau = FullLearning.coefFinalFullLearn.ExpTSLS;
AggregatedTau = zeros(length(coefTau), length(coefTau.(Mice{1})));
MiceTau = fieldnames(coefTau);

for i = 1:length(MiceTau)
    coef = coefTau.(MiceTau{i});
    AggregatedTau(i,:) = (coef - min(coef)) / (max(coef) - min(coef));
    plot(AggregatedTau(i,:)), hold on
end 

Conf_Inter = std(AggregatedTau)/sqrt(size(AggregatedTau,1));
Mean_All_Sp = median(AggregatedTau);
figure; 
shadedErrorBar(10*(1:length(coefTau.(MiceTau{i}))), Mean_All_Sp, Conf_Inter,'-k',1), hold on 
plot([30 30], [-0.1 0.9], 'r--')
title('Saline')
text(34, 0.35, {'Chosen'; 'Charectristic Time'})
ylabel('R^2')
xlabel('\tau (seconds)')
xlim([10 120])
ylim([0.3 0.9])


%Plot Choice of Tau of ExpTSLS DZP
figure;
coefTau = coefFinalFullLearnDZP.ExpTSLS;
AggregatedTau = zeros(length(coefTau), length(coefTau.(MiceDZP{1})));
MiceTau = fieldnames(coefTau);

for i = 1:length(MiceTau)
    coef = coefTau.(MiceTau{i});
    AggregatedTau(i,:) = (coef - min(coef)) / (max(coef) - min(coef));
    plot(AggregatedTau(i,:)), hold on
end 

Conf_Inter = std(AggregatedTau)/sqrt(size(AggregatedTau,1));
Mean_All_Sp = median(AggregatedTau);
figure; 
shadedErrorBar(10*(1:length(coefTau.(MiceTau{i}))), Mean_All_Sp, Conf_Inter,'-k',1), hold on 
plot([30 30], [-0.1 0.9], 'r--')
title('Diazepam')
text(34, 0.1, {'Chosen'; 'Charectristic Time'})
ylabel('R^2')
xlabel('\tau (seconds)')
xlim([10 150])
ylim([0 1])


%Plot The range of exponentials of TSLS 

figure;
fill([1:300, fliplr(1:300)], [exp(- (1:300)), fliplr(exp(- (1:300)/300))],  [0.95 0.95 0.95]), hold on 
for i = 1:20:301 
    disp(i)
    if i == 1 || i == 301
        plot(1:300, exp(- (1:300)/i), 'r', 'linewidth', 2)
    else 
        plot(1:300, exp(- (1:300)/i), 'Color', [0.8 0.8 0.8])
    end 
        
end 
ylabel('Breathing (A.U.)')
xlabel('Time Since Last Shock (seconds)')
title('Range of Exponentials used')


%Plot Range of Sigmoids with variation on lp 
figure;
fill([1:5640, fliplr(1:5640)], [sigm(0.01, 56.4, 1:5640), fliplr(sigm(0.01, 56.4 * 91, 1:5640))],  [0.95 0.95 0.95]), hold on 
for i = 56.4 * (1:9:91)
    disp(i)
    if i == 56.4 || i == 56.4*91
        plot(1:5640, sigm(0.01, i, 1:5640), 'r')
    else 
        plot(1:5640, sigm(0.01, i, 1:5640), 'Color', [0.8 0.8 0.8])
    end 
        
end 
xlabel('Global Time')
title('Range of Sigmoids Points used')


%Plot Range of Sigmoids with variation on ls
figure;
fill([1:5640, fliplr(1:5640)], [sigm(0.001, 2820, 1:5640), fliplr(sigm(0.1, 2820, 1:5640))],  [0.95 0.95 0.95]), hold on 
for i = logspace(-3, -1, 10)
    disp(i)
    if i == 0.001 || i == 0.1
        plot(1:5640, sigm(i, 2820, 1:5640), 'r')
    else 
        plot(1:5640, sigm(i, 2820, 1:5640), 'Color', [0.8 0.8 0.8])
    end 
        
end 
xlabel('Global Time')
title('Range of Sigmoids Slope used')



%Test Take in account STD and Median for the best ls and lp General Model 
MiceTest = fieldnames(coefFinalAnalysis.SigGT);
for i = 1:length(MiceTest)
    coefMouse = coefFinalAnalysis.SigGT.(MiceTest{i});
    minn = min(min(coefMouse));
    maxx = max(max(coefMouse));
    AggregatedCoefs1(:,:,i) = (coefMouse - minn) / (maxx - minn) ;
end 
figure;
subplot(1,3,1)
GlobalMapNormalized = mean(AggregatedCoefs1, 3);
imagesc(GlobalMapNormalized), hold on 
title('Global Mean')
colorbar('eastoutside')
[r,c] = find(GlobalMapNormalized == max(max(GlobalMapNormalized)));
plot(c,r,'r*')

subplot(1,3,2)
GlobalMapSTD = std(AggregatedCoefs1, [], 3);
imagesc(GlobalMapSTD)
title('Global Std ')
colorbar('eastoutside')

NormalizedMean = (GlobalMapNormalized - min(min(GlobalMapNormalized)) ) ...
    / (max(max(GlobalMapNormalized)) - min(min(GlobalMapNormalized)));
NormalizedStd = 1 - ((GlobalMapSTD - min(min(GlobalMapSTD)) ) ...
    / (max(max(GlobalMapSTD)) - min(min(GlobalMapSTD))));
ProductMaps = NormalizedMean .* NormalizedStd;
subplot(1,3,3)
imagesc(ProductMaps), hold on 
title('Product of Normalized Mean and STD')
colorbar
[r,c] = find(ProductMaps == max(max(ProductMaps)));
plot(c,r,'r*')



%Physio approximation of OB_freq(TSLS)
figure;
coefTau = FullLearning.coefFinalFullLearn.ExpTSLS;
AggregatedTau = zeros(length(coefTau), length(coefTau.(Mice{1})));
MiceTau = fieldnames(coefTau);

figure;
for i = 1:length(Mice)
    
    shock = diff(DATAtable.(Mice{i}).EyelidNumber);
    indx = find(shock);
    arrayTSLSMouse = zeros(length(indx)-1, max(diff(indx)));
    arrayOBFreqMouse = zeros(length(indx)-1, max(diff(indx)));
    resMouse = zeros(length(indx)-1, floor(max(DATAtable.(Mice{i}).TimeSinceLastShock)));
    for j = 1:length(indx)-1
        arrayTSLSMouse(j,1:indx(j+1)-indx(j)+1) = DATAtable.(Mice{i}).TimeSinceLastShock(indx(j):indx(j+1));
        arrayOBFreqMouse(j,1:indx(j+1)-indx(j)+1) = DATAtable.(Mice{i}).OB_Frequency(indx(j):indx(j+1));
        resMouse(floor(arrayTSLSMouse(j,:))) = arrayOBFreqMouse(j,:);
    end
    resMouse(resMouse==0) = NaN;
    plot(nanmedian(resMouse, 2)), hold on 
end 

Conf_Inter = std(AggregatedTau)/sqrt(size(AggregatedTau,1));
Mean_All_Sp = median(AggregatedTau);
figure; 
shadedErrorBar(10*(1:length(coefTau.(MiceTau{i}))), Mean_All_Sp, Conf_Inter,'-k',1), hold on 
plot([30 30], [-0.1 0.9], 'r--')
title('DZP')
text(34, 0.05, {'Chosen'; 'Charectristic Time'})
ylabel('Normalized Goodness of Fit')
xlabel('Shock Distance Characteristic Time')




%Evaluation of fixed LS&LP vs optimized for Saline Mice
modeloptim = Models.FinalAnalysis;
modelfixed = Models.TowardGeneralGlobal;
coefoptim = coefFinalAnalysis;

%Remove Mice that don't appear in both models
MiceModel1 = fieldnames(modeloptim);
MiceModel2 = fieldnames(modelfixed);
Mice = {};
for i = 1:length(MiceModel1)
    if MiceModel1{i} == "M688"
        disp('check')
    elseif any(~cellfun('isempty',(strfind(MiceModel2, MiceModel1{i}))))
        Mice{end+1} = MiceModel1{i};
    else
        disp(['Warning : '  MiceModel1{i} ' not in model2'])
    end 
end 
for i = 1:length(Mice)
    if ~any(~cellfun('isempty',(strfind(MiceModel2, Mice{i}))))
        disp(['Warning : '  Mice{i} ' not in model1'])
    end 
end 

DiffR2 = zeros(length(Mice), 1);
DiffR2Meaned = zeros(length(Mice), 1);
AggregatedR2 = zeros(length(Mice), 1);
AggregatedR2Meaned = zeros(length(Mice), 1);
Xls = zeros(length(Mice), 1);
Xlp = zeros(length(Mice), 1);
for i = 1:length(Mice)
    [~, Rmoptim] = ErrorPredExactAndMean(modeloptim.(Mice{i}).Variables.OB_Frequency, modeloptim.(Mice{i}).Fitted.Response);
    [~, Rmfixed] = ErrorPredExactAndMean(modelfixed.(Mice{i}).Variables.OB_Frequency, modelfixed.(Mice{i}).Fitted.Response);
    DiffR2(i) = modeloptim.(Mice{i}).Rsquared.Ordinary - modelfixed.(Mice{i}).Rsquared.Ordinary;
    DiffR2Meaned(i) = Rmoptim - Rmfixed;
    [~, Xls(i)] = max(max(coefoptim.SigGT.(Mice{i}), [], 2));
    [~, Xlp(i)] = max(max(coefoptim.SigGT.(Mice{i}), [], 1));
    AggregatedR2(i) = modelfixed.(Mice{i}).Rsquared.Ordinary;
    AggregatedR2Meaned(i) = Rmfixed;
end 

figure; 
subplot(2,2,1)
scatter(Xls, DiffR2, [], AggregatedR2, 'filled') 
xlabel('Learn slope')
ylabel('Difference between R2 Ordinary : Optim SigGT vs Fixed')
correlation = corrcoef(Xls, DiffR2);
text(45, 0.17, ['CorrCoef : ' num2str(correlation(1,2))])
%text(Xls+0.1, DiffR2, sprintf('%.3f', AggregatedR2))
colorbar
title('Impact of Learn Slope and Learn Point in R2 Variation : Saline')

subplot(2,2,2)
scatter(Xls, DiffR2Meaned, [], AggregatedR2Meaned, 'filled') 
xlabel('Learn slope')
ylabel('Difference between R2 Meaned : Optim SigGT vs Fixed')
correlation = corrcoef(Xls, DiffR2Meaned);
text(4function sig = sigm(ls, lp, x)
    sig = 1 / (1 + exp( - ls * (x - lp)));
end 5, 0.33, ['CorrCoef : ' num2str(correlation(1,2))])
colorbar

subplot(2,2,3)
scatter(Xlp, DiffR2, [], AggregatedR2, 'filled') 
xlabel('Learn point')
ylabel('Difference between R2 Ordinary : Optim SigGT vs Fixed')
correlation = corrcoef(Xlp, DiffR2);
text(20, 0.17, ['CorrCoef : ' num2str(correlation(1,2))])
colorbar

subplot(2,2,4)
scatter(Xlp, DiffR2Meaned, [], AggregatedR2Meaned, 'filled') 
xlabel('Learn point')
ylabel('Difference between R2 Meaned : Optim SigGT vs Fixed')
correlation = corrcoef(Xlp, DiffR2Meaned);
text(20, 0.33, ['CorrCoef : ' num2str(correlation(1,2))])
colorbar








%Evaluation of fixed LS&LP vs optimized for DIAZEPAM Mice
modeloptim = Models.AnalysisDZP;
modelfixed = Models.TowardGeneralDZP;
coefoptim = coefAnalysisDZP;

%Remove Mice that don't appear in both models
MiceModel1 = fieldnames(modeloptim);
MiceModel2 = fieldnames(modelfixed);
MiceDZP = {};
for i = 1:length(MiceModel1)
    if any(~cellfun('isempty',(strfind(MiceModel2, MiceModel1{i}))))
        MiceDZP{end+1} = MiceModel1{i};
    else
        disp(['Warning : '  MiceModel1{i} ' not in model2'])
    end 
end 
for i = 1:length(MiceDZP)
    if ~any(~cellfun('isempty',(strfind(MiceModel2, MiceDZP{i}))))
        disp(['Warning : '  MiceDZP{i} ' not in model1'])
    end 
end 

DiffR2 = zeros(length(MiceDZP), 1);
DiffR2Meaned = zeros(length(MiceDZP), 1);
AggregatedR2 = zeros(length(MiceDZP), 1);
AggregatedR2Meaned = zeros(length(MiceDZP), 1);
Xls = zeros(length(MiceDZP), 1);
Xlp = zeros(length(MiceDZP), 1);
for i = 1:length(MiceDZP)
    [~, Rmoptim] = ErrorPredExactAndMean(modeloptim.(MiceDZP{i}).Variables.OB_Frequency, modeloptim.(MiceDZP{i}).Fitted.Response);
    [~, Rmfixed] = ErrorPredExactAndMean(modelfixed.(MiceDZP{i}).Variables.OB_Frequency, modelfixed.(MiceDZP{i}).Fitted.Response);
    DiffR2(i) = modeloptim.(MiceDZP{i}).Rsquared.Ordinary - modelfixed.(MiceDZP{i}).Rsquared.Ordinary;
    DiffR2Meaned(i) = Rmoptim - Rmfixed;
    [~, Xls(i)] = max(max(coefoptim.SigGT.(MiceDZP{i}), [], 2));
    [~, Xlp(i)] = max(max(coefoptim.SigGT.(MiceDZP{i}), [], 1));
    AggregatedR2(i) = modelfixed.(MiceDZP{i}).Rsquared.Ordinary;
    AggregatedR2Meaned(i) = Rmfixed;
end 

figure; 
subplot(2,2,1)
scatter(Xls, DiffR2, [], AggregatedR2, 'filled') 
xlabel('Learn slope')
ylabel('Difference between R2 Ordinary : Optim SigGT vs Fixed')
correlation = corrcoef(Xls, DiffR2);
text(45, max(DiffR2)*0.95, ['CorrCoef : ' num2str(correlation(1,2))])
%text(Xls+0.1, DiffR2, sprintf('%.3f', AggregatedR2))
colorbar
title('Impact of Learn Slope and Learn Point in R2 Variation : DZP')

subplot(2,2,2)
scatter(Xls, DiffR2Meaned, [], AggregatedR2Meaned, 'filled') 
xlabel('Learn slope')
ylabel('Difference between R2 Meaned : Optim SigGT vs Fixed')
correlation = corrcoef(Xls, DiffR2Meaned);
text(45, max(DiffR2Meaned)*0.95, ['CorrCoef : ' num2str(correlation(1,2))])
colorbar

subplot(2,2,3)
scatter(Xlp, DiffR2, [], AggregatedR2, 'filled') 
xlabel('Learn point')
ylabel('Difference between R2 Ordinary : Optim SigGT vs Fixed')
correlation = corrcoef(Xlp, DiffR2);
text(20, max(DiffR2)*0.95, ['CorrCoef : ' num2str(correlation(1,2))])
colorbar

subplot(2,2,4)
scatter(Xlp, DiffR2Meaned, [], AggregatedR2Meaned, 'filled') 
xlabel('Learn point')
ylabel('Difference between R2 Meaned : Optim SigGT vs Fixed')
correlation = corrcoef(Xlp, DiffR2Meaned);
text(20, max(DiffR2Meaned)*0.95, ['CorrCoef : ' num2str(correlation(1,2))])
colorbar




%Plot Fit of Model 
chosenMouse = "M777";
model = Models.AnalysisCorrected.(chosenMouse);

PredictedY = model.Fitted.Response;
x = 1:length(PredictedY);

figure;
a = plot(x, DATAtable.(chosenMouse).OB_Frequency, 'x', 'Color', colors{1}); hold on  %'markersize',20,
ylabel('Breathing Frequency (Hz)')
xlabel('Observation')
title("Fit of Chosen Model on Mouse " + chosenMouse)
ylim([0 10])
legend({'Observation'}, 'FontSize', 12, 'Location', 'northeast');
legend boxoff
%plot(x, movmean(ObservedY.(chosenMouse), 8), 'x', 'Color', [0.85 0.85 0.85])
b = plot(x, PredictedY, 'o', 'Color', colors{2});
legend({'Observation', 'Fitted'}, 'FontSize', 12, 'Location', 'northeast');

for k = 1:height(DATAtable.(chosenMouse))
    if DATAtable.(chosenMouse).Position(k) > 0.5
        safeplot = area([k k+1],[10 10], 'FaceColor', 'blue', 'FaceAlpha', 0.08, 'linestyle', 'none');
    else 
        shockplot = area([k k+1],[10 10], 'FaceColor', 'red', 'FaceAlpha', 0.08, 'linestyle', 'none'); 
    end 
end
legend([a, b, safeplot, shockplot], {'Observation', 'Fitted', 'Safe Zone', 'Shock zone'}, 'FontSize', 12, 'Location', 'northeast');





