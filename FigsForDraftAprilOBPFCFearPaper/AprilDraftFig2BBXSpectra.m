% This code generates pannels used in april draft
clear all
% Get data
[Dir,KeepFirstSessionOnly,CtrlEphys]=GetRightSessionsFor4HzPaper('CtrlBBXAllData');

% Where to savep
SaveFigFolder='/home/vador/Dropbox/MOBS_workingON/OB4Hz-manuscrit/Figure1/';
Date=date;
SaveFigFolder=[SaveFigFolder,Date,filesep];

% Get Parameters
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
Cols1=[0,146,146;189,109,255]/263;
Cols1=[0,109,219;146,0,0]/263;

n=1;
StrucNames={'HPC','PFCx'};
for mm=KeepFirstSessionOnly
    disp(Dir.path{mm})
    cd(Dir.path{mm})
    clear chH chB chP
    load('behavResources.mat')
    tpsmax=max(Range(Movtsd));
    try,load('StateEpochSB.mat')
        TotEpoch=intervalSet(0,tpsmax)-TotalNoiseEpoch;
    catch
        TotEpoch=intervalSet(0,tpsmax);
    end
    
    
    clear  Sptsd Spectro
    load('PFCx_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    Spec.Fz.PFC(n,:)=(nanmean(log(Data(Restrict(Sptsd,FreezeEpoch)))));
    Spec.NoFz.PFC(n,:)=(nanmean(log(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch)))));
    chP=ch;
    
    clear  Sptsd Spectro
    load('H_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    Spec.Fz.HPC(n,:)=(nanmean(log(Data(Restrict(Sptsd,FreezeEpoch)))));
    Spec.NoFz.HPC(n,:)=(nanmean(log(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch)))));
    chH=ch;

    
    % Coherence
    AllCombi=combnk([chP,chH],2);
    AllCombiNums=combnk([1,2,3],2);
    for st=1:size(AllCombi,1)
        NameTemp1=['CohgramcDataL/Cohgram_',num2str(AllCombi(st,1)),'_',num2str(AllCombi(st,2)),'.mat'];
        load(NameTemp1)
        Ctsd=tsd(t*1e4,C);
%         ICtsd=tsd(t*1e4,imag(S12./sqrt(S1.*S2)));
        temp=nanmean(Data(Restrict(Ctsd,FreezeEpoch)));
        eval(['Coh.Fz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'(n,:)=temp;']);
        temp=nanmean(Data(Restrict(Ctsd,TotEpoch-FreezeEpoch)));
        eval(['Coh.NoFz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'(n,:)=temp;']);
%         temp=abs(nanmean(Data(Restrict(ICtsd,FreezeEpoch))));
%         eval(['ICoh.Fz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'(n,:)=temp;']);
%         temp=abs(nanmean(Data(Restrict(ICtsd,TotEpoch-FreezeEpoch))));
%         eval(['ICoh.NoFz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'(n,:)=temp;']);
        fC=f;
        clear C
    end
    
    AllCombi=combnk([chH,chP],2);
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

    
    MouseNum(n)=eval(Dir.name{mm}(end-2:end));
    chP=ch;
    fS=Spectro{3};
    
    clear FreezeEpoch TotEpoch Sptsd Spectro TotalNoiseEpoch Fx2y Fy2x Ctsd C
    n=n+1;
    
end

IsCtrl=ismember(MouseNum,CtrlEphys);

BandLimsS=[find(fS<3,1,'last'):find(fS<6,1,'last')];
OtherFreq=[1:length(fS)];OtherFreq(ismember(OtherFreq,BandLimsS))=[];
BandLimsThet=[find(fS<6,1,'last'):find(fS<9,1,'last')];
OtherFreqThet=[1:length(fS)];OtherFreqThet(ismember(OtherFreqThet,BandLimsThet))=[];

%% PFC freezing
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
title('PFC Spectra - Fz')
saveas(fig,[SaveFigFolder,'MeanSpecPFCxFz.png']),
saveas(fig,[SaveFigFolder,'MeanSpecPFCxFz.fig']), close all

ValCtrl=nanmean(Spec.Fz.PFC(IsCtrl==1,BandLimsS)')./nanmean(Spec.Fz.PFC(IsCtrl==1,OtherFreq)');
ValOBX=nanmean(Spec.Fz.PFC(IsCtrl==0,BandLimsS)')./nanmean(Spec.Fz.PFC(IsCtrl==0,OtherFreq)');
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValCtrl),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValOBX),'color','k','linewidth',2)
handles=plotSpread({ValCtrl,ValOBX},'distributionColors',[Cols1(1,:);Cols1(2,:)]); hold on
set(handles{1},'MarkerSize',20)
[p,h,stats]=ranksum(ValCtrl,ValOBX);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'Ctrl','OBX'})
set(gca,'FontSize',14, 'YTick',[1:0.1:2])
ylabel('3-6SNR')
saveas(fig,[SaveFigFolder,'MeanSpecPFCxFzQuantif.png']), 
saveas(fig,[SaveFigFolder,'MeanSpecPFCxFzQuantif.fig']), close all
save([SaveFigFolder,'MeanSpecPFCxFzQuantif.mat'],'p','h','stats'), close all, clear p h stats

figure
clf
Vals = {ValCtrl'; ValOBX'};
XPos = [1.1,1.9,3.5,4.4];
Colors_Points = [Cols1(1,:);Cols1(2,:)];
Colors_Boxplot = [0.9,0.9,1;1,0.9,0.9];
for k = 1:2
X = Vals{k};
a=iosr.statistics.boxPlot(XPos(k),X,'boxColor',Colors_Boxplot(k,:),'lineColor',Colors_Boxplot(k,:),'medianColor','k','boxWidth',0.5,'showOutliers',false);
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;

handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',XPos(k),'spreadWidth',0.7), hold on;
set(handlesplot{1},'MarkerSize',30)
handlesplot=plotSpread(X,'distributionColors',Colors_Points(k,:),'xValues',XPos(k),'spreadWidth',0.7), hold on;
set(handlesplot{1},'MarkerSize',20)

end

xlim([0.5 2.5])
ylim([1 1.4])
set(gca,'FontSize',18,'XTick',XPos,'XTickLabel',{'Ctrl','OBX'},'linewidth',1.5,'YTick',[1:0.1:1.5])
ylabel('3-6Hz SNR')
box off


ValCtrl=nanmean(Spec.Fz.PFC(IsCtrl==1,BandLimsThet)')./nanmean(Spec.Fz.PFC(IsCtrl==1,OtherFreqThet)');
ValOBX=nanmean(Spec.Fz.PFC(IsCtrl==0,BandLimsThet)')./nanmean(Spec.Fz.PFC(IsCtrl==0,OtherFreqThet)');
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValCtrl),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValOBX),'color','k','linewidth',2)
handles=plotSpread({ValCtrl,ValOBX},'distributionColors',[Cols1(1,:);Cols1(2,:)]); hold on
set(handles{1},'MarkerSize',20)
[p,h,stats]=ranksum(ValCtrl,ValOBX);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'Ctrl','OBX'})
set(gca,'FontSize',14, 'YTick',[1:0.1:2])
saveas(fig,[SaveFigFolder,'MeanSpecPFCxFzQuantifThet.png']), 
saveas(fig,[SaveFigFolder,'MeanSpecPFCxFzQuantifThet.fig']), close all
save([SaveFigFolder,'MeanSpecPFCxFzQuantifThet.mat'],'p','h','stats'), close all, clear p h stats

%% PFC No freezing
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
title('PFC Spectra - NoFz')
set(gca,'Layer','top')
saveas(fig,[SaveFigFolder,'MeanSpecPFCxNoFz.png']), 
saveas(fig,[SaveFigFolder,'MeanSpecPFCxNoFz.fig']), close all

ValCtrl=nanmean(Spec.NoFz.PFC(IsCtrl==1,BandLimsS)')./nanmean(Spec.NoFz.PFC(IsCtrl==1,OtherFreq)');
ValOBX=nanmean(Spec.NoFz.PFC(IsCtrl==0,BandLimsS)')./nanmean(Spec.NoFz.PFC(IsCtrl==0,OtherFreq)');
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValCtrl),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValOBX),'color','k','linewidth',2)
handles=plotSpread({ValCtrl,ValOBX},'distributionColors',[Cols1(1,:);Cols1(2,:)]); hold on
set(handles{1},'MarkerSize',20)
[p,h,stats]=ranksum(ValCtrl,ValOBX);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'Ctrl','OBX'})
ylabel('3-6SNR')
saveas(fig,[SaveFigFolder,'MeanSpecPFCxNoFzQuantif.png']),
saveas(fig,[SaveFigFolder,'MeanSpecPFCxNoFzQuantif.fig']), close all
save([SaveFigFolder,'MeanSpecPFCxNoFzQuantif.mat'],'p','h','stats'), close all, clear p h stats


ValCtrl=nanmean(Spec.NoFz.PFC(IsCtrl==1,BandLimsThet)')./nanmean(Spec.NoFz.PFC(IsCtrl==1,OtherFreqThet)');
ValOBX=nanmean(Spec.NoFz.PFC(IsCtrl==0,BandLimsThet)')./nanmean(Spec.NoFz.PFC(IsCtrl==0,OtherFreqThet)');
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValCtrl),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValOBX),'color','k','linewidth',2)
handles=plotSpread({ValCtrl,ValOBX},'distributionColors',[Cols1(1,:);Cols1(2,:)]); hold on
set(handles{1},'MarkerSize',20)
[p,h,stats]=ranksum(ValCtrl,ValOBX);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'Ctrl','OBX'})
saveas(fig,[SaveFigFolder,'MeanSpecPFCxNoFzQuantifThet.png']), 
saveas(fig,[SaveFigFolder,'MeanSpecPFCxNoFzQuantifThet.fig']), close all
save([SaveFigFolder,'MeanSpecPFCxNoFzQuantifThet.mat'],'p','h','stats'), close all, clear p h stats

% HPC Spectra
fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fS,nanmean(Spec.Fz.HPC(IsCtrl==1,:)),[stdError(Spec.Fz.HPC(IsCtrl==1,:));stdError(Spec.Fz.HPC(IsCtrl==1,:))]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fS,nanmean(Spec.Fz.HPC(IsCtrl==0,:)),[stdError(Spec.Fz.HPC(IsCtrl==0,:));stdError(Spec.Fz.HPC(IsCtrl==0,:))]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Power - log scale')
ylim([5 12])
title('HPC Spectra - Fz')
set(gca,'Layer','top')
saveas(fig,[SaveFigFolder,'MeanSpecHPCxFz.png'])
saveas(fig,[SaveFigFolder,'MeanSpecHPCxFz.fig']), close all

ValCtrl=nanmean(Spec.Fz.HPC(IsCtrl==1,BandLimsS)')./nanmean(Spec.Fz.HPC(IsCtrl==1,OtherFreq)');
ValOBX=nanmean(Spec.Fz.HPC(IsCtrl==0,BandLimsS)')./nanmean(Spec.Fz.HPC(IsCtrl==0,OtherFreq)');
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValCtrl),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValOBX),'color','k','linewidth',2)
handles=plotSpread({ValCtrl,ValOBX},'distributionColors',[Cols1(1,:);Cols1(2,:)]); hold on
set(handles{1},'MarkerSize',20)
[p,h,stats]=ranksum(ValCtrl,ValOBX);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'Ctrl','OBX'})
set(gca,'FontSize',14, 'YTick',[1:0.1:2])
saveas(fig,[SaveFigFolder,'MeanSpecHPCxFzQuantif.png']),
saveas(fig,[SaveFigFolder,'MeanSpecHPCxFzQuantif.fig']), close all
save([SaveFigFolder,'MeanSpecHPCxFzQuantif.mat'],'p','h','stats'), close all, clear p h stats

ValCtrl=nanmean(Spec.Fz.HPC(IsCtrl==1,BandLimsThet)')./nanmean(Spec.Fz.HPC(IsCtrl==1,OtherFreqThet)');
ValOBX=nanmean(Spec.Fz.HPC(IsCtrl==0,BandLimsThet)')./nanmean(Spec.Fz.HPC(IsCtrl==0,OtherFreqThet)');
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValCtrl),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValOBX),'color','k','linewidth',2)
handles=plotSpread({ValCtrl,ValOBX},'distributionColors',[Cols1(1,:);Cols1(2,:)]); hold on
set(handles{1},'MarkerSize',20)
[p,h,stats]=ranksum(ValCtrl,ValOBX);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'Ctrl','OBX'})
set(gca,'FontSize',14, 'YTick',[1:0.1:2])
saveas(fig,[SaveFigFolder,'MeanSpecHPCxFzQuantifThet.png'])
saveas(fig,[SaveFigFolder,'MeanSpecHPCxFzQuantifThet.fig']), close all
save([SaveFigFolder,'MeanSpecHPCxFzQuantifThet.mat'],'p','h','stats'), close all, clear p h stats


%% HPC No freezing
fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fS,nanmean(Spec.NoFz.HPC(IsCtrl==1,:)),[stdError(Spec.NoFz.HPC(IsCtrl==1,:));stdError(Spec.NoFz.HPC(IsCtrl==1,:))]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fS,nanmean(Spec.NoFz.HPC(IsCtrl==0,:)),[stdError(Spec.NoFz.HPC(IsCtrl==0,:));stdError(Spec.NoFz.HPC(IsCtrl==0,:))]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Power - log scale')
ylim([5 12])
set(gca,'Layer','top')
title('HPC Spectra - NoFz')
saveas(fig,[SaveFigFolder,'MeanSpecHPCxNoFz.png']),
saveas(fig,[SaveFigFolder,'MeanSpecHPCxNoFz.fig']), close all

ValCtrl=nanmean(Spec.NoFz.HPC(IsCtrl==1,BandLimsS)')./nanmean(Spec.NoFz.HPC(IsCtrl==1,OtherFreq)');
ValOBX=nanmean(Spec.NoFz.HPC(IsCtrl==0,BandLimsS)')./nanmean(Spec.NoFz.HPC(IsCtrl==0,OtherFreq)');
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValCtrl),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValOBX),'color','k','linewidth',2)
handles=plotSpread({ValCtrl,ValOBX},'distributionColors',[Cols1(1,:);Cols1(2,:)]); hold on
set(handles{1},'MarkerSize',20)
[p,h,stats]=ranksum(ValCtrl,ValOBX);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'Ctrl','OBX'})
set(gca,'FontSize',14, 'YTick',[1:0.02:2])
saveas(fig,[SaveFigFolder,'MeanSpecHPCxNoFzQuantif.png']),
saveas(fig,[SaveFigFolder,'MeanSpecHPCxNoFzQuantif.fig']), close all
save([SaveFigFolder,'MeanSpecHPCxNoFzQuantif.mat'],'p','h','stats'), close all, clear p h stats


ValCtrl=nanmean(Spec.NoFz.HPC(IsCtrl==1,BandLimsThet)')./nanmean(Spec.NoFz.HPC(IsCtrl==1,OtherFreqThet)');
ValOBX=nanmean(Spec.NoFz.HPC(IsCtrl==0,BandLimsThet)')./nanmean(Spec.NoFz.HPC(IsCtrl==0,OtherFreqThet)');
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValCtrl),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValOBX),'color','k','linewidth',2)
handles=plotSpread({ValCtrl,ValOBX},'distributionColors',[Cols1(1,:);Cols1(2,:)]); hold on
set(handles{1},'MarkerSize',20)
[p,h,stats]=ranksum(ValCtrl,ValOBX);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'Ctrl','OBX'})
set(gca,'FontSize',14, 'YTick',[1:0.02:2])
saveas(fig,[SaveFigFolder,'MeanSpecHPCxNoFzQuantifThet.png']),
saveas(fig,[SaveFigFolder,'MeanSpecHPCxNoFzQuantifThet.fig']), close all
save([SaveFigFolder,'MeanSpecHPCxNoFzQuantifThet.mat'],'p','h','stats'), close all, clear p h stats


%% Coherence
BandLimsS=[find(fC<3,1,'last'):find(fC<6,1,'last')];
OtherFreq=[1:length(fC)];OtherFreq(ismember(OtherFreq,BandLimsS))=[];
BandLimsThet=[find(fC<6,1,'last'):find(fC<9,1,'last')];
OtherFreqThet=[1:length(fC)];OtherFreqThet(ismember(OtherFreqThet,BandLimsThet))=[];

% Fz
fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fC,nanmean(Coh.Fz.PFCx_HPC(IsCtrl==1,:)),[stdError(Coh.Fz.PFCx_HPC(IsCtrl==1,:));stdError(Coh.Fz.PFCx_HPC(IsCtrl==1,:))]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fC,nanmean(Coh.Fz.PFCx_HPC(IsCtrl==0,:)),[stdError(Coh.Fz.PFCx_HPC(IsCtrl==0,:));stdError(Coh.Fz.PFCx_HPC(IsCtrl==0,:))]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Power - log scale')
ylim([0.4 1])
set(gca,'Layer','top')
title('PFCx-HPCCoherence FZ')
saveas(fig,[SaveFigFolder,'MeanCohPFCxHPCFz.png']),
saveas(fig,[SaveFigFolder,'MeanCohPFCxHPCFz.fig']), close all

ValCtrl=nanmean(Coh.Fz.PFCx_HPC(IsCtrl==1,BandLimsS)');
ValOBX=nanmean(Coh.Fz.PFCx_HPC(IsCtrl==0,BandLimsS)');
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValCtrl),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValOBX),'color','k','linewidth',2)
handles=plotSpread({ValCtrl,ValOBX},'distributionColors',[Cols1(1,:);Cols1(2,:)]); hold on
set(handles{1},'MarkerSize',20)
[p,h,stats]=ranksum(ValCtrl,ValOBX);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'Ctrl','OBX'})
set(gca,'FontSize',14, 'YTick',[0:0.1:2])
saveas(fig,[SaveFigFolder,'MeanCohPFCxHPCFzQuantif.png']),
saveas(fig,[SaveFigFolder,'MeanCohPFCxHPCFzQuantif.fig']), close all
save([SaveFigFolder,'MeanCohPFCxHPCFzQuantif.mat'],'p','h','stats'), close all, clear p h stats

ValCtrl=nanmean(Coh.Fz.PFCx_HPC(IsCtrl==1,BandLimsThet)');
ValOBX=nanmean(Coh.Fz.PFCx_HPC(IsCtrl==0,BandLimsThet)');
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValCtrl),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValOBX),'color','k','linewidth',2)
handles=plotSpread({ValCtrl,ValOBX},'distributionColors',[Cols1(1,:);Cols1(2,:)]); hold on
set(handles{1},'MarkerSize',20)
[p,h,stats]=ranksum(ValCtrl,ValOBX);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'Ctrl','OBX'})
set(gca,'FontSize',14, 'YTick',[1:0.1:2])
saveas(fig,[SaveFigFolder,'MeanCohPFCxFzQuantifThet.png']),
saveas(fig,[SaveFigFolder,'MeanCohPFCxFzQuantifThet.fig']), close all
save([SaveFigFolder,'MeanCohPFCxFzQuantifThet.mat'],'p','h','stats'), close all, clear p h stats


% No Fz
fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fC,nanmean(Coh.NoFz.PFCx_HPC(IsCtrl==1,:)),[stdError(Coh.NoFz.PFCx_HPC(IsCtrl==1,:));stdError(Coh.NoFz.PFCx_HPC(IsCtrl==1,:))]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fC,nanmean(Coh.NoFz.PFCx_HPC(IsCtrl==0,:)),[stdError(Coh.NoFz.PFCx_HPC(IsCtrl==0,:));stdError(Coh.NoFz.PFCx_HPC(IsCtrl==0,:))]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Power - log scale')
ylim([0.4 1])
set(gca,'Layer','top')
title('PFCx-HPCCoherence No FZ')
saveas(fig,[SaveFigFolder,'MeanCohPFCxHPCNoFz.png']),
saveas(fig,[SaveFigFolder,'MeanCohPFCxHPCNoFz.fig']), close all

ValCtrl=nanmean(Coh.NoFz.PFCx_HPC(IsCtrl==1,BandLimsS)');
ValOBX=nanmean(Coh.NoFz.PFCx_HPC(IsCtrl==0,BandLimsS)');
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValCtrl),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValOBX),'color','k','linewidth',2)
handles=plotSpread({ValCtrl,ValOBX},'distributionColors',[Cols1(1,:);Cols1(2,:)]); hold on
set(handles{1},'MarkerSize',20)
[p,h,stats]=ranksum(ValCtrl,ValOBX);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'Ctrl','OBX'})
set(gca,'FontSize',14, 'YTick',[0:0.1:2])
saveas(fig,[SaveFigFolder,'MeanCohPFCxHPCNoFzFzQuantif.png']), 
saveas(fig,[SaveFigFolder,'MeanCohPFCxHPCNoFzFzQuantif.fig']), close all
save([SaveFigFolder,'MeanCohPFCxHPCNoFzFzQuantif.mat'],'p','h','stats'), close all, clear p h stats

ValCtrl=nanmean(Coh.NoFz.PFCx_HPC(IsCtrl==1,BandLimsThet)');
ValOBX=nanmean(Coh.NoFz.PFCx_HPC(IsCtrl==0,BandLimsThet)');
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValCtrl),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValOBX),'color','k','linewidth',2)
handles=plotSpread({ValCtrl,ValOBX},'distributionColors',[Cols1(1,:);Cols1(2,:)]); hold on
set(handles{1},'MarkerSize',20)
[p,h,stats]=ranksum(ValCtrl,ValOBX);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'Ctrl','OBX'})
set(gca,'FontSize',14, 'YTick',[1:0.1:2])
saveas(fig,[SaveFigFolder,'MeanCohPFCxNoFzQuantifThet.png']), 
saveas(fig,[SaveFigFolder,'MeanCohPFCxNoFzQuantifThet.fig']), close all
save([SaveFigFolder,'MeanCohPFCxNoFzQuantifThet.mat'],'p','h','stats'), close all, clear p h stats

%% Granger
BandLimsS=[find(freqBin<3,1,'last'):find(freqBin<6,1,'last')];
OtherFreq=[1:length(freqBin)];OtherFreq(ismember(OtherFreq,BandLimsS))=[];
BandLimsThet=[find(freqBin<6,1,'last'):find(freqBin<9,1,'last')];
OtherFreqThet=[1:length(freqBin)];OtherFreqThet(ismember(OtherFreq,BandLimsThet))=[];

% Granger NoFz HPC PFC
fig=figure;
subplot(121)
plot(freqBin,nanmean(Granger.NoFz.PFCx_HPC(IsCtrl==1,:)),':','color',Cols1(1,:)*0.7,'linewidth',3), hold on
plot(freqBin,nanmean(Granger.NoFz.HPC_PFCx(IsCtrl==1,:)),'color',Cols1(1,:)*0.7,'linewidth',3)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.PFCx_HPC(IsCtrl==1,:)),[stdError(Granger.NoFz.PFCx_HPC(IsCtrl==1,:));stdError(Granger.NoFz.PFCx_HPC(IsCtrl==1,:))]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',3,'linestyle',':')
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.HPC_PFCx(IsCtrl==1,:)),[stdError(Granger.NoFz.HPC_PFCx(IsCtrl==1,:));stdError(Granger.NoFz.HPC_PFCx(IsCtrl==1,:))]','alpha');
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',3)
set(hp,'FaceColor',Cols1(1,:))
xlim([0 20]),ylim([0 0.8])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
set(gca,'Layer','top')
legend({'PFCx-HPC';'HPC-PFCx'})
title('CTRL Granger NoFz')
subplot(122)
plot(freqBin,nanmean(Granger.NoFz.PFCx_HPC(IsCtrl==0,:)),':','color',Cols1(2,:)*0.7,'linewidth',3), hold on
plot(freqBin,nanmean(Granger.NoFz.HPC_PFCx(IsCtrl==0,:)),'color',Cols1(2,:)*0.7,'linewidth',3)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.PFCx_HPC(IsCtrl==0,:)),[stdError(Granger.NoFz.PFCx_HPC(IsCtrl==0,:));stdError(Granger.NoFz.PFCx_HPC(IsCtrl==0,:))]','alpha'),hold on
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3,'linestyle',':')
set(hp,'FaceColor',Cols1(2,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.HPC_PFCx(IsCtrl==0,:)),[stdError(Granger.NoFz.HPC_PFCx(IsCtrl==0,:));stdError(Granger.NoFz.HPC_PFCx(IsCtrl==0,:))]','alpha');
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3)
set(hp,'FaceColor',Cols1(2,:))
xlim([0 20]),ylim([0 0.8])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
legend({'PFCx-HPC';'HPC-PFCx'})
set(gca,'Layer','top')
title('BBX Granger NoFz')
saveas(fig,[SaveFigFolder,'GrangerNoFzHPCPFC.png']),
saveas(fig,[SaveFigFolder,'GrangerNoFzHPCPFC.fig']), close all

fig=figure;
DirectionA=nanmean(Granger.NoFz.PFCx_HPC(IsCtrl==0,BandLimsS)');
DirectionB=nanmean(Granger.NoFz.HPC_PFCx(IsCtrl==0,BandLimsS)');
line([0.7 1.3],[1 1]*nanmedian(DirectionB),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(DirectionA),'color','k','linewidth',2)
handlesplot=plotSpread({DirectionB,DirectionA},'distributionColors',[0,0,0;0,0,0]); hold on
set(handlesplot{1},'MarkerSize',20)
[p,h,stats]=signrank(DirectionB,DirectionA);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'HPC-PFC','PFC-HPC'})
set(gca,'FontSize',14, 'YTick',[0.1:0.1:1.4])
saveas(fig,[SaveFigFolder,'GrangerNoFzHPCPFCQuantif4HzBBX.png']), 
saveas(fig,[SaveFigFolder,'GrangerNoFzHPCPFCQuantif4HzBBX.fig']), close all
save([SaveFigFolder,'GrangerNoFzHPCPFCQuantif4HzBBX.mat'],'p','h','stats'), close all, clear p h stats

fig=figure;
DirectionA=nanmean(Granger.NoFz.PFCx_HPC(IsCtrl==0,BandLimsThet)');
DirectionB=nanmean(Granger.NoFz.HPC_PFCx(IsCtrl==0,BandLimsThet)');
line([0.7 1.3],[1 1]*nanmedian(DirectionB),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(DirectionA),'color','k','linewidth',2)
handlesplot=plotSpread({DirectionB,DirectionA},'distributionColors',[0,0,0;0,0,0]); hold on
set(handlesplot{1},'MarkerSize',20)
[p,h,stats]=signrank(DirectionB,DirectionA);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'HPC-PFC','PFC-HPC'})
set(gca,'FontSize',14, 'YTick',[0.1:0.1:1.4])
saveas(fig,[SaveFigFolder,'GrangerNoFzHPCPFCQuantifThetBBX.png']),
saveas(fig,[SaveFigFolder,'GrangerNoFzHPCPFCQuantifThetBBX.fig']), close all
save([SaveFigFolder,'GrangerNoFzHPCPFCQuantifThetBBX.mat'],'p','h','stats'), close all, clear p h stats


% Granger Fz HPC PFC
fig=figure;
subplot(121)
plot(freqBin,nanmean(Granger.Fz.PFCx_HPC(IsCtrl==1,:)),':','color',Cols1(1,:)*0.7,'linewidth',3), hold on
plot(freqBin,nanmean(Granger.Fz.HPC_PFCx(IsCtrl==1,:)),'color',Cols1(1,:)*0.7,'linewidth',3)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.PFCx_HPC(IsCtrl==1,:)),[stdError(Granger.Fz.PFCx_HPC(IsCtrl==1,:));stdError(Granger.Fz.PFCx_HPC(IsCtrl==1,:))]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',3,'linestyle',':')
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.HPC_PFCx(IsCtrl==1,:)),[stdError(Granger.Fz.HPC_PFCx(IsCtrl==1,:));stdError(Granger.Fz.HPC_PFCx(IsCtrl==1,:))]','alpha');
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',3)
set(hp,'FaceColor',Cols1(1,:))
xlim([0 20]),ylim([0 0.8])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
set(gca,'Layer','top')
legend({'PFCx-HPC';'HPC-PFCx'})
title('CTRL Granger Fz')
subplot(122)
plot(freqBin,nanmean(Granger.Fz.PFCx_HPC(IsCtrl==0,:)),':','color',Cols1(2,:)*0.7,'linewidth',3), hold on
plot(freqBin,nanmean(Granger.Fz.HPC_PFCx(IsCtrl==0,:)),'color',Cols1(2,:)*0.7,'linewidth',3)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.PFCx_HPC(IsCtrl==0,:)),[stdError(Granger.Fz.PFCx_HPC(IsCtrl==0,:));stdError(Granger.Fz.PFCx_HPC(IsCtrl==0,:))]','alpha'),hold on
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3,'linestyle',':')
set(hp,'FaceColor',Cols1(2,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.HPC_PFCx(IsCtrl==0,:)),[stdError(Granger.Fz.HPC_PFCx(IsCtrl==0,:));stdError(Granger.Fz.HPC_PFCx(IsCtrl==0,:))]','alpha');
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3)
set(hp,'FaceColor',Cols1(2,:))
xlim([0 20]),ylim([0 0.8])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
legend({'PFCx-HPC';'HPC-PFCx'})
set(gca,'Layer','top')
title('BBX Granger Fz')
saveas(fig,[SaveFigFolder,'GrangerFzHPCPFC.png']),
saveas(fig,[SaveFigFolder,'GrangerFzHPCPFC.fig']), close all

fig=figure;
DirectionA=nanmean(Granger.Fz.PFCx_HPC(IsCtrl==0,BandLimsS)');
DirectionB=nanmean(Granger.Fz.HPC_PFCx(IsCtrl==0,BandLimsS)');
line([0.7 1.3],[1 1]*nanmedian(DirectionB),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(DirectionA),'color','k','linewidth',2)
handlesplot=plotSpread({DirectionB,DirectionA},'distributionColors',[0,0,0;0,0,0]); hold on
set(handlesplot{1},'MarkerSize',20)
[p,h,stats]=signrank(DirectionB,DirectionA);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'HPC-PFC','PFC-HPC'})
set(gca,'FontSize',14, 'YTick',[0.1:0.1:1.4])
saveas(fig,[SaveFigFolder,'GrangerFzHPCPFCQuantif4HzBBX.png']), 
saveas(fig,[SaveFigFolder,'GrangerFzHPCPFCQuantif4HzBBX.fig']), close all
save([SaveFigFolder,'GrangerFzHPCPFCQuantif4HzBBX.mat'],'p','h','stats'), close all, clear p h stats

fig=figure;
DirectionA=nanmean(Granger.Fz.PFCx_HPC(IsCtrl==0,BandLimsThet)');
DirectionB=nanmean(Granger.Fz.HPC_PFCx(IsCtrl==0,BandLimsThet)');
line([0.7 1.3],[1 1]*nanmedian(DirectionB),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(DirectionA),'color','k','linewidth',2)
handlesplot=plotSpread({DirectionB,DirectionA},'distributionColors',[0,0,0;0,0,0]); hold on
set(handlesplot{1},'MarkerSize',20)
[p,h,stats]=signrank(DirectionB,DirectionA);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'HPC-PFC','PFC-HPC'})
set(gca,'FontSize',14, 'YTick',[0.1:0.1:1.4])
saveas(fig,[SaveFigFolder,'GrangerFzHPCPFCQuantifThetBBX.png']),
saveas(fig,[SaveFigFolder,'GrangerFzHPCPFCQuantifThetBBX.fig']), close all
save([SaveFigFolder,'GrangerFzHPCPFCQuantifThetBBX.mat'],'p','h','stats'), close all, clear p h stats

%% Im coherence

BandLimsS=[find(fC<3,1,'last'):find(fC<6,1,'last')];
OtherFreq=[1:length(fC)];OtherFreq(ismember(OtherFreq,BandLimsS))=[];
BandLimsThet=[find(fC<6,1,'last'):find(fC<9,1,'last')];
OtherFreqThet=[1:length(fC)];OtherFreqThet(ismember(OtherFreq,BandLimsThet))=[];

% Fz
fig=figure;
patch([3 3 6 6],[-10,20,20,-10],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fC,nanmean((ICoh.Fz.PFCx_HPC(IsCtrl==1,:))),[stdError((ICoh.Fz.PFCx_HPC(IsCtrl==1,:)));stdError((ICoh.Fz.PFCx_HPC(IsCtrl==1,:)))]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fC,nanmean(ICoh.Fz.PFCx_HPC(IsCtrl==0,:)),[stdError(ICoh.Fz.PFCx_HPC(IsCtrl==0,:));stdError(ICoh.Fz.PFCx_HPC(IsCtrl==0,:))]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Power - log scale')
ylim([0 1])
set(gca,'Layer','top')
title('PFCx-HPCICoherence FZ')
saveas(fig,[SaveFigFolder,'MeanAbsICohPFCxHPCFz.png']),
saveas(fig,[SaveFigFolder,'MeanAbsICohPFCxHPCFz.fig']), close all

ValCtrl=nanmean(ICoh.Fz.PFCx_HPC(IsCtrl==1,BandLimsS)');
ValOBX=nanmean(ICoh.Fz.PFCx_HPC(IsCtrl==0,BandLimsS)');
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValCtrl),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValOBX),'color','k','linewidth',2)
handles=plotSpread({ValCtrl,ValOBX},'distributionColors',[Cols1(1,:);Cols1(2,:)]); hold on
set(handles{1},'MarkerSize',20)
[p,h,stats]=ranksum(ValCtrl,ValOBX);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'Ctrl','OBX'})
set(gca,'FontSize',14, 'YTick',[-2:0.1:2])
saveas(fig,[SaveFigFolder,'MeanAbsICohPFCxHPCFzQuantif.png']),
saveas(fig,[SaveFigFolder,'MeanAbsICohPFCxHPCFzQuantif.fig']), close all
save([SaveFigFolder,'MeanAbsICohPFCxHPCFzQuantif.mat'],'p','h','stats'), close all, clear p h stats

ValCtrl=nanmean(ICoh.Fz.PFCx_HPC(IsCtrl==1,BandLimsThet)');
ValOBX=nanmean(ICoh.Fz.PFCx_HPC(IsCtrl==0,BandLimsThet)');
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValCtrl),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValOBX),'color','k','linewidth',2)
handles=plotSpread({ValCtrl,ValOBX},'distributionColors',[Cols1(1,:);Cols1(2,:)]); hold on
set(handles{1},'MarkerSize',20)
[p,h,stats]=ranksum(ValCtrl,ValOBX);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'Ctrl','OBX'})
set(gca,'FontSize',14, 'YTick',[-2:0.1:2])
saveas(fig,[SaveFigFolder,'MeanAbsICohPFCxFzQuantifThet.png']),
saveas(fig,[SaveFigFolder,'MeanAbsICohPFCxFzQuantifThet.fig']), close all
save([SaveFigFolder,'MeanAbsICohPFCxFzQuantifThet.mat'],'p','h','stats'), close all, clear p h stats


% No Fz
fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fC,nanmean(ICoh.NoFz.PFCx_HPC(IsCtrl==1,:)),[stdError(ICoh.NoFz.PFCx_HPC(IsCtrl==1,:));stdError(ICoh.NoFz.PFCx_HPC(IsCtrl==1,:))]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fC,nanmean(ICoh.NoFz.PFCx_HPC(IsCtrl==0,:)),[stdError(ICoh.NoFz.PFCx_HPC(IsCtrl==0,:));stdError(ICoh.NoFz.PFCx_HPC(IsCtrl==0,:))]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Power - log scale')
ylim([0 1])
set(gca,'Layer','top')
title('PFCx-HPCICoherence No FZ')
saveas(fig,[SaveFigFolder,'MeanAbsICohPFCxHPCNoFz.png']),
saveas(fig,[SaveFigFolder,'MeanAbsICohPFCxHPCNoFz.fig']), close all

ValCtrl=nanmean(ICoh.NoFz.PFCx_HPC(IsCtrl==1,BandLimsS)');
ValOBX=nanmean(ICoh.NoFz.PFCx_HPC(IsCtrl==0,BandLimsS)');
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValCtrl),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValOBX),'color','k','linewidth',2)
handles=plotSpread({ValCtrl,ValOBX},'distributionColors',[Cols1(1,:);Cols1(2,:)]); hold on
set(handles{1},'MarkerSize',20)
[p,h,stats]=ranksum(ValCtrl,ValOBX);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'Ctrl','OBX'})
set(gca,'FontSize',14, 'YTick',[0:0.1:2])
saveas(fig,[SaveFigFolder,'MeanAbsICohPFCxHPCNoFzFzQuantif.png']), 
saveas(fig,[SaveFigFolder,'MeanAbsICohPFCxHPCNoFzFzQuantif.fig']), close all
save([SaveFigFolder,'MeanAbsICohPFCxHPCNoFzFzQuantif.mat'],'p','h','stats'), close all, clear p h stats

ValCtrl=nanmean(ICoh.NoFz.PFCx_HPC(IsCtrl==1,BandLimsThet)');
ValOBX=nanmean(ICoh.NoFz.PFCx_HPC(IsCtrl==0,BandLimsThet)');
fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValCtrl),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValOBX),'color','k','linewidth',2)
handles=plotSpread({ValCtrl,ValOBX},'distributionColors',[Cols1(1,:);Cols1(2,:)]); hold on
set(handles{1},'MarkerSize',20)
[p,h,stats]=ranksum(ValCtrl,ValOBX);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'Ctrl','OBX'})
set(gca,'FontSize',14, 'YTick',[1:0.1:2])
saveas(fig,[SaveFigFolder,'MeanAbsICohPFCxNoFzQuantifThet.png']), 
saveas(fig,[SaveFigFolder,'MeanAbsICohPFCxNoFzQuantifThet.fig']), close all
save([SaveFigFolder,'MeanAbsICohPFCxNoFzQuantifThet.mat'],'p','h','stats'), close all, clear p h stats
