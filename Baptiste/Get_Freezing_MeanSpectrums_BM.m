
function [OB_Low_Spec] = Get_Freezing_MeanSpectrums_BM(Mouse_List)


Session_type={'Ext'};

for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse_List,lower(Session_type{sess}),'ob_low');
end


for mouse=1:length(Mouse_List)
    Mouse_names{mouse}=['M' num2str(Mouse_List(mouse))];
    for sess=1:length(Session_type)
       % Mean spec
        OB_Low_Spec.Shock.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ob_low.mean(mouse,5,:);
        OB_Low_Spec.Safe.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ob_low.mean(mouse,6,:);
end
    disp(Mouse_names{mouse})
end


Drug_Group={'Nicotine'};
for group=1
    for sess=1:length(Session_type) 
        for mouse=1:length(Mouse_List)
            
            OB_Low_Spec.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_Low_Spec.Shock.(Session_type{sess}).(Mouse_names{mouse});
            OB_Low_Spec.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_Low_Spec.Safe.(Session_type{sess}).(Mouse_names{mouse});
            
        end
    end
end








