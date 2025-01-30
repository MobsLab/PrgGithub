clear all
SessionNames = {'SleepPre','SleepPost','SleepPostSound','SleepPreSound','UMazeCond'};
Binsize = 0.01*1e4;
MiceNumber=[490,507,508,509,514];
vals = [-1:0.05:1];
TimeAroundDelta = 0.2*1e4;
for ss=1:length(SessionNames)
    RippleTriggeredSpikes.(SessionNames{ss}) = [];
    RippleTriggeredSpikesNoDelta.(SessionNames{ss}) = [];
    NeuroInfo.(SessionNames{ss}) = [];
end
DurBefRip = 1000;

for mm=1:length(MiceNumber)
    DirTemp = GetAllMouseTaskSessions(MiceNumber(mm));
    
    
    for ss=1:length(SessionNames)
        
        % Find the session files
        x1 = strfind(DirTemp,[SessionNames{ss} filesep]);
        ToKeep = find(~cellfun(@isempty,x1));
        Dir.(SessionNames{ss}) = DirTemp(ToKeep);
        
        cd(Dir.(SessionNames{ss}){1})
        load('ChannelsToAnalyse/dHPC_rip.mat')
        
        % Load the ripples, spikes and epochs
        Ripples = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'ripples');
        Deltas = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'deltawaves');
        Spikes = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'spikes');
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
        Spikes = Spikes(numNeurons);
        SleepEpochs = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'epoch','epochname','sleepstates'); % wake - nrem -rem
        if ss==5
            LinPos= ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'linearposition');
            FreezeEpoch = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'epoch','epochname','freezeepoch');
        end
        
        Q = MakeQfromS(Spikes,Binsize);
        
        if ss<5
            RipplesRest = Restrict(Ripples,SleepEpochs{2});
            DeltaEpoch = mergeCloseIntervals(intervalSet(Start(Deltas)-TimeAroundDelta,Stop(Deltas)+TimeAroundDelta),0.1*1e4);
            RipplesRest2 = Restrict(Ripples,SleepEpochs{2}-DeltaEpoch);
            
        elseif ss==5
            RipplesRest = Restrict(Ripples,thresholdIntervals(LinPos,0.6,'Direction','Above'));
        end
        
        RippleSpiking = []; RippleSpiking2 = [];
        clear FRRateInfo
        QDat = Data(Q);
        
        for nn = 1:length(numNeurons)
            QOneNeur = tsd(Range(Q),QDat(:,nn));
            
            [M,T] = PlotRipRaw(QOneNeur,Range(RipplesRest,'s'),DurBefRip,0,0);
            RippleSpiking = [RippleSpiking,(M(:,2))];
            
            if ss<5
                [M,T] = PlotRipRaw(QOneNeur,Range(RipplesRest2,'s'),DurBefRip,0,0);
                RippleSpiking2 = [RippleSpiking2,(M(:,2))];
            end
            
            tpsrip = M(:,1);
            
            % Get some general firing rate info to do zscore fairly
            if ss<5
                FRRateInfo(nn,:) = [nanmean(Data(Restrict(QOneNeur,SleepEpochs{2}))),nanstd(Data(Restrict(QOneNeur,SleepEpochs{2})))];
            elseif ss==5
                FRRateInfo(nn,:) = [nanmean(Data(Restrict(QOneNeur,FreezeEpoch))),nanstd(Data(Restrict(QOneNeur,FreezeEpoch)))];
            end
        end
        
        [val,ind] = max(RippleSpiking);
        [C,I] = sort(ind);
        RippleTriggeredSpikes.(SessionNames{ss}) = [RippleTriggeredSpikes.(SessionNames{ss}),RippleSpiking];
        RippleTriggeredSpikesNoDelta.(SessionNames{ss}) = [RippleTriggeredSpikesNoDelta.(SessionNames{ss}),RippleSpiking2];
        NeuroInfo.(SessionNames{ss}) = [NeuroInfo.(SessionNames{ss});full(FRRateInfo)];
        
        
    end
end

RippleTriggeredSpikesNoDelta.UMazeCond = RippleTriggeredSpikes.UMazeCond;
     

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD/RippleActivityPFC
load('RippleTriggeredSpikesWithDelta.mat')

% ordered by time with delta
figure
clf
for ss1 = 1:length(SessionNames)
    for ss2 = 1:length(SessionNames)
        subplot(5,5,ss1+(ss2-1)*5)
        [val,ind] = max(SmoothDec(zscore(RippleTriggeredSpikes.(SessionNames{ss1})(20:60,:)),[0.1 1]));
        [C,I] = sort(ind);
        
        imagesc(tpsrip(20:60),1:length(I),SmoothDec(zscore(RippleTriggeredSpikes.(SessionNames{ss2})(20:60,I)),[0.1 1])')
        line([0 0],ylim,'linewidth',2,'color','w')
        clim([-1.5 1.5])
        hold on
        if ss1==1
        ylabel('Neuron number')
        end
        yyaxis right
        plot(tpsrip(20:60),nanmean((RippleTriggeredSpikes.(SessionNames{ss2})(20:60,I))'),'k')
        if ss2 ==1
            title([SessionNames{ss1} ' ordered'])
        end
        xlabel('Time to ripple (s)')
        
    end
end

% ordered by response depth  with delta
figure
clf
for ss1 = 1:length(SessionNames)
    for ss2 = 1:length(SessionNames)
        subplot(5,5,ss1+(ss2-1)*5);
        A = SmoothDec(zscore(RippleTriggeredSpikes.(SessionNames{ss1})(20:60,:)),[0.1 1]);
        [val] = mean(A(20:25,:));
        [C,I] = sort(val);
        
        imagesc(tpsrip(20:60),1:length(I),SmoothDec(zscore(RippleTriggeredSpikes.(SessionNames{ss2})(20:60,I)),[0.1 1])')
        line([0 0],ylim,'linewidth',2,'color','w')
        clim([-1.5 1.5])
        hold on
        if ss1==1
        ylabel('Neuron number')
        end
        yyaxis right
        plot(tpsrip(20:60),nanmean((RippleTriggeredSpikes.(SessionNames{ss2})(20:60,I))'),'k')
        if ss2 ==1
            title([SessionNames{ss1} ' ordered'])
        end
        xlabel('Time to ripple (s)')
        
    end
end


% ordered by time without delta
figure
clf
for ss1 = 1:length(SessionNames)
    for ss2 = 1:length(SessionNames)
        subplot(5,5,ss1+(ss2-1)*5)
        [val,ind] = max(SmoothDec(zscore(RippleTriggeredSpikesNoDelta.(SessionNames{ss1})(20:60,:)),[0.1 1]));
        [C,I] = sort(ind);
        
        imagesc(tpsrip(20:60),1:length(I),SmoothDec(zscore(RippleTriggeredSpikesNoDelta.(SessionNames{ss2})(20:60,I)),[0.1 1])')
        line([0 0],ylim,'linewidth',2,'color','w')
        clim([-1.5 1.5])
        hold on
        if ss1==1
        ylabel('Neuron number')
        end
        yyaxis right
        plot(tpsrip(20:60),nanmean((RippleTriggeredSpikesNoDelta.(SessionNames{ss2})(20:60,I))'),'k')
        if ss2 ==1
            title([SessionNames{ss1} ' ordered'])
        end
        xlabel('Time to ripple (s)')
        
    end
end

% ordered by response depth  without delta
figure
clf
for ss1 = 1:length(SessionNames)
    for ss2 = 1:length(SessionNames)
        subplot(5,5,ss1+(ss2-1)*5);
        A = SmoothDec(zscore(RippleTriggeredSpikesNoDelta.(SessionNames{ss1})(20:60,:)),[0.1 1]);
        [val] = mean(A(20:25,:));
        [C,I] = sort(val);
        
        imagesc(tpsrip(20:60),1:length(I),SmoothDec(zscore(RippleTriggeredSpikesNoDelta.(SessionNames{ss2})(20:60,I)),[0.1 1])')
        line([0 0],ylim,'linewidth',2,'color','w')
        clim([-1.5 1.5])
        hold on
        if ss1==1
        ylabel('Neuron number')
        end
        yyaxis right
        plot(tpsrip(20:60),nanmean((RippleTriggeredSpikesNoDelta.(SessionNames{ss2})(20:60,I))'),'k')
        if ss2 ==1
            title([SessionNames{ss1} ' ordered'])
        end
        xlabel('Time to ripple (s)')
        
    end
end

% correlation no delta
figure
for ss1 = 1:length(SessionNames)
    for ss2 = 1:length(SessionNames)
        
        A = SmoothDec(zscore(RippleTriggeredSpikesNoDelta.(SessionNames{ss1})(20:60,:)),[0.1 1])';
        B = SmoothDec(zscore(RippleTriggeredSpikesNoDelta.(SessionNames{ss2})(20:60,:)),[0.1 1])';
        subplot(5,5,ss1+(ss2-1)*5)
        [R,P] = corr(A,B);
        imagesc(tpsrip(20:60),tpsrip(20:60),SmoothDec(R,[0.5,0.5]))
        clim([-0.2 0.2])

%         imagesc(tpsrip(20:60),tpsrip(20:60),P<0.05)
%         clim([-0.3 0.3])
        if ss2 ==1
            title(SessionNames{ss1})
        end
        xlabel('Time to ripple')
        ylabel('Template time')

    end
end

% correlation with delta
figure
for ss1 = 1:length(SessionNames)
    for ss2 = 1:length(SessionNames)
        
        A = SmoothDec(zscore(RippleTriggeredSpikes.(SessionNames{ss1})(20:60,:)),[0.1 1])';
        B = SmoothDec(zscore(RippleTriggeredSpikes.(SessionNames{ss2})(20:60,:)),[0.1 1])';
        subplot(5,5,ss1+(ss2-1)*5)
        [R,P] = corr(A,B);
        imagesc(tpsrip(20:60),tpsrip(20:60),SmoothDec(R,[0.5,0.5]))
        clim([-0.2 0.2])

%         imagesc(tpsrip(20:60),tpsrip(20:60),P<0.05)
%         clim([-0.3 0.3])
        if ss2 ==1
            title(SessionNames{ss1})
        end
        xlabel('Time to ripple')
        ylabel('Template time')

    end
end


figure
clf
for ss1 = 1:length(SessionNames)
    for ss2 = 1:length(SessionNames)
        subplot(5,5,ss1+(ss2-1)*5)
        
        
        A = RippleTriggeredSpikes.(SessionNames{ss2});
        for nn = 1:length(A)
            A(:,nn) = (A(:,nn)-NeuroInfo.(SessionNames{ss2})(nn,1))./NeuroInfo.(SessionNames{ss2})(nn,1);
        end
        
        
        [val,ind] = max(SmoothDec((RippleTriggeredSpikes.(SessionNames{ss1})),[0.1 1]));
        [C,I] = sort(ind);
        
        imagesc(tpsrip,1:length(I),SmoothDec((A(:,I)),[0.1 1])')
        line([0 0],ylim,'linewidth',2,'color','w')
        clim([-3 3])
        hold on
        yyaxis right
        plot(tpsrip,nanmean(A'),'k')

        
    end
end



% Response during sleep depending on responses during wake - all zscored to
% no delta
figure
clf
[val,ind] = max(SmoothDec(zscore(RippleTriggeredSpikesNoDelta.(SessionNames{5})(20:60,:)),[0.1 1]));
[C,I] = sort(ind);
subplot(2,3,1)
for ss2 = 1:length(SessionNames)
    plot(tpsrip(20:60),nanmean(SmoothDec(zscore(RippleTriggeredSpikesNoDelta.(SessionNames{ss2})(20:60,I(100:180)))',[0.1 0.8])),'linewidth',2)
    hold on
end
ylim([-0.8 0.8])
line([0 0],ylim,'color','k','linewidth',2)
xlabel('Time to ripple (s)')
ylabel('ZScored response')
title('Group1 - no delta')
box off
set(gca,'linewidth',2,'FontSize',14)
legend(SessionNames)

subplot(2,3,2)
for ss2 = 1:length(SessionNames)
    plot(tpsrip(20:60),nanmean(SmoothDec(zscore(RippleTriggeredSpikesNoDelta.(SessionNames{ss2})(20:60,I(1:99)))',[0.1 0.8])),'linewidth',2)
    hold on
end
ylim([-0.8 0.8])
line([0 0],ylim,'color','k','linewidth',2)
xlabel('Time to ripple (s)')
ylabel('ZScored response')
title('Group2 - no delta')
box off
set(gca,'linewidth',2,'FontSize',14)

subplot(2,3,3)
for ss2 = 1:length(SessionNames)
    plot(tpsrip(20:60),nanmean(SmoothDec(zscore(RippleTriggeredSpikesNoDelta.(SessionNames{ss2})(20:60,I(181:end)))',[0.1 0.8])),'linewidth',2)
    hold on
end
ylim([-0.8 0.8])
line([0 0],ylim,'color','k','linewidth',2)
xlabel('Time to ripple (s)')
ylabel('ZScored response')
title('Group3 - no delta')
box off
set(gca,'linewidth',2,'FontSize',14)

subplot(2,3,4)
for ss2 = 1:length(SessionNames)
    A = RippleTriggeredSpikes.(SessionNames{ss2})(20:60,I(100:180));
    B  = RippleTriggeredSpikesNoDelta.(SessionNames{ss2})(20:60,I(100:180));
    for nn = 1:size(A,2)
        if sum(B(:,nn))>0
            A(:,nn) = (A(:,nn) - nanmean(B(:,nn)))/nanstd(B(:,nn));
        end
    end
    
    plot(tpsrip(20:60),nanmean(SmoothDec(A',[0.1 0.8])),'linewidth',2)
    hold on
end
ylim([-0.8 0.8])
line([0 0],ylim,'color','k','linewidth',2)
xlabel('Time to ripple (s)')
ylabel('ZScored response')
title('Group1 - with delta')
box off
set(gca,'linewidth',2,'FontSize',14)

subplot(2,3,5)
for ss2 = 1:length(SessionNames)
    A = RippleTriggeredSpikes.(SessionNames{ss2})(20:60,I(1:99));
    B  = RippleTriggeredSpikesNoDelta.(SessionNames{ss2})(20:60,I(1:99));
    for nn = 1:size(A,2)
        if sum(B(:,nn))>0
            A(:,nn) = (A(:,nn) - nanmean(B(:,nn)))/nanstd(B(:,nn));
        end
    end
    
    plot(tpsrip(20:60),nanmean(SmoothDec(A',[0.1 0.8])),'linewidth',2)
    hold on
end
ylim([-0.8 0.8])
line([0 0],ylim,'color','k','linewidth',2)
xlabel('Time to ripple (s)')
ylabel('ZScored response')
title('Group2 - with delta')
box off
set(gca,'linewidth',2,'FontSize',14)

subplot(2,3,6)
for ss2 = 1:length(SessionNames)
    A = RippleTriggeredSpikes.(SessionNames{ss2})(20:60,I(181:end));
    B  = RippleTriggeredSpikesNoDelta.(SessionNames{ss2})(20:60,I(181:end));
    for nn = 1:size(A,2)
        if sum(B(:,nn))>0
            A(:,nn) = (A(:,nn) - nanmean(B(:,nn)))/nanstd(B(:,nn));
        end
    end
        plot(tpsrip(20:60),nanmean(SmoothDec(A',[0.1 0.8])),'linewidth',2)

    hold on
end
ylim([-0.8 0.8])
line([0 0],ylim,'color','k','linewidth',2)
xlabel('Time to ripple (s)')
ylabel('ZScored response')
title('Group3 - with delta')
box off
set(gca,'linewidth',2,'FontSize',14)


figure
clf
[val,ind] = max(SmoothDec(zscore(RippleTriggeredSpikesNoDelta.(SessionNames{5})(20:60,:)),[0.1 1]));
[C,I] = sort(ind);
subplot(2,3,1)
for ss2 = 1:length(SessionNames)
    A = RippleTriggeredSpikesNoDelta.(SessionNames{ss2})(20:60,:);
    for nn = 1:size(A,2)
        A(:,nn) = (A(:,nn) - NeuroInfo.(SessionNames{ss2})(nn,1))/(NeuroInfo.(SessionNames{ss2})(nn,2));
    end
    A = A(:,I(100:180));
    plot(tpsrip(20:60),nanmean(SmoothDec(A',[0.1 0.8])),'linewidth',2)
    
    hold on
end
ylim([-0.05 0.12])
line([0 0],ylim,'color','k','linewidth',2)
xlabel('Time to ripple (s)')
ylabel('ZScored to total response')
title('Group1 - no delta')
box off
set(gca,'linewidth',2,'FontSize',14)

subplot(2,3,2)
for ss2 = 1:length(SessionNames)
    A = RippleTriggeredSpikesNoDelta.(SessionNames{ss2})(20:60,:);
    for nn = 1:size(A,2)
        A(:,nn) = (A(:,nn) - NeuroInfo.(SessionNames{ss2})(nn,1))/(NeuroInfo.(SessionNames{ss2})(nn,2));
    end
        A = A(:,I(1:99));

        plot(tpsrip(20:60),nanmean(SmoothDec(A',[0.1 0.8])),'linewidth',2)

    hold on
end
ylim([-0.05 0.12])
line([0 0],ylim,'color','k','linewidth',2)
xlabel('Time to ripple (s)')
ylabel('ZScored to total response')
title('Group2 - no delta')
box off
set(gca,'linewidth',2,'FontSize',14)

subplot(2,3,3)
for ss2 = 1:length(SessionNames)
    A = RippleTriggeredSpikesNoDelta.(SessionNames{ss2})(20:60,:);
    for nn = 1:size(A,2)
        A(:,nn) = (A(:,nn) - NeuroInfo.(SessionNames{ss2})(nn,1))/(NeuroInfo.(SessionNames{ss2})(nn,2));
    end
    A = A(:,I(181:end));
        plot(tpsrip(20:60),nanmean(SmoothDec(A',[0.1 0.8])),'linewidth',2)

    hold on
end
ylim([-0.05 0.12])
line([0 0],ylim,'color','k','linewidth',2)
xlabel('Time to ripple (s)')
ylabel('ZScored to total response')
title('Group3 - no delta')
box off
set(gca,'linewidth',2,'FontSize',14)

subplot(2,3,4)
for ss2 = 1:length(SessionNames)
    A = RippleTriggeredSpikes.(SessionNames{ss2})(20:60,:);
    for nn = 1:size(A,2)
        A(:,nn) = (A(:,nn) - NeuroInfo.(SessionNames{ss2})(nn,1))/(NeuroInfo.(SessionNames{ss2})(nn,2));
    end
    A = A(:,I(100:180));
    plot(tpsrip(20:60),nanmean(SmoothDec(A',[0.1 0.8])),'linewidth',2)
    hold on
end
ylim([-0.05 0.12])
line([0 0],ylim,'color','k','linewidth',2)
xlabel('Time to ripple (s)')
ylabel('ZScored to total response')
title('Group1 - with delta')
box off
set(gca,'linewidth',2,'FontSize',14)

subplot(2,3,5)
for ss2 = 1:length(SessionNames)
    A = RippleTriggeredSpikes.(SessionNames{ss2})(20:60,:);
    for nn = 1:size(A,2)
        A(:,nn) = (A(:,nn) - NeuroInfo.(SessionNames{ss2})(nn,1))/(NeuroInfo.(SessionNames{ss2})(nn,2));
    end
    A = A(:,I(1:99));
    plot(tpsrip(20:60),nanmean(SmoothDec(A',[0.1 0.8])),'linewidth',2)
    hold on
end
ylim([-0.05 0.12])
line([0 0],ylim,'color','k','linewidth',2)
xlabel('Time to ripple (s)')
ylabel('ZScored to total response')
title('Group2 - with delta')
box off
set(gca,'linewidth',2,'FontSize',14)

subplot(2,3,6)
for ss2 = 1:length(SessionNames)
    A = RippleTriggeredSpikes.(SessionNames{ss2})(20:60,:);
    for nn = 1:size(A,2)
        A(:,nn) = (A(:,nn) - NeuroInfo.(SessionNames{ss2})(nn,1))/(NeuroInfo.(SessionNames{ss2})(nn,2));
    end
    A = A(:,I(181:end));
        plot(tpsrip(20:60),nanmean(SmoothDec(A',[0.1 0.8])),'linewidth',2)

    hold on
end
ylim([-0.05 0.12])
line([0 0],ylim,'color','k','linewidth',2)
xlabel('Time to ripple (s)')
ylabel('ZScored to total response')
title('Group3 - with delta')
box off
set(gca,'linewidth',2,'FontSize',14)


figure
ss2=1;
A = RippleTriggeredSpikes.(SessionNames{ss2})(20:60,:);
for nn = 1:size(A,2)
    A(:,nn) = (A(:,nn) - NeuroInfo.(SessionNames{ss2})(nn,1))/(NeuroInfo.(SessionNames{ss2})(nn,2));
end
plot(tpsrip(20:60),nanmean(SmoothDec(A',[0.1 0.8])),'linewidth',2)
hold on
A = RippleTriggeredSpikesNoDelta.(SessionNames{ss2})(20:60,:);
for nn = 1:size(A,2)
    A(:,nn) = (A(:,nn) - NeuroInfo.(SessionNames{ss2})(nn,1))/(NeuroInfo.(SessionNames{ss2})(nn,2));
end
plot(tpsrip(20:60),nanmean(SmoothDec(A',[0.1 0.8])),'linewidth',2)
legend('delta','no delta')
set(gca,'linewidth',2,'FontSize',14)
box off
xlabel('Time to ripple (s)')
ylabel('ZScored response')

