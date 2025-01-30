% Look at HPC phase after subtraction of Local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
% Get directories
CtrlEphys=[254,253,395];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
% Frequency bands to scan through
FreqRange=[1:12;[3:14]];
% Name of possible different structures
FieldNames={'OB1','OB2','OBLoc','HPC1','HPC2','HPCLoc'};
TimeLag=1;
% Parameters for triggered spectro
MouseNum=1;
TotNeurons=0;
[params,movingwin,suffix]=SpectrumParametersML('low');

for mm=1:length(Dir.path)
    mm
    cd(Dir.path{mm})
    load('behavResources.mat')
     load('StateEpochSB.mat')
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
        
        % Coherence OB
        load('CohgramcDataL/Cohgram_OB1_HPC1.mat')
        Ctsd=tsd(t*1e4,C);
        Coh.HPC1OB1.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
        load('CohgramcDataL/Cohgram_OB1_HPC2.mat')
        Ctsd=tsd(t*1e4,C);
        Coh.HPC2OB1.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
        load('CohgramcDataL/Cohgram_OB1_HPCLoc.mat')
        Ctsd=tsd(t*1e4,C);
        Coh.HPCLocOB1.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
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
        Coh.HPC1OBLoc.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
        load('CohgramcDataL/Cohgram_OBLoc_HPC2.mat')
        Ctsd=tsd(t*1e4,C);
        Coh.HPC2OBLoc.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));
        load('CohgramcDataL/Cohgram_OBLoc_HPCLoc.mat')
        Ctsd=tsd(t*1e4,C);
        Coh.HPCLocOBLoc.Fz(mm,:)=mean(Data(Restrict(Ctsd,FreezeEpoch)));

        
end

SaveFolder='/home/vador/Dropbox/MOBS_workingON/OB4Hz-manuscrit/FigHippocampus/CoherenceLocalNonLocal/';
fig=figure;
hold on
plot([-1 0],[-1 0],'Color',[0.6 0.6 1]*0.7,'linewidth',3)
plot([-1 0],[-1 0],'Color',[0.6 1 0.6]*0.7,'linewidth',3)
plot([-1 0],[-1 0],'Color',[1 0.6 0.6]*0.7,'linewidth',3)
plot([-1 0],[-1 0],'Color',[0.6 0.6 0.6]*0.7,'linewidth',3)
temp=Coh.HPC1OB2.Fz;
temp=temp+Coh.HPC2OB2.Fz;
temp=temp+Coh.HPC1OB1.Fz;
temp=temp+Coh.HPC2OB1.Fz;
[hl,hp]=boundedline(f,nanmean(temp/4)',[stdError(temp/4);stdError(temp/4)]','alpha')
set(hp,'FaceColor',[0.6 0.6 1])
set(hl,'Color',[0.6 0.6 1]*0.7,'linewidth',3)
temp=Coh.HPC1OBLoc.Fz;
temp=temp+Coh.HPC2OBLoc.Fz;
[hl,hp]=boundedline(f,nanmean(temp/2)',[stdError(temp/2);stdError(temp/2)]','alpha')
set(hp,'FaceColor',[0.6 1 0.6])
set(hl,'Color',[0.6 1 0.6]*0.7,'linewidth',3)
temp=Coh.HPCLocOB1.Fz;
temp=temp+Coh.HPCLocOB2.Fz;
[hl,hp]=boundedline(f,nanmean(temp/2)',[stdError(temp/2);stdError(temp/2)]','alpha')
set(hp,'FaceColor',[1 0.6 0.6])
set(hl,'Color',[1 0.6 0.6]*0.7,'linewidth',3)
[hl,hp]=boundedline(f,nanmean(Coh.HPCLocOBLoc.Fz)',[stdError(Coh.HPCLocOBLoc.Fz);stdError(Coh.HPCLocOBLoc.Fz)]','b','alpha')
set(hp,'FaceColor',[0.6 0.6 0.6])
set(hl,'Color',[0.6 0.6 0.6]*0.7,'linewidth',3)
xlim([0 20]), ylim([0.35 0.6])
ylabel('coherence'),xlabel('Frequency (Hz)')
legend({'OB & HPC non local','OB local,HPC non-local','HPC local,OB non-local','OB & HPC local'})