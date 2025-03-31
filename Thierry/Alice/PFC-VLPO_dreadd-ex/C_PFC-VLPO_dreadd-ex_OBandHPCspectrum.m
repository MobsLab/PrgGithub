%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /home/mobschapeau/Dropbox/Kteam/PrgMatlab/Thierry/Alice/PFC-VLPO_dread-ex/C_ParcoursComputeOBandHPCspectrum.m

% Ce script permet de tracer 18 figures pour l'expérience PFC-VLPO_dread-ex
% L'expérience PFC-VLPO_dread-ex comprend 4 conditions : Baseline 1, Saline,
% Baseline 2 et CNO
% Et elle a été réalisée pour 3 souris : M1035, M1036 et M1037

% Le sctrip est composé de 6 sections :
%   * Section 1 : chargement des données
%   * Section 2 : tracé des analyses spectrales avec les deux sleepscoring
%   différents pour chacune des 3 souris (2 fois 6 figures)
%   * Section 3 : tracé des spectrogrammes low HPC pour chacune des
%   3 souris (3 figures)
%   * Section 4 : tracé des spectrogrammes high OB pour chacune des
%   3 souris (3 figures)
%   * Section 5 : Tracé des analyses spectrales HPC moyennes sur toutes les
%   souris
%   * Section 6 : Tracé des analyses spectrales OB moyennes sur toutes les
%   souris

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Section 1 : Chargement des données
a=0
Dir{1}=PathForExperiments_TG('PFC-VLPO_dreadd-ex_Baseline1');
Dir{2}=PathForExperiments_TG('PFC-VLPO_dreadd-ex_Saline');
Dir{3}=PathForExperiments_TG('PFC-VLPO_dreadd-ex_Baseline2');
Dir{4}=PathForExperiments_TG('PFC-VLPO_dreadd-ex_CNO');
DirFigure='/media/nas5/Thierry_DATA/Figures/PFC-VLPO_dreadd-cre/';

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
    plot(fht{2}{i},mean(10*(Data(Restrict(SpHt{2}{i},Wakeob{2,i})))),'g','linewidth',2)
    plot(fht{4}{i},mean(10*(Data(Restrict(SpHt{4}{i},Wakeob{4,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
    xlabel('Frequency')
    title(strcat('HPC Wake SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
    % HPC SWS
    subplot(2,3,2), hold on, 
    plot(fht{1}{i},mean(10*(Data(Restrict(SpHt{1}{i},SWSob{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(fht{3}{i},mean(10*(Data(Restrict(SpHt{3}{i},SWSob{3,i})))),'b','linewidth',2)
    plot(fht{2}{i},mean(10*(Data(Restrict(SpHt{2}{i},SWSob{2,i})))),'g','linewidth',2)
    plot(fht{4}{i},mean(10*(Data(Restrict(SpHt{4}{i},SWSob{4,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
    xlabel('Frequency')
    title(strcat('HPC NREM SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
    %HPC REM
    subplot(2,3,3), hold on, 
    plot(fht{1}{i},mean(10*(Data(Restrict(SpHt{1}{i},REMob{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(fht{3}{i},mean(10*(Data(Restrict(SpHt{3}{i},REMob{3,i})))),'b','linewidth',2)
    plot(fht{2}{i},mean(10*(Data(Restrict(SpHt{2}{i},REMob{2,i})))),'g','linewidth',2)
    plot(fht{4}{i},mean(10*(Data(Restrict(SpHt{4}{i},REMob{4,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
    xlabel('Frequency')
    title(strcat('HPC REM SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
    %OB Wake
    subplot(2,3,4), hold on, length(Dir{i}.path)
    plot(fbt{1}{i},mean(10*(Data(Restrict(SpBt{1}{i},Wakeob{1,i})))),'k','linewidth',2), ylabel('OB')
    plot(fbt{3}{i},mean(10*(Data(Restrict(SpBt{3}{i},Wakeob{3,i})))),'b','linewidth',2)
    plot(fbt{2}{i},mean(10*(Data(Restrict(SpBt{2}{i},Wakeob{2,i})))),'g','linewidth',2)
    plot(fbt{4}{i},mean(10*(Data(Restrict(SpBt{4}{i},Wakeob{4,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
    xlabel('Frequency')
    title(strcat('OB Wake SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
    %OB SWS
    subplot(2,3,5), hold on, 
    plot(fbt{1}{i},mean(10*(Data(Restrict(SpBt{1}{i},SWSob{1,i})))),'k','linewidth',2), ylabel('OB')
    plot(fbt{3}{i},mean(10*(Data(Restrict(SpBt{3}{i},SWSob{3,i})))),'b','linewidth',2)
    plot(fbt{2}{i},mean(10*(Data(Restrict(SpBt{2}{i},SWSob{2,i})))),'g','linewidth',2)
    plot(fbt{4}{i},mean(10*(Data(Restrict(SpBt{4}{i},SWSob{4,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
    xlabel('Frequency')
    title(strcat('OB NREM SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
    %OB REM
    subplot(2,3,6), hold on, 
    plot(fbt{1}{i},mean(10*(Data(Restrict(SpBt{1}{i},REMob{1,i})))),'k','linewidth',2), ylabel('OB')
    plot(fbt{3}{i},mean(10*(Data(Restrict(SpBt{3}{i},REMob{3,i})))),'b','linewidth',2)
    plot(fbt{2}{i},mean(10*(Data(Restrict(SpBt{2}{i},REMob{2,i})))),'g','linewidth',2)
    plot(fbt{4}{i},mean(10*(Data(Restrict(SpBt{4}{i},REMob{4,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
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
    plot(fht{2}{i},mean(10*(Data(Restrict(SpHt{2}{i},WakeAcc{2,i})))),'g','linewidth',2)
    plot(fht{4}{i},mean(10*(Data(Restrict(SpHt{4}{i},WakeAcc{4,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
    xlabel('Frequency')
    title(strcat('HPC Wake SleepScoring Accelero M',num2str(Dir{1}.nMice{i})))
    % HPC SWS
    subplot(2,3,2), hold on, 
    plot(fht{1}{i},mean(10*(Data(Restrict(SpHt{1}{i},SWSAcc{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(fht{3}{i},mean(10*(Data(Restrict(SpHt{3}{i},SWSAcc{3,i})))),'b','linewidth',2)
    plot(fht{2}{i},mean(10*(Data(Restrict(SpHt{2}{i},SWSAcc{2,i})))),'g','linewidth',2)
    plot(fht{4}{i},mean(10*(Data(Restrict(SpHt{4}{i},SWSAcc{4,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
    xlabel('Frequency')
    title(strcat('HPC NREM SleepScoring Accelero M',num2str(Dir{1}.nMice{i})))
    % HPC REM
    subplot(2,3,3), hold on, 
    plot(fht{1}{i},mean(10*(Data(Restrict(SpHt{1}{i},REMAcc{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(fht{3}{i},mean(10*(Data(Restrict(SpHt{3}{i},REMAcc{3,i})))),'b','linewidth',2)
    plot(fht{2}{i},mean(10*(Data(Restrict(SpHt{2}{i},REMAcc{2,i})))),'g','linewidth',2)
    plot(fht{4}{i},mean(10*(Data(Restrict(SpHt{4}{i},REMAcc{4,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
    xlabel('Frequency')
    title(strcat('HPC REM SleepScoring Accelero M',num2str(Dir{1}.nMice{i})))
    % OB wake
    subplot(2,3,4), hold on, 
    plot(fbt{1}{i},mean(10*(Data(Restrict(SpBt{1}{i},WakeAcc{1,i})))),'k','linewidth',2), ylabel('OB')
    plot(fbt{3}{i},mean(10*(Data(Restrict(SpBt{3}{i},WakeAcc{3,i})))),'b','linewidth',2)
    plot(fbt{2}{i},mean(10*(Data(Restrict(SpBt{2}{i},WakeAcc{2,i})))),'g','linewidth',2)
    plot(fbt{4}{i},mean(10*(Data(Restrict(SpBt{4}{i},WakeAcc{4,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
    xlabel('Frequency')
    title(strcat('OB Wake SleepScoring Accelero M',num2str(Dir{1}.nMice{i})))
    % OB SWS
    subplot(2,3,5), hold on, 
    plot(fbt{1}{i},mean(10*(Data(Restrict(SpBt{1}{i},SWSAcc{1,i})))),'k','linewidth',2), ylabel('OB')
    plot(fbt{3}{i},mean(10*(Data(Restrict(SpBt{3}{i},SWSAcc{3,i})))),'b','linewidth',2)
    plot(fbt{2}{i},mean(10*(Data(Restrict(SpBt{2}{i},SWSAcc{2,i})))),'g','linewidth',2)
    plot(fbt{4}{i},mean(10*(Data(Restrict(SpBt{4}{i},SWSAcc{4,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
    xlabel('Frequency')
    title(strcat('OB NREM SleepScoring Accelero M',num2str(Dir{1}.nMice{i})))
    % OB REM
    subplot(2,3,6), hold on, 
    plot(fbt{1}{i},mean(10*(Data(Restrict(SpBt{1}{i},REMAcc{1,i})))),'k','linewidth',2), ylabel('OB')
    plot(fbt{3}{i},mean(10*(Data(Restrict(SpBt{3}{i},REMAcc{3,i})))),'b','linewidth',2)
    plot(fbt{2}{i},mean(10*(Data(Restrict(SpBt{2}{i},REMAcc{2,i})))),'g','linewidth',2)
    plot(fbt{4}{i},mean(10*(Data(Restrict(SpBt{4}{i},REMAcc{4,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
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
axH{1}=[25,55]; % M1035
axH{2}=[30,58]; % M1036
axH{3}=[28,58]; % M1037

for i=1:length(Dir{1}.path)
    figure
    %Baseline 1
    subplot(4,1,1)
    imagesc(SpectroH{1}{i}{2},SpectroH{1}{i}{3},10*log10(SpectroH{1}{i}{1}')), axis xy
    title(strcat('Low HPC spectrum Baseline 1 M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})  %lancer le premier subplot dans un premier temps pour déterminer le meilleur caxis
    % Saline
    subplot(4,1,2)
    imagesc(SpectroH{2}{i}{2},SpectroH{2}{i}{3},10*log10(SpectroH{2}{i}{1})'), axis xy
    title(strcat('Low HPC spectrum Saline M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})
    % Baseline 2
    subplot(4,1,3)
    imagesc(SpectroH{3}{i}{2},SpectroH{3}{i}{3},10*log10(SpectroH{3}{i}{1})'), axis xy
    title(strcat('Low HPC spectrum Baseline 2 M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})
    % CNO
    subplot(4,1,4)
    imagesc(SpectroH{4}{i}{2},SpectroH{4}{i}{3},10*log10(SpectroH{4}{i}{1})'), axis xy
    title(strcat('Low HPC spectrum CNO M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})

    cd(DirFigure);
    figname=strcat('Spectre low HPC M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname))
end

%% Section 4 : Tracé des Spectrogrammes du Bulbe
% High OB
axB{1}=[15,50];  % M1035
axB{2}=[12,48]; % M1036
axB{3}=[12,48]; % M1037

for i=1:length(Dir{1}.path)
    figure
    %Baseline 1
    subplot(4,1,1)
    imagesc(SpectroB{1}{i}{2},SpectroB{1}{i}{3},10*log10(SpectroB{1}{i}{1}')), axis xy
    title(strcat('High OB spectrum Baseline 1 M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axB{i})  %lancer le premier subplot dans un premier temps pour déterminer le meilleur caxis
    % Saline
    subplot(4,1,2)
    imagesc(SpectroB{2}{i}{2},SpectroB{2}{i}{3},10*log10(SpectroB{2}{i}{1})'), axis xy
    title(strcat('High OB spectrum Saline M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axB{i})
    % Baseline 2
    subplot(4,1,3)
    imagesc(SpectroB{3}{i}{2},SpectroB{3}{i}{3},10*log10(SpectroB{3}{i}{1})'), axis xy
    title(strcat('High OB spectrum Baseline 2 M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axB{i})
    % CNO
    subplot(4,1,4)
    imagesc(SpectroB{4}{i}{2},SpectroB{4}{i}{3},10*log10(SpectroB{4}{i}{1})'), axis xy
    title(strcat('High OB spectrum CNO M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axB{i})

    cd(DirFigure);
    figname=strcat('Spectre High OB M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname))
end


%% Section 5 : Tracé des analyses spectrales moyennes HPC

for i=1:length(Dir{1}.path)
    data_Wake_Baseline1(i,:)=mean(10*(Data(Restrict(SpHt{1}{i},Wakeob{1,i}))));
    data_SWS_Baseline1(i,:)=mean(10*(Data(Restrict(SpHt{1}{i},SWSob{1,i}))));
    data_REM_Baseline1(i,:)=mean(10*(Data(Restrict(SpHt{1}{i},REMob{1,i}))));
    data_Wake_Saline(i,:)=mean(10*(Data(Restrict(SpHt{2}{i},Wakeob{2,i}))));
    data_SWS_Saline(i,:)=mean(10*(Data(Restrict(SpHt{2}{i},SWSob{2,i}))));
    data_REM_Saline(i,:)=mean(10*(Data(Restrict(SpHt{2}{i},REMob{2,i}))));
    data_Wake_Baseline2(i,:)=mean(10*(Data(Restrict(SpHt{3}{i},Wakeob{3,i}))));
    data_SWS_Baseline2(i,:)=mean(10*(Data(Restrict(SpHt{3}{i},SWSob{3,i}))));
    data_REM_Baseline2(i,:)=mean(10*(Data(Restrict(SpHt{3}{i},REMob{3,i}))));
    data_Wake_CNO(i,:)=mean(10*(Data(Restrict(SpHt{4}{i},Wakeob{4,i}))));
    data_SWS_CNO(i,:)=mean(10*(Data(Restrict(SpHt{4}{i},SWSob{4,i}))));
    data_REM_CNO(i,:)=mean(10*(Data(Restrict(SpHt{4}{i},REMob{4,i}))));
end
% Calcul des moyennes
SpHt_Wake_Baseline1_moy=mean(data_Wake_Baseline1);
SpHt_SWS_Baseline1_moy=mean(data_SWS_Baseline1);
SpHt_REM_Baseline1_moy=mean(data_REM_Baseline1);
SpHt_Wake_Saline_moy=mean(data_Wake_Saline);
SpHt_SWS_Saline_moy=mean(data_SWS_Saline);
SpHt_REM_Saline_moy=mean(data_REM_Saline);
SpHt_Wake_Baseline2_moy=mean(data_Wake_Baseline2);
SpHt_SWS_Baseline2_moy=mean(data_SWS_Baseline2);
SpHt_REM_Baseline2_moy=mean(data_REM_Baseline2);
SpHt_Wake_CNO_moy=mean(data_Wake_CNO);
SpHt_SWS_CNO_moy=mean(data_SWS_CNO);
SpHt_REM_CNO_moy=mean(data_REM_CNO);

% Calcul des écarts types
SpHt_Wake_Baseline1_std=CalculStdMoyMouse(data_Wake_Baseline1);
SpHt_SWS_Baseline1_std=CalculStdMoyMouse(data_SWS_Baseline1);
SpHt_REM_Baseline1_std=CalculStdMoyMouse(data_REM_Baseline1);
SpHt_Wake_Saline_std=CalculStdMoyMouse(data_Wake_Saline);
SpHt_SWS_Saline_std=CalculStdMoyMouse(data_SWS_Saline);
SpHt_REM_Saline_std=CalculStdMoyMouse(data_REM_Saline);
SpHt_Wake_Baseline2_std=CalculStdMoyMouse(data_Wake_Baseline2);
SpHt_SWS_Baseline2_std=CalculStdMoyMouse(data_SWS_Baseline2);
SpHt_REM_Baseline2_std=CalculStdMoyMouse(data_REM_Baseline2);
SpHt_Wake_CNO_std=CalculStdMoyMouse(data_Wake_CNO);
SpHt_SWS_CNO_std=CalculStdMoyMouse(data_SWS_CNO);
SpHt_REM_CNO_std=CalculStdMoyMouse(data_REM_CNO);

% HPC wake
figure
%subplot(3,1,1), 
hold on, 
%errorbar(fht{1}{1},SpHt_Wake_Baseline1_moy,SpHt_Wake_Baseline1_std,'k')
%errorbar(fht{3}{1},SpHt_Wake_Baseline2_moy,SpHt_Wake_Baseline2_std,'b')
errorbar(fht{2}{1},SpHt_Wake_Saline_moy,SpHt_Wake_Saline_std,'.','color',[0.2,0.6,0.2])
plot(fht{2}{1},SpHt_Wake_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(fht{4}{1},SpHt_Wake_CNO_moy,SpHt_Wake_CNO_std,'r .')
plot(fht{2}{1},SpHt_Wake_CNO_moy,'r','linewidth',2)
%legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
legend('Saline ErrorBar','Saline','CNO ErrorBar','CNO')
xlabel('Frequency'), ylabel('HPC')
title('Mean of HPC Wake over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_HPC_Wake'))

% HPC SWS
figure
%subplot(3,1,2),
hold on, 
%errorbar(fht{1}{1},SpHt_SWS_Baseline1_moy,SpHt_SWS_Baseline1_std,'k')
%errorbar(fht{3}{1},SpHt_SWS_Baseline2_moy,SpHt_SWS_Baseline2_std,'b')
errorbar(fht{2}{1},SpHt_SWS_Saline_moy,SpHt_SWS_Saline_std,'.','color',[0.2,0.6,0.2])
plot(fht{2}{1},SpHt_SWS_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(fht{4}{1},SpHt_SWS_CNO_moy,SpHt_SWS_CNO_std,'r .')
plot(fht{2}{1},SpHt_SWS_CNO_moy,'r','linewidth',2)
%legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
legend('Saline ErrorBar','Saline','CNO ErrorBar','CNO')
xlabel('Frequency'), ylabel('HPC')
title('Mean of HPC NREM over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_HPC_NREM'))

%HPC REM
figure
%subplot(3,1,3), 
hold on, 
%errorbar(fht{1}{1},SpHt_REM_Baseline1_moy,SpHt_REM_Baseline1_std,'k')
%errorbar(fht{3}{1},SpHt_REM_Baseline2_moy,SpHt_REM_Baseline2_std,'b')
errorbar(fht{2}{1},SpHt_REM_Saline_moy,SpHt_REM_Saline_std,'.','color',[0.2,0.6,0.2])
plot(fht{2}{1},SpHt_REM_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(fht{4}{1},SpHt_REM_CNO_moy,SpHt_REM_CNO_std,'r .')
plot(fht{2}{1},SpHt_REM_CNO_moy,'r','linewidth',2)
%legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
legend('Saline ErrorBar','Saline','CNO ErrorBar','CNO')
xlabel('Frequency'), ylabel('HPC')
title('Mean of HPC REM over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_HPC_REM'))


%% Section 6 : Tracé des analyses spectrales moyennes OB

for i=1:length(Dir{1}.path)
    dataB_Wake_Baseline1(i,:)=mean(10*(Data(Restrict(SpBt{1}{i},Wakeob{1,i}))));
    dataB_SWS_Baseline1(i,:)=mean(10*(Data(Restrict(SpBt{1}{i},SWSob{1,i}))));
    dataB_REM_Baseline1(i,:)=mean(10*(Data(Restrict(SpBt{1}{i},REMob{1,i}))));
    dataB_Wake_Saline(i,:)=mean(10*(Data(Restrict(SpBt{2}{i},Wakeob{2,i}))));
    dataB_SWS_Saline(i,:)=mean(10*(Data(Restrict(SpBt{2}{i},SWSob{2,i}))));
    dataB_REM_Saline(i,:)=mean(10*(Data(Restrict(SpBt{2}{i},REMob{2,i}))));
    dataB_Wake_Baseline2(i,:)=mean(10*(Data(Restrict(SpBt{3}{i},Wakeob{3,i}))));
    dataB_SWS_Baseline2(i,:)=mean(10*(Data(Restrict(SpBt{3}{i},SWSob{3,i}))));
    dataB_REM_Baseline2(i,:)=mean(10*(Data(Restrict(SpBt{3}{i},REMob{3,i}))));
    dataB_Wake_CNO(i,:)=mean(10*(Data(Restrict(SpBt{4}{i},Wakeob{4,i}))));
    dataB_SWS_CNO(i,:)=mean(10*(Data(Restrict(SpBt{4}{i},SWSob{4,i}))));
    dataB_REM_CNO(i,:)=mean(10*(Data(Restrict(SpBt{4}{i},REMob{4,i}))));
end
% Calcul des moyennes
SpBt_Wake_Baseline1_moy=mean(dataB_Wake_Baseline1);
SpBt_SWS_Baseline1_moy=mean(dataB_SWS_Baseline1);
SpBt_REM_Baseline1_moy=mean(dataB_REM_Baseline1);
SpBt_Wake_Saline_moy=mean(dataB_Wake_Saline);
SpBt_SWS_Saline_moy=mean(dataB_SWS_Saline);
SpBt_REM_Saline_moy=mean(dataB_REM_Saline);
SpBt_Wake_Baseline2_moy=mean(dataB_Wake_Baseline2);
SpBt_SWS_Baseline2_moy=mean(dataB_SWS_Baseline2);
SpBt_REM_Baseline2_moy=mean(dataB_REM_Baseline2);
SpBt_Wake_CNO_moy=mean(dataB_Wake_CNO);
SpBt_SWS_CNO_moy=mean(dataB_SWS_CNO);
SpBt_REM_CNO_moy=mean(dataB_REM_CNO);

% Calcul des écarts types
SpBt_Wake_Baseline1_std=CalculStdMoyMouse(dataB_Wake_Baseline1);
SpBt_SWS_Baseline1_std=CalculStdMoyMouse(dataB_SWS_Baseline1);
SpBt_REM_Baseline1_std=CalculStdMoyMouse(dataB_REM_Baseline1);
SpBt_Wake_Saline_std=CalculStdMoyMouse(dataB_Wake_Saline);
SpBt_SWS_Saline_std=CalculStdMoyMouse(dataB_SWS_Saline);
SpBt_REM_Saline_std=CalculStdMoyMouse(dataB_REM_Saline);
SpBt_Wake_Baseline2_std=CalculStdMoyMouse(dataB_Wake_Baseline2);
SpBt_SWS_Baseline2_std=CalculStdMoyMouse(dataB_SWS_Baseline2);
SpBt_REM_Baseline2_std=CalculStdMoyMouse(dataB_REM_Baseline2);
SpBt_Wake_CNO_std=CalculStdMoyMouse(dataB_Wake_CNO);
SpBt_SWS_CNO_std=CalculStdMoyMouse(dataB_SWS_CNO);
SpBt_REM_CNO_std=CalculStdMoyMouse(dataB_REM_CNO);


% OB wake
figure
%subplot(3,1,1), 
hold on, 
%errorbar(fbt{1}{1},SpBt_Wake_Baseline1_moy,SpBt_Wake_Baseline1_std,'k')
%errorbar(fbt{3}{1},SpBt_Wake_Baseline2_moy,SpBt_Wake_Baseline2_std,'b')
errorbar(fbt{2}{1},SpBt_Wake_Saline_moy,SpBt_Wake_Saline_std,'.','color',[0.2,0.6,0.2])
plot(fbt{2}{1},SpBt_Wake_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(fbt{4}{1},SpBt_Wake_CNO_moy,SpBt_Wake_CNO_std,'r .')
plot(fbt{2}{1},SpBt_Wake_CNO_moy,'r','linewidth',2)
%legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
legend('Saline ErrorBar','Saline','CNO ErrorBar','CNO')
xlabel('Frequency'), ylabel('OB')
title('Mean of OB Wake over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_OB_Wake'))

% OB SWS
figure
%subplot(3,1,2),
hold on, 
%errorbar(fbt{1}{1},SpBt_SWS_Baseline1_moy,SpBt_SWS_Baseline1_std,'k')
%errorbar(fbt{3}{1},SpBt_SWS_Baseline2_moy,SpBt_SWS_Baseline2_std,'b')
errorbar(fbt{2}{1},SpBt_SWS_Saline_moy,SpBt_SWS_Saline_std,'.','color',[0.2,0.6,0.2])
plot(fbt{2}{1},SpBt_SWS_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(fbt{4}{1},SpBt_SWS_CNO_moy,SpBt_SWS_CNO_std,'r .')
plot(fbt{2}{1},SpBt_SWS_CNO_moy,'r','linewidth',2)
%legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
legend('Saline ErrorBar','Saline','CNO ErrorBar','CNO')
xlabel('Frequency'), ylabel('OB')
title('Mean of OB NREM over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_OB_NREM'))

%OB REM
figure
%subplot(3,1,3), 
hold on, 
%errorbar(fbt{1}{1},SpBt_REM_Baseline1_moy,SpBt_REM_Baseline1_std,'k')
%errorbar(fbt{3}{1},SpBt_REM_Baseline2_moy,SpBt_REM_Baseline2_std,'b')
errorbar(fbt{2}{1},SpBt_REM_Saline_moy,SpBt_REM_Saline_std,'.','color',[0.2,0.6,0.2])
plot(fbt{2}{1},SpBt_REM_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(fbt{4}{1},SpBt_REM_CNO_moy,SpBt_REM_CNO_std,'r .')
plot(fbt{2}{1},SpBt_REM_CNO_moy,'r','linewidth',2)
%legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
legend('Saline ErrorBar','Saline','CNO ErrorBar','CNO')
xlabel('Frequency'), ylabel('OB')
title('Mean of OB REM over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_OB_REM'))
