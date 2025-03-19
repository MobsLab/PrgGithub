% ------------------------------------------------------------
% ------------------------ Mouse 130 -------------------------
% ------------------------------------------------------------

directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');

% ------------------------ Day 1 : 5 seconds------------------
cd([directoryName,'/20140516/ICSS-Mouse-130-16052014'])
load LastResults

MeanFirstPoke_Day1=MeanFirstPoke;
PercReward_Day1=PercReward;
SuccesRule2_Day1=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day1=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day1=IntraSessionPercReward;
IntraSessionSuccesRule2_Day1=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay1 MeanFirstPoke_Day1 PercReward_Day1 SuccesRule2_Day1 IntraSessionMeanFirstPoke_Day1 IntraSessionPercReward_Day1 IntraSessionSuccesRule2_Day1

% ------------------------ Day 2 : 5 seconds------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');
cd([directoryName,'/20140519/ICSS-Mouse-130-19052014'])
load LastResults_5sec

MeanFirstPoke_Day2=MeanFirstPoke;
PercReward_Day2=PercReward;
SuccesRule2_Day2=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day2=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day2=IntraSessionPercReward;
IntraSessionSuccesRule2_Day2=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay1b MeanFirstPoke_Day2 PercReward_Day2 SuccesRule2_Day2 IntraSessionMeanFirstPoke_Day2 IntraSessionPercReward_Day2 IntraSessionSuccesRule2_Day2

clear all
load ResultDay1 
load ResultDay1b
MeanFirstPokeDay1=[MeanFirstPoke_Day1 MeanFirstPoke_Day2];
MeanFirstPoke_Day1=mean(MeanFirstPokeDay1);
PercRewardDay1=[PercReward_Day1 PercReward_Day2];
PercReward_Day1=mean(PercRewardDay1);
SuccesRule2Day1=[SuccesRule2_Day1 SuccesRule2_Day2];
SuccesRule2_Day1=mean(SuccesRule2Day1);
IntraSessionMeanFirstPoke_Day1=[IntraSessionMeanFirstPoke_Day1 IntraSessionMeanFirstPoke_Day2];
IntraSessionPercReward_Day1=[IntraSessionPercReward_Day1 IntraSessionPercReward_Day2];
IntraSessionSuccesRule2_Day1=[IntraSessionSuccesRule2_Day1 IntraSessionSuccesRule2_Day2];

save ResultDay1 MeanFirstPoke_Day1 PercReward_Day1 SuccesRule2_Day1 IntraSessionMeanFirstPoke_Day1 IntraSessionPercReward_Day1 IntraSessionSuccesRule2_Day1


% ------------------------ Day 2 : 1 seconds------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');
cd([directoryName,'/20140519/ICSS-Mouse-130-19052014'])
load LastResults_1sec

MeanFirstPoke_Day2=MeanFirstPoke;
PercReward_Day2=PercReward;
SuccesRule2_Day2=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day2=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day2=IntraSessionPercReward;
IntraSessionSuccesRule2_Day2=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay2 MeanFirstPoke_Day2 PercReward_Day2 SuccesRule2_Day2 IntraSessionMeanFirstPoke_Day2 IntraSessionPercReward_Day2 IntraSessionSuccesRule2_Day2

% ------------------------ Day 2 : 1 seconds------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');
cd([directoryName,'/20140521/ICSS-Mouse-130-21052014'])
load LastResults_1sec

MeanFirstPoke_Day2b=MeanFirstPoke;
PercReward_Day2b=PercReward;
SuccesRule2_Day2b=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day2b=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day2b=IntraSessionPercReward;
IntraSessionSuccesRule2_Day2b=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay2b MeanFirstPoke_Day2b PercReward_Day2b SuccesRule2_Day2b IntraSessionMeanFirstPoke_Day2b IntraSessionPercReward_Day2b IntraSessionSuccesRule2_Day2b

clear all
load ResultDay2 
load ResultDay2b
MeanFirstPokeDay2=[MeanFirstPoke_Day2 MeanFirstPoke_Day2b];
MeanFirstPoke_Day2=mean(MeanFirstPokeDay2);
PercRewardDay2=[PercReward_Day2 PercReward_Day2b];
PercReward_Day2=mean(PercRewardDay2);
SuccesRule2Day2=[SuccesRule2_Day2 SuccesRule2_Day2b];
SuccesRule2_Day2=mean(SuccesRule2Day2);
IntraSessionMeanFirstPoke_Day2=[IntraSessionMeanFirstPoke_Day2 IntraSessionMeanFirstPoke_Day2b];
IntraSessionPercReward_Day2=[IntraSessionPercReward_Day2 IntraSessionPercReward_Day2b];
IntraSessionSuccesRule2_Day2=[IntraSessionSuccesRule2_Day2 IntraSessionSuccesRule2_Day2b];

save ResultDay2 MeanFirstPoke_Day2 PercReward_Day2 SuccesRule2_Day2 IntraSessionMeanFirstPoke_Day2 IntraSessionPercReward_Day2 IntraSessionSuccesRule2_Day2

% ------------------------ Day 3 : 500 msec------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');
cd([directoryName,'/20140522/ICSS-Mouse-130-22052014'])
load LastResults_500ms

MeanFirstPoke_Day3=MeanFirstPoke;
PercReward_Day3=PercReward;
SuccesRule2_Day3=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day3=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day3=IntraSessionPercReward;
IntraSessionSuccesRule2_Day3=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay3 MeanFirstPoke_Day3 PercReward_Day3 SuccesRule2_Day3 IntraSessionMeanFirstPoke_Day3 IntraSessionPercReward_Day3 IntraSessionSuccesRule2_Day3

% ------------------------ Day 4 : 500 msec------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');
cd([directoryName,'/20140603/ICSS-Mouse-130-03062014'])
load LastResults_500ms

MeanFirstPoke_Day4=MeanFirstPoke;
PercReward_Day4=PercReward;
SuccesRule2_Day4=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day4=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day4=IntraSessionPercReward;
IntraSessionSuccesRule2_Day4=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay4 MeanFirstPoke_Day4 PercReward_Day4 SuccesRule2_Day4 IntraSessionMeanFirstPoke_Day4 IntraSessionPercReward_Day4 IntraSessionSuccesRule2_Day4

% ------------------------ Day 5 : 100 msec------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');
cd([directoryName,'/20140605/ICSS-Mouse-130-05062014'])
load LastResults_100ms

MeanFirstPoke_Day5=MeanFirstPoke;
PercReward_Day5=PercReward;
SuccesRule2_Day5=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day5=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day5=IntraSessionPercReward;
IntraSessionSuccesRule2_Day5=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay5 MeanFirstPoke_Day5 PercReward_Day5 SuccesRule2_Day5 IntraSessionMeanFirstPoke_Day5 IntraSessionPercReward_Day5 IntraSessionSuccesRule2_Day5


% ------------------------ Day 7 : Generalization ------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');
cd([directoryName,'/20140610/ICSS-Mouse-130-10062014'])
load LastResults

MeanFirstPoke_Day6=MeanFirstPoke;
PercReward_Day6=PercReward;
SuccesRule2_Day6=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day6=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day6=IntraSessionPercReward;
IntraSessionSuccesRule2_Day6=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay6 MeanFirstPoke_Day6 PercReward_Day6 SuccesRule2_Day6 IntraSessionMeanFirstPoke_Day6 IntraSessionPercReward_Day6 IntraSessionSuccesRule2_Day6

directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');
cd([directoryName])
save ResultGeneralizationM130 MeanFirstPokeGen20kHz MeanFirstPokeGen25kHz MeanFirstPokeGen30kHz PercRewardGen20kHz PercRewardGen25kHz PercRewardGen30kHz

% ------------------------ Day 7 : Generalization ------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');
cd([directoryName,'/20140611/ICSS-Mouse-130-11062014'])
load LastResults

MeanFirstPoke_Day7=MeanFirstPoke;
PercReward_Day7=PercReward;
SuccesRule2_Day7=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day7=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day7=IntraSessionPercReward;
IntraSessionSuccesRule2_Day7=IntraSessionSuccesRule2;

directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');
cd([directoryName])
save ResultDay7 MeanFirstPoke_Day7 PercReward_Day7 SuccesRule2_Day7 IntraSessionMeanFirstPoke_Day7 IntraSessionPercReward_Day7 IntraSessionSuccesRule2_Day7
save ResultGeneralizationM130 -append MeanFirstPokeGen5kHz MeanFirstPokeGen10kHz MeanFirstPokeGen15kHz PercRewardGen5kHz PercRewardGen10kHz PercRewardGen15kHz


clear all
load ResultDay6 
load ResultDay7
MeanFirstPoke_12kHz=[MeanFirstPoke_Day6 MeanFirstPoke_Day7];
MeanFirstPoke_12kHz=mean(MeanFirstPoke_12kHz);
PercReward_12kHz=[PercReward_Day6 PercReward_Day7];
PercReward_12kHz=mean(PercReward_12kHz);


save ResultGeneralizationM130 -append MeanFirstPoke_12kHz PercReward_12kHz

% ------------------------------------------------------------
% ------------------------------------------------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');
cd([directoryName])

load ResultDay1
load ResultDay2
load ResultDay3
load ResultDay4
load ResultDay5
load ResultDay6
load ResultDay7
load ResultGeneralization
MeanFirstPokeM130=[MeanFirstPoke_Day1 MeanFirstPoke_Day2 MeanFirstPoke_Day3 MeanFirstPoke_Day4 MeanFirstPoke_Day5 MeanFirstPoke_Day6 MeanFirstPoke_Day7];
PercRewardM130=[PercReward_Day1;PercReward_Day2;PercReward_Day3;PercReward_Day4;PercReward_Day5;PercReward_Day6;PercReward_Day7];
SuccesRule2M130=[SuccesRule2_Day1;SuccesRule2_Day2;SuccesRule2_Day3;SuccesRule2_Day4;SuccesRule2_Day5;SuccesRule2_Day6;SuccesRule2_Day7];

BeforeSucessPercM130=[BeforeSucessPerc_Day1;BeforeSucessPerc_Day2;BeforeSucessPerc_Day3;BeforeSucessPerc_Day4;BeforeSucessPerc_Day5;BeforeSucessPerc_Day6;BeforeSucessPerc_Day7];
IntraSessionFirstPokeM130=[IntraSessionFirstPoke_Day1;IntraSessionFirstPoke_Day2;IntraSessionFirstPoke_Day3;IntraSessionFirstPoke_Day4;IntraSessionFirstPoke_Day5;IntraSessionFirstPoke_Day6;IntraSessionFirstPoke_Day7];
IntraSessionPercM130=[IntraSessionPerc_Day1;IntraSessionPerc_Day2;IntraSessionPerc_Day3;IntraSessionPerc_Day4;IntraSessionPerc_Day5;IntraSessionPerc_Day6;IntraSessionPerc_Day7];
IntraSessionRule2M130=[IntraSessionRule2_Day1;IntraSessionRule2_Day2;IntraSessionRule2_Day3;IntraSessionRule2_Day4;IntraSessionRule2_Day5;IntraSessionRule2_Day6;IntraSessionRule2_Day7];

directoryName=('/media/DataMOBsG/AttentionalNosePoke');
cd([directoryName])
save M130 MeanFirstPokeM130 PercRewardM130 SuccesRule2M130 BeforeSucessPercM130 IntraSessionFirstPokeM130 IntraSessionPercM130 IntraSessionRule2M130

% ------------------------------------------------------------
% ------------------------ Mouse 133 -------------------------
% ------------------------------------------------------------

directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');

% ------------------------ Day 1 : 5 seconds------------------
cd([directoryName,'/20140516/ICSS-Mouse-133-16052014'])
load LastResults

MeanFirstPoke_Day1=MeanFirstPoke;
PercReward_Day1=PercReward;
SuccesRule2_Day1=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day1=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day1=IntraSessionPercReward;
IntraSessionSuccesRule2_Day1=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay1 MeanFirstPoke_Day1 PercReward_Day1 SuccesRule2_Day1 IntraSessionMeanFirstPoke_Day1 IntraSessionPercReward_Day1 IntraSessionSuccesRule2_Day1

% ------------------------ Day 2 : 5 seconds------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');
cd([directoryName,'/20140519/ICSS-Mouse-133-19052014'])
load LastResults_5sec

MeanFirstPoke_Day2=MeanFirstPoke;
PercReward_Day2=PercReward;
SuccesRule2_Day2=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day2=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day2=IntraSessionPercReward;
IntraSessionSuccesRule2_Day2=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay1b MeanFirstPoke_Day2 PercReward_Day2 SuccesRule2_Day2 IntraSessionMeanFirstPoke_Day2 IntraSessionPercReward_Day2 IntraSessionSuccesRule2_Day2

clear all
load ResultDay1 
load ResultDay1b
MeanFirstPokeDay1=[MeanFirstPoke_Day1 MeanFirstPoke_Day2];
MeanFirstPoke_Day1=mean(MeanFirstPokeDay1);
PercRewardDay1=[PercReward_Day1 PercReward_Day2];
PercReward_Day1=mean(PercRewardDay1);
SuccesRule2Day1=[SuccesRule2_Day1 SuccesRule2_Day2];
SuccesRule2_Day1=mean(SuccesRule2Day1);
IntraSessionMeanFirstPoke_Day1=[IntraSessionMeanFirstPoke_Day1 IntraSessionMeanFirstPoke_Day2];
IntraSessionPercReward_Day1=[IntraSessionPercReward_Day1 IntraSessionPercReward_Day2];
IntraSessionSuccesRule2_Day1=[IntraSessionSuccesRule2_Day1 IntraSessionSuccesRule2_Day2];

save ResultDay1 MeanFirstPoke_Day1 PercReward_Day1 SuccesRule2_Day1 IntraSessionMeanFirstPoke_Day1 IntraSessionPercReward_Day1 IntraSessionSuccesRule2_Day1


% ------------------------ Day 2 : 1 seconds------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');
cd([directoryName,'/20140519/ICSS-Mouse-133-19052014'])
load LastResults_1sec

MeanFirstPoke_Day2=MeanFirstPoke;
PercReward_Day2=PercReward;
SuccesRule2_Day2=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day2=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day2=IntraSessionPercReward;
IntraSessionSuccesRule2_Day2=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay2 MeanFirstPoke_Day2 PercReward_Day2 SuccesRule2_Day2 IntraSessionMeanFirstPoke_Day2 IntraSessionPercReward_Day2 IntraSessionSuccesRule2_Day2

% ------------------------ Day 2 : 1 seconds------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');
cd([directoryName,'/20140521/ICSS-Mouse-133-21052014'])
load LastResults_1sec

MeanFirstPoke_Day2b=MeanFirstPoke;
PercReward_Day2b=PercReward;
SuccesRule2_Day2b=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day2b=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day2b=IntraSessionPercReward;
IntraSessionSuccesRule2_Day2b=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay2b MeanFirstPoke_Day2b PercReward_Day2b SuccesRule2_Day2b IntraSessionMeanFirstPoke_Day2b IntraSessionPercReward_Day2b IntraSessionSuccesRule2_Day2b

clear all
load ResultDay2 
load ResultDay2b
MeanFirstPokeDay2=[MeanFirstPoke_Day2 MeanFirstPoke_Day2b];
MeanFirstPoke_Day2=mean(MeanFirstPokeDay2);
PercRewardDay2=[PercReward_Day2 PercReward_Day2b];
PercReward_Day2=mean(PercRewardDay2);
SuccesRule2Day2=[SuccesRule2_Day2 SuccesRule2_Day2b];
SuccesRule2_Day2=mean(SuccesRule2Day2);
IntraSessionMeanFirstPoke_Day2=[IntraSessionMeanFirstPoke_Day2 IntraSessionMeanFirstPoke_Day2b];
IntraSessionPercReward_Day2=[IntraSessionPercReward_Day2 IntraSessionPercReward_Day2b];
IntraSessionSuccesRule2_Day2=[IntraSessionSuccesRule2_Day2 IntraSessionSuccesRule2_Day2b];

save ResultDay2 MeanFirstPoke_Day2 PercReward_Day2 SuccesRule2_Day2 IntraSessionMeanFirstPoke_Day2 IntraSessionPercReward_Day2 IntraSessionSuccesRule2_Day2

% ------------------------ Day 3 : 500 msec------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');
cd([directoryName,'/20140522/ICSS-Mouse-133-22052014'])
load LastResults_500ms

MeanFirstPoke_Day3=MeanFirstPoke;
PercReward_Day3=PercReward;
SuccesRule2_Day3=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day3=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day3=IntraSessionPercReward;
IntraSessionSuccesRule2_Day3=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay3 MeanFirstPoke_Day3 PercReward_Day3 SuccesRule2_Day3 IntraSessionMeanFirstPoke_Day3 IntraSessionPercReward_Day3 IntraSessionSuccesRule2_Day3

% ------------------------ Day 4 : 500 msec------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');
cd([directoryName,'/20140603/ICSS-Mouse-133-03062014'])
load LastResults_500ms

MeanFirstPoke_Day4=MeanFirstPoke;
PercReward_Day4=PercReward;
SuccesRule2_Day4=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day4=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day4=IntraSessionPercReward;
IntraSessionSuccesRule2_Day4=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay4 MeanFirstPoke_Day4 PercReward_Day4 SuccesRule2_Day4 IntraSessionMeanFirstPoke_Day4 IntraSessionPercReward_Day4 IntraSessionSuccesRule2_Day4

% ------------------------ Day 5 : 100 msec------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');
cd([directoryName,'/20140605/ICSS-Mouse-133-05062014'])
load LastResults_100ms

MeanFirstPoke_Day5=MeanFirstPoke;
PercReward_Day5=PercReward;
SuccesRule2_Day5=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day5=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day5=IntraSessionPercReward;
IntraSessionSuccesRule2_Day5=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay5 MeanFirstPoke_Day5 PercReward_Day5 SuccesRule2_Day5 IntraSessionMeanFirstPoke_Day5 IntraSessionPercReward_Day5 IntraSessionSuccesRule2_Day5


% ------------------------ Day 7 : Generalization ------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');
cd([directoryName,'/20140610/ICSS-Mouse-133-10062014'])
load LastResults

MeanFirstPoke_Day6=MeanFirstPoke;
PercReward_Day6=PercReward;
SuccesRule2_Day6=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day6=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day6=IntraSessionPercReward;
IntraSessionSuccesRule2_Day6=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay6 MeanFirstPoke_Day6 PercReward_Day6 SuccesRule2_Day6 IntraSessionMeanFirstPoke_Day6 IntraSessionPercReward_Day6 IntraSessionSuccesRule2_Day6
save ResultGeneralizationM133 MeanFirstPokeGen20kHz MeanFirstPokeGen25kHz MeanFirstPokeGen30kHz PercRewardGen20kHz PercRewardGen25kHz PercRewardGen30kHz

% ------------------------ Day 7 : Generalization ------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');
cd([directoryName,'/20140611/ICSS-Mouse-133-11062014'])
load LastResults

MeanFirstPoke_Day7=MeanFirstPoke;
PercReward_Day7=PercReward;
SuccesRule2_Day7=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day7=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day7=IntraSessionPercReward;
IntraSessionSuccesRule2_Day7=IntraSessionSuccesRule2;

directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');
cd([directoryName])
save ResultDay7 MeanFirstPoke_Day7 PercReward_Day7 SuccesRule2_Day7 IntraSessionMeanFirstPoke_Day7 IntraSessionPercReward_Day7 IntraSessionSuccesRule2_Day7
save ResultGeneralizationM133 -append MeanFirstPokeGen5kHz MeanFirstPokeGen10kHz MeanFirstPokeGen15kHz PercRewardGen5kHz PercRewardGen10kHz PercRewardGen15kHz

load ResultDay6 
load ResultDay7
MeanFirstPoke_12kHz=[MeanFirstPoke_Day6 MeanFirstPoke_Day7];
MeanFirstPoke_12kHz=mean(MeanFirstPoke_12kHz);
PercReward_12kHz=[PercReward_Day6 PercReward_Day7];
PercReward_12kHz=mean(PercReward_12kHz);

save ResultGeneralizationM133 -append MeanFirstPoke_12kHz PercReward_12kHz

% ------------------------------------------------------------
% ------------------------------------------------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');
cd([directoryName])

load ResultDay1
load ResultDay2
load ResultDay3
load ResultDay4
load ResultDay5
load ResultDay6
load ResultDay7
load ResultGeneralization
MeanFirstPokeM133=[MeanFirstPoke_Day1 MeanFirstPoke_Day2 MeanFirstPoke_Day3 MeanFirstPoke_Day4 MeanFirstPoke_Day5 MeanFirstPoke_Day6 MeanFirstPoke_Day7];
PercRewardM133=[PercReward_Day1;PercReward_Day2;PercReward_Day3;PercReward_Day4;PercReward_Day5;PercReward_Day6;PercReward_Day7];
SuccesRule2M133=[SuccesRule2_Day1;SuccesRule2_Day2;SuccesRule2_Day3;SuccesRule2_Day4;SuccesRule2_Day5;SuccesRule2_Day6;SuccesRule2_Day7];

BeforeSucessPercM133=[BeforeSucessPerc_Day1;BeforeSucessPerc_Day2;BeforeSucessPerc_Day3;BeforeSucessPerc_Day4;BeforeSucessPerc_Day5;BeforeSucessPerc_Day6;BeforeSucessPerc_Day7];
IntraSessionFirstPokeM133=[IntraSessionFirstPoke_Day1;IntraSessionFirstPoke_Day2;IntraSessionFirstPoke_Day3;IntraSessionFirstPoke_Day4;IntraSessionFirstPoke_Day5;IntraSessionFirstPoke_Day6;IntraSessionFirstPoke_Day7];
IntraSessionPercM133=[IntraSessionPerc_Day1;IntraSessionPerc_Day2;IntraSessionPerc_Day3;IntraSessionPerc_Day4;IntraSessionPerc_Day5;IntraSessionPerc_Day6;IntraSessionPerc_Day7];
IntraSessionRule2M133=[IntraSessionRule2_Day1;IntraSessionRule2_Day2;IntraSessionRule2_Day3;IntraSessionRule2_Day4;IntraSessionRule2_Day5;IntraSessionRule2_Day6;IntraSessionRule2_Day7];

directoryName=('/media/DataMOBsG/AttentionalNosePoke');
cd([directoryName])
save M133 MeanFirstPokeM133 PercRewardM133 SuccesRule2M133 BeforeSucessPercM133 IntraSessionFirstPokeM133 IntraSessionPercM133 IntraSessionRule2M133

% ------------------------------------------------------------
% ------------------------ Mouse 142 -------------------------
% ------------------------------------------------------------

directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse142');

% ------------------------ Day 1 : 5 seconds------------------
cd([directoryName,'/20140722/ICSS-Mouse-142-22072014'])
load LastResults

MeanFirstPoke_Day1=MeanFirstPoke;
PercReward_Day1=PercReward;
SuccesRule2_Day1=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day1=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day1=IntraSessionPercReward;
IntraSessionSuccesRule2_Day1=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay1 MeanFirstPoke_Day1 PercReward_Day1 SuccesRule2_Day1 IntraSessionMeanFirstPoke_Day1 IntraSessionPercReward_Day1 IntraSessionSuccesRule2_Day1

% ------------------------ Day 2 : 1 seconds------------------
cd([directoryName,'/20140723/ICSS-Mouse-142-23072014'])
load LastResults

MeanFirstPoke_Day2=MeanFirstPoke;
PercReward_Day2=PercReward;
SuccesRule2_Day2=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day2=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day2=IntraSessionPercReward;
IntraSessionSuccesRule2_Day2=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay2 MeanFirstPoke_Day2 PercReward_Day2 SuccesRule2_Day2 IntraSessionMeanFirstPoke_Day2 IntraSessionPercReward_Day2 IntraSessionSuccesRule2_Day2

% ------------------------ Day 3 : 500 msec------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse142');
cd([directoryName,'/20140826/MMN-Mouse-142-26082014'])
load LastResults_500ms

MeanFirstPoke_Day3=MeanFirstPoke;
PercReward_Day3=PercReward;
SuccesRule2_Day3=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day3=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day3=IntraSessionPercReward;
IntraSessionSuccesRule2_Day3=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay3 MeanFirstPoke_Day3 PercReward_Day3 SuccesRule2_Day3 IntraSessionMeanFirstPoke_Day3 IntraSessionPercReward_Day3 IntraSessionSuccesRule2_Day3


% ------------------------ Day 5 : 100 msec------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse142');
cd([directoryName,'/20140826/MMN-Mouse-142-26082014'])
load LastResults_200ms

MeanFirstPoke_Day4=MeanFirstPoke;
PercReward_Day4=PercReward;
SuccesRule2_Day4=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day4=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day4=IntraSessionPercReward;
IntraSessionSuccesRule2_Day4=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay4 MeanFirstPoke_Day4 PercReward_Day4 SuccesRule2_Day4 IntraSessionMeanFirstPoke_Day4 IntraSessionPercReward_Day4 IntraSessionSuccesRule2_Day4


% ------------------------ Day 6 : Generalization ------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse142');
cd([directoryName,'/20140827/MMN-Mouse-142-27082014'])
load LastResults

MeanFirstPoke_Day5=MeanFirstPoke;
PercReward_Day5=PercReward;
SuccesRule2_Day5=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day5=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day5=IntraSessionPercReward;
IntraSessionSuccesRule2_Day5=IntraSessionSuccesRule2;

MeanFirstPoke_12kHz=MeanFirstPoke_Day5;
PercReward_12kHz=PercReward_Day5;


cd([directoryName])
save ResultDay5 MeanFirstPoke_Day5 PercReward_Day5 SuccesRule2_Day5 IntraSessionMeanFirstPoke_Day5 IntraSessionPercReward_Day5 IntraSessionSuccesRule2_Day5
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse142');
cd([directoryName])
save ResultGeneralizationM142 MeanFirstPokeGen20kHz MeanFirstPokeGen25kHz MeanFirstPokeGen30kHz PercRewardGen20kHz PercRewardGen25kHz PercRewardGen30kHz
save ResultGeneralizationM142 -append MeanFirstPokeGen5kHz MeanFirstPokeGen10kHz MeanFirstPokeGen15kHz PercRewardGen5kHz PercRewardGen10kHz PercRewardGen15kHz
save ResultGeneralizationM142 -append MeanFirstPoke_12kHz PercReward_12kHz

% ------------------------------------------------------------
% ------------------------------------------------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse142');
cd([directoryName])

load ResultDay1
load ResultDay2
load ResultDay3
load ResultDay4
load ResultDay5
load ResultGeneralization
MeanFirstPokeM142=[MeanFirstPoke_Day1 MeanFirstPoke_Day2 MeanFirstPoke_Day3 MeanFirstPoke_Day4 MeanFirstPoke_Day5];
PercRewardM142=[PercReward_Day1;PercReward_Day2;PercReward_Day3;PercReward_Day4;PercReward_Day5];
SuccesRule2M142=[SuccesRule2_Day1;SuccesRule2_Day2;SuccesRule2_Day3;SuccesRule2_Day4;SuccesRule2_Day5];

BeforeSucessPercM142=[BeforeSucessPerc_Day1;BeforeSucessPerc_Day2;BeforeSucessPerc_Day3;BeforeSucessPerc_Day4;BeforeSucessPerc_Day5];
IntraSessionFirstPokeM142=[IntraSessionFirstPoke_Day1;IntraSessionFirstPoke_Day2;IntraSessionFirstPoke_Day3;IntraSessionFirstPoke_Day4;IntraSessionFirstPoke_Day5];
IntraSessionPercM142=[IntraSessionPerc_Day1;IntraSessionPerc_Day2;IntraSessionPerc_Day3;IntraSessionPerc_Day4;IntraSessionPerc_Day5];
IntraSessionRule2M142=[IntraSessionRule2_Day1;IntraSessionRule2_Day2;IntraSessionRule2_Day3;IntraSessionRule2_Day4;IntraSessionRule2_Day5];

directoryName=('/media/DataMOBsG/AttentionalNosePoke');
cd([directoryName])
save M142 MeanFirstPokeM142 PercRewardM142 SuccesRule2M142 BeforeSucessPercM142 IntraSessionFirstPokeM142 IntraSessionPercM142 IntraSessionRule2M142


% ------------------------------------------------------------
% ------------------------ Mouse 143 -------------------------
% ------------------------------------------------------------

directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse143');

% ------------------------ Day 1 : 5 seconds------------------
cd([directoryName,'/20140722/ICSS-Mouse-143-22072014'])
load LastResults

MeanFirstPoke_Day1=MeanFirstPoke;
PercReward_Day1=PercReward;
SuccesRule2_Day1=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day1=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day1=IntraSessionPercReward;
IntraSessionSuccesRule2_Day1=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay1 MeanFirstPoke_Day1 PercReward_Day1 SuccesRule2_Day1 IntraSessionMeanFirstPoke_Day1 IntraSessionPercReward_Day1 IntraSessionSuccesRule2_Day1

% ------------------------ Day 2 : 1 seconds------------------
cd([directoryName,'/20140723_old/ICSS-Mouse-143-23072014'])
load LastResults

MeanFirstPoke_Day2=MeanFirstPoke;
PercReward_Day2=PercReward;
SuccesRule2_Day2=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day2=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day2=IntraSessionPercReward;
IntraSessionSuccesRule2_Day2=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay2 MeanFirstPoke_Day2 PercReward_Day2 SuccesRule2_Day2 IntraSessionMeanFirstPoke_Day2 IntraSessionPercReward_Day2 IntraSessionSuccesRule2_Day2

% ------------------------ Day 3 : 500 msec------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse143');
cd([directoryName,'/20140826/MMN-Mouse-143-26082014'])
load LastResults_500ms

MeanFirstPoke_Day3=MeanFirstPoke;
PercReward_Day3=PercReward;
SuccesRule2_Day3=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day3=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day3=IntraSessionPercReward;
IntraSessionSuccesRule2_Day3=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay3 MeanFirstPoke_Day3 PercReward_Day3 SuccesRule2_Day3 IntraSessionMeanFirstPoke_Day3 IntraSessionPercReward_Day3 IntraSessionSuccesRule2_Day3


% ------------------------ Day 5 : 100 msec------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse143');
cd([directoryName,'/20140826/MMN-Mouse-143-26082014'])
load LastResults_200ms

MeanFirstPoke_Day4=MeanFirstPoke;
PercReward_Day4=PercReward;
SuccesRule2_Day4=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day4=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day4=IntraSessionPercReward;
IntraSessionSuccesRule2_Day4=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay4 MeanFirstPoke_Day4 PercReward_Day4 SuccesRule2_Day4 IntraSessionMeanFirstPoke_Day4 IntraSessionPercReward_Day4 IntraSessionSuccesRule2_Day4


% ------------------------ Day 6 : Generalization ------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse143');
cd([directoryName,'/20140828/MMN-Mouse-143-28082014'])
load LastResults

MeanFirstPoke_Day5=MeanFirstPoke;
PercReward_Day5=PercReward;
SuccesRule2_Day5=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day5=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day5=IntraSessionPercReward;
IntraSessionSuccesRule2_Day5=IntraSessionSuccesRule2;

MeanFirstPoke_12kHz=MeanFirstPoke_Day5;
PercReward_12kHz=PercReward_Day5;


cd([directoryName])
save ResultDay5 MeanFirstPoke_Day5 PercReward_Day5 SuccesRule2_Day5 IntraSessionMeanFirstPoke_Day5 IntraSessionPercReward_Day5 IntraSessionSuccesRule2_Day5

directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse143');
cd([directoryName])
save ResultGeneralizationM143 MeanFirstPokeGen20kHz MeanFirstPokeGen25kHz MeanFirstPokeGen30kHz PercRewardGen20kHz PercRewardGen25kHz PercRewardGen30kHz
save ResultGeneralizationM143 -append MeanFirstPokeGen5kHz MeanFirstPokeGen10kHz MeanFirstPokeGen15kHz PercRewardGen5kHz PercRewardGen10kHz PercRewardGen15kHz
save ResultGeneralizationM143 -append MeanFirstPoke_12kHz PercReward_12kHz


% ------------------------------------------------------------
% ------------------------------------------------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse143');
cd([directoryName])

load ResultDay1
load ResultDay2
load ResultDay3
load ResultDay4
load ResultDay5
load ResultGeneralization
MeanFirstPokeM143=[MeanFirstPoke_Day1 MeanFirstPoke_Day2 MeanFirstPoke_Day3 MeanFirstPoke_Day4 MeanFirstPoke_Day5];
PercRewardM143=[PercReward_Day1;PercReward_Day2;PercReward_Day3;PercReward_Day4;PercReward_Day5];
SuccesRule2M143=[SuccesRule2_Day1;SuccesRule2_Day2;SuccesRule2_Day3;SuccesRule2_Day4;SuccesRule2_Day5];

BeforeSucessPercM143=[BeforeSucessPerc_Day1;BeforeSucessPerc_Day2;BeforeSucessPerc_Day3;BeforeSucessPerc_Day4;BeforeSucessPerc_Day5];
IntraSessionFirstPokeM143=[IntraSessionFirstPoke_Day1;IntraSessionFirstPoke_Day2;IntraSessionFirstPoke_Day3;IntraSessionFirstPoke_Day4;IntraSessionFirstPoke_Day5];
IntraSessionPercM143=[IntraSessionPerc_Day1;IntraSessionPerc_Day2;IntraSessionPerc_Day3;IntraSessionPerc_Day4;IntraSessionPerc_Day5];
IntraSessionRule2M143=[IntraSessionRule2_Day1;IntraSessionRule2_Day2;IntraSessionRule2_Day3;IntraSessionRule2_Day4;IntraSessionRule2_Day5];

directoryName=('/media/DataMOBsG/AttentionalNosePoke');
cd([directoryName])
save M143 MeanFirstPokeM143 PercRewardM143 SuccesRule2M143 BeforeSucessPercM143 IntraSessionFirstPokeM143 IntraSessionPercM143 IntraSessionRule2M143

% ------------------------------------------------------------
% ------------------------ Mouse 151 -------------------------
% ------------------------------------------------------------

directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse151');

% ------------------------ Day 1 : 5 seconds------------------
cd([directoryName,'/20140902/MMN-Mouse-151-02092014'])
load LastResults

MeanFirstPoke_Day1=MeanFirstPoke;
PercReward_Day1=PercReward;
SuccesRule2_Day1=RdmSuccesRule2;
IntraSessionMeanFirstPoke_Day1=IntraSessionMeanFirstPoke;
IntraSessionPercReward_Day1=IntraSessionPercReward;
IntraSessionSuccesRule2_Day1=IntraSessionSuccesRule2;

cd([directoryName])
save ResultDay1 MeanFirstPoke_Day1 PercReward_Day1 SuccesRule2_Day1 IntraSessionMeanFirstPoke_Day1 IntraSessionPercReward_Day1 IntraSessionSuccesRule2_Day1


% ------------------------------------------------------------
% ------------------------------------------------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');
cd([directoryName])
load ResultGeneralizationM130
MeanFirstPoke_5kHz_M130=MeanFirstPokeGen5kHz;
MeanFirstPoke_10kHz_M130=MeanFirstPokeGen10kHz;
MeanFirstPoke_12kHz_M130=MeanFirstPoke_12kHz;
MeanFirstPoke_15kHz_M130=MeanFirstPokeGen15kHz;
MeanFirstPoke_20kHz_M130=MeanFirstPokeGen20kHz;
MeanFirstPoke_25kHz_M130=MeanFirstPokeGen25kHz;
MeanFirstPoke_30kHz_M130=MeanFirstPokeGen30kHz;
PercReward_5kHz_M130=PercRewardGen5kHz;
PercReward_10kHz_M130=PercRewardGen10kHz;
PercReward_12kHz_M130=PercReward_12kHz;
PercReward_15kHz_M130=PercRewardGen15kHz;
PercReward_20kHz_M130=PercRewardGen20kHz;
PercReward_25kHz_M130=PercRewardGen25kHz;
PercReward_30kHz_M130=PercRewardGen30kHz;

directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');
cd([directoryName])
load ResultGeneralizationM133
MeanFirstPoke_5kHz_M133=MeanFirstPokeGen5kHz;
MeanFirstPoke_10kHz_M133=MeanFirstPokeGen10kHz;
MeanFirstPoke_12kHz_M133=MeanFirstPoke_12kHz;
MeanFirstPoke_15kHz_M133=MeanFirstPokeGen15kHz;
MeanFirstPoke_20kHz_M133=MeanFirstPokeGen20kHz;
MeanFirstPoke_25kHz_M133=MeanFirstPokeGen25kHz;
MeanFirstPoke_30kHz_M133=MeanFirstPokeGen30kHz;
PercReward_5kHz_M133=PercRewardGen5kHz;
PercReward_10kHz_M133=PercRewardGen10kHz;
PercReward_12kHz_M133=PercReward_12kHz;
PercReward_15kHz_M133=PercRewardGen15kHz;
PercReward_20kHz_M133=PercRewardGen20kHz;
PercReward_25kHz_M133=PercRewardGen25kHz;
PercReward_30kHz_M133=PercRewardGen30kHz;

directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse142');
cd([directoryName])
load ResultGeneralizationM142
MeanFirstPoke_5kHz_M142=MeanFirstPokeGen5kHz;
MeanFirstPoke_10kHz_M142=MeanFirstPokeGen10kHz;
MeanFirstPoke_12kHz_M142=MeanFirstPoke_12kHz;
MeanFirstPoke_15kHz_M142=MeanFirstPokeGen15kHz;
MeanFirstPoke_20kHz_M142=MeanFirstPokeGen20kHz;
MeanFirstPoke_25kHz_M142=MeanFirstPokeGen25kHz;
MeanFirstPoke_30kHz_M142=MeanFirstPokeGen30kHz;
PercReward_5kHz_M142=PercRewardGen5kHz;
PercReward_10kHz_M142=PercRewardGen10kHz;
PercReward_12kHz_M142=PercReward_12kHz;
PercReward_15kHz_M142=PercRewardGen15kHz;
PercReward_20kHz_M142=PercRewardGen20kHz;
PercReward_25kHz_M142=PercRewardGen25kHz;
PercReward_30kHz_M142=PercRewardGen30kHz;

directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse143');
cd([directoryName])
load ResultGeneralizationM143
MeanFirstPoke_5kHz_M143=MeanFirstPokeGen5kHz;
MeanFirstPoke_10kHz_M143=MeanFirstPokeGen10kHz;
MeanFirstPoke_12kHz_M143=MeanFirstPoke_12kHz;
MeanFirstPoke_15kHz_M143=MeanFirstPokeGen15kHz;
MeanFirstPoke_20kHz_M143=MeanFirstPokeGen20kHz;
MeanFirstPoke_25kHz_M143=MeanFirstPokeGen25kHz;
MeanFirstPoke_30kHz_M143=MeanFirstPokeGen30kHz;
PercReward_5kHz_M143=PercRewardGen5kHz;
PercReward_10kHz_M143=PercRewardGen10kHz;
PercReward_12kHz_M143=PercReward_12kHz;
PercReward_15kHz_M143=PercRewardGen15kHz;
PercReward_20kHz_M143=PercRewardGen20kHz;
PercReward_25kHz_M143=PercRewardGen25kHz;
PercReward_30kHz_M143=PercRewardGen30kHz;


FirstPoke_5kHz=[MeanFirstPoke_5kHz_M130,MeanFirstPoke_5kHz_M133,MeanFirstPoke_5kHz_M142,MeanFirstPoke_5kHz_M143];
eFirstPoke_5kHz=stdError(FirstPoke_5kHz);
mFirstPoke_5kHz=mean(FirstPoke_5kHz);

FirstPoke_10kHz=[MeanFirstPoke_10kHz_M130,MeanFirstPoke_10kHz_M133,MeanFirstPoke_10kHz_M142,MeanFirstPoke_10kHz_M143];
eFirstPoke_10kHz=stdError(FirstPoke_10kHz);
mFirstPoke_10kHz=mean(FirstPoke_10kHz);

FirstPoke_12kHz=[MeanFirstPoke_12kHz_M130,MeanFirstPoke_12kHz_M133,MeanFirstPoke_12kHz_M142,MeanFirstPoke_12kHz_M143];
eFirstPoke_12kHz=stdError(FirstPoke_12kHz);
mFirstPoke_12kHz=mean(FirstPoke_12kHz);

FirstPoke_15kHz=[MeanFirstPoke_15kHz_M130,MeanFirstPoke_15kHz_M133,MeanFirstPoke_15kHz_M142,MeanFirstPoke_15kHz_M143];
eFirstPoke_15kHz=stdError(FirstPoke_15kHz);
mFirstPoke_15kHz=mean(FirstPoke_15kHz);

FirstPoke_20kHz=[MeanFirstPoke_20kHz_M130,MeanFirstPoke_20kHz_M133,MeanFirstPoke_20kHz_M142,MeanFirstPoke_20kHz_M143];
eFirstPoke_20kHz=stdError(FirstPoke_20kHz);
mFirstPoke_20kHz=mean(FirstPoke_20kHz);

FirstPoke_25kHz=[MeanFirstPoke_25kHz_M130,MeanFirstPoke_25kHz_M133,MeanFirstPoke_25kHz_M142,MeanFirstPoke_25kHz_M143];
eFirstPoke_25kHz=stdError(FirstPoke_25kHz);
mFirstPoke_25kHz=mean(FirstPoke_25kHz);

FirstPoke_30kHz=[MeanFirstPoke_30kHz_M130,MeanFirstPoke_30kHz_M133,MeanFirstPoke_30kHz_M142,MeanFirstPoke_30kHz_M143];
eFirstPoke_30kHz=stdError(FirstPoke_30kHz);
mFirstPoke_30kHz=mean(FirstPoke_30kHz);

FirstPokeAll_Gen=[mean(FirstPoke_5kHz),mean(FirstPoke_10kHz),mean(FirstPoke_12kHz),mean(FirstPoke_15kHz),mean(FirstPoke_20kHz),mean(FirstPoke_25kHz),mean(FirstPoke_30kHz)];
eFirstPokeAll_Gen=[eFirstPoke_5kHz,eFirstPoke_10kHz, eFirstPoke_12kHz,eFirstPoke_15kHz,eFirstPoke_20kHz,eFirstPoke_25kHz,eFirstPoke_30kHz];
mFirstPokeAll_Gen=[mFirstPoke_5kHz,mFirstPoke_10kHz,mFirstPoke_12kHz,mFirstPoke_15kHz,mFirstPoke_20kHz,mFirstPoke_25kHz,mFirstPoke_30kHz];

PercReward_5kHz=[PercReward_5kHz_M130,PercReward_5kHz_M133,PercReward_5kHz_M142,PercReward_5kHz_M143];
ePercReward_5kHz=stdError(PercReward_5kHz);
mPercReward_5kHz=mean(PercReward_5kHz);

PercReward_10kHz=[PercReward_10kHz_M130,PercReward_10kHz_M133,PercReward_10kHz_M142,PercReward_10kHz_M143];
ePercReward_10kHz=stdError(PercReward_10kHz);
mPercReward_10kHz=mean(PercReward_10kHz);

PercReward_12kHz=[PercReward_12kHz_M130,PercReward_12kHz_M133,PercReward_12kHz_M142,PercReward_12kHz_M143];
ePercReward_12kHz=stdError(PercReward_12kHz);
mPercReward_12kHz=mean(PercReward_12kHz);

PercReward_15kHz=[PercReward_15kHz_M130,PercReward_15kHz_M133,PercReward_15kHz_M142,PercReward_15kHz_M143];
ePercReward_15kHz=stdError(PercReward_15kHz);
mPercReward_15kHz=mean(PercReward_15kHz);

PercReward_20kHz=[PercReward_20kHz_M130,PercReward_20kHz_M133,PercReward_20kHz_M142,PercReward_20kHz_M143];
ePercReward_20kHz=stdError(PercReward_20kHz);
mPercReward_20kHz=mean(PercReward_20kHz);

PercReward_25kHz=[PercReward_25kHz_M130,PercReward_25kHz_M133,PercReward_25kHz_M142,PercReward_25kHz_M143];
ePercReward_25kHz=stdError(PercReward_25kHz);
mPercReward_25kHz=mean(PercReward_25kHz);

PercReward_30kHz=[PercReward_30kHz_M130,PercReward_30kHz_M133,PercReward_30kHz_M142,PercReward_30kHz_M143];
ePercReward_30kHz=stdError(PercReward_30kHz);
mPercReward_30kHz=mean(PercReward_30kHz);

PercRewardAll_Gen=[mean(PercReward_5kHz),mean(PercReward_10kHz),mean(PercReward_12kHz),mean(PercReward_15kHz),mean(PercReward_20kHz),mean(PercReward_25kHz),mean(PercReward_30kHz)];
ePercRewardAll_Gen=[ePercReward_5kHz,ePercReward_10kHz,ePercReward_12kHz,ePercReward_15kHz,ePercReward_20kHz,ePercReward_25kHz,ePercReward_30kHz];
mPercRewardAll_Gen=[mPercReward_5kHz,mPercReward_10kHz,mPercReward_12kHz,mPercReward_15kHz,mPercReward_20kHz,mPercReward_25kHz,mPercReward_30kHz];

directoryName=('/media/DataMOBsG/AttentionalNosePoke');
cd([directoryName])
save GeneralizationAll FirstPokeAll_Gen eFirstPokeAll_Gen mFirstPokeAll_Gen 
save GeneralizationAll -append PercRewardAll_Gen ePercRewardAll_Gen mPercRewardAll_Gen 

% ------------------------------------------------------------
% ------------------------------------------------------------
% >>>>>>>>>>>>>>>>>>>>>>>>  Figures <<<<<<<<<<<<<<<<<<<<<<<<<<
% ------------------------------------------------------------
% ------------------------------------------------------------

clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke');
cd([directoryName])
load M130; load M133; load M142; load M143; load GeneralizationAll

% ------------------------------------------------------------
FirstPoke_5sec=[MeanFirstPokeM130(1,1); MeanFirstPokeM133(1,1);MeanFirstPokeM142(1,1);MeanFirstPokeM143(1,1)];
eFirstPoke_5sec=stdError(FirstPoke_5sec);
mFirstPoke_5sec=mean(FirstPoke_5sec);

FirstPoke_1sec=[MeanFirstPokeM130(1,2); MeanFirstPokeM133(1,2);MeanFirstPokeM142(1,2);MeanFirstPokeM143(1,2)];
eFirstPoke_1sec=stdError(FirstPoke_1sec);
mFirstPoke_1sec=mean(FirstPoke_1sec);

FirstPoke_500ms=[mean([MeanFirstPokeM130(1,3),MeanFirstPokeM130(1,4)]); mean([MeanFirstPokeM133(1,3),MeanFirstPokeM133(1,4)]);MeanFirstPokeM142(1,3);MeanFirstPokeM143(1,3)];
eFirstPoke_500ms=stdError(FirstPoke_500ms);
mFirstPoke_500ms=mean(FirstPoke_500ms);

FirstPoke_100ms=[MeanFirstPokeM130(1,5); MeanFirstPokeM133(1,5);MeanFirstPokeM142(1,4);MeanFirstPokeM143(1,4)];
eFirstPoke_100ms=stdError(FirstPoke_100ms);
mFirstPoke_100ms=mean(FirstPoke_100ms);

FirstPoke_Gen=[mean([MeanFirstPokeM130(1,6),MeanFirstPokeM130(1,7)]); mean([MeanFirstPokeM133(1,6),MeanFirstPokeM133(1,7)]);MeanFirstPokeM142(1,5);MeanFirstPokeM143(1,5)];
eFirstPoke_Gen=stdError(FirstPoke_Gen);
mFirstPoke_Gen=mean(FirstPoke_Gen);

% ------------------------------------------------------------
PercReward_5sec=[PercRewardM130(1,1); PercRewardM133(1,1);PercRewardM142(1,1);PercRewardM143(1,1)];
ePercReward_5sec=stdError(PercReward_5sec);
mPercReward_5sec=mean(PercReward_5sec);

PercReward_1sec=[PercRewardM130(2,1); PercRewardM133(2,1);PercRewardM142(2,1);PercRewardM143(2,1)];
ePercReward_1sec=stdError(PercReward_1sec);
mPercReward_1sec=mean(PercReward_1sec);

PercReward_500ms=[mean([PercRewardM130(3,1),PercRewardM130(4,1)]); mean([PercRewardM133(3,1),PercRewardM133(4,1)]);PercRewardM142(3,1);PercRewardM143(3,1)];
ePercReward_500ms=stdError(PercReward_500ms);
mPercReward_500ms=mean(PercReward_500ms);

PercReward_100ms=[PercRewardM130(5,1); PercRewardM133(5,1);PercRewardM142(4,1);PercRewardM143(4,1)];
ePercReward_100ms=stdError(PercReward_100ms);
mPercReward_100ms=mean(PercReward_100ms);

PercReward_Gen=[mean([PercRewardM130(6,1),PercRewardM130(7,1)]); mean([PercRewardM133(6,1),PercRewardM133(7,1)]);PercRewardM142(5,1);PercRewardM143(5,1)];
ePercReward_Gen=stdError(PercReward_Gen);
mPercReward_Gen=mean(PercReward_Gen);

% ------------------------------------------------------------
SuccesRule2_5sec=[SuccesRule2M130(1,1); SuccesRule2M133(1,1);SuccesRule2M142(1,1);SuccesRule2M143(1,1)];
eSuccesRule2_5sec=stdError(SuccesRule2_5sec);
mSuccesRule2_5sec=mean(SuccesRule2_5sec);

SuccesRule2_1sec=[SuccesRule2M130(2,1); SuccesRule2M133(2,1);SuccesRule2M142(2,1);SuccesRule2M143(2,1)];
eSuccesRule2_1sec=stdError(SuccesRule2_1sec);
mSuccesRule2_1sec=mean(SuccesRule2_1sec);

SuccesRule2_500ms=[mean([SuccesRule2M130(3,1),SuccesRule2M130(4,1)]); mean([SuccesRule2M133(3,1),SuccesRule2M133(4,1)]);SuccesRule2M142(3,1);SuccesRule2M143(3,1)];
eSuccesRule2_500ms=stdError(SuccesRule2_500ms);
mSuccesRule2_500ms=mean(SuccesRule2_500ms);

SuccesRule2_100ms=[SuccesRule2M130(5,1); SuccesRule2M133(5,1);SuccesRule2M142(4,1);SuccesRule2M143(4,1)];
eSuccesRule2_100ms=stdError(SuccesRule2_100ms);
mSuccesRule2_100ms=mean(SuccesRule2_100ms);

SuccesRule2_Gen=[mean([SuccesRule2M130(6,1),SuccesRule2M130(7,1)]); mean([SuccesRule2M133(6,1),SuccesRule2M133(7,1)]);SuccesRule2M142(5,1);SuccesRule2M143(5,1)];
eSuccesRule2_Gen=stdError(SuccesRule2_Gen);
mSuccesRule2_Gen=mean(SuccesRule2_Gen);

% ------------------------------------------------------------
BeforeSucces_5sec=[BeforeSucessPercM130(1,1); BeforeSucessPercM133(1,1);BeforeSucessPercM142(1,1);BeforeSucessPercM143(1,1)];
eBeforeSucces_5sec=stdError(BeforeSucces_5sec);
mBeforeSucces_5sec=mean(BeforeSucces_5sec);

BeforeSucces_1sec=[BeforeSucessPercM130(2,1); BeforeSucessPercM133(2,1);BeforeSucessPercM142(2,1);BeforeSucessPercM143(2,1)];
eBeforeSucces_1sec=stdError(BeforeSucces_1sec);
mBeforeSucces_1sec=mean(BeforeSucces_1sec);

BeforeSucces_500ms=[mean([BeforeSucessPercM130(3,1),BeforeSucessPercM130(4,1)]); mean([BeforeSucessPercM133(3,1),BeforeSucessPercM133(4,1)]);BeforeSucessPercM142(3,1);BeforeSucessPercM143(3,1)];
eBeforeSucces_500ms=stdError(BeforeSucces_500ms);
mBeforeSucces_500ms=mean(BeforeSucces_500ms);

BeforeSucces_100ms=[BeforeSucessPercM130(5,1); BeforeSucessPercM133(5,1);BeforeSucessPercM142(4,1);BeforeSucessPercM143(4,1)];
eBeforeSucces_100ms=stdError(BeforeSucces_100ms);
mBeforeSucces_100ms=mean(BeforeSucces_100ms);

BeforeSucces_Gen=[mean([BeforeSucessPercM130(6,1),BeforeSucessPercM130(7,1)]); mean([BeforeSucessPercM133(6,1),BeforeSucessPercM133(7,1)]);BeforeSucessPercM142(5,1);BeforeSucessPercM143(5,1)];
eBeforeSucces_Gen=stdError(BeforeSucces_Gen);
mBeforeSucces_Gen=mean(BeforeSucces_Gen);

% ------------------------------------------------------------
FirstPokeAll=[mean(FirstPoke_5sec),mean(FirstPoke_1sec),mean(FirstPoke_500ms),mean(FirstPoke_100ms),mean(FirstPoke_Gen)];
eFirstPokeAll=[eFirstPoke_5sec,eFirstPoke_1sec,eFirstPoke_500ms,eFirstPoke_100ms, eFirstPoke_Gen];
mFirstPokeAll=[mFirstPoke_5sec,mFirstPoke_1sec,mFirstPoke_500ms,mFirstPoke_100ms,mFirstPoke_Gen];

PercRewardAll=[mean(PercReward_5sec),mean(PercReward_1sec),mean(PercReward_500ms),mean(PercReward_100ms),mean(PercReward_Gen)];
ePercRewardAll=[ePercReward_5sec,ePercReward_1sec,ePercReward_500ms,ePercReward_100ms,ePercReward_Gen];
mPercRewardAll=[mPercReward_5sec,mPercReward_1sec,mPercReward_500ms,mPercReward_100ms,mPercReward_Gen];

SuccesRule2All=[mean(SuccesRule2_5sec),mean(SuccesRule2_1sec),mean(SuccesRule2_500ms),mean(SuccesRule2_100ms),mean(SuccesRule2_Gen)];
eSuccesRule2All=[eSuccesRule2_5sec,eSuccesRule2_1sec,eSuccesRule2_500ms,eSuccesRule2_100ms,eSuccesRule2_Gen];
mSuccesRule2All=[mSuccesRule2_5sec,mSuccesRule2_1sec,mSuccesRule2_500ms,mSuccesRule2_100ms,mSuccesRule2_Gen];

BeforeSuccesAll=[mean(BeforeSucces_5sec),mean(BeforeSucces_1sec),mean(BeforeSucces_500ms),mean(BeforeSucces_100ms),mean(BeforeSucces_Gen)];
eBeforeSuccesAll=[eBeforeSucces_5sec,eBeforeSucces_1sec,eBeforeSucces_500ms,eBeforeSucces_100ms, eBeforeSucces_Gen];
mBeforeSuccesAll=[mBeforeSucces_5sec,mBeforeSucces_1sec,mBeforeSucces_500ms,mBeforeSucces_100ms,mBeforeSucces_Gen];

% ------------------------------------------------------------
% ------------------------------------------------------------

figure, 
hold on, subplot(4,1,1)
hold on, bar(FirstPokeAll,'grouped')
hold on, errorbar(mFirstPokeAll,eFirstPokeAll,'k+','linewidth',1)
hold on, title('Mean time to first poke after tone')
ylabel('time (seconds)')
set(gca,'xticklabel',{'5sec','1sec','500ms','100ms','Generalization'},'xtick',1:5)

hold on, subplot(4,1,2)
hold on, bar(PercRewardAll), 
hold on, errorbar(mPercRewardAll,ePercRewardAll,'k+','linewidth',1)
hold on, title('Probability of nose poke within the rewarding-windows')
ylabel('%')
set(gca,'xticklabel',{'5sec','1sec','500ms','100ms','Generalization'},'xtick',1:5)

hold on, subplot(4,1,3)
hold on, bar(SuccesRule2All), 
hold on, errorbar(mSuccesRule2All,eSuccesRule2All,'k+','linewidth',1)
hold on, title('Probability of nose poke within random non rewarding-windows')
ylabel('%')
set(gca,'xticklabel',{'5sec','1sec','500ms','100ms','Generalization'},'xtick',1:5)

hold on, subplot(4,1,4)
hold on, bar(BeforeSuccesAll,'grouped')
hold on, errorbar(mBeforeSuccesAll,eBeforeSuccesAll,'k+','linewidth',1)
hold on, title('Mean number of tone before succeeding the rule')
ylabel('necessary tone #')
set(gca,'xticklabel',{'5sec','1sec','500ms','100ms','Generalization'},'xtick',1:5)


% ------------------------------------------------------------
% ------------------------------------------------------------

figure, 
hold on, subplot(2,1,1)
hold on, bar(FirstPokeAll_Gen,'grouped')
hold on, errorbar(mFirstPokeAll_Gen,eFirstPokeAll_Gen,'k+','linewidth',1)
hold on, title('Mean time to first poke after tone')
ylabel('time (seconds)')
set(gca,'xticklabel',{'5kHz','10kHz','12kHz','15kHz','20kHz','25kHz','30kHz'},'xtick',1:7)

hold on, subplot(2,1,2)
hold on, bar(PercRewardAll_Gen), 
hold on, errorbar(mPercRewardAll_Gen,ePercRewardAll_Gen,'k+','linewidth',1)
hold on, title('Probability of nose poke just after a Generalization Tone')
ylabel('%')
set(gca,'xticklabel',{'5kHz','10kHz','12kHz','15kHz','20kHz','25kHz','30kHz'},'xtick',1:7)


% ------------------------------------------------------------
% ------------------------------------------------------------

IntraSessionPerc_5sec=[IntraSessionPercM130(1,1:2);IntraSessionPercM133(1,1:2);IntraSessionPercM142(1,1:2);IntraSessionPercM143(1,1:2)];
IntraSessionPerc_1sec=[IntraSessionPercM130(2,1:2);IntraSessionPercM133(2,1:2);IntraSessionPercM142(2,1:2);IntraSessionPercM143(2,1:2)];
IntraSessionPerc_500ms=[IntraSessionPercM130(3,1:2);IntraSessionPercM133(3,1:2);IntraSessionPercM142(3,1:2);IntraSessionPercM143(3,1:2)];
IntraSessionPerc_100ms=[IntraSessionPercM130(4,1:2);IntraSessionPercM133(4,1:2);IntraSessionPercM142(4,1:2);IntraSessionPercM143(4,1:2)];
IntraSessionPerc_Gen=[IntraSessionPercM130(5,1:2);IntraSessionPercM133(5,1:2);IntraSessionPercM142(5,1:2);IntraSessionPercM143(5,1:2)];

PlotErrorBar2(IntraSessionPerc_5sec(:,1),IntraSessionPerc_5sec(:,2))
hold on, title('Rule 2 accuracy during 5seconds protocol')
PlotErrorBar2(IntraSessionPerc_1sec(:,1),IntraSessionPerc_1sec(:,2))
hold on, title('Rule 2 accuracy during 1seconds protocol')
PlotErrorBar2(IntraSessionPerc_500ms(:,1),IntraSessionPerc_500ms(:,2))
hold on, title('Rule 2 accuracy during 500ms protocol')
PlotErrorBar2(IntraSessionPerc_100ms(:,1),IntraSessionPerc_100ms(:,2))
hold on, title('Rule 2 accuracy during 100ms protocol')
PlotErrorBar2(IntraSessionPerc_Gen(:,1),IntraSessionPerc_Gen(:,2))
hold on, title('Rule 2 accuracy during generalization protocol')


% ------------------------------------------------------------
% ------------------------------------------------------------

IntraSessionFirstPoke_5sec=[IntraSessionFirstPokeM130(1,1:2);IntraSessionFirstPokeM133(1,1:2);IntraSessionFirstPokeM142(1,1:2);IntraSessionFirstPokeM143(1,1:2)];
IntraSessionFirstPoke_1sec=[IntraSessionFirstPokeM130(2,1:2);IntraSessionFirstPokeM133(2,1:2);IntraSessionFirstPokeM142(2,1:2);IntraSessionFirstPokeM143(2,1:2)];
IntraSessionFirstPoke_500ms=[IntraSessionFirstPokeM130(3,1:2);IntraSessionFirstPokeM133(3,1:2);IntraSessionFirstPokeM142(3,1:2);IntraSessionFirstPokeM143(3,1:2)];
IntraSessionFirstPoke_100ms=[IntraSessionFirstPokeM130(4,1:2);IntraSessionFirstPokeM133(4,1:2);IntraSessionFirstPokeM142(4,1:2);IntraSessionFirstPokeM143(4,1:2)];
IntraSessionFirstPoke_Gen=[IntraSessionFirstPokeM130(5,1:2);IntraSessionFirstPokeM133(5,1:2);IntraSessionFirstPokeM142(5,1:2);IntraSessionFirstPokeM143(5,1:2)];

PlotErrorBar2(IntraSessionFirstPoke_5sec(:,1),IntraSessionFirstPoke_5sec(:,2))
hold on, title('First Poke Time during 5seconds protocol')
PlotErrorBar2(IntraSessionFirstPoke_1sec(:,1),IntraSessionFirstPoke_1sec(:,2))
hold on, title('First Poke Time during 1seconds protocol')
PlotErrorBar2(IntraSessionFirstPoke_500ms(:,1),IntraSessionFirstPoke_500ms(:,2))
hold on, title('First Poke Time during 500ms protocol')
PlotErrorBar2(IntraSessionFirstPoke_100ms(:,1),IntraSessionFirstPoke_100ms(:,2))
hold on, title('First Poke Time during 100ms protocol')
PlotErrorBar2(IntraSessionFirstPoke_Gen(:,1),IntraSessionFirstPoke_Gen(:,2))
hold on, title('First Poke Time during generalization protocol')

% ------------------------------------------------------------
% ------------------------------------------------------------

IntraSessionRule2_5sec=[IntraSessionRule2M130(1,1:2);IntraSessionRule2M133(1,1:2);IntraSessionRule2M142(1,1:2);IntraSessionRule2M143(1,1:2)];
IntraSessionRule2_1sec=[IntraSessionRule2M130(2,1:2);IntraSessionRule2M133(2,1:2);IntraSessionRule2M142(2,1:2);IntraSessionRule2M143(2,1:2)];
IntraSessionRule2_500ms=[IntraSessionRule2M130(3,1:2);IntraSessionRule2M133(3,1:2);IntraSessionRule2M142(3,1:2);IntraSessionRule2M143(3,1:2)];
IntraSessionRule2_100ms=[IntraSessionRule2M130(4,1:2);IntraSessionRule2M133(4,1:2);IntraSessionRule2M142(4,1:2);IntraSessionRule2M143(4,1:2)];
IntraSessionRule2_Gen=[IntraSessionRule2M130(5,1:2);IntraSessionRule2M133(5,1:2);IntraSessionRule2M142(5,1:2);IntraSessionRule2M143(5,1:2)];

PlotErrorBar2(IntraSessionRule2_5sec(:,1),IntraSessionRule2_5sec(:,2))
hold on, title('Rule 2 accuracy during 5seconds protocol')
PlotErrorBar2(IntraSessionRule2_1sec(:,1),IntraSessionRule2_1sec(:,2))
hold on, title('Rule 2 accuracy during 1seconds protocol')
PlotErrorBar2(IntraSessionRule2_500ms(:,1),IntraSessionRule2_500ms(:,2))
hold on, title('Rule 2 accuracy during 500ms protocol')
PlotErrorBar2(IntraSessionRule2_100ms(:,1),IntraSessionRule2_100ms(:,2))
hold on, title('Rule 2 accuracy during 100ms protocol')
PlotErrorBar2(IntraSessionRule2_Gen(:,1),IntraSessionRule2_Gen(:,2))
hold on, title('Rule 2 accuracy during generalization protocol')

% ------------------------------------------------------------
% ------------------------------------------------------------

figure, subplot(5,1,1)
hold on, plot(IntraSessionRule1M130(1,1:3),'k','linewidth',2)
hold on, plot(IntraSessionRule1M133(1,1:3),'r','linewidth',2)
hold on, plot(IntraSessionRule1M142(1,1:3),'g','linewidth',2)
hold on, plot(IntraSessionRule1M143(1,1:3),'b','linewidth',2)
hold on, title('Time Evolution before first poke following the 5sec Rewarding Tone')
ylabel('time (seconds)')
hold on, subplot(5,1,2)
hold on, plot(IntraSessionRule1M130(2,1:3),'k','linewidth',2)
hold on, plot(IntraSessionRule1M133(2,1:3),'r','linewidth',2)
hold on, plot(IntraSessionRule1M142(2,1:3),'g','linewidth',2)
hold on, plot(IntraSessionRule1M143(2,1:3),'b','linewidth',2)
hold on, title('Time Evolution before first poke following the 1sec Rewarding Tone')
ylabel('time (seconds)')
hold on, subplot(5,1,3)
hold on, plot(IntraSessionRule1M130(3,1:3),'k','linewidth',2)
hold on, plot(IntraSessionRule1M133(3,1:3),'r','linewidth',2)
hold on, plot(IntraSessionRule1M142(3,1:3),'g','linewidth',2)
hold on, plot(IntraSessionRule1M143(3,1:3),'b','linewidth',2)
hold on, title('Time Evolution before first poke following the 500ms Rewarding Tone')
ylabel('time (seconds)')
hold on, subplot(5,1,4)
hold on, plot(IntraSessionRule1M130(4,1:3),'k','linewidth',2)
hold on, plot(IntraSessionRule1M133(4,1:3),'r','linewidth',2)
hold on, plot(IntraSessionRule1M142(4,1:3),'g','linewidth',2)
hold on, plot(IntraSessionRule1M143(4,1:3),'b','linewidth',2)
hold on, title('Time Evolution before first poke following the 100ms Rewarding Tone')
ylabel('time (seconds)')
hold on, subplot(5,1,5)
hold on, plot(IntraSessionRule1M130(5,1:3),'k','linewidth',2)
hold on, plot(IntraSessionRule1M133(5,1:3),'r','linewidth',2)
hold on, plot(IntraSessionRule1M142(5,1:3),'g','linewidth',2)
hold on, plot(IntraSessionRule1M143(5,1:3),'b','linewidth',2)
hold on, title('Time Evolution before first poke following the 100ms Rewarding Tone')
ylabel('time (seconds)')















