% List of mice to use for sleep scoring analysis (not all have EMG)
m=1;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M60/20130415/';
chan(m,:)=[1,10,4,13];
m=2;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M82/20130730/';
chan(m,:)=[2,9,10,7];
m=3;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M83/20130729/';
chan(m,:)=[6,10,5,13];
m=4;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M123/LPSD1/';
chan(m,:)=[15,6,4,9];
m=5;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M51/09112012/';
chan(m,:)=[17,9,12,7];
m=6;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M61/20130415/';
chan(m,:)=[7,8,3,4];
m=7;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M147/';
chan(m,:)=[2,13,8,14];
m=8;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M148/20140828/';
chan(m,:)=[4,11,8,14];
m=9;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M243/01042015/';
chan(m,:)=[16,17,26,18];
m=10;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M244/09042015/';
chan(m,:)=[41,48,57,44];
m=11;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M251/21052015/';
chan(m,:)=[12,22,11,25];
m=12;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M252/21052015/';
chan(m,:)=[46,55,62,57];
m=13;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M178/';
chan(m,:)=[26,31,21,NaN];
m=14;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M258/20151112/';
chan(m,:)=[0,7,12,NaN];
m=15;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M259/20151112/';
chan(m,:)=[8,14,10,NaN];

GoodForEMG=[7,8,13,14,15,16];

% Some simple info
for file=1:m
    cd(filename2{file})
    load('StateEpochSB.mat','SWSEpoch','REMEpoch','Wake')
    TotalLength(file)=max([max(Stop(SWSEpoch)),max(Stop(REMEpoch)),max(Stop(Wake))]);
    SleepDur(file)=sum(Stop(SWSEpoch)-Start(SWSEpoch))+sum(Stop(REMEpoch)-Start(REMEpoch));
end

