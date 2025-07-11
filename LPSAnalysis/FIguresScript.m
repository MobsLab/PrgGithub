load(strcat('LFPData/LFP',num2str(Ripch(m)),'.mat'));
[MSR,TSR]=PlotRipRaw(LFP,Data(Restrict(Ripples{1},Epoch))/1e4,50); close;
DT=100/125;
timeR=([DT:DT:100]-50)/1e3;
DataLPS{num,1,m}=zscore(MSR(:,2));

struct='PaCx'
ch=PaCxch(m,2);
load(strcat('LFPData/LFP',num2str(ch),'.mat'));
for s=1:length(Spf)
    [MSPa{s},TSPa{s}]=PlotRipRaw(LFP,Range(Restrict(SpindlesPa{s,1},Epoch))/1e4,1000); close;
    DataLPS{num,1+s,m}=zscore(MSPa{s}(:,2));
end
DT=2000/2501;
timeS=([DT:DT:2000]-1000)/1e3;

ch=PaCxch(m,1);
load(strcat('LFPData/LFP',num2str(ch),'.mat'));
try
    [MDSd,TDSd]=PlotRipRaw(LFP,Data(Restrict(DeltaPa{1},Epoch))/1e4,500); close;
    DataLPS{num,6,m}=zscore(MDSd(:,2));
catch
    MDSd=[];
    TDSd=[];
    timeD=[];
        DataLPS{num,6,m}=NaN;
    
end

ch=PaCxch(m,2);
load(strcat('LFPData/LFP',num2str(ch),'.mat'));
try
    [MDSs,TDSs]=PlotRipRaw(LFP,Data(Restrict(DeltaPa{1},Epoch))/1e4,500); close;
    DataLPS{num,7,m}=zscore(MDSs(:,2));
catch
    MDSs=[];
    TDSs=[];
    DataLPS{num,7,m}=NaN;

end
DT=1000/1251;
timeD=([DT:DT:1000]-500)/1e3;

scrsz = get(0,'ScreenSize');
f=figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3)/2 scrsz(4)]);
% what they look like
for s=1:length(Spf)
    subplot(4,6,s)
    plot(timeS,zscore(TSPa{s}'),'k')
    hold on
    plot(timeS,zscore(MSPa{s}(:,2)),'r','linewidth',2)
    title(spin{s})
end
subplot(4,6,5)
plot(timeR,zscore(TSR'),'k')
hold on
plot(timeR,zscore(MSR(:,2)),'r','linewidth',2)
title('Ripples')
subplot(4,6,6)
plot(timeD,zscore(MDSs(:,2)),'r')
hold on
plot(timeD,zscore(MDSd(:,2)),'r','linewidth',2)
title('Delta')
subplot(4,6,12)
plot(timeD,zscore(TDSd'),'k')
hold on
plot(timeD,zscore(MDSd(:,2)),'r','linewidth',2)
subplot(4,6,18)
plot(timeD,zscore(TDSs'),'k')
hold on
plot(timeD,zscore(MDSs(:,2)),'r','linewidth',2)

% Cross correlograms
Ri=Data(Restrict(Ripples{1},Epoch));
De=Data(Restrict(DeltaPa{1},Epoch));
for s=1:length(Spf)
    Sp=Range(Restrict(SpindlesPa{s,1},Epoch));
    subplot(4,6,6+s)
    [C, B] = CrossCorr(Sp, De, 1500, 40);
    DataLPS{num,13+s,m}=C;
    plot(B/1E3,C,'b')
    xlim([-30 30])
    a=ylim;
    hold on
    line([0 0],[a(1) a(2)],'LineStyle','--','color','k','linewidth',3)
    if s==1
        ylabel('Delta wave rel to Spindle')
    end
    
    subplot(4,6,12+s)
    [C, B] = CrossCorr(Sp, Ri, 1500, 40);
    plot(B/1E3,C,'b')
    xlim([-30 30])
    DataLPS{num,17+s,m}=C;
    a=ylim;
    hold on
    line([0 0],[a(1) a(2)],'LineStyle','--','color','k','linewidth',3)
    if s==1
        ylabel('Ripple rel to Spindle')
    end
    
    subplot(4,6,18+s)
    [M,T]=PlotRipRaw(HRip,Sp/1e4,400);close;
    TRS=[800/size(M,1):800/size(M,1):800]-400;
    plot(TRS/1e3,zscore(T'),'k')
    xlim([-0.5 0.5])
    hold on
    plot(TRS/1e3,zscore(M(:,2)),'linewidth',2,'color','r');
    DataLPS{num,21+s,m}=zscore(M(:,2));
    plot(timeS,MSPa{s}(:,2)/500-5,'b','linewidth',2)
    a=ylim;
    hold on
    line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',3)
    
    xlim([-0.4 0.4])
    if s==1
        ylabel('Ripple Power rel to Spindle')
    end
    
end

subplot(4,6,11)
[C, B] = CrossCorr(Ri, De, 1500, 40);
plot(B/1E3,C,'b')
DataLPS{num,26,m}=C;
xlim([-30 30])
a=ylim;
hold on
line([0 0],[a(1) a(2)],'LineStyle','--','color','k','linewidth',3)
title('Delta wave rel to Ripple')

saveas(f,strcat('Oscillations_',num2str(t),'_',num2str(g),'_',struct,'.fig'))
try
    saveFigure(f,strcat('Oscillations_',num2str(t),'_',num2str(g),'_',struct),filename)
end
saveas(f,strcat('Oscillations_',num2str(t),'_',num2str(g),'_',struct,'.png'))


struct='PFCx'
ch=PFCxch(m,2);
load(strcat('LFPData/LFP',num2str(ch),'.mat'));
for s=1:length(Spf)
    [MSPF{s},TSPF{s}]=PlotRipRaw(LFP,Range(Restrict(SpindlesPF{s,1},Epoch))/1e4,1000); close;
    DataLPS{num,7+s,m}=zscore(MSPF{s}(:,2));
    
end

ch=PFCxch(m,1);
load(strcat('LFPData/LFP',num2str(ch),'.mat'));
try
    [MDSd,TDSd]=PlotRipRaw(LFP,Data(Restrict(DeltaPF{1},Epoch))/1e4,500); close;
    DT=500/1251;
    DataLPS{num,12,m}=zscore(MDSd(:,2));

catch
    MDSd=[];
    TDSd=[];
    timeD=[];
    DataLPS{num,12,m}=NaN;

end
ch=PFCxch(m,2);
load(strcat('LFPData/LFP',num2str(ch),'.mat'));
try
    [MDSs,TDSs]=PlotRipRaw(LFP,Data(Restrict(DeltaPF{1},Epoch))/1e4,500); close;
DataLPS{num,13,m}=zscore(MDSs(:,2));
catch
    MDSs=[];
    TDSs=[];
DataLPS{num,13,m}=NaN;
end



scrsz = get(0,'ScreenSize');
f=figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3)/2 scrsz(4)]);
% what they look like
for s=1:length(Spf)
    subplot(4,6,s)
    plot(timeS,zscore(TSPF{s}'),'k')
    hold on
    plot(timeS,zscore(MSPF{s}(:,2)),'r','linewidth',2)
    title(spin{s})
end
subplot(4,6,5)
plot(timeR,zscore(TSR'),'k')
hold on
plot(timeR,zscore(MSR(:,2)),'r','linewidth',2)
title('Ripples')
subplot(4,6,6)
try
    plot(timeD,zscore(MDSs(:,2)),'r')
    hold on
    plot(timeD,zscore(MDSd(:,2)),'r','linewidth',2)
    title('Delta')
    subplot(4,6,12)
    plot(timeD,zscore(TDSd'),'k')
    hold on
    plot(timeD,zscore(MDSd(:,2)),'r','linewidth',2)
    subplot(4,6,18)
    plot(timeD,zscore(TDSs'),'k')
    hold on
    plot(timeD,zscore(MDSs(:,2)),'r','linewidth',2)
end

% Cross correlograms
Ri=Data(Restrict(Ripples{1},Epoch));
try
    De=Data(Restrict(DeltaPF{1},Epoch));
catch
    De=[];
end
for s=1:length(Spf)
    Sp=Range(Restrict(SpindlesPF{s,1},Epoch));
    subplot(4,6,6+s)
    try
        [C, B] = CrossCorr(Sp, De, 1500, 40);
        plot(B/1E3,C,'b')
        DataLPS{num,26+s,m}=C;
        a=ylim;
            xlim([-30 30])
        hold on
        line([0 0],[a(1) a(2)],'LineStyle','--','color','k','linewidth',3)
    catch
        DataLPS{num,26+s,m}=NaN;
        
    end
    if s==1
        ylabel('Delta wave rel to Spindle')
    end
    
    subplot(4,6,12+s)
    [C, B] = CrossCorr(Sp, Ri, 1500, 40);
    plot(B/1E3,C,'b')
    DataLPS{num,30+s,m}=C;
    a=ylim;
        xlim([-30 30])
    hold on
    line([0 0],[a(1) a(2)],'LineStyle','--','color','k','linewidth',3)
    if s==1
        ylabel('Ripple rel to Spindle')
    end
    
    subplot(4,6,18+s)
    [M,T]=PlotRipRaw(HRip,Sp/1e4,400);close;
    TRS=[800/size(M,1):800/size(M,1):800]-400;
    plot(TRS/1e3,zscore(T'),'k')
    hold on
    plot(TRS/1e3,zscore(M(:,2)),'linewidth',2,'color','r');
    DataLPS{num,34+s,m}=zscore(M(:,2));
    plot(timeS,MSPF{s}(:,2)/500-5,'b','linewidth',2)
    a=ylim;
    xlim([-0.4 0.4])
    line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',3)
    if s==1
        ylabel('Ripple Power rel to Spindle')
    end
    
end
subplot(4,6,11)
try
    [C, B] = CrossCorr(Ri, De, 1500, 40);
    plot(B/1E3,C,'b')
    a=ylim;
    xlim([-30 30])
    hold on
    line([0 0],[a(1) a(2)],'LineStyle','--','color','k','linewidth',3)
    DataLPS{num,39,m}=C;
catch
    DataLPS{num,39,m}=NaN;
    
end
title('Delta wave rel to Ripple')

saveas(f,strcat('Oscillations_',num2str(t),'_',num2str(g),'_',struct,'.fig'))
try
    saveFigure(f,strcat('Oscillations_',num2str(t),'_',num2str(g),'_',struct),filename)
end
saveas(f,strcat('Oscillations_',num2str(t),'_',num2str(g),'_',struct,'.png'))


close all