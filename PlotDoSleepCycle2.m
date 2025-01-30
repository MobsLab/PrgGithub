function SleepCycle=PlotDoSleepCycle2(Wake,SWSEpoch, REMEpoch, plotdetail,CorrectREM,paramsREM,SleepStages)


try
plotdetail;
catch
    plotdetail=1; 
end

try
    CorrectREM;
catch
    CorrectREM=1; 
    paramsREM=[15 25];
end

durWakemax=20;

%%
%
REM=REMEpoch;
SWS=SWSEpoch;

% REM=mergeCloseIntervals(REMEpoch,10E4); 
EnRem=End(REM);
SleepCycle=intervalSet([0; EnRem(1:end-1)],EnRem(1:end));

if plotdetail
    
figure
subplot(121)
for i=1:length(Start(SleepCycle,'s'))
    st=Start(subset(SleepCycle,i),'s');
    
    SWStemp=and(SWS,subset(SleepCycle,i));
    for j=1:length(Start(SWStemp))
    line([Start(subset(SWStemp,j),'s') End(subset(SWStemp,j),'s')]-st,[i i],'color','b','linewidth',5)
    end
  
    REMtemp=and(REM,subset(SleepCycle,i));
    for j=1:length(Start(REMtemp))
    line([Start(subset(REMtemp,j),'s') End(subset(REMtemp,j),'s')]-st,[i i],'color','r','linewidth',5)
    end
    
end

end

%%
if CorrectREM

REM=mergeCloseIntervals(REMEpoch,paramsREM(2)*1E4); %25E4 
REM=dropShortIntervals(REM,paramsREM(1)*1E4); %15E4
end

SWS=SWS-REM;
Wake=Wake-REM;

EnRem=End(REM);
%SleepCycle=intervalSet(EnRem(1:end-1),EnRem(2:end));
SleepCycle=intervalSet([0; EnRem(1:end-1)],EnRem(1:end));

%%
% SleepCycle=dropShortIntervals(SleepCycle,30E4); 
stSC=Start(SleepCycle);
enSC=End(SleepCycle);

for i=1:length(Start(SleepCycle))
        waketemp=and(Wake,subset(SleepCycle,i));
        if length(Start(waketemp))>0
            for k=1:length(Start(waketemp))
                if DurationEpoch(subset(waketemp,k))>durWakemax*1E4    %20E4
                       stSC(i)=End(subset(waketemp,k));
                    SleepCycle=intervalSet(stSC,enSC);
                end
            end
        end
end

%%
stSC=Start(SleepCycle);
enSC=End(SleepCycle);
dur=enSC(1:end-1)-stSC(2:end);
dur(dur<30E4)=[];

SleepCycle=intervalSet(stSC,enSC);

%%
if plotdetail
subplot(122)
for i=1:length(Start(SleepCycle,'s'))
    st=Start(subset(SleepCycle,i),'s');
    
    SWStemp=and(SWS,subset(SleepCycle,i));
    for j=1:length(Start(SWStemp))
    line([Start(subset(SWStemp,j),'s') End(subset(SWStemp,j),'s')]-st,[i i],'color','b','linewidth',5)
    end
    
    REMtemp=and(REM,subset(SleepCycle,i));
    for j=1:length(Start(REMtemp))
    line([Start(subset(REMtemp,j),'s') End(subset(REMtemp,j),'s')]-st,[i i],'color','r','linewidth',5)
    end
    
end
title(pwd)
end

%%

figure, 
subplot(4,1,1:3), hold on, title(pwd)

for i=1:length(Start(SleepCycle,'s'))
    st=Start(subset(SleepCycle,i),'s');
    
    SWStemp=and(SWS,subset(SleepCycle,i));
    for j=1:length(Start(SWStemp))
    line([Start(subset(SWStemp,j),'s') End(subset(SWStemp,j),'s')]-st,[i i],'color','b','linewidth',5)
    end
  
    REMtemp=and(REM,subset(SleepCycle,i));
    for j=1:length(Start(REMtemp))
    line([Start(subset(REMtemp,j),'s') End(subset(REMtemp,j),'s')]-st,[i i],'color','r','linewidth',5)
    end
    
%     plot(End(subset(SleepCycle,i),'s')-st,i,'ko')
end

%%

en=End(REM);
rg=0:100:en(end);
rgts=ts(rg);

rgrem=Range(Restrict(rgts,REM));
grouprem=zeros(length(rg),1);
grouprem(ismember(rg,rgrem))=1;

clear groupSCREM
for i=1:length(Start(SleepCycle))
    rgSCtemp=Range(Restrict(rgts,subset(SleepCycle,i)));
    rgStSC(i)=rgSCtemp(1);
    
    rgSCREM=Range(Restrict(rgts,and(REM,subset(SleepCycle,i))));
    groupSCREM{i}=zeros(200E3,1);
    groupSCREM{i}(ismember(rgSCtemp,rgSCREM))=1;
    rgSleepCycle{i}=rgSCtemp-rgSCtemp(1);

end
groupStartSleepCycle=zeros(length(rg),1);
groupStartSleepCycle(ismember(rg,rgStSC))=1;

rgSC=Range(Restrict(rgts,SleepCycle));
groupSleepCycle=zeros(length(rg),1);
groupStartSleepCycle(ismember(rg,rgSC))=1;

remSC=zeros(200E3,1);
for i=1:length(Start(SleepCycle))
    remSC=remSC+groupSCREM{i} ;
end

xl=xlim; 
subplot(4,1,4), area([1:length(remSC)]/100,remSC), xlim(xl), title(['Mean duration of a Sleep Cycle: ',num2str(mean(DurationEpoch(SleepCycle,'s')/60))])




