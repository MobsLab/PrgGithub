cd /media/mobs/DimaERC2/TEST1_Basile/TEST
%cd /media/mobs/DimaERC2/DataERC2/M1161/TEST
load('DataDoAnalysisFor1mouse.mat')
load('DataPred36.mat')
load('DataPred200.mat')
load('DataPred504.mat')
load('Epochs36.mat')
load('Epochs200.mat')
load('Epochs504.mat')
cd /media/mobs/DimaERC2/TEST1_Basile
%cd /media/mobs/DimaERC2/DataERC2/M1161
load('behavResources.mat')
load('SWR.mat')
binS=[0.05:0.05:0.9];
ImmobEpoch=thresholdIntervals(V,1,'Direction','Below');

%%
[h1,b]=hist(Data(Restrict(LinearPredTsd200tot,and(GoodEpoch200,and(RipplesEpoch,SessionEpoch.PreSleep)))),binS);
[h2,b]=hist(Data(Restrict(LinearPredTsd200tot,and(GoodEpoch200,and(RipplesEpoch,or(hab,testPre))))),binS);
[h3,b]=hist(Data(Restrict(LinearPredTsd200tot,and(GoodEpoch200,and(RipplesEpoch,condi)))),binS);
[h4,b]=hist(Data(Restrict(LinearPredTsd200tot,and(GoodEpoch200,and(RipplesEpoch,SessionEpoch.PostSleep)))),binS);
d1=sum(DurationEpoch(and(RipplesEpoch,SessionEpoch.PreSleep),'s'));
d2=sum(DurationEpoch(and(RipplesEpoch,or(hab,testPre)),'s'));
d3=sum(DurationEpoch(and(RipplesEpoch,condi),'s'));
d4=sum(DurationEpoch(and(RipplesEpoch,SessionEpoch.PostSleep),'s'));

figure('color',[1 1 1]),
subplot(2,4,1), bar(b,h1,1,'k'), title('SWR Sleep Pre')
subplot(2,4,2), bar(b,h2,1,'k'),title('SWR Hab & test pre')
subplot(2,4,3),  bar(b,h3,1,'k'),title('SWR Cond')
subplot(2,4,4), bar(b,h4,1,'k'),title('SWR Sleep Post')
subplot(2,4,5:8), hold on,
plot(b,h1/d1,'ko-')
plot(b,h2/d2,'o-','color',[0.7 0.7 0.7])
plot(b,h3/d3,'bo-')
plot(b,h4/d4,'ro-')

%%
[h1,b]=hist(Data(Restrict(LinearPredTsd200tot,and(GoodEpoch200,SessionEpoch.PreSleep))),binS);
[h2,b]=hist(Data(Restrict(LinearTrueTsd200,or(hab,testPre))),binS);
[h3,b]=hist(Data(Restrict(LinearTrueTsd200,condi)),binS);
[h4,b]=hist(Data(Restrict(LinearTrueTsd200,testPost)),binS);
[h5,b]=hist(Data(Restrict(LinearPredTsd200tot,and(GoodEpoch200,SessionEpoch.PostSleep))),binS);
d1=sum(DurationEpoch(and(GoodEpoch200,SessionEpoch.PreSleep),'s'));
d2=sum(DurationEpoch(or(hab,testPre),'s'));
d3=sum(DurationEpoch(condi,'s'));
d4=sum(DurationEpoch(testPost,'s'));
d5=sum(DurationEpoch(and(GoodEpoch200,SessionEpoch.PostSleep),'s'));

figure('color',[1 1 1]),
subplot(2,5,1), bar(b,h1,1,'k'),title('Sleep Pre')
subplot(2,5,2), bar(b,h2,1,'k'),title('Hab & test pre')
subplot(2,5,3), bar(b,h3,1,'k'),title('Cond')
subplot(2,5,5),  bar(b,h4,1,'k'),title('test post')
subplot(2,5,4), bar(b,h5,1,'k'),title('Sleep Post')
subplot(2,5,6:10), hold on,
plot(b,h1/d1,'ko-')
plot(b,h2/d2,'o-','color',[0.7 0.7 0.7])
plot(b,h3/d3,'bo-')
plot(b,h4/d4,'co-')
plot(b,h5/d5,'ro-')

%%
[h1,b]=hist(Data(Restrict(LinearPredTsd200tot,and(and(ImmobEpoch,GoodEpoch200),SessionEpoch.PreSleep))),binS);
[h2,b]=hist(Data(Restrict(LinearTrueTsd200,and(ImmobEpoch,or(hab,testPre)))),binS);
[h3,b]=hist(Data(Restrict(LinearTrueTsd200,and(ImmobEpoch,condi))),binS);
[h4,b]=hist(Data(Restrict(LinearTrueTsd200,and(ImmobEpoch,testPost))),binS);
[h5,b]=hist(Data(Restrict(LinearPredTsd200tot,and(and(ImmobEpoch,GoodEpoch200),SessionEpoch.PostSleep))),binS);
d1=sum(DurationEpoch(and(and(ImmobEpoch,GoodEpoch200),SessionEpoch.PreSleep),'s'));
d2=sum(DurationEpoch(and(ImmobEpoch,or(hab,testPre)),'s'));
d3=sum(DurationEpoch(and(ImmobEpoch,condi),'s'));
d4=sum(DurationEpoch(and(ImmobEpoch,testPost),'s'));
d5=sum(DurationEpoch(and(and(ImmobEpoch,GoodEpoch200),SessionEpoch.PostSleep),'s'));

figure('color',[1 1 1]),
subplot(2,5,1), bar(b,h1,1,'k'),title('Sleep Pre')
subplot(2,5,2), bar(b,h2,1,'k'),title('Hab & test pre')
subplot(2,5,3), bar(b,h3,1,'k'),title('Cond')
subplot(2,5,4),  bar(b,h4,1,'k'),title('test post')
subplot(2,5,5), bar(b,h5,1,'k'),title('Sleep Post')
subplot(2,5,6:10), hold on,
plot(b,h1/d1,'ko-')
plot(b,h2/d2,'o-','color',[0.7 0.7 0.7])
plot(b,h3/d3,'bo-')
plot(b,h4/d4,'co-')
plot(b,h5/d5,'ro-')
