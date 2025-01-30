%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /home/mobschapeau/Dropbox/Kteam/PrgMatlab/Thierry/Alice/box_rat_72h/ParcoursComputePFCSupDeepAndOBspectrum.m

% Ce script permet de tracer 8 figures pour l'expérience Box Rat 72h
% L'expérience Box Rat 72h comprend 3 conditions : Baseline 1, Eposure et
% Baseline 2
% Et elle a été réalisée pour 2 souris : M923 et M926

% Le sctrip est composé de  sections :
%   * Section 1 : 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Calcul des 5 spectres pour chacun des enregistrements

Dir{1}=PathForExperiments_TG('box_rat_72h_Baseline1');
Dir{2}=PathForExperiments_TG('box_rat_72h_Exposure');
Dir{3}=PathForExperiments_TG('box_rat_72h_Baseline2');
DirFigure='/media/nas5/Thierry_DATA/Rat_box_72h/Figures/';


for i=1:length(Dir) % baseline 1 ou baseline 2 ou exp
    for j=1:length(Dir{i}.path)        
        cd(Dir{i}.path{j}{1});
        if exist('ChannelsToAnalyse/PFCx_deep.mat','file')==2
            load('ChannelsToAnalyse/PFCx_deep.mat')
            channel_PFC_deep=channel;
            load('ChannelsToAnalyse/PFCx_sup.mat')
            channel_PFC_sup=channel;
            load('ChannelsToAnalyse/Bulb_deep.mat')
            channel_Bulb=channel;
        else
            error('No PFC deep channel, cannot calculate spectrogram');
        end

        foldername=pwd;
        if foldername(end)~=filesep
            foldername(end+1)=filesep;
        end
    
% PFC Deep High
        if ~(exist('PFC_deep_High_Spectrum.mat', 'file') == 2)
            fprintf('Calculting PFC deep High spectrum %d/%d\n',[i,length(path)])
            HighSpectrum(foldername,channel_PFC_deep,'PFC_deep');
        else
            disp('PFC deep High spectrum already calculated')
        end
% PFC Deep Low    
        if ~(exist('PFC_deep_Low_Spectrum.mat', 'file') == 2)
            fprintf('Calculting PFC deep Low spectrum %d/%d\n',[i,length(path)])
            LowSpectrumSB(foldername,channel_PFC_deep,'PFC_deep');
        else
            disp('PFC deep Low spectrum already calculated')
        end
% PFC Sup High    
        if ~(exist('PFC_sup_High_Spectrum.mat', 'file') == 2)
            fprintf('Calculting PFC sup High spectrum %d/%d\n',[i,length(path)])
            HighSpectrum(foldername,channel_PFC_sup,'PFC_sup');
        elseplot(f_LH_Exposure{1},mean(Data(Restrict(Spectrotsd_LH_Exposure(1),REMEpoch_Exposure(1)))),'r')
            disp('PFC sup Low spectrum already calculated')
        end
% PFC Sup Low    
        if ~(exist('PFC_sup_Low_Spectrum.mat', 'file') == 2)
            fprintf('Calculting PFC sup Low spectrum %d/%d\n',[i,length(path)])
            LowSpectrumSB(foldername,channel_PFC_sup,'PFC_sup');
        else
            disp('PFC sup Low spectrum already calculated')
        end   
% Bulb low
        if ~(exist('B_Low_Spectrum.mat', 'file') == 2)
            fprintf('Calculting Bulb Low spectrum %d/%d\n',[i,length(path)])
            LowSpectrumSB(foldername,channel_Bulb,'B');
        else
            disp('Bulb Low spectrum already calculated')
        end  
    end
    
end

%% Chargement des données

Dir{1}=PathForExperiments_TG('box_rat_72h_Baseline1');
Dir{2}=PathForExperiments_TG('box_rat_72h_Exposure');
Dir{3}=PathForExperiments_TG('box_rat_72h_Baseline2');
DirFigure='/media/nas5/Thierry_DATA/Rat_box_72h/Figures/';
a=0;

for i=1:length(Dir) % baseline 1 ou baseline 2 ou exp
    for j=1:length(Dir{i}.path)        
        cd(Dir{i}.path{j}{1});
        a=a+1;
        load SleepScoring_OBGamma REMEpoch SWSEpoch Wake
        REM{i,j}=REMEpoch;
        wake{i,j}=Wake; 
        SWS{i,j}=SWSEpoch;
%PFC deep high
        fprintf('Loading PFC deep High spectrum Baseline 1 %d/%d...\n',[a,length(Dir)*length(Dir{1}.path)])
        load('PFC_deep_High_Spectrum.mat')
        Spectro_HPFC_deep{i}{j}=Spectro;
        Spectrotsd_HPFC_deep{i}{j}=tsd(Spectro{2}*1E4,Spectro{1});
        f_HPFC_deep{i}{j}=Spectro{3};
% %PFC deep low
         fprintf('Loading PFC deep Low spectrum Baseline 1 %d/%d...\n',[a,length(Dir)*length(Dir{1}.path)])
         load('PFC_deep_Low_Spectrum.mat')
         Spectro_LPFC_deep{i}{j}=Spectro;
         Spectrotsd_LPFC_deep{i}{j}=tsd(Spectro{2}*1E4,Spectro{1});
         f_LPFC_deep{i}{j}=Spectro{3};
% %PFC sup high
        fprintf('Loading PFC sup High spectrum Baseline 1 %d/%d...\n',[a,length(Dir)*length(Dir{1}.path)])
        load('PFC_sup_High_Spectrum.mat')
        Spectro_HPFC_sup{i}{j}=Spectro;
        Spectrotsd_HPFC_sup{i}{j}=tsd(Spectro{2}*1E4,Spectro{1});
        f_HPFC_sup{i}{j}=Spectro{3};
% %PFC sup low
        fprintf('Loading PFC sup Low spectrum Baseline 1 %d/%d...\n',[a,length(Dir)*length(Dir{1}.path)])
        load('PFC_sup_Low_Spectrum.mat')
        Spectro_LPFC_sup{i}{j}=Spectro;
        Spectrotsd_LPFC_sup{i}{j}=tsd(Spectro{2}*1E4,Spectro{1});
        f_LPFC_sup{i}{j}=Spectro{3};
% %Bulb low
        fprintf('Loading OB low spectrum Baseline 1 %d/%d...\n',[a,length(Dir)*length(Dir{1}.path)])
        load('B_Low_Spectrum.mat')
        Spectro_LB{i}{j}=Spectro;
        Spectrotsd_LB{i}{j}=tsd(Spectro{2}*1E4,Spectro{1});
        f_LB{i}{j}=Spectro{3};        
% %Bulb High
        fprintf('Loading OB high spectrum Baseline 1 %d/%d...\n',[a,length(Dir)*length(Dir{1}.path)])
        load('B_High_Spectrum.mat')
        Spectro_HB{i}{j}=Spectro;
        Spectrotsd_HB{i}{j}=tsd(Spectro{2}*1E4,Spectro{1});
        f_HB{i}{j}=Spectro{3};
    end
end

%% Calcul des spectrogrammes PFC sup

for i=1:length(Dir{1}.path);

    figure
    subplot(2,3,1), hold on, 
    plot(f_HPFC_sup{1}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{1}{i},wake{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_HPFC_sup{3}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{3}{i},wake{3,i})))),'b','linewidth',2)
    plot(f_HPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{2}{i},wake{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('High PFC sup Wake M',num2str(Dir{1}.nMice{i})))

    subplot(2,3,2), hold on, 
    plot(f_HPFC_sup{1}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{1}{i},SWS{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_HPFC_sup{3}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{3}{i},SWS{3,i})))),'b','linewidth',2)
    plot(f_HPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{2}{i},SWS{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('High PFC sup NREM M',num2str(Dir{1}.nMice{i})))

    subplot(2,3,3), hold on, 
    plot(f_HPFC_sup{1}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{1}{i},REM{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_HPFC_sup{3}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{3}{i},REM{3,i})))),'b','linewidth',2)
    plot(f_HPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_sup{2}{i},REM{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('High PFC sup REM M',num2str(Dir{1}.nMice{i})))

    subplot(2,3,4), hold on, length(Dir{i}.path)
    plot(f_LPFC_sup{1}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{1}{i},wake{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_LPFC_sup{3}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{3}{i},wake{3,i})))),'b','linewidth',2)
    plot(f_LPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{2}{i},wake{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('Low PFC sup Wake M',num2str(Dir{1}.nMice{i})))

    subplot(2,3,5), hold on, 
    plot(f_LPFC_sup{1}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{1}{i},SWS{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_LPFC_sup{3}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{3}{i},SWS{3,i})))),'b','linewidth',2)
    plot(f_LPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{2}{i},SWS{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('Low PFC sup NREM M',num2str(Dir{1}.nMice{i})))

    subplot(2,3,6), hold on, 
    plot(f_LPFC_sup{1}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{1}{i},REM{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_LPFC_sup{3}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{3}{i},REM{3,i})))),'b','linewidth',2)
    plot(f_LPFC_sup{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_sup{2}{i},REM{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('Low PFC sup REM M',num2str(Dir{1}.nMice{i})))
  
    cd(DirFigure);
    figname=strcat('Analyse spectrale PFC sup M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname))
    
end

%% Calcul des spectrogrammes PFC deep

for i=1:length(Dir{1}.path);

    figure
    subplot(2,3,1), hold on, 
    plot(f_HPFC_deep{1}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{1}{i},wake{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_HPFC_deep{3}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{3}{i},wake{3,i})))),'b','linewidth',2)
    plot(f_HPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{2}{i},wake{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('High PFC deep Wake M',num2str(Dir{1}.nMice{i})))

    subplot(2,3,2), hold on, 
    plot(f_HPFC_deep{1}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{1}{i},SWS{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_HPFC_deep{3}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{3}{i},SWS{3,i})))),'b','linewidth',2)
    plot(f_HPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{2}{i},SWS{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('High PFC deep NREM M',num2str(Dir{1}.nMice{i})))

    subplot(2,3,3), hold on, 
    plot(f_HPFC_deep{1}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{1}{i},REM{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_HPFC_deep{3}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{3}{i},REM{3,i})))),'b','linewidth',2)
    plot(f_HPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_HPFC_deep{2}{i},REM{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('High PFC deep REM M',num2str(Dir{1}.nMice{i})))

    subplot(2,3,4), hold on, length(Dir{i}.path)
    plot(f_LPFC_deep{1}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{1}{i},wake{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_LPFC_deep{3}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{3}{i},wake{3,i})))),'b','linewidth',2)
    plot(f_LPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{2}{i},wake{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('Low PFC deep Wake M',num2str(Dir{1}.nMice{i})))

    subplot(2,3,5), hold on, 
    plot(f_LPFC_deep{1}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{1}{i},SWS{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_LPFC_deep{3}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{3}{i},SWS{3,i})))),'b','linewidth',2)
    plot(f_LPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{2}{i},SWS{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('Low PFC deep NREM M',num2str(Dir{1}.nMice{i})))

    subplot(2,3,6), hold on, 
    plot(f_LPFC_deep{1}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{1}{i},REM{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_LPFC_deep{3}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{3}{i},REM{3,i})))),'b','linewidth',2)
    plot(f_LPFC_deep{2}{i},mean(10*(Data(Restrict(Spectrotsd_LPFC_deep{2}{i},REM{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('Low PFC deep REM M',num2str(Dir{1}.nMice{i})))
  
    cd(DirFigure);
    figname=strcat('Analyse spectrale PFC deep M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname))
    
end

%% Calcul des spectrogrammes low OB

for i=1:length(Dir{1}.path);

    figure
    subplot(2,3,1), hold on, 
    plot(f_HB{1}{i},mean(10*(Data(Restrict(Spectrotsd_HB{1}{i},wake{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_HB{3}{i},mean(10*(Data(Restrict(Spectrotsd_HB{3}{i},wake{3,i})))),'b','linewidth',2)
    plot(f_HB{2}{i},mean(10*(Data(Restrict(Spectrotsd_HB{2}{i},wake{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('High OB Wake M',num2str(Dir{1}.nMice{i})))

    subplot(2,3,2), hold on, 
    plot(f_HB{1}{i},mean(10*(Data(Restrict(Spectrotsd_HB{1}{i},SWS{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_HB{3}{i},mean(10*(Data(Restrict(Spectrotsd_HB{3}{i},SWS{3,i})))),'b','linewidth',2)
    plot(f_HB{2}{i},mean(10*(Data(Restrict(Spectrotsd_HB{2}{i},SWS{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('High OB NREM M',num2str(Dir{1}.nMice{i})))

    subplot(2,3,3), hold on, 
    plot(f_HB{1}{i},mean(10*(Data(Restrict(Spectrotsd_HB{1}{i},REM{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_HB{3}{i},mean(10*(Data(Restrict(Spectrotsd_HB{3}{i},REM{3,i})))),'b','linewidth',2)
    plot(f_HB{2}{i},mean(10*(Data(Restrict(Spectrotsd_HB{2}{i},REM{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('High OB REM M',num2str(Dir{1}.nMice{i})))
    
    subplot(2,3,4), hold on, 
    plot(f_LB{1}{i},mean(10*(Data(Restrict(Spectrotsd_LB{1}{i},wake{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_LB{3}{i},mean(10*(Data(Restrict(Spectrotsd_LB{3}{i},wake{3,i})))),'b','linewidth',2)
    plot(f_LB{2}{i},mean(10*(Data(Restrict(Spectrotsd_LB{2}{i},wake{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('Low OB Wake M',num2str(Dir{1}.nMice{i})))

    subplot(2,3,5), hold on, 
    plot(f_LB{1}{i},mean(10*(Data(Restrict(Spectrotsd_LB{1}{i},SWS{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_LB{3}{i},mean(10*(Data(Restrict(Spectrotsd_LB{3}{i},SWS{3,i})))),'b','linewidth',2)
    plot(f_LB{2}{i},mean(10*(Data(Restrict(Spectrotsd_LB{2}{i},SWS{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('Low OB NREM M',num2str(Dir{1}.nMice{i})))

    subplot(2,3,6), hold on, 
    plot(f_LB{1}{i},mean(10*(Data(Restrict(Spectrotsd_LB{1}{i},REM{1,i})))),'k','linewidth',2), ylabel('HPC')
    plot(f_LB{3}{i},mean(10*(Data(Restrict(Spectrotsd_LB{3}{i},REM{3,i})))),'b','linewidth',2)
    plot(f_LB{2}{i},mean(10*(Data(Restrict(Spectrotsd_LB{2}{i},REM{2,i})))),'r','linewidth',2)
    legend('Baseline 1', 'Baseline 2', 'Exposure')
    xlabel('Frequency')
    title(strcat('Low OB REM M',num2str(Dir{1}.nMice{i})))
    
    cd(DirFigure);
    figname=strcat('Analyse spectrale low et high OB M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname))
    
end