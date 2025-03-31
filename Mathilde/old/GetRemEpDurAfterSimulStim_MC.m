function REMdurSimu = GetRemEpDurAfterSimulStim_MC(Wake, SWSEpoch, REMEpoch)

REMend=End(REMEpoch)./(1e4); % matrix with end times of all REM ep

load SimulatedStims RemStim
StimREM=Range(Restrict(RemStim,REMEpoch))./1E4;

for k=1:length(StimREM)
    RemEpDur=REMend-StimREM(k); % duration of REM ep after the stim
    %(smallest positive difference between the end of the REM ep and the time of the stim)
        if sum(RemEpDur>0)==0

        REMdurSimu(k)=NaN;
    else
        REMdurSimu(k)=min(RemEpDur(RemEpDur>0));
    end
end

end