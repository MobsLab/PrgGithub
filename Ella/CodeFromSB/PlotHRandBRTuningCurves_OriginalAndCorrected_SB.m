Reorder = 1;
SmoFact = 2;
cd /media/DataMOBsRAIDN/ProjectEmbReact/Data_ella

%% Plot tuning curves
load('BF_tuning.mat')
% subplot(221)
subplot(121)
ZScSp = smooth2a(nanzscore(original')',0,SmoFact);
[val,ind]= max(ZScSp');
[~,ind]= sort(ind);
if Reorder ==0
    ind = 1:length(ind);
end
FreqLimsBF=2:11;
imagesc(FreqLimsBF,1:length(ind),ZScSp(ind,:))
colormap parula
xlabel('OB Frequency')
ylabel('# SU ordered by preferred frequency')
title('original')
caxis([-2 2])

% subplot(222)
subplot(122)
ZScSp = smooth2a(nanzscore(motion')',0,SmoFact);
imagesc(FreqLimsBF,1:length(ind),ZScSp(ind,:))
colormap parula
xlabel('OB Frequency')
ylabel('# SU ordered by preferred frequency')
title('corrected')
caxis([-2 2])

load('HR_tuning.mat')
% subplot(223)
subplot(121)
ZScSp = smooth2a(nanzscore(original')',0,SmoFact);
[val,ind]= max(ZScSp');
[~,ind]= sort(ind);
FreqLimsHR = 8.2:12.2;
imagesc(FreqLimsHR,1:length(ind),ZScSp(ind,:))
colormap parula
xlabel('HR Frequency')
ylabel('# SU ordered by preferred frequency')
title('original')
caxis([-1.5 1.5])


% subplot(224)
subplot(122)
ZScSp = smooth2a(nanzscore(motion')',0,SmoFact);
imagesc(FreqLimsHR,1:length(ind),ZScSp(ind,:))
if Reorder ==0
    ind = 1:length(ind);
end
colormap parula
xlabel('HR Frequency')
ylabel('# SU ordered by preferred frequency')
title('corrected')
caxis([-1.5 1.5])


%% Look at individual neurons
figure
clf
load('BF_tuning.mat')
SmoFact = 1;
ZScSp = smooth2a(nanzscore(original')',0,SmoFact);
[val,ind]= max(ZScSp');
[~,ind]= sort(ind);
ZScSp = ZScSp(ind,:);

ZScSp2 = smooth2a(nanzscore(motion')',0,SmoFact);
ZScSp2 = ZScSp2(ind,:);

clf,ha = tight_subplot(12,30,0,0.01,0.01);
for ind = 1:size(ZScSp,1)
    axes(ha((ind)));
plot(ZScSp(ind,:),'k')
hold on
plot(ZScSp2(ind,:),'r')
% pause
% clf
 set(gca,'XTick',[],'YTick',[])
makepretty
end


figure
clf
load('HR_tuning.mat')
SmoFact = 1;
ZScSp = smooth2a(nanzscore(original')',0,SmoFact);
[val,ind]= max(ZScSp');
[~,ind]= sort(ind);
ZScSp = ZScSp(ind,:);

ZScSp2 = smooth2a(nanzscore(motion')',0,SmoFact);
ZScSp2 = ZScSp2(ind,:);

clf,ha = tight_subplot(11,20,0,0.01,0.01);
for ind = 1:size(ZScSp,1)
    axes(ha((ind)));
plot(ZScSp(:,:),'k')
hold on
plot(ZScSp2(:,:),'r')
% pause
% clf
 set(gca,'XTick',[],'YTick',[])
makepretty
end

%% 

figure
subplot(211)
load('BF_tuning.mat')
plot(nanmean(zscore(original(:,:)' - motion(:,:)')')')
ylim([-1.5 1.5])
line(xlim,[0 0])
line(xlim,[0 0],'color','k')
title('HR')
ylabel('diff original - corrected')
title('BR')
makepretty
subplot(212)
load('HR_tuning.mat')
plot(nanmean(zscore(original(:,:)' - motion(:,:)')')')
ylim([-1.5 1.5])
line(xlim,[0 0])
line(xlim,[0 0],'color','k')
title('HR')
ylabel('diff original - corrected')
title('HR')
makepretty