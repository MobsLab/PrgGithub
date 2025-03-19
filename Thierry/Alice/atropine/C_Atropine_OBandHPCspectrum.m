%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /home/mobschapeau/Dropbox/Kteam/PrgMatlab/Thierry/Alice/Atropine/C_ParcoursComputeOBandHPCspectrum.m

% Ce script permet de tracer 30 figures pour l'expérience atropine
% L'expérience atropine comprend 3 conditions : Baseline, Atropine et Saline
% Et elle a été réalisée pour 3 souris : M923, M9266, M927 et M928

% Le sctrip est composé de 6 sections :
%   * Section 1 : chargement des données
%   * Section 2 : tracé des analyses spectrales avec les deux sleepscoring
%   différents pour chacune des 4 souris (2 fois 8 figures)
%   * Section 3 : tracé des spectrogrammes low HPC pour chacune des
%   4 souris (4 figures)
%   * Section 4 : tracé des spectrogrammes high OB pour chacune des
%   4 souris (4 figures)
%   * Section 5 : Tracé des analyses spectrales HPC moyennes pour les 3 états de vigilence sur toutes les
%   souris (3 figures)
%   * Section 6 : Tracé des analyses spectrales OB moyennes pour les 3 états de vigilence sur toutes les
%   souris (3 figures)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Section 1 : Chargement des données
a=0
Dir{1}=PathForExperiments_TG('atropine_Baseline');
Dir{2}=PathForExperiments_TG('atropine_Atropine');
Dir{3}=PathForExperiments_TG('atropine_Saline');
DirFigure='/media/nas5/Thierry_DATA/Figures/Atropine/';  % dossier où seront enregistrées les figures .fig


for i=1:length(Dir) % baseline 1, saline, baseline 2 ou CNO
    for j=1:length(Dir{i}.path)        
        cd(Dir{i}.path{j}{1});
        a=a+1;
        load SleepScoring_OBGamma REMEpoch SWSEpoch Wake
        REMob{i,j}=REMEpoch;
        Wakeob{i,j}=Wake; 
        SWSob{i,j}=SWSEpoch;
        load SleepScoring_Accelero REMEpoch Wake SWSEpoch
        REMAcc{i,j}=REMEpoch;
        WakeAcc{i,j}=Wake; 
        SWSAcc{i,j}=SWSEpoch;
        load('B_High_Spectrum.mat')
        fprintf('Loading OB high spectrum %d/%d...\n',[a,length(Dir)*length(Dir{1}.path)])
        SpectroB{i}{j}=Spectro;
        SpB=tsd(Spectro{2}*1E4,Spectro{1});
        fb=Spectro{3};
        load('H_Low_Spectrum.mat')
        fprintf('Loading HPC Low spectrum %d/%d...\n',[a,length(Dir)*length(Dir{1}.path)])
        SpectroH{i}{j}=Spectro;
        SpH=tsd(Spectro{2}*1E4,Spectro{1});
        fh=Spectro{3};
    
        SpHt{i}{j}=SpH;
        SpBt{i}{j}=SpB;
        fbt{i}{j}=fb;
        fht{i}{j}=fh;
    end
end


%% Section 2 : Tracé des analyses spectrales

% Avec le sleep scoring OB gamma
for i=1:length(Dir{1}.path)

    figure
    % HPC wake
    subplot(2,3,1), hold on, 
    plot(fht{1}{i},mean(10*(Data(Restrict(SpHt{1}{i},Wakeob{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(fht{3}{i},mean(10*(Data(Restrict(SpHt{3}{i},Wakeob{3,i})))),'b','linewidth',2)
    plot(fht{2}{i},mean(10*(Data(Restrict(SpHt{2}{i},Wakeob{2,i})))),'r','linewidth',2)
    legend('Baseline','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('HPC Wake SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
    % HPC SWS
    subplot(2,3,2), hold on, 
    plot(fht{1}{i},mean(10*(Data(Restrict(SpHt{1}{i},SWSob{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(fht{3}{i},mean(10*(Data(Restrict(SpHt{3}{i},SWSob{3,i})))),'b','linewidth',2)
    plot(fht{2}{i},mean(10*(Data(Restrict(SpHt{2}{i},SWSob{2,i})))),'r','linewidth',2)
    legend('Baseline','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('HPC NREM SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
    %HPC REM
    subplot(2,3,3), hold on, 
    plot(fht{1}{i},mean(10*(Data(Restrict(SpHt{1}{i},REMob{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(fht{3}{i},mean(10*(Data(Restrict(SpHt{3}{i},REMob{3,i})))),'b','linewidth',2)
    plot(fht{2}{i},mean(10*(Data(Restrict(SpHt{2}{i},REMob{2,i})))),'r','linewidth',2)
    legend('Baseline','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('HPC REM SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
    %OB Wake
    subplot(2,3,4), hold on,
    plot(fbt{1}{i},mean(10*(Data(Restrict(SpBt{1}{i},Wakeob{1,i})))),'k','linewidth',2), ylabel('OB')
    plot(fbt{3}{i},mean(10*(Data(Restrict(SpBt{3}{i},Wakeob{3,i})))),'b','linewidth',2)
    plot(fbt{2}{i},mean(10*(Data(Restrict(SpBt{2}{i},Wakeob{2,i})))),'r','linewidth',2)
    legend('Baseline','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('OB Wake SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
    %OB SWS
    subplot(2,3,5), hold on, 
    plot(fbt{1}{i},mean(10*(Data(Restrict(SpBt{1}{i},SWSob{1,i})))),'k','linewidth',2), ylabel('OB')
    plot(fbt{3}{i},mean(10*(Data(Restrict(SpBt{3}{i},SWSob{3,i})))),'b','linewidth',2)
    plot(fbt{2}{i},mean(10*(Data(Restrict(SpBt{2}{i},SWSob{2,i})))),'r','linewidth',2)
    legend('Baseline','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('OB NREM SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
    %OB REM
    subplot(2,3,6), hold on, 
    plot(fbt{1}{i},mean(10*(Data(Restrict(SpBt{1}{i},REMob{1,i})))),'k','linewidth',2), ylabel('OB')
    plot(fbt{3}{i},mean(10*(Data(Restrict(SpBt{3}{i},REMob{3,i})))),'b','linewidth',2)
    plot(fbt{2}{i},mean(10*(Data(Restrict(SpBt{2}{i},REMob{2,i})))),'r','linewidth',2)
    legend('Baseline','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('OB REM SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
    
    cd(DirFigure);
    figname=strcat('Analyse spectrale SleepScoring OB gamma M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname))

end


% Avec le sleep scoring accelero
for i=1:length(Dir{1}.path)
    figure
    % HPC Wake
    subplot(2,3,1), hold on, 
    plot(fht{1}{i},mean(10*(Data(Restrict(SpHt{1}{i},WakeAcc{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(fht{3}{i},mean(10*(Data(Restrict(SpHt{3}{i},WakeAcc{3,i})))),'b','linewidth',2)
    plot(fht{2}{i},mean(10*(Data(Restrict(SpHt{2}{i},WakeAcc{2,i})))),'r','linewidth',2)
    legend('Baseline','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('HPC Wake SleepScoring Accelero M',num2str(Dir{1}.nMice{i})))
    % HPC SWS
    subplot(2,3,2), hold on, 
    plot(fht{1}{i},mean(10*(Data(Restrict(SpHt{1}{i},SWSAcc{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(fht{3}{i},mean(10*(Data(Restrict(SpHt{3}{i},SWSAcc{3,i})))),'b','linewidth',2)
    plot(fht{2}{i},mean(10*(Data(Restrict(SpHt{2}{i},SWSAcc{2,i})))),'r','linewidth',2)
    legend('Baseline','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('HPC NREM SleepScoring Accelero M',num2str(Dir{1}.nMice{i})))
    % HPC REM
    subplot(2,3,3), hold on, 
    plot(fht{1}{i},mean(10*(Data(Restrict(SpHt{1}{i},REMAcc{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(fht{3}{i},mean(10*(Data(Restrict(SpHt{3}{i},REMAcc{3,i})))),'b','linewidth',2)
    plot(fht{2}{i},mean(10*(Data(Restrict(SpHt{2}{i},REMAcc{2,i})))),'r','linewidth',2)
    legend('Baseline','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('HPC REM SleepScoring Accelero M',num2str(Dir{1}.nMice{i})))
    % OB wake
    subplot(2,3,4), hold on, 
    plot(fbt{1}{i},mean(10*(Data(Restrict(SpBt{1}{i},WakeAcc{1,i})))),'k','linewidth',2), ylabel('OB')
    plot(fbt{3}{i},mean(10*(Data(Restrict(SpBt{3}{i},WakeAcc{3,i})))),'b','linewidth',2)
    plot(fbt{2}{i},mean(10*(Data(Restrict(SpBt{2}{i},WakeAcc{2,i})))),'r','linewidth',2)
    legend('Baseline','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('OB Wake SleepScoring Accelero M',num2str(Dir{1}.nMice{i})))
    % OB SWS
    subplot(2,3,5), hold on, 
    plot(fbt{1}{i},mean(10*(Data(Restrict(SpBt{1}{i},SWSAcc{1,i})))),'k','linewidth',2), ylabel('OB')
    plot(fbt{3}{i},mean(10*(Data(Restrict(SpBt{3}{i},SWSAcc{3,i})))),'b','linewidth',2)
    plot(fbt{2}{i},mean(10*(Data(Restrict(SpBt{2}{i},SWSAcc{2,i})))),'r','linewidth',2)
    legend('Baseline','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('OB NREM SleepScoring Accelero M',num2str(Dir{1}.nMice{i})))
    % OB REM
    subplot(2,3,6), hold on, 
    plot(fbt{1}{i},mean(10*(Data(Restrict(SpBt{1}{i},REMAcc{1,i})))),'k','linewidth',2), ylabel('OB')
    plot(fbt{3}{i},mean(10*(Data(Restrict(SpBt{3}{i},REMAcc{3,i})))),'b','linewidth',2)
    plot(fbt{2}{i},mean(10*(Data(Restrict(SpBt{2}{i},REMAcc{2,i})))),'r','linewidth',2)
    legend('Baseline','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('OB REM SleepScoring Accelero M',num2str(Dir{1}.nMice{i})))
    
    cd(DirFigure);
    figname=strcat('Analyse spectrale SleepScoring Accelero M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname))

end


%% Section 3 : Tracé des spectrogrammes HPC
% Attention, pour des problèmes de mémoire, les 6 spectres ne peuvent pas
% être générés en même temps

% Low HPC
axH{1}=[25,55]; % M923
axH{2}=[30,58]; % M926
axH{3}=[30,50]; % M927
axH{4}=[30,53]; % M928

for i=1:length(Dir{1}.path)
    figure
    %Baseline
    subplot(3,1,1)
    imagesc(SpectroH{1}{i}{2},SpectroH{1}{i}{3},10*log10(SpectroH{1}{i}{1}')), axis xy
    title(strcat('Low HPC spectrum Baseline M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})  %lancer le premier subplot dans un premier temps pour déterminer le meilleur caxis
    % Atropine
    subplot(3,1,2)
    imagesc(SpectroH{2}{i}{2},SpectroH{2}{i}{3},10*log10(SpectroH{2}{i}{1})'), axis xy
    title(strcat('Low HPC spectrum Atropine M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})
    % Saline
    subplot(3,1,3)
    imagesc(SpectroH{3}{i}{2},SpectroH{3}{i}{3},10*log10(SpectroH{3}{i}{1})'), axis xy
    title(strcat('Low HPC spectrum Saline M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})

    cd(DirFigure);
    figname=strcat('Spectre low HPC M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname))
end

%% Section 4 : Tracé des Spectrogrammes du Bulbe
% High OB
axB{1}=[15,50];  % M923
axB{2}=[12,48]; % M926
axB{3}=[12,48]; % M927
axB{4}=[12,48]; % M928

for i=1:length(Dir{1}.path)
    figure
    %Baseline
    subplot(3,1,1)
    imagesc(SpectroB{1}{i}{2},SpectroB{1}{i}{3},10*log10(SpectroB{1}{i}{1}')), axis xy
    title(strcat('High OB spectrum Baseline M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axB{i})  %lancer le premier subplot dans un premier temps pour déterminer le meilleur caxis
    % Atropine
    subplot(3,1,2)
    imagesc(SpectroB{2}{i}{2},SpectroB{2}{i}{3},10*log10(SpectroB{2}{i}{1})'), axis xy
    title(strcat('High OB spectrum Atropine M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axB{i})
    % Saline
    subplot(3,1,3)
    imagesc(SpectroB{3}{i}{2},SpectroB{3}{i}{3},10*log10(SpectroB{3}{i}{1})'), axis xy
    title(strcat('High OB spectrum Saline M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axB{i})

    cd(DirFigure);
    figname=strcat('Spectre High OB M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname))
end


%% Section 5 : Tracé des analyses spectrales moyennes HPC

for i=1:length(Dir{1}.path)
    data_Wake_Baseline(i,:)=mean(10*(Data(Restrict(SpHt{1}{i},Wakeob{1,i}))));
    data_SWS_Baseline(i,:)=mean(10*(Data(Restrict(SpHt{1}{i},SWSob{1,i}))));
    data_REM_Baseline(i,:)=mean(10*(Data(Restrict(SpHt{1}{i},REMob{1,i}))));
    data_Wake_Saline(i,:)=mean(10*(Data(Restrict(SpHt{3}{i},Wakeob{3,i}))));
    data_SWS_Saline(i,:)=mean(10*(Data(Restrict(SpHt{3}{i},SWSob{3,i}))));
    data_REM_Saline(i,:)=mean(10*(Data(Restrict(SpHt{3}{i},REMob{3,i}))));
    data_Wake_Atropine(i,:)=mean(10*(Data(Restrict(SpHt{2}{i},Wakeob{2,i}))));
    data_SWS_Atropine(i,:)=mean(10*(Data(Restrict(SpHt{2}{i},SWSob{2,i}))));
    data_REM_Atropine(i,:)=mean(10*(Data(Restrict(SpHt{2}{i},REMob{2,i}))));
end
% Calcul des moyennes
SpHt_Wake_Baseline_moy=mean(data_Wake_Baseline);
SpHt_SWS_Baseline_moy=mean(data_SWS_Baseline);
SpHt_REM_Baseline_moy=mean(data_REM_Baseline);
SpHt_Wake_Saline_moy=mean(data_Wake_Saline);
SpHt_SWS_Saline_moy=mean(data_SWS_Saline);
SpHt_REM_Saline_moy=mean(data_REM_Saline);
SpHt_Wake_Atropine_moy=mean(data_Wake_Atropine);
SpHt_SWS_Atropine_moy=mean(data_SWS_Atropine);
SpHt_REM_Atropine_moy=mean(data_REM_Atropine);


% Calcul des écarts types
SpHt_Wake_Baseline_std=CalculStdMoyMouse(data_Wake_Baseline);
SpHt_SWS_Baseline_std=CalculStdMoyMouse(data_SWS_Baseline);
SpHt_REM_Baseline_std=CalculStdMoyMouse(data_REM_Baseline);
SpHt_Wake_Saline_std=CalculStdMoyMouse(data_Wake_Saline);
SpHt_SWS_Saline_std=CalculStdMoyMouse(data_SWS_Saline);
SpHt_REM_Saline_std=CalculStdMoyMouse(data_REM_Saline);
SpHt_Wake_Atropine_std=CalculStdMoyMouse(data_Wake_Atropine);
SpHt_SWS_Atropine_std=CalculStdMoyMouse(data_SWS_Atropine);
SpHt_REM_Atropine_std=CalculStdMoyMouse(data_REM_Atropine);

% HPC wake
figure
%subplot(3,1,1), 
hold on, 
%errorbar(fht{1}{1},SpHt_Wake_Baseline_moy,SpHt_Wake_Baseline_std,'k')
errorbar(fht{3}{1},SpHt_Wake_Saline_moy,SpHt_Wake_Saline_std,'.','color',[0.2,0.6,0.2])
plot(fht{3}{1},SpHt_Wake_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(fht{2}{1},SpHt_Wake_Atropine_moy,SpHt_Wake_Atropine_std,'r .')
plot(fht{2}{1},SpHt_Wake_Atropine_moy,'r','linewidth',2)
legend('Saline ErrorBar','Saline','Atropine ErrorBar','Atropine')
xlabel('Frequency'), ylabel('HPC')
title('Mean of HPC Wake over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_HPC_Wake'))

% HPC SWS
figure
%subplot(3,1,2),
hold on, 
%errorbar(fht{1}{1},SpHt_SWS_Baseline1_moy,SpHt_SWS_Baseline1_std,'k')
errorbar(fht{3}{1},SpHt_SWS_Saline_moy,SpHt_SWS_Saline_std,'.','color',[0.2,0.6,0.2])
plot(fht{3}{1},SpHt_SWS_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(fht{2}{1},SpHt_SWS_Atropine_moy,SpHt_SWS_Atropine_std,'r .')
plot(fht{2}{1},SpHt_SWS_Atropine_moy,'r','linewidth',2)
legend('Saline ErrorBar','Saline','Atropine ErrorBar','Atropine')
xlabel('Frequency'), ylabel('HPC')
title('Mean of HPC NREM over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_HPC_NREM'))

%HPC REM
figure
%subplot(3,1,3), 
hold on, 
%errorbar(fht{1}{1},SpHt_REM_Baseline1_moy,SpHt_REM_Baseline1_std,'k')
errorbar(fht{3}{1},SpHt_REM_Saline_moy,SpHt_REM_Saline_std,'.','color',[0.2,0.6,0.2])
plot(fht{3}{1},SpHt_REM_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(fht{2}{1},SpHt_REM_Atropine_moy,SpHt_REM_Atropine_std,'r .')
plot(fht{2}{1},SpHt_REM_Atropine_moy,'r','linewidth',2)
%legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
legend('Saline ErrorBar','Saline','Atropine ErrorBar','Atropine')
xlabel('Frequency'), ylabel('HPC')
title('Mean of HPC REM over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_HPC_REM'))


%% Section 6 : Tracé des analyses spectrales moyennes OB

for i=1:length(Dir{1}.path)
    dataB_Wake_Baseline(i,:)=mean(10*(Data(Restrict(SpBt{1}{i},Wakeob{1,i}))));
    dataB_SWS_Baseline(i,:)=mean(10*(Data(Restrict(SpBt{1}{i},SWSob{1,i}))));
    dataB_REM_Baseline(i,:)=mean(10*(Data(Restrict(SpBt{1}{i},REMob{1,i}))));
    dataB_Wake_Saline(i,:)=mean(10*(Data(Restrict(SpBt{3}{i},Wakeob{3,i}))));
    dataB_SWS_Saline(i,:)=mean(10*(Data(Restrict(SpBt{3}{i},SWSob{3,i}))));
    dataB_REM_Saline(i,:)=mean(10*(Data(Restrict(SpBt{3}{i},REMob{3,i}))));
    dataB_Wake_Atropine(i,:)=mean(10*(Data(Restrict(SpBt{2}{i},Wakeob{2,i}))));
    dataB_SWS_Atropine(i,:)=mean(10*(Data(Restrict(SpBt{2}{i},SWSob{2,i}))));
    dataB_REM_Atropine(i,:)=mean(10*(Data(Restrict(SpBt{2}{i},REMob{2,i}))));
end
% Calcul des moyennes 
SpBt_Wake_Baseline_moy=mean(dataB_Wake_Baseline);
SpBt_SWS_Baseline_moy=mean(dataB_SWS_Baseline);
SpBt_REM_Baseline_moy=mean(dataB_REM_Baseline);
SpBt_Wake_Saline_moy=mean(dataB_Wake_Saline);
SpBt_SWS_Saline_moy=mean(dataB_SWS_Saline);
SpBt_REM_Saline_moy=mean(dataB_REM_Saline);
SpBt_Wake_Atropine_moy=mean(dataB_Wake_Atropine);
SpBt_SWS_Atropine_moy=mean(dataB_SWS_Atropine);
SpBt_REM_Atropine_moy=mean(dataB_REM_Atropine);


% Calcul des écarts types
SpBt_Wake_Baseline_std=CalculStdMoyMouse(dataB_Wake_Baseline);
SpBt_SWS_Baseline_std=CalculStdMoyMouse(dataB_SWS_Baseline);
SpBt_REM_Baseline_std=CalculStdMoyMouse(dataB_REM_Baseline);
SpBt_Wake_Saline_std=CalculStdMoyMouse(dataB_Wake_Saline);
SpBt_SWS_Saline_std=CalculStdMoyMouse(dataB_SWS_Saline);
SpBt_REM_Saline_std=CalculStdMoyMouse(dataB_REM_Saline);
SpBt_Wake_Atropine_std=CalculStdMoyMouse(dataB_Wake_Atropine);
SpBt_SWS_Atropine_std=CalculStdMoyMouse(dataB_SWS_Atropine);
SpBt_REM_Atropine_std=CalculStdMoyMouse(dataB_REM_Atropine);


% OB wake
figure
%subplot(3,1,1), 
hold on, 
%errorbar(fbt{1}{1},SpBt_Wake_Baseline1_moy,SpBt_Wake_Baseline1_std,'k')
errorbar(fbt{2}{1},SpBt_Wake_Saline_moy,SpBt_Wake_Saline_std,'.','color',[0.2,0.6,0.2])
plot(fbt{3}{1},SpBt_Wake_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(fbt{2}{1},SpBt_Wake_Atropine_moy,SpBt_Wake_Atropine_std,'r .')
plot(fbt{2}{1},SpBt_Wake_Atropine_moy,'r','linewidth',2)
legend('Saline ErrorBar','Saline','Atropine ErrorBar','Atropine')
xlabel('Frequency'), ylabel('OB')
title('Mean of OB Wake over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_OB_Wake'))

% OB SWS
figure
%subplot(3,1,2),
hold on, 
%errorbar(fbt{1}{1},SpBt_SWS_Baseline1_moy,SpBt_SWS_Baseline1_std,'k')
errorbar(fbt{3}{1},SpBt_SWS_Saline_moy,SpBt_SWS_Saline_std,'.','color',[0.2,0.6,0.2])
plot(fbt{3}{1},SpBt_SWS_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(fbt{2}{1},SpBt_SWS_Atropine_moy,SpBt_SWS_Atropine_std,'r .')
plot(fbt{2}{1},SpBt_SWS_Atropine_moy,'r','linewidth',2)
legend('Saline ErrorBar','Saline','Atropine ErrorBar','Atropine')
xlabel('Frequency'), ylabel('OB')
title('Mean of OB NREM over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_OB_NREM'))

%OB REM
figure
%subplot(3,1,3), 
hold on, 
%errorbar(fbt{1}{1},SpBt_REM_Baseline1_moy,SpBt_REM_Baseline1_std,'k')
errorbar(fbt{3}{1},SpBt_REM_Saline_moy,SpBt_REM_Saline_std,'.','color',[0.2,0.6,0.2])
plot(fbt{3}{1},SpBt_REM_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(fbt{2}{1},SpBt_REM_Atropine_moy,SpBt_REM_Atropine_std,'r .')
plot(fbt{2}{1},SpBt_REM_Atropine_moy,'r','linewidth',2)
legend('Saline ErrorBar','Saline','Atropine ErrorBar','Atropine')
xlabel('Frequency'), ylabel('OB')
title('Mean of OB REM over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_OB_REM'))
