%%StatHomeostasisDownInterArea
% 20.10.2019 KJ
%
% Infos
%   script about homeostasis for real and fake delta
%
% see
%     QuantifHomeostasisDownInterArea
%    

% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifHomeostasisDownInterArea.mat'))

animals = unique(local_res.name);
list_mouse = local_res.name;
%exclude
list_mouse{3} = 'NoName';
list_mouse{6} = 'NoName';



%% quantif quantity

perc_intra.pfc = [];
perc_intra.pa  = [];
perc_intra.mo  = [];

perc_among.intra = [];
perc_among.area2 = [];
perc_among.area3 = [];

for p=1:length(local_res.path)
    if strcmpi(local_res.date{p},'01042015')
        continue
    end
    
    %intra
    perc_intra.pfc = [perc_intra.pfc ; local_res.intra_pfc.nb{p}/local_res.all_pfc.nb{p}];
    perc_intra.pa  = [perc_intra.pa ; local_res.intra_pa.nb{p}/local_res.all_pa.nb{p}];
    perc_intra.mo  = [perc_intra.mo ; local_res.intra_mo.nb{p}/local_res.all_mo.nb{p}];
    
    
    %intra, 2 or 3 area
    nb_all   = local_res.all_deltas.nb{p};
    nb_3area = local_res.inter_all.nb{p};
    nb_2area = local_res.pfc_mo.nb{p} + local_res.pfc_pa.nb{p} + local_res.mo_pa.nb{p}; 
    nb_intra = local_res.intra_pfc.nb{p} + local_res.intra_pa.nb{p} + local_res.intra_mo.nb{p};
    
    perc_among.intra = [perc_among.intra ; nb_intra/nb_all];
    perc_among.area2 = [perc_among.area2 ; nb_2area/nb_all];
    perc_among.area3 = [perc_among.area3 ; nb_3area/nb_all];
    
end

%percentage
perc_intra.pfc = perc_intra.pfc * 100;
perc_intra.pa  = perc_intra.pa * 100;
perc_intra.mo  = perc_intra.mo * 100;

perc_among.intra = perc_among.intra * 100 ;
perc_among.area2 = perc_among.area2 * 100;
perc_among.area3 = perc_among.area3 * 100;



%% Homeostasis quantif

InterAll.slope0  = []; InterAll.slope1  = []; InterAll.slope2  = []; InterAll.expB = [];
Inter2.slope0  = []; Inter2.slope1  = []; Inter2.slope2  = []; Inter2.expB = [];
Intra1.slope0 = []; Intra1.slope1 = []; Intra1.slope2 = []; Intra1.expB = [];

for p=1:length(local_res.path)
    %inter all - 3 area
    Hstat = local_res.inter_all.rescaled.Hstat{p};
    InterAll.slope0(p,1) = Hstat.p0(1);
    InterAll.slope1(p,1) = Hstat.p1(1);
    InterAll.slope2(p,1) = Hstat.p2(1);
    InterAll.expB(p,1)   = Hstat.exp_b;
    
    %2 area
    Hstat1 = local_res.pfc_pa.rescaled.Hstat{p};
    Hstat2 = local_res.pfc_mo.rescaled.Hstat{p};
    Hstat3 = local_res.mo_pa.rescaled.Hstat{p};
    
    Inter2.slope0(p,1) = mean([Hstat1.p0(1) Hstat2.p0(1) Hstat3.p0(1)]);
    Inter2.slope1(p,1) = mean([Hstat1.p1(1) Hstat2.p1(1) Hstat3.p1(1)]);
    Inter2.slope2(p,1) = mean([Hstat1.p2(1) Hstat2.p2(1) Hstat3.p2(1)]);
    Inter2.expB(p,1) = mean([Hstat1.exp_b Hstat2.exp_b Hstat3.exp_b]);
    
    %all intra
    Hstat1 = local_res.intra_pfc.rescaled.Hstat{p};
    Hstat2 = local_res.intra_pa.rescaled.Hstat{p};
    Hstat3 = local_res.intra_mo.rescaled.Hstat{p};
    
    Intra1.slope0(p,1) = mean([Hstat1.p0(1) Hstat2.p0(1) Hstat3.p0(1)]);
    Intra1.slope1(p,1) = mean([Hstat1.p1(1) Hstat2.p1(1) Hstat3.p1(1)]);
    Intra1.slope2(p,1) = mean([Hstat1.p2(1) Hstat2.p2(1) Hstat3.p2(1)]);
    Intra1.expB(p,1) = mean([Hstat1.exp_b Hstat2.exp_b Hstat3.exp_b]);

end

%animals average
for m=1:length(animals)
    idm = strcmpi(list_mouse,animals{m}); %list of record of animals m
    
    fn = fieldnames(InterAll);
    for a=1:numel(fn)
        datam = InterAll.(fn{a});
        average.InterAll.(fn{a})(m,1) = mean(datam(idm));
        
        datam = Inter2.(fn{a});
        average.Inter2.(fn{a})(m,1) = mean(datam(idm));
        
        datam = Intra1.(fn{a});
        average.Intra1.(fn{a})(m,1) = mean(datam(idm));
    end
end



%% Stat


%percentage of intra
[pval_intra12, h_intra12, stat_intra12] = signrank(perc_intra.pfc, perc_intra.pa);
[pval_intra13, h_intra13, stat_intra13] = signrank(perc_intra.pfc, perc_intra.mo);
[pval_intra23, h_intra23, stat_intra23] = signrank(perc_intra.pa, perc_intra.mo);

%involvement/among
[pval_among12, h_among12, stat_among12] = signrank(perc_among.intra, perc_among.area2);
[pval_among13, h_among13, stat_among13] = signrank(perc_among.intra, perc_among.area3);
[pval_among23, h_among23, stat_among23] = signrank(perc_among.area2, perc_among.area3);


%slope 1 fit
[pval_1fit_12, h_1fit_12, stat_1fit_12] = signrank(Intra1.slope0, Inter2.slope0);
[pval_1fit_13, h_1fit_13, stat_1fit_13] = signrank(Intra1.slope0, InterAll.slope0);
[pval_1fit_23, h_1fit_23, stat_1fit_23] = signrank(Inter2.slope0, InterAll.slope0);

%slope 2 fit first
[pval_2fit1_12, h_2fit1_12, stat_2fit1_12] = signrank(Intra1.slope1, Inter2.slope1);
[pval_2fit1_13, h_2fit1_13, stat_2fit1_13] = signrank(Intra1.slope1, InterAll.slope1);
[pval_2fit1_23, h_2fit1_23, stat_2fit1_23] = signrank(Inter2.slope1, InterAll.slope1);
%slope 2 fit end
[pval_2fit2_12, h_2fit2_12, stat_2fit2_12] = signrank(Intra1.slope2, Inter2.slope2);
[pval_2fit2_13, h_2fit2_13, stat_2fit2_13] = signrank(Intra1.slope2, InterAll.slope2);
[pval_2fit2_23, h_2fit2_23, stat_2fit2_23] = signrank(Inter2.slope2, InterAll.slope2);

%slope exp
[pval_exp_23, h_exp_23, stat_exp_23] = signrank(Inter2.expB, InterAll.expB);




