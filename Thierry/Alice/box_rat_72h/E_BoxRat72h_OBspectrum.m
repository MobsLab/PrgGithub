%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /home/mobschapeau/Dropbox/Kteam/PrgMatlab/Thierry/Alice/box_rat_72h/ParcoursComputeOBspectrum.m

% Ce script permet de tracer 4 figures pour l'expérience Box Rat 72h en
% utilisant la fonction LoadSpectrumML pour calculer les spectres
% L'expérience Box Rat 72h comprend 3 conditions : Baseline 1, Eposure et
% Baseline 2
% Et elle a été réalisée pour 2 souris : M923 et M926

% Le sctrip est composé de 3 sections :
%   * Section 1 : calcul et chargement des spectres (2 par condition par
%     souris) à l'aide de la fonction LoadSpectrumML
%   * Section 2 : tracé des analyses spectrales high et low de OB pour
%     chacune des deux souris (2 figures)
%   * Section 3 : tracé des spectrogrammes low OB pour chacune des deux souris
%     (2 figures)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Section 1 : Calcul et chargement des 6 spectres pour chacun des enregistrements

Dir{1}=PathForExperiments_TG('box_rat_72h_Baseline1');      % 1=Baseline 1
Dir{2}=PathForExperiments_TG('box_rat_72h_Exposure');       % 2=Exposure
Dir{3}=PathForExperiments_TG('box_rat_72h_Baseline2');      % 3=Baseline 2
DirFigure='/media/nas5/Thierry_DATA/Figures/Rat_box_72h/Figures/';  % dossier où seront enregistrées les figures .fig
a=0;

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

for i=1:length(Dir{1}.path);    % pour chacune des souris 1=923 et 2=926

    figure
    % High Bulb
    % Wake
    subplot(2,3,1), hold on,
    plot(f_HB{1}{i},mean(10*(Data(Restrict(Spectrotsd_HB{1}{i},wake{1,i})))),'k','linewidth',2), ylabel('HPC')  % 1=Baseline 1
    plot(f_HB{3}{i},mean(10*(Data(Restrict(Spectrotsd_HB{3}{i},wake{3,i})))),'b','linewidth',2)                 % 3=Baseline 2
    plot(f_HB{2}{i},mean(10*(Data(Restrict(Spectrotsd_HB{2}{i},wake{2,i})))),'r','linewidth',2)                 % 2=Exposure
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('High OB Wake M',num2str(Dir{1}.nMice{i})))
    % SWS
    subplot(2,3,2), hold on, 
    plot(f_HB{1}{i},mean(10*(Data(Restrict(Spectrotsd_HB{1}{i},SWS{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_HB{3}{i},mean(10*(Data(Restrict(Spectrotsd_HB{3}{i},SWS{3,i})))),'b','linewidth',2)
    plot(f_HB{2}{i},mean(10*(Data(Restrict(Spectrotsd_HB{2}{i},SWS{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('High OB NREM M',num2str(Dir{1}.nMice{i})))
    % REM
    subplot(2,3,3), hold on, 
    plot(f_HB{1}{i},mean(10*(Data(Restrict(Spectrotsd_HB{1}{i},REM{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_HB{3}{i},mean(10*(Data(Restrict(Spectrotsd_HB{3}{i},REM{3,i})))),'b','linewidth',2)
    plot(f_HB{2}{i},mean(10*(Data(Restrict(Spectrotsd_HB{2}{i},REM{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('High OB REM M',num2str(Dir{1}.nMice{i})))
    % Low Bulb
    % Wake
    subplot(2,3,4), hold on, 
    plot(f_OB{1}{i},mean(10*(Data(Restrict(Spectrotsd_OB{1}{i},wake{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_OB{3}{i},mean(10*(Data(Restrict(Spectrotsd_OB{3}{i},wake{3,i})))),'b','linewidth',2)
    plot(f_OB{2}{i},mean(10*(Data(Restrict(Spectrotsd_OB{2}{i},wake{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('Low OB Wake M',num2str(Dir{1}.nMice{i})))
    % SWS
    subplot(2,3,5), hold on, 
    plot(f_OB{1}{i},mean(10*(Data(Restrict(Spectrotsd_OB{1}{i},SWS{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_OB{3}{i},mean(10*(Data(Restrict(Spectrotsd_OB{3}{i},SWS{3,i})))),'b','linewidth',2)
    plot(f_OB{2}{i},mean(10*(Data(Restrict(Spectrotsd_OB{2}{i},SWS{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('Low OB NREM M',num2str(Dir{1}.nMice{i})))
    % REM
    subplot(2,3,6), hold on, 
    plot(f_OB{1}{i},mean(10*(Data(Restrict(Spectrotsd_OB{1}{i},REM{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_OB{3}{i},mean(10*(Data(Restrict(Spectrotsd_OB{3}{i},REM{3,i})))),'b','linewidth',2)
    plot(f_OB{2}{i},mean(10*(Data(Restrict(Spectrotsd_OB{2}{i},REM{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('Low OB REM M',num2str(Dir{1}.nMice{i})))
    
    cd(DirFigure);
    figname=strcat('Analyse spectrale low et high OB M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname)) % enregistrement de la figure .fig
    
end


%% Section 3 : tracé des spectrogrammes low OB

axH{1}=[25,55];     % caxis pour la première souris 923 à déterminer pour optimiser l'affichage
axH{2}=[25,55];     % caxis pour las deuxième souris 926 à déterminer pour optimiser l'affichage

for i=1:length(Dir{1}.path)    % pour chacune des souris 1=923 et 2=926
    figure
    % Baseline 1
    subplot(3,1,1)
    imagesc(Spectro_OB{1}{i}{2},Spectro_OB{1}{i}{3},10*log10(Spectro_OB{1}{i}{1}')), axis xy
    title(strcat('Low OB spectrum Baseline 1 M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})  %lancer le premier subplot dans un premier temps pour déterminer le meilleur caxis
    % Exposure
    subplot(3,1,2)
    imagesc(Spectro_OB{2}{i}{2},Spectro_OB{2}{i}{3},10*log10(Spectro_OB{2}{i}{1})'), axis xy
    title(strcat('Low OB spectrum Exposure M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})
    % Baseline 2
    subplot(3,1,3)
    imagesc(Spectro_OB{3}{i}{2},Spectro_OB{3}{i}{3},10*log10(Spectro_OB{3}{i}{1})'), axis xy
    title(strcat('Low OB spectrum Baseline 2 M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})

    cd(DirFigure);
    figname=strcat('Spectre low OB M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname)) % enregistrement de la figure .fig
end
