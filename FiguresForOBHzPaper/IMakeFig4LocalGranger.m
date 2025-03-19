% Calculate spectra,coherence and Granger
clear all
% Get data
OBXEphys=[230,249,250,291,297,298];
CtrlEphys=[242,248,244,243,253,254,258,259,299,394,395,402,403,450,451];

[params,movingwin,suffix]=SpectrumParametersML('low');
order=16;
paramsGranger.trialave=0;
paramsGrangerparamsGranger.err=[1 0.0500];
paramsGranger.pad=2;
paramsGranger.fpass=[0.1 80];
paramsGranger.tapers=[3 5];
paramsGranger.Fs=250;
paramsGranger.err=[1 0.05];
movingwinGranger=[3 0.2];

Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
EpNames{1}='Fz';EpNames{2}='NoFz';
Granger.Fz.PFCx_HPCLocal=[];
Granger.Fz.HPCLocal_PFCx=[];
Granger.NoFz.PFCx_HPCLocal=[];
Granger.NoFz.HPCLocal_PFCx=[];
Granger.Fz.PFCx_OBLocal=[];
Granger.Fz.OBLocal_PFCx=[];
Granger.NoFz.PFCx_OBLocal=[];
Granger.NoFz.OBLocal_PFCx=[];

for mm=1:length(Dir.path)
    
    Dir.path{mm}
    cd(Dir.path{mm})
    if exist('LFPData/LocalOBActivity.mat')>0
         load('GrangerData/Granger_Fz_PFCx_OBLoc.mat')
        Granger.Fz.PFCx_OBLocal=[Granger.Fz.PFCx_OBLocal;Fx2y];
        Granger.Fz.OBLocal_PFCx=[Granger.Fz.OBLocal_PFCx;Fy2x];
        load('GrangerData/Granger_NoFz_PFCx_OBLoc.mat')
        Granger.NoFz.PFCx_OBLocal=[Granger.NoFz.PFCx_OBLocal;Fx2y];
        Granger.NoFz.OBLocal_PFCx=[Granger.NoFz.OBLocal_PFCx;Fy2x];
        
    end
    
    
    if exist('LFPData/LocalHPCActivity.mat')>0
        load('GrangerData/Granger_Fz_PFCx_HPCLoc.mat')
        Granger.Fz.PFCx_HPCLocal=[Granger.Fz.PFCx_HPCLocal;Fx2y];
        Granger.Fz.HPCLocal_PFCx=[Granger.Fz.HPCLocal_PFCx;Fy2x];
        load('GrangerData/Granger_NoFz_PFCx_HPCLoc.mat')
        Granger.NoFz.PFCx_HPCLocal=[Granger.NoFz.PFCx_HPCLocal;Fx2y];
        Granger.NoFz.HPCLocal_PFCx=[Granger.NoFz.HPCLocal_PFCx;Fy2x];
    end
    clear LFPAll  AllCombiName AllCombi
    
end
cd /home/vador/Dropbox/MOBS_workingON/OB4Hz-manuscrit/Fig4Granger
Cols1=[0,109,219;146,0,0]/263;
Cols2=[0,146,146;189,109,255]/263;
BandLimsG=[find(freqBin<3,1,'last'):find(freqBin<6,1,'last')];

fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.PFCx_HPCLocal),[stdError(Granger.Fz.PFCx_HPCLocal);stdError(Granger.Fz.PFCx_HPCLocal)]','alpha'),hold on
set(hl,'Color',Cols2(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols2(1,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.HPCLocal_PFCx),[stdError(Granger.Fz.HPCLocal_PFCx);stdError(Granger.Fz.HPCLocal_PFCx)]','alpha');
set(hl,'Color',Cols2(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols2(2,:))
xlim([0 20]),ylim([0 0.35])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
set(gca,'Layer','top')
ValsFz=nanmean(Granger.Fz.PFCx_HPCLocal(:,BandLimsG)');
ValsNoFz=nanmean(Granger.Fz.HPCLocal_PFCx(:,BandLimsG)');
 saveas(fig,'GrangerFzHPCLocPFC.fig'), close all
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValsFz),'color','k','linewidth',2)
plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols2(2,:);Cols2(1,:)]), hold on
[p,h]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'HPC-PFC','PFC-HPC'})
saveas(fig,'GrangerFzHPCLocPFCQuantif.fig'), close all


fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.PFCx_HPCLocal),[stdError(Granger.NoFz.PFCx_HPCLocal);stdError(Granger.NoFz.PFCx_HPCLocal)]','alpha'),hold on
set(hl,'Color',Cols2(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols2(1,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.HPCLocal_PFCx),[stdError(Granger.NoFz.HPCLocal_PFCx);stdError(Granger.NoFz.HPCLocal_PFCx)]','alpha');
set(hl,'Color',Cols2(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols2(2,:))
xlim([0 20]),ylim([0 0.35])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
set(gca,'Layer','top')
ValsFz=nanmean(Granger.NoFz.PFCx_HPCLocal(:,BandLimsG)');
ValsNoFz=nanmean(Granger.NoFz.HPCLocal_PFCx(:,BandLimsG)');
 saveas(fig,'GrangerNoFzHPCLocPFC.fig'), close all
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValsFz),'color','k','linewidth',2)
plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols2(2,:);Cols2(1,:)]), hold on
[p,h]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'HPC-PFC','PFC-HPC'})
saveas(fig,'GrangerNoFzHPCLocPFCQuantif.fig'), close all


fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.PFCx_OBLocal),[stdError(Granger.Fz.PFCx_OBLocal);stdError(Granger.Fz.PFCx_OBLocal)]','alpha'),hold on
set(hl,'Color',Cols2(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols2(1,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.OBLocal_PFCx),[stdError(Granger.Fz.OBLocal_PFCx);stdError(Granger.Fz.OBLocal_PFCx)]','alpha');
set(hl,'Color',Cols2(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols2(2,:))
xlim([0 20]),ylim([0 0.35])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
set(gca,'Layer','top')
ValsFz=nanmean(Granger.Fz.PFCx_OBLocal(:,BandLimsG)');
ValsNoFz=nanmean(Granger.Fz.OBLocal_PFCx(:,BandLimsG)');
 saveas(fig,'GrangerFzOBLocPFC.fig'), close all
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValsFz),'color','k','linewidth',2)
plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols2(2,:);Cols2(1,:)]), hold on
[p,h]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'OB-PFC','PFC-OB'})
saveas(fig,'GrangerFzOBLocPFCQuantif.fig'), close all


fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.PFCx_OBLocal),[stdError(Granger.NoFz.PFCx_OBLocal);stdError(Granger.NoFz.PFCx_OBLocal)]','alpha'),hold on
set(hl,'Color',Cols2(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols2(1,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.OBLocal_PFCx),[stdError(Granger.NoFz.OBLocal_PFCx);stdError(Granger.NoFz.OBLocal_PFCx)]','alpha');
set(hl,'Color',Cols2(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols2(2,:))
xlim([0 20]),ylim([0 0.35])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
set(gca,'Layer','top')
ValsFz=nanmean(Granger.NoFz.PFCx_OBLocal(:,BandLimsG)');
ValsNoFz=nanmean(Granger.NoFz.OBLocal_PFCx(:,BandLimsG)');
 saveas(fig,'GrangerNoFzOBLocPFC.fig'), close all
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValsFz),'color','k','linewidth',2)
plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols2(2,:);Cols2(1,:)]), hold on
[p,h]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'OB-PFC','PFC-OB'})
saveas(fig,'GrangerNoFzOBLocPFCQuantif.fig'), close all

