clear all
Mice = [666,667,668,669];
for mm=4
    FileName = {'/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180221_Day',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180221_Night',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180222_Day_saline',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180222_Night_saline',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180223_Day_fluoxetine',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180223_Night_fluoxetine',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180224_Day_fluoxetine48H',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180224_Night_fluoxetine48H'};
    FileName = strrep(FileName,'MouseX',['Mouse',num2str(Mice(mm))]);
    
    
    for f = 1:length(FileName)
        cd(FileName{f})
        
        if exist('SpikeData.mat')>0
        CreateSpikeToAnalyse_KJ
        load('MeanWaveform.mat')
        [UnitID,AllParamsNew,WFInfo,BestElec,figid] = MakeData_ClassifySpikeWaveforms(W,'/home/vador/Dropbox/Kteam',1)
        end
        
        %% Sleep event
        CreateSleepSignals('recompute',0,'scoring','accelero');
        
        %% Substages
        [featuresNREM, Namesfeatures, EpochSleep, NoiseEpoch, scoring] = FindNREMfeatures('scoring','accelero');
        save('FeaturesScoring', 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch', 'scoring')
        [Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch);
        save('SleepSubstages', 'Epoch', 'NameEpoch')
        
        %% Id figure 1
        MakeIDSleepData('scoring','accelero')
        PlotIDSleepData('scoring','accelero')
        saveas(1,'IDFig1.png')
        close all
        
        %% Id figure 2
        MakeIDSleepData2('scoring','accelero')
        PlotIDSleepData2
        saveas(1,'IDFig2.png')
        close all

    end
end