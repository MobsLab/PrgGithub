function [Peaks,PeaksU,PeaksD,PeaksIdx,upPeaksIdx,downPeaksIdx]=DetectExtremas(datas)

try
de = diff(datas);
de1 = [de 0];
de2 = [0 de];
catch
datas=datas';
de = diff(datas);
de1 = [de 0];
de2 = [0 de];  
end

%finding peaks
upPeaksIdx = find(de1 < 0 & de2 > 0);
downPeaksIdx = find(de1 > 0 & de2 < 0);

PeaksIdx = [upPeaksIdx downPeaksIdx];
PeaksIdx = sort(PeaksIdx);

Peaks = datas(PeaksIdx);
PeaksU= datas(upPeaksIdx);
PeaksD= datas(downPeaksIdx);
          
          