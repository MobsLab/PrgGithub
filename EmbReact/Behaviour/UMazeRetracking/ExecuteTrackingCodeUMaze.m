tic
for k=1:length(SessOfInterest)
    for l=1:max([length(SubSession{k}),1])
        cd(FolderNameAllUMaze{1}{k,l})
        load('behavResources.mat','ref','mask','pixratio')
        save('InfoTrackingOffline.mat','ref','mask','pixratio','-append')
        load('InfoTrackingOffline.mat')
        cd(FolderNameAllUMaze{2}{k,l})
        FolderNameAllUMaze{1}{k,l}
        ExecuteOffLineUMazeTracking
        cd ..
        save('ResultsTrackinfOfflineBis.mat','PosMat','im_diff')
        clear('PosMat','im_diff')
    end
end
toc