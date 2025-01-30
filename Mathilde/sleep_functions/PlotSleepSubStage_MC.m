
function SleepSubStage=PlotSleepSubStage_MC(N1,N2,N3,REMEpoch,Wake,SWSEpoch,plo)


% SleepStages -1: noise; 1 N1; 2 N2; 3 N3; 4 REM; 5 Wake


try
    plo;
catch
    plo=1;
end


if plo
    fac2=1;
    fac=0;
end

st=min([Start(Wake,'s');Start(REMEpoch,'s');Start(SWSEpoch,'s')]);
en=max([End(Wake,'s');End(REMEpoch,'s');End(SWSEpoch,'s')]);

timeTsd=tsd(st*1E4:500:en*1E4,zeros(length(st*1E4:500:en*1E4),1));

SleepSubStage=6*ones(1,length(Range(timeTsd)));
rg=Range(timeTsd);

rgSWS=Range(Restrict(timeTsd,SWSEpoch));
idSWS=(find(ismember(rg,rgSWS)==1));

rgN1=Range(Restrict(timeTsd,N1));
idN1=(find(ismember(rg,rgN1)==1));

rgN2=Range(Restrict(timeTsd,N2));
idN2=(find(ismember(rg,rgN2)==1));

rgN3=Range(Restrict(timeTsd,N3));
idN3=(find(ismember(rg,rgN3)==1));

rgSP=Range(Restrict(timeTsd,REMEpoch));
idSP=(find(ismember(rg,rgSP)==1));

rgeveil=Range(Restrict(timeTsd,Wake));
ideveil=(find(ismember(rg,rgeveil)==1));


try
    SleepSubStage(idSWS)=6;
end
try
    SleepSubStage(ideveil)=5;
end
try
    SleepSubStage(idSP)=4;
end
try
    SleepSubStage(idN3)=3;
end
try
    SleepSubStage(idN2)=2;
end
try
    SleepSubStage(idN1)=1;
end


SleepSubStage(SleepSubStage>6)=-1;

SleepSubStage=tsd(rg,SleepSubStage');
% 
% if plo
%     figure('color',[1 1 1])
%     set(gca,'ytick',[-1:5])
%     set(gca,'yticklabel',{'noise',' ','N1','N2','N3 ','REM','Wake','SWS'})
% 
% end
% 
% hold on, plot(Range(SleepSubStage,'s'),fac+fac2*Data(SleepSubStage),'k')
% hold on, plot(Range(Restrict(SleepSubStage,N3),'s'),fac+fac2*Data(Restrict(SleepSubStage,N3)),'r.')%,'markerfacecolor','b')
% hold on, plot(Range(Restrict(SleepSubStage,N2),'s'),fac+fac2*Data(Restrict(SleepSubStage,N2)),'g.')%,'markerfacecolor','b')
% 
% hold on, plot(Range(Restrict(SleepSubStage,N1),'s'),fac+fac2*Data(Restrict(SleepSubStage,N1)),'g.')%,'markerfacecolor','r')
% hold on, plot(Range(Restrict(SleepSubStage,REMEpoch),'s'),fac+fac2*Data(Restrict(SleepSubStage,REMEpoch)),'r.')%,'markerfacecolor','k')
% hold on, plot(Range(Restrict(SleepSubStage,Wake),'s'),fac+fac2*Data(Restrict(SleepSubStage,Wake)),'b.')%,'markerfacecolor','b')

    
end
