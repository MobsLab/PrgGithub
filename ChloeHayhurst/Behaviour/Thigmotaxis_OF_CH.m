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
    % HomeCage : AlignedXtsd is comprised between 0 and 40 and Aligned
    % Ytsd between 0 and 20
    
    cage_width = 40;
    cage_height = 20;
    
    x_data = Data(Xtsd);
    y_data = Data(Ytsd);
        
    distances = max(abs(x_data - cage_width / 2) / (cage_width / 2), abs(y_data - cage_height / 2) / (cage_height / 2));
    
    % Définition des zones
    inner_limit = sqrt(percent_inner);
    specific_inner_limit = sqrt(ring(1));
    specific_outer_limit = sqrt(ring(2));
    
    in_inner_zone = distances <= inner_limit;
    in_outer_zone = distances > inner_limit;
    in_specific_zone = distances > specific_inner_limit & distances <= specific_outer_limit;
end

% Création des epochs
distances_tsd = tsd(Range(Xtsd) , distances);

ZoneEpoch_Outer = thresholdIntervals(distances_tsd , inner_limit , 'Direction' , 'Above');
ZoneEpoch_Inner = thresholdIntervals(distances_tsd , inner_limit , 'Direction' , 'Below');
Temp1 = thresholdIntervals(distances_tsd , specific_inner_limit , 'Direction' , 'Above');
Temp2 = thresholdIntervals(distances_tsd , specific_outer_limit , 'Direction' , 'Below');
ZoneEpoch_Specific = and(Temp1,Temp2);

if figure_flag == 1
    figure;
    hold on;
    
    p1 = plot(x_data(in_inner_zone), y_data(in_inner_zone), '.g');
    p2 = plot(x_data(in_outer_zone), y_data(in_outer_zone), '.m');
    %     p3 = plot(x_data(in_specific_zone), y_data(in_specific_zone), '.b');

    if strcmp(arena_type, 'OF')
    
        theta = linspace(0, 2*pi, 100);
        plot(center(1) + radius * cos(theta), center(2) + radius * sin(theta), 'k-', 'LineWidth', 2);
        plot(center(1) + inner_radius * cos(theta), center(2) + inner_radius * sin(theta), 'k--', 'LineWidth', 2);
        plot(center(1) + specific_inner_radius * cos(theta), center(2) + specific_inner_radius * sin(theta), 'b--', 'LineWidth', 2);
        plot(center(1) + specific_outer_radius * cos(theta), center(2) + specific_outer_radius * sin(theta), 'b-', 'LineWidth', 2);
    else
       rectangle('Position', [0, 0, cage_width, cage_height], 'EdgeColor', 'k', 'LineWidth', 2);
        rectangle('Position', [cage_width * (1 - inner_limit)/2, cage_height * (1 - inner_limit)/2, cage_width * inner_limit, cage_height * inner_limit], 'EdgeColor', 'k', 'LineStyle', '--', 'LineWidth', 2);
        rectangle('Position', [cage_width * (1 - specific_inner_limit)/2, cage_height * (1 - specific_inner_limit)/2, cage_width * specific_inner_limit, cage_height * specific_inner_limit], 'EdgeColor', 'b', 'LineStyle', '--', 'LineWidth', 2);
        rectangle('Position', [cage_width * (1 - specific_outer_limit)/2, cage_height * (1 - specific_outer_limit)/2, cage_width * specific_outer_limit, cage_height * specific_outer_limit], 'EdgeColor', 'b', 'LineWidth', 2);
    end
        
    axis equal;
    xlabel('X'); ylabel('Y');
    title('Thigmotaxis - Zones spécifiques');
    legend([p1 p2],'Inner Zone','Outer Zone', 'Location', 'Best');

    hold off;
end

% Calcul de la proportion dans la zone extérieure
% Thigmotaxis = length(x_data(in_outer_zone))/(length(x_data(in_inner_zone)) + length(x_data(in_outer_zone)));
Thigmotaxis = sum(in_outer_zone) / (sum(in_inner_zone) + sum(in_outer_zone));

% DistanceToCenter = tsd(Range(Xtsd),distances);

end
