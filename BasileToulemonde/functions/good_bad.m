function [BadEpoch36,GoodEpoch36,BadEpoch200,GoodEpoch200,BadEpoch504,GoodEpoch504,EpochOK36,EpochOK200,EpochOK504] = good_bad(LossPredTsd36tot,LossPredTsd200tot,LossPredTsd504tot)
    BadEpoch36=thresholdIntervals(LossPredTsd36tot,-2.5,'Direction','Above'); % PL>-2.5
    GoodEpoch36=thresholdIntervals(LossPredTsd36tot,-4,'Direction','Below'); % PL
    BadEpoch200=thresholdIntervals(LossPredTsd200tot,-2.5,'Direction','Above'); % PL>-2.5
    GoodEpoch200=thresholdIntervals(LossPredTsd200tot,-4.2,'Direction','Below'); % PL
    BadEpoch504=thresholdIntervals(LossPredTsd504tot,-2.5,'Direction','Above'); % PL>-2.5
    GoodEpoch504=thresholdIntervals(LossPredTsd504tot,-4,'Direction','Below'); % PL
    id=find(isnan(Data(X)));
    temp(1,:)=Range(X);
    temp(2,:)=ones(length(Data(X)),1);
    temp(2,id)=0;
    EpochOK=thresholdIntervals(tsd(temp(1,:),temp(2,:)'),0.5,'Direction','Above')
    EpochOK36=and(GoodEpoch36,EpochOK)
    EpochOK200=and(GoodEpoch200,EpochOK)
    EpochOK504=and(GoodEpoch504,EpochOK)
end