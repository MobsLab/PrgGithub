clear all
%just change titles and channels if you want bulb instead of pfc
Mice_arch=[915,916,917,918];
Mice_cherry=[919,920];
%%
Mat_bulb_laserON_arch=[];
Mat_bulb_laserOFF_arch=[];
Mat_pfc_laserON_arch=[];
Mat_pfc_laserOFF_arch=[];
Mat_bulb_laserON_cherry=[];
Mat_bulb_laserOFF_cherry=[];
Mat_pfc_laserON_cherry=[];
Mat_pfc_laserOFF_cherry=[];
%% matrice arch
for i=1:length(Mice_arch)
    mouse_num=Mice_arch(i);
    path=strcat('/media/gruffalo/09E7077B1FE07CCB/ARCHT/ArchT/', num2str(mouse_num), '/laser_hab');
    cd(path)
    load('ExpeInfo.mat');
    load('behavResources.mat');
    
    %get laser data
    load('LFPData/DigInfo9.mat')
    StimOn = thresholdIntervals(DigTSD,0.9,'Direction','Above');
    StimOff = intervalSet(0,900*1e4)-StimOn;
    
    %get the spectro pfc
    channel_pfc=ExpeInfo.ChannelToAnalyse.PFCx_deep; 
    load(['LFPData/LFP',num2str(channel_pfc),'.mat']);
    [Sp_pfc,t_pfc,f_pfc]=LoadSpectrumML(channel_pfc,pwd,'low');
    Spectsd_pfc = tsd(t_pfc*1e4,log(Sp_pfc));
    
    %get the spectro bulb
    channel_bulb=ExpeInfo.ChannelToAnalyse.Bulb_deep; 
    load(['LFPData/LFP',num2str(channel_bulb),'.mat']);
    [Sp_bulb,t_bulb,f_bulb]=LoadSpectrumML(channel_bulb,pwd,'low');
    Spectsd_bulb = tsd(t_bulb*1e4,log(Sp_bulb));
    
    Mat_pfc_laserON_arch(i,:)=mean(Data(Restrict(Spectsd_pfc,StimOn)));
    Mat_pfc_laserOFF_arch(i,:)=mean(Data(Restrict(Spectsd_pfc,StimOff)));
    Mat_bulb_laserON_arch(i,:)=mean(Data(Restrict(Spectsd_bulb,StimOn)));
    Mat_bulb_laserOFF_arch(i,:)=mean(Data(Restrict(Spectsd_bulb,StimOff)));
end

%% matrice cherry
for i=1:length(Mice_cherry)
    mouse_num=Mice_cherry(i);
    path=strcat('/media/gruffalo/09E7077B1FE07CCB/ARCHT/ArchT/', num2str(mouse_num), '/laser_hab');
    cd(path)
    load('ExpeInfo.mat');
    load('behavResources.mat');
    
    %get laser data
    load('LFPData/DigInfo9.mat')
    StimOn = thresholdIntervals(DigTSD,0.9,'Direction','Above');
    StimOff = intervalSet(0,900*1e4)-StimOn;
    
    %get the spectro pfc
    channel_pfc=ExpeInfo.ChannelToAnalyse.PFCx_deep; 
    load(['LFPData/LFP',num2str(channel_pfc),'.mat']);
    [Sp_pfc,t_pfc,f_pfc]=LoadSpectrumML(channel_pfc,pwd,'low');
    Spectsd_pfc = tsd(t_pfc*1e4,log(Sp_pfc));
    
    %get the spectro bulb
    channel_bulb=ExpeInfo.ChannelToAnalyse.Bulb_deep; 
    load(['LFPData/LFP',num2str(channel_bulb),'.mat']);
    [Sp_bulb,t_bulb,f_bulb]=LoadSpectrumML(channel_bulb,pwd,'low');
    Spectsd_bulb = tsd(t_bulb*1e4,log(Sp_bulb));
    
    Mat_pfc_laserON_cherry(i,:)=mean(Data(Restrict(Spectsd_pfc,StimOn)));
    Mat_pfc_laserOFF_cherry(i,:)=mean(Data(Restrict(Spectsd_pfc,StimOff)));
    Mat_bulb_laserON_cherry(i,:)=mean(Data(Restrict(Spectsd_bulb,StimOn)));
    Mat_bulb_laserOFF_cherry(i,:)=mean(Data(Restrict(Spectsd_bulb,StimOff)));
end

%% Norm
    

for i=1:length(Mice_arch)
    
    Mat_pfc_laserON_arch(i,:)=Mat_pfc_laserON_arch(i,:)./(sum(Mat_pfc_laserON_arch(i,1:end)));
    Mat_bulb_laserON_arch(i,:)=Mat_bulb_laserON_arch(i,:)./(sum(Mat_bulb_laserON_arch(i,1:end)));
    Mat_pfc_laserOFF_arch(i,:)=Mat_pfc_laserOFF_arch(i,:)./(sum(Mat_pfc_laserOFF_arch(i,1:end)));
    Mat_bulb_laserOFF_arch(i,:)=Mat_bulb_laserOFF_arch(i,:)./(sum(Mat_bulb_laserOFF_arch(i,1:end)));

end

for i=1:length(Mice_cherry)
    
    Mat_pfc_laserON_cherry(i,:)=Mat_pfc_laserON_cherry(i,:)./(sum(Mat_pfc_laserON_cherry(i,1:end)));
    Mat_bulb_laserON_cherry(i,:)=Mat_bulb_laserON_cherry(i,:)./(sum(Mat_bulb_laserON_cherry(i,1:end)));
    Mat_pfc_laserOFF_cherry(i,:)=Mat_pfc_laserOFF_cherry(i,:)./(sum(Mat_pfc_laserOFF_cherry(i,1:end)));
    Mat_bulb_laserOFF_cherry(i,:)=Mat_bulb_laserOFF_cherry(i,:)./(sum(Mat_bulb_laserOFF_cherry(i,1:end)));

end

%% FIGURE 

figure
%arch
subplot(2,2,1)
line([-1 0],[-1 0],'color',[0,0.3,0],'linewidth',4)
hold on
line([-1 0],[-1 0],'color',[1,0.5,0],'linewidth',4)
hold on
g=shadedErrorBar(f_pfc,nanmean(Mat_pfc_laserOFF_arch),stdError(Mat_pfc_laserOFF_arch));
set(g.patch,'FaceColor',[0.2,1,0.15],'FaceAlpha',0.3)
set(g.mainLine,'Color',[0,0.3,0],'linewidth',2)
g=shadedErrorBar(f_pfc,nanmean(Mat_pfc_laserON_arch),stdError(Mat_pfc_laserON_arch));
set(g.patch,'FaceColor',[0.95,0.83,0.1],'FaceAlpha',0.5)
set(g.mainLine,'Color',[1,0.5,0],'linewidth',2)

ylim([0.003 0.0065])
xlim([0 15])
%legend('laser OFF','laser ON')
ylabel('Power')
xlabel('Frequency(Hz)')
title('PFC, ArchT')

subplot(2,2,2)
line([-1 0],[-1 0],'color',[0,0.3,0],'linewidth',4)
hold on
line([-1 0],[-1 0],'color',[1,0.5,0],'linewidth',4)
hold on
g=shadedErrorBar(f_pfc,nanmean(Mat_bulb_laserOFF_arch),stdError(Mat_bulb_laserOFF_arch));
set(g.patch,'FaceColor',[0.2,1,0.15],'FaceAlpha',0.3)
set(g.mainLine,'Color',[0,0.3,0],'linewidth',2)
g=shadedErrorBar(f_pfc,nanmean(Mat_bulb_laserON_arch),stdError(Mat_bulb_laserON_arch));
set(g.patch,'FaceColor',[0.95,0.83,0.1],'FaceAlpha',0.5)
set(g.mainLine,'Color',[1,0.5,0],'linewidth',2)

ylim([0.003 0.0065])
xlim([0 15])
legend('laser OFF','laser ON')
ylabel('Power')
xlabel('Frequency(Hz)')
title('OB, ArchT')



subplot(2,2,3)
%cherry
line([-1 0],[-1 0],'color',[0,0.3,0],'linewidth',4);
hold on
line([-1 0],[-1 0],'color',[1,0.5,0],'linewidth',4);
hold on
g=shadedErrorBar(f_pfc,nanmean(Mat_pfc_laserOFF_cherry),stdError(Mat_pfc_laserOFF_cherry));
set(g.patch,'FaceColor',[0.2,1,0.15],'FaceAlpha',0.3)
set(g.mainLine,'Color',[0,0.3,0],'linewidth',2)
g=shadedErrorBar(f_pfc,nanmean(Mat_pfc_laserON_cherry),stdError(Mat_pfc_laserON_cherry));
set(g.patch,'FaceColor',[0.95,0.83,0.1],'FaceAlpha',0.5)
set(g.mainLine,'Color',[1,0.5,0],'linewidth',2)

ylim([0.003 0.0065])
xlim([0 15])
%legend('laser OFF','laser ON')
ylabel('Power')
xlabel('Frequency(Hz)')
title('PFC, mCherry')

subplot(2,2,4)
%cherry
line([-1 0],[-1 0],'color',[0,0.3,0],'linewidth',4);
hold on
line([-1 0],[-1 0],'color',[1,0.5,0],'linewidth',4);
hold on
g=shadedErrorBar(f_pfc,nanmean(Mat_bulb_laserOFF_cherry),stdError(Mat_bulb_laserOFF_cherry));
set(g.patch,'FaceColor',[0.2,1,0.15],'FaceAlpha',0.3)
set(g.mainLine,'Color',[0,0.3,0],'linewidth',2)
g=shadedErrorBar(f_pfc,nanmean(Mat_bulb_laserON_cherry),stdError(Mat_bulb_laserON_cherry));
set(g.patch,'FaceColor',[0.95,0.83,0.1],'FaceAlpha',0.5)
set(g.mainLine,'Color',[1,0.5,0],'linewidth',2)

ylim([0.003 0.0065])
xlim([0 15])
%legend('laser OFF','laser ON')
ylabel('Power')
xlabel('Frequency(Hz)')
title('OB, mCherry')

