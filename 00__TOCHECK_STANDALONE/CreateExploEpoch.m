%CreateExploEpoch

load behavResources

StartExplo=[];
StopExplo=[];
sle=0;

if length(Start(SleepEpoch))<1
    sle=1;
StartSleep=[];
StopSleep=[];
end

for i=1:length(namePos)
try
                if sum(ismember('Explo',namePos{i}(10:end)))==5
                    StartExplo=[StartExplo;tpsdeb{i}*1E4];
                    StopExplo=[StopExplo;tpsfin{i}*1E4];   
                end
end

if length(Start(SleepEpoch))<1

         try        
                if sum(ismember('Sleep',namePos{i}(10:end)))==5
                    StartSleep=[StartSleep;tpsdeb{i}*1E4];
                    StopSleep=[StopSleep;tpsfin{i}*1E4];   
                end
         end
end
end

try
    ExploEpoch=intervalSet(StartExplo,StopExplo);
    SleepEpoch=intervalSet(StartSleep,StopSleep);
end


if sle==1
save behavResources -Append ExploEpoch SleepEpoch
else
save behavResources -Append ExploEpoch 
end

