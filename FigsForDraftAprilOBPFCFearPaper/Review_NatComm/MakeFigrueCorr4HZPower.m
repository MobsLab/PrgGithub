%% Get PFC figures
close all
% cd C:\Users\sbagur\Dropbox\Mobs_member\SophieBagur\DataKB
cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/DataKB
% load('DataPFCFreezing.mat')
load('DataPFCFreezing.mat','TimeStartStop','TpsNorm')
load('DataPFCFreezing_VeryRes2.mat')
load('DataPFCFreezing_BBW.mat')
load('4HZNorma.mat')

Thresh = 0.3;
DatMat = zscore([StartResp{1},StopResp{1}]')';
Temp = zscore(NormResp{1}')';
SustValNorm = nanmean(Temp(:,13:28)');
SustVal = nanmean(DatMat(:,75:125)');

clear DatMatCl
for neur = 1:size(DatMat,1)
    MeanNoFzNew(neur) = nanmean(DatMat(neur,[1:40,210:250]));
    MeanFzNew(neur) = nanmean(DatMat(neur,[75:125]));
    Skeletton = [ones(1,62)*MeanNoFzNew(neur),ones(1,126)*MeanFzNew(neur),ones(1,62)*MeanNoFzNew(neur)];
    DatMatCl(neur,:) =  DatMat(neur,:)-Skeletton;
end
% DatMatCl = zscore(DatMatCl')';
OnsetVal = nanmean(DatMatCl(:,63:88)');
OffsetVal = nanmean(DatMatCl(:,[63:88]+125)');
OnsetValrg = range(DatMatCl(:,63:88)');
OffsetValrg = range(DatMatCl(:,[63:88]+125)');

DatMat_B = zscore([StartResp_B{1},StopResp_B{1}]')';
Temp = zscore(NormResp_B{1}')';
SustValNorm_B = nanmean(Temp(:,13:28)');
SustVal_B = nanmean(DatMat_B(:,75:125)');
DatNormZ = zscore(NormResp{1}')';

clear DatMatCl_B
for neur = 1:size(DatMat_B,1)
    MeanNoFzNew(neur) = nanmean(DatMat_B(neur,[1:40,210:250]));
    MeanFzNew(neur) = nanmean(DatMat_B(neur,[75:125]));
    Skeletton = [ones(1,62)*MeanNoFzNew(neur),ones(1,126)*MeanFzNew(neur),ones(1,62)*MeanNoFzNew(neur)];
    DatMatCl_B(neur,:) =  DatMat_B(neur,:)-Skeletton;
end
% DatMatCl_B = zscore(DatMatCl_B')';
OnsetVal_B = nanmean(DatMatCl_B(:,63:88)');
OffsetVal_B = nanmean(DatMatCl_B(:,[63:88]+125)');
OnsetValrg_B = range(DatMatCl_B(:,63:88)');
OffsetValrg_B = range(DatMatCl_B(:,[63:88]+125)');

DatNormZ_B = zscore(NormResp_B{1}')';


figure
imagesc(corr(DatNormZ))
axis square
axis xy
caxis([-0.6 0.8])
colormap redblue
set(gca,'XTick',[5:5:35],'XTickLabel',{'-0.25','0','0.25','0.5','0.75','1','1.25'})
set(gca,'YTick',[5:5:35],'YTickLabel',{'-0.25','0','0.25','0.5','0.75','1','1.25'})


X2 = [1:40];
X = [1:2:40];
A = corr(DatNormZ);
clf
plot(X2,nanmean(A(11:15,:)),'color',[251,176,64]/256,'linewidth',5),hold on
plot(X2,nanmean(A(25:29,:)),'color',[127,63,152]/256,'linewidth',5)
ylabel('Population vector correlation')
ylim([-0.6 1])
makepretty
set(gca,'YTick',[-2:2])
yyaxis right
plot(X,nanmean(Dat),'linewidth',2,'color','k')
plot(X,nanmean(Dat),'linewidth',2,'color',[0.8 0.8 0.8])
ylim([-1.7 1.7])
set(gca,'XTick',[10 30],'XTickLabel',{'0','1'})
line([10 10],ylim,'linewidth',2,'color',[251,176,64]/256), hold on
line([30 30],ylim,'linewidth',2,'color',[127,63,152]/256), hold on
ylabel('4Hz power')
makepretty
xlabel('Norm. Time')
set(gca,'YColor','k')
set(gca,'YTick',[-0.5:0.5:1])




%% Get data from fi
uiopen('C:\Users\sbagur\Documents\espci\Projects\Projects-InProgress\OB4HZpapier\Review-NatureComm\NewFiguresFinal\Figure5\SpectroGramTriggered_NormPer.fig',1)
fig = gcf;
axObjs = fig.Children
dataObjs = axObjs.Children;

for k  = 1:size(dataObjs,1)
x(k,:) = dataObjs(k).XData;
y(k,:) = dataObjs(k).YData;
end

Dat=y;
X = x(1,:);
save('4HZNorma.mat','Dat','X')
