function [Res,ResTones,doRip,doNoRip,dpfcRip,dpfcNoRip,dpacRip,dpacNoRip,dmocRip,dmocNoRip,M1,T1,M2,T2,M3,T3,M4,T4,M5,T5]=QuantifTonesDeltaCorticesRipples(ton,delay)




    clear dHPCrip
            clear rip

            try
                load RipplesdHPC25
                dHPCrip;
                rip=ts(dHPCrip(:,2)*1E4);
            catch

            %% FIND RIPPLES
            disp(' ')
            disp('   ________ FIND RIPPLES ________ ')
            clear dHPCrip
            clear rip
            res=pwd;
            load StateEpochSB SWSEpoch
            tempchHPC=load([res,'/ChannelsToAnalyse/dHPC_rip.mat'],'channel'); % changed by Marie 3june2015
            chHPC=tempchHPC.channel;
            eval(['tempLoad=load([res,''/LFPData/LFP',num2str(chHPC),'.mat''],''LFP'');'])
            eegRip=tempLoad.LFP;
            [dHPCrip,EpochRip]=FindRipplesKarimSB(eegRip,SWSEpoch,[2 5]);
            save([res,'/RipplesdHPC25.mat'],'dHPCrip','EpochRip','chHPC');
            clear dHPCrip EpochRip chHPC
            end

            load RipplesdHPC25
            rip=ts(dHPCrip(:,2)*1E4);

            clear MPEaverageRip
            clear TPEaverageRip
            
            try
                load DataPEaverageRip
                MPEaverageRip;
            catch
%                 keyboard
                clear LFPrip
                load ChannelsToAnalyse/dHPC_rip
                eval(['load LFPData/LFP',num2str(channel)])
                LFPrip=LFP;
                clear LFP
                clear Mtemp
                [MPEaverageRip,TPEaverageRip]=PlotRipRaw(LFPrip,Range(rip)/1E4);close
                save DataPEaverageRip MPEaverageRip TPEaverageRip
            end
            
            






clear tDelta
load newDeltaPFCx
Dpfc=ts(tDelta);

clear tDelta
load newDeltaPaCx
Dpac=ts(tDelta);

clear tDelta
load newDeltaMoCx
Dmoc=ts(tDelta);


load StateEpochSB SWSEpoch REMEpoch Wake

try
    
    load DeltaSleepEvent
    disp(' ')
    disp('*************************')
    if ton==1
        Tones=TONEtime1;disp('Tones 1')
    elseif ton==2
        Tones=TONEtime2; disp('Tones 2')
    elseif ton==3
        Tones=DeltaDetect;disp('Delta detection')
    end

    Tones=Tones+delay*1E4;

catch
    
    load ToneEvent
    Tones=SingleTone;
    
end

try 
    load DownSpk
    Start(Down);
    rg=Range(Qt);
    try
        NumNeurons;
    catch
        [Spfc,NumNeurons]=GetSpikesFromStructure('PFCx');
        save DownSpk Down Qt NumNeurons
    end
    
catch
    load SpikeData
    [Spfc,NumNeurons]=GetSpikesFromStructure('PFCx');
    limSizDown=70;
    binSize=10;
    [Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons,SWSEpoch,binSize,0.01,1,1,[0 limSizDown],1);close
    save DownSpk Down Qt NumNeurons
end




load EpochToAnalyse
for i=1:5
    EpochToAnalyseSWS{i}=and(EpochToAnalyse{i},SWSEpoch);
end


for k=1:5
    clear do
    do=Start(and(Down,EpochToAnalyseSWS{k}));
    doRip(k)=0;
    doNoRip(k)=0;
    for i=1:length(do)
        id=find(dHPCrip(:,2)*1E4<do(i));
        try
            if (do(i)-dHPCrip(id(end),2)*1E4)<0.2E4
                doRip(k)=doRip(k)+1;
            else
                doNoRip(k)=doNoRip(k)+1;
            end
        end
    end
end


for k=1:5
    clear do
    do=Range(Restrict(Dpfc,EpochToAnalyseSWS{k}));
    dpfcRip(k)=0;
    dpfcNoRip(k)=0;
    for i=1:length(do)
        id=find(dHPCrip(:,2)*1E4<do(i));
        try
            if (do(i)-dHPCrip(id(end),2)*1E4)<0.2E4
                dpfcRip(k)=dpfcRip(k)+1;
            else
                dpfcNoRip(k)=dpfcNoRip(k)+1;
            end
        end
    end
end


for k=1:5
    clear do
    do=Range(Restrict(Dpac,EpochToAnalyseSWS{k}));
    dpacRip(k)=0;
    dpacNoRip(k)=0;
    for i=1:length(do)
        id=find(dHPCrip(:,2)*1E4<do(i));
        try
            if (do(i)-dHPCrip(id(end),2)*1E4)<0.2E4
                dpacRip(k)=dpacRip(k)+1;
            else
                dpacNoRip(k)=dpacNoRip(k)+1;
            end
        end
    end
end


for k=1:5
    clear do
    do=Range(Restrict(Dmoc,EpochToAnalyseSWS{k}));
    dmocRip(k)=0;
    dmocNoRip(k)=0;
    for i=1:length(do)
        id=find(dHPCrip(:,2)*1E4<do(i));
        try
            if (do(i)-dHPCrip(id(end),2)*1E4)<0.2E4
                dmocRip(k)=dmocRip(k)+1;
            else
                dmocNoRip(k)=dmocNoRip(k)+1;
            end
        end
    end
end



Res(1)=length(Range(Restrict(rip,EpochToAnalyseSWS{1})));
Res(2)=length(Range(Restrict(rip,EpochToAnalyseSWS{2})));
Res(3)=length(Range(Restrict(rip,EpochToAnalyseSWS{3})));
Res(4)=length(Range(Restrict(rip,EpochToAnalyseSWS{4})));
Res(5)=length(Range(Restrict(rip,EpochToAnalyseSWS{5})));

Res(6)=length(Start(and(Down,EpochToAnalyseSWS{1})));
Res(7)=length(Start(and(Down,EpochToAnalyseSWS{2})));
Res(8)=length(Start(and(Down,EpochToAnalyseSWS{3})));
Res(9)=length(Start(and(Down,EpochToAnalyseSWS{4})));
Res(10)=length(Start(and(Down,EpochToAnalyseSWS{5})));

Res(11)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{1})));
Res(12)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{2})));
Res(13)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{3})));
Res(14)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{4})));
Res(15)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{5})));

Res(16)=length(Range(Restrict(Dpac,EpochToAnalyseSWS{1})));
Res(17)=length(Range(Restrict(Dpac,EpochToAnalyseSWS{2})));
Res(18)=length(Range(Restrict(Dpac,EpochToAnalyseSWS{3})));
Res(19)=length(Range(Restrict(Dpac,EpochToAnalyseSWS{4})));
Res(20)=length(Range(Restrict(Dpac,EpochToAnalyseSWS{5})));

Res(21)=length(Range(Restrict(Dmoc,EpochToAnalyseSWS{1})));
Res(22)=length(Range(Restrict(Dmoc,EpochToAnalyseSWS{2})));
Res(23)=length(Range(Restrict(Dmoc,EpochToAnalyseSWS{3})));
Res(24)=length(Range(Restrict(Dmoc,EpochToAnalyseSWS{4})));
Res(25)=length(Range(Restrict(Dmoc,EpochToAnalyseSWS{5})));

Res(26)=sum(End(and(EpochToAnalyse{1},SWSEpoch),'s')-Start(and(EpochToAnalyse{1},SWSEpoch),'s'));
Res(27)=sum(End(and(EpochToAnalyse{2},SWSEpoch),'s')-Start(and(EpochToAnalyse{2},SWSEpoch),'s'));
Res(28)=sum(End(and(EpochToAnalyse{3},SWSEpoch),'s')-Start(and(EpochToAnalyse{3},SWSEpoch),'s'));
Res(29)=sum(End(and(EpochToAnalyse{4},SWSEpoch),'s')-Start(and(EpochToAnalyse{4},SWSEpoch),'s'));
Res(30)=sum(End(and(EpochToAnalyse{5},SWSEpoch),'s')-Start(and(EpochToAnalyse{5},SWSEpoch),'s'));

Res(31)=sum(End(and(EpochToAnalyse{1},REMEpoch),'s')-Start(and(EpochToAnalyse{1},REMEpoch),'s'));
Res(32)=sum(End(and(EpochToAnalyse{2},REMEpoch),'s')-Start(and(EpochToAnalyse{2},REMEpoch),'s'));
Res(33)=sum(End(and(EpochToAnalyse{3},REMEpoch),'s')-Start(and(EpochToAnalyse{3},REMEpoch),'s'));
Res(34)=sum(End(and(EpochToAnalyse{4},REMEpoch),'s')-Start(and(EpochToAnalyse{4},REMEpoch),'s'));
Res(35)=sum(End(and(EpochToAnalyse{5},REMEpoch),'s')-Start(and(EpochToAnalyse{5},REMEpoch),'s'));

Res(36)=sum(End(and(EpochToAnalyse{1},Wake),'s')-Start(and(EpochToAnalyse{1},Wake),'s'));
Res(37)=sum(End(and(EpochToAnalyse{2},Wake),'s')-Start(and(EpochToAnalyse{2},Wake),'s'));
Res(38)=sum(End(and(EpochToAnalyse{3},Wake),'s')-Start(and(EpochToAnalyse{3},Wake),'s'));
Res(39)=sum(End(and(EpochToAnalyse{4},Wake),'s')-Start(and(EpochToAnalyse{4},Wake),'s'));
Res(40)=sum(End(and(EpochToAnalyse{5},Wake),'s')-Start(and(EpochToAnalyse{5},Wake),'s'));

try
TonesEpoch=intervalSet(Tones,Tones+0.3*1E4);

Res(41)=length(Range(Restrict(rip,and(TonesEpoch,EpochToAnalyseSWS{1}))));
Res(42)=length(Range(Restrict(rip,and(TonesEpoch,EpochToAnalyseSWS{2}))));
Res(43)=length(Range(Restrict(rip,and(TonesEpoch,EpochToAnalyseSWS{3}))));
Res(44)=length(Range(Restrict(rip,and(TonesEpoch,EpochToAnalyseSWS{4}))));
Res(45)=length(Range(Restrict(rip,and(TonesEpoch,EpochToAnalyseSWS{5}))));

Res(46)=length(Range(Restrict(rip,EpochToAnalyseSWS{1}-TonesEpoch)));
Res(47)=length(Range(Restrict(rip,EpochToAnalyseSWS{2}-TonesEpoch)));
Res(48)=length(Range(Restrict(rip,EpochToAnalyseSWS{3}-TonesEpoch)));
Res(49)=length(Range(Restrict(rip,EpochToAnalyseSWS{4}-TonesEpoch)));
Res(50)=length(Range(Restrict(rip,EpochToAnalyseSWS{5}-TonesEpoch)));


Res(51)=length(Start(and(Down,and(TonesEpoch,EpochToAnalyseSWS{1}))));
Res(52)=length(Start(and(Down,and(TonesEpoch,EpochToAnalyseSWS{2}))));
Res(53)=length(Start(and(Down,and(TonesEpoch,EpochToAnalyseSWS{3}))));
Res(54)=length(Start(and(Down,and(TonesEpoch,EpochToAnalyseSWS{4}))));
Res(55)=length(Start(and(Down,and(TonesEpoch,EpochToAnalyseSWS{5}))));

Res(56)=length(Start(and(Down,EpochToAnalyseSWS{1}-TonesEpoch)));
Res(57)=length(Start(and(Down,EpochToAnalyseSWS{2}-TonesEpoch)));
Res(58)=length(Start(and(Down,EpochToAnalyseSWS{3}-TonesEpoch)));
Res(59)=length(Start(and(Down,EpochToAnalyseSWS{4}-TonesEpoch)));
Res(60)=length(Start(and(Down,EpochToAnalyseSWS{5}-TonesEpoch)));

Res(61)=length(Range(Restrict(Dpfc,and(TonesEpoch,EpochToAnalyseSWS{1}))));
Res(62)=length(Range(Restrict(Dpfc,and(TonesEpoch,EpochToAnalyseSWS{2}))));
Res(63)=length(Range(Restrict(Dpfc,and(TonesEpoch,EpochToAnalyseSWS{3}))));
Res(64)=length(Range(Restrict(Dpfc,and(TonesEpoch,EpochToAnalyseSWS{4}))));
Res(65)=length(Range(Restrict(Dpfc,and(TonesEpoch,EpochToAnalyseSWS{5}))));

Res(66)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{1}-TonesEpoch)));
Res(67)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{2}-TonesEpoch)));
Res(68)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{3}-TonesEpoch)));
Res(69)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{4}-TonesEpoch)));
Res(70)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{5}-TonesEpoch)));

Res(71)=length(Range(Restrict(Dpac,and(TonesEpoch,EpochToAnalyseSWS{1}))));
Res(72)=length(Range(Restrict(Dpac,and(TonesEpoch,EpochToAnalyseSWS{2}))));
Res(73)=length(Range(Restrict(Dpac,and(TonesEpoch,EpochToAnalyseSWS{3}))));
Res(74)=length(Range(Restrict(Dpac,and(TonesEpoch,EpochToAnalyseSWS{4}))));
Res(75)=length(Range(Restrict(Dpac,and(TonesEpoch,EpochToAnalyseSWS{5}))));

Res(76)=length(Range(Restrict(Dpac,EpochToAnalyseSWS{1}-TonesEpoch)));
Res(77)=length(Range(Restrict(Dpac,EpochToAnalyseSWS{2}-TonesEpoch)));
Res(78)=length(Range(Restrict(Dpac,EpochToAnalyseSWS{3}-TonesEpoch)));
Res(79)=length(Range(Restrict(Dpac,EpochToAnalyseSWS{4}-TonesEpoch)));
Res(80)=length(Range(Restrict(Dpac,EpochToAnalyseSWS{5}-TonesEpoch)));

Res(81)=length(Range(Restrict(Dmoc,and(TonesEpoch,EpochToAnalyseSWS{1}))));
Res(82)=length(Range(Restrict(Dmoc,and(TonesEpoch,EpochToAnalyseSWS{2}))));
Res(83)=length(Range(Restrict(Dmoc,and(TonesEpoch,EpochToAnalyseSWS{3}))));
Res(84)=length(Range(Restrict(Dmoc,and(TonesEpoch,EpochToAnalyseSWS{4}))));
Res(85)=length(Range(Restrict(Dmoc,and(TonesEpoch,EpochToAnalyseSWS{5}))));

Res(86)=length(Range(Restrict(Dmoc,EpochToAnalyseSWS{1}-TonesEpoch)));
Res(87)=length(Range(Restrict(Dmoc,EpochToAnalyseSWS{2}-TonesEpoch)));
Res(88)=length(Range(Restrict(Dmoc,EpochToAnalyseSWS{3}-TonesEpoch)));
Res(89)=length(Range(Restrict(Dmoc,EpochToAnalyseSWS{4}-TonesEpoch)));
Res(90)=length(Range(Restrict(Dmoc,EpochToAnalyseSWS{5}-TonesEpoch)));
end


Res(91)=length(NumNeurons);
Res(92)=mean(Data(Restrict(Qt,SWSEpoch)));

try
    try
[M1,T1]=PlotRipRaw(Qt,Range(Restrict(ts(Tones),EpochToAnalyseSWS{1}))/1E4,1800);close,   eval(['save PTEHQtTones',num2str(ton),'EpochToAnalyse1 M1 T1'])
    catch
        M1=[];
        T1=[];
    end
[M2,T2]=PlotRipRaw(Qt,Range(Restrict(ts(Tones),EpochToAnalyseSWS{2}))/1E4,1800);close,   eval(['save PTEHQtTones',num2str(ton),'EpochToAnalyse1 M2 T2']) 
try
[M3,T3]=PlotRipRaw(Qt,Range(Restrict(ts(Tones),EpochToAnalyseSWS{3}))/1E4,1800);close,   eval(['save PTEHQtTones',num2str(ton),'EpochToAnalyse1 M3 T3'])  
catch
    M3=[];
    T3=[];
end
[M4,T4]=PlotRipRaw(Qt,Range(Restrict(ts(Tones),EpochToAnalyseSWS{4}))/1E4,1800);close,   eval(['save PTEHQtTones',num2str(ton),'EpochToAnalyse1 M4 T4'])
try
[M5,T5]=PlotRipRaw(Qt,Range(Restrict(ts(Tones),EpochToAnalyseSWS{5}))/1E4,1800);close,   eval(['save PTEHQtTones',num2str(ton),'EpochToAnalyse1 M5 T5']) 
catch
    M5=[];
    T5=[];
end
clear del
clear del2
clear del3
clear del4
clear del5
clear del6
clear del7

for j=1:5
    clear To
    To=Range(Restrict(ts(Tones),EpochToAnalyseSWS{j}));
    if length(To)==0
       To=nan;
    end
    
    for i=1:length(To)
        clear temp
        clear temp2
        clear temp3
        clear temp4
        clear temp5
        clear temp6
        clear temp7
        
        temp=Start(Down)-To(i); try del{j}(i)=min(temp(temp>0)); catch del{j}(i)=5E4; end
        temp2=To(i)-End(Down); try del2{j}(i)=min(temp2(temp2>0)); catch del2{j}(i)=5E4; end
        temp3=To(i)-Start(Down); try del3{j}(i)=min(temp3(temp3>0)); catch del3{j}(i)=5E4; end

        temp4=Range(Dpfc)-To(i); try del4{j}(i)=min(temp4(temp4>0)); catch del4{j}(i)=5E4; end   % Dpfc
        temp5=Range(Dpac)-To(i); try del5{j}(i)=min(temp5(temp5>0)); catch del5{j}(i)=5E4; end   % Dpac
        temp6=Range(Dmoc)-To(i); try del6{j}(i)=min(temp6(temp6>0)); catch del6{j}(i)=5E4; end   % Dmoc
        temp7=Range(rip)-To(i); try del7{j}(i)=min(temp7(temp7>0)); catch del7{j}(i)=5E4; end    % Drip
    end
end

a=0;
for j=1:5
a=a+1;ResTones(a)=length(find(del{j}/1E4<0.1)); 
a=a+1;ResTones(a)=length(del{j});
a=a+1;ResTones(a)=floor(10*length(find(del{j}/1E4<0.1))/length(del{j})*100)/10;
end
for j=1:5
a=a+1;ResTones(a)=length(find(del4{j}/1E4<0.2)); 
a=a+1;ResTones(a)=length(del4{j});
a=a+1;ResTones(a)=floor(10*length(find(del4{j}/1E4<0.2))/length(del4{j})*100)/10;
end
for j=1:5
a=a+1;ResTones(a)=length(find(del5{j}/1E4<0.2)); 
a=a+1;ResTones(a)=length(del5{j});
a=a+1;ResTones(a)=floor(10*length(find(del5{j}/1E4<0.2))/length(del5{j})*100)/10;
end
for j=1:5
a=a+1;ResTones(a)=length(find(del6{j}/1E4<0.2)); 
a=a+1;ResTones(a)=length(del6{j});
a=a+1;ResTones(a)=floor(10*length(find(del6{j}/1E4<0.2))/length(del6{j})*100)/10;
end
for j=1:5
a=a+1;ResTones(a)=length(find(del7{j}/1E4<0.2)); 
a=a+1;ResTones(a)=length(del7{j});
a=a+1;ResTones(a)=floor(10*length(find(del7{j}/1E4<0.2))/length(del7{j})*100)/10;
end

catch
%     keyboard
M1=[];
T1=[];
M2=[];
T2=[];
M3=[];
T3=[];
M4=[];
T4=[];
M5=[];
T5=[];
ResTones=nan*ones(1,40);
end


% b=1;
% for j=0.01:0.01:3
%     val1(b)=length(find(del/1E4<j));
%     val2(b)=floor(10*length(find(del/1E4<j))/length(del)*100)/10;
% b=b+1;
% end
% 
% 

