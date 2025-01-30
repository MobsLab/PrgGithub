%%DeltaDownMultiChannel
% 23.02.2018 KJ
%
% see
%   DetectDeltaDepthMultiChannel MakeIDfunc_DownDelta DeltaDownSingleChannel
%


% load
clear
load([FolderProjetDelta 'Data/DetectDeltaDepthMultiChannel.mat'])

%loop
for p=1:length(depth_res.path)

    %down states
    load(fullfile(depth_res.path{p}, 'DownState.mat'), 'down_PFCx')
    %deltas detected on different single channels
    DeltaEpochs = depth_res.deltas{p};
    
    for i=1:length(DeltaEpochs)
        deltas_PFCx = DeltaEpochs{i};
        
        %total amount
        down.all(p,i) = length(Start(down_PFCx));
        delta.all(p,i) = length(Start(deltas_PFCx));   
        
        
        % intersection delta waves and down states
        intvDur = 1E3;
        larger_delta_epochs = [Start(deltas_PFCx)-intvDur, End(deltas_PFCx)+intvDur];
        down_tmp = (Start(down_PFCx)+End(down_PFCx)) / 2; 

        if ~isempty(down_tmp)
            [status, ~, ~] = InIntervals(down_tmp,larger_delta_epochs);
        else
            status = [];
        end
        
        %result
        down.delta(p,i) = sum(status);
        delta.down(p,i) = sum(status);

        down.only(p,i) = down.all(p,i) - down.delta(p,i);
        delta.only(p,i) = delta.all(p,i) - delta.down(p,i);

    end
        
end


%data
true_down   = down.delta ./ delta.all;
missed_down = down.only ./ down.all;
fake_down   = delta.only ./ delta.all;


% %% PLOT
% figure, hold on
% scatter(true_down, missed_down, 25, fake_down,'filled')
% 
% 
% 




