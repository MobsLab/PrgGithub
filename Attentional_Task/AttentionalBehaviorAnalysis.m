
try load AttentionalEvent
catch
    load StimTonePoke
    
    RwdToneEvt=ToneEvent/1E4;
    RwdStimEvt=MFBstimEvent/1E4;
    
    %-----------------------------------------------------------------------------------------------------------
    %                     Determination des temps de chaque sons/sequences/stim
    %-----------------------------------------------------------------------------------------------------------
    
    %load behavResources
    
    % RwdToneEvt=Event17;
    % RwdToneEvt(1)=[];
    % disp(' ')
    % disp(['nombre de sons récompensant :   ', num2str(length(RwdToneEvt))])
    % disp(' ')
    %
    % RwdStimEvt=Event21;
    % RwdStimEvt(1)=[];
    % disp(' ')
    % disp(['nombre de stimulations récompensantes :   ', num2str(length(RwdStimEvt))])
    % disp(' ')
    
    try
        StandardEvt=Event18;
        StandardEvt(1,:)=[];
        disp(' ')
        disp(['nombre de sons standard :   ', num2str(length(StandardEvt))])
        disp(' ')
        
        DeviantEvt=Event19;
        DeviantEvt(1,:)=[];
        disp(' ')
        disp(['nombre de sons déviants :   ', num2str(length(DeviantEvt))])
        disp(' ')
        
        OmissionEvt=Event20;
        OmissionEvt(1,:)=[];
        disp(' ')
        disp(['nombre de sons Omission :   ', num2str(length(OmissionEvt))])
        disp(' ')
        
        AllNonRwdEvt=[StandardEvt' DeviantEvt' OmissionEvt'];
        AllNonRwdEvt=AllNonRwdEvt';
        disp(' ')
        disp(['nombre total de sons non récompensants :   ', num2str(length(AllNonRwdEvt))])
        disp(' ')
    end
    
    disp(' ')
    RewardWindow=input('Duration of nose poke allowed window (tone + 3s) = ?  ');
    disp(' ')
    
    %-----------------------------------------------------------------------------------------------------------
    %                                 Determine all the NosePoke time
    %-----------------------------------------------------------------------------------------------------------
    res=pwd;
    load([res,'/LFPData/InfoLFP']);
    
    num=input('  LFP channel for Nose Poke ? (usual:0) ');
    load([res,'/LFPData/LFP',num2str(num)]);
    LFP2=ResampleTSD(LFP,500);
    i=num+1;
    
    signalPoke=Data(LFP2);
    tpsPoke=Range(LFP2);
    C=find(signalPoke<-20000);
    
    a=1;
    PokeEvent=[];
    PokeEvent(a,1)=tpsPoke(C(1));
    a=2;
    for j=1:length(C)-1
        if C(j+1)-C(j)>2;
            PokeEvent(a,1)=tpsPoke(C(j+1));   % début du nose poke
            a=a+1;
        end
    end
    a=1;
    for j=1:length(C)-1
        if C(j+1)-C(j)>2;
            PokeEvent(a,2)=tpsPoke(C(j));    % fin du nose poke
            a=a+1;
        end
    end
    PokeEvent(a,2)=tpsPoke(C(j));
    PokeEvent=PokeEvent/1E4;
    for i=1:length(PokeEvent)
        PokeEvent(i,3)=PokeEvent(i,2)-PokeEvent(i,1);    % duration of each poke
    end
    
    save AttentionalEvent -append PokeEvent
    
    figure, plot(Range(LFP,'s'),Data(LFP),'k'), title([InfoLFP.structure(num+1),'n= ',num2str(length(PokeEvent))])
    hold on, plot(PokeEvent(:,1),10,'rd','markerfacecolor','r','MarkerSize',5);
    hold on, plot(PokeEvent(:,2),10,'bd','markerfacecolor','b','MarkerSize',5);
    
    
    %-----------------------------------------------------------------------------------------------------------
    %                      number of poke for each time window (Rwd vs. Non-Rwd)
    %-----------------------------------------------------------------------------------------------------------
      
end  
    for i=2:length(RwdToneEvt)
        TimeTone1=RwdToneEvt(i-1);
        TimeTone2=RwdToneEvt(i);
        RwdToneEvt(i-1,2)=length(find(PokeEvent(:,1)>TimeTone1 & PokeEvent(:,1)<TimeTone1+RewardWindow & PokeEvent(:,1)<TimeTone2)); % number of poke during the rewarding window
        RwdToneEvt(i-1,3)=RwdToneEvt(i-1,2)/(RewardWindow);
        RwdToneEvt(i-1,4)=length(find(PokeEvent(:,1)>TimeTone1+RewardWindow & PokeEvent(:,1)<TimeTone2));  % number of non-rwd pokes between during non rewarding window
        RwdToneEvt(i-1,5)=RwdToneEvt(i-1,4)/(TimeTone2-(TimeTone1+RewardWindow));
    end
    
  
    
    RwdToneNb=length(RwdToneEvt);
    PokeEventNb=length(PokeEvent);
    
    RwdPokeNb=sum(RwdToneEvt(:,2));
    NonRwdPokeNb=sum(RwdToneEvt(:,4));
    
    RwdPokeMeanNb=mean(RwdToneEvt(:,2));
    RwdPokeMeanFq=mean(RwdToneEvt(:,3));
    NonRwdPokeMeanNb=mean(RwdToneEvt(:,4));
    NonRwdPokeMeanFq=mean(RwdToneEvt(:,5));
    
    try
        save AttentionalEvent -append RwdToneEvt StandardEvt DeviantEvt OmissionEvt RwdStimEvt
    catch
        save AttentionalEvent -append RwdToneEvt RwdStimEvt RewardWindow
    end

%-----------------------------------------------------------------------------------------------------------
%                      Percentage of success rule #1 (mouse have to poke when tone occurs)
%-----------------------------------------------------------------------------------------------------------

%--------------------------------------------------------------------------
% All Tone Result
%--------------------------------------------------------------------------
clear id FirstPoke
for i=1:length(RwdToneEvt),
    try
        id=(PokeEvent(:,1)-RwdToneEvt(i));
        pokeaftertone=id(find(id>0));
        FirstPoke(i)=min(pokeaftertone);
    end
end
MeanFirstPoke=mean(FirstPoke); % temps moyen pour le 1er nose poke
PercReward=length(find(FirstPoke<RewardWindow))/length(FirstPoke)*100; % percentage of success

figure, plot(FirstPoke,'ko-')
hold on, plot(0:0.1:length(FirstPoke),RewardWindow,'b'), title(['Success for Rewarding Tone (%) = ',num2str(PercReward)])

figure, plot(RwdToneEvt(:,1),FirstPoke,'ro-')
hold on, plot(RwdToneEvt(1:end-1,1),TimeTwoTone,'bo-')
hold on, plot(RwdToneEvt(:,1),RwdToneEvt(:,4),'ko-')
%--------------------------------------------------------------------------
% Positive and negative pokes
%--------------------------------------------------------------------------
clear id PokeEventOK PokeEventNO
for i=1:length(PokeEvent)
        id=(RwdToneEvt(:,1)-PokeEvent(i,1));
        a=find(id(:,1)>0 & id(:,1)<RewardWindow);
        if ~isempty(a)
            PokeEvent(i,3)=1;
            PokeEventOK(i,1)= PokeEvent(i,1);
        elseif isempty(a)
            PokeEvent(i,3)=0;
            PokeEventNO(i,1)= PokeEvent(i,1);
        end
end
j=1;
while j<length(PokeEventOK)
    if PokeEventOK(j,1)==0
        PokeEventOK(j,:)=[];
    end
    j=j+1;
end

j=1;
while j<length(PokeEventNO)
    if PokeEventNO(j,1)==0
        PokeEventNO(j,:)=[];
    end
    j=j+1;
end

figure, plot(FirstPoke,'ko-')
hold on, plot(0:0.1:length(FirstPoke),RewardWindow,'b'), title(['Success for Rewarding Tone (%) = ',num2str(PercReward)])

%--------------------------------------------------------------------------
% Fragmentation Result
%--------------------------------------------------------------------------
clear id FirstPoke IntraSessionMeanFirstPoke IntraSessionPercReward
wind=floor(length(RwdToneEvt)/10);
for i=1:wind,
    if i==1
        for j=1:10
            id=(PokeEvent(:,1)-RwdToneEvt(j));
            pokeaftertone=id(find(id>0));
            FirstPoke(j)=min(pokeaftertone);
        end
        IntraSessionMeanFirstPoke(i)=mean(FirstPoke);
        IntraSessionPercReward(i)=length(find(FirstPoke<RewardWindow))/length(FirstPoke)*100;
    elseif i>1
        clear id FirstPoke
        for j=(i-1)*10+1:i*10
            id=(PokeEvent(:,1)-RwdToneEvt(j));
            pokeaftertone=id(find(id>0));
            FirstPoke(j)=min(pokeaftertone);
        end
        IntraSessionMeanFirstPoke(i)=mean(FirstPoke(1,(i-1)*10+1:i*10));
        IntraSessionPercReward(i)=length(find(FirstPoke(1,(i-1)*10+1:i*10)<RewardWindow))/length(FirstPoke(1,(i-1)*10+1:i*10))*100;
    end
end
figure, plot(IntraSessionPercReward), title(['Success (%) = ',num2str(IntraSessionPercReward)])
figure, plot(IntraSessionMeanFirstPoke),title(['Mean Time to first Poke (s) = ',num2str(IntraSessionMeanFirstPoke)])

%-----------------------------------------------------------------------------------------------------------
%                                 Time between two successive tones
%-----------------------------------------------------------------------------------------------------------
for i=1:length(RwdToneEvt)-1,
    try
        TimeTwoTone(i)=(RwdToneEvt(i+1,1)-RwdToneEvt(i));
    end
end
figure, plot(TimeTwoTone,'ko-')
hold on, title('time between two successive tones')

wind=floor(length(RwdToneEvt)/10); % fragmentation by IntraSession 10 tones windows
for i=1:wind
    if i==1
        IntraSessionTimeTwoTone(i)=mean(TimeTwoTone(1,1:10));
    elseif i>1
        IntraSessionTimeTwoTone(i)=mean(TimeTwoTone(1,(i-1)*10+1:i*10-1));
    end
end
figure, plot(IntraSessionTimeTwoTone,'ko-')
hold on, title('time between two successive tones')

%-----------------------------------------------------------------------------------------------------------
%                                 Time of the last poke before tone
%-----------------------------------------------------------------------------------------------------------
clear LastPoke
for i=1:length(RwdToneEvt)-1,
    try
        id=(PokeEvent(:,1)-RwdToneEvt(i+1));
        lastpoke=id(find(id<0));
        LastPoke(i)=max(lastpoke);
    end
end
figure, plot(LastPoke,'ko-')
hold on, title('time between a tone and the last preceeding poke')

%-----------------------------------------------------------------------------------------------------------
%                     Percentage of success rule #2 (mouse have to restrain poke between two tones)
%-----------------------------------------------------------------------------------------------------------
disp('----------------------------------------------------------------------------------------------------------')
approximation=input('for how long do you authorize mice to test nosepoke and understand it is no longer rewarding (standard=1) ?  ');
disp('----------------------------------------------------------------------------------------------------------')

clear id
% Isolate each poke within between two successive tones
ab=cell(length(RwdToneEvt),1);

for i=1:(length(RwdToneEvt))
    id(:,i)=(PokeEvent(:,1)-RwdToneEvt(i));
end
for i=1:(length(RwdToneEvt)-1)
    temp=id(:,i);
    ab{i}=temp(find(id(:,i)>RewardWindow+approximation & id(:,i+1)<0));
end


%Determine la probabilité que la souris fasse un nose dans une fentre aléatoire de même durée
clear TEST PercPokeOnRdmTime rdmPokeOff
rdmPokeOff=cell(length(RwdToneEvt),100);

for i=1:(length(RwdToneEvt)-1)
    TEST=ab{i};
    try
        TimeOpenWindowOff=RewardWindow+approximation;
        TimeCloseWindowOff=RwdToneEvt(i+1,1)-RwdToneEvt(i,1);
        timefirstpoke=TEST(1);
        timelastpoke=TEST(length(TEST));
        for j=1:100;
            rdmTime(j)=rand*100;
        end
        for j=1:100;
            if rdmTime(1,j)>TimeOpenWindowOff & rdmTime(1,j)<(TimeCloseWindowOff-RewardWindow)
                a=TEST(find(TEST(:,1)>rdmTime(j) & TEST(:,1)<rdmTime(j)+RewardWindow));
                if a>0;
                    rdmPokeOff{i,j}=a;
                end
            end
        end
    end
end

for i=1:length(RwdToneEvt)
    perc=0;
    for j=1:100
        A{j}=rdmPokeOff{i,j};
        if ~isempty(A{j})
            perc=perc+1;
        end
    end
    PercPokeOnRdmTime(i)=perc;
end
RdmSuccesRule2=mean(PercPokeOnRdmTime);

wind=floor(length(RwdToneEvt)/10); % fragmentation by IntraSession 10 tones windows
for i=1:wind
    if i==1
        IntraSessionSuccesRule2(i)=mean(PercPokeOnRdmTime(1,1:10));
    elseif i>1
        IntraSessionSuccesRule2(i)=mean(PercPokeOnRdmTime(1,(i-1)*10+1:i*10));
    end
end
figure, plot(PercPokeOnRdmTime,'ko-'), title(['% of nose poke on a random non-reward window = ',num2str(RdmSuccesRule2)])
figure, plot(IntraSessionSuccesRule2,'ko-'), title(['% of nose poke on a random non-reward window = ',num2str(mean(IntraSessionSuccesRule2))])




%-----------------------------------------------------------------------------------------------------------
%                                          save values
%-----------------------------------------------------------------------------------------------------------
disp(' ')
sav=input('Do you want to save all recent value in LastResults (yes/1 - no/0) ? ')
disp(' ')

if sav==1
    save LastResults  RwdToneNb PokeEventNb RwdPokeNb NonRwdPokeNb RwdPokeMeanNb RwdPokeMeanFq NonRwdPokeMeanNb NonRwdPokeMeanFq
    save LastResults -append MeanFirstPoke PercReward RdmSuccesRule2 TimeTwoTone LastPoke
    save LastResults -append IntraSessionMeanFirstPoke IntraSessionPercReward IntraSessionSuccesRule2 IntraSessionTimeTwoTone
end

clear all

%-----------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------
%                  Generalization analysis (mouse have to restrain poke when GenTone occurs)
%-----------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------

disp('---------------------------------------')
generalizationTestFreq=input('was there a multiple frequency generalization test 1(yes) / 0(no)  ? ');
disp('---------------------------------------')

if generalizationTestFreq==1;
    
    load AttentionalEvent
    disp('---------------------------------------')
    disp(['quantity of generalization tones : ',num2str(length(AllNonRwdEvt))])
    disp('---------------------------------------')
    
    %----------------------------------------------------------------------
    %       suppresses too close tones (event artifacts)
    %----------------------------------------------------------------------
    try
        for i=1:length(AllNonRwdEvt)-1
            id=(AllNonRwdEvt(i,1)-AllNonRwdEvt(i+1,1));
            if abs(id)>0 & abs(id)<0.1
                AllNonRwdEvt(i+1,2)=1;
            end
        end
        
        disp(' ')
        disp([' number of suppressed tone for analysis :', num2str(length(find(AllNonRwdEvt(:,2)==1)))])
        disp(' ')
        
        AllNonRwdEvt((find(AllNonRwdEvt(:,2)==1)),:)=[];
    end
    
    %-----------------------------------------------------------------------------------------------------------
    %-----------------------------------------------------------------------------------------------------------
    
    
    %-----------------------------
    %   5kHz analysis
    %-----------------------------
    Do=input('was there a 5kHz tone presentation during the protocol ? (yes/1 - no/0)   ');
    if Do==1
        disp(' ')
        generalization5kHz=input('5kHz frequency numbers (e.g. [40:60]) =  ');
        ToneEvt5kHz=AllNonRwdEvt(generalization5kHz(1):generalization5kHz(length(generalization5kHz)));
        %ToneEvt5kHz=ToneEvt5kHz';
        save AttentionalEvent -append ToneEvt5kHz
        
        % number of poke during "Rwd" time window
        for i=2:length(ToneEvt5kHz),
            TimeTone1=ToneEvt5kHz(i-1);
            TimeTone2=ToneEvt5kHz(i);
            ToneEvt5kHz(i-1,2)=length(find(PokeEvent(:,1)>TimeTone1 & PokeEvent(:,1)<TimeTone1+RewardWindow & PokeEvent(:,1)<TimeTone2)); % number of poke during the rewarding window
            ToneEvt5kHz(i-1,3)=ToneEvt5kHz(i-1,2)/(RewardWindow);
        end
        
        Tone5kHzNb=length(ToneEvt5kHz);
        Poke5kHzNb=sum(ToneEvt5kHz(:,2));
        Poke5kHzMeanNb=mean(ToneEvt5kHz(:,2));
        Poke5kHzMeanFq=mean(ToneEvt5kHz(:,3));
        
        for i=1:length(ToneEvt5kHz)
            id=(PokeEvent(:,1)-ToneEvt5kHz(i));
            pokeaftertone=id(find(id>0));
            FirstPokeGen5kHz(i)=min(pokeaftertone);
        end
        % temps moyen pour le 1er nose poke
        MeanFirstPokeGen5kHz=mean(FirstPokeGen5kHz);
        % percentage of "success"
        PercRewardGen5kHz=length(find(FirstPokeGen5kHz>0.2 & FirstPokeGen5kHz<RewardWindow))/length(FirstPokeGen5kHz)*100;
        
        save GeneralizationResult -append Tone5kHzNb Poke5kHzNb Poke5kHzMeanNb Poke5kHzMeanFq MeanFirstPokeGen5kHz PercRewardGen5kHz
        
    end
    
    %-----------------------------
    %   10kHz analysis
    %-----------------------------
    Do=input('was there a 10kHz tone presentation during the protocol ? (yes/1 - no/0)   ');
    if Do==1
        disp(' ')
        generalization10kHz=input('10kHz frequency numbers (e.g. [40:60]) =  ');
        ToneEvt10kHz=AllNonRwdEvt(generalization10kHz(1):generalization10kHz(length(generalization10kHz)));
        %ToneEvt10kHz=ToneEvt10kHz';
        save AttentionalEvent -append ToneEvt10kHz
        
        % number of poke during "Rwd" time window
        for i=2:length(ToneEvt10kHz),
            TimeTone1=ToneEvt10kHz(i-1);
            TimeTone2=ToneEvt10kHz(i);
            ToneEvt10kHz(i-1,2)=length(find(PokeEvent(:,1)>TimeTone1 & PokeEvent(:,1)<TimeTone1+RewardWindow & PokeEvent(:,1)<TimeTone2)); % number of poke during the rewarding window
            ToneEvt10kHz(i-1,3)=ToneEvt10kHz(i-1,2)/(RewardWindow);
        end
        
        Tone10kHzNb=length(ToneEvt10kHz);
        Poke10kHzNb=sum(ToneEvt10kHz(:,2));
        Poke10kHzMeanNb=mean(ToneEvt10kHz(:,2));
        Poke10kHzMeanFq=mean(ToneEvt10kHz(:,3));
        
        for i=1:length(ToneEvt10kHz)
            id=(PokeEvent(:,1)-ToneEvt10kHz(i));
            pokeaftertone=id(find(id>0));
            FirstPokeGen10kHz(i)=min(pokeaftertone);
        end
        % temps moyen pour le 1er nose poke
        MeanFirstPokeGen10kHz=mean(FirstPokeGen10kHz);
        % percentage of "success"
        PercRewardGen10kHz=length(find(FirstPokeGen10kHz>0.2 & FirstPokeGen10kHz<RewardWindow))/length(FirstPokeGen10kHz)*100;
        
        save GeneralizationResult -append Tone10kHzNb Poke10kHzNb Poke10kHzMeanNb Poke10kHzMeanFq MeanFirstPokeGen10kHz PercRewardGen10kHz
        
    end
    %-----------------------------
    %   15kHz analysis
    %-----------------------------
    Do=input('was there a 15kHz tone presentation during the protocol ? (yes/1 - no/0)   ');
    if Do==1
        disp(' ')
        generalization15kHz=input('15kHz frequency numbers (e.g. [40:60]) =  ');
        ToneEvt15kHz=AllNonRwdEvt(generalization15kHz(1):generalization15kHz(length(generalization15kHz)));
        %ToneEvt15kHz=ToneEvt15kHz';
        save AttentionalEvent -append ToneEvt15kHz
        
        % number of poke during "Rwd" time windowcle'
        for i=2:length(ToneEvt15kHz),
            TimeTone1=ToneEvt15kHz(i-1);
            TimeTone2=ToneEvt15kHz(i);
            ToneEvt15kHz(i-1,2)=length(find(PokeEvent(:,1)>TimeTone1 & PokeEvent(:,1)<TimeTone1+RewardWindow & PokeEvent(:,1)<TimeTone2)); % number of poke during the rewarding window
            ToneEvt15kHz(i-1,3)=ToneEvt15kHz(i-1,2)/(RewardWindow);
        end
        
        Tone15kHzNb=length(ToneEvt15kHz);
        Poke15kHzNb=sum(ToneEvt15kHz(:,2));
        Poke15kHzMeanNb=mean(ToneEvt15kHz(:,2));
        Poke15kHzMeanFq=mean(ToneEvt15kHz(:,3));
        
        for i=1:length(ToneEvt15kHz)
            id=(PokeEvent(:,1)-ToneEvt15kHz(i));
            pokeaftertone=id(find(id>0));
            FirstPokeGen15kHz(i)=min(pokeaftertone);
        end
        % temps moyen pour le 1er nose poke
        MeanFirstPokeGen15kHz=mean(FirstPokeGen15kHz);
        % percentage of "success"
        PercRewardGen15kHz=length(find(FirstPokeGen15kHz>0.2 & FirstPokeGen15kHz<RewardWindow))/length(FirstPokeGen15kHz)*100;
        
        save GeneralizationResult -append Tone15kHzNb Poke15kHzNb Poke15kHzMeanNb Poke15kHzMeanFq MeanFirstPokeGen15kHz PercRewardGen15kHz
        
    end
    
    
    %-----------------------------
    %   20kHz analysis
    %-----------------------------
    Do=input('was there a 20kHz tone presentation during the protocol ? (yes/1 - no/0)   ');
    if Do==1
        disp(' ')
        generalization20kHz=input('20kHz frequency numbers (e.g. [40:60]) =  ');
        ToneEvt20kHz=AllNonRwdEvt(generalization20kHz(1):generalization20kHz(length(generalization20kHz)));
        %ToneEvt20kHz=ToneEvt20kHz';
        save AttentionalEvent -append ToneEvt20kHz
        
        % number of poke during "Rwd" time window
        for i=2:length(ToneEvt20kHz),
            TimeTone1=ToneEvt20kHz(i-1);
            TimeTone2=ToneEvt20kHz(i);
            ToneEvt20kHz(i-1,2)=length(find(PokeEvent(:,1)>TimeTone1 & PokeEvent(:,1)<TimeTone1+RewardWindow & PokeEvent(:,1)<TimeTone2)); % number of poke during the rewarding window
            ToneEvt20kHz(i-1,3)=ToneEvt20kHz(i-1,2)/(RewardWindow);
        end
        
        Tone20kHzNb=length(ToneEvt20kHz);
        Poke20kHzNb=sum(ToneEvt20kHz(:,2));
        Poke20kHzMeanNb=mean(ToneEvt20kHz(:,2));
        Poke20kHzMeanFq=mean(ToneEvt20kHz(:,3));
        
        for i=1:length(ToneEvt20kHz)
            id=(PokeEvent(:,1)-ToneEvt20kHz(i));
            pokeaftertone=id(find(id>0));
            FirstPokeGen20kHz(i)=min(pokeaftertone);
        end
        % temps moyen pour le 1er nose poke
        MeanFirstPokeGen20kHz=mean(FirstPokeGen20kHz);
        % percentage of "success"
        PercRewardGen20kHz=length(find(FirstPokeGen20kHz>0.2 & FirstPokeGen20kHz<RewardWindow))/length(FirstPokeGen20kHz)*100;
        
        try
            save GeneralizationResult -append Tone20kHzNb Poke20kHzNb Poke20kHzMeanNb Poke20kHzMeanFq MeanFirstPokeGen20kHz PercRewardGen20kHz
        catch
            save GeneralizationResult Tone20kHzNb Poke20kHzNb Poke20kHzMeanNb Poke20kHzMeanFq MeanFirstPokeGen20kHz PercRewardGen20kHz
        end
    end
    
    %-----------------------------
    %   25kHz analysis
    %-----------------------------
    Do=input('was there a 25kHz tone presentation during the protocol ? (yes/1 - no/0)   ');
    if Do==1
        disp(' ')
        generalization25kHz=input('25kHz frequency numbers (e.g. [40:60]) =  ');
        ToneEvt25kHz=AllNonRwdEvt(generalization25kHz(1):generalization25kHz(length(generalization25kHz)));
        %ToneEvt25kHz=ToneEvt25kHz';
        save AttentionalEvent -append ToneEvt25kHz
        
        % number of poke during "Rwd" time window
        for i=2:length(ToneEvt25kHz),
            TimeTone1=ToneEvt25kHz(i-1);
            TimeTone2=ToneEvt25kHz(i);
            ToneEvt25kHz(i-1,2)=length(find(PokeEvent(:,1)>TimeTone1 & PokeEvent(:,1)<TimeTone1+RewardWindow & PokeEvent(:,1)<TimeTone2)); % number of poke during the rewarding window
            ToneEvt25kHz(i-1,3)=ToneEvt25kHz(i-1,2)/(RewardWindow);
        end
        
        Tone25kHzNb=length(ToneEvt25kHz);
        Poke25kHzNb=sum(ToneEvt25kHz(:,2));
        Poke25kHzMeanNb=mean(ToneEvt25kHz(:,2));
        Poke25kHzMeanFq=mean(ToneEvt25kHz(:,3));
        
        for i=1:length(ToneEvt25kHz)
            id=(PokeEvent(:,1)-ToneEvt25kHz(i));
            pokeaftertone=id(find(id>0));
            FirstPokeGen25kHz(i)=min(pokeaftertone);
        end
        % temps moyen pour le 1er nose poke
        MeanFirstPokeGen25kHz=mean(FirstPokeGen25kHz);
        % percentage of "success"
        PercRewardGen25kHz=length(find(FirstPokeGen25kHz>0.2 & FirstPokeGen25kHz<RewardWindow))/length(FirstPokeGen25kHz)*100;
        
        save GeneralizationResult -append Tone25kHzNb Poke25kHzNb Poke25kHzMeanNb Poke25kHzMeanFq MeanFirstPokeGen25kHz PercRewardGen25kHz
        
    end
    
    %-----------------------------
    %   30kHz analysis
    %-----------------------------
    Do=input('was there a 30kHz tone presentation during the protocol ? (yes/1 - no/0)   ');
    if Do==1
        disp(' ')
        generalization30kHz=input('30kHz frequency numbers (e.g. [40:60]) =  ');
        ToneEvt30kHz=AllNonRwdEvt(generalization30kHz(1):generalization30kHz(length(generalization30kHz)));
       %ToneEvt30kHz=ToneEvt30kHz';
        save AttentionalEvent -append ToneEvt30kHz
        
        % number of poke during "Rwd" time window
        for i=2:length(ToneEvt30kHz),
            TimeTone1=ToneEvt30kHz(i-1);
            TimeTone2=ToneEvt30kHz(i);
            ToneEvt30kHz(i-1,2)=length(find(PokeEvent(:,1)>TimeTone1 & PokeEvent(:,1)<TimeTone1+RewardWindow & PokeEvent(:,1)<TimeTone2)); % number of poke during the rewarding window
            ToneEvt30kHz(i-1,3)=ToneEvt30kHz(i-1,2)/(RewardWindow);
        end
        
        Tone30kHzNb=length(ToneEvt30kHz);
        Poke30kHzNb=sum(ToneEvt30kHz(:,2));
        Poke30kHzMeanNb=mean(ToneEvt30kHz(:,2));
        Poke30kHzMeanFq=mean(ToneEvt30kHz(:,3));
        
        for i=1:length(ToneEvt30kHz)
            id=(PokeEvent(:,1)-ToneEvt30kHz(i));
            pokeaftertone=id(find(id>0));
            FirstPokeGe30kHz(i)=min(pokeaftertone);
        end
        % temps moyen pour le 1er nose poke
        MeanFirstPokeGen30kHz=mean(FirstPokeGe30kHz);
        % percentage of "success"
        PercRewardGen30kHz=length(find(FirstPokeGe30kHz>0.2 & FirstPokeGe30kHz<RewardWindow))/length(FirstPokeGe30kHz)*100;
        
        save GeneralizationResult -append Tone30kHzNb Poke30kHzNb Poke30kHzMeanNb Poke30kHzMeanFq MeanFirstPokeGen30kHz PercRewardGen30kHz
        
    end
    
end


%-----------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------
%                              Attentional time windows definition
%-----------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------

disp('---------------------------------------')
LocalGlobal=input('was is Local / Global paradigm 1(yes) / 0(no)  ? ');
disp('---------------------------------------')

if LocalGlobal==1
    
    %-------------------------------------------------------------------------------------
    %   give a value 1 or 0 to each Rewardin Tone regarding the given behavioral success
    %-------------------------------------------------------------------------------------
    for i=1:length(RwdToneEvt),
        try
            idRwd=(PokeEvent(:,1)-RwdToneEvt(i));
            if ~isempty (idRwd(find(idRwd>0 & idRwd<RewardWindow)));
                RwdToneEvt(i,2)=1;
            elseif isempty (idRwd(find(idRwd>0 & idRwd<RewardWindow)))
                RwdToneEvt(i,2)=0;
            end
        end
    end
    
    %--------------------------------------------------------------------------------------
    % give a value 1 or 0 to each Non-Rewarding Tone regarding the given behavioral success
    %--------------------------------------------------------------------------------------
    % Local Standard Sequence
    for j=1:length(RwdToneEvt)
        if RwdToneEvt(j,2)==1
            for i=1:length(StandardEvt),
                idStd=(StandardEvt(:,1)-RwdToneEvt(j,1));
                a=find(idStd>0);
                StandardEvt(a,2)=1;
            end
        elseif RwdToneEvt(j,2)==0
            for i=1:length(StandardEvt),
                idStd=(StandardEvt(:,1)-RwdToneEvt(j,1));
                a=find(idStd>0);
                StandardEvt(a,2)=0;
            end
        end
    end
    PercAttentionalStandard=length(find(StandardEvt(:,2)==1))/length(StandardEvt)*100;
    disp(' ')
    disp([' Standard sequence occuring during attentional state (%) =  ', num2str(PercAttentionalStandard)])
    disp(' ')
    
    
    % Local Deviant Sequence
    for j=1:length(RwdToneEvt)
        if RwdToneEvt(j,2)==1
            for i=1:length(DeviantEvt),
                idDvt=(DeviantEvt(:,1)-RwdToneEvt(j,1));
                a=find(idDvt>0);
                DeviantEvt(a,2)=1;
            end
        elseif RwdToneEvt(j,2)==0
            for i=1:length(DeviantEvt),
                idDvt=(DeviantEvt(:,1)-RwdToneEvt(j,1));
                a=find(idDvt>0);
                DeviantEvt(a,2)=0;
            end
        end
    end
    PercAttentionalDeviant=length(find(DeviantEvt(:,2)==1))/length(DeviantEvt)*100;
    disp(' ')
    disp([' Deviant sequence occuring during attentional state (%) =  ', num2str(PercAttentionalDeviant)])
    disp(' ')
    
    % Local Omission Sequence
    for j=1:length(RwdToneEvt)
        if RwdToneEvt(j,2)==1
            for i=1:length(OmissionEvt),
                idOmi=(OmissionEvt(:,1)-RwdToneEvt(j,1));
                a=find(idOmi>0);
                OmissionEvt(a,2)=1;
            end
        elseif RwdToneEvt(j,2)==0
            for i=1:length(OmissionEvt),
                idOmi=(OmissionEvt(:,1)-RwdToneEvt(j,1));
                a=find(idOmi>0);
                OmissionEvt(a,2)=0;
            end
        end
    end
    PercAttentionalOmission=length(find(OmissionEvt(:,2)==1))/length(OmissionEvt)*100;
    disp(' ')
    disp([' Omission sequence occuring during attentional state (%) =  ', num2str(PercAttentionalOmission)])
    disp(' ')
    
    save -append LastResults -append PercAttentionalStandard PercAttentionalDeviant PercAttentionalOmission
    
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    