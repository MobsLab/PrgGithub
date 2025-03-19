%%
%% figure
clear all
Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');
nbin = 30;
rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')
num=1;
fig = figure;
clf
for d = 1:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
        
        if (exist('NeuronModulation/NeuronMod_Respi_ZeroCross_total_nonoise'))>0 & isempty(numNeurons)==0
            clear Kappa pval
            disp(Dir.path{d}{dd})
            
            
            load('SpikeData.mat')
            load('NeuronModulation/NeuronMod_Respi_ZeroCross_total_nonoise.mat')
            load(['ChannelsToAnalyse/Bulb_deep.mat']); chOB = channel;
            load(['ChannelsToAnalyse/Respi.mat']); chRespi = channel;
            
            clear C f t
            try
                load(['CohgramcDataL/Cohgram_',num2str(chRespi),'_',num2str(chOB),'.mat'])
            catch
                load(['CohgramcDataL/Cohgram_',num2str(chOB),'_',num2str(chRespi),'.mat'])
            end
            freq = f;
            Ctsd = tsd(t*1e4,nanmean(C(:,1:70)')');
            Cohtsd = tsd(t*1e4,C);
            load('SleepSubstages.mat')

            clf
            for ep = 1:5
                
                Ctsd_Res = Restrict(Ctsd, Epoch{ep});
                for pp = 1:4
                    if pp>1
                        CohEp1 = thresholdIntervals(Ctsd_Res,prctile(Data(Ctsd_Res),25*(pp-1)),'Direction','Above');
                    else
                        CohEp1 = Epoch{ep};
                    end
                    if pp<4
                        CohEp2 = thresholdIntervals(Ctsd_Res,prctile(Data(Ctsd_Res),25*(pp)),'Direction','Below');
                    else
                        CohEp2 = Epoch{ep};
                    end
                    CohEp = and(CohEp1,CohEp2);
                    
                    
                    subplot(5,2,(ep-1)*2+1)
                    plot(freq,nanmean(Data(Restrict(Cohtsd,CohEp))),'linewidth',2)
                    hold on
                    
                    
                    for unitnum = 1:length(numNeurons)
                        unitnum
                        Phasetsd = tsd(Range(Restrict(S{numNeurons(unitnum)},epoch)), PhasesSpikes.Transf{numNeurons(unitnum)});
                        [mu_Coh{ep}{pp}(unitnum), Kappa_Coh{ep}{pp}(unitnum), pval_Coh{ep}{pp}(unitnum)] = CircularMean(Data(Restrict(Phasetsd,and(Epoch{ep},CohEp))));
                        [mu_All{ep}{pp}(unitnum), Kappa_All{ep}{pp}(unitnum), pval_All{ep}{pp}(unitnum)] = CircularMean(Data(Restrict(Phasetsd,Epoch{ep})));
                    end
                    
                end
                
                subplot(5,2,(ep-1)*2+2)
                PlotErrorBarN_KJ({Kappa_Coh{ep}{1}(pval_All{ep}{1}<0.05),Kappa_Coh{ep}{2}(pval_All{ep}{2}<0.05),Kappa_Coh{ep}{3}(pval_All{ep}{3}<0.05),Kappa_Coh{ep}{4}(pval_All{ep}{4}<0.05)}','newfig',0,'paired',0)
                set(gca,'XTick',[1:4],'XTickLabel',{'Low','Mid1','Mid2','High'})
                
                
                
            end
            
            
            saveas(fig,[dropbox '/Mobs_member/SophieBagur/Figures/MTZLmice/NeuronModulation/SleepSession/EffectOfOBREspiCohToBreathingOnNeuronLocking_',num2str(Dir.ExpeInfo{d}{dd}.nmouse),'_',num2str(Dir.ExpeInfo{d}{dd}.date),'.png'])
            saveas(fig,[dropbox '/Mobs_member/SophieBagur/Figures/MTZLmice/NeuronModulation/SleepSession/EffectOfOBREspiCohToBreathingOnNeuronLocking_',num2str(Dir.ExpeInfo{d}{dd}.nmouse),'_',num2str(Dir.ExpeInfo{d}{dd}.date),'.fig'])
            save('NeuronModulation/EffectOfOBRespiCohOnNeuronLocking.mat','mu_Coh','Kappa_Coh', 'pval_Coh')
            
            Results_AllMice{num}.mu_Coh = mu_Coh; clear mu_Coh;
            Results_AllMice{num}.mu_All = mu_All; clear mu_All
            
            Results_AllMice{num}.pval_Coh = pval_Coh; clear pval_Coh
            Results_AllMice{num}.pval_All = pval_All; clear pval_All
            
            Results_AllMice{num}.Kappa_Coh = Kappa_Coh; clear Kappa_Coh
            Results_AllMice{num}.Kappa_All = Kappa_All; clear Kappa_All

            num = num+1;
        end
    end
end


num=1;
for d = 1:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
        
        if (exist('NeuronModulation/NeuronMod_Respi_ZeroCross_total_nonoise'))>0 & isempty(numNeurons)==0
            clear Kappa pval
            disp(Dir.path{d}{dd})
            DRUG{num} = Dir.ExpeInfo{d}{dd}.DrugInjected;
            num = num+1;
        end
    end
end

DRUG{1} = 'SALINE';
DRUG{2} = 'SALINE';

figure
clf
load('SleepSubstages.mat')
for ep=1:5
    
    AllKappa.METHIMAZOLE=[];
    AllKappa.SALINE=[];
    Allpval.SALINE=[];
    Allpval.METHIMAZOLE=[];
    
    for mm = 1:num-1
        AllKappa.(DRUG{mm}) = [AllKappa.(DRUG{mm}), [Results_AllMice{mm}.Kappa_All{ep}{1};Results_AllMice{mm}.Kappa_Coh{ep}{1};Results_AllMice{mm}.Kappa_Coh{ep}{2};Results_AllMice{mm}.Kappa_Coh{ep}{3};Results_AllMice{mm}.Kappa_Coh{ep}{4}]];
        Allpval.(DRUG{mm}) = [Allpval.(DRUG{mm}), [Results_AllMice{mm}.pval_All{ep}{1};Results_AllMice{mm}.pval_Coh{ep}{1};Results_AllMice{mm}.pval_Coh{ep}{2};Results_AllMice{mm}.pval_Coh{ep}{3};Results_AllMice{mm}.pval_Coh{ep}{4}]];
    end
    
    subplot(5,3,(ep-1)*3+1)
    PlotErrorBarN_KJ(AllKappa.SALINE(2:5,Allpval.SALINE(1,:)<0.05)','newfig',0,'showPoints',0)
    set(gca,'XTick',[1:4],'XTickLabel',{'Low','Mid1','Mid2','High'})
    title(NameEpoch{ep})
    ylabel('Kappa - SALINE')
    subplot(5,3,(ep-1)*3+2)
    PlotErrorBarN_KJ(AllKappa.METHIMAZOLE(2:5,Allpval.METHIMAZOLE(1,:)<0.05)','newfig',0,'showPoints',0)
    set(gca,'XTick',[1:4],'XTickLabel',{'Low','Mid1','Mid2','High'})
    ylabel('Kappa - MTZL')
    
    subplot(5,3,(ep-1)*3+3)
    bar(1:4,nanmean(Allpval.SALINE(2:5,:)'<0.05),'b'), hold on
    bar(6:9,nanmean(Allpval.METHIMAZOLE(2:5,:)'<0.05),'r')
    set(gca,'XTick',[1:4,6:9],'XTickLabel',{'Low','Mid1','Mid2','High'})
    ylabel('Prop Mod units')
    ylim([0 1])
    
    
end




