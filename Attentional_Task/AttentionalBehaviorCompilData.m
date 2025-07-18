% ------------------------------------------------------------
% ------------------------ Mouse 130 -------------------------
% ------------------------------------------------------------

% ------------------------ Step 1 : 5 seconds------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');

try load ResultDay1
catch
    cd([directoryName,'/20140516/ICSS-Mouse-130-16052014'])
    load LastResults
    
    MeanFirstPoke_DayTemp1=MeanFirstPoke;
    PercReward_DayTemp1=PercReward;
    SuccesRule2_DayTemp1=RdmSuccesRule2;
    TimeTwoTone_DayTemp1=TimeTwoTone;
    
    NonRwdPokeMeanFq_DayTemp1=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_DayTemp1=NonRwdPokeMeanNb;
    NonRwdPokeNb_DayTemp1=NonRwdPokeNb;
    PokeEventNb_DayTemp1=PokeEventNb;
    RwdPokeMeanFq_DayTemp1=RwdPokeMeanFq;
    RwdPokeMeanNb_DayTemp1=RwdPokeMeanNb;
    RwdPokeNb_DayTemp1=RwdPokeNb;
    RwdToneNb_DayTemp1=RwdToneNb;
    
    IntraSessionTimeTwoTone_DayTemp1=IntraSessionTimeTwoTone;
    IntraSessionMeanFirstPoke_DayTemp1=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_DayTemp1=IntraSessionPercReward;
    IntraSessionSuccesRule2_DayTemp1=IntraSessionSuccesRule2;
    
    cd([directoryName])
    save ResultDayTemp1 MeanFirstPoke_DayTemp1 PercReward_DayTemp1 SuccesRule2_DayTemp1 TimeTwoTone_DayTemp1 
    save ResultDayTemp1 -append IntraSessionMeanFirstPoke_DayTemp1 IntraSessionPercReward_DayTemp1 IntraSessionSuccesRule2_DayTemp1 IntraSessionTimeTwoTone_DayTemp1
    save ResultDayTemp1 -append RwdToneNb_DayTemp1 PokeEventNb_DayTemp1 RwdPokeNb_DayTemp1 NonRwdPokeNb_DayTemp1 RwdToneNb_DayTemp1 NonRwdPokeMeanNb_DayTemp1 RwdPokeMeanNb_DayTemp1 RwdPokeMeanFq_DayTemp1 NonRwdPokeMeanFq_DayTemp1
    
    % ------------------------ Day 2 : 5 seconds------------------
    clear all
    directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');
    cd([directoryName,'/20140519/ICSS-Mouse-130-19052014'])
    load LastResults_5sec
    
    MeanFirstPoke_DayTemp2=MeanFirstPoke;
    PercReward_DayTemp2=PercReward;
    SuccesRule2_DayTemp2=RdmSuccesRule2;
    TimeTwoTone_DayTemp2=TimeTwoTone;
    
    NonRwdPokeMeanFq_DayTemp2=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_DayTemp2=NonRwdPokeMeanNb;
    NonRwdPokeNb_DayTemp2=NonRwdPokeNb;
    PokeEventNb_DayTemp2=PokeEventNb;
    RwdPokeMeanFq_DayTemp2=RwdPokeMeanFq;
    RwdPokeMeanNb_DayTemp2=RwdPokeMeanNb;
    RwdPokeNb_DayTemp2=RwdPokeNb;
    RwdToneNb_DayTemp2=RwdToneNb;
    
    IntraSessionMeanFirstPoke_DayTemp2=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_DayTemp2=IntraSessionPercReward;
    IntraSessionSuccesRule2_DayTemp2=IntraSessionSuccesRule2;
    IntraSessionTimeTwoTone_DayTemp2=IntraSessionTimeTwoTone;

    directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');

    cd([directoryName])
    save ResultDayTemp2 MeanFirstPoke_DayTemp2 PercReward_DayTemp2 SuccesRule2_DayTemp2 TimeTwoTone_DayTemp2 
    save ResultDayTemp2 -append IntraSessionMeanFirstPoke_DayTemp2 IntraSessionPercReward_DayTemp2 IntraSessionSuccesRule2_DayTemp2 IntraSessionTimeTwoTone_DayTemp2
    save ResultDayTemp2 -append RwdToneNb_DayTemp2 PokeEventNb_DayTemp2 RwdPokeNb_DayTemp2 NonRwdPokeNb_DayTemp2 RwdToneNb_DayTemp2 NonRwdPokeMeanNb_DayTemp2 RwdPokeMeanNb_DayTemp2 RwdPokeMeanFq_DayTemp2 NonRwdPokeMeanFq_DayTemp2
    
    
    clear all
    load ResultDayTemp1
    load ResultDayTemp2
    
    MeanFirstPoke_Day1=mean([MeanFirstPoke_DayTemp1 MeanFirstPoke_DayTemp2]);
    PercReward_Day1=mean([PercReward_DayTemp1 PercReward_DayTemp2]);
    SuccesRule2_Day1=mean([SuccesRule2_DayTemp1 SuccesRule2_DayTemp2]);
    Time2Tone_Day1=mean([TimeTwoTone_DayTemp1 TimeTwoTone_DayTemp2]);
    
    NonRwdPokeMeanFq_Day1=mean([NonRwdPokeMeanFq_DayTemp1 NonRwdPokeMeanFq_DayTemp2]);
    NonRwdPokeMeanNb_Day1=mean([NonRwdPokeMeanNb_DayTemp1 NonRwdPokeMeanNb_DayTemp2]);
    NonRwdPokeNb_Day1=mean([NonRwdPokeNb_DayTemp1 NonRwdPokeNb_DayTemp2]);
    PokeEventNb_Day1=mean([PokeEventNb_DayTemp1 PokeEventNb_DayTemp2]);
    RwdPokeMeanFq_Day1=mean([RwdPokeMeanFq_DayTemp1 RwdPokeMeanFq_DayTemp2]);
    RwdPokeMeanNb_Day1=mean([RwdPokeMeanNb_DayTemp1 RwdPokeMeanNb_DayTemp2]);
    RwdPokeNb_Day1=mean([RwdPokeNb_DayTemp1 RwdPokeNb_DayTemp2]);
    RwdToneNb_Day1=mean([RwdToneNb_DayTemp1 RwdToneNb_DayTemp2]);
    
    IntraSessionMeanFirstPoke_Day1=[IntraSessionMeanFirstPoke_DayTemp1 IntraSessionMeanFirstPoke_DayTemp2];
    IntraSessionPercReward_Day1=[IntraSessionPercReward_DayTemp1 IntraSessionPercReward_DayTemp2];
    IntraSessionSuccesRule2_Day1=[IntraSessionSuccesRule2_DayTemp1 IntraSessionSuccesRule2_DayTemp2];
    IntraSessionTimeTwoTone_Day1=[IntraSessionTimeTwoTone_DayTemp1 IntraSessionTimeTwoTone_DayTemp2];
    
    % number of tone necessary to reach the 80% succes
    BeforeSucessPerc=find(IntraSessionPercReward_Day1>80);
    BeforeSucessPerc_Day1=BeforeSucessPerc(1)*10;
    
    % evolution of the Rule1 behavior along the session
    len=length(IntraSessionMeanFirstPoke_Day1)/2;
    IntraSessionFirstPoke_Day1(1)=mean(IntraSessionMeanFirstPoke_Day1(1:len));
    IntraSessionFirstPoke_Day1(2)=mean(IntraSessionMeanFirstPoke_Day1(len+1:2*len));
    
    % evolution of the Rule1 Success behavior along the session
    len=length(IntraSessionSuccesRule2_Day1)/2;
    IntraSessionPerc_Day1(1)=mean(IntraSessionPercReward_Day1(1:len));
    IntraSessionPerc_Day1(2)=mean(IntraSessionPercReward_Day1(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=length(IntraSessionSuccesRule2_Day1)/2;
    IntraSessionRule2_Day1(1)=mean(IntraSessionSuccesRule2_Day1(1:len));
    IntraSessionRule2_Day1(2)=mean(IntraSessionSuccesRule2_Day1(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=length(IntraSessionTimeTwoTone_Day1)/2;
    IntraSessionTime2Tone_Day1(1)=mean(IntraSessionTimeTwoTone_Day1(1:len));
    IntraSessionTime2Tone_Day1(2)=mean(IntraSessionTimeTwoTone_Day1(len+1:2*len));
    
    save ResultDay1 MeanFirstPoke_Day1 PercReward_Day1 SuccesRule2_Day1 Time2Tone_Day1 BeforeSucessPerc_Day1
    save ResultDay1 -append IntraSessionFirstPoke_Day1 IntraSessionPerc_Day1 IntraSessionRule2_Day1 IntraSessionTime2Tone_Day1
    save ResultDay1 -append RwdToneNb_Day1 PokeEventNb_Day1 RwdPokeNb_Day1 NonRwdPokeNb_Day1 RwdToneNb_Day1 NonRwdPokeMeanNb_Day1 RwdPokeMeanNb_Day1 RwdPokeMeanFq_Day1 NonRwdPokeMeanFq_Day1
   
end

% ------------------------ Step 2 : 1 seconds------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');

try load ResultDay2
catch
    cd([directoryName,'/20140519/ICSS-Mouse-130-19052014'])
    load LastResults_1sec
    
    MeanFirstPoke_DayTemp1=MeanFirstPoke;
    PercReward_DayTemp1=PercReward;
    SuccesRule2_DayTemp1=RdmSuccesRule2;
    TimeTwoTone_DayTemp1=TimeTwoTone;
    
    NonRwdPokeMeanFq_DayTemp1=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_DayTemp1=NonRwdPokeMeanNb;
    NonRwdPokeNb_DayTemp1=NonRwdPokeNb;
    PokeEventNb_DayTemp1=PokeEventNb;
    RwdPokeMeanFq_DayTemp1=RwdPokeMeanFq;
    RwdPokeMeanNb_DayTemp1=RwdPokeMeanNb;
    RwdPokeNb_DayTemp1=RwdPokeNb;
    RwdToneNb_DayTemp1=RwdToneNb;
    
    IntraSessionTimeTwoTone_DayTemp1=IntraSessionTimeTwoTone;
    IntraSessionMeanFirstPoke_DayTemp1=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_DayTemp1=IntraSessionPercReward;
    IntraSessionSuccesRule2_DayTemp1=IntraSessionSuccesRule2;
    
    cd([directoryName])
    save ResultDayTemp1 MeanFirstPoke_DayTemp1 PercReward_DayTemp1 SuccesRule2_DayTemp1 TimeTwoTone_DayTemp1 
    save ResultDayTemp1 -append IntraSessionMeanFirstPoke_DayTemp1 IntraSessionPercReward_DayTemp1 IntraSessionSuccesRule2_DayTemp1 IntraSessionTimeTwoTone_DayTemp1
    save ResultDayTemp1 -append RwdToneNb_DayTemp1 PokeEventNb_DayTemp1 RwdPokeNb_DayTemp1 NonRwdPokeNb_DayTemp1 RwdToneNb_DayTemp1 NonRwdPokeMeanNb_DayTemp1 RwdPokeMeanNb_DayTemp1 RwdPokeMeanFq_DayTemp1 NonRwdPokeMeanFq_DayTemp1
    
    % ------------------------ Day 3 : 1 seconds------------------
    clear all
    directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');
    cd([directoryName,'/20140521/ICSS-Mouse-130-21052014'])
    load LastResults_1sec
    
    MeanFirstPoke_DayTemp2=MeanFirstPoke;
    PercReward_DayTemp2=PercReward;
    SuccesRule2_DayTemp2=RdmSuccesRule2;
    TimeTwoTone_DayTemp2=TimeTwoTone;
    
    NonRwdPokeMeanFq_DayTemp2=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_DayTemp2=NonRwdPokeMeanNb;
    NonRwdPokeNb_DayTemp2=NonRwdPokeNb;
    PokeEventNb_DayTemp2=PokeEventNb;
    RwdPokeMeanFq_DayTemp2=RwdPokeMeanFq;
    RwdPokeMeanNb_DayTemp2=RwdPokeMeanNb;
    RwdPokeNb_DayTemp2=RwdPokeNb;
    RwdToneNb_DayTemp2=RwdToneNb;
    
    IntraSessionMeanFirstPoke_DayTemp2=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_DayTemp2=IntraSessionPercReward;
    IntraSessionSuccesRule2_DayTemp2=IntraSessionSuccesRule2;
    IntraSessionTimeTwoTone_DayTemp2=IntraSessionTimeTwoTone;

    directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');

    cd([directoryName])
    save ResultDayTemp2 MeanFirstPoke_DayTemp2 PercReward_DayTemp2 SuccesRule2_DayTemp2 TimeTwoTone_DayTemp2 
    save ResultDayTemp2 -append IntraSessionMeanFirstPoke_DayTemp2 IntraSessionPercReward_DayTemp2 IntraSessionSuccesRule2_DayTemp2 IntraSessionTimeTwoTone_DayTemp2
    save ResultDayTemp2 -append RwdToneNb_DayTemp2 PokeEventNb_DayTemp2 RwdPokeNb_DayTemp2 NonRwdPokeNb_DayTemp2 RwdToneNb_DayTemp2 NonRwdPokeMeanNb_DayTemp2 RwdPokeMeanNb_DayTemp2 RwdPokeMeanFq_DayTemp2 NonRwdPokeMeanFq_DayTemp2
    
    
    clear all
    load ResultDayTemp1
    load ResultDayTemp2
    
    MeanFirstPoke_Day2=mean([MeanFirstPoke_DayTemp1 MeanFirstPoke_DayTemp2]);
    PercReward_Day2=mean([PercReward_DayTemp1 PercReward_DayTemp2]);
    SuccesRule2_Day2=mean([SuccesRule2_DayTemp1 SuccesRule2_DayTemp2]);
    Time2Tone_Day2=mean([TimeTwoTone_DayTemp1 TimeTwoTone_DayTemp2]);
    
    NonRwdPokeMeanFq_Day2=mean([NonRwdPokeMeanFq_DayTemp1 NonRwdPokeMeanFq_DayTemp2]);
    NonRwdPokeMeanNb_Day2=mean([NonRwdPokeMeanNb_DayTemp1 NonRwdPokeMeanNb_DayTemp2]);
    NonRwdPokeNb_Day2=mean([NonRwdPokeNb_DayTemp1 NonRwdPokeNb_DayTemp2]);
    PokeEventNb_Day2=mean([PokeEventNb_DayTemp1 PokeEventNb_DayTemp2]);
    RwdPokeMeanFq_Day2=mean([RwdPokeMeanFq_DayTemp1 RwdPokeMeanFq_DayTemp2]);
    RwdPokeMeanNb_Day2=mean([RwdPokeMeanNb_DayTemp1 RwdPokeMeanNb_DayTemp2]);
    RwdPokeNb_Day2=mean([RwdPokeNb_DayTemp1 RwdPokeNb_DayTemp2]);
    RwdToneNb_Day2=mean([RwdToneNb_DayTemp1 RwdToneNb_DayTemp2]);
    
    IntraSessionMeanFirstPoke_Day2=[IntraSessionMeanFirstPoke_DayTemp1 IntraSessionMeanFirstPoke_DayTemp2];
    IntraSessionPercReward_Day2=[IntraSessionPercReward_DayTemp1 IntraSessionPercReward_DayTemp2];
    IntraSessionSuccesRule2_Day2=[IntraSessionSuccesRule2_DayTemp1 IntraSessionSuccesRule2_DayTemp2];
    IntraSessionTimeTwoTone_Day2=[IntraSessionTimeTwoTone_DayTemp1 IntraSessionTimeTwoTone_DayTemp2];
    
    % number of tone necessary to reach the 80% succes
    BeforeSucessPerc=find(IntraSessionPercReward_Day2>80);
    BeforeSucessPerc_Day2=BeforeSucessPerc(1)*10;
    
    % evolution of the Rule1 behavior along the session
    len=floor(length(IntraSessionMeanFirstPoke_Day2)/2);
    IntraSessionFirstPoke_Day2(1)=mean(IntraSessionMeanFirstPoke_Day2(1:len));
    IntraSessionFirstPoke_Day2(2)=mean(IntraSessionMeanFirstPoke_Day2(len+1:2*len));
    
    % evolution of the Rule1 Success behavior along the session
    len=floor(length(IntraSessionPercReward_Day2)/2);
    IntraSessionPerc_Day2(1)=mean(IntraSessionPercReward_Day2(1:len));
    IntraSessionPerc_Day2(2)=mean(IntraSessionPercReward_Day2(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionSuccesRule2_Day2)/2);
    IntraSessionRule2_Day2(1)=mean(IntraSessionSuccesRule2_Day2(1:len));
    IntraSessionRule2_Day2(2)=mean(IntraSessionSuccesRule2_Day2(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionTimeTwoTone_Day2)/2);
    IntraSessionTime2Tone_Day2(1)=mean(IntraSessionTimeTwoTone_Day2(1:len));
    IntraSessionTime2Tone_Day2(2)=mean(IntraSessionTimeTwoTone_Day2(len+1:2*len));
    
    save ResultDay2 MeanFirstPoke_Day2 PercReward_Day2 SuccesRule2_Day2 Time2Tone_Day2 BeforeSucessPerc_Day2
    save ResultDay2 -append IntraSessionFirstPoke_Day2 IntraSessionPerc_Day2 IntraSessionRule2_Day2 IntraSessionTime2Tone_Day2
    save ResultDay2 -append RwdToneNb_Day2 PokeEventNb_Day2 RwdPokeNb_Day2 NonRwdPokeNb_Day2 RwdToneNb_Day2 NonRwdPokeMeanNb_Day2 RwdPokeMeanNb_Day2 RwdPokeMeanFq_Day2 NonRwdPokeMeanFq_Day2
   
end

% ------------------------ Step 3 : 500 msec------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');

try load ResultDay3
catch
    cd([directoryName,'/20140522/ICSS-Mouse-130-22052014'])
    load LastResults
    
    MeanFirstPoke_DayTemp1=MeanFirstPoke;
    PercReward_DayTemp1=PercReward;
    SuccesRule2_DayTemp1=RdmSuccesRule2;
    TimeTwoTone_DayTemp1=TimeTwoTone;
    
    NonRwdPokeMeanFq_DayTemp1=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_DayTemp1=NonRwdPokeMeanNb;
    NonRwdPokeNb_DayTemp1=NonRwdPokeNb;
    PokeEventNb_DayTemp1=PokeEventNb;
    RwdPokeMeanFq_DayTemp1=RwdPokeMeanFq;
    RwdPokeMeanNb_DayTemp1=RwdPokeMeanNb;
    RwdPokeNb_DayTemp1=RwdPokeNb;
    RwdToneNb_DayTemp1=RwdToneNb;
    
    IntraSessionTimeTwoTone_DayTemp1=IntraSessionTimeTwoTone;
    IntraSessionMeanFirstPoke_DayTemp1=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_DayTemp1=IntraSessionPercReward;
    IntraSessionSuccesRule2_DayTemp1=IntraSessionSuccesRule2;
    
    cd([directoryName])
    save ResultDayTemp1 MeanFirstPoke_DayTemp1 PercReward_DayTemp1 SuccesRule2_DayTemp1 TimeTwoTone_DayTemp1 
    save ResultDayTemp1 -append IntraSessionMeanFirstPoke_DayTemp1 IntraSessionPercReward_DayTemp1 IntraSessionSuccesRule2_DayTemp1 IntraSessionTimeTwoTone_DayTemp1
    save ResultDayTemp1 -append RwdToneNb_DayTemp1 PokeEventNb_DayTemp1 RwdPokeNb_DayTemp1 NonRwdPokeNb_DayTemp1 RwdToneNb_DayTemp1 NonRwdPokeMeanNb_DayTemp1 RwdPokeMeanNb_DayTemp1 RwdPokeMeanFq_DayTemp1 NonRwdPokeMeanFq_DayTemp1
    
    % ------------------------ Day 2 : 5 seconds------------------
    clear all
    directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');
    cd([directoryName,'/20140603/ICSS-Mouse-130-03062014'])
    load LastResults
    
    MeanFirstPoke_DayTemp2=MeanFirstPoke;
    PercReward_DayTemp2=PercReward;
    SuccesRule2_DayTemp2=RdmSuccesRule2;
    TimeTwoTone_DayTemp2=TimeTwoTone;
    
    NonRwdPokeMeanFq_DayTemp2=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_DayTemp2=NonRwdPokeMeanNb;
    NonRwdPokeNb_DayTemp2=NonRwdPokeNb;
    PokeEventNb_DayTemp2=PokeEventNb;
    RwdPokeMeanFq_DayTemp2=RwdPokeMeanFq;
    RwdPokeMeanNb_DayTemp2=RwdPokeMeanNb;
    RwdPokeNb_DayTemp2=RwdPokeNb;
    RwdToneNb_DayTemp2=RwdToneNb;
    
    IntraSessionMeanFirstPoke_DayTemp2=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_DayTemp2=IntraSessionPercReward;
    IntraSessionSuccesRule2_DayTemp2=IntraSessionSuccesRule2;
    IntraSessionTimeTwoTone_DayTemp2=IntraSessionTimeTwoTone;

    directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');

    cd([directoryName])
    save ResultDayTemp2 MeanFirstPoke_DayTemp2 PercReward_DayTemp2 SuccesRule2_DayTemp2 TimeTwoTone_DayTemp2 
    save ResultDayTemp2 -append IntraSessionMeanFirstPoke_DayTemp2 IntraSessionPercReward_DayTemp2 IntraSessionSuccesRule2_DayTemp2 IntraSessionTimeTwoTone_DayTemp2
    save ResultDayTemp2 -append RwdToneNb_DayTemp2 PokeEventNb_DayTemp2 RwdPokeNb_DayTemp2 NonRwdPokeNb_DayTemp2 RwdToneNb_DayTemp2 NonRwdPokeMeanNb_DayTemp2 RwdPokeMeanNb_DayTemp2 RwdPokeMeanFq_DayTemp2 NonRwdPokeMeanFq_DayTemp2
    
    
    clear all
    load ResultDayTemp1
    load ResultDayTemp2
    
    MeanFirstPoke_Day3=mean([MeanFirstPoke_DayTemp1 MeanFirstPoke_DayTemp2]);
    PercReward_Day3=mean([PercReward_DayTemp1 PercReward_DayTemp2]);
    SuccesRule2_Day3=mean([SuccesRule2_DayTemp1 SuccesRule2_DayTemp2]);
    Time2Tone_Day3=mean([TimeTwoTone_DayTemp1 TimeTwoTone_DayTemp2]);
    
    NonRwdPokeMeanFq_Day3=mean([NonRwdPokeMeanFq_DayTemp1 NonRwdPokeMeanFq_DayTemp2]);
    NonRwdPokeMeanNb_Day3=mean([NonRwdPokeMeanNb_DayTemp1 NonRwdPokeMeanNb_DayTemp2]);
    NonRwdPokeNb_Day3=mean([NonRwdPokeNb_DayTemp1 NonRwdPokeNb_DayTemp2]);
    PokeEventNb_Day3=mean([PokeEventNb_DayTemp1 PokeEventNb_DayTemp2]);
    RwdPokeMeanFq_Day3=mean([RwdPokeMeanFq_DayTemp1 RwdPokeMeanFq_DayTemp2]);
    RwdPokeMeanNb_Day3=mean([RwdPokeMeanNb_DayTemp1 RwdPokeMeanNb_DayTemp2]);
    RwdPokeNb_Day3=mean([RwdPokeNb_DayTemp1 RwdPokeNb_DayTemp2]);
    RwdToneNb_Day3=mean([RwdToneNb_DayTemp1 RwdToneNb_DayTemp2]);
    
    IntraSessionMeanFirstPoke_Day3=[IntraSessionMeanFirstPoke_DayTemp1 IntraSessionMeanFirstPoke_DayTemp2];
    IntraSessionPercReward_Day3=[IntraSessionPercReward_DayTemp1 IntraSessionPercReward_DayTemp2];
    IntraSessionSuccesRule2_Day3=[IntraSessionSuccesRule2_DayTemp1 IntraSessionSuccesRule2_DayTemp2];
    IntraSessionTimeTwoTone_Day3=[IntraSessionTimeTwoTone_DayTemp1 IntraSessionTimeTwoTone_DayTemp2];
    
    % number of tone necessary to reach the 80% succes
    BeforeSucessPerc=find(IntraSessionPercReward_Day3>80);
    BeforeSucessPerc_Day3=BeforeSucessPerc(1)*10;
    
    % evolution of the Rule1 behavior along the session
    len=floor(length(IntraSessionMeanFirstPoke_Day3)/2);
    IntraSessionFirstPoke_Day3(1)=mean(IntraSessionMeanFirstPoke_Day3(1:len));
    IntraSessionFirstPoke_Day3(2)=mean(IntraSessionMeanFirstPoke_Day3(len+1:2*len));
    
    % evolution of the Rule1 Success behavior along the session
    len=floor(length(IntraSessionPercReward_Day3)/2);
    IntraSessionPerc_Day3(1)=mean(IntraSessionPercReward_Day3(1:len));
    IntraSessionPerc_Day3(2)=mean(IntraSessionPercReward_Day3(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionSuccesRule2_Day3)/2);
    IntraSessionRule2_Day3(1)=mean(IntraSessionSuccesRule2_Day3(1:len));
    IntraSessionRule2_Day3(2)=mean(IntraSessionSuccesRule2_Day3(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionTimeTwoTone_Day3)/2);
    IntraSessionTime2Tone_Day3(1)=mean(IntraSessionTimeTwoTone_Day3(1:len));
    IntraSessionTime2Tone_Day3(2)=mean(IntraSessionTimeTwoTone_Day3(len+1:2*len));
    
    save ResultDay3 MeanFirstPoke_Day3 PercReward_Day3 SuccesRule2_Day3 Time2Tone_Day3 BeforeSucessPerc_Day3
    save ResultDay3 -append IntraSessionFirstPoke_Day3 IntraSessionPerc_Day3 IntraSessionRule2_Day3 IntraSessionTime2Tone_Day3
    save ResultDay3 -append RwdToneNb_Day3 PokeEventNb_Day3 RwdPokeNb_Day3 NonRwdPokeNb_Day3 RwdToneNb_Day3 NonRwdPokeMeanNb_Day3 RwdPokeMeanNb_Day3 RwdPokeMeanFq_Day3 NonRwdPokeMeanFq_Day3
   
end

% ------------------------ Step 4 : 100 msec------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');

try load ResultDay4
catch
    cd([directoryName,'/20140605/ICSS-Mouse-130-05062014'])
    load LastResults
    
    MeanFirstPoke_Day4=MeanFirstPoke;
    PercReward_Day4=PercReward;
    SuccesRule2_Day4=RdmSuccesRule2;
    Time2Tone_Day4=mean(TimeTwoTone);
    
    NonRwdPokeMeanFq_Day4=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_Day4=NonRwdPokeMeanNb;
    NonRwdPokeNb_Day4=NonRwdPokeNb;
    PokeEventNb_Day4=PokeEventNb;
    RwdPokeMeanFq_Day4=RwdPokeMeanFq;
    RwdPokeMeanNb_Day4=RwdPokeMeanNb;
    RwdPokeNb_Day4=RwdPokeNb;
    RwdToneNb_Day4=RwdToneNb;
    
    IntraSessionTimeTwoTone_Day4=IntraSessionTimeTwoTone;
    IntraSessionMeanFirstPoke_Day4=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_Day4=IntraSessionPercReward;
    IntraSessionSuccesRule2_Day4=IntraSessionSuccesRule2;
    
    % number of tone necessary to reach the 80% succes
    BeforeSucessPerc=find(IntraSessionPercReward_Day4>80);
    BeforeSucessPerc_Day4=BeforeSucessPerc(1)*10;
    
    % evolution of the Rule1 behavior along the session
    len=floor(length(IntraSessionMeanFirstPoke_Day4)/2);
    IntraSessionFirstPoke_Day4(1)=mean(IntraSessionMeanFirstPoke_Day4(1:len));
    IntraSessionFirstPoke_Day4(2)=mean(IntraSessionMeanFirstPoke_Day4(len+1:2*len));
    
    % evolution of the Rule1 Success behavior along the session
    len=floor(length(IntraSessionPercReward_Day4)/2);
    IntraSessionPerc_Day4(1)=mean(IntraSessionPercReward_Day4(1:len));
    IntraSessionPerc_Day4(2)=mean(IntraSessionPercReward_Day4(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionSuccesRule2_Day4)/2);
    IntraSessionRule2_Day4(1)=mean(IntraSessionSuccesRule2_Day4(1:len));
    IntraSessionRule2_Day4(2)=mean(IntraSessionSuccesRule2_Day4(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionTimeTwoTone_Day4)/2);
    IntraSessionTime2Tone_Day4(1)=mean(IntraSessionTimeTwoTone_Day4(1:len));
    IntraSessionTime2Tone_Day4(2)=mean(IntraSessionTimeTwoTone_Day4(len+1:2*len));
    
    cd([directoryName])
    save ResultDay4 MeanFirstPoke_Day4 PercReward_Day4 SuccesRule2_Day4 Time2Tone_Day4 BeforeSucessPerc_Day4
    save ResultDay4 -append IntraSessionFirstPoke_Day4 IntraSessionPerc_Day4 IntraSessionRule2_Day4 IntraSessionTime2Tone_Day4
    save ResultDay4 -append RwdToneNb_Day4 PokeEventNb_Day4 RwdPokeNb_Day4 NonRwdPokeNb_Day4 RwdToneNb_Day4 NonRwdPokeMeanNb_Day4 RwdPokeMeanNb_Day4 RwdPokeMeanFq_Day4 NonRwdPokeMeanFq_Day4
   
end

% ------------------------ Step 5 : 100ms / Gen ------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');

try load ResultDay5
catch
    cd([directoryName,'/20140610/ICSS-Mouse-130-10062014'])
    load LastResults
    
    MeanFirstPoke_DayTemp1=MeanFirstPoke;
    PercReward_DayTemp1=PercReward;
    SuccesRule2_DayTemp1=RdmSuccesRule2;
    TimeTwoTone_DayTemp1=TimeTwoTone;
    
    NonRwdPokeMeanFq_DayTemp1=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_DayTemp1=NonRwdPokeMeanNb;
    NonRwdPokeNb_DayTemp1=NonRwdPokeNb;
    PokeEventNb_DayTemp1=PokeEventNb;
    RwdPokeMeanFq_DayTemp1=RwdPokeMeanFq;
    RwdPokeMeanNb_DayTemp1=RwdPokeMeanNb;
    RwdPokeNb_DayTemp1=RwdPokeNb;
    RwdToneNb_DayTemp1=RwdToneNb;
    
    IntraSessionTimeTwoTone_DayTemp1=IntraSessionTimeTwoTone;
    IntraSessionMeanFirstPoke_DayTemp1=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_DayTemp1=IntraSessionPercReward;
    IntraSessionSuccesRule2_DayTemp1=IntraSessionSuccesRule2;
    
    cd([directoryName])
    save ResultDayTemp1 MeanFirstPoke_DayTemp1 PercReward_DayTemp1 SuccesRule2_DayTemp1 TimeTwoTone_DayTemp1 
    save ResultDayTemp1 -append IntraSessionMeanFirstPoke_DayTemp1 IntraSessionPercReward_DayTemp1 IntraSessionSuccesRule2_DayTemp1 IntraSessionTimeTwoTone_DayTemp1
    save ResultDayTemp1 -append RwdToneNb_DayTemp1 PokeEventNb_DayTemp1 RwdPokeNb_DayTemp1 NonRwdPokeNb_DayTemp1 RwdToneNb_DayTemp1 NonRwdPokeMeanNb_DayTemp1 RwdPokeMeanNb_DayTemp1 RwdPokeMeanFq_DayTemp1 NonRwdPokeMeanFq_DayTemp1
    
    % ------------------------ Day 2 : 5 seconds------------------
    clear all
    directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');
    cd([directoryName,'/20140611/ICSS-Mouse-130-11062014'])
    load LastResults
    
    MeanFirstPoke_DayTemp2=MeanFirstPoke;
    PercReward_DayTemp2=PercReward;
    SuccesRule2_DayTemp2=RdmSuccesRule2;
    TimeTwoTone_DayTemp2=TimeTwoTone;
    
    NonRwdPokeMeanFq_DayTemp2=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_DayTemp2=NonRwdPokeMeanNb;
    NonRwdPokeNb_DayTemp2=NonRwdPokeNb;
    PokeEventNb_DayTemp2=PokeEventNb;
    RwdPokeMeanFq_DayTemp2=RwdPokeMeanFq;
    RwdPokeMeanNb_DayTemp2=RwdPokeMeanNb;
    RwdPokeNb_DayTemp2=RwdPokeNb;
    RwdToneNb_DayTemp2=RwdToneNb;
    
    IntraSessionMeanFirstPoke_DayTemp2=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_DayTemp2=IntraSessionPercReward;
    IntraSessionSuccesRule2_DayTemp2=IntraSessionSuccesRule2;
    IntraSessionTimeTwoTone_DayTemp2=IntraSessionTimeTwoTone;

    directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');

    cd([directoryName])
    save ResultDayTemp2 MeanFirstPoke_DayTemp2 PercReward_DayTemp2 SuccesRule2_DayTemp2 TimeTwoTone_DayTemp2 
    save ResultDayTemp2 -append IntraSessionMeanFirstPoke_DayTemp2 IntraSessionPercReward_DayTemp2 IntraSessionSuccesRule2_DayTemp2 IntraSessionTimeTwoTone_DayTemp2
    save ResultDayTemp2 -append RwdToneNb_DayTemp2 PokeEventNb_DayTemp2 RwdPokeNb_DayTemp2 NonRwdPokeNb_DayTemp2 RwdToneNb_DayTemp2 NonRwdPokeMeanNb_DayTemp2 RwdPokeMeanNb_DayTemp2 RwdPokeMeanFq_DayTemp2 NonRwdPokeMeanFq_DayTemp2
    
    
    clear all
    load ResultDayTemp1
    load ResultDayTemp2
    
    MeanFirstPoke_Day5=mean([MeanFirstPoke_DayTemp1 MeanFirstPoke_DayTemp2]);
    PercReward_Day5=mean([PercReward_DayTemp1 PercReward_DayTemp2]);
    SuccesRule2_Day5=mean([SuccesRule2_DayTemp1 SuccesRule2_DayTemp2]);
    Time2Tone_Day5=mean([TimeTwoTone_DayTemp1 TimeTwoTone_DayTemp2]);
    
    NonRwdPokeMeanFq_Day5=mean([NonRwdPokeMeanFq_DayTemp1 NonRwdPokeMeanFq_DayTemp2]);
    NonRwdPokeMeanNb_Day5=mean([NonRwdPokeMeanNb_DayTemp1 NonRwdPokeMeanNb_DayTemp2]);
    NonRwdPokeNb_Day5=mean([NonRwdPokeNb_DayTemp1 NonRwdPokeNb_DayTemp2]);
    PokeEventNb_Day5=mean([PokeEventNb_DayTemp1 PokeEventNb_DayTemp2]);
    RwdPokeMeanFq_Day5=mean([RwdPokeMeanFq_DayTemp1 RwdPokeMeanFq_DayTemp2]);
    RwdPokeMeanNb_Day5=mean([RwdPokeMeanNb_DayTemp1 RwdPokeMeanNb_DayTemp2]);
    RwdPokeNb_Day5=mean([RwdPokeNb_DayTemp1 RwdPokeNb_DayTemp2]);
    RwdToneNb_Day5=mean([RwdToneNb_DayTemp1 RwdToneNb_DayTemp2]);
    
    IntraSessionMeanFirstPoke_Day5=[IntraSessionMeanFirstPoke_DayTemp1 IntraSessionMeanFirstPoke_DayTemp2];
    IntraSessionPercReward_Day5=[IntraSessionPercReward_DayTemp1 IntraSessionPercReward_DayTemp2];
    IntraSessionSuccesRule2_Day5=[IntraSessionSuccesRule2_DayTemp1 IntraSessionSuccesRule2_DayTemp2];
    IntraSessionTimeTwoTone_Day5=[IntraSessionTimeTwoTone_DayTemp1 IntraSessionTimeTwoTone_DayTemp2];
    
    % number of tone necessary to reach the 80% succes
    BeforeSucessPerc=find(IntraSessionPercReward_Day5>80);
    BeforeSucessPerc_Day5=BeforeSucessPerc(1)*10;
    
    % evolution of the Rule1 behavior along the session
    len=length(IntraSessionMeanFirstPoke_Day5)/2;
    IntraSessionFirstPoke_Day5(1)=mean(IntraSessionMeanFirstPoke_Day5(1:len));
    IntraSessionFirstPoke_Day5(2)=mean(IntraSessionMeanFirstPoke_Day5(len+1:2*len));
    
    % evolution of the Rule1 Success behavior along the session
    len=length(IntraSessionPercReward_Day5)/2;
    IntraSessionPerc_Day5(1)=mean(IntraSessionPercReward_Day5(1:len));
    IntraSessionPerc_Day5(2)=mean(IntraSessionPercReward_Day5(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=length(IntraSessionSuccesRule2_Day5)/2;
    IntraSessionRule2_Day5(1)=mean(IntraSessionSuccesRule2_Day5(1:len));
    IntraSessionRule2_Day5(2)=mean(IntraSessionSuccesRule2_Day5(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=length(IntraSessionTimeTwoTone_Day5)/2;
    IntraSessionTime2Tone_Day5(1)=mean(IntraSessionTimeTwoTone_Day5(1:len));
    IntraSessionTime2Tone_Day5(2)=mean(IntraSessionTimeTwoTone_Day5(len+1:2*len));
    
    save ResultDay5 MeanFirstPoke_Day5 PercReward_Day5 SuccesRule2_Day5 Time2Tone_Day5 BeforeSucessPerc_Day5
    save ResultDay5 -append IntraSessionFirstPoke_Day5 IntraSessionPerc_Day5 IntraSessionRule2_Day5 IntraSessionTime2Tone_Day5
    save ResultDay5 -append RwdToneNb_Day5 PokeEventNb_Day5 RwdPokeNb_Day5 NonRwdPokeNb_Day5 RwdToneNb_Day5 NonRwdPokeMeanNb_Day5 RwdPokeMeanNb_Day5 RwdPokeMeanFq_Day5 NonRwdPokeMeanFq_Day5
end

% ------------------------ Step 5 : Generalization ------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');
cd([directoryName])
try load ResultGeneralization
catch
    cd([directoryName,'/20140610/ICSS-Mouse-130-10062014'])
    load GeneralizationResult
    
    MeanFirstPoke20kHz_M130=MeanFirstPokeGen20kHz;
    MeanFirstPoke25kHz_M130=MeanFirstPokeGen25kHz;
    MeanFirstPoke30kHz_M130=MeanFirstPokeGen30kHz;
    
    PercReward20kHz_M130=PercRewardGen20kHz;
    PercReward25kHz_M130=PercRewardGen25kHz;
    PercReward30kHz_M130=PercRewardGen30kHz;
    
    Poke20kHzNb_M130=Poke20kHzNb;
    Poke25kHzNb_M130=Poke25kHzNb;
    Poke30kHzNb_M130=Poke30kHzNb;
    
    Poke20kHzMeanNb_M130=Poke20kHzMeanNb;
    Poke25kHzMeanNb_M130=Poke25kHzMeanNb;
    Poke30kHzMeanNb_M130=Poke30kHzMeanNb;
        
    Poke20kHzMeanFq_M130=Poke20kHzMeanFq;
    Poke25kHzMeanFq_M130=Poke25kHzMeanFq;
    Poke30kHzMeanFq_M130=Poke30kHzMeanFq;
    
    Tone20kHzNb_M130=Tone20kHzNb;
    Tone25kHzNb_M130=Tone25kHzNb;
    Tone30kHzNb_M130=Tone30kHzNb;
    
    cd([directoryName,'/20140611/ICSS-Mouse-130-11062014'])
    load GeneralizationResult
    
    MeanFirstPoke5kHz_M130=MeanFirstPokeGen5kHz;
    MeanFirstPoke15kHz_M130=MeanFirstPokeGen15kHz;
    MeanFirstPoke10kHz_M130=MeanFirstPokeGen10kHz;
    
    PercReward5kHz_M130=PercRewardGen5kHz;
    PercReward15kHz_M130=PercRewardGen15kHz;
    PercReward10kHz_M130=PercRewardGen10kHz;
    
    Poke5kHzNb_M130=Poke5kHzNb;
    Poke15kHzNb_M130=Poke15kHzNb;
    Poke10kHzNb_M130=Poke10kHzNb;
    
    Poke5kHzMeanNb_M130=Poke5kHzMeanNb;
    Poke15kHzMeanNb_M130=Poke15kHzMeanNb;
    Poke10kHzMeanNb_M130=Poke10kHzMeanNb;
        
    Poke5kHzMeanFq_M130=Poke5kHzMeanFq;
    Poke15kHzMeanFq_M130=Poke15kHzMeanFq;
    Poke10kHzMeanFq_M130=Poke10kHzMeanFq;
    
    Tone5kHzNb_M130=Tone5kHzNb;
    Tone15kHzNb_M130=Tone15kHzNb;
    Tone10kHzNb_M130=Tone10kHzNb;
    
    cd([directoryName])
    save ResultGeneralization_M130 MeanFirstPoke5kHz_M130 MeanFirstPoke10kHz_M130 MeanFirstPoke15kHz_M130 MeanFirstPoke20kHz_M130  MeanFirstPoke25kHz_M130 MeanFirstPoke30kHz_M130
    save ResultGeneralization_M130 -append PercReward5kHz_M130 PercReward10kHz_M130 PercReward15kHz_M130 PercReward20kHz_M130 PercReward25kHz_M130 PercReward30kHz_M130
    save ResultGeneralization_M130 -append Poke5kHzNb_M130 Poke10kHzNb_M130 Poke15kHzNb_M130 Poke20kHzNb_M130 Poke25kHzNb_M130 Poke30kHzNb_M130
    save ResultGeneralization_M130 -append Poke5kHzMeanNb_M130 Poke10kHzMeanNb_M130 Poke15kHzMeanNb_M130 Poke20kHzMeanNb_M130 Poke25kHzMeanNb_M130 Poke30kHzMeanNb_M130
    save ResultGeneralization_M130 -append Poke5kHzMeanFq_M130 Poke10kHzMeanFq_M130 Poke15kHzMeanFq_M130 Poke20kHzMeanFq_M130 Poke25kHzMeanFq_M130 Poke30kHzMeanFq_M130
    save ResultGeneralization_M130 -append Tone5kHzNb_M130 Tone10kHzNb_M130 Tone15kHzNb_M130 Tone20kHzNb_M130 Tone25kHzNb_M130 Tone30kHzNb_M130
    
end

clear all
load ResultDay5
MeanFirstPoke12kHz_M130=MeanFirstPoke_Day5;
PercReward12kHz_M130=PercReward_Day5;
Poke12kHzNb_M130=RwdPokeNb_Day5;
Poke12kHzMeanNb_M130=RwdPokeMeanNb_Day5;
Poke12kHzMeanFq_M130=RwdPokeMeanFq_Day5;
Tone12kHzNb_M130=RwdToneNb_Day5;
  
save ResultGeneralization_M130 -append MeanFirstPoke12kHz_M130 PercReward12kHz_M130 Poke12kHzNb_M130 Poke12kHzMeanNb_M130 Poke12kHzMeanFq_M130 Tone12kHzNb_M130

%------------------------------------------------------------%------------------------------------------------------------%------------------------------------------------------------
%------------------------------------------------------------%------------------------------------------------------------%------------------------------------------------------------

% ------------------------------------------------------------
% ------------------------ Mouse 133 -------------------------
% ------------------------------------------------------------
% ------------------------ Step 1 : 5 seconds------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');
cd([directoryName])
try load ResultDay1
catch
    cd([directoryName,'/20140516/ICSS-Mouse-133-16052014'])
    load LastResults
    
    MeanFirstPoke_DayTemp1=MeanFirstPoke;
    PercReward_DayTemp1=PercReward;
    SuccesRule2_DayTemp1=RdmSuccesRule2;
    TimeTwoTone_DayTemp1=TimeTwoTone;
    
    NonRwdPokeMeanFq_DayTemp1=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_DayTemp1=NonRwdPokeMeanNb;
    NonRwdPokeNb_DayTemp1=NonRwdPokeNb;
    PokeEventNb_DayTemp1=PokeEventNb;
    RwdPokeMeanFq_DayTemp1=RwdPokeMeanFq;
    RwdPokeMeanNb_DayTemp1=RwdPokeMeanNb;
    RwdPokeNb_DayTemp1=RwdPokeNb;
    RwdToneNb_DayTemp1=RwdToneNb;
    
    IntraSessionTimeTwoTone_DayTemp1=IntraSessionTimeTwoTone;
    IntraSessionMeanFirstPoke_DayTemp1=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_DayTemp1=IntraSessionPercReward;
    IntraSessionSuccesRule2_DayTemp1=IntraSessionSuccesRule2;
    
    cd([directoryName])
    save ResultDayTemp1 MeanFirstPoke_DayTemp1 PercReward_DayTemp1 SuccesRule2_DayTemp1 TimeTwoTone_DayTemp1 
    save ResultDayTemp1 -append IntraSessionMeanFirstPoke_DayTemp1 IntraSessionPercReward_DayTemp1 IntraSessionSuccesRule2_DayTemp1 IntraSessionTimeTwoTone_DayTemp1
    save ResultDayTemp1 -append RwdToneNb_DayTemp1 PokeEventNb_DayTemp1 RwdPokeNb_DayTemp1 NonRwdPokeNb_DayTemp1 RwdToneNb_DayTemp1 NonRwdPokeMeanNb_DayTemp1 RwdPokeMeanNb_DayTemp1 RwdPokeMeanFq_DayTemp1 NonRwdPokeMeanFq_DayTemp1
    
    % ------------------------ Day 2 : 5 seconds------------------
    clear all
    directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');
    cd([directoryName,'/20140519/ICSS-Mouse-133-19052014'])
    load LastResults_5sec
    
    MeanFirstPoke_DayTemp2=MeanFirstPoke;
    PercReward_DayTemp2=PercReward;
    SuccesRule2_DayTemp2=RdmSuccesRule2;
    TimeTwoTone_DayTemp2=TimeTwoTone;
    
    NonRwdPokeMeanFq_DayTemp2=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_DayTemp2=NonRwdPokeMeanNb;
    NonRwdPokeNb_DayTemp2=NonRwdPokeNb;
    PokeEventNb_DayTemp2=PokeEventNb;
    RwdPokeMeanFq_DayTemp2=RwdPokeMeanFq;
    RwdPokeMeanNb_DayTemp2=RwdPokeMeanNb;
    RwdPokeNb_DayTemp2=RwdPokeNb;
    RwdToneNb_DayTemp2=RwdToneNb;
    
    IntraSessionMeanFirstPoke_DayTemp2=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_DayTemp2=IntraSessionPercReward;
    IntraSessionSuccesRule2_DayTemp2=IntraSessionSuccesRule2;
    IntraSessionTimeTwoTone_DayTemp2=IntraSessionTimeTwoTone;

    directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');

    cd([directoryName])
    save ResultDayTemp2 MeanFirstPoke_DayTemp2 PercReward_DayTemp2 SuccesRule2_DayTemp2 TimeTwoTone_DayTemp2 
    save ResultDayTemp2 -append IntraSessionMeanFirstPoke_DayTemp2 IntraSessionPercReward_DayTemp2 IntraSessionSuccesRule2_DayTemp2 IntraSessionTimeTwoTone_DayTemp2
    save ResultDayTemp2 -append RwdToneNb_DayTemp2 PokeEventNb_DayTemp2 RwdPokeNb_DayTemp2 NonRwdPokeNb_DayTemp2 RwdToneNb_DayTemp2 NonRwdPokeMeanNb_DayTemp2 RwdPokeMeanNb_DayTemp2 RwdPokeMeanFq_DayTemp2 NonRwdPokeMeanFq_DayTemp2
    
    
    clear all
    load ResultDayTemp1
    load ResultDayTemp2
    
    MeanFirstPoke_Day1=mean([MeanFirstPoke_DayTemp1 MeanFirstPoke_DayTemp2]);
    PercReward_Day1=mean([PercReward_DayTemp1 PercReward_DayTemp2]);
    SuccesRule2_Day1=mean([SuccesRule2_DayTemp1 SuccesRule2_DayTemp2]);
    Time2Tone_Day1=mean([TimeTwoTone_DayTemp1 TimeTwoTone_DayTemp2]);
    
    NonRwdPokeMeanFq_Day1=mean([NonRwdPokeMeanFq_DayTemp1 NonRwdPokeMeanFq_DayTemp2]);
    NonRwdPokeMeanNb_Day1=mean([NonRwdPokeMeanNb_DayTemp1 NonRwdPokeMeanNb_DayTemp2]);
    NonRwdPokeNb_Day1=mean([NonRwdPokeNb_DayTemp1 NonRwdPokeNb_DayTemp2]);
    PokeEventNb_Day1=mean([PokeEventNb_DayTemp1 PokeEventNb_DayTemp2]);
    RwdPokeMeanFq_Day1=mean([RwdPokeMeanFq_DayTemp1 RwdPokeMeanFq_DayTemp2]);
    RwdPokeMeanNb_Day1=mean([RwdPokeMeanNb_DayTemp1 RwdPokeMeanNb_DayTemp2]);
    RwdPokeNb_Day1=mean([RwdPokeNb_DayTemp1 RwdPokeNb_DayTemp2]);
    RwdToneNb_Day1=mean([RwdToneNb_DayTemp1 RwdToneNb_DayTemp2]);
    
    IntraSessionMeanFirstPoke_Day1=[IntraSessionMeanFirstPoke_DayTemp1 IntraSessionMeanFirstPoke_DayTemp2];
    IntraSessionPercReward_Day1=[IntraSessionPercReward_DayTemp1 IntraSessionPercReward_DayTemp2];
    IntraSessionSuccesRule2_Day1=[IntraSessionSuccesRule2_DayTemp1 IntraSessionSuccesRule2_DayTemp2];
    IntraSessionTimeTwoTone_Day1=[IntraSessionTimeTwoTone_DayTemp1 IntraSessionTimeTwoTone_DayTemp2];
    
    % number of tone necessary to reach the 80% succes
    BeforeSucessPerc=find(IntraSessionPercReward_Day1>80);
    BeforeSucessPerc_Day1=BeforeSucessPerc(1)*10;
    
    % evolution of the Rule1 behavior along the session
    len=length(IntraSessionMeanFirstPoke_Day1)/2;
    IntraSessionFirstPoke_Day1(1)=mean(IntraSessionMeanFirstPoke_Day1(1:len));
    IntraSessionFirstPoke_Day1(2)=mean(IntraSessionMeanFirstPoke_Day1(len+1:2*len));
    
    % evolution of the Rule1 Success behavior along the session
    len=length(IntraSessionSuccesRule2_Day1)/2;
    IntraSessionPerc_Day1(1)=mean(IntraSessionPercReward_Day1(1:len));
    IntraSessionPerc_Day1(2)=mean(IntraSessionPercReward_Day1(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=length(IntraSessionSuccesRule2_Day1)/2;
    IntraSessionRule2_Day1(1)=mean(IntraSessionSuccesRule2_Day1(1:len));
    IntraSessionRule2_Day1(2)=mean(IntraSessionSuccesRule2_Day1(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=length(IntraSessionTimeTwoTone_Day1)/2;
    IntraSessionTime2Tone_Day1(1)=mean(IntraSessionTimeTwoTone_Day1(1:len));
    IntraSessionTime2Tone_Day1(2)=mean(IntraSessionTimeTwoTone_Day1(len+1:2*len));
    
    save ResultDay1 MeanFirstPoke_Day1 PercReward_Day1 SuccesRule2_Day1 Time2Tone_Day1 BeforeSucessPerc_Day1
    save ResultDay1 -append IntraSessionFirstPoke_Day1 IntraSessionPerc_Day1 IntraSessionRule2_Day1 IntraSessionTime2Tone_Day1
    save ResultDay1 -append RwdToneNb_Day1 PokeEventNb_Day1 RwdPokeNb_Day1 NonRwdPokeNb_Day1 RwdToneNb_Day1 NonRwdPokeMeanNb_Day1 RwdPokeMeanNb_Day1 RwdPokeMeanFq_Day1 NonRwdPokeMeanFq_Day1
   
end

% ------------------------ Step 2 : 1 seconds------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');

try load ResultDay2
catch
    cd([directoryName,'/20140519/ICSS-Mouse-133-19052014'])
    load LastResults_1sec
    
    MeanFirstPoke_DayTemp1=MeanFirstPoke;
    PercReward_DayTemp1=PercReward;
    SuccesRule2_DayTemp1=RdmSuccesRule2;
    TimeTwoTone_DayTemp1=TimeTwoTone;
    
    NonRwdPokeMeanFq_DayTemp1=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_DayTemp1=NonRwdPokeMeanNb;
    NonRwdPokeNb_DayTemp1=NonRwdPokeNb;
    PokeEventNb_DayTemp1=PokeEventNb;
    RwdPokeMeanFq_DayTemp1=RwdPokeMeanFq;
    RwdPokeMeanNb_DayTemp1=RwdPokeMeanNb;
    RwdPokeNb_DayTemp1=RwdPokeNb;
    RwdToneNb_DayTemp1=RwdToneNb;
    
    IntraSessionTimeTwoTone_DayTemp1=IntraSessionTimeTwoTone;
    IntraSessionMeanFirstPoke_DayTemp1=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_DayTemp1=IntraSessionPercReward;
    IntraSessionSuccesRule2_DayTemp1=IntraSessionSuccesRule2;
    
    cd([directoryName])
    save ResultDayTemp1 MeanFirstPoke_DayTemp1 PercReward_DayTemp1 SuccesRule2_DayTemp1 TimeTwoTone_DayTemp1 
    save ResultDayTemp1 -append IntraSessionMeanFirstPoke_DayTemp1 IntraSessionPercReward_DayTemp1 IntraSessionSuccesRule2_DayTemp1 IntraSessionTimeTwoTone_DayTemp1
    save ResultDayTemp1 -append RwdToneNb_DayTemp1 PokeEventNb_DayTemp1 RwdPokeNb_DayTemp1 NonRwdPokeNb_DayTemp1 RwdToneNb_DayTemp1 NonRwdPokeMeanNb_DayTemp1 RwdPokeMeanNb_DayTemp1 RwdPokeMeanFq_DayTemp1 NonRwdPokeMeanFq_DayTemp1
    
    % ------------------------ Day 3 : 1 seconds------------------
    clear all
    directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');
    cd([directoryName,'/20140521/ICSS-Mouse-133-21052014'])
    load LastResults
    
    MeanFirstPoke_DayTemp2=MeanFirstPoke;
    PercReward_DayTemp2=PercReward;
    SuccesRule2_DayTemp2=RdmSuccesRule2;
    TimeTwoTone_DayTemp2=TimeTwoTone;
    
    NonRwdPokeMeanFq_DayTemp2=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_DayTemp2=NonRwdPokeMeanNb;
    NonRwdPokeNb_DayTemp2=NonRwdPokeNb;
    PokeEventNb_DayTemp2=PokeEventNb;
    RwdPokeMeanFq_DayTemp2=RwdPokeMeanFq;
    RwdPokeMeanNb_DayTemp2=RwdPokeMeanNb;
    RwdPokeNb_DayTemp2=RwdPokeNb;
    RwdToneNb_DayTemp2=RwdToneNb;
    
    IntraSessionMeanFirstPoke_DayTemp2=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_DayTemp2=IntraSessionPercReward;
    IntraSessionSuccesRule2_DayTemp2=IntraSessionSuccesRule2;
    IntraSessionTimeTwoTone_DayTemp2=IntraSessionTimeTwoTone;

    directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');

    cd([directoryName])
    save ResultDayTemp2 MeanFirstPoke_DayTemp2 PercReward_DayTemp2 SuccesRule2_DayTemp2 TimeTwoTone_DayTemp2 
    save ResultDayTemp2 -append IntraSessionMeanFirstPoke_DayTemp2 IntraSessionPercReward_DayTemp2 IntraSessionSuccesRule2_DayTemp2 IntraSessionTimeTwoTone_DayTemp2
    save ResultDayTemp2 -append RwdToneNb_DayTemp2 PokeEventNb_DayTemp2 RwdPokeNb_DayTemp2 NonRwdPokeNb_DayTemp2 RwdToneNb_DayTemp2 NonRwdPokeMeanNb_DayTemp2 RwdPokeMeanNb_DayTemp2 RwdPokeMeanFq_DayTemp2 NonRwdPokeMeanFq_DayTemp2
    
    
    clear all
    load ResultDayTemp1
    load ResultDayTemp2
    
    MeanFirstPoke_Day2=mean([MeanFirstPoke_DayTemp1 MeanFirstPoke_DayTemp2]);
    PercReward_Day2=mean([PercReward_DayTemp1 PercReward_DayTemp2]);
    SuccesRule2_Day2=mean([SuccesRule2_DayTemp1 SuccesRule2_DayTemp2]);
    Time2Tone_Day2=mean([TimeTwoTone_DayTemp1 TimeTwoTone_DayTemp2]);
    
    NonRwdPokeMeanFq_Day2=mean([NonRwdPokeMeanFq_DayTemp1 NonRwdPokeMeanFq_DayTemp2]);
    NonRwdPokeMeanNb_Day2=mean([NonRwdPokeMeanNb_DayTemp1 NonRwdPokeMeanNb_DayTemp2]);
    NonRwdPokeNb_Day2=mean([NonRwdPokeNb_DayTemp1 NonRwdPokeNb_DayTemp2]);
    PokeEventNb_Day2=mean([PokeEventNb_DayTemp1 PokeEventNb_DayTemp2]);
    RwdPokeMeanFq_Day2=mean([RwdPokeMeanFq_DayTemp1 RwdPokeMeanFq_DayTemp2]);
    RwdPokeMeanNb_Day2=mean([RwdPokeMeanNb_DayTemp1 RwdPokeMeanNb_DayTemp2]);
    RwdPokeNb_Day2=mean([RwdPokeNb_DayTemp1 RwdPokeNb_DayTemp2]);
    RwdToneNb_Day2=mean([RwdToneNb_DayTemp1 RwdToneNb_DayTemp2]);
    
    IntraSessionMeanFirstPoke_Day2=[IntraSessionMeanFirstPoke_DayTemp1 IntraSessionMeanFirstPoke_DayTemp2];
    IntraSessionPercReward_Day2=[IntraSessionPercReward_DayTemp1 IntraSessionPercReward_DayTemp2];
    IntraSessionSuccesRule2_Day2=[IntraSessionSuccesRule2_DayTemp1 IntraSessionSuccesRule2_DayTemp2];
    IntraSessionTimeTwoTone_Day2=[IntraSessionTimeTwoTone_DayTemp1 IntraSessionTimeTwoTone_DayTemp2];
    
    % number of tone necessary to reach the 80% succes
    BeforeSucessPerc=find(IntraSessionPercReward_Day2>80);
    BeforeSucessPerc_Day2=BeforeSucessPerc(1)*10;
    
    % evolution of the Rule1 behavior along the session
    len=floor(length(IntraSessionMeanFirstPoke_Day2)/2);
    IntraSessionFirstPoke_Day2(1)=mean(IntraSessionMeanFirstPoke_Day2(1:len));
    IntraSessionFirstPoke_Day2(2)=mean(IntraSessionMeanFirstPoke_Day2(len+1:2*len));
    
    % evolution of the Rule1 Success behavior along the session
    len=floor(length(IntraSessionPercReward_Day2)/2);
    IntraSessionPerc_Day2(1)=mean(IntraSessionPercReward_Day2(1:len));
    IntraSessionPerc_Day2(2)=mean(IntraSessionPercReward_Day2(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionSuccesRule2_Day2)/2);
    IntraSessionRule2_Day2(1)=mean(IntraSessionSuccesRule2_Day2(1:len));
    IntraSessionRule2_Day2(2)=mean(IntraSessionSuccesRule2_Day2(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionTimeTwoTone_Day2)/2);
    IntraSessionTime2Tone_Day2(1)=mean(IntraSessionTimeTwoTone_Day2(1:len));
    IntraSessionTime2Tone_Day2(2)=mean(IntraSessionTimeTwoTone_Day2(len+1:2*len));
    
    save ResultDay2 MeanFirstPoke_Day2 PercReward_Day2 SuccesRule2_Day2 Time2Tone_Day2 BeforeSucessPerc_Day2
    save ResultDay2 -append IntraSessionFirstPoke_Day2 IntraSessionPerc_Day2 IntraSessionRule2_Day2 IntraSessionTime2Tone_Day2
    save ResultDay2 -append RwdToneNb_Day2 PokeEventNb_Day2 RwdPokeNb_Day2 NonRwdPokeNb_Day2 RwdToneNb_Day2 NonRwdPokeMeanNb_Day2 RwdPokeMeanNb_Day2 RwdPokeMeanFq_Day2 NonRwdPokeMeanFq_Day2
   
end

% ------------------------ Step 3 : 500 msec------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');

try load ResultDay3
catch
    cd([directoryName,'/20140522/ICSS-Mouse-133-22052014'])
    load LastResults
    
    MeanFirstPoke_DayTemp1=MeanFirstPoke;
    PercReward_DayTemp1=PercReward;
    SuccesRule2_DayTemp1=RdmSuccesRule2;
    TimeTwoTone_DayTemp1=TimeTwoTone;
    
    NonRwdPokeMeanFq_DayTemp1=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_DayTemp1=NonRwdPokeMeanNb;
    NonRwdPokeNb_DayTemp1=NonRwdPokeNb;
    PokeEventNb_DayTemp1=PokeEventNb;
    RwdPokeMeanFq_DayTemp1=RwdPokeMeanFq;
    RwdPokeMeanNb_DayTemp1=RwdPokeMeanNb;
    RwdPokeNb_DayTemp1=RwdPokeNb;
    RwdToneNb_DayTemp1=RwdToneNb;
    
    IntraSessionTimeTwoTone_DayTemp1=IntraSessionTimeTwoTone;
    IntraSessionMeanFirstPoke_DayTemp1=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_DayTemp1=IntraSessionPercReward;
    IntraSessionSuccesRule2_DayTemp1=IntraSessionSuccesRule2;
    
    cd([directoryName])
    save ResultDayTemp1 MeanFirstPoke_DayTemp1 PercReward_DayTemp1 SuccesRule2_DayTemp1 TimeTwoTone_DayTemp1 
    save ResultDayTemp1 -append IntraSessionMeanFirstPoke_DayTemp1 IntraSessionPercReward_DayTemp1 IntraSessionSuccesRule2_DayTemp1 IntraSessionTimeTwoTone_DayTemp1
    save ResultDayTemp1 -append RwdToneNb_DayTemp1 PokeEventNb_DayTemp1 RwdPokeNb_DayTemp1 NonRwdPokeNb_DayTemp1 RwdToneNb_DayTemp1 NonRwdPokeMeanNb_DayTemp1 RwdPokeMeanNb_DayTemp1 RwdPokeMeanFq_DayTemp1 NonRwdPokeMeanFq_DayTemp1
    
    % ------------------------ Day 2 : 5 seconds------------------
    clear all
    directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');
    cd([directoryName,'/20140603/ICSS-Mouse-133-03062014'])
    load LastResults
    
    MeanFirstPoke_DayTemp2=MeanFirstPoke;
    PercReward_DayTemp2=PercReward;
    SuccesRule2_DayTemp2=RdmSuccesRule2;
    TimeTwoTone_DayTemp2=TimeTwoTone;
    
    NonRwdPokeMeanFq_DayTemp2=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_DayTemp2=NonRwdPokeMeanNb;
    NonRwdPokeNb_DayTemp2=NonRwdPokeNb;
    PokeEventNb_DayTemp2=PokeEventNb;
    RwdPokeMeanFq_DayTemp2=RwdPokeMeanFq;
    RwdPokeMeanNb_DayTemp2=RwdPokeMeanNb;
    RwdPokeNb_DayTemp2=RwdPokeNb;
    RwdToneNb_DayTemp2=RwdToneNb;
    
    IntraSessionMeanFirstPoke_DayTemp2=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_DayTemp2=IntraSessionPercReward;
    IntraSessionSuccesRule2_DayTemp2=IntraSessionSuccesRule2;
    IntraSessionTimeTwoTone_DayTemp2=IntraSessionTimeTwoTone;

    directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');

    cd([directoryName])
    save ResultDayTemp2 MeanFirstPoke_DayTemp2 PercReward_DayTemp2 SuccesRule2_DayTemp2 TimeTwoTone_DayTemp2 
    save ResultDayTemp2 -append IntraSessionMeanFirstPoke_DayTemp2 IntraSessionPercReward_DayTemp2 IntraSessionSuccesRule2_DayTemp2 IntraSessionTimeTwoTone_DayTemp2
    save ResultDayTemp2 -append RwdToneNb_DayTemp2 PokeEventNb_DayTemp2 RwdPokeNb_DayTemp2 NonRwdPokeNb_DayTemp2 RwdToneNb_DayTemp2 NonRwdPokeMeanNb_DayTemp2 RwdPokeMeanNb_DayTemp2 RwdPokeMeanFq_DayTemp2 NonRwdPokeMeanFq_DayTemp2
    
    
    clear all
    load ResultDayTemp1
    load ResultDayTemp2
    
    MeanFirstPoke_Day3=mean([MeanFirstPoke_DayTemp1 MeanFirstPoke_DayTemp2]);
    PercReward_Day3=mean([PercReward_DayTemp1 PercReward_DayTemp2]);
    SuccesRule2_Day3=mean([SuccesRule2_DayTemp1 SuccesRule2_DayTemp2]);
    Time2Tone_Day3=mean([TimeTwoTone_DayTemp1 TimeTwoTone_DayTemp2]);
    
    NonRwdPokeMeanFq_Day3=mean([NonRwdPokeMeanFq_DayTemp1 NonRwdPokeMeanFq_DayTemp2]);
    NonRwdPokeMeanNb_Day3=mean([NonRwdPokeMeanNb_DayTemp1 NonRwdPokeMeanNb_DayTemp2]);
    NonRwdPokeNb_Day3=mean([NonRwdPokeNb_DayTemp1 NonRwdPokeNb_DayTemp2]);
    PokeEventNb_Day3=mean([PokeEventNb_DayTemp1 PokeEventNb_DayTemp2]);
    RwdPokeMeanFq_Day3=mean([RwdPokeMeanFq_DayTemp1 RwdPokeMeanFq_DayTemp2]);
    RwdPokeMeanNb_Day3=mean([RwdPokeMeanNb_DayTemp1 RwdPokeMeanNb_DayTemp2]);
    RwdPokeNb_Day3=mean([RwdPokeNb_DayTemp1 RwdPokeNb_DayTemp2]);
    RwdToneNb_Day3=mean([RwdToneNb_DayTemp1 RwdToneNb_DayTemp2]);
    
    IntraSessionMeanFirstPoke_Day3=[IntraSessionMeanFirstPoke_DayTemp1 IntraSessionMeanFirstPoke_DayTemp2];
    IntraSessionPercReward_Day3=[IntraSessionPercReward_DayTemp1 IntraSessionPercReward_DayTemp2];
    IntraSessionSuccesRule2_Day3=[IntraSessionSuccesRule2_DayTemp1 IntraSessionSuccesRule2_DayTemp2];
    IntraSessionTimeTwoTone_Day3=[IntraSessionTimeTwoTone_DayTemp1 IntraSessionTimeTwoTone_DayTemp2];
    
    % number of tone necessary to reach the 80% succes
    BeforeSucessPerc=find(IntraSessionPercReward_Day3>80);
    BeforeSucessPerc_Day3=BeforeSucessPerc(1)*10;
    
    % evolution of the Rule1 behavior along the session
    len=floor(length(IntraSessionMeanFirstPoke_Day3)/2);
    IntraSessionFirstPoke_Day3(1)=mean(IntraSessionMeanFirstPoke_Day3(1:len));
    IntraSessionFirstPoke_Day3(2)=mean(IntraSessionMeanFirstPoke_Day3(len+1:2*len));
    
    % evolution of the Rule1 Success behavior along the session
    len=floor(length(IntraSessionPercReward_Day3)/2);
    IntraSessionPerc_Day3(1)=mean(IntraSessionPercReward_Day3(1:len));
    IntraSessionPerc_Day3(2)=mean(IntraSessionPercReward_Day3(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionSuccesRule2_Day3)/2);
    IntraSessionRule2_Day3(1)=mean(IntraSessionSuccesRule2_Day3(1:len));
    IntraSessionRule2_Day3(2)=mean(IntraSessionSuccesRule2_Day3(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionTimeTwoTone_Day3)/2);
    IntraSessionTime2Tone_Day3(1)=mean(IntraSessionTimeTwoTone_Day3(1:len));
    IntraSessionTime2Tone_Day3(2)=mean(IntraSessionTimeTwoTone_Day3(len+1:2*len));
    
    save ResultDay3 MeanFirstPoke_Day3 PercReward_Day3 SuccesRule2_Day3 Time2Tone_Day3 BeforeSucessPerc_Day3
    save ResultDay3 -append IntraSessionFirstPoke_Day3 IntraSessionPerc_Day3 IntraSessionRule2_Day3 IntraSessionTime2Tone_Day3
    save ResultDay3 -append RwdToneNb_Day3 PokeEventNb_Day3 RwdPokeNb_Day3 NonRwdPokeNb_Day3 RwdToneNb_Day3 NonRwdPokeMeanNb_Day3 RwdPokeMeanNb_Day3 RwdPokeMeanFq_Day3 NonRwdPokeMeanFq_Day3
   
end

% ------------------------ Step 4 : 100 msec------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');

try load ResultDay4
catch
    cd([directoryName,'/20140605/ICSS-Mouse-133-05062014'])
    load LastResults
    
    MeanFirstPoke_Day4=MeanFirstPoke;
    PercReward_Day4=PercReward;
    SuccesRule2_Day4=RdmSuccesRule2;
    Time2Tone_Day4=mean(TimeTwoTone);
    
    NonRwdPokeMeanFq_Day4=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_Day4=NonRwdPokeMeanNb;
    NonRwdPokeNb_Day4=NonRwdPokeNb;
    PokeEventNb_Day4=PokeEventNb;
    RwdPokeMeanFq_Day4=RwdPokeMeanFq;
    RwdPokeMeanNb_Day4=RwdPokeMeanNb;
    RwdPokeNb_Day4=RwdPokeNb;
    RwdToneNb_Day4=RwdToneNb;
    
    IntraSessionTimeTwoTone_Day4=IntraSessionTimeTwoTone;
    IntraSessionMeanFirstPoke_Day4=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_Day4=IntraSessionPercReward;
    IntraSessionSuccesRule2_Day4=IntraSessionSuccesRule2;
    
    % number of tone necessary to reach the 80% succes
    BeforeSucessPerc=find(IntraSessionPercReward_Day4>80);
    BeforeSucessPerc_Day4=BeforeSucessPerc(1)*10;
    
    % evolution of the Rule1 behavior along the session
    len=floor(length(IntraSessionMeanFirstPoke_Day4)/2);
    IntraSessionFirstPoke_Day4(1)=mean(IntraSessionMeanFirstPoke_Day4(1:len));
    IntraSessionFirstPoke_Day4(2)=mean(IntraSessionMeanFirstPoke_Day4(len+1:2*len));
    
    % evolution of the Rule1 Success behavior along the session
    len=floor(length(IntraSessionPercReward_Day4)/2);
    IntraSessionPerc_Day4(1)=mean(IntraSessionPercReward_Day4(1:len));
    IntraSessionPerc_Day4(2)=mean(IntraSessionPercReward_Day4(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionSuccesRule2_Day4)/2);
    IntraSessionRule2_Day4(1)=mean(IntraSessionSuccesRule2_Day4(1:len));
    IntraSessionRule2_Day4(2)=mean(IntraSessionSuccesRule2_Day4(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionTimeTwoTone_Day4)/2);
    IntraSessionTime2Tone_Day4(1)=mean(IntraSessionTimeTwoTone_Day4(1:len));
    IntraSessionTime2Tone_Day4(2)=mean(IntraSessionTimeTwoTone_Day4(len+1:2*len));
    
    cd([directoryName])
    save ResultDay4 MeanFirstPoke_Day4 PercReward_Day4 SuccesRule2_Day4 Time2Tone_Day4 BeforeSucessPerc_Day4
    save ResultDay4 -append IntraSessionFirstPoke_Day4 IntraSessionPerc_Day4 IntraSessionRule2_Day4 IntraSessionTime2Tone_Day4
    save ResultDay4 -append RwdToneNb_Day4 PokeEventNb_Day4 RwdPokeNb_Day4 NonRwdPokeNb_Day4 RwdToneNb_Day4 NonRwdPokeMeanNb_Day4 RwdPokeMeanNb_Day4 RwdPokeMeanFq_Day4 NonRwdPokeMeanFq_Day4
   
end

% --------------------- Step 5 : 100ms /Gen  ------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');

try load ResultDay5
catch
    cd([directoryName,'/20140610/ICSS-Mouse-133-10062014'])
    load LastResults
    
    MeanFirstPoke_DayTemp1=MeanFirstPoke;
    PercReward_DayTemp1=PercReward;
    SuccesRule2_DayTemp1=RdmSuccesRule2;
    TimeTwoTone_DayTemp1=TimeTwoTone;
    
    NonRwdPokeMeanFq_DayTemp1=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_DayTemp1=NonRwdPokeMeanNb;
    NonRwdPokeNb_DayTemp1=NonRwdPokeNb;
    PokeEventNb_DayTemp1=PokeEventNb;
    RwdPokeMeanFq_DayTemp1=RwdPokeMeanFq;
    RwdPokeMeanNb_DayTemp1=RwdPokeMeanNb;
    RwdPokeNb_DayTemp1=RwdPokeNb;
    RwdToneNb_DayTemp1=RwdToneNb;
    
    IntraSessionTimeTwoTone_DayTemp1=IntraSessionTimeTwoTone;
    IntraSessionMeanFirstPoke_DayTemp1=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_DayTemp1=IntraSessionPercReward;
    IntraSessionSuccesRule2_DayTemp1=IntraSessionSuccesRule2;
    
    cd([directoryName])
    save ResultDayTemp1 MeanFirstPoke_DayTemp1 PercReward_DayTemp1 SuccesRule2_DayTemp1 TimeTwoTone_DayTemp1 
    save ResultDayTemp1 -append IntraSessionMeanFirstPoke_DayTemp1 IntraSessionPercReward_DayTemp1 IntraSessionSuccesRule2_DayTemp1 IntraSessionTimeTwoTone_DayTemp1
    save ResultDayTemp1 -append RwdToneNb_DayTemp1 PokeEventNb_DayTemp1 RwdPokeNb_DayTemp1 NonRwdPokeNb_DayTemp1 RwdToneNb_DayTemp1 NonRwdPokeMeanNb_DayTemp1 RwdPokeMeanNb_DayTemp1 RwdPokeMeanFq_DayTemp1 NonRwdPokeMeanFq_DayTemp1
    
    % ------------------------ Day 2 : 5 seconds------------------
    clear all
    directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');
    cd([directoryName,'/20140611/ICSS-Mouse-133-11062014'])
    load LastResults
    
    MeanFirstPoke_DayTemp2=MeanFirstPoke;
    PercReward_DayTemp2=PercReward;
    SuccesRule2_DayTemp2=RdmSuccesRule2;
    TimeTwoTone_DayTemp2=TimeTwoTone;
    
    NonRwdPokeMeanFq_DayTemp2=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_DayTemp2=NonRwdPokeMeanNb;
    NonRwdPokeNb_DayTemp2=NonRwdPokeNb;
    PokeEventNb_DayTemp2=PokeEventNb;
    RwdPokeMeanFq_DayTemp2=RwdPokeMeanFq;
    RwdPokeMeanNb_DayTemp2=RwdPokeMeanNb;
    RwdPokeNb_DayTemp2=RwdPokeNb;
    RwdToneNb_DayTemp2=RwdToneNb;
    
    IntraSessionMeanFirstPoke_DayTemp2=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_DayTemp2=IntraSessionPercReward;
    IntraSessionSuccesRule2_DayTemp2=IntraSessionSuccesRule2;
    IntraSessionTimeTwoTone_DayTemp2=IntraSessionTimeTwoTone;

    directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');

    cd([directoryName])
    save ResultDayTemp2 MeanFirstPoke_DayTemp2 PercReward_DayTemp2 SuccesRule2_DayTemp2 TimeTwoTone_DayTemp2 
    save ResultDayTemp2 -append IntraSessionMeanFirstPoke_DayTemp2 IntraSessionPercReward_DayTemp2 IntraSessionSuccesRule2_DayTemp2 IntraSessionTimeTwoTone_DayTemp2
    save ResultDayTemp2 -append RwdToneNb_DayTemp2 PokeEventNb_DayTemp2 RwdPokeNb_DayTemp2 NonRwdPokeNb_DayTemp2 RwdToneNb_DayTemp2 NonRwdPokeMeanNb_DayTemp2 RwdPokeMeanNb_DayTemp2 RwdPokeMeanFq_DayTemp2 NonRwdPokeMeanFq_DayTemp2
    
    
    clear all
    load ResultDayTemp1
    load ResultDayTemp2
    
    MeanFirstPoke_Day5=mean([MeanFirstPoke_DayTemp1 MeanFirstPoke_DayTemp2]);
    PercReward_Day5=mean([PercReward_DayTemp1 PercReward_DayTemp2]);
    SuccesRule2_Day5=mean([SuccesRule2_DayTemp1 SuccesRule2_DayTemp2]);
    Time2Tone_Day5=mean([TimeTwoTone_DayTemp1 TimeTwoTone_DayTemp2]);
    
    NonRwdPokeMeanFq_Day5=mean([NonRwdPokeMeanFq_DayTemp1 NonRwdPokeMeanFq_DayTemp2]);
    NonRwdPokeMeanNb_Day5=mean([NonRwdPokeMeanNb_DayTemp1 NonRwdPokeMeanNb_DayTemp2]);
    NonRwdPokeNb_Day5=mean([NonRwdPokeNb_DayTemp1 NonRwdPokeNb_DayTemp2]);
    PokeEventNb_Day5=mean([PokeEventNb_DayTemp1 PokeEventNb_DayTemp2]);
    RwdPokeMeanFq_Day5=mean([RwdPokeMeanFq_DayTemp1 RwdPokeMeanFq_DayTemp2]);
    RwdPokeMeanNb_Day5=mean([RwdPokeMeanNb_DayTemp1 RwdPokeMeanNb_DayTemp2]);
    RwdPokeNb_Day5=mean([RwdPokeNb_DayTemp1 RwdPokeNb_DayTemp2]);
    RwdToneNb_Day5=mean([RwdToneNb_DayTemp1 RwdToneNb_DayTemp2]);
    
    IntraSessionMeanFirstPoke_Day5=[IntraSessionMeanFirstPoke_DayTemp1 IntraSessionMeanFirstPoke_DayTemp2];
    IntraSessionPercReward_Day5=[IntraSessionPercReward_DayTemp1 IntraSessionPercReward_DayTemp2];
    IntraSessionSuccesRule2_Day5=[IntraSessionSuccesRule2_DayTemp1 IntraSessionSuccesRule2_DayTemp2];
    IntraSessionTimeTwoTone_Day5=[IntraSessionTimeTwoTone_DayTemp1 IntraSessionTimeTwoTone_DayTemp2];
    
    % number of tone necessary to reach the 80% succes
    BeforeSucessPerc=find(IntraSessionPercReward_Day5>80);
    BeforeSucessPerc_Day5=BeforeSucessPerc(1)*10;
    
    % evolution of the Rule1 behavior along the session
    len=length(IntraSessionMeanFirstPoke_Day5)/2;
    IntraSessionFirstPoke_Day5(1)=mean(IntraSessionMeanFirstPoke_Day5(1:len));
    IntraSessionFirstPoke_Day5(2)=mean(IntraSessionMeanFirstPoke_Day5(len+1:2*len));
    
    % evolution of the Rule1 Success behavior along the session
    len=length(IntraSessionPercReward_Day5)/2;
    IntraSessionPerc_Day5(1)=mean(IntraSessionPercReward_Day5(1:len));
    IntraSessionPerc_Day5(2)=mean(IntraSessionPercReward_Day5(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=length(IntraSessionSuccesRule2_Day5)/2;
    IntraSessionRule2_Day5(1)=mean(IntraSessionSuccesRule2_Day5(1:len));
    IntraSessionRule2_Day5(2)=mean(IntraSessionSuccesRule2_Day5(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=length(IntraSessionTimeTwoTone_Day5)/2;
    IntraSessionTime2Tone_Day5(1)=mean(IntraSessionTimeTwoTone_Day5(1:len));
    IntraSessionTime2Tone_Day5(2)=mean(IntraSessionTimeTwoTone_Day5(len+1:2*len));
    
    save ResultDay5 MeanFirstPoke_Day5 PercReward_Day5 SuccesRule2_Day5 Time2Tone_Day5 BeforeSucessPerc_Day5
    save ResultDay5 -append IntraSessionFirstPoke_Day5 IntraSessionPerc_Day5 IntraSessionRule2_Day5 IntraSessionTime2Tone_Day5
    save ResultDay5 -append RwdToneNb_Day5 PokeEventNb_Day5 RwdPokeNb_Day5 NonRwdPokeNb_Day5 RwdToneNb_Day5 NonRwdPokeMeanNb_Day5 RwdPokeMeanNb_Day5 RwdPokeMeanFq_Day5 NonRwdPokeMeanFq_Day5
end

% ------------------ Step 5 : Generalization ------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');
cd([directoryName])

try load ResultGeneralization
catch
    cd([directoryName,'/20140610/ICSS-Mouse-133-10062014'])
    load GeneralizationResult
    
    MeanFirstPoke20kHz_M133=MeanFirstPokeGen20kHz;
    MeanFirstPoke25kHz_M133=MeanFirstPokeGen25kHz;
    MeanFirstPoke30kHz_M133=MeanFirstPokeGen30kHz;
    
    PercReward20kHz_M133=PercRewardGen20kHz;
    PercReward25kHz_M133=PercRewardGen25kHz;
    PercReward30kHz_M133=PercRewardGen30kHz;
    
    Poke20kHzNb_M133=Poke20kHzNb;
    Poke25kHzNb_M133=Poke25kHzNb;
    Poke30kHzNb_M133=Poke30kHzNb;
    
    Poke20kHzMeanNb_M133=Poke20kHzMeanNb;
    Poke25kHzMeanNb_M133=Poke25kHzMeanNb;
    Poke30kHzMeanNb_M133=Poke30kHzMeanNb;
        
    Poke20kHzMeanFq_M133=Poke20kHzMeanFq;
    Poke25kHzMeanFq_M133=Poke25kHzMeanFq;
    Poke30kHzMeanFq_M133=Poke30kHzMeanFq;
    
    Tone20kHzNb_M133=Tone20kHzNb;
    Tone25kHzNb_M133=Tone25kHzNb;
    Tone30kHzNb_M133=Tone30kHzNb;
    
    cd([directoryName,'/20140611/ICSS-Mouse-133-11062014'])
    load GeneralizationResult
    
    MeanFirstPoke5kHz_M133=MeanFirstPokeGen5kHz;
    MeanFirstPoke15kHz_M133=MeanFirstPokeGen15kHz;
    MeanFirstPoke10kHz_M133=MeanFirstPokeGen10kHz;
    
    PercReward5kHz_M133=PercRewardGen5kHz;
    PercReward15kHz_M133=PercRewardGen15kHz;
    PercReward10kHz_M133=PercRewardGen10kHz;
    
    Poke5kHzNb_M133=Poke5kHzNb;
    Poke15kHzNb_M133=Poke15kHzNb;
    Poke10kHzNb_M133=Poke10kHzNb;
    
    Poke5kHzMeanNb_M133=Poke5kHzMeanNb;
    Poke15kHzMeanNb_M133=Poke15kHzMeanNb;
    Poke10kHzMeanNb_M133=Poke10kHzMeanNb;
        
    Poke5kHzMeanFq_M133=Poke5kHzMeanFq;
    Poke15kHzMeanFq_M133=Poke15kHzMeanFq;
    Poke10kHzMeanFq_M133=Poke10kHzMeanFq;
    
    Tone5kHzNb_M133=Tone5kHzNb;
    Tone15kHzNb_M133=Tone15kHzNb;
    Tone10kHzNb_M133=Tone10kHzNb;
    
    cd([directoryName])
    save ResultGeneralization_M133 MeanFirstPoke5kHz_M133 MeanFirstPoke10kHz_M133 MeanFirstPoke15kHz_M133 MeanFirstPoke20kHz_M133  MeanFirstPoke25kHz_M133 MeanFirstPoke30kHz_M133
    save ResultGeneralization_M133 -append PercReward5kHz_M133 PercReward10kHz_M133 PercReward15kHz_M133 PercReward20kHz_M133 PercReward25kHz_M133 PercReward30kHz_M133
    save ResultGeneralization_M133 -append Poke5kHzNb_M133 Poke10kHzNb_M133 Poke15kHzNb_M133 Poke20kHzNb_M133 Poke25kHzNb_M133 Poke30kHzNb_M133
    save ResultGeneralization_M133 -append Poke5kHzMeanNb_M133 Poke10kHzMeanNb_M133 Poke15kHzMeanNb_M133 Poke20kHzMeanNb_M133 Poke25kHzMeanNb_M133 Poke30kHzMeanNb_M133
    save ResultGeneralization_M133 -append Poke5kHzMeanFq_M133 Poke10kHzMeanFq_M133 Poke15kHzMeanFq_M133 Poke20kHzMeanFq_M133 Poke25kHzMeanFq_M133 Poke30kHzMeanFq_M133
    save ResultGeneralization_M133 -append Tone5kHzNb_M133 Tone10kHzNb_M133 Tone15kHzNb_M133 Tone20kHzNb_M133 Tone25kHzNb_M133 Tone30kHzNb_M133
    
end

clear all
load ResultDay5
MeanFirstPoke12kHz_M133=MeanFirstPoke_Day5;
PercReward12kHz_M133=PercReward_Day5;
Poke12kHzNb_M133=RwdPokeNb_Day5;
Poke12kHzMeanNb_M133=RwdPokeMeanNb_Day5;
Poke12kHzMeanFq_M133=RwdPokeMeanFq_Day5;
Tone12kHzNb_M133=RwdToneNb_Day5;
  
save ResultGeneralization_M133 -append MeanFirstPoke12kHz_M133 PercReward12kHz_M133 Poke12kHzNb_M133 Poke12kHzMeanNb_M133 Poke12kHzMeanFq_M133 Tone12kHzNb_M133

%------------------------------------------------------------%------------------------------------------------------------%------------------------------------------------------------
%------------------------------------------------------------%------------------------------------------------------------%------------------------------------------------------------

% ------------------------------------------------------------
% ------------------------ Mouse 142 -------------------------
% ------------------------------------------------------------

% ------------------------ Day 1 : 5 seconds------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse142');
cd([directoryName])
try load ResultDay1
catch
    cd([directoryName,'/20140722/ICSS-Mouse-142-22072014'])
    load LastResults
    
    MeanFirstPoke_Day1=MeanFirstPoke;
    PercReward_Day1=PercReward;
    SuccesRule2_Day1=RdmSuccesRule2;
    Time2Tone_Day1=mean(TimeTwoTone);
    
    NonRwdPokeMeanFq_Day1=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_Day1=NonRwdPokeMeanNb;
    NonRwdPokeNb_Day1=NonRwdPokeNb;
    PokeEventNb_Day1=PokeEventNb;
    RwdPokeMeanFq_Day1=RwdPokeMeanFq;
    RwdPokeMeanNb_Day1=RwdPokeMeanNb;
    RwdPokeNb_Day1=RwdPokeNb;
    RwdToneNb_Day1=RwdToneNb;
    
    IntraSessionTimeTwoTone_Day1=IntraSessionTimeTwoTone;
    IntraSessionMeanFirstPoke_Day1=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_Day1=IntraSessionPercReward;
    IntraSessionSuccesRule2_Day1=IntraSessionSuccesRule2;
    
    % number of tone necessary to reach the 80% succes
    BeforeSucessPerc=find(IntraSessionPercReward_Day1>80);
    BeforeSucessPerc_Day1=BeforeSucessPerc(1)*10;
    
    % evolution of the Rule1 behavior along the session
    len=floor(length(IntraSessionMeanFirstPoke_Day1)/2);
    IntraSessionFirstPoke_Day1(1)=mean(IntraSessionMeanFirstPoke_Day1(1:len));
    IntraSessionFirstPoke_Day1(2)=mean(IntraSessionMeanFirstPoke_Day1(len+1:2*len));
    
    % evolution of the Rule1 Success behavior along the session
    len=floor(length(IntraSessionPercReward_Day1)/2);
    IntraSessionPerc_Day1(1)=mean(IntraSessionPercReward_Day1(1:len));
    IntraSessionPerc_Day1(2)=mean(IntraSessionPercReward_Day1(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionSuccesRule2_Day1)/2);
    IntraSessionRule2_Day1(1)=mean(IntraSessionSuccesRule2_Day1(1:len));
    IntraSessionRule2_Day1(2)=mean(IntraSessionSuccesRule2_Day1(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionTimeTwoTone_Day1)/2);
    IntraSessionTime2Tone_Day1(1)=mean(IntraSessionTimeTwoTone_Day1(1:len));
    IntraSessionTime2Tone_Day1(2)=mean(IntraSessionTimeTwoTone_Day1(len+1:2*len));
    
    cd([directoryName])
    save ResultDay1 MeanFirstPoke_Day1 PercReward_Day1 SuccesRule2_Day1 Time2Tone_Day1 BeforeSucessPerc_Day1
    save ResultDay1 -append IntraSessionFirstPoke_Day1 IntraSessionPerc_Day1 IntraSessionRule2_Day1 IntraSessionTime2Tone_Day1
    save ResultDay1 -append RwdToneNb_Day1 PokeEventNb_Day1 RwdPokeNb_Day1 NonRwdPokeNb_Day1 RwdToneNb_Day1 NonRwdPokeMeanNb_Day1 RwdPokeMeanNb_Day1 RwdPokeMeanFq_Day1 NonRwdPokeMeanFq_Day1
end

% ------------------------ Day 2 : 1 seconds------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse142');
cd([directoryName])
try load ResultDay2
catch
    cd([directoryName,'/20140723/ICSS-Mouse-142-23072014'])
    load LastResults
    
    MeanFirstPoke_Day2=MeanFirstPoke;
    PercReward_Day2=PercReward;
    SuccesRule2_Day2=RdmSuccesRule2;
    Time2Tone_Day2=mean(TimeTwoTone);
    
    NonRwdPokeMeanFq_Day2=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_Day2=NonRwdPokeMeanNb;
    NonRwdPokeNb_Day2=NonRwdPokeNb;
    PokeEventNb_Day2=PokeEventNb;
    RwdPokeMeanFq_Day2=RwdPokeMeanFq;
    RwdPokeMeanNb_Day2=RwdPokeMeanNb;
    RwdPokeNb_Day2=RwdPokeNb;
    RwdToneNb_Day2=RwdToneNb;
    
    IntraSessionTimeTwoTone_Day2=IntraSessionTimeTwoTone;
    IntraSessionMeanFirstPoke_Day2=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_Day2=IntraSessionPercReward;
    IntraSessionSuccesRule2_Day2=IntraSessionSuccesRule2;
    
    % number of tone necessary to reach the 80% succes
    BeforeSucessPerc=find(IntraSessionPercReward_Day2>80);
    BeforeSucessPerc_Day2=BeforeSucessPerc(1)*10;
    
    % evolution of the Rule1 behavior along the session
    len=floor(length(IntraSessionMeanFirstPoke_Day2)/2);
    IntraSessionFirstPoke_Day2(1)=mean(IntraSessionMeanFirstPoke_Day2(1:len));
    IntraSessionFirstPoke_Day2(2)=mean(IntraSessionMeanFirstPoke_Day2(len+1:2*len));
    
    % evolution of the Rule1 Success behavior along the session
    len=floor(length(IntraSessionPercReward_Day2)/2);
    IntraSessionPerc_Day2(1)=mean(IntraSessionPercReward_Day2(1:len));
    IntraSessionPerc_Day2(2)=mean(IntraSessionPercReward_Day2(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionSuccesRule2_Day2)/2);
    IntraSessionRule2_Day2(1)=mean(IntraSessionSuccesRule2_Day2(1:len));
    IntraSessionRule2_Day2(2)=mean(IntraSessionSuccesRule2_Day2(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionTimeTwoTone_Day2)/2);
    IntraSessionTime2Tone_Day2(1)=mean(IntraSessionTimeTwoTone_Day2(1:len));
    IntraSessionTime2Tone_Day2(2)=mean(IntraSessionTimeTwoTone_Day2(len+1:2*len));
    
    cd([directoryName])
    save ResultDay2 MeanFirstPoke_Day2 PercReward_Day2 SuccesRule2_Day2 Time2Tone_Day2 BeforeSucessPerc_Day2
    save ResultDay2 -append IntraSessionFirstPoke_Day2 IntraSessionPerc_Day2 IntraSessionRule2_Day2 IntraSessionTime2Tone_Day2
    save ResultDay2 -append RwdToneNb_Day2 PokeEventNb_Day2 RwdPokeNb_Day2 NonRwdPokeNb_Day2 RwdToneNb_Day2 NonRwdPokeMeanNb_Day2 RwdPokeMeanNb_Day2 RwdPokeMeanFq_Day2 NonRwdPokeMeanFq_Day2
end

% ------------------------ Day 3 : 500 msec------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse142');
cd([directoryName])
try load ResultDay3
catch
    <cd([directoryName,'/20140826/MMN-Mouse-142-26082014'])
    load LastResults_500ms
    
    MeanFirstPoke_Day3=MeanFirstPoke;
    PercReward_Day3=PercReward;
    SuccesRule2_Day3=RdmSuccesRule2;
    Time2Tone_Day3=mean(TimeTwoTone);
    
    NonRwdPokeMeanFq_Day3=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_Day3=NonRwdPokeMeanNb;
    NonRwdPokeNb_Day3=NonRwdPokeNb;
    PokeEventNb_Day3=PokeEventNb;
    RwdPokeMeanFq_Day3=RwdPokeMeanFq;
    RwdPokeMeanNb_Day3=RwdPokeMeanNb;
    RwdPokeNb_Day3=RwdPokeNb;
    RwdToneNb_Day3=RwdToneNb;
    
    IntraSessionTimeTwoTone_Day3=IntraSessionTimeTwoTone;
    IntraSessionMeanFirstPoke_Day3=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_Day3=IntraSessionPercReward;
    IntraSessionSuccesRule2_Day3=IntraSessionSuccesRule2;
    
    % number of tone necessary to reach the 80% succes
    BeforeSucessPerc=find(IntraSessionPercReward_Day3>80);
    BeforeSucessPerc_Day3=BeforeSucessPerc(1)*10;
    
    % evolution of the Rule1 behavior along the session
    len=floor(length(IntraSessionMeanFirstPoke_Day3)/2);
    IntraSessionFirstPoke_Day3(1)=mean(IntraSessionMeanFirstPoke_Day3(1:len));
    IntraSessionFirstPoke_Day3(2)=mean(IntraSessionMeanFirstPoke_Day3(len+1:2*len));
    
    % evolution of the Rule1 Success behavior along the session
    len=floor(length(IntraSessionPercReward_Day3)/2);
    IntraSessionPerc_Day3(1)=mean(IntraSessionPercReward_Day3(1:len));
    IntraSessionPerc_Day3(2)=mean(IntraSessionPercReward_Day3(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionSuccesRule2_Day3)/2);
    IntraSessionRule2_Day3(1)=mean(IntraSessionSuccesRule2_Day3(1:len));
    IntraSessionRule2_Day3(2)=mean(IntraSessionSuccesRule2_Day3(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionTimeTwoTone_Day3)/2);
    IntraSessionTime2Tone_Day3(1)=mean(IntraSessionTimeTwoTone_Day3(1:len));
    IntraSessionTime2Tone_Day3(2)=mean(IntraSessionTimeTwoTone_Day3(len+1:2*len));
    
    cd([directoryName])
    save ResultDay3 MeanFirstPoke_Day3 PercReward_Day3 SuccesRule2_Day3 Time2Tone_Day3 BeforeSucessPerc_Day3
    save ResultDay3 -append IntraSessionFirstPoke_Day3 IntraSessionPerc_Day3 IntraSessionRule2_Day3 IntraSessionTime2Tone_Day3
    save ResultDay3 -append RwdToneNb_Day3 PokeEventNb_Day3 RwdPokeNb_Day3 NonRwdPokeNb_Day3 RwdToneNb_Day3 NonRwdPokeMeanNb_Day3 RwdPokeMeanNb_Day3 RwdPokeMeanFq_Day3 NonRwdPokeMeanFq_Day3
end

% ------------------------ Day 4 : 100 msec------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse142');
cd([directoryName])
try load ResultDay4
catch
    cd([directoryName,'/20140826/MMN-Mouse-142-26082014'])
    load LastResults_100ms
    
    MeanFirstPoke_Day4=MeanFirstPoke;
    PercReward_Day4=PercReward;
    SuccesRule2_Day4=RdmSuccesRule2;
    Time2Tone_Day4=mean(TimeTwoTone);
    
    NonRwdPokeMeanFq_Day4=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_Day4=NonRwdPokeMeanNb;
    NonRwdPokeNb_Day4=NonRwdPokeNb;
    PokeEventNb_Day4=PokeEventNb;
    RwdPokeMeanFq_Day4=RwdPokeMeanFq;
    RwdPokeMeanNb_Day4=RwdPokeMeanNb;
    RwdPokeNb_Day4=RwdPokeNb;
    RwdToneNb_Day4=RwdToneNb;
    
    IntraSessionTimeTwoTone_Day4=IntraSessionTimeTwoTone;
    IntraSessionMeanFirstPoke_Day4=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_Day4=IntraSessionPercReward;
    IntraSessionSuccesRule2_Day4=IntraSessionSuccesRule2;
    
    % number of tone necessary to reach the 80% succes
    BeforeSucessPerc=find(IntraSessionPercReward_Day4>80);
    BeforeSucessPerc_Day4=BeforeSucessPerc(1)*10;
    
    % evolution of the Rule1 behavior along the session
    len=floor(length(IntraSessionMeanFirstPoke_Day4)/2);
    IntraSessionFirstPoke_Day4(1)=mean(IntraSessionMeanFirstPoke_Day4(1:len));
    IntraSessionFirstPoke_Day4(2)=mean(IntraSessionMeanFirstPoke_Day4(len+1:2*len));
    
    % evolution of the Rule1 Success behavior along the session
    len=floor(length(IntraSessionPercReward_Day4)/2);
    IntraSessionPerc_Day4(1)=mean(IntraSessionPercReward_Day4(1:len));
    IntraSessionPerc_Day4(2)=mean(IntraSessionPercReward_Day4(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionSuccesRule2_Day4)/2);
    IntraSessionRule2_Day4(1)=mean(IntraSessionSuccesRule2_Day4(1:len));
    IntraSessionRule2_Day4(2)=mean(IntraSessionSuccesRule2_Day4(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionTimeTwoTone_Day4)/2);
    IntraSessionTime2Tone_Day4(1)=mean(IntraSessionTimeTwoTone_Day4(1:len));
    IntraSessionTime2Tone_Day4(2)=mean(IntraSessionTimeTwoTone_Day4(len+1:2*len));
    
    cd([directoryName])
    save ResultDay4 MeanFirstPoke_Day4 PercReward_Day4 SuccesRule2_Day4 Time2Tone_Day4 BeforeSucessPerc_Day4
    save ResultDay4 -append IntraSessionFirstPoke_Day4 IntraSessionPerc_Day4 IntraSessionRule2_Day4 IntraSessionTime2Tone_Day4
    save ResultDay4 -append RwdToneNb_Day4 PokeEventNb_Day4 RwdPokeNb_Day4 NonRwdPokeNb_Day4 RwdToneNb_Day4 NonRwdPokeMeanNb_Day4 RwdPokeMeanNb_Day4 RwdPokeMeanFq_Day4 NonRwdPokeMeanFq_Day4
   
end

% ------------------- Day 5 : 100 msec / Gen ------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse142');
cd([directoryName])
try load ResultDay5
catch
    cd([directoryName,'/20140827/MMN-Mouse-142-27082014'])
    load LastResults
    
    MeanFirstPoke_Day5=MeanFirstPoke;
    PercReward_Day5=PercReward;
    SuccesRule2_Day5=RdmSuccesRule2;
    Time2Tone_Day5=mean(TimeTwoTone);
    
    NonRwdPokeMeanFq_Day5=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_Day5=NonRwdPokeMeanNb;
    NonRwdPokeNb_Day5=NonRwdPokeNb;
    PokeEventNb_Day5=PokeEventNb;
    RwdPokeMeanFq_Day5=RwdPokeMeanFq;
    RwdPokeMeanNb_Day5=RwdPokeMeanNb;
    RwdPokeNb_Day5=RwdPokeNb;
    RwdToneNb_Day5=RwdToneNb;
    
    IntraSessionTimeTwoTone_Day5=IntraSessionTimeTwoTone;
    IntraSessionMeanFirstPoke_Day5=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_Day5=IntraSessionPercReward;
    IntraSessionSuccesRule2_Day5=IntraSessionSuccesRule2;
    
    % number of tone necessary to reach the 80% succes
    BeforeSucessPerc=find(IntraSessionPercReward_Day5>80);
    BeforeSucessPerc_Day5=BeforeSucessPerc(1)*10;
    
    % evolution of the Rule1 behavior along the session
    len=floor(length(IntraSessionMeanFirstPoke_Day5)/2);
    IntraSessionFirstPoke_Day5(1)=mean(IntraSessionMeanFirstPoke_Day5(1:len));
    IntraSessionFirstPoke_Day5(2)=mean(IntraSessionMeanFirstPoke_Day5(len+1:2*len));
    
    % evolution of the Rule1 Success behavior along the session
    len=floor(length(IntraSessionPercReward_Day5)/2);
    IntraSessionPerc_Day5(1)=mean(IntraSessionPercReward_Day5(1:len));
    IntraSessionPerc_Day5(2)=mean(IntraSessionPercReward_Day5(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionSuccesRule2_Day5)/2);
    IntraSessionRule2_Day5(1)=mean(IntraSessionSuccesRule2_Day5(1:len));
    IntraSessionRule2_Day5(2)=mean(IntraSessionSuccesRule2_Day5(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionTimeTwoTone_Day5)/2);
    IntraSessionTime2Tone_Day5(1)=mean(IntraSessionTimeTwoTone_Day5(1:len));
    IntraSessionTime2Tone_Day5(2)=mean(IntraSessionTimeTwoTone_Day5(len+1:2*len));
    
    cd([directoryName])
    save ResultDay5 MeanFirstPoke_Day5 PercReward_Day5 SuccesRule2_Day5 Time2Tone_Day5 BeforeSucessPerc_Day5
    save ResultDay5 -append IntraSessionFirstPoke_Day5 IntraSessionPerc_Day5 IntraSessionRule2_Day5 IntraSessionTime2Tone_Day5
    save ResultDay5 -append RwdToneNb_Day5 PokeEventNb_Day5 RwdPokeNb_Day5 NonRwdPokeNb_Day5 RwdToneNb_Day5 NonRwdPokeMeanNb_Day5 RwdPokeMeanNb_Day5 RwdPokeMeanFq_Day5 NonRwdPokeMeanFq_Day5
   
end


% ----------------- Day 5 : 100 Generalization ----------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse142');
cd([directoryName])
try load ResultGeneralization
catch
    cd([directoryName,'/20140827/MMN-Mouse-142-27082014'])
    load GeneralizationResult
        
    MeanFirstPoke5kHz_M142=MeanFirstPokeGen5kHz;
    MeanFirstPoke15kHz_M142=MeanFirstPokeGen15kHz;
    MeanFirstPoke10kHz_M142=MeanFirstPokeGen10kHz;
    MeanFirstPoke20kHz_M142=MeanFirstPokeGen20kHz;
    MeanFirstPoke25kHz_M142=MeanFirstPokeGen25kHz;
    MeanFirstPoke30kHz_M142=MeanFirstPokeGen30kHz;
    
    PercReward5kHz_M142=PercRewardGen5kHz;
    PercReward15kHz_M142=PercRewardGen15kHz;
    PercReward10kHz_M142=PercRewardGen10kHz;
    PercReward20kHz_M142=PercRewardGen20kHz;
    PercReward25kHz_M142=PercRewardGen25kHz;
    PercReward30kHz_M142=PercRewardGen30kHz;
    
    Poke5kHzNb_M142=Poke5kHzNb;
    Poke15kHzNb_M142=Poke15kHzNb;
    Poke10kHzNb_M142=Poke10kHzNb;
    Poke20kHzNb_M142=Poke20kHzNb;
    Poke25kHzNb_M142=Poke25kHzNb;
    Poke30kHzNb_M142=Poke30kHzNb;
    
    Poke5kHzMeanNb_M142=Poke5kHzMeanNb;
    Poke15kHzMeanNb_M142=Poke15kHzMeanNb;
    Poke10kHzMeanNb_M142=Poke10kHzMeanNb;
    Poke20kHzMeanNb_M142=Poke20kHzMeanNb;
    Poke25kHzMeanNb_M142=Poke25kHzMeanNb;
    Poke30kHzMeanNb_M142=Poke30kHzMeanNb;
         
    Poke5kHzMeanFq_M142=Poke5kHzMeanFq;
    Poke15kHzMeanFq_M142=Poke15kHzMeanFq;
    Poke10kHzMeanFq_M142=Poke10kHzMeanFq;   
    Poke20kHzMeanFq_M142=Poke20kHzMeanFq;
    Poke25kHzMeanFq_M142=Poke25kHzMeanFq;
    Poke30kHzMeanFq_M142=Poke30kHzMeanFq;
    
    Tone5kHzNb_M142=Tone5kHzNb;
    Tone15kHzNb_M142=Tone15kHzNb;
    Tone10kHzNb_M142=Tone10kHzNb;
    Tone20kHzNb_M142=Tone20kHzNb;
    Tone25kHzNb_M142=Tone25kHzNb;
    Tone30kHzNb_M142=Tone30kHzNb;
     
    cd([directoryName])
    save ResultGeneralization_M142 MeanFirstPoke5kHz_M142 MeanFirstPoke10kHz_M142 MeanFirstPoke15kHz_M142 MeanFirstPoke20kHz_M142 MeanFirstPoke25kHz_M142 MeanFirstPoke30kHz_M142
    save ResultGeneralization_M142 -append PercReward5kHz_M142 PercReward10kHz_M142 PercReward15kHz_M142 PercReward20kHz_M142 PercReward25kHz_M142 PercReward30kHz_M142
    save ResultGeneralization_M142 -append Poke5kHzNb_M142 Poke10kHzNb_M142 Poke15kHzNb_M142 Poke20kHzNb_M142 Poke25kHzNb_M142 Poke30kHzNb_M142
    save ResultGeneralization_M142 -append Poke5kHzMeanNb_M142 Poke10kHzMeanNb_M142 Poke15kHzMeanNb_M142 Poke20kHzMeanNb_M142 Poke25kHzMeanNb_M142 Poke30kHzMeanNb_M142
    save ResultGeneralization_M142 -append Poke5kHzMeanFq_M142 Poke10kHzMeanFq_M142 Poke15kHzMeanFq_M142 Poke20kHzMeanFq_M142 Poke25kHzMeanFq_M142 Poke30kHzMeanFq_M142
    save ResultGeneralization_M142 -append Tone5kHzNb_M142 Tone10kHzNb_M142 Tone15kHzNb_M142 Tone20kHzNb_M142 Tone25kHzNb_M142 Tone30kHzNb_M142
    
end

clear all
load ResultDay5
MeanFirstPoke12kHz_M142=MeanFirstPoke_Day5;
PercReward12kHz_M142=PercReward_Day5;
Poke12kHzNb_M142=RwdPokeNb_Day5;
Poke12kHzMeanNb_M142=RwdPokeMeanNb_Day5;
Poke12kHzMeanFq_M142=RwdPokeMeanFq_Day5;
Tone12kHzNb_M142=RwdToneNb_Day5;
  
save ResultGeneralization_M142 -append MeanFirstPoke12kHz_M142 PercReward12kHz_M142 Poke12kHzNb_M142 Poke12kHzMeanNb_M142 Poke12kHzMeanFq_M142 Tone12kHzNb_M142

%------------------------------------------------------------%------------------------------------------------------------%------------------------------------------------------------
%------------------------------------------------------------%------------------------------------------------------------%------------------------------------------------------------

% ------------------------------------------------------------
% ------------------------ Mouse 143 -------------------------
% ------------------------------------------------------------

% ------------------------ Day 1 : 5 seconds------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse143');
cd([directoryName])
try load ResultDay1
catch
    cd([directoryName,'/20140722/ICSS-Mouse-143-22072014'])
    load LastResults
    
    MeanFirstPoke_Day1=MeanFirstPoke;
    PercReward_Day1=PercReward;
    SuccesRule2_Day1=RdmSuccesRule2;
    Time2Tone_Day1=mean(TimeTwoTone);
    
    NonRwdPokeMeanFq_Day1=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_Day1=NonRwdPokeMeanNb;
    NonRwdPokeNb_Day1=NonRwdPokeNb;
    PokeEventNb_Day1=PokeEventNb;
    RwdPokeMeanFq_Day1=RwdPokeMeanFq;
    RwdPokeMeanNb_Day1=RwdPokeMeanNb;
    RwdPokeNb_Day1=RwdPokeNb;
    RwdToneNb_Day1=RwdToneNb;
    
    IntraSessionTimeTwoTone_Day1=IntraSessionTimeTwoTone;
    IntraSessionMeanFirstPoke_Day1=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_Day1=IntraSessionPercReward;
    IntraSessionSuccesRule2_Day1=IntraSessionSuccesRule2;
    
    % number of tone necessary to reach the 80% succes
    BeforeSucessPerc=find(IntraSessionPercReward_Day1>80);
    BeforeSucessPerc_Day1=BeforeSucessPerc(1)*10;
    
    % evolution of the Rule1 behavior along the session
    len=floor(length(IntraSessionMeanFirstPoke_Day1)/2);
    IntraSessionFirstPoke_Day1(1)=mean(IntraSessionMeanFirstPoke_Day1(1:len));
    IntraSessionFirstPoke_Day1(2)=mean(IntraSessionMeanFirstPoke_Day1(len+1:2*len));
    
    % evolution of the Rule1 Success behavior along the session
    len=floor(length(IntraSessionPercReward_Day1)/2);
    IntraSessionPerc_Day1(1)=mean(IntraSessionPercReward_Day1(1:len));
    IntraSessionPerc_Day1(2)=mean(IntraSessionPercReward_Day1(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionSuccesRule2_Day1)/2);
    IntraSessionRule2_Day1(1)=mean(IntraSessionSuccesRule2_Day1(1:len));
    IntraSessionRule2_Day1(2)=mean(IntraSessionSuccesRule2_Day1(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionTimeTwoTone_Day1)/2);
    IntraSessionTime2Tone_Day1(1)=mean(IntraSessionTimeTwoTone_Day1(1:len));
    IntraSessionTime2Tone_Day1(2)=mean(IntraSessionTimeTwoTone_Day1(len+1:2*len));
    
    cd([directoryName])
    save ResultDay1 MeanFirstPoke_Day1 PercReward_Day1 SuccesRule2_Day1 Time2Tone_Day1 BeforeSucessPerc_Day1
    save ResultDay1 -append IntraSessionFirstPoke_Day1 IntraSessionPerc_Day1 IntraSessionRule2_Day1 IntraSessionTime2Tone_Day1
    save ResultDay1 -append RwdToneNb_Day1 PokeEventNb_Day1 RwdPokeNb_Day1 NonRwdPokeNb_Day1 RwdToneNb_Day1 NonRwdPokeMeanNb_Day1 RwdPokeMeanNb_Day1 RwdPokeMeanFq_Day1 NonRwdPokeMeanFq_Day1
end

% ------------------------ Day 2 : 1 seconds------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse143');
cd([directoryName])
try load ResultDay2
catch
    cd([directoryName,'/20140723_old/ICSS-Mouse-143-23072014'])
    load LastResults
    
    MeanFirstPoke_Day2=MeanFirstPoke;
    PercReward_Day2=PercReward;
    SuccesRule2_Day2=RdmSuccesRule2;
    Time2Tone_Day2=mean(TimeTwoTone);
    
    NonRwdPokeMeanFq_Day2=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_Day2=NonRwdPokeMeanNb;
    NonRwdPokeNb_Day2=NonRwdPokeNb;
    PokeEventNb_Day2=PokeEventNb;
    RwdPokeMeanFq_Day2=RwdPokeMeanFq;
    RwdPokeMeanNb_Day2=RwdPokeMeanNb;
    RwdPokeNb_Day2=RwdPokeNb;
    RwdToneNb_Day2=RwdToneNb;
    
    IntraSessionTimeTwoTone_Day2=IntraSessionTimeTwoTone;
    IntraSessionMeanFirstPoke_Day2=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_Day2=IntraSessionPercReward;
    IntraSessionSuccesRule2_Day2=IntraSessionSuccesRule2;
    
    % number of tone necessary to reach the 80% succes
    BeforeSucessPerc=find(IntraSessionPercReward_Day2>80);
    BeforeSucessPerc_Day2=BeforeSucessPerc(1)*10;
    
    % evolution of the Rule1 behavior along the session
    len=floor(length(IntraSessionMeanFirstPoke_Day2)/2);
    IntraSessionFirstPoke_Day2(1)=mean(IntraSessionMeanFirstPoke_Day2(1:len));
    IntraSessionFirstPoke_Day2(2)=mean(IntraSessionMeanFirstPoke_Day2(len+1:2*len));
    
    % evolution of the Rule1 Success behavior along the session
    len=floor(length(IntraSessionPercReward_Day2)/2);
    IntraSessionPerc_Day2(1)=mean(IntraSessionPercReward_Day2(1:len));
    IntraSessionPerc_Day2(2)=mean(IntraSessionPercReward_Day2(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionSuccesRule2_Day2)/2);
    IntraSessionRule2_Day2(1)=mean(IntraSessionSuccesRule2_Day2(1:len));
    IntraSessionRule2_Day2(2)=mean(IntraSessionSuccesRule2_Day2(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionTimeTwoTone_Day2)/2);
    IntraSessionTime2Tone_Day2(1)=mean(IntraSessionTimeTwoTone_Day2(1:len));
    IntraSessionTime2Tone_Day2(2)=mean(IntraSessionTimeTwoTone_Day2(len+1:2*len));
    
    cd([directoryName])
    save ResultDay2 MeanFirstPoke_Day2 PercReward_Day2 SuccesRule2_Day2 Time2Tone_Day2 BeforeSucessPerc_Day2
    save ResultDay2 -append IntraSessionFirstPoke_Day2 IntraSessionPerc_Day2 IntraSessionRule2_Day2 IntraSessionTime2Tone_Day2
    save ResultDay2 -append RwdToneNb_Day2 PokeEventNb_Day2 RwdPokeNb_Day2 NonRwdPokeNb_Day2 RwdToneNb_Day2 NonRwdPokeMeanNb_Day2 RwdPokeMeanNb_Day2 RwdPokeMeanFq_Day2 NonRwdPokeMeanFq_Day2
end

% ------------------------ Day 3 : 500 msec------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse143');
cd([directoryName])
try load ResultDay3
catch
    cd([directoryName,'/20140826/MMN-Mouse-143-26082014'])
    load LastResults_500ms
    
    MeanFirstPoke_Day3=MeanFirstPoke;
    PercReward_Day3=PercReward;
    SuccesRule2_Day3=RdmSuccesRule2;
    Time2Tone_Day3=mean(TimeTwoTone);
    
    NonRwdPokeMeanFq_Day3=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_Day3=NonRwdPokeMeanNb;
    NonRwdPokeNb_Day3=NonRwdPokeNb;
    PokeEventNb_Day3=PokeEventNb;
    RwdPokeMeanFq_Day3=RwdPokeMeanFq;
    RwdPokeMeanNb_Day3=RwdPokeMeanNb;
    RwdPokeNb_Day3=RwdPokeNb;
    RwdToneNb_Day3=RwdToneNb;
    
    IntraSessionTimeTwoTone_Day3=IntraSessionTimeTwoTone;
    IntraSessionMeanFirstPoke_Day3=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_Day3=IntraSessionPercReward;
    IntraSessionSuccesRule2_Day3=IntraSessionSuccesRule2;
    
    % number of tone necessary to reach the 80% succes
    BeforeSucessPerc=find(IntraSessionPercReward_Day3>80);
    BeforeSucessPerc_Day3=BeforeSucessPerc(1)*10;
    
    % evolution of the Rule1 behavior along the session
    len=floor(length(IntraSessionMeanFirstPoke_Day3)/2);
    IntraSessionFirstPoke_Day3(1)=mean(IntraSessionMeanFirstPoke_Day3(1:len));
    IntraSessionFirstPoke_Day3(2)=mean(IntraSessionMeanFirstPoke_Day3(len+1:2*len));
    
    % evolution of the Rule1 Success behavior along the session
    len=floor(length(IntraSessionPercReward_Day3)/2);
    IntraSessionPerc_Day3(1)=mean(IntraSessionPercReward_Day3(1:len));
    IntraSessionPerc_Day3(2)=mean(IntraSessionPercReward_Day3(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionSuccesRule2_Day3)/2);
    IntraSessionRule2_Day3(1)=mean(IntraSessionSuccesRule2_Day3(1:len));
    IntraSessionRule2_Day3(2)=mean(IntraSessionSuccesRule2_Day3(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionTimeTwoTone_Day3)/2);
    IntraSessionTime2Tone_Day3(1)=mean(IntraSessionTimeTwoTone_Day3(1:len));
    IntraSessionTime2Tone_Day3(2)=mean(IntraSessionTimeTwoTone_Day3(len+1:2*len));
    
    cd([directoryName])
    save ResultDay3 MeanFirstPoke_Day3 PercReward_Day3 SuccesRule2_Day3 Time2Tone_Day3 BeforeSucessPerc_Day3
    save ResultDay3 -append IntraSessionFirstPoke_Day3 IntraSessionPerc_Day3 IntraSessionRule2_Day3 IntraSessionTime2Tone_Day3
    save ResultDay3 -append RwdToneNb_Day3 PokeEventNb_Day3 RwdPokeNb_Day3 NonRwdPokeNb_Day3 RwdToneNb_Day3 NonRwdPokeMeanNb_Day3 RwdPokeMeanNb_Day3 RwdPokeMeanFq_Day3 NonRwdPokeMeanFq_Day3
end

% ------------------------ Day 4 : 100 msec------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse143');
cd([directoryName])
try load ResultDay4
catch
    cd([directoryName,'/20140826/MMN-Mouse-143-26082014'])
    load LastResults_100ms
    
    MeanFirstPoke_Day4=MeanFirstPoke;
    PercReward_Day4=PercReward;
    SuccesRule2_Day4=RdmSuccesRule2;
    Time2Tone_Day4=mean(TimeTwoTone);
    
    NonRwdPokeMeanFq_Day4=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_Day4=NonRwdPokeMeanNb;
    NonRwdPokeNb_Day4=NonRwdPokeNb;
    PokeEventNb_Day4=PokeEventNb;
    RwdPokeMeanFq_Day4=RwdPokeMeanFq;
    RwdPokeMeanNb_Day4=RwdPokeMeanNb;
    RwdPokeNb_Day4=RwdPokeNb;
    RwdToneNb_Day4=RwdToneNb;
    
    IntraSessionTimeTwoTone_Day4=IntraSessionTimeTwoTone;
    IntraSessionMeanFirstPoke_Day4=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_Day4=IntraSessionPercReward;
    IntraSessionSuccesRule2_Day4=IntraSessionSuccesRule2;
    
    % number of tone necessary to reach the 80% succes
    BeforeSucessPerc=find(IntraSessionPercReward_Day4>80);
    BeforeSucessPerc_Day4=BeforeSucessPerc(1)*10;
    
    % evolution of the Rule1 behavior along the session
    len=floor(length(IntraSessionMeanFirstPoke_Day4)/2);
    IntraSessionFirstPoke_Day4(1)=mean(IntraSessionMeanFirstPoke_Day4(1:len));
    IntraSessionFirstPoke_Day4(2)=mean(IntraSessionMeanFirstPoke_Day4(len+1:2*len));
    
    % evolution of the Rule1 Success behavior along the session
    len=floor(length(IntraSessionPercReward_Day4)/2);
    IntraSessionPerc_Day4(1)=mean(IntraSessionPercReward_Day4(1:len));
    IntraSessionPerc_Day4(2)=mean(IntraSessionPercReward_Day4(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionSuccesRule2_Day4)/2);
    IntraSessionRule2_Day4(1)=mean(IntraSessionSuccesRule2_Day4(1:len));
    IntraSessionRule2_Day4(2)=mean(IntraSessionSuccesRule2_Day4(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionTimeTwoTone_Day4)/2);
    IntraSessionTime2Tone_Day4(1)=mean(IntraSessionTimeTwoTone_Day4(1:len));
    IntraSessionTime2Tone_Day4(2)=mean(IntraSessionTimeTwoTone_Day4(len+1:2*len));
    
    cd([directoryName])
    save ResultDay4 MeanFirstPoke_Day4 PercReward_Day4 SuccesRule2_Day4 Time2Tone_Day4 BeforeSucessPerc_Day4
    save ResultDay4 -append IntraSessionFirstPoke_Day4 IntraSessionPerc_Day4 IntraSessionRule2_Day4 IntraSessionTime2Tone_Day4
    save ResultDay4 -append RwdToneNb_Day4 PokeEventNb_Day4 RwdPokeNb_Day4 NonRwdPokeNb_Day4 RwdToneNb_Day4 NonRwdPokeMeanNb_Day4 RwdPokeMeanNb_Day4 RwdPokeMeanFq_Day4 NonRwdPokeMeanFq_Day4
   
end

% ------------------- Day 5 : 100 msec / Gen ------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse143');
cd([directoryName])
try load ResultDay5
catch
    cd([directoryName,'/20140828/MMN-Mouse-143-28082014'])
    load LastResults
    
    MeanFirstPoke_Day5=MeanFirstPoke;
    PercReward_Day5=PercReward;
    SuccesRule2_Day5=RdmSuccesRule2;
    Time2Tone_Day5=mean(TimeTwoTone);
    
    NonRwdPokeMeanFq_Day5=NonRwdPokeMeanFq;
    NonRwdPokeMeanNb_Day5=NonRwdPokeMeanNb;
    NonRwdPokeNb_Day5=NonRwdPokeNb;
    PokeEventNb_Day5=PokeEventNb;
    RwdPokeMeanFq_Day5=RwdPokeMeanFq;
    RwdPokeMeanNb_Day5=RwdPokeMeanNb;
    RwdPokeNb_Day5=RwdPokeNb;
    RwdToneNb_Day5=RwdToneNb;
    
    IntraSessionTimeTwoTone_Day5=IntraSessionTimeTwoTone;
    IntraSessionMeanFirstPoke_Day5=IntraSessionMeanFirstPoke;
    IntraSessionPercReward_Day5=IntraSessionPercReward;
    IntraSessionSuccesRule2_Day5=IntraSessionSuccesRule2;
    
    % number of tone necessary to reach the 80% succes
    BeforeSucessPerc=find(IntraSessionPercReward_Day5>80);
    BeforeSucessPerc_Day5=BeforeSucessPerc(1)*10;
    
    % evolution of the Rule1 behavior along the session
    len=floor(length(IntraSessionMeanFirstPoke_Day5)/2);
    IntraSessionFirstPoke_Day5(1)=mean(IntraSessionMeanFirstPoke_Day5(1:len));
    IntraSessionFirstPoke_Day5(2)=mean(IntraSessionMeanFirstPoke_Day5(len+1:2*len));
    
    % evolution of the Rule1 Success behavior along the session
    len=floor(length(IntraSessionPercReward_Day5)/2);
    IntraSessionPerc_Day5(1)=mean(IntraSessionPercReward_Day5(1:len));
    IntraSessionPerc_Day5(2)=mean(IntraSessionPercReward_Day5(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionSuccesRule2_Day5)/2);
    IntraSessionRule2_Day5(1)=mean(IntraSessionSuccesRule2_Day5(1:len));
    IntraSessionRule2_Day5(2)=mean(IntraSessionSuccesRule2_Day5(len+1:2*len));
    
    % evolution of the Rule2 behavior along the session
    len=floor(length(IntraSessionTimeTwoTone_Day5)/2);
    IntraSessionTime2Tone_Day5(1)=mean(IntraSessionTimeTwoTone_Day5(1:len));
    IntraSessionTime2Tone_Day5(2)=mean(IntraSessionTimeTwoTone_Day5(len+1:2*len));
    
    cd([directoryName])
    save ResultDay5 MeanFirstPoke_Day5 PercReward_Day5 SuccesRule2_Day5 Time2Tone_Day5 BeforeSucessPerc_Day5
    save ResultDay5 -append IntraSessionFirstPoke_Day5 IntraSessionPerc_Day5 IntraSessionRule2_Day5 IntraSessionTime2Tone_Day5
    save ResultDay5 -append RwdToneNb_Day5 PokeEventNb_Day5 RwdPokeNb_Day5 NonRwdPokeNb_Day5 RwdToneNb_Day5 NonRwdPokeMeanNb_Day5 RwdPokeMeanNb_Day5 RwdPokeMeanFq_Day5 NonRwdPokeMeanFq_Day5
   
end


% ----------------- Day 5 : 100 Generalization ----------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse143');
cd([directoryName])
try load ResultGeneralization
catch
    cd([directoryName,'/20140828/MMN-Mouse-143-28082014'])
    load GeneralizationResult
        
    MeanFirstPoke5kHz_M143=MeanFirstPokeGen5kHz;
    MeanFirstPoke15kHz_M143=MeanFirstPokeGen15kHz;
    MeanFirstPoke10kHz_M143=MeanFirstPokeGen10kHz;
    MeanFirstPoke20kHz_M143=MeanFirstPokeGen20kHz;
    MeanFirstPoke25kHz_M143=MeanFirstPokeGen25kHz;
    MeanFirstPoke30kHz_M143=MeanFirstPokeGen30kHz;
    
    PercReward5kHz_M143=PercRewardGen5kHz;
    PercReward15kHz_M143=PercRewardGen15kHz;
    PercReward10kHz_M143=PercRewardGen10kHz;
    PercReward20kHz_M143=PercRewardGen20kHz;
    PercReward25kHz_M143=PercRewardGen25kHz;
    PercReward30kHz_M143=PercRewardGen30kHz;
    
    Poke5kHzNb_M143=Poke5kHzNb;
    Poke15kHzNb_M143=Poke15kHzNb;
    Poke10kHzNb_M143=Poke10kHzNb;
    Poke20kHzNb_M143=Poke20kHzNb;
    Poke25kHzNb_M143=Poke25kHzNb;
    Poke30kHzNb_M143=Poke30kHzNb;
    
    Poke5kHzMeanNb_M143=Poke5kHzMeanNb;
    Poke15kHzMeanNb_M143=Poke15kHzMeanNb;
    Poke10kHzMeanNb_M143=Poke10kHzMeanNb;
    Poke20kHzMeanNb_M143=Poke20kHzMeanNb;
    Poke25kHzMeanNb_M143=Poke25kHzMeanNb;
    Poke30kHzMeanNb_M143=Poke30kHzMeanNb;
         
    Poke5kHzMeanFq_M143=Poke5kHzMeanFq;
    Poke15kHzMeanFq_M143=Poke15kHzMeanFq;
    Poke10kHzMeanFq_M143=Poke10kHzMeanFq;   
    Poke20kHzMeanFq_M143=Poke20kHzMeanFq;
    Poke25kHzMeanFq_M143=Poke25kHzMeanFq;
    Poke30kHzMeanFq_M143=Poke30kHzMeanFq;
    
    Tone5kHzNb_M143=Tone5kHzNb;
    Tone15kHzNb_M143=Tone15kHzNb;
    Tone10kHzNb_M143=Tone10kHzNb;
    Tone20kHzNb_M143=Tone20kHzNb;
    Tone25kHzNb_M143=Tone25kHzNb;
    Tone30kHzNb_M143=Tone30kHzNb;
     
    cd([directoryName])
    save ResultGeneralization_M143 MeanFirstPoke5kHz_M143 MeanFirstPoke10kHz_M143 MeanFirstPoke15kHz_M143 MeanFirstPoke20kHz_M143 MeanFirstPoke25kHz_M143 MeanFirstPoke30kHz_M143
    save ResultGeneralization_M143 -append PercReward5kHz_M143 PercReward10kHz_M143 PercReward15kHz_M143 PercReward20kHz_M143 PercReward25kHz_M143 PercReward30kHz_M143
    save ResultGeneralization_M143 -append Poke5kHzNb_M143 Poke10kHzNb_M143 Poke15kHzNb_M143 Poke20kHzNb_M143 Poke25kHzNb_M143 Poke30kHzNb_M143
    save ResultGeneralization_M143 -append Poke5kHzMeanNb_M143 Poke10kHzMeanNb_M143 Poke15kHzMeanNb_M143 Poke20kHzMeanNb_M143 Poke25kHzMeanNb_M143 Poke30kHzMeanNb_M143
    save ResultGeneralization_M143 -append Poke5kHzMeanFq_M143 Poke10kHzMeanFq_M143 Poke15kHzMeanFq_M143 Poke20kHzMeanFq_M143 Poke25kHzMeanFq_M143 Poke30kHzMeanFq_M143
    save ResultGeneralization_M143 -append Tone5kHzNb_M143 Tone10kHzNb_M143 Tone15kHzNb_M143 Tone20kHzNb_M143 Tone25kHzNb_M143 Tone30kHzNb_M143
    
end

clear all
load ResultDay5
MeanFirstPoke12kHz_M143=MeanFirstPoke_Day5;
PercReward12kHz_M143=PercReward_Day5;
Poke12kHzNb_M143=RwdPokeNb_Day5;
Poke12kHzMeanNb_M143=RwdPokeMeanNb_Day5;
Poke12kHzMeanFq_M143=RwdPokeMeanFq_Day5;
Tone12kHzNb_M143=RwdToneNb_Day5;
  
save ResultGeneralization_M143 -append MeanFirstPoke12kHz_M143 PercReward12kHz_M143 Poke12kHzNb_M143 Poke12kHzMeanNb_M143 Poke12kHzMeanFq_M143 Tone12kHzNb_M143

%------------------------------------------------------------%------------------------------------------------------------%------------------------------------------------------------
%------------------------------------------------------------%------------------------------------------------------------%------------------------------------------------------------
%------------------------------------------------------------%------------------------------------------------------------%------------------------------------------------------------

clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');
cd([directoryName])

load ResultDay1
load ResultDay2
load ResultDay3
load ResultDay4
load ResultDay5

directoryName=('/media/DataMOBsG/AttentionalNosePoke');
cd([directoryName])

NonRwdPokeMeanFq_M130=[NonRwdPokeMeanFq_Day1;NonRwdPokeMeanFq_Day2;NonRwdPokeMeanFq_Day3;NonRwdPokeMeanFq_Day4;NonRwdPokeMeanFq_Day5];
NonRwdPokeMeanNb_M130=[NonRwdPokeMeanNb_Day1;NonRwdPokeMeanNb_Day2;NonRwdPokeMeanNb_Day3;NonRwdPokeMeanNb_Day4;NonRwdPokeMeanNb_Day5];
NonRwdPokeNb_M130=[NonRwdPokeNb_Day1;NonRwdPokeNb_Day2;NonRwdPokeNb_Day3;NonRwdPokeNb_Day4;NonRwdPokeNb_Day5];
PokeEventNb_M130=[PokeEventNb_Day1;PokeEventNb_Day2;PokeEventNb_Day2;PokeEventNb_Day3;PokeEventNb_Day4;PokeEventNb_Day5];
RwdPokeMeanFq_M130=[RwdPokeMeanFq_Day1;RwdPokeMeanFq_Day2;RwdPokeMeanFq_Day3;RwdPokeMeanFq_Day4;RwdPokeMeanFq_Day4];
RwdPokeMeanNb_M130=[RwdPokeMeanNb_Day1;RwdPokeMeanNb_Day2;RwdPokeMeanNb_Day3;RwdPokeMeanNb_Day4;RwdPokeMeanNb_Day5];
RwdPokeNb_M130=[RwdPokeNb_Day1;RwdPokeNb_Day2;RwdPokeNb_Day3;RwdPokeNb_Day4;RwdPokeNb_Day5];
RwdToneNb_M130=[RwdToneNb_Day1;RwdToneNb_Day2;RwdToneNb_Day3;RwdToneNb_Day4;RwdToneNb_Day5];

save M130b NonRwdPokeMeanFq_M130 NonRwdPokeMeanNb_M130 NonRwdPokeNb_M130 PokeEventNb_M130 RwdPokeMeanFq_M130 RwdPokeMeanNb_M130 RwdPokeNb_M130 RwdToneNb_M130

MeanFirstPoke_M130=[MeanFirstPoke_Day1;MeanFirstPoke_Day2;MeanFirstPoke_Day3;MeanFirstPoke_Day4;MeanFirstPoke_Day5];
PercReward_M130=[PercReward_Day1;PercReward_Day2;PercReward_Day3;PercReward_Day4;PercReward_Day5];
SuccesRule2_M130=[SuccesRule2_Day1;SuccesRule2_Day2;SuccesRule2_Day3;SuccesRule2_Day4;SuccesRule2_Day5];
Time2Tone_M130=[Time2Tone_Day1;Time2Tone_Day2;Time2Tone_Day3;Time2Tone_Day4;Time2Tone_Day5];
BeforeSucessPerc_M130=[BeforeSucessPerc_Day1;BeforeSucessPerc_Day2;BeforeSucessPerc_Day3;BeforeSucessPerc_Day4;BeforeSucessPerc_Day5];

save M130b -append  MeanFirstPoke_M130 PercReward_M130 SuccesRule2_M130 Time2Tone_M130 BeforeSucessPerc_M130 

IntraSessionFirstPoke_M130=[IntraSessionFirstPoke_Day1;IntraSessionFirstPoke_Day2;IntraSessionFirstPoke_Day3;IntraSessionFirstPoke_Day4;IntraSessionFirstPoke_Day5];
IntraSessionPerc_M130=[IntraSessionPerc_Day1;IntraSessionPerc_Day2;IntraSessionPerc_Day3;IntraSessionPerc_Day4;IntraSessionPerc_Day5];
IntraSessionRule2_M130=[IntraSessionRule2_Day1;IntraSessionRule2_Day2;IntraSessionRule2_Day3;IntraSessionRule2_Day4;IntraSessionRule2_Day5];
IntraSessionTime2Tone_M130=[IntraSessionTime2Tone_Day1;IntraSessionTime2Tone_Day2;IntraSessionTime2Tone_Day3;IntraSessionTime2Tone_Day4;IntraSessionTime2Tone_Day5];

save M130b -append IntraSessionFirstPoke_M130 IntraSessionPerc_M130 IntraSessionRule2_M130 IntraSessionTime2Tone_M130   

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

directoryName=('/media/DataMOBsG/AttentionalNosePoke');
cd([directoryName])

NonRwdPokeMeanFq_M133=[NonRwdPokeMeanFq_Day1;NonRwdPokeMeanFq_Day2;NonRwdPokeMeanFq_Day3;NonRwdPokeMeanFq_Day4;NonRwdPokeMeanFq_Day5];
NonRwdPokeMeanNb_M133=[NonRwdPokeMeanNb_Day1;NonRwdPokeMeanNb_Day2;NonRwdPokeMeanNb_Day3;NonRwdPokeMeanNb_Day4;NonRwdPokeMeanNb_Day5];
NonRwdPokeNb_M133=[NonRwdPokeNb_Day1;NonRwdPokeNb_Day2;NonRwdPokeNb_Day3;NonRwdPokeNb_Day4;NonRwdPokeNb_Day5];
PokeEventNb_M133=[PokeEventNb_Day1;PokeEventNb_Day2;PokeEventNb_Day2;PokeEventNb_Day3;PokeEventNb_Day4;PokeEventNb_Day5];
RwdPokeMeanFq_M133=[RwdPokeMeanFq_Day1;RwdPokeMeanFq_Day2;RwdPokeMeanFq_Day3;RwdPokeMeanFq_Day4;RwdPokeMeanFq_Day4];
RwdPokeMeanNb_M133=[RwdPokeMeanNb_Day1;RwdPokeMeanNb_Day2;RwdPokeMeanNb_Day3;RwdPokeMeanNb_Day4;RwdPokeMeanNb_Day5];
RwdPokeNb_M133=[RwdPokeNb_Day1;RwdPokeNb_Day2;RwdPokeNb_Day3;RwdPokeNb_Day4;RwdPokeNb_Day5];
RwdToneNb_M133=[RwdToneNb_Day1;RwdToneNb_Day2;RwdToneNb_Day3;RwdToneNb_Day4;RwdToneNb_Day5];

save M133b NonRwdPokeMeanFq_M133 NonRwdPokeMeanNb_M133 NonRwdPokeNb_M133 PokeEventNb_M133 RwdPokeMeanFq_M133 RwdPokeMeanNb_M133 RwdPokeNb_M133 RwdToneNb_M133

MeanFirstPoke_M133=[MeanFirstPoke_Day1;MeanFirstPoke_Day2;MeanFirstPoke_Day3;MeanFirstPoke_Day4;MeanFirstPoke_Day5];
PercReward_M133=[PercReward_Day1;PercReward_Day2;PercReward_Day3;PercReward_Day4;PercReward_Day5];
SuccesRule2_M133=[SuccesRule2_Day1;SuccesRule2_Day2;SuccesRule2_Day3;SuccesRule2_Day4;SuccesRule2_Day5];
Time2Tone_M133=[Time2Tone_Day1;Time2Tone_Day2;Time2Tone_Day3;Time2Tone_Day4;Time2Tone_Day5];
BeforeSucessPerc_M133=[BeforeSucessPerc_Day1;BeforeSucessPerc_Day2;BeforeSucessPerc_Day3;BeforeSucessPerc_Day4;BeforeSucessPerc_Day5];

save M133b -append  MeanFirstPoke_M133 PercReward_M133 SuccesRule2_M133 Time2Tone_M133 BeforeSucessPerc_M133 

IntraSessionFirstPoke_M133=[IntraSessionFirstPoke_Day1;IntraSessionFirstPoke_Day2;IntraSessionFirstPoke_Day3;IntraSessionFirstPoke_Day4;IntraSessionFirstPoke_Day5];
IntraSessionPerc_M133=[IntraSessionPerc_Day1;IntraSessionPerc_Day2;IntraSessionPerc_Day3;IntraSessionPerc_Day4;IntraSessionPerc_Day5];
IntraSessionRule2_M133=[IntraSessionRule2_Day1;IntraSessionRule2_Day2;IntraSessionRule2_Day3;IntraSessionRule2_Day4;IntraSessionRule2_Day5];
IntraSessionTime2Tone_M133=[IntraSessionTime2Tone_Day1;IntraSessionTime2Tone_Day2;IntraSessionTime2Tone_Day3;IntraSessionTime2Tone_Day4;IntraSessionTime2Tone_Day5];

save M133b -append IntraSessionFirstPoke_M133 IntraSessionPerc_M133 IntraSessionRule2_M133 IntraSessionTime2Tone_M133   

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

directoryName=('/media/DataMOBsG/AttentionalNosePoke');
cd([directoryName])

NonRwdPokeMeanFq_M142=[NonRwdPokeMeanFq_Day1;NonRwdPokeMeanFq_Day2;NonRwdPokeMeanFq_Day3;NonRwdPokeMeanFq_Day4;NonRwdPokeMeanFq_Day5];
NonRwdPokeMeanNb_M142=[NonRwdPokeMeanNb_Day1;NonRwdPokeMeanNb_Day2;NonRwdPokeMeanNb_Day3;NonRwdPokeMeanNb_Day4;NonRwdPokeMeanNb_Day5];
NonRwdPokeNb_M142=[NonRwdPokeNb_Day1;NonRwdPokeNb_Day2;NonRwdPokeNb_Day3;NonRwdPokeNb_Day4;NonRwdPokeNb_Day5];
PokeEventNb_M142=[PokeEventNb_Day1;PokeEventNb_Day2;PokeEventNb_Day2;PokeEventNb_Day3;PokeEventNb_Day4;PokeEventNb_Day5];
RwdPokeMeanFq_M142=[RwdPokeMeanFq_Day1;RwdPokeMeanFq_Day2;RwdPokeMeanFq_Day3;RwdPokeMeanFq_Day4;RwdPokeMeanFq_Day4];
RwdPokeMeanNb_M142=[RwdPokeMeanNb_Day1;RwdPokeMeanNb_Day2;RwdPokeMeanNb_Day3;RwdPokeMeanNb_Day4;RwdPokeMeanNb_Day5];
RwdPokeNb_M142=[RwdPokeNb_Day1;RwdPokeNb_Day2;RwdPokeNb_Day3;RwdPokeNb_Day4;RwdPokeNb_Day5];
RwdToneNb_M142=[RwdToneNb_Day1;RwdToneNb_Day2;RwdToneNb_Day3;RwdToneNb_Day4;RwdToneNb_Day5];

save M142b NonRwdPokeMeanFq_M142 NonRwdPokeMeanNb_M142 NonRwdPokeNb_M142 PokeEventNb_M142 RwdPokeMeanFq_M142 RwdPokeMeanNb_M142 RwdPokeNb_M142 RwdToneNb_M142

MeanFirstPoke_M142=[MeanFirstPoke_Day1;MeanFirstPoke_Day2;MeanFirstPoke_Day3;MeanFirstPoke_Day4;MeanFirstPoke_Day5];
PercReward_M142=[PercReward_Day1;PercReward_Day2;PercReward_Day3;PercReward_Day4;PercReward_Day5];
SuccesRule2_M142=[SuccesRule2_Day1;SuccesRule2_Day2;SuccesRule2_Day3;SuccesRule2_Day4;SuccesRule2_Day5];
Time2Tone_M142=[Time2Tone_Day1;Time2Tone_Day2;Time2Tone_Day3;Time2Tone_Day4;Time2Tone_Day5];
BeforeSucessPerc_M142=[BeforeSucessPerc_Day1;BeforeSucessPerc_Day2;BeforeSucessPerc_Day3;BeforeSucessPerc_Day4;BeforeSucessPerc_Day5];

save M142b -append  MeanFirstPoke_M142 PercReward_M142 SuccesRule2_M142 Time2Tone_M142 BeforeSucessPerc_M142

IntraSessionFirstPoke_M142=[IntraSessionFirstPoke_Day1;IntraSessionFirstPoke_Day2;IntraSessionFirstPoke_Day3;IntraSessionFirstPoke_Day4;IntraSessionFirstPoke_Day5];
IntraSessionPerc_M142=[IntraSessionPerc_Day1;IntraSessionPerc_Day2;IntraSessionPerc_Day3;IntraSessionPerc_Day4;IntraSessionPerc_Day5];
IntraSessionRule2_M142=[IntraSessionRule2_Day1;IntraSessionRule2_Day2;IntraSessionRule2_Day3;IntraSessionRule2_Day4;IntraSessionRule2_Day5];
IntraSessionTime2Tone_M142=[IntraSessionTime2Tone_Day1;IntraSessionTime2Tone_Day2;IntraSessionTime2Tone_Day3;IntraSessionTime2Tone_Day4;IntraSessionTime2Tone_Day5];

save M142b -append IntraSessionFirstPoke_M142 IntraSessionPerc_M142 IntraSessionRule2_M142 IntraSessionTime2Tone_M142  

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

directoryName=('/media/DataMOBsG/AttentionalNosePoke');
cd([directoryName])

NonRwdPokeMeanFq_M143=[NonRwdPokeMeanFq_Day1;NonRwdPokeMeanFq_Day2;NonRwdPokeMeanFq_Day3;NonRwdPokeMeanFq_Day4;NonRwdPokeMeanFq_Day5];
NonRwdPokeMeanNb_M143=[NonRwdPokeMeanNb_Day1;NonRwdPokeMeanNb_Day2;NonRwdPokeMeanNb_Day3;NonRwdPokeMeanNb_Day4;NonRwdPokeMeanNb_Day5];
NonRwdPokeNb_M143=[NonRwdPokeNb_Day1;NonRwdPokeNb_Day2;NonRwdPokeNb_Day3;NonRwdPokeNb_Day4;NonRwdPokeNb_Day5];
PokeEventNb_M143=[PokeEventNb_Day1;PokeEventNb_Day2;PokeEventNb_Day2;PokeEventNb_Day3;PokeEventNb_Day4;PokeEventNb_Day5];
RwdPokeMeanFq_M143=[RwdPokeMeanFq_Day1;RwdPokeMeanFq_Day2;RwdPokeMeanFq_Day3;RwdPokeMeanFq_Day4;RwdPokeMeanFq_Day4];
RwdPokeMeanNb_M143=[RwdPokeMeanNb_Day1;RwdPokeMeanNb_Day2;RwdPokeMeanNb_Day3;RwdPokeMeanNb_Day4;RwdPokeMeanNb_Day5];
RwdPokeNb_M143=[RwdPokeNb_Day1;RwdPokeNb_Day2;RwdPokeNb_Day3;RwdPokeNb_Day4;RwdPokeNb_Day5];
RwdToneNb_M143=[RwdToneNb_Day1;RwdToneNb_Day2;RwdToneNb_Day3;RwdToneNb_Day4;RwdToneNb_Day5];

save M143b NonRwdPokeMeanFq_M143 NonRwdPokeMeanNb_M143 NonRwdPokeNb_M143 PokeEventNb_M143 RwdPokeMeanFq_M143 RwdPokeMeanNb_M143 RwdPokeNb_M143 RwdToneNb_M143

MeanFirstPoke_M143=[MeanFirstPoke_Day1;MeanFirstPoke_Day2;MeanFirstPoke_Day3;MeanFirstPoke_Day4;MeanFirstPoke_Day5];
PercReward_M143=[PercReward_Day1;PercReward_Day2;PercReward_Day3;PercReward_Day4;PercReward_Day5];
SuccesRule2_M143=[SuccesRule2_Day1;SuccesRule2_Day2;SuccesRule2_Day3;SuccesRule2_Day4;SuccesRule2_Day5];
Time2Tone_M143=[Time2Tone_Day1;Time2Tone_Day2;Time2Tone_Day3;Time2Tone_Day4;Time2Tone_Day5];
BeforeSucessPerc_M143=[BeforeSucessPerc_Day1;BeforeSucessPerc_Day2;BeforeSucessPerc_Day3;BeforeSucessPerc_Day4;BeforeSucessPerc_Day5];

save M142b -append  MeanFirstPoke_M143 PercReward_M143 SuccesRule2_M143 Time2Tone_M143 BeforeSucessPerc_M143

IntraSessionFirstPoke_M143=[IntraSessionFirstPoke_Day1;IntraSessionFirstPoke_Day2;IntraSessionFirstPoke_Day3;IntraSessionFirstPoke_Day4;IntraSessionFirstPoke_Day5];
IntraSessionPerc_M143=[IntraSessionPerc_Day1;IntraSessionPerc_Day2;IntraSessionPerc_Day3;IntraSessionPerc_Day4;IntraSessionPerc_Day5];
IntraSessionRule2_M143=[IntraSessionRule2_Day1;IntraSessionRule2_Day2;IntraSessionRule2_Day3;IntraSessionRule2_Day4;IntraSessionRule2_Day5];
IntraSessionTime2Tone_M143=[IntraSessionTime2Tone_Day1;IntraSessionTime2Tone_Day2;IntraSessionTime2Tone_Day3;IntraSessionTime2Tone_Day4;IntraSessionTime2Tone_Day5];

save M142b -append IntraSessionFirstPoke_M143 IntraSessionPerc_M143 IntraSessionRule2_M143 IntraSessionTime2Tone_M143 


%------------------------------------------------------------%------------------------------------------------------------%------------------------------------------------------------
%------------------------------------------------------------%------------------------------------------------------------%------------------------------------------------------------
%------------------------------------------------------------%------------------------------------------------------------%------------------------------------------------------------

clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse130');
cd([directoryName])
load ResultGeneralization_M130

MeanFirstPoke_M130=[MeanFirstPoke5kHz_M130;MeanFirstPoke10kHz_M130;MeanFirstPoke12kHz_M130;MeanFirstPoke15kHz_M130;MeanFirstPoke20kHz_M130;MeanFirstPoke25kHz_M130;MeanFirstPoke30kHz_M130];
PercReward_M130=[PercReward5kHz_M130;PercReward10kHz_M130;PercReward12kHz_M130;PercReward15kHz_M130;PercReward20kHz_M130;PercReward25kHz_M130;PercReward30kHz_M130];
PokeNb_M130=[Poke5kHzNb_M130;Poke10kHzNb_M130;Poke12kHzNb_M130;Poke15kHzNb_M130;Poke20kHzNb_M130;Poke25kHzNb_M130;Poke30kHzNb_M130];
PokeMeanNb_M130=[Poke5kHzMeanNb_M130;Poke10kHzMeanNb_M130;Poke12kHzMeanNb_M130;Poke15kHzMeanNb_M130;Poke20kHzMeanNb_M130;Poke25kHzMeanNb_M130;Poke30kHzMeanNb_M130];
PokeMeanFq_M130=[Poke5kHzMeanFq_M130;Poke10kHzMeanFq_M130;Poke12kHzMeanFq_M130;Poke15kHzMeanFq_M130;Poke20kHzMeanFq_M130;Poke25kHzMeanFq_M130;Poke30kHzMeanFq_M130];
ToneNb_M130=[Tone5kHzNb_M130;Tone10kHzNb_M130;Tone12kHzNb_M130;Tone15kHzNb_M130;Tone20kHzNb_M130;Tone25kHzNb_M130;Tone30kHzNb_M130];

directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse133');
cd([directoryName])
load ResultGeneralization_M133

MeanFirstPoke_M133=[MeanFirstPoke5kHz_M133;MeanFirstPoke10kHz_M133;MeanFirstPoke12kHz_M133;MeanFirstPoke15kHz_M133;MeanFirstPoke20kHz_M133;MeanFirstPoke25kHz_M133;MeanFirstPoke30kHz_M133];
PercReward_M133=[PercReward5kHz_M133;PercReward10kHz_M133;PercReward12kHz_M133;PercReward15kHz_M133;PercReward20kHz_M133;PercReward25kHz_M133;PercReward30kHz_M133];
PokeNb_M133=[Poke5kHzNb_M133;Poke10kHzNb_M133;Poke12kHzNb_M133;Poke15kHzNb_M133;Poke20kHzNb_M133;Poke25kHzNb_M133;Poke30kHzNb_M133];
PokeMeanNb_M133=[Poke5kHzMeanNb_M133;Poke10kHzMeanNb_M133;Poke12kHzMeanNb_M133;Poke15kHzMeanNb_M133;Poke20kHzMeanNb_M133;Poke25kHzMeanNb_M133;Poke30kHzMeanNb_M133];
PokeMeanFq_M133=[Poke5kHzMeanFq_M133;Poke10kHzMeanFq_M133;Poke12kHzMeanFq_M133;Poke15kHzMeanFq_M133;Poke20kHzMeanFq_M133;Poke25kHzMeanFq_M133;Poke30kHzMeanFq_M133];
ToneNb_M133=[Tone5kHzNb_M133;Tone10kHzNb_M133;Tone12kHzNb_M133;Tone15kHzNb_M133;Tone20kHzNb_M133;Tone25kHzNb_M133;Tone30kHzNb_M133];

directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse142');
cd([directoryName])
load ResultGeneralization_M142

MeanFirstPoke_M142=[MeanFirstPoke5kHz_M142;MeanFirstPoke10kHz_M142;MeanFirstPoke12kHz_M142;MeanFirstPoke15kHz_M142;MeanFirstPoke20kHz_M142;MeanFirstPoke25kHz_M142;MeanFirstPoke30kHz_M142];
PercReward_M142=[PercReward5kHz_M142;PercReward10kHz_M142;PercReward12kHz_M142;PercReward15kHz_M142;PercReward20kHz_M142;PercReward25kHz_M142;PercReward30kHz_M142];
PokeNb_M142=[Poke5kHzNb_M142;Poke10kHzNb_M142;Poke12kHzNb_M142;Poke15kHzNb_M142;Poke20kHzNb_M142;Poke25kHzNb_M142;Poke30kHzNb_M142];
PokeMeanNb_M142=[Poke5kHzMeanNb_M142;Poke10kHzMeanNb_M142;Poke12kHzMeanNb_M142;Poke15kHzMeanNb_M142;Poke20kHzMeanNb_M142;Poke25kHzMeanNb_M142;Poke30kHzMeanNb_M142];
PokeMeanFq_M142=[Poke5kHzMeanFq_M142;Poke10kHzMeanFq_M142;Poke12kHzMeanFq_M142;Poke15kHzMeanFq_M142;Poke20kHzMeanFq_M142;Poke25kHzMeanFq_M142;Poke30kHzMeanFq_M142];
ToneNb_M142=[Tone5kHzNb_M142;Tone10kHzNb_M142;Tone12kHzNb_M142;Tone15kHzNb_M142;Tone20kHzNb_M142;Tone25kHzNb_M142;Tone30kHzNb_M142];

directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse143');
cd([directoryName])
load ResultGeneralization_M143

MeanFirstPoke_M143=[MeanFirstPoke5kHz_M143;MeanFirstPoke10kHz_M143;MeanFirstPoke12kHz_M143;MeanFirstPoke15kHz_M143;MeanFirstPoke20kHz_M143;MeanFirstPoke25kHz_M143;MeanFirstPoke30kHz_M143];
PercReward_M143=[PercReward5kHz_M143;PercReward10kHz_M143;PercReward12kHz_M143;PercReward15kHz_M143;PercReward20kHz_M143;PercReward25kHz_M143;PercReward30kHz_M143];
PokeNb_M143=[Poke5kHzNb_M143;Poke10kHzNb_M143;Poke12kHzNb_M143;Poke15kHzNb_M143;Poke20kHzNb_M143;Poke25kHzNb_M143;Poke30kHzNb_M143];
PokeMeanNb_M143=[Poke5kHzMeanNb_M143;Poke10kHzMeanNb_M143;Poke12kHzMeanNb_M143;Poke15kHzMeanNb_M143;Poke20kHzMeanNb_M143;Poke25kHzMeanNb_M143;Poke30kHzMeanNb_M143];
PokeMeanFq_M143=[Poke5kHzMeanFq_M143;Poke10kHzMeanFq_M143;Poke12kHzMeanFq_M143;Poke15kHzMeanFq_M143;Poke20kHzMeanFq_M143;Poke25kHzMeanFq_M143;Poke30kHzMeanFq_M143];
ToneNb_M143=[Tone5kHzNb_M143;Tone10kHzNb_M143;Tone12kHzNb_M143;Tone15kHzNb_M143;Tone20kHzNb_M143;Tone25kHzNb_M143;Tone30kHzNb_M143];

directoryName=('/media/DataMOBsG/AttentionalNosePoke');
cd([directoryName])
save GeneralizationAllb MeanFirstPoke_M130 MeanFirstPoke_M133 MeanFirstPoke_M142  MeanFirstPoke_M143
save GeneralizationAllb -append PercReward_M130 PercReward_M133 PercReward_M142  PercReward_M143
save GeneralizationAllb -append PokeNb_M130 PokeNb_M133 PokeNb_M142  PokeNb_M143
save GeneralizationAllb -append PokeMeanNb_M130 PokeMeanNb_M133 PokeMeanNb_M142 PokeMeanNb_M143
save GeneralizationAllb -append PokeMeanFq_M130 PokeMeanFq_M133 PokeMeanFq_M142 PokeMeanFq_M143
save GeneralizationAllb -append ToneNb_M130 ToneNb_M133 ToneNb_M142 ToneNb_M143


