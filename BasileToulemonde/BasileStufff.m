%BasileStufff


%%
addpath(genpath('~/Dropbox/Kteam/PrgMatlab/FMAtoolbox/'))
addpath(genpath('~/Dropbox/Kteam/Fra'))
addpath(genpath('~/Dropbox/Kteam/PrgMatlab'))
addpath('~/Dropbox/Kteam/PrgMatlab')

%%
cd('/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated')
load behavResources.mat
load SpikeData.mat
load SWR
load LFPData/LFP14
cd('~/download/')

%%
try
    % old fashion data
    Range(S{1});
    Stsd=S;
    t=Range(AlignedXtsd);
    X=AlignedXtsd;

    Y=AlignedYtsd;
    V=Vtsd;
    preSleep=SessionEpoch.PreSleep;
    hab = or(SessionEpoch.Hab1,SessionEpoch.Hab2);
    testPre=or(or(SessionEpoch.Hab1,SessionEpoch.Hab2),or(or(SessionEpoch.TestPre1,SessionEpoch.TestPre2),or(SessionEpoch.TestPre3,SessionEpoch.TestPre4)));
    cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
    postSleep=SessionEpoch.PostSleep;
    testPost=or(or(SessionEpoch.TestPost1,SessionEpoch.TestPost2),or(SessionEpoch.TestPost3,SessionEpoch.TestPost4));
    extinct = SessionEpoch.Extinct;
    sleep = or(preSleep,postSleep);
    tot=or(or(hab,or(testPre,or(testPost,or(cond,extinct)))),sleep);
catch
    % Dima's style of data 
    clear Stsd
    for i=1:length(S.C)
    test=S.C{1,i};
    Stsd{i}=ts(test.data);
    end
    Stsd=tsdArray(Stsd);
    t = AlignedXtsd.data;
    X = tsd(AlignedXtsd.t,AlignedXtsd.data);
    Y = tsd(AlignedYtsd.t,AlignedYtsd.data);
    V = tsd(Vtsd.t,Vtsd.data);
    hab1 = intervalSet(SessionEpoch.Hab1.start,SessionEpoch.Hab1.stop);
    hab2 = intervalSet(SessionEpoch.Hab2.start,SessionEpoch.Hab2.stop);
    testPre1=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre1.stop);
    testPre2=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre2.stop);
    testPre3=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre3.stop);
    testPre4=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre4.stop);
    testPre=or(or(hab1,hab2),or(or(testPre1,testPre2),or(testPre3,testPre4)));
    cond1 = intervalSet(SessionEpoch.Cond1.start,SessionEpoch.Cond1.stop);
    cond2 = intervalSet(SessionEpoch.Cond2.start,SessionEpoch.Cond2.stop);
    cond3 = intervalSet(SessionEpoch.Cond3.start,SessionEpoch.Cond3.stop);
    cond4 = intervalSet(SessionEpoch.Cond4.start,SessionEpoch.Cond4.stop);
    cond = or(or(cond1,cond2),or(cond3,cond4));
    postSleep = intervalSet(SessionEpoch.PostSleep.start,SessionEpoch.PostSleep.stop);
    preSleep = intervalSet(SessionEpoch.PreSleep.start,SessionEpoch.PreSleep.stop);
    sleep = or(preSleep,postSleep);
    tot = or(testPre,sleep);
end

%%
mice = 1199;
Dir = PathForExperimentsERC("Sub");
Dir = RestrictPathForExperiment(Dir, 'nMice', mice);

csvLinearPred = csvread([ Dir.path{1}{1}  '/TEST/results/200/linearPred.csv']);
idxLinearPred = csvLinearPred(2:end,1);
LinearPred=csvLinearPred(2:end,2);
save('linearPred.mat', 'idxLinearPred', 'LinearPred')
csvTimeStepsPred = csvread([Dir.path{1}{1}  '/TEST/results/200/timeStepsPred.csv']);
idxTimeStepsPred = csvTimeStepsPred(2:end,1);
TimeStepsPred = csvTimeStepsPred(2:end,2);
save('timeStepsPred.mat', 'idxTimeStepsPred', 'TimeStepsPred')

csvLossPred = csvread([ Dir.path{1}{1} '/TEST/results/200/lossPred.csv']);
idxLossPred = csvLossPred(2:end,1);
LossPred=csvLossPred(2:end,2);
save('lossPred.mat', 'idxLossPred', 'LossPred')


csvLinearTrue = csvread([ Dir.path{1}{1} '/TEST/results/200/linearTrue.csv']);
idxLinearTrue = csvLinearTrue(2:end,1);
LinearTrue=csvLinearTrue(2:end,2);
save('linearTrue.mat', 'idxLinearTrue', 'LinearTrue')

%importing decoded position during sleep
csvLinearPredSleep = csvread([ Dir.path{1}{1} '/TEST/results_Sleep/200/PostSleep/linearPred.csv']);
idxLinearPredSleep = csvLinearPredSleep(2:end,1);
LinearPredSleep=csvLinearPredSleep(2:end,2);
save('linearPredSleep.mat', 'idxLinearPredSleep', 'LinearPredSleep')
csvTimeStepsPredSleep = csvread([ Dir.path{1}{1} '/TEST/results_Sleep/200/PostSleep/timeStepsPred.csv']);
idxTimeStepsPredSleep = csvTimeStepsPredSleep(2:end,1);
TimeStepsPredSleep = csvTimeStepsPredSleep(2:end,2);
save('timeStepsPredSleep.mat', 'idxTimeStepsPredSleep', 'TimeStepsPredSleep')

% Concatenating decoded postion before and during sleep

%% Something is wrong here : I am concatenating linearpred and linearpredsleep but the linearpred postsleep 
%% are after sleep so it is incorrect especially for timestepspred where, with this method, some timesteps from after sleep are 
%% placed before sleep

idxLinearPredtot = [idxLinearPred; idxLinearPredSleep];
LinearPredtot=[LinearPred;LinearPredSleep];
save('linearPredtot.mat', 'idxLinearPredtot', 'LinearPredtot')

idxTimeStepsPredtot = [idxTimeStepsPred;idxTimeStepsPredSleep];
TimeStepsPredtot = [TimeStepsPred;TimeStepsPredSleep];
save('timeStepsPredtot.mat', 'idxTimeStepsPredtot', 'TimeStepsPredtot')

%%
k=80;
SpeedEpoch=thresholdIntervals(V,5,'Direction','Above');

figure, plot(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
hold on, scatter(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)),300,Data(Restrict(V,Restrict(Y,testPre))),'filled')

disp('pause')
figure, RasterPlot(Restrict(Stsd,testPost))
disp('pause')
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPre),Restrict(X,testPre),Restrict(Y,testPre));
% [map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},tot),Restrict(X,tot),Restrict(Y,tot));
disp('pause')
k=28;
k=k+1;
% PlaceField(Restrict(Stsd{k},and(tot,SpeedEpoch)),Restrict(X,and(tot,SpeedEpoch)),Restrict(Y,and(tot,SpeedEpoch)));
PlaceField(Restrict(Stsd{k},and(testPre,SpeedEpoch)),Restrict(X,and(testPre,SpeedEpoch)),Restrict(Y,and(testPre,SpeedEpoch)));

disp('pause')
k=1;
rg=Range(X,'s');
tend=rg(end)-rg(1);
T=poissonKB((length(Range(Stsd{k}))/(rg(end)-rg(1)))/1,tend)+rg(1);
Ts=tsd(T'*1E4,T'*1E4);
PlaceField(Restrict(Ts,and(testPre,SpeedEpoch)),Restrict(X,and(testPre,SpeedEpoch)),Restrict(Y,and(testPre,SpeedEpoch)));
k=1;
k=k+1;
[C,B]=CrossCorr(Range(Stsd{k}),Range(Stsd{k+1}),10,100);
figure, bar(B/1E3,C,1,'k')

[C,B]=CrossCorr(Range(Stsd{k}),Range(Stsd{k}),5,100);C(B==0)=0;
figure, bar(B/1E3,C,1,'k')

k=1;
k=k+1;
[C,B]=CrossCorr(Range(tRipples),Range(Stsd{k}),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')

[C,B]=CrossCorr(Range(Restrict(tRipples,testPre)),Range(PoolNeurons(Stsd,1:90)),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')

% 
%     k=1;
% 	Qs = MakeQfromS(Stsd,500);  % 50ms !!!!!
% 	ratek = Restrict(Qs,intervalSet(Ts(1)-30000,Ts(end)+3000));
%     ratek=Qs; 
%     Qs=tsdArray(Qs);
% 	rate = Data(ratek);
% 	ratek = tsd(Range(ratek),rate(:,k));
% 
% ratetotal=tsd(Range(ratek),sum(rate,2));
% figure, plot(Data(ratetotal))
% 
%%
sw=Range(tRipples);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',10);

idx=find(BasicNeuronInfo.neuroclass==1);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,idx), ts(sw(1:200)), -1500,+1500,'BinSize',10);

idxI=find(BasicNeuronInfo.neuroclass==-1);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,idxI), ts(sw(1:200)), -1500,+1500,'BinSize',10);




%%
%LFP is a tsd object, which means time has to be multiplied by 1*E-4 in
%order to be in seconds 
Fil=FilterLFP(LFP,[5 10],1024);

QsTestPre = MakeQfromS(Restrict(Stsd,testPre),5000);  % 50ms !!!!!   

rateTestPre = full(Data(QsTestPre));
 
figure, imagesc(zscore(rateTestPre)'), caxis([-5 5])

% C=cov(zscore(rateTestPre));
% [V,L]=pcacov(C);
% [BE,id]=sort(V(:,1));     % neurons indexed according to covariance
% id = [75,80,49,15,11,63,6,51,90,58,3,74,62,77,14,72,82] %  neurons indexed in order to see the theta sequences
                                                        % TODO :- put some
                                                        % indexes twice and
                                                        % see if it works
                                                        %       - Take only
                                                        %       a few to
                                                        %       see it
                                                        %       better

id = [60,37];
% figure, imagesc(C(id,id)-diag(diag(C)))

% figure, RasterPlotid(Restrict(Stsd,testPre), id)


figure, 
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),80,0)
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),id,0) %Neurons indexed
%                                                         according to id
subplot(5,1,1:3), RasterPlot(Restrict(Stsd,tot))       %No particular indexation
% subplot(5,1,1:3), [fh,sq,sweeps] = RasterPETH(Stsd{80}, ts((TimeStepsPred(1)+TimeStepsPred(end))/2), -100000,+100000, 'BinSize', 1000);
%%%%%%%%

subplot(5,1,4), plot(Range(Restrict(LFP,tot),'sec'),Data(Restrict(LFP,tot)),'k'), ylim([-6000 6000]);hold on, plot(Range(tRipples,'sec'), 5000,'r*')
% plot(Range(Restrict(Fil,tot),'sec'),Data(Restrict(Fil,tot)),'r','linewidth',2)
% subplot(5,1,5), hold on, plot(TimeStepsPred,LinearPred, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r')
subplot(5,1,5), hold on, plot(TimeStepsPredtot,LinearPredtot, 'b'), hold on, plot(TimeStepsPred, LinearTrue, 'r'), ylim([0 1])
%subplot(5,1,5), hold on, plot(Range(Restrict(X,testPre),'ms'),Data(Restrict(X,testPre)),'ko-'),plot(Range(Restrict(Y,testPre),'ms'),Data(Restrict(Y,testPre)),'ro-'), ylim([0 1])
a=TimeStepsPred(1);
l=1000; a=a+l*0.5; subplot(5,1,1:3), xlim([a*1E3 a*1E3+l*1E3]), subplot(5,1,4),xlim([a a+l]), subplot(5,1,5), xlim([a a+l])
%l=10; a=a-l*0.5; subplot(5,1,1:3), xlim([a*1E3-l*1E3 a*1E3]), subplot(5,1,4),xlim([a-l a]), subplot(5,1,5), xlim([a-l a])
%subplot(5,1,1:3), xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,4),xlim([TimeStepsPred(1) TimeStepsPred(end)]), subplot(5,1,5), xlim([TimeStepsPred(1) TimeStepsPred(end)])
subplot(5,1,1:3), xlabel('Time'), ylabel('Place Cell')
subplot(5,1,4), xlabel('Time'), ylabel('LFP')
subplot(5,1,5), xlabel('Time'), ylabel('Linear Position')
subplot(5,1,5), xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,4),xlim([TimeStepsPredtot(1) TimeStepsPredtot(end)])
subplot(5,1,1:3), xlim([TimeStepsPredtot(1)*1E3 TimeStepsPredtot(end)*1E3])

%% In this section we want to check whether or not the decoding is valid
% In order to do that, we will :
% - train the decoder on the habituation (DONE)
% - use the decoder on the rest of the data (except sleep for now) (DONE)
% - first we check decoding when the mouse is moving since we have ground
% truth (take screenshots)
% - during pretest, when the mouse is not moving, we check if the decoded
% position is coherent with the observed spikes of place cells whose PF is
% clearly defined

% WE WILL DO THESE STEPS FIRST BY PLOTTING THE LINEARIZED POSITION AND THEN
% IN ORDER TO BE MORE PRECISE WE WILL PLOT THE POSITION WITH X AND Y

%Conversion of the decoded position in TSD
LossPredTsd=tsd(TimeStepsPred*1E4,LossPred);

LinearTrueTsd=tsd(TimeStepsPred*1E4,LinearTrue);
LinearPredTsd=tsd(TimeStepsPred*1E4,LinearPred);
LinearPredSleepTsd=tsd(TimeStepsPredSleep*1E4,LinearPredSleep);

LossPredCorrected=LossPred;
LossPredCorrected(LossPredCorrected<-15)=NaN;
LossPredTsdCorrected=tsd(TimeStepsPred*1E4,LossPredCorrected);
LossPredTsd = LossPredTsdCorrected;

BadEpoch=thresholdIntervals(LossPredTsd,-3,'Direction','Above');
GoodEpoch=thresholdIntervals(LossPredTsd,-5,'Direction','Below');
stim=ts(Start(StimEpoch));

figure, 

% This subplot is plotting the true linear in red, and the predicted one
% either in blue if the confidence is high (high predicted loss) , or in
% green if it's low (low/negative predicted loss)
subplot(3,1,1), hold on, 
plot(Range(Restrict(LinearTrueTsd, tot),'s'), Data(Restrict(LinearTrueTsd, tot)),'r','linewidth',2)
plot(Range(Restrict(LinearPredTsd, tot),'s'), Data(Restrict(LinearPredTsd, tot)),'k.','markersize',5)
plot(Range(Restrict(LinearPredTsd, BadEpoch),'s'), Data(Restrict(LinearPredTsd, BadEpoch)),'g.','markersize',15)
plot(Range(Restrict(LinearPredTsd, GoodEpoch),'s'), Data(Restrict(LinearPredTsd, GoodEpoch)),'b.','markersize',15)
line([Range(stim,'s') Range(stim,'s')],ylim,'color','k')
line([Range(tRipples,'s') Range(tRipples,'s')],ylim/2,'color','b')

subplot(3,1,2), hold on, 
% Only plot the good epochs
plot(Range(Restrict(LinearTrueTsd, tot),'s'), Data(Restrict(LinearTrueTsd, tot)),'r','linewidth',2)
plot(Range(Restrict(LinearPredTsd, tot),'s'), Data(Restrict(LinearPredTsd, tot)),'k.','markersize',5)
%plot(Range(Restrict(LinearPredTsd, BadEpoch),'s'), Data(Restrict(LinearPredTsd, BadEpoch)),'g.','markersize',15)
plot(Range(Restrict(LinearPredTsd, GoodEpoch),'s'), Data(Restrict(LinearPredTsd, GoodEpoch)),'b.','markersize',15)
line([Range(stim,'s') Range(stim,'s')],ylim,'color','k')
line([Range(tRipples,'s') Range(tRipples,'s')],ylim/2,'color','b')

subplot(3,1,3), hold on, 
% only plot the bad epochs
plot(Range(Restrict(LinearTrueTsd, tot),'s'), Data(Restrict(LinearTrueTsd, tot)),'r','linewidth',2)
plot(Range(Restrict(LinearPredTsd, tot),'s'), Data(Restrict(LinearPredTsd, tot)),'k.','markersize',5)
plot(Range(Restrict(LinearPredTsd, BadEpoch),'s'), Data(Restrict(LinearPredTsd, BadEpoch)),'g.','markersize',15)
%plot(Range(Restrict(LinearPredTsd, GoodEpoch),'s'), Data(Restrict(LinearPredTsd, GoodEpoch)),'b.','markersize',15)
line([Range(stim,'s') Range(stim,'s')],ylim,'color','k')
line([Range(tRipples,'s') Range(tRipples,'s')],ylim/2,'color','b')

figure;
subplot(1,2,1);
[hBad,bBad]=hist(Data(Restrict(LinearPredTsd, BadEpoch))-Data(Restrict(LinearTrueTsd, BadEpoch)),500);
[hGood,bGood]=hist(Data(Restrict(LinearPredTsd, GoodEpoch))-Data(Restrict(LinearTrueTsd, GoodEpoch)),500);
hold on, plot(bBad,hBad, 'blue'), plot(bGood,hGood,'r')
legend({'BadEpochs', 'GoodEpochs'}, 'Location', 'best');

xlabel('Linear Error');
ylabel('Number');
title('Distribution of linear prediction error for high and low confidence');
grid on;

subplot(1,2,2)
[hBad,bBad]=histcounts(Data(Restrict(LinearPredTsd, BadEpoch))-Data(Restrict(LinearTrueTsd, BadEpoch)),500);
[hGood,bGood]=histcounts(Data(Restrict(LinearPredTsd, GoodEpoch))-Data(Restrict(LinearTrueTsd, GoodEpoch)),500);
edges = bBad;
counts = hBad;
bin_centers = (edges(1:end-1) + edges(2:end)) / 2;
% Normalize counts to frequencies
frequencies = counts / sum(counts);
hold on; bar(bin_centers, frequencies, 'blue');

edges = bGood;
counts = hGood;
bin_centers = (edges(1:end-1) + edges(2:end)) / 2;
% Normalize counts to frequencies
frequencies = counts / sum(counts);
hold on; bar(bin_centers, frequencies, 'r');
legend({'BadEpochs', 'GoodEpochs'}, 'Location', 'best');
xlabel('Linear Error');
ylabel('Frequency');
title('Distribution of linear prediction error for high and low confidence');


[hBad,bBad]=hist(Data(Restrict(LinearPredTsd, BadEpoch))-Data(Restrict(LinearTrueTsd, BadEpoch)),50);
[hGood,bGood]=hist(Data(Restrict(LinearPredTsd, GoodEpoch))-Data(Restrict(LinearTrueTsd, GoodEpoch)),50);
figure, hold on, plot(bBad,hBad), plot(bGood,hGood,'r')
[hBad,bBad]=hist(Data(Restrict(LinearPredTsd, BadEpoch))-Data(Restrict(LinearTrueTsd, BadEpoch)),100);
[hGood,bGood]=hist(Data(Restrict(LinearPredTsd, GoodEpoch))-Data(Restrict(LinearTrueTsd, GoodEpoch)),100);
figure, hold on, plot(bBad,hBad), plot(bGood,hGood,'r')
[hBad,bBad]=hist(Data(Restrict(LinearPredTsd, BadEpoch))-Data(Restrict(LinearTrueTsd, BadEpoch)),70);
[hGood,bGood]=hist(Data(Restrict(LinearPredTsd, GoodEpoch))-Data(Restrict(LinearTrueTsd, GoodEpoch)),70);
figure, hold on, plot(bBad,hBad), plot(bGood,hGood,'r')

% We need to find PC whose PF are clearly defined DURING PRETEST : to find
% them we plot the observed spikes of each place cells during pretest, by 
% plotting red dots at the locations of the maze where the mouse was when the 
% spike took place. We do that with a speed treshold otherwise the spikes 
% might be linked to a reactivation rather than to the actual location of
% the mouse
SpeedEpoch=thresholdIntervals(V,5,'Direction','Above');

k=80;

PlaceField(Restrict(Stsd{k},and(testPre,SpeedEpoch)),Restrict(X,and(testPre,SpeedEpoch)),Restrict(Y,and(testPre,SpeedEpoch)));

% for k=1:90;
%     PlaceField(Restrict(Stsd{k},and(testPre,SpeedEpoch)),Restrict(X,and(testPre,SpeedEpoch)),Restrict(Y,and(testPre,SpeedEpoch)));
% end

id=[80,44,49,58,60,62]; % indexes of the cells for which we want to see the spikes

figure,
subplot(5,1,1:4), RasterPlotid(Restrict(Stsd,testPre),id,0);
subplot(5,1,5), hold on, plot(Range(Restrict(LinearTrueTsd, testPre),'s'), Data(Restrict(LinearTrueTsd, testPre)),'r')
plot(Range(Restrict(LinearPredTsd,testPre),'s'),Data(Restrict(LinearPredTsd,testPre)),'b');
a=TimeStepsPred(1);
l=10; a=a+l; subplot(5,1,1:4), xlim([a*1E3 a*1E3+l*1E3]), subplot(5,1,5), xlim([a a+l])
subplot(5,1,1:4), xlabel('Time'), ylabel('Spikes of the Selected Place Cells')
subplot(5,1,5), xlabel('Time'), ylabel('Linearized Position')

%% In this section we want to see what is the decoded position during conditioning 
% In particular, we want to see whether or not the shock zone is
% reactivated when the mouse stops outside of it, which could correspond to
% rumination

% The problem is that during conditioning the mouse doesn't go in the shock
% zone as much as before. As a consequence, when plotting the firing map of
% all 90 cells only during conditioning, the shock zone won't be as
% represented as during habituation. The question is : is there remapping ?
% If not, we can consider the PC whose PF identified during habituation was
% almost only in the shock zone and use them to see whether or not they are
% reactived during conditioning, especially when the mouse is in reality in
% the safe zone. If yes, what do we do since it will be hard, if not 
% impossible, to identify PF located in the shock zone during conditionning?

% Indexes of place cells that code (mostly) for the shock zone during testPre.
idx_shockZone_testPre = [44,62];

% Indexes of place cells that code mostly for the shock zone during
% conditionning (if some can be found...)
idx_shockZone_cond = [62]; % la PC62 garde une firing map axée sur la shock zone mais elle fire aussi à d'autres endroits

LinearTrueTsd=tsd(TimeStepsPred*1E4,LinearTrue);
condTime = Range(Restrict(LinearTrueTsd,cond),'s'); %Time interval of the conditioning (for a)

figure,
subplot(5,1,1:4), RasterPlotid(Restrict(Stsd,cond),idx_shockZone_testPre,0);
subplot(5,1,5), hold on, plot(Range(Restrict(LinearTrueTsd, cond),'s'), Data(Restrict(LinearTrueTsd, cond)),'r')
plot(Range(Restrict(LinearPredTsd,cond),'s'),Data(Restrict(LinearPredTsd,cond)),'b');
hold on, plot(Range(tRipples,'sec'), 0.9,'r*') % We also plot the ripples because reactivations occur during ripples
subplot(5,1,5), ylim([0 1])
a=condTime(1);
l=10; a=a+l; subplot(5,1,1:4), xlim([a*1E3 a*1E3+l*1E3]), subplot(5,1,5), xlim([a a+l])
subplot(5,1,1:4), xlabel('Time'), ylabel('Spikes of the Selected Place Cells')
subplot(5,1,5), xlabel('Time'), ylabel('Linearized Position')
%%

id = [60,37];

figure,
subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),id,0)
subplot(5,1,4), plot(TimeStepsPredSleep, LinearPredSleep)
subplot(5,1,5), plot(Range(Restrict(LFP, sleep),'sec'), Data(Restrict(LFP, sleep)),'k'), ylim([-6000 6000]); hold on

LinearTrueTsd=tsd(TimeStepsPred*1E4,LinearTrue);
LinearPredTsd=tsd(TimeStepsPred*1E4,LinearPred);
LinearPredSleepTsd=tsd(TimeStepsPredSleep*1E4,LinearPredSleep);

%no Tsd except Ripples but converted in sec with 's'
figure, hold on,
plot(TimeStepsPredSleep, LinearPredSleep,'color',[0.7 0.7 0.7])
plot(TimeStepsPredSleep, LinearPredSleep,'k.')
hold on, plot(TimeStepsPred, LinearPred,'b.')
hold on, plot(TimeStepsPred, LinearTrue,'r')
hold on, plot(TimeStepsPred, LinearTrue,'r.','markersize',10)
hold on, plot(Range(tRipples,'s'),Data(Restrict(LinearTrueTsd,tRipples)),'ko','markerfacecolor','y')

%tsd  but not for the time-axe so no prb
figure, hold on,
plot(TimeStepsPredSleep, Data(LinearPredSleepTsd),'color',[0.7 0.7 0.7])
plot(TimeStepsPredSleep, Data(LinearPredSleepTsd),'k.')
hold on, plot(TimeStepsPred, Data(LinearPredTsd),'b.')
hold on, plot(TimeStepsPred, Data(LinearTrueTsd),'r')
hold on, plot(TimeStepsPred, Data(LinearTrueTsd),'r.','markersize',10)
hold on, plot(Range(tRipples,'s'),Data(Restrict(LinearTrueTsd,tRipples)),'ko','markerfacecolor','y')

%tsd everywhere so the time is in 1/10000 s and I have to remove the 's'
%for the ripples
figure, hold on,
plot(Range(LinearPredSleepTsd), Data(LinearPredSleepTsd),'color',[0.7 0.7 0.7])
plot(Range(LinearPredSleepTsd), Data(LinearPredSleepTsd),'k.')
hold on, plot(Range(LinearPredTsd), Data(LinearPredTsd),'b.')
hold on, plot(Range(LinearTrueTsd), Data(LinearTrueTsd),'r')
hold on, plot(Range(LinearTrueTsd), Data(LinearTrueTsd),'r.','markersize',10)
hold on, plot(Range(tRipples),Data(Restrict(LinearTrueTsd,tRipples)),'ko','markerfacecolor','y')


[h1,b1]=hist(Data(Restrict(LinearTrueTsd,testPre)),50);
[h2,b2]=hist(Data(Restrict(LinearPredTsd,testPre)),50);
[h3,b3]=hist(Data(Restrict(LinearPredSleepTsd,postSleep)),50);
[h4,b4]=hist(Data(Restrict(LinearPredSleepTsd,preSleep)),50);
RipEp=intervalSet(Range(tRipples)-0.2*1E4,Range(tRipples)+0.2*1E4);RipEp=mergeCloseIntervals(RipEp,1);
[h4,b4]=hist(Data(Restrict(LinearPredSleepTsd,RipEp)),50);

[h5,b5]=hist(Data(Restrict(LinearPredSleepTsd,REMEpoch)),50);

figure, plot(b1,h1/max(h1),'k')
hold on, plot(b2,h2/max(h2),'b'), 
plot(b3,h3/max(h3),'r'), 
plot(b4,h4/max(h4),'color',[0.6 0.6 0.6])
plot(b5,h5/max(h5),'color',[0.6 1 0.6])

SpeedEpoch=thresholdIntervals(V,5,'Direction','Above');
Ep=intervalSet(1.2327*1E8,1.5210*1E8);

k=k+1; 
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},Ep),Restrict(X,Ep),Restrict(Y,Ep));
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},Ep),Restrict(LinearTrueTsd,Ep),Restrict(LinearPredTsd,Ep));
% [map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},and(testPre,SpeedEpoch)),Restrict(LinearTrueTsd,and(testPre,SpeedEpoch)),Restrict(LinearPredTsd,and(testPre,SpeedEpoch)));
k=k+1; 
[m1,s1,t1]=mETAverage(Range(Restrict(Stsd{k},testPre)),Range(Restrict(LinearTrueTsd,testPre)),Data(Restrict(LinearTrueTsd,testPre)),30,100);
[m2,s2,t2]=mETAverage(Range(Restrict(Stsd{k},testPre)),Range(Restrict(LinearPredTsd,testPre)),Data(Restrict(LinearPredTsd,testPre)),30,100);
figure, hold on, plot(t1/1E3,s1,'k'), plot(t2/1E3,s2,'r'),ylim([0 1])

figure, hold on
plot(Range(Restrict(LinearPredTsd,testPre)),Data(Restrict(LinearPredTsd,testPre)),'.')
plot(Range(Restrict(LinearTrueTsd,testPre)),Data(Restrict(LinearTrueTsd,testPre)))
plot(Range(Restrict(LinearTrueTsd,Restrict(Stsd{k},testPre))),Data(Restrict(LinearPredTsd,Restrict(Stsd{k},testPre))),'r.','markersize',15)


 
 figure, hold on
plot(Data(Restrict(LinearTrueTsd,testPre)),Data(Restrict(LinearPredTsd,testPre)))
plot(Data(Restrict(LinearTrueTsd,Restrict(Stsd{k},testPre))),Data(Restrict(LinearPredTsd,Restrict(Stsd{k},testPre))),'r.')
 


figure, 
subplot(1,2,1), plot(Data(LinearTrueTsd),Data(Restrict(X,LinearTrueTsd)))
subplot(1,2,2), plot(Data(LinearTrueTsd),Data(Restrict(Y,LinearTrueTsd)))


 figure, 
 subplot(5,1,1:4), RasterPlot(S)
 subplot(5,1,5),plot(Range(LinearPredTsd),LinearPred)
hold on, plot(Range(Restrict(X,ts(Start(StimEpoch)))),Data(Restrict(Y,ts(Start(StimEpoch)))),'r.','markersize',10)

figure, plot(Data(Restrict(X,cond)),Data(Restrict(Y,cond)));
hold on, plot(Data(Restrict(X,ts(Start(StimEpoch)))), Data(Restrict(Y,ts(Start(StimEpoch)))),'r.','markersize',10)
figure, plot(Data(Restrict(X,testPost)),Data(Restrict(Y,testPost)))