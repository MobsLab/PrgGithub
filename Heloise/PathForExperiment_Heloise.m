function Dir=PathForExperiment_Heloise(experiment)

% input:
% name of the experiment.
% possible choices:
% 'CalibPAG'
%
% output
% Dir = structure containing paths / names / strains / name of the
% experiment (manipe) / correction for amplification (default=1000)
%
%
% example:
% Dir=PathForExperimentsML('EPM');
%
% 	merge two Dir:
% Dir=MergePathForExperiment(Dir1,Dir2);
%lHav
%   restrict Dir to mice or group:
% Dir=RestrictPathForExperiment(Dir,'nMice',[245 246])
% Dir=RestrictPathForExperiment(Dir,'Group',{'OBX','hemiOBX'})
% Dir=RestrictPathForExperiment(Dir,'Group','OBX')
%
% similar functions:
% PathForExperimentFEAR.m
% PathForExperimentsDeltaSleep.m
% PathForExperimentsKB.m PathForExperimentsKBnew.m
% PathForExperimentsML.m

%% Path

addpath(genpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/'));

a=0;

if strcmp(experiment,'CalibPAG')
    % Mouse 797
    a=a+1;Dir.path{a}{1}='/media/gruffalo/DataMOBS87/Mouse-797/10112018/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
     
    % Mouse 798
    a=a+1;Dir.path{a}{1}='/media/gruffalo/DataMOBS87/Mouse-798/10112018_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
%{    
    % Mouse 861
    a=a+1;Dir.path{a}{1}='/media/gruffalo/DataMOBS114/Mouse-861/        Concatenated';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
%}    

    % Mouse 905
    a=a+1;Dir.path{a}{1}='/media/gruffalo/DataMOBS102/Mouse-905/20190402_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
   
    % Mouse911 (OB)
    a=a+1;Dir.path{a}{1}='/media/gruffalo/DataMOBS102/Mouse-911/20190503/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse912 (OB)
    a=a+1;Dir.path{a}{1}='/media/gruffalo/DataMOBS102/Mouse-912/20190503/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;

%{ 
    % Mouse936 (OB)
    a=a+1;Dir.path{a}{1}='/media/gruffalo/DataMOBS114/Mouse-936/20190603/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse937 (OB)
    a=a+1;Dir.path{a}{1}='/media/gruffalo/DataMOBS114/Mouse-937/20190604/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
    % Mouse941 (OB)
    a=a+1;Dir.path{a}{1}='/media/gruffalo/DataMOBS114/Mouse-941/20190610/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
    
 %} 
    
    % Mouse977
    a=a+1;Dir.path{a}{1}='/media/gruffalo/DataMOBS102/Mouse-977/20190808/_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;

%{ 
    % Mouse 978
    a=a+1;Dir.path{a}{1}='/media/gruffalo/DataMOBS114/Mouse-978/          /_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;

    % Mouse 994
    a=a+1;Dir.path{a}{1}='/media/gruffalo/DataMOBS114/Mouse-994/          /_Concatenated/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}=ExpeInfo;
 %}
    
else
    error('Invalid name of experiment')
    
end

%% Get mice names
for i=1:length(Dir.path)
    Dir.manipe{i}=experiment;
    temp=strfind(Dir.path{i}{1},'Mouse-');
    if isempty(temp)
        Dir.name{i}=Dir.path{i}{1}(strfind(Dir.path{i}{1},'Mouse'):strfind(Dir.path{i}{1},'Mouse')+7);
    else
        Dir.name{i}=['Mouse',Dir.path{i}{1}(temp+6:temp+8)];
    end
    %fprintf(Dir.name{i});
end

end
