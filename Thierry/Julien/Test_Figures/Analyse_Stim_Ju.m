function  [Result] = Analyse_Stim_Ju()
%Analyse_Stim_Ap Summary of this function goes here
%   Detailed explanation goes here

%%
load('SleepScoring_OBGamma.mat')

WkStart= Start(Wake)./(1e4); %matrix with the start times of all the Wake states
SWSStart = Start(SWSEpoch)./(1e4); %matrix with the start times of all the SWS states
REMStart = Start(REMEpoch)./(1e4); %matrix with the start times of all the REM states
NoiseStart = Start(TotalNoiseEpoch)./(1e4); %matrix with the start times of all the Noise states

%Calculation of the start time of all the stimulations and their frequency
  Sleepy = or(SWSEpoch,REMEpoch);
    Sleepy = mergeCloseIntervals(Sleepy,10000);
    
    SleepStart = Start(Sleepy)./(1e4); %matrix with the start times of all the sleep states
    SleepEnd = End(Sleepy)./(1e4); %matrix with the end times of all the sleep states
    Nb_SleepEpoch = length(SleepStart); 
    Time_Stim = [];
    
    for j = 1:Nb_SleepEpoch
        Stim = SleepStart(j)+60;
        while Stim < SleepEnd(j)
            Time_Stim = [Time_Stim;Stim];
            Stim = Stim+120;
        end
    end
        

Nb_Stim = length(Time_Stim);

Result = zeros(Nb_Stim,5);

%% Calculation of the previous and next Wake, SWS and REM transitions

%%Loop to calculate the next wake transition after a stimulation
NextWakeTrans = NaN(Nb_Stim,1);
PreviousWakeTrans = NaN(Nb_Stim,1);

if isempty(WkStart) == 0

    for k=1:Nb_Stim
        CandidateNextWakeTrans = WkStart-Time_Stim(k);
        CandidatePreviousWakeTrans = Time_Stim(k)-WkStart;

        if CandidateNextWakeTrans(end) < 0
            NextWakeTrans(k) = NaN;
        else 
            NextWakeTrans(k) = min(CandidateNextWakeTrans(CandidateNextWakeTrans>0));
        end

        if CandidatePreviousWakeTrans(1) < 0
            PreviousWakeTrans(k) = NaN;
        else
            PreviousWakeTrans(k) = min(CandidatePreviousWakeTrans(CandidatePreviousWakeTrans>=0));
        end

    end
end

%%Loop to calculate the next SWS transition after a stimulation
NextSWSTrans = NaN(Nb_Stim,1);
PreviousSWSTrans = NaN(Nb_Stim,1);

if isempty(SWSStart) == 0

    for k=1:length(Time_Stim)
        CandidateNextSWSTrans = SWSStart-Time_Stim(k);
        CandidatePreviousSWSTrans = Time_Stim(k)-SWSStart;

        if CandidateNextSWSTrans(end) < 0
            NextSWSTrans(k) = NaN;
        else 
            NextSWSTrans(k) = min(CandidateNextSWSTrans(CandidateNextSWSTrans>0));
        end

        if CandidatePreviousSWSTrans(1) < 0
            PreviousSWSTrans(k) = NaN;
        else
            PreviousSWSTrans(k) = min(CandidatePreviousSWSTrans(CandidatePreviousSWSTrans>=0));
        end

    end
end

%%Loop to calculate the next REM transition after a stimulation
NextREMTrans = NaN(Nb_Stim,1);
PreviousREMTrans = NaN(Nb_Stim,1);

if isempty(REMStart) == 0
    
    for k=1:length(Time_Stim)
        CandidateNextREMTrans = REMStart-Time_Stim(k);
        CandidatePreviousREMTrans = Time_Stim(k)-REMStart;

        if CandidateNextREMTrans(end) < 0
            NextREMTrans(k) = NaN;
        else 
            NextREMTrans(k) = min(CandidateNextREMTrans(CandidateNextREMTrans>0));
        end

        if CandidatePreviousREMTrans(1) < 0
            PreviousREMTrans(k) = NaN;
        else
            PreviousREMTrans(k) = min(CandidatePreviousREMTrans(CandidatePreviousREMTrans>=0));
        end

    end
end

%%Loop to calculate the next Noise transition after a stimulation
NextNoiseTrans = NaN(Nb_Stim,1);
PreviousNoiseTrans = NaN(Nb_Stim,1);

if isempty(NoiseStart) == 0
    
    for k=1:Nb_Stim
        CandidateNextNoiseTrans = NoiseStart-Time_Stim(k);
        CandidatePreviousNoiseTrans = Time_Stim(k)-NoiseStart;

        if CandidateNextNoiseTrans(end) < 0
            NextNoiseTrans(k) = NaN;
        else 
            NextNoiseTrans(k) = min(CandidateNextNoiseTrans(CandidateNextNoiseTrans>0));
        end

        if CandidatePreviousNoiseTrans(1) < 0
            PreviousNoiseTrans(k) = NaN;
        else
            PreviousNoiseTrans(k) = min(CandidatePreviousNoiseTrans(CandidatePreviousNoiseTrans>=0));
        end

    end
end

%% Determination of the previous and next transition and the delay time

for k3=1:Nb_Stim
    Result(k3,1) = Time_Stim(k3);
    if min([PreviousWakeTrans(k3),PreviousSWSTrans(k3),PreviousREMTrans(k3),PreviousNoiseTrans(k3)])==PreviousWakeTrans(k3)
        Result(k3,2) = 0;
        Result(k3,3) = PreviousWakeTrans(k3);
    elseif min([PreviousWakeTrans(k3),PreviousSWSTrans(k3),PreviousREMTrans(k3),PreviousNoiseTrans(k3)])==PreviousSWSTrans(k3)
        Result(k3,2) = 1;
        Result(k3,3) = PreviousSWSTrans(k3);
    elseif min([PreviousWakeTrans(k3),PreviousSWSTrans(k3),PreviousREMTrans(k3),PreviousNoiseTrans(k3)])==PreviousREMTrans(k3)
        Result(k3,2) = 2;
        Result(k3,3) = PreviousREMTrans(k3);
    else 
        Result(k3,2) = 3;
        Result(k3,3) = PreviousNoiseTrans(k3);
    end
    
    
    if min([NextWakeTrans(k3),NextSWSTrans(k3),NextREMTrans(k3), NextNoiseTrans(k3)])==NextWakeTrans(k3)
        Result(k3,4) = 0;
        Result(k3,5) = NextWakeTrans(k3);
    elseif min([NextWakeTrans(k3),NextSWSTrans(k3),NextREMTrans(k3), NextNoiseTrans(k3)])==NextSWSTrans(k3)
        Result(k3,4) = 1;
        Result(k3,5) = NextSWSTrans(k3);
    elseif min([NextWakeTrans(k3),NextSWSTrans(k3),NextREMTrans(k3), NextNoiseTrans(k3)])==NextREMTrans(k3)
        Result(k3,4) = 2;
        Result(k3,5) = NextREMTrans(k3);
    else
        Result(k3,4) = 3;
        Result(k3,5) = NextNoiseTrans(k3);
    end
end


end

