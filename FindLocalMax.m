function td=FindLocalMax(CRtheta)

dth = diff(Data(CRtheta));

dth1 = [0 dth'];
dth2 = [dth' 0];
clear dth;

t = Range(CRtheta);

thpeaks = (t(find (dth1 > 0 & dth2 < 0)));
val=Data(CRtheta);

td=tsd(thpeaks,val(find (dth1 > 0 & dth2 < 0)));




