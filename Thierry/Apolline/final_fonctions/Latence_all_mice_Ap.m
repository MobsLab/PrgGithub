clear all
clc

Dir=PathForExperimentsEmbReact('BaselineSleep');

TransREMSWS = [];
i = 0

for k = 1:length(Dir.path)
    
    for l = 1:length(Dir.path{k})
        
        cd(Dir.path{k}{l})
        load('StateEpochSB.mat')

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


        WkStart= Start(Wake)./(1e4); %matrix with the start times of all the Wake states
        SWSStart = Start(SWSEpoch)./(1e4); %matrix with the start times of all the SWS states
        REMStart = Start(REMEpoch)./(1e4); %matrix with the start times of all the REM states
        NoiseStart = Start(TotalNoiseEpoch)./(1e4); %matrix with the start times of all the Noise states

        TransREMSWS = [TransREMSWS; Latence_all_mice_analyse(WkStart, SWSStart, REMStart, NoiseStart, Time_Stim)];


        i=i+1
    end
end

Nb_Total_Stim = length(TransREMSWS(:,3));

hist(TransREMSWS(:,3),50)
ylabel('nb de stim')
xlabel('temps de latence (s)')
str = sprintf('%d stim',Nb_Total_Stim);
legend(str)

figure

hist(TransREMSWS(:,2),50)
ylabel('nb de stim')
xlabel('delais debut du REM - stim  (s)')
mean_REM = mean(TransREMSWS(:,2)+TransREMSWS(:,3));
mean_Latence = mean(TransREMSWS(:,3));
str = sprintf('mean REM Epoch time : %f s',mean_REM);
legend(str)

norm_Stim_REM = TransREMSWS(:,2)./(TransREMSWS(:,2)+TransREMSWS(:,3));
hist(norm_Stim_REM)
ylabel('nb de stim')
str = sprintf('%d stim',Nb_Total_Stim);
legend(str)

% cd(Dir.path{1}{1})
%     
% load('StateEpochSB.mat')
% 
% 
% Sleepy = or(SWSEpoch,REMEpoch);
% Sleepy = mergeCloseIntervals(Sleepy,10000);
% 
% SleepStart = Start(Sleepy)./(1e4); %matrix with the start times of all the sleep states
% SleepEnd = End(Sleepy)./(1e4); %matrix with the end times of all the sleep states
% 
% Nb_SleepEpoch = length(SleepStart); 
% 
% Time_Stim = [];
% 
% for k = 1:Nb_SleepEpoch
%     Stim = SleepStart(k)+60;
%     while Stim < SleepEnd(k)
%         Time_Stim = [Time_Stim;Stim];
%         Stim = Stim+120;
%     end
% end
% 
% 
% WkStart= Start(Wake)./(1e4); %matrix with the start times of all the Wake states
% SWSStart = Start(SWSEpoch)./(1e4); %matrix with the start times of all the SWS states
% REMStart = Start(REMEpoch)./(1e4); %matrix with the start times of all the REM states
% NoiseStart = Start(TotalNoiseEpoch)./(1e4); %matrix with the start times of all the Noise states
% 
% TransREMSWS = Latence_all_mice_analyse(WkStart, SWSStart, REMStart, NoiseStart, Time_Stim);
% 
% hist(TransREMSWS(:,3))
% 
% 
% 
