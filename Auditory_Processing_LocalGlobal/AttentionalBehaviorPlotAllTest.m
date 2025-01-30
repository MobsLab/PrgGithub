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
    load AttentionalEvent
    %--------------------------------------------------------------------------
    % Positive and negative pokes
    %--------------------------------------------------------------------------
    clear id
    for i=1:length(PokeEvent)
        id=(PokeEvent(i,1)-RwdToneEvt(:,1));
        a=find(id(:,1)>0 & id(:,1)<RewardWindow);
        if ~isempty(a)
            PokeEvent(i,3)=1;
        elseif isempty(a)
            PokeEvent(i,3)=0;
        end
    end
    
    Begin=RwdToneEvt(1,1);
    End=RwdToneEvt(length(RwdToneEvt(:,1)),1);
    windowNb=floor((End-Begin)/120);
    for i=1:windowNb
        time1=Begin+(i-1)*120;
        time2=Begin+i*120;
        PokeInTime=find(PokeEvent(:,1)>=time1 & PokeEvent(:,1)<=time2);
        ToneInTime=RwdToneEvt(find(RwdToneEvt(:,1)>=time1 & RwdToneEvt(:,1)<=time2));
        NbTone_Day1(i)=length(ToneInTime);
        NbPokeOK_Day1(i)=length(find(PokeEvent(PokeInTime,3)==1));
        NbPokeOff_Day1(i)=length(find(PokeEvent(PokeInTime,3)==0));
    end
    
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
    save ResultDay1 -append NbTone_Day1 NbPokeOK_Day1 NbPokeOff_Day1 
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
    load AttentionalEvent
    %--------------------------------------------------------------------------
    % Positive and negative pokes
    %--------------------------------------------------------------------------
    clear id
    for i=1:length(PokeEvent)
        id=(PokeEvent(i,1)-RwdToneEvt(:,1));
        a=find(id(:,1)>0 & id(:,1)<RewardWindow);
        if ~isempty(a)
            PokeEvent(i,3)=1;
        elseif isempty(a)
            PokeEvent(i,3)=0;
        end
    end
    
    Begin=RwdToneEvt(1,1);
    End=RwdToneEvt(length(RwdToneEvt(:,1)),1);
    windowNb=floor((End-Begin)/120);
    for i=1:windowNb
        time1=Begin+(i-1)*120;
        time2=Begin+i*120;
        PokeInTime=find(PokeEvent(:,1)>=time1 & PokeEvent(:,1)<=time2);
        ToneInTime=RwdToneEvt(find(RwdToneEvt(:,1)>=time1 & RwdToneEvt(:,1)<=time2));
        NbTone_Day2(i)=length(ToneInTime);
        NbPokeOK_Day2(i)=length(find(PokeEvent(PokeInTime,3)==1));
        NbPokeOff_Day2(i)=length(find(PokeEvent(PokeInTime,3)==0));
    end
    
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
    save ResultDay2 -append NbTone_Day2 NbPokeOK_Day2 NbPokeOff_Day2 
    save ResultDay2 -append IntraSessionFirstPoke_Day2 IntraSessionPerc_Day2 IntraSessionRule2_Day2 IntraSessionTime2Tone_Day2
    save ResultDay2 -append RwdToneNb_Day2 PokeEventNb_Day2 RwdPokeNb_Day2 NonRwdPokeNb_Day2 RwdToneNb_Day2 NonRwdPokeMeanNb_Day2 RwdPokeMeanNb_Day2 RwdPokeMeanFq_Day2 NonRwdPokeMeanFq_Day2
end

% ------------------------ Day 3 : 500 msec------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse142');
cd([directoryName])
try load ResultDay3
catch
    cd([directoryName,'/20140826/MMN-Mouse-142-26082014'])
    load AttentionalEvent_500ms
    %--------------------------------------------------------------------------
    % Positive and negative pokes
    %--------------------------------------------------------------------------
    clear id
    for i=1:length(PokeEvent)
        id=(PokeEvent(i,1)-RwdToneEvt(:,1));
        a=find(id(:,1)>0 & id(:,1)<RewardWindow);
        if ~isempty(a)
            PokeEvent(i,3)=1;
        elseif isempty(a)
            PokeEvent(i,3)=0;
        end
    end
    
    Begin=RwdToneEvt(1,1);
    End=RwdToneEvt(length(RwdToneEvt(:,1)),1);
    windowNb=floor((End-Begin)/120);
    for i=1:windowNb
        time1=Begin+(i-1)*120;
        time2=Begin+i*120;
        PokeInTime=find(PokeEvent(:,1)>=time1 & PokeEvent(:,1)<=time2);
        ToneInTime=RwdToneEvt(find(RwdToneEvt(:,1)>=time1 & RwdToneEvt(:,1)<=time2));
        NbTone_Day3(i)=length(ToneInTime);
        NbPokeOK_Day3(i)=length(find(PokeEvent(PokeInTime,3)==1));
        NbPokeOff_Day3(i)=length(find(PokeEvent(PokeInTime,3)==0));
    end
    
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
    save ResultDay3 -append NbTone_Day3 NbPokeOK_Day3 NbPokeOff_Day3
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
    load AttentionalEvent_100ms
    %--------------------------------------------------------------------------
    % Positive and negative pokes
    %--------------------------------------------------------------------------
    clear id
    for i=1:length(PokeEvent)
        id=(PokeEvent(i,1)-RwdToneEvt(:,1));
        a=find(id(:,1)>0 & id(:,1)<RewardWindow);
        if ~isempty(a)
            PokeEvent(i,3)=1;
        elseif isempty(a)
            PokeEvent(i,3)=0;
        end
    end
    
    Begin=RwdToneEvt(1,1);
    End=RwdToneEvt(length(RwdToneEvt(:,1)),1);
    windowNb=floor((End-Begin)/120);
    for i=1:windowNb
        time1=Begin+(i-1)*120;
        time2=Begin+i*120;
        PokeInTime=find(PokeEvent(:,1)>=time1 & PokeEvent(:,1)<=time2);
        ToneInTime=RwdToneEvt(find(RwdToneEvt(:,1)>=time1 & RwdToneEvt(:,1)<=time2));
        NbTone_Day4(i)=length(ToneInTime);
        NbPokeOK_Day4(i)=length(find(PokeEvent(PokeInTime,3)==1));
        NbPokeOff_Day4(i)=length(find(PokeEvent(PokeInTime,3)==0));
    end
    
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
    save ResultDay4 -append NbTone_Day4 NbPokeOK_Day4 NbPokeOff_Day4
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
   
    load AttentionalEvent
    %--------------------------------------------------------------------------
    % Positive and negative pokes
    %--------------------------------------------------------------------------
    clear id
    for i=1:length(PokeEvent)
        id=(PokeEvent(i,1)-RwdToneEvt(:,1));
        a=find(id(:,1)>0 & id(:,1)<RewardWindow);
        if ~isempty(a)
            PokeEvent(i,3)=1;
        elseif isempty(a)
            PokeEvent(i,3)=0;
        end
    end
    
    Begin=RwdToneEvt(1,1);
    End=RwdToneEvt(length(RwdToneEvt(:,1)),1);
    windowNb=floor((End-Begin)/120);
    for i=1:windowNb
        time1=Begin+(i-1)*120;
        time2=Begin+i*120;
        PokeInTime=find(PokeEvent(:,1)>=time1 & PokeEvent(:,1)<=time2);
        ToneInTime=RwdToneEvt(find(RwdToneEvt(:,1)>=time1 & RwdToneEvt(:,1)<=time2));
        NbTone_Day5(i)=length(ToneInTime);
        NbPokeOK_Day5(i)=length(find(PokeEvent(PokeInTime,3)==1));
        NbPokeOff_Day5(i)=length(find(PokeEvent(PokeInTime,3)==0));
    end
    
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
    save ResultDay5 -append NbTone_Day5 NbPokeOK_Day5 NbPokeOff_Day5
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
NbPokeOK=[NbPokeOK_Day1 [1:20]  NbPokeOK_Day2 [1:20] NbPokeOK_Day3 [1:20] NbPokeOK_Day4 [1:20] NbPokeOK_Day5];
NbPokeOff=[NbPokeOff_Day1 [1:20]  NbPokeOff_Day2 [1:20] NbPokeOff_Day3 [1:20] NbPokeOff_Day4 [1:20] NbPokeOff_Day5];
figure,plot(NbPokeOK,'ro-','linewidth',1)
hold on, plot(NbPokeOff,'ko-','linewidth',1)
hold on, title(' 120 sec time windows --- pokeOK (red) VS pokeOff(black)')


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
    load AttentionalEvent
    %--------------------------------------------------------------------------
    % Positive and negative pokes
    %--------------------------------------------------------------------------
    clear id
    for i=1:length(PokeEvent)
        id=(PokeEvent(i,1)-RwdToneEvt(:,1));
        a=find(id(:,1)>0 & id(:,1)<RewardWindow);
        if ~isempty(a)
            PokeEvent(i,3)=1;
        elseif isempty(a)
            PokeEvent(i,3)=0;
        end
    end
    
    Begin=RwdToneEvt(1,1);
    End=RwdToneEvt(length(RwdToneEvt(:,1)),1);
    windowNb=floor((End-Begin)/120);
    for i=1:windowNb
        time1=Begin+(i-1)*120;
        time2=Begin+i*120;
        PokeInTime=find(PokeEvent(:,1)>=time1 & PokeEvent(:,1)<=time2);
        ToneInTime=RwdToneEvt(find(RwdToneEvt(:,1)>=time1 & RwdToneEvt(:,1)<=time2));
        NbTone_Day1(i)=length(ToneInTime);
        NbPokeOK_Day1(i)=length(find(PokeEvent(PokeInTime,3)==1));
        NbPokeOff_Day1(i)=length(find(PokeEvent(PokeInTime,3)==0));
    end
    
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
    save ResultDay1 -append NbTone_Day1 NbPokeOK_Day1 NbPokeOff_Day1 
    save ResultDay1 -append IntraSessionFirstPoke_Day1 IntraSessionPerc_Day1 IntraSessionRule2_Day1 IntraSessionTime2Tone_Day1
    save ResultDay1 -append RwdToneNb_Day1 PokeEventNb_Day1 RwdPokeNb_Day1 NonRwdPokeNb_Day1 RwdToneNb_Day1 NonRwdPokeMeanNb_Day1 RwdPokeMeanNb_Day1 RwdPokeMeanFq_Day1 NonRwdPokeMeanFq_Day1
end

% ------------------------ Day 2 : 1 seconds------------------
clear all
directoryName=('/media/DataMOBsG/AttentionalNosePoke/Mouse143');
cd([directoryName])
try load ResultDay2
catch
    cd([directoryName,'/20140723/ICSS-Mouse-143-23072014'])
    load AttentionalEvent
    %--------------------------------------------------------------------------
    % Positive and negative pokes
    %--------------------------------------------------------------------------
    clear id
    for i=1:length(PokeEvent)
        id=(PokeEvent(i,1)-RwdToneEvt(:,1));
        a=find(id(:,1)>0 & id(:,1)<RewardWindow);
        if ~isempty(a)
            PokeEvent(i,3)=1;
        elseif isempty(a)
            PokeEvent(i,3)=0;
        end
    end
    
    Begin=RwdToneEvt(1,1);
    End=RwdToneEvt(length(RwdToneEvt(:,1)),1);
    windowNb=floor((End-Begin)/120);
    for i=1:windowNb
        time1=Begin+(i-1)*120;
        time2=Begin+i*120;
        PokeInTime=find(PokeEvent(:,1)>=time1 & PokeEvent(:,1)<=time2);
        ToneInTime=RwdToneEvt(find(RwdToneEvt(:,1)>=time1 & RwdToneEvt(:,1)<=time2));
        NbTone_Day2(i)=length(ToneInTime);
        NbPokeOK_Day2(i)=length(find(PokeEvent(PokeInTime,3)==1));
        NbPokeOff_Day2(i)=length(find(PokeEvent(PokeInTime,3)==0));
    end
    
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
    save ResultDay2 -append NbTone_Day2 NbPokeOK_Day2 NbPokeOff_Day2 
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
    load AttentionalEvent_500ms
    %--------------------------------------------------------------------------
    % Positive and negative pokes
    %--------------------------------------------------------------------------
    clear id
    for i=1:length(PokeEvent)
        id=(PokeEvent(i,1)-RwdToneEvt(:,1));
        a=find(id(:,1)>0 & id(:,1)<RewardWindow);
        if ~isempty(a)
            PokeEvent(i,3)=1;
        elseif isempty(a)
            PokeEvent(i,3)=0;
        end
    end
    
    Begin=RwdToneEvt(1,1);
    End=RwdToneEvt(length(RwdToneEvt(:,1)),1);
    windowNb=floor((End-Begin)/120);
    for i=1:windowNb
        time1=Begin+(i-1)*120;
        time2=Begin+i*120;
        PokeInTime=find(PokeEvent(:,1)>=time1 & PokeEvent(:,1)<=time2);
        ToneInTime=RwdToneEvt(find(RwdToneEvt(:,1)>=time1 & RwdToneEvt(:,1)<=time2));
        NbTone_Day3(i)=length(ToneInTime);
        NbPokeOK_Day3(i)=length(find(PokeEvent(PokeInTime,3)==1));
        NbPokeOff_Day3(i)=length(find(PokeEvent(PokeInTime,3)==0));
    end
    
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
    save ResultDay3 -append NbTone_Day3 NbPokeOK_Day3 NbPokeOff_Day3
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
    load AttentionalEvent_100ms
    %--------------------------------------------------------------------------
    % Positive and negative pokes
    %--------------------------------------------------------------------------
    clear id
    for i=1:length(PokeEvent)
        id=(PokeEvent(i,1)-RwdToneEvt(:,1));
        a=find(id(:,1)>0 & id(:,1)<RewardWindow);
        if ~isempty(a)
            PokeEvent(i,3)=1;
        elseif isempty(a)
            PokeEvent(i,3)=0;
        end
    end
    
    Begin=RwdToneEvt(1,1);
    End=RwdToneEvt(length(RwdToneEvt(:,1)),1);
    windowNb=floor((End-Begin)/120);
    for i=1:windowNb
        time1=Begin+(i-1)*120;
        time2=Begin+i*120;
        PokeInTime=find(PokeEvent(:,1)>=time1 & PokeEvent(:,1)<=time2);
        ToneInTime=RwdToneEvt(find(RwdToneEvt(:,1)>=time1 & RwdToneEvt(:,1)<=time2));
        NbTone_Day4(i)=length(ToneInTime);
        NbPokeOK_Day4(i)=length(find(PokeEvent(PokeInTime,3)==1));
        NbPokeOff_Day4(i)=length(find(PokeEvent(PokeInTime,3)==0));
    end
    
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
    save ResultDay4 -append NbTone_Day4 NbPokeOK_Day4 NbPokeOff_Day4
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
   
    load AttentionalEvent
    %--------------------------------------------------------------------------
    % Positive and negative pokes
    %--------------------------------------------------------------------------
    clear id
    for i=1:length(PokeEvent)
        id=(PokeEvent(i,1)-RwdToneEvt(:,1));
        a=find(id(:,1)>0 & id(:,1)<RewardWindow);
        if ~isempty(a)
            PokeEvent(i,3)=1;
        elseif isempty(a)
            PokeEvent(i,3)=0;
        end
    end
    
    Begin=RwdToneEvt(1,1);
    End=RwdToneEvt(length(RwdToneEvt(:,1)),1);
    windowNb=floor((End-Begin)/120);
    for i=1:windowNb
        time1=Begin+(i-1)*120;
        time2=Begin+i*120;
        PokeInTime=find(PokeEvent(:,1)>=time1 & PokeEvent(:,1)<=time2);
        ToneInTime=RwdToneEvt(find(RwdToneEvt(:,1)>=time1 & RwdToneEvt(:,1)<=time2));
        NbTone_Day5(i)=length(ToneInTime);
        NbPokeOK_Day5(i)=length(find(PokeEvent(PokeInTime,3)==1));
        NbPokeOff_Day5(i)=length(find(PokeEvent(PokeInTime,3)==0));
    end
    
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
    save ResultDay5 -append NbTone_Day5 NbPokeOK_Day5 NbPokeOff_Day5
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
load ResultDay1; load ResultDay2;load ResultDay3;load ResultDay4;load ResultDay5;

NbPokeOK=[NbPokeOK_Day1 [1:20]  NbPokeOK_Day2 [1:20] NbPokeOK_Day3 [1:20] NbPokeOK_Day4 [1:20] NbPokeOK_Day5];
NbPokeOff=[NbPokeOff_Day1 [1:20]  NbPokeOff_Day2 [1:20] NbPokeOff_Day3 [1:20] NbPokeOff_Day4 [1:20] NbPokeOff_Day5];
figure,plot(NbPokeOK,'ro-','linewidth',1)
hold on, plot(NbPokeOff,'ko-','linewidth',1)
hold on, title(' 120 sec time windows --- pokeOK (red) VS pokeOff(black)')

