%TableQuantitySleep
% 10.07.2017 KJ
%
% Table quantifying sleep duration, for each sleep stage and many conditions 
%
%
%%%%%

clear


%% load
load([FolderPrecomputeDreem 'ClinicQuantitySleepNew.mat']) 
conditions = unique(quantity_res.condition(~cellfun(@isempty, quantity_res.condition)));
subjects = unique(cell2mat(quantity_res.subject));
for p=1:length(quantity_res.subject)
   if isempty(quantity_res.subject{p})
       quantity_res.subject{p}=-1;
   end
end


% params
stages_den = 1:5;
ind_scorer = 3; %pascal
idx_plot = 1:length(hours_expe); %Whole night
NameStat = {'N1','N2','N3','REM','W','NREM','N2-N3','SOL','WASO','Sleep Efficiency'};
stat_field(7:9) = {'sol','waso','sleep_efficiency'};
coeff = [100 100 100 100 100 100 1E-4 1E-4 100];



%% loop over sleep stages
SleepData.mean = cell(0);
SleepData.sem = cell(0);

for stat=1:9
    %conditions
    for cond=1:length(conditions)
        data_cond = [];
        path_cond = find(strcmpi(quantity_res.condition,conditions{cond}));
        
        if stat<7 %sleep stages
            if stat==6
                stages_num=2:3;
            else
                stages_num=stat;
            end
            
            for p=1:length(path_cond)
                if ~isempty(quantity_res.sleepstages.hours{path_cond(p),ind_scorer})
                    data_num = sum(sum(quantity_res.sleepstages.hours{path_cond(p),ind_scorer}(idx_plot,stages_num)));
                    data_den = sum(sum(quantity_res.sleepstages.hours{path_cond(p),ind_scorer}(idx_plot,stages_den)));

                    data_cond(p) = data_num / data_den;
                end
            end
        else %stat (sol,waso,sleep eff)
            for p=1:length(path_cond)
                data_cond = [data_cond quantity_res.sleepstages.(stat_field{stat}){path_cond(p),ind_scorer}];
            end
        end
        
        [R,~,E]=MeanDifNan(data_cond);
        SleepData.mean{stat,cond} = R * coeff(stat);
        SleepData.sem{stat,cond} = E * coeff(stat);

    end
end






