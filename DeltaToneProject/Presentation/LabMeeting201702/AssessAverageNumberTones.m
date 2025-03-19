% AssessAverageNumberTones
% 20.02.2017 KJ
%
% Average number of tones and success tones per night
%
% 
%   see AnalyseSuccessDeltaTone FigureSuccessDelayDelta
%


%load
clear
eval(['load ' FolderProjetDelta 'Data/AnalyseSuccessDeltaTone.mat'])
animals = unique(tonesuccess_res.name);
conditions = unique(tonesuccess_res.condition);

%params
yes=2;
no=1;
colori = {'b',[0.1 0.15 0.1],[0.75 0.75 0.75],[0.4 0.4 0.4],'c','r'};
show_sig = 'sig';
optiontest='ranksum';
x = 1:length(conditions);


%% data
for cond=1:length(conditions)
    path_cond = find(strcmpi(tonesuccess_res.condition,conditions{cond}));
    data{cond} = zeros(2,2,length(path_cond));
    for p=1:length(path_cond)
        nb_delta = tonesuccess_res.all.delta{path_cond(p)};
        data{cond}(:,:,p) = cell2mat(nb_delta);
    end
    mean_tones{cond} = mean(data{cond},3);
end

%% PLOT - figure1

figure, hold on
%% all tones
for cond=1:length(conditions)    
    tones_value(cond,1) = sum(mean_tones{cond}(:,yes));
    tones_value(cond,2) = sum(mean_tones{cond}(:,no));
    percentage_success(cond) = 100*tones_value(cond,1) / (tones_value(cond,1)+tones_value(cond,2));
end

%plot
subplot(1,2,1), hold on
yyaxis right
plot(x, percentage_success, 'color','k','Linewidth',2);
ylim([0 60]),ylabel('sucess percentage'),
yyaxis left
color_stacked = {'b';'r'};
b=bar(x, tones_value, 'stacked'); hold on
set(b,{'FaceColor'},color_stacked);
set(gca, 'XTickLabel', conditions,'XTick',(1:numel(conditions))), hold on,
legend('Success Tones','Failed Tones'); 
%title('Average Number of success and failed tones')


%% distinguish triggered and not triggered
for cond=1:length(conditions)
    if strcmpi(conditions{cond},'RdmTone')
        tones_value2(cond,1) = mean_tones{cond}(no,yes);
        tones_value2(cond,2) =  mean_tones{cond}(yes,yes);
        tones_value2(cond,3) =  mean_tones{cond}(no,no);
        tones_value2(cond,4) =  mean_tones{cond}(yes,no);
    else
        tones_value2(cond,1) = mean_tones{cond}(no,yes);
        tones_value2(cond,2) =  mean_tones{cond}(yes,yes);
        tones_value2(cond,3) =  mean_tones{cond}(no,no);
        tones_value2(cond,4) =  mean_tones{cond}(yes,no);
    end
    
end

%plot
subplot(1,2,2), hold on
color_stacked = {'c';'b';'k';'r'};
b=bar(x, tones_value2, 'stacked'); hold on
set(b,{'FaceColor'},color_stacked);
set(gca, 'XTickLabel', conditions,'XTick',(1:numel(conditions))), hold on,
legend('Not trig - success Tones','Trig - success Tones','Not trig - failed Tones','Trig - failed Tones'); 
%title('Average Number of success and failed tones')

suplabel('Average Number of success and failed tones','t');




