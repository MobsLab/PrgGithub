%%LFPonDownStatesLayerPlot
% 24.01.2018 KJ
%
% meancurves on downstates, for many channels and many animals
%
%   see 
%       LFPonDownStatesLayer
%

%load
clear
load(fullfile(FolderDeltaDataKJ,'LFPonDownStatesLayer.mat'))

%params
animals = unique(layer_res.name);
coloranimals = {'b','k','r','g','c','m',[0.5 0.5 0.5]};
range_peakvalue = [-2000 -700 200 600 1100 1600 2000 3000];
colorpeakvalue = {'b','g',[0.5 0.5 0.5],'m','k','c','r'};



%% find peak value
for p=1:length(layer_res.path)
    curves = layer_res.down.meancurves2{p};
    for ch=1:length(curves)
        x = curves{ch}(:,1);
        y = curves{ch}(:,2);
        
        y = y(x>0 & x<200);
        if sum(y)>0
            peak_value(p,ch)=max(y);
        else
            peak_value(p,ch)=min(y);
        end
    end
end
peak_value(peak_value==0)=nan;
peak_value(21:22,:)=nan; %no ripples



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT PER PEAK VALUE
figure, hold on
for k=1:length(range_peakvalue)-1
    
    c = colorpeakvalue{k};
    
    for p=1:size(peak_value,1)
        for ch=1:size(peak_value,2)
            if peak_value(p,ch)>=range_peakvalue(k) && peak_value(p,ch)<range_peakvalue(k+1)
                
                %Down states mean curves
                curve_down = layer_res.down.meancurves2{p}{ch};
                subplot(1,2,1), hold on
                plot(curve_down(:,1), curve_down(:,2), 'color', c), hold on
                title('On down states'), xlim([-200 400]),
                
                
                %Ripples mean curves
                curve_ripple = layer_res.ripples.meancurves{p}{ch};
                subplot(1,2,2), hold on
                plot(curve_ripple(:,1), curve_ripple(:,2), 'color', c), hold on
                title('On ripples'), xlim([-200 400]),
            end
        end
    end
    
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% MULTIPLOT PER PEAK VALUE
% for k=1:length(range_peakvalue)-1
%     figure, hold on
%     
%     for p=1:size(peak_value,1)
%         for ch=1:size(peak_value,2)
%             if peak_value(p,ch)>=range_peakvalue(k) && peak_value(p,ch)<range_peakvalue(k+1)
%                 
%                 %Down states mean curves
%                 curve_down = layer_res.down.meancurves2{p}{ch};
%                 subplot(2,1,1), hold on
%                 plot(curve_down(:,1), curve_down(:,2)), hold on
%                 title('On down states'),
%                 
%                 
%                 %Ripples mean curves
%                 curve_ripple = layer_res.ripples.meancurves{p}{ch};
%                 subplot(2,1,2), hold on
%                 plot(curve_ripple(:,1), curve_ripple(:,2)), hold on
%                 title('On ripples'),
%                 ylim([-1000 1000])
%             end
%         end
%     end
%     
%     namefig = ['Amplitude ' num2str(range_peakvalue(k)) '-' num2str(range_peakvalue(k+1)) 'mV']
%     suplabel(namefig,'t');
%     
% end

% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% PLOT PER ANIMALS
% 
% %% down1
% figure, hold on
% 
% %for different record
% for p=1:length(layer_res.path)
%     
%     curves = layer_res.down.meancurves1{p};
%     c = coloranimals{strcmpi(layer_res.name{p},animals)};
%     %several channels per record
%     for ch=1:length(curves)
%         plot(curves{ch}(:,1), curves{ch}(:,2), 'color', c), hold on
%     end
%     
% end
% xlabel('Time (s)'), ylabel('Amplitude'),
% title(['Mean LFP averaged on down state onset (' num2str(durations1(1)/10) '-' num2str(durations1(2)/10) 'ms)'])
% 
% 
% %% down2
% figure, hold on
% 
% %for different record
% for p=1:length(layer_res.path)
%     
%     curves = layer_res.down.meancurves2{p};
%     c = coloranimals{strcmpi(layer_res.name{p},animals)};
%     %several channels per record
%     for ch=1:length(curves)
%         plot(curves{ch}(:,1), curves{ch}(:,2), 'color', c), hold on
%     end
%     
% end
% xlabel('Time (s)'), ylabel('Amplitude'),
% title(['Mean LFP averaged on down state onset (' num2str(durations2(1)/10) '-' num2str(durations2(2)/10) 'ms)'])
% 
% 
% %% ripples
% figure, hold on
% 
% %for different record
% for p=1:length(layer_res.path)
%     
%     curves = layer_res.ripples.meancurves{p};
%     c = coloranimals{strcmpi(layer_res.name{p},animals)};
%     %several channels per record
%     for ch=1:length(curves)
%         if ~isempty(curves{ch})
%             plot(curves{ch}(:,1), curves{ch}(:,2), 'color', c), hold on
%         end
%     end
%     
% end
% xlabel('Time (s)'), ylabel('Amplitude'),
% title('Mean LFP averaged on SPW-r')
% 
