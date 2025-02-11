
%%
load('LFPData/LFP0.mat')
max(Range(LFP,'s'))
load('behavResources.mat', 'Xtsd')
max(Range(Xtsd,'s'))
load('behavResources_SB.mat')
for i=1:5
    p(i) = max(Start(Behav.ZoneEpoch{i},'s'));
end
p_max = max(p)

%%

load('LFPData/LFP0.mat')

% If LFP is the smallest
Epoch = intervalSet(0,max(Range(LFP)));

% If behaviour is the smallest
Epoch = intervalSet(0,max(Range(Xtsd)));

% If zone is the smallest
Epoch = intervalSet(0,p_max*1e4-1);

LFP = Restrict(LFP,Epoch);
save('LFPData/LFP0.mat','LFP')

load('behavResources.mat', 'Xtsd','Ytsd','Vtsd', 'Imdifftsd' ,'FreezeEpoch', 'ZoneEpoch')
load('behavResources_SB.mat', 'Behav')

Xtsd = Restrict(Xtsd,Epoch);
Ytsd = Restrict(Ytsd,Epoch);
Vtsd = Restrict(Vtsd,Epoch);
Imdifftsd = Restrict(Imdifftsd,Epoch);
FreezeEpoch = and(FreezeEpoch,Epoch);
for i=1:5
    ZoneEpoch{i} = and(ZoneEpoch{i},Epoch);
end

save('behavResources.mat','Xtsd','Ytsd','Vtsd','Imdifftsd','FreezeEpoch','ZoneEpoch','-append')

Behav.Xtsd = Restrict(Behav.Xtsd,Epoch);
Behav.Ytsd = Restrict(Behav.Ytsd,Epoch);
Behav.Vtsd = Restrict(Behav.Vtsd,Epoch);
Behav.ImDiffTsd = Restrict(Behav.ImDiffTsd,Epoch);
Behav.FreezeEpoch = and(Behav.FreezeEpoch,Epoch);
Behav.MovAcctsd = Restrict(Behav.MovAcctsd,Epoch);
Behav.FreezeAccEpoch = and(Behav.FreezeAccEpoch,Epoch);
for i=1:5
    Behav.ZoneEpoch{i} = and(Behav.ZoneEpoch{i},Epoch);
end
try, Behav.AlignedXtsd = Restrict(Behav.AlignedXtsd,Epoch);
Behav.AlignedYtsd = Restrict(Behav.AlignedYtsd,Epoch); end
try, Behav.LinearDist = Restrict(Behav.LinearDist,Epoch); end
try, Behav.JumpEpoch = and(Behav.JumpEpoch,Epoch); end

save('behavResources_SB.mat','Behav','-append')








