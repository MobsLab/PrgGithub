
clear all

RewardWindow=input('Duration of nose poke allowed window (tone + 3s) = ?  ');

%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
% Percentage of success rule #1 (mouse have to poke when tone occurs)
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
load StimTonePoke
for i=1:length(ToneEvent),
    try
        id=(PokeEvent(:,1)-ToneEvent(i))/1E4;
        pokeaftertone=id(find(id>0));
        FirstPoke(i)=min(pokeaftertone);
    end
end
MeanFirstPoke=mean(FirstPoke); % temps moyen pour le 1er nose poke
PercReward=length(find(FirstPoke<RewardWindow))/length(FirstPoke)*100; % percentage of success

figure, plot(FirstPoke,'ko-')
hold on, plot(0:0.1:length(FirstPoke),RewardWindow,'b'), title(['Success for Rewarding Tone (%) = ',num2str(PercReward)])

disp('---------------------------------------------------------')
start=input('when mouse have really started to play the game ? ')
disp('---------------------------------------------------------')

clear id FirstPoke FirstPokeTime
for i=start:length(ToneEvent), 
    id=(PokeEvent(:,1)-ToneEvent(i))/1E4; 
    pokeaftertone=id(find(id>0));
    FirstPoke(i)=min(pokeaftertone);
    pokeaftertoneIdx=find(id>0);
    FirstPokeTime(i)=PokeEvent(min(pokeaftertoneIdx),1)/1E4;
end

MeanFirstPoke=mean(FirstPoke); % temps moyen pour le 1er nose poke
PercReward=length(find(FirstPoke<RewardWindow))/length(FirstPoke)*100; % percentage of success
close

save LastResults  MeanFirstPoke  PercReward FirstPoke

%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
%                      Time between two tones
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
for i=start:length(ToneEvent)-1,
    try
       TimeTwoTone(i)=(ToneEvent(i+1,1)-ToneEvent(i))/1E4;
    end
end

figure, plot(TimeTwoTone,'ko-')
hold on, title('time between two successive tones')
save LastResults -append TimeTwoTone

%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
%                   Time of last poke before tone
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
clear LastPoke
for i=start:length(ToneEvent)-1,
    try
       id=(PokeEvent(:,1)-ToneEvent(i+1))/1E4; 
       lastpoke=id(find(id<0));
       LastPoke(i)=max(lastpoke);
    end
end

figure, plot(LastPoke,'ko-')
hold on, title('time between a tone and the last preceeding poke')

save LastResults -append LastPoke


%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
% Percentage of success rule #2 (mouse have to restrain poke between two tones)
%-------------------------------------------------------------------------------
%------------------------------------------------------------------------------
clear id

ab=cell(length(ToneEvent),1);

for i=start:(length(ToneEvent)) 
    id(:,i)=(PokeEvent(:,1)-ToneEvent(i))/1E4; 
end
for i=start:(length(ToneEvent)-1) 
    temp=id(:,i);
    ab{i}=temp(find(id(:,i)>RewardWindow & id(:,i+1)<0));
end

%Determine le pourcentage de reussite rule 2 dans lequel la souris ne fait aucun nosepoke entre la fin de la periode de récompense + un temps donné et le prochain son
disp('----------------------------------------------------------------------------------------------------------')
approximation=input('for how long do you authorize mice to test nosepoke and understand it is no longer rewarding (standard=3) ?  ');
disp('----------------------------------------------------------------------------------------------------------')

clear cd TEST C D
cd=ab;
for i=start:(length(ToneEvent)-1)
    TEST=ab{i};
    try
        if TEST(length(TEST))<RewardWindow+approximation
            cd{i}=[];
        end
    end
end        

for i=start:(length(ToneEvent)-1)
    if isempty(cd{i})==1
        C(i)=2;
    end
end
C=C';
D=find(C(start:length(C))==2);
WildSuccesRule2=length(D)/(length(ToneEvent)-start)*100


figure, plot(FirstPokeTime(start:length(FirstPoke)),FirstPoke(start:length(FirstPoke)),'ko-')
hold on, plot(0:0.1:FirstPokeTime(length(FirstPokeTime)),RewardWindow,'b'), title(['Success Rule#1 : ',num2str(PercReward), '% --- Success Rule#2 with approximation :',num2str(WildSuccesRule2),'%'])

%Determine la probabilité que la souris fasse un nose dans une fentre aléatoire de même durée
clear cd TEST PercPokeOnRdmTime rdmPokeOff
rdmPokeOff=cell(length(ToneEvent),10000);

for i=start:(length(ToneEvent)-1)
    TEST=ab{i};
    try
        timefirstpoke=TEST(1);
        timelastpoke=TEST(length(TEST));
        for j=1:10000;
            rdmTime(j)=rand*100;
        end
        for j=1:10000;
            if rdmTime(1,j)>timefirstpoke & rdmTime(1,j)<(timelastpoke-approximation)
                a=TEST(find(TEST(:,1)>rdmTime(j) & TEST(:,1)<rdmTime(j)+approximation));
                if a>0;
                    rdmPokeOff{i,j}=a;
                end
            end
        end
    end
end

for i=start:length(ToneEvent)
    perc=0;
    for j=1:10000
        A{j}=rdmPokeOff{i,j};
        if isempty(A{j})
            perc=perc+1;
        end
    end
    PercPokeOnRdmTime(i)=100-(perc/100);
end

RdmSuccesRule2=mean(PercPokeOnRdmTime);

figure, plot(PercPokeOnRdmTime,'ko-'), title(['% of nose poke on a random non-reward window = ',num2str(RdmSuccesRule2)]) 


save LastResults -append WildSuccesRule2 RdmSuccesRule2


%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
% Percentage of generalization (mouse have to restrain poke when GenTone occurs)
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
disp('---------------------------------------')
generalization=input('was there a genralization sound 1(yes) / 0(no)  ? ');
disp('---------------------------------------')

if generalization==1;
    
    load StimTonePoke
    disp('---------------------------------------')
    disp(['quantity of generalization tones : ',num2str(length(GenToneEvent))])
    disp('---------------------------------------')
        
    generalization1=input('first frequency numbers (e.g. [1:20]) =  ');
    generalization2=input('first frequency numbers (e.g. [20:40]) =  ');
    generalization3=input('first frequency numbers (e.g. [4:30]) =  ');
        
    clear id FirstPokeGen1 FirstPokeGen2 FirstPokeGen3
    
    for i=generalization1(1):length(generalization1),
        id=(PokeEvent(:,1)-GenToneEvent(i))/1E4;
        pokeaftertone=id(find(id>0));
        FirstPokeGen1(i)=min(pokeaftertone);
    end
    for i=generalization2(1):generalization2(length(generalization2)),
        id=(PokeEvent(:,1)-GenToneEvent(i))/1E4;
        pokeaftertone=id(find(id>0));
        FirstPokeGen2(i)=min(pokeaftertone);
    end
    for i=generalization3(1):generalization3(length(generalization3)),
        id=(PokeEvent(:,1)-GenToneEvent(i))/1E4;
        pokeaftertone=id(find(id>0));
        FirstPokeGen3(i)=min(pokeaftertone);
    end
    
    MeanFirstPokeGen1=mean(FirstPokeGen1); % temps moyen pour le 1er nose poke
    PercRewardGen1=length(find(FirstPokeGen1>0.4 & FirstPokeGen1<RewardWindow))/length(FirstPokeGen1)*100; % percentage of success
    
    MeanFirstPokeGen2=mean(FirstPokeGen2); % temps moyen pour le 1er nose poke
    PercRewardGen2=length(find(FirstPokeGen2(length(FirstPokeGen1)+1:length(FirstPokeGen2))>0.4 & FirstPokeGen2(length(FirstPokeGen1)+1:length(FirstPokeGen2))<RewardWindow))/(length(FirstPokeGen2)-length(FirstPokeGen1))*100; % percentage of success
    
    MeanFirstPokeGen3=mean(FirstPokeGen3); % temps moyen pour le 1er nose poke
    PercRewardGen3=length(find(FirstPokeGen3(length(FirstPokeGen2)+1:length(FirstPokeGen3))>0.4 & FirstPokeGen3(length(FirstPokeGen2)+1:length(FirstPokeGen3))<RewardWindow))/(length(FirstPokeGen3)-length(FirstPokeGen2))*100; % percentage of success
    
    save LastResults -append MeanFirstPokeGen1 PercRewardGen1 MeanFirstPokeGen2 PercRewardGen2 MeanFirstPokeGen3  PercRewardGen3
    
    figure, plot(FirstPokeGen1,'ko-')
    hold on, plot(FirstPokeGen2,'ro-')
    hold on, plot(FirstPokeGen3,'bo-')
    
    hold on, plot(0:0.1:length(GenToneEvent),RewardWindow,'g')
    hold on, plot(0:0.1:length(GenToneEvent),0.4,'g')
    hold on, title(['Failure GenTone1 (%) = ',num2str(PercRewardGen1),'--- Failure GenTone1 (%) = ',num2str(PercRewardGen2),'--- Failure GenTone3 (%) = ',num2str(PercRewardGen3)])
end



