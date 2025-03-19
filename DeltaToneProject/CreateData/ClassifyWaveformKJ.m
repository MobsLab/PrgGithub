% ClassifyWaveformKJ
% 21.10.2016 KJ
%
% make waveform classification
%
% Info
%   see MakeWaveformDataKJ, IdentifyWaveforms
%


% Dir = PathForExperimentsDeltaWavesTone('all');
Dir = PathForExperimentsDeltaToInclude('all');


for p=4:length(Dir.path)
    try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)
        
        clearvars -except Dir p
        
        PlotOrNot=0;
        FilenamDropBox = '/home/mobsjunior/';
        load SpikeData.mat
        numNeurons = 1:length(S);
        Filename = [pwd '/'];
        
        [WfId,W]=IdentifyWaveforms(Filename,FilenamDropBox,PlotOrNot,numNeurons);
        save SpikeClassification WfId W
        
    catch
        disp('problem for classification') 
    end
    
end