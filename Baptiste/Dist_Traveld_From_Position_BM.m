

function total_distance = Dist_Traveld_From_Position_BM(Position)

% Position is a tsd

D = Data(Position);
x_coords = D(:,1);
y_coords = D(:,2);

% Function to calculate the total distance traveled from X and Y coordinates
% x_coords: a vector of X coordinates
% y_coords: a vector of Y coordinates

% Check if the input vectors are the same length
if length(x_coords) ~= length(y_coords)
    error('X and Y coordinates must have the same length');
end

% Initialize the total distance to zero
total_distance = 0;

% Loop through each consecutive pair of points and calculate the distance
for i = 2:length(x_coords)
    % Calculate the distance between consecutive points
    dx = x_coords(i) - x_coords(i-1);
    dy = y_coords(i) - y_coords(i-1);
    distance = sqrt(dx^2 + dy^2); % Euclidean distance
    
    % Add the distance to the total distance
    total_distance = total_distance + distance;
end

end







