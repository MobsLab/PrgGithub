root_dir='/media/nas8-2/ProjectCardioSense';
original_mat = 'behavResources_Online.mat';
offline_mat = 'behavResources.mat';

offline_tracking_correct_time_base(root_dir, original_mat, offline_mat)

% fid = fopen('behavResources_Online.mat', 'r');
% header = fread(fid, 128, 'char=>char')'; % First 128 chars is header
% fclose(fid);
% disp(header)

