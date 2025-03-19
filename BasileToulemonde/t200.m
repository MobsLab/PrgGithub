% On recommence tout pour 200

%% MAKING SURE THE TSD TOOLS ARE USABLE
addpath(genpath('/home/mobs/Dropbox/Kteam/PrgMatlab/FMAtoolbox/'))
addpath(genpath('/home/mobs/Dropbox/Kteam/Fra'))
addpath(genpath('/home/mobs/Dropbox/Kteam/PrgMatlab'))
addpath('/home/mobs/Dropbox/Kteam/PrgMatlab')

%% GOING TO THE RIGHT DIRECTORY
nasDir = '/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated'
cd(nasDir)

nasResultsDecoding = strcat(nasDir, '/resultsDecoding')
%% LOADING BEHAVIOR DATA
load behavResources.mat

X=AlignedXtsd;
Y=AlignedYtsd;
V=Vtsd;

% Assigning the epochs
preSleep=SessionEpoch.PreSleep;
hab = or(SessionEpoch.Hab1,SessionEpoch.Hab2);
testPre=or(or(SessionEpoch.Hab1,SessionEpoch.Hab2),or(or(SessionEpoch.TestPre1,SessionEpoch.TestPre2),or(SessionEpoch.TestPre3,SessionEpoch.TestPre4)));
cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
postSleep=SessionEpoch.PostSleep;
testPost=or(or(SessionEpoch.TestPost1,SessionEpoch.TestPost2),or(SessionEpoch.TestPost3,SessionEpoch.TestPost4));
extinct = SessionEpoch.Extinct;
sleep = or(preSleep,postSleep);
tot=or(or(hab,or(testPre,or(testPost,or(cond,extinct)))),sleep);

%% LOADING SPIKE DATA
load SpikeData.mat
Stsd=S;

%% LOADING SWR DATA
load SWR

%% LOADING LFP DATA 
% To know which channel, go to /ChannelsToAnalyse/dHPC_rip.mat
load LFPData/LFP14

%% PATH TO THE RESULTS
folderResults = "/media/mobs/DimaERC2/TEST1_Basile/TEST"
resultsPath = "/media/mobs/DimaERC2/TEST1_Basile/TEST/results/200"
resultsPath_preSleep = "/media/mobs/DimaERC2/TEST1_Basile/TEST/results_Sleep/200/PreSleep"
resultsPath_postSleep = "/media/mobs/DimaERC2/TEST1_Basile/TEST/results_Sleep/200/PostSleep"

%% IMPORTING THE RESULTS AND CONVERSION TO TSD
[TimeStepsPred,LinearTrue,LinearPred,TimeStepsPredPreSleep,TimeStepsPredPostSleep,LinearPredPreSleep,LinearPredPostSleep,LossPred, LossPredPreSleep,LossPredPostSleep,LossPredTsd, LossPredPreSleepTsd,LossPredPostSleepTsd,LinearTrueTsd, LinearPredTsd,LinearPredPreSleepTsd,LinearPredPostSleepTsd] = importResultsf(folderResults, nasResultsDecoding, 200)

%% CONCATENATE SLEEP AND WAKE
tps=[TimeStepsPredPreSleep;TimeStepsPred;TimeStepsPredPostSleep]*1E4;
val1=[LinearPredPreSleep;LinearPred;LinearPredPostSleep];
val2=[LossPredPreSleep;LossPred;LossPredPostSleep]
[tps,id]=sort(tps);
val1=val1(id);
val2=val2(id);
LinearPredTsdtot=tsd(tps,val1);
LossPredTsdtot=tsd(tps,val2);

%% DEFINING EPOCHS ACCORDING TO THE VALUE OF PREDICTED LOSS
BadEpoch=thresholdIntervals(LossPredTsdtot,-2.5,'Direction','Above'); % PL>-2.5
GoodEpoch=thresholdIntervals(LossPredTsdtot,-4,'Direction','Below'); % PL<-4

%% PLOTS WITH THE PREDICTED LOSS : RUN THE PREVIOUS SECTION BEFORE

% Plotting the decoded position at each point of predicted loss
% Blue : Good     ;      Green : Bad
LinearPredTsdtot = LinearPredTsd200tot
LinearTrueTsd = LinearTrueTsd200
figure, 
subplot(3,1,1), hold on, 
plot(Range(Restrict(LinearTrueTsd, tot),'s'), Data(Restrict(LinearTrueTsd, tot)),'r','linewidth',2)
plot(Range(Restrict(LinearPredTsdtot, tot),'s'), Data(Restrict(LinearPredTsdtot, tot)),'k.','markersize',5)
plot(Range(Restrict(LinearPredTsdtot, BadEpoch),'s'), Data(Restrict(LinearPredTsdtot, BadEpoch)),'g.','markersize',15)
plot(Range(Restrict(LinearPredTsdtot, GoodEpoch),'s'), Data(Restrict(LinearPredTsdtot, GoodEpoch)),'b.','markersize',15)
% Adding the ripples : high certainty along with a ripple is good sign of a
% reactivation
line([Range(tRipples,'s') Range(tRipples,'s')],ylim/2,'color','b')

% Only good
subplot(3,1,2), hold on, 
plot(Range(Restrict(LinearTrueTsd, tot),'s'), Data(Restrict(LinearTrueTsd, tot)),'r','linewidth',2)
plot(Range(Restrict(LinearPredTsdtot, tot),'s'), Data(Restrict(LinearPredTsdtot, tot)),'k.','markersize',5)
%plot(Range(Restrict(LinearPredTsd, BadEpoch),'s'), Data(Restrict(LinearPredTsd, BadEpoch)),'g.','markersize',15)
plot(Range(Restrict(LinearPredTsdtot, GoodEpoch),'s'), Data(Restrict(LinearPredTsdtot, GoodEpoch)),'b.','markersize',15)
line([Range(tRipples,'s') Range(tRipples,'s')],ylim/2,'color','b')

% Only bad
subplot(3,1,3), hold on, 
plot(Range(Restrict(LinearTrueTsd, tot),'s'), Data(Restrict(LinearTrueTsd, tot)),'r','linewidth',2)
plot(Range(Restrict(LinearPredTsdtot, tot),'s'), Data(Restrict(LinearPredTsdtot, tot)),'k.','markersize',5)
plot(Range(Restrict(LinearPredTsdtot, BadEpoch),'s'), Data(Restrict(LinearPredTsdtot, BadEpoch)),'g.','markersize',15)
%plot(Range(Restrict(LinearPredTsd, GoodEpoch),'s'), Data(Restrict(LinearPredTsd, GoodEpoch)),'b.','markersize',15)
line([Range(tRipples,'s') Range(tRipples,'s')],ylim/2,'color','b')

%% MEAN LINEAR ERROR
 linearError = abs(Data(Restrict(LinearPredTsd, tot)) - Data(Restrict(LinearTrueTsd, tot)));
 meanLinearError = mean(linearError);
 
 %% MEAN PREDICTED LOSS
 lossPred = abs(Data(Restrict(LossPredTsd, tot)));
 meanLossPred = mean(lossPred);
 
 %% STUFF
Epoch=BadEpoch;

figure, 
subplot(2,1,1), hold on
plot(Range(Restrict(LinearTrueTsd, Epoch),'s'), Data(Restrict(LinearTrueTsd, Epoch)),'r')
hold on, plot(Range(Restrict(LinearPredTsd, Epoch),'s'), Data(Restrict(LinearPredTsd, Epoch)),'.-','color',[0.7 0.7 0.7])
hold on, plot(Range(Restrict(LinearPredTsd, Epoch),'s'), Data(Restrict(LinearPredTsd, Epoch)),'k.')
plot(Range(Restrict(LinearTrueTsd, Epoch),'s'), Data(Restrict(LinearTrueTsd, Epoch)),'r','linewidth',2)
subplot(2,1,2), hold on, plot(Data(Restrict(LinearTrueTsd, Epoch)),Data(Restrict(LossPredTsd, Epoch)),'k.'),ylim([-10 -2])


figure, 
plot(Data(Restrict(LinearTrueTsd, Restrict(LossPredTsd, Epoch)))-Data(Restrict(LinearPredTsd, Restrict(LossPredTsd, Epoch))),Data(Restrict(LossPredTsd, Epoch)),'k.'),ylim([-10 -2])


%% TRUE VS DECODED
id=[80,44,49,58,60,62]; % indexes of the cells for which we want to see the spikes , identified in the step above

figure,
subplot(5,1,1:4), RasterPlotid(Restrict(Stsd,preSleep),id,0);
subplot(5,1,5), hold on, plot(Range(Restrict(LinearTrueTsd, preSleep),'s'), Data(Restrict(LinearTrueTsd, preSleep)),'r')
plot(Range(Restrict(LinearPredPreSleepTsd,preSleep),'s'),Data(Restrict(LinearPredPreSleepTsd,preSleep)),'b');
a=TimeStepsPredPreSleep(1);
l=100; a=a+l; subplot(5,1,1:4), xlim([a*1E3 a*1E3+l*1E3]), subplot(5,1,5), xlim([a a+l])
subplot(5,1,1:4), xlabel('Time'), ylabel('Spikes of the Selected Place Cells')
subplot(5,1,5), xlabel('Time'), ylabel('Linearized Position')

 