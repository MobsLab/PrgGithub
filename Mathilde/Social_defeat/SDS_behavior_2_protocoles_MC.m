%% input dir
Dir_SDS_classic_1stExpo_CD1cage_1 = PathForExperimentsSD_MC('SensoryExposureCD1cage');
Dir_SDS_classic_1stExpo_CD1cage_1 = RestrictPathForExperiment(Dir_SDS_classic_1stExpo_CD1cage_1, 'nMice', [1148 1149 1150 1217 1218 1219 1220]); %restrict to mice with Ephy
Dir_SDS_classic_1stExpo_CD1cage_2 = PathForExperimentsSD_MC('SensoryExposureCD1cage_inhibDREADD_retroCre_PFC_VLPO');
Dir_SDS_classic_1stExpo_CD1cage = MergePathForExperiment(Dir_SDS_classic_1stExpo_CD1cage_1, Dir_SDS_classic_1stExpo_CD1cage_2);

Dir_SDS_classic_2ndExpo_C57cage_1 = PathForExperimentsSD_MC('SensoryExposureC57cage');
Dir_SDS_classic_2ndExpo_C57cage_2 = PathForExperimentsSD_MC('SensoryExposureC57cage_inhibDREADD_retroCre_PFC_VLPO');
Dir_SDS_classic_2ndExpo_C57cage = MergePathForExperiment(Dir_SDS_classic_2ndExpo_C57cage_1, Dir_SDS_classic_2ndExpo_C57cage_2);


Dir_SDS_safer_1stExpo_CD1cage = PathForExperimentsSD_MC('SensoryExposureCD1cage_PART1');
Dir_SDS_safer_2ndExpo_CD1cage = PathForExperimentsSD_MC('SensoryExposureCD1cage_PART2');


%%

nb_attcks_classic = [5,7,5,1,4,8,5,0,6,8];
nb_attcks_safer = [2,8,4,5];

%% load data
%%First expo in CD1 cage - classic protocol
for i=1:length(Dir_SDS_classic_1stExpo_CD1cage.path)
    cd(Dir_SDS_classic_1stExpo_CD1cage.path{i}{1});
    
    behav_SDS_classic_1stExpo_CD1cage{i} = load('behavResources.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref','FreezeAccEpoch');
    
    TotDist_SDS_classic_1stExpo_CD1cage(i) = sum(sqrt(diff(Data(behav_SDS_classic_1stExpo_CD1cage{i}.Xtsd)).^2+diff(Data(behav_SDS_classic_1stExpo_CD1cage{i}.Ytsd)).^2));
    
    
    [dur_fz,durT_fz]=DurationEpoch(behav_SDS_classic_1stExpo_CD1cage{i}.FreezeAccEpoch);
    freezing_mean_duration_SDS_classic_1stExpo_CD1cage(i) = nanmean(dur_fz);
    num_fz_SDS_classic_1stExpo_CD1cage(i) = length(dur_fz);
    freezing_total_duration_SDS_classic_1stExpo_CD1cage(i) = durT_fz;
    perc_fz_SDS_classic_1stExpo_CD1cage(i) = (freezing_total_duration_SDS_classic_1stExpo_CD1cage(i)./1200)*100;
    

end


%%Second expo in C57 cage - classic protocol
for i=1:length(Dir_SDS_classic_2ndExpo_C57cage.path)
    cd(Dir_SDS_classic_2ndExpo_C57cage.path{i}{1});
    
    behav_SDS_classic_2ndExpo_C57cage{i} = load('behavResources.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref','FreezeAccEpoch');
    
    TotDist_SDS_classic_2ndExpo_C57cage(i) = sum(sqrt(diff(Data(behav_SDS_classic_2ndExpo_C57cage{i}.Xtsd)).^2+diff(Data(behav_SDS_classic_2ndExpo_C57cage{i}.Ytsd)).^2));
    
    [dur_fz,durT_fz]=DurationEpoch(behav_SDS_classic_2ndExpo_C57cage{i}.FreezeAccEpoch);
    freezing_mean_duration_SDS_classic_2ndExpo_C57cage(i) = nanmean(dur_fz);
    num_fz_SDS_classic_2ndExpo_C57cage(i) = length(dur_fz);
    freezing_total_duration_SDS_classic_2ndExpo_C57cage(i) = durT_fz;
    perc_fz_SDS_classic_2ndExpo_C57cage(i) = (freezing_total_duration_SDS_classic_2ndExpo_C57cage(i)./1200)*100;
    


end



%%First expo in CD1 cage - safer protocol
for i=1:length(Dir_SDS_safer_1stExpo_CD1cage.path)
    cd(Dir_SDS_safer_1stExpo_CD1cage.path{i}{1});
    
    behav_SDS_safer_1stExpo_CD1cage{i} = load('behavResources.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref','FreezeAccEpoch');
    
    TotDist_SDS_safer_1stExpo_CD1cage(i) = sum(sqrt(diff(Data(behav_SDS_safer_1stExpo_CD1cage{i}.Xtsd)).^2+diff(Data(behav_SDS_safer_1stExpo_CD1cage{i}.Ytsd)).^2));
    
    [dur_fz,durT_fz]=DurationEpoch(behav_SDS_safer_1stExpo_CD1cage{i}.FreezeAccEpoch);
    freezing_mean_duration_SDS_safer_1stExpo_CD1cage(i) = nanmean(dur_fz);
    num_fz_SDS_safer_1stExpo_CD1cage(i) = length(dur_fz);
    freezing_total_duration_SDS_safer_1stExpo_CD1cage(i) = durT_fz;
    perc_fz_SDS_safer_1stExpo_CD1cage(i) = (freezing_total_duration_SDS_safer_1stExpo_CD1cage(i)./1200)*100;
    

end


%%Second expo in CD1 cage - safer protocol
for i=1:length(Dir_SDS_safer_2ndExpo_CD1cage.path)
    cd(Dir_SDS_safer_2ndExpo_CD1cage.path{i}{1});
    
    behav_SDS_safer_2ndExpo_CD1cage{i} = load('behavResources.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref','FreezeAccEpoch');
    
    TotDist_SDS_safer_2ndExpo_CD1cage(i) = sum(sqrt(diff(Data(behav_SDS_safer_2ndExpo_CD1cage{i}.Xtsd)).^2+diff(Data(behav_SDS_safer_2ndExpo_CD1cage{i}.Ytsd)).^2));


    [dur_fz,durT_fz]=DurationEpoch(behav_SDS_safer_2ndExpo_CD1cage{i}.FreezeAccEpoch);
    freezing_mean_duration_SDS_safer_2ndExpo_CD1cage(i) = nanmean(dur_fz);
    num_fz_SDS_safer_2ndExpo_CD1cage(i) = length(dur_fz);
    freezing_total_duration_SDS_safer_2ndExpo_CD1cage(i) = durT_fz;
    perc_fz_SDS_safer_2ndExpo_CD1cage(i) = (freezing_total_duration_SDS_safer_2ndExpo_CD1cage(i)./1200)*100;
    


end



%% figures
ispaired=0;

col_SD = [.91 .53 .17];
col_SDsafe = [.31 .38 .61];


%% number of attacks
figure
PlotErrorBarN_KJ({nb_attcks_classic, nb_attcks_safer},...
    'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2],'barcolors',{col_SD,col_SDsafe});

[p_attacks,h] = ranksum(nb_attcks_classic, nb_attcks_safer);
if p_attacks<0.05; sigstar_DB({[1 2]},p_attacks,0,'LineWigth',16,'StarSize',24);end
makepretty


%% Total distance travellled
figure
PlotErrorBarN_KJ({TotDist_SDS_classic_1stExpo_CD1cage, TotDist_SDS_safer_1stExpo_CD1cage, TotDist_SDS_classic_2ndExpo_C57cage, TotDist_SDS_safer_2ndExpo_CD1cage},...
    'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_SD,col_SDsafe,col_SD,col_SDsafe});

[p_1stExpo,h] = ranksum(TotDist_SDS_classic_1stExpo_CD1cage, TotDist_SDS_safer_1stExpo_CD1cage);
if p_1stExpo<0.05; sigstar_DB({[1 2]},p_1stExpo,0,'LineWigth',16,'StarSize',24);end

[p_2ndExpo,h] = ranksum(TotDist_SDS_classic_2ndExpo_C57cage, TotDist_SDS_safer_2ndExpo_CD1cage);
if p_2ndExpo<0.05; sigstar_DB({[4:5]},p_2ndExpo,0,'LineWigth',16,'StarSize',24);end


%% mean duration freezing bouts
figure
PlotErrorBarN_KJ({freezing_mean_duration_SDS_classic_1stExpo_CD1cage, freezing_mean_duration_SDS_safer_1stExpo_CD1cage, freezing_mean_duration_SDS_classic_2ndExpo_C57cage, freezing_mean_duration_SDS_safer_2ndExpo_CD1cage},...
    'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_SD,col_SDsafe,col_SD,col_SDsafe});

[p_1stExpo,h] = ranksum(freezing_mean_duration_SDS_classic_1stExpo_CD1cage, freezing_mean_duration_SDS_safer_1stExpo_CD1cage);
if p_1stExpo<0.05; sigstar_DB({[1 2]},p_1stExpo,0,'LineWigth',16,'StarSize',24);end

[p_2ndExpo,h] = ranksum(freezing_mean_duration_SDS_classic_2ndExpo_C57cage, freezing_mean_duration_SDS_safer_2ndExpo_CD1cage);
if p_2ndExpo<0.05; sigstar_DB({[4:5]},p_2ndExpo,0,'LineWigth',16,'StarSize',24);end


%% number freezing bouts

figure
PlotErrorBarN_KJ({ num_fz_SDS_classic_1stExpo_CD1cage,  num_fz_SDS_safer_1stExpo_CD1cage,  num_fz_SDS_classic_2ndExpo_C57cage,  num_fz_SDS_safer_2ndExpo_CD1cage},...
    'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_SD,col_SDsafe,col_SD,col_SDsafe});

[p_1stExpo,h] = ranksum( num_fz_SDS_classic_1stExpo_CD1cage,  num_fz_SDS_safer_1stExpo_CD1cage);
if p_1stExpo<0.05; sigstar_DB({[1 2]},p_1stExpo,0,'LineWigth',16,'StarSize',24);end

[p_2ndExpo,h] = ranksum( num_fz_SDS_classic_2ndExpo_C57cage,  num_fz_SDS_safer_2ndExpo_CD1cage);
if p_2ndExpo<0.05; sigstar_DB({[4:5]},p_2ndExpo,0,'LineWigth',16,'StarSize',24);end



%%  toal duration freezing
figure
PlotErrorBarN_KJ({freezing_total_duration_SDS_classic_1stExpo_CD1cage, freezing_total_duration_SDS_safer_1stExpo_CD1cage, freezing_total_duration_SDS_classic_2ndExpo_C57cage, freezing_total_duration_SDS_safer_2ndExpo_CD1cage},...
    'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_SD,col_SDsafe,col_SD,col_SDsafe});

[p_1stExpo,h] = ranksum(freezing_total_duration_SDS_classic_1stExpo_CD1cage, freezing_total_duration_SDS_safer_1stExpo_CD1cage);
if p_1stExpo<0.05; sigstar_DB({[1 2]},p_1stExpo,0,'LineWigth',16,'StarSize',24);end

[p_2ndExpo,h] = ranksum(freezing_total_duration_SDS_classic_2ndExpo_C57cage, freezing_total_duration_SDS_safer_2ndExpo_CD1cage);
if p_2ndExpo<0.05; sigstar_DB({[4:5]},p_2ndExpo,0,'LineWigth',16,'StarSize',24);end



%% pourcentage freezing
figure
PlotErrorBarN_KJ({perc_fz_SDS_classic_1stExpo_CD1cage, perc_fz_SDS_safer_1stExpo_CD1cage, perc_fz_SDS_classic_2ndExpo_C57cage, perc_fz_SDS_safer_2ndExpo_CD1cage},...
    'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_SD,col_SDsafe,col_SD,col_SDsafe});

[p_1stExpo,h] = ranksum(perc_fz_SDS_classic_1stExpo_CD1cage, perc_fz_SDS_safer_1stExpo_CD1cage);
if p_1stExpo<0.05; sigstar_DB({[1 2]},p_1stExpo,0,'LineWigth',16,'StarSize',24);end

[p_2ndExpo,h] = ranksum(perc_fz_SDS_classic_2ndExpo_C57cage, perc_fz_SDS_safer_2ndExpo_CD1cage);
if p_2ndExpo<0.05; sigstar_DB({[4:5]},p_2ndExpo,0,'LineWigth',16,'StarSize',24);end

