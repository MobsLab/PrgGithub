function [numNeurons,numMUA,pvalAll,KappaAll,phAll,meanPh,pthres,Kth,Duration,PercTimeval,criterion,SpkNbThr]=ModulationPFCneuronsByBulb(FreqRange,lim2,lim3, varargin);

% 07.05.2015
% repris 13.01.2016, modif 27.01.2016
% See also ModulationPFCneuronsByLFP


% INPUTS
% - FreqRange : frequency range of interest for FindStrongOsc. ex : [3 7] 
% - lim2 : frequency range below
% - lim3 : frequency range above

% intensity of signal in lim1 is compared to intensity in lim2 and lim 3, 
% lim 3 is multiplied by an increasing factor  'fac' (criterion more and
% more drastic)

% - varargin : 
%       o  'strongperonly' : 0 or 1%  =>  'suffix' becomes 'AllPer', 'StrO-3-7'
%       o  'Epoch' can be 'TotEp' , 'Freez' , 'NoFreez'
%       o  'LFP' can be 'Bulb_deep', 'PFCx_deep', 'dHPC_rip'
% remarque : StrO s'applique 
% - pour ModulatioTheta avec une FreqRange donnée
% - pour RayleighFre2 (pas de rpise en compte de cette FreqRange)

clear numNeurons Modul modulatedNeurons
RayleighFreq2switch=0;

% parameters
Kth=0.06; % threshold for Kappa
pthres=0.05; % threshold for significance
sig=0.05;
SpkNbThr=40; % nb sikes minim to run rayleighFreq

% default values for varargin
strongperonly=0;
suffix='AllPer';
Epoch='Freez';
LFP_for_modul='Bulb_deep';

% default values if strongperonly=0, modified if strongperonly=1
criterion=3;
PercTimeval=100;


% Parse options
for i = 1:2:length(varargin),
	if ~ischar(varargin{i}),
		error(['Parameter ' num2str(i+3) ' is not a property .']);
    end
    
	switch(lower(varargin{i})),
		case 'strongperonly',
			strongperonly = varargin{i+1};
            if strongperonly==0
                suffix='AllPer';
            elseif strongperonly==1
                suffix=['StrO-' num2str(FreqRange(1)), '-' ,num2str(FreqRange(2))];
            end

        case 'epoch',
			EpochName = varargin{i+1};
        case 'lfp',
			LFP_for_modul = varargin{i+1};
		
	end
end

% for titles
BandFq=[num2str(FreqRange(1)), '-' ,num2str(FreqRange(2))];

%% Load spike and LFP data
load behavResources FreezeEpoch
load StateEpoch TotalNoiseEpoch


if ~exist('InfoLFP','var') 
    load LFPData/InfoLFP.mat
end

FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;  
NoiseRemoved='OK';

chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
if ~exist('S','var')
    load SpikeData.mat
end
    
% get LFP Bulb
res=pwd; 
load([res,'/ChannelsToAnalyse/Bulb_deep']); 
load([res,'/LFPData/LFP',num2str(channel)]);

%% define Epoch
tps=Range(LFP);% tps est en 10-4sec
TotEpoch=intervalSet(tps(1),tps(end));
TotEpoch=TotEpoch-TotalNoiseEpoch;      

if strcmp(EpochName, 'Freez')
    Epoch=FreezeEpoch;
elseif strcmp(EpochName, 'TotEp')
    Epoch=TotEpoch;
elseif strcmp(EpochName, 'NoFreez')
    Epoch=TotEpoch-FreezeEpoch;
end
Duration=sum(End(Epoch)-Start(Epoch));

if strongperonly==1
    lim1=FreqRange;
    load([res,'/SpectrumDataL/Spectrum',num2str(channel)]);
    [StrongOscAndFreezeEpoch,PercTimeval,val2]=FindStrongOsc(Sp,t,f,Epoch,1,lim1, lim2,lim3);% plo=1
    PercTimeval=PercTimeval(criterion);
end

FolderName=['SpkModul_Bulb_' EpochName '_' suffix ];
if ~isdir(FolderName);  
    mkdir(FolderName);
end

%% get the n° of the neurons of PFCx
numtt=[]; % nb tetrodes ou montrodes du PFCx
for cc=1:length(chans) 
    for tt=1:length(tetrodeChannels) % tetrodeChannels= tetrodes ou montrodes (toutes)
        if ~isempty(find(tetrodeChannels{tt}==chans(cc)))
            numtt=[numtt,tt];
        end
    end
end
numNeurons=[]; % neurones du PFCx
for i=1:length(S);
    if ismember(TT{i}(1),numtt)
      numNeurons=[numNeurons,i];  
    end
end

numMUA=[];
for k=1:length(numNeurons)
    j=numNeurons(k);
    if TT{j}(2)==1
        numMUA=[numMUA, j];
    end
end

%% PFC Spike modulation by OB
try 
    load([FolderName '/Modul_' BandFq '_' suffix '.mat'])
catch

    hfigMod=figure('Position',  [100 20  1800 900]);
    fil=FilterLFP(LFP,FreqRange,2048);
    a=1;
    for i=1:length(numNeurons)
        %build the plot
        u=(TT{i}(1)-1)*5+ TT{i}(2);
        %subplot(4,5,u);
        subplot(ceil(sqrt(length(numNeurons))),ceil(sqrt(length(numNeurons))),i)
        
        KappaAll(a)=NaN;
        pvalAll(a)=NaN;
        phAll{a}=NaN;
        meanPh(a)=NaN;
        
        if strongperonly==1
            if length(Range(Restrict(S{numNeurons(i)}, StrongOscAndFreezeEpoch{criterion})))>SpkNbThr
                [ph,mu, Kappa, pval,B,C]=ModulationTheta(S{numNeurons(i)},fil,StrongOscAndFreezeEpoch{criterion},30,0);
                KappaAll(a)=Kappa;
                pvalAll(a)=pval;
                phAll{a}=ph;
                meanPh(a)=circ_mean(Data(ph{1}));
            end
        elseif strongperonly==0
            if length(Range(Restrict(S{numNeurons(i)}, Epoch)))>SpkNbThr
                [ph,mu, Kappa, pval,B,C]=ModulationTheta(S{numNeurons(i)},fil,Epoch,30,0);
                KappaAll(a)=Kappa;
                pvalAll(a)=pval;
                phAll{a}=ph;
                meanPh(a)=circ_mean(Data(ph{1}));
            end
        end
        

            if ismember(i,numMUA)
                ModThetaAllNeurons{i}.NeuronName=['MUA ' num2str(i)];
            else
                ModThetaAllNeurons{i}.NeuronName=['neuron ' num2str(i)];
            end
            xlabel(ModThetaAllNeurons{i}.NeuronName)
        
        
        if a==1
            text(-0.5,1.25, EpochName,'units','normalized')
            text(-0.5,1.05, [BandFq ' Hz'],'units','normalized')
            text(-0.5,0.95, [num2str(round(Duration*1E-4*PercTimeval*1E-2)) ' sec'],'units','normalized')
            if strongperonly==1
                text(-0.5,1.15, ['Strong Osc Per Only Crit' num2str(criterion)],'units','normalized')
            elseif strongperonly==0
                text(-0.5,1.15, 'All Epochs included','units','normalized')
            end
            text(-0.5,0.85, ['minSpkNb ' sprintf('%.0f',SpkNbThr) ],'units','normalized')
        end
        
        a=a+1;
    end

    cd ([res '/' FolderName ])
    if strongperonly==1
        suffix=[suffix '_Cr' num2str(criterion)];
    end
    saveas(hfigMod,(['Modul_' BandFq '_' suffix '.fig']))
    saveFigure(hfigMod,(['Modul_' BandFq '_' suffix ]),[res '/SpikeModulationBulb'])

% percentage of modulated neurons
hperc=figure('Position', [918 600 1002  405]);
% select neurons with significant modulation an kappa > a threshold
subplot(1,3,1)
modulatedNeurons=numNeurons((pvalAll<pthres) & (KappaAll>Kth));
scatter(log10(pvalAll), KappaAll,'MarkerFaceColor','b','MarkerEdgeColor','k')
hold on, scatter(log10(pvalAll((pvalAll<pthres) & (KappaAll>Kth))), KappaAll((pvalAll<pthres) & (KappaAll>Kth)), 'MarkerFaceColor','r','MarkerEdgeColor','k')
scatter(log10(pvalAll(numMUA)), KappaAll(numMUA),'Marker', '+','MarkerEdgeColor',[0.8 0.8 0.8])
legend({'no modulation', ['p < ' num2str(pthres) ' & K > ' num2str(Kth) ], 'MUA'}, 'Location', 'NorthWest')
title([ BandFq ' ' suffix ' ' num2str(round(Duration*1E-4*PercTimeval*1E-2)) ' sec']), xlabel('log 10 (p)'), ylabel ('kappa')

% Kappa/phase diagram, pval color-coded
subplot(1,3,2), hold on
A=round(abs(log10(pvalAll)));
% cols=jet(max(A)+1);
cols=jet(2*(max(A(~isinf(A)))+1));
cols(1:max(A(~isinf(A)))+1, :)=[];
for nn=numNeurons
    if ~isnan(KappaAll(nn))

        if pvalAll(nn)>pthres
            scatter(meanPh(nn), KappaAll(nn),'MarkerFaceColor','b','MarkerEdgeColor','k'),hold on
        else
            scatter(meanPh(nn), KappaAll(nn),'MarkerFaceColor',cols(round(abs(log10(pvalAll(nn))))+1, :),'MarkerEdgeColor','k'),hold on
        end
        if ismember(nn, numMUA)
            scatter(meanPh(nn), KappaAll(nn),'Marker', '+','MarkerEdgeColor',[0.8 0.8 0.8])
        end
    end
end
title([ 'p : green = 0.05 red =  10 - ' num2str(max(A))]), xlabel('phase'), ylabel ('kappa')

% Distribution of Kappa values
Kmean=nanmean(KappaAll);
PercModulatedNeurons=(length(pvalAll((pvalAll<pthres) & (KappaAll>Kth)))/length(pvalAll))*100;
subplot(1,3,3), hist(KappaAll,20)
hold on, title(['Kappa Distrib ',' - Kmean = ', sprintf('%.2f',Kmean),' - %modulated = ',sprintf('%.0f',PercModulatedNeurons),'%'])
Y=ylim;
plot([Kth Kth],[Y(1) Y(2)], ':r')
saveFigure(hperc,(['K_Distrib_',BandFq , '_OB_' suffix ]),[res '/SpikeModulationBulb'])
saveas(hperc,(['K_Distrib_',BandFq , '_OB_' suffix '.fig']))

save(['Modul_',BandFq '_' suffix '.mat'], 'KappaAll', 'pvalAll','phAll','meanPh', 'strongperonly', 'criterion', 'numNeurons', 'numMUA', 'Kth', 'modulatedNeurons','NoiseRemoved')
end
cd(res)
%verification
%[ph,mu,Kappa, pval,B,C,nmbBin,Cc,dB,vm]=ModulationThetaCorrection(S{numNeurons(1)},fil,Epoch,30); % nmbbin=100

if RayleighFreq2switch

    % Rayleigh Freq 2
    try
        load([FolderName '/RayleighFreq2_' suffix '.mat'])
    catch

        for n=numNeurons
            if length(Range(Restrict(S{n}, Epoch)))>SpkNbThr
                if strongperonly==1
                    %[HS,Ph,ModTheta,EpochSelected]=RayleighFreq2(Restrict(LFP, Epoch),Restrict(S{n}, Epoch),0.05,20,512,'H',10,2,'strongosc','quantile'); % sig=0.05  fre= 20
                    [H,HS,Ph,ModTheta, EpochSelected]=RayleighFreq2(Restrict(LFP, Epoch),Restrict(S{n}, Epoch),0.05,20,512,'H',10,2,'strongosc','compabovebelow'); % sig=0.05  fre= 20
                    ModThetaAllNeurons{n}=ModTheta;
                elseif strongperonly==0
                    [H,HS,Ph,ModTheta, EpochSelected]=RayleighFreq2(Restrict(LFP, Epoch),Restrict(S{n}, Epoch),0.05,20,512,'H',10,2,'strongosc','no'); % sig=0.05  fre= 20
                    ModThetaAllNeurons{n}=ModTheta;
                end
                title(['neuron ' num2str(n)])
                if ismember(n,numMUA)
                    ModThetaAllNeurons{n}.NeuronName=['MUA ' num2str(n)];
                else
                    ModThetaAllNeurons{n}.NeuronName=['neuron ' num2str(n)];
                end
                title(ModThetaAllNeurons{n}.NeuronName)
                saveFigure(gcf,(['Rayleigh_n',num2str(n)  '_OB_' suffix ]),[res '/SpikeModulationBulb'])
                saveas(gcf,([FolderName '/Rayleigh_n',num2str(n) , '_OB_' suffix '.fig']))
            end
        end

        save ([FolderName '/RayleighFreq2_' suffix '.mat'],  'ModThetaAllNeurons', 'numNeurons')

    end

    % Plot Bilan de RayleighFreq 2 : neurones modulés pour toutes les frequences
    for i=1:20
        Filt=[-0.5+i 2+0.5+i];
        ab(i)=mean(Filt); 
    end


    for i=1:length(ab) 
        PercModulatedNeuronsAllFq(i)=0;
        for n=numNeurons
            if isstruct(ModThetaAllNeurons{n})
                if ModThetaAllNeurons{n}.pval(i)<sig

                    PercModulatedNeuronsAllFq(i)=PercModulatedNeuronsAllFq(i)+1; 
                    ModulatedNeuronsAllFq(n,i)=numNeurons(n); 
                    Kappa(n,i)=[ModThetaAllNeurons{n}.Kappa(i)];
                    mu(n,i)=[ModThetaAllNeurons{n}.mu(i)];
                else
                ModulatedNeuronsAllFq(n,i)=NaN; 
                Kappa(n,i)=NaN;
                mu(n,i)=NaN;

                end
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
        ff=[ff ab(i)*ones(length(numNeurons),1)];
    end
    subplot(1,3,1), 
    plot(ff,ModulatedNeuronsAllFq,'+'), hold on
    xlim([1 20])
    title(suffix)
    ylabel ('modulated neurons'), xlabel ('frequencies')

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
    saveas(gcf, [FolderName '/RayleighFreq2_' suffix '.fig'])

end % 





% % % prepare the needed variables
% thtps_immob=2;
% th_immob=1.5;
% try 
%     load behavResources FreezeEpoch
% catch
%     load behavResources Movtsd %, attention valable seulement pour file comportment car fichier sleep= doubletracking=pixratio pas appliqué
%     FreezeEpoch=thresholdIntervals(Movtsd,th_immob,'Direction','Below');
% 
% end
% FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
% FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);

% save behavResources FreezeEpoch Movtsd thtps_immob th_immob PosMat -Append
