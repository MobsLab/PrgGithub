%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /home/mobschapeau/Dropbox/Kteam/PrgMatlab/Thierry/Alice/Atropine/D_Atropine_PFCSupDeepSpectrum.m

% Ce script permet de tracer 40 figures pour l'expérience atropine en
% utilisant la fonction LoadSpectrumML pour calculer les spectres
% L'expérience atropine comprend 3 conditions : Baseline, Atropine et Saline
% Et elle a été réalisée pour 3 souris : M923, M9266, M927 et M928

% Le sctrip est composé de 5 sections :
%   * Section 1 : calcul et chargement des spectres (4 par condition par
%     souris) à l'aide de la fonction LoadSpectrumML
%   * Section 2 : tracé des analyses spectrales high et low de PFC sup
%     pour chacune des 4 souris (4 figures)
%   * Section 3 : tracé des analyses spectrales high et low de PFC deep
%     pour chacune des 4 souris (4 figures)
%   * Section 4 : tracé des spectrogrammes low PFC deep pour chacune des 4
%     souris (4 figures)
%   * Section 5 : tracé des spectrogrammes high PFC deep pour chacune des 4
%     souris (4 figures)
%   * Section 6 : Tracé des analyses spectrales moyennes High PFC sup (4
%     figures)
%   * Section 7 : Tracé des analyses spectrales moyennes Low PFC sup (4
%     figures)
%   * Section 8 : Tracé des analyses spectrales moyennes High PFC deep (4
%     figures)
%   * Section 9 : Tracé des analyses spectrales moyennes Low PFC deep (4
%     figures)
%   * Section 10 : Analyse avant et après atropine PFC deep (4 figures)
%   * Section 11 : Analyse avant et après atropine PFC sup (4 figures)
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Section 1 : Calcul et chargement des 6 spectres pour chacun des enregistrements

a=0;
Dir{1}=PathForExperiments_TG('atropine_Baseline');
Dir{2}=PathForExperiments_TG('atropine_Atropine');
Dir{3}=PathForExperiments_TG('atropine_Saline');
DirFigure='/media/nas5/Thierry_DATA/Figures/Atropine/';  

for i=1:length(Dir) % baseline 1 ou baseline 2 saline ou CNO
    for j=1:length(Dir{i}.path)        
        cd(Dir{i}.path{j}{1});
    a=a+1;
        load SleepScoring_OBGamma REMEpoch SWSEpoch Wake
        REM{i,j}=REMEpoch;
        wake{i,j}=Wake; 
        SWS{i,j}=SWSEpoch;
% PFC Deep High
    fprintf('Calculting PFC deep high spectrum %d/%d\n',[a,length(Dir)*length(Dir{i}.path)])
    [Sp,t,f]=LoadSpectrumML('PFCx_deep',pwd,'high');
    Spectro_HPFC_deep{i}{j}={Sp,t,f};
    Spectrotsd_HPFC_deep{i}{j}=tsd(t*1E4,Sp);
    f_HPFC_deep{i}{j}=f;

% PFC Deep Low    
    fprintf('Calculting PFC deep low spectrum %d/%d\n',[a,length(Dir)*length(Dir{i}.path)])
    [Sp,t,f]=LoadSpectrumML('PFCx_deep',pwd,'low');
    Spectro_LPFC_deep{i}{j}={Sp,t,f};
    Spectrotsd_LPFC_deep{i}{j}=tsd(t*1E4,Sp);
    f_LPFC_deep{i}{j}=f;
    
% PFC Sup High    
    fprintf('Calculting PFC sup high spectrum %d/%d\n',[a,length(Dir)*length(Dir{i}.path)])
    [Sp,t,f]=LoadSpectrumML('PFCx_sup',pwd,'high');
    Spectro_HPFC_sup{i}{j}={Sp,t,f};
    Spectrotsd_HPFC_sup{i}{j}=tsd(t*1E4,Sp);
    f_HPFC_sup{i}{j}=f;

% PFC Sup Low    
    fprintf('Calculting PFC sup low spectrum %d/%d\n',[a,length(Dir)*length(Dir{i}.path)])
    [Sp,t,f]=LoadSpectrumML('PFCx_sup',pwd,'low');
    Spectro_LPFC_sup{i}{j}={Sp,t,f};
    Spectrotsd_LPFC_sup{i}{j}=tsd(t*1E4,Sp);
    f_LPFC_sup{i}{j}=f;

    end
    
end

%% Section 2 : tracé des analyses spectrales high et low de PFC sup

for i=1:length(Dir{1}.path);    % pour chacune des souris 1=923, 2=926 3=927 et 4=928

    figure
    % High PFC sup 
    % Wake
    subplot(2,3,1), hold on, 
    plot(f_HPFC_sup{1}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{1}{i},wake{1,i})))),'k','linewidth',2), ylabel('High PFC sup')  % 1=Baseline
    plot(f_HPFC_sup{3}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{3}{i},wake{3,i})))),'g','linewidth',2)                 % 3=Saline
    plot(f_HPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{2}{i},wake{2,i})))),'r','linewidth',2)                 % 2=Atropine
    legend('Baseline 1','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('High PFC sup Wake M',num2str(Dir{1}.nMice{i})))
    % SWS
    subplot(2,3,2), hold on, 
    plot(f_HPFC_sup{1}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{1}{i},SWS{1,i})))),'k','linewidth',2), ylabel('High PFC sup')   % 1=Baseline
    plot(f_HPFC_sup{3}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{3}{i},SWS{3,i})))),'g','linewidth',2)                  % 3=Saline
    plot(f_HPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{2}{i},SWS{2,i})))),'r','linewidth',2)                  % 2=Atropine
    legend('Baseline 1','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('High PFC sup NREM M',num2str(Dir{1}.nMice{i})))
    % REM
    subplot(2,3,3), hold on, 
    plot(f_HPFC_sup{1}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{1}{i},REM{1,i})))),'k','linewidth',2), ylabel('High PFC sup')   % 1=Baseline
    plot(f_HPFC_sup{3}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{3}{i},REM{3,i})))),'g','linewidth',2)                  % 3=Saline
    plot(f_HPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{2}{i},REM{2,i})))),'r','linewidth',2)                  % 2=Atropine
    legend('Baseline 1','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('High PFC sup REM M',num2str(Dir{1}.nMice{i})))
    % Low PFC sup
    % Wake
    subplot(2,3,4), hold on,
    plot(f_LPFC_sup{1}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{1}{i},wake{1,i})))),'k','linewidth',2), ylabel('Low PFC sup')
    plot(f_LPFC_sup{3}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{3}{i},wake{3,i})))),'g','linewidth',2)
    plot(f_LPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{2}{i},wake{2,i})))),'r','linewidth',2)
    legend('Baseline 1','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('Low PFC sup Wake M',num2str(Dir{1}.nMice{i})))
    % SWS
    subplot(2,3,5), hold on, 
    plot(f_LPFC_sup{1}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{1}{i},SWS{1,i})))),'k','linewidth',2), ylabel('Low PFC sup')
    plot(f_LPFC_sup{3}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{3}{i},SWS{3,i})))),'g','linewidth',2)
    plot(f_LPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{2}{i},SWS{2,i})))),'r','linewidth',2)
    legend('Baseline 1','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('Low PFC sup NREM M',num2str(Dir{1}.nMice{i})))
    % REM
    subplot(2,3,6), hold on, 
    plot(f_LPFC_sup{1}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{1}{i},REM{1,i})))),'k','linewidth',2), ylabel('Low PFC sup')
    plot(f_LPFC_sup{3}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{3}{i},REM{3,i})))),'g','linewidth',2)
    plot(f_LPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{2}{i},REM{2,i})))),'r','linewidth',2)
    legend('Baseline 1','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('Low PFC sup REM M',num2str(Dir{1}.nMice{i})))
  
    cd(DirFigure);
    figname=strcat('Analyse spectrale PFC sup M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname))  %enregistrement de la figure .fig
    
end

%% Section 3 : tracé des analyses spectrales high et low de PFC deep

for i=1:length(Dir{1}.path);    % pour chacune des souris 1=923, 2=926 3=927 et 4=928

    figure
    % High PFC deep 
    % Wake
    subplot(2,3,1), hold on, 
    plot(f_HPFC_deep{1}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{1}{i},wake{1,i})))),'k','linewidth',2), ylabel('High PFC deep')  % 1=Baseline
    plot(f_HPFC_deep{3}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{3}{i},wake{3,i})))),'g','linewidth',2)                 % 3=Saline
    plot(f_HPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{2}{i},wake{2,i})))),'r','linewidth',2)                 % 2=Atropine
    legend('Baseline 1','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('High PFC deep Wake M',num2str(Dir{1}.nMice{i})))
    % SWS
    subplot(2,3,2), hold on, 
    plot(f_HPFC_deep{1}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{1}{i},SWS{1,i})))),'k','linewidth',2), ylabel('High PFC deep')   % 1=Baseline
    plot(f_HPFC_deep{3}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{3}{i},SWS{3,i})))),'g','linewidth',2)                  % 3=Saline
    plot(f_HPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{2}{i},SWS{2,i})))),'r','linewidth',2)                  % 2=Atropine
    legend('Baseline 1','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('High PFC deep NREM M',num2str(Dir{1}.nMice{i})))
    % REM
    subplot(2,3,3), hold on, 
    plot(f_HPFC_deep{1}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{1}{i},REM{1,i})))),'k','linewidth',2), ylabel('High PFC deep')   % 1=Baseline
    plot(f_HPFC_deep{3}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{3}{i},REM{3,i})))),'g','linewidth',2)                  % 3=Saline
    plot(f_HPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{2}{i},REM{2,i})))),'r','linewidth',2)                  % 2=Atropine
    legend('Baseline 1','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('High PFC deep REM M',num2str(Dir{1}.nMice{i})))
    % Low PFC deep
    % Wake
    subplot(2,3,4), hold on,
    plot(f_LPFC_deep{1}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{1}{i},wake{1,i})))),'k','linewidth',2), ylabel('Low PFC deep')
    plot(f_LPFC_deep{3}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{3}{i},wake{3,i})))),'g','linewidth',2)
    plot(f_LPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{2}{i},wake{2,i})))),'r','linewidth',2)
    legend('Baseline 1','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('Low PFC deep Wake M',num2str(Dir{1}.nMice{i})))
    % SWS
    subplot(2,3,5), hold on, 
    plot(f_LPFC_deep{1}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{1}{i},SWS{1,i})))),'k','linewidth',2), ylabel('Low PFC deep')
    plot(f_LPFC_deep{3}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{3}{i},SWS{3,i})))),'g','linewidth',2)
    plot(f_LPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{2}{i},SWS{2,i})))),'r','linewidth',2)
    legend('Baseline 1','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('Low PFC deep NREM M',num2str(Dir{1}.nMice{i})))
    % REM
    subplot(2,3,6), hold on, 
    plot(f_LPFC_deep{1}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{1}{i},REM{1,i})))),'k','linewidth',2), ylabel('Low PFC deep')
    plot(f_LPFC_deep{3}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{3}{i},REM{3,i})))),'g','linewidth',2)
    plot(f_LPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{2}{i},REM{2,i})))),'r','linewidth',2)
    legend('Baseline 1','Saline','Atropine')
    xlabel('Frequency')
    title(strcat('Low PFC deep REM M',num2str(Dir{1}.nMice{i})))
  
    cd(DirFigure);
    figname=strcat('Analyse spectrale PFC deep M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname))  %enregistrement de la figure .fig
    
end

%% Section 4 : tracé des spectrogrammes low PFC deep

axH{1}=[25,55];     % caxis pour la première souris 923 à déterminer pour optimiser l'affichage
axH{2}=[25,55];     % caxis pour la deuxième souris 926 à déterminer pour optimiser l'affichage
axH{3}=[25,55];     % caxis pour la troisième souris 927 à déterminer pour optimiser l'affichage
axH{4}=[25,55];     % caxis pour la quatrième souris 928 à déterminer pour optimiser l'affichage

for i=1:length(Dir{1}.path);    % pour chacune des souris 1=1035 2=1036 3=1037
    figure
    % Baseline
    subplot(3,1,1)
    imagesc(Spectro_LPFC_deep{1}{i}{2},Spectro_LPFC_deep{1}{i}{3},10*log10(Spectro_LPFC_deep{1}{i}{1}')), axis xy
    title(strcat('Low PFC deep spectrum Baseline M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})  %lancer le premier subplot dans un premier temps pour déterminer le meilleur caxis
    % Atropine
    subplot(3,1,2)
    imagesc(Spectro_LPFC_deep{2}{i}{2},Spectro_LPFC_deep{2}{i}{3},10*log10(Spectro_LPFC_deep{2}{i}{1})'), axis xy
    title(strcat('Low PFC deep spectrum Atropine M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})
    % Saline
    subplot(3,1,3)
    imagesc(Spectro_LPFC_deep{3}{i}{2},Spectro_LPFC_deep{3}{i}{3},10*log10(Spectro_LPFC_deep{3}{i}{1})'), axis xy
    title(strcat('Low PFC deep spectrum Saline M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})

    cd(DirFigure);
    figname=strcat('Spectre low PFC deep M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname)) % enregistrement de la figure .fig
end

%%  Section 5 : tracé des spectrogrammes High PFC deep

axH{1}=[0,30];     % caxis pour la première souris 923 à déterminer pour optimiser l'affichage
axH{2}=[0,30];     % caxis pour la deuxième souris 926 à déterminer pour optimiser l'affichage
axH{3}=[0,30];     % caxis pour la troisième souris 927 à déterminer pour optimiser l'affichage
axH{4}=[0,30];     % caxis pour la quatrième souris 928 à déterminer pour optimiser l'affichage

for i=1:length(Dir{1}.path)    % pour chacune des souris 1=923, 2=926 et 3=927 et 4=928
    figure
    % Baseline
    subplot(3,1,1)
    imagesc(Spectro_HPFC_deep{1}{i}{2},Spectro_HPFC_deep{1}{i}{3},10*log10(Spectro_HPFC_deep{1}{i}{1}')), axis xy
    title(strcat('High PFC deep spectrum Baseline M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})  %lancer le premier subplot dans un premier temps pour déterminer le meilleur caxis
    % Atrimone
    subplot(3,1,2)
    imagesc(Spectro_HPFC_deep{2}{i}{2},Spectro_HPFC_deep{2}{i}{3},10*log10(Spectro_HPFC_deep{2}{i}{1})'), axis xy
    title(strcat('High PFC deep spectrum Atropine M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})
    % Saline
    subplot(3,1,3)
    imagesc(Spectro_HPFC_deep{3}{i}{2},Spectro_HPFC_deep{3}{i}{3},10*log10(Spectro_HPFC_deep{3}{i}{1})'), axis xy
    title(strcat('High PFC deep spectrum Saline M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})
    
    cd(DirFigure);
    figname=strcat('Spectre high PFC deep M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname)) % enregistrement de la figure .fig
end

%% Section 6 : Tracé des analyses spectrales moyennes High PFC sup

for i=1:length(Dir{1}.path)
    data_HPFC_sup_Wake_Baseline(i,:)=mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{1}{i},wake{1,i}))));
    data_HPFC_sup_SWS_Baseline(i,:)=mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{1}{i},SWS{1,i}))));
    data_HPFC_sup_REM_Baseline(i,:)=mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{1}{i},REM{1,i}))));
    data_HPFC_sup_Wake_Saline(i,:)=mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{3}{i},wake{3,i}))));
    data_HPFC_sup_SWS_Saline(i,:)=mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{3}{i},SWS{3,i}))));
    data_HPFC_sup_REM_Saline(i,:)=mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{3}{i},REM{3,i}))));
    data_HPFC_sup_Wake_Atropine(i,:)=mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{2}{i},wake{2,i}))));
    data_HPFC_sup_SWS_Atropine(i,:)=mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{2}{i},SWS{2,i}))));
    data_HPFC_sup_REM_Atropine(i,:)=mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{2}{i},REM{2,i}))));
end
% Calcul des moyennes
Spectrotsd_HPFC_sup_Wake_Baseline_moy=mean(data_HPFC_sup_Wake_Baseline);
Spectrotsd_HPFC_sup_SWS_Baseline_moy=mean(data_HPFC_sup_SWS_Baseline);
Spectrotsd_HPFC_sup_REM_Baseline_moy=mean(data_HPFC_sup_REM_Baseline);
Spectrotsd_HPFC_sup_Wake_Saline_moy=mean(data_HPFC_sup_Wake_Saline);
Spectrotsd_HPFC_sup_SWS_Saline_moy=mean(data_HPFC_sup_SWS_Saline);
Spectrotsd_HPFC_sup_REM_Saline_moy=mean(data_HPFC_sup_REM_Saline);
Spectrotsd_HPFC_sup_Wake_Atropine_moy=mean(data_HPFC_sup_Wake_Atropine);
Spectrotsd_HPFC_sup_SWS_Atropine_moy=mean(data_HPFC_sup_SWS_Atropine);
Spectrotsd_HPFC_sup_REM_Atropine_moy=mean(data_HPFC_sup_REM_Atropine);

% Calcul des écarts types
Spectrotsd_HPFC_sup_Wake_Baseline_std=CalculStdMoyMouse(data_HPFC_sup_Wake_Baseline);
Spectrotsd_HPFC_sup_SWS_Baseline_std=CalculStdMoyMouse(data_HPFC_sup_SWS_Baseline);
Spectrotsd_HPFC_sup_REM_Baseline_std=CalculStdMoyMouse(data_HPFC_sup_REM_Baseline);
Spectrotsd_HPFC_sup_Wake_Saline_std=CalculStdMoyMouse(data_HPFC_sup_Wake_Saline);
Spectrotsd_HPFC_sup_SWS_Saline_std=CalculStdMoyMouse(data_HPFC_sup_SWS_Saline);
Spectrotsd_HPFC_sup_REM_Saline_std=CalculStdMoyMouse(data_HPFC_sup_REM_Saline);
Spectrotsd_HPFC_sup_Wake_Atropine_std=CalculStdMoyMouse(data_HPFC_sup_Wake_Atropine);
Spectrotsd_HPFC_sup_SWS_Atropine_std=CalculStdMoyMouse(data_HPFC_sup_SWS_Atropine);
Spectrotsd_HPFC_sup_REM_Atropine_std=CalculStdMoyMouse(data_HPFC_sup_REM_Atropine);
% High PFC sup wake
figure
%subplot(3,1,1), 
hold on, 
%errorbar(f_HPFC_sup{1}{1},Spectrotsd_HPFC_sup_Wake_Baseline_moy,Spectrotsd_HPFC_sup_Wake_Baseline_std,'k')
errorbar(f_HPFC_sup{3}{1},Spectrotsd_HPFC_sup_Wake_Saline_moy,Spectrotsd_HPFC_sup_Wake_Saline_std,'.','color',[0.2,0.6,0.2])
plot(f_HPFC_sup{3}{1},Spectrotsd_HPFC_sup_Wake_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(f_HPFC_sup{2}{1},Spectrotsd_HPFC_sup_Wake_Atropine_moy,Spectrotsd_HPFC_sup_Wake_Atropine_std,'r .')
plot(f_HPFC_sup{2}{1},Spectrotsd_HPFC_sup_Wake_Atropine_moy,'r','linewidth',2)
legend('Saline ErrorBar','Saline','Atropine ErrorBar','Atropine')
xlabel('Frequency'), ylabel('High PFC sup')
title('Mean of High PFC sup Wake over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_High_PFC_sup_Wake'))

% High PFC sup SWS
figure
%subplot(3,1,2),
hold on, 
%errorbar(f_HPFC_sup{1}{1},Spectrotsd_HPFC_sup_SWS_Baseline1_moy,Spectrotsd_HPFC_sup_SWS_Baseline1_std,'k')
errorbar(f_HPFC_sup{3}{1},Spectrotsd_HPFC_sup_SWS_Saline_moy,Spectrotsd_HPFC_sup_SWS_Saline_std,'.','color',[0.2,0.6,0.2])
plot(f_HPFC_sup{3}{1},Spectrotsd_HPFC_sup_SWS_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(f_HPFC_sup{2}{1},Spectrotsd_HPFC_sup_SWS_Atropine_moy,Spectrotsd_HPFC_sup_SWS_Atropine_std,'r .')
plot(f_HPFC_sup{2}{1},Spectrotsd_HPFC_sup_SWS_Atropine_moy,'r','linewidth',2)
legend('Saline ErrorBar','Saline','Atropine ErrorBar','Atropine')
xlabel('Frequency'), ylabel('High PFC sup')
title('Mean of High PFC sup NREM over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_High_PFC_sup_NREM'))

%High PFC sup REM
figure
%subplot(3,1,3), 
hold on, 
%errorbar(f_HPFC_sup{1}{1},Spectrotsd_HPFC_sup_REM_Baseline1_moy,Spectrotsd_HPFC_sup_REM_Baseline1_std,'k')
errorbar(f_HPFC_sup{3}{1},Spectrotsd_HPFC_sup_REM_Saline_moy,Spectrotsd_HPFC_sup_REM_Saline_std,'.','color',[0.2,0.6,0.2])
plot(f_HPFC_sup{3}{1},Spectrotsd_HPFC_sup_REM_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(f_HPFC_sup{2}{1},Spectrotsd_HPFC_sup_REM_Atropine_moy,Spectrotsd_HPFC_sup_REM_Atropine_std,'r .')
plot(f_HPFC_sup{2}{1},Spectrotsd_HPFC_sup_REM_Atropine_moy,'r','linewidth',2)
legend('Saline ErrorBar','Saline','Atropine ErrorBar','Atropine')
xlabel('Frequency'), ylabel('High PFC sup')
title('Mean of High PFC sup REM over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_High_PFC_sup_REM'))

%% Section 7 : Tracé des analyses spectrales moyennes Low PFC sup

for i=1:length(Dir{1}.path)
    data_LPFC_sup_Wake_Baseline(i,:)=mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{1}{i},wake{1,i}))));
    data_LPFC_sup_SWS_Baseline(i,:)=mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{1}{i},SWS{1,i}))));
    data_LPFC_sup_REM_Baseline(i,:)=mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{1}{i},REM{1,i}))));
    data_LPFC_sup_Wake_Saline(i,:)=mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{3}{i},wake{3,i}))));
    data_LPFC_sup_SWS_Saline(i,:)=mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{3}{i},SWS{3,i}))));
    data_LPFC_sup_REM_Saline(i,:)=mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{3}{i},REM{3,i}))));
    data_LPFC_sup_Wake_Atropine(i,:)=mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{2}{i},wake{2,i}))));
    data_LPFC_sup_SWS_Atropine(i,:)=mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{2}{i},SWS{2,i}))));
    data_LPFC_sup_REM_Atropine(i,:)=mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{2}{i},REM{2,i}))));
end
% Calcul des moyennes
Spectrotsd_LPFC_sup_Wake_Baseline_moy=mean(data_LPFC_sup_Wake_Baseline);
Spectrotsd_LPFC_sup_SWS_Baseline_moy=mean(data_LPFC_sup_SWS_Baseline);
Spectrotsd_LPFC_sup_REM_Baseline_moy=mean(data_LPFC_sup_REM_Baseline);
Spectrotsd_LPFC_sup_Wake_Saline_moy=mean(data_LPFC_sup_Wake_Saline);
Spectrotsd_LPFC_sup_SWS_Saline_moy=mean(data_LPFC_sup_SWS_Saline);
Spectrotsd_LPFC_sup_REM_Saline_moy=mean(data_LPFC_sup_REM_Saline);
Spectrotsd_LPFC_sup_Wake_Atropine_moy=mean(data_LPFC_sup_Wake_Atropine);
Spectrotsd_LPFC_sup_SWS_Atropine_moy=mean(data_LPFC_sup_SWS_Atropine);
Spectrotsd_LPFC_sup_REM_Atropine_moy=mean(data_LPFC_sup_REM_Atropine);

% Calcul des écarts types
Spectrotsd_LPFC_sup_Wake_Baseline_std=CalculStdMoyMouse(data_LPFC_sup_Wake_Baseline);
Spectrotsd_LPFC_sup_SWS_Baseline_std=CalculStdMoyMouse(data_LPFC_sup_SWS_Baseline);
Spectrotsd_LPFC_sup_REM_Baseline_std=CalculStdMoyMouse(data_LPFC_sup_REM_Baseline);
Spectrotsd_LPFC_sup_Wake_Saline_std=CalculStdMoyMouse(data_LPFC_sup_Wake_Saline);
Spectrotsd_LPFC_sup_SWS_Saline_std=CalculStdMoyMouse(data_LPFC_sup_SWS_Saline);
Spectrotsd_LPFC_sup_REM_Saline_std=CalculStdMoyMouse(data_LPFC_sup_REM_Saline);
Spectrotsd_LPFC_sup_Wake_Atropine_std=CalculStdMoyMouse(data_LPFC_sup_Wake_Atropine);
Spectrotsd_LPFC_sup_SWS_Atropine_std=CalculStdMoyMouse(data_LPFC_sup_SWS_Atropine);
Spectrotsd_LPFC_sup_REM_Atropine_std=CalculStdMoyMouse(data_LPFC_sup_REM_Atropine);
% Low PFC sup wake
figure
%subplot(3,1,1), 
hold on, 
%errorbar(f_LPFC_sup{1}{1},Spectrotsd_LPFC_sup_Wake_Baseline_moy,Spectrotsd_LPFC_sup_Wake_Baseline_std,'k')
errorbar(f_LPFC_sup{3}{1},Spectrotsd_LPFC_sup_Wake_Saline_moy,Spectrotsd_LPFC_sup_Wake_Saline_std,'.','color',[0.2,0.6,0.2])
plot(f_LPFC_sup{3}{1},Spectrotsd_LPFC_sup_Wake_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(f_LPFC_sup{2}{1},Spectrotsd_LPFC_sup_Wake_Atropine_moy,Spectrotsd_LPFC_sup_Wake_Atropine_std,'r .')
plot(f_LPFC_sup{2}{1},Spectrotsd_LPFC_sup_Wake_Atropine_moy,'r','linewidth',2)
legend('Saline ErrorBar','Saline','Atropine ErrorBar','Atropine')
xlabel('Frequency'), ylabel('Low PFC sup')
title('Mean of Low PFC sup Wake over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_Low_PFC_sup_Wake'))

% Low PFC sup SWS
figure
%subplot(3,1,2),
hold on, 
%errorbar(f_LPFC_sup{1}{1},Spectrotsd_LPFC_sup_SWS_Baseline1_moy,Spectrotsd_LPFC_sup_SWS_Baseline1_std,'k')
errorbar(f_LPFC_sup{3}{1},Spectrotsd_LPFC_sup_SWS_Saline_moy,Spectrotsd_LPFC_sup_SWS_Saline_std,'.','color',[0.2,0.6,0.2])
plot(f_LPFC_sup{3}{1},Spectrotsd_LPFC_sup_SWS_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(f_LPFC_sup{2}{1},Spectrotsd_LPFC_sup_SWS_Atropine_moy,Spectrotsd_LPFC_sup_SWS_Atropine_std,'r .')
plot(f_LPFC_sup{2}{1},Spectrotsd_LPFC_sup_SWS_Atropine_moy,'r','linewidth',2)
legend('Saline ErrorBar','Saline','Atropine ErrorBar','Atropine')
xlabel('Frequency'), ylabel('Low PFC sup')
title('Mean of Low PFC sup NREM over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_Low_PFC_sup_NREM'))

%Low PFC sup REM
figure
%subplot(3,1,3), 
hold on, 
%errorbar(f_LPFC_sup{1}{1},Spectrotsd_LPFC_sup_REM_Baseline1_moy,Spectrotsd_LPFC_sup_REM_Baseline1_std,'k')
errorbar(f_LPFC_sup{3}{1},Spectrotsd_LPFC_sup_REM_Saline_moy,Spectrotsd_LPFC_sup_REM_Saline_std,'.','color',[0.2,0.6,0.2])
plot(f_LPFC_sup{3}{1},Spectrotsd_LPFC_sup_REM_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(f_LPFC_sup{2}{1},Spectrotsd_LPFC_sup_REM_Atropine_moy,Spectrotsd_LPFC_sup_REM_Atropine_std,'r .')
plot(f_LPFC_sup{2}{1},Spectrotsd_LPFC_sup_REM_Atropine_moy,'r','linewidth',2)
legend('Saline ErrorBar','Saline','Atropine ErrorBar','Atropine')
xlabel('Frequency'), ylabel('Low PFC sup')
title('Mean of Low PFC sup REM over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_Low_PFC_sup_REM'))

%% Section 8 : Tracé des analyses spectrales moyennes High PFC deep

for i=1:length(Dir{1}.path)
    data_HPFC_deep_Wake_Baseline(i,:)=mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{1}{i},wake{1,i}))));
    data_HPFC_deep_SWS_Baseline(i,:)=mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{1}{i},SWS{1,i}))));
    data_HPFC_deep_REM_Baseline(i,:)=mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{1}{i},REM{1,i}))));
    data_HPFC_deep_Wake_Saline(i,:)=mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{3}{i},wake{3,i}))));
    data_HPFC_deep_SWS_Saline(i,:)=mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{3}{i},SWS{3,i}))));
    data_HPFC_deep_REM_Saline(i,:)=mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{3}{i},REM{3,i}))));
    data_HPFC_deep_Wake_Atropine(i,:)=mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{2}{i},wake{2,i}))));
    data_HPFC_deep_SWS_Atropine(i,:)=mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{2}{i},SWS{2,i}))));
    data_HPFC_deep_REM_Atropine(i,:)=mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{2}{i},REM{2,i}))));
end
% Calcul des moyennes
Spectrotsd_HPFC_deep_Wake_Baseline_moy=mean(data_HPFC_deep_Wake_Baseline);
Spectrotsd_HPFC_deep_SWS_Baseline_moy=mean(data_HPFC_deep_SWS_Baseline);
Spectrotsd_HPFC_deep_REM_Baseline_moy=mean(data_HPFC_deep_REM_Baseline);
Spectrotsd_HPFC_deep_Wake_Saline_moy=mean(data_HPFC_deep_Wake_Saline);
Spectrotsd_HPFC_deep_SWS_Saline_moy=mean(data_HPFC_deep_SWS_Saline);
Spectrotsd_HPFC_deep_REM_Saline_moy=mean(data_HPFC_deep_REM_Saline);
Spectrotsd_HPFC_deep_Wake_Atropine_moy=mean(data_HPFC_deep_Wake_Atropine);
Spectrotsd_HPFC_deep_SWS_Atropine_moy=mean(data_HPFC_deep_SWS_Atropine);
Spectrotsd_HPFC_deep_REM_Atropine_moy=mean(data_HPFC_deep_REM_Atropine);

% Calcul des écarts types
Spectrotsd_HPFC_deep_Wake_Baseline_std=CalculStdMoyMouse(data_HPFC_deep_Wake_Baseline);
Spectrotsd_HPFC_deep_SWS_Baseline_std=CalculStdMoyMouse(data_HPFC_deep_SWS_Baseline);
Spectrotsd_HPFC_deep_REM_Baseline_std=CalculStdMoyMouse(data_HPFC_deep_REM_Baseline);
Spectrotsd_HPFC_deep_Wake_Saline_std=CalculStdMoyMouse(data_HPFC_deep_Wake_Saline);
Spectrotsd_HPFC_deep_SWS_Saline_std=CalculStdMoyMouse(data_HPFC_deep_SWS_Saline);
Spectrotsd_HPFC_deep_REM_Saline_std=CalculStdMoyMouse(data_HPFC_deep_REM_Saline);
Spectrotsd_HPFC_deep_Wake_Atropine_std=CalculStdMoyMouse(data_HPFC_deep_Wake_Atropine);
Spectrotsd_HPFC_deep_SWS_Atropine_std=CalculStdMoyMouse(data_HPFC_deep_SWS_Atropine);
Spectrotsd_HPFC_deep_REM_Atropine_std=CalculStdMoyMouse(data_HPFC_deep_REM_Atropine);
% High PFC deep wake
figure
%subplot(3,1,1), 
hold on, 
%errorbar(f_HPFC_deep{1}{1},Spectrotsd_HPFC_deep_Wake_Baseline_moy,Spectrotsd_HPFC_deep_Wake_Baseline_std,'k')
errorbar(f_HPFC_deep{3}{1},Spectrotsd_HPFC_deep_Wake_Saline_moy,Spectrotsd_HPFC_deep_Wake_Saline_std,'.','color',[0.2,0.6,0.2])
plot(f_HPFC_deep{3}{1},Spectrotsd_HPFC_deep_Wake_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(f_HPFC_deep{2}{1},Spectrotsd_HPFC_deep_Wake_Atropine_moy,Spectrotsd_HPFC_deep_Wake_Atropine_std,'r .')
plot(f_HPFC_deep{2}{1},Spectrotsd_HPFC_deep_Wake_Atropine_moy,'r','linewidth',2)
legend('Saline ErrorBar','Saline','Atropine ErrorBar','Atropine')
xlabel('Frequency'), ylabel('High PFC deep')
title('Mean of High PFC deep Wake over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_High_PFC_deep_Wake'))

% High PFC deep SWS
figure
%subplot(3,1,2),
hold on, 
%errorbar(f_HPFC_deep{1}{1},Spectrotsd_HPFC_deep_SWS_Baseline1_moy,Spectrotsd_HPFC_deep_SWS_Baseline1_std,'k')
errorbar(f_HPFC_deep{3}{1},Spectrotsd_HPFC_deep_SWS_Saline_moy,Spectrotsd_HPFC_deep_SWS_Saline_std,'.','color',[0.2,0.6,0.2])
plot(f_HPFC_deep{3}{1},Spectrotsd_HPFC_deep_SWS_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(f_HPFC_deep{2}{1},Spectrotsd_HPFC_deep_SWS_Atropine_moy,Spectrotsd_HPFC_deep_SWS_Atropine_std,'r .')
plot(f_HPFC_deep{2}{1},Spectrotsd_HPFC_deep_SWS_Atropine_moy,'r','linewidth',2)
legend('Saline ErrorBar','Saline','Atropine ErrorBar','Atropine')
xlabel('Frequency'), ylabel('High PFC deep')
title('Mean of High PFC deep NREM over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_High_PFC_deep_NREM'))

%High PFC deep REM
figure
%subplot(3,1,3), 
hold on, 
%errorbar(f_HPFC_deep{1}{1},Spectrotsd_HPFC_deep_REM_Baseline1_moy,Spectrotsd_HPFC_deep_REM_Baseline1_std,'k')
errorbar(f_HPFC_deep{3}{1},Spectrotsd_HPFC_deep_REM_Saline_moy,Spectrotsd_HPFC_deep_REM_Saline_std,'.','color',[0.2,0.6,0.2])
plot(f_HPFC_deep{3}{1},Spectrotsd_HPFC_deep_REM_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(f_HPFC_deep{2}{1},Spectrotsd_HPFC_deep_REM_Atropine_moy,Spectrotsd_HPFC_deep_REM_Atropine_std,'r .')
plot(f_HPFC_deep{2}{1},Spectrotsd_HPFC_deep_REM_Atropine_moy,'r','linewidth',2)
legend('Saline ErrorBar','Saline','Atropine ErrorBar','Atropine')
xlabel('Frequency'), ylabel('High PFC deep')
title('Mean of High PFC deep REM over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_High_PFC_deep_REM'))

%% Section 9 : Tracé des analyses spectrales moyennes Low PFC deep

for i=1:length(Dir{1}.path)
    data_LPFC_deep_Wake_Baseline(i,:)=mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{1}{i},wake{1,i}))));
    data_LPFC_deep_SWS_Baseline(i,:)=mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{1}{i},SWS{1,i}))));
    data_LPFC_deep_REM_Baseline(i,:)=mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{1}{i},REM{1,i}))));
    data_LPFC_deep_Wake_Saline(i,:)=mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{3}{i},wake{3,i}))));
    data_LPFC_deep_SWS_Saline(i,:)=mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{3}{i},SWS{3,i}))));
    data_LPFC_deep_REM_Saline(i,:)=mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{3}{i},REM{3,i}))));
    data_LPFC_deep_Wake_Atropine(i,:)=mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{2}{i},wake{2,i}))));
    data_LPFC_deep_SWS_Atropine(i,:)=mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{2}{i},SWS{2,i}))));
    data_LPFC_deep_REM_Atropine(i,:)=mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{2}{i},REM{2,i}))));
end
% Calcul des moyennes
Spectrotsd_LPFC_deep_Wake_Baseline_moy=mean(data_LPFC_deep_Wake_Baseline);
Spectrotsd_LPFC_deep_SWS_Baseline_moy=mean(data_LPFC_deep_SWS_Baseline);
Spectrotsd_LPFC_deep_REM_Baseline_moy=mean(data_LPFC_deep_REM_Baseline);
Spectrotsd_LPFC_deep_Wake_Saline_moy=mean(data_LPFC_deep_Wake_Saline);
Spectrotsd_LPFC_deep_SWS_Saline_moy=mean(data_LPFC_deep_SWS_Saline);
Spectrotsd_LPFC_deep_REM_Saline_moy=mean(data_LPFC_deep_REM_Saline);
Spectrotsd_LPFC_deep_Wake_Atropine_moy=mean(data_LPFC_deep_Wake_Atropine);
Spectrotsd_LPFC_deep_SWS_Atropine_moy=mean(data_LPFC_deep_SWS_Atropine);
Spectrotsd_LPFC_deep_REM_Atropine_moy=mean(data_LPFC_deep_REM_Atropine);

% Calcul des écarts types
Spectrotsd_LPFC_deep_Wake_Baseline_std=CalculStdMoyMouse(data_LPFC_deep_Wake_Baseline);
Spectrotsd_LPFC_deep_SWS_Baseline_std=CalculStdMoyMouse(data_LPFC_deep_SWS_Baseline);
Spectrotsd_LPFC_deep_REM_Baseline_std=CalculStdMoyMouse(data_LPFC_deep_REM_Baseline);
Spectrotsd_LPFC_deep_Wake_Saline_std=CalculStdMoyMouse(data_LPFC_deep_Wake_Saline);
Spectrotsd_LPFC_deep_SWS_Saline_std=CalculStdMoyMouse(data_LPFC_deep_SWS_Saline);
Spectrotsd_LPFC_deep_REM_Saline_std=CalculStdMoyMouse(data_LPFC_deep_REM_Saline);
Spectrotsd_LPFC_deep_Wake_Atropine_std=CalculStdMoyMouse(data_LPFC_deep_Wake_Atropine);
Spectrotsd_LPFC_deep_SWS_Atropine_std=CalculStdMoyMouse(data_LPFC_deep_SWS_Atropine);
Spectrotsd_LPFC_deep_REM_Atropine_std=CalculStdMoyMouse(data_LPFC_deep_REM_Atropine);
% Low PFC deep wake
figure
%subplot(3,1,1), 
hold on, 
%errorbar(f_LPFC_deep{1}{1},Spectrotsd_LPFC_deep_Wake_Baseline_moy,Spectrotsd_LPFC_deep_Wake_Baseline_std,'k')
errorbar(f_LPFC_deep{3}{1},Spectrotsd_LPFC_deep_Wake_Saline_moy,Spectrotsd_LPFC_deep_Wake_Saline_std,'.','color',[0.2,0.6,0.2])
plot(f_LPFC_deep{3}{1},Spectrotsd_LPFC_deep_Wake_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(f_LPFC_deep{2}{1},Spectrotsd_LPFC_deep_Wake_Atropine_moy,Spectrotsd_LPFC_deep_Wake_Atropine_std,'r .')
plot(f_LPFC_deep{2}{1},Spectrotsd_LPFC_deep_Wake_Atropine_moy,'r','linewidth',2)
legend('Saline ErrorBar','Saline','Atropine ErrorBar','Atropine')
xlabel('Frequency'), ylabel('Low PFC deep')
title('Mean of Low PFC deep Wake over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_Low_PFC_deep_Wake'))

% Low PFC deep SWS
figure
%subplot(3,1,2),
hold on, 
%errorbar(f_LPFC_deep{1}{1},Spectrotsd_LPFC_deep_SWS_Baseline1_moy,Spectrotsd_LPFC_deep_SWS_Baseline1_std,'k')
errorbar(f_LPFC_deep{3}{1},Spectrotsd_LPFC_deep_SWS_Saline_moy,Spectrotsd_LPFC_deep_SWS_Saline_std,'.','color',[0.2,0.6,0.2])
plot(f_LPFC_deep{3}{1},Spectrotsd_LPFC_deep_SWS_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(f_LPFC_deep{2}{1},Spectrotsd_LPFC_deep_SWS_Atropine_moy,Spectrotsd_LPFC_deep_SWS_Atropine_std,'r .')
plot(f_LPFC_deep{2}{1},Spectrotsd_LPFC_deep_SWS_Atropine_moy,'r','linewidth',2)
legend('Saline ErrorBar','Saline','Atropine ErrorBar','Atropine')
xlabel('Frequency'), ylabel('Low PFC deep')
title('Mean of Low PFC deep NREM over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_Low_PFC_deep_NREM'))

%Low PFC deep REM
figure
%subplot(3,1,3), 
hold on, 
%errorbar(f_LPFC_deep{1}{1},Spectrotsd_LPFC_deep_REM_Baseline1_moy,Spectrotsd_LPFC_deep_REM_Baseline1_std,'k')
errorbar(f_LPFC_deep{3}{1},Spectrotsd_LPFC_deep_REM_Saline_moy,Spectrotsd_LPFC_deep_REM_Saline_std,'.','color',[0.2,0.6,0.2])
plot(f_LPFC_deep{3}{1},Spectrotsd_LPFC_deep_REM_Saline_moy,'color',[0.2,0.6,0.2],'linewidth',2)
errorbar(f_LPFC_deep{2}{1},Spectrotsd_LPFC_deep_REM_Atropine_moy,Spectrotsd_LPFC_deep_REM_Atropine_std,'r .')
plot(f_LPFC_deep{2}{1},Spectrotsd_LPFC_deep_REM_Atropine_moy,'r','linewidth',2)
legend('Saline ErrorBar','Saline','Atropine ErrorBar','Atropine')
xlabel('Frequency'), ylabel('Low PFC deep')
title('Mean of Low PFC deep REM over all mice')
cd(DirFigure);
savefig(fullfile('Analyse_moyenne_Low_PFC_deep_REM'))


%% Section 10 : Analyse avant et après atropine PFC deep

Atropine(1)= intervalSet(8216*1e4,(8216+3*60*60)*1e4);
Atropine(2)= intervalSet(8295*1e4,(8295+3*60*60)*1e4);
Atropine(3)= intervalSet(8341*1e4,(8341+3*60*60)*1e4);
Atropine(4)= intervalSet(8378*1e4,(8378+3*60*60)*1e4);

Avant(1)= intervalSet(0,8216*1e4);
Avant(2)= intervalSet(0,8295*1e4);
Avant(3)= intervalSet(0,8341*1e4);
Avant(4)= intervalSet(0,8378*1e4);
for i=1:length(Dir{1}.path);
    figure
    % Low PFC deep 
    % Wake
    subplot(2,3,1), hold on, 
    plot(f_LPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{2}{i},and(wake{2,i},Avant(i)))))),'k','linewidth',2), ylabel('High PFC deep')
    plot(f_LPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{2}{i},and(wake{2,i},Atropine(i)))))),'r','linewidth',2)                 
    legend('Before atropine','After atropine')
    xlabel('Frequency')
    title(strcat('Low PFC deep Wake M',num2str(Dir{1}.nMice{i})))
    % SWS
    subplot(2,3,2), hold on, 
    plot(f_LPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{2}{i},and(SWS{2,i},Avant(i)))))),'k','linewidth',2), ylabel('High PFC deep')
    plot(f_LPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{2}{i},and(SWS{2,i},Atropine(i)))))),'r','linewidth',2)                 
    legend('Before atropine','After atropine')
    xlabel('Frequency')
    title(strcat('Low PFC deep NREM M',num2str(Dir{1}.nMice{i})))
    %REM
    subplot(2,3,3), hold on, 
    plot(f_LPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{2}{i},and(REM{2,i},Avant(i)))))),'k','linewidth',2), ylabel('High PFC deep')
    plot(f_LPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{2}{i},and(REM{2,i},Atropine(i)))))),'r','linewidth',2)                 
    legend('Before atropine','After atropine')
    xlabel('Frequency')
    title(strcat('Low PFC deep REM M',num2str(Dir{1}.nMice{i})))
    
    % High PFC deep 
    % Wake
    subplot(2,3,4), hold on, 
    plot(f_HPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{2}{i},and(wake{2,i},Avant(i)))))),'k','linewidth',2), ylabel('High PFC deep')
    plot(f_HPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{2}{i},and(wake{2,i},Atropine(i)))))),'r','linewidth',2)                 
    legend('Before atropine','After atropine')
    xlabel('Frequency')
    title(strcat('High PFC deep Wake M',num2str(Dir{1}.nMice{i})))
    % SWS
    subplot(2,3,5), hold on, 
    plot(f_HPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{2}{i},and(SWS{2,i},Avant(i)))))),'k','linewidth',2), ylabel('High PFC deep')
    plot(f_HPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{2}{i},and(SWS{2,i},Atropine(i)))))),'r','linewidth',2)                 
    legend('Before atropine','After atropine')
    xlabel('Frequency')
    title(strcat('High PFC deep NREM M',num2str(Dir{1}.nMice{i})))
    %REM
    subplot(2,3,6), hold on, 
    plot(f_HPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{2}{i},and(REM{2,i},Avant(i)))))),'k','linewidth',2), ylabel('High PFC deep')
    plot(f_HPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{2}{i},and(REM{2,i},Atropine(i)))))),'r','linewidth',2)                 
    legend('Before atropine','After atropine')
    xlabel('Frequency')
    title(strcat('High PFC deep REM M',num2str(Dir{1}.nMice{i})))
    
    cd(DirFigure);
    figname=strcat('ANALYSE SPECTRALE AVANT ET APRÈS ATROPINE PFC DEEP M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname)) % enregistrement de la figure .fig

end


%% Section 11 : Analyse avant et après atropine PFC sup

Atropine(1)= intervalSet(8216*1e4,(8216+3*60*60)*1e4);
Atropine(2)= intervalSet(8295*1e4,(8295+3*60*60)*1e4);
Atropine(3)= intervalSet(8341*1e4,(8341+3*60*60)*1e4);
Atropine(4)= intervalSet(8378*1e4,(8378+3*60*60)*1e4);

Avant(1)= intervalSet(0,8216*1e4);
Avant(2)= intervalSet(0,8295*1e4);
Avant(3)= intervalSet(0,8341*1e4);
Avant(4)= intervalSet(0,8378*1e4);
for i=1:length(Dir{1}.path);
    figure
    % Low PFC sup 
    % Wake
    subplot(2,3,1), hold on, 
    plot(f_LPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{2}{i},and(wake{2,i},Avant(i)))))),'k','linewidth',2), ylabel('High PFC sup')
    plot(f_LPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{2}{i},and(wake{2,i},Atropine(i)))))),'r','linewidth',2)                 
    legend('Before atropine','After atropine')
    xlabel('Frequency')
    title(strcat('Low PFC sup Wake M',num2str(Dir{1}.nMice{i})))
    % SWS
    subplot(2,3,2), hold on, 
    plot(f_LPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{2}{i},and(SWS{2,i},Avant(i)))))),'k','linewidth',2), ylabel('High PFC sup')
    plot(f_LPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{2}{i},and(SWS{2,i},Atropine(i)))))),'r','linewidth',2)                 
    legend('Before atropine','After atropine')
    xlabel('Frequency')
    title(strcat('Low PFC sup NREM M',num2str(Dir{1}.nMice{i})))
    %REM
    subplot(2,3,3), hold on, 
    plot(f_LPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{2}{i},and(REM{2,i},Avant(i)))))),'k','linewidth',2), ylabel('High PFC sup')
    plot(f_LPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{2}{i},and(REM{2,i},Atropine(i)))))),'r','linewidth',2)                 
    legend('Before atropine','After atropine')
    xlabel('Frequency')
    title(strcat('Low PFC sup REM M',num2str(Dir{1}.nMice{i})))
    
    % High PFC sup 
    % Wake
    subplot(2,3,4), hold on, 
    plot(f_HPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{2}{i},and(wake{2,i},Avant(i)))))),'k','linewidth',2), ylabel('High PFC sup')
    plot(f_HPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{2}{i},and(wake{2,i},Atropine(i)))))),'r','linewidth',2)                 
    legend('Before atropine','After atropine')
    xlabel('Frequency')
    title(strcat('High PFC sup Wake M',num2str(Dir{1}.nMice{i})))
    % SWS
    subplot(2,3,5), hold on, 
    plot(f_HPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{2}{i},and(SWS{2,i},Avant(i)))))),'k','linewidth',2), ylabel('High PFC sup')
    plot(f_HPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{2}{i},and(SWS{2,i},Atropine(i)))))),'r','linewidth',2)                 
    legend('Before atropine','After atropine')
    xlabel('Frequency')
    title(strcat('High PFC sup NREM M',num2str(Dir{1}.nMice{i})))
    %REM
    subplot(2,3,6), hold on, 
    plot(f_HPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{2}{i},and(REM{2,i},Avant(i)))))),'k','linewidth',2), ylabel('High PFC sup')
    plot(f_HPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{2}{i},and(REM{2,i},Atropine(i)))))),'r','linewidth',2)                 
    legend('Before atropine','After atropine')
    xlabel('Frequency')
    title(strcat('High PFC sup REM M',num2str(Dir{1}.nMice{i})))
    
    cd(DirFigure);
    figname=strcat('ANALYSE SPECTRALE AVANT ET APRÈS ATROPINE PFC SUP M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname)) % enregistrement de la figure .fig

end