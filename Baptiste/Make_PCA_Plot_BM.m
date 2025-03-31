



function [DIST_intra] = Make_PCA_Plot_BM(PC_values_x , PC_values_y , varargin)

% PC_values_x vector with PC values

for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'color'
            color = varargin{i+1}; % triplet RGB
    end
end

ind = and(~isnan(PC_values_x) , ~isnan(PC_values_y));
Bar = [nanmedian(PC_values_x(ind)) nanmedian(PC_values_y(ind))];

plot(PC_values_x(ind) , PC_values_y(ind),'.','MarkerSize',10,'Color',color), hold on
for mouse=1:length(PC_values_x)
    line([Bar(1) PC_values_x(mouse)],[Bar(2) PC_values_y(mouse)],'LineStyle','--','Color',color)
    DIST_intra(mouse) = sqrt((Bar(1)-PC_values_x(mouse))^2+(Bar(2)-PC_values_x(mouse))^2);
end
plot(Bar(1),Bar(2),'.','MarkerSize',30,'Color',color)
axis square





