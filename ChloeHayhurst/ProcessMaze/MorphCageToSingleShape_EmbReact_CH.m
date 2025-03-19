
function [AlignedXtsd,AlignedYtsd,XYOutput] = MorphCageToSingleShape_EmbReact_CH(Xtsd,Ytsd,Ref,Ratio_IMAonREAL,XYInput)


%% Function that morphs UMaze coordinates into system with 0,0 as the bottom corner of shock zone and rest of maze going from 0 to 1
%% Input
% Xtsd,Ytsd : tsd of positions
% Ref : for user input, the reference image of the maze
% XYInput : optional, if the same reference image is used multiple times,
% the user can avoid clicking repeatedly by supplying the coordinates


%% Initiation
colors = {'r','b'};

% get user input
if exist('XYInput')
    x = XYInput(1,:);
    y = XYInput(2,:);
else
    a=figure; a.Position=[1e3 1e3 2e3 2e3];
    imagesc(double(Ref)), colormap jet, hold on
    plot(Data(Xtsd)*Ratio_IMAonREAL,Data(Ytsd)*Ratio_IMAonREAL,'color',[0.8 0.8 0.8])
    title('bottom left little side corner - bottom right little side corner - top left long side corner ')
    [x,y]  = ginput(3);
end
XYOutput(1,:) = x;
XYOutput(2,:) = y;
close all

% Transformation of coordinates
Coord1 = [x(2)-x(1),y(2)-y(1)];
Coord2 = [x(3)-x(1),y(3)-y(1)];
TranssMat = [Coord1',Coord2'];
XInit = Data(Xtsd).*Ratio_IMAonREAL-x(1);
YInit = Data(Ytsd).*Ratio_IMAonREAL-y(1);

% The Xtsd and Ytsd in new coordinates
A = ((pinv(TranssMat)*[XInit,YInit]')');
AlignedXtsd = tsd(Range(Xtsd),A(:,1));
AlignedYtsd = tsd(Range(Ytsd),A(:,2));


% give us a look at the result
figure
hold on
plot(Data(AlignedXtsd),Data(AlignedYtsd))
line([0 0],[0 1])
line([1 1],[0 1])
line([0 1],[0 0])
line([0 1],[1 1])
xlim([-0.2 1.2])
ylim([-0.2 1.2])

end
