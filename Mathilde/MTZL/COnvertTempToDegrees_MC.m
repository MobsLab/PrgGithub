clear all
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MTZL-Exp/CalibrationOct2017IRCamera.mat')

MiceNumber = [756:765];
% MiceNumber = [739];

for mousenum = 1 : length(MiceNumber)
    mousenum
    frame =1;
    clear MouseTemp_ToConvert MouseTemp_InDegrees PosMat GotFrame Temp_tail Temp_tail_InDegrees Temp_body Temp_body_InDegrees Temp_eye Temp_eye_InDegrees
    %     cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/BeforeInjection/FEAR-Mouse-',num2str(MiceNumber(mousenum)),'-12062018-Hab_00'])
    %     cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/4DqysPost/FEAR-Mouse-',num2str(MiceNumber(mousenum)),'-16062018-Hab_00'])
    
    
    load('behavResources.mat','PosMat','GotFrame','frame_limits','mask')
    
    % OBJ = VideoReader('F12062018-0000.avi');
    % OBJ = VideoReader('F16062018-0000.avi');
    % OBJ = VideoReader('F29052018-0000.avi');
    
    
    while OBJ.hasFrame
        fr = OBJ.readFrame;
        fr = fr(:,:,1);
        fr = double(fr)/256;
        fr = (fr*(frame_limits(2)-frame_limits(1)))+frame_limits(1);
        
        MouseTemp_ToConvert(frame) = max(max(fr.*double(mask)));
        frame=frame+1;
    end
    TempOutput(isnan(ValuesInput))=[];
    ValuesInput(isnan(ValuesInput))=[];
    
    MouseTemp_InDegrees = (interp1(ValuesInput,TempOutput, MouseTemp_ToConvert));
    MouseTemp_InDegrees = [PosMat(find(GotFrame),1)';MouseTemp_InDegrees]';
    
    save('behavResources.mat','MouseTemp_InDegrees','-append')
    
    if exist('ManualTemp.mat')>0
        load('ManualTemp.mat')
        Temp_body_InDegrees = double(Temp_body)/256;
        Temp_body_InDegrees = (Temp_body_InDegrees*(frame_limits(2)-frame_limits(1)))+frame_limits(1);
        Temp_body_InDegrees = interp1(ValuesInput,TempOutput, Temp_body_InDegrees);
        
        Temp_eye_InDegrees = double(Temp_eye)/256;
        Temp_eye_InDegrees = (Temp_eye_InDegrees*(frame_limits(2)-frame_limits(1)))+frame_limits(1);
        Temp_eye_InDegrees = interp1(ValuesInput,TempOutput, Temp_eye_InDegrees);
        
        Temp_tail_InDegrees = double(Temp_tail)/256;
        Temp_tail_InDegrees = (Temp_tail_InDegrees*(frame_limits(2)-frame_limits(1)))+frame_limits(1);
        Temp_tail_InDegrees = interp1(ValuesInput,TempOutput, Temp_tail_InDegrees);
        save('ManualTemp.mat','Temp_body_InDegrees','Temp_eye_InDegrees','Temp_tail_InDegrees','-append')
    end
    
end
