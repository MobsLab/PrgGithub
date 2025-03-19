clear all
load('PiezoData_Corrected.mat')
[params,movingwin,suffix]=SpectrumParametersBM('piezo');
Piezo_Mouse_tsd = FilterLFP(Piezo_Mouse_tsd,[1 30],1024);
[Sp,t,f]=mtspecgramc(Data(Piezo_Mouse_tsd),movingwin,params);
Sp_tsd = tsd(t*1e4,log(Sp));
load('PiezoData_Corrected.mat')
load('SleepScoring_OBGamma.mat', 'Sleep')
load('SleepScoring_OBGamma.mat', 'Wake')
load('SleepScoring_OBGamma.mat', 'REMEpoch')
load('SleepScoring_OBGamma.mat', 'SWSEpoch')

figure
ax = tight_subplot(4,1,0.01);
axes(ax(1))
RemBlock =0;
RemData = [];
SWSEpoch = dropShortIntervals(SWSEpoch,10*1e4);
SWSEpoch = mergeCloseIntervals(SWSEpoch,1*1e4);
for i = 1 :length(Start(SWSEpoch))
    dat = Data(Restrict(Sp_tsd,subset(SWSEpoch,i)));
    RemBlock(i+1) = RemBlock(i) + size(dat,1);
    RemData = [RemData;dat];
end
imagesc(1:size(RemData,1),f,zscore(RemData')), axis xy
hold on
plot(RemBlock,12,'k*')

axes(ax(2))
% Acc = [];
% for i = 1 :length(Start(SWSEpoch))
%         dat = Data(Restrict(MovAcctsd,subset(SWSEpoch,i)));
% 
% Acc = [Acc;dat];
% end
% plot(dat)
% xlim([0 length(dat)])
load('HR_Low_Spectrum.mat')
Sp_tsd_HR = tsd(Spectro{2}*1e4,log(Spectro{1}));
RemBlock =0;
RemData = [];
SWSEpoch = dropShortIntervals(SWSEpoch,10*1e4);
SWSEpoch = mergeCloseIntervals(SWSEpoch,1*1e4);
for i = 1 :length(Start(SWSEpoch))
    dat = Data(Restrict(Sp_tsd_HR,subset(SWSEpoch,i)));
    RemBlock(i+1) = RemBlock(i) + size(dat,1);
    RemData = [RemData;dat];

end
imagesc(1:size(RemData,1),f,zscore(RemData')), axis xy
hold on
plot(RemBlock,12,'k*')


axes(ax(3))
load('B_Low_Spectrum.mat')
Sp_tsd_LB = tsd(Spectro{2}*1e4,log(Spectro{1}));
RemBlock =0;
RemData = [];
SWSEpoch = dropShortIntervals(SWSEpoch,10*1e4);
SWSEpoch = mergeCloseIntervals(SWSEpoch,1*1e4);
for i = 1 :length(Start(SWSEpoch))
    dat = Data(Restrict(Sp_tsd_LB,subset(SWSEpoch,i)));
    RemBlock(i+1) = RemBlock(i) + size(dat,1);
    RemData = [RemData;dat];

end
imagesc(1:size(RemData,1),f,zscore(RemData')), axis xy
hold on
plot(RemBlock,12,'k*')


axes(ax(4))
load('H_Low_Spectrum.mat')
Sp_tsd_H = tsd(Spectro{2}*1e4,log(Spectro{1}));RemBlock =0;
RemData = [];
SWSEpoch = dropShortIntervals(SWSEpoch,10*1e4);
SWSEpoch = mergeCloseIntervals(SWSEpoch,1*1e4);
for i = 1 :length(Start(SWSEpoch))
    dat = Data(Restrict(Sp_tsd_H,subset(SWSEpoch,i)));
    RemBlock(i+1) = RemBlock(i) + size(dat,1);
    RemData = [RemData;dat];

end
imagesc(1:size(RemData,1),f,zscore(RemData')), axis xy
hold on
plot(RemBlock,12,'k*')



figure
ax = tight_subplot(4,1,0.01);
axes(ax(1))
RemBlock =0;
RemData = [];
REMEpoch = dropShortIntervals(REMEpoch,10*1e4);
REMEpoch = mergeCloseIntervals(REMEpoch,1*1e4);
for i = 1 :length(Start(REMEpoch))
    dat = Data(Restrict(Sp_tsd,subset(REMEpoch,i)));
    RemBlock(i+1) = RemBlock(i) + size(dat,1);
    RemData = [RemData;dat];
end
imagesc(1:size(RemData,1),f,zscore(RemData')), axis xy
hold on
plot(RemBlock,12,'k*')

axes(ax(2))
% Acc = [];
% for i = 1 :length(Start(REMEpoch))
%         dat = Data(Restrict(MovAcctsd,subset(REMEpoch,i)));
% 
% Acc = [Acc;dat];
% end
% plot(dat)
% xlim([0 length(dat)])
load('HR_Low_Spectrum.mat')
Sp_tsd_HR = tsd(Spectro{2}*1e4,log(Spectro{1}));
RemBlock =0;
RemData = [];
REMEpoch = dropShortIntervals(REMEpoch,10*1e4);
REMEpoch = mergeCloseIntervals(REMEpoch,1*1e4);
for i = 1 :length(Start(REMEpoch))
    dat = Data(Restrict(Sp_tsd_HR,subset(REMEpoch,i)));
    RemBlock(i+1) = RemBlock(i) + size(dat,1);
    RemData = [RemData;dat];

end
imagesc(1:size(RemData,1),f,zscore(RemData')), axis xy
hold on
plot(RemBlock,12,'k*')


axes(ax(3))
load('B_Low_Spectrum.mat')
Sp_tsd_LB = tsd(Spectro{2}*1e4,log(Spectro{1}));
RemBlock =0;
RemData = [];
REMEpoch = dropShortIntervals(REMEpoch,10*1e4);
REMEpoch = mergeCloseIntervals(REMEpoch,1*1e4);
for i = 1 :length(Start(REMEpoch))
    dat = Data(Restrict(Sp_tsd_LB,subset(REMEpoch,i)));
    RemBlock(i+1) = RemBlock(i) + size(dat,1);
    RemData = [RemData;dat];

end
imagesc(1:size(RemData,1),f,zscore(RemData')), axis xy
hold on
plot(RemBlock,12,'k*')


axes(ax(4))
load('H_Low_Spectrum.mat')
Sp_tsd_H = tsd(Spectro{2}*1e4,log(Spectro{1}));RemBlock =0;
RemData = [];
REMEpoch = dropShortIntervals(REMEpoch,10*1e4);
REMEpoch = mergeCloseIntervals(REMEpoch,1*1e4);
for i = 1 :length(Start(REMEpoch))
    dat = Data(Restrict(Sp_tsd_H,subset(REMEpoch,i)));
    RemBlock(i+1) = RemBlock(i) + size(dat,1);
    RemData = [RemData;dat];

end
imagesc(1:size(RemData,1),f,zscore(RemData')), axis xy
hold on
plot(RemBlock,12,'k*')

