function Kap=CohenKappaSleepScoring(Ep1,Ep2,tsdcalc)
%% This code calculates Cohen's kappa for REM, NREM and wake scoring by two different methods
%% EP1 and EP2 are cell arrays containing REM, NREM and wake epochs
%% tsdcalc is a tsd of data points allowing to calculate the overlap between epochs

% observed agreement between observers
for k=1:length(Ep1)
    Agree(k)=length(Restrict(tsdcalc,and(Ep1{k},Ep2{k})));
    Overall(k)=length(Restrict(tsdcalc,Ep2{k}));
end
po=sum(Agree)/sum(Overall);

% chance agreement
for k=1:length(Ep1)
    Agree(k)=length(Restrict(tsdcalc,Ep1{k})).*length(Restrict(tsdcalc,Ep2{k}));
    Overall(k)=length(Restrict(tsdcalc,Ep1{k}));
end
pe=sum(Agree)/sum(Overall).^2;

% Kappa
Kap=(po-pe)/(1-pe);



end