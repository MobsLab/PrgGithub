z = 1;
NumGrid = 10;
clf
% [Z,X,Y] = hist2d(PC_values_shock{z} , PC_values_shock{z+1},NumGrid,NumGrid);
% Z = smooth2a(Z,SmoothingFact,SmoothingFact);
% Z = Z/max(Z(:));
% hAx=axes;
% [~,hC]=contour(X,Y,Z,10);             % put first contour on it; keep object handle
% hC.LineWidth = 2
% xlim([-6 6])                            % have to reset the limit; could linkaxes???
% colormap(hAx,"hot")                    % and arbitrary colormap
% pos=hAx.Position;                       % the present axes position
% hold  on
% hAx(2)=axes('position',hAx(1).Position,'color','none',"XTick",[],'YTick',[]);
% linkaxes(hAx,'x')    % This will tie the two axes x axis limits/sizes together
% hold(hAx(2),'on')    % HERE'S the key piece I inadvertently left out before...
% [Z,X,Y] = hist2d(PC_values_safe{z} , PC_values_safe{z+1},NumGrid,NumGrid);
% Z = smooth2a(Z,SmoothingFact,SmoothingFact);
% Z = Z/max(Z(:));
% [~,hC(2)]=contour(hAx(2),X,Y,Z,10);   % SO, the 2nd verse on contour w/o HOLD ON reset the axes...
% colormap(hAx(2),"cool")                  % different colormap this axes
% hC(2).LineWidth = 2


 plot(PC_values_shock{z} , PC_values_shock{z+1},'.','MarkerSize',20,'Color',[1 .5 .5])
    hold on
    plot(PC_values_safe{z} , PC_values_safe{z+1},'.','MarkerSize',20,'Color',[.5 .5 1])


clear ind
for states=1:5
    if states==1
        PC_values = PC_values_shock;
    elseif states==2
        PC_values = PC_values_safe;
    elseif states==3
        PC_values = PC_values_active;
    elseif states==4
        PC_values = PC_values_quiet;
    elseif states==5
        PC_values = PC_values_sleep;
    end
    
    ind{states} = and(~isnan(PC_values{z}) , ~isnan(PC_values{z+1}));
    Bar_st = [nanmean(PC_values{z}) nanmean(PC_values{z+1})];
    Q1_st(1) = quantile(PC_values{z},.25); Q1_st(2) = quantile(PC_values{z},.75);
    Q2_st(1) = quantile(PC_values{z+1},.25); Q2_st(2) = quantile(PC_values{z+1},.75);
    
    plot(Bar_st(1),Bar_st(2),'.','MarkerSize',50,'Color',Cols{states}), hold on
    line(Q1_st,[Bar_st(2) Bar_st(2)],'Color',Cols{states},'LineWidth',3)
    line([Bar_st(1) Bar_st(1)],Q2_st,'Color',Cols{states},'LineWidth',3)
    axis square
    xlabel(['PC' num2str(z) ' value']), ylabel(['PC' num2str(z+1) ' value'])
    
end
