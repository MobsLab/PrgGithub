function [Si,sq,sweeps]=PlotRasterPETHCouleur(S,neurons,EEGh,Epoch,periods, st,to,abo,bel,couleur,Bin,fig)

% EEGh = voie filtrée

[phaseTsd, ph] = firingPhaseHilbert(EEGh, Restrict(S,Epoch)) ;

Si=Restrict(S(neurons),Epoch);



Si=S{neurons};

try
Sa=thresholdIntervals(ph{neurons},abo,'Direction','Above');
Sb=thresholdIntervals(ph{neurons},bel,'Direction','Below');

if periods=='I'
Si=Restrict(S{neurons},and(Sa,Sb),'align','equal');
else
Si=Restrict(S{neurons},or(Sa,Sb),'align','equal');
end



end


A{1}=couleur;

figure(fig)

[sq,sweeps] = RasterPETHKarimCoul(Si, ts(st), -50000, 100000, 'Markers', {ts(to)} , 'MarkerTypes', {'k.' }, 'MarkerSize', 20, 'BinSize', Bin, 'BarColor',A,'FigureHandle', fig);

