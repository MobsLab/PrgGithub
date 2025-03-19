%%StatInterAreaSubstages
% 20.10.2019 KJ
%
% Infos
%
% see
%    QuantifHomeostasisDownInterAreaPlot
%    



% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifHomeostasisDownInterArea.mat'))

animals = unique(local_res.name);
list_mouse = local_res.name;
%exclude
list_mouse{3} = 'NoName';
list_mouse{6} = 'NoName';


%% Quantif N1-N2-N3

for s=1:3
    perc_sub.intra{s} = [];
    perc_sub.area2{s} = [];
    perc_sub.area3{s} = [];
    
    for p=1:length(local_res.path)
        if strcmpi(local_res.date{p},'01042015')
            continue
        end
        %intra, 2 or 3 area
        nb_all   = local_res.all_deltas.substages{p}(s);
        nb_3area = local_res.inter_all.substages{p}(s);
        nb_intra = local_res.intra_pfc.substages{p}(s) + local_res.intra_pa.substages{p}(s) + local_res.intra_mo.substages{p}(s);        
        nb_2area = nb_all - (nb_3area + nb_intra);
        

        perc_sub.intra{s} = [perc_sub.intra{s} ; nb_intra/nb_all];
        perc_sub.area2{s} = [perc_sub.area2{s} ; nb_2area/nb_all];
        perc_sub.area3{s} = [perc_sub.area3{s} ; nb_3area/nb_all];
    end
end

%data to plot
datasub_intra = [perc_sub.intra{1} perc_sub.intra{2} perc_sub.intra{3}]*100;
datasub_2area = [perc_sub.area2{1} perc_sub.area2{2} perc_sub.area2{3}]*100;
datasub_3area = [perc_sub.area3{1} perc_sub.area3{2} perc_sub.area3{3}]*100;


%% Stat


%intra
[pval_intra12, h_intra12, stat_intra12] = signrank(perc_sub.intra{1}, perc_sub.intra{2});
[pval_intra13, h_intra13, stat_intra13] = signrank(perc_sub.intra{1}, perc_sub.intra{3});
[pval_intra23, h_intra23, stat_intra23] = signrank(perc_sub.intra{2}, perc_sub.intra{3});

%2area
[pval_2area12, h_2area12, stat_2area12] = signrank(perc_sub.area2{1}, perc_sub.area2{2});
[pval_2area13, h_2area13, stat_2area13] = signrank(perc_sub.area2{1}, perc_sub.area2{3});
[pval_2area23, h_2area23, stat_2area23] = signrank(perc_sub.area2{2}, perc_sub.area2{3});

%3area
[pval_3area12, h_3area12, stat_3area12] = signrank(perc_sub.area3{1}, perc_sub.area3{2});
[pval_3area13, h_3area13, stat_3area13] = signrank(perc_sub.area3{1}, perc_sub.area3{3});
[pval_3area23, h_3area23, stat_3area23] = signrank(perc_sub.area3{2}, perc_sub.area3{3});


