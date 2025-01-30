%% Create spectros

if exist('B_Low_Spectrum.mat')==0
    disp('calculating OB')
    clear channel
    load('ChannelsToAnalyse/Bulb_deep.mat')
    channel;
    LowSpectrumSB([cd filesep],channel,'B')
end

if exist('B_High_Spectrum.mat')==0
    disp('calculating OBhigh')
    clear channel
    try
        load('ChannelsToAnalyse/Bulb_gamma.mat')
    catch
        load('ChannelsToAnalyse/Bulb_deep.mat')
    end
    channel;
    HighSpectrum([cd filesep],channel,'B');
end

if exist('H_Low_Spectrum.mat')==0
    disp('calculating H')
    clear channel
    try,load('ChannelsToAnalyse/dHPC_rip.mat'), catch,
        try,load('ChannelsToAnalyse/dHPC_deep.mat'),
        catch
            try,load('ChannelsToAnalyse/dHPC_sup.mat'),
            end
        end
    end
    channel;
    LowSpectrumSB([cd filesep],channel,'H')
end

if exist('H_VHigh_Spectrum.mat')==0
    disp('calculating H_high')
    clear channel
    try,load('ChannelsToAnalyse/dHPC_rip.mat'), catch,
        try,load('ChannelsToAnalyse/dHPC_sup.mat'),
        catch
            try,load('ChannelsToAnalyse/dHPC_deep.mat'),
            end
        end
    end
    channel;
    VeryHighSpectrum([cd filesep],channel,'H')
end

if exist('PFCx_Low_Spectrum.mat')==0
    disp('calculating PFC')
    clear channel
    load('ChannelsToAnalyse/PFCx_deep.mat')
    channel;
    LowSpectrumSB([cd filesep],channel,'PFCx')
end

clear channel

%% Create ripples

clear all;

load('ExpeInfo.mat');

if ExpeInfo.SleepSession==1
    CreateRipplesSleep('scoring','accelero','stim',0,'restrict',1,'sleep',1)
else
    CreateRipplesSleep('scoring','accelero','stim',0,'restrict',1,'sleep',0)
end

               