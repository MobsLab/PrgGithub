%%analyse CPT stress protocole
% input dir
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirBasal_SD=RestrictPathForExperiment(DirBasal_SD,'nMice',[1107]);
DirMyBasal = PathForExperiments_DREADD_MC('OneInject_Nacl');


DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');
DirBasal=MergePathForExperiment(DirMyBasal,DirLabBasal);


DirSocialDefeat_stressCD1cage = PathForExperimentsSD_MC('SensoryExposureCD1cage');
DirSocialDefeat_stressC57cage = PathForExperimentsSD_MC('SensoryExposureC57cage');
DirSocialDefeat_sleep = PathForExperimentsSD_MC('SleepPostSD');

DirSocialDefeat_stressCD1cage.nMice{1}=1075;
DirSocialDefeat_stressCD1cage.nMice{2}=1107;
DirSocialDefeat_stressCD1cage.nMice{3}=1112;

%%list of mice with old PosMat (X, Y were inverted)
miceWithOldTsd = [1075,1107,1112]; %X and Y are inverted
miceWithDifferentPos = [1148,1149,1150]; %cages were placed differently, hence needs a rotation

%%
%%load behav data from sensory exposure in CD-1 cage
for i=1:length(DirSocialDefeat_stressCD1cage.path)
    cd(DirSocialDefeat_stressCD1cage.path{i}{1});
    MiceNum(i) = DirSocialDefeat_stressCD1cage.nMice{i}; %%get mice num from sleep dir (to be sure to have Ephy)
    
    %%load behav for experimental mice
    if exist('behavResources_Offline.mat') %%if tracking offline exists it's the good version
        behav_C57_stressCD1cage{i} = load('behavResources_Offline.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref', 'MouseTemp_InDegrees');
    else
        behav_C57_stressCD1cage{i} = load('behavResources.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref', 'MouseTemp_InDegrees');
    end
    %%load behav for the corresponding CD1 mouse
    if exist('behavResources_CD1.mat')
        behav_CD1_stressCD1cage{i} = load('behavResources_CD1.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref');
    elseif exist('behavResources_Offline_CD1.mat')
        behav_CD1_stressCD1cage{i} = load('behavResources_Offline_CD1.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref');
    else
    end
    
    %%rectify variables for old mice (because they are inverted for old recordings)
    if ismember(MiceNum(i), miceWithOldTsd)==1
        %%create intermediate variables
        behav_stressCD1cage_bis{i}.Xtsd = behav_C57_stressCD1cage{i}.Ytsd;
        behav_stressCD1cage_bis{i}.Ytsd = behav_C57_stressCD1cage{i}.Xtsd;
        behav_CD1mouse_bis{i}.Xtsd = behav_CD1_stressCD1cage{i}.Ytsd;
        behav_CD1mouse_bis{i}.Ytsd = behav_CD1_stressCD1cage{i}.Xtsd;
        %%rectify X and Y (because they are inverted for old recordings)
        behav_C57_stressCD1cage{i}.Xtsd = behav_stressCD1cage_bis{i}.Xtsd;
        behav_C57_stressCD1cage{i}.Ytsd = behav_stressCD1cage_bis{i}.Ytsd;
        behav_CD1_stressCD1cage{i}.Xtsd = behav_CD1mouse_bis{i}.Xtsd;
        behav_CD1_stressCD1cage{i}.Ytsd = behav_CD1mouse_bis{i}.Ytsd;
    else
    end
    
    %%define X and Y
    x_c57_stressCD1cage{i} = Data(behav_C57_stressCD1cage{i}.Xtsd);
    y_c57_stressCD1cage{i} = Data(behav_C57_stressCD1cage{i}.Ytsd);
    x_cd1_stressCD1cage{i} = Data(behav_CD1_stressCD1cage{i}.Xtsd);
    y_cd1_stressCD1cage{i} = Data(behav_CD1_stressCD1cage{i}.Ytsd);
    
        %%distance betweeen 2 mice
        dist_mice_stressCD1cage{i} = sqrt((x_cd1_stressCD1cage{i}-x_c57_stressCD1cage{i}).^2+(y_cd1_stressCD1cage{i}-y_c57_stressCD1cage{i}).^2);
        mean_dist_mice_stressCD1cage(i) = nanmean(dist_mice_stressCD1cage{i});
        dist_mice_allMice_stressCD1cage(i,:) = dist_mice_stressCD1cage{i}(1:9050);
%     
    %     TotDistTravelled(i) = sum(sqrt(diff(x_c57_stressCD1cage{i}).^2+diff(y_c57_stressCD1cage{i}).^2))./durtotal{i};
    TotDistTravelled_stressCD1cage(i) = nansum(sqrt(diff(x_c57_stressCD1cage{i}).^2+diff(y_c57_stressCD1cage{i}).^2));
    
    %%recalculate speed
    Numer_stressCD1cage{i} = sqrt(diff(x_c57_stressCD1cage{i}).^2+diff(y_c57_stressCD1cage{i}).^2);
    Denom_stressCD1cage{i} = diff(Range(behav_C57_stressCD1cage{i}.Xtsd,'s'));
    tps_stressCD1cage{i} = Range(behav_C57_stressCD1cage{i}.Xtsd);
    tps_stressCD1cage{i} = tps_stressCD1cage{i}(1:end-1);
    speed_tsd_stressCD1cage{i} = tsd(tps_stressCD1cage{i},Numer_stressCD1cage{i}./Denom_stressCD1cage{i});
    
    meanSpeed_stressCD1cage(i) = nanmean(Data(speed_tsd_stressCD1cage{i}));
   
        VecTimeDay_stressCD1cage{i} = GetTimeOfTheDay_MC(Range(behav_C57_stressCD1cage{i}.Xtsd));
        
        meanTemp_stressCD1cage(i) = nanmean(behav_C57_stressCD1cage{i}.MouseTemp_InDegrees);

end


%%
%%load behav data from sensory exposure in C57 cage
for k=1:length(DirSocialDefeat_stressC57cage.path)
    cd(DirSocialDefeat_stressC57cage.path{k}{1});
    MiceNum(k) = DirSocialDefeat_stressC57cage.nMice{k}; %%get mice num from sleep dir (to be sure to have Ephy)
    
    %%load behav for experimental mice
    if exist('behavResources_Offline.mat') %%if tracking offline exists it's the good version
        behav_C57_stressC57cage{k} = load('behavResources_Offline.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref', 'MouseTemp_InDegrees');
    else
        behav_C57_stressC57cage{k} = load('behavResources.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref', 'MouseTemp_InDegrees');
    end
    %%load behav for the corresponding CD1 mouse
    if exist('behavResources_CD1.mat')
        behav_CD1_stressC57cage{k} = load('behavResources_CD1.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref');
    elseif exist('behavResources_Offline_CD1.mat')
        behav_CD1_stressC57cage{k} = load('behavResources_Offline_CD1.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref');
    else
    end
    
    %%rectify variables for old mice (because they are inverted for old recordings)
    if ismember(MiceNum(k), miceWithOldTsd)==1
        %%create intermediate variables
        behav_stressC57cage_bis{k}.Xtsd = behav_C57_stressC57cage{k}.Ytsd;
        behav_stressC57cage_bis{k}.Ytsd = behav_C57_stressC57cage{k}.Xtsd;
        behav_CD1mouse_bis{k}.Xtsd = behav_CD1_stressC57cage{k}.Ytsd;
        behav_CD1mouse_bis{k}.Ytsd = behav_CD1_stressC57cage{k}.Xtsd;
        %%rectify X and Y (because they are inverted for old recordings)
        behav_C57_stressC57cage{k}.Xtsd = behav_stressC57cage_bis{k}.Xtsd;
        behav_C57_stressC57cage{k}.Ytsd = behav_stressC57cage_bis{k}.Ytsd;
        behav_CD1_stressC57cage{k}.Xtsd = behav_CD1mouse_bis{k}.Xtsd;
        behav_CD1_stressC57cage{k}.Ytsd = behav_CD1mouse_bis{k}.Ytsd;
    else
    end
    
    %%define X and Y
    x_c57_stressC57cage{k} = Data(behav_C57_stressC57cage{k}.Xtsd);
    y_c57_stressC57cage{k} = Data(behav_C57_stressC57cage{k}.Ytsd);
    x_cd1_stressC57cage{k} = Data(behav_CD1_stressC57cage{k}.Xtsd);
    y_cd1_stressC57cage{k} = Data(behav_CD1_stressC57cage{k}.Ytsd);
    
        %%distance betweeen 2 mice
        dist_mice_stressC57cage{k} = sqrt((x_cd1_stressC57cage{k}-x_c57_stressC57cage{k}).^2+(y_cd1_stressC57cage{k}-y_c57_stressC57cage{k}).^2);
        mean_dist_mice_stressC57cage(k) = nanmean(dist_mice_stressC57cage{k});
        dist_mice_allMice_stressC57cage(k,:) = dist_mice_stressC57cage{k}(1:9050);
    
    %     TotDistTravelled(i) = sum(sqrt(diff(x_c57_stressC57cage{i}).^2+diff(y_c57_stressC57cage{i}).^2))./durtotal{i};
    TotDistTravelled_stressC57cage(k) = nansum(sqrt(diff(x_c57_stressC57cage{k}).^2+diff(y_c57_stressC57cage{k}).^2));
    
    %%recalculate speed
    Numer_stressC57cage{k} = sqrt(diff(x_c57_stressC57cage{k}).^2+diff(y_c57_stressC57cage{k}).^2);
    Denom_stressC57cage{k} = diff(Range(behav_C57_stressC57cage{k}.Xtsd,'s'));
    tps_stressC57cage{k} = Range(behav_C57_stressC57cage{k}.Xtsd);
    tps_stressC57cage{k} = tps_stressC57cage{k}(1:end-1);
    speed_tsd_stressC57cage{k} = tsd(tps_stressC57cage{k},Numer_stressC57cage{k}./Denom_stressC57cage{k});
    
    meanSpeed_stressC57cage(k) = nanmean(Data(speed_tsd_stressC57cage{k}));
    
    VecTimeDay_stressC57cage{k} = GetTimeOfTheDay_MC(Range(behav_C57_stressC57cage{k}.Xtsd));
    
            meanTemp_stressC57cage(k) = nanmean(behav_C57_stressC57cage{k}.MouseTemp_InDegrees);

            
            
end

%%
for j=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{j}{1});
   
    
    a{j} = load('SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch');
    durtotal_basal{j} = max([max(End(a{j}.Wake)),max(End(a{j}.SWSEpoch))]);
    beg_epoch{j} = intervalSet(0,0.33*3600*1E4); %%first 20min to compare to the sensory exposure
    
    if exist('behavResources.mat')
        behav{j} = load('behavResources.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref');
    else
    end
    
    TotDistTravelled_basal(j) = sum(sqrt(diff(Data(Restrict(behav{j}.Xtsd,beg_epoch{j}))).^2+diff(Data(Restrict(behav{j}.Ytsd,beg_epoch{j}))).^2));

    %%recalculate speed
    Numer_basal{j} = sqrt(diff(Data(Restrict(behav{j}.Xtsd,beg_epoch{j}))).^2+diff(Data(Restrict(behav{j}.Ytsd,beg_epoch{j}))).^2);
    Denom_basal{j} = diff(Range(Restrict(behav{j}.Xtsd,beg_epoch{j}),'s'));
    tps_basal{j} = Range(Restrict(behav{j}.Xtsd,beg_epoch{j}));
    tps_basal{j} = tps_basal{j}(1:end-1);
    speed_tsd_basal{j} = tsd(tps_basal{j},Numer_basal{j}./Denom_basal{j});
    
    meanSpeed_basal(j) = nanmean(Data(speed_tsd_basal{j}));
   
end

%%
figure,PlotErrorBarN_KJ({TotDistTravelled_basal TotDistTravelled_stressCD1cage TotDistTravelled_stressC57cage},'newfig',0,'paired',0)
ylabel('Total distance (cm)')
xticks([1:3]); xticklabels({'Baseline','SensoryExpoCD1cage','SensoryExpoC57cage'}); xtickangle(45)
makepretty
figure,PlotErrorBarN_KJ({meanSpeed_basal meanSpeed_stressCD1cage meanSpeed_stressC57cage},'newfig',0,'paired',0)
ylabel('Speed (cm/s)')
xticks([1:3]); xticklabels({'Baseline','SensoryExpoCD1cage','SensoryExpoC57cage'}); xtickangle(45)
makepretty

%%
%%


figure,MakeBoxPlot_MC({TotDistTravelled_basal TotDistTravelled_stressCD1cage TotDistTravelled_stressC57cage},...
    {[0.8 0.8 0.8],[1 0 0],[1 0 0]},[1:3],{'BaselineSleep','SensoryExpoCD1cage','SensoryExpoC57cage'},1,0)
ylabel('Total distance (cm)')
xtickangle(45)
makepretty

%%Rank sum test
p = ranksum(TotDistTravelled_basal, TotDistTravelled_stressCD1cage);
if p<0.05
    sigstar_DB({[1,2]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(TotDistTravelled_basal, TotDistTravelled_stressC57cage);
if p<0.05
    sigstar_DB({[1,3]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(TotDistTravelled_stressCD1cage, TotDistTravelled_stressC57cage);
if p<0.05
    sigstar_DB({[2,3]},p,0,'LineWigth',16,'StarSize',24);
end



figure,
MakeBoxPlot_MC({meanSpeed_basal meanSpeed_stressCD1cage meanSpeed_stressC57cage},...
    {[0.8 0.8 0.8],[1 0 0],[1 0 0]},[1:3],{'BaselineSleep','SensoryExpoCD1cage','SensoryExpoC57cage'},1,0)
ylabel('Speed (cm/s)')
xtickangle(45)
makepretty

%%Rank sum test
p = ranksum(meanSpeed_basal, meanSpeed_stressCD1cage);
if p<0.05
    sigstar_DB({[1,2]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(meanSpeed_basal, meanSpeed_stressC57cage);
if p<0.05
    sigstar_DB({[1,3]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(meanSpeed_stressCD1cage, meanSpeed_stressC57cage);
if p<0.05
    sigstar_DB({[2,3]},p,0,'LineWigth',16,'StarSize',24);
end


%%

figure

for ii=1:length(DirSocialDefeat_stressCD1cage.path)
    dist_mice_stressCD1cage_mean(ii) = nanmean(dist_mice_stressCD1cage{ii});
    
    subplot(5,2,ii)
%     plot(dist_mice_stressCD1cage{ii}(1:9050))
    plot(dist_mice_stressCD1cage{ii},'linewidth',2)
    ylabel('Distance (cm)')
end

%%
figure

for kk=1:length(DirSocialDefeat_stressC57cage.path)
    dist_mice_stressC57cage_mean(kk) = nanmean(dist_mice_stressC57cage{kk});
    subplot(5,2,kk+3)
%     plot(dist_mice_stressC57cage{ii}(1:9050))
    plot(dist_mice_stressC57cage{kk},'linewidth',2)
        ylabel('Distance (cm)')

end