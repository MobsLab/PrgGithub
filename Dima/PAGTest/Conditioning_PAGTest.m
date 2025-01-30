%% Conditioning_PAGTest

try
   dirin;
catch
   dirin={
       '/media/mobsrick/DataMOBS87/Mouse-783/11092018/Cond/';
       '/media/mobsrick/DataMOBS87/Mouse-785/11092018/Cond/';
       '/media/mobsrick/DataMOBS87/Mouse-785/12092018/Cond/';
       '/media/mobsrick/DataMOBS87/Mouse-786/10092018/Cond/';
       '/media/mobsrick/DataMOBS87/Mouse-786/12092018/Cond/';
       '/media/mobsrick/DataMOBS87/Mouse-787/11092018/Cond/';
       '/media/mobsrick/DataMOBS87/Mouse-787/12092018/Cond/';
       '/media/mobsrick/DataMOBS87/Mouse-788/10092018/Cond/';
       };
end


%% Load Data
for i=1:length(dirin)
    dat{i} = load([dirin{i} 'behavResources.mat'], 'PosMat','mask', 'ZoneEpoch', 'Zone', 'Ratio_IMAonREAL', 'Imdifftsd',...
        'FreezeAccEpoch', 'TTLInfo');
end


%% Plot
fbilan = figure('units','normalized','outerposition',[0 0 1 1]);

for i=1:length(dirin)
    %% Number and place of stimulations

    StimT_beh{i} = find(dat{i}.PosMat(:,4)==1);
    
    if i == 1 % M783post
        subplot(8,5,1)
    elseif i == 2 % M785ant
        subplot(8,5,6)
    elseif i == 3 % M785post
        subplot(8,5,11)
    elseif i == 4 % M786post
        subplot(8,5,16)
    elseif i == 5 % M786ant
        subplot(8,5,21)
    elseif i == 6 % M787post
        subplot(8,5,26)
    elseif i == 7 % M787ant
        subplot(8,5,31)
    elseif i == 8 % M788ant
        subplot(8,5,36)
    end
    imagesc(dat{i}.mask)
    colormap gray
    hold on
    imagesc(dat{i}.Zone{1}, 'AlphaData', 0.3);
    hold on
    for j = 1:length(StimT_beh{i})
        plot(dat{i}.PosMat(StimT_beh{i}(j),2)*dat{i}.Ratio_IMAonREAL, dat{i}.PosMat(StimT_beh{i}(j),3)*dat{i}.Ratio_IMAonREAL, 'k*')
    end
    set(gca,'XTickLabel', [], 'YTickLabel', []);
    if i == 1 % M783ant
        title([num2str(length(StimT_beh{i})) ' stimulations'])
    elseif i == 2 % M785ant
        title([num2str(length(StimT_beh{i})) ' stimulations'])
    elseif i == 3 % M785post
        title([num2str(length(StimT_beh{i})) ' stimulations'])
    elseif i == 4 % M786post
        title([num2str(length(StimT_beh{i})) ' stimulations'])
    elseif i == 5 % M786ant
        title([num2str(length(StimT_beh{i})) ' stimulations'])
    elseif i == 6 % M787post
        title([num2str(length(StimT_beh{i})) ' stimulations'])
    elseif i == 7 % M787ant
        title([num2str(length(StimT_beh{i})) ' stimulations'])
    elseif i == 8 % M788post
        title([num2str(length(StimT_beh{i})) ' stimulations'])
    end
    
    
    %% Stimulation-induced freezing
    if isempty(Start(dat{i}.TTLInfo.StimEpoch))
        if i == 1 % M783post
            subplot(8,5,2:5)
        elseif i == 2 % M785ant
            subplot(8,5,7:10)
        elseif i == 3 % M785post
            subplot(5,4,12:15)
        elseif i == 4 % M786post
            subplot(5,4,17:20)
        elseif i == 5 % M786ant
            subplot(5,4,22:25)
        elseif i == 6 % M787post
            subplot(5,4,27:30)
        elseif i == 7 % M787ant
            subplot(5,4,32:35)
        elseif i == 8 % M788ant
            subplot(5,4,37:40)
        end
        text(0.4, 0.4, 'No stimulations','FontWeight', 'bold','FontSize',14);
    else
        if i == 1 % M783post
            subplot(8,5,2:5)
        elseif i == 2 % M785ant
            subplot(8,5,7:10)
        elseif i == 3 % M785post
            subplot(8,5,12:15)
        elseif i == 4 % M786post
            subplot(8,5,17:20)
        elseif i == 5 % M786ant
            subplot(8,5,22:25)
        elseif i == 6 % M787post
            subplot(8,5,27:30)
        elseif i == 7 % M787ant
            subplot(8,5,32:35)
        elseif i == 8 % M788ant
            subplot(8,5,37:40)
        end
        plot(Range(dat{i}.Imdifftsd,'s'), zeros(length(dat{i}.Imdifftsd), 1));
        ylim([0 1]); 
        hold on
        for k=1:length(Start(dat{i}.FreezeAccEpoch))
            h1 = plot(Range(Restrict(dat{i}.Imdifftsd,subset(dat{i}.FreezeAccEpoch,k)),'s'),...
                Data(Restrict(dat{i}.Imdifftsd,subset(dat{i}.FreezeAccEpoch,k)))*0+max(ylim)*0.65,'c','linewidth',2);
        end
        h2 = plot(dat{i}.PosMat(dat{i}.PosMat(:,4)==1,1),dat{i}.PosMat(dat{i}.PosMat(:,4)==1,1)*0+max(ylim)*0.75,'k*');
        for k=1:length(Start(dat{i}.ZoneEpoch{1}))
            h3 = plot(Range(Restrict(dat{i}.Imdifftsd,subset(dat{i}.ZoneEpoch{1},k)),'s'),...
                Data(Restrict(dat{i}.Imdifftsd,subset(dat{i}.ZoneEpoch{1},k)))...
                *0+max(ylim)*0.9,'r','linewidth',2);
        end
        for k=1:length(Start(dat{i}.ZoneEpoch{2}))
            h4 = plot(Range(Restrict(dat{i}.Imdifftsd,subset(dat{i}.ZoneEpoch{2},k)),'s'),...
                Data(Restrict(dat{i}.Imdifftsd,subset(dat{i}.ZoneEpoch{2},k)))...
                *0+max(ylim)*0.9,'g','linewidth',2);
        end
        set(gca, 'YTickLabel', []);
        
        if i == 1 % M783ant
            title('Mouse 783 - ??dlPAGant')
        elseif i == 2 % M785ant
            title('Mouse 785 - ??dlPAGant')
        elseif i == 3 % M785post
            title('Mouse 785 - ??dlPAGpost')
        elseif i == 4 % M786post
            title('Mouse 786 - ??vlPAGpost')
        elseif i == 5 % M786ant
            title('Mouse 786 - ??vlPAGant')
        elseif i == 6 % M787post
            title('Mouse 787 - ??vlPAGpost')
        elseif i == 7 % M787ant
            title('Mouse 787 - ??vlPAGant')
        elseif i == 8 % M788post
            title('Mouse 788 - ??dmPAGant')
        end
        
        if i ==8
            legend([h1 h2 h3 h4], 'Freezing', 'Stims', 'Shock', 'NoShock', 'Location', 'SouthEast');
            xlabel('Time (s)');
        end

    end
end
tightfig(fbilan);
set(fbilan, 'units','normalized','outerposition',[0 0 1 1]);

saveas(fbilan, '/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/PAGTest/ConditioningEffect.fig');
saveFigure(fbilan,'ConditioningEffect','/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/PAGTest/');