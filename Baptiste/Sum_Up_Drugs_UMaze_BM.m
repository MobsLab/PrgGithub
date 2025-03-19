


%% Respi analysis overview

Cols = {[0, 0, 1],[1, 0, 0],[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.85, 0.525, 0.098],[0.55, 0.325, 0.098]};
X = [1:6];
Legends = {'SalineSB','Chronic Flx','SalineBM','DZP','RipInhib','Chronic BUS'};
NoLegends = {'','','','','',''};

Session_type={'Cond','CondPre','CondPost','Ext','Fear'};
for sess=5%1:length(Session_type) % generate all data required for analyses
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'respi_freq_bm');
end


for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        % Respi
        Respi_Data.All.(Session_type{sess}).(Mouse_names{mouse}) = Data(OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,3});
        Respi_Data.Shock.(Session_type{sess}).(Mouse_names{mouse}) = Data(OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,5});
        Respi_Data.Safe.(Session_type{sess}).(Mouse_names{mouse}) = Data(OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,6});
        
        if sess<4 % threshold at 2Hz during conditionning sessions for noise because of stims artefacts
            Respi_Data.All.(Session_type{sess}).(Mouse_names{mouse})(or(Respi_Data.All.(Session_type{sess}).(Mouse_names{mouse})<2 , Respi_Data.All.(Session_type{sess}).(Mouse_names{mouse})>8)) = NaN;
            Respi_Data.Shock.(Session_type{sess}).(Mouse_names{mouse})(or(Respi_Data.Shock.(Session_type{sess}).(Mouse_names{mouse})<2 , Respi_Data.Shock.(Session_type{sess}).(Mouse_names{mouse})>8)) = NaN;
            Respi_Data.Safe.(Session_type{sess}).(Mouse_names{mouse})(or(Respi_Data.Safe.(Session_type{sess}).(Mouse_names{mouse})<2 , Respi_Data.Safe.(Session_type{sess}).(Mouse_names{mouse})>8)) = NaN;
        else
            Respi_Data.All.(Session_type{sess}).(Mouse_names{mouse})(or(Respi_Data.All.(Session_type{sess}).(Mouse_names{mouse})<1 , Respi_Data.All.(Session_type{sess}).(Mouse_names{mouse})>8)) = NaN;
            Respi_Data.Shock.(Session_type{sess}).(Mouse_names{mouse})(or(Respi_Data.Shock.(Session_type{sess}).(Mouse_names{mouse})<1 , Respi_Data.Shock.(Session_type{sess}).(Mouse_names{mouse})>8)) = NaN;
            Respi_Data.Safe.(Session_type{sess}).(Mouse_names{mouse})(or(Respi_Data.Safe.(Session_type{sess}).(Mouse_names{mouse})<1 , Respi_Data.Safe.(Session_type{sess}).(Mouse_names{mouse})>8)) = NaN;
        end
        
        Respi.All.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Respi_Data.All.(Session_type{sess}).(Mouse_names{mouse}));
        Respi.Shock.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Respi_Data.Shock.(Session_type{sess}).(Mouse_names{mouse}));
        Respi.Safe.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Respi_Data.Safe.(Session_type{sess}).(Mouse_names{mouse}));
        
        Respi_Freq_Above_4.All.(Session_type{sess}).(Mouse_names{mouse}) = sum(Respi_Data.All.(Session_type{sess}).(Mouse_names{mouse})>4)/length(Respi_Data.All.(Session_type{sess}).(Mouse_names{mouse}));
        Respi_Freq_Above_4.Shock.(Session_type{sess}).(Mouse_names{mouse}) = sum(Respi_Data.Shock.(Session_type{sess}).(Mouse_names{mouse})>4)/length(Respi_Data.Shock.(Session_type{sess}).(Mouse_names{mouse}));
        Respi_Freq_Above_4.Safe.(Session_type{sess}).(Mouse_names{mouse}) = sum(Respi_Data.Safe.(Session_type{sess}).(Mouse_names{mouse})>4)/length(Respi_Data.Safe.(Session_type{sess}).(Mouse_names{mouse}));
        
    end
end




for group=1:length(Drug_Group)
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Respi.All.(Drug_Group{group}).(Session_type{sess})(mouse) = Respi.All.(Session_type{sess}).(Mouse_names{mouse});
            Respi.Shock.(Drug_Group{group}).(Session_type{sess})(mouse) = Respi.Shock.(Session_type{sess}).(Mouse_names{mouse});
            Respi.Safe.(Drug_Group{group}).(Session_type{sess})(mouse) = Respi.Safe.(Session_type{sess}).(Mouse_names{mouse});
            
            Respi_Freq_Above_4.All.(Drug_Group{group}).(Session_type{sess})(mouse) = Respi_Freq_Above_4.All.(Session_type{sess}).(Mouse_names{mouse});
            Respi_Freq_Above_4.Shock.(Drug_Group{group}).(Session_type{sess})(mouse) = Respi_Freq_Above_4.Shock.(Session_type{sess}).(Mouse_names{mouse});
            Respi_Freq_Above_4.Safe.(Drug_Group{group}).(Session_type{sess})(mouse) = Respi_Freq_Above_4.Safe.(Session_type{sess}).(Mouse_names{mouse});
            
        end
     end
end



for sess=1:length(Session_type)
    n=1;
    for group=[1 2 5 6 13 14]
        DataToPlot_All.(Session_type{sess}){n} = Respi.All.(Drug_Group{group}).(Session_type{sess});
        DataToPlot_Shock.(Session_type{sess}){n} = Respi.Shock.(Drug_Group{group}).(Session_type{sess});
        DataToPlot_Safe.(Session_type{sess}){n} = Respi.Safe.(Drug_Group{group}).(Session_type{sess});
        
        Figure_4Prop_All.(Session_type{sess}){n} = Respi_Freq_Above_4.All.(Drug_Group{group}).(Session_type{sess});
        Figure_4Prop_Shock.(Session_type{sess}){n} = Respi_Freq_Above_4.Shock.(Drug_Group{group}).(Session_type{sess});
        Figure_4Prop_Safe.(Session_type{sess}){n} = Respi_Freq_Above_4.Safe.(Drug_Group{group}).(Session_type{sess});
        n=n+1;
    end
end

% All fear freezing
figure; sess=5;
subplot(131)
MakeSpreadAndBoxPlot2_SB(DataToPlot_All.(Session_type{sess}) ,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)');
ylim([2 7])
title('All Fz')
hline(4,'--r')

subplot(132)
MakeSpreadAndBoxPlot2_SB(DataToPlot_Shock.(Session_type{sess}) ,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([2 7])
title('Shock Fz')
hline(4,'--r')

subplot(133)
MakeSpreadAndBoxPlot2_SB(DataToPlot_Safe.(Session_type{sess}) ,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([2 7])
title('Safe Fz')
hline(4,'--r')



% All freezing
figure
subplot(131); sess=2;
MakeSpreadAndBoxPlot2_SB(DataToPlot_All.(Session_type{sess}) ,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)');
ylim([2 7])
title(Session_type{sess})
hline(4,'--r')

subplot(132); sess=3;
MakeSpreadAndBoxPlot2_SB(DataToPlot_All.(Session_type{sess}) ,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([2 7])
title(Session_type{sess})
hline(4,'--r')

subplot(133); sess=4;
MakeSpreadAndBoxPlot2_SB(DataToPlot_All.(Session_type{sess}) ,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([2 7])
title(Session_type{sess})
hline(4,'--r')

% Shock & safe freezing
figure
subplot(231); sess=2;
MakeSpreadAndBoxPlot2_SB(DataToPlot_Shock.(Session_type{sess}) ,Cols,X,NoLegends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)');
ylim([2 7])
title('CondPre')
u=text(-2,3.5,'Shock'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90);
hline(4,'--r')

subplot(234)
MakeSpreadAndBoxPlot2_SB(DataToPlot_Safe.(Session_type{sess}) ,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)');
ylim([2 7])
u=text(-2,3.5,'Safe'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90);
hline(4,'--r')

subplot(232); sess=3;
MakeSpreadAndBoxPlot2_SB(DataToPlot_Shock.(Session_type{sess}) ,Cols,X,NoLegends,'showpoints',1,'paired',0);
ylim([2 7])
title('CondPost')
hline(4,'--r')

subplot(235)
MakeSpreadAndBoxPlot2_SB(DataToPlot_Safe.(Session_type{sess}) ,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([2 7])
hline(4,'--r')


subplot(233); sess=4;
MakeSpreadAndBoxPlot2_SB(DataToPlot_Shock.(Session_type{sess}) ,Cols,X,NoLegends,'showpoints',1,'paired',0);
ylim([2 7])
title('Ext')
hline(4,'--r')

subplot(236)
MakeSpreadAndBoxPlot2_SB(DataToPlot_Safe.(Session_type{sess}) ,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([2 7])
hline(4,'--r')

a=suptitle('Breathing during freezing, UMaze'); a.FontSize=20;



%%
figure; sess=5;
subplot(131)
MakeSpreadAndBoxPlot2_SB(Figure_4Prop_All.(Session_type{sess}) ,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Proportion');
ylim([0 1.2])
title('All Fz')
hline(4,'--r')

subplot(132)
MakeSpreadAndBoxPlot2_SB(Figure_4Prop_Shock.(Session_type{sess}) ,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 1.2])
title('Shock Fz')
hline(4,'--r')

subplot(133)
MakeSpreadAndBoxPlot2_SB(Figure_4Prop_Safe.(Session_type{sess}) ,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 1.2])
title('Safe Fz')
hline(4,'--r')



% All freezing
figure
subplot(131); sess=2;
MakeSpreadAndBoxPlot2_SB(Figure_4Prop_All.(Session_type{sess}) ,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Proportion');
ylim([0 1.3])
title(Session_type{sess})
hline(4,'--r')

subplot(132); sess=3;
MakeSpreadAndBoxPlot2_SB(Figure_4Prop_All.(Session_type{sess}) ,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 1.3])
title(Session_type{sess})
hline(4,'--r')

subplot(133); sess=4;
MakeSpreadAndBoxPlot2_SB(Figure_4Prop_All.(Session_type{sess}) ,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 1.3])
title(Session_type{sess})
hline(4,'--r')

% Shock & safe freezing
figure
subplot(231); sess=2;
MakeSpreadAndBoxPlot2_SB(Figure_4Prop_Shock.(Session_type{sess}) ,Cols,X,NoLegends,'showpoints',1,'paired',0);
ylabel('Proportion');
ylim([0 1.2])
title('CondPre')
u=text(-2,3.5,'Shock'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90);
hline(4,'--r')

subplot(234)
MakeSpreadAndBoxPlot2_SB(Figure_4Prop_Safe.(Session_type{sess}) ,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Proportion');
ylim([0 1.2])
u=text(-2,3.5,'Safe'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90);
hline(4,'--r')

subplot(232); sess=3;
MakeSpreadAndBoxPlot2_SB(Figure_4Prop_Shock.(Session_type{sess}) ,Cols,X,NoLegends,'showpoints',1,'paired',0);
ylim([0 1.2])
title('CondPost')
hline(4,'--r')

subplot(235)
MakeSpreadAndBoxPlot2_SB(Figure_4Prop_Safe.(Session_type{sess}) ,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 1.2])
hline(4,'--r')


subplot(233); sess=4;
MakeSpreadAndBoxPlot2_SB(Figure_4Prop_Shock.(Session_type{sess}) ,Cols,X,NoLegends,'showpoints',1,'paired',0);
ylim([0 1.2])
title('Ext')
hline(4,'--r')

subplot(236)
MakeSpreadAndBoxPlot2_SB(Figure_4Prop_Safe.(Session_type{sess}) ,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 1.2])
hline(4,'--r')

a=suptitle('Breathing during freezing, UMaze'); a.FontSize=20;




%% Sump up figure for all physio
% generate data and epoch
Session_type={'Fear','Cond','CondPre','CondPost','Ext'};
GetEmbReactMiceFolderList_BM
for sess=1:length(Session_type) 
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'ob_low','respi_freq_bm','heartrate','heartratevar','ob_high','ripples');
end


for sess=1:length(Session_type) % generate all data required for analyses
    for mouse = 1:length(Mouse)
        
        % respi
        try
            h=histogram(Data(OutPutData.(Session_type{sess}).respi_freq_BM_sametps.tsd{mouse,Side_ind(side)}),'BinLimits',[1 8],'NumBins',91);
            HistData_Respi.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = h.Values;
        end
        % HR
        try
            h=histogram(Data(OutPutData.(Session_type{sess}).heartrate_sametps.tsd{mouse,Side_ind(side)}),'BinLimits',[8 14],'NumBins',91);
            HistData_HR.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = h.Values;
        end
        % HR Var
        try
            h=histogram(Data(OutPutData.(Session_type{sess}).heartratevar_sametps.tsd{mouse,Side_ind(side)}),'BinLimits',[0 .5],'NumBins',91);
            HistData_HRVar.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = h.Values;
        end
        % OB gamma
        try
            h=histogram(Data(OutPutData.(Session_type{sess}).ob_high_sametps.tsd{mouse,Side_ind(side)}),'BinLimits',[0 .5],'NumBins',91);
            HistData_HRVar.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = h.Values;
        end
        % Ripples
        try
            h=histogram(Data(OutPutData.(Session_type{sess}).ripples_density_sametps.tsd{mouse,Side_ind(side)}),'BinLimits',[0 1.5e4],'NumBins',91);
            HistData_Ripples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = h.Values;
        end
        
    end
end


for group=1:length(Drug_Group)
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            for side=1:length(Side)
                try
                    if isnan(runmean(HistData_Respi.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData_Respi.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})),3))
                        HistData_Respi.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = NaN(1,91);
                    else
                        HistData_Respi.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = runmean(HistData_Respi.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData_Respi.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})),3);
                    end
                catch
                    HistData_Respi.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = NaN(1,91);
                end
                try
                    if isnan(runmean(HistData_HR.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData_HR.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})),3))
                        HistData_HR.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = NaN(1,91);
                    else
                        HistData_HR.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = runmean(HistData_HR.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData_HR.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})),3);
                    end
                catch
                    HistData_HR.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = NaN(1,91);
                end
            end
        end
    end
end


figure
for group=[5 6 13 14]
    n=1;
    for sess=5
        
        subplot(3,4,4*(n-1)+group)
        
        Conf_Inter=nanstd(HistData.Shock.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(HistData.Shock.(Drug_Group{group}).(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.Shock.(Drug_Group{group}).(Session_type{sess})),Conf_Inter,'r',1); hold on;
        Conf_Inter=nanstd(HistData.Safe.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(HistData.Safe.(Drug_Group{group}).(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.Safe.(Drug_Group{group}).(Session_type{sess})),Conf_Inter,'b',1); hold on;
        makepretty; grid on
        a=ylim; ylim([0 a(2)]);
        if and(n==1,group==1); u=text(-2,0.02,'CondPre','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if and(n==2,group==1); u=text(-2,0.02,'CondPost','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if and(n==3,group==1); u=text(-2,0.02,'Ext','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if n==1; title(Drug_Group{group}); end
        if n==3; xlabel('Frequency (Hz)'); end
        if and(n==1,group==1); f=get(gca,'Children'); legend([f(8),f(4)],'Shock','Safe'); end
        
        n=n+1;
    end
end
a=suptitle('Breathing frequency during freezing, spent time analysis'); a.FontSize=20;



'ob_low','heartrate','heartratevar','ripples','respi_freq_bm','ob_high'






