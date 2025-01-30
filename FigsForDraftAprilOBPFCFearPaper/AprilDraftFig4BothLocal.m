% This code generates pannels used in april draft
% It generates Fig4FGHI
% Need to toggle file name for Montreal vs Paris

clear all
% Get directories
CtrlEphys=[254,253,395];
Dir=PathForExperimentFEARMac('Fear-electrophy');
%Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');

% Where to save
SaveFigFolder='/Users/sophiebagur/Dropbox/OB4Hz-manuscrit/FigTest/';
Date=date;
SaveFigFolder=[SaveFigFolder,Date,filesep];

% Get parameters
Cols2=[0,146,146;189,109,255]/263;
MouseNum=1;
smootime=3;

for mm=1:length(Dir.path)
    mm
    cd(Dir.path{mm})
    load('behavResources.mat')
     load('StateEpochSB.mat')
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
        
        % Coherence OB
        load('CohgramcDataL/Cohgram_OB1_HPC1.mat')
        Ctsd=tsd(t*1e4,C);
        Coh.HPC1OB1.Fz(mm,:)=runmean(mean(Data(Restrict(Ctsd,FreezeEpoch))),smootime);
        load('CohgramcDataL/Cohgram_OB1_HPC2.mat')
        Ctsd=tsd(t*1e4,C);
        Coh.HPC2OB1.Fz(mm,:)=runmean(mean(Data(Restrict(Ctsd,FreezeEpoch))),smootime);
        load('CohgramcDataL/Cohgram_OB1_HPCLoc.mat')
        Ctsd=tsd(t*1e4,C);
        Coh.HPCLocOB1.Fz(mm,:)=runmean(mean(Data(Restrict(Ctsd,FreezeEpoch))),smootime);
       % Coherence OB
        load('CohgramcDataL/Cohgram_OB2_HPC1.mat')
        Ctsd=tsd(t*1e4,C);
        Coh.HPC1OB2.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
        load('CohgramcDataL/Cohgram_OB2_HPC2.mat')
        Ctsd=tsd(t*1e4,C);
        Coh.HPC2OB2.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
        load('CohgramcDataL/Cohgram_OB2_HPCLoc.mat')
        Ctsd=tsd(t*1e4,C);
        Coh.HPCLocOB2.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
               % Coherence OB
        load('CohgramcDataL/Cohgram_OBLoc_HPC1.mat')
        Ctsd=tsd(t*1e4,C);
        Coh.HPC1OBLoc.Fz(mm,:)=runmean(mean(Data(Restrict(Ctsd,FreezeEpoch))),smootime);
        load('CohgramcDataL/Cohgram_OBLoc_HPC2.mat')
        Ctsd=tsd(t*1e4,C);
        Coh.HPC2OBLoc.Fz(mm,:)=runmean(mean(Data(Restrict(Ctsd,FreezeEpoch))),smootime);
        load('CohgramcDataL/Cohgram_OBLoc_HPCLoc.mat')
        Ctsd=tsd(t*1e4,C);
        Coh.HPCLocOBLoc.Fz(mm,:)=runmean(mean(Data(Restrict(Ctsd,FreezeEpoch))),smootime);

        
end

fig=figure;
patch([3 3 6 6],[0,80,80,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
smootime=2;
hold on
plot([-1 0],[-1 0],'Color',[0 0.5 1],'linewidth',2)
plot([-1 0],[-1 0],'Color',Cols2(2,:),'linewidth',2)
plot([-1 0],[-1 0],'Color',Cols2(1,:),'linewidth',2)
plot([-1 0],[-1 0],'Color',[0.4 0.4 0.4],'linewidth',2)
temp=Coh.HPC1OB2.Fz;
temp=temp+Coh.HPC2OB2.Fz;
temp=temp+Coh.HPC1OB1.Fz;
temp=temp+Coh.HPC2OB1.Fz;
%temp=runmean(temp,smootime);
[hl,hp]=boundedline(f,nanmean(temp/4)',[stdError(temp/4);stdError(temp/4)]','alpha')
set(hp,'FaceColor' ,[0 0.5 1])
set(hl,'Color',[0 0.5 1],'linewidth',2)
temp=Coh.HPC1OBLoc.Fz;
temp=temp+Coh.HPC2OBLoc.Fz;
%temp=runmean(temp,smootime);
[hl,hp]=boundedline(f,nanmean(temp/2)',[stdError(temp/2);stdError(temp/2)]','alpha')
set(hp,'FaceColor',Cols2(2,:))
set(hl,'Color',Cols2(2,:),'linewidth',2)
temp=Coh.HPCLocOB1.Fz;
temp=temp+Coh.HPCLocOB2.Fz;
%temp=runmean(temp,smootime);
[hl,hp]=boundedline(f,nanmean(temp/2)',[stdError(temp/2);stdError(temp/2)]','alpha')
set(hp,'FaceColor',Cols2(1,:))
set(hl,'Color',Cols2(1,:),'linewidth',2)
temp=Coh.HPCLocOBLoc.Fz;
%temp=runmean(temp,smootime);
[hl,hp]=boundedline(f,nanmean(temp)',[stdError(temp);stdError(temp)]','k','alpha')
set(hl,'Color',[0.4 0.4 0.4],'linewidth',2)
xlim([0 20]), ylim([0.35 0.6])
ylabel('coherence'),xlabel('Frequency (Hz)')
legend({'OB & HPC non local','OB local,HPC non-local','HPC local,OB non-local','OB & HPC local'})
set(gca,'Layer','top')
ylim([0.35 0.65])
set(gca,'FontSize',15,'YTick',[0.3:0.1:1],'XTick',[0:5:20])
saveas(fig,[SaveFigFolder 'CoherenceMiceBothLocal.fig']), close all