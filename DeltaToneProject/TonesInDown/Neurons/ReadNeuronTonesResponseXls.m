% ReadNeuronTonesResponseXls
% 07.09.2018 KJ
%
%   Extract the responses of neurons to Tones, in different conditions
%
%   see 
%       ReadSlowdynDataset


clear

%params
filename = [FolderProjetDelta 'neurons_tones.xlsx'];

%sheets
[~,sheets] = xlsfinfo(filename);

%read
for k=1:length(sheets)

    p = str2num(sheets{k}(1));
    
    [~,~,raw]  = xlsread(filename,k);
    
    brain_area = raw(2:end,2);
    headers = raw(1,[1 3:end]);
    
    raw = cell2mat(raw(2:end,[1 3:end]));
    raw(isnan(raw)) = 0;

    %% Responses
    for i=2:size(raw,2)
        responses.(headers{i}){p} = raw(:, i);
    end
    responses.area{p} = brain_area;
    MatResp{p} = raw(:,2:end);

end


%% save
cd(FolderDeltaDataKJ)
save neuronResponseTones.mat MatResp responses



