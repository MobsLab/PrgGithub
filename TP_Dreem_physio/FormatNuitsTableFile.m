% FormatNuitsTableFile
% 15.01.2023 KJ
%
%

clear


%% init - 
% insert the path to the nuits_tp_dreem Excel file
original_filename = 'C:\Users\KarimElKanbiINBRAIN\Downloads\TP_dreem_preprocessing\nuits_tp_dreem_original.xlsx';
output_filename = 'C:\Users\KarimElKanbiINBRAIN\Downloads\TP_dreem_preprocessing\nuits_tp_dreem.xlsx';

% read the excel file
table_nuits_tp = readtable(original_filename);
temp_data = table_nuits_tp; % temporary table to tranform

% first table formatting
table_nuits_tp(ismissing(table_nuits_tp.Ref),:) = [];
table_nuits_tp = removevars(table_nuits_tp, "Timeseries");

temp_data.Ref = fillmissing(temp_data.Ref,'previous');
[Ref_unique,~,Ref_index] = unique(temp_data.Ref);
ChannelQuality_lists = accumarray(Ref_index,temp_data.ChannelQuality, [], @(x){x});
quality_ch1 = cellfun(@(x) x(1), ChannelQuality_lists);
quality_ch2 = cellfun(@(x) x(2), ChannelQuality_lists);
[~, best_channel] = cellfun(@(x) max(x(1:2)), ChannelQuality_lists);

table_nuits_tp = removevars(table_nuits_tp, "ChannelQuality");
table_nuits_tp.QualityChannel1 = quality_ch1;
table_nuits_tp.QualityChannel2 = quality_ch2;
table_nuits_tp.BestChannel = best_channel;
table_nuits_tp = addvars(table_nuits_tp, nan(height(table_nuits_tp),1), 'NewVariableNames', 'Status');


% write data into the tabme
writetable(table_nuits_tp, output_filename);