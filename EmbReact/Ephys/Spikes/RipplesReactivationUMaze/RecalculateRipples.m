clear all
GetUsefulDataRipplesReactivations_UMaze_SB
for mm=2
    for ff = 1:5
        cd(Dir{mm}.Cond{ff})
%         if mm==2
        CreateRipplesSleep('scoring','ob','stim',1,'rmvnoise',0,'plotavg',1,'restrict',0,'recompute',1)
%         else
        CreateRipplesSleep('scoring','ob','stim',1,'rmvnoise',1,'plotavg',1,'restrict',0,'recompute',1)
%         end
        keyboard
        close all
    end
end


%% No ripple channels
% 490 : 16
% 507 : none
% 508 : 46
% 509 : 12
% 514 : 38

