clear all


MiceNumber = [756 757 758 759 761 762 763 764 765 760];

% m = 2;

% for m = 1 : length(MiceNumber)

% cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/BeforeInjection/FEAR-Mouse-',num2str(MiceNumber(m)),'-12062018-Hab_00'])
% cd(['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_UMazeCondBlockedShock_PostDrug/Cond2/raw/FEAR-Mouse-688-09022018-CondWallShock_03/'])
cd(['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_ExtinctionBlockedShock_PostDrug/Ext1/raw/FEAR-Mouse-739-29052018-BlockedWall_02/'])

% OBJ = VideoReader('F12062018-0000.avi');
% OBJ = VideoReader('F09022018-0000.avi');
OBJ = VideoReader('F29052018-0000.avi');

load('behavResources.mat','PosMat')
dt = median(diff(PosMat(:,1)));
Time10Frames = floor(1/dt);
i=1;
click_number = 1;

while hasFrame(OBJ)
    vidFrame = readFrame(OBJ);
    vidFrame = squeeze(vidFrame(:,:,1));
    
    if rem(i-1,Time10Frames) == 0
        click_number
        imagesc(vidFrame);
        title('click on eye')
        [X,Y] = ginput(1);
        if X>250% & Y<50
            Temp_eye(click_number) = NaN;
        else
            try
                Temp_eye(click_number) = vidFrame(floor(Y),floor(X));
            catch
                Temp_eye(click_number) = NaN;
            end
        end
        
        title('click on body')
        [X,Y] = ginput(1);
        if X>250% & Y<50
            Temp_body(click_number) = NaN;
        else
            try
                Temp_body(click_number) = vidFrame(floor(Y),floor(X));
            catch
                Temp_body(click_number) = NaN;
            end
        end
        
        title('click on tail')
        [X,Y] = ginput(1);
        if X<50 & Y<50
            Temp_tail(click_number) = NaN;
        else
            try
                Temp_tail(click_number) = vidFrame(floor(Y),floor(X));
            catch
                Temp_tail(click_number) = NaN;
            end
        end
        
        
        Temp_max(click_number) = max(max(vidFrame));
        Temp_time(click_number) = PosMat(i,1);
        click_number = click_number+1;
    end
    
    i=i+1;
end

Temp_eye = double(Temp_eye);
Temp_eye(Temp_eye==0) = NaN;

Temp_tail = double(Temp_tail);
Temp_tail(Temp_tail==0) = NaN

Temp_body = double(Temp_body);
Temp_body(Temp_body==0) = NaN;

Temp_max = double(Temp_max);
Temp_max(Temp_max==0) = NaN;

save('ManualTemp.mat','Temp_time','Temp_eye','Temp_tail','Temp_body','Temp_max')

clear Temp_time Temp_eye Temp_tail Temp_body Temp_max click_number i
% end