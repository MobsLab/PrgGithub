function [SWSEpochC,REMEpochC,WakeC]=CleanSWSREM(SleepStages,SWSEpoch,REMEpoch,Wake,lim)

try
    lim;
catch
    lim=15;
end


for i=1:length(Start(SWSEpoch))
    testEpoch1=subset(SWSEpoch,i);
    
    dur=End(testEpoch1,'s')-Start(testEpoch1,'s');
    
    if dur<lim
        
            testEpoch2=intervalSet(Start(testEpoch1)-1E4,Start(testEpoch1)-2);
            SleepStageTemp2=Data(Restrict(SleepStages,testEpoch2));
            testEpoch3=intervalSet(End(testEpoch1)+2,End(testEpoch1)+1E4);
            SleepStageTemp3=Data(Restrict(SleepStages,testEpoch3));   

            try
                if SleepStageTemp2(end-1)==3&SleepStageTemp3(2)==3
                    idbad(i)=1;
                else
                    idbad(i)=0;
                end 
            catch
                idbad(i)=0;
            end

            try
                if SleepStageTemp2(end-1)==4&SleepStageTemp3(2)==4
                    idbad2(i)=1;
                else
                    idbad2(i)=0;
                end 
            catch
                idbad2(i)=0;
            end 
    
    else
        idbad(i)=0;
        idbad2(i)=0;
    end
    


    
end


SWSEpochC=subset(SWSEpoch,find(and(idbad==0,idbad2==0)));
SWSEpochC=mergeCloseIntervals(SWSEpochC,1);
REMEpochC=or(REMEpoch,subset(SWSEpoch,find(idbad==1)));
REMEpochC=mergeCloseIntervals(REMEpochC,1);
WakeC=or(Wake,subset(SWSEpoch,find(idbad2==1)));
WakeC=mergeCloseIntervals(WakeC,1);

disp('******************************')
disp(['Number of Bad SWSEpoch epochs: ',num2str(length(find(idbad==1))+length(find(idbad2==1)))])
disp('******************************')
disp('******************************')
disp(['Number of Bad SWSEpoch epochs During REM: ',num2str(length(find(idbad==1)))])
disp('******************************')
disp('******************************')
disp(['Number of Bad SWSEpoch epochs during Wake: ',num2str(length(find(idbad2==1)))])
disp('******************************')

