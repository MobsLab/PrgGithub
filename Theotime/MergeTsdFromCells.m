function [all_data1, all_data2] = MergeTsdFromCells(struct_cell1, struct_cell2)

all_data1 = []; % Collect all timestamps
all_data2 = [];

numTSDs = length(struct_cell1);
assert(numTSDs == length(struct_cell2))

for i = 1:numTSDs
    if ~strcmp(class(struct_cell1{i}),'tsd') || ~strcmp(class(struct_cell2{i}), 'tsd')
        disp('Removing empty cell')
        continue
    end
    [common_time, d1, d2] = PrepareTsds(struct_cell1{i}, struct_cell2{i});
    all_data1 = [all_data1; d1];
    all_data2 = [all_data2; d2];
end
