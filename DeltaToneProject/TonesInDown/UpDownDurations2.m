%%UpDownDurations2
% 28.06.2018 KJ
%
%
% see
%   UpDownDurations ShortUpAnalysis
%


clear

%% Dir


Dir=PathForExperimentsBasalSleepSpike;


%% get data for each record

for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p duration_res
    
    duration_res.path{p}   = Dir.path{p};
    duration_res.manipe{p} = Dir.manipe{p};
    duration_res.name{p}   = Dir.name{p};
    duration_res.date{p}   = Dir.date{p};
    
    %params
    windowsize = 30e4; %30sec
    
    
    %% Down and up
    
    %Down
    load('DownState.mat', 'down_PFCx')
    st_down   = Start(down_PFCx);
    end_down  = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    
    %% durations
    duration_res.down.duration{p} = End(down_PFCx) - Start(down_PFCx); 
    duration_res.up.duration{p}   = End(up_PFCx) - Start(up_PFCx);
    
    
    %% density
    for i=1:length(st_up)
        intv = intervalSet(st_up(i)-windowsize,end_up(i)+windowsize);
        duration_res.up.density{p}(i) = length(Restrict(ts(st_down), intv)) / tot_length(intv,'s');
        
        intv_bef = intervalSet(st_up(i)-windowsize,st_up(i));
        duration_res.up.densbefore{p}(i) = length(Restrict(ts(st_down), intv_bef)) / tot_length(intv_bef,'s');
        
    end
        
end


%saving data
cd(FolderDeltaDataKJ)
save UpDownDurations2.mat duration_res  windowsize


