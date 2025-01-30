function [m1,s1,tps1,m,EvtNumbers,LengthBreath]=HilbertModulation(LFPi,bandLow,LFPb,binsize,nbins,bandHigh,pas)

tic



if bandLow(2)<12
    fi=1024;
elseif bandLow(2)<30&bandLow(2)>12
    fi=512;
else
    fi=256;
end


try
    LFPb;
catch
    LFPb=LFPi;
end

try, bandHigh; catch, bandHigh=[20 200]; end
bandHigh=[bandHigh(1):pas:bandHigh(2)];
try, pas; catch, pas=2; end
try, binsize; catch, binsize=5; end
try, nbins; catch, nbins=100; end



% fi=1024;
%  fi=512;
%  fi=256;

Fil2=FilterLFP(LFPi,[0.05 0.5],fi);
LFPi=tsd(Range(LFPi),Data(LFPi)-Data(Fil2));
Fil=FilterLFP(LFPi,[min(min(bandLow)) max(max(bandLow))],fi);

hil=hilbert(Data(Fil));
Hil=tsd(Range(Fil),abs(hil));
phz = atan2(imag(hil), real(hil)); phz(phz < 0) = phz(phz < 0) + 2 * pi;
phTsd = tsd(Range(Fil), phz);

rg=Range(phTsd);
id=find(Data(phTsd)<0.1);

%finding peaks
de = diff(Data(Fil))';
dat=Data(Fil);
de1 = [de 0];
de2 = [0 de];
upPeaksIdx = find(de1 < 0 & de2 > 0);
downPeaksIdx = find(de1 > 0 & de2 < 0);
id=downPeaksIdx;
ToElim=[];
for t=1:length(id)-1
    sg1=sign(dat(id(t)));
    sg2=sign(dat(id(t+1)));
    existpos=sum(dat(id(t):id(t+1))>0)>0;
    if sg1==-1 & sg2==-1 & existpos==0
        ToElim=[ToElim,t];
    elseif sg1==1 & sg2==1
        ToElim=[ToElim,t];
    elseif sg1==-1 & sg2==1
        ToElim=[ToElim,t+1];
    elseif  sg2==-1 & sg1==1
        ToElim=[ToElim,t];
    end
end
id(ToElim)=[];

for k=1:size(bandLow,2)
    idToUse=find(diff(rg(id))<(1./bandLow(1,k))*1e4 & diff(rg(id))>(1./bandLow(2,k))*1e4);
    tempid=id(idToUse);
    EvtNumbers(k)=size(idToUse,1);
    [m{k},s{k},tps{k}]=mETAverage(rg(tempid),Range(LFPb),Data(LFPb),binsize,nbins);
    %[mf,sf,tpsf]=mETAverage(rg(id),Range(Hil),Data(Hil),10,200);
    
    a=1;
    for i=bandHigh
        Fil1=FilterLFP(LFPb,[i i+2],256);
        hil1=hilbert(Data(Fil1));
        Hil1=tsd(Range(Fil1),abs(hil1));
        [m1{k}(a,:),s1{k}(a,:),tps1{k}]=mETAverage(rg(tempid),Range(Hil1),Data(Hil1),binsize,nbins);
        a=a+1;
    end
    
end
LengthBreath=diff(rg(id));
end