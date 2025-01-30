

%% Make TTLInfo
StartFile = dir(['./OpenEphys/structure.oebin']);
TTLInfo_sess{1} = MakeData_TTLInfo_OpenEphys([pwd '/OpenEphys/events/Rhythm_FPGA-100.0_TTL_1.mat'] , StartFile.folder , ExpeInfo);

% Do the same as MakeData_TTLInfo_OpenEphys.m for TTL rip inhibition, dirty
sync_folder=[pwd '/OpenEphys'];
oebin = fileread([sync_folder '/structure.oebin']);
[~, sr_id] = regexp(oebin,'"sample_rate": ');
samplingrate = str2double(oebin(sr_id(1)+1:sr_id(1)+5));

sync = load([sync_folder '/continuous/continuous_Rhythm_FPGA-100.0.mat']);
starttime = sync.timestamps(1);

load([pwd '/OpenEphys/events/RippleDetector-105.0_TTL_2.mat']);

dig=4;

id_stimon = find(channel_states == dig);

TTLInfo_pre.StimEpoch2 = intervalSet(double((timestamps(id_stimon) - starttime))/samplingrate*1e4, ...
    double((timestamps(id_stimon)) - starttime)/samplingrate*1e4);


% Consider only stims during experiment session (ie during 0 to 480s part)
Sta=Start(TTLInfo_pre.StimEpoch2);
Sto=Stop(TTLInfo_pre.StimEpoch2);

Sta2=Sta(and(Sta>0 , Sta<480e4));
Sto2=Sto(and(Sta>0 , Sta<480e4));
%Sto=Sta+0.0005e4;

TTLInfo_pre.StimEpoch2 = intervalSet(Sta2 , Sto2);


% Concatenation of single session TTLs
TTLInfo = TTLInfo_sess{1};
try; TTLInfo.StimEpoch = intervalSet(Start(TTLInfo.StimEpoch) -TTLInfo.StartSession , Stop(TTLInfo.StimEpoch) -TTLInfo.StartSession); end
% TTLInfo.StimEpoch = intervalSet(Start(TTLInfo.StimEpoch) -TTLInfo.StartSession , Stop(TTLInfo.StimEpoch) -TTLInfo.StartSession);
TTLInfo.StimEpoch2 = intervalSet(Start(TTLInfo_pre.StimEpoch2) -TTLInfo.StartSession , Stop(TTLInfo_pre.StimEpoch2) -TTLInfo.StartSession);

save('behavResources.mat','TTLInfo','-append')
if exist('StimEpoch')>0
    save('behavResources.mat','StimEpoch','-append')
end


%% Create events
evt.time(1)=TTLInfo_sess{1, 1}.StartSession;
evt.time(2)=TTLInfo_sess{1, 1}.StopSession;

evt.description{1}='beginning of';
evt.description{2}='end of';

CreateEvent(evt, [cd filesep NewFolderName], 'cat')
movefile( [NewFolderName '.evt.cat'],[NewFolderName '.cat.evt'])


