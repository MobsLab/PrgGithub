function Output=GetPeakAndTroughFreqBand(LFPi,bandP)

if bandP(2)<12
    fi=1024;
elseif bandP(2)<30&bandP(2)>12
    fi=512;
else
    fi=256;
end

Fil2=FilterLFP(LFPi,[0.05 0.5],fi);
LFPi=tsd(Range(LFPi),Data(LFPi)-Data(Fil2));
Fil=FilterLFP(LFPi,[min(min(bandP)) max(max(bandP))],fi);

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

Output=rg(id);
end