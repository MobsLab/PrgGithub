function [Thigmotaxis, distances, ZoneEpoch_Inner, ZoneEpoch_Outer, ZoneEpoch_Specific] = Thigmotaxis_OF_CH(Xtsd , Ytsd, arena_type, varargin)

% Example
% [Thigmotaxis, ZoneEpoch_Inner, ZoneEpoch_Outer, ZoneEpoch_Specific] = Thigmotaxis_OF_CH(AlignedXtsd, AlignedYtsd, 'OF', 'percent_inner', 0.7, 'ring', [20 25]);

for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch lower(varargin{i})
        case 'figure'
            figure_flag = varargin{i+1};
        case 'percent_inner'
            percent_inner = varargin{i+1};
        case 'arena'
            arena_type = varargin{i+1};
        case 'ring'
            ring = varargin{i+1};  % Par exemple, [0.2 0.25] donne l'époque passée dans les 5% du cercle entre 20 et 25% en partant du centre
    end
end

if ~exist('figure_flag','var')
    figure_flag = 0;
end

if ~exist('percent_inner','var')
    percent_inner = 0.7;
end

if ~exist('ring','var')
    ring = [0.5 1];
end


if strcmp(arena_type, 'OF')
    % Paramètres géométriques
    diameter = 1;
    radius = diameter / 2;
    center = [0.5, 0];
    
    % Calcul des données X et Y
    num_points = length(Xtsd);
    x_data = center(1) + Data(Xtsd-0.5) * diameter;
    y_data = center(2) + Data(Ytsd-0.5) * diameter;
    
    distances = sqrt((x_data - center(1)).^2 + (y_data - center(2)).^2);
    
    % Calcul des rayons pour les zones
    inner_radius = radius * sqrt(percent_inner);  % Zone intérieure
    
    % Définir les limites pour la zone spécifique entre les deux pourcentages
    specific_inner_radius = radius * sqrt(ring(1));
    specific_outer_radius = radius * sqrt(ring(2));
    
    % Détection des points dans les zones
    in_inner_zone = distances <= inner_radius;
    % in_outer_zone = distances > inner_radius & distances <= radius;
    in_outer_zone = distances > inner_radius;
    in_specific_zone = distances > specific_inner_radius & distances <= specific_outer_radius;  % Zone spécifique (entre 25% et 30%)
    
elseif strcmp(arena_type, 'HC')
    side_length = 1;
    half_side = side_length / 2;
    x_data = Data(Xtsd) - 0.5;
    y_data = Data(Ytsd) - 0.5;
    
    abs_x = abs(x_data);
    abs_y = abs(y_data);
    max_coord = max(abs_x, abs_y);
    
    distances = sqrt((x_data - 0).^2 + (y_data - 0).^2);
    
    inner_limit = half_side * sqrt(percent_inner);
    specific_inner_limit = half_side * sqrt(ring(1));
    specific_outer_limit = half_side * sqrt(ring(2));
    
    in_inner_zone = max_coord <= inner_limit;
    in_outer_zone = max_coord > inner_limit;
    in_specific_zone = max_coord > specific_inner_limit & max_coord <= specific_outer_limit;
end

% Création des epochs
Xtemp = Data(Xtsd);  
T1 = Range(Xtsd);    
Ytemp = Data(Ytsd);  
Xtemp2_outer = Xtemp * 0;
Xtemp2_outer(in_outer_zone) = 1;
Xtemp2_inner = Xtemp * 0;
Xtemp2_inner(in_inner_zone) = 1;
Xtemp2_specific = Xtemp * 0;
Xtemp2_specific(in_specific_zone) = 1;

% Détection des epochs dans les zones définies
ZoneEpoch_Inner = thresholdIntervals(tsd(T1, Xtemp2_inner), 0.5, 'Direction', 'Above'); 
ZoneEpoch_Outer = thresholdIntervals(tsd(T1, Xtemp2_outer), 0.5, 'Direction', 'Above'); 
ZoneEpoch_Specific = thresholdIntervals(tsd(T1, Xtemp2_specific), 0.5, 'Direction', 'Above');  % Zone entre 25% et 30%

if figure_flag == 1
    figure;
    hold on;
    
    if strcmp(arena_type, 'OF')
    
        theta = linspace(0, 2*pi, 100);
        plot(center(1) + radius * cos(theta), center(2) + radius * sin(theta), 'k-', 'LineWidth', 2);
        plot(center(1) + inner_radius * cos(theta), center(2) + inner_radius * sin(theta), 'k--', 'LineWidth', 2);
        plot(center(1) + specific_inner_radius * cos(theta), center(2) + specific_inner_radius * sin(theta), 'b--', 'LineWidth', 2);
        plot(center(1) + specific_outer_radius * cos(theta), center(2) + specific_outer_radius * sin(theta), 'b-', 'LineWidth', 2);
    else
        rectangle('Position', [-half_side, -half_side, side_length, side_length], 'EdgeColor', 'k', 'LineWidth', 2);
        rectangle('Position', [-inner_limit, -inner_limit, 2*inner_limit, 2*inner_limit], 'EdgeColor', 'k', 'LineStyle', '--', 'LineWidth', 2);
        rectangle('Position', [-specific_inner_limit, -specific_inner_limit, 2*specific_inner_limit, 2*specific_inner_limit], 'EdgeColor', 'b', 'LineStyle', '--', 'LineWidth', 2);
        rectangle('Position', [-specific_outer_limit, -specific_outer_limit, 2*specific_outer_limit, 2*specific_outer_limit], 'EdgeColor', 'b', 'LineWidth', 2);
    end
%     
%     theta = linspace(0, 2*pi, 100);
%     outer_circle_x = center(1) + radius * cos(theta);
%     outer_circle_y = center(2) + radius * sin(theta);
%     inner_circle_x = center(1) + inner_radius * cos(theta);
%     inner_circle_y = center(2) + inner_radius * sin(theta);
%     specific_inner_circle_x = center(1) + specific_inner_radius * cos(theta);
%     specific_inner_circle_y = center(2) + specific_inner_radius * sin(theta);
%     specific_outer_circle_x = center(1) + specific_outer_radius * cos(theta);
%     specific_outer_circle_y = center(2) + specific_outer_radius * sin(theta);
%     
    
%     plot(outer_circle_x, outer_circle_y, 'k-', 'LineWidth', 2);
%     plot(inner_circle_x, inner_circle_y, 'k--', 'LineWidth', 2);
%     plot(specific_inner_circle_x, specific_inner_circle_y, 'b--', 'LineWidth', 2);
%     plot(specific_outer_circle_x, specific_outer_circle_y, 'b-', 'LineWidth', 2);
%     
    p1 = plot(x_data(in_inner_zone), y_data(in_inner_zone), '.g');
    p2 = plot(x_data(in_outer_zone), y_data(in_outer_zone), '.m');
    p3 = plot(x_data(in_specific_zone), y_data(in_specific_zone), '.b');
    
    axis equal;
    xlabel('X'); ylabel('Y');
    title('Thigmotaxis - Zones spécifiques');
    legend([p1 p2 p3],'Inner Zone','Outer Zone','Specific Zone', 'Location', 'Best');

    hold off;
end

% Calcul de la proportion dans la zone extérieure
% Thigmotaxis = length(x_data(in_outer_zone))/(length(x_data(in_inner_zone)) + length(x_data(in_outer_zone)));
Thigmotaxis = sum(in_outer_zone) / (sum(in_inner_zone) + sum(in_outer_zone));

% DistanceToCenter = tsd(Range(Xtsd),distances);

end
