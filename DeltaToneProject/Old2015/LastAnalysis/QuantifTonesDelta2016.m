function [Res,ResTones]=QuantifTonesDelta2016(ton,delay)


%% 1-  FIND RIPPLES
% clear dHPCrip
% clear rip

try
    load RipplesdHPC25
    dHPCrip;
    rip=ts(dHPCrip(:,2)*1E4);
catch
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
    % keyboard
    clear LFPrip
    load ChannelsToAnalyse/dHPC_rip
    eval(['load LFPData/LFP',num2str(channel)])
    LFPrip=LFP;
    clear LFP
    clear Mtemp
    [MPEaverageRip,TPEaverageRip]=PlotRipRaw(LFPrip,Range(rip)/1E4);close
    save DataPEaverageRip MPEaverageRip TPEaverageRip
end

%% 2 -  FIND DELTA
clear tDelta
load newDeltaPFCx
Dpfc=ts(tDelta);

load StateEpochSB SWSEpoch REMEpoch Wake


try
    load DeltaSleepEvent
    disp(' ')
    disp('*************************')
    if ton==1
        try
            Tones=TONEtime1;disp('Tones 1')
        catch
            Tones=TONEtime2; disp('Tones 2 !!!!')
        end
    elseif ton==2
        try
            Tones=TONEtime2; disp('Tones 2')
        catch
            Tones=TONEtime1; disp('Tones 1 !!!')
        end
    elseif ton==3
        Tones=DeltaDetect;disp('Delta detection')
    end
    Tones=Tones+delay*1E4;
    noTone=0;
catch
    try
    load ToneEvent
    Tones=SingleTone;
    catch 
        disp('no automatic delta detection for this day ...')
        noTone=1;
    end

end



%% 2 -  DEFINE Ripples and Delta EPOCHs
load EpochToAnalyse
for i=1:5
    EpochToAnalyseSWS{i}=and(EpochToAnalyse{i},SWSEpoch);
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


Res(1)=length(Range(Restrict(rip,EpochToAnalyseSWS{1})));
Res(2)=length(Range(Restrict(rip,EpochToAnalyseSWS{2})));
Res(3)=length(Range(Restrict(rip,EpochToAnalyseSWS{3})));
Res(4)=length(Range(Restrict(rip,EpochToAnalyseSWS{4})));
Res(5)=length(Range(Restrict(rip,EpochToAnalyseSWS{5})));

Res(6)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{1})));
Res(7)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{2})));
Res(8)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{3})));
Res(9)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{4})));
Res(10)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{5})));

Res(11)=sum(End(and(EpochToAnalyse{1},SWSEpoch),'s')-Start(and(EpochToAnalyse{1},SWSEpoch),'s'));
Res(12)=sum(End(and(EpochToAnalyse{2},SWSEpoch),'s')-Start(and(EpochToAnalyse{2},SWSEpoch),'s'));
Res(13)=sum(End(and(EpochToAnalyse{3},SWSEpoch),'s')-Start(and(EpochToAnalyse{3},SWSEpoch),'s'));
Res(14)=sum(End(and(EpochToAnalyse{4},SWSEpoch),'s')-Start(and(EpochToAnalyse{4},SWSEpoch),'s'));
Res(15)=sum(End(and(EpochToAnalyse{5},SWSEpoch),'s')-Start(and(EpochToAnalyse{5},SWSEpoch),'s'));

Res(16)=sum(End(and(EpochToAnalyse{1},REMEpoch),'s')-Start(and(EpochToAnalyse{1},REMEpoch),'s'));
Res(17)=sum(End(and(EpochToAnalyse{2},REMEpoch),'s')-Start(and(EpochToAnalyse{2},REMEpoch),'s'));
Res(18)=sum(End(and(EpochToAnalyse{3},REMEpoch),'s')-Start(and(EpochToAnalyse{3},REMEpoch),'s'));
Res(19)=sum(End(and(EpochToAnalyse{4},REMEpoch),'s')-Start(and(EpochToAnalyse{4},REMEpoch),'s'));
Res(20)=sum(End(and(EpochToAnalyse{5},REMEpoch),'s')-Start(and(EpochToAnalyse{5},REMEpoch),'s'));

Res(21)=sum(End(and(EpochToAnalyse{1},Wake),'s')-Start(and(EpochToAnalyse{1},Wake),'s'));
Res(22)=sum(End(and(EpochToAnalyse{2},Wake),'s')-Start(and(EpochToAnalyse{2},Wake),'s'));
Res(23)=sum(End(and(EpochToAnalyse{3},Wake),'s')-Start(and(EpochToAnalyse{3},Wake),'s'));
Res(24)=sum(End(and(EpochToAnalyse{4},Wake),'s')-Start(and(EpochToAnalyse{4},Wake),'s'));
Res(25)=sum(End(and(EpochToAnalyse{5},Wake),'s')-Start(and(EpochToAnalyse{5},Wake),'s'));

if noTone==0;
TonesEpoch=intervalSet(Tones,Tones+0.3*1E4);

Res(26)=length(Range(Restrict(rip,and(TonesEpoch,EpochToAnalyseSWS{1}))));
Res(27)=length(Range(Restrict(rip,and(TonesEpoch,EpochToAnalyseSWS{2}))));
Res(28)=length(Range(Restrict(rip,and(TonesEpoch,EpochToAnalyseSWS{3}))));
Res(29)=length(Range(Restrict(rip,and(TonesEpoch,EpochToAnalyseSWS{4}))));
Res(30)=length(Range(Restrict(rip,and(TonesEpoch,EpochToAnalyseSWS{5}))));

Res(31)=length(Range(Restrict(rip,EpochToAnalyseSWS{1}-TonesEpoch)));
Res(32)=length(Range(Restrict(rip,EpochToAnalyseSWS{2}-TonesEpoch)));
Res(33)=length(Range(Restrict(rip,EpochToAnalyseSWS{3}-TonesEpoch)));
Res(34)=length(Range(Restrict(rip,EpochToAnalyseSWS{4}-TonesEpoch)));
Res(35)=length(Range(Restrict(rip,EpochToAnalyseSWS{5}-TonesEpoch)));

Res(36)=length(Range(Restrict(Dpfc,and(TonesEpoch,EpochToAnalyseSWS{1}))));
Res(37)=length(Range(Restrict(Dpfc,and(TonesEpoch,EpochToAnalyseSWS{2}))));
Res(38)=length(Range(Restrict(Dpfc,and(TonesEpoch,EpochToAnalyseSWS{3}))));
Res(39)=length(Range(Restrict(Dpfc,and(TonesEpoch,EpochToAnalyseSWS{4}))));
Res(40)=length(Range(Restrict(Dpfc,and(TonesEpoch,EpochToAnalyseSWS{5}))));

Res(41)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{1}-TonesEpoch)));
Res(42)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{2}-TonesEpoch)));
Res(43)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{3}-TonesEpoch)));
Res(44)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{4}-TonesEpoch)));
Res(45)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{5}-TonesEpoch)));

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
        clear temp4
        clear temp7
        
        temp4=Range(Dpfc)-To(i); try del4{j}(i)=min(temp4(temp4>0)); catch del4{j}(i)=5E4; end   % Dpfc
        temp7=Range(rip)-To(i); try del7{j}(i)=min(temp7(temp7>0)); catch del7{j}(i)=5E4; end    % Drip
    end
end

a=0;
for j=1:5
    a=a+1;ResTones(a)=length(find(del4{j}/1E4<0.2));
    a=a+1;ResTones(a)=length(del4{j});
    a=a+1;ResTones(a)=floor(10*length(find(del4{j}/1E4<0.2))/length(del4{j})*100)/10;
end
for j=1:5
    a=a+1;ResTones(a)=length(find(del7{j}/1E4<0.2));
    a=a+1;ResTones(a)=length(del7{j});
    a=a+1;ResTones(a)=floor(10*length(find(del7{j}/1E4<0.2))/length(del7{j})*100)/10;
end

end



ResTones=nan*ones(1,40);


