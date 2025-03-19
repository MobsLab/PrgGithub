

% after edit AllSalineAnalysis_Maze_Paper_SBM.m
% or
% after this : 

GetEmbReactMiceFolderList_BM
Session_type={'Habituation','TestPre','Cond','TestPost'};
Mouse = [688 777 849 1144 1146 1147 1170 1171 9184 9205 1391 1392 1394 1224 1225 1226 739 779 893 1189 1393];
Side = {'All','Shock','Safe'};

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        Sessions_List_ForLoop_BM
        try
            Speed.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'speed');
        end
    end
    disp(Mouse_names{mouse})
end



for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            Speed_all.(Session_type{sess})(mouse) = nanmean(Data(Speed.(Session_type{sess}).(Mouse_names{mouse})));
            D = Data(Speed.(Session_type{sess}).(Mouse_names{mouse})); D=D(D<2);
            ImmobilityTime.(Session_type{sess})(mouse) = length(D)/length(Data(Speed.(Session_type{sess}).(Mouse_names{mouse})));
        end
    end
end


[Y,X]=hist(Data(Speed.TestPre.(Mouse_names{22})),50);
Y=Y/sum(Y);
bar(X,Y)
xlim([0 30])
xlabel('Speed (cm/s)'), ylabel('hits')

figure
subplot(141)
PlotCorrelations_BM(Speed_all.TestPre(1:21) , ExtraStim_all.Cond(1:21))
xlabel('Speed, TestPre (cm/s)'), ylabel('Eyelid in Cond (#)'), axis square
title('PAG')

subplot(142)
D1 = Speed_all.TestPre(1:21); 
D2 = ExtraStim_all.Cond(1:21); 
ind = D2>10;
PlotCorrelations_BM(D1(ind) , D2(ind))
xlabel('Speed, TestPre (cm/s)'), axis square
title('PAG mice receiving more than 10 stim in Cond')

subplot(143)
PlotCorrelations_BM(Speed_all.TestPre(22:end) , ExtraStim_all.Cond(22:end))
xlabel('Speed, TestPre (cm/s)'), axis square
ylim([0 19])
title('Eyelid')

subplot(144)
D1 = Speed_all.TestPre(22:end); 
D2 = ExtraStim_all.Cond(22:end); 
ind = D2<10;
PlotCorrelations_BM(D1(ind) , D2(ind))
xlabel('Speed, TestPre (cm/s)'), axis square
ylim([0 10])
title('Eyelid mice receiving less than 10 eyelids in Cond')

a=suptitle('Correlation of speed in TestPre and eyelid shocks in Cond'); a.FontSize=20;




figure
subplot(141)
PlotCorrelations_BM(ImmobilityTime.TestPre(1:21) , ExtraStim_all.Cond(1:21))
xlabel('Immobility, TestPre (prop)'), ylabel('Eyelid in Cond (#)'), axis square
title('PAG')

subplot(142)
D1 = ImmobilityTime.TestPre(1:21); 
D2 = ExtraStim_all.Cond(1:21); 
ind = D2>10;
PlotCorrelations_BM(D1(ind) , D2(ind))
xlabel('Immobility, TestPre (prop)'), axis square
title('PAG mice receiving more than 10 stim in Cond')

subplot(143)
PlotCorrelations_BM(ImmobilityTime.TestPre(22:end) , ExtraStim_all.Cond(22:end))
xlabel('Immobility, TestPre (prop)'), axis square
ylim([0 19])
title('Eyelid')

subplot(144)
D1 = ImmobilityTime.TestPre(22:end); 
D2 = ExtraStim_all.Cond(22:end); 
ind = D2<10;
PlotCorrelations_BM(D1(ind) , D2(ind))
xlabel('Immobility, TestPre (prop)'), axis square
ylim([0 10])
title('Eyelid mice receiving less than 10 eyelids in Cond')

a=suptitle('Correlation of immobility in TestPre and eyelid shocks in Cond'); a.FontSize=20;


%%



figure
MakeSpreadAndBoxPlot3_SB({FreezeTime.TestPre([1:8 18:end])./ExpeDuration.TestPre([1:8 18:end]) FreezeTime.Cond([1:8 18:end])./ExpeDuration.Cond([1:8 18:end])},{[.4 .4 .4],[0 .45 .74]},[1 2],{'TestPre','Cond'},'showpoints',0,'paired',1);
ylabel('time proportion')

figure
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries_dens.TestPre ShockZoneEntries_dens.Cond},{[.4 .4 .4],[0 .45 .74]},[1 2],{'TestPre','Cond'},'showpoints',0,'paired',1);
ylabel('zone entries (#/min)')

figure
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries_dens.TestPre ShockZoneEntries_dens.Cond},{[.4 .4 .4],[0 .45 .74]},[1 2],{'TestPre','Cond'},'showpoints',0,'paired',1);
ylabel('zone entries (#/min)')

figure, sess=2;
MakeSpreadAndBoxPlot3_SB({FreezeTime_Shock.(Session_type{sess})([1:14 16:end])/60 FreezeTime_Safe.(Session_type{sess})([1:14 16:end])/60},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('temps (min)'), title('Freezing duration')



