%  List of acronyms: Primary Visual Area (VISp),
% Posterolateral visual area (VISpl)
% Laterointermediate area (VISli), Lateral visual area (VISl)
 %Anteromedial visual area (VISal), Laterolateral anterior visual area (VISlla)
% Rostrolateral visual area (VISrl), 
% Anteromedial visual area (VISam),
% Posteromedial visual area (VISpm),
% Medial visual area (VISm),
%  Mediomedial anterior visual area (VISmma), 
% Mediomedial  posterior visual area (VISmmp).

clear all
cd /media/nas8-2/AllenBrain_VisualData/visual_coding_psth_output_mat/
load('session_715093703_psth_data.mat')

Orientations = unique(stimulus_info_per_trial.orientation);
SpatialFrequency = unique(stimulus_info_per_trial.spatial_frequency);

for or = 1:length(Orientations)
    
    AllOr = find(stimulus_info_per_trial.orientation==Orientations(or));
    HalfOr = randperm(length(AllOr));
   OrientationTuningALl(or,:) = nanmean(nanmean(psth_data_all_trials(:,AllOr,:),2),3);
   OrientationTuning(or,:) = nanmean(nanmean(psth_data_all_trials(:,AllOr(HalfOr(1:length(HalfOr)/2)),:),2),3);
   OrientationTuning_CV(or,:) = nanmean(nanmean(psth_data_all_trials(:,AllOr(HalfOr(length(HalfOr)/2+1:end)),:),2),3);
end

[val,ind] = max(OrientationTuning);
[val,ind] = sort(ind);


[val,ind] = sort(stimulus_info_per_trial.orientation);

clf
neur = neur+1
subplot(3,1,1:2)
imagesc(psth_time_bin_centers, 1:length(ind),squeeze(psth_data_all_trials(neur,ind,10:40)))
title(visual_unit_areas{neur})
subplot(3,1,3)
plot(OrientationTuningALl(:,neur))
hold on
plot(OrientationTuning(:,neur))
plot(OrientationTuning_CV(:,neur))



