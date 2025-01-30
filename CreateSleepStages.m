function SleepStages=CreateSleepStages(tsa,tsb,Wake,SWSEpoch,REMEpoch,OtherEpoch)


try
    Wake;
catch
    try
    load StateEpochSBKB SWSEpoch REMEpoch Wake
    Wake;
    catch
    load StateEpochSB SWSEpoch REMEpoch Wake    
    end
    
end


SleepStages=5*ones(1,length(Range(tsa)));

rg=Range(tsa);


rgSWS=Range(Restrict(tsa,SWSEpoch));
idSWS=(find(ismember(rg,rgSWS)==1));

rgREM=Range(Restrict(tsa,REMEpoch));
idREM=(find(ismember(rg,rgREM)==1));

rgwake=Range(Restrict(tsa,Wake));
idwake=(find(ismember(rg,rgwake)==1));

try
    rgother=Range(Restrict(tsa,OtherEpoch));
    idother=(find(ismember(rg,rgother)==1));
end


try
    SleepStages(idwake)=3;
end
try
    SleepStages(idREM)=1;
end
try
    SleepStages(idSWS)=2;
end

try
    SleepStages(idother)=0;
end

SleepStages=tsd(rg,SleepStages');

figure('color',[1 1 1])
hold on, plot(Range(SleepStages,'s'),Data(SleepStages),'k')
hold on, plot(Range(Restrict(SleepStages,Wake),'s'),Data(Restrict(SleepStages,Wake)),'bo','markerfacecolor','b')
hold on, plot(Range(Restrict(SleepStages,REMEpoch),'s'),Data(Restrict(SleepStages,REMEpoch)),'ro','markerfacecolor','r')
hold on, plot(Range(Restrict(SleepStages,SWSEpoch),'s'),Data(Restrict(SleepStages,SWSEpoch)),'go','markerfacecolor','g')
hold on, plot(Range(tsb,'s'),rescale(Data(tsb),3.5,5),'color',[0.7 0.7 0.7])
ylim([0 5])
set(gca,'ytick',[0:5])


