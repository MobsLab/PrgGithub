function [Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise)
 
%merge close REM ep and clean other states
% REMEpochWiNoise  = mergeCloseIntervals(REMEpochWiNoise,3E4);
% SWSEpochWiNoise = SWSEpochWiNoise - REMEpochWiNoise;
% WakeWiNoise =  WakeWiNoise - REMEpochWiNoise;

%load stim digin
load LFPData/DigInfo4;
% load LFPData/DigInfo5;

digTSD = DigTSD;
TTLEpoch = thresholdIntervals(digTSD,0.99,'Direction','Above');  % column of time above .99 to get ON stim
TTLEpoch_merged= mergeCloseIntervals(TTLEpoch,1e4); % merge all stims times closer to 1s to avoid slots and replace it with an entire step of 1 min

Stim = Start(TTLEpoch_merged)/1E4;  % to find opto stimulations
Stimts = ts(Stim*1e4);
% Stimts_1s =ts((Stim-1)*1e4);

StimWake = Range(Restrict(Stimts,WakeWiNoise));
StimSWS = Range(Restrict(Stimts,SWSEpochWiNoise));
StimREM = Range(Restrict(Stimts,REMEpochWiNoise));
Stim = Range(Stimts);

% StimWake=Range(Restrict(Stimts,WakeWiNoise));
% StimSWS=Range(Restrict(Stimts,SWSEpochWiNoise));
% StimREM=Range(Restrict(Stimts,REMEpochWiNoise));

% StimREM = StimREM(find(StimREM>0,1,'first'));
% StimSWS = StimSWS(find(StimSWS>0,1,'first'));
% StimWake = StimWake(find(StimWake>0,1,'first'));

end
