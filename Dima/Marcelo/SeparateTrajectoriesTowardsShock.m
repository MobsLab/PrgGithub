function [TowardsShock,AwayFromShock] = SeparateTrajectoriesTowardsShock(Trajectories)

% [TowardsShock,AwayFromShock] = SeparateTrajectoriesTowardsShock(Trajectories)
% Input is a matrix with x positions in the first column and y positions in
% the second one.
% The outputs are two matrixes of the same size as the input with NaN in
% the lines where the direction is different from the one specified in the
% variable name

TowardsShock = zeros(size(Trajectories));
AwayFromShock = zeros(size(Trajectories));

DiffTeste = diff(Trajectories);
DiffTeste(end+1,:) = 0;

TowardsShockIndices = Trajectories(:,1)>0.65 & Trajectories(:,2)<0.85 & DiffTeste(:,2)>0 ...
    |Trajectories(:,2)>0.85 & DiffTeste(:,1)<0 ...
    |Trajectories(:,1)<0.35 & Trajectories(:,2)<0.85 & DiffTeste(:,2)<0;
    
AwayFromShockIndices = Trajectories(:,1)>0.65 & Trajectories(:,2)<0.85 & DiffTeste(:,2)<0 ...
    |Trajectories(:,2)>0.85 & DiffTeste(:,1)>0 ...
    |Trajectories(:,1)<0.35 & Trajectories(:,2)<0.85 & DiffTeste(:,2)>0;


TowardsShock(TowardsShockIndices,:) = Trajectories(TowardsShockIndices,:);
AwayFromShock(AwayFromShockIndices,:) = Trajectories(AwayFromShockIndices,:);

TowardsShock(TowardsShock == 0) = NaN;
AwayFromShock(AwayFromShock == 0) = NaN;

end