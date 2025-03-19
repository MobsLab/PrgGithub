
load behavResources
% 
% load StimTonePoke
% RwdToneEvt=ToneEvent/1E4;
% RwdStimEvt=MFBstimEvent/1E4;
% save AttentionalEvent RwdStimEvt RwdToneEvt 


%------------------------------------------------------
% Determination des temps de chaque sons/sequences/stim
%------------------------------------------------------
RwdToneEvt=Event17;
RwdToneEvt(1)=[];
disp(' ')
disp(['nombre de sons récompensant :   ', num2str(length(RwdToneEvt))])
disp(' ')

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

RwdStimEvt=Event21;
RwdStimEvt(1)=[];
disp(' ')
disp(['nombre de stimulations récompensantes :   ', num2str(length(RwdStimEvt))])
disp(' ')


try
    save AttentionalEvent RwdToneEvt StandardEvt DeviantEvt OmissionEvt RwdStimEvt
catch
    save AttentionalEvent RwdToneEvt RwdStimEvt
end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%                    Determine all the NosePoke time
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
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

save AttentionalEvent -append PokeEvent

figure, plot(Range(LFP,'s'),Data(LFP),'k'), title([InfoLFP.structure(num+1),'n= ',num2str(length(PokeEvent))])
hold on, plot(PokeEvent(:,1),10,'rd','markerfacecolor','r','MarkerSize',5);
hold on, plot(PokeEvent(:,2),10,'bd','markerfacecolor','b','MarkerSize',5);

%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
%     Percentage of success rule #1 (mouse have to poke when tone occurs)
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
disp(' ')
RewardWindow=input('Duration of nose poke allowed window (tone + 3s) = ?  ');
disp(' ')
save AttentionalEvent -append RewardWindow

%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
%     Percentage of success rule #1 (mouse have to poke when tone occurs)
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
% All Tone Result
%-------------------------------------------------------------------------------
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
save LastResults  MeanFirstPoke PercReward FirstPoke

figure, plot(FirstPoke,'ko-')
hold on, plot(0:0.1:length(FirstPoke),RewardWindow,'b'), title(['Success for Rewarding Tone (%) = ',num2str(PercReward)])
%-------------------------------------------------------------------------------
% Fragmentation Result
%-------------------------------------------------------------------------------
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
save LastResults -append IntraSessionMeanFirstPoke IntraSessionPercReward 

figure, plot(IntraSessionPercReward), title(['Success (%) = ',num2str(IntraSessionPercReward)])
figure, plot(IntraSessionMeanFirstPoke),title(['Mean Time to first Poke (s) = ',num2str(IntraSessionMeanFirstPoke)])

%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
% Percentage of success rule #2 (mouse have to restrain poke between two tones)
%-------------------------------------------------------------------------------
%------------------------------------------------------------------------------
clear id

ab=cell(length(RwdToneEvt),1);

for i=1:(length(RwdToneEvt)) 
    id(:,i)=(PokeEvent(:,1)-RwdToneEvt(i)); 
end
for i=1:(length(RwdToneEvt)-1) 
    temp=id(:,i);
    ab{i}=temp(find(id(:,i)>RewardWindow & id(:,i+1)<0));
end


%Determine la probabilité que la souris fasse un nose dans une fentre aléatoire de même durée
clear cd TEST PercPokeOnRdmTime rdmPokeOff
rdmPokeOff=cell(length(RwdToneEvt),10000);

disp('----------------------------------------------------------------------------------------------------------')
approximation=input('for how long do you authorize mice to test nosepoke and understand it is no longer rewarding (standard=1) ?  ');
disp('----------------------------------------------------------------------------------------------------------')

for i=1:(length(RwdToneEvt)-1)
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

for i=1:length(RwdToneEvt)
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

wind=floor(length(RwdToneEvt)/10); % fragmentation by IntraSession 10 tones windows
for i=1:wind
    if i==1
        IntraSessionSuccesRule2(i)=mean(PercPokeOnRdmTime(1,1:10));
    elseif i>1
        IntraSessionSuccesRule2(i)=mean(PercPokeOnRdmTime(1,(i-1)*10+1:i*10));
    end
end
save LastResults -append RdmSuccesRule2 IntraSessionSuccesRule2

figure, plot(PercPokeOnRdmTime,'ko-'), title(['% of nose poke on a random non-reward window = ',num2str(RdmSuccesRule2)]) 
figure, plot(IntraSessionSuccesRule2,'ko-'), title(['% of nose poke on a random non-reward window = ',num2str(mean(IntraSessionSuccesRule2))]) 

%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
%                      Time between two tones
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
for i=1:length(RwdToneEvt)-1,
    try
       TimeTwoTone(i)=(RwdToneEvt(i+1,1)-RwdToneEvt(i));
    end
end

figure, plot(TimeTwoTone,'ko-')
hold on, title('time between two successive tones')
save LastResults -append TimeTwoTone

wind=floor(length(RwdToneEvt)/10); % fragmentation by IntraSession 10 tones windows
for i=1:wind
    if i==1
        IntraSessionTimeTwoTone(i)=mean(TimeTwoTone(1,1:10));
    elseif i>1
        IntraSessionTimeTwoTone(i)=mean(TimeTwoTone(1,(i-1)*10+1:i*10));
    end
end
save LastResults -append IntraSessionTimeTwoTone 

%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
%                   Time of last poke before tone
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
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

save LastResults -append LastPoke

%-------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------
% Percentage of generalization (mouse have to restrain poke when GenTone occurs)
%-------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------

disp('---------------------------------------')
generalizationTestFreq=input('was there a multiple frequency generalization test 1(yes) / 0(no)  ? ');
disp('---------------------------------------')

if generalizationTestFreq==1;
    
    load AttentionalEvent
    disp('---------------------------------------')
    disp(['quantity of generalization tones : ',num2str(length(AllNonRwdEvt))])
    disp('---------------------------------------')
        
    generalization30kHz=input('30kHz frequency numbers (e.g. [1:20]) =  ');
    generalization25kHz=input('25kHz frequency numbers (e.g. [20:40]) =  ');
    generalization20kHz=input('20kHz frequency numbers (e.g. [40:60]) =  ');
    generalization5kHz=input(' 05kHz frequency numbers (e.g. [60:80]) =  ');
    generalization10kHz=input('10kHz frequency numbers (e.g. [80:100]) =  ');
    generalization15kHz=input('15kHz frequency numbers (e.g. [100:120]) =  ');   
    
    clear id FirstPokeGen30kHz FirstPokeGen25kHz FirstPokeGen20kHz FirstPokeGen5kHz FirstPokeGen10kHz FirstPokeGen15kHz
    
    for i=generalization30kHz(1):length(generalization30kHz),
        id=(PokeEvent(:,1)-AllNonRwdEvt(i));
        pokeaftertone=id(find(id>0));
        FirstPokeGen30kHz(i)=min(pokeaftertone);
    end
    clear id
    for j=generalization25kHz(1):length(generalization25kHz)+i,
        id=(PokeEvent(:,1)-AllNonRwdEvt(j));
        pokeaftertone=id(find(id>0));
        FirstPokeGen25kHz(j-i)=min(pokeaftertone);
    end
    i=j;
    clear id
    for j=generalization20kHz(1):length(generalization20kHz)+i,
        id=(PokeEvent(:,1)-AllNonRwdEvt(j));
        pokeaftertone=id(find(id>0));
        FirstPokeGen20kHz(j-i)=min(pokeaftertone);
    end
    i=j;
    clear id
    for j=generalization5kHz(1):length(generalization5kHz)+i,
        id=(PokeEvent(:,1)-AllNonRwdEvt(j));
        pokeaftertone=id(find(id>0));
        FirstPokeGen5kHz(j-i)=min(pokeaftertone);
    end
    i=j;
    clear id
    for j=generalization10kHz(1):length(generalization10kHz)+i,
        id=(PokeEvent(:,1)-AllNonRwdEvt(j));
        pokeaftertone=id(find(id>0));
        FirstPokeGen10kHz(j-i)=min(pokeaftertone);
    end
    i=j;
    clear id
    for j=generalization15kHz(1):length(generalization15kHz)+i,
        id=(PokeEvent(:,1)-AllNonRwdEvt(j));
        pokeaftertone=id(find(id>0));
        FirstPokeGen15kHz(j-i)=min(pokeaftertone);
    end
    
    % temps moyen pour le 1er nose poke
    MeanFirstPokeGen30kHz=mean(FirstPokeGen30kHz); 
    MeanFirstPokeGen25kHz=mean(FirstPokeGen25kHz); 
    MeanFirstPokeGen20kHz=mean(FirstPokeGen20kHz); 
    MeanFirstPokeGen5kHz=mean(FirstPokeGen5kHz); 
    MeanFirstPokeGen10kHz=mean(FirstPokeGen10kHz); 
    MeanFirstPokeGen15kHz=mean(FirstPokeGen15kHz); 
    
    % percentage of "success"
    PercRewardGen30kHz=length(find(FirstPokeGen30kHz>0.2 & FirstPokeGen30kHz<RewardWindow))/length(FirstPokeGen30kHz)*100; 
    PercRewardGen25kHz=length(find(FirstPokeGen25kHz>0.2 & FirstPokeGen25kHz<RewardWindow))/length(FirstPokeGen25kHz)*100; 
    PercRewardGen20kHz=length(find(FirstPokeGen20kHz>0.2 & FirstPokeGen20kHz<RewardWindow))/length(FirstPokeGen20kHz)*100; 
    PercRewardGen5kHz=length(find(FirstPokeGen5kHz>0.2 & FirstPokeGen5kHz<RewardWindow))/length(FirstPokeGen5kHz)*100; 
    PercRewardGen10kHz=length(find(FirstPokeGen10kHz>0.2 & FirstPokeGen10kHz<RewardWindow))/length(FirstPokeGen10kHz)*100; 
    PercRewardGen15kHz=length(find(FirstPokeGen15kHz>0.2 & FirstPokeGen15kHz<RewardWindow))/length(FirstPokeGen15kHz)*100; 

    try
    save LastResults -append MeanFirstPokeGen30kHz MeanFirstPokeGen25kHz MeanFirstPokeGen20kHz
    save LastResults -append PercRewardGen30kHz PercRewardGen25kHz PercRewardGen20kHz
    end
    try
    save LastResults -append MeanFirstPokeGen5kHz MeanFirstPokeGen10kHz MeanFirstPokeGen15kHz
    save LastResults -append PercRewardGen5kHz PercRewardGen10kHz PercRewardGen15kHz
    end
    
    allMean=[MeanFirstPokeGen5kHz,MeanFirstPokeGen10kHz,MeanFirstPoke,MeanFirstPokeGen15kHz,MeanFirstPokeGen20kHz,MeanFirstPokeGen25kHz,MeanFirstPokeGen30kHz,];
    figure, bar(allMean)
    hold on, title('Mean time of the First NosePoke after Tone')
    ylabel('time (sec)')
    set(gca,'xticklabel',{'5kHz','10kHz','Rewarding_Fq=12kHz','15kHz','20kHz','25kHz','30kHz'},'xtick',1:7)


    allPerc=[PercRewardGen5kHz,PercRewardGen10kHz,PercReward,PercRewardGen15kHz,PercRewardGen20kHz,PercRewardGen25kHz,PercRewardGen30kHz,];
    figure, bar(allPerc)
    hold on, title('Percentage of "successfull" poke for each frequency')
    ylabel('poke<RewardWindow (%)')
    set(gca,'xticklabel',{'5kHz','10kHz','Rewarding_Fq=12kHz','15kHz','20kHz','25kHz','30kHz'},'xtick',1:7)
    

end


%-------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------
%                          Attentional windows definition
%-------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------
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







%Determine le pourcentage de reussite rule 2 dans lequel la souris ne fait aucun nosepoke entre la fin de la periode de récompense + un temps donné et le prochain son
% disp('----------------------------------------------------------------------------------------------------------')
% approximation=input('for how long do you authorize mice to test nosepoke and understand it is no longer rewarding (standard=3) ?  ');
% disp('----------------------------------------------------------------------------------------------------------')
% 
% clear cd TEST C D
% cd=ab;
% for i=1:(length(RwdToneEvt)-1)
%     TEST=ab{i};
%     try
%         if TEST(length(TEST))<RewardWindow+approximation
%             cd{i}=[];
%         end
%     end
% end        
% 
% for i=1:(length(RwdToneEvt)-1)
%     if isempty(cd{i})==1
%         C(i)=2;
%     end
% end
% C=C';
% D=find(C(1:length(C))==2);
% WildSuccesRule2=length(D)/(length(RwdToneEvt)-1)*100
% 
% 
% figure, plot(FirstPokeTime(1:length(FirstPoke)),FirstPoke(1:length(FirstPoke)),'ko-')
% hold on, plot(0:0.1:FirstPokeTime(length(FirstPokeTime)),RewardWindow,'b'), title(['Success Rule#1 : ',num2str(PercReward), '% --- Success Rule#2 with approximation :',num2str(WildSuccesRule2),'%'])





    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    