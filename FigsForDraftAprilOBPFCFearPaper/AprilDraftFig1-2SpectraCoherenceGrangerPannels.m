% This code generates pannels used in april draft
% It generates Fig1G,H,2A,4A
% Modified In August 2017
clear all, close all
% Get data

[Dir,KeepFirstSessionOnly]=GetRightSessionsFor4HzPaper('CtrlAllData')
% Where to save
SaveFigFolder='/home/vador/Dropbox/MOBS_workingON/OB4Hz-manuscrit/Figure1/';
Date=date;
SaveFigFolder=[SaveFigFolder,Date,filesep];

% Get parameters
Cols1=[0,109,219;146,146,146]/263;
Cols2=[0,146,146;189,109,255]/263;
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

n=1;
StrucNames={'HPC','OB','PFCx'};
for mm=KeepFirstSessionOnly
    disp(Dir.path{mm})
    
    cd(Dir.path{mm})
    clear chH chB chP
    load('behavResources.mat')
    disp(num2str(sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'))))
    
    tpsmax=max(Range(Movtsd));
    try,
        load('StateEpochSBOnlyRip.mat')
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
    load('B_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    % SB removed log 27/08/2018
    Spec.Fz.OB(n,:)=(nanmean((Data(Restrict(Sptsd,FreezeEpoch)))));
    Spec.NoFz.OB(n,:)=(nanmean((Data(Restrict(Sptsd,TotEpoch-FreezeEpoch)))));
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

BandLimsS=[find(fS<3,1,'last'):find(fS<6,1,'last')];
BandLimsC=[find(fC<3,1,'last'):find(fC<6,1,'last')];
OtherFreq=[1:length(fS)];OtherFreq(ismember(OtherFreq,BandLimsS))=[];
OtherFreqC=[1:length(fC)];OtherFreq(ismember(OtherFreq,BandLimsC))=[];
BandLimsG=[find(freqBin<3,1,'last'):find(freqBin<6,1,'last')];
OtherFreqG=[1:length(freqBin)];OtherFreq(ismember(OtherFreqG,BandLimsG))=[];

%% Spectra

% OB Spectra
fig=figure;
patch([3 3 6 6],[0,4.5,4.5,0]*1E5,[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fS,runmean(nanmean(Spec.Fz.OB),10),[stdError(Spec.Fz.OB);stdError(Spec.Fz.OB)]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fS,runmean(nanmean(Spec.NoFz.OB),10),[stdError(Spec.NoFz.OB);stdError(Spec.NoFz.OB)]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Power')
ylim([7.5 13])
set(gca,'Layer','top')
title('OB Spectrum')
saveas(fig,[SaveFigFolder,'MeanSpecOBOnlyRip.png']), 
saveas(fig,[SaveFigFolder,'MeanSpecOBOnlyRip.fig']), close all

ValsFz=nanmean(Spec.Fz.OB(:,BandLimsS)')./nanmean(Spec.Fz.OB(:,OtherFreq)');
ValsNoFz=nanmean(Spec.NoFz.OB(:,BandLimsS)')./nanmean(Spec.NoFz.OB(:,OtherFreq)');
fig=figure;
line([0.7 1.3],[1 1]*nanmedian(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(ValsFz),'color','k','linewidth',2)
handlesplot=plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols1(2,:);Cols1(1,:)]), hold on;
set(handlesplot{1},'MarkerSize',20)
set(gca,'FontSize',14, 'YTick',[1.1:0.1:1.3])
[p,h,stats]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'NoFz','Fz'})
title('OB Spectrum- quantif')
ylabel('SNR 3-6')
saveas(fig,[SaveFigFolder,'MeanSpecOBQuantifOnlyRip.png']),
saveas(fig,[SaveFigFolder,'MeanSpecOBQuantifOnlyRip.fig']), close all
save([SaveFigFolder,'MeanSpecOBQuantifOnlyRip.mat'],'p','h','stats'), close all, clear p h stats


figure
clf
Vals = {ValsNoFz'; ValsFz'};
XPos = [1.1,1.9,3.5,4.4];
Colors_Points = [Cols1(2,:);Cols1(1,:)];
Colors_Boxplot = [0.9,0.9,0.9;0.9,0.9,1];
for k = 1:2
X = Vals{k};
a=iosr.statistics.boxPlot(XPos(k),X,'boxColor',Colors_Boxplot(k,:),'lineColor',Colors_Boxplot(k,:),'medianColor','k','boxWidth',0.5,'showOutliers',false);
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;

handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',XPos(k),'spreadWidth',0.7), hold on;
set(handlesplot{1},'MarkerSize',22)
handlesplot=plotSpread(X,'distributionColors',Colors_Points(k,:),'xValues',XPos(k),'spreadWidth',0.7), hold on;
set(handlesplot{1},'MarkerSize',12)

end

xlim([0.5 2.5])
ylim([1.1 1.4])
set(gca,'FontSize',18,'XTick',XPos,'XTickLabel',{'NoFz','Fz'},'linewidth',1.5,'YTick',[1.1,1.2,1.3])
ylabel('SNR 3-6Hz')
box off



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
title('PFC Spectrum')
saveas(fig,[SaveFigFolder,'MeanSpecPFCOnlyRip.png']), 
saveas(fig,[SaveFigFolder,'MeanSpecPFCOnlyRip.fig']), close all

ValsFz=nanmean(Spec.Fz.PFC(:,BandLimsS)')./nanmean(Spec.Fz.PFC(:,OtherFreq)');
ValsNoFz=nanmean(Spec.NoFz.PFC(:,BandLimsS)')./nanmean(Spec.NoFz.PFC(:,OtherFreq)');
fig=figure;
line([0.7 1.3],[1 1]*nanmedian(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(ValsFz),'color','k','linewidth',2)
handlesplot=plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols1(2,:);Cols1(1,:)]); hold on
set(handlesplot{1},'MarkerSize',20)
set(gca,'FontSize',14, 'YTick',[1.1:0.1:1.4])
[p,h,stats]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'NoFz','Fz'})
title('PFC Spectrum- quantif')
ylabel('SNR 3-6')
saveas(fig,[SaveFigFolder,'MeanSpecPFCQuantifOnlyRip.png'])
saveas(fig,[SaveFigFolder,'MeanSpecPFCQuantifOnlyRip.fig']), close all
save([SaveFigFolder,'MeanSpecPFCQuantifOnlyRip.mat'],'p','h','stats'), close all, clear p h stats

figure
clf
Vals = {ValsNoFz'; ValsFz'};
XPos = [1.1,1.9,3.5,4.4];
Colors_Points = [Cols1(2,:);Cols1(1,:)];
Colors_Boxplot = [0.9,0.9,0.9;0.9,0.9,1];
for k = 1:2
X = Vals{k};
a=iosr.statistics.boxPlot(XPos(k),X,'boxColor',Colors_Boxplot(k,:),'lineColor',Colors_Boxplot(k,:),'medianColor','k','boxWidth',0.5,'showOutliers',false);
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;

handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',XPos(k),'spreadWidth',0.7), hold on;
set(handlesplot{1},'MarkerSize',22)
handlesplot=plotSpread(X,'distributionColors',Colors_Points(k,:),'xValues',XPos(k),'spreadWidth',0.7), hold on;
set(handlesplot{1},'MarkerSize',12)

end

xlim([0.5 2.5])
ylim([1.1 1.4])
set(gca,'FontSize',18,'XTick',XPos,'XTickLabel',{'NoFz','Fz'},'linewidth',1.5,'YTick',[1.1,1.2,1.3])
ylabel('SNR 3-6Hz')
box off

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
title('HPC Spectrum')
ValsFz=nanmean(Spec.Fz.HPC(:,BandLimsS)')./nanmean(Spec.Fz.HPC(:,OtherFreq)');
ValsNoFz=nanmean(Spec.NoFz.HPC(:,BandLimsS)')./nanmean(Spec.NoFz.HPC(:,OtherFreq)');
saveas(fig,[SaveFigFolder,'MeanSpecHPCOnlyRip.fig']), close all

fig=figure;
line([0.7 1.3],[1 1]*nanmedian(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(ValsFz),'color','k','linewidth',2)
handlesplot=plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols1(2,:);Cols1(1,:)]); hold on
set(handlesplot{1},'MarkerSize',20)
[p,h,stats]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'FontSize',14, 'YTick',[1:0.1:1.4])
set(gca,'XTickLabel',{'NoFz','Fz'})
title('HPC Spectrum- quantif')
ylabel('SNR 3-6')
saveas(fig,[SaveFigFolder,'MeanSpecHPCQuantifOnlyRip.png'])
saveas(fig,[SaveFigFolder,'MeanSpecHPCQuantifOnlyRip.fig']), close all
save([SaveFigFolder,'MeanSpecHPCQuantifOnlyRip.mat'],'p','h','stats'), close all, clear p h stats

%% Coherence
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
title('OB/PFC coherence')
saveas(fig,[SaveFigFolder,'MeanCohPFCOBOnlyRip.png'])
saveas(fig,[SaveFigFolder,'MeanCohPFCOBOnlyRip.fig']), close all

ValsFz=nanmean(Coh.Fz.PFCx_OB(:,BandLimsC)');
ValsNoFz=nanmean(Coh.NoFz.PFCx_OB(:,BandLimsC)');

fig=figure;
line([0.7 1.3],[1 1]*nanmedian(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(ValsFz),'color','k','linewidth',2)
handlesplot=plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols1(2,:);Cols1(1,:)]); hold on
set(handlesplot{1},'MarkerSize',20)
[p,h,stats]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'FontSize',14, 'YTick',[0.5:0.1:1.4])
set(gca,'XTickLabel',{'NoFz','Fz'})
title('OB/PFC coherence- quantif')
ylabel('SNR 3-6')
saveas(fig,[SaveFigFolder,'MeanCohPFCOBQuantfiOnlyRip.png']),
saveas(fig,[SaveFigFolder,'MeanCohPFCOBQuantfiOnlyRip.fig']), close all
save([SaveFigFolder,'MeanCohPFCOBQuantfiOnlyRip.mat'],'p','h','stats'), close all, clear p h stats

figure
clf
Vals = {ValsNoFz'; ValsFz'};
XPos = [1.1,1.9,3.5,4.4];
Colors_Points = [Cols1(2,:);Cols1(1,:)];
Colors_Boxplot = [0.9,0.9,0.9;0.9,0.9,1];
for k = 1:2
X = Vals{k};
a=iosr.statistics.boxPlot(XPos(k),X,'boxColor',Colors_Boxplot(k,:),'lineColor',Colors_Boxplot(k,:),'medianColor','k','boxWidth',0.5,'showOutliers',false);
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;

handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',XPos(k),'spreadWidth',0.7), hold on;
set(handlesplot{1},'MarkerSize',22)
handlesplot=plotSpread(X,'distributionColors',Colors_Points(k,:),'xValues',XPos(k),'spreadWidth',0.7), hold on;
set(handlesplot{1},'MarkerSize',12)

end

xlim([0.5 2.5])
ylim([0.4 1])
set(gca,'FontSize',18,'XTick',XPos,'XTickLabel',{'NoFz','Fz'},'linewidth',1.5,'YTick',[0.4:0.2:1])
ylabel('Coherence')
box off


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
title('HPC/PFC coherence')
saveas(fig,[SaveFigFolder,'MeanCohPFCHPCOnlyRip.png'])
saveas(fig,[SaveFigFolder,'MeanCohPFCHPCOnlyRip.fig']), close all

fig=figure;
line([0.7 1.3],[1 1]*nanmedian(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(ValsFz),'color','k','linewidth',2)
handlesplot=plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols1(2,:);Cols1(1,:)]); hold on
set(handlesplot{1},'MarkerSize',20)
[p,h,stats]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'NoFz','Fz'})
set(gca,'FontSize',14, 'YTick',[0.3:0.1:1.4])
title('HPC/PFC coherence- quantif')
ylabel('SNR 3-6')
saveas(fig,[SaveFigFolder,'MeanCohPFCHPCQuantifOnlyRip.png'])
saveas(fig,[SaveFigFolder,'MeanCohPFCHPCQuantifOnlyRip.fig']), close all
save([SaveFigFolder,'MeanCohPFCHPCQuantifOnlyRip.mat'],'p','h','stats'), close all, clear p h stats


%Coh OB HPC
fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fC,nanmean(Coh.Fz.OB_HPC),[stdError(Coh.Fz.OB_HPC);stdError(Coh.Fz.OB_HPC)]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fC,nanmean(Coh.NoFz.OB_HPC),[stdError(Coh.NoFz.OB_HPC);stdError(Coh.NoFz.OB_HPC)]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Coherence')
ylim([0.4 1])
set(gca,'Layer','top')
ValsFz=nanmean(Coh.Fz.OB_HPC(:,BandLimsC)');
ValsNoFz=nanmean(Coh.NoFz.OB_HPC(:,BandLimsC)');
title('HPC/OB coherence')
saveas(fig,[SaveFigFolder,'MeanCohOBHPCOnlyRip.png'])
saveas(fig,[SaveFigFolder,'MeanCohOBHPCOnlyRip.fig']), close all

fig=figure;
line([0.7 1.3],[1 1]*nanmedian(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(ValsFz),'color','k','linewidth',2)
handlesplot=plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols1(2,:);Cols1(1,:)]); hold on
set(handlesplot{1},'MarkerSize',20)
[p,h,stats]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'NoFz','Fz'})
set(gca,'FontSize',14, 'YTick',[0.3:0.1:1.4])
title('HPC/OB coherence- quantif')
ylabel('SNR 3-6')
saveas(fig,[SaveFigFolder,'MeanCohPFCOBQuantifOnlyRip.png']),
saveas(fig,[SaveFigFolder,'MeanCohPFCOBQuantifOnlyRip.fig']), close all
save([SaveFigFolder,'MeanCohPFCOBQuantifOnlyRip.mat'],'p','h','stats'), close all, clear p h stats


%% Granger 
% Granger Fz OB PFC
fig=figure;
plot(freqBin,nanmean(Granger.Fz.PFCx_OB),'k:','linewidth',3), hold on
plot(freqBin,nanmean(Granger.Fz.OB_PFCx),'k','linewidth',3)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95)
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.PFCx_OB),[stdError(Granger.Fz.PFCx_OB);stdError(Granger.Fz.PFCx_OB)]','alpha'),hold on
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3,'linestyle',':')
set(hp,'FaceColor',Cols1(2,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.OB_PFCx),[stdError(Granger.Fz.OB_PFCx);stdError(Granger.Fz.OB_PFCx)]','alpha');
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3)
set(hp,'FaceColor',Cols1(2,:))
xlim([0 20]),ylim([0 0.35])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
set(gca,'Layer','top')
legend({'PFC-OB';'OB-PFC'})
DirectionA=nanmean(Granger.Fz.PFCx_OB(:,BandLimsG)');
DirectionB=nanmean(Granger.Fz.OB_PFCx(:,BandLimsG)');
saveas(fig,[SaveFigFolder,'GrangerFZOBPFCOnlyRip.png']),
saveas(fig,[SaveFigFolder,'GrangerFZOBPFCOnlyRip.fig']), close all

fig=figure;
line([0.7 1.3],[1 1]*nanmedian(DirectionB),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(DirectionA),'color','k','linewidth',2)
handlesplot=plotSpread({DirectionB,DirectionA},'distributionColors',[0,0,0;0,0,0]); hold on
set(handlesplot{1},'MarkerSize',20)
[p,h,stats]=signrank(DirectionB,DirectionA);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'OB-PFC','PFC-OB'})
set(gca,'FontSize',14, 'YTick',[0.1:0.1:1.4])
ylabel('Granger causality')
saveas(fig,[SaveFigFolder,'GrangerFzOBPFCQuantifOnlyRip.fig']),
saveas(fig,[SaveFigFolder,'GrangerFzOBPFCQuantifOnlyRip.png']), close all
save([SaveFigFolder,'GrangerFzOBPFCQuantifOnlyRip.mat'],'p','h','stats'), close all, clear p h stats


figure
clf
Vals = {DirectionB'; DirectionA'};
XPos = [1.1,1.9,3.5,4.4];
Colors_Points = [0.5,0.5,0.5;0.5,0.5,0.5];
Colors_Boxplot = [0.9,0.9,0.9;0.9,0.9,0.9];
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
ylim([-0.05 0.65])
set(gca,'FontSize',18,'XTick',XPos,'XTickLabel',{'OB->PFC','PFC->OB'},'linewidth',1.5,'YTick',[0:0.2:0.6])
ylabel('3-6Hz G. causality')
box off



% Granger NoFz OB PFC
fig=figure;
plot(freqBin,nanmean(Granger.NoFz.PFCx_OB),'k:','linewidth',3), hold on
plot(freqBin,nanmean(Granger.NoFz.OB_PFCx),'k','linewidth',3)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.PFCx_OB),[stdError(Granger.NoFz.PFCx_OB);stdError(Granger.NoFz.PFCx_OB)]','alpha'),hold on
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3,'linestyle',':')
set(hp,'FaceColor',Cols1(2,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.OB_PFCx),[stdError(Granger.NoFz.OB_PFCx);stdError(Granger.NoFz.OB_PFCx)]','alpha');
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3)
set(hp,'FaceColor',Cols1(2,:))
xlim([0 20]),ylim([0 0.35])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
set(gca,'Layer','top')
legend({'PFC-OB';'OB-PFC'})
DirectionA=nanmean(Granger.NoFz.PFCx_OB(:,BandLimsG)');
DirectionB=nanmean(Granger.NoFz.OB_PFCx(:,BandLimsG)');
saveas(fig,[SaveFigFolder,'GrangerNoFzOBPFCOnlyRip.png']),
saveas(fig,[SaveFigFolder,'GrangerNoFzOBPFCOnlyRip.fig']), close all

fig=figure;
line([0.7 1.3],[1 1]*nanmedian(DirectionB),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(DirectionA),'color','k','linewidth',2)
handlesplot=plotSpread({DirectionB,DirectionA},'distributionColors',[0,0,0;0,0,0]); hold on
set(handlesplot{1},'MarkerSize',20)
[p,h,stats]=signrank(DirectionB,DirectionA);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'OB-PFC','PFC-OB'})
set(gca,'FontSize',14, 'YTick',[0.1:0.1:1.4])
ylabel('Granger causality')
saveas(fig,[SaveFigFolder,'GrangerNoFzOBPFCQuantifOnlyRip.png']), 
saveas(fig,[SaveFigFolder,'GrangerNoFzOBPFCQuantifOnlyRip.fig']), close all
save([SaveFigFolder,'GrangerNoFzOBPFCQuantifOnlyRip.mat'],'p','h','stats'), close all, clear p h stats

% Granger Fz PFC HPC
fig=figure;
plot(freqBin,nanmean(Granger.Fz.PFCx_HPC),'k:','linewidth',3), hold on
plot(freqBin,nanmean(Granger.Fz.HPC_PFCx),'k','linewidth',3)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.PFCx_HPC),[stdError(Granger.Fz.PFCx_HPC);stdError(Granger.Fz.PFCx_HPC)]','alpha'),hold on
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3,'linestyle',':')
set(hp,'FaceColor',Cols1(2,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.HPC_PFCx),[stdError(Granger.Fz.HPC_PFCx);stdError(Granger.Fz.HPC_PFCx)]','alpha');
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3)
set(hp,'FaceColor',Cols1(2,:))
xlim([0 20]),ylim([0 0.35])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
set(gca,'Layer','top')
DirectionA=nanmean(Granger.Fz.PFCx_HPC(:,BandLimsG)');
DirectionB=nanmean(Granger.Fz.HPC_PFCx(:,BandLimsG)');
legend({'PFC-HPC';'HPC-PFC'})
saveas(fig,[SaveFigFolder,'GrangerFZHPCPFCOnlyRip.png']),
saveas(fig,[SaveFigFolder,'GrangerFZHPCPFCOnlyRip.fig']), close all

fig=figure;
line([0.7 1.3],[1 1]*nanmedian(DirectionB),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(DirectionA),'color','k','linewidth',2)
handlesplot=plotSpread({DirectionB,DirectionA},'distributionColors',[0,0,0;0,0,0]); hold on
set(handlesplot{1},'MarkerSize',20)
[p,h,stats]=signrank(DirectionB,DirectionA);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'HPC-PFC','PFC-HPC'})
set(gca,'FontSize',14, 'YTick',[0.1:0.1:1.4])
ylabel('Granger causality')
saveas(fig,[SaveFigFolder,'GrangerFzHPCPFCQuantifOnlyRip.png'])
saveas(fig,[SaveFigFolder,'GrangerFzHPCPFCQuantifOnlyRip.fig']), close all
save([SaveFigFolder,'GrangerFzHPCPFCQuantifOnlyRip.mat'],'p','h','stats'), close all, clear p h stats

% Granger NoFz HPC PFC
fig=figure;
plot(freqBin,nanmean(Granger.NoFz.PFCx_HPC),'k:','linewidth',3), hold on
plot(freqBin,nanmean(Granger.NoFz.HPC_PFCx),'k','linewidth',3)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.PFCx_HPC),[stdError(Granger.NoFz.PFCx_HPC);stdError(Granger.NoFz.PFCx_HPC)]','alpha'),hold on
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3,'linestyle',':')
set(hp,'FaceColor',Cols1(2,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.HPC_PFCx),[stdError(Granger.NoFz.HPC_PFCx);stdError(Granger.NoFz.HPC_PFCx)]','alpha');
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3)
set(hp,'FaceColor',Cols1(2,:))
xlim([0 20]),ylim([0 0.35])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
set(gca,'Layer','top')
DirectionA=nanmean(Granger.NoFz.PFCx_HPC(:,BandLimsG)');
DirectionB=nanmean(Granger.NoFz.HPC_PFCx(:,BandLimsG)');
legend({'PFC-HPC';'HPC-PFC'})
saveas(fig,[SaveFigFolder,'GrangerNoFzHPCPFCOnlyRip.png'])
saveas(fig,[SaveFigFolder,'GrangerNoFzHPCPFCOnlyRip.fig']), close all

fig=figure;
line([0.7 1.3],[1 1]*nanmedian(DirectionB),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(DirectionA),'color','k','linewidth',2)
handlesplot=plotSpread({DirectionB,DirectionA},'distributionColors',[0,0,0;0,0,0]); hold on
set(handlesplot{1},'MarkerSize',20)
[p,h,stats]=signrank(DirectionB,DirectionA);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'HPC-PFC','PFC-HPC'})
set(gca,'FontSize',14, 'YTick',[0.1:0.1:1.4])
ylabel('Granger causality')
saveas(fig,[SaveFigFolder,'GrangerNoFzHPCPFCQuantifOnlyRip.png']),
saveas(fig,[SaveFigFolder,'GrangerNoFzHPCPFCQuantifOnlyRip.fig']), close all
save([SaveFigFolder,'GrangerNoFzHPCPFCQuantifOnlyRip.mat'],'p','h','stats'), close all, clear p h stats


% Granger Fz OB HPC
fig=figure;
plot(freqBin,nanmean(Granger.Fz.OB_HPC),'k:','linewidth',3), hold on
plot(freqBin,nanmean(Granger.Fz.HPC_OB),'k','linewidth',3)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.OB_HPC),[stdError(Granger.Fz.OB_HPC);stdError(Granger.Fz.OB_HPC)]','alpha'),hold on
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3,'linestyle',':')
set(hp,'FaceColor',Cols1(2,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.HPC_OB),[stdError(Granger.Fz.HPC_OB);stdError(Granger.Fz.HPC_OB)]','alpha');
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3)
set(hp,'FaceColor',Cols1(2,:))
xlim([0 20]),ylim([0 0.35])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
set(gca,'Layer','top')
DirectionA=nanmean(Granger.Fz.OB_HPC(:,BandLimsG)');
DirectionB=nanmean(Granger.Fz.HPC_OB(:,BandLimsG)');
legend({'OB-HPC';'HPC-OB'})
saveas(fig,'GrangerFZHPCOBOnlyRip.png')
saveas(fig,[SaveFigFolder,'GrangerFZHPCOBOnlyRip.fig']), close all

fig=figure;
line([0.7 1.3],[1 1]*nanmedian(DirectionB),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(DirectionA),'color','k','linewidth',2)
handlesplot=plotSpread({DirectionB,DirectionA},'distributionColors',[0,0,0;0,0,0]); hold on
set(handlesplot{1},'MarkerSize',20)
[p,h,stats]=signrank(DirectionB,DirectionA);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'OB-HPC','HPC-OB'})
set(gca,'FontSize',14, 'YTick',[0.1:0.1:1.4])
ylabel('Granger causality')
saveas(fig,[SaveFigFolder,'GrangerFzHPCOBQuantifOnlyRip.png']), 
saveas(fig,[SaveFigFolder,'GrangerFzHPCOBQuantifOnlyRip.fig']), close all
save([SaveFigFolder,'GrangerFzHPCOBQuantifOnlyRip.mat'],'p','h','stats'), close all, clear p h stats

% Granger NoFz HPC OB
fig=figure;
plot(freqBin,nanmean(Granger.NoFz.OB_HPC),'k:','linewidth',3), hold on
plot(freqBin,nanmean(Granger.NoFz.HPC_OB),'k','linewidth',3)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.OB_HPC),[stdError(Granger.NoFz.OB_HPC);stdError(Granger.NoFz.OB_HPC)]','alpha'),hold on
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3,'linestyle',':')
set(hp,'FaceColor',Cols1(2,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.HPC_OB),[stdError(Granger.NoFz.HPC_OB);stdError(Granger.NoFz.HPC_OB)]','alpha');
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3)
set(hp,'FaceColor',Cols1(2,:))
xlim([0 20]),ylim([0 0.35])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
set(gca,'Layer','top')
DirectionA=nanmean(Granger.NoFz.OB_HPC(:,BandLimsG)');
DirectionB=nanmean(Granger.NoFz.HPC_OB(:,BandLimsG)');
legend({'OB-HPC';'HPC-OB'})
saveas(fig,[SaveFigFolder,'GrangerNoFzHPCOBOnlyRip.png']),
saveas(fig,[SaveFigFolder,'GrangerNoFzHPCOBOnlyRip.fig']), close all

fig=figure;
line([0.7 1.3],[1 1]*nanmedian(DirectionB),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(DirectionA),'color','k','linewidth',2)
handlesplot=plotSpread({DirectionB,DirectionA},'distributionColors',[0,0,0;0,0,0]); hold on
set(handlesplot{1},'MarkerSize',20)
[p,h,stats]=signrank(DirectionB,DirectionA);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'OB-HPC','HPC-OB'})
set(gca,'FontSize',14, 'YTick',[0.1:0.1:1.4])
ylabel('Granger causality')
saveas(fig,[SaveFigFolder,'GrangerNoFzHPCOBQuantifOnlyRip.png']),
saveas(fig,[SaveFigFolder,'GrangerNoFzHPOBCQuantifOnlyRip.fig']), close all
save([SaveFigFolder,'GrangerNoFzHPCOBQuantifOnlyRip.mat'],'p','h','stats'), close all, clear p h stats



%% ICoherence
% ICoh OB PFC
fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fC,nanmean(ICoh.Fz.PFCx_OB),[stdError(ICoh.Fz.PFCx_OB);stdError(ICoh.Fz.PFCx_OB)]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fC,nanmean(ICoh.NoFz.PFCx_OB),[stdError(ICoh.NoFz.PFCx_OB);stdError(ICoh.NoFz.PFCx_OB)]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('ICoherence')
ylim([0 1])
set(gca,'Layer','top')
title('OB/PFC ICoherence')
ValsFz=nanmean(ICoh.Fz.PFCx_OB(:,BandLimsC)');
ValsNoFz=nanmean(ICoh.NoFz.PFCx_OB(:,BandLimsC)');
saveas(fig,[SaveFigFolder,'MeanICohPFCOBOnlyRip.png'])
saveas(fig,[SaveFigFolder,'MeanICohPFCOBOnlyRip.fig']), close all

fig=figure;
line([0.7 1.3],[1 1]*nanmedian(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(ValsFz),'color','k','linewidth',2)
handlesplot=plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols1(2,:);Cols1(1,:)]); hold on
set(handlesplot{1},'MarkerSize',20)
[p,h,stats]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'FontSize',14, 'YTick',[0.5:0.1:1.4])
set(gca,'XTickLabel',{'NoFz','Fz'})
title('OB/PFC ICoherence- quantif')
ylabel('SNR 3-6')
saveas(fig,[SaveFigFolder,'MeanICohPFCOBQuantfiOnlyRip.png']),
saveas(fig,[SaveFigFolder,'MeanICohPFCOBQuantfiOnlyRip.fig']), close all
save([SaveFigFolder,'MeanICohPFCOBQuantfiOnlyRip.mat'],'p','h','stats'), close all, clear p h stats

%ICoh PFC HPC
fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fC,nanmean(ICoh.Fz.PFCx_HPC),[stdError(ICoh.Fz.PFCx_HPC);stdError(ICoh.Fz.PFCx_HPC)]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fC,nanmean(ICoh.NoFz.PFCx_HPC),[stdError(ICoh.NoFz.PFCx_HPC);stdError(ICoh.NoFz.PFCx_HPC)]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('ICoherence')
ylim([0 1])
set(gca,'Layer','top')
ValsFz=nanmean(ICoh.Fz.PFCx_HPC(:,BandLimsC)');
ValsNoFz=nanmean(ICoh.NoFz.PFCx_HPC(:,BandLimsC)');
title('HPC/PFC ICoherence')
saveas(fig,[SaveFigFolder,'MeanICohPFCHPCOnlyRip.png'])
saveas(fig,[SaveFigFolder,'MeanICohPFCHPCOnlyRip.fig']), close all

fig=figure;
line([0.7 1.3],[1 1]*nanmedian(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(ValsFz),'color','k','linewidth',2)
handlesplot=plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols1(2,:);Cols1(1,:)]); hold on
set(handlesplot{1},'MarkerSize',20)
[p,h,stats]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'NoFz','Fz'})
set(gca,'FontSize',14, 'YTick',[0.3:0.1:1.4])
title('HPC/PFC ICoherence- quantif')
ylabel('SNR 3-6')
saveas(fig,[SaveFigFolder,'MeanICohPFCHPCQuantifOnlyRip.png'])
saveas(fig,[SaveFigFolder,'MeanICohPFCHPCQuantifOnlyRip.fig']), close all
save([SaveFigFolder,'MeanICohPFCHPCQuantifOnlyRip.mat'],'p','h','stats'), close all, clear p h stats


%ICoh OB HPC
fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fC,nanmean(ICoh.Fz.OB_HPC),[stdError(ICoh.Fz.OB_HPC);stdError(ICoh.Fz.OB_HPC)]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fC,nanmean(ICoh.NoFz.OB_HPC),[stdError(ICoh.NoFz.OB_HPC);stdError(ICoh.NoFz.OB_HPC)]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('ICoherence')
ylim([0 1])
set(gca,'Layer','top')
ValsFz=nanmean(ICoh.Fz.OB_HPC(:,BandLimsC)');
ValsNoFz=nanmean(ICoh.NoFz.OB_HPC(:,BandLimsC)');
title('HPC/OB ICoherence')
saveas(fig,[SaveFigFolder,'MeanICohOBHPCOnlyRip.png'])
saveas(fig,[SaveFigFolder,'MeanICohOBHPCOnlyRip.fig']), close all

fig=figure;
line([0.7 1.3],[1 1]*nanmedian(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(ValsFz),'color','k','linewidth',2)
handlesplot=plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols1(2,:);Cols1(1,:)]); hold on
set(handlesplot{1},'MarkerSize',20)
[p,h,stats]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'NoFz','Fz'})
set(gca,'FontSize',14, 'YTick',[0.3:0.1:1.4])
title('HPC/OB ICoherence- quantif')
ylabel('SNR 3-6')
saveas(fig,[SaveFigFolder,'MeanICohPFCOBQuantifOnlyRip.png']),
saveas(fig,[SaveFigFolder,'MeanICohPFCOBQuantifOnlyRip.fig']), close all
save([SaveFigFolder,'MeanICohPFCOBQuantifOnlyRip.mat'],'p','h','stats'), close all, clear p h stats