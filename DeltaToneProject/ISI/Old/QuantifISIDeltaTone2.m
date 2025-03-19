% QuantifISIDeltaTone2
% 15.09.2016 KJ
%
% plot ISI statistics for several conditions
%   - Basal (n+1, n+2)
%   - DeltaTone, efficient tones (n+1, n+2)
%   - DeltaTone, failed tones (n+1, n+2)
% color bar plot for medians, means and modes
%
% Info
%   In this version of QuantifIsiDeltaTone, we take into account delay of
%   the tones, as well as the first ISI when the tones induced a down/delta
%

cd([FolderProjetDelta 'Data/'])


%% Concatenate
clear 
load QuantifIsiDeltaTone.mat
for i=1:length(delays)    
    %Basal records
    if delays(i)==0
        basal_deltas_isi1 = [];
        basal_deltas_isi2 = [];
        basal_down_isi1 = [];
        basal_down_isi2 = [];
        for p=1:length(basal_res.path)
            basal_deltas_isi1 = [basal_deltas_isi1 ; basal_res.intv_deltas1{p}];
            basal_deltas_isi2 = [basal_deltas_isi2 ; basal_res.intv_deltas2{p}];
            basal_down_isi1 = [basal_down_isi1 ; basal_res.intv_down1{p}];
            basal_down_isi2 = [basal_down_isi2 ; basal_res.intv_down2{p}];
        end
        dltone_delay.delay{i} = delays(i);

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
                dltone_gooddelta_isi1 = [dltone_gooddelta_isi1 ; deltatone_res.intv1_good_deltas{p}];
                dltone_gooddelta_isi2 = [dltone_gooddelta_isi2 ; deltatone_res.intv2_good_deltas{p}];
                dltone_baddelta_isi1 = [dltone_baddelta_isi1 ; deltatone_res.intv1_bad_deltas{p}];
                dltone_baddelta_isi2 = [dltone_baddelta_isi2 ; deltatone_res.intv2_bad_deltas{p}];
                dltone_gooddown_isi1 = [dltone_gooddown_isi1 ; deltatone_res.intv1_good_down{p}];
                dltone_gooddown_isi2 = [dltone_gooddown_isi2 ; deltatone_res.intv2_good_down{p}];
                dltone_baddown_isi1 = [dltone_baddown_isi1 ; deltatone_res.intv1_bad_down{p}];
                dltone_baddown_isi2 = [dltone_baddown_isi2 ; deltatone_res.intv2_bad_down{p}];
            end
        end
        dltone_delay.dltone_gooddelta_isi1{i} = dltone_gooddelta_isi1;
        dltone_delay.dltone_gooddelta_isi2{i} = dltone_gooddelta_isi2;
        dltone_delay.dltone_baddelta_isi1{i} = dltone_baddelta_isi1;
        dltone_delay.dltone_baddelta_isi2{i} = dltone_baddelta_isi2;
        dltone_delay.dltone_gooddown_isi1{i} = dltone_gooddown_isi1;
        dltone_delay.dltone_gooddown_isi2{i} = dltone_gooddown_isi2;
        dltone_delay.dltone_baddown_isi1{i} = dltone_baddown_isi1;
        dltone_delay.dltone_baddown_isi2{i} = dltone_baddown_isi2;
        dltone_delay.delay{i} = delays(i);
    end
    
end

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

down_median = [];
down_mean = [];
down_mode= [];
down_str = cell(0);
down_color = cell(0);
down_alpha = [];

for i=1:length(delays)
    
    %basal
    if delays(i)==0
        %delta
        delta_median = [delta_median median(basal_deltas_isi1)];
        delta_mean = [delta_mean mean(basal_deltas_isi1)];
        delta_mode = [delta_mode mode(basal_deltas_isi1)];
        delta_str{length(delta_str)+1} = 'Basal n+1';
        delta_color{length(delta_color)+1} = 'k';
        delta_alpha = [delta_alpha 1];
        
        delta_median = [delta_median median(basal_deltas_isi2)];
        delta_mean = [delta_mean mean(basal_deltas_isi2)];
        delta_mode = [delta_mode mode(basal_deltas_isi2)];
        delta_str{length(delta_str)+1} = 'Basal n+2';
        delta_color{length(delta_color)+1} = 'k';
        delta_alpha = [delta_alpha 0.9];
        
        %down
        down_median = [down_median median(basal_down_isi1)];
        down_mean = [down_mean mean(basal_down_isi1)];
        down_mode = [down_mode mode(basal_down_isi1)];
        down_str{length(down_str)+1} = 'Basal n+1';
        down_color{length(down_color)+1} = 'k';
        down_alpha = [down_alpha 1];

        down_median = [down_median median(basal_down_isi2)];
        down_mean = [down_mean mean(basal_down_isi2)];
        down_mode = [down_mode mode(basal_down_isi2)];
        down_str{length(down_str)+1} = 'Basal n+2';
        down_color{length(down_color)+1} = 'k';
        down_alpha = [down_alpha 0.9];

        
    %deltatone, many delays
    else
        %delta
        delta_median = [delta_median median(dltone_delay.dltone_gooddelta_isi1{i})];
        delta_mean = [delta_mean mean(dltone_delay.dltone_gooddelta_isi1{i})];
        delta_mode = [delta_mode mode(dltone_delay.dltone_gooddelta_isi1{i})];
        delta_str{length(delta_str)+1} = ['Success Tones n+1 (' num2str(delays(i)*1000) 'ms)'];
        delta_color{length(delta_color)+1} = 'b';
        delta_alpha = [delta_alpha 1];

        delta_median = [delta_median median(dltone_delay.dltone_gooddelta_isi2{i})];
        delta_mean = [delta_mean mean(dltone_delay.dltone_gooddelta_isi2{i})];
        delta_mode = [delta_mode mode(dltone_delay.dltone_gooddelta_isi2{i})];
        delta_str{length(delta_str)+1} = ['Success Tones n+2 (' num2str(delays(i)*1000) 'ms)'];
        delta_color{length(delta_color)+1} = 'b';
        delta_alpha = [delta_alpha 0.5];

        delta_median = [delta_median median(dltone_delay.dltone_baddelta_isi1{i})];
        delta_mean = [delta_mean mean(dltone_delay.dltone_baddelta_isi1{i})];
        delta_mode = [delta_mode mode(dltone_delay.dltone_baddelta_isi1{i})];
        delta_str{length(delta_str)+1} = ['Failed Tones n+1 (' num2str(delays(i)*1000) 'ms)'];
        delta_color{length(delta_color)+1} = 'r';
        delta_alpha = [delta_alpha 1];
        
        delta_median = [delta_median median(dltone_delay.dltone_baddelta_isi2{i})];
        delta_mean = [delta_mean mean(dltone_delay.dltone_baddelta_isi2{i})];
        delta_mode = [delta_mode mode(dltone_delay.dltone_baddelta_isi2{i})];
        delta_str{length(delta_str)+1} = ['Failed Tones n+2 (' num2str(delays(i)*1000) 'ms)'];
        delta_color{length(delta_color)+1} = 'r';
        delta_alpha = [delta_alpha 0.5];
        
        %down
        down_median = [down_median median(dltone_delay.dltone_gooddown_isi1{i})];
        down_mean = [down_mean mean(dltone_delay.dltone_gooddown_isi1{i})];
        down_mode = [down_mode mode(dltone_delay.dltone_gooddown_isi1{i})];
        down_str{length(down_str)+1} = ['Success Tones n+1 (' num2str(delays(i)*1000) 'ms)'];
        down_color{length(down_color)+1} = 'b';
        down_alpha = [down_alpha 1];
        
        down_median = [down_median median(dltone_delay.dltone_gooddown_isi2{i})];
        down_mean = [down_mean mean(dltone_delay.dltone_gooddown_isi2{i})];
        down_mode = [down_mode mode(dltone_delay.dltone_gooddown_isi2{i})];
        down_str{length(down_str)+1} = ['Success Tones n+2 (' num2str(delays(i)*1000) 'ms)'];
        down_color{length(down_color)+1} = 'b';
        down_alpha = [down_alpha 0.5];
        
        down_median = [down_median median(dltone_delay.dltone_baddown_isi1{i})];
        down_mean = [down_mean mean(dltone_delay.dltone_baddown_isi1{i})];
        down_mode = [down_mode mode(dltone_delay.dltone_baddown_isi1{i})];
        down_str{length(down_str)+1} = ['Failed Tones n+1 (' num2str(delays(i)*1000) 'ms)'];
        down_color{length(down_color)+1} = 'r';
        down_alpha = [down_alpha 1];
        
        down_median = [down_median median(dltone_delay.dltone_baddown_isi2{i})];
        down_mean = [down_mean mean(dltone_delay.dltone_baddown_isi2{i})];
        down_mode = [down_mode mode(dltone_delay.dltone_baddown_isi2{i})];
        down_str{length(down_str)+1} = ['Failed Tones n+2 (' num2str(delays(i)*1000) 'ms)'];
        down_color{length(down_color)+1} = 'r';
        down_alpha = [down_alpha 0.5];
        
    end
end

%% sort data - ascend
%delta
[delta_median, idx] = sort(delta_median);
delta_median_str = delta_str(idx);
delta_median_color = delta_color(idx);
delta_median_alpha = delta_alpha(idx);

[delta_mean, idx] = sort(delta_mean);
delta_mean_str = delta_str(idx);
delta_mean_color = delta_color(idx);
delta_mean_alpha = delta_alpha(idx);

[delta_mode, idx] = sort(delta_mode);
delta_mode_str = delta_str(idx);
delta_mode_color = delta_color(idx);
delta_mode_alpha = delta_alpha(idx);

%down
[down_median, idx] = sort(down_median);
down_median_str = down_str(idx);
down_median_color = down_color(idx);
down_median_alpha = down_alpha(idx);

[down_mean, idx] = sort(down_mean);
down_mean_str = down_str(idx);
down_mean_color = down_color(idx);
down_mean_alpha = down_alpha(idx);

[down_mode, idx] = sort(down_mode);
down_mode_str = down_str(idx);
down_mode_color = down_color(idx);
down_mode_alpha = down_alpha(idx);


%% plot bar

%delta figure
figure, hold on
subplot(1,3,1), hold on, 
for i=1:length(delta_median)
    h = bar(i, delta_median(i)/10);
    set(h,'FaceColor', delta_median_color{i});
    set(h,'FaceAlpha', delta_median_alpha(i));
end
title('delta ISI - median'), hold on,
set(gca, 'XTickLabel',delta_median_str, 'XTick',1:numel(delta_median_str), 'XTickLabelRotation', 45), hold on,

subplot(1,3,2), hold on,
for i=1:length(delta_mean)
    h = bar(i, delta_mean(i)/10);
    set(h,'FaceColor', delta_mean_color{i});
    set(h,'FaceAlpha', delta_mean_alpha(i));
end
title('delta ISI - mean'), hold on,
set(gca, 'XTickLabel',delta_mean_str, 'XTick',1:numel(delta_mean_str), 'XTickLabelRotation', 45), hold on,

subplot(1,3,3), hold on,
for i=1:length(delta_mode)
    h = bar(i, delta_mode(i)/10);
    set(h,'FaceColor', delta_mode_color{i});
    set(h,'FaceAlpha', delta_mode_alpha(i));
end
title('delta ISI - mode'), hold on,
set(gca, 'XTickLabel',delta_mode_str, 'XTick',1:numel(delta_mode_str), 'XTickLabelRotation', 45)

l = zeros(3, 1);
l(2) = plot(0,0,'s', 'visible', 'on', 'MarkerFaceColor', 'b','MarkerEdgeColor','b');
l(3) = plot(0,0,'s', 'visible', 'on', 'MarkerFaceColor', 'r','MarkerEdgeColor','r');
l(1) = plot(0,0,'s', 'visible', 'on', 'MarkerFaceColor', 'k','MarkerEdgeColor','k');
leg = legend(l, 'Basal', 'Success', 'Failed');
set(leg,'fontweight','bold', 'Location','NorthWest');


%down figure
figure, hold on
subplot(1,3,1), hold on,
for i=1:length(down_median)
    h = bar(i, down_median(i)/10);
    set(h,'FaceColor', down_median_color{i});
    set(h,'FaceAlpha', down_median_alpha(i));
end
title('down ISI - median'), hold on,
set(gca, 'XTickLabel',down_median_str, 'XTick',1:numel(down_median_str), 'XTickLabelRotation', 45), hold on,

subplot(1,3,2), hold on,
for i=1:length(down_mean)
    h = bar(i, down_mean(i)/10);
    set(h,'FaceColor', down_mean_color{i});
    set(h,'FaceAlpha', down_mean_alpha(i));
end
title('down ISI - mean'), hold on,
set(gca, 'XTickLabel',down_mean_str, 'XTick',1:numel(down_mean_str), 'XTickLabelRotation', 45), hold on,

subplot(1,3,3), hold on,
for i=1:length(down_mode)
    h = bar(i, down_mode(i)/10);
    set(h,'FaceColor', down_mode_color{i});
    set(h,'FaceAlpha', down_mode_alpha(i));
end
title('down ISI - mode'), hold on,
set(gca, 'XTickLabel',down_mode_str, 'XTick',1:numel(down_mode_str), 'XTickLabelRotation', 45)

l = zeros(3, 1);
l(2) = plot(0,0,'s', 'visible', 'on', 'MarkerFaceColor', 'b','MarkerEdgeColor','b');
l(3) = plot(0,0,'s', 'visible', 'on', 'MarkerFaceColor', 'r','MarkerEdgeColor','r');
l(1) = plot(0,0,'s', 'visible', 'on', 'MarkerFaceColor', 'k','MarkerEdgeColor','k');
leg = legend(l, 'Basal', 'Success', 'Failed');
set(leg,'fontweight','bold', 'Location','NorthWest');






