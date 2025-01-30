

Dir=PathForExperimentsEmbReact('Calibration_VHC');

for mouse=1:length(Dir.ExpeInfo)
    Mouse(mouse) = Dir.ExpeInfo{mouse}{1}.nmouse;
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    CalibSess.(Mouse_names{mouse}) = Dir.path{mouse};  
end


for group=7:8
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=4:8:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        FolderName=CalibSess.(Mouse_names{mouse});
        
        for sess=1:length(CalibSess.(Mouse_names{mouse}))
            cd(CalibSess.(Mouse_names{mouse}){sess})
            
%             FileName=FolderName{f}(max(regexp(FolderName{f},filesep))+1:end);
%             if isempty(findstr(FileName,'ProjectEmbReact'))
%                 All=regexp(FolderName{f},filesep);
%                 FileName=FolderName{f}(All(end-1)+1:end);
%                 FileName=strrep(FileName,filesep,'_');
%             end
%             file=dir('*.xml'); FileName=file.name;
%             
%             try
%                 SetCurrentSession(FileName(1:end-3))
%             catch
%                 FileName=FileName(1:end-1);
%             end
%             MakeData_Main_SB
            MakeData_TTLInfo
%             clear FileName NewFolderName
        end
    end
end











