% code pour renommer les spectres to fit SpectroFearML_JL.m
% 18.01.2016




[params,movingwin,suffix]=SpectrumParametersML('low');

Dir=PathForExperimentFEAR('Fear-electrophy','fear',1);



    for man=1:length(Dir.path)
        %Dir.path{man}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse299/20151218-EXT-48h-envB';
        Dir.path{man}
        cd(Dir.path{man})

        if ~exist([Dir.path{man},'/SpectrumDataL'],'dir'), mkdir([Dir.path{man},'/SpectrumDataL']);end

        if exist('ChannelsToAnalyse/Bulb_deep.mat')
            Ch_OB=load('ChannelsToAnalyse/Bulb_deep.mat');
            load B_Low_Spectrum.mat
            Sp=Spectro{1,1};
            t=Spectro{1,2};
            f=Spectro{1,3};
            eval(['save(''',Dir.path{man},'/SpectrumDataL/Spectrum',num2str(Ch_OB.channel),'.mat'',','''Sp'',','''t'',','''f'',','''params'',','''movingwin'');'])
            clear Spectro Sp t f Ch_OB
            disp('rename Bulb_deep spectrum')
        end

        if exist('ChannelsToAnalyse/dHPC_rip.mat')
            Ch_H=load('ChannelsToAnalyse/dHPC_rip.mat');
            load H_Low_Spectrum.mat
            Sp=Spectro{1,1};
            t=Spectro{1,2};
            f=Spectro{1,3};
            eval(['save(''',Dir.path{man},'/SpectrumDataL/Spectrum',num2str(Ch_H.channel),'.mat'',','''Sp'',','''t'',','''f'',','''params'',','''movingwin'');'])
            clear Spectro Sp t f Ch_H
            disp('rename dHPC_rip spectrum')
        end

        if exist('ChannelsToAnalyse/PFCx_deep.mat')
            Ch_PF=load('ChannelsToAnalyse/PFCx_deep.mat');
            load PF_Low_Spectrum.mat
            Sp=Spectro{1,1};
            t=Spectro{1,2};
            f=Spectro{1,3};
            eval(['save(''',Dir.path{man},'/SpectrumDataL/Spectrum',num2str(Ch_PF.channel),'.mat'',','''Sp'',','''t'',','''f'',','''params'',','''movingwin'');'])
            clear Spectro Sp t f Ch_PF
            disp('rename PFCx_deep spectrum')
        end
    end


