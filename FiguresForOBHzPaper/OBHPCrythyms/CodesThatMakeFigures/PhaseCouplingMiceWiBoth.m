% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
CtrlEphys=[254,253,395];
IsObx=[0,0,0];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
% Parameters for triggered spectro
FreqRange=[1:12;[3:14]];
for mm=1:length(Dir.path)
    mm
    cd(Dir.path{mm})
    
    load('behavResources.mat')
    load('StateEpochSB.mat','TotalNoiseEpoch')
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
    
    % HPC local / non local - OB
    load('LFPPhaseCoupling/FzPhaseCouplingOB1_HPC1.mat')
    FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    load('LFPPhaseCoupling/FzPhaseCouplingOB1_HPC2.mat')
    FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    load('LFPPhaseCoupling/FzPhaseCouplingOB2_HPC1.mat')
    FinalSig3=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    load('LFPPhaseCoupling/FzPhaseCouplingOB2_HPC2.mat')
    FinalSig4=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength+FinalSig3.VectLength+FinalSig4.VectLength)/4;
    FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon+FinalSig3.Shannon+FinalSig4.Shannon)/4;
    AllHPCnonlocOBnonloc.Shannon(mm,:)=(FinalSig.Shannon);
    AllHPCnonlocOBnonloc.VectLength(mm,:)=(FinalSig.VectLength);
    
    load('LFPPhaseCoupling/FzPhaseCouplingOB1_HPCLoc.mat')
    FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    load('LFPPhaseCoupling/FzPhaseCouplingOB2_HPCLoc.mat')
    FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
    FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
    AllHPClocOBnonloc.Shannon(mm,:)=(FinalSig.Shannon);
    AllHPClocOBnonloc.VectLength(mm,:)=(FinalSig.VectLength);
    
    load('LFPPhaseCoupling/FzPhaseCouplingOBLoc_HPCLoc.mat')
    FinalSig=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    AllHPClocOBloc.Shannon(mm,:)=(FinalSig.Shannon);
    AllHPClocOBloc.VectLength(mm,:)=(FinalSig.VectLength);
    
    
    load('LFPPhaseCoupling/FzPhaseCouplingOBLoc_HPC1.mat')
    FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    load('LFPPhaseCoupling/FzPhaseCouplingOBLoc_HPC2.mat')
    FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
    FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
    FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
    AllHPCnonlocOBloc.Shannon(mm,:)=(FinalSig.Shannon);
    AllHPCnonlocOBloc.VectLength(mm,:)=(FinalSig.VectLength);
    
    % minimaxi method
    
    load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB1_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
    FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
    load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB1_HPC2.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
    FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
    load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB2_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
    FinalSig3=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
    load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB2_HPC2.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
    FinalSig4=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
    FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength+FinalSig3.VectLength+FinalSig4.VectLength)/4;
    FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon+FinalSig3.Shannon+FinalSig4.Shannon)/4;
    AllMiniMaxiHPCnonlocOBnonloc.Shannon(mm,:)=(FinalSig.Shannon);
    AllMiniMaxiHPCnonlocOBnonloc.VectLength(mm,:)=(FinalSig.VectLength);
    
    load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB1_HPCLoc.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
    FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
    load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB2_HPCLoc.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
    FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
    FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
    FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
    AllMiniMaxiHPClocOBnonloc.Shannon(mm,:)=(FinalSig.Shannon);
    AllMiniMaxiHPClocOBnonloc.VectLength(mm,:)=(FinalSig.VectLength);
    
    load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOBLoc_HPCLoc.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
    FinalSig=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
    AllMiniMaxiHPClocOBloc.Shannon(mm,:)=(FinalSig.Shannon);
    AllMiniMaxiHPClocOBloc.VectLength(mm,:)=(FinalSig.VectLength);
    
    load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOBLoc_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
    FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
    load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOBLoc_HPC2.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
    FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
    FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
    FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
    AllMiniMaxiHPCnonlocOBloc.Shannon(mm,:)=(FinalSig.Shannon);
    AllMiniMaxiHPCnonlocOBloc.VectLength(mm,:)=(FinalSig.VectLength);
    
    
    % MN coupling but with filtering in the bans that presents a peak in
    % the spectra
    
    load('LFPPhaseCoupling/FzPhaseCouplingMNOB1_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
    FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
    load('LFPPhaseCoupling/FzPhaseCouplingMNOB1_HPC2.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
    FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
    load('LFPPhaseCoupling/FzPhaseCouplingMNOB2_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
    FinalSig3=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
    load('LFPPhaseCoupling/FzPhaseCouplingMNOB2_HPC2.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
    FinalSig4=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
    FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength+FinalSig3.VectLength+FinalSig4.VectLength)/4;
    FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon+FinalSig3.Shannon+FinalSig4.Shannon)/4;
    AllSpeBandMNHPCnonlocOBnonloc.Shannon(mm,:)=(FinalSig.Shannon);
    AllSpeBandMNHPCnonlocOBnonloc.VectLength(mm,:)=(FinalSig.VectLength);
    
    load('LFPPhaseCoupling/FzPhaseCouplingMNOB1_HPCLoc.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
    FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
    load('LFPPhaseCoupling/FzPhaseCouplingMNOB2_HPCLoc.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
    FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
    FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
    FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
    AllSpeBandMNHPClocOBnonloc.Shannon(mm,:)=(FinalSig.Shannon);
    AllSpeBandMNHPClocOBnonloc.VectLength(mm,:)=(FinalSig.VectLength);
    
    load('LFPPhaseCoupling/FzPhaseCouplingMNOBLoc_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
    FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
    load('LFPPhaseCoupling/FzPhaseCouplingMNOBLoc_HPC2.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
    FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
    FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
    FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
    AllSpeBandMNHPCnonlocOBloc.Shannon(mm,:)=(FinalSig.Shannon);
    AllSpeBandMNHPCnonlocOBloc.VectLength(mm,:)=(FinalSig.VectLength);
    
    load('LFPPhaseCoupling/FzPhaseCouplingMNOBLoc_HPCLoc.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
    FinalSig=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
    AllSpeBandMNHPClocOBloc.Shannon(mm,:)=(FinalSig.Shannon);
    AllSpeBandMNHPClocOBloc.VectLength(mm,:)=(FinalSig.VectLength);
    
end

figure
%% MN coupling with peak trough method
figure('name','MN Coupling Peak-Trough method - vect str')
subplot(411)
temp1=AllSpeBandMNHPCnonlocOBnonloc.VectLength(IsObx==0,:);TotMice1=sum(sum(isnan(temp1'))==0);TotSig1=sum(temp1>0);
temp1(temp1==0)=NaN;
temp2=AllSpeBandMNHPClocOBloc.VectLength(IsObx==0,:);TotMice2=sum(sum(isnan(temp2'))==0);TotSig2=sum(temp2>0);
temp2(temp2==0)=NaN;
g=bar([1:11],[nanmean(temp1);nanmean(temp2)]')
set(g(1),'facecolor','r')
set(g(2),'facecolor','b')
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    text(k,Yl,[num2str(TotSig1(k)),'/',num2str(TotMice1)],'color','r')
    text(k,Yl*1.1,[num2str(TotSig2(k)),'/',num2str(TotMice2)],'color','b')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
text(3,0.07,'n*OB:1*HPC')
text(8,0.07,'n*HPC:1*OB')
set(gca,'XTickLabel',XTickList)
legend('non local','local','Location','NorthEastOutside')
box off
title('HPC (l-nl) - PFCx')
ylabel('Vect Str')
subplot(412)
temp1=AllSpeBandMNHPCnonlocOBnonloc.Shannon(IsObx==0,:);TotMice1=sum(sum(isnan(temp1'))==0);TotSig1=sum(temp1>0);
temp1(temp1==0)=NaN;
temp2=AllSpeBandMNHPClocOBloc.Shannon(IsObx==0,:);TotMice2=sum(sum(isnan(temp2'))==0);TotSig2=sum(temp2>0);
temp2(temp2==0)=NaN;
g=bar([1:11],[nanmean(temp1);nanmean(temp2)]')
set(g(1),'facecolor','r')
set(g(2),'facecolor','b')
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    text(k,Yl,[num2str(TotSig1(k)),'/',num2str(TotMice1)],'color','r')
    text(k,Yl*1.1,[num2str(TotSig2(k)),'/',num2str(TotMice2)],'color','b')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
set(gca,'XTickLabel',XTickList)
legend('non local','local','Location','NorthEastOutside')
box off
text(3,0.002,'n*HPC:1*OB')
text(8,0.002,'n*OB:1*HPC')
title('HPC (l-nl) - OB')
ylabel('Shannon entr')

subplot(413)
temp1=AllMiniMaxiHPCnonlocOBnonloc.VectLength(IsObx==0,:);TotMice1=sum(sum(isnan(temp1'))==0);TotSig1=sum(temp1>0);
temp1(temp1==0)=NaN;
temp2=AllMiniMaxiHPClocOBloc.VectLength(IsObx==0,:);TotMice2=sum(sum(isnan(temp2'))==0);TotSig2=sum(temp2>0);
temp2(temp2==0)=NaN;
g=bar([1:11],[nanmean(temp1);nanmean(temp2)]')
set(g(1),'facecolor','r')
set(g(2),'facecolor','b')
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    text(k,Yl,[num2str(TotSig1(k)),'/',num2str(TotMice1)],'color','r')
    text(k,Yl*1.1,[num2str(TotSig2(k)),'/',num2str(TotMice2)],'color','b')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
text(3,0.1,'n*OB:1*HPC')
text(8,0.1,'n*HPC:1*OB')
set(gca,'XTickLabel',XTickList)
legend('non local','local','Location','NorthEastOutside')
box off
title('HPC (l-nl) - PFCx')
ylabel('Vect Str')
subplot(414)
temp1=AllMiniMaxiHPCnonlocOBnonloc.Shannon(IsObx==0,:);TotMice1=sum(sum(isnan(temp1'))==0);TotSig1=sum(temp1>0);
temp1(temp1==0)=NaN;
temp2=AllMiniMaxiHPClocOBloc.Shannon(IsObx==0,:);TotMice2=sum(sum(isnan(temp2'))==0);TotSig2=sum(temp2>0);
temp2(temp2==0)=NaN;
g=bar([1:11],[nanmean(temp1);nanmean(temp2)]')
set(g(1),'facecolor','r')
set(g(2),'facecolor','b')
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    text(k,Yl,[num2str(TotSig1(k)),'/',num2str(TotMice1)],'color','r')
    text(k,Yl*1.1,[num2str(TotSig2(k)),'/',num2str(TotMice2)],'color','b')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
set(gca,'XTickLabel',XTickList)
legend('non local','local','Location','NorthEastOutside')
box off
text(3,0.01,'n*HPC:1*OB')
text(8,0.01,'n*OB:1*HPC')
title('HPC (l-nl) - OB')
ylabel('Shannon entr')
