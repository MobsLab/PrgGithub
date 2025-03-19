
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
IntraSessionRdmSuccesRule2_Day1=IntraSessionSuccesRule2;

divi=length(FirstPoke)/10;
FirstPokeDay1(1)=mean(FirstPoke(1:divi));
for i=2:10
    FirstPokeM130Day1(i)=mean(FirstPoke((i-1)*divi:i*divi));
end

divi=length(TimeTwoTone)/10;
TimeTwoToneDay1(1)=mean(TimeTwoTone(1:divi));
for i=2:10
    TimeTwoToneM130Day1(i)=mean(TimeTwoTone((i-1)*divi:i*divi));
end

% ------------------------ Day 2 : 1 seconds------------------
cd([directoryName,'/20140519/ICSS-Mouse-130-19052014'])
load LastResults5s

MeanFirstPokeDay2a=MeanFirstPoke;
PercRewardDay2a=PercReward;
WildSuccessRule2Day2a=WildSuccesRule2;
RdmSuccesRule2Day2a=RdmSuccesRule2;
LastPokeDay2a=LastPoke;

divi=length(FirstPoke)/10;
FirstPokeM130Day1b(1)=mean(FirstPoke(1:divi));
for i=2:10
    FirstPokeM130Day1b(i)=mean(FirstPoke((i-1)*divi:i*divi));
end

divi=length(TimeTwoTone)/10;
TimeTwoToneM130Day1b(1)=mean(TimeTwoTone(1:divi));
for i=2:10
    TimeTwoToneM130Day1b(i)=mean(TimeTwoTone((i-1)*divi:i*divi));
end

MeanFirstPokeDay1=[MeanFirstPokeDay1 MeanFirstPokeDay2a];MeanFirstPokeDay1=mean(MeanFirstPokeDay1);
PercRewardDay1=[PercRewardDay1 PercRewardDay2a];PercRewardDay1=mean(PercRewardDay1);
WildSuccessRule2Day1=[WildSuccessRule2Day1 WildSuccessRule2Day2a];WildSuccessRule2Day1=mean(WildSuccessRule2Day1);
RdmSuccesRule2Day1=[RdmSuccesRule2Day1 RdmSuccesRule2Day2a];RdmSuccesRule2Day1=mean(RdmSuccesRule2Day1);
LastPokeM130Day1=[LastPokeDay1 LastPokeDay2a];

load LastResults1s

MeanFirstPokeDay2=MeanFirstPoke;
PercRewardDay2=PercReward;
WildSuccessRule2Day2=WildSuccesRule2;
RdmSuccesRule2Day2=RdmSuccesRule2;
LastPokeM130Day2=LastPoke;

divi=length(FirstPoke)/10;
FirstPokeM130Day2(1)=mean(FirstPoke(1:divi));
for i=2:10
    FirstPokeM130Day2(i)=mean(FirstPoke((i-1)*divi:i*divi));
end

divi=length(TimeTwoTone)/10;
TimeTwoToneM130Day1(1)=mean(TimeTwoTone(1:divi));
for i=2:10
    TimeTwoToneM130Day2(i)=mean(TimeTwoTone((i-1)*divi:i*divi));
end


% ------------------------ Day 3 : 500 msec------------------
cd([directoryName,'/20140522/ICSS-Mouse-130-22052014'])
load LastResults

MeanFirstPokeDay3=MeanFirstPoke;
PercRewardDay3=PercReward;
WildSuccessRule2Day3=WildSuccesRule2;
RdmSuccesRule2Day3=RdmSuccesRule2;
LastPokeM130Day3=LastPoke;

divi=length(FirstPoke)/10;
FirstPokM130eDay3(1)=mean(FirstPoke(1:divi));
for i=2:10
    FirstPokeM130Day3(i)=mean(FirstPoke((i-1)*divi:i*divi));
end

divi=length(TimeTwoTone)/10;
TimeTwoToneM130Day3(1)=mean(TimeTwoTone(1:divi));
for i=2:10
    TimeTwoToneM130Day3(i)=mean(TimeTwoTone((i-1)*divi:i*divi));
end
% ------------------------ Day 4 : 500 msec------------------
cd([directoryName,'/20140603/ICSS-Mouse-130-03062014'])
load LastResults

MeanFirstPokeDay4=MeanFirstPoke;
PercRewardDay4=PercReward;
WildSuccessRule2Day4=WildSuccesRule2;
RdmSuccesRule2Day4=RdmSuccesRule2;
LastPokeM130Day4=LastPoke;

divi=length(FirstPoke)/10;
FirstPokeM130Day4(1)=mean(FirstPoke(1:divi));
for i=2:10
    FirstPokeM130Day4(i)=mean(FirstPoke((i-1)*divi:i*divi));
end

divi=length(TimeTwoTone)/10;
TimeTwoToneM130Day4(1)=mean(TimeTwoTone(1:divi));
for i=2:10
    TimeTwoToneM130Day4(i)=mean(TimeTwoTone((i-1)*divi:i*divi));
end
% ------------------------ Day 5 : 100 msec------------------
cd([directoryName,'/20140605/ICSS-Mouse-130-05062014'])
load LastResults

MeanFirstPokeDay5=MeanFirstPoke;
PercRewardDay5=PercReward;
WildSuccessRule2Day5=WildSuccesRule2;
RdmSuccesRule2Day5=RdmSuccesRule2;
LastPokeM130Day5=LastPoke;

divi=length(FirstPoke)/10;
FirstPokeM130Day5(1)=mean(FirstPoke(1:divi));
for i=2:10
    FirstPokeM130Day5(i)=mean(FirstPoke((i-1)*divi:i*divi));
end

divi=length(TimeTwoTone)/10;
TimeTwoToneM130Day5(1)=mean(TimeTwoTone(1:divi));
for i=2:10
    TimeTwoToneM130Day5(i)=mean(TimeTwoTone((i-1)*divi:i*divi));
end
% ------------------------ Day 6 : 100 msec------------------
cd([directoryName,'/20140610/ICSS-Mouse-130-10062014'])
load LastResults

MeanFirstPokeDay6=MeanFirstPoke;
PercRewardDay6=PercReward;
WildSuccessRule2Day6=WildSuccesRule2;
RdmSuccesRule2Day6=RdmSuccesRule2;

MeanFirstPoke20kHzM130=MeanFirstPokeGen1;
PercReward20kHzM130=PercRewardGen1;
MeanFirstPoke25kHzM130=MeanFirstPokeGen2;
PercReward25kHzM130=PercRewardGen2;
MeanFirstPoke30kHzM130=MeanFirstPokeGen3;
PercReward30kHzM130=PercRewardGen3;

LastPokeM130Day6=LastPoke;

divi=length(FirstPoke)/10;
FirstPokeM130Day6(1)=mean(FirstPoke(1:divi));
for i=2:10
    FirstPokeM130Day6(i)=mean(FirstPoke((i-1)*divi:i*divi));
end

divi=length(TimeTwoTone)/10;
TimeTwoToneM130Day6(1)=mean(TimeTwoTone(1:divi));
for i=2:10
    TimeTwoToneM130Day6(i)=mean(TimeTwoTone((i-1)*divi:i*divi));
end

% ------------------------ Day 7 : 100 msec------------------
cd([directoryName,'/20140611/ICSS-Mouse-130-11062014'])
load LastResults

MeanFirstPokeDay7=MeanFirstPoke;
PercRewardDay7=PercReward;
WildSuccessRule2Day7=WildSuccesRule2;
RdmSuccesRule2Day7=RdmSuccesRule2;

MeanFirstPoke5kHzM130=MeanFirstPokeGen1;
PercReward5kHzM130=PercRewardGen1;
MeanFirstPoke10kHzM130=MeanFirstPokeGen2;
PercReward10kHzM130=PercRewardGen2;
MeanFirstPoke15kHzM130=MeanFirstPokeGen3;
PercReward15kHzM130=PercRewardGen3;
LastPokeM130Day7=LastPoke;

divi=length(FirstPoke)/10;
FirstPokeM130Day7(1)=mean(FirstPoke(1:divi));
for i=2:10
    FirstPokeM130Day7(i)=mean(FirstPoke((i-1)*divi:i*divi));
end

divi=length(TimeTwoTone)/10;
TimeTwoToneM130Day7(1)=mean(TimeTwoTone(1:divi));
for i=2:10
    TimeTwoToneM130Day7(i)=mean(TimeTwoTone((i-1)*divi:i*divi));
end

% ------------------------------------------------------------
% ------------------------------------------------------------

directoryName=('/media/DataMOBsG/AttentionalNosePoke/');
cd([directoryName])

MeanFirstPokeM130=[MeanFirstPokeDay1 MeanFirstPokeDay2 MeanFirstPokeDay3 MeanFirstPokeDay4 MeanFirstPokeDay5 MeanFirstPokeDay6 MeanFirstPokeDay7];
PercRewardM130=[PercRewardDay1;PercRewardDay2;PercRewardDay3;PercRewardDay4;PercRewardDay5;PercRewardDay6;PercRewardDay7];
WildSuccessRule2M130=[WildSuccessRule2Day1;WildSuccessRule2Day2;WildSuccessRule2Day3;WildSuccessRule2Day4;WildSuccessRule2Day5;WildSuccessRule2Day6;WildSuccessRule2Day7];
RdmSuccesRule2M130=[RdmSuccesRule2Day1;RdmSuccesRule2Day2;RdmSuccesRule2Day3;RdmSuccesRule2Day4;RdmSuccesRule2Day5;RdmSuccesRule2Day6;RdmSuccesRule2Day7];



% ------------------------------------------------------------
% ------------------------ Mouse 133 -------------------------
% ------------------------------------------------------------

directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');

% ------------------------ Day 1 : 5 seconds------------------
cd([directoryName,'/20140516/ICSS-Mouse-133-16052014'])
load LastResults

MeanFirstPokeDay1=MeanFirstPoke;
PercRewardDay1=PercReward;
WildSuccessRule2Day1=WildSuccesRule2;
RdmSuccesRule2Day1=RdmSuccesRule2;
LastPokeDay1=LastPoke;

divi=length(FirstPoke)/10;
FirstPokeDay1(1)=mean(FirstPoke(1:divi));
for i=2:10
    FirstPokeM133Day1(i)=mean(FirstPoke((i-1)*divi:i*divi));
end

divi=length(TimeTwoTone)/10;
TimeTwoToneDay1(1)=mean(TimeTwoTone(1:divi));
for i=2:10
    TimeTwoToneM133Day1(i)=mean(TimeTwoTone((i-1)*divi:i*divi));
end

% ------------------------ Day 2 : 1 seconds------------------
cd([directoryName,'/20140519/ICSS-Mouse-133-19052014'])
load LastResults5s

MeanFirstPokeDay2a=MeanFirstPoke;
PercRewardDay2a=PercReward;
WildSuccessRule2Day2a=WildSuccesRule2;
RdmSuccesRule2Day2a=RdmSuccesRule2;
LastPokeDay2a=LastPoke;

divi=length(FirstPoke)/10;
FirstPokeM133Day1b(1)=mean(FirstPoke(1:divi));
for i=2:10
    FirstPokeM133Day1b(i)=mean(FirstPoke((i-1)*divi:i*divi));
end

divi=length(TimeTwoTone)/10;
TimeTwoToneM133Day1b(1)=mean(TimeTwoTone(1:divi));
for i=2:10
    TimeTwoToneM133Day1b(i)=mean(TimeTwoTone((i-1)*divi:i*divi));
end

MeanFirstPokeDay1=[MeanFirstPokeDay1 MeanFirstPokeDay2a];MeanFirstPokeDay1=mean(MeanFirstPokeDay1);
PercRewardDay1=[PercRewardDay1 PercRewardDay2a];PercRewardDay1=mean(PercRewardDay1);
WildSuccessRule2Day1=[WildSuccessRule2Day1 WildSuccessRule2Day2a];WildSuccessRule2Day1=mean(WildSuccessRule2Day1);
RdmSuccesRule2Day1=[RdmSuccesRule2Day1 RdmSuccesRule2Day2a];RdmSuccesRule2Day1=mean(RdmSuccesRule2Day1);
LastPokeM133Day1=[LastPokeDay1 LastPokeDay2a];

load LastResults1s

MeanFirstPokeDay2=MeanFirstPoke;
PercRewardDay2=PercReward;
WildSuccessRule2Day2=WildSuccesRule2;
RdmSuccesRule2Day2=RdmSuccesRule2;
LastPokeM133Day2=LastPoke;

divi=length(FirstPoke)/10;
FirstPokeM133Day2(1)=mean(FirstPoke(1:divi));
for i=2:10
    FirstPokeM133Day2(i)=mean(FirstPoke((i-1)*divi:i*divi));
end

divi=length(TimeTwoTone)/10;
TimeTwoToneM133Day1(1)=mean(TimeTwoTone(1:divi));
for i=2:10
    TimeTwoToneM133Day2(i)=mean(TimeTwoTone((i-1)*divi:i*divi));
end


% ------------------------ Day 3 : 500 msec------------------
cd([directoryName,'/20140522/ICSS-Mouse-133-22052014'])
load LastResults

MeanFirstPokeDay3=MeanFirstPoke;
PercRewardDay3=PercReward;
WildSuccessRule2Day3=WildSuccesRule2;
RdmSuccesRule2Day3=RdmSuccesRule2;
LastPokeM133Day3=LastPoke;

divi=length(FirstPoke)/10;
FirstPokM133eDay3(1)=mean(FirstPoke(1:divi));
for i=2:10
    FirstPokeM133Day3(i)=mean(FirstPoke((i-1)*divi:i*divi));
end

divi=length(TimeTwoTone)/10;
TimeTwoToneM133Day3(1)=mean(TimeTwoTone(1:divi));
for i=2:10
    TimeTwoToneM133Day3(i)=mean(TimeTwoTone((i-1)*divi:i*divi));
end
% ------------------------ Day 4 : 500 msec------------------
cd([directoryName,'/20140603/ICSS-Mouse-133-03062014'])
load LastResults

MeanFirstPokeDay4=MeanFirstPoke;
PercRewardDay4=PercReward;
WildSuccessRule2Day4=WildSuccesRule2;
RdmSuccesRule2Day4=RdmSuccesRule2;
LastPokeM133Day4=LastPoke;

divi=length(FirstPoke)/10;
FirstPokeM133Day4(1)=mean(FirstPoke(1:divi));
for i=2:10
    FirstPokeM133Day4(i)=mean(FirstPoke((i-1)*divi:i*divi));
end

divi=length(TimeTwoTone)/10;
TimeTwoToneM133Day4(1)=mean(TimeTwoTone(1:divi));
for i=2:10
    TimeTwoToneM133Day4(i)=mean(TimeTwoTone((i-1)*divi:i*divi));
end
% ------------------------ Day 5 : 100 msec------------------
cd([directoryName,'/20140605/ICSS-Mouse-133-05062014'])
load LastResults

MeanFirstPokeDay5=MeanFirstPoke;
PercRewardDay5=PercReward;
WildSuccessRule2Day5=WildSuccesRule2;
RdmSuccesRule2Day5=RdmSuccesRule2;
LastPokeM133Day5=LastPoke;

divi=length(FirstPoke)/10;
FirstPokeM133Day5(1)=mean(FirstPoke(1:divi));
for i=2:10
    FirstPokeM133Day5(i)=mean(FirstPoke((i-1)*divi:i*divi));
end

divi=length(TimeTwoTone)/10;
TimeTwoToneM133Day5(1)=mean(TimeTwoTone(1:divi));
for i=2:10
    TimeTwoToneM133Day5(i)=mean(TimeTwoTone((i-1)*divi:i*divi));
end
% ------------------------ Day 6 : 100 msec------------------
cd([directoryName,'/20140610/ICSS-Mouse-133-10062014'])
load LastResults

MeanFirstPokeDay6=MeanFirstPoke;
PercRewardDay6=PercReward;
WildSuccessRule2Day6=WildSuccesRule2;
RdmSuccesRule2Day6=RdmSuccesRule2;

MeanFirstPoke20kHzM133=MeanFirstPokeGen1;
PercReward20kHzM133=PercRewardGen1;
MeanFirstPoke25kHzM133=MeanFirstPokeGen2;
PercReward25kHzM133=PercRewardGen2;
MeanFirstPoke30kHzM133=MeanFirstPokeGen3;
PercReward30kHzM133=PercRewardGen3;

LastPokeM133Day6=LastPoke;

divi=length(FirstPoke)/10;
FirstPokeM133Day6(1)=mean(FirstPoke(1:divi));
for i=2:10
    FirstPokeM133Day6(i)=mean(FirstPoke((i-1)*divi:i*divi));
end

divi=length(TimeTwoTone)/10;
TimeTwoToneM133Day6(1)=mean(TimeTwoTone(1:divi));
for i=2:10
    TimeTwoToneM133Day6(i)=mean(TimeTwoTone((i-1)*divi:i*divi));
end

% ------------------------ Day 7 : 100 msec------------------
cd([directoryName,'/20140611/ICSS-Mouse-133-11062014'])
load LastResults

MeanFirstPokeDay7=MeanFirstPoke;
PercRewardDay7=PercReward;
WildSuccessRule2Day7=WildSuccesRule2;
RdmSuccesRule2Day7=RdmSuccesRule2;

MeanFirstPoke5kHzM133=MeanFirstPokeGen1;
PercReward5kHzM133=PercRewardGen1;
MeanFirstPoke10kHzM133=MeanFirstPokeGen2;
PercReward10kHzM133=PercRewardGen2;
MeanFirstPoke15kHzM133=MeanFirstPokeGen3;
PercReward15kHzM133=PercRewardGen3;
LastPokeM133Day7=LastPoke;

divi=length(FirstPoke)/10;
FirstPokeM133Day7(1)=mean(FirstPoke(1:divi));
for i=2:10
    FirstPokeM133Day7(i)=mean(FirstPoke((i-1)*divi:i*divi));
end

divi=length(TimeTwoTone)/10;
TimeTwoToneM133Day7(1)=mean(TimeTwoTone(1:divi));
for i=2:10
    TimeTwoToneM133Day7(i)=mean(TimeTwoTone((i-1)*divi:i*divi));
end

% ------------------------------------------------------------
% ------------------------------------------------------------

directoryName=('/media/DataMOBsG/AttentionalNosePoke/');
cd([directoryName])

MeanFirstPokeM133=[MeanFirstPokeDay1 MeanFirstPokeDay2 MeanFirstPokeDay3 MeanFirstPokeDay4 MeanFirstPokeDay5 MeanFirstPokeDay6 MeanFirstPokeDay7];
PercRewardM133=[PercRewardDay1;PercRewardDay2;PercRewardDay3;PercRewardDay4;PercRewardDay5;PercRewardDay6;PercRewardDay7];
WildSuccessRule2M133=[WildSuccessRule2Day1;WildSuccessRule2Day2;WildSuccessRule2Day3;WildSuccessRule2Day4;WildSuccessRule2Day5;WildSuccessRule2Day6;WildSuccessRule2Day7];
RdmSuccesRule2M133=[RdmSuccesRule2Day1;RdmSuccesRule2Day2;RdmSuccesRule2Day3;RdmSuccesRule2Day4;RdmSuccesRule2Day5;RdmSuccesRule2Day6;RdmSuccesRule2Day7];

% ------------------------------------------------------------
PercRewardAllGenM130=[PercReward5kHzM130 PercReward10kHzM130 PercReward15kHzM130 PercReward20kHzM130 PercReward25kHzM130 PercReward30kHzM130];
PercRewardAllGenM133=[PercReward5kHzM133 PercReward10kHzM133 PercReward15kHzM133 PercReward20kHzM133 PercReward25kHzM133 PercReward30kHzM133];


% ------------------------------------------------------------
% ------------------------ Mouse 143 -------------------------
% ------------------------------------------------------------

directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse143');

% ------------------------ Day 1 : 5 seconds------------------
cd([directoryName,'/20140722/ICSS-Mouse-143-22072014'])
load LastResults

MeanFirstPokeDay1=MeanFirstPoke;
PercRewardDay1=PercReward;
WildSuccessRule2Day1=WildSuccesRule2;
RdmSuccesRule2Day1=RdmSuccesRule2;
LastPokeDay1=LastPoke;

divi=length(FirstPoke)/10;
FirstPokeDay1(1)=mean(FirstPoke(1:divi));
for i=2:10
    FirstPokeM143Day1(i)=mean(FirstPoke((i-1)*divi:i*divi));
end

divi=length(TimeTwoTone)/10;
TimeTwoToneDay1(1)=mean(TimeTwoTone(1:divi));
for i=2:10
    TimeTwoToneM143Day1(i)=mean(TimeTwoTone((i-1)*divi:i*divi));
end

% ------------------------ Day 2 : 1 seconds------------------
cd([directoryName,'/20140723/ICSS-Mouse-143-23072014'])
load LastResults

MeanFirstPokeDay2=MeanFirstPoke;
PercRewardDay2=PercReward;
WildSuccessRule2Day2=WildSuccesRule2;
RdmSuccesRule2Day2=RdmSuccesRule2;
LastPokeM143Day2=LastPoke;

divi=length(FirstPoke)/10;
FirstPokeM143Day2(1)=mean(FirstPoke(1:divi));
for i=2:10
    FirstPokeM143Day2(i)=mean(FirstPoke((i-1)*divi:i*divi));
end

divi=length(TimeTwoTone)/10;
TimeTwoToneM143Day2(1)=mean(TimeTwoTone(1:divi));
for i=2:10
    TimeTwoToneM143Day2(i)=mean(TimeTwoTone((i-1)*divi:i*divi));
end


% ------------------------ Day 3 : 500 msec------------------
cd([directoryName,'/20140724/ICSS-Mouse-143-24072014'])
load LastResults_500ms

MeanFirstPokeDay3=MeanFirstPoke_500ms;
PercRewardDay3=PercReward_500ms;
WildSuccessRule2Day3=WildSuccesRule2_500ms;
RdmSuccesRule2Day3=RdmSuccesRule2_500ms;
LastPokeM143Day3=LastPoke_500ms;

divi=length(FirstPoke_500ms)/10;
FirstPokeM143Day3(1)=mean(FirstPoke_500ms(1:divi));
for i=2:10
    FirstPokeM143Day3(i)=mean(FirstPoke_500ms((i-1)*divi:i*divi));
end

divi=length(TimeTwoTone_500ms)/10;
FirstPokeM143Day3(1)=mean(TimeTwoTone_500ms(1:divi));
for i=2:10
    FirstPokeM143Day3(i)=mean(TimeTwoTone_500ms((i-1)*divi:i*divi));
end

% ------------------------ Day 3 : 100 msec------------------
load LastResults_200ms

MeanFirstPokeDay4=MeanFirstPoke_200ms;
PercRewardDay4=PercReward_200ms;
RdmSuccesRule2Day4=RdmSuccesRule2_200ms;
LastPokeM143Day4=LastPoke_200ms;

divi=length(FirstPoke_200ms)/10;
FirstPokeM143Day4(1)=mean(FirstPoke_200ms(1:divi));
for i=2:10
    FirstPokeM143Day4(i)=mean(FirstPoke_200ms((i-1)*divi:i*divi));
end

divi=length(TimeTwoTone_200ms)/10;
TimeTwoToneM143Day4(1)=mean(TimeTwoTone_200ms(1:divi));
for i=2:10
    TimeTwoToneM143Day4(i)=mean(TimeTwoTone_200ms((i-1)*divi:i*divi));
end

% ------------------------------------------------------------
% ------------------------------------------------------------

directoryName=('/media/DataMOBsG/AttentionalNosePoke/');
cd([directoryName])

MeanFirstPokeM143=[MeanFirstPokeDay1 MeanFirstPokeDay2 MeanFirstPokeDay3 MeanFirstPokeDay4];
PercRewardM143=[PercRewardDay1;PercRewardDay2;PercRewardDay3;PercRewardDay4];
WildSuccessRule2M133=[WildSuccessRule2Day1;WildSuccessRule2Day2;WildSuccessRule2Day3];
RdmSuccesRule2M143=[RdmSuccesRule2Day1;RdmSuccesRule2Day2;RdmSuccesRule2Day3;RdmSuccesRule2Day4];


% ------------------------------------------------------------
% ------------------------------------------------------------
% >>>>>>>>>>>>>>>>>>>>>>>>  Figures <<<<<<<<<<<<<<<<<<<<<<<<<<
% ------------------------------------------------------------
% ------------------------------------------------------------

figure, 
hold on, subplot(4,1,1)
hold on, plot(MeanFirstPokeM130,'ro-','linewidth',2)
hold on, plot(MeanFirstPokeM133,'bo-','linewidth',2) 
hold on, plot(MeanFirstPokeM143,'ko-','linewidth',2), title('Mean time to first poke after tone')
ylabel('time (seconds)')
set(gca,'xticklabel',{'5sec','1sec','500ms','500ms','100ms','Generalization 1','Generalization 2'},'xtick',1:7)

hold on, subplot(4,1,2)
hold on, plot(PercRewardM130,'ro-','linewidth',2)
hold on, plot(PercRewardM133,'bo-','linewidth',2)
hold on, plot(PercRewardM143,'ko-','linewidth',2), title('Probability of nose poke within the rewarding-windows')
ylabel('%')
set(gca,'xticklabel',{'5sec','1sec','500ms','500ms','100ms','Generalization 1','Generalization 2'},'xtick',1:7)

hold on, subplot(4,1,3)
hold on, plot(RdmSuccesRule2M130,'ro-','linewidth',2)
hold on, plot(RdmSuccesRule2M133,'bo-','linewidth',2)
hold on, plot(RdmSuccesRule2M143,'ko-','linewidth',2), title('Probability of nose poke within random non rewarding-windows')
ylabel('%')
set(gca,'xticklabel',{'5sec','1sec','500ms','500ms','100ms','Generalization 1','Generalization 2'},'xtick',1:7)

hold on, subplot(4,1,4)
hold on, plot(PercRewardAllGenM130,'ro-','linewidth',2)
hold on, plot(PercRewardAllGenM133,'bo-','linewidth',2), title('Probability of nose poke after Generalization Tone Sequences')
ylabel('%')
set(gca,'xticklabel',{'5kHz','10kHz','15kHz','20kHz','25kHz','30kHz 1'},'xtick',1:6)

% ------------------------------------------------------------
% ------------------------------------------------------------
% ------------------------------------------------------------

FirstPokeAll=[MeanFirstPokeM130; MeanFirstPokeM133];
eMeanFirstPoke=stdError(FirstPokeAll);
MeanFirstPokeAll=mean(FirstPokeAll);

PercRewardAll=[PercRewardM130'; PercRewardM133'];
ePercRewardAll=stdError(PercRewardAll);
PercRewardAll=mean(PercRewardAll);

RdmSuccesRule2All=[RdmSuccesRule2M130'; RdmSuccesRule2M133'];
eRdmSuccesRule2All=stdError(RdmSuccesRule2All);
RdmSuccesRule2All=mean(RdmSuccesRule2All);

PercRewardAllGen=[PercRewardAllGenM130; PercRewardAllGenM133];
ePercRewardAllGen=stdError(PercRewardAllGen);
PercRewardAllGen=mean(PercRewardAllGen);

figure, 
hold on, subplot(4,1,1)
hold on, bar(MeanFirstPokeAll,'grouped')
hold on, plot(MeanFirstPokeM130,'ko','MarkerFaceColor','w')
hold on, plot(MeanFirstPokeM133,'bo','MarkerFaceColor','g')
hold on, errorbar(MeanFirstPokeAll,eMeanFirstPoke,'k+','linewidth',1)
hold on, title('Mean time to first poke after tone')
ylabel('time (seconds)')
set(gca,'xticklabel',{'5sec','1sec','500ms','500ms','100ms','Generalization 1','Generalization 2'},'xtick',1:7)

hold on, subplot(4,1,2)
hold on, bar(PercRewardAll), 
hold on, plot(PercRewardM130,'ko','MarkerFaceColor','w')
hold on, plot(PercRewardM133,'bo','MarkerFaceColor','g')
hold on, errorbar(PercRewardAll,ePercRewardAll,'k+','linewidth',1)
hold on, title('Probability of nose poke within the rewarding-windows')
ylabel('%')
set(gca,'xticklabel',{'5sec','1sec','500ms','500ms','100ms','Generalization 1','Generalization 2'},'xtick',1:7)

hold on, subplot(4,1,3)
hold on, bar(RdmSuccesRule2All), 
hold on, plot(RdmSuccesRule2M130,'ko','MarkerFaceColor','w')
hold on, plot(RdmSuccesRule2M133,'bo','MarkerFaceColor','g')
hold on, errorbar(RdmSuccesRule2All,eRdmSuccesRule2All,'k+','linewidth',1)
hold on, title('Probability of nose poke within random non rewarding-windows')
ylabel('%')
set(gca,'xticklabel',{'5sec','1sec','500ms','500ms','100ms','Generalization 1','Generalization 2'},'xtick',1:7)

hold on, subplot(4,1,4)
hold on, bar(PercRewardAllGen), 
hold on, plot(PercRewardAllGenM130,'ko','MarkerFaceColor','w')
hold on, plot(PercRewardAllGenM133,'bo','MarkerFaceColor','g')
hold on, errorbar(PercRewardAllGen,ePercRewardAllGen,'k+','linewidth',1)
hold on, title('Probability of nose poke after Generalization Tone Sequences')
ylabel('%')
set(gca,'xticklabel',{'5kHz','10kHz','15kHz','20kHz','25kHz','30kHz 1'},'xtick',1:6)

% ------------------------------------------------------------
% >>>>>>>>>>>>>>>>> time between two tones  <<<<<<<<<<<<<<<<<<
% ------------------------------------------------------------
figure, plot(TimeTwoToneM133Day1,'ro-','MarkerFaceColor','r')
hold on, plot(TimeTwoToneM133Day1b,'ro-')
hold on, plot(TimeTwoToneM133Day2,'bo-')
hold on, plot(TimeTwoToneM133Day3,'go-','MarkerFaceColor','g')
hold on, plot(TimeTwoToneM133Day4,'go-')
hold on, plot(TimeTwoToneM133Day5,'ko-')
hold on, title('Mouse133: Mean time between two two consecutive tones')
ylabel('time (sec)')
set(gca,'xticklabel',{'10%','20%','30%','40%','50%','60%','70%','80%','90%','100%'},'xtick',1:10)
legend('5sec session1','5sec session2','1 seconde','500ms session1','500ms session1','100ms')
xlim([0.5 10.5])

figure, plot(TimeTwoToneM130Day1,'ro-','MarkerFaceColor','r')
hold on, plot(TimeTwoToneM130Day1b,'ro-')
hold on, plot(TimeTwoToneM130Day2,'bo-')
hold on, plot(TimeTwoToneM130Day3,'go-','MarkerFaceColor','g')
hold on, plot(TimeTwoToneM130Day4,'go-')
hold on, plot(TimeTwoToneM130Day5,'ko-')
hold on, title('Mouse130: Mean time between two two consecutive tones')
ylabel('time (sec)')
set(gca,'xticklabel',{'10%','20%','30%','40%','50%','60%','70%','80%','90%','100%'},'xtick',1:10)
legend('5sec session1','5sec session2','1 seconde','500ms session1','500ms session1','100ms')
xlim([0.5 10.5])

% ------------------------------------------------------------
% >>>>>>>>>>>>>>>>> time of the first poke  <<<<<<<<<<<<<<<<<<
% ------------------------------------------------------------
figure, plot(FirstPokeM133Day1,'ro-','MarkerFaceColor','r')
hold on, plot(FirstPokeM133Day1b,'ro-')
hold on, plot(FirstPokeM133Day2,'bo-')
hold on, plot(FirstPokeM133Day3,'go-','MarkerFaceColor','g')
hold on, plot(FirstPokeM133Day4,'go-')
hold on, plot(FirstPokeM133Day5,'ko-')
hold on, title('Mouse133: Time of the first nosepoke following the tone')
ylabel('time (sec)')
set(gca,'xticklabel',{'10%','20%','30%','40%','50%','60%','70%','80%','90%','100%'},'xtick',1:10)
legend('5sec session1','5sec session2','1 seconde','500ms session1','500ms session1','100ms')
xlim([0.5 10.5])

figure, plot(FirstPokeM130Day1,'ro-','MarkerFaceColor','r')
hold on, plot(FirstPokeM130Day1b,'ro-')
hold on, plot(FirstPokeM130Day2,'bo-')
hold on, plot(FirstPokeM130Day3,'go-','MarkerFaceColor','g')
hold on, plot(FirstPokeM130Day4,'go-')
hold on, plot(FirstPokeM130Day5,'ko-')
hold on, title('Mouse130: Time of the first nosepoke following the tone')
ylabel('time (sec)')
set(gca,'xticklabel',{'10%','20%','30%','40%','50%','60%','70%','80%','90%','100%'},'xtick',1:10)
legend('5sec session1','5sec session2','1 seconde','500ms session1','500ms session1','100ms')
xlim([0.5 10.5])


% ------------------------------------------------------------
% >>>>>>>>>>>>>>>>> time of the first poke  <<<<<<<<<<<<<<<<<<
% ------------------------------------------------------------
figure, plot(LastPokeM130Day1,'ro-','MarkerFaceColor','r')
hold on, plot(FirstPokeM133Day1b,'ro-')
hold on, plot(FirstPokeM133Day2,'bo-')
hold on, plot(FirstPokeM133Day3,'go-','MarkerFaceColor','g')
hold on, plot(FirstPokeM133Day4,'go-')
hold on, plot(FirstPokeM133Day5,'ko-')
hold on, title('Mouse133: Time of the first nosepoke following the tone')
ylabel('time (sec)')
set(gca,'xticklabel',{'10%','20%','30%','40%','50%','60%','70%','80%','90%','100%'},'xtick',1:10)
legend('5sec session1','5sec session2','1 seconde','500ms session1','500ms session1','100ms')
xlim([0.5 10.5])

figure, plot(LastPokeM130Day1,'r','linewidth',2)
hold on, plot(LastPokeM130Day3,'b','linewidth',2)
hold on, plot(LastPokeM130Day5,'g','linewidth',2)
hold on, title('Time of last previous nosepoke : 2 criterion')
ylabel('time (sec)')
legend('Day1 > 5 seconds','Day3 > 10-15 seconds','Day5 > 10-15 seconds')
xlim([5 60])












