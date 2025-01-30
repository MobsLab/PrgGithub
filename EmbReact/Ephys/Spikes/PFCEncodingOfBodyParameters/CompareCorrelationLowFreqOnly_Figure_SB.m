clear all
JustLowFreq = 1;
MiceNumber=[490,507,508,509,510,512,514];

load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis
Fz = load('PFCUnitFiringOnOBFrequency.mat');

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFC_Neurons_TwoTypesOfFreezing
NoFz = load('PFCUnitFiringOnOBFrequencyCorrLowFrequencies.mat');

FreqLimsFz=[2.5:0.15:6];
%% Just the sig units
GoodNeurFz = [];
PNeurFz = [];
RNeurFz = [];

GoodNeurNoFz = [];
PNeurNoFz = [];
RNeurNoFz = [];


for mm=1:length(MiceNumber)
    for sp=1:length(Fz.RSpk{mm})
        if IsPFCNeuron{mm}(sp)==1
            
            if Fz.RSpk{mm}(sp)>prctile(Fz.RSpk_btstrp{mm}(sp,:),97.5)
                GoodNeurFz = [GoodNeurFz,1];
            elseif Fz.RSpk{mm}(sp)<prctile(Fz.RSpk_btstrp{mm}(sp,:),2.5);
                GoodNeurFz = [GoodNeurFz,-1];
            else
                GoodNeurFz = [GoodNeurFz,0];
            end
            PNeurFz = [PNeurFz,Fz.PSpk{mm}(sp)];
            RNeurFz = [RNeurFz,Fz.RSpk{mm}(sp)];
            
            if NoFz.RSpk{mm}(sp)>prctile(NoFz.RSpk_btstrp{mm}(sp,:),97.5)
                GoodNeurNoFz = [GoodNeurNoFz,1];
            elseif NoFz.RSpk{mm}(sp)<prctile(NoFz.RSpk_btstrp{mm}(sp,:),2.5);
                GoodNeurNoFz = [GoodNeurNoFz,-1];
            else
                GoodNeurNoFz = [GoodNeurNoFz,0];
            end
            PNeurNoFz = [PNeurNoFz,NoFz.PSpk{mm}(sp)];
            RNeurNoFz = [RNeurNoFz,NoFz.RSpk{mm}(sp)];
            
            
            
            
        end
    end
end
TotNeur = length(PNeurNoFz);
subplot(121)
A = [sum(abs(GoodNeurFz)>0 & abs(GoodNeurNoFz)==0),sum(abs(GoodNeurFz)>0 & abs(GoodNeurNoFz)>0),...
    sum(abs(GoodNeurFz)==0 & abs(GoodNeurNoFz)>0),sum(abs(GoodNeurFz)==0 & abs(GoodNeurNoFz)==0)]/TotNeur;
h=pie(A,[0 0 0 0]);
set(h(1), 'FaceColor', 'b');
set(h(3), 'FaceColor', [0.4 0 0.4]);
set(h(5), 'FaceColor', 'r');
set(h(7), 'FaceColor', 'w');
legend('Fz','NoFz&Fz','NoFz','NoSig')
set(gca,'LineWidth',2,'FontSize',15), box off
subplot(122)
plot(RNeurFz,RNeurNoFz,'.','MarkerSize',20)
hold on
plot(RNeurFz(abs(GoodNeurFz)>0),RNeurNoFz(abs(GoodNeurFz)>0),'.','MarkerSize',20)
[R,P]=corrcoef(RNeurFz(abs(GoodNeurFz)>0),RNeurNoFz(abs(GoodNeurFz)>0));
title(['Corr: R=' num2str(R(1,2)) ' P=' num2str(P(1,2))])
set(gca,'LineWidth',2,'FontSize',15), box off
xlabel('R-Fz'), ylabel('R-NoFz')
ylim([-0.15 0.2])
xlim([-0.4 0.4])
