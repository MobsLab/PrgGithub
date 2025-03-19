function REMdurOpto = GetRemEpDurAfterStim_MC(Wake, SWSEpoch, REMEpoch)

REMend=End(REMEpoch)./(1e4); % matrix with end times of all REM ep

[Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC; % to get the times of every stim during REM sleep
StimREM = StimREM./1E4;


for k=1:length(StimREM)
    RemEpDur=REMend-StimREM(k); % duration of REM ep after the stim
    %(smallest positive difference between the end of the REM ep and the time of the stim)
        if sum(RemEpDur>0)==0

        REMdurOpto(k)=NaN;
    else
        REMdurOpto(k)=min(RemEpDur(RemEpDur>0));
    end
end

end
