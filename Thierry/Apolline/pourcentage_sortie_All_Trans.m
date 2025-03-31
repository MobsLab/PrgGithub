clear all
clc

result = 'number'; % unit of the yaxis of the plots, 'number' or 'percent'
plot = 'total'; % 'all' if you want the graphs per night, 'total' if you want only the sum graph

% %night 1
% %stim
% DataLocation{1}='/media/mobschapeau/DataMOBS81/Pre-processing/M711/04042018/M711_Stim_ProtoSleep_1min_180404_102816';
% %baseline
% DataLocation{2}='/media/mobschapeau/DataMOBS81/Pre-processing/M711/28032018/M711_Baseline_ProtoSleep_1min_28032018';

% %night 2
% %stim
% DataLocation{3}='/media/mobschapeau/DataMOBS81/Pre-processing/M675/21032018/M675_ProtoStimSleep_1min_180321_102404';
% %baseline
% DataLocation{4}='/media/mobschapeau/DataMOBS81/Pre-processing/M675/22032018/M675_M645_Baseline_protoSleep_1min_180322_104439';

% %night 3
% %stim
% DataLocation{5}='/media/mobschapeau/DataMOBS81/Pre-processing/M675/23032018/M675_Stim_ProtoSleep_1min_180323_103305';
% %baseline
% DataLocation{6}='/media/mobschapeau/DataMOBS81/Pre-processing/M675/28032018/M675_M711_Baseline_ProtoSleep_1min_180328_111302';

% %night 2_new_sleepScoring
% %stim
% DataLocation{1}='/media/mobschapeau/DataMOBS81/Pre-processing/M675/21032018/M675_ProtoStimSleep_1min_180321_102404/Test_SleepScoring';
% %baseline
% DataLocation{2}='/media/mobschapeau/DataMOBS81/Pre-processing/M675/22032018/M675_M645_Baseline_protoSleep_1min_180322_104439';

%night 2_new_sleepScoring_noNoise
%stim
DataLocation{1}='/media/mobschapeau/DataMOBS81/Pre-processing/M675/21032018/M675_ProtoStimSleep_1min_180321_102404/Test_SleepScoring/Without_all_Noise';
%baseline
DataLocation{2}='/media/mobschapeau/DataMOBS81/Pre-processing/M675/22032018/M675_M645_Baseline_protoSleep_1min_180322_104439/Test_SleepScoring/Without_all_Noise';

percentTotal = zeros(8,4);
Nb_StimTotal = zeros(8,1);

for l = 1:2:length(DataLocation)

    ind = strfind(DataLocation{l},'/M');
    Mouse_Nb = DataLocation{l}(ind(1)+1:ind(1)+4);
    night_Stim = DataLocation{l}(ind(1)+6:ind(1)+13);
    night_Baseline = DataLocation{l+1}(ind(1)+6:ind(1)+13);

    percent = NaN(8,4);

    n = 0;
    for i= [l l+1]
        
        n = n + 1;
        cd(DataLocation{i})
        
        if i == l
            Result = Analyse_Stim_Ap();
        else
            Result = Analyse_Stim_Ap();
        end


        for j = 0:3

            Nb_Stim = 0;
            Nb_TranstoREM = 0;     
            Nb_TranstoWake = 0 ;
            Nb_TranstoNoise = 0;
            Nb_TranstoSWS = 0;

            for k = 1:length(Result(:,1))

                if Result(k,2) == j
                    Nb_Stim = Nb_Stim + 1;

                    if Result(k,4) == 2
                        Nb_TranstoREM = Nb_TranstoREM + 1;
                    end

                    if Result(k,4) == 0
                        Nb_TranstoWake = Nb_TranstoWake + 1;
                    end

                    if Result(k,4) == 3
                        Nb_TranstoNoise = Nb_TranstoNoise + 1;
                    end

                    if Result(k,4) == 1
                        Nb_TranstoSWS = Nb_TranstoSWS + 1;
                    end
                end
            end

            percent((2*j)+n,1) = Nb_TranstoWake ;
            percent((2*j)+n,2) = Nb_TranstoSWS ;
            percent((2*j)+n,3) = Nb_TranstoREM ;
            percent((2*j)+n,4) = Nb_TranstoNoise ;

            percentTotal((2*j)+n,:) = percentTotal((2*j)+n,:) + percent((2*j)+n,:);
            Nb_StimTotal((2*j)+n,1) = Nb_StimTotal((2*j)+n,1) + Nb_Stim;

            if strcmp(result,'percent') == 1
                percent((2*j)+n,:) = (percent((2*j)+n,:)./Nb_Stim)*100;
            end

        end


    end

    if strcmp(plot,'all') == 1
        
        c = categorical({'Stimulation','Baseline'});

        figure

        subplot(2,2,1)
        bar(c,percent(1:2,:),'stacked')
        legend('Wake', 'SWS','REM', 'Noise')
        ylim([0 100])
        if strcmp(result,'percent') == 1
            ylabel('percentage of stimulations')
        else
            ylabel('number of stimulations')
        end
        title([Mouse_Nb ' - Baseline ' night_Baseline ' - Stim ' night_Stim ' - Wake'] )

        subplot(2,2,2)
        bar(c,percent(3:4,:),'stacked')
        legend('Wake', 'SWS','REM', 'Noise')
        ylim([0 100])
        if strcmp(result,'percent') == 1
            ylabel('percentage of stimulations')
        else
            ylabel('number of stimulations')
        end
        title([Mouse_Nb ' - SWS'] )

        subplot(2,2,3)
        bar(c,percent(5:6,:),'stacked')
        legend('Wake', 'SWS','REM', 'Noise')
        ylim([0 100])
        if strcmp(result,'percent') == 1
            ylabel('percentage of stimulations')
        else
            ylabel('number of stimulations')
        end
        title([Mouse_Nb ' - REM'] )

        subplot(2,2,4)
        bar(c,percent(7:8,:),'stacked')
        legend('Wake', 'SWS','REM', 'Noise')
        ylim([0 100])
        if strcmp(result,'percent') == 1
            ylabel('percentage of stimulations')
        else
            ylabel('number of stimulations')
        end
        title([Mouse_Nb ' - Noise'] )
        
    end

end

if strcmp(result,'percent') == 1
    for m = 1:4
        percentTotal(:,m) = (percentTotal(:,m)./Nb_StimTotal).*100;
    end
end

c = categorical({'Stimulation','Baseline'});

figure

subplot(2,2,1)
bar(c,percentTotal(1:2,:),'stacked')
legend('Wake', 'SWS','REM', 'Noise')
ylim([0 100])
if strcmp(result,'percent') == 1
    ylabel('percentage of stimulations')
else
    ylabel('number of stimulations')
end
title('Total - Wake' )

subplot(2,2,2)
bar(c,percentTotal(3:4,:),'stacked')
legend('Wake', 'SWS','REM', 'Noise')
ylim([0 100])
if strcmp(result,'percent') == 1
    ylabel('percentage of stimulations')
else
    ylabel('number of stimulations')
end
title('Total - SWS' )

subplot(2,2,3)
bar(c,percentTotal(5:6,:),'stacked')
legend('Wake', 'SWS','REM', 'Noise')
ylim([0 100])
if strcmp(result,'percent') == 1
    ylabel('percentage of stimulations')
else
    ylabel('number of stimulations')
end
title('Total - REM' )

subplot(2,2,4)
bar(c,percentTotal(7:8,:),'stacked')
legend('Wake', 'SWS','REM', 'Noise')
ylim([0 100])
if strcmp(result,'percent') == 1
    ylabel('percentage of stimulations')
else
    ylabel('number of stimulations')
end
title('Total - Noise' )

