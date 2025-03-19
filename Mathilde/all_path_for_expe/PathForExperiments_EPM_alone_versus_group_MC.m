function Dir=PathForExperiments_EPM_alone_versus_group_MC(experiment)

% INPUT:
% name of the experiment.
% possible choices:

% OUTPUT
% Dir = structure containing paths / names / strains / name of the
% experiment (manipe) / correction for amplification (default=1000)
%
% example:
% Dir=PathForExperiments_MC('BASAL');
%
% 	merge two Dir:
% Dir=MergePathForExperiment(Dir1,Dir2);
%lHav
%
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
a=0;
if strcmp(experiment,'EPM_alone')
        %Mouse 1449
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1449/20230414/EPM_Basal/ERC-Mouse-1449-14042023-EPM_00/';
    %Mouse 1450
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1450/20230414/EPM_Basal/ERC-Mouse-1450-14042023-EPM_00/';
    %Mouse 1451
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1451/20230414/EPM_Basal/ERC-Mouse-1451-14042023-EPM_00/';
        %Mouse 1196
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1196/20220222/EPM_saline/ERC-Mouse-1196-22022022-EPM_00/';
    %Mouse 1237
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1237/20220222/EPM_saline/ERC-Mouse-1237-22022022-EPM_00/';
    %Mouse 1238
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1238/20220222/EPM_saline/ERC-Mouse-1238-22022022-EPM_00/';
    
    
    
        %Mouse1300
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMobs166/ERC-Mouse-1300-16082022-EPM_00/';
    %Mouse1301
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMobs166/ERC-Mouse-1301-16082022-EPM_00/';
    %Mouse1302
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMobs166/ERC-Mouse-1302-22082022-EPM_00/';
    %Mouse1303
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMobs166/ERC-Mouse-1303-22082022-EPM_00/';
        %Mouse1371
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMobs166/ERC-Mouse-1371-10012023-EPM_00/';
    %Mouse1372
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMobs166/ERC-Mouse-1372-10012023-EPM_00/';
    %Mouse1373
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMobs166/ERC-Mouse-1373-17012023-EPM_00/';
    %Mouse1374
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMobs166/ERC-Mouse-1374-17012023-EPM_00/';
    
    
    
elseif strcmp(experiment,'EPM_group')
        %Mouse 1452
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1452/20230414/EPM_Basal/ERC-Mouse-1452-14042023-EPM_00/';
    %Mouse 1453
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1453/20230414/EPM_Basal/ERC-Mouse-1453-14042023-EPM_00/';
    %Eleonore's mice
    %Mouse CLA231
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/CLA231/20230602/EPM_Basal/ERC-Mouse-NaN-02062023-EPM_00/';
    %Mouse CLA232
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/CLA232/20230602/EPM_Basal/ERC-Mouse-NaN-02062023-EPM_02/';
    %Mouse CLA234
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/CLA234/20230602/EPM_Basal/ERC-Mouse-NaN-02062023-EPM_05/';
    %Mouse CLA235
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/CLA235/20230602/EPM_Basal/ERC-Mouse-NaN-02062023-EPM_06/';
    %Mouse EV93
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/EV93/20230602/EPM_Basal/ERC-Mouse-NaN-02062023-EPM_03/';
    %Mouse EV94
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/EV94/20230602/EPM_Basal/ERC-Mouse-NaN-02062023-EPM_04/';
    
    
    
    
    
else
    error('Invalid name of experiment')
end


%% Get mice names
for i=1:length(Dir.path)
    Dir.manipe{i}=experiment;
    temp=strfind(Dir.path{i}{1},'M');
    if isempty(temp)
        Dir.name{i}=Dir.path{i}{1}(strfind(Dir.path{i}{1},'Mouse'):strfind(Dir.path{i}{1},'Mouse')+7);
    else
        Dir.name{i}=['Mouse',Dir.path{i}{1}(temp+1:temp+4)];
        if sum(isstrprop(Dir.path{i}{1}(temp+1:temp+4),'alphanum'))<4
            Dir.name{i}=['Mouse',Dir.path{i}{1}(temp+1:temp+3)];
        end
    end
end

end

    
    
