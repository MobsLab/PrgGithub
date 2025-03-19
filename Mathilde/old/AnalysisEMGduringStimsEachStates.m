
Dir{1}=PathForExperiments_Opto_MC('PFC_Control_20Hz');
Dir{2}=PathForExperiments_Opto_MC('PFC_Stim_20Hz');

number=1;
for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
    
    [MatRemEMG,MatWakeEMG,MatSwsEMG,MatSpHPC,FreqSpHPC,TpsSpHPC] = PlotEMGandSpectroHPCduringStim_MC;
    data_MatRemEMG{i}=MatRemEMG;
    data_MatWakeEMG{i}=MatWakeEMG;
    data_MatSwsEMG{i}=MatSwsEMG;
    
    data_MatSpHPC{i}=MatSpHPC;
    
    MouseId(number) = Dir{1}.nMice{i} ;
    number=number+1;
end

clear MatRemEMG MatWakeEMG MatSwsEMG MatSpHPC FreqSpHPC TpsSpHPC
%--------------------------------------------------------------------------

numberOpto=1;
for j=1:length(Dir{2}.path)
    cd(Dir{2}.path{j}{1});
    
    [MatRemEMG,MatWakeEMG,MatSwsEMG,MatSpHPC,FreqSpHPC,TpsSpHPC] = PlotEMGandSpectroHPCduringStim_MC;
    data_MatRemEMGopto{j}=MatRemEMG;
    data_MatWakeEMGopto{j}=MatWakeEMG;
    data_MatSwsEMGopto{j}=MatSwsEMG;
    
    data_MatSpHPCopto{j}=MatSpHPC;
    
    MouseId(numberOpto) = Dir{2}.nMice{j} ;
    numberOpto=numberOpto+1;
end


%%
% pour faire les moyennes sur les souris: on transorme le cell array en
% matrices à 3 dimentions (la troisième dimention étant les souris) =>
% correspond à la première ligne. Puis on moyenne la matrice le long de la
% 3e dimention => correspond à la deuxième ligne. Et ça pour chaque
% variable d'intéret et les deux conditions.
% pour control
dataMatRemEMG=cat(3,data_MatRemEMG{:});
avMatRemEMG=nanmean(dataMatRemEMG,3);

dataMatSwsEMG=cat(3,data_MatSwsEMG{:});
avMatSwsEMG=nanmean(dataMatSwsEMG,3);

dataMatWakeEMG=cat(3,data_MatWakeEMG{:});
avMatWakeEMG=nanmean(dataMatWakeEMG,3);
   
dataMatSpHPC=cat(3,data_MatSpHPC{:});
avMatSpHPC=nanmean(dataMatSpHPC,3); 

% pour opto
dataMatRemEMGopto=cat(3,data_MatRemEMGopto{:});
avMatRemEMGopto=nanmean(dataMatRemEMGopto,3);

dataMatSwsEMGopto=cat(3,data_MatSwsEMGopto{:});
avMatSwsEMGopto=nanmean(dataMatSwsEMGopto,3);

dataMatWakeEMGopto=cat(3,data_MatWakeEMGopto{:});
avMatWakeEMGopto=nanmean(dataMatWakeEMGopto,3);
   
dataMatSpHPCopto=cat(3,data_MatSpHPCopto{:});
avMatSpHPCopto=nanmean(dataMatSpHPCopto,3);  

%% plots

% pour opto
figure, subplot(511),imagesc(TpsSpHPC/1E3,FreqSpHPC,avMatSpHPCopto),xlim([-60 60]), axis xy
line([0 0], ylim,'color','w','linestyle',':')
subplot(512),plot(avMatRemEMGopto(:,1),avMatRemEMGopto(:,2),'k'),ylim([0 5e6]),line([0 0], ylim,'color','k','linestyle',':')
subplot(514),plot(avMatSwsEMGopto(:,1),avMatSwsEMGopto(:,2),'k'),ylim([0 5e6]),line([0 0], ylim,'color','k','linestyle',':')
subplot(515),plot(dataMatWakeEMGopto(:,1),dataMatWakeEMGopto(:,2),'k'),ylim([0 5e6]),line([0 0], ylim,'color','k','linestyle',':')
suptitle('EMG average (n=5) opto')
% pour les controles
figure, subplot(511),imagesc(TpsSpHPC/1E3,FreqSpHPC,avMatSpHPC),xlim([-60 60]),axis xy
line([0 0], ylim,'color','w','linestyle',':')
subplot(512),plot(avMatRemEMG(:,1),avMatRemEMG(:,2),'k'),ylim([0 5e6]),line([0 0], ylim,'color','k','linestyle',':')
subplot(514),plot(avMatSwsEMG(:,1),avMatSwsEMG(:,2),'k'),ylim([0 5e6]),line([0 0], ylim,'color','k','linestyle',':')
subplot(515),plot(dataMatWakeEMG(:,1),dataMatWakeEMG(:,2),'k'),ylim([0 5e6]),line([0 0], ylim,'color','k','linestyle',':')
suptitle('EMG average(n=3) control')


