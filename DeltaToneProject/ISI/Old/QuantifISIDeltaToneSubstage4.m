% QuantifISIDeltaToneSubstage4
% 05.10.2016 KJ
%
% - bar plot (median, mode) for several conditions and substages
% - one figure per condition / delay
%
% Info
%   see QuantifISIDeltaToneSubstage42
%


%load
cd([FolderProjetDelta 'Data/']) 
clear 
load QuantifISIDeltaToneSubstage2.mat


%% Concatenate
for sub=substages_ind
    for i=1:length(delays)

        %Basal records
        if delays(i)==0
            basal_deltas_isi1 = [];
            basal_deltas_isi2 = [];
            basal_down_isi1 = [];
            basal_down_isi2 = [];
            for p=1:length(basal_res.path)
                basal_deltas_isi1 = [basal_deltas_isi1 ; basal_res.intv_deltas1{p,sub}];
                basal_deltas_isi2 = [basal_deltas_isi2 ; basal_res.intv_deltas2{p,sub}];
                basal_down_isi1 = [basal_down_isi1 ; basal_res.intv_down1{p,sub}];
                basal_down_isi2 = [basal_down_isi2 ; basal_res.intv_down2{p,sub}];
            end
            dltone_delay.delay{i} = delays(i);
            dltone_delay.basal_deltas_isi1{sub} = basal_deltas_isi1;
            dltone_delay.basal_deltas_isi2{sub} = basal_deltas_isi2;
            dltone_delay.basal_down_isi1{sub} = basal_down_isi1;
            dltone_delay.basal_down_isi2{sub} = basal_down_isi2;
            
        %DeltaTone records
        else
            dltone_gooddelta_isi1 = [];
            dltone_gooddelta_isi2 = [];
            dltone_baddelta_isi1 = [];
            dltone_baddelta_isi2 = [];
            dltone_gooddown_isi1 = [];
            dltone_gooddown_isi2 = [];
            dltone_baddown_isi1 = [];
            dltone_baddown_isi2 = [];
            for p=1:length(deltatone_res.path)
                if deltatone_res.delay{p}==delays(i)
                    dltone_gooddelta_isi1 = [dltone_gooddelta_isi1 ; deltatone_res.intv1_good_deltas{p,sub}];
                    dltone_gooddelta_isi2 = [dltone_gooddelta_isi2 ; deltatone_res.intv2_good_deltas{p,sub}];
                    dltone_baddelta_isi1 = [dltone_baddelta_isi1 ; deltatone_res.intv1_bad_deltas{p,sub}];
                    dltone_baddelta_isi2 = [dltone_baddelta_isi2 ; deltatone_res.intv2_bad_deltas{p,sub}];
                    dltone_gooddown_isi1 = [dltone_gooddown_isi1 ; deltatone_res.intv1_good_down{p,sub}];
                    dltone_gooddown_isi2 = [dltone_gooddown_isi2 ; deltatone_res.intv2_good_down{p,sub}];
                    dltone_baddown_isi1 = [dltone_baddown_isi1 ; deltatone_res.intv1_bad_down{p,sub}];
                    dltone_baddown_isi2 = [dltone_baddown_isi2 ; deltatone_res.intv2_bad_down{p,sub}];
                end
            end
            dltone_delay.dltone_gooddelta_isi1{i,sub} = dltone_gooddelta_isi1;
            dltone_delay.dltone_gooddelta_isi2{i,sub} = dltone_gooddelta_isi2;
            dltone_delay.dltone_baddelta_isi1{i,sub} = dltone_baddelta_isi1;
            dltone_delay.dltone_baddelta_isi2{i,sub} = dltone_baddelta_isi2;
            dltone_delay.dltone_gooddown_isi1{i,sub} = dltone_gooddown_isi1;
            dltone_delay.dltone_gooddown_isi2{i,sub} = dltone_gooddown_isi2;
            dltone_delay.dltone_baddown_isi1{i,sub} = dltone_baddown_isi1;
            dltone_delay.dltone_baddown_isi2{i,sub} = dltone_baddown_isi2;
            dltone_delay.delay{i,sub} = delays(i);
        end
        
    end
end

clear sub i p
clear basal_deltas_isi1 basal_deltas_isi2 basal_down_isi1 basal_down_isi2
clear dltone_gooddelta_isi1 dltone_gooddelta_isi2 dltone_baddelta_isi1 dltone_baddelta_isi2
clear dltone_gooddown_isi1 dltone_gooddown_isi2 dltone_baddown_isi1 dltone_baddown_isi2
clear deltatone_res basal_res


%% Stat and plot
delta_median = [];
delta_mean = [];
delta_mode = [];
delta_str = cell(0);
delta_color = cell(0);
delta_alpha = [];
delta_condition = [];

down_median = [];
down_mean = [];
down_mode= [];
down_str = cell(0);
down_color = cell(0);
down_alpha = [];
down_condition = [];


for sub=substages_ind
    delta_median_sub = [];
    delta_mean_sub = [];
    delta_mode_sub = [];
    delta_str_sub = cell(0);
    delta_color_sub = cell(0);
    delta_alpha_sub = [];
    delta_condition_sub = [];

    down_median_sub = [];
    down_mean_sub = [];
    down_mode_sub = [];
    down_str_sub = cell(0);
    down_color_sub = cell(0);
    down_alpha_sub = [];
    down_condition_sub = [];
    
    for i=1:length(delays)
        %basal
        if delays(i)==0
            %delta
            delta_median_sub = [delta_median_sub median(dltone_delay.basal_deltas_isi1{sub})];
            delta_mean_sub = [delta_mean_sub mean(dltone_delay.basal_deltas_isi1{sub})];
            delta_mode_sub = [delta_mode_sub mode(dltone_delay.basal_deltas_isi1{sub})];
            delta_str_sub{length(delta_str_sub)+1} = 'Basal n+1';
            delta_color_sub{length(delta_color_sub)+1} = 'k';
            delta_alpha_sub = [delta_alpha_sub 1];
            delta_condition_sub = [delta_condition_sub delays(i)];

            delta_median_sub = [delta_median_sub median(dltone_delay.basal_deltas_isi2{sub})];
            delta_mean_sub = [delta_mean_sub mean(dltone_delay.basal_deltas_isi2{sub})];
            delta_mode_sub = [delta_mode_sub mode(dltone_delay.basal_deltas_isi2{sub})];
            delta_str_sub{length(delta_str_sub)+1} = 'Basal n+2';
            delta_color_sub{length(delta_color_sub)+1} = 'k';
            delta_alpha_sub = [delta_alpha_sub 0.8];
            delta_condition_sub = [delta_condition_sub delays(i)];

            %down
            down_median_sub = [down_median_sub median(dltone_delay.basal_down_isi1{sub})];
            down_mean_sub = [down_mean_sub mean(dltone_delay.basal_down_isi1{sub})];
            down_mode_sub = [down_mode_sub mode(dltone_delay.basal_down_isi1{sub})];
            down_str_sub{length(down_str_sub)+1} = 'Basal n+1';
            down_color_sub{length(down_color_sub)+1} = 'k';
            down_alpha_sub = [down_alpha_sub 1];
            down_condition_sub = [down_condition_sub delays(i)];

            down_median_sub = [down_median_sub median(dltone_delay.basal_down_isi2{sub})];
            down_mean_sub = [down_mean_sub mean(dltone_delay.basal_down_isi2{sub})];
            down_mode_sub = [down_mode_sub mode(dltone_delay.basal_down_isi2{sub})];
            down_str_sub{length(down_str_sub)+1} = 'Basal n+2';
            down_color_sub{length(down_color_sub)+1} = 'k';
            down_alpha_sub = [down_alpha_sub 0.8];
            down_condition_sub = [down_condition_sub delays(i)];


        %deltatone, many delays
        else
            %delta
            delta_median_sub = [delta_median_sub median(dltone_delay.dltone_gooddelta_isi1{i,sub})];
            delta_mean_sub = [delta_mean_sub mean(dltone_delay.dltone_gooddelta_isi1{i,sub})];
            delta_mode_sub = [delta_mode_sub mode(dltone_delay.dltone_gooddelta_isi1{i,sub})];
            delta_str_sub{length(delta_str_sub)+1} = 'Success Tones n+1';
            delta_color_sub{length(delta_color_sub)+1} = 'b';
            delta_alpha_sub = [delta_alpha_sub 1];
            delta_condition_sub = [delta_condition_sub delays(i)];

            delta_median_sub = [delta_median_sub median(dltone_delay.dltone_gooddelta_isi2{i,sub})];
            delta_mean_sub = [delta_mean_sub mean(dltone_delay.dltone_gooddelta_isi2{i,sub})];
            delta_mode_sub = [delta_mode_sub mode(dltone_delay.dltone_gooddelta_isi2{i,sub})];
            delta_str_sub{length(delta_str_sub)+1} = 'Success Tones n+2';
            delta_color_sub{length(delta_color_sub)+1} = 'b';
            delta_alpha_sub = [delta_alpha_sub 0.5];
            delta_condition_sub = [delta_condition_sub delays(i)];

            delta_median_sub = [delta_median_sub median(dltone_delay.dltone_baddelta_isi1{i,sub})];
            delta_mean_sub = [delta_mean_sub mean(dltone_delay.dltone_baddelta_isi1{i,sub})];
            delta_mode_sub = [delta_mode_sub mode(dltone_delay.dltone_baddelta_isi1{i,sub})];
            delta_str_sub{length(delta_str_sub)+1} = 'Failed Tones n+1';
            delta_color_sub{length(delta_color_sub)+1} = 'r';
            delta_alpha_sub = [delta_alpha_sub 1];
            delta_condition_sub = [delta_condition_sub delays(i)];

            delta_median_sub = [delta_median_sub median(dltone_delay.dltone_baddelta_isi2{i,sub})];
            delta_mean_sub = [delta_mean_sub mean(dltone_delay.dltone_baddelta_isi2{i,sub})];
            delta_mode_sub = [delta_mode_sub mode(dltone_delay.dltone_baddelta_isi2{i,sub})];
            delta_str_sub{length(delta_str_sub)+1} = 'Failed Tones n+2';
            delta_color_sub{length(delta_color_sub)+1} = 'r';
            delta_alpha_sub = [delta_alpha_sub 0.5];
            delta_condition_sub = [delta_condition_sub delays(i)];

            %down
            down_median_sub = [down_median_sub median(dltone_delay.dltone_gooddown_isi1{i,sub})];
            down_mean_sub = [down_mean_sub mean(dltone_delay.dltone_gooddown_isi1{i,sub})];
            down_mode_sub = [down_mode_sub mode(dltone_delay.dltone_gooddown_isi1{i,sub})];
            down_str_sub{length(down_str_sub)+1} = 'Success Tones n+1';
            down_color_sub{length(down_color_sub)+1} = 'b';
            down_alpha_sub = [down_alpha_sub 1];
            down_condition_sub = [down_condition_sub delays(i)];

            down_median_sub = [down_median_sub median(dltone_delay.dltone_gooddown_isi2{i,sub})];
            down_mean_sub = [down_mean_sub mean(dltone_delay.dltone_gooddown_isi2{i,sub})];
            down_mode_sub = [down_mode_sub mode(dltone_delay.dltone_gooddown_isi2{i,sub})];
            down_str_sub{length(down_str_sub)+1} = 'Success Tones n+2';
            down_color_sub{length(down_color_sub)+1} = 'b';
            down_alpha_sub = [down_alpha_sub 0.5];
            down_condition_sub = [down_condition_sub delays(i)];

            down_median_sub = [down_median_sub median(dltone_delay.dltone_baddown_isi1{i,sub})];
            down_mean_sub = [down_mean_sub mean(dltone_delay.dltone_baddown_isi1{i,sub})];
            down_mode_sub = [down_mode_sub mode(dltone_delay.dltone_baddown_isi1{i,sub})];
            down_str_sub{length(down_str_sub)+1} = 'Failed Tones n+1';
            down_color_sub{length(down_color_sub)+1} = 'r';
            down_alpha_sub = [down_alpha_sub 1];
            down_condition_sub = [down_condition_sub delays(i)];

            down_median_sub = [down_median_sub median(dltone_delay.dltone_baddown_isi2{i,sub})];
            down_mean_sub = [down_mean_sub mean(dltone_delay.dltone_baddown_isi2{i,sub})];
            down_mode_sub = [down_mode_sub mode(dltone_delay.dltone_baddown_isi2{i,sub})];
            down_str_sub{length(down_str_sub)+1} = 'Failed Tones n+2';
            down_color_sub{length(down_color_sub)+1} = 'r';
            down_alpha_sub = [down_alpha_sub 0.5];
            down_condition_sub = [down_condition_sub delays(i)];
        end
    end
    
    
    delta_median = [delta_median; delta_median_sub];
    delta_mean = [delta_mean; delta_mean_sub];
    delta_mode = [delta_mode; delta_mode_sub];
    delta_str(sub,:) = delta_str_sub;
    delta_color(sub,:) = delta_color_sub;
    delta_alpha = [delta_alpha; delta_alpha_sub];
    delta_condition = [delta_condition; delta_condition_sub];

    down_median = [down_median; down_median_sub];
    down_mean = [down_mean; down_mean_sub];
    down_mode= [down_mode; down_mode_sub];
    down_str(sub,:) = down_str_sub;
    down_color(sub,:) = down_color_sub;
    down_alpha = [down_alpha; down_alpha_sub];
    down_condition = [down_condition; down_condition_sub];

end

clear delta_median_sub delta_mean_sub delta_mode_sub delta_str_sub delta_color_sub delta_alpha_sub delta_condition_sub
clear down_median_sub down_mean_sub down_mode_sub down_str_sub down_color_sub down_alpha_sub down_condition_sub
clear i sub


%% Order and plot
pos_delays = delays(delays>0);
figtypes = {'Median', 'Mode'}; % stats
NameSubstages = {'N1', 'N2', 'N3'}; % NREM substages
substages_plot = 1:3;

%Delta
for conditions=pos_delays
    figure, hold on
    for ft=1:length(figtypes)
        for sub=substages_plot
            if ft==1 %median
                [values_sorted, idx] = sort(delta_median(sub,:));
                ylim = [0 6000];
            elseif ft==2 %mode
                [values_sorted, idx] = sort(delta_mode(sub,:));
                ylim = [0 6000];
            end
            idx_cond = find(delta_condition(sub,:)==conditions|delta_condition(sub,:)==0);
            idx = idx(ismember(idx,idx_cond));
            values_sorted = values_sorted(ismember(idx,idx_cond));
            
            bar_str = delta_str(sub, idx);
            bar_color = delta_color(sub, idx);
            bar_alpha = delta_alpha(sub, idx);

            subplot(2,3,3*(ft-1)+sub), hold on, 
            for i=1:length(values_sorted)
                h = bar(i, values_sorted(i)/10);
                set(h,'FaceColor', bar_color{i});
                set(h,'FaceAlpha', bar_alpha(i));
            end
            title([NameSubstages{sub} ' - ' figtypes{ft}]), hold on,
            set(gca, 'XTickLabel',bar_str, 'XTick',1:numel(bar_str), 'XTickLabelRotation', 30), hold on,
        end
    end
    suplabel(['Delta ISI - ' num2str(conditions) 'ms'],'t');
    
end

%Down
for conditions=pos_delays
    figure, hold on
    for ft=1:length(figtypes)
        %down
        for sub=substages_plot
            if ft==1 %median
                [values_sorted, idx] = sort(down_median(sub,:));
                ylim = [0 6000];
            elseif ft==2 %mode
                [values_sorted, idx] = sort(down_mode(sub,:));
                ylim = [0 6000];
            end
            idx_cond = find(down_condition(sub,:)==conditions|down_condition(sub,:)==0);
            idx = idx(ismember(idx,idx_cond));
            values_sorted = values_sorted(ismember(idx,idx_cond));
            
            bar_str = down_str(sub, idx);
            bar_color = down_color(sub, idx);
            bar_alpha = down_alpha(sub, idx);

            subplot(2,3,3*(ft-1)+sub), hold on, 
            for i=1:length(values_sorted)
                h = bar(i, values_sorted(i)/10);
                set(h,'FaceColor', bar_color{i});
                set(h,'FaceAlpha', bar_alpha(i));
            end
            title([NameSubstages{sub} ' - ' figtypes{ft}]), hold on,
            set(gca, 'XTickLabel',bar_str, 'XTick',1:numel(bar_str), 'XTickLabelRotation', 30), hold on,
        end
    end
    suplabel(['Down ISI - ' num2str(conditions) 'ms'],'t');
    
end


