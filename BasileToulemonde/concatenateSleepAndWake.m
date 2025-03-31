% 1161
% folderResults = '/media/mobs/DimaERC2/DataERC2/M1161/TEST'
% nasResultsDecoding = '/media/nas5/ProjetERC2/Mouse-K161/20201224/_Concatenated/resultsDecoding'
% 1161 control
% folderResults = '/media/mobs/DimaERC2/DataERC2/M1161/TEST_with_1199_model'
resultsPath = '/media/mobs/DimaERC2/DataERC2/M1161/TEST_with_1199_model'
% nasResultsDecoding = '/media/nas5/ProjetERC2/Mouse-K161/20201224/_Concatenated/resultsDecoding_control'
%1199
% dir = '/media/mobs/DimaERC2/TEST1_Basile/TEST'
% 1336
% folderResults = '/media/mobs/DimaERC2/Known_M1336/TEST'
% nasResultsDecoding = '/media/nas7/ProjetERC1/Known/M1336/resultsDecoding'

[TimeStepsPred36,LinearTrue36,LinearPred36,TimeStepsPredPreSleep36,TimeStepsPredPostSleep36,LinearPredPreSleep36,LinearPredPostSleep36,LossPred36, LossPredPreSleep36,LossPredPostSleep36,LossPredTsd36, LossPredPreSleepTsd36,LossPredPostSleepTsd36,LinearTrueTsd36, LinearPredTsd36,LinearPredPreSleepTsd36,LinearPredPostSleepTsd36] = importResultsf(folderResults, nasResultsDecoding, 36);
[TimeStepsPred200,LinearTrue200,LinearPred200,TimeStepsPredPreSleep200,TimeStepsPredPostSleep200,LinearPredPreSleep200,LinearPredPostSleep200,LossPred200, LossPredPreSleep200,LossPredPostSleep200,LossPredTsd200, LossPredPreSleepTsd200,LossPredPostSleepTsd200,LinearTrueTsd200, LinearPredTsd200,LinearPredPreSleepTsd200,LinearPredPostSleepTsd200] = importResultsf(folderResults, nasResultsDecoding, 200);
[TimeStepsPred504,LinearTrue504,LinearPred504,TimeStepsPredPreSleep504,TimeStepsPredPostSleep504,LinearPredPreSleep504,LinearPredPostSleep504,LossPred504, LossPredPreSleep504,LossPredPostSleep504,LossPredTsd504, LossPredPreSleepTsd504,LossPredPostSleepTsd504,LinearTrueTsd504, LinearPredTsd504,LinearPredPreSleepTsd504,LinearPredPostSleepTsd504] = importResultsf(folderResults, nasResultsDecoding, 504);

%CONCATENATE SLEEP AND WAKE
tps36=[TimeStepsPredPreSleep36;TimeStepsPred36;TimeStepsPredPostSleep36]*1E4;
linearPred36tot=[LinearPredPreSleep36;LinearPred36;LinearPredPostSleep36];
lossPredtot36=[LossPredPreSleep36;LossPred36;LossPredPostSleep36];
[tps36,id36]=sort(tps36);
linearPred36tot=linearPred36tot(id36);
lossPredtot36=lossPredtot36(id36);
LinearPredTsd36tot=tsd(tps36,linearPred36tot);
LossPredTsd36tot=tsd(tps36,lossPredtot36);

tps200=[TimeStepsPredPreSleep200;TimeStepsPred200;TimeStepsPredPostSleep200]*1E4;
linearPred200tot=[LinearPredPreSleep200;LinearPred200;LinearPredPostSleep200];
lossPredtot200=[LossPredPreSleep200;LossPred200;LossPredPostSleep200];
[tps200,id200]=sort(tps200);
linearPred200tot=linearPred200tot(id200);
lossPredtot200=lossPredtot200(id200);
LinearPredTsd200tot=tsd(tps200,linearPred200tot);
LossPredTsd200tot=tsd(tps200,lossPredtot200);

tps504=[TimeStepsPredPreSleep504;TimeStepsPred504;TimeStepsPredPostSleep504]*1E4;
linearPred504tot=[LinearPredPreSleep504;LinearPred504;LinearPredPostSleep504];
lossPredtot504=[LossPredPreSleep504;LossPred504;LossPredPostSleep504];
[tps504,id504]=sort(tps504);
linearPred504tot=linearPred504tot(id504);
lossPredtot504=lossPredtot504(id504);
LinearPredTsd504tot=tsd(tps504,linearPred504tot);
LossPredTsd504tot=tsd(tps504,lossPredtot504);

figure,
hold on;
subplot(3,1,1), hold on, plot(Range(Restrict(LinearTrueTsd36, tot),'s'), Data(Restrict(LinearTrueTsd36,tot)),'k','linewidth',0.1);
subplot(3,1,1), hold on, plot(Range(Restrict(LinearPredTsd36tot, tot),'s'), Data(Restrict(LinearPredTsd36tot,tot)),'r.','markersize',5);
subplot(3,1,2), hold on, plot(Range(Restrict(LinearTrueTsd200, tot),'s'), Data(Restrict(LinearTrueTsd200,tot)),'k','linewidth',0.1);
subplot(3,1,2), hold on, plot(Range(Restrict(LinearPredTsd200tot, tot),'s'), Data(Restrict(LinearPredTsd200tot,tot)),'r.','markersize',5);
subplot(3,1,3), hold on, plot(Range(Restrict(LinearTrueTsd504, tot),'s'), Data(Restrict(LinearTrueTsd504,tot)),'k','linewidth',0.1);
subplot(3,1,3), hold on, plot(Range(Restrict(LinearPredTsd504tot, tot),'s'), Data(Restrict(LinearPredTsd504tot,tot)),'r.','markersize',5);
a=TimeStepsPredPreSleep(1);
l=5000; a=a+l; subplot(3,1,1), xlim([a a+l]),subplot(3,1,2), xlim([a a+l]),subplot(3,1,3), xlim([a a+l])
% t1 = 1.2*1E4
% t2 = 1.4*1E4
% subplot(3,1,1), xlim([t1,t2])
% subplot(3,1,2), xlim([t1,t2])
% subplot(3,1,3), xlim([t1,t2])
xlabel('Time(s)')
subplot(3,1,1), ylabel('Linear Position')
subplot(3,1,2), ylabel('Linear Position')
subplot(3,1,3), ylabel('Linear Position')
subplot(3,1,1), title('36ms window')
subplot(3,1,2), title('200ms window')
subplot(3,1,3), title('504ms window')