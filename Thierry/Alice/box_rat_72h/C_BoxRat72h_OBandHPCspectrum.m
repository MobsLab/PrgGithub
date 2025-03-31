%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /home/mobschapeau/Dropbox/Kteam/PrgMatlab/Thierry/Alice/box_rat_72h/ParcoursComputeOBandHPCspectrum.m

% Ce script permet de tracer 8 figures pour l'expérience Box Rat 72h
% L'expérience Box Rat 72h comprend 3 conditions : Baseline 1, Eposure et
% Baseline 2
% Et elle a été réalisée pour 2 souris : M923 et M926

% Le sctrip est composé de 3 sections :
%   * Section 1 : chargement des données
%   * Section 2 : tracé des analyses spectrales avec les deux sleepscoring
%   différents pour chacune des deux souris (4 figures)
%   * Section 3 : tracé des spectrogrammes low HPC et high OB pour chacune des
%   deux souris (4 figures)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Section 1 : Chargement des données
a=0
Dir{1}=PathForExperiments_TG('box_rat_72h_Baseline1');
Dir{2}=PathForExperiments_TG('box_rat_72h_Exposure');
Dir{3}=PathForExperiments_TG('box_rat_72h_Baseline2');
DirFigure='/media/nas5/Thierry_DATA/Figures/Rat_box_72h/Figures/';  % dossier où seront enregistrées les figures .fig


for i=1:length(Dir) % baseline 1 ou baseline 2 ou exp
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
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('HPC Wake SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
    % HPC SWS
    subplot(2,3,2), hold on, 
    plot(fht{1}{i},mean(10*(Data(Restrict(SpHt{1}{i},SWSob{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(fht{3}{i},mean(10*(Data(Restrict(SpHt{3}{i},SWSob{3,i})))),'b','linewidth',2)
    plot(fht{2}{i},mean(10*(Data(Restrict(SpHt{2}{i},SWSob{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('HPC NREM SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
    %HPC REM
    subplot(2,3,3), hold on, 
    plot(fht{1}{i},mean(10*(Data(Restrict(SpHt{1}{i},REMob{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(fht{3}{i},mean(10*(Data(Restrict(SpHt{3}{i},REMob{3,i})))),'b','linewidth',2)
    plot(fht{2}{i},mean(10*(Data(Restrict(SpHt{2}{i},REMob{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('HPC REM SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
    %OB Wake
    subplot(2,3,4), hold on, length(Dir{i}.path)
    plot(fbt{1}{i},mean(10*(Data(Restrict(SpBt{1}{i},Wakeob{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(fbt{3}{i},mean(10*(Data(Restrict(SpBt{3}{i},Wakeob{3,i})))),'b','linewidth',2)
    plot(fbt{2}{i},mean(10*(Data(Restrict(SpBt{2}{i},Wakeob{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('OB Wake SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
    %OB SWS
    subplot(2,3,5), hold on, 
    plot(fbt{1}{i},mean(10*(Data(Restrict(SpBt{1}{i},SWSob{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(fbt{3}{i},mean(10*(Data(Restrict(SpBt{3}{i},SWSob{3,i})))),'b','linewidth',2)
    plot(fbt{2}{i},mean(10*(Data(Restrict(SpBt{2}{i},SWSob{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('OB NREM SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
    %OB REM
    subplot(2,3,6), hold on, 
    plot(fbt{1}{i},mean(10*(Data(Restrict(SpBt{1}{i},REMob{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(fbt{3}{i},mean(10*(Data(Restrict(SpBt{3}{i},REMob{3,i})))),'b','linewidth',2)
    plot(fbt{2}{i},mean(10*(Data(Restrict(SpBt{2}{i},REMob{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('OB REM SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
    
    cd(DirFigure);
    figname=strcat('Analyse spectrale SleepScoring OB gamma M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname))

end


% Avec le sleep scoring accelero
for i=1:length(Dir{1}.path)
    figure
    subplot(2,3,1), hold on, 
    plot(fht{1}{i},mean(10*(Data(Restrict(SpHt{1}{i},WakeAcc{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(fht{3}{i},mean(10*(Data(Restrict(SpHt{3}{i},WakeAcc{3,i})))),'b','linewidth',2)
    plot(fht{2}{i},mean(10*(Data(Restrict(SpHt{2}{i},WakeAcc{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('HPC Wake SleepScoring Accelero M',num2str(Dir{1}.nMice{i})))

    subplot(2,3,2), hold on, 
    plot(fht{1}{i},mean(10*(Data(Restrict(SpHt{1}{i},SWSAcc{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(fht{3}{i},mean(10*(Data(Restrict(SpHt{3}{i},SWSAcc{3,i})))),'b','linewidth',2)
    plot(fht{2}{i},mean(10*(Data(Restrict(SpHt{2}{i},SWSAcc{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('HPC NREM SleepScoring Accelero M',num2str(Dir{1}.nMice{i})))

    subplot(2,3,3), hold on, 
    plot(fht{1}{i},mean(10*(Data(Restrict(SpHt{1}{i},REMAcc{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(fht{3}{i},mean(10*(Data(Restrict(SpHt{3}{i},REMAcc{3,i})))),'b','linewidth',2)
    plot(fht{2}{i},mean(10*(Data(Restrict(SpHt{2}{i},REMAcc{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('HPC REM SleepScoring Accelero M',num2str(Dir{1}.nMice{i})))

    subplot(2,3,4), hold on, 
    plot(fbt{1}{i},mean(10*(Data(Restrict(SpBt{1}{i},WakeAcc{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(fbt{3}{i},mean(10*(Data(Restrict(SpBt{3}{i},WakeAcc{3,i})))),'b','linewidth',2)
    plot(fbt{2}{i},mean(10*(Data(Restrict(SpBt{2}{i},WakeAcc{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('OB Wake SleepScoring Accelero M',num2str(Dir{1}.nMice{i})))

    subplot(2,3,5), hold on, 
    plot(fbt{1}{i},mean(10*(Data(Restrict(SpBt{1}{i},SWSAcc{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(fbt{3}{i},mean(10*(Data(Restrict(SpBt{3}{i},SWSAcc{3,i})))),'b','linewidth',2)
    plot(fbt{2}{i},mean(10*(Data(Restrict(SpBt{2}{i},SWSAcc{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('OB NREM SleepScoring Accelero M',num2str(Dir{1}.nMice{i})))

    subplot(2,3,6), hold on, 
    plot(fbt{1}{i},mean(10*(Data(Restrict(SpBt{1}{i},REMAcc{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(fbt{3}{i},mean(10*(Data(Restrict(SpBt{3}{i},REMAcc{3,i})))),'b','linewidth',2)
    plot(fbt{2}{i},mean(10*(Data(Restrict(SpBt{2}{i},REMAcc{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('OB REM SleepScoring Accelero M',num2str(Dir{1}.nMice{i})))
    
    cd(DirFigure);
    figname=strcat('Analyse spectrale SleepScoring Accelero M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname))

end


%% Section 3 : Tracé des spectrogrammes

% Low HPC
axH{1}=[25,55]; % M923
axH{2}=[25,55]; % M926

for i=1:length(Dir{1}.path)
    figure
    %Baseline 1
    subplot(3,1,1)
    imagesc(SpectroH{1}{i}{2},SpectroH{1}{i}{3},10*log10(SpectroH{1}{i}{1}')), axis xy
    title(strcat('Low HPC spectrum Baseline 1 M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})  %lancer le premier subplot dans un premier temps pour déterminer le meilleur caxis
    % Exposure
    subplot(3,1,2)
    imagesc(SpectroH{2}{i}{2},SpectroH{2}{i}{3},10*log10(SpectroH{2}{i}{1})'), axis xy
    title(strcat('Low HPC spectrum Exposure M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})
    % Baseline 2
    subplot(3,1,3)
    imagesc(SpectroH{3}{i}{2},SpectroH{3}{i}{3},10*log10(SpectroH{3}{i}{1})'), axis xy
    title(strcat('Low HPC spectrum Baseline 2 M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})

    cd(DirFigure);
    figname=strcat('Spectre low HPC M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname))
end

% High OB
axB{1}=[0,50];  % M923
axB{2}=[12,44]; % M926
for i=1:length(Dir{1}.path)
    figure
    %Baseline 1
    subplot(3,1,1)
    imagesc(SpectroB{1}{i}{2},SpectroB{1}{i}{3},10*log10(SpectroB{1}{i}{1}')), axis xy
    title(strcat('High OB spectrum Baseline 1 M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axB{i})  %lancer le premier subplot dans un premier temps pour déterminer le meilleur caxis
    % Exposure
    subplot(3,1,2)
    imagesc(SpectroB{2}{i}{2},SpectroB{2}{i}{3},10*log10(SpectroB{2}{i}{1})'), axis xy
    title(strcat('High OB spectrum Exposure M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axB{i})
    % Baseline 2
    subplot(3,1,3)
    imagesc(SpectroB{3}{i}{2},SpectroB{3}{i}{3},10*log10(SpectroB{3}{i}{1})'), axis xy
    title(strcat('High OB spectrum Baseline 2 M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axB{i})

    cd(DirFigure);
    figname=strcat('Spectre High OB M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname))
end


 %% Tracé des analyses spectrales moyennes
% 
% for i=1:length(Dir) % i=Condition : baseline 1 ou baseline 2 ou exp
%     SpHt_wake_moy{i}=zeros(length(Data(Restrict(SpHt{i}{1},Wakeob{i,1}))),1);
%     SpHt_wake_min{i}=zeros(length(Data(Restrict(SpHt{i}{1},Wakeob{i,1}))),1);
%     SpHt_wake_max{i}=zeros(length(Data(Restrict(SpHt{i}{1},Wakeob{i,1}))),1);
%     SpHt_SWS_moy{i}=zeros(length(Data(Restrict(SpHt{i}{1},SWSob{i,1}))),1);
%     SpHt_SWS_min{i}=zeros(length(Data(Restrict(SpHt{i}{1},SWSob{i,1}))),1);
%     SpHt_SWS_max{i}=zeros(length(Data(Restrict(SpHt{i}{1},SWSob{i,1}))),1);
%     SpHt_REM_moy{i}=zeros(length(Data(Restrict(SpHt{i}{1},REMob{i,1}))),1);
%     SpHt_REM_min{i}=zeros(length(Data(Restrict(SpHt{i}{1},REMob{i,1}))),1);
%     SpHt_REM_max{i}=zeros(length(Data(Restrict(SpHt{i}{1},REMob{i,1}))),1);
%     for j=1:length(Dir{i}.path)     % j=numéro de la souris : 923 ou 926
%         SpHt_wake_moy{i}=SpHt_wake_moy{i}+Data(Restrict(SpHt{i}{j},Wakeob{i,j}));
%         SpHt_SWS_moy{i}=SpHt_SWS_moy{i}+Data(Restrict(SpHt{i}{j},SWSob{i,j}));
%         SpHt_REM_moy{i}=SpHt_REM_moy{i}+Data(Restrict(SpHt{i}{j},REMob{i,j}));
%         if j==1
%             SpHt_wake_min{i}=Data(Restrict(SpHt{i}{j},Wakeob{i,j}));
%             SpHt_wake_max{i}=Data(Restrict(SpHt{i}{j},Wakeob{i,j}));
%             SpHt_SWS_min{i}=Data(Restrict(SpHt{i}{j},SWSob{i,j}));
%             SpHt_SWS_max{i}=Data(Restrict(SpHt{i}{j},SWSob{i,j}));
%             SpHt_REM_min{i}=Data(Restrict(SpHt{i}{j},REMob{i,j}));
%             SpHt_REM_max{i}=Data(Restrict(SpHt{i}{j},REMob{i,j}));
%         else
%             SpHt_wake_min{i}=min(SpHt_wake_min{i},Data(Restrict(SpHt{i}{j},Wakeob{i,j})));
%             SpHt_wake_max{i}=max(SpHt_wake_min{i},Data(Restrict(SpHt{i}{j},Wakeob{i,j})));
%             SpHt_SWS_min{i}=min(SpHt_SWS_min{i},Data(Restrict(SpHt{i}{j},SWSob{i,j})));
%             SpHt_SWS_max{i}=max(SpHt_SWS_min{i},Data(Restrict(SpHt{i}{j},SWSob{i,j})));
%             SpHt_REM_min{i}=min(SpHt_REM_min{i},Data(Restrict(SpHt{i}{j},REMob{i,j})));
%             SpHt_REM_max{i}=max(SpHt_REM_min{i},Data(Restrict(SpHt{i}{j},REMob{i,j})));
%         end
%     end
%     SpHt_wake_moy{i}=SpHt_wake_moy{i}./length(Dir{i}.path);
%     SpHt_SWS_moy{i}=SpHt_SWS_moy{i}./length(Dir{i}.path);
%     SpHt_REM_moy{i}=SpHt_REM_moy{i}./length(Dir{i}.path);
% end
% 
%     figure
%     % HPC wake
%     subplot(2,3,1), hold on, 
%     errorbar(fht{1}{i},mean(10*(Restrict(SpHt_moy{1},Wakeob{1,i}))),SpHt_min{1},SpHt_max{1},'k'), ylabel('HPC')
%     plot(fht{3}{i},mean(10*(Data(Restrict(SpHt{3}{i},Wakeob{3,i})))),'b','linewidth',2)
%     plot(fht{2}{i},mean(10*(Data(Restrict(SpHt{2}{i},Wakeob{2,i})))),'r','linewidth',2)
%     legend('Baseline 1', 'Baseline 2', 'Exposure')
%     xlabel('Frequency')
%     title(strcat('HPC Wake SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
%     % HPC SWS
%     subplot(2,3,2), hold on, 
%     plot(fht{1}{i},mean(10*(Data(Restrict(SpHt{1}{i},SWSob{1,i})))),'k','linewidth',2), ylabel('HPC')
%     plot(fht{3}{i},mean(10*(Data(Restrict(SpHt{3}{i},SWSob{3,i})))),'b','linewidth',2)
%     plot(fht{2}{i},mean(10*(Data(Restrict(SpHt{2}{i},SWSob{2,i})))),'r','linewidth',2)
%     legend('Baseline 1', 'Baseline 2', 'Exposure')
%     xlabel('Frequency')
%     title(strcat('HPC NREM SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
%     %HPC REM
%     subplot(2,3,3), hold on, 
%     plot(fht{1}{i},mean(10*(Data(Restrict(SpHt{1}{i},REMob{1,i})))),'k','linewidth',2), ylabel('HPC')
%     plot(fht{3}{i},mean(10*(Data(Restrict(SpHt{3}{i},REMob{3,i})))),'b','linewidth',2)
%     plot(fht{2}{i},mean(10*(Data(Restrict(SpHt{2}{i},REMob{2,i})))),'r','linewidth',2)
%     legend('Baseline 1', 'Baseline 2', 'Exposure')
%     xlabel('Frequency')
%     title(strcat('HPC REM SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
%     %OB Wake
%     subplot(2,3,4), hold on, length(Dir{i}.path)
%     plot(fbt{1}{i},mean(10*(Data(Restrict(SpBt{1}{i},Wakeob{1,i})))),'k','linewidth',2), ylabel('HPC')
%     plot(fbt{3}{i},mean(10*(Data(Restrict(SpBt{3}{i},Wakeob{3,i})))),'b','linewidth',2)
%     plot(fbt{2}{i},mean(10*(Data(Restrict(SpBt{2}{i},Wakeob{2,i})))),'r','linewidth',2)
%     legend('Baseline 1', 'Baseline 2', 'Exposure')
%     xlabel('Frequency')
%     title(strcat('OB Wake SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
%     %OB SWS
%     subplot(2,3,5), hold on, 
%     plot(fbt{1}{i},mean(10*(Data(Restrict(SpBt{1}{i},SWSob{1,i})))),'k','linewidth',2), ylabel('HPC')
%     plot(fbt{3}{i},mean(10*(Data(Restrict(SpBt{3}{i},SWSob{3,i})))),'b','linewidth',2)
%     plot(fbt{2}{i},mean(10*(Data(Restrict(SpBt{2}{i},SWSob{2,i})))),'r','linewidth',2)
%     legend('Baseline 1', 'Baseline 2', 'Exposure')
%     xlabel('Frequency')
%     title(strcat('OB NREM SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))
%     %OB REM
%     subplot(2,3,6), hold on, 
%     plot(fbt{1}{i},mean(10*(Data(Restrict(SpBt{1}{i},REMob{1,i})))),'k','linewidth',2), ylabel('HPC')
%     plot(fbt{3}{i},mean(10*(Data(Restrict(SpBt{3}{i},REMob{3,i})))),'b','linewidth',2)
%     plot(fbt{2}{i},mean(10*(Data(Restrict(SpBt{2}{i},REMob{2,i})))),'r','linewidth',2)
%     legend('Baseline 1', 'Baseline 2', 'Exposure')
%     xlabel('Frequency')
%     title(strcat('OB REM SleepScoring OB gamma M',num2str(Dir{1}.nMice{i})))