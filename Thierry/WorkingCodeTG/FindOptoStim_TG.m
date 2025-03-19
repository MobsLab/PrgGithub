function [Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_TG(Wake, SWSEpoch, REMEpoch, ThetaEpoch)


% WakeTheta= and(Wake,ThetaEpoch);

load LFPData/DigInfo4 DigTSD
digTSD=DigTSD;

TTLEpoch= thresholdIntervals(digTSD,0.99,'Direction','Above');      % column of time above .99 to get ON stim
TTLEpoch_merged= mergeCloseIntervals(TTLEpoch,1e4); % merge all stims times closer to 1s to avoid slots and replace it with an entire step of 1 min

% for j = 1:length(Start(TTLEpoch_merged))
%     LittleEpoch = subset(TTLEpoch_merged,j);
%     FreqStim  = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
% end

Stim=Start(TTLEpoch_merged)/1E4;    % to find opto stimulations
Stimts=ts(Stim*1e4);


% StimREM=Range(Restrict(ts(Stim*1e4)),REMEpoch);   % to find opto stim in each state
% StimSWS=Range(Restrict(ts(Stim*1e4)),SWSEpoch);
% StimWake=Range(Restrict(ts(Stim*1e4)),Wake);

%% Stim in Epoch without noise
% StimWake=Range(Restrict(Stimts,Wake));
% StimSWS=Range(Restrict(Stimts,SWSEpoch));
% StimREM=Range(Restrict(Stimts,REMEpoch));

%% Stim in Epoch with noise
StimWake=Range(Restrict(Stimts,WakeWiNoise));
StimSWS=Range(Restrict(Stimts,SWSEpochWiNoise));
StimREM=Range(Restrict(Stimts,REMEpochWiNoise));
Stim=size(Start(TTLEpoch_merged),1)

end