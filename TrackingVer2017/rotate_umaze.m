function [mask_UMaze_rot z_rot side] = rotate_UMaze(mask_UMaze,z,setside)
% written by S. laventure 2020-08-26
% rotate the maze in tracking codes 
% and the associated zones
%   Default coordinates:
%      mask_UMaze = [200 223 200 57 60 57 60 130 155 130 155 151 60 151 60 223 200 223];
    % init var
    side = 0; % left side default (right=1)   
    
    % get rotation value from user
    if setside 
        answ = inputdlg({'Angle of rotation (0 to 360)','[U] stim side (Left=0; Right=1)'},'Rotate UMaze',[1 35],{'0','0'});
        theta = str2num(answ{1});
        side = str2num(answ{2}); 
    else 
        theta_str = inputdlg('Angle of rotation (0 to 360)','Rotate UMaze',[1 25],{'0'});
        theta = str2num(theta_str{1});
    end

    % UMAZE set x and y
    x = mask_UMaze(1:2:end);
    y = mask_UMaze(2:2:end);
    xcenter = mean(x);
    ycenter = mean(y);
    x = x - xcenter;
    y = y - ycenter;
    xy = [x; y]';
    
    % set zones side (switch left and right side except center (in position 3)
    if setside
        if side
            ztmp(1,:) = z(2,:);
            ztmp(2,:) = z(1,:);
            ztmp(3,:) = z(3,:);
            ztmp(4,:) = z(5,:);
            ztmp(5,:) = z(4,:);
            ztmp(6,:) = z(7,:);
            ztmp(7,:) = z(6,:);
            z = ztmp;
            clear ztmp
        end
    end
    if setside 
        % set x and y for zones
        for iz=1:size(z,1)
            zx(iz,1:size(z,2)/2) = z(iz,1:2:end);
            zy(iz,1:size(z,2)/2) = z(iz,2:2:end);
            zx(iz,:) = zx(iz,:) - xcenter;
            zy(iz,:) = zy(iz,:) - ycenter;
            zxy{iz} = [zx(iz,:); zy(iz,:)]';
        end
    end
    
    % rotate maze
    if theta 
        % get rotation values
        rotarray = [cosd(theta) sind(theta); -sind(theta) cosd(theta)]; % to change the rotation direction change the -sind to sind and vis versa
        % rotate maze
        rot_UMaze = xy * rotarray;
        x = rot_UMaze(:,1) + xcenter;
        y = rot_UMaze(:,2) + ycenter;
        %extract x and y
        mask_UMaze_rot = [x'; y'];
        mask_UMaze_rot = mask_UMaze_rot(:)';
        
        % rotate zones
        if setside
            for iz=1:size(z,1)
                rot_z{iz} = zxy{iz} * rotarray;
                zx(iz,1:size(z,2)/2) = rot_z{iz}(:,1) + xcenter;
                zy(iz,1:size(z,2)/2) = rot_z{iz}(:,2) + ycenter;
                z_tmp = [zx(iz,:); zy(iz,:)];
                z_rot(iz,1:size(z,2)) = z_tmp(:)';
            end
        else
            z_rot = z;
        end
        
    else
        mask_UMaze_rot = mask_UMaze;
        z_rot = z;
    end
    
%%     To test
%     figure,
%         for i=1:2:15
%             line([mask_UMaze_rot(1,i) mask_UMaze_rot(1,i+2)],[mask_UMaze_rot(1,i+1) mask_UMaze_rot(1,i+3)])
%             hold on
%         end
    
    