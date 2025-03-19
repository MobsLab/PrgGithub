%%analyse CPT sleep session
% input dir

DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);

DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirBasal_SD=RestrictPathForExperiment(DirBasal_SD,'nMice',[1107]);


DirMyBasal = PathForExperiments_DREADD_MC('OneInject_Nacl');




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
for i=1:length(DirSocialDefeat_sleep.path)
    cd(DirSocialDefeat_sleep.path{i}{1});
    MiceNum(i) = DirSocialDefeat_sleep.nMice{i}; %%get mice num from sleep dir (to be sure to have Ephy)
    
          b{i} = load('SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch');
    durtotal{i} = max([max(End(b{i}.Wake)),max(End(b{i}.SWSEpoch))]);
    
    
    %%load behav for experimental mice
    if exist('behavResources_Offline.mat') %%if tracking offline exists it's the good version
        behav_C57_stressCD1cage{i} = load('behavResources_Offline.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref');
    else
        behav_C57_stressCD1cage{i} = load('behavResources.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref');
    end
%     %%load behav for the corresponding CD1 mouse
%     if exist('behavResources_CD1.mat')
%         behav_CD1_stressCD1cage{i} = load('behavResources_CD1.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref');
%     elseif exist('behavResources_Offline_CD1.mat')
%         behav_CD1_stressCD1cage{i} = load('behavResources_Offline_CD1.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref');
%     else
%     end
    
    %%rectify variables for old mice (because they are inverted for old recordings)
    if ismember(MiceNum(i), miceWithOldTsd)==1
        %%create intermediate variables
        behav_stressCD1cage_bis{i}.Xtsd = behav_C57_stressCD1cage{i}.Ytsd;
        behav_stressCD1cage_bis{i}.Ytsd = behav_C57_stressCD1cage{i}.Xtsd;
%         behav_CD1mouse_bis{i}.Xtsd = behav_CD1_stressCD1cage{i}.Ytsd;
%         behav_CD1mouse_bis{i}.Ytsd = behav_CD1_stressCD1cage{i}.Xtsd;
        %%rectify X and Y (because they are inverted for old recordings)
        behav_C57_stressCD1cage{i}.Xtsd = behav_stressCD1cage_bis{i}.Xtsd;
        behav_C57_stressCD1cage{i}.Ytsd = behav_stressCD1cage_bis{i}.Ytsd;
%         behav_CD1_stressCD1cage{i}.Xtsd = behav_CD1mouse_bis{i}.Xtsd;
%         behav_CD1_stressCD1cage{i}.Ytsd = behav_CD1mouse_bis{i}.Ytsd;
    else
    end
    
    %%define X and Y
    x_c57_stressCD1cage{i} = Data(behav_C57_stressCD1cage{i}.Xtsd);
    y_c57_stressCD1cage{i} = Data(behav_C57_stressCD1cage{i}.Ytsd);
%     x_cd1_stressCD1cage{i} = Data(behav_CD1_stressCD1cage{i}.Xtsd);
%     y_cd1_stressCD1cage{i} = Data(behav_CD1_stressCD1cage{i}.Ytsd);
    
    
%     %%distance betweeen 2 mice
%     dist_mice{i} = sqrt((x_cd1_stressCD1cage{i}-x_c57_stressCD1cage{i}).^2+(y_cd1_stressCD1cage{i}-y_c57_stressCD1cage{i}).^2);
%     mean_dist_mice(i) = nanmean(dist_mice{i});
%     dist_mice_allMice(i,:) = dist_mice{i}(1:9050);
    
    
    
    
%     TotDistTravelled(i) = sum(sqrt(diff(x_c57_stressCD1cage{i}).^2+diff(y_c57_stressCD1cage{i}).^2))./durtotal{i};
    TotDistTravelled(i) = sum(sqrt(diff(x_c57_stressCD1cage{i}).^2+diff(y_c57_stressCD1cage{i}).^2));

    
    
end


%%

TotDist(i) = sum(sqrt(diff(Data(Xtsd)).^2+diff(Data(Ytsd)).^2));


figure

for i=1:length(DirSocialDefeat_stressCD1cage.path)
    subplot(length(DirSocialDefeat_stressCD1cage.path),1,i)
    plot(dist_mice{i}(1:9050))
end


figure,plot(nanmean(dist_mice_allMice))












%%
for j=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{j}{1});
    %     MiceNum(j) = DirMyBasal.nMice{j}; %%get mice num from sleep dir (to be sure to have Ephy)
    
        a{j} = load('SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch');
    durtotal_basal{j} = max([max(End(a{j}.Wake)),max(End(a{j}.SWSEpoch))]);
    beg_epoch{j} = intervalSet(0,0.3*3600*1E4);
    
    if exist('behavResources.mat')
        behav{j} = load('behavResources.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref');
        TotDistTravelled_basal2(j) = sum(sqrt(diff(Data(behav{j}.Xtsd)).^2+diff(Data(behav{j}.Ytsd)).^2))./durtotal_basal{j};

            TotDistTravelled_basal(j) = sum(sqrt(diff(Data(Restrict(behav{j}.Xtsd,beg_epoch{j}))).^2+diff(Data(Restrict(behav{j}.Ytsd,beg_epoch{j}))).^2));

    else
    end
end