clear all
SessNames={'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug',...
    'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug',...
    'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
    'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};



SALMice = [688,739,777,779,849];
FzTimes = [0:5:300];
for ss = 1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            cd(Dir.path{d}{dd})
            clear Behav ExpeInfo
            load('ExpeInfo.mat')
            
            MouseNum = find(SALMice==ExpeInfo.nmouse);
            if not(isempty(MouseNum))
                load('behavResources_SB.mat','Behav')
                Behav.MovAcctsd = Restrict(Behav.MovAcctsd,intervalSet(0,300*1e4));
                Behav.JumpEpoch = and(Behav.JumpEpoch,intervalSet(0,300*1e4));
                Behav.FreezeAccEpoch = and(Behav.FreezeAccEpoch,intervalSet(0,300*1e4));
                
                if not(isempty(Start(Behav.JumpEpoch,'s')))
                    JumpTime.(SessNames{ss}){MouseNum,dd} = Start(Behav.JumpEpoch,'s');
                else
                    JumpTime.(SessNames{ss}){MouseNum,dd} = NaN;
                end
                
                for j = 1:length(Start(Behav.JumpEpoch))
                JumpPos.(SessNames{ss}){MouseNum,dd}(j) = nanmean(Data(Restrict(Behav.LinearDist,subset(Behav.JumpEpoch,j))));
                end
                
                FreezeStartTime.(SessNames{ss}){MouseNum,dd} = Start(Behav.FreezeAccEpoch,'s');
                FreezeStopTime.(SessNames{ss}){MouseNum,dd} = Stop(Behav.FreezeAccEpoch,'s');
                
                AllTimes = Range(Behav.MovAcctsd,'s');
                AllFzTimes = Range(Restrict(Behav.MovAcctsd,Behav.FreezeAccEpoch),'s');
                A = ismember(AllTimes,AllFzTimes);
                FzingBinarized = zeros(1,length(AllTimes));
                FzingBinarized(A) = 1;
                FzingBinarized = interp1(Range(Behav.MovAcctsd,'s'),FzingBinarized,FzTimes);
                FreezeTimeCourse.(SessNames{ss})(MouseNum,dd,:) = FzingBinarized;
                
                AllTimes = Range(Behav.Vtsd,'s');
                AllFzTimes = Range(Restrict(Behav.Vtsd,Behav.FreezeAccEpoch),'s');
                A = ismember(AllTimes,AllFzTimes);
                Speed = Data(Behav.Vtsd);
                Speed(A) = NaN;
                Speed = interp1(Range(Behav.Vtsd,'s'),Speed,FzTimes);
                SpeedTimeCourse.(SessNames{ss})(MouseNum,dd,:) = Speed;
                
                %                 [M,T] = PlotRipRaw(Behav.MovAcctsd,Start(Behav.JumpEpoch,'s'),5000);
                
            end
        end
    end
end
figure
% Show freezing and jumping in habituation
AllSalJump = [];
ss = 1;
for m=1:5

    for dd=1
        AllSalJump = [AllSalJump; JumpTime.(SessNames{ss}){m,dd}];
    end
end

[Y,X] = hist(AllSalJump,[0:10:300]);
ShockTimes  = [120,150,180,210];
 figure
clf
subplot(211)
bar(FzTimes,runmean(nanmean(squeeze(nanmean(FreezeTimeCourse.(SessNames{ss}),2))),1))
hold on
ylabel('% Time fz'), ylim([0 0.4])
yyaxis right
plot(X,Y,'linewidth',3)
ylabel('Num Jumps'), ylim([0 30])
title('Shock side')
xlabel('time (s)')

ss=2;
AllSalJump = [];
for m=1:5

    for dd=1
        AllSalJump = [AllSalJump; JumpTime.(SessNames{ss}){m,dd}];
    end
end

[Y,X] = hist(AllSalJump,[0:10:300]);
subplot(212)
bar(FzTimes,runmean(nanmean(squeeze(nanmean(FreezeTimeCourse.(SessNames{ss}),2))),1))
hold on
ylabel('% Time fz'), ylim([0 0.4])
yyaxis right
plot(X,Y,'linewidth',3)
ylabel('Num Jumps'), ylim([0 30])
title('Safe side')
xlabel('time (s)')


figure
% Show freezing and jumping in extinction
AllSalJump = [];
ss = 7;
for m=1:5

    for dd=1:2
        AllSalJump = [AllSalJump; JumpTime.(SessNames{ss}){m,dd}];
    end
end

[Y,X] = hist(AllSalJump,[0:10:300]);
ShockTimes  = [120,150,180,210];
 figure
clf
subplot(211)
bar(FzTimes,runmean(nanmean(squeeze(nanmean(FreezeTimeCourse.(SessNames{ss}),2))),1))
hold on
ylabel('% Time fz'), ylim([0 0.4])
yyaxis right
plot(X,Y,'linewidth',3)
ylabel('Num Jumps'), ylim([0 30])
title('Shock side')
xlabel('time (s)')

ss=8;
AllSalJump = [];
for m=1:5

    for dd=1:2
        AllSalJump = [AllSalJump; JumpTime.(SessNames{ss}){m,dd}];
    end
end

[Y,X] = hist(AllSalJump,[0:10:300]);
subplot(212)
bar(FzTimes,runmean(nanmean(squeeze(nanmean(FreezeTimeCourse.(SessNames{ss}),2))),1))
hold on
ylabel('% Time fz'), ylim([0 0.4])
yyaxis right
plot(X,Y,'linewidth',3)
ylabel('Num Jumps'), ylim([0 30])
title('Safe side')
xlabel('time (s)')


figure
% Show freezing and jumping in extinction
AllSalJump = [];
ss = 5;
for m=1:5

    for dd=1:2
        AllSalJump = [AllSalJump; JumpTime.(SessNames{ss}){m,dd}];
    end
end

[Y,X] = hist(AllSalJump,[0:10:300]);
ShockTimes  = [120,150,180,210];
 figure
clf
subplot(211)
bar(FzTimes,runmean(nanmean(squeeze(nanmean(FreezeTimeCourse.(SessNames{ss}),2))),1))
hold on
ylabel('% Time fz'), ylim([0 0.4])
yyaxis right
plot(X,Y,'linewidth',3)
ylabel('Num Jumps'), ylim([0 30])
title('Shock side')
xlabel('time (s)')

ss=6;
AllSalJump = [];
for m=1:5

    for dd=1:2
        AllSalJump = [AllSalJump; JumpTime.(SessNames{ss}){m,dd}];
    end
end

[Y,X] = hist(AllSalJump,[0:10:300]);
subplot(212)
bar(FzTimes,runmean(nanmean(squeeze(nanmean(FreezeTimeCourse.(SessNames{ss}),2))),1))
hold on
ylabel('% Time fz'), ylim([0 0.4])
yyaxis right
plot(X,Y,'linewidth',3)
ylabel('Num Jumps'), ylim([0 30])
title('Safe side')
xlabel('time (s)')


figure
clf
subplot(211)
bar(FzTimes,runmean(nanmean(squeeze(nanmean(FreezeTimeCourse.(SessNames{ss}),2))),1))
hold on
ylabel('% Time fz'), ylim([0 0.4])
yyaxis right
plot(X,Y,'linewidth',3)
ylabel('Num Jumps'), ylim([0 30])
title('Shock side')
line([ShockTimes;ShockTimes],repmat(ylim,4,1)','color','k','linestyle','-')
xlabel('time (s)')


subplot(212)
bar(FzTimes,runmean(nanmean(squeeze(nanmean(FreezeTimeCourse.(SessNames{ss}).Flx,2))),1))
hold on
ylabel('% Time fz'), ylim([0 0.4])
yyaxis right
plot(X,Y2,'linewidth',3)
ylabel('Num Jumps'), ylim([0 30])
title('Safe side')
line([ShockTimes;ShockTimes],repmat(ylim,4,1)','color','k','linestyle','-')
xlabel('time (s)')

figure
clf
plot(FzTimes,nanmean(squeeze(nanmean(SpeedTimeCourse.(SessNames{ss}).Sal,2))),'linewidth',2)
hold on,plot(FzTimes,nanmean(squeeze(nanmean(SpeedTimeCourse.(SessNames{ss}).Flx,2))),'linewidth',2)
legend('Sal','Flx')
box off
xlabel('time (s)')
ylabel('speed out of freezing (cm/s)')


figure
AlllSalCrossCorr = [];
AlllFlxCrossCorr = [];

for m=1:4
    for dd=1:2
        if not(isempty(FreezeStartTime.(SessNames{ss}).Sal{m,dd}))
            [C,B] = CrossCorr(JumpTime.(SessNames{ss}).Sal{m,dd},FreezeStartTime.(SessNames{ss}).Sal{m,dd},0.1,50);
            AlllSalCrossCorr = [AlllSalCrossCorr,C];
        end
        if not(isempty(FreezeStartTime.(SessNames{ss}).Flx{m,dd}))
            [C,B] = CrossCorr(JumpTime.(SessNames{ss}).Flx{m,dd},FreezeStartTime.(SessNames{ss}).Flx{m,dd},0.1,50);
            AlllFlxCrossCorr = [AlllFlxCrossCorr,C];
        end
    end
end
subplot(121)
g = shadedErrorBar(B*10,nanmean(AlllSalCrossCorr'),stdError(AlllSalCrossCorr')); hold on
set(g.patch,'FaceColor',[0.4 0.4 0.4])
g = shadedErrorBar(B*10,nanmean(AlllFlxCrossCorr'),stdError(AlllFlxCrossCorr')); hold on
set(g.patch,'FaceColor',[0.6 0.6 0.6])
line([0 0],ylim,'color','k')
xlabel('Time to jump (s)')
title('cross corr Jump / Fz start')
AlllSalCrossCorr = [];
AlllFlxCrossCorr = [];

for m=1:4
    for dd=1:2
        if not(isempty(FreezeStopTime.(SessNames{ss}).Sal{m,dd}))
            [C,B] = CrossCorr(JumpTime.(SessNames{ss}).Sal{m,dd},FreezeStopTime.(SessNames{ss}).Sal{m,dd},0.1,50);
            AlllSalCrossCorr = [AlllSalCrossCorr,C];
        end
        if not(isempty(FreezeStopTime.(SessNames{ss}).Flx{m,dd}))
            [C,B] = CrossCorr(JumpTime.(SessNames{ss}).Flx{m,dd},FreezeStopTime.(SessNames{ss}).Flx{m,dd},0.11,50);
            AlllFlxCrossCorr = [AlllFlxCrossCorr,C];
        end
    end
end
subplot(122)
g = shadedErrorBar(B*10,nanmean(AlllSalCrossCorr'),stdError(AlllSalCrossCorr')); hold on
set(g.patch,'FaceColor',[0.4 0.4 0.4])
g = shadedErrorBar(B*10,nanmean(AlllFlxCrossCorr'),stdError(AlllFlxCrossCorr')); hold on
set(g.patch,'FaceColor',[0.6 0.6 0.6])
line([0 0],ylim,'color','k')
xlabel('Time to jump (s)')
title('cross corr Jump / Fz stop')

figure
clear AllSalJump AllFlxJump

for m=1:4
    AllSalJump{m} = [];
    AllFlxJump{m} = [];
    AllFzDurSal{m} = [];
    AllFzDurFlx{m} = [];
    
    for dd=1:2
        AllSalJump{m} = [AllSalJump{m}; JumpTime.(SessNames{ss}).Sal{m,dd}];
        AllFlxJump{m} = [AllFlxJump{m};JumpTime.(SessNames{ss}).Flx{m,dd}];
        AllFzDurSal{m} = [AllFzDurSal{m}; sum(FreezeStopTime.(SessNames{ss}).Sal{m,dd}-FreezeStartTime.(SessNames{ss}).Sal{m,dd})];
        AllFzDurFlx{m} = [AllFzDurFlx{m}; sum(FreezeStopTime.(SessNames{ss}).Flx{m,dd}-FreezeStartTime.(SessNames{ss}).Flx{m,dd})];
        
    end
    NumJump.Sal(m) = length(AllSalJump{m});
    NumJump.Flx(m) = length(AllFlxJump{m});
    FzDur.Sal(m) = sum(AllFzDurSal{m});
    FzDur.Flx(m) = sum(AllFzDurFlx{m});
    
end

figure
bar(1,nanmean(NumJump.Sal),'Facecolor',[0.4 0.4 0.4]),hold on
plot(1,NumJump.Sal,'.k','MarkerSize',10)
bar(2,nanmean(NumJump.Flx),'Facecolor',[0.6 0.6 0.6]),hold on
plot(2,NumJump.Flx,'.k','MarkerSize',10)
set(gca,'XTick',[1:2],'XTickLabel',{'SAL','FLX'})
ylabel('Number of jumps')

PlotErrorBarN_KJ([FzDur.Sal;FzDur.Flx]','paired',0)

AllJumpPos =  [];
for ss = 1:length(SessNames)
    for m=1:5
        
        for dd=1:size(JumpPos.(SessNames{ss}),2)
            AllJumpPos = [AllJumpPos,JumpPos.(SessNames{ss}){m,dd}];
        end
    end
end

[Y,X] = hist(AllJumpPos,[0:0.05:1]);