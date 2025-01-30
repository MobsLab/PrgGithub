clear all
%just change titles and channels if you want bulb instead of pfc
Mice_arch=[915,916,917,918];
Mice_cherry=[919,920];
%%
Mat_freeze_laserON_arch=[];
Mat_freeze_laserOFF_arch=[];
Mat_active_laserON_arch=[];
Mat_active_laserOFF_arch=[];
Mat_freeze_laserON_cherry=[];
Mat_freeze_laserOFF_cherry=[];
Mat_active_laserON_cherry=[];
Mat_active_laserOFF_cherry=[];
%% matrice arch
for i=1:length(Mice_arch)
    mouse_num=Mice_arch(i);
    path=strcat('/media/gruffalo/09E7077B1FE07CCB/ARCHT/ArchT/', num2str(mouse_num), '/test');
    cd(path)
    load('ExpeInfo.mat');
    load('behavResources.mat');
    load('Epoch.mat');
    
    %get the 4 interesting epoch :
    freeze_laser = and(Epoch.LaserON,Epoch.FreezeAcc);
    freeze_non_laser = and(Epoch.LaserOFF,Epoch.FreezeAcc);
    active_laser = and(Epoch.LaserON,Epoch.Non_FreezeAcc);
    active_non_laser = and(Epoch.LaserOFF,Epoch.Non_FreezeAcc);

    %get the spectro
    channel_pfc=ExpeInfo.ChannelToAnalyse.PFCx_deep; % change this line to Bulb_deep if you want bulb
    load(['LFPData/LFP',num2str(channel_pfc),'.mat']);
    [Sp_pfc,t_pfc,f_pfc]=LoadSpectrumML(channel_pfc,pwd,'low');
    Spectsd_pfc = tsd(t_pfc*1e4,log(Sp_pfc));
    
    Mat_active_laserON_arch(i,:)=mean(Data(Restrict(Spectsd_pfc,active_laser)));
    Mat_active_laserOFF_arch(i,:)=mean(Data(Restrict(Spectsd_pfc,active_non_laser)));
    Mat_freeze_laserON_arch(i,:)=mean(Data(Restrict(Spectsd_pfc,freeze_laser)));
    Mat_freeze_laserOFF_arch(i,:)=mean(Data(Restrict(Spectsd_pfc,freeze_non_laser)));
end

%% matrice cherry
for i=1:length(Mice_cherry)
    mouse_num=Mice_cherry(i);
    path=strcat('/media/gruffalo/09E7077B1FE07CCB/ARCHT/ArchT/', num2str(mouse_num), '/test');
    cd(path)
    load('ExpeInfo.mat');
    load('behavResources.mat');
    load('Epoch.mat');
    
    %get the 4 interesting epoch :
    freeze_laser = and(Epoch.LaserON,Epoch.FreezeAcc);
    freeze_non_laser = and(Epoch.LaserOFF,Epoch.FreezeAcc);
    active_laser = and(Epoch.LaserON,Epoch.Non_FreezeAcc);
    active_non_laser = and(Epoch.LaserOFF,Epoch.Non_FreezeAcc);

    %get the spectro
    channel_pfc=ExpeInfo.ChannelToAnalyse.PFCx_deep; % change this line to Bulb_deep if you want bulb
    load(['LFPData/LFP',num2str(channel_pfc),'.mat']);
    [Sp_pfc,t_pfc,f_pfc]=LoadSpectrumML(channel_pfc,pwd,'low');
    Spectsd_pfc = tsd(t_pfc*1e4,log(Sp_pfc));
    
    Mat_active_laserON_cherry(i,:)=mean(Data(Restrict(Spectsd_pfc,active_laser)));
    Mat_active_laserOFF_cherry(i,:)=mean(Data(Restrict(Spectsd_pfc,active_non_laser)));
    Mat_freeze_laserON_cherry(i,:)=mean(Data(Restrict(Spectsd_pfc,freeze_laser)));
    Mat_freeze_laserOFF_cherry(i,:)=mean(Data(Restrict(Spectsd_pfc,freeze_non_laser)));
end

%% Norm
    

for i=1:length(Mice_arch)
    
    Mat_active_laserON_arch(i,:)=Mat_active_laserON_arch(i,:)./(sum(Mat_active_laserON_arch(i,1:end)));
    Mat_freeze_laserON_arch(i,:)=Mat_freeze_laserON_arch(i,:)./(sum(Mat_freeze_laserON_arch(i,1:end)));
    Mat_active_laserOFF_arch(i,:)=Mat_active_laserOFF_arch(i,:)./(sum(Mat_active_laserOFF_arch(i,1:end)));
    Mat_freeze_laserOFF_arch(i,:)=Mat_freeze_laserOFF_arch(i,:)./(sum(Mat_freeze_laserOFF_arch(i,1:end)));

end

for i=1:length(Mice_cherry)
    
    Mat_active_laserON_cherry(i,:)=Mat_active_laserON_cherry(i,:)./(sum(Mat_active_laserON_cherry(i,1:end)));
    Mat_freeze_laserON_cherry(i,:)=Mat_freeze_laserON_cherry(i,:)./(sum(Mat_freeze_laserON_cherry(i,1:end)));
    Mat_active_laserOFF_cherry(i,:)=Mat_active_laserOFF_cherry(i,:)./(sum(Mat_active_laserOFF_cherry(i,1:end)));
    Mat_freeze_laserOFF_cherry(i,:)=Mat_freeze_laserOFF_cherry(i,:)./(sum(Mat_freeze_laserOFF_cherry(i,1:end)));

end

%% FIGURE 

figure
%arch
subplot(1,2,1)
line([-1 0],[-1 0],'color',[0,0.3,0],'linewidth',4), hold on
line([-1 0],[-1 0],'color',[0,0,0],'linewidth',4)
line([-1 0],[-1 0],'color',[0.71,0,0],'linewidth',4)
line([-1 0],[-1 0],'color',[0,0,1],'linewidth',4)

g=shadedErrorBar(f_pfc,nanmean(Mat_active_laserON_arch),stdError(Mat_active_laserON_arch));
hold on
set(g.patch,'FaceColor',[0.4,1,0.4],'FaceAlpha',0.5)
set(g.mainLine,'Color',[0,0.3,0],'linewidth',2)
g=shadedErrorBar(f_pfc,nanmean(Mat_active_laserOFF_arch),stdError(Mat_active_laserOFF_arch));
hold on
set(g.patch,'FaceColor',[0.56,0.56,0.56],'FaceAlpha',0.3)
set(g.mainLine,'Color',[0,0,0],'linewidth',2)

g=shadedErrorBar(f_pfc,nanmean(Mat_freeze_laserON_arch),stdError(Mat_freeze_laserON_arch));
hold on
set(g.patch,'FaceColor',[1,0.35,0.71],'FaceAlpha',0.5)
set(g.mainLine,'Color',[0.71,0,0],'linewidth',2)
g=shadedErrorBar(f_pfc,nanmean(Mat_freeze_laserOFF_arch),stdError(Mat_freeze_laserOFF_arch));
hold on
set(g.patch,'FaceColor',[0,0.7,1],'FaceAlpha',0.3)
set(g.mainLine,'Color',[0,0,1],'linewidth',2)

ylim([0.003 0.006])
xlim([0 15])

%legend('active laserON','active laserOFF', 'freezing laserON', 'freezing laserOFF')
ylabel('Power')
xlabel('Frequency(Hz)')
title('ArchT') %change title if you want bulb


subplot(1,2,2)
%cherry
line([-1 0],[-1 0],'color',[0,0.3,0],'linewidth',4), hold on
line([-1 0],[-1 0],'color',[0,0,0],'linewidth',4)
line([-1 0],[-1 0],'color',[0.71,0,0],'linewidth',4)
line([-1 0],[-1 0],'color',[0,0,1],'linewidth',4)

g=shadedErrorBar(f_pfc,nanmean(Mat_active_laserON_cherry),stdError(Mat_active_laserON_cherry));
hold on
set(g.patch,'FaceColor',[0.4,1,0.4],'FaceAlpha',0.5)
set(g.mainLine,'Color',[0,0.3,0],'linewidth',2)
g=shadedErrorBar(f_pfc,nanmean(Mat_active_laserOFF_cherry),stdError(Mat_active_laserOFF_cherry));
hold on
set(g.patch,'FaceColor',[0.56,0.56,0.56],'FaceAlpha',0.3)
set(g.mainLine,'Color',[0,0,0],'linewidth',2)

g=shadedErrorBar(f_pfc,nanmean(Mat_freeze_laserON_cherry),stdError(Mat_freeze_laserON_cherry));
hold on
set(g.patch,'FaceColor',[1,0.35,0.71],'FaceAlpha',0.5)
set(g.mainLine,'Color',[0.71,0,0],'linewidth',2)
g=shadedErrorBar(f_pfc,nanmean(Mat_freeze_laserOFF_cherry),stdError(Mat_freeze_laserOFF_cherry));
hold on
set(g.patch,'FaceColor',[0,0.7,1],'FaceAlpha',0.3)
set(g.mainLine,'Color',[0,0,1],'linewidth',2)

ylim([0.003 0.006])
xlim([0 15])

legend('active laserON','active laserOFF', 'freezing laserON', 'freezing laserOFF')
ylabel('Power')
xlabel('Frequency(Hz)')
title('mCherry') %change title if you want bulb