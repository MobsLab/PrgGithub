function [Si,sq,sweeps]=PlotRasterPETHCouleur2(S,neurons,EEGh,Epoch,periods, st,to,abo,bel,couleur,Bin,fig,Avant,Apres)

% EEGh = voie filtrée

[phaseTsd, ph] = firingPhaseHilbert(EEGh, Restrict(S,Epoch)) ;

Si=Restrict(S(neurons),Epoch);

Si=S{neurons};

tps=Range(ph{neurons});
phtps=Data(ph{neurons});

if periods=='I'
    temps=tps(find(phtps>abo&phtps<bel));
else
    temps=tps(find(phtps<abo&phtps>bel));
end

Si=tsd(sort(temps),sort(temps));

% try
%     Sa=thresholdIntervals(ph{neurons},abo,'Direction','Above');
%     Sb=thresholdIntervals(ph{neurons},bel,'Direction','Below');
%     if periods=='I'
%         Si=Restrict(S{neurons},and(Sa,Sb),'align','equal');
%         else
%         Si=Restrict(S{neurons},or(Sa,Sb),'align','equal');
%     end
% end


A{1}=couleur;

figure(fig)
try
Avant;
catch
Avant=-50000;
Apres=100000;
end

if to~=0
[sq,sweeps] = RasterPETHKarimCoul(Si, ts(st), Avant, Apres, 'Markers', {ts(to)} , 'MarkerTypes', {'k.' }, 'MarkerSize', 20, 'BinSize', Bin, 'BarColor',A,'FigureHandle', fig);
else
[sq,sweeps] = RasterPETHKarimCoul(Si, ts(st), Avant, Apres,'BinSize', Bin, 'BarColor',A,'FigureHandle', fig);
end