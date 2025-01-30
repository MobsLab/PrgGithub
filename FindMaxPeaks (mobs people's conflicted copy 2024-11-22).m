function [tPeaks,Peaks]=FindMaxPeaks(signal)

%signal(:,1)=time
%signal(:,2)=values

td=signal(:,1);

de = diff(signal(:,2));

    de1 = [de' 0];
    de2 = [0 de'];


%finding peaks
PeaksIdx = find(de1 < 0 & de2 > 0);
%downPeaksIdx = find(de1 > 0 & de2 < 0);

%PeaksIdx = [upPeaksIdx downPeaksIdx];
%PeaksIdx = sort(PeaksIdx);

Peaks = signal(PeaksIdx,2);
tPeaks=td(PeaksIdx);




