


GetEmbReactMiceFolderList_BM
Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        
        Sessions_List_ForLoop_BM
        
%         Position.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_BM(FolderList.(Mouse_names{mouse}) , 'xtsd');
%         Accelero.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_BM(FolderList.(Mouse_names{mouse}) , 'accelero');

        TotalTime_Behav(mouse,sess) = max(Range(Position.(Session_type{sess}).(Mouse_names{mouse})));
        TotalTime_Ephys(mouse,sess) = max(Range(Accelero.(Session_type{sess}).(Mouse_names{mouse})));
    end
    disp(Mouse_names{mouse})
end

for sess=1:length(Session_type)
    figure
    plot(TotalTime_Behav(:,sess))
    hold on
    plot(TotalTime_Ephys(:,sess))
    xticks([1:length(Mouse)]), xticklabels(Mouse_names), xtickangle(45), xlim([0 length(Mouse)])
end
