%Check record

clear


cd('/home/karim/Dreem/ClinicalTrials')
[~,~,data_rec] = xlsread('ref_id.xls');

references = cell2mat(data_rec(:,2));


%data in record folder
cd([FolderClinicTrial 'records'])
d=dir();
filesh5 = {d(:).name};
filesh5 = sort(filesh5(3:end));
for i=1:length(filesh5)
    filesh5{i}=str2num(filesh5{i}(1:end-3));
end
filesh5 = cell2mat(filesh5)';


%test
for r=1:length(references)
    if ~ismember(references(r),filesh5)
        disp(references(r))
    end
end














