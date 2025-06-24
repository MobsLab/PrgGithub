function fig_4_OB_ferret_paper(allPValues, allCorrelations, allPupilSizes)

%%



%% pupil distributions across states

for sess = 1:size(allPValues, 2)
    for epoch = 1:size(allPValues, 3)
        D{sess, epoch} = Data(allPupilSizes(sess, epoch));
        data_mean_pupil(sess, epoch) = nanmean(D{sess, epoch}, 1);
        h{epoch}=histogram(D{sess, epoch},'NumBins',200);
        HistData(sess,epoch,:) = h{epoch}.Values./sum(h{epoch}.Values);
    end
end

figure
cols = {'-b', '-r', '-g'};
    i = 1;

for epoch = [2 4 7]
    hold on
    Data_to_use = squeeze(HistData(:, epoch, :));
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    shadedErrorBar(linspace(-2,4,200), runmean(nanmean(Data_to_use),3) , runmean(Conf_Inter,3) ,cols{i},1); hold on;
    % ylim([0 .045])
    xlabel('Pupil size (zscore)'), ylabel('PDF')
    makepretty
    i = i + 1;
end

FigFolder = '/home/mobsrick/Documents/temp_Arsenii/paper_fig_4';
saveas(gcf, fullfile(FigFolder, ['pupil_size_distribution_' Dirs_names{selection} '.svg']));
saveas(gcf, fullfile(FigFolder, ['pupil_size_distribution_' Dirs_names{selection} '.png']));

%% box-plots: pupil size across states
Cols = {[0 0 1],[1 0 0],[0 1 0]};
X = 1:3;
Legends = {'Wake','NREM','REM'};
figure
clf
MakeSpreadAndBoxPlot3_SB({data_mean_pupil(:, 2) data_mean_pupil(:, 3) data_mean_pupil(:, 7)},Cols,X,Legends,'showpoints',1,'paired',0);

saveas(gcf, fullfile(FigFolder, ['pupil_size_distribution_box' Dirs_names{selection} '.svg']));
saveas(gcf, fullfile(FigFolder, ['pupil_size_distribution_box' Dirs_names{selection} '.png']));

%% Imagesc correlation OB gamma vs pupil size
figure
sgtitle(['Pupil size vs OB gamma correlation in ' num2str(size(OccupMaps, 1)) ' sessions'], 'FontWeight', 'bold')
colormap viridis
i = 1;
for epoch = [1 2 4 7] %1:size(OccupMaps, 2)
%     subplot(2,4,i)
    subplot(1,4,i)
    
    OccupMap_temp{epoch} = squeeze(OccupMaps(:, epoch, :, :));
    OccupMap_temp{epoch} = OccupMap_temp{epoch}./sum(sum(OccupMap_temp{epoch},3),2);
    imagesc(linspace(-2,3,100) , linspace(-2,2,100) , runmean(runmean(squeeze(nanmean(OccupMap_temp{epoch}))',2)',2)'), axis xy
    axis square, xlabel('pupil size (zscore)'), ylabel('OB gamma (zscore)')
    title(Epoch_names{epoch})
    i = i +1;
    makepretty
end

saveas(gcf, fullfile(FigFolder, ['imagesc_pupil_gamma_corr' Dirs_names{selection} '.svg']));
saveas(gcf, fullfile(FigFolder, ['imagesc_pupil_gamma_corr' Dirs_names{selection} '.png']));

%% box-plots: correlation OB gamma vs pupil size in different states
clear r
for region = 1:size(allPValues, 1)
    for session = 1:size(allPValues, 2)
        for epoch = 1:size(allPValues, 3)
            if allPValues(region, session, epoch) <= 0.05
                r(region, session, epoch) = allCorrelations(region, session, epoch);
            else
                r(region, session, epoch) = nan;
            end
        end
    end
end

Cols = {[.3 .3 .3],[0 0 1],[1 0 0],[0 1 0]};
X = 1:4;
Legends = {'All','Wake','NREM','REM'};
brain_signals_names = {'OB Gamma', 'OB 0.1-0.5Hz', 'HPC Theta/Delta', 'HPC Gamma', 'PFC Gamma', 'ACx Gamma'};

for region = 1:size(allCorrelations, 1)
    figure
    MakeSpreadAndBoxPlot3_SB({r(region, :, 1) r(region,  :, 2) r(region, :, 3) r(region, :, 7)},Cols,X,Legends,'showpoints',1,'paired',0);
    title(brain_signals_names{region})
    ylim([-0.5 1.5])
    hline([ 0 0])
end

saveas(gcf, fullfile(FigFolder, ['pupil_OB_gamma_corr' Dirs_names{selection} '.svg']));
saveas(gcf, fullfile(FigFolder, ['pupil_OB_gamma_corr' Dirs_names{selection} '.png']));

saveas(gcf, fullfile(FigFolder, ['pupil_OB_0105_corr' Dirs_names{selection} '.svg']));
saveas(gcf, fullfile(FigFolder, ['pupil_OB_0105_corr' Dirs_names{selection} '.png']));

saveas(gcf, fullfile(FigFolder, ['pupil_HPC_gamma_corr' Dirs_names{selection} '.svg']));
saveas(gcf, fullfile(FigFolder, ['pupil_HPC_gamma_corr' Dirs_names{selection} '.png']));

saveas(gcf, fullfile(FigFolder, ['pupil_PFC_gamma_corr' Dirs_names{selection} '.svg']));
saveas(gcf, fullfile(FigFolder, ['pupil_PFC_gamma_corr' Dirs_names{selection} '.png']));

saveas(gcf, fullfile(FigFolder, ['pupil_ACx_gamma_corr' Dirs_names{selection} '.svg']));
saveas(gcf, fullfile(FigFolder, ['pupil_ACx_gamma_corr' Dirs_names{selection} '.png']));

%% box-plots: OB correlation versus other brain regions

colors = viridis(4);
Cols = arrayfun(@(i) colors(i,:), 1:size(colors,1), 'UniformOutput', false);X = 1:4;
Legends = {'OB','HPC','PFC','ACx'};

for epochs = [1 2 4 7]
    figure
    MakeSpreadAndBoxPlot3_SB({r(1, :, epochs) r(4,  :, epochs) r(5, :, epochs) r(6, :, 7)},Cols,X,Legends,'showpoints',1,'paired',0);
    title(Epoch_names{epochs})
    ylim([-0.5 1.5])
    hline([ 0 0])
end

saveas(gcf, fullfile(FigFolder, ['pupil_gamma_corr_full' Dirs_names{selection} '.svg']));
saveas(gcf, fullfile(FigFolder, ['pupil_gamma_corr_full' Dirs_names{selection} '.png']));

saveas(gcf, fullfile(FigFolder, ['pupil_gamma_corr_wake' Dirs_names{selection} '.svg']));
saveas(gcf, fullfile(FigFolder, ['pupil_gamma_corr_wake' Dirs_names{selection} '.png']));

saveas(gcf, fullfile(FigFolder, ['pupil_gamma_corr_NREM' Dirs_names{selection} '.svg']));
saveas(gcf, fullfile(FigFolder, ['pupil_gamma_corr_NREM' Dirs_names{selection} '.png']));

saveas(gcf, fullfile(FigFolder, ['pupil_gamma_corr_REM' Dirs_names{selection} '.svg']));
saveas(gcf, fullfile(FigFolder, ['pupil_gamma_corr_REM' Dirs_names{selection} '.png']));

%% Example evolution trace
example = {
    '/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230208' ,...
    '/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230225',...
    '/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230227',...
    '/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230303',...
    '/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230307' ,...
    '/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230308' ,...
    '/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230323' ,...
    '/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230504_2' ,...
    '/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230508_3' ,...
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241126_yves_train',...
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241128_yves_train',...
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241129_yves_test',...
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241204_TORCs',...
    '/media/nas7/React_Passive_AG/OBG/Brynza/head-fixed/20240126' ,...
    '/media/nas7/React_Passive_AG/OBG/Brynza/head-fixed/20240129' ,...
    '/media/nas7/React_Passive_AG/OBG/Brynza/head-fixed/20240204' ,...
    '/media/nas7/React_Passive_AG/OBG/Brynza/head-fixed/20240308' ,...
    };
example = example';
% keepIdx = ~ismember(session_dlc, example);
% session_dlc = session_dlc(keepIdx);

atropine = {
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241220_TORCs_atropine',...
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241231_TORCs_atropine',...
    };
atropine = atropine';

smootime_pupil = 10;
smootime_gamma = 10;

for sess = 1:length(atropine)
    datapath = atropine{sess};
    [~, name, ~] = fileparts(datapath);
    if contains(datapath, 'Shropshire')
        ferret = 'Shropshire';
    elseif contains(datapath, 'Brynza')
        ferret = 'Brynza';
    elseif contains(datapath, 'Labneh')
        ferret = 'Labneh';
    end
    
    load(fullfile(datapath, 'SleepScoring_OBGamma.mat'), 'SmoothGamma')
    load(fullfile(datapath, 'DLC', 'DLC_data.mat'), 'areas_pupil')
    
    clear f1
    f1 = figure('Color','w','Units','normalized','Position',[0 0 1 1],'Visible', 'on');
    
    timeline = Range(areas_pupil,'min');
    
    clear D
    D = zscore(Data(areas_pupil));
    D(movstd(D,10)>.5) = NaN;
    clear G
    G = zscore(Data(Restrict(SmoothGamma,areas_pupil)));
    G(movstd(G,10)>.2) = NaN;

    subplot(312)
    hold on
    plot(timeline, movmean(G,ceil(smootime_gamma/median(diff(Range(areas_pupil,'s')))),'omitnan')-1, 'color', colors(1, :))
    plot(timeline, movmean(D,ceil(smootime_pupil/median(diff(Range(areas_pupil,'s')))),'omitnan'), 'color', colors(3, :))

    xlim([timeline(1) timeline(end)])
    xlabel('Time (min)')
    legend({'OB Gamma' 'Pupil size'})
    makepretty
    title([ferret ' ' name])
    
    saveas(f1, fullfile(FigFolder, ['example_evolution_gamma_pupil_' ferret '_' name '.svg']));
    saveas(f1, fullfile(FigFolder, ['example_evolution_gamma_pupil_' ferret '_' name '.png']));
end

%%

end
