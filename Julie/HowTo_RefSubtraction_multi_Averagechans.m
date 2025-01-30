% A faire pour soustraire la moyenne de toutes les voies tetrodes, une fois
% la soustraction de la ref effectuée
% - AllChans=[0:63]; % liste de toutes les voies dans le .dat
% - amplifier_M507.dat correspond au fichier sur lequel effectuer la soustraction
% - SpikeRef correspond au suffixe qui sera ajouté au nom du fichier après soustraction
% - le fichier d'origine gardera son nom et portera le suffixe '_original'
% - TetPFC1 : liste de toutes les voies tetrodes à soustraire -ne pas mettre les mauvaises voies ou les voies bruitées, ça contaminera tout



% cd /media/mobsjunior/DataMOBS59/OptoSleepStim/Mouse458/20161117


% % cd /media/DataMOBS59/OptoSleepStim/Mouse458/20161117
% 
% AllChans=[0:35];
% NumChans=length(AllChans);
% TetPFC1=[0:15 29:31];
% AllChans(TetPFC1+1)=[];
% RefSubtraction_multi_AverageChans('FEAR-MOUSE-458-2016117.dat',NumChans,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
% 

cd /media/DataMOBs62/OptoSleepStim/Mouse459/20161123

AllChans=[0:35];
NumChans=length(AllChans);
TetPFC1=[0:15 29:31];
AllChans(ismember(AllChans,TetPFC1))=[];
RefSubtraction_multi_AverageChans('FEAR-Mouse-459-20161123.dat',NumChans,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);

