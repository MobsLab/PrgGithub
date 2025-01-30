function [del1,PlotMF,PlotMY,PlotSF1,PlotSF2,PlotSY1,PlotSY2,ey,my,sy,ef,mf,sf,st2,Yf,Ff]=DelayVmLFP(plott,Loc,smoo,win,seuil)


%
% plott
%
% Loc
%
% smoo
%
% win
%
% seuil
%


load Data
try
    load DataCompLFP10
catch
load DataMCLFP
end

try
    win;
catch
    win=250;
end

try
    plott;
catch
    plott=0;
end


try
    Loc;
    if length(Loc)==1
        Loc(2)=2;
    end
catch
    Loc(1)=10;
    Loc(2)=2;
end

Ff=locdetrend(data(:,3),10000,[Loc(1),Loc(2)]);
Yf=locdetrend(data(:,2),10000,[Loc(1),Loc(2)]);


Ff=FilterLFP(tsd(data(:,1)*1E4,Ff),[0.0000001 40],1024);
Ff=Data(Ff);
Yf=FilterLFP(tsd(data(:,1)*1E4,Yf),[0.0000001 40],1024);
Yf=Data(Yf);

try
    seuil;
catch
    seuil=percentile(Yf, 95);
    smoo=3;
end

Epoch=thresholdIntervals(tsd(data(:,1)*1E4,Yf),seuil,'Direction','Above');
Epoch2=mergeCloseIntervals(Epoch,2000);

st2=Start(Epoch2);

[mf,sf,ef]=ETAverage(st2,data(:,1)*1E4,Ff,20,win);
[my,sy,ey]=ETAverage(st2,data(:,1)*1E4,Yf,20,win);

if plott==1
    
    figure('Color',[1 1 1]),
    subplot(2,2,2), hold on
    plot(data(:,1),Ff,'r')
    plot(data(:,1),Yf,'b')
    plot(st2/1E4,zeros(length(st2),1),'ko','MarkerFaceColor','k')
    line([data(1,1) data(end,1)],[seuil seuil],'Color','r')
    subplot(2,2,4), hold on
    hist(Yf,100)
    yl=ylim;
    line([seuil seuil],[yl(1) yl(2)],'Color','r')

end


% figure('Color',[1 1 1]),
if plott==1

    subplot(2,2,1),
    plot(ey/1000,smooth(my,smoo),'-','linewidth',1')
    hold on, plot(ef/1000,smooth(mf*10+0.2,smoo),'-r','linewidth',1)
    yl=ylim;
    hold on, line([0 0],[yl(1) yl(2)],'Color','k')
    xlim([ef(1)/1000 ef(end)/1000])
    title('LFP (red), Vm (blue)')

end

PlotSY1=smooth(((my+sqrt(sy)/length(st2))-mean(my(ey<-500)))/max(my-mean(my(ey<-500))),smoo);
PlotSY2=smooth(((my-sqrt(sy)/length(st2))-mean(my(ey<-500)))/max(my-mean(my(ey<-500))),smoo);
PlotSF1=smooth((-(mf+sqrt(sf)/length(st2))+mean(mf(ef<-500)))/max(-mf+mean(mf(ef<-500))),smoo);
PlotSF2=smooth((-(mf-sqrt(sf)/length(st2))+mean(mf(ef<-500)))/max(-mf+mean(mf(ef<-500))),smoo);

PlotMF=smooth((-mf+mean(mf(ef<-500)))/max(-mf+mean(mf(ef<-500))),smoo);
PlotMY=smooth((my-mean(my(ey<-500)))/max(my-mean(my(ey<-500))),smoo);

if plott==1
    
    subplot(2,2,3), plot(ey,PlotMY)
    hold on, plot(ef,PlotMF,'r')
    plot(ef,PlotSF2,'--r')
    plot(ef,PlotSF1,'--r')
    plot(ef,PlotSY1,'--')
    plot(ey,PlotSY2,'--')
    plot(ey,PlotSY1,'--')

    yl=ylim;
    ylim([yl(1) 1.2])
    try
    hold on, line([ey(find(my==max(my))) ey(find(my==max(my)))],[yl(1) 1.2],'Color',[0.7 0.7 1])
    hold on, line([ey(find(-mf==max(-mf))) ey(find(-mf==max(-mf)))],[yl(1) 1.2],'Color',[1 0.7 0.7])
    end
    hold on, line([-450 -450],[yl(1) 1.2],'Color',[1 0.7 0.7])
    hold on, line([-300 -300],[yl(1) 1.2],'Color',[0.7 0.7 1])
    xlim([ef(1) ef(end)])

end

del1=ey(find(my==max(my)))-ey(find(-mf==max(-mf)));
del1=abs(del1);

if plott==1

    title(['delay: ',num2str(del1),'ms'])



del2=300;

num=gcf;

        fichier=pwd;

        eval(['saveFigure(num,''FigureDelai'',''',fichier,''')'])
end        
        
%         keyboard
%         
if plott==1
    
figure('Color',[1 1 1]), plot(ey,smooth(my,smoo),'linewidth',2)
hold on, plot(ey,smooth(my+sqrt(sy)/(length(st2)),smoo))
hold on, plot(ey,smooth(my-sqrt(sy)/(length(st2)),smoo))
hold on, plot(ef,smooth(mf*10+0.3,smoo),'r','linewidth',2)
hold on, plot(ef,smooth(0.3+10*(mf-sqrt(sf)/(length(st2))),smoo),'r')
hold on, plot(ef,smooth(0.3+10*(mf+sqrt(sf)/(length(st2))),smoo),'r')
hold on, line([ef(mf==min(mf)) ef(mf==min(mf))],[-0.2 0.6],'Color',[1 0.7 0.7])
hold on, line([ey(my==max(my)) ey(my==max(my))],[-0.2 0.6],'Color',[0.7 0.7 1])


    figure('Color',[1 1 1]), 
    plot(ey,PlotMY,'linewidth',2)
    hold on, plot(ef,PlotMF,'r','linewidth',2)
    plot(ef,PlotSF2,'r')
    plot(ef,PlotSF1,'r')
    plot(ef,PlotSY1)
    plot(ey,PlotSY2)

    hold on, line([ey(PlotMF==max(PlotMF)) ey(PlotMF==max(PlotMF))],[-0.2 1.2],'Color',[1 0.7 0.7])
    hold on, line([ey(PlotMY==max(PlotMY)) ey(PlotMY==max(PlotMY))],[-0.2 1.2],'Color',[0.7 0.7 1])

end
