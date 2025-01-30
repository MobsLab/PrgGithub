figure, imagesc(MP)
Undefined function or variable 'MP'.
 
figure, imagesc(MH)
load('LFPData/DigInfo2.mat')
load('SleepScoring_OBGamma.mat')
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
load('ExpeInfo')
pathname='Figures'
pathname2='Figures/Average_Spectrums'

for k = 1:length(Start(TTLEpoch_merged))
LittleEpoch = subset(TTLEpoch_merged,k);
Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end


REM10s=Ordered_REM(:,2)
REM10_20s=Ordered_REM(:,5)
REM20_30s=Ordered_REM(:,8)
REM30setplus=Ordered_REM(:,11)



events=REM10s

%%%Pour l'HPC (à changer si le load est différent)
load('dHPC_deep_Low_Spectrum')
SpectroH2=Spectro
%%AveargeSpectre Stim REM (0)
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title('HPC REM10s')
savefig(fullfile(pathname2,'HPC_REM10s'))

pathname =

    'Figures'


pathname2 =

    'Figures/Average_Spectrums'


REM10s =

   1.0e+04 *

    0.5891
    0.9012
    0.9690
    1.5342
    1.5702
    2.4333


REM10_20s =

   1.0e+04 *

    0.7831
    1.8985
    2.5778
       NaN
       NaN
       NaN


REM20_30s =

   NaN
   NaN
   NaN
   NaN
   NaN
   NaN


REM30setplus =

   NaN
   NaN
   NaN
   NaN
   NaN
   NaN


events =

   1.0e+04 *

    0.5891
    0.9012
    0.9690
    1.5342
    1.5702
    2.4333


SpectroH2 =

  1×3 cell array

    {130430×261 double}    {1×130430 double}    {1×261 double}

figure, imagesc(MH)
val=SpectroH2{2};
figure, imagesc(val)
val=SpectroH2{1};
figure, imagesc(val)
val=SpectroH2{3};
figure, imagesc(val)
val=SpectroH2{1};
figure, imagesc(val)
figure, imagesc(10*log10(val))
figure, imagesc(10*log10(val'))
figure, imagesc(10*log10(val')), axis xy
figure, plot(SpectroH2{3})
fq=find(SpectroH2{3}>6&SpectroH2{3}<10);
thetaPower=mean(SpectroH2{1}(fq,:),1);
figure, plot(thetaPower)
thetaPower=mean(SpectroH2{1}(:,fq),2);
figure, plot(thetaPower)
figure, imagesc(10*log10(val')), axis xy
hold on, plot(rescale(thetaPower,15,20))
figure, imagesc(SpectroH2{2},SpectroH2{3},10*log10(val')), axis xy
hold on, plot(SpectroH2{2},rescale(thetaPower,15,20))
caxis([30 50])
caxis([30 60])
caxis([20 55])
fq=find(SpectroH2{3}>6&SpectroH2{3}<8);
fq2=find(SpectroH2{3}>2&SpectroH2{3}<4);
thetaPower=mean(SpectroH2{1}(:,fq),2)./mean(SpectroH2{1}(:,fq2),2);
hold on, plot(SpectroH2{2},rescale(thetaPower,10,15),'k')
xl=xlim;
a=xl(1);
a=a+10E4; xlim(a,a+10E4)
Error using xlim (line 31)
When 2 input arguments are specified, the first argument
must be an axes.
 
a=xl(1); xlim(a,a+10E4)
Error using xlim (line 31)
When 2 input arguments are specified, the first argument
must be an axes.
 
a=xl(1); xlim([a,a+10E4])
a=xl(1); xlim([a,a+1E4])
a=a+1E4; xlim([a,a+1E4])
a=0;
a=a+1E4; xlim([a,a+1E4])
vv=tsd(SpectroH2{2}*1E4,thetaPower);
[Mm,Tm]=PlotRipRaw(vv,Restrict(ts(events*1E4),REMEpoch));
Error using ts/size
Too many input arguments.

Error in PlotRipRaw (line 44)
if size(events,2)>2
 
help PlotRipRaw
 PlotRipRaw
 
  [M,T] = PlotRipRaw(LFP, events, durations, cleaning, PlotFigure)
 
 
 %INPUT
  events : in seconds
  durations in ms
 
 %OUTPUT
  M :   time, mean, std, stdError
  T :   matrix
 
 

[Mm,Tm]=PlotRipRaw(vv,Restrict(ts(events*1E4),REMEpoch),800);
Error using ts/size
Too many input arguments.

Error in PlotRipRaw (line 44)
if size(events,2)>2
 
[Mm,Tm]=PlotRipRaw(vv,Restrict(ts(events*1E4),REMEpoch));
Error using ts/size
Too many input arguments.

Error in PlotRipRaw (line 44)
if size(events,2)>2
 
whos events
  Name        Size            Bytes  Class     Attributes

  events      6x1                48  double              

[Mm,Tm]=PlotRipRaw(vv,ts(events*1E4));
Error using ts/size
Too many input arguments.

Error in PlotRipRaw (line 44)
if size(events,2)>2
 
[Mm,Tm]=PlotRipRaw(vv,events);
[Mm,Tm]=PlotRipRaw(vv,events*1E4);
edit PLotRipRaw
events=Range(Restrict(ts(events*1E4),REMEpoch)))
 events=Range(Restrict(ts(events*1E4),REMEpoch)))
                                                ↑
Error: Unbalanced or unexpected parenthesis or bracket.
 
events=Range(Restrict(ts(events*1E4),REMEpoch));
[Mm,Tm]=PlotRipRaw(vv,events/1E4);
figure, plot(Data(vv))
size'events)
 size'events)
      ↑
Error: Unexpected MATLAB expression.
 
size(events)

ans =

     6     1

StimREM=size(Start(and(TTLEpoch_merged,REMEpoch)))

StimREM =

    23     1



load('LFPData/DigInfo2.mat')
load('SleepScoring_OBGamma.mat')
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);

for k = 1:length(Start(TTLEpoch_merged))
LittleEpoch = subset(TTLEpoch_merged,k);
Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end


events=Start(TTLEpoch_merged)/1E4;
StartStim_dansREM=Range(Restrict(ts(events*1E4),REMEpoch)))
 StartStim_dansREM=Range(Restrict(ts(events*1E4),REMEpoch)))
                                                           ↑
Error: Unbalanced or unexpected parenthesis or bracket.
 
StartStim_dansREM=Range(Restrict(ts(events*1E4),REMEpoch));
[Mm,Tm]=PlotRipRaw(vv,StartStim_dansREM/1E4);
figure, imagesc(SpectroH2{2},SpectroH2{3},10*log10(val')), axis xy
hold on, plot(StartStim_dansREM/1E4,8,'ko','markerfacecolor','k')
caxis([20 55])
hold on, plot(SpectroH2{2},rescale(thetaPower,10,20),'k')
help mETAverage
 [m,s,tps]=mETAverage(e,t,v,bins,nbBins)
 
  Input:
  e       : times of events
  t       : time of the values  - in 1/10000 sec (assumed to be sorted)
  v       : values
  binsize : size of the bin in ms
  nbBins  : number of bins
  
  Output:
  m   : mean
  S   : time
  tps : times

 [mx,sx,tpsx]=mETAverage(StartStim_dansREM,Range(vv),Data(vv),100,100);
figure, imagesc(tpsx,mx)
Error using image
Incorrect number of arguments.

Error in imagesc (line 40)
    hh = image(varargin{:},'CDataMapping','scaled');
 
figure, plot(tpsx,mx)
[mx,sx,tpsx]=mETAverage(StartStim_dansREM,Range(vv),Data(vv),200,100);
figure, plot(tpsx,mx)
[mx,sx,tpsx]=mETAverage(StartStim_dansREM,Range(vv),Data(vv),200,800);
figure, plot(tpsx,mx)
figure, plot(tpsx/1E3,mx)
[mx,sx,tpsx]=mETAverage(StartStim_dansREM,Range(vv),Data(vv),200,200);
figure, plot(tpsx/1E3,mx)
st=StartStim_dansREM,Range(vv);

st =

   1.0e+08 *

    0.5891
    0.7831
    0.9012
    0.9690
    1.5342
    1.5702
    1.8985
    2.4333
    2.5778

load('M723_Stim_Ordered_REM.mat', 'Ordered_REM')
Ordered_REM

Ordered_REM =

   1.0e+04 *

  Columns 1 through 9

    0.0019    0.5891    0.0020    0.0026    0.7831    0.0003       NaN       NaN       NaN
    0.0035    0.9012    0.0000    0.0072    1.8985    0.0004       NaN       NaN       NaN
    0.0040    0.9690    0.0041    0.0089    2.5778    0.0000       NaN       NaN       NaN
    0.0061    1.5342    0.0005       NaN       NaN       NaN       NaN       NaN       NaN
    0.0064    1.5702    0.0035       NaN       NaN       NaN       NaN       NaN       NaN
    0.0084    2.4333    0.0004       NaN       NaN       NaN       NaN       NaN       NaN

  Columns 10 through 12

       NaN       NaN       NaN
       NaN       NaN       NaN
       NaN       NaN       NaN
       NaN       NaN       NaN
       NaN       NaN       NaN
       NaN       NaN       NaN

length(st)

ans =

     9

[mx,sx,tpsx]=mETAverage(st,Range(vv),Data(vv),200,200);
figure, plot(tpsx/1E3,mx)
REM10s=Ordered_REM(:,2);
REM10_20s=Ordered_REM(:,5);
REM20_30s=Ordered_REM(:,8);
REM30setplus=Ordered_REM(:,11);
[mx,sx,tpsx]=mETAverage(REM10s,Range(vv),Data(vv),200,200);
figure, plot(tpsx/1E3,mx)
REM10s

REM10s =

   1.0e+04 *

    0.5891
    0.9012
    0.9690
    1.5342
    1.5702
    2.4333

st

st =

   1.0e+08 *

    0.5891
    0.7831
    0.9012
    0.9690
    1.5342
    1.5702
    1.8985
    2.4333
    2.5778

[m1,s1,tps1]=mETAverage(REM10s,Range(vv),Data(vv),200,200);
[m2,s2,tps2]=mETAverage(REM10_20s,Range(vv),Data(vv),200,200);
[m3,s3,tps3]=mETAverage(REM30_30s,Range(vv),Data(vv),200,200);
Undefined function or variable 'REM30_30s'.
 
Did you mean:
[m3,s3,tps3]=mETAverage(REM20_30s,Range(vv),Data(vv),200,200);
[m4,s4,tps4]=mETAverage(REM30+,Range(vv),Data(vv),200,200);
 [m4,s4,tps4]=mETAverage(REM30+,Range(vv),Data(vv),200,200);
                               ↑
Error: Expression or statement is incorrect--possibly unbalanced (, {, or [.
 
figure, plot(tpsx/1E3,mx)
[mx,sx,tpsx]=mETAverage(st,Range(vv),Data(vv),200,200);
figure, plot(tpsx/1E3,mx)
hold on, plot(tps1/1E3,m1,'r')
hold on, plot(tps2/1E3,m2,'m')
hold on, plot(tps3/1E3,m3,'k')
figure, imagesc(SpectroH2{2},SpectroH2{3},10*log10(val')), axis xy
caxis([20 55])
hold on, plot(StartStim_dansREM/1E4,8,'ko','markerfacecolor','k')
hold on, plot(REM10s/1E4,8,'ko','markerfacecolor','r')
hold on, plot(REM10s,8,'ko','markerfacecolor','r')
[m1,s1,tps1]=mETAverage(REM10s*1E4,Range(vv),Data(vv),200,200);
[m2,s2,tps2]=mETAverage(REM10_20s*1E4,Range(vv),Data(vv),200,200);
[m3,s3,tps3]=mETAverage(REM20_30s,Range(vv),Data(vv),200,200);
[m3,s3,tps3]=mETAverage(REM20_30s,Range(vv),Data(vv),200,200);
[m3,s3,tps3]=mETAverage(REM20_30s*1E4,Range(vv),Data(vv),200,200);
figure, plot(tpsx/1E3,mx)
hold on, plot(tps1/1E3,m1,'r')
hold on, plot(tps2/1E3,m2,'m')
hold on, plot(tps3/1E3,m3,'k')
close all
figure, imagesc(SpectroH2{2},SpectroH2{3},10*log10(val')), axis xy
caxis([20 55])
hold on, plot(StartStim_dansREM/1E4,8,'ko','markerfacecolor','k')
hold on, plot(REM10s,8,'ko','markerfacecolor','r')
figure, plot(tpsx/1E3,mx)
hold on, plot(tps1/1E3,m1,'r')
hold on, plot(tps2/1E3,m2,'m')
hold on, plot(tps3/1E3,m3,'k')
[Mm,Tm]=PlotRipRaw(vv,StartStim_dansREM*1E4);
[Mm,Tm]=PlotRipRaw(vv,StartStim_dansREM);
[Mm,Tm]=PlotRipRaw(vv,REM10s);
[Mm,Tm]=PlotRipRaw(vv,REM10s*1E4);
[Mm,Tm]=PlotRipRaw(Data(vv),REM10s*1E4);
Cannot find an exact (case-sensitive) match for 'Range'

The closest match is: range in /usr/local/MATLAB/R2017b/toolbox/stats/stats/range.m


Error in PlotRipRaw (line 40)
samplingRate = round(1/median(diff(Range(LFP,'s'))));
 
[Mm,Tm]=PlotRipRaw(vv,REM10s*1E4,800);
error
line([0 0],ylim,'color,'k')
 line([0 0],ylim,'color,'k')
                         ↑
Error: Unexpected MATLAB expression.
 
line([0 0],ylim,'color','k')
load('dHPC_deep_Low_Spectrum')
SpectroH2=Spectro
%%AveargeSpectre Stim REM (0)
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title('HPC REM10s')
s

SpectroH2 =

  1×3 cell array

    {130430×261 double}    {1×130430 double}    {1×261 double}

Undefined function or variable 's'.
 

events=REM10s;
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title('HPC REM10s')
hold on, plot(tps1/1E3,m1,'r')
length(evants)
Undefined function or variable 'evants'.
 
Did you mean:
length(events)

ans =

     6

[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},ts(REM10s),500,300);
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},ts(REM10s(2:end)),500,300);
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},ts(REM10s*1E4),500,300);
[m1,s1,tps1]=mETAverage(REM10s*1E4,Range(vv),Data(vv),200,2000);
figure, plot(tps1/1E3,m1)
hold on, plot(tps1/1E3,m1,'k')
hold on, plot(tps1/1E3,m1,'k','linewidth',2)
thetaPower2=mean(SpectroH2{1}(:,fq),2),2);
 thetaPower2=mean(SpectroH2{1}(:,fq),2),2);
                                         ↑
Error: Unbalanced or unexpected parenthesis or bracket.
 
thetaPower2=mean(SpectroH2{1}(:,fq),2);
vv2=tsd(SpectroH2{2}*1E4,thetaPower2);
[m2,s2,tps2]=mETAverage(REM10s*1E4,Range(vv2),Data(vv2),200,2000);
hold on, plot(tps2/1E3,m2,'r','linewidth',2)
hold on, plot(tps2/1E3,m2,'r','linewidth',2)
figure
hold on, plot(tps2/1E3,m2,'r','linewidth',2)
hold on, plot(tps2/1E3,rescale(m2,0 20),'r','linewidth',2)
 hold on, plot(tps2/1E3,rescale(m2,0 20),'r','linewidth',2)
                                     ↑
Error: Unexpected MATLAB expression.
 
hold on, plot(tps2/1E3,rescale(m2,0,20),'r','linewidth',2)
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},ts(REM10s*1E4),500,300);
thetaPower2=10*log10(mean(SpectroH2{1}(:,fq),2));
thetaPower=10*log10(mean(SpectroH2{1}(:,fq),2)./mean(SpectroH2{1}(:,fq2),2));
thetaPower=10*log10(mean(SpectroH2{1}(:,fq),2))./10*log1°(mean(SpectroH2{1}(:,fq2),2));
 thetaPower=10*log10(mean(SpectroH2{1}(:,fq),2))./10*log1°(mean(SpectroH2{1}(:,fq2),2));
                                                         ↑
Error: The input character is not valid in MATLAB statements or expressions.
 
thetaPower=10*log10(mean(SpectroH2{1}(:,fq),2))./10*log10(mean(SpectroH2{1}(:,fq2),2));
Error using  * 
Inner matrix dimensions must agree.
 
thetaPower=10*log10(mean(SpectroH2{1}(:,fq),2))./(10*log10(mean(SpectroH2{1}(:,fq2),2)));
vv2=tsd(SpectroH2{2}*1E4,thetaPower2);
vv=tsd(SpectroH2{2}*1E4,thetaPower);
[m2,s2,tps2]=mETAverage(REM10s*1E4,Range(vv2),Data(vv2),200,2000);
[m1,s1,tps1]=mETAverage(REM10s*1E4,Range(vv),Data(vv),200,2000);
hold on, plot(tps2/1E3,rescale(m2,0,20),'r','linewidth',2)
hold on, plot(tps1/1E3,rescale(m1,0,20),'k','linewidth',2)
fq=find(SpectroH2{3}>6&SpectroH2{3}<8.5);
fq2=find(SpectroH2{3}>3&SpectroH2{3}<5);
thetaPower2=10*log10(mean(SpectroH2{1}(:,fq),2));
thetaPower=10*log10(mean(SpectroH2{1}(:,fq),2))./(10*log10(mean(SpectroH2{1}(:,fq2),2)));
vv2=tsd(SpectroH2{2}*1E4,thetaPower2);
vv=tsd(SpectroH2{2}*1E4,thetaPower);
[m2,s2,tps2]=mETAverage(REM10s*1E4,Range(vv2),Data(vv2),200,2000);
[m1,s1,tps1]=mETAverage(REM10s*1E4,Range(vv),Data(vv),200,2000);
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},ts(REM10s*1E4),500,300);
hold on, plot(tps2/1E3,rescale(m2,0,20),'r','linewidth',2)
hold on, plot(tps1/1E3,rescale(m1,0,20),'k','linewidth',2)

events=StartStim_dansREM;

fq=find(SpectroH2{3}>6&SpectroH2{3}<8.5);
fq2=find(SpectroH2{3}>3&SpectroH2{3}<5);
thetaPower2=10*log10(mean(SpectroH2{1}(:,fq),2));
thetaPower=10*log10(mean(SpectroH2{1}(:,fq),2))./(10*log10(mean(SpectroH2{1}(:,fq2),2)));
vv2=tsd(SpectroH2{2}*1E4,thetaPower2);
vv=tsd(SpectroH2{2}*1E4,thetaPower);
[m2,s2,tps2]=mETAverage(events,Range(vv2),Data(vv2),200,2000);
[m1,s1,tps1]=mETAverage(events,Range(vv),Data(vv),200,2000);
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},ts(events),500,300);
hold on, plot(tps2/1E3,rescale(m2,0,20),'r','linewidth',2)
hold on, plot(tps1/1E3,rescale(m1,0,20),'k','linewidth',2)


events=REM10s*1E4;

%events=StartStim_dansREM;

fq=find(SpectroH2{3}>6&SpectroH2{3}<8.5);
fq2=find(SpectroH2{3}>3&SpectroH2{3}<5);
thetaPower2=10*log10(mean(SpectroH2{1}(:,fq),2));
thetaPower=10*log10(mean(SpectroH2{1}(:,fq),2))./(10*log10(mean(SpectroH2{1}(:,fq2),2)));
vv2=tsd(SpectroH2{2}*1E4,thetaPower2);
vv=tsd(SpectroH2{2}*1E4,thetaPower);
[m2,s2,tps2]=mETAverage(events,Range(vv2),Data(vv2),200,2000);
[m1,s1,tps1]=mETAverage(events,Range(vv),Data(vv),200,2000);
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},ts(events),500,300);
hold on, plot(tps2/1E3,rescale(m2,0,20),'r','linewidth',2)
hold on, plot(tps1/1E3,rescale(m1,0,20),'k','linewidth',2)
edit Raster
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(ratek, ts(st), -10000, +15000,'BinSize',500);
Undefined function or variable 'ratek'.
 
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(vv, ts(events), -10000, +15000,'BinSize',500);
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(vv, ts(events), -100000, +150000,'BinSize',2000);
events=StartStim_dansREM;
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(vv, ts(events), -100000, +150000,'BinSize',2000);
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(vv, ts(events), -10E4, +10E4,'BinSize',2000);
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(vv, ts(events), -10E4, +10E4,'BinSize',500);
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(vv, ts(events*1E4), -10E4, +10E4,'BinSize',500);
Error using area (line 52)
The length of X must match the number of rows of Y.

Error in ImagePETH (line 67)
area(Range(matVal, 's'), dArea, 'FaceColor', 'k');
 
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(vv, ts(events/1E4), -10E4, +10E4,'BinSize',500);
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(vv, ts(events), -10E4, +10E4,'BinSize',500);
figure, plot(mean(Data(matVal))
 figure, plot(mean(Data(matVal))
                                ↑
Error: Expression or statement is incorrect--possibly unbalanced (, {, or [.
 
Did you mean:
figure, plot(mean(Data(matVal)))
figure, plot(mean(Data(matVal)'))
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(vv, ts(events), -20E4, +20E4,'BinSize',500);
figure, plot(mean(Data(matVal)'))
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(vv2, ts(events), -20E4, +20E4,'BinSize',500);
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(vv2, ts(events), -40E4, +40E4,'BinSize',500);
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(vv2, ts(events), -60E4, +80E4,'BinSize',500);
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(vv2, ts(events), -60E4, +80E4,'BinSize',1000);
