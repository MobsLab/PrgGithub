% ToneDeltaKB

% ch=1; Down perfect
 ch=0 Down loose

try
    S;
    NumNeurons;
    SWSEpoch;
    LFPs;
    LFPd;
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
    save SpikeData -Append tetrodeChannels
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


load ToneEvent
load StateEpochSB SWSEpoch REMEpoch Wake

limSizDown=70;

if ch
    [Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,1:30,SWSEpoch,10,0.01,1,0,[0 limSizDown],1);
else
    [Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,1:30,SWSEpoch,10,0.01,1,2,[10 limSizDown],1);
end

Tones=SingleTone;
%Tones=SeqTone(1:10:end);

[M,T]=PlotRipRaw(Qt,Tones/1E4,1800);close

[C,B]=CrossCorr(Tones,Start(Down),10,100);
clear del
clear del2
for i=1:length(Tones)
temp=Start(Down)-Tones(i); del(i)=min(temp(temp>0));
temp2=Tones(i)-End(Down); del2(i)=min(temp2(temp2>0));
end
[BE,id2]=sort(del2);
[BE,id]=sort(del);

[length(find(del/1E4<0.1)) length(del) length(find(del/1E4<0.1))/length(del)*100]

% for i=id2
% temp=SingleTone(i)-End(Down); del3(i)=min(temp(temp>0));
% end
% for i=id
% temp2=Start(Down)-SingleTone(i); del4(i)=min(temp2(temp2>0));
% end

figure('color',[1 1 1]), 
subplot(1,3,1),plot(B/1E3,C,'k'), yl=ylim; line([0 0],yl,'color','r')
subplot(1,3,2),imagesc(M(:,1),1:length(id2),T(id2,:)), yl=ylim; line([0 0],yl,'color','w')
hold on, plot(del(id2)/1E4,1:length(id),'w.','markersize',5)
subplot(1,3,3),imagesc(M(:,1),1:length(id),T(id,:)), yl=ylim; line([0 0],yl,'color','w')
hold on, plot(-del2(id)/1E4,1:length(id),'w.','markersize',5)

[A,B,C]=mjPETH(Start(Down),SingleTone,End(Down),10,100,1,2);



