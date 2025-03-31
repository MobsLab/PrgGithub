% SWActivityStimShamPlot
% 05.10.2017 KJ
%
% Effect of Stim on Slow Wave Activity
%
%   see 
%       SWActivityStimShamPlot
%

%load
clear
eval(['load ' FolderPrecomputeDreem 'SWActivityStimSham.mat'])

conditions = unique(swa_res.condition);

%params


%% loop over conditions
for cond=1:length(conditions)
    for p=1:length(swa_res.filename)
        if strcmpi(swa_res.condition{p},conditions{cond})
            
            
        end
    end
end
















