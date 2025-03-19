
function Grooming_Epoch = FindGrooming_BM(Speed , Accelero)

smooth_time = 1;

Acc_smooth_bis = tsd(Range(Accelero) , runmean(Data(Accelero),30));
Speed_Smooth = tsd(Range(Speed) , runmean(Data(Speed),ceil(smooth_time/median(diff(Range(Speed,'s'))))));

NotMoving_Speed = thresholdIntervals(Speed_Smooth , 1 , 'Direction' , 'Below');
% NotMoving_Speed = mergeCloseIntervals(NotMoving_Speed,0.3*1E4);
% NotMoving_Speed = dropShortIntervals(NotMoving_Speed,3*1E4);

HighAcc = thresholdIntervals(Acc_smooth_bis , 6e7);
% HighAcc = mergeCloseIntervals(HighAcc,0.3*1E4);
% HighAcc = dropShortIntervals(HighAcc,3*1E4);

NotMoving_HighAcc = and(NotMoving_Speed , HighAcc);
% NotMoving_HighAcc = mergeCloseIntervals(NotMoving_HighAcc,0.3*1E4);
% NotMoving_HighAcc = dropShortIntervals(NotMoving_HighAcc,3*1E4);

Grooming_Epoch = NotMoving_HighAcc;




