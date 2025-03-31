clear all
Mice = [666,667,668,669];
for mm=1:4
    FileName = {'/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180221_Day',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180221_Night',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180222_Day_saline',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180222_Night_saline',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180223_Day_fluoxetine',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180223_Night_fluoxetine',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180224_Day_fluoxetine48H',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180224_Night_fluoxetine48H'};
    FileName = strrep(FileName,'MouseX',['Mouse',num2str(Mice(mm))]);
    
    
    for f =1:length(FileName)
        cd(FileName{f})
        disp(FileName{f})
        
        disp('deleting old files done with OB')
        delete([cd filesep 'IDFig1.png'])
        delete([cd filesep 'IDFig2.png'])
        delete([cd filesep 'IdFigureData.mat'])
        delete([cd filesep 'IdFigureData2.mat'])

        %% Sleep event
        disp('getting sleep signals')
        CreateSleepSignals('recompute',1,'scoring','accelero');
        
        %% Substages
        disp('getting sleep stages')
        [featuresNREM, Namesfeatures, EpochSleep, NoiseEpoch, scoring] = FindNREMfeatures('scoring','accelero');
        save('FeaturesScoring', 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch', 'scoring')
        [Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch);
        save('SleepSubstages', 'Epoch', 'NameEpoch')
        
        %% Id figure 1
        disp('making ID fig1')
        MakeIDSleepData
        PlotIDSleepData('scoring','accelero');
        saveas(1,'IDFig1.png')
        close all
        
        %% Id figure 2
        disp('making ID fig2')
        MakeIDSleepData2
        PlotIDSleepData2
        saveas(1,'IDFig2.png')
        close all

    end
end