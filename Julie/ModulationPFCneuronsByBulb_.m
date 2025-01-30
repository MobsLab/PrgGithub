function ModulationPFCneuronsByBulb_(FreqRange,lim2,lim3, varargin)

% FreqRange= [2 4] por example 
 
% default values
strongperonly=0;

% Parse options
for i = 1:2:length(varargin),
	if ~ischar(varargin{i}),
		error(['Parameter ' num2str(i+3) ' is not a property (type ''help <a href="matlab:help RefSubtraction">RefSubtraction</a>'' for details).']);
	end
	switch(lower(varargin{i})),
		case 'strongperonly',
			strongperonly = varargin{i+1};
			if ~isdscalar(strongperonly,'>=0'),
				error('Incorrect value for property ''strongperonly'' ');
			end
		
	end
end


%% Load spike and LFP data
load behavResources FreezeEpoch
if ~exist('InfoLFP','var') 
    load LFPData/InfoLFP.mat
end
chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
if ~exist('S','var')
    load SpikeData.mat
end
    
% get LFP Bulb
res=pwd;
load([res,'/ChannelsToLookAt/OB_deep']); 
load([res,'/LFPData/LFP',num2str(channel)]);
lim1=FreqRange;
load([res,'/SpectrumDataL/Spectrum',num2str(channel)]);
[StrongOscAndFreezeEpoch,val,val2]=FindStrongOsc(Sp,t,f,FreezeEpoch,1,lim1, lim2,lim3);% plo=1

if ~isdir('SpikeModulationBulb');
    mkdir('SpikeModulationBulb');
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

%% PFC Spike modulation by OB

hfigMod=figure('Position',  [100 20  1800 900]);
fil=FilterLFP(LFP,FreqRange,2048);
a=1;
for i=1:length(numNeurons)
    %build the plot
    u=(TT{i}(1)-1)*5+ TT{i}(2);
    subplot(4,5,u);
    if strongperonly==1
        criterion=9;
        [ph,mu, Kappa, pval,B,C]=ModulationTheta(S{numNeurons(i)},fil,StrongOscAndFreezeEpoch{criterion},30,0);
    elseif strongperonly==0
        [ph,mu, Kappa, pval,B,C]=ModulationTheta(S{numNeurons(i)},fil,FreezeEpoch,30,0);
    end
    if a==1
        text(-0.5,1.15, [num2str(FreqRange(1)) '-' num2str(FreqRange(2)) ' Hz'],'units','normalized')
        if strongperonly==1
            text(-0.5,1.25, ['Strong Osc Per Only Crit' num2str(criterion)],'units','normalized')
        elseif strongperonly==0
            text(-0.5,1.25, 'All FreezeEpochs included','units','normalized')
        end
    end
    KappaAll(a)=Kappa;
    pvalAll(a)=pval;
    phAll{a}=ph;
    a=a+1;
end
saveas(hfigMod,(['Modul_' num2str(FreqRange(1)) '-' num2str(FreqRange(2)) '.fig']))
saveFigure(hfigMod,(['Modul_' num2str(FreqRange(1)) '-' num2str(FreqRange(2)) ]),[res '/SpikeModulationBulb'])

% percentage of modulated neurons
Kmean=mean(KappaAll);
% select neurons with significant modulation an kappa > a threshold
PercModulatedNeurons=(length(pvalAll((pvalAll<0.05) & (KappaAll>0.06)))/length(pvalAll))*100;
figure, hist(KappaAll,20)
hold on, title(['Kappa Distrib ',' - Kmean = ',num2str(Kmean),' - %modulated = ',num2str(PercModulatedNeurons),'%'])
Y=ylim;
plot([0.06 0.06],[Y(1) Y(2)], ':r')
%saveFigure(1,(['Kappa_Distribution_Freeze_',FreqRange,'_',num2str(structure)]),res)

%verification
%[ph,mu,Kappa, pval,B,C,nmbBin,Cc,dB,vm]=ModulationThetaCorrection(S{numNeurons(1)},fil,FreezeEpoch,30); % nmbbin=100





% % prepare the needed variables
% thtps_immob=2;
% try 
%     load behavResources FreezeEpoch
% catch
%     load behavResources Movtsd %, attention valable seulement pour file comportment car fichier sleep= doubletracking=pixratio pas appliqué
%     FreezeEpoch=thresholdIntervals(Movtsd,th_immob,'Direction','Below');
% 
% end
% FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
% FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
% 
% save behavResources FreezeEpoch Movtsd -Append
