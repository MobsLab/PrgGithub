function [BadEpoch,GoodEpoch,EpochOK] = good_bad_Single(LossPredTsdtot,X,Y);
    BadEpoch=thresholdIntervals(LossPredTsdtot,-2.5,'Direction','Above'); % PL>-2.5
    GoodEpoch=thresholdIntervals(LossPredTsdtot,-4.5,'Direction','Below'); % PL
    id=find(isnan(Data(X)));
    temp(1,:)=Range(X);
    temp(2,:)=ones(length(Data(X)),1);
    temp(2,id)=0;
    EpochOK=thresholdIntervals(tsd(temp(1,:),temp(2,:)'),0.5,'Direction','Above');
    EpochOK=and(GoodEpoch,EpochOK);
end