

Mouse=[688,739,777,779,849,893,1096,875,876,877,1001,1002,1095,740,750,775,778,794]; 

Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};
for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'hpc_low');
end

for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        HPC_Mean_Spc.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Data(TSD_DATA.(Session_type{sess}).hpc_low.tsd{mouse,4}));
        
    end
end

for group=1:3
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            HPC_Mean_Spc.(Drug_Group{group}).(Session_type{sess})(mouse,:) = HPC_Mean_Spc.(Session_type{sess}).(Mouse_names{mouse});
          
        end
    end
end


figure
subplot(131)
plot(Spectro{3} , mean(HPC_Mean_Spc.SalineSB.TestPre).*Spectro{3})
hold on
plot(Spectro{3} , mean(HPC_Mean_Spc.ChronicFlx.TestPre).*Spectro{3})
plot(Spectro{3} , mean(HPC_Mean_Spc.AcuteFlx.TestPre).*Spectro{3},'m')
makepretty
xlim([6 12])
[a,b]=max(mean(HPC_Mean_Spc.SalineSB.TestPre).*Spectro{3}); vline(Spectro{3}(b),'--b')
[a,b]=max(mean(HPC_Mean_Spc.ChronicFlx.TestPre).*Spectro{3}); vline(Spectro{3}(b),'--r')
[a,b]=max(mean(HPC_Mean_Spc.AcuteFlx.TestPre).*Spectro{3}); vline(Spectro{3}(b),'--m')

subplot(132)
plot(Spectro{3} , mean(HPC_Mean_Spc.SalineSB.CondPre).*Spectro{3})
hold on
plot(Spectro{3} , mean(HPC_Mean_Spc.ChronicFlx.CondPre).*Spectro{3})
plot(Spectro{3} , mean(HPC_Mean_Spc.AcuteFlx.CondPre).*Spectro{3},'m')
makepretty
xlim([6 12])
[a,b]=max(mean(HPC_Mean_Spc.SalineSB.CondPre).*Spectro{3}); vline(Spectro{3}(b),'--b')
[a,b]=max(mean(HPC_Mean_Spc.ChronicFlx.CondPre).*Spectro{3}); vline(Spectro{3}(b),'--r')
[a,b]=max(mean(HPC_Mean_Spc.AcuteFlx.CondPre).*Spectro{3}); vline(Spectro{3}(b),'--m')

subplot(133)
plot(Spectro{3} , mean(HPC_Mean_Spc.SalineSB.CondPost).*Spectro{3})
hold on
plot(Spectro{3} , mean(HPC_Mean_Spc.ChronicFlx.CondPost).*Spectro{3})
plot(Spectro{3} , mean(HPC_Mean_Spc.AcuteFlx.CondPost).*Spectro{3},'m')
makepretty
xlim([6 12])
[a,b]=max(mean(HPC_Mean_Spc.SalineSB.CondPost).*Spectro{3}); vline(Spectro{3}(b),'--b')
[a,b]=max(mean(HPC_Mean_Spc.ChronicFlx.CondPost).*Spectro{3}); vline(Spectro{3}(b),'--r')
[a,b]=max(mean(HPC_Mean_Spc.AcuteFlx.CondPost).*Spectro{3}); vline(Spectro{3}(b),'--m')

