% TonesEffectEpisodeDuration_bis
% 12.04.2017 KJ
%
% Format data to study the effect of tones on substage episode duration
% 
% 
%   see TonesAtTransitionSWSSubstageDuration_bis1 TonesEffectEpisodeDuration
%



clear
load([FolderProjetDelta 'Data/TonesEffectEpisodeDuration.mat']) 

conditions = unique(episodedur_res.condition);
cond_basal = find(strcmpi(conditions,'Basal'));

%params
NamesSubstages = {'N1','N2','N3','REM','Wake'};


%% Concatenate data
%Tone & sham
for cond=1:length(conditions)
    for sub=substage_ind
        delay_tone = [];
        duration_sub = [];
        success_tone = [];

        %loop over records
        for p=1:length(episodedur_res.path)
            if strcmpi(episodedur_res.condition{p},conditions{cond})
                delay_tone = [delay_tone ; episodedur_res.tone_delay{p,sub}];
                duration_sub = [duration_sub ; episodedur_res.substage_duration{p,sub}];
                success_tone = [success_tone ; episodedur_res.tone_sucess{p,sub}];
            end
        end

        success.delay{cond,sub} = delay_tone(success_tone==1 & duration_sub-delay_tone>0);
        success.duration{cond,sub} = duration_sub(success_tone==1 & duration_sub-delay_tone>0);
        failed.delay{cond,sub} = delay_tone(success_tone==0 & duration_sub-delay_tone>0);
        failed.duration{cond,sub} = duration_sub(success_tone==0 & duration_sub-delay_tone>0);
        notone.duration{cond,sub} = duration_sub(duration_sub-delay_tone<=0);
    end
end


%Basal
for sub=substage_ind
    duration_sub = [];
    
    %loop over records
    for p=1:length(episodedur_res.path)
        if strcmpi(episodedur_res.condition{p},conditions(cond_basal))
            duration_sub = [duration_sub ; episodedur_res.substage_duration{p,sub}];
        end
    end
    basal.duration{sub} = duration_sub;
    
end


%saving data
cd([FolderProjetDelta 'Data/']) 
save TonesEffectEpisodeDuration_bis.mat conditions cond_basal success failed notone basal
save TonesEffectEpisodeDuration_bis.mat -append substage_ind NamesSubstages












