function [m1,s1,tps1,m]=PhasePowerModulation(LFPi,bandP,LFPb,plo)

% LFPi will be filtered in the bandP band and instantaneous phase extracted
% with Hilbert - peaks are identified and LFPb power in different
% frequencies triggered off this

tic

limFreq=120;

pas=2;


try 
    plo;
catch
    plo=0;
end

if bandP(2)<12
    fi=1024;
elseif bandP(2)<30&bandP(2)>12
    fi=512;
else
    fi=256;
end
   

try
    LFPb;
catch
    LFPb=LFPi;
end

% fi=1024;
%  fi=512;
%  fi=256;

Fil=FilterLFP(LFPi,bandP,fi);
hil=hilbert(Data(Fil));
Hil=tsd(Range(Fil),abs(hil));
phz = atan2(imag(hil), real(hil)); phz(phz < 0) = phz(phz < 0) + 2 * pi;
phTsd = tsd(Range(Fil), phz);

rg=Range(phTsd);
id=find(Data(phTsd)<0.1);

%finding peaks
de = diff(Data(Fil))';
de1 = [de 0];
de2 = [0 de];
upPeaksIdx = find(de1 < 0 & de2 > 0);
downPeaksIdx = find(de1 > 0 & de2 < 0);          
id=downPeaksIdx;

[m,s,tps]=mETAverage(rg(id),Range(LFPb),Data(LFPb),10,200);
%[mf,sf,tpsf]=mETAverage(rg(id),Range(Hil),Data(Hil),10,200);

a=1;
for i=1:pas:limFreq   
    Fil1=FilterLFP(LFPb,[i i+2],256);
    hil1=hilbert(Data(Fil1));
    Hil1=tsd(Range(Fil1),abs(hil1));
    [m1(a,:),s1(a,:),tps1]=mETAverage(rg(id),Range(Hil1),Data(Hil1),10,200);
    a=a+1;
end

if plo
    
figure('color',[1 1 1]), 
subplot(2,1,1), imagesc(tps,1:limFreq, (m1')'), axis xy
hold on, plot(tps,rescale((m),40,limFreq-40),'w','linewidth',2)
colorbar
%caxis([0 1200])
title(['Freq: ',num2str(bandP(1)),' -- ',num2str(bandP(2))])
subplot(2,1,2), imagesc(tps,1:limFreq, zscore(m1')'), axis xy
hold on, plot(tps,rescale(zscore(m),40,limFreq-40),'k','linewidth',2)
colorbar

axis xy
end

toc
