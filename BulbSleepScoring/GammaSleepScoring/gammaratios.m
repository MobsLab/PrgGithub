load('HiSpectrumData.mat')
 HighSpectr1=HighSpectr;
channels=[0,2,4,6,9,12,18,7,13,1,5];
blb=[0,2,4,6,9];
hpc=[12,10,8];
cx=[7,11,13,1,3,5];
for i=1:length(channels)
        HighSpectr1.ch{i}=channels(i);
%         hold on
end
load('HiSpectrumDatabis.mat')
HighSpectr=mergestruct(HighSpectr, HighSpectr1);

SWSvals=zeros(6,length(HighSpectr.FsSWS));
for i=1:length(HighSpectr.FsSWS)
    Fs=HighSpectr.FsSWS{i}(1:10:end);
       St30=find(Fs>30,1,'first');
    St40=find(Fs>40,1,'first');
   St50=find(Fs>50,1,'first');
    St60=find(Fs>60,1,'first');
    St70=find(Fs>70,1,'first');
    St80=find(Fs>80,1,'first');
    St90=find(Fs>90,1,'first');

    SWSvals(1,i)=HighSpectr.ch{i};
    SWSvals(2,i)=mean(HighSpectr.SpSWS{i}(St30:St50));
    SWSvals(3,i)=mean(HighSpectr.SpSWS{i}(St40:St60));
    SWSvals(4,i)=mean(HighSpectr.SpSWS{i}(St50:St70));
    SWSvals(5,i)=mean(HighSpectr.SpSWS{i}(St60:St80));
    SWSvals(6,i)=mean(HighSpectr.SpSWS{i}(St70:St90));
end 
    

REMvals=zeros(6,length(HighSpectr.FsREM));
for i=1:length(HighSpectr.FsREM)
    Fs=HighSpectr.FsREM{i}(1:10:end);
       St30=find(Fs>30,1,'first');
    St40=find(Fs>40,1,'first');
   St50=find(Fs>50,1,'first');
    St60=find(Fs>60,1,'first');
    St70=find(Fs>70,1,'first');
    St80=find(Fs>80,1,'first');
    St90=find(Fs>90,1,'first');

    REMvals(1,i)=HighSpectr.ch{i};
    REMvals(2,i)=mean(HighSpectr.SpREM{i}(St30:St50));
    REMvals(3,i)=mean(HighSpectr.SpREM{i}(St40:St60));
    REMvals(4,i)=mean(HighSpectr.SpREM{i}(St50:St70));
    REMvals(5,i)=mean(HighSpectr.SpREM{i}(St60:St80));
    REMvals(6,i)=mean(HighSpectr.SpREM{i}(St70:St90));
end 

Wakevals=zeros(6,length(HighSpectr.FsWake));
for i=1:length(HighSpectr.FsWake)
    Fs=HighSpectr.FsWake{i}(1:10:end);
       St30=find(Fs>30,1,'first');
    St40=find(Fs>40,1,'first');
   St50=find(Fs>50,1,'first');
    St60=find(Fs>60,1,'first');
    St70=find(Fs>70,1,'first');
    St80=find(Fs>80,1,'first');
    St90=find(Fs>90,1,'first');

    Wakevals(1,i)=HighSpectr.ch{i};
    Wakevals(2,i)=mean(HighSpectr.SpWake{i}(St30:St50));
    Wakevals(3,i)=mean(HighSpectr.SpWake{i}(St40:St60));
    Wakevals(4,i)=mean(HighSpectr.SpWake{i}(St50:St70));
    Wakevals(5,i)=mean(HighSpectr.SpWake{i}(St60:St80));
    Wakevals(6,i)=mean(HighSpectr.SpWake{i}(St70:St90));
end 

    
WR=zeros(6,length(HighSpectr.FsWake));
WS=zeros(6,length(HighSpectr.FsWake));

for i=1:length(HighSpectr.FsWake)
    WR(1,i)=HighSpectr.ch{i};
    WS(1,i)=HighSpectr.ch{i};

    for g=2:6
    WR(g,i)=Wakevals(g,i)/REMvals(g,i);
    WS(g,i)=Wakevals(g,i)/SWSvals(g,i);
    end
end

blbWS=[];
hpcWS=[];
cxWS=[];
S=figure
for i=1:length(HighSpectr.FsWake)
    if  sum(HighSpectr.ch{i}==blb)
     plot(WS(2:end,i),'.')
     blbWS=[blbWS,WS(2:end,i)];
    elseif sum(HighSpectr.ch{i}==hpc)
             plot(WS(2:end,i),'.','color','r')
    hpcWS=[hpcWS,WS(2:end,i)];

    elseif sum(HighSpectr.ch{i}==cx)
             plot(WS(2:end,i),'.','color','g')
                  cxWS=[cxWS,WS(2:end,i)];

    end
     hold on
end
xlim([0 6])
ax=gca;
set(ax,'XTick',[1,2,3,4,5],'XTickLabel',{'30-50','40-60','50-70','60-80','70-90'})
title('Wake to SWS ratios for gamma frequency')
xlabel ('frequency bands')

blbWR=[];
hpcWR=[];
cxWR=[];
R=figure
for i=1:length(HighSpectr.FsWake)
    if  sum(HighSpectr.ch{i}==blb)
     plot(WR(2:end,i),'.')
          blbWR=[blbWR,WR(2:end,i)];

    elseif sum(HighSpectr.ch{i}==hpc)
             plot(WR(2:end,i),'.','color','r')
                     hpcWR=[hpcWR,WR(2:end,i)];

    elseif sum(HighSpectr.ch{i}==cx)
             plot(WR(2:end,i),'.','color','g')       
             cxWR=[cxWR,WR(2:end,i)];

    end
     hold on
end
xlim([0 6])
ax=gca;
set(ax,'XTick',[1,2,3,4,5],'XTickLabel',{'30-50','40-60','50-70','60-80','70-90'})
title('Wake to REM ratios for gamma frequency')
xlabel ('frequency bands')

disp(strcat('max HIPP WR = ', num2str(max(hpcWR(3,:)))))
disp(strcat('max HIPP WS = ', num2str(max(hpcWS(3,:)))))
disp(' ')
disp(strcat('max CX WR = ', num2str(max(cxWR(3,:)))))
disp(strcat('max CX WS = ', num2str(max(cxWS(3,:)))))
disp(' ')
disp(strcat('max BLB WR = ', num2str(max(blbWR(3,:)))))
disp(strcat('max BLB WS = ', num2str(max(blbWS(3,:)))))

saveas(S,'SWSratio.fig')
saveas(S,'SWSratio.png')
saveas(R,'REMratio.png')
saveas(R,'REMratio.fig')

[a,b]=max(blbWR(3,:));
[c,d]=max(blbWS(3,:));
bestblb=[bestblb;mean([blbWR(:,b)'; blbWS(:,d)'])];
