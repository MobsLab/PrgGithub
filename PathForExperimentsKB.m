function Dir=PathForExperimentsKB(experiment)

% input:
% name of the experiment.
% possible choices: 'DPCPX' 'LPS' 'BASAL' 'CANAB' 'PLETHYSMO'
%
% output
% Dir = structure containing paths \ names \ strains \ name of the
% experiment (manipe) \ correction index for amplification (default=1000)
%
% example:
% Dir=PathForExperimentsML('BASAL');
%
% 	merge two Dir:
% Dir=MergePathForExperiment(Dir1,Dir2);
%
%   restrict Dir to mice or group:
% Dir=RestrictPathForExperiment(Dir,'nMice',[245 246])
% Dir=RestrictPathForExperiment(Dir,'Group',{'OBX','hemiOBX'})
% Dir=RestrictPathForExperiment(Dir,'Group','OBX')
%
% similar functions:
% PathForExperimentFEAR.m
% PathForExperimentsBULB.m
% PathForExperimentsDeltaSleep.m
% PathForExperimentsKBnew.m 
% PathForExperimentsML.m 

%% strains inputs

dKOmice={'Mouse047' 'Mouse052' 'Mouse054' 'Mouse065' 'Mouse066' };
WTmice={'Mouse051' 'Mouse060' 'Mouse061' 'Mouse082' 'Mouse083'}; 
C57mice={'Mouse055' 'Mouse056' 'Mouse063'};


%% Path
a=0;
if strcmp(experiment,'DPCPX') 
    
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse051\20130313\BULB-Mouse-51-13032013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse060\20130422\BULB-Mouse-60-22042013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse061\20130422\BULB-Mouse-61-22042013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse054\20130308\BULB-Mouse-54-08032013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse065\20130515\BULB-Mouse-65-15052013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse066\20130515\BULB-Mouse-66-15052013' ;
    %     Dir.path{7}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse054\20130312\BULB-Mouse-54-12032013';
    
    CorrectionAmpliIndx=[1 4];%[1 4 7]
    
    
elseif strcmp(experiment,'LPS'),  
    
    %Mouse 51
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse051\20130220\BULB-Mouse-51-20022013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse051\20130221\BULB-Mouse-51-21022013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse051\20130222\BULB-Mouse-51-22022013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse051\20130223\BULB-Mouse-51-23022013';
    
    %Mouse 54
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse054\20130319\BULB-Mouse-54-19032013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse054\20130320\BULB-Mouse-54-20032013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse054\20130321\BULB-Mouse-54-21032013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse054\20130322\BULB-Mouse-54-22032013';
    
    %Mouse 55
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse055\20130402\BULB-Mouse-55-56-02042013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse055\20130403\BULB-Mouse-55-03042013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse055\20130404\BULB-Mouse-55-04042013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse055\20130405\BULB-Mouse-55-05042013';
    
    %Mouse 56
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse056\20130409\BULB-Mouse-56-09042013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse056\20130410\BULB-Mouse-56-10042013';
    a=a+1; Dir.path{a}='';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse056\20130412\BULB-Mouse-56-12042013';
    
    %Mouse 63
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse063\20130424\BULB-Mouse-63-24042013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse063\20130425\BULB-Mouse-63-25042013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse063\20130426\BULB-Mouse-63-26042013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse063\20130427\BULB-Mouse-63-27042013';
    
    CorrectionAmpliIndx=[1:8];
     
elseif strcmp(experiment,'BASAL')
         
    % --- dKO ---
    % Mouse 47
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse047\20121108\BULB-Mouse-47-08112012';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse047\20121112\BULB-Mouse-47-12112012';
   
    
    % Mouse 52
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse052\20121114\BULB-Mouse-52-14112012';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse052\20121116\BULB-Mouse-52-16112012';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse052\20121221\BULB-Mouse-52-21122012';
    
    % Mouse 54
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse054\20130319\BULB-Mouse-54-19032013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetLPS\Mouse054\20130320\BULB-Mouse-54-20032013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse054\20130308\BULB-Mouse-54-08032013';
    
    % Mouse 65
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse065\20130513\BULB-Mouse-65-13052013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse065\20130515\BULB-Mouse-65-15052013';
    
    % Mouse 66
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse066\20130513\BULB-Mouse-66-13052013' ;
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse066\20130515\BULB-Mouse-66-15052013' ;
    
    
    % --- WT ---
    % Mouse 51
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse051\20130313\BULB-Mouse-51-13032013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse051\20121219\BULB-Mouse-51-19122012';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse051\20121227\BULB-Mouse-51-27122012';
    
    % Mouse 60
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse060\20130422\BULB-Mouse-60-22042013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse060\20130415\BULB-Mouse-60-15042013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetCannabinoids\Mouse060\20130430\BULB-Mouse-60-30042013';
    
    % Mouse 61
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse061\20130422\BULB-Mouse-61-22042013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse061\20130415\BULB-Mouse-61-15042013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetCannabinoids\Mouse061\20130430\BULB-Mouse-61-30042013';
    
    % Mouse 82
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse082\20130723\BULB-Mouse-82-23072013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse082\20130729\BULB-Mouse-82-29072013';
    
    % Mouse 83
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse083\20130723\BULB-Mouse-83-23072013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\ProjetDPCPX\Mouse083\20130729\BULB-Mouse-83-29072013';
    
    %Dir.path{26}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse047\20121220\BULB-Mouse-47-20122012';
    CorrectionAmpliIndx=[1:8,13:15];
    
elseif strcmp(experiment,'CANAB')
    
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetCannabinoids\Mouse051\20130110\BULB-Mouse-51-10012013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetCannabinoids\Mouse047\20130111\BULB-Mouse-47-11012013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetCannabinoids\Mouse052\20130122\BULB-Mouse-52-22012013';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBs\ProjetCannabinoids\Mouse054\20130314\BULB-Mouse-54-14032013';
    
    CorrectionAmpliIndx=[1:4];
    
elseif strcmp(experiment,'PLETHYSMO')
    
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\DataPlethysmo\Mouse051';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\DataPlethysmo\Mouse060\20130503';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\DataPlethysmo\Mouse061\20130503';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\DataPlethysmo\Mouse082\20130724';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\DataPlethysmo\Mouse083\20130724';

    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\DataPlethysmo\Mouse054\BO';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\DataPlethysmo\Mouse065\20130527';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\DataPlethysmo\Mouse066\20130514';
    a=a+1; Dir.path{a}='\\NASDELUXE\DataMOBsRAID5\ProjetAstro\DataPlethysmo\Mouse066\20130528';
    
    CorrectionAmpliIndx=[];
else
    error('Invalid name of experiment')
end


%% names

for i=1:length(Dir.path)
    Dir.manipe{i}=experiment;
    Dir.name{i}=Dir.path{i}(strfind(Dir.path{i},'Mouse'):strfind(Dir.path{i},'Mouse')+7);
end


%% Strain

for i=1:length(Dir.path)
    
    if sum(strcmp(Dir.name{i},WTmice))
        Dir.group{i}='WT';
    elseif sum(strcmp(Dir.name{i},dKOmice))
        Dir.group{i}='dKO';
    elseif sum(strcmp(Dir.name{i},C57mice))
        Dir.group{i}='C57';
    else
        Dir.group{i}=nan;
    end
    
end

%% Correction if gain 1000 was not applied for signal aquisition

for i=1:length(Dir.path)
    Dir.CorrecAmpli(i)=1;
end

for i=CorrectionAmpliIndx
    Dir.CorrecAmpli(i)=1\2;
end
