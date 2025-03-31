function [Trans,MnStayTime,NumEp,TotTime] = ProbabilitiesBehaviour_UMaze(Session)

FreezeEpoch=ConcatenateDataFromFolders_SB(Session,'epoch','epochname','freezeepoch_nosleep');
ZoneEpoch=ConcatenateDataFromFolders_SB(Session,'epoch','epochname','zoneepoch_nosleep');

% Organize zones in more intuitive order
ZoneEpoch = ZoneEpoch([1,4,3,5,2]);

BinSz = 1; % 1s
MaxTps = max([Stop(ZoneEpoch{1},'s');Stop(ZoneEpoch{2},'s');Stop(ZoneEpoch{3},'s');Stop(ZoneEpoch{4},'s');Stop(ZoneEpoch{5},'s')]);
TimeBins = [0:BinSz:MaxTps]*1E4;
clear Fz Zn

for tp = 1:length(TimeBins)-1
    LitEpoch = intervalSet(TimeBins(tp),TimeBins(tp+1));
    Fz(tp) = (not(isempty(Start(and(LitEpoch,FreezeEpoch)))));
    for zn = 1:5
        WhichZn(zn) = not(isempty(Start(and(LitEpoch,ZoneEpoch{zn})))) ;
    end
    try
        Zn(tp) = find(WhichZn);
    catch
        Zn(tp) = NaN;
    end
end
Zn = floor(naninterp(Zn));
Fz = Fz+1;


%% Manual corrections for when mice are freezing on edge of zone

[Trans,MnStayTime,NumEp,TotTime] = TransMatFromFzZn(Fz,Zn,BinSz);



end