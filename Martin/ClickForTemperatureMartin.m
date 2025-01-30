clear all

% All commented lines were commented by Dima and KarimSr 8.7.19

% Put files of interest here
% mm=0;
% mm=mm+1;
% FileNameList{mm} = '/media/nas4/ProjetEmbReact/Mouse794/20181116/ProjectEmbReact_M794_20181116_TestPre_PreDrug/TestPre1';
% mm=mm+1;
% FileNameList{mm} = '/media/nas4/ProjetEmbReact/Mouse794/20181116/ProjectEmbReact_M794_20181116_TestPre_PreDrug/TestPre2Ma';


% cd /media/nas5/ProjetReversalBehavior/Data/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPre_00
% cd /media/nas5/ProjetReversalBehavior/Data/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPre_01
% cd /media/nas5/ProjetReversalBehavior/Data/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_00
% cd /media/nas5/ProjetReversalBehavior/Data/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_01
% cd /media/nas5/ProjetReversalBehavior/Data/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_04
% cd /media/nas5/ProjetReversalBehavior/Data/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_05

% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPre_01
% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPre_02
% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPost_03
% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPost_04
% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPost_05

% cd /media/nas5/ProjetReversalBehavior/Data/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-CondWallShock_00
% cd /media/nas5/ProjetReversalBehavior/Data/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-CondWallShock_01
% cd /media/nas5/ProjetReversalBehavior/Data/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-CondWallShock_02
% cd /media/nas5/ProjetReversalBehavior/Data/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-CondWallShock_03
% cd /media/nas5/ProjetReversalBehavior/Data/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-CondWallShock_04
% cd /media/nas5/ProjetReversalBehavior/Data/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-CondWallShock_05

cd /media/nas5/ProjetReversalBehavior/Data/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_00
% cd /media/nas5/ProjetReversalBehavior/Data/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_01
% cd /media/nas5/ProjetReversalBehavior/Data/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_02
% cd /media/nas5/ProjetReversalBehavior/Data/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_03
% cd /media/nas5/ProjetReversalBehavior/Data/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_04
% cd /media/nas5/ProjetReversalBehavior/Data/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_05

% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190612/Reversal/ERC-Mouse-934-12062019-CondWallShock_00
% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190612/Reversal/ERC-Mouse-934-12062019-CondWallShock_01
% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190612/Reversal/ERC-Mouse-934-12062019-CondWallShock_02
% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190612/Reversal/ERC-Mouse-934-12062019-CondWallShock_03
% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190612/Reversal/ERC-Mouse-934-12062019-CondWallShock_04
% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190612/Reversal/ERC-Mouse-934-12062019-CondWallShock_05

% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190708/ReversalControl/ERC-Mouse-934-08072019-CondWallShock_00
% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190708/ReversalControl/ERC-Mouse-934-08072019-CondWallShock_01
% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190708/ReversalControl/ERC-Mouse-934-08072019-CondWallShock_02
% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190708/ReversalControl/ERC-Mouse-934-08072019-CondWallShock_03
% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190708/ReversalControl/ERC-Mouse-934-08072019-CondWallShock_04
% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190708/ReversalControl/ERC-Mouse-934-08072019-CondWallShock_05




%% launche from here
clear all
% for m = 1:mm
%     cd(FileNameList{m})
% Get the video                       


[filename, pathname] = uigetfile('Select the video','*avi');
cd(pathname)
OBJ = VideoReader([pathname filename]);
% Get the behav data
load('behavResources.mat','PosMat','Ratio_IMAonREAL')
dt = median(diff(PosMat(:,1)));
Time1secFrames = floor(1/dt);
i=1;
click_number = 1;

sizeIm=30;
while hasFrame(OBJ)
    vidFrame = readFrame(OBJ);
    vidFrame = squeeze(vidFrame(:,:,1));
    
    if rem(i-1,Time1secFrames) == 0
        click_number
        
        subplot(1,2,1),  imshow(vidFrame);
        idxm=floor(max(Ratio_IMAonREAL*PosMat(i,3)-sizeIm,1));
        idxM=floor(min(Ratio_IMAonREAL*PosMat(i,3)+sizeIm,size(vidFrame,1)));
        idym=floor(max(Ratio_IMAonREAL*PosMat(i,2)-sizeIm,1));
        idyM=floor(min(Ratio_IMAonREAL*PosMat(i,2)+sizeIm,size(vidFrame,2)));
        subplot(1,3,1),  imshow(vidFrame);
        subplot(1,3,2), imshow(vidFrame(idxm:idxM,idym:idyM));
        subplot(1,3,3), imagesc(vidFrame(idxm:idxM,idym:idyM));
        %            subplot(1,2,2), imagesc(vidFrame); hold on, plot(PosMat(i,2),PosMat(i,3),'ko')
        
        %             title('click on eye or to the right of the frame for NaN')
        %             [X,Y] = ginput(1);
        %             if X>size(vidFrame,2)
        %                 Temp_eye(click_number) = NaN;
        %             else
        %                 try
        %                     Temp_eye(click_number) = vidFrame(floor(Y),floor(X));
        %                 catch
        %                     Temp_eye(click_number) = NaN;/media/nas5/ProjetReversalBehavior/Data/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPre_01
        %                 end
        %             end
        
        title(['click on body or to the left of the figure for NaN,  ',num2str(floor(PosMat(i,1))),'/',num2str(floor(PosMat(end,1)))])
        [X,Y] = ginput(1);
        if (X<0)
            Temp_body(click_number) = NaN;
        else
            try
                Temp_body(click_number) = vidFrame(floor(Y),floor(X));
            catch
                Temp_body(click_number) = NaN;
            end
        end
        
        title(['click on tail or to the left of the figure for NaN,  ',num2str(floor(PosMat(i,1))),'/',num2str(floor(PosMat(end,1)))])
        [X,Y] = ginput(1);
        if (X<0)
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
        Temp_PosX(click_number) = PosMat(i,2);
        Temp_PosY(click_number) = PosMat(i,3);
        click_number = click_number+1;
        save('ManualTempongoing.mat','Temp_time','Temp_tail','Temp_body','Temp_max','Temp_PosY','Temp_PosX')
    end
    
    i=i+1;
end

%     Temp_eye = double(Temp_eye);
%     Temp_eye(Temp_eye==0) = NaN;

Temp_tail = double(Temp_tail);
Temp_tail(Temp_tail==0) = NaN;
Temp_body = double(Temp_body);
Temp_body(Temp_body==0) = NaN;

Temp_max = double(Temp_max);
Temp_max(Temp_max==0) = NaN;

Temp_PosY = double(Temp_PosY);
Temp_PosY(Temp_PosY==0) = NaN;

Temp_PosX = double(Temp_PosX);
Temp_PosX(Temp_PosX==0) = NaN;
        
    save('ManualTemp.mat','Temp_time','Temp_tail','Temp_body','Temp_max','Temp_PosY','Temp_PosX')
       clear Temp_time Temp_tail Temp_body Temp_max click_number i Temp_PosX Temp_Pos
%     save('ManualTemp.mat','Temp_time','Temp_eye','Temp_tail','Temp_body','Temp_max') 
%     clear Temp_time Temp_eye Temp_tail Temp_body Temp_max click_number i
% end
% end