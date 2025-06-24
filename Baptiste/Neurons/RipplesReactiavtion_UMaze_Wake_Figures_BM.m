

% run RipplesReactivation_UMaze_DataAnalysis_BM
% or
load('/media/nas7/ProjetEmbReact/DataEmbReact/RipplesReactivation_FzMaze.mat')


figure
MakeSpreadAndBoxPlot3_SB({AllComp_Shock_rip./nanmedian(AllComp_Shock_ctrl) AllComp_Safe_rip./nanmedian(AllComp_Safe_ctrl)},{[1 .5 .5],[.5 .5 1]},[1 2],{'Shock','Safe'},'showpoints',0,'paired',1)
ylabel('Activation strength'), set(gca,'YScale','log')
makepretty_BM2

figure
MakeSpreadAndBoxPlot3_SB({AllComp_Shock_ctrl./nanmedian(AllComp_Shock_ctrl) AllComp_Safe_ctrl./nanmedian(AllComp_Safe_ctrl)},{[1 .5 .5],[.5 .5 1]},[1 2],{'Shock','Safe'},'showpoints',0,'paired',1)
ylabel('Activation strength'), set(gca,'YScale','log')
makepretty_BM2








%%
% choosssse if you want to study PFC or HPC reactivations
PFC=0;

if PFC
    l=[-.5 3 0 3 2 2.5 -.15 .15 -.2 .2 -.1 1.3];
else
    l=[-.5 8 0 15 13 14 -.15 .3 -.15 .6 -1 8];
end



%% Sanity check on firing rate
for i=51:53
    Spike_density_stim(:,i) = nanmedian([Spike_density_stim(:,50) Spike_density_stim(:,54)]');
end

figure
Data_to_use = Spike_density_stim;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(-5,5,length(Spike_density_stim)) , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-r',1); hold on;

Data_to_use = Spike_density_rip;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(-5,5,length(Spike_density_rip)) , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-g',1); hold on;

Data_to_use = Spike_density_rand;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(-5,5,length(Spike_density_rand)) , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;

Data_to_use = Spike_density_rip_SleepPre;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(-5,5,length(Spike_density_rand)) , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-m',1); hold on;


f=get(gca,'Children'); legend([f([13 9 5 1])],'Around stim','Around rip','Around rand','Around rip sleep pre');
xlabel('Time from aversive stimulation (s)'), ylabel('Firing rate (zscore)'), xlim([-3 3]), 
vline(0,'--k')
makepretty



%% 1 window, 2 template : pre ripples & ripples
AllTriggeredStim{9}(AllTriggeredStim{9}==0)=NaN;
AllTriggeredStim{10}(AllTriggeredStim{10}==0)=NaN;

AllTriggeredStim{9}(std(AllTriggeredStim{9}(:,1:40)')<.2,:)=NaN;
AllTriggeredStim{10}(std(AllTriggeredStim{10}(:,1:40)')<.2,:)=NaN;
AllTriggeredStim{9} = real(AllTriggeredStim{9});
AllTriggeredStim{10} = real(AllTriggeredStim{10});


figure
subplot(2,7,1:4)

a=area([-5 0],[8 8]); 
a.BaseValue=-.5; 
a.FaceColor=[.3 .3 .3];
a.FaceAlpha=.15;  
a.EdgeColor=[1 1 1];

hold on
 
a=area([0 1.5],[8 8]); 
a.BaseValue=-.5; 
a.FaceColor=[.1 .1 .1];
a.FaceAlpha=.15;  
a.EdgeColor=[1 1 1]; 

Data_to_use = AllTriggeredStim{10};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-5,5,101*30) , runmean(resample(Mean_All_Sp,30,1),30) , runmean(resample(Conf_Inter,30,1),30) ,'-k',1); hold on;
color= [.6 .1 .2]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;

Data_to_use = AllTriggeredStim{9};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-5,5,101*30) , runmean(resample(Mean_All_Sp,30,1),30) , runmean(resample(Conf_Inter,30,1),30) ,'-k',1); hold on;
color= [.47 .67 .19]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;

vline(0,'--k')
xlabel('Time from aversive stimulation (s)'), ylabel('Reactivation strength'), xlim([-3 3]), ylim([l(1) l(2)])
makepretty
f=get(gca,'Children'); legend([f([5 1])],'Control template','Ripples template');
li=ylim;
text(-1.5,li(2)+.1,'Pre','FontSize',20), text(.5,li(2)+.1,'Post','FontSize',20)


subplot(276)
A=nanmean(AllTriggeredStim{10}(:,1:40)'); %A(11)=NaN;
B=nanmean(AllTriggeredStim{10}(:,50:60)'); %B(11)=NaN;
MakeSpreadAndBoxPlot_BM({A,B},{[.9 .4 .5],[.6 .1 .2]},[1,2],{'Pre','Post'},0,1)
ylim([l(3) l(4)]), ylabel('Reactivation strength')
makepretty_BM2

lim=l(5);
plot([1 2],[lim lim],'-k','LineWidth',1.5);
text(1.5,l(6),'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);

% set(gca,'YScale','log')

[p,~,~]=signrank(A,B)


subplot(277)
A=nanmean(AllTriggeredStim{9}(:,1:30)'); %A(14)=NaN;
B=nanmean(AllTriggeredStim{9}(:,50:60)'); %B(14)=NaN;
MakeSpreadAndBoxPlot_BM({A,B},{[.77 .97 .49],[.47 .67 .19]},[1,2],{'Pre','Post'},0,1)
ylim([l(3) l(4)])
makepretty_BM2

lim=l(5);
plot([1 2],[lim lim],'-k','LineWidth',1.5);
text(1.5,l(6),'**','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);

% set(gca,'YScale','log')

[p,~,~]=signrank(A,B)



subplot(2,7,8:11)
Data_to_use = Spike_density_stim;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(-5,5,length(Spike_density_stim)) , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;
xlabel('Time from aversive stimulation (s)'), ylabel('Firing rate (zscore)'), xlim([-3 3]), ylim([l(7) l(8)])
vline(0,'--k')
makepretty


Spike_density_rip_epoch(Spike_density_rip_epoch==0)=NaN;
Spike_density_ctrl_epoch(Spike_density_ctrl_epoch==0)=NaN;


subplot(2,7,13)
MakeSpreadAndBoxPlot_BM({Spike_density_ctrl_epoch , Spike_density_rip_epoch},{[.9 .4 .5],[.77 .97 .49]},[1,2],{'Control template','Ripples template'},0,1)
ylim([l(9) l(10)]), ylabel('Firing rate (zscore)')
makepretty_BM2

[p,~,~]=signrank(Spike_density_rip_epoch,Spike_density_ctrl_epoch)

if ~PFC
    lim=.5;
    plot([1 2],[lim lim],'-k','LineWidth',1.5);
    text(1.5,.55,'**','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
end


%% 1 template, 2 window : rand & stim
AllTriggeredRand{9} = real(AllTriggeredRand{9});

figure
subplot(2,7,1:4)

a=area([-5 0],[8 8]); 
a.BaseValue=-.5; 
a.FaceColor=[.3 .3 .3];
a.FaceAlpha=.15;  
a.EdgeColor=[1 1 1];

hold on
 
a=area([0 1.5],[8 8]); 
a.BaseValue=-.5; 
a.FaceColor=[.1 .1 .1];
a.FaceAlpha=.15;  
a.EdgeColor=[1 1 1]; 

Data_to_use = AllTriggeredRand{9};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-5,5,101*30) , runmean(resample(Mean_All_Sp,30,1),30) , runmean(resample(Conf_Inter,30,1),30) ,'-k',1); hold on;
color= [.6 .1 .2]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;


Data_to_use = AllTriggeredStim{9};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-5,5,101*30) , runmean(resample(Mean_All_Sp,30,1),30) , runmean(resample(Conf_Inter,30,1),30) ,'-k',1); hold on;
color= [.47 .67 .19]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;

vline(0,'--k')
xlabel('Time from events (s)'), ylabel('Reactivation strength'), xlim([-3 3]), ylim([l(1) l(2)])
makepretty
f=get(gca,'Children'); legend([f([5 1])],'Control epoch','Stim epoch');
li=ylim;
text(-1.5,li(2)+.1,'Pre','FontSize',20), text(.5,li(2)+.1,'Post','FontSize',20)


subplot(276)
A=nanmedian(AllTriggeredRand{9}(:,1:40)'); %A(11)=NaN;
B=nanmedian(AllTriggeredRand{9}(:,50:60)'); %B(11)=NaN;
MakeSpreadAndBoxPlot_BM({A,B},{[.9 .4 .5],[.6 .1 .2]},[1,2],{'Pre','Post'},0,1)
ylim([l(3) l(4)]), ylabel('Reactivation strength')
makepretty_BM2

lim=l(5);
plot([1 2],[lim lim],'-k','LineWidth',1.5);
text(1.5,l(6),'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);

[p,~,~]=signrank(A,B)


subplot(277)
A=nanmedian(AllTriggeredStim{9}(:,1:40)'); %A(14)=NaN;
B=nanmedian(AllTriggeredStim{9}(:,50:60)'); %B(14)=NaN;
MakeSpreadAndBoxPlot_BM({A,B},{[.77 .97 .49],[.47 .67 .19]},[1,2],{'Pre','Post'},0,1)
ylim([l(3) l(4)])
makepretty_BM2

lim=l(5);
plot([1 2],[lim lim],'-k','LineWidth',1.5);
text(1.5,l(6),'*','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);

[p,~,~]=signrank(A,B)



subplot(2,7,8:11)
Data_to_use = Spike_density_rand;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-5,5,length(Spike_density_rand)) , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;
color= [.6 .1 .2]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;

Data_to_use = Spike_density_stim;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-5,5,length(Spike_density_stim)) , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;
color= [.47 .67 .19]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;

xlabel('Time from aversive stimulation (s)'), ylabel('Firing rate (zscore)'), xlim([-3 3]), ylim([l(7) l(8)])
vline(0,'--k')
makepretty

f=get(gca,'Children'); legend([f([5 1])],'Control epoch','Stim epoch');


subplot(2,7,13)
MakeSpreadAndBoxPlot_BM({Spike_density_rip_epoch},{[.3 .3 .3]},[1],{'Ripples template'},0,1)
ylim([l(9) l(10)]), ylabel('Firing rate (zscore)')
makepretty_BM2



%% window : around stim, template : wake /sleep pre ripples
figure
subplot(2,7,1:4)

a=area([-5 0],[8 8]); 
a.BaseValue=-.5; 
a.FaceColor=[.3 .3 .3];
a.FaceAlpha=.15;  
a.EdgeColor=[1 1 1];

hold on
 
a=area([0 1.5],[8 8]); 
a.BaseValue=-.5; 
a.FaceColor=[.1 .1 .1];
a.FaceAlpha=.15;  
a.EdgeColor=[1 1 1]; 

Data_to_use = AllTriggeredStim{11};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-5,5,101*30) , runmean(resample(Mean_All_Sp,30,1),30) , runmean(resample(Conf_Inter,30,1),30) ,'-k',1); hold on;
color= [.6 .1 .2]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;

Data_to_use = AllTriggeredStim{9};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-5,5,101*30) , runmean(resample(Mean_All_Sp,30,1),30) , runmean(resample(Conf_Inter,30,1),30) ,'-k',1); hold on;
color= [.47 .67 .19]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;

vline(0,'--k')
xlabel('Time from aversive stimulation (s)'), ylabel('Reactivation strength'), xlim([-3 3]), ylim([l(1) l(2)])
makepretty
f=get(gca,'Children'); legend([f([5 1])],'Control template','Ripples template');
li=ylim;
text(-1.5,li(2)+.1,'Pre','FontSize',20), text(.5,li(2)+.1,'Post','FontSize',20)


subplot(276)
A=nanmedian(AllTriggeredStim{11}(:,1:40)'); %A(11)=NaN;
B=nanmedian(AllTriggeredStim{11}(:,50:60)'); %B(11)=NaN;
MakeSpreadAndBoxPlot_BM({A,B},{[.9 .4 .5],[.6 .1 .2]},[1,2],{'Pre','Post'},0,1)
ylim([l(3) l(4)]), ylabel('Reactivation strength')
makepretty_BM2

lim=l(5);
plot([1 2],[lim lim],'-k','LineWidth',1.5);
text(1.5,l(6),'**','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);

% set(gca,'YScale','log')

[p,~,~]=signrank(A,B)


subplot(277)
A=nanmedian(AllTriggeredStim{9}(:,1:40)'); %A(14)=NaN;
B=nanmedian(AllTriggeredStim{9}(:,50:60)'); %B(14)=NaN;
MakeSpreadAndBoxPlot_BM({A,B},{[.77 .97 .49],[.47 .67 .19]},[1,2],{'Pre','Post'},0,1)
ylim([l(3) l(4)])
makepretty_BM2

lim=l(5);
plot([1 2],[lim lim],'-k','LineWidth',1.5);
text(1.5,l(6),'**','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);

% set(gca,'YScale','log')

[p,~,~]=signrank(A,B)



subplot(2,7,8:11)
Data_to_use = Spike_density_stim;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(-5,5,length(Spike_density_stim)) , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;
xlabel('Time from aversive stimulation (s)'), ylabel('Firing rate (zscore)'), xlim([-3 3]), ylim([l(7) l(8)])
vline(0,'--k')
makepretty


Spike_density_rip_epoch(Spike_density_rip_epoch==0)=NaN;
Spike_density_ctrl_epoch(Spike_density_ctrl_epoch==0)=NaN;


subplot(2,7,13)
MakeSpreadAndBoxPlot_BM({Spike_density_ctrl_epoch , Spike_density_ctrl_epoch_SleepPre},{[.9 .4 .5],[.77 .97 .49]},[1,2],{'Control template','Ripples template'},0,1)
ylim([-.15 .15]), ylabel('Firing rate (zscore)')
makepretty_BM2

[p,~,~]=signrank(Spike_density_rip_epoch,Spike_density_ctrl_epoch_SleepPre)

if ~PFC
    lim=.1;
    plot([1 2],[lim lim],'-k','LineWidth',1.5);
    text(1.5,.12,'**','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
end




%% Position
% binned linpos 1-10
AllCompOnPos = [];
for mm = 1:length(MnReactPos_Mov)
    AllCompOnPos = [AllCompOnPos;MnReactPos_Mov{mm}{9}];
end

for pos = 1:10
    ReactByPos{pos}  = AllCompOnPos(:,pos);
end
figure
errorbar([0.05:0.1:1],nanmean(AllCompOnPos),stdError(AllCompOnPos))
xlabel('Position in maze')
ylabel('React strength from ripples')
makepretty


% shock/safe
AllComp_Shock_rip = [];
AllComp_Safe_rip = [];
AllComp_Shock_ctrl = [];
AllComp_Safe_ctrl = [];
for mm = 1:length(MnReactPos_Mov_Shock)
    AllComp_Shock_rip = [AllComp_Shock_rip;MnReactPos_Mov_Shock{mm}{9}'];
    AllComp_Safe_rip = [AllComp_Safe_rip;MnReactPos_Mov_Safe{mm}{9}'];
    AllComp_Shock_ctrl = [AllComp_Shock_ctrl;MnReactPos_Mov_Shock{mm}{10}'];
    AllComp_Safe_ctrl = [AllComp_Safe_ctrl;MnReactPos_Mov_Safe{mm}{10}'];
end


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({AllComp_Shock_rip AllComp_Safe_rip},{[1 .5 .5],[.5 .5 1]},[1 2],{'Shock','Safe'},'showpoints',0,'paired',1)
ylabel('Reactivation strength'), ylim([l(11) l(12)])
makepretty
title('Ripples epoch')

[p,~,~]=signrank(AllComp_Shock_rip ,AllComp_Safe_rip)

if ~PFC
    lim=7;
    plot([1 2],[lim lim],'-k','LineWidth',1.5);
    text(1.5,7.3,'***','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
else
    lim=1.2;
    plot([1 2],[lim lim],'-k','LineWidth',1.5);
    text(1.5,1.25,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
end

subplot(122)
MakeSpreadAndBoxPlot_BM({AllComp_Shock_ctrl AllComp_Safe_ctrl},{[1 .5 .5],[.5 .5 1]},[1 2],{'Shock','Safe'},0,1)
ylim([l(11) l(12)])
makepretty
title('Pre-ripples epoch')

[p,~,~]=signrank(AllComp_Shock_ctrl ,AllComp_Safe_ctrl)

if ~PFC
    lim=7;
    plot([1 2],[lim lim],'-k','LineWidth',1.5);
    text(1.5,7.3,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
else
    lim=1.2;
    plot([1 2],[lim lim],'-k','LineWidth',1.5);
    text(1.5,1.25,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
end


%% Maze 2D
Maze_2D_Ripples=[]; n=1;
for mm = 1:length(MiceNumber)
    for i=1:size(MnReact2D_Mov{mm}{9},1)
        clear A; A=real(MnReact2D_Mov{mm}{9});
        Maze_2D_Ripples(n,:,:) = squeeze(A(i,:,:));
        n=n+1;
    end
end

Maze_2D_Ctrl=[]; n=1;
for mm = 1:length(MiceNumber)
    for i=1:size(MnReact2D_Mov{mm}{10},1)
        clear A; A=real(MnReact2D_Mov{mm}{10});
        Maze_2D_Ctrl(n,:,:) = squeeze(A(i,:,:));
        n=n+1;
    end
end

for i=1:10
    for ii=1:10
   
        try, [P(i,ii),~,~] = ranksum(Maze_2D_Ripples(:,i,ii) , Maze_2D_Ctrl(:,i,ii)); end
        
    end
end
P(or(P==0 , P==1))=NaN;

figure
ax_to_use = linspace(0,1,10);
A = squeeze(nanmean(Maze_2D_Ripples))'; A(1:8,5:6)=NaN; %A(8,5)=0;
B = squeeze(nanmean(Maze_2D_Ctrl))';  B(1:8,5:6)=NaN; %B(8,5)=0;

subplot(131)
imagesc(ax_to_use , ax_to_use , A)
axis xy, axis off, axis square

subplot(132)
imagesc(ax_to_use , ax_to_use , B)
axis xy, axis off, axis square

subplot(133)
imagesc(ax_to_use , ax_to_use , smooth2a(A-B,1,1))
hold on
[rows1,cols1] = find(P<.05);
% plot(ax_to_use(rows1),ax_to_use(cols1),'*k')
axis xy, axis off, axis square

colormap hot








%% SB figures
figure
subplot(2,2,1)
imagesc(tpsstim,1:size(EpochNames,1),(AllTrigStim))
set(gca,'YTick',1:size(EpochNames,1),'YTickLabel',EpochNames)
clim([-0 1])
xlabel('Time to stims (s)')
set(gca,'FontSize',15,'linewidth',2)
box off

subplot(2,2,2)
imagesc(tpsrip,1:size(EpochNames,1),(AllTrigRip))
set(gca,'YTick',1:size(EpochNames,1),'YTickLabel',EpochNames)
clim([-0 1])
xlabel('Time to ripples (s)')
set(gca,'FontSize',15,'linewidth',2)
box off

subplot(2,2,3)
errorbar(tpsstim,nanmean(AllTriggeredStim{9}),stdError(AllTriggeredStim{9}),'linewidth',2)
hold on
errorbar(tpsstim,nanmean(AllTriggeredStim{10}),stdError(AllTriggeredStim{10}),'linewidth',2)
xlabel('Time to stims (s)')
box off
set(gca,'FontSize',15,'linewidth',2)
legend({'PostRipples','PreRipples'})
ylabel('Mean R')

subplot(2,2,4)
errorbar(tpsrip,nanmean(AllTriggeredRipples{5}),stdError(AllTriggeredRipples{5}),'linewidth',2)
hold on
errorbar(tpsrip,nanmean(AllTriggeredRipples{4}),stdError(AllTriggeredRipples{4}),'linewidth',2)
xlabel('Time to ripples (s)')
box off
set(gca,'FontSize',15,'linewidth',2)
legend({'PostStim','PreStim'})
ylabel('Mean R')




