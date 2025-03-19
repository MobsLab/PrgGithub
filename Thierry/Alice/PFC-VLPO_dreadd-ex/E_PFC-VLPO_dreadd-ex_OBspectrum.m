%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /home/mobschapeau/Dropbox/Kteam/PrgMatlab/Thierry/Alice/PFC-VLPO_dread-ex/ParcoursComputeOBspectrum.m

% Ce script permet de tracer 9 figures pour l'expérience PFC-VLPO_dread-ex en
% utilisant la fonction LoadSpectrumML pour calculer les spectres
% L'expérience PFC-VLPO_dread-ex comprend 4 conditions : Baseline 1, Saline,
% Baseline 2 et CNO
% Et elle a été réalisée pour 3 souris : M1035, M1036 et M1037

% Le sctrip est composé de 4 sections :
%   * Section 1 : calcul et chargement des spectres (2 par condition par
%     souris) à l'aide de la fonction LoadSpectrumML
%   * Section 2 : tracé des analyses spectrales high et low de OB pour
%     chacune des 3 souris (3 figures)
%   * Section 3 : tracé des spectrogrammes low OB pour chacune des 3 souris
%     (3 figures)
%   * Section 4 : Tracé des analyses spectrales moyennes Low OB (3 figures)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Section 1 : Calcul et chargement des 6 spectres pour chacun des enregistrements

a=0
Dir{1}=PathForExperiments_TG('PFC-VLPO_dreadd-ex_Baseline1');
Dir{2}=PathForExperiments_TG('PFC-VLPO_dreadd-ex_Saline');
Dir{3}=PathForExperiments_TG('PFC-VLPO_dreadd-ex_Baseline2');
Dir{4}=PathForExperiments_TG('PFC-VLPO_dreadd-ex_CNO');
DirFigure='/media/nas5/Thierry_DATA/Figures/PFC-VLPO_dreadd-cre/';

for i=1:length(Dir) % baseline 1 ou baseline 2 ou exp i = pour chacune des condtions
    for j=1:length(Dir{i}.path) % j = pour chacune des souris       
        cd(Dir{i}.path{j}{1});
        a=a+1;
        load SleepScoring_OBGamma REMEpoch SWSEpoch Wake
        REM{i,j}=REMEpoch;
        wake{i,j}=Wake; 
        SWS{i,j}=SWSEpoch;
    
% Bulb low
    fprintf('Calculting OB low spectrum %d/%d\n',[a,length(Dir)*length(Dir{i}.path)])
    [Sp,t,f]=LoadSpectrumML('Bulb_deep',pwd,'low');
    Spectro_OB{i}{j}={Sp,t,f};
    Spectrotsd_OB{i}{j}=tsd(t*1E4,Sp);
    f_OB{i}{j}=f;
    
% Bulb High
    fprintf('Calculting OB high spectrum %d/%d\n',[a,length(Dir)*length(Dir{i}.path)])
    [Sp,t,f]=LoadSpectrumML('Bulb_deep',pwd,'high');
    Spectro_HB{i}{j}={Sp,t,f};
    Spectrotsd_HB{i}{j}=tsd(t*1E4,Sp);
    f_HB{i}{j}=f;
    end
    
end


%% Section 2 : tracé des analyses spectrales high et low de OB

for i=1:length(Dir{1}.path);    % pour chacune des souris 1=1035, 2=1036 et 3=1037

    figure
    % High Bulb
    % Wake
    subplot(2,3,1), hold on,
    plot(f_HB{1}{i},mean(10*(Data(Restrict(Spectrotsd_HB{1}{i},wake{1,i})))),'k','linewidth',2), ylabel('HPC')  % 1=Baseline 1
    plot(f_HB{3}{i},mean(10*(Data(Restrict(Spectrotsd_HB{3}{i},wake{3,i})))),'b','linewidth',2)                 % 3=Baseline 2
    plot(f_HB{2}{i},mean(10*(Data(Restrict(Spectrotsd_HB{2}{i},wake{2,i})))),'g','linewidth',2)                 % 2=Saline
    plot(f_HB{4}{i},mean(10*(Data(Restrict(Spectrotsd_HB{4}{i},wake{4,i})))),'r','linewidth',2)                 % 4=CNO
    legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
    xlabel('Frequency')
    title(strcat('High OB Wake M',num2str(Dir{1}.nMice{i})))
    % SWS
    subplot(2,3,2), hold on, 
    plot(f_HB{1}{i},mean(10*(Data(Restrict(Spectrotsd_HB{1}{i},SWS{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_HB{3}{i},mean(10*(Data(Restrict(Spectrotsd_HB{3}{i},SWS{3,i})))),'b','linewidth',2)
    plot(f_HB{2}{i},mean(10*(Data(Restrict(Spectrotsd_HB{2}{i},SWS{2,i})))),'g','linewidth',2)
    plot(f_HB{4}{i},mean(10*(Data(Restrict(Spectrotsd_HB{4}{i},SWS{4,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
    xlabel('Frequency')
    title(strcat('High OB NREM M',num2str(Dir{1}.nMice{i})))
    % REM
    subplot(2,3,3), hold on, 
    plot(f_HB{1}{i},mean(10*(Data(Restrict(Spectrotsd_HB{1}{i},REM{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_HB{3}{i},mean(10*(Data(Restrict(Spectrotsd_HB{3}{i},REM{3,i})))),'b','linewidth',2)
    plot(f_HB{2}{i},mean(10*(Data(Restrict(Spectrotsd_HB{2}{i},REM{2,i})))),'g','linewidth',2)
    plot(f_HB{4}{i},mean(10*(Data(Restrict(Spectrotsd_HB{4}{i},REM{4,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Saline','Exposure')
    xlabel('Frequency')
    title(strcat('High OB REM M',num2str(Dir{1}.nMice{i})))
    % Low Bulb
    % Wake
    subplot(2,3,4), hold on, 
    plot(f_OB{1}{i},mean(10*(Data(Restrict(Spectrotsd_OB{1}{i},wake{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_OB{3}{i},mean(10*(Data(Restrict(Spectrotsd_OB{3}{i},wake{3,i})))),'b','linewidth',2)
    plot(f_OB{2}{i},mean(10*(Data(Restrict(Spectrotsd_OB{2}{i},wake{2,i})))),'g','linewidth',2)
    plot(f_OB{4}{i},mean(10*(Data(Restrict(Spectrotsd_OB{4}{i},wake{4,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
    xlabel('Frequency')
    title(strcat('Low OB Wake M',num2str(Dir{1}.nMice{i})))
    % SWS
    subplot(2,3,5), hold on, 
    plot(f_OB{1}{i},mean(10*(Data(Restrict(Spectrotsd_OB{1}{i},SWS{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_OB{3}{i},mean(10*(Data(Restrict(Spectrotsd_OB{3}{i},SWS{3,i})))),'b','linewidth',2)
    plot(f_OB{2}{i},mean(10*(Data(Restrict(Spectrotsd_OB{2}{i},SWS{2,i})))),'g','linewidth',2)
    plot(f_OB{4}{i},mean(10*(Data(Restrict(Spectrotsd_OB{4}{i},SWS{4,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
    xlabel('Frequency')
    title(strcat('Low OB NREM M',num2str(Dir{1}.nMice{i})))
    % REM
    subplot(2,3,6), hold on, 
    plot(f_OB{1}{i},mean(10*(Data(Restrict(Spectrotsd_OB{1}{i},REM{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_OB{3}{i},mean(10*(Data(Restrict(Spectrotsd_OB{3}{i},REM{3,i})))),'b','linewidth',2)
    plot(f_OB{2}{i},mean(10*(Data(Restrict(Spectrotsd_OB{2}{i},REM{2,i})))),'g','linewidth',2)
    plot(f_OB{4}{i},mean(10*(Data(Restrict(Spectrotsd_OB{4}{i},REM{4,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
    xlabel('Frequency')
    title(strcat('Low OB REM M',num2str(Dir{1}.nMice{i})))
    
    cd(DirFigure);
    figname=strcat('Analyse spectrale low et high OB M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname)) % enregistrement de la figure .fig
    
end


%% Section 3 : tracé des spectrogrammes low OB

axH{1}=[25,55];     % caxis pour la première souris 1035 à déterminer pour optimiser l'affichage
axH{2}=[25,55];     % caxis pour la deuxième souris 1036 à déterminer pour optimiser l'affichage
axH{3}=[25,55];     % caxis pour la troisième souris 1037 à déterminer pour optimiser l'affichage

for i=1:length(Dir{1}.path)    % pour chacune des souris 1=923 et 2=926
    figure
    % Baseline 1
    subplot(4,1,1)
    imagesc(Spectro_OB{1}{i}{2},Spectro_OB{1}{i}{3},10*log10(Spectro_OB{1}{i}{1}')), axis xy
    title(strcat('Low OB spectrum Baseline 1 M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})  %lancer le premier subplot dans un premier temps pour déterminer le meilleur caxis
    % Saline
    subplot(4,1,2)
    imagesc(Spectro_OB{2}{i}{2},Spectro_OB{2}{i}{3},10*log10(Spectro_OB{2}{i}{1})'), axis xy
    title(strcat('Low OB spectrum Saline M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})
    % Baseline 2
    subplot(4,1,3)
    imagesc(Spectro_OB{3}{i}{2},Spectro_OB{3}{i}{3},10*log10(Spectro_OB{3}{i}{1})'), axis xy
    title(strcat('Low OB spectrum Baseline 2 M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})
    % CNO
    subplot(4,1,3)
    imagesc(Spectro_OB{4}{i}{2},Spectro_OB{4}{i}{3},10*log10(Spectro_OB{4}{i}{1})'), axis xy
    title(strcat('Low OB spectrum CNO M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})

    cd(DirFigure);
    figname=strcat('Spectre low OB M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname)) % enregistrement de la figure .fig
end


%% Section 4 : Tracé des analyses spectrales moyennes Low OB

for i=1:length(Dir{1}.path)
    data_OB_Wake_Baseline1(i,:)=mean(10*(Data(Restrict(Spectrotsd_OB{1}{i},wake{1,i}))));
    data_OB_SWS_Baseline1(i,:)=mean(10*(Data(Restrict(Spectrotsd_OB{1}{i},SWS{1,i}))));
    data_OB_REM_Baseline1(i,:)=mean(10*(Data(Restrict(Spectrotsd_OB{1}{i},REM{1,i}))));
    data_OB_Wake_Saline(i,:)=mean(10*(Data(Restrict(Spectrotsd_OB{2}{i},wake{2,i}))));
    data_OB_SWS_Saline(i,:)=mean(10*(Data(Restrict(Spectrotsd_OB{2}{i},SWS{2,i}))));
    data_OB_REM_Saline(i,:)=mean(10*(Data(Restrict(Spectrotsd_OB{2}{i},REM{2,i}))));
    data_OB_Wake_Baseline2(i,:)=mean(10*(Data(Restrict(Spectrotsd_OB{3}{i},wake{3,i}))));
    data_OB_SWS_Baseline2(i,:)=mean(10*(Data(Restrict(Spectrotsd_OB{3}{i},SWS{3,i}))));
    data_OB_REM_Baseline2(i,:)=mean(10*(Data(Restrict(Spectrotsd_OB{3}{i},REM{3,i}))));
    data_OB_Wake_CNO(i,:)=mean(10*(Data(Restrict(Spectrotsd_OB{4}{i},wake{4,i}))));
    data_OB_SWS_CNO(i,:)=mean(10*(Data(Restrict(Spectrotsd_OB{4}{i},SWS{4,i}))));
    data_OB_REM_CNO(i,:)=mean(10*(Data(Restrict(Spectrotsd_OB{4}{i},REM{4,i}))));
end
% Calcul des moyennes
Spectrotsd_OB_Wake_Baseline1_moy=mean(data_OB_Wake_Baseline1);
Spectrotsd_OB_SWS_Baseline1_moy=mean(data_OB_SWS_Baseline1);
Spectrotsd_OB_REM_Baseline1_moy=mean(data_OB_REM_Baseline1);
Spectrotsd_OB_Wake_Saline_moy=mean(data_OB_Wake_Saline);
Spectrotsd_OB_SWS_Saline_moy=mean(data_OB_SWS_Saline);
Spectrotsd_OB_REM_Saline_moy=mean(data_OB_REM_Saline);
Spectrotsd_OB_Wake_Baseline2_moy=mean(data_OB_Wake_Baseline2);
Spectrotsd_OB_SWS_Baseline2_moy=mean(data_OB_SWS_Baseline2);
Spectrotsd_OB_REM_Baseline2_moy=mean(data_OB_REM_Baseline2);
Spectrotsd_OB_Wake_CNO_moy=mean(data_OB_Wake_CNO);
Spectrotsd_OB_SWS_CNO_moy=mean(data_OB_SWS_CNO);
Spectrotsd_OB_REM_CNO_moy=mean(data_OB_REM_CNO);

% Calcul des écarts types
Spectrotsd_OB_Wake_Baseline1_std=CalculStdMoyMouse(data_OB_Wake_Baseline1);
Spectrotsd_OB_SWS_Baseline1_std=CalculStdMoyMouse(data_OB_SWS_Baseline1);
Spectrotsd_OB_REM_Baseline1_std=CalculStdMoyMouse(data_OB_REM_Baseline1);
Spectrotsd_OB_Wake_Saline_std=CalculStdMoyMouse(data_OB_Wake_Saline);
Spectrotsd_OB_SWS_Saline_std=CalculStdMoyMouse(data_OB_SWS_Saline);
Spectrotsd_OB_REM_Saline_std=CalculStdMoyMouse(data_OB_REM_Saline);
Spectrotsd_OB_Wake_Baseline2_std=CalculStdMoyMouse(data_OB_Wake_Baseline2);
Spectrotsd_OB_SWS_Baseline2_std=CalculStdMoyMouse(data_OB_SWS_Baseline2);
Spectrotsd_OB_REM_Baseline2_std=CalculStdMoyMouse(data_OB_REM_Baseline2);
Spectrotsd_OB_Wake_CNO_std=CalculStdMoyMouse(data_OB_Wake_CNO);
Spectrotsd_OB_SWS_CNO_std=CalculStdMoyMouse(data_OB_SWS_CNO);
Spectrotsd_OB_REM_CNO_std=CalculStdMoyMouse(data_OB_REM_CNO);

% Low OB wake
figure
%subplot(3,1,1), 
hold on, 
%errorbar(f_OB{1}{1},Spectrotsd_OB_Wake_Baseline1_moy,Spectrotsd_OB_Wake_Baseline1_std,'k')
%errorbar(f_OB{3}{1},Spectrotsd_OB_Wake_Baseline2_moy,Spectrotsd_OB_Wake_Baseline2_std,'b')
errorbar(f_OB{2}{1},Spectrotsd_OB_Wake_Saline_moy,Spectrotsd_OB_Wake_Saline_std,'.','color',[0.2,0.6,0.2])
plot(f_OB{2}{1},Spectrotsd_OB_Wake_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(f_OB{4}{1},Spectrotsd_OB_Wake_CNO_moy,Spectrotsd_OB_Wake_CNO_std,'r .')
plot(f_OB{2}{1},Spectrotsd_OB_Wake_CNO_moy,'r','linewidth',2)
%legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
legend('Saline ErrorBar','Saline','CNO ErrorBar','CNO')
xlabel('Frequency'), ylabel('Low OB')
title('Mean of Low OB Wake over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_Low_OB_Wake'))

% Low OB SWS
figure
%subplot(3,1,2),
hold on, 
%errorbar(f_OB{1}{1},Spectrotsd_OB_SWS_Baseline1_moy,Spectrotsd_OB_SWS_Baseline1_std,'k')
%errorbar(f_OB{3}{1},Spectrotsd_OB_SWS_Baseline2_moy,Spectrotsd_OB_SWS_Baseline2_std,'b')
errorbar(f_OB{2}{1},Spectrotsd_OB_SWS_Saline_moy,Spectrotsd_OB_SWS_Saline_std,'.','color',[0.2,0.6,0.2])
plot(f_OB{2}{1},Spectrotsd_OB_SWS_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(f_OB{4}{1},Spectrotsd_OB_SWS_CNO_moy,Spectrotsd_OB_SWS_CNO_std,'r .')
plot(f_OB{2}{1},Spectrotsd_OB_SWS_CNO_moy,'r','linewidth',2)
%legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
legend('Saline ErrorBar','Saline','CNO ErrorBar','CNO')
xlabel('Frequency'), ylabel('Low OB')
title('Mean of Low OB NREM over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_Low_OB_NREM'))

%Low OB REM
figure
%subplot(3,1,3), 
hold on, 
%errorbar(f_OB{1}{1},Spectrotsd_OB_REM_Baseline1_moy,Spectrotsd_OB_REM_Baseline1_std,'k')
%errorbar(f_OB{3}{1},Spectrotsd_OB_REM_Baseline2_moy,Spectrotsd_OB_REM_Baseline2_std,'b')
errorbar(f_OB{2}{1},Spectrotsd_OB_REM_Saline_moy,Spectrotsd_OB_REM_Saline_std,'.','color',[0.2,0.6,0.2])
plot(f_OB{2}{1},Spectrotsd_OB_REM_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(f_OB{4}{1},Spectrotsd_OB_REM_CNO_moy,Spectrotsd_OB_REM_CNO_std,'r .')
plot(f_OB{2}{1},Spectrotsd_OB_REM_CNO_moy,'r','linewidth',2)
%legend('Baseline 1', 'Baseline 2', 'Saline','CNO')
legend('Saline ErrorBar','Saline','CNO ErrorBar','CNO')
xlabel('Frequency'), ylabel('Low OB')
title('Mean of Low OB REM over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_Low_OB_REM'))
