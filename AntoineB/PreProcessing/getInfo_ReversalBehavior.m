% Script based on getInfo_ReversalBehavior.m
% Coded by Antoine Bergel antoine.bergel[at]espci.fr
% 03/09/2021

% Moves all behavResources.mat and cleanbehavResources.mat in the folder Old
% Regenerates behavResources.mat in the right format (namely Xtsd, Ytsd,
% AlignedXtsd and AlignedYtsd

% The general rationale is that in the new format the process of cleaning
% tsd in performed automatically so no need to 

% Load all experiments in
Dir = PathForExperimentsReversalBehavior_AB('Hab');
all_experiments = {'Hab', 'Ext' , 'TestPre', 'TestProbe',...
    'TestPostPAG', 'TestPostMFB',...
    'CondPAG', 'CondWallShockPAG', 'CondWallSafePAG',...
    'CondMFB', 'CondWallShockMFB', 'CondWallSafeMFB'};
all_but_hab = {'Ext','TestPre', 'TestProbe','TestPostPAG','TestPostMFB',...
    'CondPAG','CondWallShockPAG','CondWallSafePAG',...
    'CondMFB','CondWallShockMFB','CondWallSafeMFB'};
for i =1:length(all_but_hab)
    Dir2 = PathForExperimentsReversalBehavior_AB(char(all_but_hab(i)));
    Dir = MergePathForExperiment(Dir,Dir2);
end

% % Restrict to some mice if needed
mice = [863 913 932 934 935 938];   % Marcelo's Data
%mice = [1138 1139 1140 1141 1142 1143];   % Mathilde's Data
Dir = RestrictPathForExperiment(Dir, 'nMice', mice);

% % Restrict to some group if needed
% Dir=RestrictPathForExperiment(Dir,'Group','SleepImport');

n_exp = length(Dir.path);
all_paths = [];
all_xtsd = [];
all_aligned_xtsd = [];
all_clean_xtsd = [];
all_cleanaligned_xtsd = [];
number_of_zones = [];
        
for iexp = 1:n_exp
    
    n_rec = length(Dir.path{iexp});
    for irec = 1:n_rec
        cd(Dir.path{iexp}{irec});
        
        % Load old data
        d=load(fullfile('behavResources.mat'));

        cur_path = strrep(Dir.path{iexp}{irec},'/media/nas6/ProjetReversalBehavior','');
        all_paths = [all_paths;{cur_path}];
        all_xtsd = [all_xtsd;isfield(d,'Xtsd')];
        all_aligned_xtsd = [all_aligned_xtsd;isfield(d,'AlignedXtsd')];
        all_clean_xtsd = [all_clean_xtsd;isfield(d,'CleanXtsd')];
        all_cleanaligned_xtsd = [all_cleanaligned_xtsd;isfield(d,'CleanAlignedXtsd')];
        number_of_zones = [number_of_zones;length(d_old.ZoneLabels)];
        
        %fprintf('[%s] Xtsd:%d - AlignedXtsd:%d - CleanXtsd:%d.\n',cur_path,isfield(d,'Xtsd'),isfield(d,'AlignedXtsd'),isfield(d,'CleanXtsd'));
    end
end

% display results
fprintf('\nTotal number of files : %d.\n \n',length(all_paths));
fprintf('=============== Missing CleanXtsd ===============\n');
all_paths(~all_clean_xtsd)

fprintf('=============== Missing AlignedXtsd ===============\n');
all_paths(~all_aligned_xtsd)

fprintf('=============== Missing CleanAlignedXtsd ===============\n');
all_paths(~all_cleanaligned_xtsd)

fprintf('=============== Files with 7 Zones ===============\n');
all_paths(number_of_zones==7)

fprintf('=============== Files with 9 Zones ===============\n');
all_paths(number_of_zones==9)