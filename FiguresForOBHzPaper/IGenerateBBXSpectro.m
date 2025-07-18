% Make behaviour,spectra, coherence and granger pannels for fig1
clear all
% Get data
OBXEphys=[230,291,297,298];
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
Dir=RestrictPathForExperiment(Dir,'nMice',[CtrlEphys,OBXEphys]);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
KeepFirstSessionOnly=[1,6,8:length(Dir.path)];

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
    MouseNum(n)=eval(Dir.name{mm}(end-2:end));
    chP=ch;
    fS=Spectro{3};
 
    clear FreezeEpoch TotEpoch Sptsd Spectro TotalNoiseEpoch
    n=n+1;
    
end


Cols1=[0,146,146;189,109,255]/263;
BandLimsS=[find(fS<3,1,'last'):find(fS<6,1,'last')];
OtherFreq=[1:length(fS)];OtherFreq(ismember(OtherFreq,BandLimsS))=[];
cd /home/vador/Dropbox/MOBS_workingON/OB4Hz-manuscrit/Fig3
IsCtrl=ismember(MouseNum,CtrlEphys);
fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fS,nanmean(Spec.Fz.PFC(IsCtrl==1,:)),[stdError(Spec.Fz.PFC(IsCtrl==1,:));stdError(Spec.Fz.PFC(IsCtrl==1,:))]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fS,nanmean(Spec.Fz.PFC(IsCtrl==0,:)),[stdError(Spec.Fz.PFC(IsCtrl==0,:));stdError(Spec.Fz.PFC(IsCtrl==0,:))]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Power - log scale')
ylim([5 12])
set(gca,'Layer','top')
%  saveas(fig,'MeanSpecPFCxFz.fig'), close all
ValCtrl=nanmean(Spec.Fz.PFC(IsCtrl==1,BandLimsS)')./nanmean(Spec.Fz.PFC(IsCtrl==1,OtherFreq)');
ValOBX=nanmean(Spec.Fz.PFC(IsCtrl==0,BandLimsS)')./nanmean(Spec.Fz.PFC(IsCtrl==0,OtherFreq)');
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValCtrl),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValOBX),'color','k','linewidth',2)
plotSpread({ValCtrl,ValOBX},'distributionColors',[Cols1(2,:);Cols1(1,:)]), hold on
[p,h]=ranksum(ValCtrl,ValOBX);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'Ctrl','OBX'})
%  saveas(fig,'MeanSpecPFCxFzQuantif.fig'), close all


fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fS,nanmean(Spec.NoFz.PFC(IsCtrl==1,:)),[stdError(Spec.NoFz.PFC(IsCtrl==1,:));stdError(Spec.NoFz.PFC(IsCtrl==1,:))]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fS,nanmean(Spec.NoFz.PFC(IsCtrl==0,:)),[stdError(Spec.NoFz.PFC(IsCtrl==0,:));stdError(Spec.NoFz.PFC(IsCtrl==0,:))]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Power - log scale')
ylim([5 12])
set(gca,'Layer','top')
 saveas(fig,'MeanSpecPFCxNoFz.fig'), close all
ValCtrl=nanmean(Spec.NoFz.PFC(IsCtrl==1,BandLimsS)')./nanmean(Spec.NoFz.PFC(IsCtrl==1,OtherFreq)');
ValOBX=nanmean(Spec.NoFz.PFC(IsCtrl==0,BandLimsS)')./nanmean(Spec.NoFz.PFC(IsCtrl==0,OtherFreq)');
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValCtrl),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValOBX),'color','k','linewidth',2)
plotSpread({ValCtrl,ValOBX},'distributionColors',[Cols1(2,:);Cols1(1,:)]), hold on
[p,h]=ranksum(ValCtrl,ValOBX);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'Ctrl','OBX'})
 saveas(fig,'MeanSpecPFCxNoFzQuantif.fig'), close all
