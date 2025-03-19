
load('behavResources.mat', 'tpsCatEvt')
for i = 1:length(tpsCatEvt)
    tpsCatEvt{i} = tpsCatEvt{i}*(2/3);
end

% If you have less than 3 phases (1-2)
SessionEpoch.firstrec = intervalSet(tpsCatEvt{1}*1e4  , tpsCatEvt{2}*1e4);
SessionEpoch.secondrec = intervalSet(tpsCatEvt{3}*1e4  , tpsCatEvt{4}*1e4);

% If you have 3 phases 9preExp, Exp, PostExp)
SessionEpoch.PreExp = intervalSet(tpsCatEvt{1}*1e4  , tpsCatEvt{2}*1e4);
SessionEpoch.Exp = intervalSet(tpsCatEvt{3}*1e4  , tpsCatEvt{4}*1e4);
SessionEpoch.PostExp = intervalSet(tpsCatEvt{5}*1e4  , tpsCatEvt{6}*1e4);


save('behavResources.mat','SessionEpoch','-append')



