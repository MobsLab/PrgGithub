function [Tones, idxOK,idBad,del,del2,del3,C,B,Aj,Bj,Cj,M,T]=ToneDeltaKB(ch,to,delay,NumEpochToAnalyse)


% [Tones, idxOK,idBad,del,del2,del3]=ToneDeltaKB(ch,to,delay)
% ch=1; %Down perfect
% ch=0; %Down loose
% 
% Tones=TONEtime1;
% elseif to==2
% Tones=TONEtime2;
% elseif to==3
% Tones=DeltaDetect;
        
try
    ch;
catch
     ch=1; %Down perfect
    % ch=0; %Down loose
end

try
    to;
catch
    to=2;
end

try
    delay;
%    delay=delay+0.02;
catch
    delay=0;
end

try
    NumEpochToAnalyse;
catch
    NumEpochToAnalyse=0;
end

% BASAL SLEEP
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% a=0;
% a=a+1; Path_M243_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse243';
% a=a+1; Path_M243_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse243';
% a=a+1; Path_M243_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243';
% a=a+1; Path_M243_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';
% 
% a=0;
% a=a+1; Path_M244_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse244';
% a=a+1; Path_M244_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse244';
% a=a+1; Path_M244_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244';
% a=a+1; Path_M244_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244';
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


% Random time OK
% /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150223/Breath-Mouse-243-244-23022015/Mouse243
%
%
% 
% a=0;
% a=a+1;
% Path_Mouse243_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse243';         % 16-04-2015 > random tone effect (sound after 200ms !!!!!!) 
% a=a+1; Path_Mouse243_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150421/Breath-Mouse-243-21042015';               % 21-04-2015 > delay 140ms
% a=a+1; Path_Mouse243_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse243';  % 17-04-2015 > delay 200ms
% a=a+1; Path_Mouse243_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150423/Breath-Mouse-243-23042015';               % 23-04-2015 > delay 320ms
% a=a+1; Path_Mouse243_Delta{a}='/media/DataMOBs28/Mice-243-244/20150425/Breath-Mouse-243-25042015';                                          % 25-04-2015 > delay 480ms
% a=a+1; Path_Mouse243_Delta{a}='/media/DataMOBs28/Mice-243-244/20150429/Breath-Mouse-243-29042015';                                          % 25-04-2015 > delay 3*140ms
% 
% a=0;
% a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse244';  % 17-04-2015 > random tone effect (sound after 200ms !!!!!!) 
% a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150422/Breath-Mouse-244-22042015';               % 22-04-2015 > delay 140ms
% a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse244';  % 16-04-2015 > delay 200ms
% a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBs28/Mice-243-244/20150424/Breath-Mouse-244-24042015';                                          % 24-04-2015 > delay 320ms
% a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBs28/Mice-243-244/20150426/Breath-Mouse-244-26042015';                                          % 26-04-2015 > delay 480ms
% a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBs28/Mice-243-244/20150430/Breath-Mouse-244-30042015';                                          % 25-04-2015 > delay 3*140ms





try
    load ToneEvent
    Tones=SingleTone;
    %Tones=SeqTone(1:10:end);
    disp(' ')
    disp('*************************')
    disp('old toneEvent !!!!!!! ')
catch
    load DeltaSleepEvent
    disp(' ')
    disp('*************************')
    if to==1
        Tones=TONEtime1;disp('Tones 1')
    elseif to==2
        Tones=TONEtime2; disp('Tones 2')
    elseif to==3
        Tones=DeltaDetect;disp('Delta detection')
    end
    
end

Tones=Tones+delay*1E4;

disp(' ')
try
    S;
    NumNeurons;
    SWSEpoch;
catch
    tic
    load StateEpochSB SWSEpoch REMEpoch
    load SpikeData
    try
        tetrodeChannels;
    catch
        SetCurrentSession
        global DATA
        tetrodeChannels=DATA.spikeGroups.groups;
        rep=input('Do you want to save tetrodechannels ? (y/n)','s');
        if rep=='y'
        save SpikeData -Append tetrodeChannels
        end
        
    end
    
    load LFPData/InfoLFP InfoLFP
    ok=0;
    for i=1:32
        try
        if InfoLFP.structure{i}=='CxPF';
            ok=1;
           InfoLFP.structure{i}='PFCx';
        end
        end
    end
    if ok==1
        disp('****** Modification of InfoLFP ******')
        res=pwd;
        cd LFPData
        save InfoLFP InfoLFP
        cd(res)
    end
    clear InfoLFP
    
    [Spfc,NumNeurons]=GetSpikesFromStructure('PFCx');
    
 
    
    toc
end



load StateEpochSB SWSEpoch REMEpoch Wake

limSizDown=70;
binSize=10;

if ch
    [Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons,SWSEpoch,binSize,0.01,1,0,[0 limSizDown],1);
else
    [Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons,SWSEpoch,binSize,0.01,1,0,[20 limSizDown],1);
end
title(pwd)

  load EpochToAnalyse
    for i=1:5
        EpochToAnalyse{i}=and(EpochToAnalyse{i},SWSEpoch);
    end
    
    if NumEpochToAnalyse>0
    Tones=Range(Restrict(ts(Tones),and(SWSEpoch,EpochToAnalyse{NumEpochToAnalyse})));   
    else
     Tones=Range(Restrict(ts(Tones),SWSEpoch));
    end
    
[M,T]=PlotRipRaw(Qt,Tones/1E4,1800);close

[C,B]=CrossCorr(Tones,Start(Down),10,100);

clear del
clear del2
clear del3
for i=1:length(Tones)
    temp=Start(Down)-Tones(i); del(i)=min(temp(temp>0));
    temp2=Tones(i)-End(Down); try del2(i)=min(temp2(temp2>0)); catch del2(i)=5E4; end
    temp3=Tones(i)-Start(Down); try del3(i)=min(temp3(temp3>0)); catch del3(i)=5E4; end
end
[BE,id]=sort(del);
[BE,id3]=sort(del3);
[BE,id2]=sort(del2);

disp(' ')
disp('**************************************************')
disp('Probability of Down states evoked by sound')
disp(num2str([length(find(del/1E4<0.1)) length(del) floor(10*length(find(del/1E4<0.1))/length(del)*100)/10]))
disp('**************************************************')

idxOK=find(del/1E4<0.1);
idBad=find(ismember([1:max(idxOK)],idxOK)-1);

% for i=id2
% temp=SingleTone(i)-End(Down); del3(i)=min(temp(temp>0));
% end
% for i=id
% temp2=Start(Down)-SingleTone(i); del4(i)=min(temp2(temp2>0));
% end

figure('color',[1 1 1]), 
subplot(4,3,1:3),plot(B/1E3,C,'k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), xlim([-0.5 0.5])
subplot(4,3,[4,7,10]),imagesc(M(:,1),1:length(id2),T(id2,:)), yl=ylim; line([0 0],yl,'color','w')
hold on, plot(del(id2)/1E4,1:length(id),'yo','markersize',3,'markerfacecolor','y')

subplot(4,3,[5,8,11]),imagesc(M(:,1),1:length(id3),T(id3,:)), yl=ylim; line([0 0],yl,'color','w')
hold on, plot(del(id3)/1E4,1:length(id),'yo','markersize',3,'markerfacecolor','y')

subplot(4,3,[6,9,12]),imagesc(M(:,1),1:length(id),T(id,:)), yl=ylim; line([0 0],yl,'color','w')
hold on, plot(-del2(id)/1E4,1:length(id),'yo','markersize',3,'markerfacecolor','y')

[Aj,Bj,Cj]=mjPETH(Start(Down),Tones,End(Down),10,100,1,2);
subplot(3,3,[4 5 7 8]),title('Start Down, Tones, End Down')


