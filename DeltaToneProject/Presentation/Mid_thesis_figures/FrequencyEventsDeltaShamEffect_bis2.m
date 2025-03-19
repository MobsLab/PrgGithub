% FrequencyEventsDeltaShamEffect_bis2
% 17.12.2016 KJ
%
% collect data 
% 
% 
%   see FrequencyEventsDeltaShamEffect FrequencyEventsDeltaShamEffect_bis
%

%% load
clear
eval(['load ' FolderProjetDelta 'Data/FrequencyEventsDeltaShamEffect.mat'])

animals = unique(frequency_res.name); %Mice
conditions = unique(frequency_res.manipe); %Conditions
no=1;
yes=2;

for cond=1:length(conditions)
        deltas_dens=[];
        tones_dens = [];
        tsuccess_dens = []; %for delta
        tfailed_dens = []; %for delta
        
        %loop over records
        for p=1:length(frequency_res.path)
            if strcmpi(frequency_res.manipe{p},conditions{cond})
                deltas_dens = [deltas_dens frequency_res.deltas.density{p}/max(frequency_res.deltas.density{p})];
                tones_dens = [tones_dens frequency_res.tones_all.density{p}];
                
                success = frequency_res.tones_delta.density{p}{no,yes}' + frequency_res.tones_delta.density{p}{yes,yes}';
                tsuccess_dens = [tsuccess_dens success];
                failed = frequency_res.tones_delta.density{p}{no,no}' + frequency_res.tones_delta.density{p}{yes,no}';
                tfailed_dens = [tfailed_dens failed];
                
            end
        end
        
        nb_night.all{cond} = size(deltas_dens,2);
        deltas.all.density{cond} = nanmean(deltas_dens,2);
        events.all.density{cond} = mean(tones_dens,2);
        events.success.density{cond} = mean(tsuccess_dens,2);
        events.failed.density{cond} = mean(tfailed_dens,2);
end

%saving data
cd([FolderProjetDelta 'Data/']) 
save FrequencyEventsDeltaShamEffect_bis2 nb_night deltas events nb_intervals sessions_ind conditions


