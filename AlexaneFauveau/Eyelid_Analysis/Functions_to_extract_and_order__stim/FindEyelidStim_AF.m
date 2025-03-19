function [Stim, StimSleep, StimWake, Stimts] = FindEyelidStim_AF(Wake,Sleep,ValueStim,system)

% Code based on FindOptoStim_MC by Mathilde

%Load stim digin
load('behavResources.mat', 'TTLInfo')
Stim = Start(TTLInfo.StimEpoch);

load('journal_stim.mat')
StimValue =  cell2mat(journal_stim(:,1));

Stim = Stim(StimValue==ValueStim);

if strcmp(lower(system),'OB')
    Stim = Stim-3;
end
    
Stimts = ts(Stim);

% order the stim
StimWake = Range(Restrict(Stimts,Wake));

StimSleep = Range(Restrict(Stimts,Sleep));
Stim = Range(Stimts);
end
