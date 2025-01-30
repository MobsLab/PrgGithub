%P2Pdistance - 
%   computes the point-to-point shortest distance between two points in an 2D-arena.
%   The direction of movement that is authorized can be encoded on the periscope_array variable
%   
%
%----INPUT----
% OccupationG                       The grid of Occupation is a logical 2D-array of all the points where one can go. It is fondamentally the size of the arena
% (periscope_array)                 (optional) Array of the same size than OccupationG, that contains the individuals' authorized movements for each point. If not given, we suppose that any movement is authorized, meaning that the direction of movement is not encoded.
%
%----OUTPUT----
% distance_aggregator               4D-array (bi-symmetrical) that gives for distance_aggregator(a,b,c,d) the length of the shortest path to get from (a,b) to (c,d)
%
%
%
%
% Assumptions : 
%   as a unit distance we are no more precise than sqrt(2). This is important ! There is a bias in that the only movements authorized are vertical, horizontal, and diagonal.
%   There are no cavalier-chess-like movements (or more advnaced either). This is only to simplify the algorithm.
%
%   The spirit of the algorithm is exploration-like. Starting frome the source-point, we go to the nearest-authorized-members and compute their distances.
%   We then expand the horizon one bit to get the 2-points paths, etc. At each step, we know for certain the distance to previous points, 
%   because we already took the shortest path to get there ! This is only possible by negliging complexe chess-like movements.
%
%   

% Copyright (C) 2017 by Thibault Balenbois
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.






function distance_aggregator=P2Pdistance(OccupationG, varargin)

    distance_aggregator=ones(size(OccupationG,1),size(OccupationG,2),size(OccupationG,1),size(OccupationG,2))./zeros(size(OccupationG,1),size(OccupationG,2),size(OccupationG,1),size(OccupationG,2));
    if nargin==1
        periscope_array{size(OccupationG,1),size(OccupationG,2)}=[];
        for x = 1:size(OccupationG,1)
            for y = 1:size(OccupationG,2)
                if OccupationG(x,y)
                    periscope_array{x,y} = [[0;1] [0;-1] [1;0] [-1;0] [1;1] [1;-1] [-1;1] [-1;-1]];
                end
            end
        end
    else
        periscope_array=varargin{1};
    end


    n=1;
    disp('Starting calculating the shortest distance between two points.');
    for occx=1:size(OccupationG,1)
        for occy=1:size(OccupationG,2)

            if ~OccupationG(occx,occy)
                continue
            end

            source = [occx;occy];
            matrice_resultat = ((ones(size(OccupationG)))./OccupationG);
            Unchecked_points = [];
            for x = 1:size(OccupationG,1)
                for y  = 1:size(OccupationG,2)
                    if OccupationG(x,y)
                        Unchecked_points = [Unchecked_points [x;y]];
                    end
                end
            end
            horizon_line = source;


            while size(Unchecked_points,2)~=0
               next_horizon_line = [];
                
                %% -- if we haven't finished, we'll try to extand the scope of our result
                for x = 1:size(horizon_line,2)
                    reference_point = horizon_line(:,x);
                    periscope = periscope_array{reference_point(1),reference_point(2)};
                    
                    %% -- Looking around our selected point
                    for theta = 1:size(periscope,2)
                        current_point = horizon_line(:,x) + periscope(:,theta);
                        
                        %% -- First we check if we aren't close to the edge of the grid
                        if current_point(1)<1 || current_point(1)>size(matrice_resultat,1) ||current_point(2)<1 || current_point(2)>size(matrice_resultat,2)
                            continue
                        end
                        
                        %% -- Then we check if it is indeed a new point
                        if ~ismember(current_point',Unchecked_points','rows') || ismember(current_point',horizon_line','rows')
                            continue
                        end
                        
                        %% -- We calculate the distance of the new point using this path
                        if theta<5
                            distance = matrice_resultat(reference_point(1),reference_point(2)) + 1;
                        else
                            distance = matrice_resultat(reference_point(1),reference_point(2)) + sqrt(2);
                        end
                        
                        %% -- We add the new point to the next horizon_line (without redundancy)
                        if size(next_horizon_line,2) == 0
                            next_horizon_line = current_point;
                        elseif ~ismember(current_point',next_horizon_line','rows')
                            next_horizon_line = [next_horizon_line current_point];
                        end
                        
                        %% -- If this path is short, we can finally add it to the result
                        if matrice_resultat(current_point(1),current_point(2))==1 || distance<matrice_resultat(current_point(1),current_point(2))
                            matrice_resultat(current_point(1),current_point(2)) = distance;
                        end
                    end
                end

                %% -- We can now update the list of future points to go through
                for y = 1:size(horizon_line,2)
                    [in idx] = ismember(horizon_line(:,y)',Unchecked_points','rows');
                    if in
                        Unchecked_points(:,idx) = [];
                    end
                end
                horizon_line = next_horizon_line;
            end

            distance_aggregator(occx,occy,:,:) = matrice_resultat;
            disp(['Completed calculation for ',num2str(n),' points over ',num2str(sum(sum(OccupationG)))]);
            n=n+1;
        end
    end