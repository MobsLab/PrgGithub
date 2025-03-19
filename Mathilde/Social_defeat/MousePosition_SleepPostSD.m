%% input dir
% DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
% DirBasal_SD = PathForExperimentsSD_MC('Baseline');
% DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);
% DirMyBasal=RestrictPathForExperiment(DirMyBasal,'nMice',[ 1075 1109 1107 1112]);

DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD');
% DirSocialDefeat=RestrictPathForExperiment(DirSocialDefeat,'nMice',[1148 1149 1150]);

%%list of mice with old PosMat (X, Y were inverted)
miceWithOldTsd = [1075,1107,1112]; %X and Y are inverted

%%
% for i=1:length(DirMyBasal.path)
%     cd(DirMyBasal.path{i}{1});
%     c{i} = load('behavResources.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref');
%     d{i} = load( 'SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch');
%     durtotal_basal{i} = max([max(End(d{i}.Wake)),max(End(d{i}.SWSEpoch))]);
%     %3h post injection
%     epoch_3hPostSD_basal{i} = intervalSet(0*3600*1E4,3*3600*1E4);
%     %3h after first sleep episode
%     [tpsFirstREM, tpsFirstSWS]= FindLatencySleep_MC(d{i}.Wake,d{i}.SWSEpoch,d{i}.REMEpoch,5,200); tpsFirstSleep_basal{i}=tpsFirstSWS;
%     epoch_3hFirstSleep_basal{i}=intervalSet(tpsFirstSleep_basal{i}*1e4,tpsFirstSleep_basal{i}*1e4+2*3600*1E4);
% end

%%list of mice with concat data
NewMiceWithConcatData = [1217,1218,1219,1220];

for k=1:length(DirSocialDefeat.path)
    cd(DirSocialDefeat.path{k}{1});
    MiceNum(k) = DirSocialDefeat.nMice{k};
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%mice with concatenated data (loading is a bit different)
    if ismember(MiceNum(k), NewMiceWithConcatData)==1
        b{k} = load( 'SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch');
        bb{k} = load('behavResources.mat', 'SessionEpoch');
        behav_sleep{k} = load('behavResources-03.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref');
        behav_stressCD1{k} = load('behavResources-01.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref');
        behav_stressC57{k} = load('behavResources-02.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref');
        %%restrict epoch to the sleep post SD session (not exposure to stress)
        b{k}.Wake = and(b{k}.Wake,bb{k}.SessionEpoch.SleepPostSD);
        b{k}.SWSEpoch = and(b{k}.SWSEpoch,bb{k}.SessionEpoch.SleepPostSD);
        b{k}.REMEpoch = and(b{k}.REMEpoch,bb{k}.SessionEpoch.SleepPostSD);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    else
        b{k} = load( 'SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch');
        behav_sleep{k} = load('behavResources.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref');
    end
    
    %%define specific periods 
    durtotal_SD{k} = max([max(End(b{k}.Wake)),max(End(b{k}.SWSEpoch))]);
    %3h post injection
    epoch_3hPostSD_SD{k} = intervalSet(0*3600*1E4,3*3600*1E4);
    %3h after first long sleep episode
    [tpsFirstREM, tpsFirstSWS]= FindLatencySleep_MC(b{k}.Wake,b{k}.SWSEpoch,b{k}.REMEpoch,5,70); tpsFirstSleep_SD{k}=tpsFirstSWS;
    %     epoch_3hPostFisrtSleep_SD{k}=intervalSet(tpsFirstSleep_SD{k}*1e4,tpsFirstSleep_SD{k}*1e4+3*3600*1E4);
    epoch_3hPostFisrtSleep_SD{k}=intervalSet(tpsFirstSleep_SD{k}*1e4,durtotal_SD{k});   
end


%% SD sessions
%% plot trajectories for the first 3h post SD

figure,
for imouse=1:length(DirSocialDefeat.path)
    MiceNum(k) = DirSocialDefeat.nMice{imouse};
    
    %%mice with old tsd (and old protocole)
    if ismember(MiceNum(k), miceWithOldTsd)==1
        %%get mask coordinates to set the x and y limits
        mask_conv{imouse} = im2double(behav_sleep{imouse}.mask);
        y1{imouse} = find(mean(mask_conv{imouse}));
        x1{imouse} = find(mean(mask_conv{imouse}'));
        %%coordinates to draw the cage
        cageMap(imouse) = {[min(y1{imouse})-2, min(x1{imouse})-2; max(y1{imouse})+2, min(x1{imouse})-2;...
            max(y1{imouse})+2, max(x1{imouse})+2; min(y1{imouse})-2, max(x1{imouse})+2; min(y1{imouse})-2, min(x1{imouse})-2]};

        subplot(1,10,imouse),
        %%all sleep session
        %plot(Data(c{imouse}.Ytsd)*c{imouse}.Ratio_IMAonREAL,Data(c{imouse}.Xtsd)*c{imouse}.Ratio_IMAonREAL,'k')
%         plot(Data(c{imouse}.Ytsd),Data(c{imouse}.Xtsd),'k')
        %%restrict to 3h post SD
        plot(Data(Restrict(behav_sleep{imouse}.Ytsd,epoch_3hPostFisrtSleep_SD{imouse}))*behav_sleep{imouse}.Ratio_IMAonREAL,...
           Data(Restrict(behav_sleep{imouse}.Xtsd,epoch_3hPostFisrtSleep_SD{imouse}))*behav_sleep{imouse}.Ratio_IMAonREAL,'k'),hold on
       plot(cageMap{imouse}(:,1),cageMap{imouse}(:,2),'k','LineWidth',3), hold on
        xlim([min(y1{imouse})-2, max(y1{imouse})+2])
        ylim([min(x1{imouse})-2, max(x1{imouse})+2])

        %imagesc(c{imouse}.ref), hold on
        set(gca,'visible','off')
        
        
    %%mice with good tsd (and concat data)   
    elseif ismember(MiceNum(k), NewMiceWithConcatData)==1
        %%get mask coordinates to set the x and y limits
        mask_conv{imouse} = im2double(behav_sleep{imouse}.mask);
        y1{imouse} = find(mean(mask_conv{imouse}));
        x1{imouse} = find(mean(mask_conv{imouse}'));
        %%coordinates to draw the cage
        cageMap(imouse) = {[min(x1{imouse})-2, min(y1{imouse})-2; max(x1{imouse})+2, min(y1{imouse})-2;...
            max(x1{imouse})+2, max(y1{imouse})+2; min(x1{imouse})-2, max(y1{imouse})+2; min(x1{imouse})-2, min(y1{imouse})-2]};

        subplot(1,10,imouse),
        %%all sleep session
        %plot(Data(c{imouse}.Xtsd)*c{imouse}.Ratio_IMAonREAL,Data(c{imouse}.Ytsd)*c{imouse}.Ratio_IMAonREAL,'k')
        %         plot(Data(c{imouse}.Xtsd),Data(c{imouse}.Ytsd),'k')
        %%restrict to 3h post SD
        plot(Data(Restrict(behav_sleep{imouse}.Xtsd,epoch_3hPostFisrtSleep_SD{imouse}))*behav_sleep{imouse}.Ratio_IMAonREAL,...
            Data(Restrict(behav_sleep{imouse}.Ytsd,epoch_3hPostFisrtSleep_SD{imouse}))*behav_sleep{imouse}.Ratio_IMAonREAL,'k'),hold on
        plot(cageMap{imouse}(:,1),cageMap{imouse}(:,2),'k','LineWidth',3), hold on
        ylim([min(y1{imouse})-2, max(y1{imouse})+2])
        xlim([min(x1{imouse})-2, max(x1{imouse})+2])
        
%                 imagesc(c{imouse}.ref),hold on
                set(gca,'visible','off')


        
    %%mice with good tsd (different cage position -> need rotation)    
    else
        subplot(1,10,imouse),
        %%get mask coordinates to set the x and y limits
        mask_conv{imouse} = im2double(behav_sleep{imouse}.mask);
        y1{imouse} = find(mean(mask_conv{imouse}'));
        x1{imouse} = find(mean(mask_conv{imouse}));
        %%coordinates to draw the cage
        cageMap(imouse) = {[min(x1{imouse})-2, min(y1{imouse})-2; max(x1{imouse})+2, min(y1{imouse})-2;...
            max(x1{imouse})+2, max(y1{imouse})+2; min(x1{imouse})-2, max(y1{imouse})+2; min(x1{imouse})-2, min(y1{imouse})-2]};
        
        %%all sleep session
        %plot(Data(c{imouse}.Xtsd)*c{imouse}.Ratio_IMAonREAL,Data(c{imouse}.Ytsd)*c{imouse}.Ratio_IMAonREAL,'k')
%         plot(Data(c{imouse}.Xtsd),Data(c{imouse}.Ytsd),'k')
        %%restrict to 3h post SD
        plot(Data(Restrict(behav_sleep{imouse}.Xtsd,epoch_3hPostFisrtSleep_SD{imouse}))*behav_sleep{imouse}.Ratio_IMAonREAL,...
            Data(Restrict(behav_sleep{imouse}.Ytsd,epoch_3hPostFisrtSleep_SD{imouse}))*behav_sleep{imouse}.Ratio_IMAonREAL,'k'), hold on
        plot(cageMap{imouse}(:,1),cageMap{imouse}(:,2),'k','LineWidth',3), hold on
        ylim([min(y1{imouse})-2, max(y1{imouse})+2])
        xlim([min(x1{imouse})-2, max(x1{imouse})+2])
        camroll(90)
        
%          imagesc(c{imouse}.ref),hold on
        set(gca,'visible','off')
    end
end
