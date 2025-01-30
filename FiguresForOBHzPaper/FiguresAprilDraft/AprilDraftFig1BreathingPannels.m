% This code generates pannels used in april draft
% It generates Fig1D,E,H
clear all,close all
% Get data
Dir=PathForExperimentFEARMac('Fear-electrophy-plethysmo');
%Dir=PathForExperimentFEAR('Fear-electrophy-plethysmo');

% Where to save
SaveFigFolder='/Users/sophiebagur/Dropbox/OB4Hz-manuscrit/FigTest/';
Date=date;
SaveFigFolder=[SaveFigFolder,Date,filesep];

% Get parameters
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
Cols1=[0,109,219;146,0,0]/263;
Cols2=[0,146,146;189,109,255]/263;
Convto1ML=277139.48707754;

n=1;
StrucNames={'OB','PFCx','Respi'};
for mm=1:length(Dir.path)
    Dir.path{mm}
    cd(Dir.path{mm})
    clear chH chB chP FreezeEpoch FreezeEpochAcc NoFreezeEpoch TotalNoiseEpoch
    load('behavResources.mat')
    try, FreezeEpoch=FreezeEpochAcc; end
    tpsmax=max(Range(Movtsd));
    load('StateEpochSB.mat')
    TotEpoch=intervalSet(0,tpsmax)-TotalNoiseEpoch;
    
    
    clear  Sptsd Spectro
    try
        load('PFCx_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        Spec.Fz.PFC(n,:)=(nanmean(log(Data(Restrict(Sptsd,FreezeEpoch)))));
        Spec.NoFz.PFC(n,:)=(nanmean(log(Data(Restrict(Sptsd,NoFreezeEpoch-TotalNoiseEpoch)))));
        chP=ch;
    catch
        Spec.Fz.PFC(n,:)=nan(1,263);
        Spec.NoFz.PFC(n,:)=nan(1,263);
        chP=NaN;
    end
    
    clear  Sptsd Spectro
    load('B_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    Spec.Fz.OB(n,:)=(nanmean(log(Data(Restrict(Sptsd,FreezeEpoch)))));
    Spec.NoFz.OB(n,:)=(nanmean(log(Data(Restrict(Sptsd,NoFreezeEpoch-TotalNoiseEpoch)))));
    chB=ch;
    
    % Respi
    clear channel
    load('ChannelsToAnalyse/Respi.mat')
    chR=channel;
    load('Respi_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    Spec.Fz.Respi(n,:)=(nanmean(log(Data(Restrict(Sptsd,FreezeEpoch)))));
    Spec.NoFz.Respi(n,:)=(nanmean(log(Data(Restrict(Sptsd,NoFreezeEpoch-TotalNoiseEpoch)))));
    chR=ch;
    fS=Spectro{3};
    
    % Coherence
    AllCombi=combnk([chB,chP,chR],2);
    AllCombiNums=combnk([1,2,3],2);
    for st=1:size(AllCombi,1)
        if sum(isnan(AllCombi(st,:)))==0
            NameTemp1=['CohgramcDataL/Cohgram_',num2str(AllCombi(st,1)),'_',num2str(AllCombi(st,2)),'.mat'];
            NameTemp2=['CohgramcDataL/Cohgram_',num2str(AllCombi(st,2)),'_',num2str(AllCombi(st,1)),'.mat'];
            try, load(NameTemp1);
            catch
                load(NameTemp2);
            end
            Ctsd=tsd(t*1e4,C);
            temp=nanmean(Data(Restrict(Ctsd,FreezeEpoch)));
            eval(['Coh.Fz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'(n,:)=temp(1:261);']);
            temp=nanmean(Data(Restrict(Ctsd,NoFreezeEpoch-TotalNoiseEpoch)));
            eval(['Coh.NoFz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'(n,:)=temp(1:261);']);
            fC=f;
            clear C
        else
            eval(['Coh.Fz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'(n,:)=nan(1,261);']);
            eval(['Coh.NoFz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'(n,:)=nan(1,261);']);
            
        end
    end
    
    for st=1:size(AllCombi,1)
        if sum(isnan(AllCombi(st,:)))==0
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
        else
            eval(['Granger.Fz.',StrucNames{AllCombiNums(st,1)},'_',StrucNames{AllCombiNums(st,2)},'(n,:)=NaN(1,1250);']);
            eval(['Granger.Fz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'(n,:)=nan(1,1250);']);
            
            eval(['Granger.NoFz.',StrucNames{AllCombiNums(st,1)},'_',StrucNames{AllCombiNums(st,2)},'(n,:)=NaN(1,1250);']);
            eval(['Granger.NoFz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'(n,:)=nan(1,1250);']);
            
        end
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


fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fS,runmean(nanmean(Spec.Fz.Respi),5),[stdError(Spec.Fz.Respi);stdError(Spec.Fz.Respi)]','alpha'),hold on
set(hl,'Color',Cols1(1,:),'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fS,runmean(nanmean(Spec.NoFz.Respi),5),[stdError(Spec.NoFz.Respi);stdError(Spec.NoFz.Respi)]','alpha')
set(hl,'Color',Cols1(2,:),'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Power - log scale')
ylim([0 7]), xlim([0 20])
set(gca,'Layer','top')
ValsFz=nanmean(Spec.Fz.Respi(:,BandLimsS)')./nanmean(Spec.Fz.Respi(:,OtherFreq)');
ValsNoFz=nanmean(Spec.NoFz.Respi(:,BandLimsS)')./nanmean(Spec.NoFz.Respi(:,OtherFreq)');
saveas(fig,[SaveFigFolder,'RespiSpectra.fig']), close all

fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValsFz),'color','k','linewidth',2)
plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols1(2,:);Cols1(1,:)]), hold on
[p,h,stats]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'NoFz','Fz'})
saveas(fig,[SaveFigFolder,'RespiSNR4Hz.fig']), close all
save([SaveFigFolder,'RespiSNR4HzStats.mat'],'p','h','stats'), close all, clear p h stats

fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fC,nanmean(Coh.Fz.Respi_OB),[stdError(Coh.Fz.Respi_OB);stdError(Coh.Fz.Respi_OB)]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fC,nanmean(Coh.NoFz.Respi_OB),[stdError(Coh.NoFz.Respi_OB);stdError(Coh.NoFz.Respi_OB)]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Coherence')
ylim([0.4 1])
set(gca,'Layer','top')
ValsFz=nanmean(Coh.Fz.Respi_OB(:,BandLimsC)');
ValsNoFz=nanmean(Coh.NoFz.Respi_OB(:,BandLimsC)');
saveas(fig,[SaveFigFolder,'RespiOBcoherence.fig']), close all

fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValsFz),'color','k','linewidth',2)
plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols1(2,:);Cols1(1,:)]), hold on
[p,h,stats]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'NoFz','Fz'})
saveas(fig,[SaveFigFolder,'RespiOBcoherenceQuantif.fig']), close all
save([SaveFigFolder,'RespiOBcoherenceQuantif.mat'],'p','h','stats'), close all, clear p h stats


fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fC,nanmean(Coh.Fz.Respi_PFCx),[stdError(Coh.Fz.Respi_PFCx);stdError(Coh.Fz.Respi_PFCx)]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fC,nanmean(Coh.NoFz.Respi_PFCx),[stdError(Coh.NoFz.Respi_PFCx);stdError(Coh.NoFz.Respi_PFCx)]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Coherence')
ylim([0.4 1])
set(gca,'Layer','top')
ValsFz=nanmean(Coh.Fz.Respi_PFCx(:,BandLimsC)');
ValsNoFz=nanmean(Coh.NoFz.Respi_PFCx(:,BandLimsC)');
saveas(fig,[SaveFigFolder,'RespiPFCxcoherence.fig']), close all

fig=figure;
line([0.7 1.3],[1 1]*nanmean(ValsNoFz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ValsFz),'color','k','linewidth',2)
plotSpread({ValsNoFz,ValsFz},'distributionColors',[Cols1(2,:);Cols1(1,:)]), hold on
[p,h,stats]=signrank(ValsNoFz,ValsFz);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'NoFz','Fz'})
saveas(fig,[SaveFigFolder,'RespiPFCxcoherenceQuantif.fig']), close all
save([SaveFigFolder,'RespiPFCxcoherenceQuantif.mat'],'p','h','stats'), close all, clear p h stats


for mm=1:length(Dir.path)
    cd(Dir.path{mm})
    load('BreathingInfo.mat')
    load('behavResources.mat')
    MeanFreq(mm,1)=nanmean(Data(Restrict(Frequecytsd,NoFreezeEpoch-BreathNoiseEpoch)));
    MeanFreq(mm,2)=nanmean(Data(Restrict(Frequecytsd,FreezeEpoch-BreathNoiseEpoch)));
    StdFreq(mm,1)=nanstd(Data(Restrict(Frequecytsd,NoFreezeEpoch-BreathNoiseEpoch)));
    StdFreq(mm,2)=nanstd(Data(Restrict(Frequecytsd,FreezeEpoch-BreathNoiseEpoch)));
    Top95=prctile(Data(TidalVolumtsd),95);
    TidalNoise=thresholdIntervals(TidalVolumtsd,Top95);
    TidalVolumtsd=tsd(Range(TidalVolumtsd),Data(TidalVolumtsd)/Convto1ML);
    MeanVol(mm,1)=nanmean(Data(Restrict(TidalVolumtsd,NoFreezeEpoch-BreathNoiseEpoch-TidalNoise)));
    MeanVol(mm,2)=nanmean(Data(Restrict(TidalVolumtsd,FreezeEpoch-BreathNoiseEpoch-TidalNoise)));
    StdVol(mm,1)=nanstd(Data(Restrict(TidalVolumtsd,NoFreezeEpoch-BreathNoiseEpoch-TidalNoise)));
    StdVol(mm,2)=nanstd(Data(Restrict(TidalVolumtsd,FreezeEpoch-BreathNoiseEpoch-TidalNoise)));
end

fig=figure;
line([0.7 1.3],[1 1]*nanmean(MeanFreq(:,1)),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(MeanFreq(:,2)),'color','k','linewidth',2)
handles=plotSpread({MeanFreq(:,1),MeanFreq(:,2)},'distributionColors',[Cols1(2,:);Cols1(1,:)]);
set(handles{1}(1),'MarkerSize',20)
set(handles{1}(2),'MarkerSize',20)
ylabel('nanmean frequency (Hz)')
[p,h,stats]=signrank(MeanFreq(:,1),MeanFreq(:,2));
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'NoFz','Fz'})
xlim([0 3])
saveas(fig,[SaveFigFolder,'MeanFreqbr.fig'])
save([SaveFigFolder,'MeanFreqbr.mat'],'p','h','stats'), close all, clear p h stats


fig=figure;
line([0.7 1.3],[1 1]*nanmean(StdFreq(:,1)),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(StdFreq(:,2)),'color','k','linewidth',2)
handles=plotSpread({StdFreq(:,1),StdFreq(:,2)},'distributionColors',[Cols1(2,:);Cols1(1,:)]);
set(handles{1}(1),'MarkerSize',20)
set(handles{1}(2),'MarkerSize',20)
[p,h,stats]=signrank(StdFreq(:,1),StdFreq(:,2));
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'NoFz','Fz'})
xlim([0 3])
ylabel('Std frequency (Hz)')
saveas(fig,[SaveFigFolder,'StdFreqbr.fig'])
save([SaveFigFolder,'StdFreqbr.mat'],'p','h','stats'), close all, clear p h stats

fig=figure;
line([0.7 1.3],[1 1]*nanmean(MeanVol(:,1)),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(MeanVol(:,2)),'color','k','linewidth',2)
handles=plotSpread({MeanVol(:,1),MeanVol(:,2)},'distributionColors',[Cols1(2,:);Cols1(1,:)]); hold on
set(handles{1}(1),'MarkerSize',20)
set(handles{1}(2),'MarkerSize',20)
[p,h,stats]=signrank(MeanVol(:,1),MeanVol(:,2));
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'NoFz','Fz'})
xlim([0 3])
ylabel('nanmean tidal Volume (AU)')
saveas(fig,[SaveFigFolder,'MeanTidalVol.fig'])
save([SaveFigFolder,'MeanTidalVol.mat'],'p','h','stats'), close all, clear p h stats


fig=figure;
line([0.7 1.3],[1 1]*nanmean(StdVol(:,1)),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(StdVol(:,2)),'color','k','linewidth',2)
handles=plotSpread({StdVol(:,1),StdVol(:,2)},'distributionColors',[Cols1(2,:);Cols1(1,:)]);
set(handles{1}(1),'MarkerSize',20)
set(handles{1}(2),'MarkerSize',20)
[p,h,stats]=signrank(StdVol(:,1),StdVol(:,2));
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'NoFz','Fz'})
xlim([0 3])
ylabel('Std tidal Volume (AU)')
set(gca,'FontSize',14,'YTick',[800:400:1600])
saveas(fig,[SaveFigFolder,'StdTidalVol.fig'])
save([SaveFigFolder,'StdTidalVol.mat'],'p','h','stats'), close all, clear p h stats

% Extra analysis is in Fig1BreathingCalibrationvolFreq.m