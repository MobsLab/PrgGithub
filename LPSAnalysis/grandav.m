
    f=figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3)/2 scrsz(4)]);
load('DataLPS1.mat')
s=1;
pvals=[27:39];
plotvals=[1,2,3,4,9,10,11,12,17,18,19,20,8]
for k=1:length(pvals)
    clear Dat;
s=1;
for m=1:4
    for num=1:6
        try
            Dat(s,:)=DataLPS{num,pvals(k),m};
            s=s+1;
        end
    end
end

subplot(3,8,plotvals(k))
try
boundedline(Bds,nanmean(Dat),nanvar(Dat));
  xlim([-30 30])
   hold on
  a=ylim;
          line([0 0],[a(1) a(2)],'LineStyle','--','color','k','linewidth',2)
catch
  boundedline(TRS,nanmean(Dat),nanvar(Dat));
  xlim([-0.4 0.4])
  ylim([-2 4])
   hold on
  a=ylim;
          line([0 0],[a(1) a(2)],'LineStyle','--','color','k','linewidth',2)
  end
end

load('DataLPS2.mat')
s=1;
pvals=[14,15,16,18,19,20,22,23,24]+13;
plotvals=[5,6,7,13,14,15,21,22,23]
for k=1:length(pvals)
    clear Dat;
s=1;
for m=1:4
    for num=1:6
        try
            Dat(s,:)=DataLPS{num,pvals(k),m};
            s=s+1;
        end
    end
end

subplot(3,8,plotvals(k))
try
boundedline(Bds,nanmean(Dat),nanvar(Dat));
  xlim([-30 30])
  hold on
  a=ylim;
          line([0 0],[a(1) a(2)],'LineStyle','--','color','k','linewidth',2)

catch
  boundedline(TRS,nanmean(Dat),nanvar(Dat));
  xlim([-0.4 0.4])
  ylim([-2 4])
   hold on
  a=ylim;
          line([0 0],[a(1) a(2)],'LineStyle','--','color','k','linewidth',2)
  end
end

subplot(3,8,1)
ylabel('Delta rel to Spindle')
title('8:12Hz')
subplot(3,8,2)
title('10:15Hz')
subplot(3,8,3)
title('15:20Hz')
subplot(3,8,4)
title('10:20Hz')
subplot(3,8,5)
title('5:10Hz')
subplot(3,8,6)
title('10:14Hz')
subplot(3,8,7)
title('6:8Hz')
subplot(3,8,8)
ylabel('Delta rel to Ripple')
subplot(3,8,9)
ylabel('Ripple rel to Spindle')
subplot(3,8,17)
ylabel('Ripple power rel to Spindle')

