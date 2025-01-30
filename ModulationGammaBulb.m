function [M,M2,burst1,burst2]=ModulationGammaBulb(LFPb,LFP,Epoch,lim,plo,parmasTh)

try
    parmasTh;
catch
    parmasTh=[0.4 0 5]; %0.002 0.01];
end

try
    lim;
catch
    lim=500;
end

try
    plo;
catch
    plo=1;
end

Fil2=FilterLFP(Restrict(LFPb,Epoch),[70 90],512);
Fil=FilterLFP(Restrict(LFPb,Epoch),[50 60],512);
[burst1,stdev,noise] = FindRipples([Range(Restrict(Fil,Epoch),'s') Data(Restrict(Fil,Epoch))],'durations',[1 50 1000],'thresholds',parmasTh);
[burst2,stdev,noise] = FindRipples([Range(Restrict(Fil2,Epoch),'s') Data(Restrict(Fil2,Epoch))],'durations',[1 50 1000],'thresholds',parmasTh);

M=PlotRipRaw(LFP,burst1,lim);close
M2=PlotRipRaw(LFP,burst2,lim);close

if plo
    figure('color',[1 1 1]), plot(M(:,1),M(:,2),'k')
    hold on, plot(M2(:,1),M2(:,2),'r')
    yl=ylim; hold on, line([0 0]',yl','color','b')
end

