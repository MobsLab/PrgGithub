
function [RESULT]=MeanPlusOrMinusStd(DATA,DATABis)

RESULT(1,:)=[nanmean(DATA)-std(DATA) nanmean(DATA)+std(DATA)];
RESULT(2,:)=[nanmean(DATABis) nanmean(DATABis)];
RESULT(3,:)=[nanmean(DATA) nanmean(DATA)];
RESULT(4,:)=[nanmean(DATABis)-std(DATABis) nanmean(DATABis)+std(DATABis)];

end

