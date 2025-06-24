


clear all
Session_type={'Cond'};
Mouse=Drugs_Groups_UMaze_BM(22);
for sess=1:length(Session_type)
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = ...
        MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'ob_high');
end



Cols = {[1 .5 .5],[.5 .5 1]};
X = [1:2.5];
Legends = {'Shock','Safe'};

figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({nanmean(OutPutData.Cond.ob_high.mean(:,5,13:end),3) nanmean(OutPutData.Cond.ob_high.mean(:,6,13:end),3)},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('OB gamma power (a.u.)')
makepretty_BM2

subplot(122)
MakeSpreadAndBoxPlot3_SB({OutPutData.Cond.ob_high.max_freq(:,5) OutPutData.Cond.ob_high.max_freq(:,6)},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('OB gamma power (a.u.)')
makepretty_BM2

figure
plot(linspace(20,100,32) , squeeze(OutPutData.Cond.ob_high.mean(:,5,:))' , 'Color' , [1 .5 .5])
hold on
plot(linspace(20,100,32) , squeeze(OutPutData.Cond.ob_high.mean(:,6,:))' , 'Color' , [.5 .5 1])
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)')


%%
GetEmbReactMiceFolderList_BM

Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};

for sess=1:5%length(Session_type) % generate all data required for analyses
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'ob_high');
end

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        %         OB_High_Spec.Shock.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ob_high.mean(mouse,5);
        %         OB_High_Spec.Safe.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ob_high.mean(mouse,6);
        % Max freq
        OB_High_MaxFreq.Shock.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ob_high.max_freq(mouse,5);
        OB_High_MaxFreq.Safe.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ob_high.max_freq(mouse,6);
        % power
        OB_High_Power.Shock.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ob_high.power(mouse,5);
        OB_High_Power.Safe.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ob_high.power(mouse,6);
    end
    Mouse_names{mouse}
end


Drug_Group={'SalineSB','ChronicFlx'};
for group=1:2%length(Drug_Group)
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            %             OB_High_Spec.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_High_Spec.Shock.(Session_type{sess}).(Mouse_names{mouse});
            %             OB_High_Spec.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_High_Spec.Safe.(Session_type{sess}).(Mouse_names{mouse});
            %
            OB_High_MaxFreq.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_High_MaxFreq.Shock.(Session_type{sess}).(Mouse_names{mouse});
            OB_High_MaxFreq.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_High_MaxFreq.Safe.(Session_type{sess}).(Mouse_names{mouse});
            
            OB_High_Power.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_High_Power.Shock.(Session_type{sess}).(Mouse_names{mouse});
            OB_High_Power.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_High_Power.Safe.(Session_type{sess}).(Mouse_names{mouse});
        end
    end
end

for sess=1:length(Session_type)
    for group=1:2
        %         OB_High_Spec.Shock.Figure.(Session_type{sess}){group} = OB_High_Spec.Shock.(Drug_Group{group}).(Session_type{sess});
        %         OB_High_Spec.Safe.Figure.(Session_type{sess}){group} = OB_High_Spec.Safe.(Drug_Group{group}).(Session_type{sess});
        %
        OB_High_MaxFreq.Shock.Figure.(Session_type{sess}){group} = OB_High_MaxFreq.Shock.(Drug_Group{group}).(Session_type{sess});
        OB_High_MaxFreq.Safe.Figure.(Session_type{sess}){group} = OB_High_MaxFreq.Safe.(Drug_Group{group}).(Session_type{sess});
        
        OB_High_Power.Shock.Figure.(Session_type{sess}){group} = OB_High_Power.Shock.(Drug_Group{group}).(Session_type{sess});
        OB_High_Power.Safe.Figure.(Session_type{sess}){group} = OB_High_Power.Safe.(Drug_Group{group}).(Session_type{sess});
    end
end

Cols = {[1 0.5 0.5],[0.5 0.5 1]};
X = [1,2];
Legends = {'Shock','Safe'};
NoLegends = {'',''};

% Max freq
figure; n=1;
for sess=[4 5 3]
    for group=1:length(Drug_Group)
        subplot(3,8,group+8*(n-1))
        if sess==3; MakeSpreadAndBoxPlot2_SB([OB_High_MaxFreq.Shock.Figure.(Session_type{sess}){group} OB_High_MaxFreq.Safe.Figure.(Session_type{sess}){group}],Cols,X,Legends,'showpoints',0,'paired',1);
        else; MakeSpreadAndBoxPlot2_SB([OB_High_MaxFreq.Shock.Figure.(Session_type{sess}){group} OB_High_MaxFreq.Safe.Figure.(Session_type{sess}){group}],Cols,X,NoLegends,'showpoints',0,'paired',1); end
        if group==1; ylabel('Frequency (Hz)'); end
        if sess==4; title(Drug_Group{group}); end
        ylim([40 90])
    end
    n=n+1;
end

a=suptitle('OB high frequencies during freezing'); a.FontSize=20;

% Power
figure; n=1;
for sess=[4 5 3]
    for group=1:length(Drug_Group)
        subplot(3,8,group+8*(n-1))
        if sess==3; MakeSpreadAndBoxPlot2_SB([log10(OB_High_Power.Shock.Figure.(Session_type{sess}){group}) log10(OB_High_Power.Safe.Figure.(Session_type{sess}){group})],Cols,X,Legends,'showpoints',0,'paired',1);
        else; MakeSpreadAndBoxPlot2_SB([log10(OB_High_Power.Shock.Figure.(Session_type{sess}){group}) log10(OB_High_Power.Safe.Figure.(Session_type{sess}){group})],Cols,X,NoLegends,'showpoints',0,'paired',1); end
        if group==1; ylabel('Power (a.u.)'); end
        if sess==4; title(Drug_Group{group}); end
        ylim([3 4.6])
    end
    n=n+1;
end






