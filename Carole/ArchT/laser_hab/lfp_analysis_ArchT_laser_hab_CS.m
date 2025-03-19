%%

clear all
Mice=[915,916,919,917,918,920];
type=[{'A'},{'A'},{'mCh'},{'A'},{'A'},{'mCh'}]

for i=1:length(Mice)
    mouse_num=Mice(i)
    path=strcat('/media/gruffalo/09E7077B1FE07CCB/ARCHT/ArchT/', num2str(mouse_num), '/laser_hab'); % /!\ a modifier !!!!!!!
    cd(path)
    load('ExpeInfo.mat');
    %get laser data
    load('LFPData/DigInfo9.mat')
    StimOn = thresholdIntervals(DigTSD,0.9,'Direction','Above');
    StimOff = intervalSet(0,900*1e4)-StimOn;
    %spectro du pfc
    channel_pfc=ExpeInfo.ChannelToAnalyse.PFCx_deep;
    load(['LFPData/LFP',num2str(channel_pfc),'.mat']);
    [Sp_pfc,t_pfc,f_pfc]=LoadSpectrumML(channel_pfc,pwd,'low');
    Spectsd_pfc = tsd(t_pfc*1e4,log(Sp_pfc));
    %spectro du bulb
    channel_bulb=ExpeInfo.ChannelToAnalyse.Bulb_deep;
    load(['LFPData/LFP',num2str(channel_bulb),'.mat']);
    [Sp_bulb,t_bulb,f_bulb]=LoadSpectrumML(channel_bulb,pwd,'low');
    Spectsd_bulb = tsd(t_bulb*1e4,log(Sp_bulb));
    %figure
    subplot(2,3,i)
    %pfc sans laser
    plot(f_pfc,mean(Data(Restrict(Spectsd_pfc,StimOff))), 'color', 'g','linewidth',2);
    hold on
    %pfc avec laser
    plot(f_pfc,mean(Data(Restrict(Spectsd_pfc,StimOn))), 'color', 'r','linewidth',2);
    hold on
    %bulb sans laser
    plot(f_pfc,mean(Data(Restrict(Spectsd_bulb,StimOff))), 'color', 'k','linewidth',2);
    hold on
    %bulb avec laser
    plot(f_pfc,mean(Data(Restrict(Spectsd_bulb,StimOn))), 'color', 'b','linewidth',2);
    hold on

    legend('PFC-laser-Off', 'PFC-laser-On','Bulb-laser-Off', 'Bulb-laser-On');
    title(strcat('mouse',num2str(mouse_num),', ',type{i}));
end