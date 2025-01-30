 function Dir=PathForExperimentsERC_DimaMAC(experiment)


%% Groups

% Concatenated - small zone (starting with 797)
LFP = [1:11]; % Good LFP
Neurons = [1 2 3 5 7 8 9 10 11]; % Good Neurons
ECG = [1 4 5 9 10]; % Good ECG

%% Path
a=0;
I_CA=[];
% 'ERC'
% 'Hab' 'PreSleep' 'TestPre' 'Cond' 'PostSleep' 'TestPost' 'TestPost24h' 'FindSleep' 'UMaze'
%%
if strcmp(experiment,'UMazePAG')
    
    % Mouse797
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/DataERC2/M797/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse798
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/DataERC2/M798/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse828
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/DataERC2/M828/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse861
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/DataERC2/M861/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse882
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/DataERC2/M882/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse905
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/DataERC2/M905/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse906
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/DataERC2/M906/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse911
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/DataERC2/M911/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse912
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/DataERC2/M912/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse977
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/DataERC2/M977/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse994
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/DataERC2/M994/20191013/';
%     a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/M994/20191106/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse1117
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/DataERC2/M1117/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse1124
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/DataERC2/M1124/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse1161
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/DataERC2/M1161/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse1162
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/DataERC2/M1162/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse1168
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/DataERC2/M1168/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse1182
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/DataERC2/M1182/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse1182
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/DataERC2/M1182/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse1186
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/DataERC2/M1186/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse1199
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/DataERC2/M1199/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;


elseif strcmp(experiment,'FirstExplo')
    
%     % Mouse828
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-828/20190301/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%     
%     % Mouse861
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC2/Mouse-861/20190312/ExploDay/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
%     % Mouse882
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC1/M0882/First Exploration/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%     
%     % Mouse905
%     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/_Concatenated/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse912
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/M912/1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse977
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/M977/1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse979
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/M979/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % MouseK016
    a=a+1;Dir.path{a}{1}='/Volumes/DimaERC2/M1016/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    
else
    error('Invalid name of experiment')
end


%% Get mice names
for i=1:length(Dir.path)
    Dir.manipe{i}=experiment;
    temp=strfind(Dir.path{i}{1},'M');
    if strcmp(Dir.path{i}{1}(temp+1:temp+2), '11')
        Dir.name{i}=['Mouse',Dir.path{i}{1}(temp+1:temp+4)];
    else
        if isempty(temp)
            Dir.name{i}=Dir.path{i}{1}(strfind(Dir.path{i}{1},'Mouse'):strfind(Dir.path{i}{1},'Mouse')+7);
        else
            Dir.name{i}=['Mouse',Dir.path{i}{1}(temp+1:temp+3)];
        end
    end
    %fprintf(Dir.name{i});
end


%% Get Groups

for i=1:length(Dir.path)
    Dir.manipe{i}=experiment;
    if strcmp(Dir.manipe{i},'UMazePAG')
        Dir.group{1} = cell(length(Dir.path));
        for j=1:length(LFP)
            Dir.group{1}{LFP(j)} = 'LFP';
        end
        Dir.group{2} = cell(length(Dir.path));
        for j=1:length(Neurons)
            Dir.group{2}{Neurons(j)} = 'Neurons';
        end
        Dir.group{3} = cell(length(Dir.path));
        for j=1:length(ECG)
            Dir.group{3}{ECG(j)} = 'ECG';
        end
    end
    
end

end