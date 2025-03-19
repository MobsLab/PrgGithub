%% Look at results
%% figure
clear all
Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');
nbin = 30;
rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')
num=1;
for d = 1:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        switch Dir.ExpeInfo{d}{dd}.DrugInjected
            case 'METHIMAZOLE'
            otherwise
                
                if (exist('NeuronModulation/NeuronMod_Respi_ZeroCross_total_nonoise'))>0
                    clear Kappa pval
                    load(('NeuronModulation/NeuronMod_Respi_ZeroCross_total_nonoise'))
                    load('SleepSubstages.mat')
                    load('SpikeData.mat')
                    
                    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
                    if not(isempty(numNeurons))
                        MouseNum{num} = Dir.ExpeInfo{d}{1}.nmouse;
                        load('SleepScoring_Accelero.mat','tsdMovement')
                        Epoch{6} = and(thresholdIntervals(tsdMovement,1e7,'Direction','Below'),Epoch{5});
                        Epoch{7} = or(or(Epoch{5},Epoch{4}),Epoch{7});
                        load('BreathingInfo_ZeroCross.mat')

                        DRUG{num} = Dir.ExpeInfo{d}{dd}.DrugInjected;
                        for ep = 1:7
                            clear Kappa pval mu
                            for nn = 1:length(numNeurons)
                                Phasetsd = tsd(Range(Restrict(S{numNeurons(nn)},epoch)), PhasesSpikes.Transf{numNeurons(nn)});
                                
                                rmpath(genpath([dropbox, '/Kteam/PrgMatlab/FMAToolbox/General']));
                                rmpath(genpath([dropbox, '/Kteam/PrgMatlab/Fra/UtilsStats']));
                                [mu(nn),Kappa(nn), pval(nn), Rmean, delta, sigma,confDw,confUp] = CircularMean(Data(Restrict(Phasetsd,Epoch{ep})));
                                addpath(genpath([dropbox, '/Kteam/PrgMatlab/FMAToolbox/General']));
                                addpath(genpath([dropbox, '/Kteam/PrgMatlab/Fra/UtilsStats']));
                                
                                Ztemp(nn) = length(Data(Restrict(Phasetsd,Epoch{ep}))) * Rmean.^2;
                            end
                            
                            KAPPA{ep}{num} = Kappa;
                            PVAL{ep}{num} = pval;
                            MU{ep}{num} = mu;
                            Z{ep}{num} = Ztemp;
                            BreathFreq{ep}{num} = hist(Data(Restrict(Frequecytsd,Epoch{ep})),[0:0.5:15]);
                        end
                        
                                                
                    end
                    num = num+1;
                end
        end
    end
end

figure
for ep = 1:7
    hold on
    AllMu{ep} = [];
    AllZ{ep} = [];
    AllKappa{ep} = [];
    AllBreath{ep} = [];

    for m = 1:length(MU{ep})
        AllMu{ep} = [AllMu{ep},[MU{ep}{m}]];
        AllZ{ep} = [AllZ{ep},Z{ep}{m}];
        AllKappa{ep} = [AllKappa{ep},KAPPA{ep}{m}(PVAL{ep}{m}<0.05)];
        AllBreath{ep} = [AllBreath{ep};BreathFreq{ep}{m}./sum(BreathFreq{ep}{m})];
            
    end
end

cols = lines(6);
for k = 1:6
    COLS{k} = cols(k,:);
end
clf
subplot(2,3,1:2)
MakeSpreadAndBoxPlot_SB(AllKappa(1:6),COLS,[1:6],NameEpoch(1:6))
ylabel('Kappa')

subplot(2,3,3)
for k = 1:6
    [Y1,X1]=(hist(log(AllZ{k}),100));
    plot(X1,100*(1-cumsum(Y1)/sum(Y1)),'color',cols(k,:),'linewidth',2), hold on
    xlabel('ln(Z)')
    ylabel('Neurons %')
    box off
    
end
line([1 1],ylim,'color','k','linewidth',2 )
xlabel('ln(Z)')
xlim([0 7])
set(gca,'FontSize',20,'Linewidth',2)
legend(NameEpoch(1:6),'FontSize',12)

for k = 1:6
subplot(2,6,6+k)
    [Y1,X1]=hist(AllMu{k},20);
    stairs([X1,X1+2*pi],[Y1,Y1]/sum(Y1),'color',cols(k,:),'linewidth',2)
    xlim([0 4*pi])
    hold on
    title(NameEpoch{k})
    xlabel('Phase (rad)')
    set(gca,'FontSize',15,'Linewidth',2)
box off

end

figure

for k = 1:6
plot([0:0.5:15],nanmean(AllBreath{k}),'color',cols(k,:),'linewidth',2)
hold on
end
set(gca,'FontSize',20,'Linewidth',2)
box off
legend(NameEpoch(1:6),'FontSize',12)
xlabel('Frequency(Hz)')
ylabel('Counts norm')
title('Distribution Of Breathing Freq')


figure
for k = 1:5
    subplot(3,2,k)
    [Y1,X1]=hist(MU{6}{k},20);
    stairs([X1,X1+2*pi],[Y1,Y1]/sum(Y1),'color',cols(k,:),'linewidth',2)
    hold on
end
