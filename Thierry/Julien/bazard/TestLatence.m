%% time to next transition
WkStart= Start(Wake);
SlpStart = Start(Sleep);
for k=1:length(Time_Stim)
    CandidateTransitionsToWake = WkStart-Time_Stim(k);
    CandidateTransitionsToWake(CandidateTransitionsToWake<0)=[];
    NextWakeTrans(k) = min(CandidateTransitionsToWake);
    
end

for k2=1:length(Time_Stim)
    CandidateTransitionsToSleep = SlpStart-Time_Stim(k2);
    CandidateTransitionsToSleep(CandidateTransitionsToSleep<0)=[];
    NextSleepTrans(k2) = min(CandidateTransitionsToSleep);
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%
for k3=1:length(NextWakeTrans) 
        if NextWakeTrans(k3)<NextSleepTrans(k3)
            
            for i=1:
            LatenceWake=[NextWakeTrans(k3)]
        else 
            LatenceSleep=[NextSleepTrans(k3)]
        end
end

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù
 I=NextWakeTrans-NextSleepTrans
J=I(I<0)
H=I(I>0)
for k3=1:length(NextWakeTrans) 
        if NextWakeTrans(k3)<NextSleepTrans(k3)
            for i=1:length(J)
            LatenceWake(k3)=NextWakeTrans(k3)
            end
            else 
            for i2=1:length(H)
            LatenceSleep(i2)=NextSleepTrans(k3)
            end
        end
end
