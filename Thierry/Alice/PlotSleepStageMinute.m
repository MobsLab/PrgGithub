function SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,plo,fac,OptEpoch,OptYaxis)

% SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,plo,fac,OptEpoch,OptYaxis)
% SleepStages -1: noise; 1 SWS; 2 opEpoch; 3 REM; 4 Wake
% 
% Use:
%
% figure('color',[1 1 1]), imagesc(t,f,10*log10(Sp')), axis xy  % (spectrum between 0 and 20 Hz)
% SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[10 2]);
%
% figure('color',[1 1 1]), imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy  % (spectrum between 20 and 100 Hz)
% SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[70 4]);
%


try
    plo;
catch
    plo=1;
end



try
    fac;
    if length(fac)==1
    fac2=1;   
    if fac>69
        fac2=5;
    end
    else
        fac2=fac(2);
        fac=fac(1);
    end
catch
    fac=0;
    fac2=1;
end

if plo
fac2=1;
fac=0;
end

try
    OptYaxis;
catch
    OptYaxis=2;
end

    

st=min([Start(Wake,'s')/60;Start(REMEpoch,'s')/60;Start(SWSEpoch,'s')/60]);
en=max([End(Wake,'s')/60;End(REMEpoch,'s')/60;End(SWSEpoch,'s')/60]);
timeTsd=tsd(st*1E4/60:500/60:en*1E4/60,zeros(length(st*1E4/60:500/60:en*1E4/60),1));

SleepStages=5*ones(1,length(Range(timeTsd)));
rg=Range(timeTsd);

rgREM=Range(Restrict(timeTsd,REMEpoch));
idREM=(find(ismember(rg,rgREM)==1));

rgwake=Range(Restrict(timeTsd,Wake));
idwake=(find(ismember(rg,rgwake)==1));

rgSWS=Range(Restrict(timeTsd,SWSEpoch));
idSWS=(find(ismember(rg,rgSWS)==1));

try 
    for i=1:length(OptEpoch)
 rgSup{i}=Range(Restrict(timeTsd,OptEpoch{i}));
 idSup{i}=(find(ismember(rg,rgSup{i})==1));
    end
catch
    
    try
 rgSup{1}=Range(Restrict(timeTsd,OptEpoch));
 idSup{1}=(find(ismember(rg,rgSup{1})==1));        
    end
    
end


try
    SleepStages(idwake)=4;
end
try
    SleepStages(idREM)=3;
end
try
    SleepStages(idSWS)=1;
end

try
    for i=1:length(idSup)
    SleepStages(idSup{i})=OptYaxis(i);
    end
catch
    
    try
        SleepStages(idSup{1})=OptYaxis(i);    
    end
    
end

SleepStages(SleepStages>4)=-1;
SleepStages=tsd(rg,SleepStages');

if plo
    figure('color',[1 1 1])
    set(gca,'ytick',[-1:4])
    set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
    ylim([-1.5 4.5])
end

    hold on, plot(Range(SleepStages,'s'),fac+fac2*Data(SleepStages),'k')
    % hold on, plot(Range(SleepStages,'s'),fac+Data(SleepStages),'k.')
    hold on, plot(Range(Restrict(SleepStages,REMEpoch),'s'),fac+fac2*Data(Restrict(SleepStages,REMEpoch)),'r.')%,'markerfacecolor','r')
    hold on, plot(Range(Restrict(SleepStages,Wake),'s'),fac+fac2*Data(Restrict(SleepStages,Wake)),'k.')%,'markerfacecolor','k')
    hold on, plot(Range(Restrict(SleepStages,SWSEpoch),'s'),fac+fac2*Data(Restrict(SleepStages,SWSEpoch)),'b.')%,'markerfacecolor','b')
try
    for i=1:length(OptEpoch)
    hold on, plot(Range(Restrict(SleepStages,OptEpoch{i}),'s'),fac+fac2*Data(Restrict(SleepStages,OptEpoch{i})),'.','color',[0 i/3 0])%,'markerfacecolor','g')
    end
catch
    try
    hold on, plot(Range(Restrict(SleepStages,OptEpoch),'s'),fac+fac2*Data(Restrict(SleepStages,OptEpoch)),'g.')%,'markerfacecolor','g')
    end
    
end