function polygon = GetCageEdgesWithoutVideo(x,y)
clf
plot(x,y,'k')
axis equal
title('Draw estimated cage bottom ')
polygon = drawpolygon	;
polygon.InteractionsAllowed = 'none';
numPoints = size(polygon.Position, 1);
if numPoints > 4
    % Restrict to the first 4 points
    polygon.Position = polygon.Position(1:4, :);
    disp('Polygon limited to 4 points.');
end
polygon.InteractionsAllowed = 'reshape';

title('Adjust cage bottom during video ')

keyboard

% Callback function to enforce the 4-point limit
    function limitVertices(polygon)
        if size(polygon.Position, 1) > 4
            % Remove extra points
            polygon.Position = polygon.Position(1:4, :);
            % Finalize drawing
            disp('Polygon limited to 4 points.');
        end
    end


end