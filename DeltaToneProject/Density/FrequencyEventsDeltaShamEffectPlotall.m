% FrequencyEventsDeltaShamEffectPlotall
% 13.12.2016 KJ
%
% plot data about the density of delta, for all records
% 
% 
%   see FrequencyEventsDeltaShamEffect FrequencyEventsDeltaShamEffect_bis FrequencyEventsDeltaShamEffect2 
%

%% load
clear
eval(['load ' FolderProjetDelta 'Data/FrequencyEventsDeltaShamEffect.mat'])

animals = unique(frequency_res.name); %Mice
conditions = unique(frequency_res.manipe); %Conditions

%params
smoothing = 1;

x_rec1 = [2 3 3 2];
y_rec1 = [0 0 1.5 1.5];
x_rec2 = [4 5 5 4];
y_rec2 = [0 0 1.5 1.5];

x = linspace(1,6,length(frequency_res.deltas.density{1})+1);
x = x(1:end-1);
    
for cond=1:length(conditions)
        figure, hold on
        %loop over records
        for p=1:length(frequency_res.path) 
            if strcmpi(frequency_res.manipe{p},conditions{cond})
                plot(x, Smooth(frequency_res.deltas.density{p},smoothing)*1E4)
            end
        end
        title(conditions{cond});
        

end