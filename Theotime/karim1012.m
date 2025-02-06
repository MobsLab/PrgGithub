
edit BasileStufff.m

cd('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/')
load behavResources.mat
load SpikeData.mat
load SWR

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


m = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv');

% size(m)
% figure, plot(m(:,1),m(:,2))
% figure, plot(m(:,1),m(:,3))
% figure, plot(m(:,2),m(:,3))

%% Show the density of the prediction
pts = linspace(0, 1, 25);
x = m(:,2);
y=m(:,3);
N = histcounts2(y, x, pts, pts);
subplot(1, 2, 1);
scatter(x, y, 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
subplot(1, 2, 2);
image(pts, pts, N );
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');



m = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featureTrue.csv');
figure, plot(m(:,2),m(:,3))
figure, hist(predi(:,2),1000)

mp = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/featurePred.csv');
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
predi = csvread('/media/mickey/DataMOBS210/DimaERC2/M1199TEST1_Basile/TEST/results/200/lossPred.csv');
hold on, plot(mp(find(predi(:,2)<5),1),mp(find(predi(:,2)<5),3),'ko')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko')
hold on, plot(mp(find(predi(:,2)<-5),1),mp(find(predi(:,2)<-5),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)<-8),1),mp(find(predi(:,2)<-8),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)>-5),1),mp(find(predi(:,2)>-5),3),'ko','markerfacecolor','k')
figure, plot(m(:,1),m(:,3),'b.-'), hold on,  plot(mp(:,1),mp(:,3),'r.-')
hold on, plot(mp(find(predi(:,2)>-3),1),mp(find(predi(:,2)>-3),3),'ko','markerfacecolor','k')

k=80;

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(Stsd{k},testPre),Restrict(X,testPre),Restrict(Y,testPre));

[C,B]=CrossCorr(Range(tRipples),Range(Stsd{k}),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')

[C,B]=CrossCorr(Range(Restrict(tRipples,testPre)),Range(PoolNeurons(Stsd,1:90)),1,300);
figure, bar(B/1E3,C,1,'k'), line([0 0],ylim,'color','r')
sw=Range(tRipples);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',10);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',100);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:100)), -1500,+1500,'BinSize',1);
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:90), ts(sw(1:500)), -1500,+1500,'BinSize',1);

% edit mETAverage
% [m,s,tps]=mETAverage(e,t,v,binsize,nbBins);

figure, plot(predi(:,1),predi(:,2))
figure, plot(Data(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
% figure, plot(range(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(Range(Restrict(X,testPre)),Data(Restrict(Y,testPre)))
figure, plot(Range((X)),Data((Y)))
figure, plot(predi(:,1),predi(:,2))
figure, RasterPlot(S)
figure,
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),80,0)
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),id,0) %Neurons indexed
%                                                         according to id
subplot(5,1,1:3), RasterPlot(Restrict(Stsd,tot))       %No particular indexation
% subplot(5,1,1:3), [fh,sq,sweeps] = RasterPETH(Stsd{80}, ts((TimeStepsPred(1)+TimeStepsPred(end))/2), -100000,+100000, 'BinSize', 1000);
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
figure,
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),80,0)
% subplot(5,1,1:3), RasterPlotid(Restrict(Stsd,tot),id,0) %Neurons indexed
%                                                         according to id
subplot(5,1,1:3), RasterPlot(Restrict(Stsd,tot))       %No particular indexation
% subplot(5,1,1:3), [fh,sq,sweeps] = RasterPETH(Stsd{80}, ts((TimeStepsPred(1)+TimeStepsPred(end))/2), -100000,+100000, 'BinSize', 1000);
%%%%%%%%subplot(5,1,4), plot(Range(Restrict(LFP,tot),'sec'),Data(Restrict(LFP,tot)),'k'), ylim([-6000 6000]);hold on, plot(Range(tRipples,'sec'), 5000,'r*')
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