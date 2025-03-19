clear all
% Get all waveform ID for mice
DropBoxLocation = ['/home/vador/Dropbox/Kteam' filesep];
MiceNumber=[490,507,508,509,510,512,514];


for mm=1:length(MiceNumber)
    disp(MiceNumber(mm))
    % Get data location
    FileNames = GetAllMouseTaskSessions(MiceNumber(mm));
    
    % Classify waveforms on each session that is long enough (sleep)
    SleepSessions=find(~(cellfun(@isempty,strfind(FileNames,'Sleep'))));
    all_sess_id = [];
    all_sess_dist = [];
    all_sess_params = cell(1,3);
    all_sess_elec = [];
    
    for sl_sess=1:length(SleepSessions)
        cd(FileNames{SleepSessions(sl_sess)})
        load('MeanWaveform.mat','W')
        [UnitIDNew,AllParamsNew,~,BestElecNew,~] = MakeData_ClassifySpikeWaveforms(W,['/home/vador/Dropbox/Kteam' filesep],0);
        all_sess_id = [all_sess_id,UnitIDNew(:,1)];
        all_sess_dist = [all_sess_dist,UnitIDNew(:,2)];
        all_sess_elec = [all_sess_elec,cell2mat(BestElecNew)'];
        for p=1:3
            all_sess_params{p} = [all_sess_params{p},AllParamsNew(:,p)];
        end
        clear W
    end
    
    % Now get the average result over these sleep sessions
    UnitID(:,1) = mode(all_sess_id');
    UnitID(:,2) = mean(all_sess_dist');
    for p=1:3
        AllParams(:,p) = mean(all_sess_params{p}');
    end
    BestElec = num2cell(mode(all_sess_elec'));    
    % save to all 
    for sess = 1:length(FileNames)
        cd(FileNames{sess})
%         save('MeanWaveform.mat','AllParams','BestElec','-append')
%         save('WFIdentity.mat','UnitID')
    end
    clear UnitID  UnitID AllParams BestElec
end

