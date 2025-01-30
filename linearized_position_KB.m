function lin_pos = linearized_position_KB(Xtsd, Ytsd)
    % Check if the position is in the first arm (0 <= X <= 0.3, Y = 0)

Xt=Data(Xtsd);
Yt=Data(Ytsd);

 % Define the width of the maze
    maze_width = 0.3;
for i=1:length(Xt)
    X=Xt(i);Y=Yt(i);
    % Check if the position is in the first arm (0 <= X <= 0.3, 0 <= Y < 0.3)
    if X >= 0 & X <= maze_width & Y >= 0 & Y < maze_width
        lin_pos(i) = X / maze_width * 0.25;
    % Check if the position is in the vertical part (0 <= Y <= 1, 0.3 <= X <= 0.7)
    elseif X >= maze_width & X <= 1 - maze_width & Y >= 0 && Y < maze_width
        lin_pos(i) = 0.25 + Y / maze_width * 0.5;
    % Check if the position is in the second arm (0.7 <= X <= 1, 0 <= Y < 0.3)
    elseif X >= 1 - maze_width && X <= 1 && Y >= 0 && Y < maze_width
        lin_pos(i) = 0.75 + (X - (1 - maze_width)) / maze_width * 0.25;
    else
        lin_pos(i) = nan;
    end
end
end