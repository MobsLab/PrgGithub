Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');
% si tu veux savoir si c'est MTZL ou saline, il faut regarder 

%pour calculer pour une époque donnée (N1, N2, N3) sur un jour exemple

n=4;
cd(Dir.path{n}{1})
Dir.ExpeInfo{n}{1}.DrugInjected

[numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
load('SpikeData.mat')

% loader la modualtion par le bulbe ou la repsi
load('NeuronModulation/NeuronMod_Bulb_deep_Filt_0.1-15Hz_total_nonoise.mat')
phBulb=PhasesSpikes.Transf;
% load('NeuronModulation/NeuronMod_Respi_Filt_0.1-15Hz_total_nonoise.mat')
load('NeuronModulation/NeuronMod_Respi_ZeroCross_total_nonoise.mat')
phRespi=PhasesSpikes.Transf;
 
NoiseToRemov = epoch;
% là dedans il y a PhasesSpikes.Transf qui est des cellules avec les phases
% de tous les neurones

load('SleepSubstages.mat')

for ep = 1:5
for unitnum = 1:length(numNeurons)
    unitnum;
    PhasetsdRespi = tsd(Range(Restrict(S{numNeurons(unitnum)},NoiseToRemov)), phRespi{numNeurons(unitnum)});
    PhasetsdBulb = tsd(Range(Restrict(S{numNeurons(unitnum)},NoiseToRemov)), phBulb{numNeurons(unitnum)});    
    [mu_AllRespi{ep}(unitnum), Kappa_AllRespi{ep}(unitnum), pval_AllRespi{ep}(unitnum)] = CircularMean(Data(Restrict(PhasetsdRespi,Epoch{ep})));
    [mu_AllBulb{ep}(unitnum), Kappa_AllBulb{ep}(unitnum), pval_AllBulb{ep}(unitnum)] = CircularMean(Data(Restrict(PhasetsdBulb,Epoch{ep})));    
end
end 






clear h
for i=1:length(numNeurons)
    
    Phasetsd = tsd(Range(Restrict(S{numNeurons(i)},NoiseToRemov)), PhasesSpikes.Transf{numNeurons(i)});
    [h1(i,:),b]=hist(Data(Restrict(Phasetsd,Epoch{1})),[0:0.2:2*pi]);
    [h2(i,:),b]=hist(Data(Restrict(Phasetsd,Epoch{2})),[0:0.2:2*pi]);
    [h3(i,:),b]=hist(Data(Restrict(Phasetsd,Epoch{3})),[0:0.2:2*pi]);
    [h4(i,:),b]=hist(Data(Restrict(Phasetsd,Epoch{4})),[0:0.2:2*pi]);
    [h5(i,:),b]=hist(Data(Restrict(Phasetsd,Epoch{5})),[0:0.2:2*pi]);
    
end

figure, 
subplot(5,1,1), imagesc(SmoothDec(zscore(h1(:,2:end-1)')',[0.01 0.7]))
subplot(5,1,2), imagesc(SmoothDec(zscore(h2(:,2:end-1)')',[0.01 0.7]))
subplot(5,1,3), imagesc(SmoothDec(zscore(h3(:,2:end-1)')',[0.01 0.7]))
subplot(5,1,4), imagesc(SmoothDec(zscore(h4(:,2:end-1)')',[0.01 0.7]))
subplot(5,1,5), imagesc(SmoothDec(zscore(h5(:,2:end-1)')',[0.01 0.7]))

figure, 
for i=1:5
    for j=1:5
    if i==j
    [htemp,btemp]=hist(mu_AllRespi{i},[0:0.6:2*pi]);
     subplot(5,5,MatXY(i,j,5)), hold on,   bar([0:0.6:2*pi]+2*pi,htemp,1,'k'),
     bar([0:0.6:2*pi],htemp,1,'k'),xlabel(NameEpoch{i}),ylabel(NameEpoch{j}), title('Respi')
    else
    hold on,
    subplot(5,5,MatXY(i,j,5)), hold on, 
    plot(mu_AllRespi{i},mu_AllRespi{j},'ko','markerfacecolor','k')
    plot(mu_AllRespi{i}+2*pi,mu_AllRespi{j},'ko','markerfacecolor','k')
    plot(mu_AllRespi{i},mu_AllRespi{j}+2*pi,'ko','markerfacecolor','k')
    plot(mu_AllRespi{i}+2*pi,mu_AllRespi{j}+2*pi,'ko','markerfacecolor','k'), xlim([0 4*pi]), ylim([0 4*pi]), xlabel(NameEpoch{i}),ylabel(NameEpoch{j}),
    hold on, line([0 4*pi],[0 4*pi],'color','r'),line([0 2*pi],[2*pi 4*pi],'color','r'), line([2*pi 4*pi],[0 2*pi],'color','r')
    end
    end
end

figure, 
for i=1:5
    for j=1:5
    if i==j
    [htemp,btemp]=hist(mu_AllBulb{i},[0:0.6:2*pi]);
     subplot(5,5,MatXY(i,j,5)), hold on,   bar([0:0.6:2*pi]+2*pi,htemp,1,'k'),
     bar([0:0.6:2*pi],htemp,1,'k'),xlabel(NameEpoch{i}),ylabel(NameEpoch{j}), title('Bulb')
    else
    hold on,
    subplot(5,5,MatXY(i,j,5)), hold on, 
    plot(mu_AllBulb{i},mu_AllBulb{j},'ko','markerfacecolor','k')
    plot(mu_AllBulb{i}+2*pi,mu_AllBulb{j},'ko','markerfacecolor','k')
    plot(mu_AllBulb{i},mu_AllBulb{j}+2*pi,'ko','markerfacecolor','k')
    plot(mu_AllBulb{i}+2*pi,mu_AllBulb{j}+2*pi,'ko','markerfacecolor','k'), xlim([0 4*pi]), ylim([0 4*pi]), xlabel(NameEpoch{i}),ylabel(NameEpoch{j}),
    hold on, line([0 4*pi],[0 4*pi],'color','r'),line([0 2*pi],[2*pi 4*pi],'color','r'), line([2*pi 4*pi],[0 2*pi],'color','r')
    end
    end
end



figure, 
for i=1:5
    subplot(3,5,i), hold on, 
    plot(mu_AllRespi{i},mu_AllBulb{i},'ko','markerfacecolor','k')
    plot(mu_AllRespi{i}+2*pi,mu_AllBulb{i},'ko','markerfacecolor','k')
    plot(mu_AllRespi{i},mu_AllBulb{i}+2*pi,'ko','markerfacecolor','k')
    plot(mu_AllRespi{i}+2*pi,mu_AllBulb{i}+2*pi,'ko','markerfacecolor','k'), xlim([0 4*pi]), ylim([0 4*pi]), title(NameEpoch{i})
    hold on, line([0 4*pi],[0 4*pi],'color','r'),line([0 2*pi],[2*pi 4*pi],'color','r'), line([2*pi 4*pi],[0 2*pi],'color','r')
end
for i=1:5
subplot(3,5,i+5), hold on, 
   plot(Kappa_AllRespi{i},Kappa_AllBulb{i},'ko','markerfacecolor','k'), line(xlim,ylim,'color','r'), title(NameEpoch{i})
end
for i=1:5
subplot(3,5,i+10), hold on, 
   plot(pval_AllRespi{i},pval_AllBulb{i},'ko','markerfacecolor','k'), line(xlim,ylim,'color','r'), title(NameEpoch{i})
end
