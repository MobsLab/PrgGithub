function Batch_MorphLinearizeMaze_AB(varargin)
% Coded by Antoine Bergel antoine.bergel[at]espci.fr
% 02/05/2021
%
% This function morphs Umaze to the unified 0-1 coordinates and
% linearizes trajectories from 0 (shock zone) to 1 (safe zone)
%
% INPUT (Optional)
%     Dir   directory containing the files to be morhped
%
%  OUTPUT
%     None  Saves new variables in behavResources.mat


% Default values
folder_name = [];

%% Optional parameters handling
for i=1:2:length(varargin)
    switch(lower(varargin{i}))
        
        case 'dir'
            folder_name = varargin{i+1};
            if ~isdir(folder_name)>1
                error('Incorrect value for property ''dir'' (type ''help Batch_MorphLinearizeMaze_AB'' for details).');
            end
    end
end

% Manual folder selection
start_path = '/media/mobshamilton/DataMOBS141';
dialog_title = 'Select folder containing the recordings to process.';
folder_name = uigetdir(start_path,dialog_title);


% Searching subfolders to find behav_Ressources.mat
d = dir(fullfile(folder_name,'*','behavResources.mat'));
if isempty(d)
    errordlg(sprintf('No subfolders containing behavResources.mat in [%s].',folder_name));
    return;
else
    fprintf('%d subfolders containing behavResources.mat in [%s].\n',length(d),folder_name);
end


% Keeping only relevant folders
d = d(contains({d(:).folder}',{'Hab_';'TestPre_';'Cond_';'CondWallShock_';'CondWallSafe_';'TestPost_';'Ext_'}));
% Sorting recordings
dd = [d(contains({d(:).folder}','Hab_'));...
    d(contains({d(:).folder}','Ext_'));...
    d(contains({d(:).folder}','Cond_'));...
    d(contains({d(:).folder}','CondWallShock_'));...
    d(contains({d(:).folder}','CondWallSafe_'));...
    d(contains({d(:).folder}','TestPre_'));...
    d(contains({d(:).folder}','TestPost_'))];


% Loading behavResources.mat
for i =1:length(dd)
    cur_name = dd(i).name;
    [cur_folder,cur_subfolder,~] = fileparts(dd(i).folder);
    filename = fullfile(cur_folder,cur_subfolder,cur_name);
    bR = load(filename);
    
    % Remorphing dialog
    choice = 'Yes';
    if isfield(bR,'CleanAlignedXtsd') && isfield(bR,'CleanAlignedYtsd') && isfield(bR,'CleanZoneEpochAligned') && isfield(bR,'CleanXYOutput')
        choice = questdlg(sprintf('Do you want to re-morph [%s]?',cur_subfolder), ...
            'Morphing Parameters found', ...
            'Yes','No','No');
    end
    
    if strcmp(choice,'No') || isempty(choice)
        fprintf('Morphing skipped (%d/%d) [%s] .\n',i,length(dd),cur_subfolder);
        continue;
    else
        fprintf('Morphing file (%d/%d) [%s] ...',i,length(dd),cur_subfolder);
        [CleanAlignedXtsd,CleanAlignedYtsd,CleanZoneEpochAligned,CleanXYOutput] = MorphMazeToSingleShape_EmbReact_AB...
            (bR.CleanXtsd,bR.CleanYtsd, bR.Zone{1}, bR.ref, bR.Ratio_IMAonREAL);
        save(filename,'CleanAlignedXtsd','CleanAlignedYtsd','CleanZoneEpochAligned','CleanXYOutput','-append');
    end
    fprintf(' done.\n'); 

end

end