function polygon = GetCageEdgesWithVideo(x,y)
clf
a=dir('*.avi');
v = VideoReader(a.name);
firstFrame = read(v,1);

Im = imagesc(rgb2gray(firstFrame));
hold on
plot(x,y,'w')
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

% Create a button to pause/resume
pauseFlag = false; % Initialize the pause flag
uicontrol('Style', 'pushbutton', 'String', 'Pause/Resume', ...
    'Position', [10, 10, 100, 40], 'Callback', @buttonCallback);

stopFlag = false; % Initialize the pause flag

uicontrol('Style', 'pushbutton', 'String', 'Done', ...
    'Position', [200, 10, 100, 40], 'Callback', @finishedbutton);

go_backFlag = false;
go_forwardFlag = false;
uicontrol('Style', 'pushbutton', 'String', '<<', ...
    'Position', [400, 10, 100, 40], 'Callback', @go_back);
uicontrol('Style', 'pushbutton', 'String', '>>', ...
    'Position', [500, 10, 100, 40], 'Callback', @go_forward);

i=1;
while i<v.NumFrames
    Im.CData = read(v,i);
    % Check the pause flag
    while pauseFlag
        pause
    end
    if stopFlag
        return
    end
    
    if go_backFlag
        i = max([1,i-100]);
        go_backFlag = false;
    end
    
        if go_forwardFlag
        i = max([1,i+100]);
        go_forwardFlag = false;
    end

    i=i+1;
    pause(0.1)
end

% Callback function for the button
    function buttonCallback(~, ~)
        pauseFlag = ~pauseFlag; % Toggle the pause flag
    end

    function finishedbutton(~, ~)
        stopFlag = ~stopFlag; % Toggle the pause flag
        
    end

    function go_back(~, ~)
        go_backFlag = ~go_backFlag; % Toggle the pause flag
        
    end

    function go_forward(~, ~)
        go_forwardFlag = ~go_forwardFlag; % Toggle the pause flag
        
    end



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