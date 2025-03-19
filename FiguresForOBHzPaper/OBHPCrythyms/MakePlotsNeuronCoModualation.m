function MakePlotsNeuronCoModualation(Phase1,Phase2,SubPlotCoord,NBins,SmooFact,ShuffleTimes,Normalize)

NumSpk=size(Phase1,1);
try Normalize
    catch,Normalize=ones(NBins,NBins);    
end

subplot(SubPlotCoord(1,1),SubPlotCoord(1,2),SubPlotCoord(1,3))
[nn,xx,yy]=hist2(Phase1,Phase2,NBins,NBins);
nn=nn/NumSpk;
imagesc(xx,yy,SmoothDec(nn,SmooFact)./Normalize),axis xy, hold on
xlim([min(xx) max(xx)]),ylim([min(yy) max(yy)])
Caxlim=clim;

subplot(SubPlotCoord(2,1),SubPlotCoord(2,2),SubPlotCoord(2,3))
nnval=zeros(NBins,NBins);
Shuff=[1:max([ceil(length(Phase1)/ShuffleTimes),1]):length(Phase1)-1];

ShuffleTimes=length(Shuff);
for c=Shuff
    [nn,xx,yy]=hist2(Phase1,circshift(Phase2,c),NBins,NBins); axis xy, hold on
    nnval=nnval+nn;
end
nnval=nnval/ShuffleTimes;nnval=nnval/NumSpk;
imagesc(xx,yy,SmoothDec(nnval,SmooFact)./Normalize),axis xy, hold on
xlim([min(xx) max(xx)]),ylim([min(yy) max(yy)])

subplot(SubPlotCoord(3,1),SubPlotCoord(3,2),SubPlotCoord(3,3))
[Y1,x]=hist(Phase1,NBins);Y1=Y1/sum(Y1);
[Y2,x]=hist(Phase2,NBins);Y2=Y2/sum(Y2);

imagesc(x,x,SmoothDec(Y1'*Y2,SmooFact)'./Normalize),axis xy, hold on
xlim([min(x) max(x)]),ylim([min(x) max(x)])

subplot(SubPlotCoord(1,1),SubPlotCoord(1,2),SubPlotCoord(1,3))
clim(Caxlim)
subplot(SubPlotCoord(2,1),SubPlotCoord(2,2),SubPlotCoord(2,3))
clim(Caxlim)
subplot(SubPlotCoord(3,1),SubPlotCoord(3,2),SubPlotCoord(3,3))
clim(Caxlim)

end