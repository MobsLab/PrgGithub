%ObservationDown

%cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243


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
    %save SpikeData -Append tetrodeChannels
        rep=input('Do you want to save tetrodechannels ? (y/n) ','s');
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
    
    load ChannelsToAnalyse/PFCx_deep
    eval(['load LFPData/LFP',num2str(channel)])
    LFPd=LFP;
    clear LFP
    
    load ChannelsToAnalyse/PFCx_sup
    eval(['load LFPData/LFP',num2str(channel)])
    LFPs=LFP;
    
    clear LFP
    
    toc
end

limSizDown=70;

[Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons,SWSEpoch,10,0.01,1,0,[0 limSizDown],1);

DownREM=and(Down,REMEpoch);
DownWake=(Down-SWSEpoch-REMEpoch);
Down=and(Down,SWSEpoch);

Down=dropShortIntervals(Down,limSizDown*10);
DownREM=dropShortIntervals(DownREM,limSizDown*10);
DownWake=dropShortIntervals(DownWake,limSizDown*10);

disp('********************************************')
disp(['Down during SWS: ',num2str(length(Start((Down))))])
disp(['Down during REM: ',num2str(length(Start(DownREM)))])
disp(['Down during Wake: ',num2str(length(Start((DownWake))))])
disp('********************************************')

% Down=DownREM;
% Down=DownWake;

Down=subset(Down,2:length(Start(Down)-1));


st=End(Down,'s');
[MQ,TQ]=PlotRipRaw(Qt,st,800,1);close
[MLd,TLd]=PlotRipRaw(LFPd,st,800,1);close
[MLs,TLs]=PlotRipRaw(LFPs,st,800,1);close

dur=End(Down,'s')-Start(Down,'s');
[BD,idd]=sort(dur,'Descend');

figure('color',[1 1 1]), 
subplot(2,3,1), imagesc(MQ(:,1),1:length(idd),TQ(idd,:)), yl=ylim; line([0 0],yl,'color','w')
subplot(2,3,4), hold on
try
plot(MQ(:,1),mean(TQ(idd(1:2000),:)),'k'), 
plot(MQ(:,1),mean(TQ(idd(end-2000:end),:)),'r'), 
end
yl=ylim; line([0 0],yl), xlim([-0.8 0.8])
subplot(2,3,2), imagesc(MLs(:,1),1:length(idd),TLs(idd,:)),  yl=ylim; line([0 0],yl,'color','k'), caxis([-2000 2000])
subplot(2,3,5), imagesc(MLd(:,1),1:length(idd),TLd(idd,:)), yl=ylim; line([0 0],yl,'color','k'), caxis([-2000 2000])
try
subplot(2,3,3), hold on, plot(MLs(:,1),mean(TLs(idd(1:2000),:)),'k'), plot(MLs(:,1),mean(TLs(idd(end-2000:end),:)),'r'), yl=ylim; line([0 0],yl), xlim([-0.8 0.8])
subplot(2,3,6), hold on, plot(MLd(:,1),mean(TLd(idd(1:2000),:)),'k'), plot(MLd(:,1),mean(TLd(idd(end-2000:end),:)),'r'), yl=ylim; line([0 0],yl), xlim([-0.8 0.8])
end

% 
% try
%     
% figure('color',[1 1 1]),
% subplot(4,2,7), plot(MLs(:,1),mean(TLs(idd(1:200),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd(1:200),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000])
% subplot(4,2,5), plot(MLs(:,1),mean(TLs(idd(2200:2400),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd(2200:2400),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000])
% subplot(4,2,3), plot(MLs(:,1),mean(TLs(idd(5400:5600),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd(5400:5600),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000])
% subplot(4,2,1), plot(MLs(:,1),mean(TLs(idd(10600:10800),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd(10600:10800),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000])
% 
% subplot(4,2,8), hist(dur(idd(1:200)),100), title(num2str(1000*mean(dur(idd(1:200)))))
% subplot(4,2,6), hist(dur(idd(2200:2400)),100), title(num2str(1000*mean(dur(idd(2200:2400)))))
% subplot(4,2,4), hist(dur(idd(5400:5600)),100), title(num2str(1000*mean(dur(idd(5400:5600)))))
% subplot(4,2,2), hist(dur(idd(10600:10800)),100),title(num2str(1000*mean(dur(idd(10600:10800)))))
% 
% 
% idd2=idd(end:-1:1);
% figure('color',[1 1 1]),
% subplot(4,2,1), plot(MLs(:,1),mean(TLs(idd2(1:200),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd2(1:200),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000])
% subplot(4,2,3), plot(MLs(:,1),mean(TLs(idd2(2200:2400),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd2(2200:2400),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000])
% subplot(4,2,5), plot(MLs(:,1),mean(TLs(idd2(5400:5600),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd2(5400:5600),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000])
% subplot(4,2,7), plot(MLs(:,1),mean(TLs(idd2(10600:10800),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd2(10600:10800),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000])
% 
% subplot(4,2,2), hist(dur(idd2(1:200)),100), title(num2str(1000*mean(dur(idd2(1:200)))))
% subplot(4,2,4), hist(dur(idd2(2200:2400)),100),title(num2str(1000*mean(dur(idd2(2200:2400)))))
% subplot(4,2,6), hist(dur(idd2(5400:5600)),100), title(num2str(1000*mean(dur(idd2(5400:5600)))))
% subplot(4,2,8), hist(dur(idd2(10600:10800)),100),title(num2str(1000*mean(dur(idd2(10600:10800)))))
% 
% 
% 
% catch
%     close
    le=length(idd);
    
figure('color',[1 1 1]),
subplot(4,2,7), plot(MLs(:,1),mean(TLs(idd(1:floor(le/4)),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd(1:floor(le/4)),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000]), xlim([-0.8 0.8])
subplot(4,2,5), plot(MLs(:,1),mean(TLs(idd(floor(le/4):2*floor(le/4)),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd(floor(le/4):2*floor(le/4)),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000]), xlim([-0.8 0.8])
subplot(4,2,3), plot(MLs(:,1),mean(TLs(idd(2*floor(le/4):3*floor(le/4)),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd(2*floor(le/4):3*floor(le/4)),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000]), xlim([-0.8 0.8])
subplot(4,2,1), plot(MLs(:,1),mean(TLs(idd(3*floor(le/4):le),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd(3*floor(le/4):le),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000]), xlim([-0.8 0.8])

subplot(4,2,8), hist(dur(idd(1:floor(le/4))),100), title(num2str(1000*mean(dur(idd(1:floor(le/4))))))
subplot(4,2,6), hist(dur(idd(floor(le/4):2*floor(le/4))),100), title(num2str(1000*mean(dur(idd(floor(le/4):2*floor(le/4))))))
subplot(4,2,4), hist(dur(idd(2*floor(le/4):3*floor(le/4))),100), title(num2str(1000*mean(dur(idd(2*floor(le/4):3*floor(le/4))))))
subplot(4,2,2), hist(dur(idd(3*floor(le/4):le)),100),title(num2str(1000*mean(dur(idd(3*floor(le/4):le)))))


% end





st=Start(Down,'s');
[MQ,TQ]=PlotRipRaw(Qt,st,800,1);close
[MLd,TLd]=PlotRipRaw(LFPd,st,800,1);close
[MLs,TLs]=PlotRipRaw(LFPs,st,800,1);close

dur=End(Down,'s')-Start(Down,'s');
[BD,idd]=sort(dur,'Descend');

figure('color',[1 1 1]), 
subplot(2,3,1), imagesc(MQ(:,1),1:length(idd),TQ(idd,:)), yl=ylim; line([0 0],yl,'color','w')
try
    subplot(2,3,4), hold on
plot(MQ(:,1),mean(TQ(idd(1:2000),:)),'k'), 
plot(MQ(:,1),mean(TQ(idd(end-2000:end),:)),'r'), 
yl=ylim; line([0 0],yl), xlim([-0.8 0.8])
end
subplot(2,3,2), imagesc(MLs(:,1),1:length(idd),TLs(idd,:)),  yl=ylim; line([0 0],yl,'color','k'), caxis([-2000 2000])
subplot(2,3,5), imagesc(MLd(:,1),1:length(idd),TLd(idd,:)), yl=ylim; line([0 0],yl,'color','k'), caxis([-2000 2000])
try
    subplot(2,3,3), hold on, plot(MLs(:,1),mean(TLs(idd(1:2000),:)),'k'), plot(MLs(:,1),mean(TLs(idd(end-2000:end),:)),'r'), yl=ylim; line([0 0],yl), xlim([-0.8 0.8])
subplot(2,3,6), hold on, plot(MLd(:,1),mean(TLd(idd(1:2000),:)),'k'), plot(MLd(:,1),mean(TLd(idd(end-2000:end),:)),'r'), yl=ylim; line([0 0],yl), xlim([-0.8 0.8])
end

% 
% try
%     
% figure('color',[1 1 1]),
% subplot(4,2,7), plot(MLs(:,1),mean(TLs(idd(1:200),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd(1:200),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000])
% subplot(4,2,5), plot(MLs(:,1),mean(TLs(idd(2200:2400),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd(2200:2400),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000])
% subplot(4,2,3), plot(MLs(:,1),mean(TLs(idd(5400:5600),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd(5400:5600),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000])
% subplot(4,2,1), plot(MLs(:,1),mean(TLs(idd(10600:10800),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd(10600:10800),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000])
% 
% subplot(4,2,8), hist(dur(idd(1:200)),100), title(num2str(1000*mean(dur(idd(1:200)))))
% subplot(4,2,6), hist(dur(idd(2200:2400)),100), title(num2str(1000*mean(dur(idd(2200:2400)))))
% subplot(4,2,4), hist(dur(idd(5400:5600)),100), title(num2str(1000*mean(dur(idd(5400:5600)))))
% subplot(4,2,2), hist(dur(idd(10600:10800)),100),title(num2str(1000*mean(dur(idd(10600:10800)))))
% 
% 
% idd2=idd(end:-1:1);
% figure('color',[1 1 1]),
% subplot(4,2,1), plot(MLs(:,1),mean(TLs(idd2(1:200),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd2(1:200),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000])
% subplot(4,2,3), plot(MLs(:,1),mean(TLs(idd2(2200:2400),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd2(2200:2400),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000])
% subplot(4,2,5), plot(MLs(:,1),mean(TLs(idd2(5400:5600),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd2(5400:5600),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000])
% subplot(4,2,7), plot(MLs(:,1),mean(TLs(idd2(10600:10800),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd2(10600:10800),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000])
% 
% subplot(4,2,2), hist(dur(idd2(1:200)),100), title(num2str(1000*mean(dur(idd2(1:200)))))
% subplot(4,2,4), hist(dur(idd2(2200:2400)),100),title(num2str(1000*mean(dur(idd2(2200:2400)))))
% subplot(4,2,6), hist(dur(idd2(5400:5600)),100), title(num2str(1000*mean(dur(idd2(5400:5600)))))
% subplot(4,2,8), hist(dur(idd2(10600:10800)),100),title(num2str(1000*mean(dur(idd2(10600:10800)))))
% 
% 
% 
% catch
%     
%    close
    le=length(idd);
    
figure('color',[1 1 1]),
subplot(4,2,7), plot(MLs(:,1),mean(TLs(idd(1:floor(le/4)),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd(1:floor(le/4)),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000]), xlim([-0.8 0.8])
subplot(4,2,5), plot(MLs(:,1),mean(TLs(idd(floor(le/4):2*floor(le/4)),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd(floor(le/4):2*floor(le/4)),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000]), xlim([-0.8 0.8])
subplot(4,2,3), plot(MLs(:,1),mean(TLs(idd(2*floor(le/4):3*floor(le/4)),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd(2*floor(le/4):3*floor(le/4)),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000]), xlim([-0.8 0.8])
subplot(4,2,1), plot(MLs(:,1),mean(TLs(idd(3*floor(le/4):le),:)),'k'), hold on, plot(MLd(:,1),mean(TLd(idd(3*floor(le/4):le),:)),'r'), ylim([-1000 1000]), line([0 0],[-1000 1000]), xlim([-0.8 0.8])

subplot(4,2,8), hist(dur(idd(1:floor(le/4))),100), title(num2str(1000*mean(dur(idd(1:floor(le/4))))))
subplot(4,2,6), hist(dur(idd(floor(le/4):2*floor(le/4))),100), title(num2str(1000*mean(dur(idd(floor(le/4):2*floor(le/4))))))
subplot(4,2,4), hist(dur(idd(2*floor(le/4):3*floor(le/4))),100), title(num2str(1000*mean(dur(idd(2*floor(le/4):3*floor(le/4))))))
subplot(4,2,2), hist(dur(idd(3*floor(le/4):le)),100),title(num2str(1000*mean(dur(idd(3*floor(le/4):le)))))




% end

