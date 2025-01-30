


Mouse=[688,739,777,779,849,893,1096];
Session_type={'Cond','CondPre','CondPost','Ext'};
Fz_Type={'Total','After_stim','Freezing','Active','Freezing_shock','Freezing_safe','Active_shock','Active_safe'};

for sess=1:length(Session_type) % generate all data required for analyses
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'ripples','respi_freq_bm');
end


for sess=1:length(Session_type) % generate all data required for analyses
    for mouse = 1:5%length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for type=[3 5 6]
            for ep=1:length(Start(Epoch1.(Session_type{sess}){mouse,type}))
                
                Epoch_to_use = subset(Epoch1.(Session_type{sess}){mouse,type} , ep);
                Rip_tsd = OutPutData.(Session_type{sess}).ripples.ts{mouse,type};
                Respi_tsd = OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,type};
                
                try
                    Rip_density.(Session_type{sess}).(Mouse_names{mouse}).(Fz_Type{type})(ep) = size(Range(Restrict(Rip_tsd , Epoch_to_use)),1) / ((Stop(Epoch_to_use)-Start(Epoch_to_use))/1e4);
                    OB_respi.(Session_type{sess}).(Mouse_names{mouse}).(Fz_Type{type})(ep) = nanmean(Data(Restrict(Respi_tsd , Epoch_to_use)));
                    Ep_duration.(Session_type{sess}).(Mouse_names{mouse}).(Fz_Type{type})(ep) = ((Stop(Epoch_to_use)-Start(Epoch_to_use))/1e4);
                catch
                    Rip_density.(Session_type{sess}).(Mouse_names{mouse}).(Fz_Type{type})(ep) = NaN;
                    Ep_duration.(Session_type{sess}).(Mouse_names{mouse}).(Fz_Type{type})(ep) = NaN;
                    OB_respi.(Session_type{sess}).(Mouse_names{mouse}).(Fz_Type{type})(ep) = NaN;
               end
                clear Epoch_to_use Rip_tsd Respi_tsd
                
            end
        end
    end
end


figure
histogram(Rip_density.(Session_type{sess}).(Mouse_names{mouse}),30)
histogram(Rip_density.(Session_type{sess}).(Mouse_names{mouse}),30)

sess=1; mouse=1;

figure
plot(Ep_duration.(Session_type{sess}).(Mouse_names{mouse}) , Rip_density.(Session_type{sess}).(Mouse_names{mouse}) , '.r')


plot3(OB_respi.(Session_type{sess}).(Mouse_names{mouse}).Freezing_shock , Ep_duration.(Session_type{sess}).(Mouse_names{mouse}).Freezing_shock , Rip_density.(Session_type{sess}).(Mouse_names{mouse}).Freezing_shock , '.r')
hold on
plot3(OB_respi.(Session_type{sess}).(Mouse_names{mouse}).Freezing_safe , Ep_duration.(Session_type{sess}).(Mouse_names{mouse}).Freezing_safe , Rip_density.(Session_type{sess}).(Mouse_names{mouse}).Freezing_safe , '.b')
ylim([0 15]); zlim([0 2.5]); makepretty




