% Finds the point line distance from 3 points the user clicked, plus finds the intersection point on the main line.
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;

axis([-10, 10, -10, 10]);
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
% Set up the axis to go from -10 to 10
xlim([-10, 10]);
ylim([-10, 10]);
axis square
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
grid on;
axis equal

% Let user click 3 points.
[x, y] = ginput(3)
hold on;
% Plot the points
plot(x, y, 'b.', 'MarkerSize', 40);
% Draw lines between them all
plot([x; x(1)], [y; y(1)], 'b-', 'LineWidth', 2);
grid on;
xlim([-10, 10]);
ylim([-10, 10]);
axis square
text(x(1), y(1), '  1', 'FontSize', fontSize, 'Color', 'r', 'FontWeight', 'bold');
text(x(2), y(2), '  2', 'FontSize', fontSize, 'Color', 'r', 'FontWeight', 'bold');
text(x(3), y(3), '  3', 'FontSize', fontSize, 'Color', 'r', 'FontWeight', 'bold');

% Get theta between the line from point 1 to point 2, and the x axis
theta12 = atan2d(y(2) - y(1), x(2)-x(1))
theta13 = atan2d(y(3) - y(1), x(3)-x(1))
% Get the delta theta
deltaTheta = theta13 - theta12
distance = GetPointLineDistance(x(3),y(3),x(1),y(1),x(2),y(2))
% Get angle from a axis to point 5.
theta15 = theta12 - deltaTheta
% Get distance from point 1 to point 3
d13 = sqrt((x(1)-x(3))^2 + (y(1) - y(3))^2)

% Get (x5, y5)
x(5) = d13 * cosd(theta15) + x(1)
y(5) = d13 * sind(theta15) + y(1)
% Plot it
hold on;
plot(x(5), y(5), 'r.', 'MarkerSize', 40, 'LineWidth', 2);
line([x(3), x(5)], [y(3), y(5)], 'Color', 'r', 'LineWidth', 2);
line([x(1), x(5)], [y(1), y(5)], 'Color', 'r', 'LineWidth', 2);
xlim([-10, 10]);
ylim([-10, 10]);
axis square
text(x(5), y(5), '  5', 'FontSize', fontSize, 'Color', 'r', 'FontWeight', 'bold');

% Get (x4, y4) which is on the line from point 1 to point 2.
x(4) = mean([x(3), x(5)])
y(4) = mean([y(3), y(5)])
% Plot it
hold on;
plot(x(4), y(4), 'r.', 'MarkerSize', 40, 'LineWidth', 2);
text(x(4), y(4), '  4', 'FontSize', fontSize, 'Color', 'r', 'FontWeight', 'bold');
viscircles([x(1), y(1)], d13);
xlabel('X', 'FontSize', fontSize);
ylabel('Y', 'FontSize', fontSize);

% Get the distance from a point (x3, y3) to
% a line defined by two points (x1, y1) and (x2, y2);
% Reference: http://mathworld.wolfram.com/Point-LineDistance2-Dimensional.html
function distance = GetPointLineDistance(x3,y3,x1,y1,x2,y2)
try
	
	% Find the numerator for our point-to-line distance formula.
	numerator = abs((x2 - x1) * (y1 - y3) - (x1 - x3) * (y2 - y1));
	
	% Find the denominator for our point-to-line distance formula.
	denominator = sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2);
	
	% Compute the distance.
	distance = numerator ./ denominator;
catch ME
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s',...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage)
end
return; % from GetPointLineDistance()
end
