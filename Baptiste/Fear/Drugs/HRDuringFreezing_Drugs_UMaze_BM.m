
GetEmbReactMiceFolderList_BM

Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};

for sess=1:5%length(Session_type) % generate all data required for analyses
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'heartrate','heartratevar');
end

for mouse=1:length(Mouse)
    for sess=1:5%length(Session_type)
        % HR
        HR.Shock.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).heartrate.mean(mouse,5);
        HR.Safe.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).heartrate.mean(mouse,6);
        % HRVar
        HRVar.Shock.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).heartratevar.mean(mouse,5);
        HRVar.Safe.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).heartratevar.mean(mouse,6);
    end
    Mouse_names{mouse}
end


% Group data for drug groups
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long'};
for group=1:length(Drug_Group)
    
Drugs_Groups_UMaze_BM
    
    for sess=1:5%length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            HR.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:)=HR.Shock.(Session_type{sess}).(Mouse_names{mouse});
            HR.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:)=HR.Safe.(Session_type{sess}).(Mouse_names{mouse});
                      
            HRVar.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:)=HRVar.Shock.(Session_type{sess}).(Mouse_names{mouse});
            HRVar.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:)=HRVar.Safe.(Session_type{sess}).(Mouse_names{mouse});
            
        end
        HR.Shock.(Drug_Group{group}).(Session_type{sess})(HR.Shock.(Drug_Group{group}).(Session_type{sess})==0)=NaN;
        HR.Safe.(Drug_Group{group}).(Session_type{sess})(HR.Safe.(Drug_Group{group}).(Session_type{sess})==0)=NaN;
        HRVar.Shock.(Drug_Group{group}).(Session_type{sess})(HRVar.Shock.(Drug_Group{group}).(Session_type{sess})==0)=NaN;
        HRVar.Safe.(Drug_Group{group}).(Session_type{sess})(HRVar.Safe.(Drug_Group{group}).(Session_type{sess})==0)=NaN;
    end
end

for sess=1:length(Session_type)
    for group=1:length(Drug_Group)
        HR.Shock.Figure.(Session_type{sess}){group} = HR.Shock.(Drug_Group{group}).(Session_type{sess});
        HR.Safe.Figure.(Session_type{sess}){group} = HR.Safe.(Drug_Group{group}).(Session_type{sess});
        HR.Shock.Figure.(Session_type{sess}){group}(HR.Shock.Figure.(Session_type{sess}){group}==0)=NaN;
        HR.Safe.Figure.(Session_type{sess}){group}(HR.Safe.Figure.(Session_type{sess}){group}==0)=NaN;
    end
end

% Figure
Cols = {[1 0.5 0.5],[0.5 0.5 1]};
X = [1,2];
Legends = {'Shock','Safe'};
NoLegends = {'',''}; D_n = length(Drug_Group);

figure; n=1;
for sess=[4 5 3]
    for group=1:length(Drug_Group)
        subplot(3,8,group+8*(n-1))
        if sess==3; MakeSpreadAndBoxPlot2_SB({HR.Shock.(Drug_Group{group}).(Session_type{sess}) , HR.Safe.(Drug_Group{group}).(Session_type{sess})},Cols,X,Legends,'showpoints',0,'paired',1);
        else; MakeSpreadAndBoxPlot2_SB({HR.Shock.(Drug_Group{group}).(Session_type{sess}) , HR.Safe.(Drug_Group{group}).(Session_type{sess})},Cols,X,NoLegends,'showpoints',0,'paired',1); end
        if group==1; ylabel('Frequency (Hz)'); u=text(-1.5,8,Session_type{sess}); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
        if sess==4; title(Drug_Group{group}); end
        ylim([7 13.5])
    end
    n=n+1;
end
a=suptitle('Heart rate during freezing, UMaze drugs experiments'); a.FontSize=20;


figure; n=1;
for sess=[4 5 3]
    for group=1:length(Drug_Group)
        subplot(3,8,group+8*(n-1))
        if sess==3; MakeSpreadAndBoxPlot2_SB({HRVar.Shock.(Drug_Group{group}).(Session_type{sess}) , HRVar.Safe.(Drug_Group{group}).(Session_type{sess})},Cols,X,Legends,'showpoints',0,'paired',1);
        else; MakeSpreadAndBoxPlot2_SB({HRVar.Shock.(Drug_Group{group}).(Session_type{sess}) , HRVar.Safe.(Drug_Group{group}).(Session_type{sess})},Cols,X,NoLegends,'showpoints',0,'paired',1); end
        if group==1; ylabel('Frequency (Hz)'); u=text(-1.5,.1,Session_type{sess}); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
        if sess==4; title(Drug_Group{group}); end
        ylim([0 .5])
    end
    n=n+1;
end
a=suptitle('Heart rate variability during freezing, UMaze drugs experiments'); a.FontSize=20;




figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({HR.Shock.SalineBM_Short.CondPre HR.Safe.SalineBM_Short.CondPre HR.Shock.Diazepam_Short.CondPre HR.Safe.Diazepam_Short.CondPre},{[1 .5 .5],[.5 .5 1],[.8 .5 .5],[.5 .5 .8]},[1:4],{'Shock Saline','Safe Saline','Shock DZP','Safe DZP'},'showpoints',1,'paired',0);
ylim([7 13.5])
title('CondPre'); ylabel('Frequency (Hz)')
subplot(132)
MakeSpreadAndBoxPlot2_SB({HR.Shock.SalineBM_Short.CondPost HR.Safe.SalineBM_Short.CondPost HR.Shock.Diazepam_Short.CondPost HR.Safe.Diazepam_Short.CondPost},{[1 .5 .5],[.5 .5 1],[.8 .5 .5],[.5 .5 .8]},[1:4],{'Shock Saline','Safe Saline','Shock DZP','Safe DZP'},'showpoints',1,'paired',0);
title('CondPost')
ylim([7 13.5])
subplot(133)
MakeSpreadAndBoxPlot2_SB({HR.Shock.SalineBM_Short.Ext HR.Safe.SalineBM_Short.Ext HR.Shock.Diazepam_Short.Ext HR.Safe.Diazepam_Short.Ext},{[1 .5 .5],[.5 .5 1],[.8 .5 .5],[.5 .5 .8]},[1:4],{'Shock Saline','Safe Saline','Shock DZP','Safe DZP'},'showpoints',1,'paired',0);
title('Ext')
ylim([7 13.5])
a=suptitle('Heart rate during freezing'); a.FontSize=20;


figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({HR.Shock.SalineSB.CondPre HR.Safe.SalineSB.CondPre HR.Shock.ChronicFlx.CondPre HR.Safe.ChronicFlx.CondPre},{[1 .5 .5],[.5 .5 1],[.8 .5 .5],[.5 .5 .8]},[1:4],{'Shock Saline','Safe Saline','Shock Chronic flx','Safe Chronic flx'},'showpoints',1,'paired',0);
ylim([7 13.5])
title('CondPre'); ylabel('Frequency (Hz)')
subplot(132)
MakeSpreadAndBoxPlot2_SB({HR.Shock.SalineSB.CondPost HR.Safe.SalineSB.CondPost HR.Shock.ChronicFlx.CondPost HR.Safe.ChronicFlx.CondPost},{[1 .5 .5],[.5 .5 1],[.8 .5 .5],[.5 .5 .8]},[1:4],{'Shock Saline','Safe Saline','Shock Chronic flx','Safe Chronic flx'},'showpoints',1,'paired',0);
title('CondPost')
ylim([7 13.5])
subplot(133)
MakeSpreadAndBoxPlot2_SB({HR.Shock.SalineSB.Ext HR.Safe.SalineSB.Ext HR.Shock.ChronicFlx.Ext HR.Safe.ChronicFlx.Ext},{[1 .5 .5],[.5 .5 1],[.8 .5 .5],[.5 .5 .8]},[1:4],{'Shock Saline','Safe Saline','Shock Chronic flx','Safe Chronic flx'},'showpoints',1,'paired',0);
title('Ext')
ylim([7 13.5])
a=suptitle('Heart rate during freezing'); a.FontSize=20;



figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({HRVar.Shock.SalineBM_Short.CondPre HRVar.Safe.SalineBM_Short.CondPre HRVar.Shock.Diazepam_Short.CondPre HRVar.Safe.Diazepam_Short.CondPre},{[1 .5 .5],[.5 .5 1],[.8 .5 .5],[.5 .5 .8]},[1:4],{'Shock Saline','Safe Saline','Shock DZP','Safe DZP'},'showpoints',1,'paired',0);
ylim([0 .37])
title('CondPre'); ylabel('Frequency (Hz)')
subplot(132)
MakeSpreadAndBoxPlot2_SB({HRVar.Shock.SalineBM_Short.CondPost HRVar.Safe.SalineBM_Short.CondPost HRVar.Shock.Diazepam_Short.CondPost HRVar.Safe.Diazepam_Short.CondPost},{[1 .5 .5],[.5 .5 1],[.8 .5 .5],[.5 .5 .8]},[1:4],{'Shock Saline','Safe Saline','Shock DZP','Safe DZP'},'showpoints',1,'paired',0);
title('CondPost')
ylim([0 .37])
subplot(133)
MakeSpreadAndBoxPlot2_SB({HRVar.Shock.SalineBM_Short.Ext HRVar.Safe.SalineBM_Short.Ext HRVar.Shock.Diazepam_Short.Ext HRVar.Safe.Diazepam_Short.Ext},{[1 .5 .5],[.5 .5 1],[.8 .5 .5],[.5 .5 .8]},[1:4],{'Shock Saline','Safe Saline','Shock DZP','Safe DZP'},'showpoints',1,'paired',0);
title('Ext')
ylim([0 .37])
a=suptitle('Heart rate variability during freezing'); a.FontSize=20;


figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({HRVar.Shock.SalineSB.CondPre HRVar.Safe.SalineSB.CondPre HRVar.Shock.ChronicFlx.CondPre HRVar.Safe.ChronicFlx.CondPre},{[1 .5 .5],[.5 .5 1],[.8 .5 .5],[.5 .5 .8]},[1:4],{'Shock Saline','Safe Saline','Shock Chronic flx','Safe Chronic flx'},'showpoints',1,'paired',0);
ylim([0 .4])
title('CondPre'); ylabel('Frequency (Hz)')
subplot(132)
MakeSpreadAndBoxPlot2_SB({HRVar.Shock.SalineSB.CondPost HRVar.Safe.SalineSB.CondPost HRVar.Shock.ChronicFlx.CondPost HRVar.Safe.ChronicFlx.CondPost},{[1 .5 .5],[.5 .5 1],[.8 .5 .5],[.5 .5 .8]},[1:4],{'Shock Saline','Safe Saline','Shock Chronic flx','Safe Chronic flx'},'showpoints',1,'paired',0);
title('CondPost')
ylim([0 .4])
subplot(133)
MakeSpreadAndBoxPlot2_SB({HRVar.Shock.SalineSB.Ext HRVar.Safe.SalineSB.Ext HRVar.Shock.ChronicFlx.Ext HRVar.Safe.ChronicFlx.Ext},{[1 .5 .5],[.5 .5 1],[.8 .5 .5],[.5 .5 .8]},[1:4],{'Shock Saline','Safe Saline','Shock Chronic flx','Safe Chronic flx'},'showpoints',1,'paired',0);
title('Ext')
ylim([0 .4])
a=suptitle('Heart rate variability during freezing'); a.FontSize=20;

