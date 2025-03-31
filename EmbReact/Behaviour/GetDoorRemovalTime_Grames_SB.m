% drug sessions
% SessNames = {'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug'...
%     'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};

SessNames = {    'HabituationBlockedShock_EyeShock','HabituationBlockedSafe_EyeShock',...
    'ExtinctionBlockedShock_EyeShock' 'ExtinctionBlockedSafe_EyeShock'};


for ss = 1:length(SessNames)
    
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            if Dir.ExpeInfo{d}{dd}.nmouse>0
                
                
                cd(Dir.path{d}{dd})
                disp(Dir.path{d}{dd})
                clear Params Time frame_num vidFrame OBJ GotFrame
                load('behavResources_SB.mat','Params','Behav')
                
                if not(isfield(Params,'DoorRemoved'))

                    
                    keyboard
                    
                    Params.DoorRemoved = Time_GotFrame(frame_num);
                    save('behavResources_SB.mat','Params','-append')
                end
            end
        end
    end
end


% read the video with this
FolderName = uigetdir()
FirstGrame = find(Range(Behav.Ytsd,'s')>295,1,'first')
for i = FirstGrame:FirstGrame+1000
    
    prefac1=char; for ii=1:6-length(num2str(i)), prefac1=cat(2,prefac1,'0');end
    load([ FolderName filesep 'frame' prefac1 sprintf('%0.5g',i)]);
    imagesc(datas.image)
    pause(0.1)
end



