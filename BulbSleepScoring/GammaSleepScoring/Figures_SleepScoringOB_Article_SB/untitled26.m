clear all, close all
AllSlScoringMice_SleepScoringArticle_SB
sm = 6;
for file=1:m
    
    %Getting the right Epochs
    file
    cd(filename2{file})
    clear X Y
    load('StateEpochSBAllOB.mat','smooth_1015','SWSEpoch','TenFif_thresh')
    load('SleepBimodBeta.mat','X','Y')
    AllX(file,:) = X{sm}-log(nanmean(Data(Restrict(smooth_1015,SWSEpoch))));
    AllY(file,:) = Y{sm}/sum(Y{sm});
    TenFif_thresh_sub(file) = log(TenFif_thresh)-log(nanmean(Data(Restrict(smooth_1015,SWSEpoch))));
end

XToUse = [-1.5:0.01:1];
for file=1:m
    AllY_int(file,:) = interp1(AllX(file,:),runmean(AllY(file,:),2),XToUse);
end