% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
% Get directories
CtrlEphys=[254,253,258,299,395,403,451,248,244,402];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
% Frequency bands to scan through
FreqRange=[1:12;[3:14]];
% Name of possible different structures
FieldNames={'OB1','OB2','OBLoc','HPC1','HPC2','HPCLoc','PFCx'};
% Freq bands specific to each area - only used for NM coupling
FiltBand=[3,6;3,6;3,6;5.5,8.5;5.5,8.5;5.5,8.5;3,6];
%Where to save things
FolderName='NeuronLFPCoupling';
% Number of bootstraps for statistics
DoStats=500;
% NM Ratios of phases to try, as in Scheffer-Teixeira 2016
MNRatio=[1,1;1,1.5;1,2;1,3;1,4;1,5];
nbin=30;
% Parameters for triggered spectro
MouseNum=1;
TotNeurons=0;
for mm=1:length(Dir.path)
    mm
    cd(Dir.path{mm})
    try 
        load([FolderName '/FzNeuronModFreqAllStructCorrected.mat'])
        KappaAllFreq=Kappa;
        MuAllFreq=mu;
        pvalAllFreq=pval;
        clear pval mu Kappa FreqRange ph
        
        for cc=1:length(FieldNames)
            
            if isfield(KappaAllFreq,FieldNames{cc})
                for sp=1:size(KappaAllFreq.(FieldNames{cc}),1)
                    for f=1:size(KappaAllFreq.(FieldNames{cc}),2)
                        Res.Fz.AllFreq.(FieldNames{cc}).kappa{MouseNum}(TotNeurons+sp,f)= KappaAllFreq.(FieldNames{cc}){sp,f}.Transf;
                        Res.Fz.AllFreq.(FieldNames{cc}).pval{MouseNum}(TotNeurons+sp,f)= pvalAllFreq.(FieldNames{cc}){sp,f}.Transf;
                        Res.Fz.AllFreq.(FieldNames{cc}).mu{MouseNum}(TotNeurons+sp,f)= MuAllFreq.(FieldNames{cc}){sp,f}.Transf;
                    end
                end
            end
            
            % Phase coupling filtered signals in specific regions of
            % interest
            if exist([FolderName,'/FzNeuronModFreqSpecificBandCorrected_',FieldNames{cc},'.mat'])>0
                disp([FolderName,'/FzNeuronModFreqSpecificBandCorrected_',FieldNames{cc},'.mat'])
                load([FolderName,'/FzNeuronModFreqSpecificBandCorrected_',FieldNames{cc},'.mat'])
                
                for sp=1:size(Kappa,2)
                    Res.Fz.FreqSpe.(FieldNames{cc}).kappa{MouseNum}(TotNeurons+sp)=Kappa{sp}.Transf;
                    Res.Fz.FreqSpe.(FieldNames{cc}).pval{MouseNum}(TotNeurons+sp)=pval{sp}.Transf;
                    Res.Fz.FreqSpe.(FieldNames{cc}).mu{MouseNum}(TotNeurons+sp)=mu{sp}.Transf;
                end
                
                clear PhasesSpikes mu Kappa channel pval SpBand
                
                                disp([FolderName,'/NoFzNeuronModFreqSpecificBandCorrected_',FieldNames{cc},'.mat'])
                load([FolderName,'/NoFzNeuronModFreqSpecificBandCorrected_',FieldNames{cc},'.mat'])
                
                for sp=1:size(Kappa,2)
                    Res.NoFz.FreqSpe.(FieldNames{cc}).kappa{MouseNum}(TotNeurons+sp)=Kappa{sp}.Transf;
                    Res.NoFz.FreqSpe.(FieldNames{cc}).pval{MouseNum}(TotNeurons+sp)=pval{sp}.Transf;
                    Res.NoFz.FreqSpe.(FieldNames{cc}).mu{MouseNum}(TotNeurons+sp)=mu{sp}.Transf;
                end
                
                clear PhasesSpikes mu Kappa channel pval SpBand

                
                % Phase coupling filtered signals in specific regions of
                % interest
                disp([FolderName,'/FzNeuronModFreqMiniMaxiPhaseCorrected_',FieldNames{cc},'.mat'])
                load([FolderName,'/FzNeuronModFreqMiniMaxiPhaseCorrected_',FieldNames{cc},'.mat'])
                
                for sp=1:size(Kappa.Real,2)
                    Res.Fz.MiniMaxi.(FieldNames{cc}).kappa{MouseNum}(TotNeurons+sp)=Kappa.Real{sp}.Transf;
                    Res.Fz.MiniMaxi.(FieldNames{cc}).pval{MouseNum}(TotNeurons+sp)=pval.Real{sp}.Transf;
                    Res.Fz.MiniMaxi.(FieldNames{cc}).mu{MouseNum}(TotNeurons+sp)=mu.Real{sp}.Transf;
                end
                
                clear PhasesSpikes mu Kappa channel pval SpBand
                
                % Phase coupling filtered signals in specific regions of
                % interest
                disp([FolderName,'/NoFzNeuronModFreqMiniMaxiPhaseCorrected_',FieldNames{cc},'.mat'])
                load([FolderName,'/NoFzNeuronModFreqMiniMaxiPhaseCorrected_',FieldNames{cc},'.mat'])
                
                for sp=1:size(Kappa.Real,2)
                    Res.NoFz.MiniMaxi.(FieldNames{cc}).kappa{MouseNum}(TotNeurons+sp)=Kappa.Real{sp}.Transf;
                    Res.NoFz.MiniMaxi.(FieldNames{cc}).pval{MouseNum}(TotNeurons+sp)=pval.Real{sp}.Transf;
                    Res.NoFz.MiniMaxi.(FieldNames{cc}).mu{MouseNum}(TotNeurons+sp)=mu.Real{sp}.Transf;
                end
                
                clear PhasesSpikes mu Kappa channel pval SpBand
                
            end
        end
        clear         KappaAllFreq MuAllFreq pvalAllFreq

        %         TotNeurons=length(Res.Fz.FreqSpe.(FieldNames{cc}).kappa);
        MouseNum=MouseNum+1;
    end
end

% Very basic figures
figure
alpha=0.05;
subplot(121)
JustOB=sum([Res.Fz.FreqSpe.OB1.pval{:}]<alpha & [Res.Fz.FreqSpe.HPC1.pval{:}]>alpha)./length([Res.Fz.FreqSpe.HPC1.pval{:}]);
JustHPC=sum([Res.Fz.FreqSpe.OB1.pval{:}]>alpha & [Res.Fz.FreqSpe.HPC1.pval{:}]<alpha)./length([Res.Fz.FreqSpe.HPC1.pval{:}]);
Both=sum([Res.Fz.FreqSpe.OB1.pval{:}]<alpha & [Res.Fz.FreqSpe.HPC1.pval{:}]<alpha)./length([Res.Fz.FreqSpe.HPC1.pval{:}]);
None=sum([Res.Fz.FreqSpe.OB1.pval{:}]>alpha & [Res.Fz.FreqSpe.HPC1.pval{:}]>alpha)./length([Res.Fz.FreqSpe.HPC1.pval{:}]);
pie([JustOB,JustHPC,Both,None],{'JustOB','JustHPC','Both','Neither'}), colormap hot
subplot(122)
AllOBKappa=[Res.Fz.FreqSpe.OB1.kappa{:}];
AllHPCKappa=[Res.Fz.FreqSpe.HPC1.kappa{:}];
[Y,X]=hist(AllOBKappa([Res.Fz.FreqSpe.OB1.pval{:}]<alpha & [Res.Fz.FreqSpe.HPC1.pval{:}]<alpha)-AllHPCKappa([Res.Fz.FreqSpe.OB1.pval{:}]<alpha & [Res.Fz.FreqSpe.HPC1.pval{:}]<alpha));
bar(X,Y/sum(Y),'Facecolor',[1 0.8 0.2]), hold on
line([0 0],ylim,'color','k','linewidth',3)
xlim([-0.5 0.5]), box off
text(0.2,0.25,'OB pref')
text(-0.4,0.25,'HPC pref')
% Very basic figures
figure
alpha=0.05;
subplot(121)
JustOB=sum([Res.Fz.MiniMaxi.OB1.pval{:}]<alpha & [Res.Fz.MiniMaxi.HPC1.pval{:}]>alpha)./length([Res.Fz.MiniMaxi.HPC1.pval{:}]);
JustHPC=sum([Res.Fz.MiniMaxi.OB1.pval{:}]>alpha & [Res.Fz.MiniMaxi.HPC1.pval{:}]<alpha)./length([Res.Fz.MiniMaxi.HPC1.pval{:}]);
Both=sum([Res.Fz.MiniMaxi.OB1.pval{:}]<alpha & [Res.Fz.MiniMaxi.HPC1.pval{:}]<alpha)./length([Res.Fz.MiniMaxi.HPC1.pval{:}]);
None=sum([Res.Fz.MiniMaxi.OB1.pval{:}]>alpha & [Res.Fz.MiniMaxi.HPC1.pval{:}]>alpha)./length([Res.Fz.MiniMaxi.HPC1.pval{:}]);
pie([JustOB,JustHPC,Both,None],{'JustOB','JustHPC','Both','Neither'}), colormap hot
subplot(122)
AllOBKappa=[Res.Fz.MiniMaxi.OB1.kappa{:}];
AllHPCKappa=[Res.Fz.MiniMaxi.HPC1.kappa{:}];
[Y,X]=hist(AllOBKappa([Res.Fz.MiniMaxi.OB1.pval{:}]<alpha & [Res.Fz.MiniMaxi.HPC1.pval{:}]<alpha)-AllHPCKappa([Res.Fz.MiniMaxi.OB1.pval{:}]<alpha & [Res.Fz.MiniMaxi.HPC1.pval{:}]<alpha));
bar(X,Y/sum(Y),'Facecolor',[1 0.8 0.2]), hold on
line([0 0],ylim,'color','k','linewidth',3)
xlim([-0.7 0.7]), box off
text(0.2,0.25,'OB pref')
text(-0.4,0.25,'HPC pref')

% Very basic figures
figure
alpha=0.05;
subplot(121)
JustOB=sum([Res.NoFz.MiniMaxi.OB1.pval{:}]<alpha & [Res.NoFz.MiniMaxi.HPC1.pval{:}]>alpha)./length([Res.NoFz.MiniMaxi.HPC1.pval{:}]);
JustHPC=sum([Res.NoFz.MiniMaxi.OB1.pval{:}]>alpha & [Res.NoFz.MiniMaxi.HPC1.pval{:}]<alpha)./length([Res.NoFz.MiniMaxi.HPC1.pval{:}]);
Both=sum([Res.NoFz.MiniMaxi.OB1.pval{:}]<alpha & [Res.NoFz.MiniMaxi.HPC1.pval{:}]<alpha)./length([Res.NoFz.MiniMaxi.HPC1.pval{:}]);
None=sum([Res.NoFz.MiniMaxi.OB1.pval{:}]>alpha & [Res.NoFz.MiniMaxi.HPC1.pval{:}]>alpha)./length([Res.NoFz.MiniMaxi.HPC1.pval{:}]);
pie([JustOB,JustHPC,Both,None],{'JustOB','JustHPC','Both','Neither'}), colormap hot
subplot(122)
AllOBKappa=[Res.NoFz.MiniMaxi.OB1.kappa{:}];
AllHPCKappa=[Res.NoFz.MiniMaxi.HPC1.kappa{:}];
[Y,X]=hist(AllOBKappa([Res.NoFz.MiniMaxi.OB1.pval{:}]<alpha & [Res.NoFz.MiniMaxi.HPC1.pval{:}]<alpha)-AllHPCKappa([Res.NoFz.MiniMaxi.OB1.pval{:}]<alpha & [Res.NoFz.MiniMaxi.HPC1.pval{:}]<alpha));
bar(X,Y/sum(Y),'Facecolor',[1 0.8 0.2]), hold on
line([0 0],ylim,'color','k','linewidth',3)
xlim([-0.7 0.7]), box off
text(0.2,0.25,'OB pref')
text(-0.4,0.25,'HPC pref')


figure
AllOBPhase=[Res.Fz.FreqSpe.OB1.mu{:}];
AllHPCPhase=[Res.Fz.FreqSpe.HPC1.mu{:}];
subplot(311)
[Y,X]=hist(AllOBPhase([Res.Fz.FreqSpe.OB1.pval{:}]<alpha & [Res.Fz.FreqSpe.HPC1.pval{:}]>alpha),10);
stairs([X,X+2*pi],[Y/sum(Y),Y/sum(Y)],'k','linewidth',3)
xlim([0 4*pi])
subplot(312)
[Y,X]=hist(AllHPCPhase([Res.Fz.FreqSpe.OB1.pval{:}]>alpha & [Res.Fz.FreqSpe.HPC1.pval{:}]<alpha),10);
stairs([X,X+2*pi],[Y/sum(Y),Y/sum(Y)],'r','linewidth',3)
xlim([0 4*pi])
subplot(313)
[Y,X]=hist(AllHPCPhase([Res.Fz.FreqSpe.OB1.pval{:}]<alpha & [Res.Fz.FreqSpe.HPC1.pval{:}]<alpha),10);
stairs([X,X+2*pi],[Y/sum(Y),Y/sum(Y)],'r','linewidth',3),hold on
[Y,X]=hist(AllOBPhase([Res.Fz.FreqSpe.OB1.pval{:}]<alpha & [Res.Fz.FreqSpe.HPC1.pval{:}]<alpha),10);
stairs([X,X+2*pi],[Y/sum(Y),Y/sum(Y)],'k','linewidth',3),hold on
xlim([0 4*pi])

FieldNames={'OB1','OB2','OBLoc','HPC1','HPC2','HPCLoc','PFCx'};
close all
A=[0.05,0.01,0.001,0.0001];
for alpha=A

clear Sig
% Bulb
Sig.MiniMaxi.OB1=[];Sig.MiniMaxi.OB2=[];Sig.MiniMaxi.OBLoc=[];
Sig.FreqSpe.OB1=[];Sig.FreqSpe.OB2=[];Sig.FreqSpe.OBLoc=[];
Sig.AllFreq.OB1=[];Sig.AllFreq.OBLoc=[];
for k=1:length(Res.Fz.MiniMaxi.OB2.kappa)
    if not(isempty(Res.Fz.MiniMaxi.OB2.kappa{k}))
        Sig.MiniMaxi.OB1=[Sig.MiniMaxi.OB1,Res.Fz.MiniMaxi.OB1.pval{k}<alpha];
        Sig.MiniMaxi.OB2=[Sig.MiniMaxi.OB2,Res.Fz.MiniMaxi.OB2.pval{k}<alpha];
        Sig.MiniMaxi.OBLoc=[Sig.MiniMaxi.OBLoc,Res.Fz.MiniMaxi.OBLoc.pval{k}<alpha];
        Sig.FreqSpe.OB1=[Sig.FreqSpe.OB1,Res.Fz.FreqSpe.OB1.pval{k}<alpha];
        Sig.FreqSpe.OB2=[Sig.FreqSpe.OB2,Res.Fz.FreqSpe.OB2.pval{k}<alpha];
        Sig.FreqSpe.OBLoc=[Sig.FreqSpe.OBLoc,Res.Fz.FreqSpe.OBLoc.pval{k}<alpha];
        Sig.AllFreq.OB1=[Sig.AllFreq.OB1;Res.Fz.AllFreq.OB1.pval{k}<alpha];
        Sig.AllFreq.OBLoc=[Sig.AllFreq.OBLoc;Res.Fz.AllFreq.OBLoc.pval{k}<alpha];
    end
end
    
% HPC
Sig.MiniMaxi.HPC1=[];Sig.MiniMaxi.HPC2=[];Sig.MiniMaxi.HPCLoc=[];
Sig.FreqSpe.HPC1=[];Sig.FreqSpe.HPC2=[];Sig.FreqSpe.HPCLoc=[];
Sig.AllFreq.HPC1=[];Sig.AllFreq.HPCLoc=[];
for k=1:length(Res.Fz.MiniMaxi.HPC2.kappa)
    if not(isempty(Res.Fz.MiniMaxi.HPC2.kappa{k}))
        k
        Sig.MiniMaxi.HPC1=[Sig.MiniMaxi.HPC1,Res.Fz.MiniMaxi.HPC1.pval{k}<alpha];
        Sig.MiniMaxi.HPC2=[Sig.MiniMaxi.HPC2,Res.Fz.MiniMaxi.HPC2.pval{k}<alpha];
        Sig.MiniMaxi.HPCLoc=[Sig.MiniMaxi.HPCLoc,Res.Fz.MiniMaxi.HPCLoc.pval{k}<alpha];
        Sig.FreqSpe.HPC1=[Sig.FreqSpe.HPC1,Res.Fz.FreqSpe.HPC1.pval{k}<alpha];
        Sig.FreqSpe.HPC2=[Sig.FreqSpe.HPC2,Res.Fz.FreqSpe.HPC2.pval{k}<alpha];
        Sig.FreqSpe.HPCLoc=[Sig.FreqSpe.HPCLoc,Res.Fz.FreqSpe.HPCLoc.pval{k}<alpha];
        Sig.AllFreq.HPC1=[Sig.AllFreq.HPC1;Res.Fz.AllFreq.HPC1.pval{k}<alpha];
        Sig.AllFreq.HPCLoc=[Sig.AllFreq.HPCLoc;Res.Fz.AllFreq.HPCLoc.pval{k}<alpha];
    end
end

fig=figure('name',num2str(alpha));
subplot(211)
bar(1,100*sum((Sig.MiniMaxi.HPC1+Sig.MiniMaxi.HPC2)>0)/length(Sig.MiniMaxi.HPC1),'r'), hold on
bar(2,100*sum(Sig.MiniMaxi.HPCLoc)/length(Sig.MiniMaxi.HPCLoc)), hold on
bar(4,100*sum((Sig.FreqSpe.HPC1+Sig.FreqSpe.HPC2)>0)/length(Sig.FreqSpe.HPC1),'r'), hold on
bar(5,100*sum(Sig.FreqSpe.HPCLoc)/length(Sig.FreqSpe.HPCLoc)), hold on
ylim([0 70]), box off
set(gca,'XTick',[1,2,4,5],'XTickLabel',{'NonLoc','Loc','NonLoc','Loc'})
text(1,60,'Belluscio method')
text(4,60,'Filtering')
title(['HPC n=' num2str(length(Sig.FreqSpe.HPC2)) ' units']), ylabel('% Mod neurons')
subplot(212)
bar(1,100*sum((Sig.MiniMaxi.OB1+Sig.MiniMaxi.OB2)>0)/length(Sig.MiniMaxi.OB1),'r'), hold on
bar(2,100*sum(Sig.MiniMaxi.OBLoc)/length(Sig.MiniMaxi.OBLoc)), hold on
bar(4,100*sum((Sig.FreqSpe.OB1+Sig.FreqSpe.OB2)>0)/length(Sig.FreqSpe.OB1),'r'), hold on
bar(5,100*sum(Sig.FreqSpe.OBLoc)/length(Sig.FreqSpe.OBLoc)), hold on
ylim([0 70]),box off
set(gca,'XTick',[1,2,4,5],'XTickLabel',{'NonLoc','Loc','NonLoc','Loc'})
text(1,60,'Belluscio method')
text(4,60,'Filtering')
title('OB'),title(['OB n=' num2str(length(Sig.FreqSpe.OB2)) ' units']), ylabel('% Mod neurons')
saveas(fig,['SpeFreq' num2str(alpha) '.png'])
saveas(fig,['SpeFreq' num2str(alpha) '.fig'])
close all
fig=figure('name',num2str(alpha));
smoonum=1;
subplot(211)
hold on
plot(mean(FreqRange),100*runmean(sum(Sig.AllFreq.HPC1)./length(Sig.AllFreq.HPC1),smoonum),'r','linewidth',2)
plot(mean(FreqRange),100*runmean(sum(Sig.AllFreq.HPCLoc)./length(Sig.AllFreq.HPCLoc),smoonum),'b','linewidth',2)
legend({'NonLoc','Loc'})
title(['HPC n=' num2str(length(Sig.FreqSpe.HPC2)) ' units']), ylabel('% Mod neurons')
xlim([2 13])
xlabel('Frequency (Hz)')
subplot(212)
hold on
plot(mean(FreqRange),100*runmean(sum(Sig.AllFreq.OB1)./length(Sig.AllFreq.OB1),smoonum),'r','linewidth',2)
plot(mean(FreqRange),100*runmean(sum(Sig.AllFreq.OBLoc)./length(Sig.AllFreq.OBLoc),smoonum),'b','linewidth',2)
legend({'NonLoc','Loc'})
title(['OB n=' num2str(length(Sig.FreqSpe.OB2)) ' units']), ylabel('% Mod neurons')
xlim([2 13])
xlabel('Frequency (Hz)')
saveas(fig,['AllFreq' num2str(alpha) '.png'])
saveas(fig,['AllFreq' num2str(alpha) '.fig'])
close all

end