function plotAnalysisCP(num,a,LFPt,R,coul)

try
    del;
catch
    del=6;
end
fac=30;

figure(num), clf, hold on

%--------------------------------------------------------------------------
EpochPlot=intervalSet(a*1E4,(a+del)*1E4);
for i=1:15
plot(Range(Restrict(LFPt{i},EpochPlot),'s'),fac*Data(Restrict(LFPt{i},EpochPlot))/1000+fac*i+fac*2.5,'color',coul{i})
end
% 
% plot(Range(LFPt{10},'s'),fac*Data(LFPt{10})/1000+fac*10+fac*2.5,'k','linewidth',2)
% plot(Range(LFPt{5},'s'),fac*Data(LFPt{5})/1000+fac*5+fac*2.5,'k','linewidth',2)

yl=ylim;
yl=[-150 900];
ylim(yl)

% for i=1:3
% line([Range(R{i},'s') Range(R{i},'s')],yl,'color','r')
% end
line([Range(R{1},'s') Range(R{1},'s')],yl,'color','r','linewidth',2)% DW Par
line([Range(R{2},'s') Range(R{2},'s')],yl,'color','m')% DW Pfc
line([Range(R{3},'s') Range(R{3},'s')],yl,'color','r')% DW Hpc

% for i=4:6
% line([Range(R{i},'s') Range(R{i},'s')],yl,'color','b')
% end
line([Range(R{4},'s') Range(R{4},'s')],yl,'color','b','linewidth',2) % spi Par
line([Range(R{5},'s') Range(R{5},'s')],yl,'color','b') % spi Pfc
line([Range(R{6},'s') Range(R{6},'s')],yl,'color','c') % spi Hpc
% for i=7:9
% line([Range(R{i},'s') Range(R{i},'s')],yl','color','g')
% end
line([Range(R{7},'s') Range(R{7},'s')],yl,'color','g','linewidth',2) %DW Bulb
line([Range(R{8},'s') Range(R{8},'s')],yl,'color','g','linewidth',1) %Sp Bulb
line([Range(R{9},'s') Range(R{9},'s')],yl,'color','y','linewidth',2) %Rip

%set(gcf,'Position',[1283 587 1276 348])

% i=0;
% i=i+1; labels{i}='DW Par';
% i=i+1; labels{i}='DW Pfc';
% i=i+1; labels{i}='DW Hpc';
% i=i+1; labels{i}='Sp Par';
% i=i+1; labels{i}='Sp Pfc';
% i=i+1; labels{i}='Sp Hpc';
% i=i+1; labels{i}='DW Bulb';
% i=i+1; labels{i}='Sp Bulb';
% i=i+1; labels{i}='Ri Hpc';

xlim([a a+del])
