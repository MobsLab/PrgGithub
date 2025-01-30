GetEmbReactMiceFolderList_BM

Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long'};

for sess=1:5%length(Session_type) % generate all data required for analyses
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'ripples');
end


for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        Ripples.Shock.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ripples.mean(mouse,5);
        Ripples.Safe.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ripples.mean(mouse,6);
    end
    Mouse_names{mouse}
end

for group=1:length(Drug_Group)
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            try
            Ripples.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Ripples.Shock.(Session_type{sess}).(Mouse_names{mouse});
            Ripples.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Ripples.Safe.(Session_type{sess}).(Mouse_names{mouse});
            end
        end
    end
end

for sess=1:length(Session_type)
    for group=1:length(Drug_Group)
        Ripples.Shock.Figure.(Session_type{sess}){group} = Ripples.Shock.(Drug_Group{group}).(Session_type{sess});
        Ripples.Safe.Figure.(Session_type{sess}){group} = Ripples.Safe.(Drug_Group{group}).(Session_type{sess});
        Ripples.Shock.Figure.(Session_type{sess}){group}(Ripples.Shock.Figure.(Session_type{sess}){group}==0)=NaN;
        Ripples.Safe.Figure.(Session_type{sess}){group}(Ripples.Safe.Figure.(Session_type{sess}){group}==0)=NaN;
    end
end

Cols = {[1 0.5 0.5],[0.5 0.5 1]};
X = [1,2];
Legends = {'Shock','Safe'};
NoLegends = {'',''};

% Max freq
figure; n=1;
for sess=[4 5 3]
    for group=1:8
        subplot(3,8,group+8*(n-1))
        try
        if sess==3; MakeSpreadAndBoxPlot2_SB([Ripples.Shock.Figure.(Session_type{sess}){group} Ripples.Safe.Figure.(Session_type{sess}){group}],Cols,X,Legends,'showpoints',0,'paired',1);
        else; MakeSpreadAndBoxPlot2_SB([Ripples.Shock.Figure.(Session_type{sess}){group} Ripples.Safe.Figure.(Session_type{sess}){group}],Cols,X,NoLegends,'showpoints',0,'paired',1); end
        if group==1; ylabel('Frequency (Hz)'); end
        if sess==4; title(Drug_Group{group}); end
        ylim([0 1.5])
        end
        end
    n=n+1;
end
a=suptitle('Ripples density during freezing'); a.FontSize=20;





