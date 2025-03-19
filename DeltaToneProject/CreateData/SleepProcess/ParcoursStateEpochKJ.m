%ParcoursStateEpochKJ
% 03.10.2016 KJ
%
% generate StateEpochSB.mat
%
% see BulbSleepScript

Dir1=PathForExperimentsDeltaWavesTone('Basal');
Dir2=PathForExperimentsDeltaWavesTone('RdmTone');
Dir3=PathForExperimentsDeltaWavesTone('DeltaToneAll');
Dir = MergePathForExperiment(Dir1,Dir2);
Dir = MergePathForExperiment(Dir,Dir3);

for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    if exist('StateEpochSB.mat', 'file') == 2
        disp('StateEpochSB.mat already there')
    else
        try
            clearvars -except Dir p
            %% Step 1 - channels to use and 2 spectra
            filename=cd;
            if filename(end)~='/'
                filename(end+1)='/';
            end
            scrsz = get(0,'ScreenSize');
            res=pwd;

            load([res,'/LFPData/InfoLFP']);
            load([res,'/LFPData/LFP',num2str(InfoLFP.channel(1))]);

            r=Range(LFP);
            TotalEpoch=intervalSet(0,r(end));
            mindur=3; %abs cut off for events;
            ThetaI=[3 3]; %merge and drop
            mw_dur=5; %max length of microarousal
            sl_dur=15; %min duration of sleep around microarousal
            ms_dur=10; % max length of microsleep
            wa_dur=20; %min duration of wake around microsleep
            ThreshEpoch=TotalEpoch;

            try
                load('ChannelsToAnalyse/dHPC_deep.mat')
                chH=channel;
            catch
                try
                    load('ChannelsToAnalyse/dHPC_rip.mat')
                    chH=channel;
                catch
                    chH=input('please give hippocampus channel for theta ');
                end
            end

            try
                load('ChannelsToAnalyse/Bulb_deep.mat')
                chB=channel;
            catch
                chB=input('please give olfactory bulb channel ');
            end

            %% Step 2 - Theta and Gamma Epochs from Spectra
            % load('behavRessources.mat');
            if ~(exist('B_High_Spectrum.mat', 'file') == 2)
                HighSpectrum(filename,chB,'B');
                disp('Bulb Spectrum done')
            end
            if ~(exist('H_Low_Spectrum.mat', 'file') == 2)
                LowSpectrumSB(filename,chH,'H');
                disp('Hpc spectrum done')
            end
            Epoch=FindNoiseEpoch(filename,chH);

            try
                load('behavResources.mat','PreEpoch')
                Epoch=and(Epoch,PreEpoch);
                Epoch=CleanUpEpoch(Epoch);
            end
            try
                load('behavResources.mat','stimEpoch')
                Epoch=Epoch-stimEpoch;
                Epoch=CleanUpEpoch(Epoch);
            end
            
            TotalEpoch=and(TotalEpoch,Epoch);
            TotalEpoch=CleanUpEpoch(TotalEpoch);
            ThreshEpoch=and(ThreshEpoch,Epoch);
            ThreshEpoch=CleanUpEpoch(ThreshEpoch);
            close all;
            FindGammaEpoch(ThreshEpoch,chB,mindur,filename);
            close all;
            FindThetaEpoch(ThreshEpoch,ThetaI,chH,filename);
            %CalcTheta(Epoch,ThetaI,chH,filename)
            %CalcGamma(Epoch,chB,mindur,filename)
            
            close all;

            %% Step 3 - Behavioural Epochs
            FindBehavEpochs(TotalEpoch,mindur,mw_dur,sl_dur,ms_dur,wa_dur,filename)
        end
        
    end
    
end
