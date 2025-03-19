function MakeData_Stimulator()

%% MakeData_Stimulator

%% Parameters

load([pwd '/LFPData/DigInfo3.mat']);
figure, plot(Range(DigTSD,'s'),Data(DigTSD)); ylim([-1 2])
StimSent = thresholdIntervals(DigTSD,0.001,'Direction','Above');
save('StimSent.mat', 'StimSent');

end