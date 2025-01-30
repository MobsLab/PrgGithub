function A = WarpPositionAnalysis(A)

%parameters 
jump_thresh = 50;
reward_skip_thresh = 100;
smooth_length = 40;
velThresh = 0.3;

cdir = current_dir(A);



close all


% resources to be registered 

A = registerResource(A, 'XS', 'tsdArray', {1,1}, ...
    'XS', ...
    ['smoothed X position']);

A = registerResource(A, 'YS', 'tsdArray', {1,1}, ...
    'YS', ...
    ['smoothed X position']);



A = registerResource(A, 'Phi', 'cell', {1,1}, ...
    'phi', ...
    ['linearized coordinate on the circle'], 1);

A = registerResource(A, 'PhiMaze', 'cell', {1,1}, ...
    'phiMaze', ...
    ['linearized coordinate on the circle,restricted to maze epoch'], 1);

A = registerResource(A, 'PhiInterp', 'cell', {1,1}, ...
    'phiInterp', ...
    ['linearized coordinate on the circle,restricted to maze epoch, interpolated continuous at 60 Hz'], 1);

A = registerResource(A, 'MazeEpoch', 'cell', {1,1}, ...
    'mazeEpoch', ...
    ['intervalSet for the maze period'], 1);

A = registerResource(A, 'Sleep1Epoch', 'cell', {1,1}, ...
    'sleep1Epoch', ...
    ['intervalSet for the sleep 1 period'], 1);

A = registerResource(A, 'Sleep2Epoch', 'cell', {1,1}, ...
    'sleep2Epoch', ...
    ['intervalSet for the sleep 2 period'], 1);

A = registerResource(A, 'Reward1', 'cell', {1,1}, ...
    'reward1', ...
    ['intervalSet for all the time spend at first reward'], 1);

A = registerResource(A, 'Reward2', 'cell', {1,1}, ...
    'reward2', ...
    ['intervalSet for all the time spend at second reward'], 1);

A = registerResource(A, 'UpJourney', 'cell', {1,1}, ...
    'upJourney', ...
    ['intervalSet for the upJourneys'],1);

A = registerResource(A, 'DownJourney', 'cell',{1,1}, ...
    'downJourney', ...
    ['intervalSet for the down journeys'], 1);

A = registerResource(A, 'MovingUp', 'cell',{1,1}, ...
    'movingUp', ...
    ['intervalSet for all the time the animal moves in the "up" direction']);

A = registerResource(A, 'MovingDown', 'cell',{1,1}, ...
    'movingDown', ...
    ['intervalSet for all the times the animal moves in the "down" direction']);







%%%%%%%%%%%%%%%%%%%%%%%
if exist([cdir filesep 'VT1.pascii.bz2'])
    eval([ '!bunzip2 ' cdir filesep 'VT1.pascii.bz2']);
end



% get tracker coordinates 
[X, Y] = LoadPosition([cdir filesep 'VT1.pascii']);
[X1, Y1] = RemoveBadPosPoints(X, Y,jump_thresh,  jump_thresh);
XS = SmoothTsd(X1, smooth_length);
YS = SmoothTsd(Y1, smooth_length);


if exist([cdir filesep 'epoch_limits.mat'])
    load([cdir filesep 'epoch_limits.mat'])
else
    load ([cdir filesep 'old_analysis/epoch_limits.mat'])
end

mazeEpoch = intervalSet(epoch_limits(1), epoch_limits(2));
sleep1Epoch = intervalSet(StartTime(XS), epoch_limits(1)-1200000);
sleep2Epoch = intervalSet(epoch_limits(2)+1200000, EndTime(XS));



% linearized coordinates 
phi = CircularMazeAngularCoordinate(XS, YS);
phiMaze = Restrict(phi, mazeEpoch);
tp = Start(mazeEpoch):170:End(mazeEpoch);
p_inp = interp1(Range(phiMaze, 'ts'), Data(phiMaze), tp);

phiInterp = tsd(tp', p_inp');


% velocity assessments 
warning off
[VX, VY] = Vel2d(XS, YS);
warning on

V2 = tsd(Range(VX, 'ts'), sqrt(Data(VX).*Data(VX) + Data(VY) .* ...
    Data(VY)));

tv2 = Range(V2, 'ts');
v2 = Data(V2);
V2 = tsd(tv2(find(isfinite(v2))), v2(find(isfinite(v2))));

tv2 = Range(V2,'ts');
v2 = Data(V2);
tp = Range(phiInterp, 'ts');
v2Interp = interp1(tv2, v2, tp);
V2interp = tsd(tp, v2Interp);


% assess reward points

tp = Range(phiInterp, 's');
pin = Data(phiInterp);

plot(tp, pin);
display('choose limits for reward 1 and 2');
gg = ginput(2);
rewThresh1 = gg(1,2);
rewThresh2 = gg(2,2);



at_reward1 = find((v2Interp < (max(v2Interp)/100)) & pin < rewThresh1);
at_reward2 = find((v2Interp < (max(v2Interp)/100)) & pin > rewThresh2);

hold on 

plot(tp(at_reward1), pin(at_reward1), 'ro');
plot(tp(at_reward2), pin(at_reward2), 'go');

startReward1 = at_reward1(find(diff(at_reward1) > reward_skip_thresh)+ 1);
startReward1 = startReward1(1:(end-1));
endReward1 = at_reward1(find(diff(at_reward1) > reward_skip_thresh));
endReward1 = endReward1(2:end);


startReward2 = at_reward2(find(diff(at_reward2) > reward_skip_thresh)+1);
startReward2 = startReward2(1:(end-1));
endReward2 = at_reward2(find(diff(at_reward2) > reward_skip_thresh));
endReward2 = endReward2(2:end);
reward1 = intervalSet(startReward1, endReward1);
reward2 = intervalSet(startReward2, endReward2);

up1 = Restrict(ts(startReward2), endReward1, 'align', 'next');
upJourney = intervalSet(endReward1, up1, '-fixit');

up2 = Restrict(ts(startReward1), endReward2, 'align', 'next');
downJourney = intervalSet(endReward2, up2, '-fixit');


tv = thresholdIntervals(V2interp, velThresh);
tv = intersect(tv, union(upJourney, downJourney));

ps = Restrict(phiInterp, Start(tv));
pe = Restrict(phiInterp, End(tv));

goingUp = find((Data(pe)-Data(ps)) > 0);
goingDown = find((Data(pe)-Data(ps)) < 0);

movingUp = subset(tv, goingUp);
movingDown = subset(tv, goingDown);






plot(tp(startReward1), pin(startReward1), 'r<', 'MarkerSize',20);
plot(tp(endReward1), pin(endReward1), 'r>', 'MarkerSize',20);
plot(tp(startReward2), pin(startReward2), 'g<', 'MarkerSize',20);
plot(tp(endReward2), pin(endReward2), 'g>', 'MarkerSize',20);

plot(tp(Start(upJourney)), pin(Start(upJourney)), 'bd', 'MarkerSize', 20);
plot(tp(Start(downJourney)), pin(Start(downJourney)), 'bd', 'MarkerSize', 20);

plot(tp(End(upJourney)), pin(End(upJourney)), 'yd', 'MarkerSize', 20);
plot(tp(End(downJourney)), pin(End(downJourney)), 'yd', 'MarkerSize', 20);

keyboard


A = SaveAllResources(A);



    