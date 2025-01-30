function [ Nb, States, Latence, Result] = LatenceTransition_new_SleepScoring()
%LatenceTransition This fonction calculate the average time of delay
%between the beginning of the stim and the following transition of sleep
%state
%   The output is a matrix of 3 columns: The first one is the state at the
%   beginning of the stimulation, the second one is the following transition
%   and the third one is the time of delay 
%   0 = 'Wake'
%   1 = 'SWS'
%   2 = 'REM'
%   3 = 'Noise'


%% Loading and necessary variables

cd ..
cd ..
load('LFPData/DigInfo2.mat')
cd('Test_SleepScoring/Without_High_Noise')
load('SleepScoring_OBGamma_Ap.mat')

WkStart= Start(Wake)./(1e4); %matrix with the start times of all the Wake states
SWSStart = Start(SWSEpoch)./(1e4); %matrix with the start times of all the SWS states
REMStart = Start(REMEpoch)./(1e4); %matrix with the start times of all the REM states
NoiseStart = Start(TotalNoiseEpoch)./(1e4); %matrix with the start times of all the Noise states

%Calculation of the start time of all the stimulations and their frequency
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
Nb_Stim = length(Start(TTLEpoch_merged));
Freq_Stim = zeros(Nb_Stim,1);
Time_Stim = zeros(Nb_Stim,1); %matrix with all the start times of the stimulations

for k = 1:Nb_Stim
LittleEpoch = subset(TTLEpoch_merged,k);
Freq_Stim(k) =round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)))./(1e4);
end

Result = zeros(Nb_Stim,4);

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

Nb_Trans_REM_SWS = 0;
Nb_Trans_REM_Wake = 0;
Nb_Trans_REM_Noise = 0;
Nb_Trans_SWS_REM = 0;
Nb_Trans_SWS_Wake = 0;
Nb_Trans_SWS_Noise = 0;
Nb_Stim_Wake = 0;
Nb_Stim_Noise = 0;
error = 0;

Latence = NaN (Nb_Stim,12);

for k3=1:Nb_Stim
    Result(k3,1) = k3;
    if min([PreviousWakeTrans(k3),PreviousSWSTrans(k3),PreviousREMTrans(k3),PreviousNoiseTrans(k3)])==PreviousWakeTrans(k3)
        Result(k3,2) = 0;
    elseif min([PreviousWakeTrans(k3),PreviousSWSTrans(k3),PreviousREMTrans(k3),PreviousNoiseTrans(k3)])==PreviousSWSTrans(k3)
        Result(k3,2) = 1;
    elseif min([PreviousWakeTrans(k3),PreviousSWSTrans(k3),PreviousREMTrans(k3),PreviousNoiseTrans(k3)])==PreviousREMTrans(k3)
        Result(k3,2) = 2;
    else 
        Result(k3,2) = 3;
    end
    
    if min([NextWakeTrans(k3),NextSWSTrans(k3),NextREMTrans(k3), NextNoiseTrans(k3)])==NextWakeTrans(k3)
        Result(k3,3) = 0;
        Result(k3,4) = NextWakeTrans(k3);
        if Result(k3,2) == 1
            Nb_Trans_SWS_Wake = Nb_Trans_SWS_Wake + 1;
            Latence(Nb_Trans_SWS_Wake,10) = NextWakeTrans(k3);
            Latence(Nb_Trans_SWS_Wake,9) = k3;
        elseif Result(k3,2) == 2
            Nb_Trans_REM_Wake = Nb_Trans_REM_Wake + 1;
            Latence(Nb_Trans_REM_Wake,4) = NextWakeTrans(k3);
            Latence(Nb_Trans_REM_Wake,3) = k3;
        elseif Result(k3,2) == 3
            Nb_Stim_Noise = Nb_Stim_Noise + 1;
        else
           error = error +1; 
        end
    elseif min([NextWakeTrans(k3),NextSWSTrans(k3),NextREMTrans(k3), NextNoiseTrans(k3)])==NextSWSTrans(k3)
        Result(k3,3) = 1;
        Result(k3,4) = NextSWSTrans(k3);
        if Result(k3,2) == 1
            error = error + 1;
        elseif Result(k3,2) == 2
            Nb_Trans_REM_SWS = Nb_Trans_REM_SWS + 1;
            Latence(Nb_Trans_REM_SWS,2) = NextSWSTrans(k3);
            Latence(Nb_Trans_REM_SWS,1) = k3;
        elseif Result(k3,2) == 3
            Nb_Stim_Noise = Nb_Stim_Noise + 1;
        else
            Nb_Stim_Wake = Nb_Stim_Wake +1; 
        end
    elseif min([NextWakeTrans(k3),NextSWSTrans(k3),NextREMTrans(k3), NextNoiseTrans(k3)])==NextREMTrans(k3)
        Result(k3,3) = 2;
        Result(k3,4) = NextREMTrans(k3);
        if Result(k3,2) == 1
            Nb_Trans_SWS_REM = Nb_Trans_SWS_REM + 1;
            Latence(Nb_Trans_SWS_REM,8) = NextREMTrans(k3);
            Latence(Nb_Trans_SWS_REM,7) = k3;
        elseif Result(k3,2) == 2
            error = error + 1;
        elseif Result(k3,2) == 3
            Nb_Stim_Noise = Nb_Stim_Noise + 1;
        else
            Nb_Stim_Wake = Nb_Stim_Wake +1;
        end
    else
        Result(k3,3) = 3;
        Result(k3,4) = NextNoiseTrans(k3);
        if Result(k3,2) == 1
            Nb_Trans_SWS_Noise = Nb_Trans_SWS_Noise + 1;
            Latence(Nb_Trans_SWS_Noise,12) = NextNoiseTrans(k3);
            Latence(Nb_Trans_SWS_Noise,11) = k3;
        elseif Result(k3,2) == 2
            Nb_Trans_REM_Noise = Nb_Trans_REM_Noise + 1;
            Latence(Nb_Trans_REM_Noise,6) = NextNoiseTrans(k3);
            Latence(Nb_Trans_REM_Noise,5) = k3;
        elseif Result(k3,2) == 3
            error = error + 1;
        else
            Nb_Stim_Wake = Nb_Stim_Wake +1;
        end 
    end
end

Latence = Latence(1:max([Nb_Trans_REM_SWS, Nb_Trans_REM_Wake, Nb_Trans_REM_Noise, Nb_Trans_SWS_REM, Nb_Trans_SWS_Wake, Nb_Trans_SWS_Noise]),:);
Nb = [[Nb_Stim; Nb_Trans_REM_SWS; Nb_Trans_REM_Wake; Nb_Trans_REM_Noise; Nb_Trans_SWS_REM; Nb_Trans_SWS_Wake; Nb_Trans_SWS_Noise; Nb_Stim_Wake; Nb_Stim_Noise; error],zeros(10,2)];
Legend_Nb = ["Nb_Stim"; "Nb_Trans_REM_SWS"; "Nb_Trans_REM_Wake"; "Nb_Trans_REM_Noise"; "Nb_Trans_SWS_REM"; "Nb_Trans_SWS_Wake"; "Nb_Trans_SWS_Noise"; "Nb_Stim_Wake"; "Nb_Stim_Noise"; "error"];

%% Calculation of the mean and the standard deviation of the Delay time for the 4 kinds of transition

Nb(2,2) = mean(Latence(1:Nb_Trans_REM_SWS,2));
Nb(3,2) = mean(Latence(1:Nb_Trans_REM_Wake,4));
Nb(4,2) = mean(Latence(1:Nb_Trans_REM_Noise,6));
Nb(5,2) = mean(Latence(1:Nb_Trans_SWS_REM,8));
Nb(6,2) = mean(Latence(1:Nb_Trans_SWS_Wake,10));
Nb(7,2) = mean(Latence(1:Nb_Trans_SWS_Noise,12));

Nb(2,3) = std(Latence(1:Nb_Trans_REM_SWS,2));
Nb(3,3) = std(Latence(1:Nb_Trans_REM_Wake,4));
Nb(4,3) = std(Latence(1:Nb_Trans_REM_Noise,6));
Nb(5,3) = std(Latence(1:Nb_Trans_SWS_REM,8));
Nb(6,3) = std(Latence(1:Nb_Trans_SWS_Wake,10));
Nb(7,3) = std(Latence(1:Nb_Trans_SWS_Noise,12));

%% Calculation of the number of Wake, SWS, and REM state and their total length

States = zeros(4,4);

States(1,1) = length(WkStart);
States(2,1) = length(SWSStart);
States(3,1) = length(REMStart);
States(4,1) = length(NoiseStart);

States(1,2) = sum(End(Wake) - Start(Wake))*(1e-4)/(60*60);
States(2,2) = sum(End(SWSEpoch) - Start(SWSEpoch))*(1e-4)/(60*60) ;
States(3,2) = sum(End(REMEpoch) - Start(REMEpoch))*(1e-4)/(60*60);
States(4,2) = sum(End(TotalNoiseEpoch) - Start(TotalNoiseEpoch))*(1e-4)/(60*60);

States(1,3) = (States(1,2).*(60*60))./States(1,1);
States(2,3) = (States(2,2).*(60*60))./States(2,1);
States(3,3) = (States(3,2).*(60*60))./States(3,1);
States(4,3) = (States(4,2).*(60*60))./States(4,1);


States(1,4) = std(End(Wake) - Start(Wake)).*(1e-4);
States(2,4) = std(End(SWSEpoch) - Start(SWSEpoch)).*(1e-4) ;
States(3,4) = std(End(REMEpoch) - Start(REMEpoch)).*(1e-4);
States(4,4) = std(End(TotalNoiseEpoch) - Start(TotalNoiseEpoch)).*(1e-4);

end

