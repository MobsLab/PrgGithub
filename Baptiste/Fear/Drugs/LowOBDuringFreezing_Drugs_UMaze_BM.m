

Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long'};
GetEmbReactMiceFolderList_BM
Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};

for sess=2%1:length(Session_type) % generate all data required for analyses
    [TSD_DATA2.(Session_type{sess}) , Epoch2.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM([688,739,777,849,829,857,858,859,1005,1006],lower(Session_type{sess}),'ob_low');
end

Mouse=[688,739,777,849,829,857,858,859,1005,1006];

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=2
        LowOB_Max_Freq.Shock.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA2.(Session_type{sess}).ob_low.max_freq(mouse,5);
        LowOB_Max_Freq.Safe.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA2.(Session_type{sess}).ob_low.max_freq(mouse,6);
   
        LowOB_Power.Shock.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA2.(Session_type{sess}).ob_low.power(mouse,5);
        LowOB_Power.Safe.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA2.(Session_type{sess}).ob_low.power(mouse,6);
   end
    disp(Mouse_names{mouse})
end

for group=[1 4]
    
    if group==1 % saline mice
        Mouse=[688,739,777,849,];
    elseif group==2 % chronic flx mice
        Mouse=[1001,1002];
    elseif group==3 % Acute Flx
        Mouse=[750,794];
    elseif group==4 % midazolam mice
        Mouse=[829,857,858,859,1005,1006];
    elseif group==5 % saline short BM
        Mouse=[1170,1189]; % no 1172 1200 1204 1206 1207
    elseif group==6 % diazepam short
        Mouse=[11204,11206,11207]; %11200
    elseif group==7 % saline long
        Mouse=[1224 1225 1226 1227];
    elseif group==8 % diazepam long BM
        Mouse=[11225 11226 11203 1199 1230];
    end
    
    for sess=2
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            LowOB_Max_Freq.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = LowOB_Max_Freq.Shock.(Session_type{sess}).(Mouse_names{mouse});
            LowOB_Max_Freq.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = LowOB_Max_Freq.Safe.(Session_type{sess}).(Mouse_names{mouse});
            
            LowOB_Power.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = LowOB_Power.Shock.(Session_type{sess}).(Mouse_names{mouse});
            LowOB_Power.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = LowOB_Power.Safe.(Session_type{sess}).(Mouse_names{mouse});
        end
    end
end

for sess=2
    for group=[1 4]
        LowOB_Max_Freq.Shock.Figure.(Session_type{sess}){group} = LowOB_Max_Freq.Shock.(Drug_Group{group}).(Session_type{sess});
        LowOB_Max_Freq.Safe.Figure.(Session_type{sess}){group} = LowOB_Max_Freq.Safe.(Drug_Group{group}).(Session_type{sess});
   
        LowOB_Power.Shock.Figure.(Session_type{sess}){group} = LowOB_Power.Shock.(Drug_Group{group}).(Session_type{sess});
        LowOB_Power.Safe.Figure.(Session_type{sess}){group} = LowOB_Power.Safe.(Drug_Group{group}).(Session_type{sess});
   end
end

figure; sess=2;
subplot(121)
MakeSpreadAndBoxPlot2_SB([LowOB_Max_Freq.Shock.Figure.(Session_type{sess}){1} LowOB_Max_Freq.Safe.Figure.(Session_type{sess}){1}],Cols,X,Legends,'showpoints',0,'paired',1); 
subplot(122)
MakeSpreadAndBoxPlot2_SB([LowOB_Max_Freq.Shock.Figure.(Session_type{sess}){4} LowOB_Max_Freq.Safe.Figure.(Session_type{sess}){4}],Cols,X,Legends,'showpoints',0,'paired',1);


figure; sess=2;
subplot(121)
MakeSpreadAndBoxPlot2_SB([log10(LowOB_Power.Shock.Figure.(Session_type{sess}){1}) log10(LowOB_Power.Safe.Figure.(Session_type{sess}){1})],Cols,X,Legends,'showpoints',0,'paired',1); 
subplot(122)
MakeSpreadAndBoxPlot2_SB([log10(LowOB_Power.Shock.Figure.(Session_type{sess}){4}) log10(LowOB_Power.Safe.Figure.(Session_type{sess}){4})],Cols,X,Legends,'showpoints',0,'paired',1); 









