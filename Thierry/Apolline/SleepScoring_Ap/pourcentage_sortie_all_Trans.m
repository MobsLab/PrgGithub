function [] = pourcentage_sortie_all_Trans(DataLocation,result,plot)
%pourcentage_sortie_all_Trans_new_SleepScoring_noNoise Summary of this function goes here
%   Detailed explanation goes here

%     result = 'percent'; % unit of the yaxis of the plots, 'number' or 'percent'
%     plot = 'total'; % 'all' if you want the graphs per night, 'total' if you want only the sum graph

%     for i = 1:length(DataLocation)
%          DataLocation{i}=[DataLocation{i} '/Without_all_Noise'];
%     end

    percentTotal = zeros(8,4);
    Nb_StimTotal = zeros(8,1);
    Nb_all_Stim = cell(length(DataLocation),4);

    for y = 1:length(DataLocation)
        for u = 1:4
            Nb_all_Stim{y,u} = zeros(1,4);
        end
    end

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
            cd ..

            if i == l
                Result = Analyse_Stim_Ap();
            else
                Result = Analyse_Stim_Ap();
            end


            for j = 0:3

                Nb_Stim = 0;

                for k = 1:length(Result(:,1))

                    if Result(k,2) == j
                        Nb_Stim = Nb_Stim + 1;

                        if Result(k,4) == 0
                            Nb_all_Stim{i,j+1}(1) = Nb_all_Stim{i,j+1}(1) + 1;
                        end

                        if Result(k,4) == 1
                            Nb_all_Stim{i,j+1}(2) = Nb_all_Stim{i,j+1}(2) + 1;
                        end

                        if Result(k,4) == 2
                            Nb_all_Stim{i,j+1}(3) = Nb_all_Stim{i,j+1}(3) + 1;
                        end

                        if Result(k,4) == 3
                            Nb_all_Stim{i,j+1}(4) = Nb_all_Stim{i,j+1}(4) + 1;
                        end

                    end
                end

                percent((2*j)+n,1) = Nb_all_Stim{i,j+1}(1) ;
                percent((2*j)+n,2) = Nb_all_Stim{i,j+1}(2) ;
                percent((2*j)+n,3) = Nb_all_Stim{i,j+1}(3) ;
                percent((2*j)+n,4) = Nb_all_Stim{i,j+1}(4) ;

                percentTotal((2*j)+n,:) = percentTotal((2*j)+n,:) + percent((2*j)+n,:);
                Nb_StimTotal((2*j)+n,1) = Nb_StimTotal((2*j)+n,1) + Nb_Stim;

                if strcmp(result,'percent') == 1
                    percent((2*j)+n,:) = (percent((2*j)+n,:)./Nb_Stim)*100;
                end

            end


        end

        if strcmp(plot,'all') == 1


            figure

            subplot(2,2,1)
            c = categorical({strcat('Stimulation - ',num2str(sum(Nb_all_Stim{l,1})),' stims'), strcat('Baseline - ',num2str(sum(Nb_all_Stim{l+1,1})),' stims')});
            bar(c,percent(1:2,:),'stacked')
            legend('Wake', 'SWS','REM', 'Noise')
            ylim([0 100])
            if strcmp(result,'percent') == 1
                ylabel('percentage of stimulations')
            else
                ylabel('number of stimulations')
            end
            title( 'Transitions from Wake' )

            subplot(2,2,2)
            c = categorical({strcat('Stimulation - ',num2str(sum(Nb_all_Stim{l,2})),' stims'), strcat('Baseline - ',num2str(sum(Nb_all_Stim{l+1,2})),' stims')});
            bar(c,percent(3:4,:),'stacked')
            legend('Wake', 'SWS','REM', 'Noise')
            ylim([0 100])
            if strcmp(result,'percent') == 1
                ylabel('percentage of stimulations')
            else
                ylabel('number of stimulations')
            end
            title('Transitions from SWS' )

            subplot(2,2,3)
            c = categorical({strcat('Stimulation - ',num2str(sum(Nb_all_Stim{l,3})),' stims'), strcat('Baseline - ',num2str(sum(Nb_all_Stim{l+1,3})),' stims')});
            bar(c,percent(5:6,:),'stacked')
            legend('Wake', 'SWS','REM', 'Noise')
            ylim([0 100])
            if strcmp(result,'percent') == 1
                ylabel('percentage of stimulations')
            else
                ylabel('number of stimulations')
            end
            title('Transitions from REM' )

            subplot(2,2,4)
            c = categorical({strcat('Stimulation - ',num2str(sum(Nb_all_Stim{l,4})),' stims'), strcat('Baseline - ',num2str(sum(Nb_all_Stim{l+1,4})),' stims')});
            bar(c,percent(7:8,:),'stacked')
            legend('Wake', 'SWS','REM', 'Noise')
            ylim([0 100])
            if strcmp(result,'percent') == 1
                ylabel('percentage of stimulations')
            else
                ylabel('number of stimulations')
            end
            title('Transitions from Noise' )

            suplabel([Mouse_Nb ' - Baseline ' night_Baseline ' - Stim ' night_Stim ' - no Noise' ],'t')

        end

    end

    if strcmp(result,'percent') == 1
        for m = 1:4
            percentTotal(:,m) = (percentTotal(:,m)./Nb_StimTotal).*100;
        end
    end

    figure

    subplot(2,2,1)
    c = categorical({strcat('Stimulation - ',num2str(Nb_StimTotal(1)),' stims'), strcat('Baseline - ',num2str(Nb_StimTotal(2)),' stims')});
    bar(c,percentTotal(1:2,:),'stacked')
    legend('Wake', 'SWS','REM', 'Noise')
    ylim([0 100])
    if strcmp(result,'percent') == 1
        ylabel('percentage of stimulations')
    else
        ylabel('number of stimulations')
    end
    title('Transitions from Wake')

    subplot(2,2,2)
    c = categorical({strcat('Stimulation - ',num2str(Nb_StimTotal(3)),' stims'), strcat('Baseline - ',num2str(Nb_StimTotal(4)),' stims')});
    bar(c,percentTotal(3:4,:),'stacked')
    legend('Wake', 'SWS','REM', 'Noise')
    ylim([0 100])
    if strcmp(result,'percent') == 1
        ylabel('percentage of stimulations')
    else
        ylabel('number of stimulations')
    end
    title('Transitions from SWS' )

    subplot(2,2,3)
    c = categorical({strcat('Stimulation - ',num2str(Nb_StimTotal(5)),' stims'), strcat('Baseline - ',num2str(Nb_StimTotal(6)),' stims')});
    bar(c,percentTotal(5:6,:),'stacked')
    legend('Wake', 'SWS','REM', 'Noise')
    ylim([0 100])
    if strcmp(result,'percent') == 1
        ylabel('percentage of stimulations')
    else
        ylabel('number of stimulations')
    end
    title('Transitions from REM' )

    subplot(2,2,4)
    c = categorical({strcat('Stimulation - ',num2str(Nb_StimTotal(7)),' stims'), strcat('Baseline - ',num2str(Nb_StimTotal(8)),' stims')});
    bar(c,percentTotal(7:8,:),'stacked')
    legend('Wake', 'SWS','REM', 'Noise')
    ylim([0 100])
    if strcmp(result,'percent') == 1
        ylabel('percentage of stimulations')
    else
        ylabel('number of stimulations')
    end
    title('Transitions from Noise')

    suplabel('all 6 mice together - allNoise','t')



end

