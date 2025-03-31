% This code generates pannels used in april draft
% It generates Fig4M
% Need to toggle file name for Montreal vs Paris

clear all
% Get directories
CtrlEphys=[244,243,253,254,258,259,299,394,395,402,403,450,451,248];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');


% Where to save
SaveFigFolder='/Users/sophiebagur/Dropbox/OB4Hz-manuscrit/FigTest/';
Date=date;
SaveFigFolder=[SaveFigFolder,Date,filesep];

% Get parameters
% Frequency bands to scan through
FreqRange=[1:12;[3:14]];
% Name of possible different structures
FieldNames={'OB1','OB2','OBLoc','HPC1','HPC2','HPCLoc','PFCx'};
% Freq bands specific to each area - only used for NM coupling
%Where to save things
FolderName='NeuronLFPCoupling';
% Parameters for triggered spectro
MouseNum=1;
TotNeurons=0;
KeepFirstSessionOnly=[1,5:length(Dir.path)];

for mm=KeepFirstSessionOnly
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

FieldNames={'OB1','OB2','OBLoc','HPC1','HPC2','HPCLoc','PFCx'};
close all
A=[0.05,0.01,0.001,0.0001,0.00001];
for a=1:length(A)
    alpha=A(a);
    
% HPC
Sig.MiniMaxi.HPC1=[];Sig.MiniMaxi.HPC2=[];Sig.MiniMaxi.HPCLoc=[];
Sig.FreqSpe.HPC1=[];Sig.FreqSpe.HPC2=[];Sig.FreqSpe.HPCLoc=[];
Sig.AllFreq.HPC1=[];Sig.AllFreq.HPCLoc=[];
NumNeur=0;
for k=1:length(Res.Fz.MiniMaxi.HPC2.kappa)
    if not(isempty(Res.Fz.MiniMaxi.HPC2.kappa{k}))
        k
        Sig.AllFreq.HPC1=[Sig.AllFreq.HPC1;sum(Res.Fz.AllFreq.HPC1.pval{k}<alpha)];
        Sig.AllFreq.HPCLoc=[Sig.AllFreq.HPCLoc;sum(Res.Fz.AllFreq.HPCLoc.pval{k}<alpha)];
        NumNeur=NumNeur+size(Res.Fz.AllFreq.HPC1.pval{k},1);
    end
end
HPC1Res(a,:)=sum(Sig.AllFreq.HPC1);
HPCLocRes(a,:)=sum(Sig.AllFreq.HPCLoc);
end


load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015/NeuronLFPCoupling/FzNeuronModFreqAllStructCorrected.mat')

fig=figure();
smoonum=1;
subplot(121)
patch([3 3 6 6],[0,80,80,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
hold on
subplot(122)
patch([3 3 6 6],[0,80,80,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
hold on
cols=paruly(length(A));
for a=1:length(A)
    subplot(121)
    plot(mean(FreqRange),100*runmean((HPC1Res(a,:))./NumNeur,smoonum),'color',cols(a,:),'linewidth',2), hold on
    subplot(122)
    plot(mean(FreqRange),100*runmean((HPCLocRes(a,:))./NumNeur,smoonum),'color',cols(a,:),'linewidth',2), hold on
end
subplot(121)
set(gca,'Layer','top')
box off,ylim([0 60]), xlim([2 13])
xlabel('Frequency (Hz)')
ylabel('Percent modulated neurons')
title('HPC sup')
legend('3-6HZ band','0.05','0.01','0.001','0.0001','0.00001')
set(gca,'FontSize',15)
subplot(122)
set(gca,'Layer','top')
box off,ylim([0 60]), xlim([2 13])
xlabel('Frequency (Hz)')
ylabel('Percent modulated neurons')
title('HPC local')
set(gca,'FontSize',15)