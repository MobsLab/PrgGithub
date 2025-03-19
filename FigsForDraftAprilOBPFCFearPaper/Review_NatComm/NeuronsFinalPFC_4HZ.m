%% Get PFC figures
% close all
cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/DataKB
load('DataPFCFreezing.mat')
load('DataPFCFreezing_BBW.mat')

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
DatNormZ = zscore(NormResp_new{1}')';

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


UseForTresh = SustVal;
% figure
[~,ind] = sort(UseForTresh);
% imagesc(TpsNorm,1:size(DatNormZ,1),DatNormZ(ind,:))
% caxis([-3 3])

figure
subplot(3,1,1)
errorbar(1:40,nanmean(DatNormZ(UseForTresh<-Thresh,:)),stdError(DatNormZ(UseForTresh<-Thresh,:)),'color','k','linewidth',2)
ylim([-2 2])
line([11 11],ylim,'linewidth',2)
line([30 30],ylim,'linewidth',2)
makepretty
subplot(3,1,2)
errorbar(1:40,nanmean(DatNormZ(abs(UseForTresh)<Thresh,:)),stdError(DatNormZ(abs(UseForTresh)<Thresh,:)),'color','k','linewidth',2)
ylim([-2 2])
line([11 11],ylim,'linewidth',2)
line([30 30],ylim,'linewidth',2)
makepretty
subplot(3,1,3)
errorbar(1:40,nanmean(DatNormZ((UseForTresh)>Thresh,:)),stdError(DatNormZ((UseForTresh)>Thresh,:)),'color','k','linewidth',2)
ylim([-2 2])
line([11 11],ylim,'linewidth',2)
line([30 30],ylim,'linewidth',2)
makepretty

figure
subplot(3,1,1)
errorbar(1:250,nanmean(DatMat(UseForTresh<-Thresh,:)),stdError(DatMat(UseForTresh<-Thresh,:)),'color','k')
ylim([-2 2])
line([62 62],ylim,'linewidth',2)
line([187 187],ylim,'linewidth',2)
makepretty
subplot(3,1,2)
errorbar(1:250,nanmean(DatMat(abs(UseForTresh)<Thresh,:)),stdError(DatMat(abs(UseForTresh)<Thresh,:)),'color','k')
ylim([-2 2])
line([62 62],ylim,'linewidth',2)
line([187 187],ylim,'linewidth',2)
makepretty
subplot(3,1,3)
errorbar(1:250,nanmean(DatMat((UseForTresh)>Thresh,:)),stdError(DatMat((UseForTresh)>Thresh,:)),'color','k')
ylim([-2 2])
line([62 62],ylim,'linewidth',2)
line([187 187],ylim,'linewidth',2)
makepretty


figure
subplot(3,1,1)
bar([TimeStartStop;TimeStartStop+5000]/1E3,runmean(nanmean(DatMat((UseForTresh)<-Thresh,:)),1),'FaceColor',[0.3 0.3 0.3],'EdgeColor',[0.3 0.3 0.3])
ylim([-1.1 1.1])
line([0 0],ylim,'linewidth',2,'color',[0.6 0.6 0.6]), hold on
line([5 5],ylim,'linewidth',2,'color',[0.6 0.6 0.6])
makepretty
set(gca,'XTick',[-2,0,2,3,5,7],'XTickLabel',{'-2','0','2','-2','0','2'})
ylabel('FR (zscore)')
xlabel('Time to onset/offset(s)')

subplot(3,1,2)
bar([TimeStartStop;TimeStartStop+5000]/1E3,runmean(nanmean(DatMat(abs(UseForTresh)<Thresh,:)),1),'FaceColor',[0.3 0.3 0.3],'EdgeColor',[0.3 0.3 0.3])
ylim([-1.1 1.1])
line([0 0],ylim,'linewidth',2,'color',[0.6 0.6 0.6]), hold on
line([5 5],ylim,'linewidth',2,'color',[0.6 0.6 0.6])
makepretty
set(gca,'XTick',[-2,0,2,3,5,7],'XTickLabel',{'-2','0','2','-2','0','2'})
ylabel('FR (zscore)')
xlabel('Time to onset/offset(s)')

subplot(3,1,3)
bar([TimeStartStop;TimeStartStop+5000]/1E3,runmean(nanmean(DatMat((UseForTresh)>Thresh,:)),1),'FaceColor',[0.3 0.3 0.3],'EdgeColor',[0.3 0.3 0.3])
ylim([-1.1 1.1])
line([0 0],ylim,'linewidth',2,'color',[0.6 0.6 0.6]), hold on
line([5 5],ylim,'linewidth',2,'color',[0.6 0.6 0.6])
set(gca,'XTick',[-2,0,2,3,5,7],'XTickLabel',{'-2','0','2','-2','0','2'})
ylabel('FR (zscore)')
xlabel('Time to onset/offset(s)')
makepretty


A = {nanmean((PValNeur(UseForTresh<-Thresh)<0.001)),nanmean((PValNeur(abs(UseForTresh)<Thresh)<0.001)),nanmean((PValNeur((UseForTresh)>Thresh)<0.001))};

figure
subplot(311)
pie([A{1},1-A{1}])

subplot(312)
pie([A{2},1-A{2}])

subplot(313)
pie([A{3},1-A{3}])
colormap gray

[h,p, chi2stat,df] = prop_test([nansum((PValNeur(UseForTresh<-Thresh)<0.001)),nansum((PValNeur(abs(UseForTresh)<Thresh)<0.001))], [length(PValNeur(UseForTresh<-Thresh)),length(PValNeur(abs(UseForTresh)<Thresh))],0)

[h,p, chi2stat,df] = prop_test([nansum((PValNeur(abs(UseForTresh)>Thresh)<0.001)),nansum((PValNeur(abs(UseForTresh)<Thresh)<0.001))], [length(PValNeur(abs(UseForTresh)>Thresh)),length(PValNeur(abs(UseForTresh)<Thresh))],0)

nmbBin = 15;
dB = 2*pi/nmbBin;
B = [dB/2:dB:2*pi-dB/2];

nmbBin_Sin = 40;
dB_Sin = 2*pi/nmbBin_Sin;
B_Sin = [dB_Sin/2:dB_Sin:2*pi-dB_Sin/2];

figure
subplot(311)
[mu, Kappa, pval] = CircularMean_SBSB(PhaseNeur((UseForTresh)<-Thresh & PValNeur<0.05));
C = runmean(hist(PhaseNeur((UseForTresh)<-Thresh & PValNeur<0.05),B),2);
hold on
bar(B,2*nmbBin*C/sum(C),1,'FaceColor',[0.3 0.3 0.3],'EdgeColor',[0.3 0.3 0.3])
bar(B+2*pi,2*nmbBin*C/sum(C),1,'FaceColor',[0.3 0.3 0.3],'EdgeColor',[0.3 0.3 0.3])
vm = von_mises_pdf(B_Sin-pi,mu+pi,Kappa);
plot([0 B_Sin 2*pi],2*nmbBin_Sin*dB_Sin*[(vm(1)+vm(end))/2 vm (vm(1)+vm(end))/2],'lineWidth',2,'Color','r');
plot([0 B_Sin 2*pi]+2*pi,2*nmbBin_Sin*dB_Sin*[(vm(1)+vm(end))/2 vm (vm(1)+vm(end))/2],'lineWidth',2,'Color','r');
ylabel('% spikes');
xlabel('Phase (rad)');
xlim([-0.1 4*pi+0.1])
set(gca,'XTick',[0,pi,2*pi,3*pi,4*pi],'XTickLabel',{'0','?','2?','3?','4?'})
% title(['K : ' num2str(Kappa) ', p = ' num2str(pval),', Ph ',sprintf('%.2f',mu)])
makepretty

subplot(312)
[mu, Kappa, pval] = CircularMean_SBSB(PhaseNeur(abs(UseForTresh)>Thresh & PValNeur<0.05));
C = runmean(hist(PhaseNeur(abs(UseForTresh)>Thresh & PValNeur<0.05),B),2);
hold on
bar(B,2*nmbBin*C/sum(C),1,'FaceColor',[0.3 0.3 0.3],'EdgeColor',[0.3 0.3 0.3])
bar(B+2*pi,2*nmbBin*C/sum(C),1,'FaceColor',[0.3 0.3 0.3],'EdgeColor',[0.3 0.3 0.3])
ylabel('% spikes');
xlabel('Phase (rad)');
xlim([-0.1 4*pi+0.1])
set(gca,'XTick',[0,pi,2*pi,3*pi,4*pi],'XTickLabel',{'0','?','2?','3?','4?'})
% title(['K : ' num2str(Kappa) ', p = ' num2str(pval),', Ph ',sprintf('%.2f',mu)])
makepretty

subplot(313)
[mu, Kappa, pval] = CircularMean_SBSB(PhaseNeur((UseForTresh)>Thresh & PValNeur<0.05));
C = runmean(hist(PhaseNeur((UseForTresh)>Thresh & PValNeur<0.05),B),2);
hold on
bar(B,2*nmbBin*C/sum(C),1,'FaceColor',[0.3 0.3 0.3],'EdgeColor',[0.3 0.3 0.3])
bar(B+2*pi,2*nmbBin*C/sum(C),1,'FaceColor',[0.3 0.3 0.3],'EdgeColor',[0.3 0.3 0.3])
vm = von_mises_pdf(B_Sin-pi,mu+pi,Kappa);
plot([0 B_Sin 2*pi],2*nmbBin_Sin*dB_Sin*[(vm(1)+vm(end))/2 vm (vm(1)+vm(end))/2],'lineWidth',2,'Color','r');
plot([0 B_Sin 2*pi]+2*pi,2*nmbBin_Sin*dB_Sin*[(vm(1)+vm(end))/2 vm (vm(1)+vm(end))/2],'lineWidth',2,'Color','r');
ylabel('% spikes');
xlabel('Phase (rad)');
xlim([-0.1 4*pi+0.1])
set(gca,'XTick',[0,pi,2*pi,3*pi,4*pi],'XTickLabel',{'0','?','2?','3?','4?'})
% title(['K : ' num2str(Kappa) ', p = ' num2str(pval),', Ph ',sprintf('%.2f',mu)])
makepretty

circ_cmtest(PhaseNeur((SustValNorm)<-Thresh & PValNeur<0.05)',PhaseNeur(SustValNorm>Thresh & PValNeur<0.05)')

%% Onset vs offset for the three groups
figure
subplot(311)
PlotErrorBarN_KJ({OnsetVal((UseForTresh)<-Thresh);OffsetVal((UseForTresh)<-Thresh)},'paired',0,'showpoints',0,'newfig',0,'barcolors',{[251,176,64]/256,[127,63,152]/256})
ylim([-0.65 0.65])
set(gca,'XTick',[1,2],'XTickLabel',{'Onset','Offset'})
ylabel('FR (zscore)')
xlim([0.5 2.5])
makepretty
subplot(312)
PlotErrorBarN_KJ({OnsetVal(abs(UseForTresh)<Thresh);OffsetVal(abs(UseForTresh)<Thresh)},'paired',0,'showpoints',0,'newfig',0,'barcolors',{[251,176,64]/256,[127,63,152]/256},'ShowSigstar','none')
ylim([-0.65 0.65])
set(gca,'XTick',[1,2],'XTickLabel',{'Onset','Offset'})
ylabel('FR (zscore)')
xlim([0.5 2.5])
makepretty
subplot(313)
PlotErrorBarN_KJ({OnsetVal((UseForTresh)>Thresh);OffsetVal((UseForTresh)>Thresh)},'paired',0,'showpoints',0,'newfig',0,'barcolors',{[251,176,64]/256,[127,63,152]/256},'ShowSigstar','none')
ylim([-0.65 0.65])
set(gca,'XTick',[1,2],'XTickLabel',{'Onset','Offset'})
ylabel('FR (zscore)')
xlim([0.5 2.5])
makepretty

figure
% DatMat(find(nanmean(StartResp')<0.1),:) = [];
[EigVect,EigVals]=PerformPCA(DatMat);
[val,ind] = sort(SustVal);
imagesc([TimeStartStop;TimeStartStop+5000]/1E3,1:size(DatMat,1),DatMat(ind,:))
line([0 0],ylim,'linewidth',2,'color',[0.6 0.6 0.6]), hold on
line([5 5],ylim,'linewidth',2,'color',[0.6 0.6 0.6])
line(xlim,[1 1]*find(val>-Thresh,1,'first'),'color','w','linestyle',':','linewidth',2)
line(xlim,[1 1]*find(val>Thresh,1,'first'),'color','w','linestyle',':','linewidth',2)
caxis([-3 3])
ylabel('Unit #')
makepretty
% set(gca,'XTick',[])
set(gca,'LineWidth',2,'FontSize',20), box off

figure
subplot(2,1,1)
ylim([-15 15]), hold on
line([0 0],ylim,'linewidth',2,'color',[0.6 0.6 0.6]), hold on
line([5 5],ylim,'linewidth',2,'color',[0.6 0.6 0.6])
plot([TimeStartStop;TimeStartStop+5000]/1E3,runmean(EigVect(:,1)'*zscore(DatMat')',2),'k','linewidth',2)
hold on
ylim([-15 15])
set(gca,'LineWidth',2,'FontSize',12), box off
ylabel('PC1')
xlim([-2.5 7.5])
set(gca,'XTick',[])
makepretty

subplot(2,1,2)
ylim([-15 15]), hold on
line([0 0],ylim,'linewidth',2,'color',[0.6 0.6 0.6]), hold on
line([5 5],ylim,'linewidth',2,'color',[0.6 0.6 0.6])
plot([TimeStartStop;TimeStartStop+5000]/1E3,-runmean(EigVect(:,2)'*zscore(DatMat')',2),'k','linewidth',2)
set(gca,'LineWidth',2,'FontSize',12), box off
xlabel('Time to onset/offset (s)')
set(gca,'XTick',[-2,0,2,3,5,7],'XTickLabel',{'-2','0','2','-2','0','2'})
ylabel('PC2')
makepretty
xlim([-2.5 7.5])



%%


close all

figure
[no,xo1,xo2]  = hist2dDB(SustValNorm(PValNeur<0.05),PhaseNeur(PValNeur<0.05),20,20);
imagesc(xo1,xo2,smooth2a(no,2,2)')
hold on
plot(SustValNorm(PValNeur<0.05),PhaseNeur(PValNeur<0.05),'r.','MarkerSize',20)
xlabel('SustainedResponse')
ylabel('Preferred phase')
makepretty

for neur = 1:size(DatMat,1)
    DatMatClt(neur,:) = DatMatCl(neur,:)*sign(OffsetVal(neur));
end
for neur = 1:size(DatMat_B,1)
    DatMatClt_B(neur,:) = DatMatCl_B(neur,:)*sign(OffsetVal_B(neur));
end

for neur = 1:size(DatMat,1)
    DatMatNormt(neur,:) = -DatNormZ(neur,:)*sign(SustVal(neur));
end
for neur = 1:size(DatMat_B,1)
    DatMatNormt_B(neur,:) = -DatNormZ_B(neur,:)*sign(SustVal_B(neur));
end
figure
errorbar(1:40,runmean(nanmean(DatMatNormt(PValNeur<0.05,:)),1),stdError(runmean(DatMatNormt(PValNeur<0.05,:)',1)'),'LineWidth',2,'color','k')
hold on
errorbar(1:40,runmean(nanmean(DatMatNormt(PValNeur>0.05,:)),1),stdError(runmean(DatMatNormt(PValNeur>0.05,:)',1)'),'LineWidth',2,'color',[0.6 0.6 0.6])
errorbar(1:40,runmean(nanmean(DatMatNormt_B(:,:)),1),stdError(runmean(DatMatNormt_B(:,:)',1)'),'LineWidth',2,'color',[0.8 0.2 0.2])
xlabel('Norm. Time')    
ylabel('Fr (zscore)')
set(gca,'XTick',[5:5:35],'XTickLabel',{'-0.25','0','0.25','0.5','0.75','1','1.25'})
legend('CTRL-Mod','CTRL-NonMod','OBX')
legend('CTRL-Mod','CTRL-NonMod','OBX')
makepretty

SustValNormt = nanmean(DatMatNormt(:,13:25)')';
SustValNormt_B = nanmean(DatMatNormt_B(:,13:25)')';

Offsett = nanmean(DatMatNormt(:,31:36)')';
Offsett_B = nanmean(DatMatNormt_B(:,31:36)')';

Onsett = nanmean(DatMatNormt(:,10:13)')';
Onsett_B = nanmean(DatMatNormt_B(:,10:13)')';

figure
subplot(131)
A = {abs(Onsett(PValNeur<0.05)),abs(Onsett(PValNeur>0.05)),abs(Onsett_B)};
[p,~,s] = PlotErrorBarN_KJ(A,'paired',0,'Newfig',0,'showpoints',0,'barcolors',{'k',[0.6 0.6 0.6],[0.8 0.2 0.2]})
% MakeSpreadAndBoxPlot_SB(A,{[0.4 0.4 0.4],[0.8 0.8 0.8],[0.8 0.2 0.2]},[1,3,5],{'CTRL-Mod','CTRL-NonMod','OBX'},0)
set(gca,'XTick',[1,2,3],'XTickLabel',{'CTRL-Mod','CTRL-NonMod','OBX'})
ylim([0 1.1])
xtickangle(45)
title('Onset')
makepretty
    
subplot(132)
A = {abs(SustValNormt(PValNeur<0.05)),abs(SustValNormt(PValNeur>.05)),abs(SustValNorm_B)};
[p,~,s] =PlotErrorBarN_KJ(A,'paired',0,'Newfig',0,'showpoints',0,'barcolors',{'k',[0.6 0.6 0.6],[0.8 0.2 0.2]})
% MakeSpreadAndBoxPlot_SB(A,{[0.4 0.4 0.4],[0.8 0.8 0.8],[0.8 0.2 0.2]},[1,3,5],{'CTRL-Mod','CTRL-NonMod','OBX'},0)
set(gca,'XTick',[1,2,3],'XTickLabel',{'CTRL-Mod','CTRL-NonMod','OBX'})
ylim([0 1.1])
xtickangle(45)
title('Sustained')
makepretty


subplot(133)
A = {abs(Offsett(PValNeur<0.05)),abs(Offsett(PValNeur>0.05)),abs(Offsett_B)};
[p,~,s] =PlotErrorBarN_KJ(A,'paired',0,'Newfig',0,'showpoints',0,'barcolors',{'k',[0.6 0.6 0.6],[0.8 0.2 0.2]})
% MakeSpreadAndBoxPlot_SB(A,{[0.4 0.4 0.4],[0.8 0.8 0.8],[0.8 0.2 0.2]},[1,3,5],{'CTRL-Mod','CTRL-NonMod','OBX'},0)
ylim([0 1.1])
xtickangle(45)
set(gca,'XTick',[1,2,3],'XTickLabel',{'CTRL-Mod','CTRL-NonMod','OBX'})
title('Offset')
makepretty

figure

subplot(131)
A = {abs(Onsett(PValNeur<0.05)),abs(Onsett(PValNeur>0.05)),abs(Onsett_B)};
% PlotErrorBarN_KJ(A,'paired',0,'Newfig',0,'showpoints',0)
MakeSpreadAndBoxPlot_SB(A,{[0.4 0.4 0.4],[0.8 0.8 0.8],[0.8 0.2 0.2]},[1,3,5],{'CTRL-Mod','CTRL-NonMod','OBX'},0)
ylim([0 1.3])
xtickangle(45)
title('Onset')
ylim([0 1.4])
[p(1),h,stats(1)] = ranksum(abs(Onsett(PValNeur<0.05)),abs(Onsett(PValNeur>0.05)));
[p(2),h,stats(2)] = ranksum(abs(Onsett(PValNeur>0.05)),abs(Onsett_B));
[p(3),h,stats(3)] = ranksum(abs(Onsett(PValNeur<0.05)),abs(Onsett_B));
sigstar({{1,3},{3,5},{1,5}},p)
ylabel('Amplitude')
makepretty

subplot(132)
A = {abs(SustValNormt(PValNeur<0.05)),abs(SustValNormt(PValNeur>0.05)),abs(SustValNorm_B)};
% PlotErrorBarN_KJ(A,'paired',0,'Newfig',0,'showpoints',0)
MakeSpreadAndBoxPlot_SB(A,{[0.4 0.4 0.4],[0.8 0.8 0.8],[0.8 0.2 0.2]},[1,3,5],{'CTRL-Mod','CTRL-NonMod','OBX'},0)
ylim([0 1.3])
xtickangle(45)
title('Sustained')
ylim([0 1.4])
[p(1),h,stats(1)] = ranksum(abs(SustValNormt(PValNeur<0.05)),abs(SustValNormt(PValNeur>0.05)));
[p(2),h,stats(2)] = ranksum(abs(SustValNormt(PValNeur>0.05)),abs(SustValNorm_B));
[p(3),h,stats(3)] = ranksum(abs(SustValNormt(PValNeur<0.05)),abs(SustValNorm_B));
sigstar({{1,3},{3,5},{1,5}},p)
ylabel('Amplitude')
makepretty

subplot(133)
A = {abs(Offsett(PValNeur<0.05)),abs(Offsett(PValNeur>0.05)),abs(Offsett_B)};
% PlotErrorBarN_KJ(A,'paired',0,'Newfig',0,'showpoints',0)
MakeSpreadAndBoxPlot_SB(A,{[0.4 0.4 0.4],[0.8 0.8 0.8],[0.8 0.2 0.2]},[1,3,5],{'CTRL-Mod','CTRL-NonMod','OBX'},0)
ylim([0 1.3])
xtickangle(45)
title('Offset')
ylim([0 1.4])
[p(1),h,stats(1)] = ranksum(abs(Offsett(PValNeur<0.05)),abs(Offsett(PValNeur>0.05)));
[p(2),h,stats(2)] = ranksum(abs(Offsett(PValNeur>0.05)),abs(Offsett_B));
[p(3),h,stats(3)] = ranksum(abs(Offsett(PValNeur<0.05)),abs(Offsett_B));
sigstar({{1,3},{3,5},{1,5}},p)
ylabel('Amplitude')
makepretty



% DatMat(find(nanmean(StartResp')<0.1),:) = [];
[EigVect,EigVals]=PerformPCA(DatMat);
[val,ind] = sort(SustVal);
subplot(3,1,1:2)
imagesc([TimeStartStop;TimeStartStop+5000]/1E3,1:size(DatMat,1),DatMat(ind,:))
caxis([-3 3])
xlabel('Time to Fz onset(s)')
ylabel('Number of units')
makepretty
subplot(3,1,3)
plot([TimeStartStop;TimeStartStop+5000]/1E3,runmean(EigVect(:,1)'*zscore(DatMat')',2),'linewidth',2)
hold on
plot([TimeStartStop;TimeStartStop+5000]/1E3,-runmean(EigVect(:,2)'*zscore(DatMat')',2),'linewidth',2)
xlim([-2.5 7.5])
set(gca,'LineWidth',2,'FontSize',12), box off
xlabel('Time to Fz onset(s)')
legend('PC1','PC2')
ylim([-15 15])
makepretty

figure
indclean = ind(PValNeur<0.05);
clear ValPhase ValKappa
for k =1:30:146
    ValPhase(k) = nanmean(KappaNeur(indclean(k:k+20)));
    ValKappa(k) = nanmean(PhaseNeur(indclean(k:k+20)));
end
ValPhase = ValPhase(1:30:end);
ValKappa = ValKappa(1:30:end);


figure
indclean = ind(PValNeur<0.05);
SustValNormt = SustValNorm+1;
clear ValPhase ValKappa ValPropt
for k =1:20
    ValKappa(k) = nanmean(KappaNeur(SustValNormt>(k-1)*0.1 & SustValNormt<(k)*0.1 & PValNeur<0.05));
    ValPhase(k) = nanmean(PhaseNeur(SustValNormt>(k-1)*0.1 & SustValNormt<(k)*0.1 & PValNeur<0.05));
    ValPropt(k) = nanmean(PValNeur(SustValNormt>(k-1)*0.1 & SustValNormt<(k)*0.1)<0.05);
end

subplot(211)
bar(runmean(ValPhase,2),'Facecolor',[0.6 0.6 0.6],'EdgeColor',[0.6 0.6 0.6])
ylim([0 2*pi])
ylabel('MeanPhase')
makepretty
subplot(212)
bar(runmean(ValPropt,2),'Facecolor',[0.6 0.6 0.6],'EdgeColor',[0.6 0.6 0.6])
ylabel('PropSigUnits')
makepretty

indclean = ind(PValNeur<0.05);
SustValNormt = SustValNorm+1;
clear ValPhase ValKappa ValPropt
for k =1:20:length(indclean)
    try
        ValKappa(k) = nanmean(KappaNeur(indclean(k:k+20)));
        ValPhase(k) = nanmean(PhaseNeur(indclean(k:k+20)));
        ValPropt(k) = nanmean(PValNeur(indclean(k:k+20))<0.05);
    catch
        ValKappa(k) = nanmean(KappaNeur(indclean(k:end)));
        ValPhase(k) = nanmean(PhaseNeur(indclean(k:end)));
        ValPropt(k) = nanmean(PValNeur(indclean(k:end))<0.05);
        
    end
end
ValPhase = ValPhase(1:20:end);
ValKappa = ValKappa(1:20:end);
ValPropt = ValPropt(1:20:end);


figure
imagesc(corr(DatNormZ))
axis square
axis xy
caxis([-0.6 0.8])
colormap redblue
set(gca,'XTick',[10,30],'XTickLabel',{'0','1'})
set(gca,'YTick',[10,30],'YTickLabel',{'0','1'})
set(gca,'LineWidth',2,'FontSize',20), box off
colormap(fliplr(brewermap(200,'Spectral')')')
colorbar


%% Get % of sig units exactly
Temp = zscore(NormResp{1}')';
for i = 1:1000
    Temp2 = Temp(:,randperm(40,40));
    RemVals(i,:) = (max(abs(cumsum(Temp2'))));
end
sum(prctile(RemVals,95)<(max(abs(cumsum(Temp')))))


Temp = zscore(NormResp_B{1}')';
clear RemVals
for i = 1:1000
    Temp2 = Temp(:,randperm(40,40));
    RemVals(i,:) = (max(abs(cumsum(Temp2'))));
end
sum(prctile(RemVals,95)<(max(abs(cumsum(Temp')))))


%%
%% Onset vs offset for the three groups
figure
subplot(311)
MakeSpreadAndBoxPlot_SB({OnsetVal((UseForTresh)>Thresh);OffsetVal((UseForTresh)<-Thresh)},{[251,176,64]/256,[127,63,152]/256},[1,1.75],{'Onset','Offset'},0,0)
ylim([-0.65 0.65])
set(gca,'XTick',[1,2],'XTickLabel',{'Onset','Offset'})
ylabel('FR (zscore)')
xlim([0.5 2.25])
ylim([-1 1])
makepretty
line(xlim,[0 0],'color','k')
subplot(312)
MakeSpreadAndBoxPlot_SB({OnsetVal(abs(UseForTresh)<Thresh);OffsetVal(abs(UseForTresh)<Thresh)},{[251,176,64]/256,[127,63,152]/256},[1,1.75],{'Onset','Offset'},0,0)
ylim([-0.65 0.65])
ylabel('FR (zscore)')
xlim([0.5 2.25])
ylim([-1 1])
makepretty
line(xlim,[0 0],'color','k')
subplot(313)
MakeSpreadAndBoxPlot_SB({OnsetVal((UseForTresh)>Thresh);OffsetVal((UseForTresh)>Thresh)},{[251,176,64]/256,[127,63,152]/256},[1,1.75],{'Onset','Offset'},0,0)
ylim([-0.65 0.65])
set(gca,'XTick',[1,2],'XTickLabel',{'Onset','Offset'})
ylabel('FR (zscore)')
xlim([0.5 2.25])
ylim([-1 1])
makepretty
line(xlim,[0 0],'color','k')

figure
subplot(131)
A = {abs(Onsett(PValNeur<0.05)),abs(Onsett(PValNeur>0.05)),abs(Onsett_B)};

MakeSpreadAndBoxPlot_SB(A,{'k',[0.6 0.6 0.6],[0.8 0.2 0.2]},[1:3],{'CTRL-Mod','CTRL-NonMod','OBX'},0,0)

ylim([0 1.1])
xtickangle(45)
title('Onset')
makepretty
    
subplot(132)
A = {abs(SustValNormt(PValNeur<0.05)),abs(SustValNormt(PValNeur>.05)),abs(SustValNorm_B)};
MakeSpreadAndBoxPlot_SB(A,{'k',[0.6 0.6 0.6],[0.8 0.2 0.2]},[1:3],{'CTRL-Mod','CTRL-NonMod','OBX'},0,0)
ylim([0 1.1])
xtickangle(45)
title('Sustained')
makepretty


subplot(133)
A = {abs(Offsett(PValNeur<0.05)),abs(Offsett(PValNeur>0.05)),abs(Offsett_B)};
MakeSpreadAndBoxPlot_SB(A,{'k',[0.6 0.6 0.6],[0.8 0.2 0.2]},[1:3],{'CTRL-Mod','CTRL-NonMod','OBX'},0,0)
% MakeSpreadAndBoxPlot_SB(A,{[0.4 0.4 0.4],[0.8 0.8 0.8],[0.8 0.2 0.2]},[1,3,5],{'CTRL-Mod','CTRL-NonMod','OBX'},0)
ylim([0 1.3])
xtickangle(45)
title('Offset')
makepretty