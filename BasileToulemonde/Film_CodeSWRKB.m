%CodeSWRKB

% 1161
DirAnalyse{1} = '/media/mobs/DimaERC2/DataERC2/M1161/TEST';
DirAnalyse2{1}= '/media/nas5/ProjetERC2/Mouse-K161/20201224/_Concatenated/resultsDecoding';
% 1199
DirAnalyse{2} =  '/media/mobs/DimaERC2/TEST1_Basile/TEST';
DirAnalyse2{2}  = '/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated/resultsDecoding';
% 905
DirAnalyse{3} =  '/media/mobs/DimaERC2/DataERC2/M905/TEST';
DirAnalyse2{3}  = '/media/nas5/ProjetERC2/Mouse-905/20190404/PAGExp/_Concatenated/resultsDecoding';

%1186 PAG
DirAnalyse{4} = '/media/mobs/DimaERC2/DataERC2/M1186/TEST';
DirAnalyse2{4} = '/media/nas6/ProjetERC2/Mouse-K186/20210409/_Concatenated/resultsDecoding';

% 1336 MFB
DirAnalyse{5} = '/media/mobs/DimaERC2/Known_M1336/TEST';
DirAnalyse2{5} = '/media/nas7/ProjetERC1/Known/M1336/resultsDecoding';
% 1281 MFB
DirAnalyse{6} =  '/media/mobs/DimaERC2/TEST3_Basile_1281MFB/TEST';
DirAnalyse2{6}  = '/media/nas7/ProjetERC1/StimMFBWake/M1281/resultsDecoding';
% 1239 MFB
DirAnalyse{7} =  '/media/mobs/DimaERC2/TEST3_Basile_M1239/TEST';
DirAnalyse2{7}  = '/media/nas6/ProjetERC1/StimMFBWake/M1239/Exp2/resultsDecoding';
% 1168 MFB
DirAnalyse{8} = '/media/mobs/DimaERC2/DataERC1/M1168/TEST';
DirAnalyse2{8} = '/media/nas5/ProjetERC1/StimMFBWake/M1168/resultsDecoding';
%1117 MFB
DirAnalyse{9} = '/media/mobs/DimaERC2/DataERC1/M1117/TEST';
DirAnalyse2{9} = '/media/nas5/ProjetERC1/StimMFBWake/M1117/resultsDecoding';

ResT=[];

for i=1:9
    
    cd(DirAnalyse{i})

load('DataPred200.mat')
load('Epochs200.mat')
load('DataDoAnalysisFor1mouse.mat')

cd ..
load('behavResources.mat')
cd TEST

MovEpoch=thresholdIntervals(V,7,'Direction','Above');
ImmobEpoch=thresholdIntervals(V,2,'Direction','Below');

%epoch=condi;
%epoch=and(hab,ImmobEpoch);
epoch=and(condi,ImmobEpoch);
%epoch=and(testPre,MovEpoch);

EpochOK=and(GoodEpoch200,epoch); Res(1)=nanmean(abs(Data(Restrict(LinearPredTsd200, EpochOK))-Data(Restrict(LinearTrueTsd200, EpochOK))));
EpochOK=and(BadEpoch200,epoch); Res(2)=nanmean(abs(Data(Restrict(LinearPredTsd200, EpochOK))-Data(Restrict(LinearTrueTsd200, EpochOK))));

RipEpoch=intervalSet(Range(tRipples)-0.5*1E4,Range(tRipples)+0.5*1E4);
RipEpoch=mergeCloseIntervals(RipEpoch,1);

EpochOK=and(RipEpoch,and(GoodEpoch200,epoch)); Res(3)=nanmean(abs(Data(Restrict(LinearPredTsd200, EpochOK))-Data(Restrict(LinearTrueTsd200, EpochOK))));
EpochOK=and(RipEpoch,and(BadEpoch200,epoch)); Res(4)=nanmean(abs(Data(Restrict(LinearPredTsd200, EpochOK))-Data(Restrict(LinearTrueTsd200, EpochOK))));

EpochOK=and(GoodEpoch200,epoch)-RipEpoch; Res(5)=nanmean(abs(Data(Restrict(LinearPredTsd200, EpochOK))-Data(Restrict(LinearTrueTsd200, EpochOK))));
EpochOK=and(BadEpoch200,epoch)-RipEpoch; Res(6)=nanmean(abs(Data(Restrict(LinearPredTsd200, EpochOK))-Data(Restrict(LinearTrueTsd200, EpochOK))));

Res(7)=sum(DurationEpoch(and(RipEpoch,and(GoodEpoch200,epoch))))/(sum(DurationEpoch(and(RipEpoch,and(GoodEpoch200,epoch))))+sum(DurationEpoch(and(RipEpoch,and(BadEpoch200,epoch)))))*100;
Res(8)=sum(DurationEpoch(and(GoodEpoch200,epoch)-RipEpoch))/(sum(DurationEpoch(and(GoodEpoch200,epoch)-RipEpoch))+sum(DurationEpoch(and(BadEpoch200,epoch)-RipEpoch)))*100;

%figure, subplot(1,2,1), plot(Res(1:6),'ko-'), xlim([0 7]), ylim([0 0.4]), subplot(1,2,2), plot(Res(7:8),'ko-'), xlim([0 3]), ylim([0 100]), title(pwd)

ResT=[ResT;Res];
end

a=1;b=4;
%a=5;b=9;
figure, subplot(1,2,1), PlotErrorBarN_KJ(ResT(a:b,1:6),'newfig',0); xlim([0 7]), ylim([0 0.6]), subplot(1,2,2), PlotErrorBarN_KJ(ResT(a:b,7:8),'newfig',0); xlim([0 3]), ylim([0 100])





%%

% 1161
DirAnalyse{1} = '/media/mobs/DimaERC2/DataERC2/M1161/TEST';
DirAnalyse2{1}= '/media/nas5/ProjetERC2/Mouse-K161/20201224/_Concatenated/resultsDecoding';
% 1199
DirAnalyse{2} =  '/media/mobs/DimaERC2/TEST1_Basile/TEST';
DirAnalyse2{2}  = '/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated/resultsDecoding';
% 905
DirAnalyse{3} =  '/media/mobs/DimaERC2/DataERC2/M905/TEST';
DirAnalyse2{3}  = '/media/nas5/ProjetERC2/Mouse-905/20190404/PAGExp/_Concatenated/resultsDecoding';

%1186 PAG
DirAnalyse{4} = '/media/mobs/DimaERC2/DataERC2/M1186/TEST';
DirAnalyse2{4} = '/media/nas6/ProjetERC2/Mouse-K186/20210409/_Concatenated/resultsDecoding';

% 1336 MFB
DirAnalyse{5} = '/media/mobs/DimaERC2/Known_M1336/TEST';
DirAnalyse2{5} = '/media/nas7/ProjetERC1/Known/M1336/resultsDecoding';
% 1281 MFB
DirAnalyse{6} =  '/media/mobs/DimaERC2/TEST3_Basile_1281MFB/TEST';
DirAnalyse2{6}  = '/media/nas7/ProjetERC1/StimMFBWake/M1281/resultsDecoding';
% 1239 MFB
DirAnalyse{7} =  '/media/mobs/DimaERC2/TEST3_Basile_M1239/TEST';
DirAnalyse2{7}  = '/media/nas6/ProjetERC1/StimMFBWake/M1239/Exp2/resultsDecoding';
% 1168 MFB
DirAnalyse{8} = '/media/mobs/DimaERC2/DataERC1/M1168/TEST';
DirAnalyse2{8} = '/media/nas5/ProjetERC1/StimMFBWake/M1168/resultsDecoding';
%1117 MFB
DirAnalyse{9} = '/media/mobs/DimaERC2/DataERC1/M1117/TEST';
DirAnalyse2{9} = '/media/nas5/ProjetERC1/StimMFBWake/M1117/resultsDecoding';

cd(DirAnalyse{2})

clear
load('DataPred200.mat')
load('Epochs200.mat')
load('DataDoAnalysisFor1mouse.mat')

cd ..
 load('behavResources.mat', 'StimEpoch','X','Y','V')
cd TEST
isConditionningGood
figure('color',[1 1 1]), hold on
plot(Range(Restrict(LinearPredTsd200, hab)), Data(Restrict(LinearPredTsd200, hab)),'.-','color',[0.7 0.7 0.7])
plot(Range(Restrict(LinearTrueTsd200, hab)), Data(Restrict(LinearTrueTsd200, hab)),'r-','linewidth',3)
plot(Range(Restrict(LinearPredTsd200, and(GoodEpoch200,hab))), Data(Restrict(LinearPredTsd200, and(GoodEpoch200,hab))),'bo','markerfacecolor','b'), ylim([0 1])
try, plot(Range(Restrict(stim,hab)),0,'ko','markerfacecolor','y'), end
try, plot(Range(Restrict(tRipples,hab)),0.9,'ko','markerfacecolor','c'), end

figure('color',[1 1 1]), 

%%
videoFileName = 'animation_condi2.avi';
frameRate = 30;
v = VideoWriter(videoFileName);
v.FrameRate = frameRate;
open(v);
pas=0.2;paswindow=30;
testepoch=condi; 

testepoch=mergeCloseIntervals(testepoch,30*1E4); 
stim=ts(Start(StimEpoch));
a=Start(testepoch);a=a(1); 
e=End(testepoch); e=e(end);
clf
subplot(2,4,5:7), hold on
%line([a a]+paswindow*1E4,[0 1],'color','k','linewidth',5)
plot(Range(Restrict(LinearPredTsd200, testepoch)), Data(Restrict(LinearPredTsd200, testepoch)),'.-','color',[0.7 0.7 0.7])
plot(Range(Restrict(LinearTrueTsd200, testepoch)), Data(Restrict(LinearTrueTsd200, testepoch)),'r-','linewidth',3)
plot(Range(Restrict(LinearPredTsd200, and(GoodEpoch200,testepoch))), Data(Restrict(LinearPredTsd200, and(GoodEpoch200,testepoch))),'bo','markerfacecolor','b'), ylim([0 1])
try, plot(Range(Restrict(stim,testepoch)),0,'ko','markerfacecolor','y'), end
try, plot(Range(Restrict(tRipples,testepoch)),0.9,'ko','markerfacecolor','c'), end

while a<e-10E4
Epoch=intervalSet(a,a+paswindow*1E4);
rg=Start(Epoch,'s');
subplot(2,4,1:2), cla, hold on,
plot(Range(Restrict(LinearTrueTsd200, Epoch)), Data(Restrict(LinearTrueTsd200, Epoch)),'r-','linewidth',3), try, xlim([a a+paswindow*1E4]), end
plot(Range(Restrict(LinearPredTsd200, Epoch)), Data(Restrict(LinearPredTsd200, Epoch)),'.-','color',[0.7 0.7 0.7])
plot(Range(Restrict(LinearPredTsd200, and(GoodEpoch200,Epoch))), Data(Restrict(LinearPredTsd200, and(GoodEpoch200,Epoch))),'bo','markerfacecolor','b'), ylim([0 1])
 try, plot(Range(Restrict(stim,Epoch)),0,'ko','markerfacecolor','y'), end
try, plot(Range(Restrict(tRipples,Epoch)),1,'ko','markerfacecolor','c'), end
subplot(2,4,3:4), cla, hold on
plot(Range(Restrict(LinearTrueTsd200, Epoch)), Data(Restrict(LinearTrueTsd200, Epoch)),'r-','linewidth',3)
plot(Range(Restrict(LinearPredTsd200, and(GoodEpoch200,Epoch))), Data(Restrict(LinearPredTsd200, and(GoodEpoch200,Epoch))),'bo','markerfacecolor','b'), ylim([0 1]), try, xlim([a a+paswindow*1E4]), end
try, plot(Range(Restrict(stim,Epoch)),0,'ko','markerfacecolor','y'), end
try, plot(Range(Restrict(tRipples,Epoch)),1,'ko','markerfacecolor','c'), end
subplot(2,4,5:7), hold on
plot(a+paswindow*1E4,1,'k.')
subplot(2,4,8), cla, hold on
plot(Data(Restrict(X,testepoch)),Data(Restrict(Y,testepoch)),'.','color',[0.7 0.7 0.7])
plot(Data(Restrict(X,Epoch)),Data(Restrict(Y,Epoch)),'.-','color',[1 0.2 0.2])
x=Data(Restrict(X,Epoch));
y=Data(Restrict(Y,Epoch));
plot(x(end),y(end),'ko','markerfacecolor','r','markersize',10)
xlim([0 1]),ylim([0 1])
a=a+pas*1E4;
%pause(0)
frame = getframe(gcf);
writeVideo(v, frame);
end
close(v);
%%
lin=Data(LinearTrueTsd200);

for i=1:length(lin)
if lin(i)>0&lin(i)<0.4
pos(i,1)= 0;
pos(i,2)= lin(i);
end
if lin(i)>0.4&lin(i)<0.6
pos(i,1)= (lin(i)-0.4)*2;
pos(i,2)= 1;
end
if lin(i)>0.6&lin(i)<1
 pos(i,1)= 0;
pos(i,2)= 1-lin(i);
end
end

    