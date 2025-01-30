clear all;
DataLocationPFCMultipleDepths
% Options for peak ID
Options.Fs=1250; % sampling rate of LFP
Options.FilBand=[1 20];
Options.std=[0.5 0.2];
Options.TimeLim=0.08;
for m=1:mm
    cc=1;
%     cd(SleepSession{m})
%     load('newDeltaPFCx.mat')  
%     for ch=1:length(AllChans{m})
%         load(['LFPData/LFP',num2str(AllChans{m}(ch)),'.mat'])
%         tps=Start(DeltaEpoch,'s');
%         tps=tps(1:min(1000,length(tps)));
%         [M,T]=PlotRipRaw(LFP,tps,1000,0,0);
%         AvDel{m}(ch,:)=M(:,2);
%     end
%     clear Behav FreezeEpoch FreezeAccEpoch Movtsd

    for ff=1:length(Filename{m})
        cd(Filename{m}{ff})
        disp(Filename{m}{ff})

        load('ChannelsToAnalyse/Bulb_deep.mat')
        load(['LFPData/LFP',num2str(channel),'.mat'])
        LFPOB=LFP;
        load('behavResources.mat')
        if exist('Behav')
            try
                FreezeEpoch=Behav.FreezeAccEpoch;
            catch
                FreezeEpoch=Behav.FreezeEpoch;
            end
            TotEpoch=intervalSet(0,max(Range(Behav.Movtsd)));
            load('StateEpochSB.mat')
            FreezeEpoch=FreezeEpoch-SleepyEpoch;
            
        else
            try
                FreezeEpoch=Behav.FreezeAccEpoch;
            catch
            end
            TotEpoch=intervalSet(0,max(Range(Movtsd)));
        end
        DataDur(m,ff)=sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'))
        AllPeaks=FindPeaksForFrequency(LFPOB,Options,0);
        Troughs=ts(AllPeaks(find(AllPeaks(:,2)==-1),1)*1e4);
        for ch=1:length(AllChans{m})
            load(['LFPData/LFP',num2str(AllChans{m}(ch)),'.mat'])
            [M,T]=PlotRipRaw(LFP,Range(Restrict(Troughs,FreezeEpoch),'s'),500,0,0);
            AvBr{m,ff}(ch,:)=M(:,2);
%         end
        clear Behav FreezeEpoch FreezeAccEpoch Movtsd SleepyEpoch

    end
end
 [valDur,indDur]=max(DataDur');


clf
Order=[2,1,5,3,6,4];
for m=1:length(Order)
subplot(6,3,(m-1)*3+1) 
[val,ind]=max(abs(AvDel{Order(m)}(:,1200:1400)'));
ind=ind+1200;
clear dat
for k=1:size(AvDel{Order(m)},1)
   dat(k)=AvDel{Order(m)}(k,ind(k));
end
[val,ind]=sort(dat);
cols=jet(length(dat));
for k=1:size(AvDel{Order(m)},1)
plot(AvDel{Order(m)}(ind(k),:)','color',cols(k,:),'linewidth',2),hold on
end
ylabel(MouseNum{Order(m)})
title('delta')
subplot(6,3,(m-1)*3+2) 
for k=1:size(AvDel{Order(m)},1)
    plot(M(:,1),(AvBr{Order(m),indDur(Order(m))}(ind(k),:)'),'color',cols(k,:),'linewidth',2),hold on
end
title('breathing triggered')
subplot(6,3,(m-1)*3+3) 
for k=1:size(AvDel{Order(m)},1)
    plot(M(:,1),zscore(AvBr{Order(m),indDur(Order(m))}(ind(k),:)'),'color',cols(k,:),'linewidth',2),hold on
end
title('breathing triggered zscored')

end