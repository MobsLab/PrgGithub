cd /media/DataMOBsRAIDN/ProjectEmbReact/Data_ella
load('BF_tuning.mat')
subplot(221)
ZScSp = smooth2a(nanzscore(original')',0,2);
[val,ind]= max(ZScSp');
[~,ind]= sort(ind);
imagesc(FreqLims,1:length(ind),ZScSp(ind,:))
colormap parula
xlabel('OB Frequency')
ylabel('# SU ordered by preferred frequency')
title('original')
caxis([-2 2])

subplot(222)
ZScSp = smooth2a(nanzscore(motion')',0,2);
imagesc(FreqLims,1:length(ind),ZScSp(ind,:))
colormap parula
xlabel('OB Frequency')
ylabel('# SU ordered by preferred frequency')
title('corrected')
caxis([-2 2])

load('HR_tuning.mat')
subplot(223)
ZScSp = smooth2a(nanzscore(original')',0,2);
[val,ind]= max(ZScSp');
[~,ind]= sort(ind);
imagesc(8.2:12.2,1:length(ind),ZScSp(ind,:))
colormap parula
xlabel('HR Frequency')
ylabel('# SU ordered by preferred frequency')
title('original')
caxis([-1.5 1.5])


subplot(224)
ZScSp = smooth2a(nanzscore(motion')',0,2);
imagesc(FreqLims,1:length(ind),ZScSp(ind,:))
colormap parula
xlabel('HR Frequency')
ylabel('# SU ordered by preferred frequency')
title('corrected')
caxis([-1.5 1.5])

