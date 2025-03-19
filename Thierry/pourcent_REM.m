
clear all 
clc

DataLocation{1}='/media/mobschapeau/DataMOBS82/Test Figures/21032018/M675_ProtoStimSleep_1min_180321_102404';
DataLocation{2}='/media/mobschapeau/DataMOBS82/M733/11052018/M733_Stim_ProtoSleep_1min_180511_103535';
DataLocation{3}='/media/mobschapeau/DataMOBS82/M711/10042018/M711_Stim_ProtoSleep_1min_180410_103027';
DataLocation{4}='/media/mobschapeau/DataMOBS821/M711/04042018/M711_Stim_ProtoSleep_1min_180404_102816';
DataLocation{5}='/media/mobschapeau/DataMOBS81/Pre-processing/M675/23032018/M675_Stim_ProtoSleep_1min_180323_103305';
DataLocation{6}='/media/mobschapeau/DataMOBS82/M733/23052018/M733_Stim_ProtoSleep_1min_180523_102236';
DataLocation{7}='/media/mobschapeau/DataMOBS82/M733/04062018/M733_Stim_ProtoSleep_1min_180604_100548';

DataLocation_Base{1}='/media/mobschapeau/DataMOBS82/Test Figures/22032018/M675_M645_Baseline_protoSleep_1min_180322_104439';
DataLocation_Base{2}='/media/mobschapeau/DataMOBS82/M733/24052018/M733_Baseline_ProtoSleep_1min_180524_103728';
% DataLocation_Base{3}='/media/mobschapeau/DataMOBS82/M711/17042018/M711_M675_Baseline_ProtoSleep_1min_180417_101952';
DataLocation_Base{3}='/media/mobschapeau/DataMOBS821/M711/28032018/M711_Baseline_ProtoSleep_1min_28032018';
DataLocation_Base{4}='/media/mobschapeau/DataMOBS81/Pre-processing/M675/28032018/M675_M711_Baseline_ProtoSleep_1min_180328_111302';
DataLocation_Base{5}='/media/mobschapeau/DataMOBS82/M733/28052018/M733_Baseline_ProtoSleep_1min_180528_110038';

VectTotal=[];

for i=1:length(DataLocation)
    cd(DataLocation{i})
    DataLocation{i}
    
    load('LFPData/DigInfo2.mat')
    load('SleepScoring_OBGamma.mat')
    
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

    %% Detection of the REM transition
   
    TransREMSWS = [];
    
    for k3=1:Nb_Stim

        if Result(k3,2) == 2
            if Result(k3,4) == 1
                TransREMSWS = sortrows([TransREMSWS ; Result(k3,1),Result(k3,3),Result(k3,5)],2);
            end
        end

    end
    
    
    %% Reste
    
    
    SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch);
    
    Vect = {};
    for i = 1:length(TransREMSWS(:,1))
        Vect{1} = Data(Restrict(SleepStages,intervalSet((TransREMSWS(i,1)-60)*(1e4), (TransREMSWS(i,1)+60)*(1e4))))';
        VectTotal=[VectTotal;Vect{1}];
        rg=Range(Restrict(SleepStages,intervalSet((TransREMSWS(i,1)-60)*(1e4), (TransREMSWS(i,1)+60)*(1e4))),'s');
        tps2=rg-rg(1)-60;
    end

end


VectTotal_Base=[];


for i=1:length(DataLocation_Base)
    cd(DataLocation_Base{i})
    DataLocation_Base{i}
    
    load('LFPData/DigInfo2.mat')
    load('SleepScoring_OBGamma.mat')
    
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

    %% Detection of the REM transition
   
    TransREMSWS = [];
    
    for k3=1:Nb_Stim

        if Result(k3,2) == 2
            if Result(k3,4) == 1
                TransREMSWS = sortrows([TransREMSWS ; Result(k3,1),Result(k3,3),Result(k3,5)],2);
            end
        end

    end
    
    
    %% Reste
    
    
    SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch);
    
    Vect = {};
    for i = 1:length(TransREMSWS(:,1))
        Vect{1} = Data(Restrict(SleepStages,intervalSet((TransREMSWS(i,1)-60)*(1e4), (TransREMSWS(i,1)+60)*(1e4))))';
        VectTotal_Base=[VectTotal_Base;Vect{1}];
        rg=Range(Restrict(SleepStages,intervalSet((TransREMSWS(i,1)-60)*(1e4), (TransREMSWS(i,1)+60)*(1e4))),'s');
        tps2=rg-rg(1)-60;
    end

end

% Dir=PathForExperimentsEmbReact('BaselineSleep');
% q = 0
% 
% for k = 1:length(Dir.path)
%     
%     for l = 1:length(Dir.path{k})
%         
%         cd(Dir.path{k}{l})
%         load('StateEpochSB.mat')
% 
%         a = 0
%         
%         Sleepy = or(SWSEpoch,REMEpoch);
%         Sleepy = mergeCloseIntervals(Sleepy,10000);
% 
%         a = 1
%         
%         SleepStart = Start(Sleepy)./(1e4); %matrix with the start times of all the sleep states
%         SleepEnd = End(Sleepy)./(1e4); %matrix with the end times of all the sleep states
%         Nb_SleepEpoch = length(SleepStart); 
%         Time_Stim = [];
% 
%         a = 2
%         
%         for j = 1:Nb_SleepEpoch
%             Stim = SleepStart(j)+60;
%             while Stim < SleepEnd(j)
%                 Time_Stim = [Time_Stim;Stim];
%                 Stim = Stim+120;
%             end
%         end
% 
%         a = 3
% 
%         WkStart= Start(Wake)./(1e4); %matrix with the start times of all the Wake states
%         SWSStart = Start(SWSEpoch)./(1e4); %matrix with the start times of all the SWS states
%         REMStart = Start(REMEpoch)./(1e4); %matrix with the start times of all the REM states
%         NoiseStart = Start(TotalNoiseEpoch)./(1e4); %matrix with the start times of all the Noise states
% 
%         a = 4
%         
%         TransREMSWS = Latence_all_mice_analyse(WkStart, SWSStart, REMStart, NoiseStart, Time_Stim);
%         
%         a = 5
%         
%         SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch);
% 
%         a = 6
%         
%         Vect = {};
%         for i = 1:length(TransREMSWS(:,1))
%             Vect{1} = Data(Restrict(SleepStages,intervalSet((TransREMSWS(i,1)-60)*(1e4), (TransREMSWS(i,1)+60)*(1e4))))';
%             VectTotal_Base=[VectTotal_Base;Vect{1}];
% %             rg=Range(Restrict(SleepStages,intervalSet((TransREMSWS(i,1)-60)*(1e4), (TransREMSWS(i,1)+60)*(1e4))),'s');
% %             tps2=rg-rg(1)-60;
%         end
% 
% 
%         q=q+1
%     end
% end
% 



cd('/home/mobschapeau/Dropbox/Mobs_member/Apolline/projet_VLPO')

% figure, imagesc(tps2,1:size(VectTotal,1),VectTotal(:,:))

REM = zeros(length(VectTotal(:,1)),2);

for k = 1:length(VectTotal(:,1)) %boucle sur toutes les lignes
    
    REMBefore = 0;
    REMAfter = 0;
    
    for i = 1:floor(length(VectTotal(1,:))./2)-1 %boucle sur toutes les colones avant stim
        if VectTotal(k,i) == 3
            REMBefore = REMBefore + 1;
        end
    end
    for p = floor(length(VectTotal(1,:))./2)+1:length(VectTotal(1,:))
        if VectTotal(k,p) == 3
            REMAfter = REMAfter + 1;
        end
    end
    
    REM(k,1) = (REMBefore/i)*100;
    REM(k,2) = (REMAfter/(p+1-floor(length(VectTotal(1,:))./2)+1))*100;
    
end

REM_Base_Mice = zeros(length(VectTotal_Base(:,1)),2);

for k = 1:length(VectTotal_Base(:,1)) %boucle sur toutes les lignes
    
    REMBefore = 0;
    REMAfter = 0;
    
    for i = 1:floor(length(VectTotal_Base(1,:))./2)-1 %boucle sur toutes les colones avant stim
        if VectTotal_Base(k,i) == 3
            REMBefore = REMBefore + 1;
        end
    end
    for p = floor(length(VectTotal_Base(1,:))./2)+1:length(VectTotal_Base(1,:))
        if VectTotal_Base(k,p) == 3
            REMAfter = REMAfter + 1;
        end
    end
    
    REM_Base_Mice(k,1) = (REMBefore/i)*100;
    REM_Base_Mice(k,2) = (REMAfter/(p+1-floor(length(VectTotal_Base(1,:))./2)+1))*100;
    
end

load('percentage_REM_BeforeAfter_all_mice_lab.mat')

% figure, plot(REM_Base(:,1),REM_Base(:,2),'*')
% hold on, plot(REM_Base_Mice(:,1),REM_Base_Mice(:,2),'g*')
% hold on, plot(REM(:,1),REM(:,2),'r*')
% title('Effect of the stim regarding the time of the Stim in the REM') 
% legend('All the mice of the lab','Baseline','Stimulation')
% xlabel('Percentage of REM during one minute before the Stim')
% ylabel('Percentage of REM during one minute after the Stim')

figure, hist2(REM_Base(:,1),REM_Base(:,2),20,20)
colorbar
hold on, scatter(REM_Base_Mice(:,1),REM_Base_Mice(:,2),50,'g','filled')
hold on, scatter(REM(:,1),REM(:,2),50,'r','filled')
title('Effect of the stim regarding the time of the Stim in the REM') 
legend('Baseline','Stimulation')
xlabel('Percentage of REM during one minute before the Stim')
ylabel('Percentage of REM during one minute after the Stim')


