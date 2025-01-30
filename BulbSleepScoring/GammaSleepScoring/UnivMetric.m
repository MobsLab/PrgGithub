%% Look at superposition of phase spaces and theta distributions in and out of sleep
clear all
struc={'B','H','Pi','PF','Pa','PFSup','PaSup','Amyg'};
clear todo chan dataexis
m=1;
filename2{m}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013/';
todo(m,:)=[1,1,0,1,1,1,1,0];
dataexis(m,:)=[1,1,0,1,1,1,1,0];
chan(m,:)=[1,10,NaN,4,13,6,2,NaN];

m=2;
filename2{m}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130730/BULB-Mouse-82-30072013/';
todo(m,:)=[1,1,0,1,1,1,1,0];
dataexis(m,:)=[1,1,0,1,1,1,1,0];
chan(m,:)=[2,9,NaN,10,7,8,3,NaN];

m=3;
filename2{m}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse083/20130802/BULB-Mouse-83-02082013/';
todo(m,:)=[1,1,0,1,1,1,1,0];
dataexis(m,:)=[1,1,0,1,1,1,1,0];
chan(m,:)=[6,10,NaN,5,13,1,7,NaN];

m=4;
filename2{m}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse123/LPS_D1/LPSD1-Mouse-123-31032014/';
todo(m,:)=[1,1,1,1,1,1,1,1];
dataexis(m,:)=[1,1,1,1,1,1,1,1];
chan(m,:)=[15,6,0,4,9,12,NaN,3];

m=5;
filename2{m}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD1/LPSD1-Mouse-124-31032014/';
todo(m,:)=[1,1,1,1,1,1,1,1];
dataexis(m,:)=[1,1,1,1,1,0,0,1];
chan(m,:)=[11,2,12,8,4,15,NaN,15];


close all
Xfin=[];
Yfin=[];
Xpeak=[];
Ypeak=[];
for file=1:5
    file
    cd(filename2{file})
    load('StateEpochSB.mat')
    try
        load('LFPData/LFP0.mat')
    catch
        try
            load('LFPData/LFP1.mat')
        catch
            load('LFPData/LFP2.mat')
        end
    end
    try
        load('behavResources.mat','PreEpoch');
        TotalEpoch=And(TotalEpoch,PreEpoch);
    end
    rg=Range(LFP);
    TotalEpoch=intervalSet(0,rg(end))-NoiseEpoch-GndNoiseEpoch;
    try
       load('behavResources.mat','PreEpoch')
       TotalEpoch=And(TotalEpoch,PreEpoch);
    end
    ghi_new=Restrict(smooth_ghi,TotalEpoch);
    theta_new=Restrict(smooth_Theta,TotalEpoch);
    %need to think about this
    t=Range(theta_new);
    if file<4 & file~=1
        ti=t(5:100:end);
    elseif file==1
        ti=t(5:100:end/3);
    else
        ti=t(5:100:end/3);
    end
    
    ghi_new=(Restrict(ghi_new,ts(ti)));
    theta_new=(Restrict(theta_new,ts(ti)));
    theta_new=(Restrict(theta_new,sleepper));
    cent=mean([log(Data(Restrict(theta_new,And(SWSEpoch,TotalEpoch)))) log(Data(Restrict(ghi_new,And(SWSEpoch,TotalEpoch))))]);
    Xfin{file}=log(Data(ghi_new))-cent(2);
    Yfin{file}=log(Data(theta_new))-cent(1);
    Xpeak=[Xpeak,log(gamma_thresh)-cent(2)];
    Ypeak=[Ypeak,log(theta_thresh)-cent(1)];
end

% save('METRICS.mat','Xfin','Yfin','Ypeak','Xpeak')     

    Xfin{3}(Xfin{3}<1.28 & Xfin{3}>1.23)=NaN;
    Xfin{1}(Xfin{2}<1.709 & Xfin{2}>1.706)=NaN;
    
    close all
    figure
    hold on
    x=[0 0.08];
%     y1=mean(Xpeak)-(std(Xpeak)/sqrt(5))
%     y2=mean(Xpeak)+(std(Xpeak)/sqrt(5))
%     X=[x,fliplr(x)];
%     f=fill([y1 y1 y2 y2],[0 0.12 0.12 0],'b');
%     set(f,'FaceColor',[0.8 0.8 1],'EdgeColor',[0.8 0.8 1])
%     hold on
    plot([Xpeak ;Xpeak],[0 0 0 0 0 ; 1 1 1 1 1]*0.1,'color',[0.8 0.6 0.8],'linewidth',1)
%     plot([mean(Xpeak) mean(Xpeak)],[0 1]*0.12,'color','b','linewidth',3)
    
    Xtot=[];
    Ytot=[];
    for i=1:5
        Xtot=[Xtot;Xfin{i}];
        Ytot=[Ytot;Yfin{i}];
        [Y,X]=hist(Xfin{i},100);
        plot(X,smooth(Y/sum(Y),5),'k','linewidth',2)
    end   
    ylim([0 0.08])
    xlim([-0.7 2.7])
    [Y,X]=hist(Xtot,500);
    plot(X,Y/sum(Y),'linewidth',5,'color','r')
    
    
    close all
    figure
    hold on
    x=[0 0.08];
%     y1=mean(Xpeak)-(std(Xpeak)/sqrt(5))
%     y2=mean(Xpeak)+(std(Xpeak)/sqrt(5))
%     X=[x,fliplr(x)];
%     f=fill([y1 y1 y2 y2],[0 0.12 0.12 0],'b');
%     set(f,'FaceColor',[0.8 0.8 1],'EdgeColor',[0.8 0.8 1])
%     hold on
    plot([Ypeak ;Ypeak],[0 0 0 0 0 ; 1 1 1 1 1]*0.05,'color',[0.8 0.6 0.8],'linewidth',1)
%     plot([mean(Xpeak) mean(Xpeak)],[0 1]*0.12,'color','b','linewidth',3)
    
    Xtot=[];
    Ytot=[];
    for i=1:5
        Xtot=[Xtot;Xfin{i}];
        Ytot=[Ytot;Yfin{i}];
        [Y,X]=hist(Yfin{i},100);
        plot(X,smooth(Y/sum(Y),5),'k','linewidth',2)
    end
    ylim([0 0.08])
    xlim([-0.7 2.7])
    [Y,X]=hist(Xtot,500);
    plot(X,Y/sum(Y),'linewidth',5,'color','r')
    
    
    figure
    plot(Xtot,Ytot,'.','color',[0.8 0.8 0.8],'MarkerSize',5)
    [occH, x1, x2] = hist2d(Xtot,Ytot,200,200);
    occH2=SmoothDec(occH,[2,2]);
    imagesc(x1,x2,occH2'), axis xy
    colormap hot
   