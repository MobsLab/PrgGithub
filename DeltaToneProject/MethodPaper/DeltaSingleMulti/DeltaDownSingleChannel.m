%%DeltaDownSingleChannel
% 22.02.2018 KJ
%
% see
%   DetectDeltaDepthSingleChannel MakeIDfunc_DownDelta
%


% load
clear
load([FolderProjetDelta 'Data/DetectDeltaDepthSingleChannel.mat'])

%loop
k=1;
for p=1:length(depth_res.path)

    %down states
    load(fullfile(depth_res.path{p}, 'DownState.mat'), 'down_PFCx')
    %deltas detected on different single channels
    DeltaEpochs = depth_res.deltas{p};
    
    for i=1:length(DeltaEpochs)
        deltas_PFCx = DeltaEpochs{i};
        
        %total amount
        down.all(k) = length(Start(down_PFCx));
        delta.all(k) = length(Start(deltas_PFCx));   
        
        
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
        down.delta(k) = sum(status);
        delta.down(k) = sum(status);

        down.only(k) = down.all(k) - down.delta(k);
        delta.only(k) = delta.all(k) - delta.down(k);
        
        %peak value
        peak_value(k) = depth_res.peak_value{p}(i);
        
        %increment
        k=k+1;
    end
        
end

%data
true_down   = down.delta ./ delta.all;
missed_down = down.only ./ down.all;
fake_down   = delta.only ./ delta.all;

[~,idx]     = sort(peak_value);
true_down   = true_down(idx);
missed_down = missed_down(idx);
fake_down   = fake_down(idx);
speak_value = peak_value(idx);


%% PLOT
figure, hold on
plot(speak_value, true_down, 'r')
plot(speak_value, missed_down, 'b')
plot(speak_value, fake_down, 'g')


%properties
legend('TP','Missed','FP'), xlabel('peak value during down states'), ylabel('%')


figure, hold on
scatter(true_down, missed_down, 25, speak_value,'filled')







