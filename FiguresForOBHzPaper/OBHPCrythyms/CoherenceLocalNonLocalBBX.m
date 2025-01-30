% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
CtrlEphysInvHPC=[249,250,297];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphysInvHPC);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-envC');
FieldNames={'HPC1','HPC2','HPCLoc','PFCx'};
FreqRange=[1:12;[3:14]];

for mm=1:length(Dir.path)
    mm
    cd(Dir.path{mm})
    load('behavResources.mat')
    if exist('LFPData/LocalHPCActivity.mat')>0
        % Spectra
        load('HPC1_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        Sp.HPC1.Fz(mm,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)))/sum(mean(Data(Restrict(Sptsd,FreezeEpoch))));
        load('HPC2_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        Sp.HPC2.Fz(mm,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)))/sum(mean(Data(Restrict(Sptsd,FreezeEpoch))));
        load('HPCLoc_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        Sp.HPCLoc.Fz(mm,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)))/sum(mean(Data(Restrict(Sptsd,FreezeEpoch))));
        % Coherence PFCx
        load('CohgramcDataL/Cohgram_PFC_HPC1.mat')
        Ctsd=tsd(t*1e4,C);
        Coh.HPC1.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
        load('CohgramcDataL/Cohgram_PFC_HPC2.mat')
        Ctsd=tsd(t*1e4,C);
        Coh.HPC2.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
        load('CohgramcDataL/Cohgram_PFC_HPCLoc.mat')
        Ctsd=tsd(t*1e4,C);
        Coh.HPCLoc.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
        
        % LFPCorr
        load('LFPCorr/HPC_PFCx_Loc_NonLoc_Corr.mat')
        Corr.HPC1(mm,:)=CorrVals.HPC1;
        Corr.HPC2(mm,:)=CorrVals.HPC2;
        Corr.HPCLoc(mm,:)=CorrVals.HPCLoc;
    else
        Sp.HPCLoc.Fz(mm,:)=nan(1,263);
        Sp.HPC2.Fz(mm,:)=nan(1,263);
        Sp.HPC1.Fz(mm,:)=nan(1,263);
        Coh.HPC1.Fz(mm,:)=nan(1,261);
        Coh.HPC2.Fz(mm,:)=nan(1,261);
        Coh.HPCLoc.Fz(mm,:)=nan(1,261);
        Coh.HPC1OB.Fz(mm,:)=nan(1,261);
        Coh.HPC2OB.Fz(mm,:)=nan(1,261);
        Coh.HPCLocOB.Fz(mm,:)=nan(1,261);
        Corr.HPC1(mm,:)=nan(1,2499);
        Corr.HPCLoc(mm,:)=nan(1,2499);
        Corr.HPC2(mm,:)=nan(1,2499);
        
    end
    
    
end

SaveFolder='/home/vador/Dropbox/MOBS_workingON/OB4Hz-manuscrit/FigHippocampus/CoherenceLocalNonLocal/';

fig=figure;
[hl,hp]=boundedline(Spectro{3},nanmean(Sp.HPC1.Fz)',[stdError(Sp.HPC1.Fz);stdError(Sp.HPC1.Fz)]','b','alpha')
hold on
[hl,hp]=boundedline(Spectro{3},nanmean(Sp.HPC2.Fz)',[stdError(Sp.HPC2.Fz);stdError(Sp.HPC2.Fz)]','alpha');
set(hp,'FaceColor',[0.3 0.3 1])
[hl,hp]=boundedline(Spectro{3},nanmean(Sp.HPCLoc.Fz)',[stdError(Sp.HPCLoc.Fz);stdError(Sp.HPCLoc.Fz)]','k','alpha')
saveas(fig,[SaveFolder,'SpectraHPCLNBBX.fig']); close all;

fig=figure;
[hl,hp]=boundedline(f,nanmean(Coh.HPC1.Fz)',[stdError(Coh.HPC1.Fz);stdError(Coh.HPC1.Fz)]','b','alpha')
hold on
[hl,hp]=boundedline(f,nanmean(Coh.HPC2.Fz)',[stdError(Coh.HPC2.Fz);stdError(Coh.HPC2.Fz)]','alpha')
set(hp,'FaceColor',[0.3 0.3 1])
[hl,hp]=boundedline(f,nanmean(Coh.HPCLoc.Fz)',[stdError(Coh.HPCLoc.Fz);stdError(Coh.HPCLoc.Fz)]','k','alpha')
bandlim=[find(f>3,1,'first'):find(f>5,1,'first')];
HPCNL=min([mean(Coh.HPC1.Fz(:,bandlim)');mean(Coh.HPC2.Fz(:,bandlim)')]);HPCNL(isnan(HPCNL))=[];
HPCL=[mean(Coh.HPCLoc.Fz(:,bandlim)')];HPCL(isnan(HPCL))=[];
saveas(fig,[SaveFolder,'CohHPCPFCLNBBX.fig']); close all;


