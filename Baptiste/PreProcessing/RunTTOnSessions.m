

%% Folder List

Mouse=[1001];
for mouse = 1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
    AllSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
end



for mouse = 1:length(Mouse)
    for sess=1:length(AllSleepSess.(Mouse_names{mouse}) )
        
        cd(Sess.(Mouse_names{mouse}){sess})
        
        try cd([Sess.(Mouse_names{mouse}){sess} 'Temperature'])
            disp('already done')
        catch
            mkdir Temperature
            
            if exist('behavResources_SB.mat')==0
                BehavResourcesCorrection_BM
            end
            
            copyfile behavResources_SB.mat Temperature
            copyfile behavResources.mat Temperature
            file=dir('*.avi'); filename=file.name;
            copyfile(filename,'Temperature')
            
            cd([Sess.(Mouse_names{mouse}){sess} 'Temperature/'])
            
            load('behavResources_SB.mat')
            TTMask
            
            clearvars -except mouse sess Sess Mouse_names Mouse
        end
        
    end
end











