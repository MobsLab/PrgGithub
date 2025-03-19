
%% Freezing

GetEmbReactMiceFolderList_BM
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long'};
X = [1:8];
Cols = {[0, 0, 1],[1, 0, 0],[1, 0.5, 0.5],[0, 0.5, 0],[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83],[0.75, 0.225, 0]};
Legends_Drugs ={'SalineSB' 'Chronic Flx' 'Acute Flx' 'Midazolam','Saline_Short','DZP_Short','Saline_Long','DZP_Long'};
NoLegends_Drugs ={'', '', '', '','','','',''};
Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};
Side_ind=[1:8];
 

for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'speed','accelero','heartrate','respi_freq_BM','masktemperature','ripples');
end
Fz_Type=NameEpoch;

cd('/media/nas6/ProjetEmbReact/Mouse1130/20201201/ProjectEmbReact_M1130_20201201_Habituation_PreDrug/Hab1')
load('B_Low_Spectrum.mat')
for mouse=1:length(Mouse)
    for sess=1:length(Session_type)
        for type=1:length(Fz_Type)
            % Speed
            Speed.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).speed.mean(mouse,Side_ind(type));
            % Accelero
            Accelero.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).accelero.mean(mouse,Side_ind(type));
            % Heart rate
            if TSD_DATA.(Session_type{sess}).heartrate.mean(mouse,1)<9
                HR.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = NaN;
            else
                HR.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).heartrate.mean(mouse,Side_ind(type));
            end
            % Respi
            Respi.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).respi_freq_BM.mean(mouse,Side_ind(type));
            % Temperature
            try; Temperature.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).masktemperature.mean(mouse,Side_ind(type)); end
            % Ripples density
            Ripples.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ripples.mean(mouse,Side_ind(type));
        end
    end
    Mouse_names{mouse}
end


for group=1:length(Drug_Group)
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            for type=1:length(Fz_Type)
                
                if convertCharsToStrings(Mouse_names{mouse})=='M739'; Speed.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse})=NaN; end
                Speed.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = Speed.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                Accelero.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = Accelero.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                HR.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = HR.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                Respi.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = Respi.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                try; Temperature.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = Temperature.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse}); end
                 Ripples.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = Ripples.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse});
            end
        end
    end
end


for sess=1:length(Session_type)
    for group=1:length(Drug_Group)
        for type=1:length(Fz_Type)
            Speed.(Fz_Type{type}).Figure.(Session_type{sess}){group} = Speed.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess});
            Accelero.(Fz_Type{type}).Figure.(Session_type{sess}){group} = Accelero.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess});
            HR.(Fz_Type{type}).Figure.(Session_type{sess}){group} = HR.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess});
            Respi.(Fz_Type{type}).Figure.(Session_type{sess}){group} = Respi.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess});
            try; Temperature.(Fz_Type{type}).Figure.(Session_type{sess}){group} = Temperature.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess}); end
            Temperature.(Fz_Type{type}).Figure.(Session_type{sess}){group}(Temperature.(Fz_Type{type}).Figure.(Session_type{sess}){group}==0)=NaN;
            Ripples.(Fz_Type{type}).Figure.(Session_type{sess}){group} = Ripples.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess});
            Ripples.(Fz_Type{type}).Figure.(Session_type{sess}){group}(Ripples.(Fz_Type{type}).Figure.(Session_type{sess}){group}==0)=NaN;
        end
    end
end


%% All epoch
Cols1 = {[0, 0, 1],[1, 0, 0],[0.3, 0.745, 0.93],[0.85, 0.325, 0.098]};
Legends_Drugs1 ={'SalineSB' 'Chronic Flx' 'Saline_Short','DZP_Short'};
NoLegends_Drugs1 ={'', '', '', '',''};
X1 = [1:4];

Cols2 = {[0, 0, 1],[1, 0.5, 0.5],[0, 0.5, 0],[0.2, 0.645, 0.83],[0.75, 0.225, 0]};
Legends_Drugs2 ={'SalineSB' 'Acute Flx' 'Midazolam','Saline_Long','DZP_Long'};
NoLegends_Drugs2 ={'', '', '', '',''};
X2 = [1:5];


figure; n=1;
for sess=[6 2 7 3]
    if sess==2
        subplot(2,5,2)
        MakeSpreadAndBoxPlot2_SB(Speed.Total.Figure.Cond([1 2 5 6]),Cols1,X1,Legends_Drugs1,'showpoints',1,'paired',0);
        title('Cond'); ylim([0 6])
        subplot(2,5,7)
        MakeSpreadAndBoxPlot2_SB(Speed.Total.Figure.CondPre([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0);
         title('CondPre'); ylim([0 6])
       subplot(2,5,8)
        MakeSpreadAndBoxPlot2_SB(Speed.Total.Figure.CondPost([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0);
         title('CondPost'); ylim([0 6])
   n=n+2;
    else
        subplot(1,5,n)
        MakeSpreadAndBoxPlot2_SB(Speed.Total.Figure.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
        ylim([0 9]);
        title(Session_type{sess})
        n=n+1;
    end
    if sess==6; ylabel('Speed (cm/s)'); end
end
a=suptitle('Mean speed values, Drugs UMaze'); a.FontSize=20;


figure; n=1;
for sess=[6 2 7 3]
    if sess==2
        subplot(2,5,2)
        MakeSpreadAndBoxPlot2_SB(Accelero.Total.Figure.Cond([1 2 5 6]),Cols1,X1,Legends_Drugs1,'showpoints',1,'paired',0);
        title('Cond');         ylim([0 1.5e8]);
        subplot(2,5,7)
        MakeSpreadAndBoxPlot2_SB(Accelero.Total.Figure.CondPre([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0);
         title('CondPre');         ylim([0 1.5e8]);
       subplot(2,5,8)
        MakeSpreadAndBoxPlot2_SB(Accelero.Total.Figure.CondPost([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0);
         title('CondPost');      ylim([0 1.5e8]);
   n=n+2;
    else
        subplot(1,5,n)
        MakeSpreadAndBoxPlot2_SB(Accelero.Total.Figure.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
        ylim([0 2.6e8]);
        title(Session_type{sess})
        n=n+1;
    end
    if sess==6; ylabel('Movement quantity (a.u.)'); end
end
a=suptitle('Mean accelero values, Drugs UMaze'); a.FontSize=20;


figure; n=1;
for sess=[6 2 7 3]
    if sess==2
        subplot(2,5,2)
        MakeSpreadAndBoxPlot2_SB(HR.Total.Figure.Cond([1 2 5 6]),Cols1,X1,Legends_Drugs1,'showpoints',1,'paired',0);
        title('Cond');        ylim([10 14])
        subplot(2,5,7)
        MakeSpreadAndBoxPlot2_SB(HR.Total.Figure.CondPre([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0);
         title('CondPre');        ylim([10 14])
       subplot(2,5,8)
        MakeSpreadAndBoxPlot2_SB(HR.Total.Figure.CondPost([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0);
         title('CondPost');      ylim([10 14])
   n=n+2;
    else
        subplot(1,5,n)
        MakeSpreadAndBoxPlot2_SB(HR.Total.Figure.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
        ylim([10 14])
        title(Session_type{sess})
        n=n+1;
    end
    if sess==6; ylabel('Frequency (Hz)'); end
end
a=suptitle('Mean heart rate values, Drugs UMaze'); a.FontSize=20;


figure; n=1;
for sess=[6 2 7 3]
    if sess==2
        subplot(2,5,2)
        MakeSpreadAndBoxPlot2_SB(Respi.Total.Figure.Cond([1 2 5 6]),Cols1,X1,Legends_Drugs1,'showpoints',1,'paired',0);
        title('Cond'); ylim([3 10]);
        subplot(2,5,7)
        MakeSpreadAndBoxPlot2_SB(Respi.Total.Figure.CondPre([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0);
         title('CondPre'); ylim([3 10]);
       subplot(2,5,8)
        MakeSpreadAndBoxPlot2_SB(Respi.Total.Figure.CondPost([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0);
         title('CondPost'); ylim([3 10]);
   n=n+2;
    else
        subplot(1,5,n)
        MakeSpreadAndBoxPlot2_SB(Respi.Total.Figure.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
        ylim([3 10]);
        title(Session_type{sess})
        n=n+1;
    end
    if sess==6; ylabel('Frequency (Hz)'); end
end
a=suptitle('Mean respiratory rate values, Drugs UMaze'); a.FontSize=20;


figure; n=1;
for sess=[6 2 7 3]
    if sess==2
        subplot(2,5,2)
        MakeSpreadAndBoxPlot2_SB(Ripples.Total.Figure.Cond([1 2 5 6]),Cols1,X1,Legends_Drugs1,'showpoints',1,'paired',0);
        title('Cond'); ylim([0 1.5]);
        subplot(2,5,7)
        MakeSpreadAndBoxPlot2_SB(Ripples.Total.Figure.CondPre([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0);
         title('CondPre');  ylim([0 1.5]);
       subplot(2,5,8)
        MakeSpreadAndBoxPlot2_SB(Ripples.Total.Figure.CondPost([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0);
         title('CondPost');  ylim([0 1.5]);
   n=n+2;
    else
        subplot(1,5,n)
        MakeSpreadAndBoxPlot2_SB(Ripples.Total.Figure.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
         ylim([0 1.5]);
        title(Session_type{sess})
        n=n+1;
    end
    if sess==6; ylabel('(#/s)'); end
end
a=suptitle('Mean ripples density values, Drugs UMaze'); a.FontSize=20;


figure; n=1;
for sess=[6 4 5 7 3]
    subplot(1,5,n)
    try
    MakeSpreadAndBoxPlot2_SB(Temperature.Total.Figure.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
    ylim([27 33]);
    title(Session_type{sess})
    n=n+1;
    end
    if sess==6; ylabel('Temperature (°C)'); end
end
a=suptitle('Mean total body temperature values, Drugs UMaze'); a.FontSize=20;


figure; n=1;
for sess=[6 4 5 7 3]
    subplot(3,5,n)
    MakeSpreadAndBoxPlot2_SB(FreezingProp.FigureAll.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0);
    if n==1; ylabel('Freezing proportion'); end
    title(Session_type{sess})
    ylim([-0.01 0.4])
    
    subplot(3,5,n+5)
    MakeSpreadAndBoxPlot2_SB(FreezingPercentage.Figure.Shock.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0);
    if n==1; ylabel('Shock freezing proportion'); end
    ylim([-0.01 1.1])
    
    subplot(3,5,n+10)
    MakeSpreadAndBoxPlot2_SB(FreezingPercentage.Figure.Safe.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
    if n==1; ylabel('Safe freezing proportion'); end
    ylim([-0.01 1.1])
    
    n=n+1;
end
a=suptitle('Mean freezing values, Drugs UMaze'); a.FontSize=20;

%% Freezing 
figure; n=1;
for sess=[6 4 5 7 3]
   try
       subplot(3,5,n)
    MakeSpreadAndBoxPlot2_SB(Speed.Fz.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0,'showsigstar','none');
    ylim([0 3]);
    title(Session_type{sess})
   end; try
    subplot(3,5,n+5)
    MakeSpreadAndBoxPlot2_SB(Speed.Fz_Shock.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0,'showsigstar','none');
    ylim([0 3]);
   end; try
    subplot(3,5,n+10)
    MakeSpreadAndBoxPlot2_SB(Speed.Fz_Safe.Figure.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0,'showsigstar','none');
    ylim([0 3]);
   end
    n=n+1;
    if sess==6; ylabel('Speed (cm/s)'); end
end
a=suptitle('Mean speed values, Drugs UMaze'); a.FontSize=20;


figure; n=1;
for sess=[6 4 5 7 3]
   try
       subplot(3,5,n)
    MakeSpreadAndBoxPlot2_SB(Accelero.Fz.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0,'showsigstar','none');
    ylim([0 2e7]);
    title(Session_type{sess})
   end; try
    subplot(3,5,n+5)
    MakeSpreadAndBoxPlot2_SB(Accelero.Fz_Shock.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0,'showsigstar','none');
    ylim([0 2e7]);
   end; try
    subplot(3,5,n+10)
    MakeSpreadAndBoxPlot2_SB(Accelero.Fz_Safe.Figure.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0,'showsigstar','none');
    ylim([0 2e7]);
   end
    n=n+1;
    if sess==6; ylabel('Speed (cm/s)'); end
end
a=suptitle('Mean accelero values, Drugs UMaze'); a.FontSize=20;


figure; n=1;
for sess=[4 5 7 3]
    try
        subplot(3,4,n)
        MakeSpreadAndBoxPlot2_SB(HR.Freezing.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0);
        ylim([7.5 13.5]);
        if sess==4; ylabel('Frequency (Hz)'); u=text(-2.5,9.5,'All Fz'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
        title(Session_type{sess})
    end; try
        subplot(3,4,n+4)
        MakeSpreadAndBoxPlot2_SB(HR.Freezing_shock.Figure  .(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0);
        ylim([7.5 13.5]);
        if sess==4; ylabel('Frequency (Hz)'); u=text(-2.5,9.5,'Fz shock'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
    end; try
        subplot(3,4,n+8)
        MakeSpreadAndBoxPlot2_SB(HR.Freezing_safe.Figure  .(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
       ylim([7.5 13.5]);
        if sess==4; ylabel('Frequency (Hz)'); u=text(-2.5,9.5,'Fz safe'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
   end
   n=n+1;
   if sess==6; ylabel('Frequency (Hz)'); end
end
a=suptitle('Mean heart rate values, freezing, Drugs UMaze'); a.FontSize=20;


figure; n=1;
for sess=[4 5 7 3]
    try
        subplot(3,4,n)
        MakeSpreadAndBoxPlot2_SB(Respi.Freezing.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0);
        ylim([2 8]);
        if sess==4; ylabel('Frequency (Hz)'); u=text(-2.5,3.5,'All Fz'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
        title(Session_type{sess})
    end; try
        subplot(3,4,n+4)
        MakeSpreadAndBoxPlot2_SB(Respi.Freezing_shock.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0);
        if sess==4; ylabel('Frequency (Hz)'); u=text(-2.5,3.5,'Fz shock'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
        ylim([2 8]);
    end; try
        subplot(3,4,n+8)
        MakeSpreadAndBoxPlot2_SB(Respi.Freezing_safe.Figure.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
        if sess==4; ylabel('Frequency (Hz)'); u=text(-2.5,3.5,'Fz safe'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
        ylim([2 8]);
    end
    n=n+1;
end
a=suptitle('Mean respiratory rate values, freezing, Drugs UMaze'); a.FontSize=20;


figure; n=1;
for sess=[6 4 5 7 3]
   try
       subplot(3,5,n)
    MakeSpreadAndBoxPlot2_SB(Temperature.Fz.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0,'showsigstar','none');
    ylim([27 33]);
    title(Session_type{sess})
   end; try
    subplot(3,5,n+5)
    MakeSpreadAndBoxPlot2_SB(Temperature.Fz_Shock.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0,'showsigstar','none');
    ylim([27 33]);
   end; try
    subplot(3,5,n+10)
    MakeSpreadAndBoxPlot2_SB(Temperature.Fz_Safe.Figure.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0,'showsigstar','none');
    ylim([27 33]);
   end
    n=n+1;
    if sess==6; ylabel('Speed (cm/s)'); end
end
a=suptitle('Mean respiratory rate values, freezing, Drugs UMaze'); a.FontSize=20;


figure; n=1;
for sess=[4 5 7 3]
    try
        subplot(3,4,n)
        MakeSpreadAndBoxPlot2_SB(Ripples.Freezing.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0);
        ylim([-0.01 2.5]);
        if sess==4; ylabel('Frequency (Hz)'); u=text(-2.5,.5,'All Fz'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
        title(Session_type{sess})
    end; try
        subplot(3,4,n+4)
        MakeSpreadAndBoxPlot2_SB(Ripples.Freezing_shock.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0);
        ylim([-0.01 2.5]);
        if sess==4; ylabel('Frequency (Hz)'); u=text(-2.5,.5,'Fz shock'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
    end; try
        subplot(3,4,n+8)
        MakeSpreadAndBoxPlot2_SB(Ripples.Freezing_safe.Figure.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
        ylim([-0.01 2.5]);
        if sess==4; ylabel('Frequency (Hz)'); u=text(-2.5,.5,'Fz safe'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
    end
    n=n+1;
end
a=suptitle('Mean ripples density, freezing, Drugs UMaze'); a.FontSize=20;



%% Active
figure; n=1;
for sess=[6 4 5 7 3]
    try
        subplot(3,5,n)
        MakeSpreadAndBoxPlot2_SB(Speed.Active.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0);
        ylim([0 14]); hline(5)
        if sess==6; ylabel('Speed (cm/s)'); u=text(-2.5,.5,'All Active'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
        title(Session_type{sess})
    end; try
        subplot(3,5,n+5)
        MakeSpreadAndBoxPlot2_SB(Speed.Active_shock.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0);
        ylim([0 14]);  hline(5)
        if sess==6; ylabel('Speed (cm/s)'); u=text(-2.5,.5,'Active shock'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
    end; try
        subplot(3,5,n+10)
        MakeSpreadAndBoxPlot2_SB(Speed.Active_safe.Figure.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
        ylim([0 14]); hline(5)
        if sess==6; ylabel('Speed (cm/s)'); u=text(-2.5,.5,'Active safe'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
    end
    n=n+1;
end
a=suptitle('Mean speed values, Active, Drugs UMaze'); a.FontSize=20;


figure; n=1;
for sess=[6 4 5 7 3]
    try
        subplot(3,5,n)
        MakeSpreadAndBoxPlot2_SB(Accelero.Active.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0);
        ylim([0 2e8]);
        if sess==6; ylabel('Movement quantity (a.u)'); u=text(-2.5,.5,'All Active'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
        title(Session_type{sess})
    end; try
        subplot(3,5,n+5)
        MakeSpreadAndBoxPlot2_SB(Accelero.Active_shock.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0);
        ylim([0 2e8]);
        if sess==6; ylabel('Movement quantity (a.u)'); u=text(-2.5,.5,'Active shock'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
    end; try
        subplot(3,5,n+10)
        MakeSpreadAndBoxPlot2_SB(Accelero.Active_safe.Figure.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
        ylim([0 2e8]);
        if sess==6; ylabel('Movement quantity (a.u)'); u=text(-2.5,.5,'Active safe'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
    end
    n=n+1;
end
a=suptitle('Mean accelero values, Active, Drugs UMaze'); a.FontSize=20;


figure; n=1;
for sess=[6 4 5 7 3]
   try
       subplot(3,5,n)
    MakeSpreadAndBoxPlot2_SB(HR.Active.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0);
    ylim([9 15]);
    title(Session_type{sess})
         if sess==6; ylabel('Frequency (Hz)'); u=text(-2.5,10,'Active all'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
  end; try
    subplot(3,5,n+5)
    MakeSpreadAndBoxPlot2_SB(HR.Active_shock.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0);
    ylim([9 15]);
          if sess==6; ylabel('Frequency (Hz)'); u=text(-2.5,10,'Active shock'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
 end; try
    subplot(3,5,n+10)
    MakeSpreadAndBoxPlot2_SB(HR.Active_safe.Figure.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
    ylim([9 15]);
          if sess==6; ylabel('Frequency (Hz)'); u=text(-2.5,10,'Active safe'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
 end
    n=n+1;
end
a=suptitle('Mean heart rate values, Active, Drugs UMaze'); a.FontSize=20;


figure; n=1;
for sess=[6 4 5 7 3]
    try
        subplot(3,5,n)
        MakeSpreadAndBoxPlot2_SB(Respi.Active.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0);
        ylim([4 12]);
        title(Session_type{sess})
        if sess==6; ylabel('Frequency (Hz)'); u=text(-2.5,4,'Active all'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
    end; try
        subplot(3,5,n+5)
        MakeSpreadAndBoxPlot2_SB(Respi.Active_shock.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0);
        ylim([4 12]);
        if sess==6; ylabel('Frequency (Hz)'); u=text(-2.5,4,'Active shock'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
    end; try
        subplot(3,5,n+10)
        MakeSpreadAndBoxPlot2_SB(Respi.Active_safe.Figure.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
        ylim([4 12]);
        if sess==6; ylabel('Frequency (Hz)'); u=text(-2.5,4,'Active safe'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
    end
    n=n+1;
end
a=suptitle('Mean respiratory rate values, Active, Drugs UMaze'); a.FontSize=20;


figure; n=1;
for sess=[6 4 5 7 3]
   try
       subplot(3,5,n)
    MakeSpreadAndBoxPlot2_SB(Temperature.Active.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0,'showsigstar','none');
    ylim([27 33]); hline(30)
    title(Session_type{sess})
   end; try
    subplot(3,5,n+5)
    MakeSpreadAndBoxPlot2_SB(Temperature.Active_Shock.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0,'showsigstar','none');
    ylim([27 33]); hline(30)
   end; try
    subplot(3,5,n+10)
    MakeSpreadAndBoxPlot2_SB(Temperature.Active_Safe.Figure.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0,'showsigstar','none');
    ylim([27 33]); hline(30)
   end
    n=n+1;
    if sess==6; ylabel('Speed (cm/s)'); end
end



figure; n=1;
for sess=[6 4 5 7 3]
    try
        subplot(3,5,n)
        MakeSpreadAndBoxPlot2_SB(Ripples.Active.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0,'showsigstar','none');
        ylim([-0.01 0.7]);
        title(Session_type{sess})
    end
    if sess==6; ylabel('Ripples density (#/s)'); end
    try
        subplot(3,5,n+5)
        MakeSpreadAndBoxPlot2_SB(Ripples.Active_Shock.Figure.(Session_type{sess}),Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0,'showsigstar','none');
        ylim([-0.01 0.7]);
    end
    if sess==6; ylabel('Ripples density (#/s)'); end
    try
        subplot(3,5,n+10)
        MakeSpreadAndBoxPlot2_SB(Ripples.Active_Safe.Figure.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0,'showsigstar','none');
        ylim([-0.01 0.7]);
    end
    n=n+1;
    if sess==6; ylabel('Ripples density (#/s)'); end
end





