function [X,Y,S,stim]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz,diss)

try
    diss;
catch
    diss=1;
end

Xx=Data(X);
Yy=Data(Y);
rg=Range(X);
goodInterval1=thresholdIntervals(X,min(xMaz),'Direction','Above');
goodInterval2=thresholdIntervals(X,max(xMaz),'Direction','Below');
goodInterval3=thresholdIntervals(Y,min(yMaz),'Direction','Above');
goodInterval4=thresholdIntervals(Y,max(yMaz),'Direction','Below');

goodIntervalA=intersect(goodInterval1,goodInterval2);
goodIntervalB=intersect(goodInterval3,goodInterval4);

goodInterval=intersect(goodIntervalA,goodIntervalB);

X=Restrict(X,goodInterval);
Y=Restrict(Y,goodInterval);
S=Restrict(S,goodInterval);
stim=Restrict(stim,goodInterval);

Xx=Data(X);
Yy=Data(Y);
X=tsd(Range(X),Xx-min(xMaz));
Y=tsd(Range(Y),Yy-min(yMaz));
limMaz=[0 max(max(xMaz)-min(xMaz),max(yMaz)-min(yMaz))];

if diss
    dis=tsd(Range(X),sqrt((Data(X)-max(Data(X))/2).^2+(Data(Y)-max(Data(Y))/2).^2));
    EpochOk=thresholdIntervals(dis,limMaz(2)/2,'Direction','Below');

    X=Restrict(X,EpochOk);
    Y=Restrict(Y,EpochOk);
    S=Restrict(S,EpochOk);
end
