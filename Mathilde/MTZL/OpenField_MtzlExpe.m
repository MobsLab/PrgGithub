

cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/4DqysPost/FEAR-Mouse-756-16062018-Hab_00'])
load('behavResources.mat')
test=ref;
% test(mask==1)=0;
figure, imagesc(test)
title('click on each corner and then enter')
Corner = ginput;

Middle = mean(Corner)

SalMice = [756 758 761 763 765];
for i = 1:length(SalMice)
    cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/4DqysPost/FEAR-Mouse-',num2str(SalMice(i)),'-16062018-Hab_00'])
    load('behavResources.mat')
    
    Dist_Middle = tsd(Range(Ytsd),sqrt((Data(Ytsd)-Middle(1)/Ratio_IMAonREAL).^2+(Data(Xtsd)-Middle(2)/Ratio_IMAonREAL).^2));
    CloseMiddleEpoch = thresholdIntervals(Dist_Middle,5,'Direction','Below');
    CloseMiddleEpochDur(i) = nanmean(Stop(CloseMiddleEpoch,'s')-Start(CloseMiddleEpoch,'s'));
    
    CloseEdgeEpoch = thresholdIntervals(Dist_Middle,5,'Direction','Above');
    CloseEdgeEpochDur(i) = nanmean(Stop(CloseEdgeEpoch,'s')-Start(CloseEdgeEpoch,'s'));
    
    
    
    Dist_Corner = tsd(Range(Ytsd),sqrt((Data(Ytsd)-Corner(1)/Ratio_IMAonREAL).^2+(Data(Xtsd)-Corner(1,2)/Ratio_IMAonREAL).^2));
    CloseCornerEpoch = thresholdIntervals(Dist_Corner,5,'Direction','Below');
    CloseCornerEpochDur(i) = nanmean(Stop(CloseCornerEpoch,'s')-Start(CloseCornerEpoch,'s'));
    
    Dist_Corner_b = tsd(Range(Ytsd),sqrt((Data(Ytsd)-Corner(2)/Ratio_IMAonREAL).^2+(Data(Xtsd)-Corner(2,2)/Ratio_IMAonREAL).^2));
    CloseCornerEpoch_b = thresholdIntervals(Dist_Corner_b,5,'Direction','Below');
    CloseCornerEpochDur_b(i) = nanmean(Stop(CloseCornerEpoch_b,'s')-Start(CloseCornerEpoch_b,'s'));
    
    Dist_Corner_c = tsd(Range(Ytsd),sqrt((Data(Ytsd)-Corner(3)/Ratio_IMAonREAL).^2+(Data(Xtsd)-Corner(3,2)/Ratio_IMAonREAL).^2));
    CloseCornerEpoch_c = thresholdIntervals(Dist_Corner_c,5,'Direction','Below');
    CloseCornerEpochDur_c(i) = nanmean(Stop(CloseCornerEpoch_c,'s')-Start(CloseCornerEpoch_c,'s'));
    
    Dist_Corner_d = tsd(Range(Ytsd),sqrt((Data(Ytsd)-Corner(4)/Ratio_IMAonREAL).^2+(Data(Xtsd)-Corner(4,2)/Ratio_IMAonREAL).^2));
    CloseCornerEpoch_d = thresholdIntervals(Dist_Corner_d,5,'Direction','Below');
    CloseCornerEpochDur_d(i) = nanmean(Stop(CloseCornerEpoch_d,'s')-Start(CloseCornerEpoch_d,'s'));
    
    TimeCloseCorner = CloseCornerEpochDur + CloseCornerEpochDur_b + CloseCornerEpochDur_c + CloseCornerEpochDur_d
end


MtzlMice = [757 759 760 762 764];
for j = 1:length(MtzlMice)
    cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/4DqysPost/FEAR-Mouse-',num2str(MtzlMice(j)),'-16062018-Hab_00'])
    load('behavResources.mat')
    
    Dist_Middle = tsd(Range(Ytsd),sqrt((Data(Ytsd)-Middle(1)/Ratio_IMAonREAL).^2+(Data(Xtsd)-Middle(2)/Ratio_IMAonREAL).^2));
    CloseMiddleEpoch_Mtzl = thresholdIntervals(Dist_Middle,5,'Direction','Below');
    CloseMiddleEpochDur_Mtzl(j) = nanmean(Stop(CloseMiddleEpoch_Mtzl,'s')-Start(CloseMiddleEpoch_Mtzl,'s'));
    
    CloseEdgeEpoch_Mtzl = thresholdIntervals(Dist_Middle,5,'Direction','Above');
    CloseEdgeEpochDur_Mtzl(j) = nanmean(Stop(CloseEdgeEpoch_Mtzl,'s')-Start(CloseEdgeEpoch_Mtzl,'s'));
    
    
    
    Dist_Corner_mtzl = tsd(Range(Ytsd),sqrt((Data(Ytsd)-Corner(1)/Ratio_IMAonREAL).^2+(Data(Xtsd)-Corner(1,2)/Ratio_IMAonREAL).^2));
    CloseCornerEpoch_mtzl = thresholdIntervals(Dist_Corner_mtzl,5,'Direction','Below');
    CloseCornerEpochDur_mtzl(i) = nanmean(Stop(CloseCornerEpoch_mtzl,'s')-Start(CloseCornerEpoch_mtzl,'s'));
    
    Dist_Corner_mtzl_b = tsd(Range(Ytsd),sqrt((Data(Ytsd)-Corner(2)/Ratio_IMAonREAL).^2+(Data(Xtsd)-Corner(2,2)/Ratio_IMAonREAL).^2));
    CloseCornerEpoch_mtzl_b = thresholdIntervals(Dist_Corner_mtzl_b,5,'Direction','Below');
    CloseCornerEpochDur_mtzl_b(i) = nanmean(Stop(CloseCornerEpoch_mtzl_b,'s')-Start(CloseCornerEpoch_mtzl_b,'s'));
    
    Dist_Corner_mtzl_c = tsd(Range(Ytsd),sqrt((Data(Ytsd)-Corner(3)/Ratio_IMAonREAL).^2+(Data(Xtsd)-Corner(3,2)/Ratio_IMAonREAL).^2));
    CloseCornerEpoch_mtzl_c = thresholdIntervals(Dist_Corner_mtzl_c,5,'Direction','Below');
    CloseCornerEpochDur_mtzl_c(i) = nanmean(Stop(CloseCornerEpoch_mtzl_c,'s')-Start(CloseCornerEpoch_mtzl_c,'s'));
    
    Dist_Corner_mtzl_d = tsd(Range(Ytsd),sqrt((Data(Ytsd)-Corner(4)/Ratio_IMAonREAL).^2+(Data(Xtsd)-Corner(4,2)/Ratio_IMAonREAL).^2));
    CloseCornerEpoch_mtzl_d = thresholdIntervals(Dist_Corner_mtzl_d,5,'Direction','Below');
    CloseCornerEpochDur_mtzl_d(i) = nanmean(Stop(CloseCornerEpoch_mtzl_d,'s')-Start(CloseCornerEpoch_mtzl_d,'s'));
    
    TimeCloseCorner_mtzl = CloseCornerEpochDur_mtzl + CloseCornerEpochDur_mtzl_b + CloseCornerEpochDur_mtzl_c + CloseCornerEpochDur_mtzl_d
    
end


PlotBarCrossProtocol(CloseMiddleEpochDur, CloseMiddleEpochDur_Mtzl, CloseEdgeEpochDur, CloseEdgeEpochDur_Mtzl)
xticks(1:2)
xticklabels({'Center','Edges'});
ylabel('')


PlotErrorBarN_KJ({CloseMiddleEpochDur, CloseMiddleEpochDur_Mtzl, CloseEdgeEpochDur, CloseEdgeEpochDur_Mtzl, TimeCloseCorner, TimeCloseCorner_mtzl })