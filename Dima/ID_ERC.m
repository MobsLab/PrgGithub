%ID_ERC - Plot the fugure that contains basic information about a mouse
%
% 
%  OUTPUT
%
%    Figure
% 
%       2018 by Dmitri Bryzgalov

%% Parameters
Mice_to_analyze = 711;
rip_channel = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/PostSleep/ChannelsToAnalyse/dHPC_rip.mat');
durations = [-50 50]/1000;
suf = {'TestPre', 'TestPost'};
clrs = {'ko', 'ro', 'go','co'; 'k','r', 'g', 'c'};
ntest=4;
% Speed
old=1;

% Get directories
Dir_Pre = PathForExperimentsERC_Dima('TestPrePooled');
Dir_Pre = RestrictPathForExperiment(Dir_Pre,'nMice', Mice_to_analyze);
Dir_Post = PathForExperimentsERC_Dima('TestPostPooled');
Dir_Post = RestrictPathForExperiment(Dir_Post,'nMice', Mice_to_analyze);

% Output - CHANGE!!!
dir_out = '/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/Behavior/Mouse753/';
fig_out = 'ID';

%% Kostyli
% load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/AllSpikes/BasicNeuronInfoERC.mat');
% dhPC_rip = load(['/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/PostSleep/LFPData/LFP'...
%     num2str(rip_channel.channel) '.mat']);
% r=load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/PostSleep/Ripples.mat');


%% Get Data
for i = 1:1:ntest
    % PreTests
    a = load(['/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/' suf{1} '/' suf{1} num2str(i) '/behavResources.mat'],...
        'Occup', 'PosMat','Xtsd', 'Ytsd', 'Vtsd', 'mask', 'Zone', 'ZoneIndices', 'Ratio_IMAonREAL');
    Pre_Xtsd{i} = a.Xtsd;
    Pre_Ytsd{i} = a.Ytsd;
    Pre_Vtsd{i} = a.Vtsd;
    PreTest_PosMat{i} = a.PosMat;
    PreTest_occup(i,1:7) = a.Occup;
    PreTest_ZoneIndices{i} = a.ZoneIndices;
    Pre_mask = a.mask;
    Pre_Zone = a.Zone;
    Pre_Ratio_IMAonREAL = a.Ratio_IMAonREAL;
    % PostTests
    b = load(['/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/' suf{2} '/' suf{2} num2str(i) '/behavResources.mat'],...
    'Occup', 'PosMat','Xtsd', 'Ytsd', 'Vtsd', 'mask', 'Zone', 'ZoneIndices', 'Ratio_IMAonREAL');
    Post_Xtsd{i} = b.Xtsd;
    Post_Ytsd{i} = b.Ytsd;
    Post_Vtsd{i} = b.Vtsd;
    PostTest_PosMat{i} = b.PosMat;
    PostTest_occup(i,1:7) = b.Occup;
    PostTest_ZoneIndices{i} = b.ZoneIndices;
    Post_mask = b.mask;
    Post_Zone = b.Zone;
    Post_Ratio_IMAonREAL = b.Ratio_IMAonREAL;
end

PreBehavior = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/TestPre/behavResources.mat');
Pre_Imdifftsd = PreBehavior.Imdifftsd;
Pre_FreezeAccEpoch = PreBehavior.FreezeAccEpoch;
Pre_ImmobEpoch=PreBehavior.ImmobEpoch;
Pre_LocomotionEpoch = PreBehavior.LocomotionEpoch;
Pre_PosMat = PreBehavior.PosMat;
Pre_ZoneEpoch = PreBehavior.ZoneEpoch;

PostBehavior = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/TestPost/behavResources.mat');
Post_Imdifftsd = PostBehavior.Imdifftsd;
Post_FreezeAccEpoch = PostBehavior.FreezeAccEpoch;
Post_ImmobEpoch=PostBehavior.ImmobEpoch;
Post_LocomotionEpoch = PostBehavior.LocomotionEpoch;
Post_PosMat = PostBehavior.PosMat;
Post_ZoneEpoch = PostBehavior.ZoneEpoch;

%% Calculate
%-------------------------------***************************************************---------------------------------------

% %% Neurons
% % Calculate number of MUA and SUA
% num_MUA = length(BasicNeuronInfo.idx_MUA);
% num_SUA = length(BasicNeuronInfo.idx_SUA);
% 
% % Calculate number in both classes
% AllPyr = sum(BasicNeuronInfo.neuroclass(BasicNeuronInfo.idx_SUA)>0);
% AllInt = sum(BasicNeuronInfo.neuroclass(BasicNeuronInfo.idx_SUA)<0);
% 
% %% Ripples
% %params
% samplingRate = round(1/median(diff(Range(dhPC_rip.LFP,'s'))));
% nBins = floor(samplingRate*diff(durations)/2)*2+1;
% 
% %events
% if size(r.ripples,2)>2
%     events_tmp = r.ripples(:,2);
% else
%     events_tmp = r.ripples;
% end
% %signals
% LFP_filt = FilterLFP(dhPC_rip.LFP,[120 220],1048);
% rg = Range(LFP_filt)/1e4;
% LFP_signal = [rg-rg(1) Data(LFP_filt)];
% 
% % Sync
% [r,i] = Sync(LFP_signal,events_tmp,'durations',durations);
% T = SyncMap(r,i,'durations',durations,'nbins',nBins,'smooth',0);
% 
% %nbin
% if size(T,2)>nBins
%     nBins=nBins+1;
% elseif size(T,2)<nBins
%     nBins=nBins-1;
% end
% 
% %result
% try
%     M=[((1:nBins)'-ceil(nBins/2))/nBins*diff(durations)' mean(T)' std(T)' stdError(T)'];
% catch
%     M=[];
%     disp('error')
% end

%% Behavior PreTests and PostTests
% Calculate average occupancy
% Mean and STD across 4 Pre- and PostTests
Pre_Occup_mean = mean(PreTest_occup,1);
Pre_Occup_std = std(PreTest_occup,1);
Post_Occup_mean = mean(PostTest_occup,1);
Post_Occup_std = std(PostTest_occup,1);
% Wilcoxon signed rank task between Pre and PostTest
p_pre_post = signrank(PreTest_occup(:,1),PostTest_occup(:,1));
% Prepare arrays for plotting
point_pre_post = [PreTest_occup(:,1) PostTest_occup(:,1)];

% Prepare the 'first enter to shock zone' array
for u = 1:ntest
    if isempty(PreTest_ZoneIndices{u}{1})
        Pre_FirstTime(u) = 240;
    else
        Pre_FirstZoneIndices(u) = PreTest_ZoneIndices{u}{1}(1);
        Pre_FirstTime(u) = PreTest_PosMat{u}(Pre_FirstZoneIndices(u),1);
    end
    
    if isempty(PostTest_ZoneIndices{u}{1})
        Post_FirstTime(u) = 240;
    else
        Post_FirstZoneIndices(u) = PostTest_ZoneIndices{u}{1}(1);
        Post_FirstTime(u) = PostTest_PosMat{u}(Post_FirstZoneIndices(u),1);
    end
    
    Pre_Post_FirstTime(u, 1:2) = [Pre_FirstTime(u) Post_FirstTime(u)];
end
    
Pre_Post_FirstTime_mean = mean(Pre_Post_FirstTime,1);
Pre_Post_FirstTime_std = std(Pre_Post_FirstTime,1);
p_FirstTime_pre_post = signrank(Pre_Post_FirstTime(:,1),Pre_Post_FirstTime(:,2));

% Calculate number of entries into the shock zone
% Check with smb if it's correct way to calculate (plus one entry even if one frame it was outside )
for m = 1:ntest
    if isempty(PreTest_ZoneIndices{m}{1})
        Pre_entnum(m) = 0;
    else
        Pre_entnum(m)=length(find(diff(PreTest_ZoneIndices{m}{1})>1))+1;
    end
    
    if isempty(PostTest_ZoneIndices{m}{1})
        Post_entnum(m)=0;
    else
        Post_entnum(m)=length(find(diff(PostTest_ZoneIndices{m}{1})>1))+1;
    end
  
end
Pre_Post_entnum = [Pre_entnum; Post_entnum]';
Pre_Post_entnum_mean = mean(Pre_Post_entnum,1);
Pre_Post_entnum_std = std(Pre_Post_entnum,1);
p_entnum_pre_post = signrank(Pre_entnum, Post_entnum);

% Calculate speed in the shock zone and in the noshock + shock vs everything else
% I skip the last point in ZoneIndices because length(Xtsd)=length(Vtsd)+1
for r=1:ntest
        % PreTest ShockZone speed
        if isempty(PreTest_ZoneIndices{r}{1})
            VZmean_pre(r) = 0;
        else
            if old
                Vtemp_pre{r} = tsd(Range(Pre_Vtsd{r}),(Data(Pre_Vtsd{r})./(diff(Range(Pre_Xtsd{r}))/1E4)));
            end
            Vtemp_pre{r}=Data(Vtemp_pre{r});
            VZone_pre{r}=Vtemp_pre{r}(PreTest_ZoneIndices{r}{1}(1:end-1),1);
            VZmean_pre(r)=mean(VZone_pre{r},1);
        end
        
        % PostTest ShockZone speed
        if isempty(PostTest_ZoneIndices{r}{1})
            VZmean_post(r) = 0;
        else
            if old
                Vtemp_post{r} = tsd(Range(Post_Vtsd{r}),(Data(Post_Vtsd{r})./(diff(Range(Post_Xtsd{r}))/1E4)));
            end
           Vtemp_post{r}=Data(Vtemp_post{r});
           VZone_post{r}=Vtemp_post{r}(PostTest_ZoneIndices{r}{1}(1:end-1),1);
           VZmean_post(r)=mean(VZone_post{r},1);
        end
        
end

Pre_Post_VZmean = [VZmean_pre; VZmean_post]';
Pre_Post_VZmean_mean = mean(Pre_Post_VZmean,1);
Pre_Post_VZmean_std = std(Pre_Post_VZmean,1);
p_VZmean_pre_post = signrank(VZmean_pre, VZmean_post);

%-------------------------------***************************************************---------------------------------------
%% Plot
fbilan = figure('units', 'normalized', 'outerposition', [0 0 1 1]);

% subplot(6,5,29)
% pieid  = pie([AllPyr AllInt]);
% legend ({'Principal cells', 'Interneurons'});
% pieid(1).FaceColor = [0 0.484 0.87];
% pieid(3).FaceColor = [0.85 0.094 0.082];
% title(['MUA/SUA = ', sprintf('%2i', num_MUA), '/', sprintf('%2i', num_SUA),...
%     ', N of PC = ', sprintf('%3i',AllPyr), ', N of Int = ', sprintf('%3i',AllInt)]);


%% Ripples from Day3 PostSleep
% 
% subplot(6,5,30)
% plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(T),'r','linewidth',2);
% title(['Ripples PostSleep (raw data) n=' num2str(size(events_tmp,1))])
% xlim(durations)

%% Sleep Scoring Day3 PostSleep
% 
% % Histogram of theta/delta ratio values
% subplot(5, 5, 3), hold on
% [~, rawN, ~] = nhist(log(Data(Restrict(SmoothTheta,Sleep))), 'maxx',max(log(Data(Restrict(SmoothTheta,Sleep)))), 'noerror', 'xlabel','Theta power', 'ylabel',[]); 
% axis xy,
% view(90,-90),
% line([log(Info.theta_thresh) log(Info.theta_thresh)],[0 max(rawN)],'linewidth',4,'color','r');
% set(gca,'YTick',[],'Xlim',ys);
% 
% % Histogram of gamma values
% subplot(5, 5, 58:60), hold on
% [~, rawN, ~] = nhist(log(Data(SmoothGamma)),'maxx',max(log(Data(SmoothGamma))),'noerror','xlabel','Gamma power','ylabel',[]);
% line([log(Info.gamma_thresh) log(Info.gamma_thresh)],[0 max(rawN)],'linewidth',4,'color','r');
% set(gca,'YTick',[],'Xlim',xs);

%% Pre
% Trajectories in PreTests
subplot(5,5,1)
imagesc(Pre_mask);
colormap(gray)
hold on
imagesc(Pre_Zone{1}, 'AlphaData', 0.3);
hold on
for p=1:1:ntest
    plot(PreTest_PosMat{p}(:,2)*Pre_Ratio_IMAonREAL,PreTest_PosMat{p}(:,3)*Pre_Ratio_IMAonREAL,...
        clrs{2,p},'linewidth',1)
    hold on
end
legend ('Test1','Test2','Test3','Test4', 'Location', 'NorthWest');
title ('Trajectories in PreTests');

% Behavior diagram in PreTests
subplot(5,5,6)
plot(Range(Pre_Imdifftsd,'s'), zeros(length(Pre_Imdifftsd), 1));
ylim([0 1]); 
hold on
for k=1:length(Start(Pre_FreezeAccEpoch))
	h1 = plot(Range(Restrict(Pre_Imdifftsd,subset(Pre_FreezeAccEpoch,k)),'s'),Data(Restrict(Pre_Imdifftsd,subset(Pre_FreezeAccEpoch,k)))...
        *0+max(ylim)*0.3,'c','linewidth',2);
end
for k=1:length(Start(Pre_ImmobEpoch))
	h2 = plot(Range(Restrict(Pre_Imdifftsd,subset(Pre_ImmobEpoch,k)),'s'),Data(Restrict(Pre_Imdifftsd,subset(Pre_ImmobEpoch,k)))...
        *0+max(ylim)*0.3,'m','linewidth',2);
end
for k=1:length(Start(Pre_LocomotionEpoch))
	h3 = plot(Range(Restrict(Pre_Imdifftsd,subset(Pre_LocomotionEpoch,k)),'s'),Data(Restrict(Pre_Imdifftsd,subset(Pre_LocomotionEpoch,k)))...
        *0+max(ylim)*0.3,'y','linewidth',2);
end
h4 = plot(Pre_PosMat(Pre_PosMat(:,4)==1,1),Pre_PosMat(Pre_PosMat(:,4)==1,1)*0+max(ylim)*0.5,'k*');
if exist('Pre_ZoneEpoch')
	for k=1:length(Start(Pre_ZoneEpoch{1}))
        h5 = plot(Range(Restrict(Pre_Imdifftsd,subset(Pre_ZoneEpoch{1},k)),'s'),Data(Restrict(Pre_Imdifftsd,subset(Pre_ZoneEpoch{1},k)))...
            *0+max(ylim)*0.65,'r','linewidth',2);
    end
	for k=1:length(Start(Pre_ZoneEpoch{2}))
        h6 = plot(Range(Restrict(Pre_Imdifftsd,subset(Pre_ZoneEpoch{2},k)),'s'),Data(Restrict(Pre_Imdifftsd,subset(Pre_ZoneEpoch{2},k)))...
            *0+max(ylim)*0.65,'g','linewidth',2);
	end
end
legend([h1 h2 h3 h4 h5 h6], 'Freezing', 'Immobility', 'Locomotion', 'Stims', 'Shock', 'NoShock', 'Location', 'NorthEast');
xlabel('Time (s)');
set(gca, 'YTickLabel', []);
title('Behavior diagram in PreTests');

%% Post

% Trajectories in PostTests
subplot(5,5,3)
imagesc(Post_mask);
colormap(gray)
hold on
imagesc(Post_Zone{1}, 'AlphaData', 0.3);
hold on
for l=1:1:ntest
    plot(PostTest_PosMat{l}(:,2)*Post_Ratio_IMAonREAL,PostTest_PosMat{l}(:,3)*Post_Ratio_IMAonREAL,...
        clrs{2,l},'linewidth',1)
    hold on
end
legend ('Test1','Test2','Test3','Test4', 'Location', 'NorthWest');
title ('Trajectories in PostTests');

% Behavior diagram in PostTests
subplot(5,5,8)
plot(Range(Post_Imdifftsd,'s'), zeros(length(Post_Imdifftsd), 1));
ylim([0 1]); 
hold on
for k=1:length(Start(Post_FreezeAccEpoch))
	h1 = plot(Range(Restrict(Post_Imdifftsd,subset(Post_FreezeAccEpoch,k)),'s'),Data(Restrict(Post_Imdifftsd,subset(Post_FreezeAccEpoch,k)))...
        *0+max(ylim)*0.3,'c','linewidth',2);
end
for k=1:length(Start(Post_ImmobEpoch))
	h2 = plot(Range(Restrict(Post_Imdifftsd,subset(Post_ImmobEpoch,k)),'s'),Data(Restrict(Post_Imdifftsd,subset(Post_ImmobEpoch,k)))...
        *0+max(ylim)*0.3,'m','linewidth',2);
end
for k=1:length(Start(Post_LocomotionEpoch))
	h3 = plot(Range(Restrict(Post_Imdifftsd,subset(Post_LocomotionEpoch,k)),'s'),Data(Restrict(Post_Imdifftsd,subset(Post_LocomotionEpoch,k)))...
        *0+max(ylim)*0.3,'y','linewidth',2);
end
h4 = plot(Post_PosMat(Post_PosMat(:,4)==1,1),Post_PosMat(Post_PosMat(:,4)==1,1)*0+max(ylim)*0.5,'k*');
if exist('Post_ZoneEpoch')
	for k=1:length(Start(Post_ZoneEpoch{1}))
        h5 = plot(Range(Restrict(Post_Imdifftsd,subset(Post_ZoneEpoch{1},k)),'s'),Data(Restrict(Post_Imdifftsd,subset(Post_ZoneEpoch{1},k)))...
            *0+max(ylim)*0.65,'r','linewidth',2);
    end
	for k=1:length(Start(Post_ZoneEpoch{2}))
        h6 = plot(Range(Restrict(Post_Imdifftsd,subset(Post_ZoneEpoch{2},k)),'s'),Data(Restrict(Post_Imdifftsd,subset(Post_ZoneEpoch{2},k)))...
            *0+max(ylim)*0.65,'g','linewidth',2);
	end
end
legend([h1 h2 h3 h4 h5 h6], 'Freezing', 'Immobility', 'Locomotion', 'Stims', 'Shock', 'NoShock', 'Location', 'NorthEast');
xlabel('Time (s)');
set(gca, 'YTickLabel', []);
title('Behavior diagram in PostTests');

%% Cond

StimT_beh = find(PosMat(:,4)==1);

subplot(5,5,2)
imagesc(mask)
colormap gray
hold on
imagesc(ShockZone, 'AlphaData', 0.3);
hold on
for i = 1:length(StimT_beh)
    plot(PosMat(StimT_beh(i),2)*Ratio_IMAonREAL, PosMat(StimT_beh(i),3)*Ratio_IMAonREAL, 'k*')
end
set(gca,'XTickLabel', [], 'YTickLabel', []);
title([num2str(length(StimT_beh)) ' stimulations'])
