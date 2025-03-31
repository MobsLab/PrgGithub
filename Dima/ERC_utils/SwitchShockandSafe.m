%%% SwitchShockandSafe

clear all
%% Parameters
suf = 'TestPre';

%% Go to folder, load the data
for i=1:4
    indir = '/media/mobsrick/DataMOBS87/Mouse-787/11092018/TestPre/';
    cd([indir suf num2str(i)]);
    load ('behavResources.mat');

    %% Temporary arrays
    FreezeTime_temp = FreezeTime;
    Occup_temp = Occup;
%     Occupstd_temp = Occupstd;
    Zone_temp = Zone;
    ZoneEpoch_temp = ZoneEpoch;
    ZoneIndices_temp = ZoneIndices;

    %% Switch
    % Switch FreezeTime
    FreezeTime_temp(1) = FreezeTime(2);
    FreezeTime_temp(2) = FreezeTime(1);
    FreezeTime_temp(3) = FreezeTime(4);
    FreezeTime_temp(4) = FreezeTime(3);
    FreezeTime = FreezeTime_temp;
    clear FreezeTime_temp

    %% Switch Occup
    Occup_temp(1) = Occup(2);
    Occup_temp(2) = Occup(1);
    Occup_temp(3) = Occup(4);
    Occup_temp(4) = Occup(3);
    Occup = Occup_temp;
    clear Occup_temp

% %     Switch Occupstd
%     Occupstd_temp(1) = Occupstd(2);
%     Occupstd_temp(2) = Occupstd(1);
%     Occupstd_temp(3) = Occupstd(4);
%     Occupstd_temp(4) = Occupstd(3);
%     Occupstd = Occupstd_temp;
%     clear Occupstd_temp

    % Switch Zone
    Zone_temp(1) = Zone(2);
    Zone_temp(2) = Zone(1);
    Zone_temp(3) = Zone(4);
    Zone_temp(4) = Zone(3);
    Zone = Zone_temp;
    clear Zone_temp

    % Switch ZoneEpoch
    ZoneEpoch_temp(1) = ZoneEpoch(2);
    ZoneEpoch_temp(2) = ZoneEpoch(1);
    ZoneEpoch_temp(3) = ZoneEpoch(4);
    ZoneEpoch_temp(4) = ZoneEpoch(3);
    ZoneEpoch = ZoneEpoch_temp;
    clear ZoneEpoch_temp

    % Switch ZoneEpoch
    ZoneIndices_temp(1) = ZoneIndices(2);
    ZoneIndices_temp(2) = ZoneIndices(1);
    ZoneIndices_temp(3) = ZoneIndices(4);
    ZoneIndices_temp(4) = ZoneIndices(3);
    ZoneIndices = ZoneIndices_temp;
    clear ZoneIndices_temp

    %% Save
    save('behavResources.mat');
    clearvars -except suf
end