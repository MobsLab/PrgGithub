

%% correct when Matlab crashes

GetEmbReactMiceFolderList_BM

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(CondSess.(Mouse_names{mouse}))
        cd(CondSess.(Mouse_names{mouse}){sess})
        
        load('behavResources_SB.mat', 'TTLInfo')
        if sum(size(Start(TTLInfo.StimEpoch)) == [1 0])==2
            TTLInfo.StimEpoch = intervalSet([],[]);
            disp(pwd)
            disp('corrected')
        end
        save('behavResources_SB.mat', 'TTLInfo','-append')
        save('behavResources.mat', 'TTLInfo','-append')
    end
end





 Mouse=[1267 1269 1304 1351 41305 41349 41350 41352 1305,1350,1352 ,1349 41266,41268,41269,41351];
 Mouse=[1349];



