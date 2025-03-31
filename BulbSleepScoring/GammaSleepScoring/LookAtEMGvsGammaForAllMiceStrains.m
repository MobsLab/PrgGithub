%% Used for draft 11th april
% clear all, close all
mindur=3; %abs cut off for events;
ThetaI=[3 3]; %merge and drop
mw_dur=5; %max length of microarousal
sl_dur=15; %min duration of sleep around microarousal
ms_dur=10; % max length of microsleep
wa_dur=20; %min duration of wake around microsleep

%% Sessions
% EMG
m=1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M147';
% filename{m,2}=7;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M148/20140828/';
filename{m,2}=7;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M177';
filename{m,2}=9;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M178';
filename{m,2}=18;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-23022014/M177';
% filename{m,2}=9;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-23022014/M178';
% filename{m,2}=18;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M258/20151112/';
% filename{m,2}=18;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M259/20151112/';


figure
clf
for mm=1:m
    mm
    cd(filename{mm})
    load('StateEpochEMGSB.mat','REMEpoch','SWSEpoch','Wake','sleepper','EMGData','EMG_thresh')
    REMEpoch1= REMEpoch;
    SWSEpoch1=SWSEpoch;
    Wake1= Wake;
    sleepper1= sleepper;
    load('StateEpochSB.mat','REMEpoch','SWSEpoch','Wake','Epoch','smooth_ghi','gamma_thresh')
    DatEMG = Data(EMGData);
    DatOB = Data(Restrict(smooth_ghi,ts(Range(EMGData))));
    subplot(3,2,mm)
    plot(log(DatOB(1:3000:end)),log(DatEMG(1:3000:end)),'.','color','k')
    hold on
    line([1 1]*log(gamma_thresh),ylim,'color','r','linewidth',2)
    line(xlim,[1 1]*log(EMG_thresh),'color','r','linewidth',2)
    Perc_Sq.C57(mm,1) = sum(DatEMG>EMG_thresh & DatOB>gamma_thresh);
    Perc_Sq.C57(mm,2) = sum(DatEMG<EMG_thresh & DatOB>gamma_thresh);
    Perc_Sq.C57(mm,3) = sum(DatEMG>EMG_thresh & DatOB<gamma_thresh);
    Perc_Sq.C57(mm,4) = sum(DatEMG<EMG_thresh & DatOB<gamma_thresh);
    
end

clear filename
m=1;
filename{m,1}='/media/DataMOBsRAIDN/ProjetSlSc/C3H&DBA/M719/29032018';
filename{m,2}=7;
m=m+1;
filename{m,1}='/media/DataMOBsRAIDN/ProjetSlSc/C3H&DBA/M720/29032018';
% filename{m,2}=7;


figure
clf
for mm=1:m
    mm
    cd(filename{mm})
    load('StateEpochEMGSB.mat','REMEpoch','SWSEpoch','Wake','sleepper','EMGData','EMG_thresh')
    REMEpoch1= REMEpoch;
    SWSEpoch1=SWSEpoch;
    Wake1= Wake;
    sleepper1= sleepper;
    load('StateEpochSB.mat','REMEpoch','SWSEpoch','Wake','Epoch','smooth_ghi','gamma_thresh')
    DatEMG = Data(EMGData);
    DatOB = Data(Restrict(smooth_ghi,ts(Range(EMGData))));
    subplot(2,1,mm)
    plot(log(DatEMG(1:2000:end)),log(DatOB(1:2000:end)),'.','color',[0.6 0.6 0.6])
    hold on
    line([1 1]*log(EMG_thresh),ylim,'color','r','linewidth',2)
    line(xlim,[1 1]*log(gamma_thresh),'color','r','linewidth',2)
    Perc_Sq.C3H(mm,1) = sum(DatEMG>EMG_thresh & DatOB>gamma_thresh);
    Perc_Sq.C3H(mm,2) = sum(DatEMG<EMG_thresh & DatOB>gamma_thresh);
    Perc_Sq.C3H(mm,3) = sum(DatEMG>EMG_thresh & DatOB<gamma_thresh);
    Perc_Sq.C3H(mm,4) = sum(DatEMG<EMG_thresh & DatOB<gamma_thresh);
    
end


% EMG
clear filename
m=1;
filename{m,1}='/media/DataMOBsRAIDN/ProjetSlSc/C3H&DBA/M721/29032018';
m=m+1;
filename{m,1}='/media/DataMOBsRAIDN/ProjetSlSc/C3H&DBA/M730';
m=m+1;
filename{m,1}='/media/DataMOBsRAIDN/ProjetSlSc/C3H&DBA/M729';
figure
clf
for mm=1:m
    mm
    cd(filename{mm})
    load('StateEpochEMGSB.mat','REMEpoch','SWSEpoch','Wake','sleepper','EMGData','EMG_thresh')
    REMEpoch1= REMEpoch;
    SWSEpoch1=SWSEpoch;
    Wake1= Wake;
    sleepper1= sleepper;
    load('StateEpochSB.mat','REMEpoch','SWSEpoch','Wake','Epoch','smooth_ghi','gamma_thresh')
    DatEMG = Data(EMGData);
    DatOB = Data(Restrict(smooth_ghi,ts(Range(EMGData))));
    subplot(3,1,mm)
    plot(log(DatEMG(1:2000:end)),log(DatOB(1:2000:end)),'.','color',[0.6 0.6 0.6])
    hold on
    line([1 1]*log(EMG_thresh),ylim,'color','r','linewidth',2)
    line(xlim,[1 1]*log(gamma_thresh),'color','r','linewidth',2)
    Perc_Sq.DBA(mm,1) = sum(DatEMG>EMG_thresh & DatOB>gamma_thresh);
    Perc_Sq.DBA(mm,2) = sum(DatEMG<EMG_thresh & DatOB>gamma_thresh);
    Perc_Sq.DBA(mm,3) = sum(DatEMG>EMG_thresh & DatOB<gamma_thresh);
    Perc_Sq.DBA(mm,4) = sum(DatEMG<EMG_thresh & DatOB<gamma_thresh);
    
end

clear filename

% List of mice to use for sleep scoring analysis (not all have EMG)
m=1;
filename{m}='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse571/20171019-BasalSleep-8-20h/';
m=2;
filename{m}='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse570/20171019-BasalSleep-8-20h/';
m=3;
filename{m}='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse554/20170719_BasalSleep/OREXIN-Mouse-554-19072017';

figure
clf
for mm=1:m
    mm
    cd(filename{mm})
    load('StateEpochEMGSB.mat','REMEpoch','SWSEpoch','Wake','sleepper','EMGData','EMG_thresh')
    REMEpoch1= REMEpoch;
    SWSEpoch1=SWSEpoch;
    Wake1= Wake;
    sleepper1= sleepper;
    load('StateEpochSB.mat','REMEpoch','SWSEpoch','Wake','Epoch','smooth_ghi','gamma_thresh')
    DatEMG = Data(EMGData);
    DatOB = Data(Restrict(smooth_ghi,ts(Range(EMGData))));
    subplot(3,1,mm)
    plot(log(DatEMG(1:2000:end)),log(DatOB(1:2000:end)),'.','color',[0.6 0.6 0.6])
    hold on
    line([1 1]*log(EMG_thresh),ylim,'color','r','linewidth',2)
    line(xlim,[1 1]*log(gamma_thresh),'color','r','linewidth',2)
    Perc_Sq.ORX(mm,1) = sum(DatEMG>EMG_thresh & DatOB>gamma_thresh);
    Perc_Sq.ORX(mm,2) = sum(DatEMG<EMG_thresh & DatOB>gamma_thresh);
    Perc_Sq.ORX(mm,3) = sum(DatEMG>EMG_thresh & DatOB<gamma_thresh);
    Perc_Sq.ORX(mm,4) = sum(DatEMG<EMG_thresh & DatOB<gamma_thresh);
    
end

figure
Strainname = {'C57','C3H','DBA','ORX'};
for Strain = 1:4
    subplot(2,2,Strain)
    new = Perc_Sq.(Strainname{Strain}) ;
    for  k = 1:size(new,1)
        new(k,:) = new(k,:) ./ sum(new(k,:) );
    end
    PlotErrorBarN_KJ(new,'newfig',0,'ShowSigstar','none')
    title(Strainname{Strain})
    ylim([0 0.7])
end

figure
Strainname = {'C57','C3H','DBA','ORX'};
for Strain = 1:4
    subplot(2,2,Strain)
    new = Perc_Sq.(Strainname{Strain}) ;
    for  k = 1:size(new,1)
        new(k,:) = new(k,:) ./ sum(new(k,:) );
    end
    New = [sum(new(:,[1,4])');sum(new(:,[2:3])')]';
    PlotErrorBarN_KJ(New,'newfig',0,'ShowSigstar','none')
    title(Strainname{Strain})
    ylim([0 0.7])
end
