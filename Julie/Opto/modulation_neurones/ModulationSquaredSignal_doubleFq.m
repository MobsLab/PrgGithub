function Ph = ModulationSquaredSignal_doubleFq(LaserLFP,spikes, plo, newfig)

% Julie 
%22.06.2017
% computes the modulation relative to the frequency f= 2x f(squared_stim)
if ~exist('plo')
    plo=0;
end
if ~exist('newfig')
    newfig=0;
end
%spikes=S{1};

% LaserLFP=Restrict(LFPlaser,subset(int_laser,1));


rg=Range(LaserLFP);

[up,down,idxUp,idxDown] = ZeroCrossings([Range(LaserLFP), zscore(Data(LaserLFP))]);

idx=sort([idxUp;idxDown]);
ph = interp1(rg(idx),2*pi*(0:length(rg(idx))-1),rg); 

phtsd = tsd(rg,mod(ph,2*pi));

Ph=Data(Restrict(phtsd,spikes));
Ph(isnan(Ph))=[];
% [mu, Kappa, pval, Rmean, delta, sigma,confDw,confUp] = CircularMean(Ph);
% if plo    
%     if newfig
%     figure;
%     end
%     [mu, Kappa, pval, Rmean, delta, sigma,confDw,confUp]=JustPoltMod(Ph,30);
% end
