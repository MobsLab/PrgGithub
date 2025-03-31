function [ReNorm,ff,tps]=RescaleSpectroram0to1(Stsd,f,Epoch,tps,nbfreq)

try
    tps;
catch
    tps=0:0.05:1;
end

try
    nbfreq;
    ff=f(1):(f(end)-f(1))/(nbfreq-1):f(end);
catch
    ff=f;
end
    
Mat=Restrict(Stsd,Epoch);
rg=Range(Mat);
MatTemp=tsd((rg-rg(1))/(rg(end)-rg(1)),Data(Mat));
ReNorm(1:length(tps),1:length(f))=Data(Restrict(MatTemp,tps));

try
    nbfreq;
    Retsd=tsd(f,ReNorm');
    ReNorm=Data(Restrict(Retsd,ff))';
end

        
        