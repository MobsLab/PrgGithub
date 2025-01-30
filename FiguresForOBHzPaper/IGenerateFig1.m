% Make behaviour,spectra, coherence and granger pannels for fig1
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
KeepFirstSessionOnly=[1,3,4,6,8:length(Dir.path)];
n=1;
StrucNames={'HPC','OB','PFCx'};
for mm=KeepFirstSessionOnly
    Dir.path{mm}
    
    cd(Dir.path{mm})
    clear chH chB chP
    load('behavResources.mat')
    tpsmax=max(Range(Movtsd));
    load('StateEpochSB.mat')
    TotEpoch=intervalSet(0,tpsmax)-TotalNoiseEpoch;
    
    
    clear  Sptsd Spectro
    load('PFCx_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    Spec.Fz.PFC(n,:)=(nanmean(log(Data(Restrict(Sptsd,FreezeEpoch)))));
    Spec.NoFz.PFC(n,:)=(nanmean(log(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch)))));
    chP=ch;
    
    clear  Sptsd Spectro
    load('B_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    Spec.Fz.OB(n,:)=(nanmean(log(Data(Restrict(Sptsd,FreezeEpoch)))));
    Spec.NoFz.OB(n,:)=(nanmean(log(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch)))));
    chB=ch;
    
    clear  Sptsd Spectro
    load('H_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    Spec.Fz.HPC(n,:)=(nanmean(log(Data(Restrict(Sptsd,FreezeEpoch)))));
    Spec.NoFz.HPC(n,:)=(nanmean(log(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch)))));
    fS=Spectro{3};
    chH=ch;
    
    % Coherence
    AllCombi=combnk([chH,chB,chP],2);
    AllCombiNums=combnk([1,2,3],2);
    for st=1:size(AllCombi,1)
        NameTemp1=['CohgramcDataL/Cohgram_',num2str(AllCombi(st,1)),'_',num2str(AllCombi(st,2)),'.mat'];
        NameTemp2=['CohgramcDataL/Cohgram_',num2str(AllCombi(st,2)),'_',num2str(AllCombi(st,1)),'.mat'];
        try, load(NameTemp1);
        catch
            load(NameTemp2);
        end
        Ctsd=tsd(t*1e4,C);
        temp=nanmean(Data(Restrict(Ctsd,FreezeEpoch)));
        eval(['Coh.Fz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'(n,:)=temp;']);
        temp=nanmean(Data(Restrict(Ctsd,TotEpoch-FreezeEpoch)));
        eval(['Coh.NoFz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'(n,:)=temp;']);
        fC=f;
        clear C
    end
    
    for st=1:size(AllCombi,1)
        NameTemp1=['GrangerData/Granger_Fz_',num2str(AllCombi(st,1)),'_',num2str(AllCombi(st,2)),'.mat'];
        load(NameTemp1)
        if not(isempty(Fx2y))
            eval(['Granger.Fz.',StrucNames{AllCombiNums(st,1)},'_',StrucNames{AllCombiNums(st,2)},'(n,:)=Fx2y;']);
            eval(['Granger.Fz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'(n,:)=Fy2x;']);
        else
            eval(['Granger.Fz.',StrucNames{AllCombiNums(st,1)},'_',StrucNames{AllCombiNums(st,2)},'(n,:)=NaN(1,1250);']);
            eval(['Granger.Fz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'(n,:)=nan(1,1250);']);
        end
        clear Fx2y Fy2x
        NameTemp1=['GrangerData/Granger_NoFz_',num2str(AllCombi(st,1)),'_',num2str(AllCombi(st,2)),'.mat'];
        load(NameTemp1)
        if not(isempty(Fx2y))
            eval(['Granger.NoFz.',StrucNames{AllCombiNums(st,1)},'_',StrucNames{AllCombiNums(st,2)},'(n,:)=Fx2y;']);
            eval(['Granger.NoFz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'(n,:)=Fy2x;']);
        else
            eval(['Granger.NoFz.',StrucNames{AllCombiNums(st,1)},'_',StrucNames{AllCombiNums(st,2)},'(n,:)=NaN(1,1250);']);
            eval(['Granger.NoFz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'(n,:)=nan(1,1250);']);
        end
        clear Fx2y Fy2x
    end
    clear FreezeEpoch TotEpoch Sptsd Spectro TotalNoiseEpoch
    n=n+1;
    
end

Cols1=[0,109,219;146,0,0]/263;
Cols2=[0,146,146;189,109,255]/263;
BandLimsS=[find(fS<3,1,'last'):find(fS<6,1,'last')];
BandLimsC=[find(fC<3,1,'last'):find(fC<6,1,'last')];
OtherFreq=[1:length(fS)];OtherFreq(ismember(OtherFreq,BandLimsS))=[];
OtherFreqC=[1:length(fC)];OtherFreq(ismember(OtherFreq,BandLimsC))=[];
BandLimsG=[find(freqBin<3,1,'last'):find(freqBin<6,1,'last')];
OtherFreqG=[1:length(freqBin)];OtherFreq(ismember(OtherFreqG,BandLimsG))=[];


close all,
cd /home/vador/Dropbox/MOBS_workingON/OB4Hz-manuscrit/Fig1
% OB Spectra
fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fS,nanmean(Spec.Fz.OB),[stdError(Spec.Fz.OB);stdError(Spec.Fz.OB)]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fS,nanmean(Spec.NoFz.OB),[stdError(Spec.NoFz.OB);stdError(Spec.NoFz.OB)]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Power - log scale')
ylim([7.5 13])
set(gca,'Layer','top')
saveas(fig,'MeanSpecOB.fig'), close all
ValsFz=nanmean(Spec.Fz.OB(:,BandLimsS)')./nanmean(Spec.Fz.OB(:,OtherFreq)');
ValsNoFz=nanmean(Spec.NoFz.OB(:,BandLimsS)')./nanmean(Spec.NoFz.OB(:,OtherFreq)');
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValsFz),'color','k','linewidth',2)
plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols1(2,:);Cols1(1,:)]), hold on
[p,h,c]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'NoFz','Fz'})
saveas(fig,'MeanSpecOBQuantif.fig'), close all

% PFC Spectra
fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fS,nanmean(Spec.Fz.PFC),[stdError(Spec.Fz.PFC);stdError(Spec.Fz.PFC)]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fS,nanmean(Spec.NoFz.PFC),[stdError(Spec.NoFz.PFC);stdError(Spec.NoFz.PFC)]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Power - log scale')
ylim([6 11.5])
set(gca,'Layer','top')
saveas(fig,'MeanSpecPFC.fig'), close all
ValsFz=nanmean(Spec.Fz.PFC(:,BandLimsS)')./nanmean(Spec.Fz.PFC(:,OtherFreq)');
ValsNoFz=nanmean(Spec.NoFz.PFC(:,BandLimsS)')./nanmean(Spec.NoFz.PFC(:,OtherFreq)');
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValsFz),'color','k','linewidth',2)
plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols1(2,:);Cols1(1,:)]), hold on
[p,h]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'NoFz','Fz'})
saveas(fig,'MeanSpecPFCQuantif.fig'), close all

% HPC Spectra
fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fS,nanmean(Spec.Fz.HPC),[stdError(Spec.Fz.HPC);stdError(Spec.Fz.HPC)]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fS,nanmean(Spec.NoFz.HPC),[stdError(Spec.NoFz.HPC);stdError(Spec.NoFz.HPC)]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Power - log scale')
ylim([6 13])
set(gca,'Layer','top')
ValsFz=nanmean(Spec.Fz.HPC(:,BandLimsS)')./nanmean(Spec.Fz.HPC(:,OtherFreq)');
ValsNoFz=nanmean(Spec.NoFz.HPC(:,BandLimsS)')./nanmean(Spec.NoFz.HPC(:,OtherFreq)');
saveas(fig,'MeanSpecHPC.fig'), close all
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValsFz),'color','k','linewidth',2)
plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols1(2,:);Cols1(1,:)]), hold on
[p,h]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'NoFz','Fz'})
saveas(fig,'MeanSpecHPCQuantif.fig'), close all

% Coh OB PFC
fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fC,nanmean(Coh.Fz.PFCx_OB),[stdError(Coh.Fz.PFCx_OB);stdError(Coh.Fz.PFCx_OB)]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fC,nanmean(Coh.NoFz.PFCx_OB),[stdError(Coh.NoFz.PFCx_OB);stdError(Coh.NoFz.PFCx_OB)]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Coherence')
ylim([0.4 1])
set(gca,'Layer','top')
ValsFz=nanmean(Coh.Fz.PFCx_OB(:,BandLimsC)');
ValsNoFz=nanmean(Coh.NoFz.PFCx_OB(:,BandLimsC)');
saveas(fig,'MeanCohPFCOB.fig'), close all
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValsFz),'color','k','linewidth',2)
plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols1(2,:);Cols1(1,:)]), hold on
[p,h]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'NoFz','Fz'})
saveas(fig,'MeanCohPFCOBQuantfi.fig'), close all

%Coh PFC HPC
fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fC,nanmean(Coh.Fz.PFCx_HPC),[stdError(Coh.Fz.PFCx_HPC);stdError(Coh.Fz.PFCx_HPC)]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fC,nanmean(Coh.NoFz.PFCx_HPC),[stdError(Coh.NoFz.PFCx_HPC);stdError(Coh.NoFz.PFCx_HPC)]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Coherence')
ylim([0.4 1])
set(gca,'Layer','top')
ValsFz=nanmean(Coh.Fz.PFCx_HPC(:,BandLimsC)');
ValsNoFz=nanmean(Coh.NoFz.PFCx_HPC(:,BandLimsC)');
saveas(fig,'MeanCohPFCHPC.fig'), close all
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValsFz),'color','k','linewidth',2)
plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols1(2,:);Cols1(1,:)]), hold on
[p,h]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'NoFz','Fz'})
saveas(fig,'MeanCohPFCHPCQuantif.fig'), close all

% Granger Fz OB PFC
fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.PFCx_OB),[stdError(Granger.Fz.PFCx_OB);stdError(Granger.Fz.PFCx_OB)]','alpha'),hold on
set(hl,'Color',Cols2(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols2(1,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.OB_PFCx),[stdError(Granger.Fz.OB_PFCx);stdError(Granger.Fz.OB_PFCx)]','alpha');
set(hl,'Color',Cols2(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols2(2,:))
xlim([0 20]),ylim([0 0.35])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
set(gca,'Layer','top')
ValsFz=nanmean(Granger.Fz.PFCx_OB(:,BandLimsG)');
ValsNoFz=nanmean(Granger.Fz.OB_PFCx(:,BandLimsG)');
saveas(fig,'GrangerFZOBPFC.fig'), close all
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValsFz),'color','k','linewidth',2)
plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols2(2,:);Cols2(1,:)]), hold on
[p,h]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'OB-PFC','PFC-OB'})
saveas(fig,'GrangerFzOBPFCQuantif.fig'), close all

% Granger NoFz OB PFC

fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.PFCx_OB),[stdError(Granger.NoFz.PFCx_OB);stdError(Granger.NoFz.PFCx_OB)]','alpha'),hold on
set(hl,'Color',Cols2(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols2(1,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.OB_PFCx),[stdError(Granger.NoFz.OB_PFCx);stdError(Granger.NoFz.OB_PFCx)]','alpha');
set(hl,'Color',Cols2(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols2(2,:))
xlim([0 20]),ylim([0 0.35])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
set(gca,'Layer','top')
ValsFz=nanmean(Granger.NoFz.PFCx_OB(:,BandLimsG)');
ValsNoFz=nanmean(Granger.NoFz.OB_PFCx(:,BandLimsG)');
saveas(fig,'GrangerNoFzOBPFC.fig'), close all
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValsFz),'color','k','linewidth',2)
plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols2(2,:);Cols2(1,:)]), hold on
[p,h]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'OB-PFC','PFC-OB'})
saveas(fig,'GrangerNoFzOBPFCQuantif.fig'), close all

% Granger Fz PFC HPC
fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.PFCx_HPC),[stdError(Granger.Fz.PFCx_HPC);stdError(Granger.Fz.PFCx_HPC)]','alpha'),hold on
set(hl,'Color',Cols2(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols2(1,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.HPC_PFCx),[stdError(Granger.Fz.HPC_PFCx);stdError(Granger.Fz.HPC_PFCx)]','alpha');
set(hl,'Color',Cols2(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols2(2,:))
xlim([0 20]),ylim([0 0.35])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
set(gca,'Layer','top')
ValsFz=nanmean(Granger.Fz.PFCx_HPC(:,BandLimsG)');
ValsNoFz=nanmean(Granger.Fz.HPC_PFCx(:,BandLimsG)');
saveas(fig,'GrangerFZHPCPFC.fig'), close all
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValsFz),'color','k','linewidth',2)
plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols2(2,:);Cols2(1,:)]), hold on
[p,h]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'HPC-PFC','PFC-HPC'})
saveas(fig,'GrangerFzHPCPFCQuantif.fig'), close all

% Granger NoFz HPC PFC

fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.PFCx_HPC),[stdError(Granger.NoFz.PFCx_HPC);stdError(Granger.NoFz.PFCx_HPC)]','alpha'),hold on
set(hl,'Color',Cols2(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols2(1,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.HPC_PFCx),[stdError(Granger.NoFz.HPC_PFCx);stdError(Granger.NoFz.HPC_PFCx)]','alpha');
set(hl,'Color',Cols2(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols2(2,:))
xlim([0 20]),ylim([0 0.35])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
set(gca,'Layer','top')
ValsFz=nanmean(Granger.NoFz.PFCx_HPC(:,BandLimsG)');
ValsNoFz=nanmean(Granger.NoFz.HPC_PFCx(:,BandLimsG)');
saveas(fig,'GrangerNoFzHPCPFC.fig'), close all
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValsFz),'color','k','linewidth',2)
plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols2(2,:);Cols2(1,:)]), hold on
[p,h]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'HPC-PFC','PFC-HPC'})
saveas(fig,'GrangerNoFzHPCPFCQuantif.fig'), close all
