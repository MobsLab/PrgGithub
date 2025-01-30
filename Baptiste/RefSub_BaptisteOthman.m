% what you'll have in the intan file for two mice
% amplifier.dat = 64
% auxiliary.dat = 6
% digitalin.dat = 1

% copy the amplifier.xml file from
% /media/nas4/ProjetEmbReact/OthmanBaptiste/ to dossier
% rename the files
system('mv amplifier.dat amplifier-wideband.dat')
movefile('digitalin.dat', 'amplifier-digin.dat');
movefile('auxiliary.dat', 'amplifier-accelero.dat');

% merge the files
system('ndm_mergedat amplifier')

% ref subtract and separate the mice
RefNum1 = 10;
RefNum2 = 35;
RefSubtraction_multi('amplifier.dat',71,2,'M101',[0:31],RefNum1,[64,65,66,70],'M102',[32:63],RefNum2,[67,68,69,70])

% this creates amplifier_M101.dat and amplifier_M102.dat
% create 2 folders, one for mouse 101 and one for mouse 102
% copy into Mouse 101 folder amplifier_M101.dat AND supply.dat
% copy into Mouse 102 folder amplifier_M102.dat AND supply.dat

% tick merge done and ref done in the GUI