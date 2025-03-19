function GetModulationAllUnits_FreqBand_SB(LFPName,FiltBand,varargin)

% This codes gets the phase of all spikes in a folder relative to a
% filtered LFP

% INPUT
% LFPName :              Name in ChannelsToAnalyse nomenclature of channel of
% interest
% FiltBand :             Band for filtering in the format [1 4]
% epoch (optional):      Epoch to restrict analysis
% epoch_name (optional): Name Of Epoch
% plo (optional) :       1 if want to save all the figures


% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'epoch'
            epoch = lower(varargin{i+1});
        case 'epoch_name'
            epoch_name = lower(varargin{i+1});
        case 'plo'
            plo = varargin{i+1};
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

nbin = 30;
try plo; catch plo = 0; end

% Get the right LFP
load(['ChannelsToAnalyse/',LFPName,'.mat'])
load(['LFPData/LFP',num2str(channel),'.mat'])

try epoch; catch,
    epoch = intervalSet(0,max(Range(LFP)));
    epoch_name = 'TotalEpoch';
end

try epoch_name; catch, epoch_name = 'Undefined'; end

% Get the filename
mkdir('NeuronModulation')
BaseName = ['NeuronMod_' LFPName '_Filt_' num2str(FiltBand(1)) '-' num2str(FiltBand(2)) 'Hz_' epoch_name];
if plo
    mkdir(['NeuronModulation/' BaseName])
end

% Get the spikes
load('SpikeData.mat')

% Restrict to epoch
LFP = Restrict(LFP,epoch);
S = Restrict(S,epoch);

% Filter it in the desired band
Fil=FilterLFP(LFP,FiltBand,1024);


% Get the phases of the spikes
for i=1:length(S)
    [PhasesSpikes_temp{i},mu_temp{i},Kappa_temp{i},pval_temp{i}]=UnitModulationLFP_SB(S{i},Fil,epoch,nbin,plo,1);
    if plo
    saveas(gcf,['NeuronModulation/' BaseName '/Unit' num2str(i) '.png'])
    close all
    end
end

% Make the output easy to use
for i=1:length(S)
    PhasesSpikes.Nontransf{i} = PhasesSpikes_temp{i}.Nontransf;
    PhasesSpikes.Transf{i} = PhasesSpikes_temp{i}.Transf;
    
    mu.Nontransf(i) = mu_temp{i}.Nontransf;
    mu.Transf(i) = mu_temp{i}.Transf;
    
    Kappa.Nontransf(i) = Kappa_temp{i}.Nontransf;
    Kappa.Transf(i) = Kappa_temp{i}.Transf;
    
    pval.Nontransf(i) = pval_temp{i}.Nontransf;
    pval.Transf(i) = pval_temp{i}.Transf;
end

save(['NeuronModulation/' BaseName '.mat'],'PhasesSpikes','mu','Kappa','pval','epoch')
disp(['saved in NeuronModulation/' BaseName '.mat'])

end



