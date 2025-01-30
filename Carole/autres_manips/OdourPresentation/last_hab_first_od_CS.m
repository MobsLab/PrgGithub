clear all
close all
Mice=[777, 779, 796, 829, 849, 850, 851];
Colors='bkrgycm';
trials=[1 2 3 4 5 6];

%% initialisation matrice
Mov_Explo_max_min_Lhab_Fod=zeros(length(Mice),7);
Speed_Explo_max_min_Lhab_Fod=zeros(length(Mice),7);
% 
% Mat_all_trial=zeros(length(Mice),2);

%% load en fonction de la contition
% loads the LFP
for k=1:length(Mice)
mouse_num=Mice(k);
if ismember(mouse_num, [777, 849, 850, 851])
    day_hab=20190221;
    day_od=20190222;
else
    day_hab=20190306;
    day_od=20190307;
end

path_hab=strcat('/media/mobschapeau/2D373EF5372BA96B/Mouse', num2str(mouse_num), '/', num2str(day_hab));
path_od=strcat('/media/mobschapeau/2D373EF5372BA96B/Mouse', num2str(mouse_num), '/', num2str(day_od));
%% baseline, avant dernier essai et apres dernier essai, habituation
%load
cd(path_hab);
% find odor onset
load('ExpeInfo.mat');
OdorOnChannel = find(~cellfun(@isempty,strfind(ExpeInfo.DigID,'OdorON')));
load(['LFPData/DigInfo',num2str(OdorOnChannel),'.mat']);
ONEpoch = thresholdIntervals(DigTSD,0.9,'Direction','Above');
ONTTL = Start(ONEpoch);
% find odor offset
OdorOffChannel = find(~cellfun(@isempty,strfind(ExpeInfo.DigID,'OdorOFF')));
load(['LFPData/DigInfo',num2str(OdorOffChannel),'.mat']);
OFFEpoch = thresholdIntervals(DigTSD,0.9,'Direction','Above');
OFFTTL = Start(OFFEpoch);
load('behavResources.mat');

%% 30 sec before and after
debut_explo=[0*1e4];
fin_explo=[30*1e4];
OdorEpoch = intervalSet(ONTTL,ONTTL+30*1e4);
NoOdorEpoch = intervalSet(ONTTL-30*1e4,ONTTL);
ExploEpoch = intervalSet(debut_explo, fin_explo);

% baseline
explo_mov=mean(Data(Restrict(MovAcctsd,subset(ExploEpoch,1))));
explo_speed=mean(Data(Restrict(Vtsd,subset(ExploEpoch,1))));

%bef_Lhab
before_Lhab_mov=mean(Data(Restrict(MovAcctsd,subset(NoOdorEpoch,length(trials)))));
before_Lhab_speed=mean(Data(Restrict(Vtsd,subset(NoOdorEpoch,length(trials)))));

%after_Lhab
after_Lhab_mov=mean(Data(Restrict(MovAcctsd,subset(OdorEpoch,length(trials)))));
after_Lhab_speed=mean(Data(Restrict(Vtsd,subset(OdorEpoch,length(trials)))));

%remplis les matrices
Mov_Explo_max_min_Lhab_Fod(k,1)=explo_mov;
Mov_Explo_max_min_Lhab_Fod(k,4)=before_Lhab_mov;
Mov_Explo_max_min_Lhab_Fod(k,5)=after_Lhab_mov;

Speed_Explo_max_min_Lhab_Fod(k,1)=explo_speed;
Speed_Explo_max_min_Lhab_Fod(k,4)=before_Lhab_speed;
Speed_Explo_max_min_Lhab_Fod(k,5)=after_Lhab_speed;

%% max and min
debut=0:1170;
Epoch_trente=intervalSet(debut*1e4, debut*1e4+30*1e4);
means_speed=[];
means_mov=[];
    for i=1:length(debut)
        means_mov=[means_mov mean(Data(Restrict(MovAcctsd,subset(Epoch_trente,i))))];
        means_speed=[means_speed mean(Data(Restrict(Vtsd,subset(Epoch_trente,i))))];
    end
max_mov_hab=max(means_mov);
max_speed_hab=max(means_speed);
min_mov_hab=min(means_mov);
min_speed_hab=min(means_speed);

%% avant premier essai et apres premier essai, odeur

cd(path_od);
% find odor onset
load('ExpeInfo.mat');
OdorOnChannel = find(~cellfun(@isempty,strfind(ExpeInfo.DigID,'OdorON')));
load(['LFPData/DigInfo',num2str(OdorOnChannel),'.mat']);
ONEpoch = thresholdIntervals(DigTSD,0.9,'Direction','Above');
ONTTL = Start(ONEpoch);
% find odor offset
OdorOffChannel = find(~cellfun(@isempty,strfind(ExpeInfo.DigID,'OdorOFF')));
load(['LFPData/DigInfo',num2str(OdorOffChannel),'.mat']);
OFFEpoch = thresholdIntervals(DigTSD,0.9,'Direction','Above');
OFFTTL = Start(OFFEpoch);
load('behavResources.mat');

%% 30 sec before and after
OdorEpoch = intervalSet(ONTTL,ONTTL+30*1e4);
NoOdorEpoch = intervalSet(ONTTL-30*1e4,ONTTL);

%bef_Fod
before_Fod_mov=mean(Data(Restrict(MovAcctsd,subset(NoOdorEpoch,1))));
before_Fod_speed=mean(Data(Restrict(Vtsd,subset(NoOdorEpoch,1))));

%after_Fod
after_Fod_mov=mean(Data(Restrict(MovAcctsd,subset(OdorEpoch,1))));
after_Fod_speed=mean(Data(Restrict(Vtsd,subset(OdorEpoch,1))));

%remplis les matrices
Mov_Explo_max_min_Lhab_Fod(k,6)=before_Fod_mov;
Mov_Explo_max_min_Lhab_Fod(k,7)=after_Fod_mov;

Speed_Explo_max_min_Lhab_Fod(k,6)=before_Fod_speed;
Speed_Explo_max_min_Lhab_Fod(k,7)=after_Fod_speed;

%% max and min
debut=0:1170;
Epoch_trente=intervalSet(debut*1e4, debut*1e4+30*1e4);
means_speed=[];
means_mov=[];
    for i=1:length(debut)
        means_mov=[means_mov mean(Data(Restrict(MovAcctsd,subset(Epoch_trente,i))))];
        means_speed=[means_speed mean(Data(Restrict(Vtsd,subset(Epoch_trente,i))))];
    end
max_mov_od=max(means_mov);
max_speed_od=max(means_speed);
min_mov_od=min(means_mov);
min_speed_od=min(means_speed);

Mov_Explo_max_min_Lhab_Fod(k,2)=max(max_mov_hab,max_mov_od);
Mov_Explo_max_min_Lhab_Fod(k,3)=min(min_mov_hab, min_mov_od);
 
Speed_Explo_max_min_Lhab_Fod(k,2)=max(max_speed_hab,max_speed_od);
Speed_Explo_max_min_Lhab_Fod(k,3)=min(min_speed_hab,min_speed_od);
end
%% error bar
supertit = 'Movement';
figure('Color',[1 1 1], 'rend','painters','pos',[10 10 700 700],'Name',supertit, 'NumberTitle','off')
    si = 0;
subplot(1,2,1);
PlotErrorBar_mov_odor_CS(Mov_Explo_max_min_Lhab_Fod(:,4:5), 'newfig',0);
ylim([0 max(Mov_Explo_max_min_Lhab_Fod(:,2))])
set(gca,'xticklabel',{'','before','during',''});
for k=1:length(Mice)
hline(Mov_Explo_max_min_Lhab_Fod(k,2),Colors(k));
hline(Mov_Explo_max_min_Lhab_Fod(k,3),Colors(k));
end
title('last trial of hab');

subplot(1,2,2);
PlotErrorBar_mov_odor_CS(Mov_Explo_max_min_Lhab_Fod(:,6:7), 'newfig',0);
ylim([0 max(Mov_Explo_max_min_Lhab_Fod(:,2))])
set(gca,'xticklabel',{'','before','during',''});
for k=1:length(Mice)
hline(Mov_Explo_max_min_Lhab_Fod(k,2),Colors(k));
hline(Mov_Explo_max_min_Lhab_Fod(k,3),Colors(k));
end
title('first trial of od');
mtit(supertit, 'fontsize',14, 'xoff', 0, 'yoff', 0.03);

supertit = 'Speed';
figure('Color',[1 1 1], 'rend','painters','pos',[10 10 700 700],'Name',supertit, 'NumberTitle','off')
    si = 0;
subplot(1,2,1);
PlotErrorBar_mov_odor_CS(Speed_Explo_max_min_Lhab_Fod(:,4:5), 'newfig',0);
ylim([0 max(Speed_Explo_max_min_Lhab_Fod(:,2))])
set(gca,'xticklabel',{'','before','during',''});
for k=1:length(Mice)
hline(Speed_Explo_max_min_Lhab_Fod(k,2),Colors(k));
hline(Speed_Explo_max_min_Lhab_Fod(k,3),Colors(k));
end
title('last trial of hab');
subplot(1,2,2);
PlotErrorBar_mov_odor_CS(Speed_Explo_max_min_Lhab_Fod(:,6:7), 'newfig',0);
ylim([0 max(Speed_Explo_max_min_Lhab_Fod(:,2))])
set(gca,'xticklabel',{'','before','during',''});
for k=1:length(Mice)
hline(Speed_Explo_max_min_Lhab_Fod(k,2),Colors(k));
hline(Speed_Explo_max_min_Lhab_Fod(k,3),Colors(k));
end
title('first trial of od');
mtit(supertit, 'fontsize',14, 'xoff', 0, 'yoff', 0.03);
