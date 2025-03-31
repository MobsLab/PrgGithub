%%ToneDuringDownStateEffect
% 22.03.2018 KJ
%
%
% see
%   ToneDuringDownStateRaster ToneDuringDownStateEffectPlot
%


clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);


for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p tones_res
    
    tones_res.path{p}   = Dir.path{p};
    tones_res.manipe{p} = Dir.manipe{p};
    tones_res.name{p}   = Dir.name{p};
    tones_res.date{p}   = Dir.date{p};

    clearvars -except Dir p tones_res
    
    %params
    binsize_mua  = 2; %2ms
    minDuration  = 20;
    delay_before = 1000; %100ms
    delay_after  = 1000; %100ms
    
    
    %MUA & Down
    MUA = GetMuaNeurons_KJ('PFCx','binsize',binsize_mua); %2ms
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 0, 'predown_size', 10, 'method', 'mono');
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    down_duration = End(down_PFCx) - Start(down_PFCx);

    %tones
    load('DeltaSleepEvent.mat', 'TONEtime2')
    if ~exist('TONEtime2','var')
        continue
    end
    tones_tmp = TONEtime2 + Dir.delay{p}*1E4;

    
    %% delay

    %delay
    down_rep = repmat(st_down,1,length(tones_tmp));
    end_rep = repmat(end_down,1,length(tones_tmp));
    tones_rep = repmat(tones_tmp',length(st_down),1);
    
    %Inside, before and after
    select_tone = {'inside', 'before', 'after'};    
    
    for st=1:length(select_tone)
        
        delay_rep = tones_rep - down_rep;
        
        if strcmpi(select_tone{st}, 'inside')
            delay_rep(delay_rep>(end_rep-down_rep))=nan;
            delay_rep(delay_rep<0)=nan;
        elseif strcmpi(select_tone{st}, 'before')
            delay_rep(delay_rep<-delay_before | delay_rep>0)=nan;
        elseif strcmpi(select_tone{st}, 'after')
            delay_rep(delay_rep<(end_rep-down_rep) | delay_rep>(end_rep-down_rep)+delay_after)=nan;
        end

        [delay_tonedown, id_max] = max(delay_rep,[],2);

        %ids of events
        idx_down = find(~isnan(delay_tonedown));
        id_tones = id_max(idx_down);
        

        %sort index
        ibefore = zeros(length(id_tones), 1);
        iafter = zeros(length(id_tones), 1);
        ipostdown = zeros(length(id_tones), 1);
        for i=1:length(id_tones)
            tone_time = tones_tmp(id_tones(i));

            ibefore(i) = tone_time - st_down(idx_down(i));
            iafter(i) = end_down(idx_down(i)) - tone_time;

            down_after = st_down(find(st_down-end_down(idx_down(i))>0, 1));
            ipostdown(i) = down_after - tone_time;
        end
        
        tones_res.(select_tone{st}).ibefore{p}   = ibefore;
        tones_res.(select_tone{st}).iafter{p}    = iafter;
        tones_res.(select_tone{st}).ipostdown{p} = ipostdown;
    
    end
    
    
end

%saving data
cd(FolderDeltaDataKJ)
save ToneDuringDownStateEffect.mat tones_res binsize_mua minDuration delay_before delay_after



