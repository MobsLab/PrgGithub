%utils_ID_figure

Dir1=PathForExperimentsDeltaWavesTone('Basal');
Dir2=PathForExperimentsDeltaWavesTone('RdmTone');
Dir3=PathForExperimentsDeltaWavesTone('DeltaToneAll');
Dir = MergePathForExperiment(Dir1,Dir2);
Dir = MergePathForExperiment(Dir,Dir3);
clear Dir1 Dir2 Dir3
Dir = RestrictPathForExperiment(Dir,'nMice',[328 330]);


for p=1:length(Dir.path)
   
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    newname = ['SleepScoring_' Dir.title{p} '.png'] ;
    
    dir1 = '/home/mobsjunior/Dropbox/Kteam/Projets KarimJr/Projet Delta/Figures Projet DeltaFeedback/IDfigures/';
    copyfile('SleepScoring.png',dir1)
    cd(dir1)
    movefile('SleepScoring.png',newname)
    

end


x = '*.fig';
filelist = dir(x);
for i=1:length(filelist)
    figName = filelist(i).name;
    outName = [figName(1:end-3) 'png'];
    h=openfig(figName,'new','invisible');
    set(h,'units','normalized','outerposition',[0 0 1 1])
    saveas(h,outName,'png')
    close(h);
end


for p=1:length(Dir.path)
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    try
        load newDownState Down
    catch
        disp(' ')
        disp('****************************************************************')
        disp(pwd)
        disp('error for Down')
    end
    try
        load newDownState Down
    catch
        disp(' ')
        disp('****************************************************************')
        disp(pwd)
        disp('error for Down')
    end

end


warning('off','all')
warning
for p=1:length(Dir.path)
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    try
        load StateEpochSB SWSEpoch Wake REMEpoch
        SWSEpoch;Wake;REMEpoch;
    catch
        disp(' ')
        disp('****************************************************************')
        disp(pwd)
        disp('error for StateEpoch sleep stages')
    end
end


warning('off','all')
warning
for p=1:length(Dir.path)
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    if ~(exist('newRipHPC.mat','file')==2)
        disp(' ')
        disp('****************************************************************')
        disp(pwd)
        disp('no Ripples')
    end
    if ~(exist('newDownState.mat','file')==2)
        disp(' ')
        disp('****************************************************************')
        disp(pwd)
        disp('no Down states')
    end
    if ~(exist('DeltaPFCx.mat','file')==2)
        disp(' ')
        disp('****************************************************************')
        disp(pwd)
        disp('no Delta PFCx')
    end
end

%missing file
Dir=PathForExperimentsProcessingProblem('problemMakeWaveform');
warning('off','all')
warning
for p=1:length(Dir.path)
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    if ~(exist('Waveforms.mat','file')==2)
        disp(' ')
        disp('****************************************************************')
        disp(pwd)
        disp('Waveforms.mat')
    end
end

%create spike data and waveform
warning('off','all')
warning
for p=1:length(Dir.path)
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    if exist('SpikeData.mat','file')==2 && exist('Waveforms.mat','file')==2
        disp(' ')
        disp('****************************************************************')
        disp(pwd)
        MakeWaveformDataKJ;
    end
end
try
    CreateSignalsIDFigures2;
end
try
    ClassifyWaveformKJ;
end



%% create spike to analyse
clear
[S,numNeurons,numtt,TT] = GetSpikesFromStructure('PFCx');

number = [2:6 8 9 11:13 15:17];
save SpikesToAnalyse/PFCx_Neurons.mat number
number = [1 7 10 14];
save SpikesToAnalyse/PFCx_MUA.mat number


for p=1:length(Dir.path)
    if any(strcmp(Dir.name(p),{'Mouse293','Mouse294','Mouse296'}))
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp('****************************************************************')
        disp(pwd)
        clear S numNeurons numtt TT
        try
            [S,numNeurons,numtt,TT] = GetSpikesFromStructure('PFCx');
            % remove MUA from the analysis
            nN=numNeurons;
            num_mua = [];
            num_single = [];
            for s=1:length(numNeurons)
                if TT{numNeurons(s)}(2)==1
                    num_mua = [num_mua numNeurons(s)];
                else
                    num_single = [num_single numNeurons(s)];
                end
            end
            number = num_single;
            save SpikesToAnalyse/PFCx_Neurons.mat number
            number = num_mua;
            save SpikesToAnalyse/PFCx_MUA.mat number
        catch
           disp('error for this record') 
        end
    end
end

  
                






