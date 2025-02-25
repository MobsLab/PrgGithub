clearvars -except Mouse_names MouseToDo SessNames
disp('getting stims into shape')

cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')

for sess = 1:length(Sess.(Mouse_names{1}))
    cd(Sess.(Mouse_names{1}){sess})
    disp(Sess.(Mouse_names{1}){sess})
    clear TTLInfo
    load('ExpeInfo.mat')
    GetStims_CH
    try,save('behavResources_SB.mat','TTLInfo','-append')
    catch
        keyboard
    end
end