% This script makes the pre-processing of the signals from the VLPO-anesthesia experiment
% place you in the folder of the signals to analyse 
% Before beginning Copy in the folder th file amplifier.xml containing the data on the experiment and the terminal functions
% You also need a excel file containing the channels of the signals with their number, name, type

clear all
GetBasicInfoSB

% Name of file - to change
FileName  = 'M645_180620_154927_Isoflurane_125_Stim';
MouseNum = 'M645';
RefChan = 4;



% reference subtraction
RefSubtraction_multi('amplifier.dat',16,1,MouseNum,[0:15],RefChan,[]);

% rename files
system(['mv digitalin.dat ' FileName '-digin.dat'])
system(['mv auxiliary.dat ' FileName '-accelero.dat'])
system(['mv amplifier_' MouseNum '.dat ' FileName '-wideband.dat'])
system(['mv amplifier.xml ' FileName '.xml'])

% merge files
system(['ndm_mergedat ' FileName])

% makr .lfp
system(['ndm_lfp ' FileName])

% make matlab files
SetCurrentSession(FileName)
MakeData_Main_SB
