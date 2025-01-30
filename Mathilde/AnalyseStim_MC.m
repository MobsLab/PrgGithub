 function [Result] = AnalyseStim_MC()
%ANALYSE_STIM_AP caclulate the transition following the optogenetic stimulations
%
%   RESULT is a matrix of 5 column and each line correspond to a stimulation
%       - The first column is the time of the stim (in s)
%       - The second column is the state of the mouse at the moment of the
%       stim
%       - The third column is for how long the mouse was in this state at the
%       moment of the stim (in s)
%       - The fourth column is the next state directly following the stim
%       - The fifth column is the time between the stim and this next state
%       transition (in s)
%
%   STATES
%       0 is Wake
%       1 is SWS
%       2 is REM
%       3 is Noise
%
%   INPUT
%       No input is necessary, you just have to be in the folder of the
%       experiment to analyse and to have already done the SleepScoring_OBGamma
%%

%% initialisation

% loading the LFP info and the sleepScoring results (different Epoch: Wake, SWS, REM, Noise)
load('LFPData/DigInfo2.mat')
load('SleepScoring_OBGamma.mat')

% Defining the start matrix with all the start time of the Epoch
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

Result = zeros(Nb_Stim,5);

%% Calculation of the previous and next Wake, SWS and REM transitions

%%Loop to calculate the previous and the next wake transition after a stimulation
NextWakeTrans = NaN(Nb_Stim,1);
PreviousWakeTrans = NaN(Nb_Stim,1);

if isempty(WkStart) == 0 % Check if there is any Wake Epoch in the SleepScoring. If not the loop is not done

    % loop for each stimulation
    for k=1:Nb_Stim
        CandidateNextWakeTrans = WkStart-Time_Stim(k);
        CandidatePreviousWakeTrans = Time_Stim(k)-WkStart;

        % the next wake state is the smallest positive difference between
        % WkStart and Time_Stim
        if CandidateNextWakeTrans(end) < 0
            NextWakeTrans(k) = NaN;
        else 
            NextWakeTrans(k) = min(CandidateNextWakeTrans(CandidateNextWakeTrans>0));
        end

        % the previous wake state is the smallest positive difference between
        % Time_Stim and WkStart
        if CandidatePreviousWakeTrans(1) < 0
            PreviousWakeTrans(k) = NaN;
        else
            PreviousWakeTrans(k) = min(CandidatePreviousWakeTrans(CandidatePreviousWakeTrans>=0));
        end

    end
end

%%Loop to calculate the previous and the next SWS transition after a stimulation
NextSWSTrans = NaN(Nb_Stim,1);
PreviousSWSTrans = NaN(Nb_Stim,1);

if isempty(SWSStart) == 0 % Check if there is any SWS Epoch in the SleepScoring. If not the loop is not done

    % loop for each stimulation
    for k=1:length(Time_Stim)
        CandidateNextSWSTrans = SWSStart-Time_Stim(k);
        CandidatePreviousSWSTrans = Time_Stim(k)-SWSStart;

        % the next SWS state is the smallest positive difference between
        % SWSStart and Time_Stim
        if CandidateNextSWSTrans(end) < 0
            NextSWSTrans(k) = NaN;
        else 
            NextSWSTrans(k) = min(CandidateNextSWSTrans(CandidateNextSWSTrans>0));
        end

        % the previous REM state is the smallest positive difference between
        % Time_Stim and SWSStart
        if CandidatePreviousSWSTrans(1) < 0
            PreviousSWSTrans(k) = NaN;
        else
            PreviousSWSTrans(k) = min(CandidatePreviousSWSTrans(CandidatePreviousSWSTrans>=0));
        end

    end
end

%%Loop to calculate the previous and the next REM transition after a stimulation
NextREMTrans = NaN(Nb_Stim,1);
PreviousREMTrans = NaN(Nb_Stim,1);

if isempty(REMStart) == 0 % Check if there is any REM Epoch in the SleepScoring. If not the loop is not done
    
    % loop for each stimulation
    for k=1:length(Time_Stim)
        CandidateNextREMTrans = REMStart-Time_Stim(k);
        CandidatePreviousREMTrans = Time_Stim(k)-REMStart;

        % the next REM state is the smallest positive difference between
        % REMStart and Time_Stim
        if CandidateNextREMTrans(end) < 0
            NextREMTrans(k) = NaN;
        else 
            NextREMTrans(k) = min(CandidateNextREMTrans(CandidateNextREMTrans>0));
        end

        % the previous REM state is the smallest positive difference between
        % Time_Stim and REMStart
        if CandidatePreviousREMTrans(1) < 0
            PreviousREMTrans(k) = NaN;
        else
            PreviousREMTrans(k) = min(CandidatePreviousREMTrans(CandidatePreviousREMTrans>=0));
        end

    end
end

%%Loop to calculate the previous and the next Noise transition after a stimulation
NextNoiseTrans = NaN(Nb_Stim,1);
PreviousNoiseTrans = NaN(Nb_Stim,1);

if isempty(NoiseStart) == 0 % Check if there is any Start Epoch in the SleepScoring. If not the loop is not done
    
    % loop for each stimulation
    for k=1:Nb_Stim
        CandidateNextNoiseTrans = NoiseStart-Time_Stim(k);
        CandidatePreviousNoiseTrans = Time_Stim(k)-NoiseStart;

        % the next Noise state is the smallest positive difference between
        % NoiseStart and Time_Stim
        if CandidateNextNoiseTrans(end) < 0
            NextNoiseTrans(k) = NaN;
        else 
            NextNoiseTrans(k) = min(CandidateNextNoiseTrans(CandidateNextNoiseTrans>0));
        end

        % the previous Noise state is the smallest positive difference between
        % Time_Stim and NoiseStart
        if CandidatePreviousNoiseTrans(1) < 0
            PreviousNoiseTrans(k) = NaN;
        else
            PreviousNoiseTrans(k) = min(CandidatePreviousNoiseTrans(CandidatePreviousNoiseTrans>=0));
        end

    end
end

%% Determination of the previous and next transition and the delay time

%loop on all the stimulations
for k3=1:Nb_Stim
    
    % Implementation of the Time of the stim in the first row of the Result matrix
    Result(k3,1) = Time_Stim(k3);
    
    % Determination of the state of the mouse at the moment of the stim by
    % taking the state that had begun at the smaller time before the stim
    if min([PreviousWakeTrans(k3),PreviousSWSTrans(k3),PreviousREMTrans(k3),PreviousNoiseTrans(k3)])==PreviousWakeTrans(k3)
        % implementation of the state of the mouse at the moment of the stim in the second row of Result matrix
        Result(k3,2) = 0;
        % implementation of the time since when the mouse was in this state in the third row
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
    
    %Determination of the first transition after the stimulation by
    % taking the state that begin at the smaller time after the stim
    if min([NextWakeTrans(k3),NextSWSTrans(k3),NextREMTrans(k3), NextNoiseTrans(k3)])==NextWakeTrans(k3)
        % implementation the state of the mouse directly following the stim in the fourth row of Result matrix
        Result(k3,4) = 0;
        % implementation of the time between the stim and the first transition in the fifth row
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
