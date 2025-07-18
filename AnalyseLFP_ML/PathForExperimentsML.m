function Dir=PathForExperimentsML(experiment)

% input:
% name of the experiment.
% possible choices: 'DPCPX' 'LPS' 'BASAL' 'CANAB' 'PLETHYSMO'
% 'PLETHYSMO_thy1' 'SELECT_SB'
%
% output
% Dir = structure containing paths / names / strains / name of the
% experiment (manipe) / correction for amplification (default=1000)
%
%   example:
% Dir=PathForExperimentsML('BASAL');
%
% 	merge two Dir:
% Dir=MergePathForExperiment(Dir1,Dir2);
%
%   restrict Dir to mice or group:
% Dir=RestrictPathForExperiment(Dir,'nMice',[245 246])
% Dir=RestrictPathForExperiment(Dir,'Group',{'OBX','hemiOBX'})
% Dir=RestrictPathForExperiment(Dir,'Group','OBX')

% similar functions:
% PathForExperimentFEAR.m
% PathForExperimentsBULB.m
% PathForExperimentsDeltaSleep.m
% PathForExperimentsKB.m PathForExperimentsKBnew.m 


%% strains inputs

dKOmice={'Mouse047' 'Mouse052' 'Mouse054' 'Mouse065' 'Mouse066' 'Mouse146' 'Mouse149' 'Mouse158' 'Mouse159' 'Mouse164'};
WTmice={'Mouse051' 'Mouse060' 'Mouse061' 'Mouse082' 'Mouse083' 'Mouse147' 'Mouse148' 'Mouse161' 'Mouse162' 'Mouse160'};
%CTRLNmice={'Mouse051' 'Mouse060' 'Mouse061' 'Mouse082' 'Mouse083' 'Mouse147'  'Mouse148' 'Mouse161' 'Mouse162'};
C57mice={'Mouse055' 'Mouse056' 'Mouse063' 'Mouse160'};
Thy1mice={'Mouse105' 'Mouse106'};

%% Path
a=0;
I_CA=[];
if strcmp(experiment,'DPCPX')
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse051/20130313/BULB-Mouse-51-13032013'; I_CA=[I_CA,a];       
    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetDPCPX/Mouse051/20121219/BULB-Mouse-51-19122012';I_CA=[I_CA,a]; % MANIPE DPCPX
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse051/20121227/BULB-Mouse-51-27122012';I_CA=[I_CA,a];% MANIPE DPCPX
   
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/ProjetDPCPX/Mouse054/20130308/BULB-Mouse-54-08032013'; I_CA=[I_CA,a];
    %a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/ProjetDPCPX/Mouse054/20130312/BULB-Mouse-54-12032013';I_CA=[I_CA,a];
    
 %   a=a+1;  Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse054/20130308/BULB-Mouse-54-08032013';I_CA=[I_CA,a];   old---------------------------
 %   %a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse054/20130312/BULB-Mouse-54-12032013';I_CA=[I_CA,a];   old---------------------------
    
%     a=a+1; Dir.path{a}='/media/DataMOBs/ProjetDPCPX/Mouse052/20121114/BULB-Mouse-52-14112012';I_CA=[I_CA,a];% dpcpx
%     a=a+1; Dir.path{a}='/media/DataMOBs/ProjetDPCPX/Mouse052/20121116/BULB-Mouse-52-16112012';I_CA=[I_CA,a];%dpcpx
%     a=a+1; Dir.path{a}='/media/DataMOBs/ProjetDPCPX/Mouse052/20121221/BULB-Mouse-52-21122012';I_CA=[I_CA,a];%dpcpx

    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetDPCPX/Mouse047/20121112/BULB-Mouse-47-12112012';I_CA=[I_CA,a];
    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetDPCPX/Mouse047/20121220/BULB-Mouse-47-20122012';I_CA=[I_CA,a];
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130422/BULB-Mouse-60-22042013';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130422/BULB-Mouse-61-22042013';
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse065/20130515/BULB-Mouse-65-15052013';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse066/20130515/BULB-Mouse-66-15052013' ;
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130730/BULB-Mouse-82-30072013';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse083/20130730/BULB-Mouse-83-30072013';
    
    % ------------------ old manipes --------------------
    
    
    
elseif strcmp(experiment,'LPS'),
    
    %Mouse 51
    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse051/20130220/BULB-Mouse-51-20022013';I_CA=[I_CA,a];
    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse051/20130221/BULB-Mouse-51-21022013';I_CA=[I_CA,a];
    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse051/20130222/BULB-Mouse-51-22022013';I_CA=[I_CA,a];
    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse051/20130223/BULB-Mouse-51-23022013';I_CA=[I_CA,a];
    
    %Mouse 54
    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse054/20130319/BULB-Mouse-54-19032013';I_CA=[I_CA,a];
    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse054/20130320/BULB-Mouse-54-20032013';I_CA=[I_CA,a];
    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse054/20130321/BULB-Mouse-54-21032013';I_CA=[I_CA,a];
    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse054/20130322/BULB-Mouse-54-22032013';I_CA=[I_CA,a];
    
    %Mouse 55
    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse055/20130402/BULB-Mouse-55-56-02042013';
    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse055/20130403/BULB-Mouse-55-03042013';
    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse055/20130404/BULB-Mouse-55-04042013';
    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse055/20130405/BULB-Mouse-55-05042013';
    
    %Mouse 56
    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse056/20130409/BULB-Mouse-56-09042013';
    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse056/20130410/BULB-Mouse-56-10042013';
    %a=a+1; Dir.path{a}='';
    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse056/20130412/BULB-Mouse-56-12042013';
    
    %Mouse 63
    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse063/20130424/BULB-Mouse-63-24042013';
    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse063/20130425/BULB-Mouse-63-25042013';
    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse063/20130426/BULB-Mouse-63-26042013';
    a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse063/20130427/BULB-Mouse-63-27042013';
    
    
elseif strcmp(experiment,'BASAL')
    
    % --- dKO ---
    % Mouse 47 - cleaned
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse047/20121108/BULB-Mouse-47-08112012';I_CA=[I_CA,a];% Trec
    
    % Mouse 52 - cleaned
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse052/20121113/BULB-Mouse-52-13112012';I_CA=[I_CA,a];% Trec
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse052/20121114/BULB-Mouse-52-14112012';I_CA=[I_CA,a];% Trec
    
    % Mouse 54 - cleaned
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse054/20130305/BULB-Mouse-54-05032013';I_CA=[I_CA,a];% Trec
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse054/20130306/BULB-Mouse-54-06032013';I_CA=[I_CA,a];% Trec
    %a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse054/20130308/BULB-Mouse-54-08032013';I_CA=[I_CA,a];% Trec- dpcpx
    %a=a+1;Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse054/20130308/BULB-Mouse-54-08032013';I_CA=[I_CA,a];
    
    % Mouse 65 - cleaned
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse065/20130513/BULB-Mouse-65-13052013'; % Trec- REVERSE fixed (-LFP)
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse065/20130515/BULB-Mouse-65-15052013'; % Trec- REVERSE fixed (-LFP)
    
    % Mouse 66 - cleaned
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse066/20130513/BULB-Mouse-66-13052013' ; % Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse066/20130515/BULB-Mouse-66-15052013' ; % Trec- REVERSE ok
    
    % Mouse 146 - cleaned
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse146/20140804/BULB-Mouse-146-04082014'; % Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse146/20140828/BULB-Mouse-146-28082014'; % Trec- REVERSE ok
    
    % Mouse 149 - cleaned
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse149/20140804/BULB-Mouse-149-04082014'; % Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse149/20140828/BULB-Mouse-149-28082014'; % Trec- REVERSE ok
    
    % Mouse 158
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse158/20141209/BULB-Mouse-158-09122014'; % Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse158/20141211/BULB-Mouse-158-11122014'; % Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse158/20141217/BULB-Mouse-158-17122014'; % Trec- REVERSE ok
    
    % Mouse 159
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse159/20141215/BULB-Mouse-159-15122014'; % Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse159/20141216/BULB-Mouse-159-16122014'; % Trec- REVERSE ok
   % a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse159/20141218/BULB-Mouse-159-18122014'; % Trec- REVERSE ok
    
    % Mouse 164
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse164/20141219/BULB-Mouse-164-19122014'; % Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse164/20141222/BULB-Mouse-164-22122014'; % Trec- REVERSE ok
   % a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse164/20141223/BULB-Mouse-164-23122014'; % Trec- REVERSE ok
    
    
    % --- WT ---
    % Mouse 51 - cleaned
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse051/20130313/BULB-Mouse-51-13032013';I_CA=[I_CA,a]; % Trec- apres manipes dpcpx

    % Mouse 56
    % to check. Delta PFCx. Attention no PaCX, Ripples on ch8
    %a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse056/20130409/BULB-Mouse-56-09042013/';I_CA=[I_CA,a]; % Trec- apres manipes dpcpx
    
    % Mouse 60 - cleaned
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130422/BULB-Mouse-60-22042013'; % Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013'; % Trec- REVERSE fixed (-LFP)
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130416/BULB-Mouse-60-16042013'; % Trec- REVERSE ok
    
    % Mouse 61 - cleaned
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130422/BULB-Mouse-61-22042013'; % Trec- REVERSE fixed (-LFP)
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130415/BULB-Mouse-61-15042013'; % Trec- REVERSE fixed (-LFP)
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130416/BULB-Mouse-61-16042013'; % Trec- REVERSE fixed (-LFP)
    
    % Mouse 82 - cleaned
    %a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130723/BULB-Mouse-82-23072013'; % Trec- REVERSE ok, signaux Bizarre
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130729/BULB-Mouse-82-29072013'; % Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130730/BULB-Mouse-82-30072013';% Trec- DPCPX % REVERSE ok
    
    % Mouse 83 - cleaned
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse083/20130723/BULB-Mouse-83-23072013';% Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse083/20130729/BULB-Mouse-83-29072013';% Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse083/20130730/BULB-Mouse-83-30072013'; % Trec- DPCPX % REVERSE ok
    
    % Mouse 147
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse147/20140804/BULB-Mouse-147-04082014'; % Trec- % REVERSE ok
    
    % Mouse 148
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse148/20140828/BULB-Mouse-148-28082014'; % Trec- REVERSE ok
    
    % Mouse 160
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse160/20141219/BULB-Mouse-160-19122014'; % Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse160/20141222/BULB-Mouse-160-22122014'; % Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse160/20141223/BULB-Mouse-160-23122014'; % Trec- REVERSE ok
    
    % Mouse 161
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse161/20141209/BULB-Mouse-161-09122014'; % Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse161/20141211/BULB-Mouse-161-11122014'; % Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse161/20141217/BULB-Mouse-161-17122014'; % Trec- REVERSE ok
    
    % Mouse 162
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse162/20141215/BULB-Mouse-162-15122014'; % Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse162/20141216/BULB-Mouse-162-16122014'; % Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse162/20141218/BULB-Mouse-162-18122014'; % Trec- REVERSE ok
    

elseif strcmp(experiment,'SUBSET')
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse149/20140804/BULB-Mouse-149-04082014'; % Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130416/BULB-Mouse-60-16042013'; % Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse160/20141222/BULB-Mouse-160-22122014'; % Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse066/20130513/BULB-Mouse-66-13052013' ; % Trec- REVERSE ok
    
elseif strcmp(experiment,'CANAB')
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013';I_CA=[I_CA,a];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse047/20130111/BULB-Mouse-47-11012013';I_CA=[I_CA,a];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse052/20130122/BULB-Mouse-52-22012013';I_CA=[I_CA,a];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse054/20130314/BULB-Mouse-54-14032013';I_CA=[I_CA,a];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse060/20130430/BULB-Mouse-60-30042013'; % REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse061/20130430/BULB-Mouse-61-30042013';% PROBLEM REVERSE !!!
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse065/BULB-Mouse-65-05062013';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse066/BULB-Mouse-66-05062013';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse082/20130802/BULB-Mouse-82-02082013';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse083/20130802/BULB-Mouse-83-02082013';
    
elseif strcmp(experiment,'PLETHYSMO')
    % --------------- WT --------------- 
    %a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse051';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse051/20130503';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse060/20130503';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse061/20130503';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse082/20130724';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse082/20130827';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse083/20130724';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse083/20130827';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse147/20140805';
    %a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse147/20140806'; DEATH
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse148/20140805';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse148/20140806';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse160/20141221';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse160/20141224';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse160/20141228';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse161/20141210';
    %a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse161/20141212';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse161/20141222';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse162/20141217';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse162/20141219';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse162/20141223';
    % --------------- dKO ---------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse054/20130503BO';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse054/20130503Cx';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse065/20130514';
    %a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse065/20130527';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse066/20130514';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse066/20130528';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse146/20140805';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse146/20140806';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse149/20140805';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse149/20140806';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse158/20141210';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse158/20141212';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse158/20141222';
    %a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse159/20141217';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse159/20141219';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse159/20141223';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse164/20141221';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse164/20141224';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro-DataPlethysmo/Mouse164/20141228';
    
elseif strcmp(experiment,'PLETHYSMO_thy1')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse106-Thy1/20131206-plethy';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse106-Thy1/20131213-plethy';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse106-Thy1/20131230-plethy';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse106-Thy1/20131231-plethy-occlusion';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse105-Thy1/20131204-plethy';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse105-Thy1/20131205-plethy';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse105-Thy1/20131213-plethy';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse105-Thy1/20131231-plethy-occlusion';

    %     a=a+1; Dir.path{a}='';
    
elseif strcmp(experiment,'SELECT_SB')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013/';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130730/BULB-Mouse-82-30072013/';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse083/20130802/BULB-Mouse-83-02082013/';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013/';I_CA=[I_CA,a];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse061/20130430/BULB-Mouse-61-30042013/';
    
elseif strcmp(experiment,'EMG')
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse149/20140804/BULB-Mouse-149-04082014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse161/20141211/BULB-Mouse-161-11122014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse161/20141209/BULB-Mouse-161-09122014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse161/20141217/BULB-Mouse-161-17122014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse159/20141216/BULB-Mouse-159-16122014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse159/20141218/BULB-Mouse-159-18122014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse159/20141215/BULB-Mouse-159-15122014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse164/20141222/BULB-Mouse-164-22122014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse164/20141219/BULB-Mouse-164-19122014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse164/20141223/BULB-Mouse-164-23122014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse148/20140828/BULB-Mouse-148-28082014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse160/20141222/BULB-Mouse-160-22122014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse160/20141219/BULB-Mouse-160-19122014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse160/20141223/BULB-Mouse-160-23122014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse162/20141216/BULB-Mouse-162-16122014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse162/20141218/BULB-Mouse-162-18122014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse162/20141215/BULB-Mouse-162-15122014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse147/20140804/BULB-Mouse-147-04082014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse158/20141211/BULB-Mouse-158-11122014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse158/20141209/BULB-Mouse-158-09122014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAstro/Mouse158/20141217/BULB-Mouse-158-17122014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse149/20140828/BULB-Mouse-149-28082014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse148/20140828/BULB-Mouse-148-28082014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse146/20140804/BULB-Mouse-146-04082014';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse146/20140828/BULB-Mouse-146-28082014';
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
    elseif sum(strcmp(Dir.name{i},CTRLNmice))
        Dir.group{i}='realWT';
    elseif sum(strcmp(Dir.name{i},Thy1mice))
        Dir.group{i}='Thy1';
    else
        Dir.group{i}=nan;
    end
    
end

%% Correction if gain 1000 was not applied for signal aquisition

for i=1:length(Dir.path)
    Dir.CorrecAmpli(i)=1;
end

for i=I_CA
    Dir.CorrecAmpli(i)=1/2;
end
