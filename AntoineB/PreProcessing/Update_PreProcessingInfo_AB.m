% Author AB (antoine.bergel[at]espci.fr
% Last Update 06/09/21

% Quick script to update template_PreprocessingInfo from
% template_PreprocessingInfo.mat
% Avoids running GUI_StepThree_FolderInfo 
% Move to folder containing ExpeInfo.mat and run the script

% FolderForConcatenation_Behav 
load('/home/mobshamilton/Dropbox/Mobs_member/Antoine B/3-Preprocessing/template_PreprocessingInfo_SleepImport.mat');
pattern_rep = strrep(pwd,'/media/nas6/ProjetReversalBehavior/SleepImport/','');
PreprocessingInfo.FolderForConcatenation_Behav=regexprep(PreprocessingInfo.FolderForConcatenation_Behav,'M###/YYYYMMDD',pattern_rep);

% saving ExpeInfo.mat 
load('ExpeInfo.mat');
ExpeInfo.PreProcessingInfo = PreprocessingInfo;
%movefile('ExpeInfo.mat','~ExpeInfo.mat');
save('ExpeInfo.mat','ExpeInfo');

% Display modified ExpeInfo.mat
load('ExpeInfo.mat');
ExpeInfo.PreProcessingInfo.FolderForConcatenation_Behav{1}