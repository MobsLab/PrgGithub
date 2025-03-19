% drug sessions
SessNames = {'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug'...
    'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};

% drug sessions
SessNames = {'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug'...
    'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};
% SessNames = {    'HabituationBlockedShock_EyeShock','HabituationBlockedSafe_EyeShock',...
%     'ExtinctionBlockedShock_EyeShock' 'ExtinctionBlockedSafe_EyeShock'};


for ss = 4:length(SessNames)
    
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            if Dir.ExpeInfo{d}{dd}.nmouse>875
                
                
                cd(Dir.path{d}{dd})
                disp(Dir.path{d}{dd})
                clear Params Time frame_num vidFrame OBJ GotFrame
                load('behavResources_SB.mat','Params','Behav')
                load('behavResources.mat','GotFrame')
                
                if not(isfield(Params,'DoorRemoved'))
                    [file,path] = uigetfile('*.avi');
                    OBJ = VideoReader([path,file]);
                    
                    Time = Range(Behav.Ytsd,'s');
                    try
                        Time_GotFrame = Time(find(GotFrame));
                    catch
                        Time_GotFrame =Time;
                        disp('Not got frame')
                    end
                    frame_num = 1;
                    
                    keyboard
                    
                    Params.DoorRemoved = Time_GotFrame(frame_num);
                    save('behavResources_SB.mat','Params','-append')
                end
            end
        end
    end
end


% read the video with this
Dir.ExpeInfo{d}{dd}.DrugInjected
d/length(Dir.path)
while hasFrame(OBJ)
    vidFrame = readFrame(OBJ);
    vidFrame = squeeze(vidFrame(:,:,1));
%     if Time_GotFrame(frame_num)>290
        imagesc(vidFrame)
        title(num2str(Time_GotFrame(frame_num)))
        pause(0.01)
        
%     end
    frame_num = frame_num+1;
end

