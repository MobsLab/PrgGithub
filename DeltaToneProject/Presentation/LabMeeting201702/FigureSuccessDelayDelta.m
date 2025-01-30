% FigureSuccessDelayDelta
% 18.02.2017 KJ
%
% Success rate in function of the delay between delta waves and tones (in DeltaToneConditions)
%   - for tone triggered or not triggered
%
% 
%   see AnalyseSuccessDeltaTone FigureSuccessRateDelay
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


%% Plot
figure, hold on

%Success ratio for TRIGGERED
subplot(1,2,1), hold on
for cond=1:length(conditions)
    data{cond} = [];    
    for p=1:length(tonesuccess_res.path)
        if strcmpi(tonesuccess_res.condition{p}, conditions{cond})
            nb_delta = tonesuccess_res.all.delta{p};
            ratio = nb_delta{yes,yes} / (nb_delta{yes,yes} + nb_delta{yes,no});
            data{cond} = [data{cond} ratio*100];
        end
    end
    
end
data{length(conditions)+1} = [];
for p=1:length(tonesuccess_res.path)
    if strcmpi(tonesuccess_res.manipe{p}, 'DeltaToneAll')
        nb_delta = tonesuccess_res.all.delta{p};
        ratio = nb_delta{yes,yes} / (nb_delta{yes,yes} + nb_delta{yes,no});
        data{length(conditions)+1} = [data{length(conditions)+1} ratio*100];
    end
end

labels = conditions(2:end);
labels{end+1} = 'DeltaToneAll';
columntest=[2 3;3 4;4 5;3 5]-1; %exclude random

PlotErrorBarN_KJ(data(2:end), 'newfig',0,'paired',0,'barcolors',colori(2:end),'columntest',columntest,'ShowSigstar','sig','optiontest',optiontest);
ylabel('Percentage success'),
set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
title('TRIGGERED TONES')


%Success ratio for NOT Triggered
subplot(1,2,2), hold on
for cond=1:length(conditions)
    data{cond} = [];    
    for p=1:length(tonesuccess_res.path)
        if strcmpi(tonesuccess_res.condition{p}, conditions{cond})
            nb_delta = tonesuccess_res.all.delta{p};
            ratio = nb_delta{no,yes} / (nb_delta{no,yes} + nb_delta{no,no});
            data{cond} = [data{cond} ratio*100];
        end
    end
    
end
data{length(conditions)+1} = [];
for p=1:length(tonesuccess_res.path)
    if strcmpi(tonesuccess_res.manipe{p}, 'DeltaToneAll')
        nb_delta = tonesuccess_res.all.delta{p};
        ratio = nb_delta{no,yes} / (nb_delta{no,yes} + nb_delta{no,no});
        data{length(conditions)+1} = [data{length(conditions)+1} ratio*100];
    end
end

labels = conditions;
labels{end+1} = 'DeltaToneAll';

PlotErrorBarN_KJ(data, 'newfig',0,'paired',0,'barcolors',colori,'ShowSigstar','sig','optiontest',optiontest);
set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
title('NOT Triggered TONES')

%main title
suplabel('Percentage of tones evoking delta waves','t');













% %Number of tones
% subplot(1,2,2), hold on
% for cond=1:length(conditions)
%     data{cond} = [];    
%     for p=1:length(tonesuccess_res.path)
%         if strcmpi(tonesuccess_res.condition{p}, conditions{cond})
%             nb_tones = tonesuccess_res.all.delta{p};
%             nb_tones = nb_tones{yes,yes} + nb_tones{yes,no};
%             data{cond} = [data{cond} nb_tones];
%         end
%     end
%     
% end
% data{length(conditions)+1} = [];
% for p=1:length(tonesuccess_res.path)
%     if strcmpi(tonesuccess_res.manipe{p}, 'DeltaToneAll')
%         nb_tones = tonesuccess_res.all.delta{p};
%         nb_tones = nb_tones{yes,yes} + nb_tones{yes,no};
%         data{length(conditions)+1} = [data{length(conditions)+1} nb_tones];
%     end
% end
% 
% labels = conditions;
% labels{end+1} = 'DeltaToneAll';
% 
% PlotErrorBarN_KJ(data, 'newfig',0,'paired',0,'barcolors',colori,'ShowSigstar','none','optiontest',optiontest);
% ylabel('Percentage success'),
% set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
% title('Number of tones')

