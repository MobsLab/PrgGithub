function binnedTsd=BinTsd(tsa,binSize,smo)

try
    smo;
catch
    smo=0;
end


ST{1}=tsa;
try
ST=tsdArray(ST);
end
Q=MakeQfromS(ST,binSize);
if smo>0
binnedTsd=tsd(Range(Q),smooth(full(Data(Q)),smo));
else
binnedTsd=tsd(Range(Q),full(Data(Q)));    
end

