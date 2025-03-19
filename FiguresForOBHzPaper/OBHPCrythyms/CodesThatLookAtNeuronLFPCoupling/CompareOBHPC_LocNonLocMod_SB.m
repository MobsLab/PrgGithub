% Calculate spectra,coherence and Granger
clear all
obx=0;
FreqBand=[3 6];
plo=0;
% Get data
OBXEphys=[230,249,250,291,297,298];
CtrlEphys=[242,248,244,243,253,254,258,259,299,394,395,402,403,450,451];
close all
[params,movingwin,suffix]=SpectrumParametersML('low');
rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')
Dir=PathForExperimentFEAR('Fear-electrophy');
if obx
    Dir=RestrictPathForExperiment(Dir,'nMice',[OBXEphys,CtrlEphys]);
    Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
    KeepFirstSessionOnly=[[1,2,4,6:8],[1,3,4,6,8:18]+8];
else
    Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
    Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
    KeepFirstSessionOnly=[[1,3,4,6,8:18]];
end
numNeurons=[];

n=1;
AllCrossCorr=[];
AllMod=[];
Allp=[];
AllSp=[];
FreqRange=[1:0.25:12;[3:0.25:14]];
nbin=30;
nnum=1;
for mm=1:length(KeepFirstSessionOnly)
    disp(Dir.path{KeepFirstSessionOnly(mm)})
    cd(Dir.path{KeepFirstSessionOnly(mm)})
    clear pval ph Kappa mu FreqRange
    if exist('NeuronLFPCoupling/NeuronModFreqAllStructCorrected.mat')>0
        load('NeuronLFPCoupling/NeuronModFreqAllStructCorrected.mat')
    elseif exist('NeuronLFPCoupling/FzNeuronModFreqAllStructCorrected.mat')>0
        load('NeuronLFPCoupling/FzNeuronModFreqAllStructCorrected.mat')
    end
    
    try
        pval;
        load('SpikeClassification.mat')
        tempload=load('FreezingModulationOBRef36Hz.mat');
        for i=1:size(Kappa.HPC1,1)
            for f=1:length(FreqRange)
                Kap.OB(nnum,f)= Kappa.OB1{i,f}.Transf;
                Kap.HPC(nnum,f)= Kappa.HPC1{i,f}.Transf;
                Pval.HPC(nnum,f)=pval.HPC1{i,f}.Transf;
                Pval.OB(nnum,f)=pval.OB1{i,f}.Transf;
                Pval.OBCheck(nnum,f)=tempload.pval{i};
                [~, ~, ~, Rmean, ~, ~,~,~] = CircularMean((ph.HPC1{i,f}.Transf));
                Z.HPC(nnum,f)=length(((ph.HPC1{i,f}.Transf))) * Rmean^2;
                [~, ~, ~, Rmean, ~, ~,~,~] = CircularMean((ph.OB1{i,f}.Transf));
                Z.OB(nnum,f)=length(((ph.OB1{i,f}.Transf))) * Rmean^2;

                if isfield(Kappa,'HPCLoc')
                    Kap.HPCLoc(nnum,f)= Kappa.HPCLoc{i,f}.Transf;
                    Pval.HPCLoc(nnum,f)=pval.HPCLoc{i,f}.Transf;
                    [~, ~, ~, Rmean, ~, ~,~,~] = CircularMean((ph.HPCLoc{i,f}.Transf));
                    Z.HPCLoc(nnum,f)=length(((ph.HPCLoc{i,f}.Transf))) * Rmean^2;
                else
                    Kap.HPCLoc(nnum,f)=NaN;
                    Pval.HPCLoc(nnum,f)=NaN;
                    Z.HPCLoc(nnum,f)=NaN;
                end
                if isfield(Kappa,'OBLoc')
                    Kap.OBLoc(nnum,f)= Kappa.OBLoc{i,f}.Transf;
                    Pval.OBLoc(nnum,f)=pval.OBLoc{i,f}.Transf;
                    [~, ~, ~, Rmean, ~, ~,~,~] = CircularMean((ph.OBLoc{i,f}.Transf));
                    Z.OBLoc(nnum,f)=length(((ph.OBLoc{i,f}.Transf))) * Rmean^2;
                else
                    Kap.OBLoc(nnum,f)=NaN;
                    Pval.OBLoc(nnum,f)=NaN;
                    Z.OBLoc(nnum,f)=NaN;
                end
            end
            NeuronID(nnum)=WfId(i);
            MouseID(nnum)=eval(Dir.name{KeepFirstSessionOnly(mm)}(end-2:end));
            nnum=nnum+1;
            
        end
    end
end
% Very basic figures
ToKeep=not(isnan(Pval.HPCLoc(:,1)));
figure
f=20
alpha=0.05;
subplot(221)
JustOB=round(100*sum(Pval.OB(ToKeep,f)<alpha & Pval.HPC(ToKeep,f)>alpha)./length(Pval.HPC(ToKeep,f)));
JustHPC=round(100*sum(Pval.OB(ToKeep,f)>alpha & Pval.HPC(ToKeep,f)<alpha)./length(Pval.HPC(ToKeep,f)));
Both=round(100*sum(Pval.OB(ToKeep,f)<alpha & Pval.HPC(ToKeep,f)<alpha)./length(Pval.HPC(ToKeep,f)));
None=round(100*sum(Pval.OB(ToKeep,f)>alpha & Pval.HPC(ToKeep,f)>alpha)./length(Pval.HPC(ToKeep,f)));
pie([JustOB,JustHPC,Both,None],{['JustOB ' num2str(JustOB) '%'],['JustHPC ' num2str(JustHPC) '%'],...
    ['Both ' num2str(Both) '%'],['None ' num2str(None) '%']}), colormap hot
subplot(222)
AllOBKappa=Kap.OB(ToKeep,f);
AllHPCKappa=Kap.HPC(ToKeep,f);
[Y,X]=hist(AllOBKappa(Pval.OB(ToKeep,f)<alpha & Pval.HPC(ToKeep,f)<alpha)-AllHPCKappa(Pval.OB(ToKeep,f)<alpha & Pval.HPC(ToKeep,f)<alpha));
bar(X,Y/sum(Y),'Facecolor',[1 0.8 0.2]), hold on
line([0 0],ylim,'color','k','linewidth',3)
xlim([-0.5 0.5]), box off
text(0.2,0.3,'OB pref')
text(-0.4,0.3,'HPC pref')

subplot(223)
JustOB=round(100*sum(Pval.OB(ToKeep,f)<alpha & Pval.HPCLoc(ToKeep,f)>alpha)./length(Pval.HPCLoc(ToKeep,f)));
JustHPC=round(100*sum(Pval.OB(ToKeep,f)>alpha & Pval.HPCLoc(ToKeep,f)<alpha)./length(Pval.HPCLoc(ToKeep,f)));
Both=round(100*sum(Pval.OB(ToKeep,f)<alpha & Pval.HPCLoc(ToKeep,f)<alpha)./length(Pval.HPCLoc(ToKeep,f)));
None=round(100*sum(Pval.OB(ToKeep,f)>alpha & Pval.HPCLoc(ToKeep,f)>alpha)./length(Pval.HPCLoc(ToKeep,f)));
pie([JustOB,JustHPC,Both,None],{['JustOB ' num2str(JustOB) '%'],['JustHPC ' num2str(JustHPC) '%'],...
    ['Both ' num2str(Both) '%'],['None ' num2str(None) '%']}), colormap hot
subplot(224)
AllOBKappa=Kap.OB(ToKeep,f);
AllHPCKappa=Kap.HPC(ToKeep,f);
[Y,X]=hist(AllOBKappa(Pval.OB(ToKeep,f)<alpha & Pval.HPCLoc(ToKeep,f)<alpha)-AllHPCKappa(Pval.OB(ToKeep,f)<alpha & Pval.HPCLoc(ToKeep,f)<alpha));
bar(X,Y/sum(Y),'Facecolor',[1 0.8 0.2]), hold on
line([0 0],ylim,'color','k','linewidth',3)
xlim([-0.5 0.5]), box off
text(0.2,0.16,'OB pref')
text(-0.4,0.16,'HPC pref')

figure
f=20
alpha=0.05;
subplot(121)
JustOB=sum(Pval.OB(:,f)<alpha & Pval.HPC(:,f)>alpha)./length(Pval.HPC(:,f));
JustHPC=sum(Pval.OB(:,f)>alpha & Pval.HPC(:,f)<alpha)./length(Pval.HPC(:,f));
Both=sum(Pval.OB(:,f)<alpha & Pval.HPC(:,f)<alpha)./length(Pval.HPC(:,f));
None=sum(Pval.OB(:,f)>alpha & Pval.HPC(:,f)>alpha)./length(Pval.HPC(:,f));
pie([JustOB,JustHPC,Both,None],{'JustOB','JustHPC','Both','Neither'}), colormap hot
subplot(122)
AllOBKappa=Kap.OB(:,f);
AllHPCKappa=Kap.HPC(:,f);
[Y,X]=hist(AllOBKappa(Pval.OB(:,f)<alpha & Pval.HPC(:,f)<alpha)-AllHPCKappa(Pval.OB(:,f)<alpha & Pval.HPC(:,f)<alpha));
bar(X,Y/sum(Y),'Facecolor',[1 0.8 0.2]), hold on
line([0 0],ylim,'color','k','linewidth',3)
xlim([-0.5 0.5]), box off
text(0.2,0.25,'OB pref')
text(-0.4,0.25,'HPC pref')

figure
freqbnd=[8];
subplot(121)
[Y1,X1]=(hist(log(mean(Z.OB(not(isnan(Z.OBLoc(:,freqbnd(1)))),freqbnd)',1)),100));
plot(X1,100*(1-cumsum(Y1)/sum(Y1)),'b','linewidth',2), hold on
hold on
[Y1,X1]=(hist(log(mean(Z.OBLoc(not(isnan(Z.OBLoc(:,freqbnd(1)))),freqbnd)',1)),100));
plot(X1,100*(1-cumsum(Y1)/sum(Y1)),'m','linewidth',2), hold on
line([1.12 1.12],ylim,'linestyle','--','color','k')
xlim([0 6]),ylim([0 100])
box off
xlabel('ln(Z)'), ylabel('% units')
set(gca,'FontSize',10,'YTick',[0:20:100])
subplot(122)
[Y1,X1]=(hist(log(mean(Z.HPC(not(isnan(Z.HPCLoc(:,freqbnd(1)))),freqbnd)',1)),100));
plot(X1,100*(1-cumsum(Y1)/sum(Y1)),'r','linewidth',2), hold on
hold on
[Y1,X1]=(hist(log(mean(Z.HPCLoc(not(isnan(Z.HPCLoc(:,freqbnd(1)))),freqbnd)',1)),100));
plot(X1,100*(1-cumsum(Y1)/sum(Y1)),'c','linewidth',2), hold on
line([1.12 1.12],ylim,'linestyle','--','color','k')
xlim([0 6]),ylim([0 100])
box off
xlabel('ln(Z)'), ylabel('% units')
set(gca,'FontSize',10,'YTick',[0:20:100])

figure
freqbnd=[17:24];
subplot(121)
[Y1,X1]=(hist(log(mean(Z.OB(not(isnan(Z.OBLoc(:,freqbnd(1)))),freqbnd)')),100));
plot(X1,100*(1-cumsum(Y1)/sum(Y1)),'b','linewidth',2), hold on
hold on
[Y1,X1]=(hist(log(mean(Z.OBLoc(not(isnan(Z.OBLoc(:,freqbnd(1)))),freqbnd)')),100));
plot(X1,100*(1-cumsum(Y1)/sum(Y1)),'m','linewidth',2), hold on
line([1.12 1.12],ylim,'linestyle','--','color','k')
xlim([0 6]),ylim([0 100])
box off
xlabel('ln(Z)'), ylabel('% units')
set(gca,'FontSize',10,'YTick',[0:20:100])
subplot(122)
[Y1,X1]=(hist(log(mean(Z.HPC(not(isnan(Z.HPCLoc(:,freqbnd(1)))),freqbnd)')),100));
plot(X1,100*(1-cumsum(Y1)/sum(Y1)),'r','linewidth',2), hold on
hold on
[Y1,X1]=(hist(log(mean(Z.HPCLoc(not(isnan(Z.HPCLoc(:,freqbnd(1)))),freqbnd)')),100));
plot(X1,100*(1-cumsum(Y1)/sum(Y1)),'c','linewidth',2), hold on
line([1.12 1.12],ylim,'linestyle','--','color','k')
xlim([0 6]),ylim([0 100])
box off
xlabel('ln(Z)'), ylabel('% units')
set(gca,'FontSize',10,'YTick',[0:20:100])



figure;
A=Kap.HPCLoc;
B=Kap.HPC;
NanCoord=~any(isnan(A),2);
A=A(NanCoord,:);
B=B(NanCoord,:);
DiffHPCLoc=A-B;
subplot(221)
shadedErrorBar(mean(FreqRange),mean(DiffHPCLoc),[stdError(DiffHPCLoc);stdError(DiffHPCLoc)]);
ylim([-0.05 0.05]), xlim([2 13])
title(['HPC n=',num2str(size(DiffHPCLoc,1))])
ylabel('Local - NonLocal Kappa')
xlabel('Frequency Hz')
box off
A=Kap.OBLoc;
B=Kap.OB;
NanCoord=~any(isnan(A),2);
A=A(NanCoord,:);
B=B(NanCoord,:);
DiffOBLoc=A-B;
subplot(222)
shadedErrorBar(mean(FreqRange),mean(DiffOBLoc),[stdError(DiffOBLoc);stdError(DiffOBLoc)]);
ylim([-0.05 0.05]), xlim([2 13])
title(['OB n=',num2str(size(DiffOBLoc,1))])
xlabel('Frequency Hz')
box off

A=Pval.HPCLoc;
B=Pval.HPC;
NanCoord=~any(isnan(A),2);
A=A(NanCoord,:);A=A<0.05;
B=B(NanCoord,:);B=B<0.05;
DiffHPCLoc=A-B;
subplot(223)
bar(mean(FreqRange),mean(DiffHPCLoc))
ylim([-0.3 0.15]), xlim([2 13])
title(['HPC n=',num2str(size(DiffHPCLoc,1))])
ylabel('Local - NonLocal signif neurons')
xlabel('Frequency Hz')
box off
A=Pval.OBLoc;
B=Pval.OB;
NanCoord=~any(isnan(A),2);
A=A(NanCoord,:);A=A<0.05;
B=B(NanCoord,:);B=B<0.05;
DiffOBLoc=A-B;
subplot(224)
bar(mean(FreqRange),mean(DiffOBLoc))
ylim([-0.3 0.15]), xlim([2 13])
title(['OB n=',num2str(size(DiffOBLoc,1))])
ylabel('Local - NonLocal signif neurons')
xlabel('Frequency Hz')
box off


MinBinSig=1;
LowFreqInd=find(mean(FreqRange)>3 & mean(FreqRange)<6);
B=Pval.OB;B=B<(0.05/length(LowFreqInd));
OBSigNeurons=find(sum(B(:,LowFreqInd)')>MinBinSig); % More than MinBinSig bins significant
OBNonSigNeurons=find(sum(B(:,LowFreqInd)')<MinBinSig);

LowFreqInd=find(mean(FreqRange)>6 & mean(FreqRange)<9);
B=Pval.HPC;B=B<(0.05/length(LowFreqInd));
HPCSigNeurons=find(sum(B(:,LowFreqInd)')>MinBinSig); % More than MinBinSig bins significant
HPCNonSigNeurons=find(sum(B(:,LowFreqInd)')<MinBinSig);

figure
subplot(221)
A=Kap.HPC;
OBON=A(OBSigNeurons,:);
OBOFF=A(OBNonSigNeurons,:);
NanCoord=~any(isnan(OBON),2);
OBON=OBON(NanCoord,:);
NanCoord=~any(isnan(OBOFF),2);
OBOFF=OBOFF(NanCoord,:);
plot(mean(FreqRange),mean(OBON)-mean(OBOFF),'linewidth',2), hold on
A=Kap.HPCLoc;
OBON=A(OBSigNeurons,:);
OBOFF=A(OBNonSigNeurons,:);
NanCoord=~any(isnan(OBON),2);
OBON=OBON(NanCoord,:);
NanCoord=~any(isnan(OBOFF),2);
OBOFF=OBOFF(NanCoord,:);
plot(mean(FreqRange),mean(OBON)-mean(OBOFF),'linewidth',2), hold on
ylim([-0.15 0.15]), xlim([2 13])
legend('NonLocal', 'Local')
title(['OB sig n=',num2str(size(OBSigNeurons,2)),' vs non sig n=',num2str(size(OBNonSigNeurons,2))])
ylabel('Kappa on HPC LFP of OB sig - OB non sig')
xlabel('Frequency Hz')
box off


subplot(222)
A=Kap.OB;
HPCON=A(HPCSigNeurons,:);
HPCOFF=A(HPCNonSigNeurons,:);
NanCoord=~any(isnan(HPCON),2);
HPCON=HPCON(NanCoord,:);
NanCoord=~any(isnan(HPCOFF),2);
HPCOFF=HPCOFF(NanCoord,:);
plot(mean(FreqRange),mean(HPCON)-mean(HPCOFF),'linewidth',2), hold on
A=Kap.OBLoc;
HPCON=A(HPCSigNeurons,:);
HPCOFF=A(HPCNonSigNeurons,:);
NanCoord=~any(isnan(HPCON),2);
HPCON=HPCON(NanCoord,:);
NanCoord=~any(isnan(HPCOFF),2);
HPCOFF=HPCOFF(NanCoord,:);
plot(mean(FreqRange),mean(HPCON)-mean(HPCOFF),'linewidth',2), hold on
ylim([-0.15 0.15]), xlim([2 13])
legend('NonLocal', 'Local')
title(['HPC sig n=',num2str(size(HPCSigNeurons,2)),' vs non sig n=',num2str(size(HPCNonSigNeurons,2))])
ylabel('Kappa on OB LFP of HPC sig - HPC non sig')
xlabel('Frequency Hz')
box off

subplot(223)
A=Pval.HPC;
OBON=A(OBSigNeurons,:);
NanCoord=~any(isnan(OBON),2);
OBON=OBON(NanCoord,:);
OBON=OBON<0.05;
OBOFF=A(OBNonSigNeurons,:);
NanCoord=~any(isnan(OBOFF),2);
OBOFF=OBOFF(NanCoord,:);
OBOFF=OBOFF<0.05;
NonLocNeur=[length(OBON),length(OBOFF)];
stairs(mean(FreqRange),mean(OBON)-mean(OBOFF),'b','linewidth',3), hold on
A=Pval.HPCLoc;
OBON=A(OBSigNeurons,:);
NanCoord=~any(isnan(OBON),2);
OBON=OBON(NanCoord,:);
OBON=OBON<0.05;
OBOFF=A(OBNonSigNeurons,:);
NanCoord=~any(isnan(OBOFF),2);
OBOFF=OBOFF(NanCoord,:);
OBOFF=OBOFF<0.05;
stairs(mean(FreqRange),mean(OBON)-mean(OBOFF),'r','linewidth',3), hold on
LocNeur=[length(OBON),length(OBOFF)];
legend(['NonLocal n=' num2str(NonLocNeur)], ['Local n=' num2str(LocNeur)])
title(['OB sig n=',num2str(size(OBSigNeurons,2)),' vs non sig n=',num2str(size(OBNonSigNeurons,2))])
ylabel('%Sig Neur on HPC LFP of OB sig - OB non sig')
xlabel('Frequency Hz')
box off

subplot(224)
A=Pval.OB;
HPCON=A(HPCSigNeurons,:);
NanCoord=~any(isnan(HPCON),2);
HPCON=HPCON(NanCoord,:);
HPCON=HPCON<0.05;
HPCOFF=A(HPCNonSigNeurons,:)
NanCoord=~any(isnan(HPCOFF),2);
HPCOFF=HPCOFF(NanCoord,:);
HPCOFF=HPCOFF<0.05;
NonLocNeur=[length(HPCON),length(HPCOFF)];

stairs(mean(FreqRange),mean(HPCON)-mean(HPCOFF),'b','linewidth',3), hold on
A=Pval.OBLoc;
HPCON=A(HPCSigNeurons,:);
NanCoord=~any(isnan(HPCON),2);
HPCON=HPCON(NanCoord,:);
HPCON=HPCON<0.05;
HPCOFF=A(HPCNonSigNeurons,:)
NanCoord=~any(isnan(HPCOFF),2);
HPCOFF=HPCOFF(NanCoord,:);
HPCOFF=HPCOFF<0.05;
stairs(mean(FreqRange),mean(HPCON)-mean(HPCOFF),'r','linewidth',3), hold on
LocNeur=[length(HPCON),length(HPCOFF)];
legend(['NonLocal n=' num2str(NonLocNeur)], ['Local n=' num2str(LocNeur)])
title(['HPC sig n=',num2str(size(HPCSigNeurons,2)),' vs non sig n=',num2str(size(HPCNonSigNeurons,2))])
ylabel('%Sig Neur on OB LFP of HPC sig - HPC non sig')
xlabel('Frequency Hz')
box off


% just do on neurons we have for local
figure
subplot(221)
% local act
A=Kap.HPCLoc;
OBON=A(OBSigNeurons,:);
OBOFF=A(OBNonSigNeurons,:);
NanCoord=~any(isnan(OBON),2);
NanCoordlocON=NanCoord;
OBON=OBON(NanCoord,:);
NanCoord=~any(isnan(OBOFF),2);
NanCoordlocOFF=NanCoord;
OBOFF=OBOFF(NanCoord,:);
LocNeur=[length(OBON),length(OBOFF)];
plot(mean(FreqRange),mean(OBON)-mean(OBOFF),'r','linewidth',2), hold on
% Non local act
A=Kap.HPC;
OBON=A(OBSigNeurons,:);
OBOFF=A(OBNonSigNeurons,:);
OBON=OBON(NanCoordlocON,:);
OBOFF=OBOFF(NanCoordlocOFF,:);
NonLocNeur=[length(OBON),length(OBOFF)];
plot(mean(FreqRange),mean(OBON)-mean(OBOFF),'b','linewidth',2), hold on
ylim([-0.15 0.15]), xlim([2 13])
legend(['Local n=' num2str(LocNeur)],['NonLocal n=' num2str(NonLocNeur)])
title(['OB sig n=',num2str(size(OBSigNeurons,2)),' vs non sig n=',num2str(size(OBNonSigNeurons,2))])
ylabel('Kappa on HPC LFP of OB sig - OB non sig')
xlabel('Frequency Hz')
box off


subplot(222)
% local act
A=Kap.OBLoc;
HPCON=A(HPCSigNeurons,:);
HPCOFF=A(HPCNonSigNeurons,:);
NanCoord=~any(isnan(HPCON),2);
NanCoordlocON=NanCoord;
HPCON=HPCON(NanCoord,:);
NanCoord=~any(isnan(HPCOFF),2);
NanCoordlocOFF=NanCoord;
HPCOFF=HPCOFF(NanCoord,:);
plot(mean(FreqRange),mean(HPCON)-mean(HPCOFF),'r','linewidth',2), hold on
LocNeur=[length(OBON),length(OBOFF)];
% non local act
A=Kap.OB;
HPCON=A(HPCSigNeurons,:);
HPCOFF=A(HPCNonSigNeurons,:);
NanCoord=~any(isnan(HPCON),2);
HPCON=HPCON(NanCoord,:);
NanCoord=~any(isnan(HPCOFF),2);
HPCOFF=HPCOFF(NanCoord,:);
NonLocNeur=[length(OBON),length(OBOFF)];
plot(mean(FreqRange),mean(HPCON)-mean(HPCOFF),'b','linewidth',2), hold on
ylim([-0.15 0.15]), xlim([2 13])
legend(['Local n=' num2str(LocNeur)],['NonLocal n=' num2str(NonLocNeur)])
title(['HPC sig n=',num2str(size(HPCSigNeurons,2)),' vs non sig n=',num2str(size(HPCNonSigNeurons,2))])
ylabel('Kappa on OB LFP of HPC sig - HPC non sig')
xlabel('Frequency Hz')
box off

subplot(223)
% local act
A=Pval.HPCLoc;
OBON=A(OBSigNeurons,:);
NanCoord=~any(isnan(OBON),2);
NanCoordlocON=NanCoord;
OBON=OBON(NanCoord,:);
OBON=OBON<0.05;
OBOFF=A(OBNonSigNeurons,:);
NanCoord=~any(isnan(OBOFF),2);
NanCoordlocOFF=NanCoord;
OBOFF=OBOFF(NanCoord,:);
OBOFF=OBOFF<0.05;
stairs(mean(FreqRange),mean(OBON)-mean(OBOFF),'r','linewidth',3), hold on
LocNeur=[length(OBON),length(OBOFF)];
% non local act
A=Pval.HPC;
OBON=A(OBSigNeurons,:);
OBON=OBON(NanCoordlocON,:);
OBON=OBON<0.05;
OBOFF=A(OBNonSigNeurons,:);
OBOFF=OBOFF(NanCoordlocOFF,:);
OBOFF=OBOFF<0.05;
NonLocNeur=[length(OBON),length(OBOFF)];
stairs(mean(FreqRange),mean(OBON)-mean(OBOFF),'b','linewidth',3), hold on

legend(['Local n=' num2str(LocNeur)],['NonLocal n=' num2str(NonLocNeur)])
title(['OB sig n=',num2str(size(OBSigNeurons,2)),' vs non sig n=',num2str(size(OBNonSigNeurons,2))])
ylabel('%Sig Neur on HPC LFP of OB sig - OB non sig')
xlabel('Frequency Hz')
box off

subplot(224)
% Local act
A=Pval.OBLoc;
HPCON=A(HPCSigNeurons,:);
NanCoord=~any(isnan(HPCON),2);
NanCoordlocON=NanCoord;
HPCON=HPCON(NanCoord,:);
HPCON=HPCON<0.05;
HPCOFF=A(HPCNonSigNeurons,:)
NanCoord=~any(isnan(HPCOFF),2);
NanCoordlocOFF=NanCoord;
HPCOFF=HPCOFF(NanCoord,:);
HPCOFF=HPCOFF<0.05;
stairs(mean(FreqRange),mean(HPCON)-mean(HPCOFF),'r','linewidth',3), hold on
LocNeur=[length(HPCON),length(HPCOFF)];
% Non Local act
A=Pval.OB;
HPCON=A(HPCSigNeurons,:);
HPCON=HPCON(NanCoordlocON,:);
HPCON=HPCON<0.05;
HPCOFF=A(HPCNonSigNeurons,:)
HPCOFF=HPCOFF(NanCoordlocOFF,:);
HPCOFF=HPCOFF<0.05;
NonLocNeur=[length(HPCON),length(HPCOFF)];
stairs(mean(FreqRange),mean(HPCON)-mean(HPCOFF),'b','linewidth',3), hold on

legend( ['Local n=' num2str(LocNeur)],['NonLocal n=' num2str(NonLocNeur)])
title(['HPC sig n=',num2str(size(HPCSigNeurons,2)),' vs non sig n=',num2str(size(HPCNonSigNeurons,2))])
ylabel('%Sig Neur on OB LFP of HPC sig - HPC non sig')
xlabel('Frequency Hz')
box off


Range{1}=[5:17];
Range{2}=[13:27];
clf
for i=1:2
    alpha=0.05/length(Range{1});
    NumBins=2;
    LocalSigHPC=Pval.HPCLoc;
    NonLocalSigHPC=Pval.HPC;
    NanCoord=~any(isnan(LocalSigHPC),2);
    NonLocalSigHPC=NonLocalSigHPC(NanCoord,:);
    LocalSigHPC=LocalSigHPC(NanCoord,:);
    LocSigPropHPC=sum(sum(LocalSigHPC(:,Range{i})'<alpha)>NumBins)./length(LocalSigHPC);
    NonLocSigPropHPC= sum(sum(NonLocalSigHPC(:,Range{i})'<alpha)>NumBins)./length(NonLocalSigHPC);
    subplot(1,2,1)
    bar([1,2]+(i-1)*3,[NonLocSigPropHPC,LocSigPropHPC]), hold on
    ylim([0 0.5])
    
    LocalSigOB=Pval.OBLoc;
    NonLocalSigOB=Pval.OB;
    NanCoord=~any(isnan(LocalSigOB),2);
    LocalSigOB=LocalSigOB(NanCoord,:);
    NonLocalSigOB=NonLocalSigOB(NanCoord,:);
    LocSigPropOB=sum(sum(LocalSigOB(:,Range{i})'<alpha)>NumBins)./length(LocalSigOB);
    NonLocSigPropOB= sum(sum(NonLocalSigOB(:,Range{i})'<alpha)>NumBins)./length(NonLocalSigOB);
    subplot(1,2,2)
    bar([1,2]+(i-1)*3,[NonLocSigPropOB,LocSigPropOB]), hold on
    ylim([0 0.5])
end


figure
subplot(221)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
A=Pval.HPCLoc;
NanCoord=~any(isnan(A),2);
A=A(NanCoord,:);
alpha=[0.05,0.01,0.001,0.0001,0.00001];
cols=paruly(length(alpha)+1);
for k=1:length(alpha)
    plot(mean(FreqRange),sum(A<alpha(k))/size(A,1),'color',cols(k,:),'linewidth',2), hold on
end
xlim([2 13]),ylim([0 0.6])
set(gca,'Layer','top')
xlim([2 13]),ylim([0 0.6])
set(gca,'Layer','top')
xlabel('Frequency Hz')
ylabel('Prop sig neurons')
legend('3-6Hz','0.05','0.01','0.001','0.0001','0.00001')
title('HPC LFP')
subplot(222)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
A=Pval.OBLoc;
NanCoord=~any(isnan(A),2);
A=A(NanCoord,:);
alpha=[0.05,0.01,0.001,0.0001,0.00001];
cols=paruly(length(alpha)+1);
for k=1:length(alpha)
    plot(mean(FreqRange),sum(A<alpha(k))/size(A,1),'color',cols(k,:),'linewidth',2), hold on
end
xlim([2 13]),ylim([0 0.6])
set(gca,'Layer','top')
xlim([2 13]),ylim([0 0.6])
set(gca,'Layer','top')
xlabel('Frequency Hz')
ylabel('Prop sig neurons')
title('OB LFP')
subplot(223)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
A=Pval.HPCLoc;
NanCoord=~any(isnan(A),2);
A=A(NanCoord,:);
B=Kap.HPCLoc;
B=B(NanCoord,:);
plot(mean(FreqRange),nanmean(B),'color','k','linewidth',2), hold on
xlim([2 13]),ylim([0 0.2])
set(gca,'Layer','top')
xlabel('Frequency Hz')
ylabel('mean Kappa')
subplot(224)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
A=Pval.OBLoc;
NanCoord=~any(isnan(A),2);
A=A(NanCoord,:);
B=Kap.OBLoc;
B=B(NanCoord,:);
plot(mean(FreqRange),nanmean(B),'color','k','linewidth',2), hold on
xlim([2 13]),ylim([0 0.2])
set(gca,'Layer','top')
xlabel('Frequency Hz')
ylabel('mean Kappa')



figure
subplot(221)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
A=Pval.HPC;
NanCoord=~any(isnan(A),2);
A=A(NanCoord,:);
alpha=[0.05,0.01,0.001,0.0001,0.00001];
cols=paruly(length(alpha)+1);
for k=1:length(alpha)
    plot(mean(FreqRange),sum(A<alpha(k))/size(A,1),'color',cols(k,:),'linewidth',2), hold on
end
xlim([2 13]),ylim([0 0.6])
set(gca,'Layer','top')
xlabel('Frequency Hz')
ylabel('Prop sig neurons')
legend('3-6Hz','0.05','0.01','0.001','0.0001','0.00001')
title('HPC LFP')
subplot(222)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
A=Pval.OB;
NanCoord=~any(isnan(A),2);
A=A(NanCoord,:);
alpha=[0.05,0.01,0.001,0.0001,0.00001];
cols=paruly(length(alpha)+1);
for k=1:length(alpha)
    plot(mean(FreqRange),sum(A<alpha(k))/size(A,1),'color',cols(k,:),'linewidth',2), hold on
end
xlim([2 13]),ylim([0 0.6])
set(gca,'Layer','top')
set(gca,'Layer','top')
xlabel('Frequency Hz')
ylabel('Prop sig neurons')
title('OB LFp')
subplot(223)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
A=Pval.HPC;
NanCoord=~any(isnan(A),2);
A=A(NanCoord,:);
B=Kap.HPC;
B=B(NanCoord,:);
plot(mean(FreqRange),nanmean(B),'color','k','linewidth',2), hold on
xlim([2 13]),ylim([0 0.2])
xlabel('Frequency Hz')
ylabel('mean Kappa')
set(gca,'Layer','top')
subplot(224)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
A=Pval.OB;
NanCoord=~any(isnan(A),2);
A=A(NanCoord,:);
B=Kap.OB;
B=B(NanCoord,:);
plot(mean(FreqRange),nanmean(B),'color','k','linewidth',2), hold on
xlim([2 13]),ylim([0 0.2])
set(gca,'Layer','top')
xlabel('Frequency Hz')
ylabel('mean Kappa')


% Which frequency do the neurons prefer?
figure
A=Pval.HPC;
NanCoord=~any(isnan(A),2);
A=A(NanCoord,:);
[val,ind]=min(A');
ind(val>0.01)=[];
FreqPeakNonLoc=mean(FreqRange(:,ind));
[Y,X]=hist(FreqPeakNonLoc,20);
Y=Y/sum(Y);
plot(X,Y,'linewidth',2,'color','k'), hold on

A=Pval.OB;
NanCoord=~any(isnan(A),2);
A=A(NanCoord,:);
[val,ind]=min(A');
ind(val>0.01)=[];
FreqPeakNonLoc=mean(FreqRange(:,ind));
[Y,X]=hist(FreqPeakNonLoc,20);
Y=Y/sum(Y);
plot(X,Y,'linewidth',2,'color','b'), hold on
box off
legend('HPC','OB')
xlabel('Frequency Hz')
ylabel('Prop of units')
title('preferred frequency')


% Winner takes all : OB or HPC
A=double(Pval.OB<Pval.HPC & Pval.OB<0.05);
B=double(Pval.OB>Pval.HPC & Pval.HPC<0.05);
bar(mean(FreqRange),-0.5+sum(A==1)./(sum(A)+sum(B)))
xlim([2 13]),ylim([-0.25 0.25])
box off
xlabel('Frequency Hz')
ylabel('Prop of units preferring OB or HPC')
text(3,0.2,'OB Prefering')
text(3,-0.2,'HPC Prefering')


