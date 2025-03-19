function limitVertices(polygon)
if size(polygon.Position, 1) > 4
    % Remove extra points
    polygon.Position = polygon.Position(1:4, :);
    % Finalize drawing
    disp('Polygon limited to 4 points.');
end
end