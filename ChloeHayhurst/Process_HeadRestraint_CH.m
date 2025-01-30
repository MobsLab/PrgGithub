
clear all; close all;

HeadRestraintSess_BM

MouseToDo = 1534; % Change this to process the mouse you want

if MouseToDo == 1476
    m = 8
else if MouseToDo == 1481
        m = 9
    else if MouseToDo == 1534
            m = 10
        end
    end
end


MouseName{1} = ['M' num2str(MouseToDo)];

%% Spectrums

for i = 1 : length(HeadRestraintSess{m})
    cd(HeadRestraintSess{1,m}{1,i})
    disp(HeadRestraintSess{1,m}{1,i})
    
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
    
    load('ChannelsToAnalyse/Bulb_deep.mat')
    FindNoiseEpoch_BM([cd filesep],channel,0);
%     
%     if (exist('ChannelsToAnalyse/EKG.mat')>0)
%         MakeHeartRateForSession_BM
%     end
%     
end

%% Epochs for HR

for i = 1 : length(HeadRestraintSess{m})
    cd(HeadRestraintSess{1,m}{1,i})
    disp(HeadRestraintSess{1,m}{1,i})
    
    load('StateEpochSB.mat', 'Epoch')
    FindGammaEpoch(Epoch,54,3,[pwd filesep])
    
    if (exist('ChannelsToAnalyse/EKG.mat')>0)
        MakeHeartRateForSession_BM
    end
    
end

% if ExpeInfo.SleepSession==1
%     CreateRipplesSleep('scoring','accelero','stim',0,'restrict',1,'sleep',1)
% else
%     CreateRipplesSleep('scoring','accelero','stim',0,'restrict',1,'sleep',0)
% end

   