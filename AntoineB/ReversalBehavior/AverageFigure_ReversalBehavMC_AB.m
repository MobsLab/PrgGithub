%% Parameters
% input dir

% Old architecture (nas5) (outdated)
% DirPre = PathForExperimentsReversalBehav_MC_AB('TestPre');
% DirPostPAG = PathForExperimentsReversalBehav_MC_AB('TestPostPAG');
% DirPostMFB = PathForExperimentsReversalBehav_MC_AB('TestPostMFB');
% DirCondPAG = PathForExperimentsReversalBehav_MC_AB('CondPAG');
% DirCondMFB = PathForExperimentsReversalBehav_MC_AB('CondMFB');
% 
% DirPreSham = RestrictPathForExperiment(DirPre,'Group','Sham');
% DirPostPAGSham = RestrictPathForExperiment(DirPostPAG,'Group','Sham');
% DirPostMFBSham = RestrictPathForExperiment(DirPostMFB,'Group','Sham');
% DirCondPAGSham = RestrictPathForExperiment(DirCondPAG,'Group','Sham');
% DirCondMFBSham = RestrictPathForExperiment(DirCondMFB,'Group','Sham');
% 
% DirPreExp = RestrictPathForExperiment(DirPre,'Group','Exp');
% DirPostPAGExp = RestrictPathForExperiment(DirPostPAG,'Group','Exp');
% DirPostMFBExp = RestrictPathForExperiment(DirPostMFB,'Group','Exp');
% DirCondPAGExp = RestrictPathForExperiment(DirCondPAG,'Group','Exp');
% DirCondMFBExp = RestrictPathForExperiment(DirCondMFB,'Group','Exp');

% New architecture (nas6)
DirPre = PathForExperimentsReversalBehavior_AB('TestPre');
DirPostPAG = PathForExperimentsReversalBehavior_AB('TestPostPAG');
DirPostMFB = PathForExperimentsReversalBehavior_AB('TestPostMFB');
DirCondPAG = PathForExperimentsReversalBehavior_AB('CondPAG');
DirCondMFB = PathForExperimentsReversalBehavior_AB('CondMFB');

DirPreSham = RestrictPathForExperiment(DirPre,'Group','Sham');
DirPostPAGSham = RestrictPathForExperiment(DirPostPAG,'Group','Sham');
DirPostMFBSham = RestrictPathForExperiment(DirPostMFB,'Group','Sham');
DirCondPAGSham = RestrictPathForExperiment(DirCondPAG,'Group','Sham');
DirCondMFBSham = RestrictPathForExperiment(DirCondMFB,'Group','Sham');

DirPreExp = RestrictPathForExperiment(DirPre,'Group','Exp');
DirPostPAGExp = RestrictPathForExperiment(DirPostPAG,'Group','Exp');
DirPostMFBExp = RestrictPathForExperiment(DirPostMFB,'Group','Exp');
DirCondPAGExp = RestrictPathForExperiment(DirCondPAG,'Group','Exp');
DirCondMFBExp = RestrictPathForExperiment(DirCondMFB,'Group','Exp');

ntest = 4;
ncond = 3;

% zones : 1 : StimZone, 2 : NoStimZone, 3 : Centre, 4 : CentreStim, 5 : CentreNoStim
% 6 : CornerStim, 7 : CornerNoStim
zone = 1;

% Parameters for plotting trajectories
time_beg = 5; % in s
maze = [0 0; 0 1; 1 1; 1 0; 0.63 0; 0.63 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZone = [0 0; 0 0.43; 0.35 0.43; 0.35 0; 0 0]; 

% colors
% cmap = get(gcf,'Colormap');
% clrs = cmap(1:4:end,:);
clrs = {[0 0.2 0.6], [1 0 0], [0.2 0.6 0], [0.4 0 0.6], [1 0.4 0], [0.6 0.4 0.2]};
%% Get the data
% from pre- and post- tests (x4) of sham mice
a=[];
for j = 1:length(DirPreSham.path)
    for i = 1:length(DirPreSham.path{j})
        % Pre tests
        cd(DirPreSham.path{j}{i});
        if isfile('cleanBehavResources.mat') == 1 % because CleanBlablablaAligned variables are not always in the same BehavResources
            a{j} = load('cleanBehavResources','Occup','ZoneIndices', 'PosMat', 'Vtsd', 'CleanAlignedXtsd', 'CleanAlignedYtsd');
        else
            a{j} = load('behavResources','Occup','ZoneIndices', 'PosMat', 'Vtsd', 'CleanAlignedXtsd', 'CleanAlignedYtsd');
        end
        Pre_Occup_Sham{j}{i} = a{j}.Occup(:,[1:5 8:end]); % get rid of 'inside' and 'outside' zones (that are in position 6 & 7)
        Pre_ZoneIndices_Sham{j}{i} = a{j}.ZoneIndices;
        Pre_PosMat_Sham{j}{i} = a{j}.PosMat;
        Pre_Vtsd_Sham{j}{i} = a{j}.Vtsd;
        Pre_Xtsd_Sham{j}{i} = a{j}.CleanAlignedXtsd;

        Pre_Ytsd_Sham{j}{i} = a{j}.CleanAlignedYtsd;
        % Post tests PAG
        cd(DirPostPAGSham.path{j}{i});
        if isfile('cleanBehavResources.mat') == 1
            b{j} = load('cleanBehavResources.mat','Occup','ZoneIndices', 'PosMat', 'Vtsd', 'CleanAlignedXtsd', 'CleanAlignedYtsd');
        else
            b{j} = load('behavResources.mat','Occup','ZoneIndices', 'PosMat', 'Vtsd', 'CleanAlignedXtsd', 'CleanAlignedYtsd');
        end
        PostPAG_Occup_Sham{j}{i} = b{j}.Occup(:,[1:5 8:end]);
        PostPAG_ZoneIndices_Sham{j}{i} = b{j}.ZoneIndices;
        PostPAG_PosMat_Sham{j}{i} = b{j}.PosMat;
        PostPAG_Vtsd_Sham{j}{i} = b{j}.Vtsd;
        PostPAG_Xtsd_Sham{j}{i} = b{j}.CleanAlignedXtsd;
        PostPAG_Ytsd_Sham{j}{i} = b{j}.CleanAlignedYtsd;
        % Post tests MFB
        cd(DirPostMFBSham.path{j}{i});
        if isfile('cleanBehavResources.mat') == 1
            c{j} = load('cleanBehavResources.mat','Occup','ZoneIndices', 'PosMat', 'Vtsd', 'CleanAlignedXtsd', 'CleanAlignedYtsd');
        else
            c{j} = load('behavResources.mat','Occup','ZoneIndices', 'PosMat', 'Vtsd', 'CleanAlignedXtsd', 'CleanAlignedYtsd');
        end
        PostMFB_Occup_Sham{j}{i} = c{j}.Occup(:,[1:5 8:end]);
        PostMFB_ZoneIndices_Sham{j}{i} = c{j}.ZoneIndices;
        PostMFB_PosMatSham{j}{i} = c{j}.PosMat;
        PostMFB_Vtsd_Sham{j}{i} = c{j}.Vtsd;
        PostMFB_Xtsd_Sham{j}{i} = c{j}.CleanAlignedXtsd;
        PostMFB_Ytsd_Sham{j}{i} = c{j}.CleanAlignedYtsd;
        
        %% average occupancy
        Pre_Occup_Sham_mean(j,:,:) = nanmean(Pre_Occup_Sham{j}{i},1)*100;
        Pre_Occup_Sham_std(j,:,:) = std(Pre_Occup_Sham{j}{i},1)*100;
        PostPAG_Occup_Sham_mean(j,:,:) = nanmean(PostPAG_Occup_Sham{j}{i},1)*100;
        PostPAG_Occup_Sham_std(j,:,:) = std(PostPAG_Occup_Sham{j}{i},1)*100;
        PostMFB_Occup_Sham_mean(j,:,:) = nanmean(PostMFB_Occup_Sham{j}{i},1)*100;
        PostMFB_Occup_Sham_std(j,:,:) = std(PostMFB_Occup_Sham{j}{i},1)*100;

        %% time to first enter shock zone
        % pre test
        if isempty(Pre_ZoneIndices_Sham{j}{i}{zone})
            Pre_FirstTime_Sham{j}{i} = 120;
        else
            Pre_FirstZoneIndices_Sham{j}(i) = Pre_ZoneIndices_Sham{j}{i}{zone}(1);
            Pre_FirstTime_Sham{j}{i} = Pre_PosMat_Sham{j}{i}(Pre_FirstZoneIndices_Sham{j}(i),1);
        end
        % post PAG test
        if isempty(PostPAG_ZoneIndices_Sham{j}{i}{zone})
            PostPAG_FirstTime_Sham{j}{i} = 120;
        else
            PostPAG_FirstZoneIndices_Sham{j}(i) = PostPAG_ZoneIndices_Sham{j}{i}{zone}(1);
            PostPAG_FirstTime_Sham{j}{i} = PostPAG_PosMat_Sham{j}{i}(PostPAG_FirstZoneIndices_Sham{j}(i),1);
        end
        % post MFB test
        if isempty(PostMFB_ZoneIndices_Sham{j}{i}{zone})
            PostMFB_FirstTime_Sham{j}{i} = 120;
        else
            PostMFB_FirstZoneIndices_Sham{j}(i) = PostMFB_ZoneIndices_Sham{j}{i}{zone}(1);
            PostMFB_FirstTime_Sham{j}{i} = PostMFB_PosMatSham{j}{i}(PostMFB_FirstZoneIndices_Sham{j}(i),1);
        end
        
        % calculate mean and std
        Pre_FirstTime_Sham_mean(j,i) = mean(mean(Pre_FirstTime_Sham{j}{i}));
        Pre_FirstTime_Sham_std(j,i) = std(mean(Pre_FirstTime_Sham{j}{i}));
        PostPAG_FirstTime_Sham_mean(j,i) = mean(mean(PostPAG_FirstTime_Sham{j}{i}));
        PostPAG_FirstTime_Sham_std(j,i) = std(mean(PostPAG_FirstTime_Sham{j}{i}));
        PostMFB_FirstTime_Sham_mean(j,i) = mean(mean(PostMFB_FirstTime_Sham{j}{i}));
        PostMFB_FirstTime_Sham_std(j,i) = std(mean(PostMFB_FirstTime_Sham{j}{i}));

        %% number of entries in shock zone
        % test pre
        if isempty(Pre_ZoneIndices_Sham{j}{i}{zone})
            Pre_entries_Sham{j}(i) = 0;
        else
            Pre_entries_Sham{j}(i) = length(find(diff(Pre_ZoneIndices_Sham{j}{i}{zone})>1))+1;
        end
        % post PAG
        if isempty(PostPAG_ZoneIndices_Sham{j}{i}{zone})
            PostPAG_entries_Sham{j}(i) = 0;
        else
            PostPAG_entries_Sham{j}(i) = length(find(diff(PostPAG_ZoneIndices_Sham{j}{i}{zone})>1))+1;
        end
        % post MFB
        if isempty(PostMFB_ZoneIndices_Sham{j}{i}{zone})
            PostMFB_entries_Sham{j}(i) = 0;
        else
            PostMFB_entries_Sham{j}(i) = length(find(diff(PostMFB_ZoneIndices_Sham{j}{i}{zone})>1))+1;
        end
        
        % calculate mean and std
        Pre_entries_Sham_mean(j,i) = mean(mean(Pre_entries_Sham{j}(i)));
        Pre_entries_Sham_std(j,i) = std(mean(Pre_entries_Sham{j}(i)));
        PostPAG_entries_Sham_mean(j,i) = mean(mean(PostPAG_entries_Sham{j}(i)));
        PostPAG_entries_Sham_std(j,i) = std(mean(PostPAG_entries_Sham{j}(i)));
        PostMFB_entries_Sham_mean(j,i) = mean(mean(PostMFB_entries_Sham{j}(i)));
        PostMFB_entries_Sham_std(j,i) = std(mean(PostMFB_entries_Sham{j}(i)));

        %% averaged speed in shock zone
        % speed during pre tests
        if isempty(Pre_ZoneIndices_Sham{j}{i}{zone})
            Pre_Speed_Sham{j}(i) = NaN;
        else
            Pre_SpeedTemp_Sham{j}{i}=Data(Pre_Vtsd_Sham{j}{i});
            Pre_SpeedZone_Sham{j}{i}=Pre_SpeedTemp_Sham{j}{i}(Pre_ZoneIndices_Sham{j}{i}{zone}(1:end-1),1);
            Pre_Speed_Sham{j}(i)=nanmean(Pre_SpeedZone_Sham{j}{i},1);
        end
        % speed post PAG test
        if isempty(PostPAG_ZoneIndices_Sham{j}{i}{zone})
            PostPAG_Speed_Sham{j}(i) = NaN;
        else
            PostPAG_SpeedTemp_Sham{j}{i}=Data(PostPAG_Vtsd_Sham{j}{i});
            PostPAG_SpeedZone_Sham{j}{i}=PostPAG_SpeedTemp_Sham{j}{i}(PostPAG_ZoneIndices_Sham{j}{i}{zone}(1:end-1),1);
            PostPAG_Speed_Sham{j}(i)=nanmean(PostPAG_SpeedZone_Sham{j}{i},1);
        end
        % speed post MFB tests
        if isempty(PostMFB_ZoneIndices_Sham{j}{i}{zone})
            PostMFB_Speed_Sham{j}(i) = NaN;
        else
            PostMFB_SpeedTemp_Sham{j}{i}=Data(PostMFB_Vtsd_Sham{j}{i});
            PostMFB_SpeedZone_Sham{j}{i}=PostMFB_SpeedTemp_Sham{j}{i}(PostMFB_ZoneIndices_Sham{j}{i}{zone}(1:end-1),1);
            PostMFB_Speed_Sham{j}(i)=nanmean(PostMFB_SpeedZone_Sham{j}{i},1);
        end
        
        % calculate mean and std
        Pre_speed_Sham_mean(j,i) = nanmean(mean(Pre_Speed_Sham{j}(i)));
        Pre_speed_Sham_std(j,i) = std(mean(Pre_Speed_Sham{j}(i)));
        PostPAG_speed_Sham_mean(j,i) = nanmean(mean(PostPAG_Speed_Sham{j}(i)));
        PostPAG_speed_Sham_std(j,i) = std(mean(PostPAG_Speed_Sham{j}(i)));
        PostMFB_speed_Sham_mean(j,i) = nanmean(mean(PostMFB_Speed_Sham{j}(i)));
        PostMFB_speed_Sham_std(j,i) = std(mean(PostMFB_Speed_Sham{j}(i)));
    end
end

% from conditioning sessions (x3) of sham mice
k=[];
for d = 1:length(DirCondPAGSham.path)
    for e = 1:length(DirCondPAGSham.path{d})
        % cond PAG
        cd(DirCondPAGSham.path{d}{e})
        if isfile('cleanBehavResources.mat') == 1
            k{d} = load('cleanBehavResources.mat', 'CleanAlignedXtsd', 'CleanAlignedYtsd','PosMat');
        else
            k{d} = load('behavResources.mat', 'CleanAlignedXtsd', 'CleanAlignedYtsd','PosMat');
        end
        CondPAG_Xtsd_Sham{d}{e} = k{d}.CleanAlignedXtsd;
        CondPAG_Ytsd_Sham{d}{e} = k{d}.CleanAlignedYtsd;
        CondPAG_PosMat{d}{e} = k{d}.PosMat;
        CondPAG_StimTime_Sham{d}{e} = find(CondPAG_PosMat{d}{e}(:,4)==1);
        
        % cond MFB
        cd(DirCondMFBSham.path{d}{e})
        if isfile('cleanBehavResources.mat') == 1
            l{d} = load('cleanBehavResources.mat', 'CleanAlignedXtsd', 'CleanAlignedYtsd','PosMat');
        else
            l{d} = load('behavResources.mat', 'CleanAlignedXtsd', 'CleanAlignedYtsd','PosMat');
        end
        CondMFB_Xtsd_Sham{d}{e} = l{d}.CleanAlignedXtsd;
        CondMFB_Ytsd_Sham{d}{e} = l{d}.CleanAlignedYtsd;
    end
end
%%
% get data from pre- and post- tests of experimental mice
for v = 1:length(DirPreExp.path)
    for w = 1:length(DirPreExp.path{v})
        % Pre tests
        cd(DirPreExp.path{v}{w});
        if isfile('cleanBehavResources.mat') == 1
            f{v} = load('cleanBehavResources.mat','Occup','ZoneIndices', 'PosMat', 'Vtsd', 'CleanAlignedXtsd', 'CleanAlignedYtsd');
        else
            f{v} = load('behavResources.mat','Occup','ZoneIndices', 'PosMat', 'Vtsd', 'CleanAlignedXtsd', 'CleanAlignedYtsd');
        end
        Pre_Occup_Exp{v}{w} = f{v}.Occup(:,[1:5 8:end]);
        Pre_ZoneIndices_Exp{v}{w} = f{v}.ZoneIndices;
        Pre_PosMat_Exp{v}{w} = f{v}.PosMat;
        Pre_Vtsd_Exp{v}{w} = f{v}.Vtsd;
        Pre_Xtsd_Exp{v}{w} = f{v}.CleanAlignedXtsd;
        Pre_Ytsd_Exp{v}{w} = f{v}.CleanAlignedYtsd;
        % Post tests PAG
        cd(DirPostPAGExp.path{v}{w});
        if isfile('cleanBehavResources.mat') == 1
            g{v} = load('cleanBehavResources.mat','Occup','ZoneIndices', 'PosMat', 'Vtsd', 'CleanAlignedXtsd', 'CleanAlignedYtsd');
        else
            g{v} = load('behavResources.mat','Occup','ZoneIndices', 'PosMat', 'Vtsd', 'CleanAlignedXtsd', 'CleanAlignedYtsd');
        end
        PostPAG_Occup_Exp{v}{w} = g{v}.Occup(:,[1:5 8:end]);
        PostPAG_ZoneIndices_Exp{v}{w} = g{v}.ZoneIndices;
        PostPAG_PosMat_Exp{v}{w} = g{v}.PosMat;
        PostPAG_Vtsd_Exp{v}{w} = g{v}.Vtsd;
        PostPAG_Xtsd_Exp{v}{w} = g{v}.CleanAlignedXtsd;
        PostPAG_Ytsd_Exp{v}{w} = g{v}.CleanAlignedYtsd;
        % Post tests MFB
        cd(DirPostMFBExp.path{v}{w});
        if isfile('cleanBehavResources.mat') == 1
            h{v} = load('cleanBehavResources.mat','Occup','ZoneIndices', 'PosMat', 'Vtsd', 'CleanAlignedXtsd', 'CleanAlignedYtsd');
        else
            h{v} = load('behavResources.mat','Occup','ZoneIndices', 'PosMat', 'Vtsd', 'CleanAlignedXtsd', 'CleanAlignedYtsd');
        end
         PostMFB_Occup_Exp{v}{w} = h{v}.Occup(:,[1:5 8:end]);
        PostMFB_ZoneIndices_Exp{v}{w} = h{v}.ZoneIndices;
        PostMFB_PosMatExp{v}{w} = h{v}.PosMat;
        PostMFB__Vtsd_Exp{v}{w} = h{v}.Vtsd;
        PostMFB_Xtsd_Exp{v}{w} = h{v}.CleanAlignedXtsd;
        PostMFB_Ytsd_Exp{v}{w} = h{v}.CleanAlignedYtsd;
        
        %% average occupancy
        Pre_Occup_Exp_mean(v,:,:) = nanmean(Pre_Occup_Exp{v}{w},1)*100;
        Pre_Occup_Exp_std(v,:,:) = std(Pre_Occup_Exp{v}{w},1)*100;
        PostPAG_Occup_Exp_mean(v,:,:) = nanmean(PostPAG_Occup_Exp{v}{w},1)*100;
        PostPAG_Occup_Exp_std(v,:,:) = std(PostPAG_Occup_Exp{v}{w},1)*100;
        PostMFB_Occup_Exp_mean(v,:,:) = nanmean(PostMFB_Occup_Exp{v}{w},1)*100;
        PostMFB_Occup_Exp_std(v,:,:) = std(PostMFB_Occup_Exp{v}{w},1)*100;
        
        %% time to first enter shock zone
        % pre test
        if isempty(Pre_ZoneIndices_Exp{v}{w}{zone})
            Pre_FirstTime_Exp{v}{w} = 120;
        else
            Pre_FirstZoneIndices_Exp{v}(w) = Pre_ZoneIndices_Exp{v}{w}{zone}(1);
            Pre_FirstTime_Exp{v}{w} = Pre_PosMat_Exp{v}{w}(Pre_FirstZoneIndices_Exp{v}(w),1);
        end
        % post PAG test
        if isempty(PostPAG_ZoneIndices_Exp{v}{w}{zone})
            PostPAG_FirstTime_Exp{v}{w} = 120;
        else
            PostPAG_FirstZoneIndices_Exp{v}(w) = PostPAG_ZoneIndices_Exp{v}{w}{zone}(1);
            PostPAG_FirstTime_Exp{v}{w} = PostPAG_PosMat_Exp{v}{w}(PostPAG_FirstZoneIndices_Exp{v}(w),1);
        end
        % post MFB test
        if isempty(PostMFB_ZoneIndices_Exp{v}{w}{zone})
            PostMFB_FirstTime_Exp{v}{w} = 120;
        else
            PostMFB_FirstZoneIndices_Exp{v}(w) = PostMFB_ZoneIndices_Exp{v}{w}{zone}(1);
            PostMFB_FirstTime_Exp{v}{w} = PostMFB_PosMatExp{v}{w}(PostMFB_FirstZoneIndices_Exp{v}(w),1);
        end
        
        % calculate mean and std
        Pre_FirstTime_Exp_mean(v,w) = mean(mean(Pre_FirstTime_Exp{v}{w}));
        Pre_FirstTime_Exp_std(v,w) = std(mean(Pre_FirstTime_Exp{v}{w}));
        PostPAG_FirstTime_Exp_mean(v,w) = mean(mean(PostPAG_FirstTime_Exp{v}{w}));
        PostPAG_FirstTime_Exp_std(v,w) = std(mean(PostPAG_FirstTime_Exp{v}{w}));
        PostMFB_FirstTime_Exp_mean(v,w) = mean(mean(PostMFB_FirstTime_Exp{v}{w}));
        PostMFB_FirstTime_Exp_std(v,w) = std(mean(PostMFB_FirstTime_Exp{v}{w}));
        
        %% number of entries in shock zone
        % test pre
        if isempty(Pre_ZoneIndices_Exp{v}{w}{zone})
            Pre_entries_Exp{v}(w) = 0;
        else
            Pre_entries_Exp{v}(w) = length(find(diff(Pre_ZoneIndices_Exp{v}{w}{zone})>1))+1;
        end
        % post PAG
        if isempty(PostPAG_ZoneIndices_Exp{v}{w}{zone})
            PostPAG_entries_Exp{v}(w) = 0;
        else
            PostPAG_entries_Exp{v}(w) = length(find(diff(PostPAG_ZoneIndices_Exp{v}{w}{zone})>1))+1;
        end
        % post MFB
        if isempty(PostMFB_ZoneIndices_Exp{v}{w}{zone})
            PostMFB_entries_Exp{v}(w) = 0;
        else
            PostMFB_entries_Exp{v}(w) = length(find(diff(PostMFB_ZoneIndices_Exp{v}{w}{zone})>1))+1;
        end
        
        % calculate mean and std
        Pre_entries_Exp_mean(v,w) = mean(mean(Pre_entries_Exp{v}(w)));
        Pre_entries_Exp_std(v,w) = std(mean(Pre_entries_Exp{v}(w)));
        PostPAG_entries_Exp_mean(v,w) = mean(mean(PostPAG_entries_Exp{v}(w)));
        PostPAG_entries_Exp_std(v,w) = std(mean(PostPAG_entries_Exp{v}(w)));
        PostMFB_entries_Exp_mean(v,w) = mean(mean(PostMFB_entries_Exp{v}(w)));
        PostMFB_entries_Exp_std(v,w) = std(mean(PostMFB_entries_Exp{v}(w)));
        
        %% averaged speed in shock zone
        % speed during pre tests
        if isempty(Pre_ZoneIndices_Exp{v}{w}{zone})
            Pre_Speed_Exp{v}(w) = NaN;
        else
            Pre_SpeedTemp_Exp{v}{w}=Data(Pre_Vtsd_Exp{v}{w});
            Pre_SpeedZone_Exp{v}{w}=Pre_SpeedTemp_Exp{v}{w}(Pre_ZoneIndices_Exp{v}{w}{zone}(1:end-1),1);
            Pre_Speed_Exp{v}(w)=nanmean(Pre_SpeedZone_Exp{v}{w},1);
        end
        % speed post PAG test
        if isempty(PostPAG_ZoneIndices_Exp{v}{w}{zone})
            PostPAG_Speed_Exp{v}(w) = NaN;
        else
            PostPAG_SpeedTemp_Exp{v}{w}=Data(PostPAG_Vtsd_Exp{v}{w});
            PostPAG_SpeedZone_Exp{v}{w}=PostPAG_SpeedTemp_Exp{v}{w}(PostPAG_ZoneIndices_Exp{v}{w}{zone}(1:end-1),1);
            PostPAG_Speed_Exp{v}(w)=nanmean(PostPAG_SpeedZone_Exp{v}{w},1);
        end
        % speed post MFB tests
        if isempty(PostMFB_ZoneIndices_Exp{v}{w}{zone})
            PostMFB_Speed_Exp{v}(w) = NaN;
        else
            PostMFB_SpeedTemp_Exp{v}{w}=Data(PostMFB__Vtsd_Exp{v}{w});
            PostMFB_SpeedZone_Exp{v}{w}=PostMFB_SpeedTemp_Exp{v}{w}(PostMFB_ZoneIndices_Exp{v}{w}{zone}(1:end-1),1);
            PostMFB_Speed_Exp{v}(w)=nanmean(PostMFB_SpeedZone_Exp{v}{w},1);
        end
        
        % calculate mean and std
        Pre_speed_Exp_mean(v,w) = nanmean(nanmean(Pre_Speed_Exp{v}(w)));
        Pre_speed_Exp_std(v,w) = std(nanmean(Pre_Speed_Exp{v}(w)));
        PostPAG_speed_Exp_mean(v,w) = nanmean(nanmean(PostPAG_Speed_Exp{v}(w)));
        PostPAG_speed_Exp_std(v,w) = std(nanmean(PostPAG_Speed_Exp{v}(w)));
        PostMFB_speed_Exp_mean(v,w) = nanmean(nanmean(PostMFB_Speed_Exp{v}(w)));
        PostMFB_speed_Exp_std(v,w) = std(nanmean(PostMFB_Speed_Exp{v}(w)));
    end
end

% from conditioning sessions (x3) of experiemental mice
for m = 1:length(DirCondPAGExp.path)
    for n = 1:length(DirCondPAGExp.path{m})
        cd(DirCondPAGExp.path{m}{n})
        % cond PAG
        if isfile('cleanBehavResources.mat') == 1
            r{m} = load('cleanBehavResources.mat', 'CleanAlignedXtsd', 'CleanAlignedYtsd');
        else
            r{m} = load('behavResources.mat', 'CleanAlignedXtsd', 'CleanAlignedYtsd');
        end
        CondPAG_Xtsd_Exp{m}{n} = r{m}.CleanAlignedXtsd;
        CondPAG_Ytsd_Exp{m}{n} = r{m}.CleanAlignedYtsd;
        
        % cond MFB
        cd(DirCondMFBExp.path{m}{n})
        if isfile('cleanBehavResources.mat') == 1
            s{m} = load('cleanBehavResources.mat', 'CleanAlignedXtsd', 'CleanAlignedYtsd');
        else
            s{m} = load('behavResources.mat', 'CleanAlignedXtsd', 'CleanAlignedYtsd');
        end
        CondMFB_Xtsd_Exp{m}{n} = s{m}.CleanAlignedXtsd;
        CondMFB_Ytsd_Exp{m}{n} = s{m}.CleanAlignedYtsd;
    end
end

%% plot figures
%% trajectories for all mice
figure
% Trajectories during pre- et post- tests
for p = 1:length(DirPreExp.path)
    for q = 1:1:ntest
        % SHAM MICE
        subplot(251), plot(Data(Pre_Xtsd_Sham{p}{q}),Data(Pre_Ytsd_Sham{p}{q}), 'color', clrs{p}), hold on
        title('TestPre Sham'); ylim([0 1]); xlim([0 1])
        subplot(253), plot(Data(PostPAG_Xtsd_Sham{p}{q}),Data(PostPAG_Ytsd_Sham{p}{q}), 'color', clrs{p}), hold on
        title('TestPostPAG Sham'); ylim([0 1]); xlim([0 1])
        subplot(255), plot(Data(PostMFB_Xtsd_Sham{p}{q}),Data(PostMFB_Ytsd_Sham{p}{q}), 'color', clrs{p}), hold on
        title('TestPostMFB Sham'); ylim([0 1]); xlim([0 1])
        % EXPERIMENTAL MICE
        subplot(256), plot(Data(Pre_Xtsd_Exp{p}{q}),Data(Pre_Ytsd_Exp{p}{q}), 'color', clrs{p}), hold on
        title('TestPre Experimental'); ylim([0 1]); xlim([0 1])
        subplot(258), plot(Data(PostPAG_Xtsd_Exp{p}{q}),Data(PostPAG_Ytsd_Exp{p}{q}), 'color', clrs{p}), hold on
        title('TestPostPAG Experimental'); ylim([0 1]); xlim([0 1])
        subplot(2,5,10), plot(Data(PostMFB_Xtsd_Exp{p}{q}),Data(PostMFB_Ytsd_Exp{p}{q}), 'color', clrs{p}), hold on
        title('TestPostMFB Experimental'); ylim([0 1]); xlim([0 1])
    end
end

% trajectories during conditioning
for t = 1:length(DirCondPAGExp.path)
    for u = 1:1:ncond
        % SHAM MICE
        subplot(252), plot(Data(CondPAG_Xtsd_Sham{t}{u}),Data(CondPAG_Ytsd_Sham{t}{u}), 'color', clrs{t}), hold on
        title('CondPAG Sham'); ylim([0 1]); xlim([0 1])
        subplot(254), plot(Data(CondMFB_Xtsd_Sham{t}{u}),Data(CondMFB_Ytsd_Sham{t}{u}), 'color', clrs{t}), hold on
        title('CondMFB Sham'); ylim([0 1]); xlim([0 1])

        % EXPERIMENTAL MICE
        subplot(257), plot(Data(CondPAG_Xtsd_Exp{t}{u}),Data(CondPAG_Ytsd_Exp{t}{u}), 'color', clrs{t}), hold on
        title('CondPAG Experimental'); ylim([0 1]); xlim([0 1])
        subplot(259), plot(Data(CondMFB_Xtsd_Exp{t}{u}),Data(CondMFB_Ytsd_Exp{t}{u}), 'color', clrs{t}), hold on
        title('CondMFB Experimental'); ylim([0 1]); xlim([0 1])
    end
end

%% TRAJECTORIES FOR ALL MICE FOR THE 10 FIRST SECONDS
figure
% Trajectories during pre- et post- tests FOR THE 10 FIRST SECONDS
for p = 1:length(DirPreExp.path)
    for q = 1:1:ntest
        % SHAM MICE
        % Find first 10 sec of trajectories
        dat_temp = Data(Pre_Xtsd_Sham{p}{q});
        time_temp = Range(Pre_Xtsd_Sham{p}{q});
        firstind = find(~isnan(dat_temp),1);
        Epoch = intervalSet(time_temp(firstind), time_temp(firstind)+time_beg*1e4);
        % Plot
        hold on
        subplot(251), plot(Data(Restrict(Pre_Xtsd_Sham{p}{q},Epoch)), Data(Restrict(Pre_Ytsd_Sham{p}{q},Epoch)), 'color', clrs{p})
        if p == length(DirPreExp.path)
            plot(maze(:,1),maze(:,2),'k','LineWidth',3)
            plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
        end
        makepretty
        title('TestPre Sham'); ylim([0 1]); xlim([0 1])
        % Find first 10 sec of trajectories
        dat_temp = Data(PostPAG_Xtsd_Sham{p}{q});
        time_temp = Range(PostPAG_Xtsd_Sham{p}{q});
        firstind = find(~isnan(dat_temp),1);
        Epoch = intervalSet(time_temp(firstind), time_temp(firstind)+time_beg*1e4);
        % Plot
        hold on
        subplot(253), plot(Data(Restrict(PostPAG_Xtsd_Sham{p}{q},Epoch)),Data(Restrict(PostPAG_Ytsd_Sham{p}{q},Epoch)), 'color', clrs{p})
        if p == length(DirPreExp.path)
            plot(maze(:,1),maze(:,2),'k','LineWidth',3)
            plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
        end
        makepretty
        title('TestPostPAG Sham'); ylim([0 1]); xlim([0 1])
        % Find first 10 sec of trajectories
        dat_temp = Data(PostMFB_Xtsd_Sham{p}{q});
        time_temp = Range(PostMFB_Xtsd_Sham{p}{q});
        firstind = find(~isnan(dat_temp),1);
        Epoch = intervalSet(time_temp(firstind), time_temp(firstind)+time_beg*1e4);
        % Plot
        hold on
        subplot(255), plot(Data(Restrict(PostMFB_Xtsd_Sham{p}{q},Epoch)),Data(Restrict(PostMFB_Ytsd_Sham{p}{q},Epoch)), 'color', clrs{p})
        if p == length(DirPreExp.path)
            plot(maze(:,1),maze(:,2),'k','LineWidth',3)
            plot(shockZone(:,1),shockZone(:,2),'m','LineWidth',3)
        end
        makepretty
        title('TestPostMFB Sham'); ylim([0 1]); xlim([0 1])
        % EXPERIMENTAL MICE
        % Find first 10 sec of trajectories
        dat_temp = Data(Pre_Xtsd_Exp{p}{q});
        time_temp = Range(Pre_Xtsd_Exp{p}{q});
        firstind = find(~isnan(dat_temp),1);
        Epoch = intervalSet(time_temp(firstind), time_temp(firstind)+time_beg*1e4);
        % Plot
        hold on
        subplot(256), plot(Data(Restrict(Pre_Xtsd_Exp{p}{q},Epoch)),Data(Restrict(Pre_Ytsd_Exp{p}{q},Epoch)), 'color', clrs{p})
        if p == length(DirPreExp.path)
            plot(maze(:,1),maze(:,2),'k','LineWidth',3)
            plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
        end
        makepretty
        title('TestPre Experimental'); ylim([0 1]); xlim([0 1])
        % Find first 10 sec of trajectories
        dat_temp = Data(PostPAG_Xtsd_Exp{p}{q});
        time_temp = Range(PostPAG_Xtsd_Exp{p}{q});
        firstind = find(~isnan(dat_temp),1);
        Epoch = intervalSet(time_temp(firstind), time_temp(firstind)+time_beg*1e4);
        % Plot
        hold on
        subplot(258), plot(Data(Restrict(PostPAG_Xtsd_Exp{p}{q},Epoch)),Data(Restrict(PostPAG_Ytsd_Exp{p}{q},Epoch)), 'color', clrs{p})
        if p == length(DirPreExp.path)
            plot(maze(:,1),maze(:,2),'k','LineWidth',3)
            plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
        end
        makepretty
        title('TestPostPAG Experimental'); ylim([0 1]); xlim([0 1])
        % Find first 10 sec of trajectories
        dat_temp = Data(PostMFB_Xtsd_Exp{p}{q});
        time_temp = Range(PostMFB_Xtsd_Exp{p}{q});
        firstind = find(~isnan(dat_temp),1);
        Epoch = intervalSet(time_temp(firstind), time_temp(firstind)+time_beg*1e4);
        % Plot
        hold on
        subplot(2,5,10), plot(Data(Restrict(PostMFB_Xtsd_Exp{p}{q},Epoch)),Data(Restrict(PostMFB_Ytsd_Exp{p}{q},Epoch)), 'color', clrs{p})
        if p == length(DirPreExp.path)
            plot(maze(:,1),maze(:,2),'k','LineWidth',3)
            plot(shockZone(:,1),shockZone(:,2),'g','LineWidth',3)
        end
        makepretty
        title('TestPostMFB Experimental'); ylim([0 1]); xlim([0 1])
    end
end

% trajectories during conditioning
for t = 1:length(DirCondPAGExp.path)
    for u = 1:1:ncond
        % SHAM MICE
        % Find first 10 sec of trajectories
        dat_temp = Data(CondPAG_Xtsd_Sham{t}{u});
        time_temp = Range(CondPAG_Xtsd_Sham{t}{u});
        firstind = find(~isnan(dat_temp),1);
        Epoch = intervalSet(time_temp(firstind), time_temp(firstind)+time_beg*1e4);
        % Plot
        hold on
        subplot(252), plot(Data(Restrict(CondPAG_Xtsd_Sham{t}{u},Epoch)),Data(Restrict(CondPAG_Ytsd_Sham{t}{u},Epoch)), 'color', clrs{t})
        if p == length(DirPreExp.path)
            plot(maze(:,1),maze(:,2),'k','LineWidth',3)
            plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
        end
        makepretty
        title('CondPAG Sham'); ylim([0 1]); xlim([0 1])
        % Find first 10 sec of trajectories
        dat_temp = Data(CondMFB_Xtsd_Sham{t}{u});
        time_temp = Range(CondMFB_Xtsd_Sham{t}{u});
        firstind = find(~isnan(dat_temp),1);
        Epoch = intervalSet(time_temp(firstind), time_temp(firstind)+time_beg*1e4);
        % Plot
        hold on
        subplot(254), plot(Data(Restrict(CondMFB_Xtsd_Sham{t}{u},Epoch)),Data(Restrict(CondMFB_Ytsd_Sham{t}{u},Epoch)), 'color', clrs{t})
        if p == length(DirPreExp.path)
            plot(maze(:,1),maze(:,2),'k','LineWidth',3)
            plot(shockZone(:,1),shockZone(:,2),'m','LineWidth',3)
        end
        makepretty
        title('CondMFB Sham'); ylim([0 1]); xlim([0 1])

        % EXPERIMENTAL MICE
        % Find first 10 sec of trajectories
        dat_temp = Data(CondPAG_Xtsd_Exp{t}{u});
        time_temp = Range(CondPAG_Xtsd_Exp{t}{u});
        firstind = find(~isnan(dat_temp),1);
        Epoch = intervalSet(time_temp(firstind), time_temp(firstind)+time_beg*1e4);
        % Plot
        hold on
        subplot(257), plot(Data(Restrict(CondPAG_Xtsd_Exp{t}{u},Epoch)),Data(Restrict(CondPAG_Ytsd_Exp{t}{u},Epoch)), 'color', clrs{t})
        if p == length(DirPreExp.path)
            plot(maze(:,1),maze(:,2),'k','LineWidth',3)
            plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
        end
        makepretty
        title('CondPAG Experimental'); ylim([0 1]); xlim([0 1])
        dat_temp = Data(CondMFB_Xtsd_Exp{t}{u});
        time_temp = Range(CondMFB_Xtsd_Exp{t}{u});
        firstind = find(~isnan(dat_temp),1);
        Epoch = intervalSet(time_temp(firstind), time_temp(firstind)+time_beg*1e4);
        % Plot
        hold on
        subplot(259), plot(Data(Restrict(CondMFB_Xtsd_Exp{t}{u},Epoch)),Data(Restrict(CondMFB_Ytsd_Exp{t}{u},Epoch)), 'color', clrs{t})
        if p == length(DirPreExp.path)
            plot(maze(:,1),maze(:,2),'k','LineWidth',3)
            plot(shockZone(:,1),shockZone(:,2),'g','LineWidth',3)
        end
        makepretty
        title('CondMFB Experimental'); ylim([0 1]); xlim([0 1])
    end
end

%% First time to enter the zone for each trial (for Pre, PostPAG & PostMFB)
figure,subplot(131),PlotErrorBar4MC(mean(Pre_FirstTime_Sham_mean(:,1),2), mean(Pre_FirstTime_Exp_mean(:,1),2), mean(Pre_FirstTime_Sham_mean(:,2),2), mean(Pre_FirstTime_Exp_mean(:,2),2),...
mean(Pre_FirstTime_Sham_mean(:,3),2), mean(Pre_FirstTime_Exp_mean(:,3),2), mean(Pre_FirstTime_Sham_mean(:,4),2), mean(Pre_FirstTime_Exp_mean(:,4),2))
set(gca,'Xtick',[1:4],'XtickLabel',{'Trial1', 'Trial2', 'Trial3', 'Trial4'});
ylim([0 150])
line([0.10 5],[120 120],'color','k','linestyle','--')
ylabel('Time (s)')
title('Pre test')
makepretty
subplot(132),PlotErrorBar4MC(mean(PostPAG_FirstTime_Sham_mean(:,1),2), mean(PostPAG_FirstTime_Exp_mean(:,1),2),mean(PostPAG_FirstTime_Sham_mean(:,2),2), mean(PostPAG_FirstTime_Exp_mean(:,2),2),...
mean(PostPAG_FirstTime_Sham_mean(:,3),2), mean(PostPAG_FirstTime_Exp_mean(:,3),2),mean(PostPAG_FirstTime_Sham_mean(:,4),2), mean(PostPAG_FirstTime_Exp_mean(:,4),2))
set(gca,'Xtick',[1:4],'XtickLabel',{'Trial1', 'Trial2', 'Trial3', 'Trial4'});
ylim([0 150])
line([0.10 5],[120 120],'color','k','linestyle','--')
ylabel('Time (s)')
title('PostPAG')
makepretty
subplot(133),PlotErrorBar4MC(mean(PostMFB_FirstTime_Sham_mean(:,1),2), mean(PostMFB_FirstTime_Exp_mean(:,1),2),mean(PostMFB_FirstTime_Sham_mean(:,2),2), mean(PostMFB_FirstTime_Exp_mean(:,2),2),...
mean(PostMFB_FirstTime_Sham_mean(:,3),2), mean(PostMFB_FirstTime_Exp_mean(:,3),2), mean(PostMFB_FirstTime_Sham_mean(:,4),2), mean(PostMFB_FirstTime_Exp_mean(:,4),2))
set(gca,'Xtick',[1:4],'XtickLabel',{'Trial1', 'Trial2', 'Trial3', 'Trial4'});
ylim([0 150])
line([0.10 5],[120 120],'color','k','linestyle','--')
ylabel('Time (s)')
title('PostMFB')
makepretty
suptitle('First time to enter the StimZone')

%% average occupancy for each zones of the maze (barplots for sham vs experimental)
% zones : StimZone = 1; NoStim = 2; Centre = 3; CentreStim = 4; CentreNoStim = 5; CornerStim = 6; CornerNoStim = 7;
% Test Pre
figure
subplot(131), PlotErrorBar7MC(Pre_Occup_Sham_mean(:,:,1), Pre_Occup_Exp_mean(:,:,1), Pre_Occup_Sham_mean(:,:,4), Pre_Occup_Exp_mean(:,:,4), Pre_Occup_Sham_mean(:,:,6), Pre_Occup_Exp_mean(:,:,6), Pre_Occup_Sham_mean(:,:,3),...
    Pre_Occup_Exp_mean(:,:,3), Pre_Occup_Sham_mean(:,:,7), Pre_Occup_Exp_mean(:,:,7), Pre_Occup_Sham_mean(:,:,5), Pre_Occup_Exp_mean(:,:,5),Pre_Occup_Sham_mean(:,:,2), Pre_Occup_Exp_mean(:,:,2))
set(gca,'Xtick',[1:7],'XtickLabel',{'Stim', 'CentreStim', 'CornerStim', 'Centre', 'CornerNoStim', 'CentreNoStim', 'NoStim'});
xtickangle(45)
ylim([0 100])
ylabel('% time spent')
title('TestPre')
makepretty
% Test post PAG
subplot(132), PlotErrorBar7MC(PostPAG_Occup_Sham_mean(:,:,1), PostPAG_Occup_Exp_mean(:,:,1), PostPAG_Occup_Sham_mean(:,:,4), PostPAG_Occup_Exp_mean(:,:,4), PostPAG_Occup_Sham_mean(:,:,6), PostPAG_Occup_Exp_mean(:,:,6), PostPAG_Occup_Sham_mean(:,:,3),...
    PostPAG_Occup_Exp_mean(:,:,3), PostPAG_Occup_Sham_mean(:,:,7), PostPAG_Occup_Exp_mean(:,:,7), PostPAG_Occup_Sham_mean(:,:,5), PostPAG_Occup_Exp_mean(:,:,5), PostPAG_Occup_Sham_mean(:,:,2),PostPAG_Occup_Exp_mean(:,:,2))
set(gca,'Xtick',[1:7],'XtickLabel',{'Stim', 'CentreStim', 'CornerStim', 'Centre', 'CornerNoStim', 'CentreNoStim', 'NoStim'});
xtickangle(45)
ylim([0 100])
ylabel('% time spent')
title('TestPostPAG')
makepretty
% Test post MFB
subplot(133), PlotErrorBar7MC(PostMFB_Occup_Sham_mean(:,:,1), PostMFB_Occup_Exp_mean(:,:,1), PostMFB_Occup_Sham_mean(:,:,4), PostMFB_Occup_Exp_mean(:,:,4), PostMFB_Occup_Sham_mean(:,:,6), PostMFB_Occup_Exp_mean(:,:,6), PostMFB_Occup_Sham_mean(:,:,3),...
    PostMFB_Occup_Exp_mean(:,:,3), PostMFB_Occup_Sham_mean(:,:,7), PostMFB_Occup_Exp_mean(:,:,7), PostMFB_Occup_Sham_mean(:,:,5), PostMFB_Occup_Exp_mean(:,:,5), PostMFB_Occup_Sham_mean(:,:,2), PostMFB_Occup_Exp_mean(:,:,2))
set(gca,'Xtick',[1:7],'XtickLabel',{'Stim', 'CentreStim', 'CornerStim', 'Centre', 'CornerNoStim', 'CentreNoStim', 'NoStim'});
xtickangle(45)
ylim([0 100])
ylabel('% time spent')
title('TestPostMFB')
makepretty

%% average occupancy experimental mice only
figure
subplot(231), PlotErrorBarN_KJ({Pre_Occup_Exp_mean(:,:,1), Pre_Occup_Exp_mean(:,:,4), Pre_Occup_Exp_mean(:,:,6), Pre_Occup_Exp_mean(:,:,3), Pre_Occup_Exp_mean(:,:,7), Pre_Occup_Exp_mean(:,:,5), Pre_Occup_Exp_mean(:,:,2)},'newfig',0,'paired',1);
set(gca,'Xtick',[1:7],'XtickLabel',{'Stim', 'CentreStim', 'CornerStim', 'Centre', 'CornerNoStim', 'CentreNoStim', 'NoStim'});
xtickangle(45)
ylim([0 100])
ylabel('% time spent')
title('TestPre expe')
makepretty
% Test post PAG
subplot(232), PlotErrorBarN_KJ({PostPAG_Occup_Exp_mean(:,:,1), PostPAG_Occup_Exp_mean(:,:,4), PostPAG_Occup_Exp_mean(:,:,6), PostPAG_Occup_Exp_mean(:,:,3), PostPAG_Occup_Exp_mean(:,:,7), PostPAG_Occup_Exp_mean(:,:,5), PostPAG_Occup_Exp_mean(:,:,2)},'newfig',0,'paired',1);
set(gca,'Xtick',[1:7],'XtickLabel',{'Stim', 'CentreStim', 'CornerStim', 'Centre', 'CornerNoStim', 'CentreNoStim', 'NoStim'});
xtickangle(45)
ylim([0 100])
ylabel('% time spent')
title('TestPostPAG expe')
makepretty
% Test post MFB
subplot(233), PlotErrorBarN_KJ({PostMFB_Occup_Exp_mean(:,:,1), PostMFB_Occup_Exp_mean(:,:,4), PostMFB_Occup_Exp_mean(:,:,6), PostMFB_Occup_Exp_mean(:,:,3), PostMFB_Occup_Exp_mean(:,:,7), PostMFB_Occup_Exp_mean(:,:,5), PostMFB_Occup_Exp_mean(:,:,2)},'newfig',0,'paired',1);
set(gca,'Xtick',[1:7],'XtickLabel',{'Stim', 'CentreStim', 'CornerStim', 'Centre', 'CornerNoStim', 'CentreNoStim', 'NoStim'});
xtickangle(45)
ylim([0 100])
ylabel('% time spent')
title('TestPostMFB expe')
makepretty

% average occupancy sham mice only
subplot(234), PlotErrorBarN_KJ({Pre_Occup_Sham_mean(:,:,1), Pre_Occup_Sham_mean(:,:,4), Pre_Occup_Sham_mean(:,:,6), Pre_Occup_Sham_mean(:,:,3), Pre_Occup_Sham_mean(:,:,7), Pre_Occup_Sham_mean(:,:,5), Pre_Occup_Sham_mean(:,:,2)},'newfig',0,'paired',1,'barcolors',[1 1 1 ]);
set(gca,'Xtick',[1:7],'XtickLabel',{'Stim', 'CentreStim', 'CornerStim', 'Centre', 'CornerNoStim', 'CentreNoStim', 'NoStim'});
xtickangle(45)
ylim([0 100])
ylabel('% time spent')
title('TestPre sham')
makepretty
% Test post PAG
subplot(235), PlotErrorBarN_KJ({PostPAG_Occup_Sham_mean(:,:,1), PostPAG_Occup_Sham_mean(:,:,4), PostPAG_Occup_Sham_mean(:,:,6), PostPAG_Occup_Sham_mean(:,:,3), PostPAG_Occup_Sham_mean(:,:,7), PostPAG_Occup_Sham_mean(:,:,5),PostPAG_Occup_Sham_mean(:,:,2)},'newfig',0,'paired',1,'barcolors',[1 1 1 ]);
set(gca,'Xtick',[1:7],'XtickLabel',{'Stim', 'CentreStim', 'CornerStim', 'Centre', 'CornerNoStim', 'CentreNoStim', 'NoStim'});
xtickangle(45)
ylim([0 100])
ylabel('% time spent')
title('TestPostPAG sham')
makepretty
% Test post MFB
subplot(236), PlotErrorBarN_KJ({PostMFB_Occup_Sham_mean(:,:,1), PostMFB_Occup_Sham_mean(:,:,4), PostMFB_Occup_Sham_mean(:,:,6), PostMFB_Occup_Sham_mean(:,:,3), PostMFB_Occup_Sham_mean(:,:,7), PostMFB_Occup_Sham_mean(:,:,5), PostMFB_Occup_Sham_mean(:,:,2)},'newfig',0,'paired',1,'barcolors',[1 1 1 ]);
set(gca,'Xtick',[1:7],'XtickLabel',{'Stim', 'CentreStim', 'CornerStim', 'Centre', 'CornerNoStim', 'CentreNoStim', 'NoStim'});
xtickangle(45)
ylim([0 100])
ylabel('% time spent')
title('TestPostMFB sham')
makepretty

%% behavioral parameters in the shock zone
figure
subplot(221),PlotBarMC(mean(Pre_Occup_Sham_mean(:,:,zone),2), mean(Pre_Occup_Exp_mean(:,:,zone),2), mean(PostPAG_Occup_Sham_mean(:,:,zone),2), mean(PostPAG_Occup_Exp_mean(:,:,zone),2), mean(PostMFB_Occup_Sham_mean(:,:,zone),2), mean(PostMFB_Occup_Exp_mean(:,:,zone),2))
set(gca,'Xtick',[1:3],'XtickLabel',{'TestPre', 'TestPostPAG', 'TestPostMFB'});
ylabel('% time')
line([0.10 4],[21.5 21.5],'color','k','linestyle','--')
title('Percentage of the StimZone occupancy')
makepretty
% number of entries in shock zone
subplot(222),PlotBarMC(mean(Pre_entries_Sham_mean,2), mean(Pre_entries_Exp_mean,2), mean(PostPAG_entries_Sham_mean,2), mean(PostPAG_entries_Exp_mean,2), mean(PostMFB_entries_Sham_mean,2), mean(PostMFB_entries_Exp_mean,2))
set(gca,'Xtick',[1:3],'XtickLabel',{'TestPre', 'TestPostPAG', 'TestPostMFB'});
ylabel('Number of entries')
xlim([0.10 4])
title('Number of entries to the StimZone')
makepretty
% first time to enter shock zone
subplot(223),PlotBarMC(mean(Pre_FirstTime_Sham_mean,2), mean(Pre_FirstTime_Exp_mean,2), mean(PostPAG_FirstTime_Sham_mean,2), mean(PostPAG_FirstTime_Exp_mean,2), mean(PostMFB_FirstTime_Sham_mean,2), mean(PostMFB_FirstTime_Exp_mean,2))
set(gca,'Xtick',[1:3],'XtickLabel',{'TestPre', 'TestPostPAG', 'TestPostMFB'});
line([0.1 4],[120 120],'color','k','linestyle','--')
ylabel('Time (s)')
ylim([0 150])
title('First time to enter the StimZone')
makepretty
% averaged speed in shock zone
subplot(224),PlotBarMC(nanmean(Pre_speed_Sham_mean,2), nanmean(Pre_speed_Exp_mean,2), nanmean(PostPAG_speed_Sham_mean,2), nanmean(PostPAG_speed_Exp_mean,2), nanmean(PostMFB_speed_Sham_mean,2), nanmean(PostMFB_speed_Exp_mean,2))
set(gca,'Xtick',[1:3],'XtickLabel',{'TestPre', 'TestPostPAG', 'TestPostMFB'});
ylabel('Speed (cm/s)');
xlim([0.10 4])
title('Average speed in the StimZone')
makepretty


