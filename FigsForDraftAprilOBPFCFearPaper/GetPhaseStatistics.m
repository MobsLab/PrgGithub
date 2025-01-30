function PhaseMeasures=GetPhaseStatistics(PhaseData,Resample,NewNumSpikes)
% PhaseData : list of phase vals
% Resample : 0 if no need to down sample, otherwise equal to number of
% shuffles to perform
% NewNumSpikes : number of spikes to Downsample to, will be ignored if
% Resample is 0
% Number of elements
NumSpikes= numel(PhaseData);
CosVals=cos(PhaseData);
SinVals=sin(PhaseData);
dv=0;
nm=0;
for i=1:NumSpikes-1
    for j=i+1:NumSpikes
        dv=dv+cos(PhaseData(i)-PhaseData(j));
        nm=nm+1;
    end
end
PhaseMeasures.PwPC=dv*2/(NumSpikes*(NumSpikes-1));
PhaseMeasures.PLV=sqrt(sum(CosVals).^2+sum(SinVals).^2)/NumSpikes;

if Resample==0
    [PhaseMeasures.mu, PhaseMeasures.Kappa, PhaseMeasures.pval, PhaseMeasures.Rmean, ~ , ~ ,~ ,~ ] = CircularMean(PhaseData);
else
    for k=1:Resample
        y = randperm(NumSpikes); y=y(1:NewNumSpikes);
        PhaseDataSh=PhaseData(y);
        [mu(k), Kappa(k), pval(k), Rmean(k), ~ , ~ ,~ ,~ ] = CircularMean(PhaseDataSh);
    end
    PhaseMeasures.mu=mean(mu);
    PhaseMeasures.Kappa=mean(Kappa);
    PhaseMeasures.pval=mean(pval);
    PhaseMeasures.Rmean=mean(Rmean);
end


end