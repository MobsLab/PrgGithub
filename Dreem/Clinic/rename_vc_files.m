%Rename virtual channel files

clear


cd('/home/karim/Dreem/ClinicalTrials')
[~,~,data_rec] = xlsread('ref_id.xls');

references = cell2mat(data_rec(:,2));
record_id = data_rec(:,1);
for i=1:length(record_id)
    record_id{i}=record_id{i}(1:36);
end

cd('/home/karim/Dreem/ClinicalTrials/virtual_channel')
d=dir();
filesh5 = {d(:).name};
filesh5 = sort(filesh5(3:end));

for i=1:length(filesh5)
    name_file = filesh5{i}(1:end-3);
    new_name = num2str(references(strcmpi(name_file,record_id)));
    movefile([name_file '.h5'], [new_name '.h5']);
end