% Eyelid shock

fig=figure;
clf
Filename{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_TestPre/TestPre1';
Filename{2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_TestPre/TestPre2';
Filename{3}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_TestPre/TestPre3';
Filename{4}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_TestPre/TestPre4';


load('/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_TestPre/TestPre1/raw/FEAR-Mouse-425-19072016-01-TestPre/Behavior.mat')

clear Occup Occup2
for mm=1:4
    mm
    
    cd(Filename{mm})
    load('behavResources.mat')
    TotArea=0;
    for t=1:5
        TotArea=TotArea+(sum(sum(Zone{t})));
    end
    TimeInZone1(1,mm)=(size(ZoneIndices{1},1)./size(Data(Xtsd),1))./(sum(sum(Zone{1}))./TotArea);
    
    TimeInZone1(2,mm)=(size(ZoneIndices{2},1)./size(Data(Xtsd),1))./(sum(sum(Zone{2}))./TotArea);
    
    TimeInZone1(3,mm)=(size(ZoneIndices{3},1)./size(Data(Xtsd),1))./(sum(sum(Zone{3}))./TotArea);
    
    TimeInZone1(4,mm)=(size(ZoneIndices{4},1)./size(Data(Xtsd),1))./(sum(sum(Zone{4}))./TotArea);
    
    TimeInZone2(1,mm)=size(ZoneIndices{1},1)./size(Data(Xtsd),1);
    
    TimeInZone2(2,mm)=size(ZoneIndices{2},1)./size(Data(Xtsd),1);
    
    TimeInZone2(3,mm)=size(ZoneIndices{3},1)./size(Data(Xtsd),1);
    
    TimeInZone2(4,mm)=size(ZoneIndices{4},1)./size(Data(Xtsd),1);
    
    TimeInZone2(5,mm)=size(ZoneIndices{5},1)./size(Data(Xtsd),1);
    
    subplot(2,5,1+mm)
    imagesc(imageRef),colormap gray,hold on
    plot(Data(Xtsd)*Ratio_IMAonREAL,Data(Ytsd)*Ratio_IMAonREAL,'linewidth',2,'color','b')
    xlim([60 280]), ylim([-0 200])
    set(gca,'TickLength',[0 0],'XTick',[],'Ytick',[])

end
subplot(251)
a=sum([TimeInZone2(1,:)+TimeInZone2(4,:);TimeInZone2(5,:)+TimeInZone2(2,:)])';
a=[[TimeInZone2(1,:)+TimeInZone2(4,:);TimeInZone2(5,:)+TimeInZone2(2,:)]./[a,a]']';
PlotErrorBarN(a,0)
hold on
ylabel('% time spent')
box off
set(gca,'XTick',[1,2],'XTickLabel',{'Shcock','No Shock'})

Filename{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_TestPost/TestPost1';
Filename{2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_TestPost/TestPost2';
Filename{3}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_TestPost/TestPost3';
Filename{4}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_TestPost/TestPost4';


clear Occup Occup2
for mm=1:4
    mm
    cd(Filename{mm})
    load('/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_TestPost/TestPost4/raw/FEAR-Mouse-425-19072016-01-TestPost000/behavResources.mat')
    
    load('behavResources.mat')
    TotArea=0;
    for t=1:5
        TotArea=TotArea+(sum(sum(Zone{t})));
    end
    TimeInZone1(1,mm)=(size(ZoneIndices{1},1)./size(Data(Xtsd),1))./(sum(sum(Zone{1}))./TotArea);
    
    TimeInZone1(2,mm)=(size(ZoneIndices{2},1)./size(Data(Xtsd),1))./(sum(sum(Zone{2}))./TotArea);
    
    TimeInZone1(3,mm)=(size(ZoneIndices{3},1)./size(Data(Xtsd),1))./(sum(sum(Zone{3}))./TotArea);
    
    TimeInZone1(4,mm)=(size(ZoneIndices{4},1)./size(Data(Xtsd),1))./(sum(sum(Zone{4}))./TotArea);
    
    TimeInZone2(1,mm)=size(ZoneIndices{1},1)./size(Data(Xtsd),1);
    
    TimeInZone2(2,mm)=size(ZoneIndices{2},1)./size(Data(Xtsd),1);
    
    TimeInZone2(3,mm)=size(ZoneIndices{3},1)./size(Data(Xtsd),1);
    
    TimeInZone2(4,mm)=size(ZoneIndices{4},1)./size(Data(Xtsd),1);
    
    TimeInZone2(5,mm)=size(ZoneIndices{5},1)./size(Data(Xtsd),1);
    
    subplot(2,5,6+mm)
    imagesc(imageRef),colormap gray,hold on
    plot(Data(Xtsd)*Ratio_IMAonREAL,Data(Ytsd)*Ratio_IMAonREAL,'linewidth',2,'color','b')
    xlim([60 280]), ylim([-0 200])
    set(gca,'TickLength',[0 0],'XTick',[],'Ytick',[])
end
subplot(2,5,6)
a=sum([TimeInZone2(1,:)+TimeInZone2(4,:);TimeInZone2(5,:)+TimeInZone2(2,:)])';
a=[[TimeInZone2(1,:)+TimeInZone2(4,:);TimeInZone2(5,:)+TimeInZone2(2,:)]./[a,a]']';
PlotErrorBarN(a,0)
hold on
ylabel('% time spent')
box off
set(gca,'XTick',[1,2],'XTickLabel',{'Shcock','No Shock'})




% PAG Stim shock

fig=figure;
clf
Filename{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_TestPre/TestPre1';
Filename{2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_TestPre/TestPre2';
Filename{3}='/media/DataMOBsRAID/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_TestPre/TestPre3';
Filename{4}='/media/DataMOBsRAID/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_TestPre/TestPre4';


clear Occup Occup2
for mm=1:4
    mm
    
    cd(Filename{mm})
    load('behavResources.mat')
    TotArea=0;
    for t=1:5
        TotArea=TotArea+(sum(sum(Zone{t})));
    end
    TimeInZone1(1,mm)=(size(ZoneIndices{1},1)./size(Data(Xtsd),1))./(sum(sum(Zone{1}))./TotArea);
    
    TimeInZone1(2,mm)=(size(ZoneIndices{2},1)./size(Data(Xtsd),1))./(sum(sum(Zone{2}))./TotArea);
    
    TimeInZone1(3,mm)=(size(ZoneIndices{3},1)./size(Data(Xtsd),1))./(sum(sum(Zone{3}))./TotArea);
    
    TimeInZone1(4,mm)=(size(ZoneIndices{4},1)./size(Data(Xtsd),1))./(sum(sum(Zone{4}))./TotArea);
    
    TimeInZone2(1,mm)=size(ZoneIndices{1},1)./size(Data(Xtsd),1);
    
    TimeInZone2(2,mm)=size(ZoneIndices{2},1)./size(Data(Xtsd),1);
    
    TimeInZone2(3,mm)=size(ZoneIndices{3},1)./size(Data(Xtsd),1);
    
    TimeInZone2(4,mm)=size(ZoneIndices{4},1)./size(Data(Xtsd),1);
    
    TimeInZone2(5,mm)=size(ZoneIndices{5},1)./size(Data(Xtsd),1);
    
    subplot(2,5,1+mm)
    imagesc(imageRef),colormap gray,hold on
    plot(Data(Ytsd)*Ratio_IMAonREAL,Data(Xtsd)*Ratio_IMAonREAL,'linewidth',2,'color','b')
    xlim([60 280]), ylim([10 200])
    set(gca,'TickLength',[0 0],'XTick',[],'Ytick',[])
end
subplot(251)
a=sum([TimeInZone2(1,:)+TimeInZone2(4,:);TimeInZone2(5,:)+TimeInZone2(2,:)])';
a=[[TimeInZone2(1,:)+TimeInZone2(4,:);TimeInZone2(5,:)+TimeInZone2(2,:)]./[a,a]']';
PlotErrorBarN(a,0)
hold on
ylabel('% time spent')
box off
set(gca,'XTick',[1,2],'XTickLabel',{'Shcock','No Shock'})
ylim([0 1])

Filename{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_TestPost/TestPost1';
Filename{2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_TestPost/TestPost2';
Filename{3}='/media/DataMOBsRAID/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_TestPost/TestPost3';
Filename{4}='/media/DataMOBsRAID/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_TestPost/TestPost4';


clear Occup Occup2
for mm=1:4
    mm
    cd(Filename{mm})
    
    load('behavResources.mat')
    TotArea=0;
    for t=1:5
        TotArea=TotArea+(sum(sum(Zone{t})));
    end
    TimeInZone1(1,mm)=(size(ZoneIndices{1},1)./size(Data(Xtsd),1))./(sum(sum(Zone{1}))./TotArea);
    
    TimeInZone1(2,mm)=(size(ZoneIndices{2},1)./size(Data(Xtsd),1))./(sum(sum(Zone{2}))./TotArea);
    
    TimeInZone1(3,mm)=(size(ZoneIndices{3},1)./size(Data(Xtsd),1))./(sum(sum(Zone{3}))./TotArea);
    
    TimeInZone1(4,mm)=(size(ZoneIndices{4},1)./size(Data(Xtsd),1))./(sum(sum(Zone{4}))./TotArea);
    
    TimeInZone2(1,mm)=size(ZoneIndices{1},1)./size(Data(Xtsd),1);
    
    TimeInZone2(2,mm)=size(ZoneIndices{2},1)./size(Data(Xtsd),1);
    
    TimeInZone2(3,mm)=size(ZoneIndices{3},1)./size(Data(Xtsd),1);
    
    TimeInZone2(4,mm)=size(ZoneIndices{4},1)./size(Data(Xtsd),1);
    
    TimeInZone2(5,mm)=size(ZoneIndices{5},1)./size(Data(Xtsd),1);
    
    subplot(2,5,6+mm)
    imagesc(imageRef),colormap gray,hold on
    plot(Data(Ytsd)*Ratio_IMAonREAL,Data(Xtsd)*Ratio_IMAonREAL,'linewidth',2,'color','b')
    xlim([60 280]), ylim([20 200])
    set(gca,'TickLength',[0 0],'XTick',[],'Ytick',[])
end
subplot(2,5,6)
a=sum([TimeInZone2(1,:)+TimeInZone2(4,:);TimeInZone2(5,:)+TimeInZone2(2,:)])';
a=[[TimeInZone2(1,:)+TimeInZone2(4,:);TimeInZone2(5,:)+TimeInZone2(2,:)]./[a,a]']';
PlotErrorBarN(a,0)
hold on
ylabel('% time spent')
box off
set(gca,'XTick',[1,2],'XTickLabel',{'Shcock','No Shock'})
ylim([0 1])



