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
Dir=PathForExperimentsProcessingProblem('MissingSpikeData');
warning('off','all')
warning
for p=1:length(Dir.path)
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    if ~(exist('SpikeData.mat','file')==2)
        disp(' ')
        disp('****************************************************************')
        disp(pwd)
        disp('Spike data')
    end
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

  
%% create new channel to analyse
clear
Dir=PathForExperimentsDeltaWavesTone('all');
Dir = RestrictPathForExperiment(Dir,'nMice',251);

for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)

eval('load ChannelsToAnalyse/PFCx_deep')
if channel < 32
    offset=0;
else
    offset=32;
    disp('offset')
end

channel=8+offset;
save ChannelsToAnalyse/PFCx_1 channel
channel=4+offset;
save ChannelsToAnalyse/PFCx_2 channel
channel=1+offset;
save ChannelsToAnalyse/PFCx_3 channel

end


%% split 243-244
step = 7;
x = 'Breath-Mouse-243-244*.*.*';
filelist = dir(x);
for i=1:length(filelist)
    fileName = filelist(i).name;
    
    outName = strrep(fileName, '243-244', '244');

    idx = strfind(outName,'.');
    old_end = outName(idx(2)+1:end);
    new_end = num2str(str2num(old_end) - step);
    outName = strrep(outName, ['.' old_end], ['.' new_end]);

    movefile(fileName, outName)
    
end


%% change ChannelTo Analyse
cd ChannelsToAnalyse
step = 32;
x = '*.mat';
filelist = dir(x);
for i=1:length(filelist)
    fileName = filelist(i).name;
    load(fileName);
    if ~isempty(channel)
        if channel>step && ~ismember(channel,[67 68 69])
            channel = channel -step;
            save(fileName, 'channel')
        elseif ismember(channel,[67 68 69])
            channel = channel -35;
        end
    end
end


%% change InfoLFP and LFP
cd ..
load('LFPData/InfoLFP.mat');
if all(InfoLFP.channel>31)
    InfoLFP.channel = InfoLFP.channel - 32;
end
for ch=1:length(InfoLFP.channel)
    if InfoLFP.channel(ch)>34
        InfoLFP.channel(ch)=InfoLFP.channel(ch)-3;
    end
end
save('LFPData/InfoLFP.mat','InfoLFP')


cd LFPData
step = 32;
x = 'LFP*.mat';
filelist = dir(x);
for i=1:length(filelist)
    fileName = filelist(i).name;
    idx = strfind(fileName,'.');
    
    new_number = num2str(str2num(fileName(4:idx-1)) - step);
    outName = ['LFP' new_number '.mat'];
    
    movefile(fileName, outName);
end

%% Processing

x = '*BasalSleep*';
filelist = dir(x);
for i=1:length(filelist)
    fileName = filelist(i).name;
    outName = strrep(fileName, 'BasalSleep' , 'RandomTone');
    movefile(fileName, outName);
end


x = 'M873*';
filelist = dir(x);
for i=1:length(filelist)
    fileName = filelist(i).name;
    outName = strrep(fileName, 'M873' , 'M874');
    movefile(fileName, outName);
end


AddPrefixFilesOfFolder('M873_20190502_RandomTone-01-', '/media/mobsjunior/Data2/DeltaFeedBack/Mouse873-874/20190502/Mouse873/Tone-Sleep-Mouse-873_20190502_094322/')

SplitRecordFile('amplifier.dat',64, 'Mouse-873', [0:31], 'Mouse-874', [32:63])
SplitRecordFile('auxiliary.dat',6, 'Mouse-873', [0:2], 'Mouse-874', [3:5])
SplitRecordFile('analogin.dat',4, 'Mouse-873', [0:3], 'Mouse-874', [0:3])

movefile('amplifier_Mouse-873.dat','amplifier.dat')
movefile('analogin_Mouse-873.dat','analogin.dat')
movefile('auxiliary_Mouse-873.dat','auxiliary.dat')

% Dir1=PathForExperimentsDeltaSleepNew('basal');
% Dir2=PathForExperimentsDeltaSleepNew('DeltaTone');
% Dir3=PathForExperimentsDeltaSleepNew('RdmTone');
% 
% Dir = MergePathForExperiment(Dir1, Dir2);
% Dir = MergePathForExperiment(Dir, Dir3);
% 
% 
% for p=1:length(Dir.path)
%     try
%         disp(' ')
%         disp('****************************************************************')
%         eval(['cd(Dir.path{',num2str(p),'}'')'])
%         disp(pwd)
%         
%         clearvars -except Dir p
%         
%         delete DataPEaverage*.mat
%         delete Delta*.mat
%         delete newDelta*.mat
%         delete Spindles*.mat
%         delete Down*.mat
%         delete newDown*.mat
%         delete Ripples*.mat
%         delete newRip*.mat
%     end
%     
% end





clear
folderOrigin = '/media/mobsjunior/Data2/TP_Dreem/Record/';
folderTarget = '/home/mobsjunior/Dropbox/Mobs_member/KarimJr/TP_Dreem/Record/';

cd(folderOrigin)
x = '*.h5';
filelist = dir(x);

for i=1:length(filelist)
    
    reffile = filelist(i).name(1:end-3);
    
    mkdir(fullfile(folderTarget,reffile))
    
    copyfile([reffile '.h5'], fullfile(folderTarget,reffile))
    copyfile(fullfile('heart_rate',[reffile '_heart.h5']), fullfile(folderTarget,reffile))
    copyfile(fullfile('quality',[reffile '_quality.h5']), fullfile(folderTarget,reffile))
    copyfile(fullfile('virtualchannel',[reffile '_vc.h5']), fullfile(folderTarget,reffile))

end




