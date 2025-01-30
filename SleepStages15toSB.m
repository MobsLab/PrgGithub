function SleepStage=SleepStages15toSB(SleepStages)



rg=Range(SleepStages);
SleepSt=Data(SleepStages);
SleepSt(find(Data(SleepStages)==0))=4;
SleepSt(find(Data(SleepStages)==1))=3;
SleepSt(find(Data(SleepStages)==3))=0.5;
SleepSt(find(Data(SleepStages)==4))=1;
SleepSt(find(Data(SleepStages)==5))=1.5;

SleepStage=tsd(rg,SleepSt);


