% This code generates pannels used in april draft
% It generates Fig4jK, S2BC
% Need to toggle file name for Montreal vs Paris

clear all
% Get directories
CtrlEphys=[253,258,299,395,403,451,248,244,243,254,402];%,230,249,250,291,297,298];
Dir=PathForExperimentFEARMac('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');


% Where to save
SaveFigFolder='/Users/sophiebagur/Dropbox/OB4Hz-manuscrit/FigTest/';
Date=date;
SaveFigFolder=[SaveFigFolder,Date,filesep];



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
        
        % Coherence PFC
        if exist('CohgramcDataL/Cohgram_PFCx_HPC1.mat')>0
            movefile('CohgramcDataL/Cohgram_PFCx_HPC1.mat','CohgramcDataL/Cohgram_PFC_HPC1.mat')
        end
        if exist('CohgramcDataL/Cohgram_PFCx_HPC2.mat')>0
            movefile('CohgramcDataL/Cohgram_PFCx_HPC2.mat','CohgramcDataL/Cohgram_PFC_HPC2.mat')
        end
        if exist('CohgramcDataL/Cohgram_PFCx_HPCLoc.mat')>0
            movefile('CohgramcDataL/Cohgram_PFCx_HPCLoc.mat','CohgramcDataL/Cohgram_PFC_HPCLoc.mat')
        end
        if exist('CohgramcDataL/Cohgram_HPC1_PFCx.mat')>0
            movefile('CohgramcDataL/Cohgram_HPC1_PFCx.mat','CohgramcDataL/Cohgram_HPC1_PFC.mat')
        end
        if exist('CohgramcDataL/Cohgram_HPC2_PFCx.mat')>0
            movefile('CohgramcDataL/Cohgram_HPC2_PFCx.mat','CohgramcDataL/Cohgram_HPC2_PFC.mat')
        end
        if exist('CohgramcDataL/Cohgram_HPCLoc_PFCx.mat')>0
            movefile('CohgramcDataL/Cohgram_HPCLoc_PFCx.mat','CohgramcDataL/Cohgram_HPCLoc_PFC.mat')
        end
        
        
        % Coherence PFCx
        try,load('CohgramcDataL/Cohgram_PFC_HPC1.mat'), catch, load('CohgramcDataL/Cohgram_HPC1_PFC.mat'), end
        Ctsd=tsd(t*1e4,C);
        Coh.HPC1.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
        try,load('CohgramcDataL/Cohgram_PFC_HPC2.mat'), catch, load('CohgramcDataL/Cohgram_HPC2_PFC.mat'), end
        Ctsd=tsd(t*1e4,C);
        Coh.HPC2.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
        try,load('CohgramcDataL/Cohgram_PFC_HPCLoc.mat'), catch, load('CohgramcDataL/Cohgram_HPCLoc_PFC.mat'), end
        Ctsd=tsd(t*1e4,C);
        Coh.HPCLoc.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
        
        % Coherence OB
        load('CohgramcDataL/Cohgram_OB1_HPC1.mat')
        Ctsd=tsd(t*1e4,C);
        Coh.HPC1OB.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
        load('CohgramcDataL/Cohgram_OB1_HPC2.mat')
        Ctsd=tsd(t*1e4,C);
        Coh.HPC2OB.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
        load('CohgramcDataL/Cohgram_OB1_HPCLoc.mat')
        Ctsd=tsd(t*1e4,C);
        Coh.HPCLocOB.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
        
        try,% LFPCorr
            load('LFPCorr/HPC_PFCx_Loc_NonLoc_Corr.mat')
            Corr.HPC1(mm,:)=CorrVals.HPC1;
            Corr.HPC2(mm,:)=CorrVals.HPC2;
            Corr.HPCLoc(mm,:)=CorrVals.HPCLoc;
        catch
            Corr.HPC1(mm,:)=nan(1,2499);
            Corr.HPCLoc(mm,:)=nan(1,2499);
            Corr.HPC2(mm,:)=nan(1,2499);
            
        end
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
    
    % Get OB LFP
    if exist('LFPData/LocalOBActivity.mat')>0
        % Spectra
        load('OB1_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        Sp.OB1.Fz(mm,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)))/sum(mean(Data(Restrict(Sptsd,FreezeEpoch))));
        load('OB2_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        Sp.OB2.Fz(mm,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)))/sum(mean(Data(Restrict(Sptsd,FreezeEpoch))));
        load('OBLoc_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        Sp.OBLoc.Fz(mm,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)))/sum(mean(Data(Restrict(Sptsd,FreezeEpoch))));
        
        % Coherence PFC
        if exist('CohgramcDataL/Cohgram_PFCx_OB1.mat')>0
            movefile('CohgramcDataL/Cohgram_PFCx_OB1.mat','CohgramcDataL/Cohgram_PFC_OB1.mat')
        end
        if exist('CohgramcDataL/Cohgram_PFCx_OB2.mat')>0
            movefile('CohgramcDataL/Cohgram_PFCx_OB2.mat','CohgramcDataL/Cohgram_PFC_OB2.mat')
        end
        if exist('CohgramcDataL/Cohgram_PFCx_OBLoc.mat')>0
            movefile('CohgramcDataL/Cohgram_PFCx_OBLoc.mat','CohgramcDataL/Cohgram_PFC_OBLoc.mat')
        end
        if exist('CohgramcDataL/Cohgram_OB1_PFCx.mat')>0
            movefile('CohgramcDataL/Cohgram_OB1_PFCx.mat','CohgramcDataL/Cohgram_OB1_PFC.mat')
        end
        if exist('CohgramcDataL/Cohgram_OB2_PFCx.mat')>0
            movefile('CohgramcDataL/Cohgram_OB2_PFCx.mat','CohgramcDataL/Cohgram_OB2_PFC.mat')
        end
        if exist('CohgramcDataL/Cohgram_OBLoc_PFCx.mat')>0
            movefile('CohgramcDataL/Cohgram_OBLoc_PFCx.mat','CohgramcDataL/Cohgram_OBLoc_PFC.mat')
        end
        
        try,load('CohgramcDataL/Cohgram_PFC_OB1.mat'), catch, load('CohgramcDataL/Cohgram_OB1_PFC.mat'), end
        Ctsd=tsd(t*1e4,C);
        Coh.OB1.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
        try,load('CohgramcDataL/Cohgram_PFC_OB2.mat'), catch, load('CohgramcDataL/Cohgram_OB2_PFC.mat'), end
        Ctsd=tsd(t*1e4,C);
        Coh.OB2.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
        try,load('CohgramcDataL/Cohgram_PFC_OBLoc.mat'), catch, load('CohgramcDataL/Cohgram_OBLoc_PFC.mat'), end
        Ctsd=tsd(t*1e4,C);
        Coh.OBLoc.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
        
        % Coherence HPC
        try,load('CohgramcDataL/Cohgram_HPC1_OB1.mat'), catch, load('CohgramcDataL/Cohgram_OB1_HPC1.mat'), end
        Ctsd=tsd(t*1e4,C);
        Coh.OB1HPC.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
        try,load('CohgramcDataL/Cohgram_HPC1_OB2.mat'), catch, load('CohgramcDataL/Cohgram_OB2_HPC1.mat'), end
        Ctsd=tsd(t*1e4,C);
        Coh.OB2HPC.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
        try,load('CohgramcDataL/Cohgram_HPC1_OBLoc.mat'), catch, load('CohgramcDataL/Cohgram_OBLoc_HPC1.mat'), end
        Ctsd=tsd(t*1e4,C);
        Coh.OBLocHPC.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
        
        try,
            % LFPCorr
            load('LFPCorr/OB_PFCx_Loc_NonLoc_Corr.mat')
            Corr.OB1(mm,:)=CorrVals.OB1;
            Corr.OB2(mm,:)=CorrVals.OB2;
            Corr.OBLoc(mm,:)=CorrVals.OBLoc;
        catch
            Corr.OB1(mm,:)=nan(1,2499);
            Corr.OB2(mm,:)=nan(1,2499);
            Corr.OBLoc(mm,:)=nan(1,2499);
        end
    else
        Sp.OBLoc.Fz(mm,:)=nan(1,263);
        Sp.OB2.Fz(mm,:)=nan(1,263);
        Sp.OB1.Fz(mm,:)=nan(1,263);
        Coh.OB1.Fz(mm,:)=nan(1,261);
        Coh.OB2.Fz(mm,:)=nan(1,261);
        Coh.OBLoc.Fz(mm,:)=nan(1,261);
        Coh.OB1HPC.Fz(mm,:)=nan(1,261);
        Coh.OB2HPC.Fz(mm,:)=nan(1,261);
        Coh.OBLocHPC.Fz(mm,:)=nan(1,261);
        Corr.OB1(mm,:)=nan(1,2499);
        Corr.OB2(mm,:)=nan(1,2499);
        Corr.OBLoc(mm,:)=nan(1,2499);
        
    end
    
end

fig=figure;
[hl,hp]=boundedline(Spectro{3},nanmean(Sp.HPC1.Fz)',[stdError(Sp.HPC1.Fz);stdError(Sp.HPC1.Fz)]','b','alpha')
hold on
[hl,hp]=boundedline(Spectro{3},nanmean(Sp.HPC2.Fz)',[stdError(Sp.HPC2.Fz);stdError(Sp.HPC2.Fz)]','alpha');
set(hp,'FaceColor',[0.3 0.3 1])
[hl,hp]=boundedline(Spectro{3},nanmean(Sp.HPCLoc.Fz)',[stdError(Sp.HPCLoc.Fz);stdError(Sp.HPCLoc.Fz)]','k','alpha')
saveas(fig,[SaveFigFolder,'SpectraHPCLN.fig']); close all;

fig=figure;
[hl,hp]=boundedline(f,nanmean(Coh.HPC1.Fz)',[stdError(Coh.HPC1.Fz);stdError(Coh.HPC1.Fz)]','b','alpha')
hold on
[hl,hp]=boundedline(f,nanmean(Coh.HPC2.Fz)',[stdError(Coh.HPC2.Fz);stdError(Coh.HPC2.Fz)]','alpha')
set(hp,'FaceColor',[0.3 0.3 1])
[hl,~]=boundedline(f,nanmean(Coh.HPCLoc.Fz)',[stdError(Coh.HPCLoc.Fz);stdError(Coh.HPCLoc.Fz)]','k','alpha')
bandlim=[find(f>3,1,'first'):find(f>5,1,'first')];
HPCNL=min([mean(Coh.HPC1.Fz(:,bandlim)');mean(Coh.HPC2.Fz(:,bandlim)')]);HPCNL(isnan(HPCNL))=[];
HPCL=[mean(Coh.HPCLoc.Fz(:,bandlim)')];HPCL(isnan(HPCL))=[];
saveas(fig,[SaveFigFolder,'CohHPCPFCLN.fig']); close all;


fig=figure;
[hl,hp]=boundedline(f,nanmean(Coh.HPC1OB.Fz)',[stdError(Coh.HPC1OB.Fz);stdError(Coh.HPC1OB.Fz)]','b','alpha')
hold on
[hl,hp]=boundedline(f,nanmean(Coh.HPC2OB.Fz)',[stdError(Coh.HPC2OB.Fz);stdError(Coh.HPC2OB.Fz)]','alpha')
set(hp,'FaceColor',[0.3 0.3 1])
[hl,hp]=boundedline(f,nanmean(Coh.HPCLocOB.Fz)',[stdError(Coh.HPCLocOB.Fz);stdError(Coh.HPCLocOB.Fz)]','k','alpha')
bandlim=[find(f>3,1,'first'):find(f>5,1,'first')];
HPCNL=min([mean(Coh.HPC1OB.Fz(:,bandlim)');mean(Coh.HPC2OB.Fz(:,bandlim)')]);HPCNL(isnan(HPCNL))=[];
HPCL=[mean(Coh.HPCLocOB.Fz(:,bandlim)')];HPCL(isnan(HPCL))=[];
saveas(fig,[SaveFigFolder,'CohHPCOBLN.fig']); close all;


fig=figure;
[hl,hp]=boundedline(Spectro{3},nanmean(Sp.OB1.Fz)',[stdError(Sp.OB1.Fz);stdError(Sp.OB1.Fz)]','b','alpha')
hold on
[hl,hp]=boundedline(Spectro{3},nanmean(Sp.OB2.Fz)',[stdError(Sp.OB2.Fz);stdError(Sp.OB2.Fz)]','b','alpha')
set(hp,'FaceColor',[0.3 0.3 1])
[hl,hp]=boundedline(Spectro{3},nanmean(Sp.OBLoc.Fz)',[stdError(Sp.OBLoc.Fz);stdError(Sp.OBLoc.Fz)]','k','alpha')
saveas(fig,[SaveFigFolder,'SpectraOBLN.fig']); close all;

fig=figure;
[hl,hp]=boundedline(f,nanmean(Coh.OB1.Fz)',[stdError(Coh.OB1.Fz);stdError(Coh.OB1.Fz)]','alpha')
hold on
[hl,hp]=boundedline(f,nanmean(Coh.OB2.Fz)',[stdError(Coh.OB2.Fz);stdError(Coh.OB2.Fz)]','b','alpha')
set(hp,'FaceColor',[0.3 0.3 1])
[hl,hp]=boundedline(f,nanmean(Coh.OBLoc.Fz)',[stdError(Coh.OBLoc.Fz);stdError(Coh.OBLoc.Fz)]','k','alpha')
bandlim=[find(f>6,1,'first'):find(f>9,1,'first')];
OBNL=min([mean(Coh.OB1.Fz(:,bandlim)');mean(Coh.OB2.Fz(:,bandlim)')]);OBNL(isnan(OBNL))=[];
OBL=[mean(Coh.OBLoc.Fz(:,bandlim)')];OBL(isnan(OBL))=[];
saveas(fig,[SaveFigFolder,'CohOBPFCLN.fig']); close all;


fig=figure;
[hl,hp]=boundedline(f,nanmean(Coh.OB1HPC.Fz)',[stdError(Coh.OB1HPC.Fz);stdError(Coh.OB1HPC.Fz)]','alpha')
hold on
[hl,hp]=boundedline(f,nanmean(Coh.OB2HPC.Fz)',[stdError(Coh.OB2HPC.Fz);stdError(Coh.OB2HPC.Fz)]','b','alpha')
set(hp,'FaceColor',[0.3 0.3 1])
[hl,hp]=boundedline(f,nanmean(Coh.OBLocHPC.Fz)',[stdError(Coh.OBLocHPC.Fz);stdError(Coh.OBLocHPC.Fz)]','k','alpha')
bandlim=[find(f>6,1,'first'):find(f>9,1,'first')];
OBNL=min([mean(Coh.OB1HPC.Fz(:,bandlim)');mean(Coh.OB2HPC.Fz(:,bandlim)')]);OBNL(isnan(OBNL))=[];
OBL=[mean(Coh.OBLocHPC.Fz(:,bandlim)')];OBL(isnan(OBL))=[];
saveas(fig,[SaveFigFolder,'CohOBHPCLN.fig']); close all;


