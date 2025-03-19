% Compare_FR_between_epoch
%
% SB 24/11/2017
%
% EpochFR=Compare_FR_between_epoch(S,Epoch,num_bootstraps,varargin)
%
% inputs
% S                 : ts of spikes
% Epoch             : cell array of epochs to compare
% num_bootstraps    : number of randomizations to perform
% epoch_names       : (optional), cell array of epoch names, otherwise will be
% called 1,2,3
% pairs_to_compare  : (optional) list of pairs or epochs to compare using Mod Ind. i.e : [1,2;3,4]

function EpochFR = Compare_FR_between_epoch(S,Epoch,num_bootstraps,varargin)


%% INITIATION
% Derive total epoch for later use
TotEpoch=intervalSet([],[]);
for ep=1:length(Epoch)
    TotEpoch=or(TotEpoch,Epoch{ep});
end
TotEpoch = CleanUpEpoch(TotEpoch);

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'epoch_names'
            
            epoch_names = varargin{i+1};
            if length(epoch_names)~=length(Epoch)
                error('Incorrect value for property ''epoch_names''.');
            end
        case 'pairs_to_compare'
            pairs_to_compare = varargin{i+1};
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
            
    end
end

if ~(exist('epoch_names'))
    for ep = 1:length(Epoch)
        epoch_names{ep} = ['Epoch',num2tr(ep)];
    end
end


%% Average firing rate in each epoch
AllSpikeNum=[];
for ep = 1:length(Epoch)
    EpochFR.(epoch_names{ep}).real = FiringRateEpoch(S,Epoch{ep});
    AllSpikeNum(ep)=EpochFR.(epoch_names{ep}).real;
end

if nansum(AllSpikeNum)>0
    
    % if asked by user, calculate mod ind between pairs of epoch
    if (exist('pairs_to_compare'))
        for pair_num = 1 : size(pairs_to_compare,1)
            Ep1 = epoch_names{pairs_to_compare(pair_num,1)};
            Ep2 = epoch_names{pairs_to_compare(pair_num,2)};
            EpochFR.([Ep1 '_' Ep2]).real = (EpochFR.(Ep1).real-EpochFR.(Ep2).real)./(EpochFR.(Ep1).real+EpochFR.(Ep2).real);
        end
    end
    
    %% Now randomize spike order and recalculate firing rates
    
    % get randomized spike trains
    
    AllSpikesRand_ts = Randomize_SpikeTrain_SB(S,TotEpoch,num_bootstraps,'randtype','isi_shuffle');
    
    % calculate firing rates
    for k=1:num_bootstraps
        NewSp=AllSpikesRand_ts{k};
        for ep=1:length(Epoch)
            EpochFR.(epoch_names{ep}).rand(k)=FiringRateEpoch(NewSp,Epoch{ep});
        end
        
        % if asked by user, calculate mod ind between pairs of epoch
        if (exist('pairs_to_compare'))
            for pair_num = 1 : size(pairs_to_compare,1)
                Ep1 = epoch_names{pairs_to_compare(pair_num,1)};
                Ep2 = epoch_names{pairs_to_compare(pair_num,2)};
                EpochFR.([Ep1 '_' Ep2]).rand(k) = (EpochFR.(Ep1).rand(k)-EpochFR.(Ep2).rand(k))./(EpochFR.(Ep1).rand(k)+EpochFR.(Ep2).rand(k));
            end
        end
        
    end
    
    %% Check significance by comparing with distributions
    for ep=1:length(Epoch)
        % get percentiles
        EpochFR.(epoch_names{ep}).SigLims = [prctile(EpochFR.(epoch_names{ep}).rand,2.5),prctile(EpochFR.(epoch_names{ep}).rand,97.5)];
        % Compare to get significance
        if  EpochFR.(epoch_names{ep}).real < EpochFR.(epoch_names{ep}).SigLims(1)
            EpochFR.(epoch_names{ep}).IsSig = -1;
        elseif EpochFR.(epoch_names{ep}).real > EpochFR.(epoch_names{ep}).SigLims(2)
            EpochFR.(epoch_names{ep}).IsSig = 1;
        else
            EpochFR.(epoch_names{ep}).IsSig = 0;
        end
        
    end
    
    % if asked by user, calculate for pairs of epoch
    if (exist('pairs_to_compare'))
        for pair_num = 1 : size(pairs_to_compare,1)
            % get percentiles
            Ep1 = epoch_names{pairs_to_compare(pair_num,1)};
            Ep2 = epoch_names{pairs_to_compare(pair_num,2)};
            EpochFR.([Ep1 '_' Ep2]).SigLims = [prctile(EpochFR.([Ep1 '_' Ep2]).rand,2.5),prctile(EpochFR.([Ep1 '_' Ep2]).rand,97.5)];
            
            % Compare to get significance
            if  EpochFR.([Ep1 '_' Ep2]).real < EpochFR.([Ep1 '_' Ep2]).SigLims(1)
                EpochFR.([Ep1 '_' Ep2]).IsSig = -1;
            elseif EpochFR.([Ep1 '_' Ep2]).real > EpochFR.([Ep1 '_' Ep2]).SigLims(2)
                EpochFR.([Ep1 '_' Ep2]).IsSig = 1;
            else
                EpochFR.([Ep1 '_' Ep2]).IsSig = 0;
            end
            
            
        end
    end
    
else
    
    % if asked by user, calculate mod ind between pairs of epoch
    if (exist('pairs_to_compare'))
        for pair_num = 1 : size(pairs_to_compare,1)
            Ep1 = epoch_names{pairs_to_compare(pair_num,1)};
            Ep2 = epoch_names{pairs_to_compare(pair_num,2)};
            EpochFR.([Ep1 '_' Ep2]).real = NaN;
        end
    end
    
    % calculate firing rates
    for k=1:num_bootstraps
        for ep=1:length(Epoch)
            EpochFR.(epoch_names{ep}).rand(k)=NaN;
        end
        
        % if asked by user, calculate mod ind between pairs of epoch
        if (exist('pairs_to_compare'))
            for pair_num = 1 : size(pairs_to_compare,1)
                Ep1 = epoch_names{pairs_to_compare(pair_num,1)};
                Ep2 = epoch_names{pairs_to_compare(pair_num,2)};
                EpochFR.([Ep1 '_' Ep2]).rand(k) = NaN;
            end
        end
        
        %% Check significance by comparing with distributions
        for ep=1:length(Epoch)
            % get percentiles
            EpochFR.(epoch_names{ep}).SigLims = [NaN,NaN];
            % Compare to get significance
            if  EpochFR.(epoch_names{ep}).real < EpochFR.(epoch_names{ep}).SigLims(1)
                EpochFR.(epoch_names{ep}).IsSig = -NaN;
            elseif EpochFR.(epoch_names{ep}).real > EpochFR.(epoch_names{ep}).SigLims(2)
                EpochFR.(epoch_names{ep}).IsSig = NaN;
            else
                EpochFR.(epoch_names{ep}).IsSig = NaN;
            end
            
        end
        
        % if asked by user, calculate for pairs of epoch
        if (exist('pairs_to_compare'))
            for pair_num = 1 : size(pairs_to_compare,1)
                % get percentiles
                EpochFR.([Ep1 '_' Ep2]).SigLims = [NaN,NaN];
                
                % Compare to get significance
                if  EpochFR.([Ep1 '_' Ep2]).real < EpochFR.([Ep1 '_' Ep2]).SigLims(1)
                    EpochFR.([Ep1 '_' Ep2]).IsSig = NaN;
                elseif EpochFR.([Ep1 '_' Ep2]).real > EpochFR.([Ep1 '_' Ep2]).SigLims(2)
                    EpochFR.([Ep1 '_' Ep2]).IsSig = NaN;
                else
                    EpochFR.([Ep1 '_' Ep2]).IsSig = NaN;
                end
                
                
            end
        end
    end
    
end