function FindJumpsWithAccelerometer_BM(FolderList,thr)

for f=1:length(FolderList)
    
    % load accelero
    load([FolderList{f} filesep 'behavResources.mat'], 'MovAcctsd')
    
    % Remove noise epoch
    try
        load([FolderList{f} filesep 'behavResources.mat'], 'TTLInfo')
        TTLInfo.StimEpoch;
    catch
        try
            load([FolderList{f} filesep 'behavResources_SB.mat'], 'TTLInfo')
            TTLInfo.StimEpoch;
        catch
            TTLInfo.StimEpoch = intervalSet([],[]);
        end
    end
    if isempty(TTLInfo.StimEpoch)
        TTLInfo.StimEpoch = intervalSet([],[]);
    end
    AroundStim = intervalSet(Start(TTLInfo.StimEpoch) , Start(TTLInfo.StimEpoch)+1e4);
    load([FolderList{f} filesep 'StateEpochSB.mat'], 'TotalNoiseEpoch','Epoch')
    Working_Epoch_pre = Epoch - TotalNoiseEpoch;
    Working_Epoch = Working_Epoch_pre - AroundStim;
    
    Acc = Restrict(MovAcctsd,Working_Epoch);
    smootime = .2;
    Acc_smooth = tsd(Range(Acc) , runmean(Data(Acc),ceil(smootime/median(diff(Range(Acc,'s'))))));
    
    JumpEp = thresholdIntervals(Acc_smooth,thr,'Direction','Above');
    JumpEp = dropLongIntervals(JumpEp,4*1e4);
    JumpEp = mergeCloseIntervals(JumpEp,0.5*1e4);
    
    load([FolderList{f} filesep 'behavResources_SB.mat'],'Behav')
    Behav.JumpEpoch = JumpEp;
    
    save([FolderList{f} filesep 'behavResources_SB.mat'],'Behav','-append')
    clear Behav
    
end
