% FrequencyDeltaPerSession2
% 30.11.2016 KJ
%
% collect data for the evaluation of the frequency of delta/tones per
% session
%
% Here, the data are collected
%
%   see FrequencyDeltaPerSession
%
%


%load
clear
eval(['load ' FolderProjetDelta 'Data/FrequencyDeltaPerSession.mat'])

manipes = unique(frequency_res.manipe);

for manip=1:length(manipes)
    for s=1:length(sessions)
        durations{manip,s} = [];
        deltas.nb{manip,s} = [];
        deltas.frequency{manip,s} = [];
        downs.nb{manip,s} = [];
        downs.frequency{manip,s} = [];
        
        for p=1:length(frequency_res.path)
            if strcmpi(frequency_res.condition{p},conditions{manip})
            
                deltas.nb{manip,s} = [deltas.nb{manip,s} frequency_res.deltas.nb(p,s)];
                deltas.frequency{manip,s} = [deltas.frequency{manip,s} frequency_res.deltas.frequency(p,s)];
                downs.nb{manip,s} = [downs.nb{manip,s} frequency_res.downs.nb(p,s)];
                downs.frequency{manip,s} = [downs.frequency{manip,s} frequency_res.downs.frequency(p,s)];
                durations{manip,s} = [durations{manip,s} frequency_res.durations(p,s)];
            end
        end
    end
end

clearvars -except deltas downs durations manipes sessions


%% plot
%params
scattersize = 50;
NameSessions = {'S1','S2','S3','S4','S5'};
ConditionColors = {'k','b','y'};


figure, hold on
for manip=1:length(manipes)
    try
        x = deltas.frequency{manip,1};
        y = deltas.frequency{manip,2};
        scatter(x,y,scattersize,ConditionColors{manip},'filled'), hold on
    end
end
legend(manipes)
plot(linspace(0,1.3,1000),linspace(0,1.3,1000),'k'), hold on
xlabel('Delta Frequency (S1)'); ylabel('Delta Frequency (S2)');
title('Delta Frequency - S1 vs S2')



