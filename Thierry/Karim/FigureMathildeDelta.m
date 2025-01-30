%FigureMathildeDelta

cd /Users/karimbenchenane/Dropbox/Mobs_member/MathildeChouvaeff/KB_data
try
    var;
catch
    var=3;
end

eval(['load(''Wake',num2str(var),'.mat'')'])
eval(['load(''SWS',num2str(var),'.mat'')'])
eval(['load(''REM',num2str(var),'.mat'')'])
eval(['load(''EMG',num2str(var),'.mat'')'])
eval(['load(''Stim',num2str(var),'.mat'')'])
%eval(['load(''Ripples',num2str(var),'.mat'')'])
%Delta=RipplesEpoch;
eval(['load(''AllDelta',num2str(var),'.mat'')'])
eval(['load(''Delta',num2str(var),'.mat'')'])

eval(['Wake=Wake',num2str(var),';'])
eval(['SWS=SWS',num2str(var),';'])
eval(['REM=REM',num2str(var),';'])
eval(['Delta=Delta',num2str(var),';'])
eval(['stim=ts(Stim',num2str(var),'*1E4);'])

lim=20E4;
WakeA=Wake;
SWSA=SWS;
REMA=REM;
Wake=dropShortIntervals(Wake,lim);
SWS=mergeCloseIntervals(SWS,lim);
SWS=dropShortIntervals(SWS,lim);
REM=dropShortIntervals(REM,lim);

stimREM=Restrict(stim,REMA);
stimSWS=Restrict(stim,SWSA);
stimWake=Restrict(stim,WakeA);


runfac=2;

%paramC=[1000,300];
paramC=[400,400];
[Ca,Ba]=CrossCorr(End(Wake),Start(Delta),paramC(1),paramC(2));
[Cb,Bb]=CrossCorr(End(REM),Start(Delta),paramC(1),paramC(2));
[Cc,Bc]=CrossCorr(Range(stimREM),Start(Delta),paramC(1),paramC(2));
[Cd,Bd]=CrossCorr(End(SWS),Start(Delta),paramC(1),paramC(2));
[Ce,Be]=CrossCorr(Start(SWS),Start(Delta),paramC(1),paramC(2));
[Cf,Bf]=CrossCorr(Range(stimSWS),Start(Delta),paramC(1),paramC(2));
[Cg,Bg]=CrossCorr(Start(Wake),Start(Delta),paramC(1),paramC(2));
[Ch,Bh]=CrossCorr(Start(Delta),Range(stimWake),paramC(1),paramC(2));

% figure('color',[1 1 1]), 
% subplot(2,1,1), hold on 
% plot(Ba/1E3,Ca/max(Ca),'k')
% plot(Bb/1E3,Cb/max(Cb),'b')
% plot(Bc/1E3,Cc/max(Cc),'r')
% line([0 0], ylim,'color','k','linestyle',':')
% subplot(2,1,2), hold on 
% plot(Ba/1E3,runmean(Ca,runfac)/max(runmean(Ca,runfac)),'k','linewidth',2)
% plot(Bb/1E3,runmean(Cb,runfac)/max(runmean(Cb,runfac)),'b','linewidth',2)
% plot(Bc/1E3,runmean(Cc,runfac)/max(runmean(Cc,runfac)),'r','linewidth',2)
% line([0 0], ylim,'color','k','linestyle',':')



figure('color',[1 1 1]), 
subplot(3,1,1), hold on 
plot(Ba/1E3,runmean(Ca,runfac)/max(runmean(Ca,runfac)),'k','linewidth',2)
plot(Bb/1E3,runmean(Cb,runfac)/max(runmean(Cb,runfac)),'b','linewidth',2)
plot(Bc/1E3,runmean(Cc,runfac)/max(runmean(Cc,runfac)),'r','linewidth',2)
line([0 0], ylim,'color','k','linestyle',':')
title([num2str(var),', End wake, End REM, stim REM, n=',num2str(length(Range(stimREM)))])
subplot(3,1,2), hold on 
plot(Ba/1E3,runmean(Ca,runfac)/max(runmean(Ca,runfac)),'k','linewidth',2)
plot(Bb/1E3,runmean(Cg,runfac)/max(runmean(Cg,runfac)),'b','linewidth',2)
plot(Bc/1E3,runmean(Ch,runfac)/max(runmean(Ch,runfac)),'r','linewidth',2)
line([0 0], ylim,'color','k','linestyle',':')
title([num2str(var),', End wake, Start Wake, stim Wake, n=',num2str(length(Range(stimWake)))])
subplot(3,1,3), hold on 
plot(Ba/1E3,runmean(Cd,runfac)/max(runmean(Cd,runfac)),'k','linewidth',2)
plot(Bb/1E3,runmean(Ce,runfac)/max(runmean(Ce,runfac)),'b','linewidth',2)
plot(Bc/1E3,runmean(Cf,runfac)/max(runmean(Cf,runfac)),'r','linewidth',2)
line([0 0], ylim,'color','k','linestyle',':')
title([num2str(var),', End SWS, Start SWS, stim SWS, n=',num2str(length(Range(stimSWS)))])

