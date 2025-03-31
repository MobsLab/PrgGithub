function GetModulationAllUnits_UserPhase_SB(Phastsd,LFPName,PhaseName,varargin)


% This codes gets the phase of all spikes in a folder relative to an
% arbitrary phse input provided by user

% INPUT
% Phastsd :              tsd of precalculated phases
% LFPName :           Name of structure from which this phase came (ie
%                        Bulb or dHPC or Respi)
% PhaseName :            Name to indicate how phase was dervied (ie
%                        Filt,PeakTrough...)
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

try epoch; catch,
    load('LFPData/LFP0.mat')
    epoch = intervalSet(0,max(Range(LFP)));
    epoch_name = 'TotalEpoch';
end

try epoch_name; catch, epoch_name = 'Undefined'; end

% Get the filename
mkdir('NeuronModulation')
BaseName = ['NeuronMod_' LFPName '_' PhaseName '_' epoch_name];
if plo
    mkdir(['NeuronModulation/' BaseName])
end

% Get the spikes
load('SpikeData.mat')

% Restrict to epoch
Phastsd = Restrict(Phastsd,epoch);
S = Restrict(S,epoch);


% Get the phases of the spikes
for i=1:length(S)
    [PhasesSpikes_temp{i},mu_temp{i},Kappa_temp{i},pval_temp{i}]=UnitModulationLFP_SB(S{i},Phastsd,epoch,nbin,plo,0);
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



