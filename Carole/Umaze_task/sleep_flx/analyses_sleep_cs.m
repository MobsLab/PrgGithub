    clear all

mice=[875,876,877];
mice_no_d2=[877];
%
Path_baseline=[{'/media/nas4/ProjetEmbReact/Mouse875/20190411'},...
    {'/media/nas4/ProjetEmbReact/Mouse876/20190411'},...
    {'/media/nas4/ProjetEmbReact/Mouse877/20190417'}];
%
Path_d2=[{'/media/nas4/ProjetEmbReact/Mouse875/20190514'},...
    {'/media/nas4/ProjetEmbReact/Mouse876/20190507'}];
%
Path_d4_5=[{'/media/nas4/ProjetEmbReact/Mouse875/20190516'},...
    {'/media/nas4/ProjetEmbReact/Mouse876/20190509'},...
    {'/media/nas4/ProjetEmbReact/Mouse877/20190513'}];
%
Path_d11_12=[{'/media/nas4/ProjetEmbReact/Mouse875/20190523'},...
    {'/media/nas4/ProjetEmbReact/Mouse876/20190516'},...
    {'/media/nas4/ProjetEmbReact/Mouse877/20190520'}];
%
Path_d18_19=[{'/media/nas4/ProjetEmbReact/Mouse875/20190530'},...
    {'/media/nas4/ProjetEmbReact/Mouse876/20190523'},...
    {'/media/nas4/ProjetEmbReact/Mouse877/20190527'}];
Mat_rem=NaN(length(mice),29);
Mat_sws=NaN(length(mice),29);
Mat_N1=NaN(length(mice),29);
Mat_N2=NaN(length(mice),29);
Mat_N3=NaN(length(mice),29);
Mat_tot_sleep=[];
REM_only=[];


%% baseline
for i=1:length(mice)
    cd(Path_baseline{i});
    load('SleepSubstages.mat')
    percent_N1=(sum(Stop(Epoch{1})-Start(Epoch{1})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    percent_N2=(sum(Stop(Epoch{2})-Start(Epoch{2})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    percent_N3=(sum(Stop(Epoch{3})-Start(Epoch{3})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    percent_sws=(sum(Stop(Epoch{7})-Start(Epoch{7})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    percent_rem=(sum(Stop(Epoch{4})-Start(Epoch{4})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    time_tot_sleep=sum(Stop(Epoch{10})-Start(Epoch{10}));
    Mat_rem(i,4)=percent_rem;
    Mat_sws(i,5)=percent_sws;
    Mat_N1(i,1)=percent_N1;
    Mat_N2(i,2)=percent_N2;
    Mat_N3(i,3)=percent_N3;
    Mat_tot_sleep(i,1)=time_tot_sleep;
    REM_only(i,1)=percent_rem;
end
 %% d2
for i=1:length(mice)
    if ismember(mice(i),mice_no_d2)
        Mat_tot_sleep(i,2)=NaN;
        REM_only(i,2)=NaN;
    else
    cd(Path_d2{i});
    load('SleepSubstages.mat')
    percent_N1=(sum(Stop(Epoch{1})-Start(Epoch{1})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    percent_N2=(sum(Stop(Epoch{2})-Start(Epoch{2})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    percent_N3=(sum(Stop(Epoch{3})-Start(Epoch{3})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    percent_sws=(sum(Stop(Epoch{7})-Start(Epoch{7})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    percent_rem=(sum(Stop(Epoch{4})-Start(Epoch{4})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    time_tot_sleep=sum(Stop(Epoch{10})-Start(Epoch{10}));
    Mat_rem(i,10)=percent_rem;
    Mat_sws(i,11)=percent_sws;
    Mat_N1(i,7)=percent_N1;
    Mat_N2(i,8)=percent_N2;
    Mat_N3(i,9)=percent_N3;
    Mat_tot_sleep(i,2)=time_tot_sleep;
    REM_only(i,2)=percent_rem;
    end   
end
%% d4-5
for i=1:length(mice)
    cd(Path_d4_5{i});
    load('SleepSubstages.mat')
    percent_N1=(sum(Stop(Epoch{1})-Start(Epoch{1})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    percent_N2=(sum(Stop(Epoch{2})-Start(Epoch{2})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    percent_N3=(sum(Stop(Epoch{3})-Start(Epoch{3})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    percent_sws=(sum(Stop(Epoch{7})-Start(Epoch{7})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    percent_rem=(sum(Stop(Epoch{4})-Start(Epoch{4})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    time_tot_sleep=sum(Stop(Epoch{10})-Start(Epoch{10}));
    Mat_rem(i,16)=percent_rem;
    Mat_sws(i,17)=percent_sws;
    Mat_N1(i,13)=percent_N1;
    Mat_N2(i,14)=percent_N2;
    Mat_N3(i,15)=percent_N3;
    Mat_tot_sleep(i,3)=time_tot_sleep;
    REM_only(i,3)=percent_rem;
  
end
%% d11-12
for i=1:length(mice)
    cd(Path_d11_12{i});
    load('SleepSubstages.mat')
    percent_N1=(sum(Stop(Epoch{1})-Start(Epoch{1})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    percent_N2=(sum(Stop(Epoch{2})-Start(Epoch{2})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    percent_N3=(sum(Stop(Epoch{3})-Start(Epoch{3})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    percent_sws=(sum(Stop(Epoch{7})-Start(Epoch{7})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    percent_rem=(sum(Stop(Epoch{4})-Start(Epoch{4})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    time_tot_sleep=sum(Stop(Epoch{10})-Start(Epoch{10}));
    Mat_rem(i,22)=percent_rem;
    Mat_sws(i,23)=percent_sws;
    Mat_N1(i,19)=percent_N1;
    Mat_N2(i,20)=percent_N2;
    Mat_N3(i,21)=percent_N3;
    Mat_tot_sleep(i,4)=time_tot_sleep;
    REM_only(i,4)=percent_rem;

end
%% d18-19
for i=1:length(mice)
    cd(Path_d18_19{i});
    load('SleepSubstages.mat')
    percent_N1=(sum(Stop(Epoch{1})-Start(Epoch{1})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    percent_N2=(sum(Stop(Epoch{2})-Start(Epoch{2})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    percent_N3=(sum(Stop(Epoch{3})-Start(Epoch{3})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    percent_sws=(sum(Stop(Epoch{7})-Start(Epoch{7})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    percent_rem=(sum(Stop(Epoch{4})-Start(Epoch{4})))/(sum(Stop(Epoch{10})-Start(Epoch{10})));
    time_tot_sleep=sum(Stop(Epoch{10})-Start(Epoch{10}));
    Mat_rem(i,28)=percent_rem;
    Mat_sws(i,29)=percent_sws;
    Mat_N1(i,25)=percent_N1;
    Mat_N2(i,26)=percent_N2;
    Mat_N3(i,27)=percent_N3;
    Mat_tot_sleep(i,5)=time_tot_sleep;
    REM_only(i,5)=percent_rem;

end

%% figure

% %% quantity of sleep
% PlotErrorBarN_KJ(Mat_tot_sleep/10000, 'newfig', 1);
% set(gca,'xticklabel',{'','Base+sal','Flx-D2','Flx-D5','Flx-D12','Flx-D19'});
% ylabel('s');
% title('total quantity of sleep');
% annotation('textbox',[.50 0 .2 .06], 'String', strcat(['Figure created with analyses_sleep_cs.m']), 'FitBoxToText','on','EdgeColor','none','FontAngle','italic')
% %/!\ pas bon car certains enregistrements sont plus longs que d'autres
%% %of rem
PlotErrorBarN_KJ(REM_only(2:3,:)*100, 'newfig', 1);
plot([1,2,3,4,5],REM_only(1,:)*100,'mo--')
hold on
xticklabels({'Baseline','Day2','Day5','Day12','Day19'})
xticks([1:5])
ylabel('% of REM during sleep');
annotation('textbox',[.50 0 .2 .06], 'String', strcat(['Figure created with analyses_sleep_cs.m']), 'FitBoxToText','on','EdgeColor','none','FontAngle','italic')
figure
plot([1,2,3,4,5],REM_only(1,:)*100,'ko--','linewidth',2)
hold on
plot([1,2,3,4,5],REM_only(2,:)*100,'o-','color',[0.6 0.4 0.6],'linewidth',2)
plot([1,3,4,5],REM_only(3,[1,3,4,5])*100,'o-','color',[0.6 0.4 0.6],'linewidth',2)

%% percentage of each state

figure
line([-1 0],[-1 0],'color',[0 1 0],'linewidth',4);
line([-1 0],[-1 0],'color',[0 0.7 0],'linewidth',4);
line([-1 0],[-1 0],'color',[0 0.3 0],'linewidth',4);
line([-1 0],[-1 0],'color',[1 0 0],'linewidth',4);
line([-1 0],[-1 0],'color',[0 0 1],'linewidth',4);

PlotErrorBar_Arch_CS(Mat_N1(2:3,:), 'newfig', 0,'barcolors',[0 1 0]);
PlotErrorBar_Arch_CS(Mat_N2(2:3,:), 'newfig', 0,'barcolors',[0 0.7 0]);
PlotErrorBar_Arch_CS(Mat_N3(2:3,:), 'newfig', 0,'barcolors',[0 0.3 0]);
PlotErrorBar_Arch_CS(Mat_rem(2:3,:), 'newfig', 0,'barcolors',[1 0 0]);
PlotErrorBar_Arch_CS(Mat_sws(2:3,:), 'newfig', 0,'barcolors',[0 0 1]);


set(gca,'xticklabel',{'','Baseline','D2','D5','D12','D19'});
title('% of each state');
legend({'N1','N2','N3','REM','SWS'},'Location','northwest');
	annotation('textbox',[.50 0 .2 .06], 'String', strcat(['Figure created with analyses_sleep_cs.m']), 'FitBoxToText','on','EdgeColor','none','FontAngle','italic')
