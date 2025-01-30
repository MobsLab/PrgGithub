


function [Result] = Envelope_Maxima_BM(Signal , smooth_fact)

dth = diff(Signal);

dth1 = [0 dth'];
dth2 = [dth' 0];
clear dth;

t = [1:length(Signal)];
ind=find (dth1 > 0 & dth2 < 0);
thpeaks = Signal(ind , 1);

Result_Pre(ind) = thpeaks;
Result_Pre(Result_Pre==0)=NaN;
Result = naninterp(Result_Pre);
Result = runmean(Result , smooth_fact);













