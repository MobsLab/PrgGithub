function ModulationPFCneuronsByBulb_GL(FreqRange,lim2,lim3, varargin)

clear numNeurons Modul modulatedNeurons
sig=0.05;

%FreqRange=[2 4]; % for example 

% parameter
Kth=0.06; % threshold for Kappa
pthres=0.05; % threshold for significance

% default values if strongperonly=0, modified if strongperonly=1
criterion=NaN;
PercTimeval=100;

% default values for varargin
strongperonly=0;
suffix='';

% for titles
BandFq=[num2str(FreqRange(1)), '-' ,num2str(FreqRange(2))];

% File creation
if ~isdir('SpikeModulationBulb');
    mkdir('SpikeModulationBulb');
end

%% Load spike and LFP data
res=pwd;
load([res,'/ChannelsToAnalyse/Bulb_deep']);
load([res,'/LFPData/LFP',num2str(channel)])

load SpikeData
[Spk_PFCx,NumNeurons]=GetSpikesFromStructure('PFCx');

%% Load Epoch (SWS and freezing if needed)

load StateEpochSB SWSEpoch

try
    load behavResources FreezeEpoch
    FreezingTime=sum(End(FreezeEpoch)-Start(FreezeEpoch));
        
    % get LFP Bulb
    if strongperonly==1
        lim1=FreqRange;
        criterion=9;
        load([res,'/SpectrumDataL/Spectrum',num2str(channel)]);
        [StrongOscAndFreezeEpoch,PercTimeval,val2]=FindStrongOsc(Sp,t,f,FreezeEpoch,1,lim1, lim2,lim3);% plo=1
        PercTimeval=PercTimeval(criterion);
    end
catch
    disp('no freezing period analysed ... ')
end



%% PFC Spike modulation by Bulb during SWS
fil=FilterLFP(LFP,FreqRange,2048);

hfigMod=figure('Position',[100 20 1800 900]);
a=1;
for i=1:length(NumNeurons)
    % build the plot
    subplot(6,8,i);
    [ph,mu, Kappa, pval,B,C]=ModulationTheta(S{NumNeurons(i)},fil,SWSEpoch,30,0);
    KappaAll(a)=Kappa;
    pvalAll(a)=pval;
    phAll{a}=ph;
    meanPh(a)=circ_mean(Data(ph{1}));
    a=a+1;
end
cd ([res '/SpikeModulationBulb'])
saveas(hfigMod,(['Modul_' BandFq 'Kz''.fig']))
saveFigure(hfigMod,(['Modul_' BandFq 'Hz']),[res '/SpikeModulationBulb'])

% percentage of modulated neurons
hperc=figure('Position', [918 600 1002  405]);
% select neurons with significant modulation an kappa > a threshold
subplot(1,3,1)
modulatedNeurons=NumNeurons((pvalAll<pthres) & (KappaAll>Kth));
scatter(log10(pvalAll), KappaAll,'MarkerFaceColor','b','MarkerEdgeColor','k')
hold on, scatter(log10(pvalAll((pvalAll<pthres) & (KappaAll>Kth))), KappaAll((pvalAll<pthres) & (KappaAll>Kth)), 'MarkerFaceColor','r','MarkerEdgeColor','k')
scatter(log10(pvalAll(NumNeurons)), KappaAll(NumNeurons),'Marker', '+','MarkerEdgeColor',[0.8 0.8 0.8])
legend({'no modulation', ['p < ' num2str(pthres) ' & K > ' num2str(Kth) ], 'MUA'}, 'Location', 'NorthWest')
title([ BandFq 'Hz']), xlabel('log 10 (p)'), ylabel ('kappa')

% Kappa/phase diagram, pval color-coded
subplot(1,3,2), hold on
A=round(abs(log10(pvalAll)));
% cols=jet(max(A)+1);
cols=jet(2*(max(A)+1));
cols(1:max(A)+1, :)=[];
for nn=NumNeurons
    if pvalAll(nn)>pthres
    scatter(meanPh(nn), KappaAll(nn),'MarkerFaceColor','b','MarkerEdgeColor','k'),hold on
    else
    scatter(meanPh(nn), KappaAll(nn),'MarkerFaceColor',cols(round(abs(log10(pvalAll(nn))))+1, :),'MarkerEdgeColor','k'),hold on
    end
    if ismember(nn, numMUA)
        scatter(meanPh(nn), KappaAll(nn),'Marker', '+','MarkerEdgeColor',[0.8 0.8 0.8])
    end
end
title([ 'p : green = 0.05 red =  10 - ' num2str(max(A))]), xlabel('phase'), ylabel ('kappa')

% Distribution of Kappa values
Kmean=mean(KappaAll);
PercModulatedNeurons=(length(pvalAll((pvalAll<pthres) & (KappaAll>Kth)))/length(pvalAll))*100;
subplot(1,3,3), hist(KappaAll,20)
hold on, title(['Kappa Distrib ',' - Kmean = ', sprintf('%.2f',Kmean),' - %modulated = ',sprintf('%.0f',PercModulatedNeurons),'%'])
Y=ylim;
plot([Kth Kth],[Y(1) Y(2)], ':r')
saveFigure(hperc,(['K_Distrib_',BandFq , 'Hz']),[res '/SpikeModulationBulb'])
saveas(hperc,(['K_Distrib_',BandFq , 'Hz' '.fig']))


%% PFC Spike modulation by Bulb during SWS (Rayleigh Freq 2)
cd(res)

for n=NumNeurons
    [H,HS,Ph,ModTheta, EpochSelected]=RayleighFreq2(Restrict(LFP, SWSEpoch),Restrict(S{n}, SWSEpoch),0.05,20,512,'H',10,2,'strongosc','no'); % sig=0.05  fre= 20
    ModThetaAllNeurons{n}=ModTheta;
    end
    title(['neuron ' num2str(n)])
    if ismember(n,NumNeurons)
        ModThetaAllNeurons{n}.NeuronName=['MUA ' num2str(n)];
    else
        ModThetaAllNeurons{n}.NeuronName=['neuron ' num2str(n)];
    end
    title(ModThetaAllNeurons{n}.NeuronName)
    saveFigure(gcf,(['Rayleigh_n',num2str(n)  '_OB_' suffix ]),[res '/SpikeModulationBulb'])
    saveas(gcf,(['Rayleigh_n',num2str(n) , '_OB_' suffix '.fig']))
end

%save (['RayleighFreq2_' suffix '.mat'],  'ModThetaAllNeurons', 'numNeurons')

% Plot Bilan de RayleighFreq 2 : neurones modulés pour toutes les frequences
for i=1:20
    Filt=[-0.5+i 2+0.5+i];
    ab(i)=mean(Filt); 
end


for i=1:length(ab) 
    PercModulatedNeuronsAllFq(i)=0;
    for n=NumNeurons
         ModThetaAllNeurons{n}.pval(i)
        if ModThetaAllNeurons{n}.pval(i)<sig
            
            PercModulatedNeuronsAllFq(i)=PercModulatedNeuronsAllFq(i)+1; 
            ModulatedNeuronsAllFq(n,i)=NumNeurons(n); 
            Kappa(n,i)=[ModThetaAllNeurons{n}.Kappa(i)];
            mu(n,i)=[ModThetaAllNeurons{n}.mu(i)];
        else
            ModulatedNeuronsAllFq(n,i)=NaN; 
            Kappa(n,i)=NaN;
            mu(n,i)=NaN;
            
        end
    end
end
figure('Position', [640   540   788   385])
subplot(1,3,1), 
ff=[];
for i=1:length(ab) 
    ff=[ff ab(i)*ones(length(NumNeurons),1)];
end
subplot(1,3,1), 
plot(ff,ModulatedNeuronsAllFq,'+'), hold on
xlim([1 20])
title(suffix)
ylabel ('neurons'), xlabel ('frequencies')

subplot(1,3,2), 
plot(ff,Kappa,'+'), hold on
xlim([1 20])
Y=ylim;
ylim([0 Y(2)])
ylabel ('Kappa'), xlabel ('frequencies')

subplot(1,3,3), 
plot(ff,mu,'+'), hold on
xlim([1 20])
Y=ylim;
ylim([0 Y(2)])
ylabel ('Phase'), xlabel ('frequencies')
saveas(gcf, ['RayleighFreq2_' suffix '.fig'])

end
%%
