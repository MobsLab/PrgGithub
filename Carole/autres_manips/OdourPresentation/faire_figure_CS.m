% FIGURE 5 - Occupancy % per section - AVERAGE
supertit = 'Percentage of occupancy by section of U-Maze';
figure('Color',[1 1 1], 'rend','painters','pos',[10 10 1400 700],'Name',supertit, 'NumberTitle','off')
    si = 0;
%     for s=1:6
%         if ~(s==5)
%             subplot(2,3,s)
%             PlotErrorBarN_KJ(mocc(1:6,sect_order(s))', 'barcolors', [0.3 0.266 0.613], 'newfig', 0);
%             ylim([0 0.35])
%             set(gca,'Xtick',[1:1:6]);
%             xlabel('Sessions number');
%             ylabel('% time spent in zone');
%             title(sect_name{s})
%         end
%     end

    % Supertitle
    mtit(supertit, 'fontsize',14, 'xoff', 0, 'yoff', 0.03);

    % script name at bottom
    AddScriptName

    %save
    if sav
        print([dirout 'Behav_Occup_all'], '-dpng', '-r300');
    end  