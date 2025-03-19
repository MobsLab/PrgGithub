function [dur_cycle]=sleepCycle_individualMouse_MC(Wake,SWSEpoch,REMEpoch)


%% find sleep cycles
% load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch', 'TotalNoiseEpoch', 'SubNoiseEpoch')


%%

% AllRemStop_bef = Stop(REMEpoch);
% SleepCycle_bef=intervalSet(AllRemStop_bef(1:end-1),AllRemStop_bef(2:end));
% 
% for i=1:length(Start(SleepCycle_bef))
%     dur_cycle_bef(i) = Stop(subset(SleepCycle_bef,i),'min') - Start(subset(SleepCycle_bef,i),'min');
% end
% 
% 
% val = median(dur_cycle_bef);
% val3= floor(mean(dur_cycle_bef));



%%
RemMerge = 3*60;
RemDurMin = 15;
WakeDurMin = 30;

REMEpoch = mergeCloseIntervals(REMEpoch,RemMerge*1e4);
REMEpoch = dropShortIntervals(REMEpoch,RemDurMin*1e4);

Wake=Wake-REMEpoch;
SWSEpoch=SWSEpoch-REMEpoch;

SWSEpoch = mergeCloseIntervals(SWSEpoch,30*1e4);
Wake=Wake-SWSEpoch;
REMEpoch=REMEpoch-SWSEpoch;

Wake = dropShortIntervals(Wake,WakeDurMin*1e4);
% SWSEpoch=SWSEpoch-Wake;
% REMEpoch=REMEpoch-Wake;

AllRemStop = Stop(REMEpoch);


clear BeginCycle EndCycle
for k = 2:length(AllRemStop)
    LittleEpoch = intervalSet(Stop(subset(REMEpoch,k-1)),Stop(subset(REMEpoch,k)));
    DurWakeInEpoch(k) = sum(Stop(and(Wake,LittleEpoch),'s')-Start(and(Wake,LittleEpoch),'s'));
%     if DurWakeInEpoch(k)>25 %%30
%         [aft_cell,beg_cell] = transEpoch(SWSEpoch,subset(REMEpoch,k));
%         if isempty(Start(aft_cell{1,2}))
%             BeginCycle(k-1) = AllRemStop(k-1);
%             EndCycle(k-1) = AllRemStop(k);
%         else
%             BeginCycle(k-1) = Start(aft_cell{1,2});
%             EndCycle(k-1) = AllRemStop(k);
%         end
%     else
        BeginCycle(k-1) = AllRemStop(k-1);
        EndCycle(k-1) = AllRemStop(k);
%     end
end

SleepCycle=intervalSet(BeginCycle,EndCycle);
% SleepCycle=intervalSet(AllRemStop(1:end-1),AllRemStop(2:end));

for i=1:length(Start(SleepCycle))
    dur_cycle(i) = Stop(subset(SleepCycle,i),'min') - Start(subset(SleepCycle,i),'min');
end

%%duration of state inside each cycle
for i=1:length(Start(SleepCycle))
    
    st_sws{i} = Start(and(SWSEpoch,subset(SleepCycle,i)),'min');
    en_sws{i} = Stop(and(SWSEpoch,subset(SleepCycle,i)),'min');
    
    st_rem{i} = Start(and(REMEpoch,subset(SleepCycle,i)),'min');
    en_rem{i} = Stop(and(REMEpoch,subset(SleepCycle,i)),'min');
    
    st_wake{i} = Start(and(Wake,subset(SleepCycle,i)),'min');
    en_wake{i} = Stop(and(Wake,subset(SleepCycle,i)),'min');
end
%%%
for i=1:length(Start(SleepCycle))

    for j=1:length(st_sws{i})
        dur_sws{i}(j) = en_sws{i}(j) - st_sws{i}(j);
    end
    
    for j=1:length(st_rem{i})
        dur_rem{i}(j) = en_rem{i}(j) - st_rem{i}(j);
    end
    
    for j=1:length(st_wake{i})
        if isempty(st_wake{i})==0
            dur_wake{i}(j) = en_wake{i}(j) - st_wake{i}(j);
        else
            dur_wake{i}(j)=0;
        end
    end
end

%%merge small episodes
for i=1:length(dur_sws)
    for ii=1:length(dur_sws{i})
        if length(dur_sws{i}) >1
            durT_sws(i)= sum(dur_sws{i});
        else 
            durT_sws(i)=dur_sws{i};
        end
    end
end



for i=1:length(dur_rem)
    for ii=1:length(dur_rem{i})
        if length(dur_rem{i}) >1
            durT_rem(i)= sum(dur_rem{i});
        else 
            durT_rem(i)=dur_rem{i};
        end
    end
end


for i=1:length(dur_wake)
    for ii=1:length(dur_wake{i})
        if length(dur_wake{i}) >1
            durT_wake(i)= sum(dur_wake{i});
        else 
            durT_wake(i)=dur_wake{i};
        end
    end
end

if length(dur_wake)<length(dur_sws)
    durT_wake(length(dur_wake):length(dur_sws))=0;
end


test=durT_wake+durT_sws;
% test=durT_sws;

%%
% total_dur_cycle = durT_wake+durT_sws+durT_rem;
total_dur_cycle = durT_sws+durT_rem;

max_cycle = ceil(total_dur_cycle);
max_sws = ceil(durT_sws);
M = zeros(length(Start(SleepCycle)),ceil(max(total_dur_cycle)));

M(length(Start(SleepCycle)),max_sws(i):max_cycle(i))=1;

for i=1:length(Start(SleepCycle))
    M(i,max_sws(i):max_cycle(i))=1;
end

nb_rem_align_within_cycle = sum(M,1);


%%
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1);
line([Start(SleepCycle)/1e4 Stop(SleepCycle)/1e4]',[Start(SleepCycle)/1e4 Stop(SleepCycle)/1e4]'*0+1+0.2,'color','k','linewidth',10)

%%
figure, subplot(4,3,[1,2,4,5,7,8])
% b=barh([1:length(durT_rem)], [test;durT_rem]','stacked')
% b=barh([1:length(durT_rem)], [durT_wake;durT_sws;durT_rem]','stacked')
% b(1).FaceColor=[0 0 0]
% b(2).FaceColor=[0 0 .8]
% b(3).FaceColor=[1 0 0]

b=barh([1:length(durT_rem)], [durT_sws;durT_rem]','stacked')
b(1).FaceColor=[0 0 .8]
b(2).FaceColor=[1 0 0]

set(gca,'Ydir','reverse')
yticks([1:length(durT_rem)])
ylabel('# sleep cycle')
xlabel('Duration (min)')

subplot(4,3,[10,11])
b=bar(nb_rem_align_within_cycle);
b.FaceColor = [.85 .3250 .0980];
ylabel('# aligned REM whithin cycles')
ylim([0 20])
xlim([0 20])

subplot(4,3,[3,6,9])
p1=plot(durT_rem, [1:1:length(durT_rem)],'-o','MarkerSize',5,'MarkerFaceColor',[.85 .3250 .0980]);
p1.Color=[.85 .3250 .0980];
set(gca,'Ydir','reverse')
set(gca,'Xcolor',[.85 .3250 .0980])
ylim([0 length(Start(SleepCycle))+1])
xlabel('REM duration (min)')
ylabel('# Sleep cycles')
set(gca,'FontSize',12)
hAx(1) = gca;
hAx(2) = axes('Position',hAx(1).Position,'XAxisLocation','top','YAxisLocation','right','color','none')
hold(hAx(2),'on')
% p2=plot(dur_cycle, [1:1:length(dur_cycle)],'-o','MarkerSize',5,'MarkerFaceColor',[0 .447 .741]);

p2=plot(dur_cycle, [1:1:length(dur_cycle)],'-o','MarkerSize',5,'MarkerFaceColor',[0 0 0]);
% p2.Color=[0 .447 .741];
p2.Color=[0 0 0];
set(gca,'Ydir','reverse')
% set(gca,'Xcolor',[0 .447 .741])
set(gca,'Xcolor',[0 0 0])
xlabel('Sleep cycle duration (min)')
set(gca,'FontSize',12)
set(gcf,'color',[1 1 1])
ylim([0 length(Start(SleepCycle))+1])


subplot(4,3,12)
s1 = plot(durT_rem, durT_sws,'ko')
set(s1,'MarkerSize',6,'Linewidth',2);
hold on
l=lsline;
ylabel('Sleep cycle duration (min)')
xlabel('REM duration (min)')
set(gca,'FontSize',12)
set(gcf,'color',[1 1 1])


%% figure
%% distribution durée cycles sommeil
% nbins = 50; 
% 
% [n,x]=hist(dur_rem,nbins);
% figure, hist(dur_rem,nbins);
% xlabel('REM duration (min)')
% ylabel('Nb of cycle')
% % figure,plot(x,n)
% 
% [n,x]=hist(dur_cycle,nbins);
% figure, hist(dur_cycle,nbins);
% xlabel('Sleep cycle duration (min)')
% ylabel('Nb of cycle')
% % figure,plot(x,n)
% 
% 
% %%
% 
% figure,
% s1 = plot(dur_cycle,dur_rem(1:length(dur_cycle)),'ko')
% set(s1,'MarkerSize',6,'Linewidth',2);
% hold on
% l=lsline;
% xlabel('Sleep cycle duration (min)')
% ylabel('REM duration (min)')
% set(gca,'FontSize',12)
% set(gcf,'color',[1 1 1])
% 
% [RHO,PVAL] = corrcoef(dur_cycle,dur_rem(1:length(dur_cycle)));
% title()


%%



figure
subplot(5,2,[1,3,5,7])
p1=plot(durT_rem, [1:1:length(durT_rem)],'-o','MarkerSize',5,'MarkerFaceColor',[.85 .3250 .0980]);
p1.Color=[.85 .3250 .0980];
set(gca,'Ydir','reverse')
set(gca,'Xcolor',[.85 .3250 .0980])

xlabel('REM duration (min)')
ylabel('# Sleep cycles')
set(gca,'FontSize',12)

hAx(1) = gca;
hAx(2) = axes('Position',hAx(1).Position,'XAxisLocation','top','YAxisLocation','right','color','none')
hold(hAx(2),'on')
p2=plot(durT_sws, [1:1:length(durT_sws)],'-o','MarkerSize',5,'MarkerFaceColor',[0 .447 .741]);
p2.Color=[0 .447 .741];
set(gca,'Ydir','reverse')
set(gca,'Xcolor',[0 .447 .741])
xlabel('NREM duration (min)')
set(gca,'FontSize',12)

set(gcf,'color',[1 1 1])


subplot(5,2,[2,4,6,8])
p1=plot(durT_rem, [1:1:length(durT_rem)],'-o','MarkerSize',5,'MarkerFaceColor',[.85 .3250 .0980]);
p1.Color=[.85 .3250 .0980];
set(gca,'Ydir','reverse')
set(gca,'Xcolor',[.85 .3250 .0980])

xlabel('REM duration (min)')
ylabel('# Sleep cycles')
set(gca,'FontSize',12)

hAx(1) = gca;
hAx(2) = axes('Position',hAx(1).Position,'XAxisLocation','top','YAxisLocation','right','color','none')
hold(hAx(2),'on')
p2=plot(dur_cycle, [1:1:length(dur_cycle)],'-o','MarkerSize',5,'MarkerFaceColor',[0 .447 .741]);
p2.Color=[0 .447 .741];
set(gca,'Ydir','reverse')
set(gca,'Xcolor',[0 .447 .741])
xlabel('Sleep cycle duration (min)')
set(gca,'FontSize',12)

set(gcf,'color',[1 1 1])



subplot(5,2,9)
s1 = plot(durT_rem, durT_sws,'ko')
set(s1,'MarkerSize',6,'Linewidth',2);
hold on
l=lsline;
ylabel('NREM duration (min)')
xlabel('REM duration (min)')
set(gca,'FontSize',12)
set(gcf,'color',[1 1 1])

subplot(5,2,10)
s1 = plot(durT_rem, dur_cycle,'ko')
set(s1,'MarkerSize',6,'Linewidth',2);
hold on
l=lsline;
ylabel('Sleep cycle duration (min)')
xlabel('REM duration (min)')
set(gca,'FontSize',12)
set(gcf,'color',[1 1 1])


%%

figure, hold on
line([Start(Wake)/3600e4 Stop(Wake)/3600e4]',[Start(Wake)/3600e4 Stop(Wake)/3600e4]'*0+i+0.2,'color','k','linewidth',10)
line([Start(SWSEpoch)/3600e4 Stop(SWSEpoch)/3600e4]',[Start(SWSEpoch)/3600e4 Stop(SWSEpoch)/3600e4]'*0+i+0.2,'color','b','linewidth',10)
line([Start(REMEpoch)/3600e4 Stop(REMEpoch)/3600e4]',[Start(REMEpoch)/3600e4 Stop(REMEpoch)/3600e4]'*0+i+0.2,'color','r','linewidth',10)

for i=1:length(Start(SleepCycle))
    line([Start(subset(SleepCycle,i))/3600e4 Start(subset(SleepCycle,i))/3600e4],[1 50],'color','k','linewidth',3)
    line([End(subset(SleepCycle,i))/3600e4 End(subset(SleepCycle,i))/3600e4],[1 50],'color','g','linewidth',1)
end

for i=1:length(Start(SleepCycle))
    line([End(subset(SleepCycle,i))/3600e4 End(subset(SleepCycle,i))/3600e4],[1 50],'color','g','linewidth',1)
end

%%
icycle=20;
line([Stop(subset(SleepCycle,icycle))/3600e4 Stop(subset(SleepCycle,icycle))/3600e4],[1 50],'color','r')
line([Start(subset(SleepCycle,icycle))/3600e4 Start(subset(SleepCycle,icycle))/3600e4],[1 50],'color','r')