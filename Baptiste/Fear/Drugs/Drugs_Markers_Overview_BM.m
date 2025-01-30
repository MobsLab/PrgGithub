


GetEmbReactMiceFolderList_BM
Session_type={'CondPre','CondPost','Ext'};
Fz_Type={'Fz','Fz_Shock','Fz_Safe'};
Side_ind=[3 5 6];

for sess=1:length(Session_type) % generate all data required for analyses
    [OutPutData.(Session_type{sess}) , Epoch.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse(1),lower(Session_type{sess}),'respi_freq_BM','heartrate','wake_ripples','ob_high');
end

load('B_Low_Spectrum.mat')
for mouse=1:length(Mouse)
    for sess=1:length(Session_type)
        for type=1:length(Fz_Type)
            % Heart rate
            try
                if OutPutData.(Session_type{sess}).heartrate.mean(mouse,1)<9
                    HR.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = NaN;
                else
                    HR.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).heartrate.mean(mouse,Side_ind(type));
                end
            end
            % Respi
            Respi.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = sum(Data(OutPutData.(Session_type{sess}).respi_freq_BM.tsd{mouse,Side_ind(type)})>4)/length(OutPutData.(Session_type{sess}).respi_freq_BM.tsd{mouse,Side_ind(type)});
            % Temperature
            %   try; Temperature.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).masktemperature.mean(mouse,Side_ind(type)); end
            % Ripples density
            Ripples.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).wake_ripples.mean(mouse,Side_ind(type));
            % Respi
            Gamma.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ob_high.max_freq(mouse,Side_ind(type));
            GammaPower.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ob_high.power(mouse,Side_ind(type));
        end
    end
    Mouse_names{mouse}
end

Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long'};
for group=1:length(Drug_Group)
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            for type=1:length(Fz_Type)
                
                try
                    HR.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = HR.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                end
                Respi.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = Respi.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                %   try; Temperature.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = Temperature.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse}); end
                Ripples.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = Ripples.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                Gamma.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = Gamma.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                GammaPower.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = GammaPower.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse});
            end
        end
    end
end



for sess=1:length(Session_type)
    for group=1:length(Drug_Group)
        for type=1:length(Fz_Type)
           try; HR.(Fz_Type{type}).Figure.(Session_type{sess}){group} = HR.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess}); end
            Respi.(Fz_Type{type}).Figure.(Session_type{sess}){group} = Respi.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess});
            Ripples.(Fz_Type{type}).Figure.(Session_type{sess}){group} = Ripples.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess});
            Gamma.(Fz_Type{type}).Figure.(Session_type{sess}){group} = Gamma.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess});
            GammaPower.(Fz_Type{type}).Figure.(Session_type{sess}){group} = GammaPower.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess});
           
            Ripples.(Fz_Type{type}).Figure.(Session_type{sess}){group}(Ripples.(Fz_Type{type}).Figure.(Session_type{sess}){group}==0)=NaN;
            HR.(Fz_Type{type}).Figure.(Session_type{sess}){group}(HR.(Fz_Type{type}).Figure.(Session_type{sess}){group}==0)=NaN;
            Gamma.(Fz_Type{type}).Figure.(Session_type{sess}){group}(Gamma.(Fz_Type{type}).Figure.(Session_type{sess}){group}==41.503906250096730)=NaN;
            GammaPower.(Fz_Type{type}).Figure.(Session_type{sess}){group}(Gamma.(Fz_Type{type}).Figure.(Session_type{sess}){group}==41.503906250096730)=NaN;
        end
    end
end

Cols = {[1 0.5 0.5],[1 0.7 0.7],[0.5 0.5 1],[0.7 0.7 1]};
X = [1:4];
Legends = {'Shock saline','Shock chronic flx','Safe saline','Safe chronic flx'};
NoLegends = {'','','',''};

figure; 
a=suptitle('Saline & Chronic fluoxetine'); a.FontSize=20;
for sess=1:3
    
    subplot(2,6,sess)
    MakeSpreadAndBoxPlot2_SB({Respi.Fz_Shock.Figure.(Session_type{sess}){1} Respi.Fz_Shock.Figure.(Session_type{sess}){2} Respi.Fz_Safe.Figure.(Session_type{sess}){1} Respi.Fz_Safe.Figure.(Session_type{sess}){2} },Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Respiratory rate (Hz)'); end
    ylim([0 1.2])
    title(Session_type{sess})
    
    subplot(2,6,sess+3)
    MakeSpreadAndBoxPlot2_SB({HR.Fz_Shock.Figure.(Session_type{sess}){1} HR.Fz_Shock.Figure.(Session_type{sess}){2} HR.Fz_Safe.Figure.(Session_type{sess}){1} HR.Fz_Safe.Figure.(Session_type{sess}){2} },Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Heart rate (Hz)'); end
    ylim([8 13])
     title(Session_type{sess})
      
    subplot(2,6,sess+6)
    MakeSpreadAndBoxPlot2_SB({Ripples.Fz_Shock.Figure.(Session_type{sess}){1} Ripples.Fz_Shock.Figure.(Session_type{sess}){2} Ripples.Fz_Safe.Figure.(Session_type{sess}){1} Ripples.Fz_Safe.Figure.(Session_type{sess}){2} },Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Ripples density (#/s)'); end
       ylim([0 .6])
  
    subplot(2,6,sess+9)
    MakeSpreadAndBoxPlot2_SB({Gamma.Fz_Shock.Figure.(Session_type{sess}){1} Gamma.Fz_Shock.Figure.(Session_type{sess}){2} Gamma.Fz_Safe.Figure.(Session_type{sess}){1} Gamma.Fz_Safe.Figure.(Session_type{sess}){2} },Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Gamma Frequency (Hz)'); end
     ylim([50 85])

end



figure; 
a=suptitle('Saline & Diazepam, short protocol'); a.FontSize=20;
for sess=1:3
    
    subplot(2,6,sess)
    MakeSpreadAndBoxPlot2_SB({Respi.Fz_Shock.Figure.(Session_type{sess}){5} Respi.Fz_Shock.Figure.(Session_type{sess}){6} Respi.Fz_Safe.Figure.(Session_type{sess}){5} Respi.Fz_Safe.Figure.(Session_type{sess}){6} },Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Respiratory rate (Hz)'); end
    ylim([2.5 7])
    title(Session_type{sess})
    
    subplot(2,6,sess+3)
    MakeSpreadAndBoxPlot2_SB({HR.Fz_Shock.Figure.(Session_type{sess}){5} HR.Fz_Shock.Figure.(Session_type{sess}){6} HR.Fz_Safe.Figure.(Session_type{sess}){5} HR.Fz_Safe.Figure.(Session_type{sess}){6} },Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Heart rate (Hz)'); end
    ylim([8 13])
     title(Session_type{sess})
      
    subplot(2,6,sess+6)
    MakeSpreadAndBoxPlot2_SB({Ripples.Fz_Shock.Figure.(Session_type{sess}){5} Ripples.Fz_Shock.Figure.(Session_type{sess}){6} Ripples.Fz_Safe.Figure.(Session_type{sess}){5} Ripples.Fz_Safe.Figure.(Session_type{sess}){6} },Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Ripples density (#/s)'); end
    ylim([0 .8])
  
    subplot(2,6,sess+9)
    MakeSpreadAndBoxPlot2_SB({Gamma.Fz_Shock.Figure.(Session_type{sess}){5} Gamma.Fz_Shock.Figure.(Session_type{sess}){6} Gamma.Fz_Safe.Figure.(Session_type{sess}){5} Gamma.Fz_Safe.Figure.(Session_type{sess}){6} },Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Gamma Frequency (Hz)'); end
    ylim([50 95])

end



figure; 
a=suptitle('Saline & Diazepam, long protocol'); a.FontSize=20;
for sess=1:3
    
    subplot(2,6,sess)
    MakeSpreadAndBoxPlot2_SB({Respi.Fz_Shock.Figure.(Session_type{sess}){7} Respi.Fz_Shock.Figure.(Session_type{sess}){8} Respi.Fz_Safe.Figure.(Session_type{sess}){7} Respi.Fz_Safe.Figure.(Session_type{sess}){8} },Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Respiratory rate (Hz)'); end
    ylim([2.5 7])
    title(Session_type{sess})
    
    subplot(2,6,sess+3)
    MakeSpreadAndBoxPlot2_SB({HR.Fz_Shock.Figure.(Session_type{sess}){7} HR.Fz_Shock.Figure.(Session_type{sess}){8} HR.Fz_Safe.Figure.(Session_type{sess}){7} HR.Fz_Safe.Figure.(Session_type{sess}){8} },Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Heart rate (Hz)'); end
    ylim([8 13])
     title(Session_type{sess})
      
    subplot(2,6,sess+6)
    MakeSpreadAndBoxPlot2_SB({Ripples.Fz_Shock.Figure.(Session_type{sess}){7} Ripples.Fz_Shock.Figure.(Session_type{sess}){8} Ripples.Fz_Safe.Figure.(Session_type{sess}){7} Ripples.Fz_Safe.Figure.(Session_type{sess}){8} },Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Ripples density (#/s)'); end
    ylim([0 .7])
  
    subplot(2,6,sess+9)
    MakeSpreadAndBoxPlot2_SB({Gamma.Fz_Shock.Figure.(Session_type{sess}){7} Gamma.Fz_Shock.Figure.(Session_type{sess}){8} Gamma.Fz_Safe.Figure.(Session_type{sess}){7} Gamma.Fz_Safe.Figure.(Session_type{sess}){8} },Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Gamma Frequency (Hz)'); end
    ylim([50 85])

end




