%%% FigureAverage_PAGTest

clear all
%% Parameters

% General
sav=0; % Do you want to save a figure?
dir_out = '/home/mobs/Dropbox/MOBS_workingON/Sam/PAGTests/'; % Where?
fig_post = 'AverageAllMice'; % Name of the output file

Avoidance = 1; % do you have data for avoidance UMaze protocol?
h24 = 0; % Do you have data for h24 later

 % input folder
indir = {
    '/media/mobs/DataMOBS85/PAG tests/M784/';
    '/media/mobs/DataMOBS85/PAG tests/M784/';
    '/media/mobs/DataMOBS85/PAG tests/M789/';
    '/media/mobs/DataMOBS85/PAG tests/M789/';
    '/media/mobs/DataMOBS85/PAG tests/M790/';
    '/media/mobs/DataMOBS85/PAG tests/M791/';
    '/media/mobs/DataMOBS85/PAG tests/M792/';
    '/media/mobs/DataMOBS85/PAG tests/M792/'  
};
ntest = 4;
Day3 = {
    '20092018';
    '19092018';
    '19092018';
    '20092018';
    '19092018';
    '20092018';
    '20092018';
    '19092018'
    };

Day4 = {
    '22092018';
    '21092018';
    '21092018';
    '21092018';
    '21092018';
    '22092018';
    '22092018';
    '21092018'
    };

elec = {'AnteriorStim','PosteriorStim'};
ielec = [1 2 1 2 2 1 1 2];
supertit = 'All locations - PAGTest';

suf = {'TestPre'; 'Cond'; 'TestPost'};
sufDir = {'Pretests'; 'Cond'; 'Post48h'};
suf = {'pre'; 'Cond'; 'post48h'};

clrs = {'ko', 'bo', 'ro','go'; 'k','b', 'r', 'g'; 'kp', 'bp', 'rp', 'gp'};

%%
for j = 1:length(indir)

    %% Get the data Avodance
    for i = 1:1:ntest
        if Avoidance
            % PreTests
            a{j} = load([indir{j} Day3{j} '/' elec{ielec(j)} '/' sufDir{1} '/' suf{1} num2str(i) '/behavResources.mat'],...
                'Occup', 'PosMat','Xtsd', 'Ytsd', 'Vtsd', 'ZoneIndices');
            Pre_Xtsd{j}{i} = a{j}.Xtsd;
            Pre_Ytsd{j}{i} = a{j}.Ytsd;
            Pre_Vtsd{j}{i} = a{j}.Vtsd;
            PreTest_PosMat{j}{i} = a{j}.PosMat;
            PreTest_occup{j}(i,1:7) = a{j}.Occup;
            PreTest_ZoneIndices{j}{i} = a{j}.ZoneIndices;
            % Cond
            if (~(j==6) || i<4)
                b{j} = load([indir{j} Day3{j} '/' elec{ielec(j)} '/' sufDir{2} '/' suf{2} num2str(i) '/behavResources.mat'],...
                        'Occup', 'PosMat','Xtsd', 'Ytsd', 'Vtsd', 'ZoneIndices');

                Cond_Xtsd{j}{i} = b{j}.Xtsd;
                Cond_Ytsd{j}{i} = b{j}.Ytsd;
                Cond_Vtsd{j}{i} = b{j}.Vtsd;
                Cond_PosMat{j}{i} = b{j}.PosMat;
                Cond_occup{j}(i,1:7) = b{j}.Occup;
                Cond_ZoneIndices{j}{i} = b{j}.ZoneIndices;
            end
            % PostTests
            try 
                c{j} = load([indir{j} Day4{j} '/' elec{ielec(j)} '/' sufDir{3} '/' suf{3} num2str(i) '/behavResources.mat'],...
                    'Occup', 'PosMat','Xtsd', 'Ytsd', 'Vtsd', 'ZoneIndices');
            catch
                c{j} = load([indir{j} Day4{j} '/' elec{ielec(j)} '/Post24h/post24h' num2str(i) '/behavResources.mat'],...
                    'Occup', 'PosMat','Xtsd', 'Ytsd', 'Vtsd', 'ZoneIndices');
            end
            Post_Xtsd{j}{i} = c{j}.Xtsd;
            Post_Ytsd{j}{i} = c{j}.Ytsd;
            Post_Vtsd{j}{i} = c{j}.Vtsd;
            PostTest_PosMat{j}{i} = c{j}.PosMat;
            PostTest_occup{j}(i,1:7) = c{j}.Occup;
            PostTest_ZoneIndices{j}{i} = c{j}.ZoneIndices;
        end
    end
    
    
    %% Get stimulation idxs for conditioning sessions
    if Avoidance
        if ~(j==6)
            for i=1:ntest
                StimT_beh{j}{i} = find(Cond_PosMat{j}{i}(:,4)==1);
            end
        else
            for i=1:3
                StimT_beh{j}{i} = find(Cond_PosMat{j}{i}(:,4)==1);
            end
        end
    end

    %% Calculate average occupancy
    % Mean and STD across 4 Pre- and PostTests
    if Avoidance
        PreTest_occup{j} = PreTest_occup{j}*100;
        PostTest_occup{j} = PostTest_occup{j}*100;
    end
    if h24
        Post24_occup{j} = Post24_occup{j}*100;
    end

    if Avoidance
        Pre_Occup_mean(j,1:7) = mean(PreTest_occup{j},1);
        Pre_Occup_std(j,1:7) = std(PreTest_occup{j},1);
        Post_Occup_mean(j,1:7) = mean(PostTest_occup{j},1);
        Post_Occup_std(j,1:7) = std(PostTest_occup{j},1);
       
    end
    if h24
        Post24_Occup_mean(j,1:7) = mean(Post24_occup{j},1);
        Post24_Occup_std(j,1:7) = std(Post24_occup{j},1);
    end


    %% Prepare the 'first enter to shock zone' array
    for u = 1:ntest
        if Avoidance
            if isempty(PreTest_ZoneIndices{j}{u}{1})
                Pre_FirstTime{j}(u) = 240;
            else
                Pre_FirstZoneIndices{j}(u) = PreTest_ZoneIndices{j}{u}{1}(1);
                Pre_FirstTime{j}(u) = PreTest_PosMat{j}{u}(Pre_FirstZoneIndices{j}(u),1);
            end

            if isempty(PostTest_ZoneIndices{j}{u}{1})
                Post_FirstTime{j}(u) = 240;
            else
                Post_FirstZoneIndices{j}(u) = PostTest_ZoneIndices{j}{u}{1}(1);
                Post_FirstTime{j}(u) = PostTest_PosMat{j}{u}(Post_FirstZoneIndices{j}(u),1);
            end
        end

        if h24
            if isempty(Post24_ZoneIndices{j}{u}{1})
                Post24_FirstTime{j}(u) = 240;
            else
                Post24_FirstZoneIndices{j}(u) = Post24_ZoneIndices{j}{u}{1}(1);
                Post24_FirstTime{j}(u) = Post24_PosMat{j}{u}(Post24_FirstZoneIndices{j}(u),1);
            end
        end

        if Avoidance
            Pre_Post_FirstTime{j}(u, 1:2) = [Pre_FirstTime{j}(u) Post_FirstTime{j}(u)];
        end
        if h24
            Pre_Post24_FirstTime{j}(u, 1:2) = [Pre_FirstTime{j}(u) Post24_FirstTime{j}(u)];
        end

    end

    if Avoidance
        Pre_Post_FirstTime_mean(j,1:2) = mean(Pre_Post_FirstTime{j},1);
        Pre_Post_FirstTime_std(j,1:2) = std(Pre_Post_FirstTime{j},1);
    end
    if h24
        Pre_Post24_FirstTime_mean(j,1:2) = mean(Pre_Post24_FirstTime{j},1);
        Pre_Post24_FirstTime_std(j,1:2) = std(Pre_Post24_FirstTime{j},1);
    end

    %% Calculate number of entries into the shock zone
    % Check with smb if it's correct way to calculate (plus one entry even if one frame it was outside )
    for m = 1:ntest
        if Avoidance
            if isempty(PreTest_ZoneIndices{j}{m}{1})
                Pre_entnum{j}(m) = 0;
            else
                Pre_entnum{j}(m)=length(find(diff(PreTest_ZoneIndices{j}{m}{1})>1))+1;
            end

            if isempty(PostTest_ZoneIndices{j}{m}{1})
                Post_entnum{j}(m)=0;
            else
                Post_entnum{j}(m)=length(find(diff(PostTest_ZoneIndices{j}{m}{1})>1))+1;
            end
        end

        if h24
            if isempty(Post24_ZoneIndices{j}{m}{1})
                Post24_entnum{j}(m)=0;
            else
                Post24_entnum{j}(m)=length(find(diff(Post24_ZoneIndices{j}{m}{1})>1))+1;
            end
        end

    end

    if Avoidance
        Pre_Post_entnum{j} = [Pre_entnum{j}; Post_entnum{j}]';
        Pre_Post_entnum_mean(j,1:2) = mean(Pre_Post_entnum{j},1);
        Pre_Post_entnum_std(j,1:2) = std(Pre_Post_entnum{j},1);
    end

    if h24
        Pre_Post24_entnum{j} = [Pre_entnum{j}; Post24_entnum{j}]';
        Pre_Post24_entnum_mean(j,1:2) = mean(Pre_Post24_entnum{j},1);
        Pre_Post24_entnum_std(j,1:2) = std(Pre_Post24_entnum{j},1);
    end

    %% Calculate speed in the shock zone and in the noshock + shock vs everything else
    % I skip the last point in ZoneIndices because length(Xtsd)=length(Vtsd)+1
    for r=1:ntest
        if Avoidance
            % PreTest ShockZone speed
                if isempty(PreTest_ZoneIndices{j}{r}{1})
                    VZmean_pre{j}(r) = 0;
                else
                    Vtemp_pre{j}{r}=Data(Pre_Vtsd{j}{r});
                    VZone_pre{j}{r}=Vtemp_pre{j}{r}(PreTest_ZoneIndices{j}{r}{1}(1:end-1),1);
                    VZmean_pre{j}(r)=mean(VZone_pre{j}{r},1);
                end

                % PostTest ShockZone speed
                if isempty(PostTest_ZoneIndices{j}{r}{1})
                    VZmean_post{j}(r) = 0;
                else
                    Vtemp_post{j}{r}=Data(Post_Vtsd{j}{r});
                    VZone_post{j}{r}=Vtemp_post{j}{r}(PostTest_ZoneIndices{j}{r}{1}(1:end-1),1);
                    VZmean_post{j}(r)=mean(VZone_post{j}{r},1);
                end
        end

        if h24
            % PostTesth24 ShockZone speed
            if isempty(Post24_ZoneIndices{j}{r}{1})
                VZmean_post24{j}(r) = 0;
            else
                Vtemp_post24{j}{r}=Data(Post24_Vtsd{j}{r});
                VZone_post24{j}{r}=Vtemp_post24{j}{r}(Post24_ZoneIndices{j}{r}{1}(1:end-1),1);
                VZmean_post24{j}(r)=mean(VZone_post24{j}{r},1);
            end
        end

    end

    if Avoidance
        Pre_Post_VZmean{j} = [VZmean_pre{j}; VZmean_post{j}]';
        Pre_Post_VZmean_mean(j,1:2) = mean(Pre_Post_VZmean{j},1);
        Pre_Post_VZmean_std(j,1:2) = std(Pre_Post_VZmean{j},1);
    end

    if h24
        Pre_Post24_VZmean{j} = [VZmean_pre{j}; VZmean_post24{j}]';
        Pre_Post24_VZmean_mean(j,1:2) = mean(Pre_Post24_VZmean{j},1);
        Pre_Post24_VZmean_std(j,1:2) = std(Pre_Post24_VZmean{j},1);
    end


end

%% Calculate stats

[h_occup pval_occup] = ttest2(Pre_Occup_mean(:,1),Post_Occup_mean(:,1));


%% Plot a figure
fh = figure('units', 'normalized', 'outerposition', [0 0 0.6 0.6]);

% Occupancy
subplot(221)
PlotErrorBarN_KJ([Pre_Occup_mean(:,1) Post_Occup_mean(:,1)], 'barcolors', [0.3 0.266 0.613], 'newfig', 0);
set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
ylabel('% time spent in ShockZone');
title('Percentage of occupancy');

subplot(222)
PlotErrorBarN_KJ(Pre_Post_entnum_mean, 'barcolors', [0.3 0.266 0.613], 'newfig', 0);
set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
ylabel('Number of entries');
title('# of entries to the shockzone');

subplot(223)
PlotErrorBarN_KJ(Pre_Post_FirstTime_mean, 'barcolors', [0.3 0.266 0.613], 'newfig', 0);
set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
ylabel('Time (s)');
title('First time to enter the shockzone');

subplot(224)
PlotErrorBarN_KJ(Pre_Post_VZmean_mean, 'barcolors', [0.3 0.266 0.613], 'newfig', 0);
set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
ylabel('Average speed (cm/s)');
title('Average speed');

%% Supertitle
mtit(fh,supertit, 'fontsize',14, 'xoff', 0, 'yoff', 0.03);

%% Save
if sav
    saveas(gcf, [dir_out fig_post '.fig']);
    saveFigure(gcf,fig_post,dir_out);
end

