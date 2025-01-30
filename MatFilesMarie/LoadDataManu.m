% Load data

% pour Marie
% Permet de loader les donnees importees par Manu
% tu peux copier le code et modifier deb et fin pour obtenir d'autres
% periods d'interet


% copyright (c) 2009 Karim Benchenane 
% This software is released under the GNU GPL
% www.gnu.org/copyleft/gpl.html



params.Fs=781.3232;
params.trialave=0;
params.err=[1,0.05];
params.pad=0;
params.fpass=[8 30];
movingwin=[1,0.01];
params.tapers=[3 5];


lfp1=tsd([1:length(LFP1)]'/params.Fs*10000,LFP1);
lfp2=tsd([1:length(LFP2)]'/params.Fs*10000,LFP2);
lfp3=tsd([1:length(LFP3)]'/params.Fs*10000,LFP3);

% S{1}=tsd(CH1_Temp1_flag1*10000,CH1_Temp1_flag1*10000);
% S{2}=tsd(CH2_Temp1_flag1*10000,CH2_Temp1_flag1*10000);
% S{3}=tsd(CH3_T1_9_flag1*10000,CH3_T1_9_flag1*10000);

S{1}=tsd(CH2_Temp1_flag1*10000,CH2_Temp1_flag1*10000);
S{2}=tsd(CH2_Temp2_flag1*10000,CH2_Temp2_flag1*10000);
S{3}=tsd(CH2_Temp3_flag1*10000,CH2_Temp3_flag1*10000);
S{4}=tsd(CH3_T1_9_flag1*10000,CH3_T1_9_flag1*10000);

S=tsdArray(S);

RE=REPTouch*10000;
SE=SEATouch*10000;
C1=COR1*10000;
C=COR*10000;
I=IC*10000;


deb=-20000;
fin=20000;

Correct1=intervalSet(C1+deb,C1+fin);
Correct=intervalSet(C+deb,C+fin);
InCorrect=intervalSet(I+deb,I+fin);

Sea=intervalSet(SE+deb,SE+fin);
Rep=intervalSet(RE+deb,RE+fin);