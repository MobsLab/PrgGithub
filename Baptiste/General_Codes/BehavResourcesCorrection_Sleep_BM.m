

function BehavResourcesCorrection_Sleep_BM


if exist('behavResources_SB.mat')==0
    try
        load('behavResources.mat', 'Xtsd')
        load('behavResources.mat', 'Ytsd')
        load('behavResources.mat', 'Vtsd')
        
        Behav.Xtsd=Xtsd;
        Behav.Ytsd=Ytsd;
        Behav.Vtsd=Vtsd;
    end
    try
        load('behavResources.mat', 'MovAcctsd')
        Behav.MovAcctsd=MovAcctsd;
    end
    
    save('behavResources_SB.mat', 'Behav')
end
















