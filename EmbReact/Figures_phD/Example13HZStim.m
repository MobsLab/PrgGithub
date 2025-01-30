load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse540/20170727-EXT24-laser13/LFPData/LFP5.mat')

figure
FilLFP = FilterLFP(LFP,[1 70],1024);
plot(Range(LFP,'s'),Data(FilLFP),'k','linewidth',2)
set(gca,'XTick',[],'FontSize',20,'LineWidth',2,'YTick',[])

FilLFP = FilterLFP(LFP,[1 8],1024);
hold on
plot(Range(LFP,'s'),Data(FilLFP),'r','linewidth',3)
xlim([636 639])


figure
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse613/20171005-EXT-24/LFPData/LFP25.mat')
clf
FilLFP = FilterLFP(LFP,[1 50],1024);
plot(Range(LFP,'s'),Data(FilLFP),'k','linewidth',2)
set(gca,'XTick',[],'FontSize',20,'LineWidth',2,'YTick',[])

FilLFP = FilterLFP(LFP,[1 10],1024);
hold on
plot(Range(LFP,'s'),Data(FilLFP),'r','linewidth',3)
xlim([1019 1023.2])