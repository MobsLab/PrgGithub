
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
            load('RespiEvokedPotentials/EvokedPotentialAcceleroBySubStage.mat')

%             clf
            for ep = 1:5
                [mat,ind] = sortrows([nanmean(EvokPotAcceleroAv{ep}(:,28:32)')',zscore(EvokPotAcceleroAv{ep}')']);
                AllTimes = Range(Restrict(Breathtsd,Epoch{ep}));
                SortedTimes = AllTimes(ind);
                
%                 subplot(5,4,(ep-1)*4+1)
%                 imagesc((mat(:,2:end)')'), clim([-3 3])
                TenPercNum = floor(size(mat,1)/10);
%                 line([1 1]*10,[1 TenPercNum],'linewidth',2,'color','b')
%                 line([1 1]*10,[(TenPercNum*4.5),floor(TenPercNum*5.5)],'linewidth',2,'color','g')
%                 line([1 1]*10,[size(mat,1)-TenPercNum size(mat,1)],'linewidth',2,'color','r')
                
                DownEp = intervalSet(sort(SortedTimes(1:TenPercNum))-0.5E4,sort(SortedTimes(1:TenPercNum)+0.5E4));
                UpEp = intervalSet(sort(SortedTimes(end-TenPercNum:end))-0.5E4,sort(SortedTimes(end-TenPercNum:end)+0.5E4));
                MidEp = intervalSet(sort(SortedTimes(floor(TenPercNum*4.5):floor(TenPercNum*5.5)))-0.5E4,...
                    sort(SortedTimes(floor(TenPercNum*4.5):floor(TenPercNum*5.5)))+0.5E4);
                MidEp = CleanUpEpoch(MidEp);MidEp = mergeCloseIntervals(MidEp,0.5E4);
                UpEp = CleanUpEpoch(UpEp);UpEp = mergeCloseIntervals(UpEp,0.5E4);
                DownEp = CleanUpEpoch(DownEp);DownEp = mergeCloseIntervals(DownEp,0.5E4);
                
                EvokOB = tsd(AllTimes,EvokPotAcceleroAv{ep});
                
%                 subplot(5,4,(ep-1)*4+2)
%                 plot(nanmean(Data(Restrict(EvokOB,UpEp))),'r','linewidth',2)
%                 hold on
%                 plot(nanmean(Data(Restrict(EvokOB,MidEp))),'g','linewidth',2)
%                 plot(nanmean(Data(Restrict(EvokOB,DownEp))),'b','linewidth',2)
%                 legend('Up','Mid','Down')
                
                
                for unitnum = 1:length(numNeurons)
                    unitnum
                    Phasetsd = tsd(Range(Restrict(S{numNeurons(unitnum)},epoch)), PhasesSpikes.Transf{numNeurons(unitnum)});
                    
                    [mu_All{ep}(unitnum), Kappa_All{ep}(unitnum), pval_All{ep}(unitnum)] = CircularMean(Data(Restrict(Phasetsd,Epoch{ep})));
                    [mu_Down{ep}(unitnum), Kappa_Down{ep}(unitnum), pval_Down{ep}(unitnum)] = CircularMean(Data(Restrict(Phasetsd,DownEp)));
                    [mu_Up{ep}(unitnum), Kappa_Up{ep}(unitnum), pval_Up{ep}(unitnum)] = CircularMean(Data(Restrict(Phasetsd,UpEp)));
                    [mu_Mid{ep}(unitnum), Kappa_Mid{ep}(unitnum), pval_Mid{ep}(unitnum)] = CircularMean(Data(Restrict(Phasetsd,MidEp)));
                    
                end
%                 subplot(5,4,(ep-1)*4+3)
%                 PlotErrorBarN_KJ([Kappa_Up{ep}(pval_All{ep}<0.05);Kappa_Mid{ep}(pval_All{ep}<0.05);Kappa_Down{ep}(pval_All{ep}<0.05)]','newfig',0)
%                 set(gca,'XTick',[1:3],'XTickLabel',{'Up','Mid','Down'})
%                 
%                 subplot(5,4,(ep-1)*4+4)
%                 plot(Kappa_Up{ep}(pval_All{ep}<0.05),Kappa_Down{ep}(pval_All{ep}<0.05),'b*')
%                 hold on
%                 plot(Kappa_Up{ep}(pval_All{ep}<0.05),Kappa_Mid{ep}(pval_All{ep}<0.05),'m*')
%                 line([0 0.35],[0 0.35],'color','k')
%                 xlabel('Kappa Up')
%                 ylabel('Kappa Down or mid')
%                 %legend('Down','Mid')
%                 axis square
%                 xlim([0 0.35])
%                 ylim([0 0.35])
                
                
                
            end
            
%            saveas(fig,['/home/vador/Dropbox/Mobs_member/SophieBagur/Figures/MTZLmice/NeuronModulation/SleepSession/EffectOfAccResponseToBreathingOnNeuronLocking_',num2str(Dir.ExpeInfo{d}{dd}.nmouse),'_',num2str(Dir.ExpeInfo{d}{dd}.date),'.png'])
%            saveas(fig,['/home/vador/Dropbox/Mobs_member/SophieBagur/Figures/MTZLmice/NeuronModulation/SleepSession/EffectOfAccResponseToBreathingOnNeuronLocking_',num2str(Dir.ExpeInfo{d}{dd}.nmouse),'_',num2str(Dir.ExpeInfo{d}{dd}.date),'.fig'])
        save('NeuronModulation/EffectOfAccResponseToBreathingOnNeuronLocking.mat','mu_All','mu_Mid','mu_Up','mu_Down',...
                'pval_All','pval_Mid','pval_Up','pval_Down','Kappa_All','Kappa_Mid','Kappa_Down','Kappa_Up')
            
            Results_AllMice{num}.mu_All = mu_All; clear mu_All
            Results_AllMice{num}.mu_Mid = mu_Mid; clear mu_Mid
            Results_AllMice{num}.mu_Up = mu_Up; clear mu_Up
            Results_AllMice{num}.mu_Down = mu_Down; clear mu_Down
            
            Results_AllMice{num}.pval_All = pval_All; clear pval_All
            Results_AllMice{num}.pval_Mid = pval_Mid; clear pval_Mid
            Results_AllMice{num}.pval_Up = pval_Up; clear pval_Up
            Results_AllMice{num}.pval_Down = pval_Down; clear pval_Down
            
            Results_AllMice{num}.Kappa_All = Kappa_All; clear Kappa_All
            Results_AllMice{num}.Kappa_Mid = Kappa_Mid; clear Kappa_Mid
            Results_AllMice{num}.Kappa_Up = Kappa_Up; clear Kappa_Up
                        Results_AllMice{num}.Kappa_Down = Kappa_Down; clear Kappa_Down

            num = num+1;
        end
    end
end


%%%
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

        load('NeuronModulation/EffectOfAccResponseToBreathingOnNeuronLocking.mat')
            
            Results_AllMice{num}.mu_All = mu_All; clear mu_All
            Results_AllMice{num}.mu_Mid = mu_Mid; clear mu_Mid
            Results_AllMice{num}.mu_Up = mu_Up; clear mu_Up
            Results_AllMice{num}.mu_Down = mu_Down; clear mu_Down
            
            Results_AllMice{num}.pval_All = pval_All; clear pval_All
            Results_AllMice{num}.pval_Mid = pval_Mid; clear pval_Mid
            Results_AllMice{num}.pval_Up = pval_Up; clear pval_Up
            Results_AllMice{num}.pval_Down = pval_Down; clear pval_Down
            
            Results_AllMice{num}.Kappa_All = Kappa_All; clear Kappa_All
            Results_AllMice{num}.Kappa_Mid = Kappa_Mid; clear Kappa_Mid
            Results_AllMice{num}.Kappa_Down = Kappa_Down; clear Kappa_Down
            Results_AllMice{num}.Kappa_Up = Kappa_Up; clear Kappa_Up
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
        AllKappa.(DRUG{mm}) = [AllKappa.(DRUG{mm}), [Results_AllMice{mm}.Kappa_All{ep};Results_AllMice{mm}.Kappa_Up{ep};Results_AllMice{mm}.Kappa_Mid{ep};Results_AllMice{mm}.Kappa_Down{ep}]];
        Allpval.(DRUG{mm}) = [Allpval.(DRUG{mm}), [Results_AllMice{mm}.pval_All{ep};Results_AllMice{mm}.pval_Up{ep};Results_AllMice{mm}.pval_Mid{ep};Results_AllMice{mm}.pval_Down{ep}]];
    end
    
    subplot(5,3,(ep-1)*3+1)
    PlotErrorBarN_KJ(AllKappa.SALINE(2:4,Allpval.SALINE(1,:)<0.05)','newfig',0,'showPoints',0)
    set(gca,'XTick',[1:3],'XTickLabel',{'Up','Mid','Down'})
    title(NameEpoch{ep})
    ylabel('Kappa - SALINE')
    subplot(5,3,(ep-1)*3+2)
    PlotErrorBarN_KJ(AllKappa.METHIMAZOLE(2:4,Allpval.METHIMAZOLE(1,:)<0.05)','newfig',0,'showPoints',0)
    set(gca,'XTick',[1:3],'XTickLabel',{'Up','Mid','Down'})
    ylabel('Kappa - MTZL')
    
    subplot(5,3,(ep-1)*3+3)
    bar(1:3,nanmean(Allpval.SALINE(2:4,:)'<0.05),'b'), hold on
    bar(5:7,nanmean(Allpval.METHIMAZOLE(2:4,:)'<0.05),'r')
    set(gca,'XTick',[1:3,5:7],'XTickLabel',{'Up','Mid','Down','Up','Mid','Down'})
    ylabel('Prop Mod units')
    ylim([0 1])
    
    
end




