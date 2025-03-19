%% input dir
% Dir{1} = PathForExperimentsAtropine_MC('Baseline');
% Dir{2} = PathForExperimentsAtropine_MC('Atropine');

%% get the data
a = 0;
for i=1:length(Dir)
    for j=1:length(Dir{i}.path)        
        cd(Dir{i}.path{j}{1});
        a=a+1;
        load SleepScoring_OBGamma REMEpoch SWSEpoch Wake
        REMEp{i,j}=REMEpoch;
        WakeEp{i,j}=Wake; 
        SWSEp{i,j}=SWSEpoch;
        load('Bulb_deep_Low_Spectrum.mat')
        fprintf('Loading OB low spectrum %d/%d...\n',[a,length(Dir)*length(Dir{1}.path)])
        SpectroB{i}{j}=Spectro;
        SpB=tsd(Spectro{2}*1E4,Spectro{1});
        fb=Spectro{3};
        load('H_Low_Spectrum.mat')
        fprintf('Loading HPC Low spectrum %d/%d...\n',[a,length(Dir)*length(Dir{1}.path)])
        SpectroH{i}{j}=Spectro;
        SpH=tsd(Spectro{2}*1E4,Spectro{1});
        fh=Spectro{3};
        load('PFCx_deep_Low_Spectrum.mat')
        fprintf('Loading PFC deep Low spectrum %d/%d...\n',[a,length(Dir)*length(Dir{1}.path)])
        SpectroP{i}{j}=Spectro;
        SpP=tsd(Spectro{2}*1E4,Spectro{1});
        fp=Spectro{3};
    
        SpHt{i}{j}=SpH;
        SpBt{i}{j}=SpB;
        SpPt{i}{j}=SpP;
        fbt{i}{j}=fb;
        fht{i}{j}=fh;
        fpt{i}{j}=fp;
    end
end

%% Low HPC
axH{1}=[25,55]; % M923
axH{2}=[30,58]; % M926
axH{3}=[30,50]; % M927
axH{4}=[30,53]; % M928

for i=1:length(Dir{1}.path)
    figure
    %Baseline
    subplot(2,1,1)
    imagesc(SpectroH{1}{i}{2},SpectroH{1}{i}{3},10*log10(SpectroH{1}{i}{1}')), axis xy
    title(strcat('Low HPC spectrum Baseline M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})
    % Atropine
    subplot(2,1,2)
    imagesc(SpectroH{2}{i}{2},SpectroH{2}{i}{3},10*log10(SpectroH{2}{i}{1})'), axis xy
    title(strcat('Low HPC spectrum Atropine M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axH{i})
end


%% low OB
axB{1}=[15,50]; 
axB{2}=[12,48]; 
axB{3}=[12,48];
axB{4}=[12,48]; 

for i=1:length(Dir{1}.path)
    figure
    %Baseline
    subplot(2,1,1)
    imagesc(SpectroB{1}{i}{2},SpectroB{1}{i}{3},10*log10(SpectroB{1}{i}{1}')), axis xy
    title(strcat('Low OB spectrum Baseline M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axB{i})
    % Atropine
    subplot(2,1,2)
    imagesc(SpectroB{2}{i}{2},SpectroB{2}{i}{3},10*log10(SpectroB{2}{i}{1})'), axis xy
    title(strcat('Low OB spectrum Atropine M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axB{i})
end


%% PFC deep
axB{1}=[15,50]; 
axB{2}=[12,48]; 
axB{3}=[12,48]; 
axB{4}=[12,48]; 

for i=1:length(Dir{1}.path)
    figure
    %Baseline
    subplot(2,1,1)
    imagesc(SpectroP{1}{i}{2},SpectroP{1}{i}{3},10*log10(SpectroP{1}{i}{1}')), axis xy
    title(strcat('PFC spectrum Baseline M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axB{i})
    % Atropine
    subplot(2,1,2)
    imagesc(SpectroP{2}{i}{2},SpectroP{2}{i}{3},10*log10(SpectroP{2}{i}{1})'), axis xy
    title(strcat('PFC spectrum Atropine M',num2str(Dir{1}.nMice{i})))
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    caxis(axB{i})
end