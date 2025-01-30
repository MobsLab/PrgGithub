function SleepStages=PlotAbortedTransitions(Trans,plo,fac,OptEpoch,OptYaxis)

% SleepStages=PlotSleepStage(Trans,plo,fac,OptEpoch,OptYaxis)
% SleepStages 0: baseline; 2 SW; 1 SS; -1 WW; -2 WS


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



st=min([Start(Trans{1},'s');Start(Trans{2},'s');Start(Trans{3},'s');Start(Trans{4},'s')]);
en=max([End(Trans{1},'s');End(Trans{2},'s');End(Trans{3},'s');End(Trans{4},'s')]);
timeTsd=tsd(st*1E4:500:en*1E4,zeros(length(st*1E4:500:en*1E4),1));

SleepStages=0*ones(1,length(Range(timeTsd)));
rg=Range(timeTsd);


rgWW=Range(Restrict(timeTsd,Trans{1}));
idWW=(find(ismember(rg,rgWW)==1));

rgSW=Range(Restrict(timeTsd,Trans{2}));
idSW=(find(ismember(rg,rgSW)==1));

rgWS=Range(Restrict(timeTsd,Trans{3}));
idWS=(find(ismember(rg,rgWS)==1));

rgSS=Range(Restrict(timeTsd,Trans{4}));
idSS=(find(ismember(rg,rgSS)==1));


try
    for i=1:length(OptEpoch)
        rgSup{i}=Range(Restrict(Movtsd,OptEpoch{i}));
        idSup{i}=(find(ismember(rg,rgSup{i})==1));
    end
catch
    
    try
        rgSup{1}=Range(Restrict(timeTsd,OptEpoch));
        idSup{1}=(find(ismember(rg,rgSup{1})==1));
    end
    
end

% SleepStages 0: baseline; 2 SW; 1 SS; -1 WW; -2 WS

try
    SleepStages(idSW)=2;
end
try
    SleepStages(idSS)=1;
end
try
    SleepStages(idWW)=-1;
end

try
    SleepStages(idWS)=-2;
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

SleepStages=tsd(rg,SleepStages');

if plo
    figure('color',[1 1 1])
    set(gca,'ytick',[-2:2])
    set(gca,'yticklabel',{'WS','WW ','','SS ','SW'})
    ylim([-2.5 2.5])
end

hold on, plot(Range(SleepStages,'s'),fac+fac2*Data(SleepStages),'k')
plot(Range(Restrict(SleepStages,Trans{2}),'s'),fac+fac2*Data(Restrict(SleepStages,Trans{2})),'k.')
plot(Range(Restrict(SleepStages,Trans{3}),'s'),fac+fac2*Data(Restrict(SleepStages,Trans{3})),'b.')
    ylim([-2.5 2.5])

try
    for i=1:length(OptEpoch)
        hold on, plot(Range(Restrict(SleepStages,OptEpoch{i}),'s'),fac+fac2*Data(Restrict(SleepStages,OptEpoch{i})),'.','color',[0 i/3 0])%,'markerfacecolor','g')
    end
catch
    try
        hold on, plot(Range(Restrict(SleepStages,OptEpoch),'s'),fac+fac2*Data(Restrict(SleepStages,OptEpoch)),'g.')%,'markerfacecolor','g')
    end
    
end

