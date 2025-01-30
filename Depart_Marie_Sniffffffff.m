% Depart_Marie_Sniffffffff


% ----------------------------------------------------------------------------------------------------------------
%liste souris spikes

% Dir=PathForExperimentsMLnew('Spikes');

% ----------------------------------------------------------------------------------------------------------------
% souris Basal WT pour la thèse

% dKOmice={'Mouse047' 'Mouse052' 'Mouse054' 'Mouse065' 'Mouse066' 'Mouse146' 'Mouse149' 'Mouse158' 'Mouse159' 'Mouse164'};
% WTmice={'Mouse051' 'Mouse060' 'Mouse061' 'Mouse082' 'Mouse083' 'Mouse147' 'Mouse148' 'Mouse161' 'Mouse162' 'Mouse160'};
% %CTRLNmice={'Mouse051' 'Mouse060' 'Mouse061' 'Mouse082' 'Mouse083' 'Mouse147'  'Mouse148' 'Mouse161' 'Mouse162'};
% C57mice={'Mouse055' 'Mouse056' 'Mouse063' 'Mouse160'};
% Thy1mice={'Mouse105' 'Mouse106'};
% Attention REMARQUE
% Pour utiliser les WT "réelle" il faut décommenter la ligne 34 du code PathForExperimentsML
%CTRLNmice={'Mouse051' 'Mouse060' 'Mouse061' 'Mouse082' 'Mouse083' 'Mouse147'  'Mouse148' 'Mouse161' 'Mouse162'};

Dir1=PathForExperimentsDeltaSleepNew('BASAL');   % souris Gaetan
Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
Dir2=PathForExperimentsML('BASAL'); % souris Marie
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);

% ----------------------------------------------------------------------------------------------------------------
% souris Basal WT/dKO pour la thèse


Dir1=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir1,'Group','WT');
Dir3=RestrictPathForExperiment(Dir1,'Group','dKO');

% ----------------------------------------------------------------------------------------------------------------
% souris Sommeil Deprivation et apprentissage

Dir1=PathForExperimentsMLnew('Spikes');  % souris basal avec des spikes INCLUS les souris de Gaetan


% ----------------------------------------------------------------------------------------------------------------

% Dir1=PathForExperimentsMLnew('BASAL');  % souris basal
% 'BASAL'    % une semaine de basal qui ne sont pas procéssées !!!!!!!!!!
% 'BASAL-night'
% 'SD6h'
% 'SD6h-NextDAY'
% 'SD24h'
% 'SD24h-night'
% 'SD24h-NextDAY'
% 'SD24h-NextDAY-night'
% 'OR' % object recognition
% 

% ----------------------------------------------------------------------------------------------------------------
% Cas des privations
%[Dir,nameSessions]=NREMstages_path(NamePath)
% NamePath= 'SD6h' or 'SD24h' or 'OR'
% format du Dir
% ----------------------------------------------------------------------------------------------------------------
% Dir{1,1}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160628';%ok
% Dir{1,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160628-night';% tout pourris
% Dir{1,3}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160629';% refait->Run
% Dir{1,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160629-night';
% Dir{1,5}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160630';%ok
% Dir{1,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160630-night';

% Pour SD
% nameSessions{1}='DayBSL';
% nameSessions{2}='nightBSL';
% nameSessions{3}='DayPostSD';
% nameSessions{4}='nightPostSD';
% nameSessions{5}='DaySD+24h';
% nameSessions{6}='nightSD+24h';
    
% Pour object recognition
% nameSessions{1}='DayBSL';
% nameSessions{2}='nightBSL';
% nameSessions{3}='DayORhab';
% nameSessions{4}='nightORhab';
% nameSessions{5}='DayORtest';
% nameSessions{6}='nightORtest';
    


%--------------------------------------------------------------------------------------------------------

% Pour avoir l'heure des enregistrements
% 
% NewtsdZT=GetZT_ML(pwd);
% figure, plot(Range(NewtsdZT,'h'),Data(NewtsdZT)/1E4/3600)
% 1/mean(diff(Range(NewtsdZT,'s')))
% 


%--------------------------------------------------------------------------------------------------------





