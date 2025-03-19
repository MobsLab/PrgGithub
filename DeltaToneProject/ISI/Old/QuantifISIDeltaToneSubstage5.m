% QuantifISIDeltaToneSubstage5
% 14.11.2016 KJ
%
% bar plot (median, mode) for several conditions and substages.
% Mice are represented with dots, stats are done over mice (use of plotErrorBarN) 
%
% Info
%   In this version of QuantifIsiDeltaTone, we take into account delay of
%   the tones, as well as the first ISI when the tones induced a down/delta
%   Analysis are made for the different substages. We compute for example
%   means over the mean for each mice.
%


%load
cd([FolderProjetDelta 'Data/'])
clear 
load QuantifISIDeltaToneSubstage_all.mat


%% Concatenate
animals = unique(deltatone_res.name);

for sub=substages_ind
    for d=1:length(delays)
        dltone_delay.delay{d,sub} = delays(d);
        for m=1:length(animals) 
            %Basal records
            if delays(d)==0
                
                basal_deltas_isi1 = [];
                basal_deltas_isi2 = [];
                basal_down_isi1 = [];
                basal_down_isi2 = [];
                for p=1:length(basal_res.path)
                    if strcmpi(basal_res.name{p},animals(m))
                        basal_deltas_isi1 = [basal_deltas_isi1 ; basal_res.intv_deltas1{p,sub}];
                        basal_deltas_isi2 = [basal_deltas_isi2 ; basal_res.intv_deltas2{p,sub}];
                        basal_down_isi1 = [basal_down_isi1 ; basal_res.intv_down1{p,sub}];
                        basal_down_isi2 = [basal_down_isi2 ; basal_res.intv_down2{p,sub}];
                    end
                end
                
                deltas.medians_isi.basal1(d,sub,m) = median(basal_deltas_isi1)/10;
                deltas.medians_isi.basal2(d,sub,m) = median(basal_deltas_isi2)/10;
                downs.medians_isi.basal1(d,sub,m) = median(basal_down_isi1)/10;
                downs.medians_isi.basal2(d,sub,m) = median(basal_down_isi2)/10;
                
                deltas.modes_isi.basal1(d,sub,m) = mode(basal_deltas_isi1)/10;
                deltas.modes_isi.basal2(d,sub,m) = mode(basal_deltas_isi2)/10;
                downs.modes_isi.basal1(d,sub,m) = mode(basal_down_isi1)/10;
                downs.modes_isi.basal2(d,sub,m) = mode(basal_down_isi2)/10;
               

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
                    if deltatone_res.delay{p}==delays(d) && strcmpi(deltatone_res.name{p},animals(m))
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

                
                %median
                deltas.medians_isi.good1(d,sub,m) = median(dltone_gooddelta_isi1)/10;
                deltas.medians_isi.good2(d,sub,m) = median(dltone_gooddelta_isi2)/10;
                deltas.medians_isi.bad1(d,sub,m) = median(dltone_baddelta_isi1)/10;
                deltas.medians_isi.bad2(d,sub,m) = median(dltone_baddelta_isi2)/10;
                downs.medians_isi.good1(d,sub,m) = median(dltone_gooddown_isi1)/10;
                downs.medians_isi.good2(d,sub,m) = median(dltone_gooddown_isi2)/10;
                downs.medians_isi.bad1(d,sub,m) = median(dltone_baddown_isi1)/10;
                downs.medians_isi.bad2(d,sub,m) = median(dltone_baddown_isi2)/10;
                
                %mode
                deltas.modes_isi.good1(d,sub,m) = mode(dltone_gooddelta_isi1)/10;
                deltas.modes_isi.good2(d,sub,m) = mode(dltone_gooddelta_isi2)/10;
                deltas.modes_isi.bad1(d,sub,m) = mode(dltone_baddelta_isi1)/10;
                deltas.modes_isi.bad2(d,sub,m) = mode(dltone_baddelta_isi2)/10;
                downs.modes_isi.good1(d,sub,m) = mode(dltone_gooddown_isi1)/10;
                downs.modes_isi.good2(d,sub,m) = mode(dltone_gooddown_isi2)/10;
                downs.modes_isi.bad1(d,sub,m) = mode(dltone_baddown_isi1)/10;
                downs.modes_isi.bad2(d,sub,m) = mode(dltone_baddown_isi2)/10;
                
            end

        end
    end
end
clear sub d p m
clear basal_deltas_isi1 basal_deltas_isi2 basal_down_isi1 basal_down_isi2
clear dltone_gooddelta_isi1 dltone_gooddelta_isi2 dltone_baddelta_isi1 dltone_baddelta_isi2
clear dltone_gooddown_isi1 dltone_gooddown_isi2 dltone_baddown_isi1 dltone_baddown_isi2
clear deltatone_res basal_res


%% Order and plot
pos_delays = delays(delays>0);
figtypes = {'Median'}; % stats
NameSubstages = {'N2', 'N3'}; % NREM substages
substages_plot = 2:3;

%Delta
for conditions=pos_delays
    d=find(delays==conditions);
    figure, hold on
    for ft=1:length(figtypes)
        for s=1:length(substages_plot)
            sub=substages_plot(s);
            if ft==1 %median
                data = [...
                    squeeze(deltas.medians_isi.basal1(1,sub,:))...
                    squeeze(deltas.medians_isi.basal2(1,sub,:))...
                    squeeze(deltas.medians_isi.good1(d,sub,:))...
                    squeeze(deltas.medians_isi.good2(d,sub,:))...
                    squeeze(deltas.medians_isi.bad1(d,sub,:))...
                    squeeze(deltas.medians_isi.bad2(d,sub,:))];
            elseif ft==2 %mode
                data = [...
                    squeeze(deltas.modes_isi.basal1(1,sub,:))...
                    squeeze(deltas.modes_isi.basal2(1,sub,:))...
                    squeeze(deltas.modes_isi.good1(d,sub,:))...
                    squeeze(deltas.modes_isi.good2(d,sub,:))...
                    squeeze(deltas.modes_isi.bad1(d,sub,:))...
                    squeeze(deltas.modes_isi.bad2(d,sub,:))];
            end
            
            labels={'Basal n+1','Basal n+2','Success Tones n+1','Success Tones n+2','Failed Tones n+1','Failed Tones n+2'};
            bar_color={'k','k','b','b','r','r'};
%             bar_alpha = [1 0.5 1 0.5 1 0.5];
            
            column_test = {[1 3],[1 5], [3 5], [1 4], [1 6], [2 4], [2 6], [3 6], [4 6], [4 5]};
            subplot(1,length(substages_plot),3*(ft-1)+s), hold on,
                PlotErrorBarN_KJ(data,'newfig',0,'barcolors',bar_color,'ColumnsTests',column_test);

            title([NameSubstages{s}]), ylabel('ms'), hold on,
            set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), hold on,
        end
    end
    suplabel(['Delta ISI - ' num2str(conditions*1000) 'ms'],'t');
    
end




