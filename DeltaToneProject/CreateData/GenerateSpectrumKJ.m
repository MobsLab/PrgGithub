%% GenerateSpectrumKJ


Dir=PathForExperimentsBasalSleepSpike;

for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p

    foldername=pwd;
    if foldername(end)~=filesep
        foldername(end+1)=filesep;
    end

    % OB
    if exist('ChannelsToAnalyse/Bulb_deep.mat','file')==2
        load('ChannelsToAnalyse/Bulb_deep.mat')
        channel_bulb=channel;
    else
        error('No OB channel, cannot do sleep scoring');
    end

    % HPC
    if exist('ChannelsToAnalyse/dHPC_deep.mat','file')==2
        load('ChannelsToAnalyse/dHPC_deep.mat')
        channel_hpc=channel;
    elseif exist('ChannelsToAnalyse/dHPC_rip.mat','file')==2
        load('ChannelsToAnalyse/dHPC_rip.mat')
        channel_hpc=channel;
    else
        error('No HPC channel, cannot do sleep scoring');
    end



    % Calculate spectra if they don't alread exist
    if ~(exist('H_Low_Spectrum.mat', 'file') == 2)
        LowSpectrumSB(foldername,channel_hpc,'H');
    end
    if ~(exist('B_High_Spectrum.mat', 'file') == 2)
        HighSpectrum(foldername,channel_bulb,'B');
    end
    
end

