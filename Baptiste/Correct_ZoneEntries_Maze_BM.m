


function [ShockZoneEpoch_Corrected , SafeZoneEpoch_Corrected] = Correct_ZoneEntries_Maze_BM(ShockZoneEpoch , SafeZoneEpoch)


clear StaShock StoShock StaSafe StoSafe
StaShock = Start(ShockZoneEpoch); StoShock=Stop(ShockZoneEpoch);
StaSafe = Start(SafeZoneEpoch); StoSafe=Stop(SafeZoneEpoch);

% zone epoch only considered if longer than 1s and merge with 1s
try
    clear ind_to_use_shock; ind_to_use_shock = StoShock(1:end-1)==StaShock(2:end);
    StaShock=StaShock([true ; ~ind_to_use_shock]);
    StoShock=StoShock([~ind_to_use_shock ; true]);
    ShockZoneEpoch_Corrected=intervalSet(StaShock , StoShock);
    ShockZoneEpoch_Corrected=dropShortIntervals(ShockZoneEpoch_Corrected,1e4);
    ShockZoneEpoch_Corrected=mergeCloseIntervals(ShockZoneEpoch_Corrected,1e4);
catch
    ShockZoneEpoch_Corrected = intervalSet([],[]);
end

try
    clear ind_to_use_safe; ind_to_use_safe = StoSafe(1:end-1)==StaSafe(2:end);
    StaSafe=StaSafe([true ; ~ind_to_use_safe]);
    StoSafe=StoSafe([~ind_to_use_safe ; true]);
    SafeZoneEpoch_Corrected=intervalSet(StaSafe , StoSafe);
    SafeZoneEpoch_Corrected=dropShortIntervals(SafeZoneEpoch_Corrected,1e4);
    SafeZoneEpoch_Corrected=mergeCloseIntervals(SafeZoneEpoch_Corrected,1e4);
catch
    SafeZoneEpoch_Corrected = intervalSet([],[]);
end









