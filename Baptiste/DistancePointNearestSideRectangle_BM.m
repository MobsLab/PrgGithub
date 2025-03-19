

function nearest_distances = DistancePointNearestSideRectangle_BM(X,Y)

% Define the dimensions of the walls
x_min = 0;
x_max = 20;
y_min = 0;
y_max = 40;

% Validate input sizes
if length(X) ~= length(Y)
    error('X and Y vectors must be of the same length.');
end

% Initialize distances matrix
distances_to_x_min = abs(X - x_min);
distances_to_x_max = abs(X - x_max);
distances_to_y_min = abs(Y - y_min);
distances_to_y_max = abs(Y - y_max);

% Find the nearest wall distance for each point
nearest_distances = min([distances_to_x_min'; distances_to_x_max'; distances_to_y_min'; distances_to_y_max'], [], 1);



