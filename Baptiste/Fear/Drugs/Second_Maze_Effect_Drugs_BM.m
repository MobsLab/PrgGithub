

%% OB Low
clear all
cd('/media/nas6/ProjetEmbReact/DataEmbReact')
load('OB_Low_Maze.mat')
cd('/media/nas6/ProjetEmbReact/Mouse1130/20201201/ProjectEmbReact_M1130_20201201_Habituation_PreDrug/Hab1')
load('B_Low_Spectrum.mat')

GetEmbReactMiceFolderList_BM

Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};


for mouse=1:length(Mouse)
    for sess=1:5%length(Session_type)
        % Mean spec
        OB_Low_Spec.Shock.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ob_low.mean(mouse,5,:);
        OB_Low_Spec.Safe.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ob_low.mean(mouse,6,:);
        % Mean spec active
        OB_Low_Spec.Active.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ob_low.mean(mouse,4,:);
        OB_Low_Spec.Active_Shock.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ob_low.mean(mouse,7,:);
        OB_Low_Spec.Active_Safe.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ob_low.mean(mouse,8,:);
        % Max freq
        OB_Low_MaxFreq.Shock.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ob_low.max_freq(mouse,5);
        OB_Low_MaxFreq.Safe.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ob_low.max_freq(mouse,6);
        % power
        OB_Low_Power.Shock.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ob_low.power(mouse,5);
        OB_Low_Power.Safe.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ob_low.power(mouse,6);
    end
    Mouse_names{mouse}
end

Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long','Saline1','Saline2','DZP1','DZP2'};
for group=9:12
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:5%length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            OB_Low_Spec.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_Low_Spec.Shock.(Session_type{sess}).(Mouse_names{mouse});
            OB_Low_Spec.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_Low_Spec.Safe.(Session_type{sess}).(Mouse_names{mouse});
            
            OB_Low_Spec.Active.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_Low_Spec.Active.(Session_type{sess}).(Mouse_names{mouse});
            OB_Low_Spec.Active_Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_Low_Spec.Active_Shock.(Session_type{sess}).(Mouse_names{mouse});
            OB_Low_Spec.Active_Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_Low_Spec.Active_Safe.(Session_type{sess}).(Mouse_names{mouse});
            
            OB_Low_MaxFreq.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_Low_MaxFreq.Shock.(Session_type{sess}).(Mouse_names{mouse});
            OB_Low_MaxFreq.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_Low_MaxFreq.Safe.(Session_type{sess}).(Mouse_names{mouse});
            
            OB_Low_Power.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_Low_Power.Shock.(Session_type{sess}).(Mouse_names{mouse});
            OB_Low_Power.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_Low_Power.Safe.(Session_type{sess}).(Mouse_names{mouse});
            
        end
    end
end

for sess=1:5%length(Session_type)
    for group=9:12
        OB_Low_Spec.Shock.Figure.(Session_type{sess}){group} = OB_Low_Spec.Shock.(Drug_Group{group}).(Session_type{sess});
        OB_Low_Spec.Safe.Figure.(Session_type{sess}){group} = OB_Low_Spec.Safe.(Drug_Group{group}).(Session_type{sess});
        
        OB_Low_Spec.Active.Figure.(Session_type{sess}){group} = OB_Low_Spec.Active.(Drug_Group{group}).(Session_type{sess});
        OB_Low_Spec.Active_Shock.Figure.(Session_type{sess}){group} = OB_Low_Spec.Active_Shock.(Drug_Group{group}).(Session_type{sess});
        OB_Low_Spec.Active_Safe.Figure.(Session_type{sess}){group} = OB_Low_Spec.Active_Safe.(Drug_Group{group}).(Session_type{sess});
        
        OB_Low_MaxFreq.Shock.Figure.(Session_type{sess}){group} = OB_Low_MaxFreq.Shock.(Drug_Group{group}).(Session_type{sess});
        OB_Low_MaxFreq.Safe.Figure.(Session_type{sess}){group} = OB_Low_MaxFreq.Safe.(Drug_Group{group}).(Session_type{sess});
        
        OB_Low_Power.Shock.Figure.(Session_type{sess}){group} = OB_Low_Power.Shock.(Drug_Group{group}).(Session_type{sess});
        OB_Low_Power.Safe.Figure.(Session_type{sess}){group} = OB_Low_Power.Safe.(Drug_Group{group}).(Session_type{sess});
    end
end


% Figures
figure; n=1;
for sess=[4 5 3]
    for group=9:12
        subplot(3,4,group-8+4*(n-1))
        
        Data_to_use = OB_Low_Spec.Shock.Figure.(Session_type{sess}){group}./max([OB_Low_Power.Shock.Figure.(Session_type{sess}){group} OB_Low_Power.Safe.Figure.(Session_type{sess}){group}]')';
        Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
        clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
        shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter ,'-r',1); hold on;
        [c,d]=max(Mean_All_Sp(13:end));
        vline(Spectro{3}(d+12),'--r')
        Data_to_use = OB_Low_Spec.Safe.Figure.(Session_type{sess}){group}./max([OB_Low_Power.Shock.Figure.(Session_type{sess}){group} OB_Low_Power.Safe.Figure.(Session_type{sess}){group}]')';
        Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
        clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
        shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter ,'-b',1); hold on;
        [c,d]=max(Mean_All_Sp(13:end));
        vline(Spectro{3}(d+12),'--b')
        xticks([0:2:10]);
        makepretty
        
        if group==9; ylabel('Power (a.u.)'); u=text(-5,.2,Session_type{sess}); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
        if sess==4; title(Drug_Group{group}); end
        xlim([0 10]); ylim([0 1])
    end
    n=n+1;
end
a=suptitle('OB mean spectrums during freezing'); a.FontSize=20;

Cols_1 = {'-k','-m','-r'}; Cols_2 = {'-k','-c','-b'}; Cols_3 = {'--k','--m','--r'}; Cols_4 = {'--k','--c','--b'};
figure
for group=9:12
    subplot(2,4,group-8); n=1;
    for sess=[4 5 3]
        
        Data_to_use = OB_Low_Spec.Shock.Figure.(Session_type{sess}){group}./max([OB_Low_Power.Shock.Figure.(Session_type{sess}){group} OB_Low_Power.Safe.Figure.(Session_type{sess}){group}]')';
        Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
        clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
        shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter ,Cols_1{n},1); hold on;
        [c,d]=max(Mean_All_Sp(13:end));
        vline(Spectro{3}(d+12),Cols_3{n})
        xticks([0:2:10]);
        makepretty
        xlim([0 10]); ylim([0 1])
        title(Drug_Group{group})
        
        n=n+1;
    end
    if group==9; ylabel('Power (a.u.)'); u=text(-2,.4,'Shock'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90);
        f=get(gca,'Children'); legend([f(10),f(6),f(2)],'CondPre','CondPost','Ext'); end
    
    subplot(2,4,group-4); n=1;
    for sess=[4 5 3]
        
        Data_to_use = OB_Low_Spec.Safe.Figure.(Session_type{sess}){group}./max([OB_Low_Power.Shock.Figure.(Session_type{sess}){group} OB_Low_Power.Safe.Figure.(Session_type{sess}){group}]')';
        Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
        clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
        shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter ,Cols_2{n},1); hold on;
        [c,d]=max(Mean_All_Sp(13:end));
        vline(Spectro{3}(d+12),Cols_4{n})
        xticks([0:2:10]);
        makepretty
        xlim([0 10]); ylim([0 1])
        xlabel('Frequency (Hz)')
        
        n=n+1;
    end
    if group==9; ylabel('Power (a.u.)'); u=text(-2,.4,'Shock'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); 
    f=get(gca,'Children'); legend([f(10),f(6),f(2)],'CondPre','CondPost','Ext'); end
end
a=suptitle('OB mean spectrums during freezing'); a.FontSize=20;


%
Cols = {[1 .5 .5],[.8 .5 .5],[1 .7 .7],[.8 .7 .7],[.5 .5 1],[.5 .5 .8],[.7 .7 1],[.7 .7 .8]};
X = [1:8];
Legends = {'Shock Saline1','Shock Saline2','Shock DZP1','Shock DZP2','Safe Saline1','Safe Saline2','Safe DZP1','Safe DZP2'};


figure
subplot(131)
MakeSpreadAndBoxPlot2_SB([OB_Low_MaxFreq.Shock.Figure.CondPre{5}  OB_Low_MaxFreq.Safe.Figure.CondPre{5} OB_Low_MaxFreq.Shock.Figure.CondPre{6}  OB_Low_MaxFreq.Safe.Figure.CondPre{6}],Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 8])
title('CondPre'); ylabel('Frequency (Hz)')
subplot(132)
MakeSpreadAndBoxPlot2_SB([OB_Low_MaxFreq.Shock.Figure.CondPost{5} OB_Low_MaxFreq.Safe.Figure.CondPost{5} OB_Low_MaxFreq.Shock.Figure.CondPost{6} OB_Low_MaxFreq.Safe.Figure.CondPost{6}],{[1 .5 .5],[.5 .5 1],[.8 .5 .5],[.5 .5 .8]},[1:4],{'Shock Saline','Safe Saline','Shock DZP','Safe DZP'},'showpoints',1,'paired',0);
title('CondPost')
ylim([0 8])
subplot(133)
MakeSpreadAndBoxPlot2_SB([OB_Low_MaxFreq.Shock.Figure.Ext{5} OB_Low_MaxFreq.Safe.Figure.Ext{5} OB_Low_MaxFreq.Shock.Figure.Ext{6} OB_Low_MaxFreq.Safe.Figure.Ext{6}],{[1 .5 .5],[.5 .5 1],[.8 .5 .5],[.5 .5 .8]},[1:4],{'Shock Saline','Safe Saline','Shock DZP','Safe DZP'},'showpoints',1,'paired',0);
title('Ext')
ylim([0 8])
a=suptitle('OB low frequencies during freezing'); a.FontSize=20;

%% Peak
Cols = {[1 .5 .5],[.8 .5 .5],[1 .7 .7],[.8 .7 .7],[.5 .5 1],[.5 .5 .8],[.7 .7 1],[.7 .7 .8]};
X = [1:8];
Legends = {'Shock Saline1','Shock Saline2','Shock DZP1','Shock DZP2','Safe Saline1','Safe Saline2','Safe DZP1','Safe DZP2'};

figure
subplot(131)
MakeSpreadAndBoxPlot2_SB([{nanmean((HistData.Shock.Saline1.CondPre.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Shock.Saline2.CondPre.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Shock.DZP1.CondPre.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Shock.DZP2.CondPre.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Safe.Saline1.CondPre.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Safe.Saline2.CondPre.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Safe.DZP1.CondPre.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Safe.DZP2.CondPre.*(Spectro{3}(13:103)))')*100}]',Cols,X,Legends,'showpoints',1,'paired',0);
ylim([3 8])
title('CondPre'); ylabel('Frequency (Hz)')
subplot(132)
MakeSpreadAndBoxPlot2_SB([{nanmean((HistData.Shock.Saline1.CondPost.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Shock.Saline2.CondPost.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Shock.DZP1.CondPost.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Shock.DZP2.CondPost.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Safe.Saline1.CondPost.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Safe.Saline2.CondPost.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Safe.DZP1.CondPost.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Safe.DZP2.CondPost.*(Spectro{3}(13:103)))')*100}]',Cols,X,Legends,'showpoints',1,'paired',0);
title('CondPost')
ylim([3 8])
subplot(133)
MakeSpreadAndBoxPlot2_SB([{nanmean((HistData.Shock.Saline1.Ext.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Shock.Saline2.Ext.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Shock.DZP1.Ext.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Shock.DZP2.Ext.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Safe.Saline1.Ext.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Safe.Saline2.Ext.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Safe.DZP1.Ext.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Safe.DZP2.Ext.*(Spectro{3}(13:103)))')*100}]',Cols,X,Legends,'showpoints',1,'paired',0);
title('Ext')
ylim([3 8])
a=suptitle('OB low frequencies during freezing'); a.FontSize=20;




%% Behaviour
figure; n=1;
for sess=[4 5 3]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot2_SB(FreezingProp.FigureAll.(Session_type{sess})([9:12]),Cols2,X2,NoLegends_Drugs2,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Freezing proportion'); end
    title(Session_type{sess})
    ylim([-0.01 0.5])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot2_SB(FreezingProp.FigureShock.(Session_type{sess})([9:12]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Shock/Safe ratio'); end
    ylim([-0.01 1.1])
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments'); a.FontSize=20;

figure; n=1;
for sess=[4 5 3]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot2_SB(FreezingPercentage.Figure.Shock.(Session_type{sess})([9:12]),Cols2,X2,NoLegends_Drugs2,'showpoints',1,'paired',0);
    if sess==4; ylabel('Shock freezing proportion'); end
    title(Session_type{sess})
    ylim([-0.01 .8])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot2_SB(FreezingPercentage.Figure.Safe.(Session_type{sess})([9:12]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0);
    if sess==4; ylabel('Safe freezing proportion'); end
    ylim([-0.01 .5])
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments'); a.FontSize=20;


figure; sess=4;
subplot(241)
MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.FigureShock.(Session_type{sess})([9:12]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); makepretty; xtickangle(45);
title('Shock zone occupancy'); ylabel('proportion')
ylim([-0.01 0.55])
u=text(-2.5,.15,Session_type{sess}); set(u,'FontSize',20,'FontWeight','bold','Rotation',90);

subplot(242)
MakeSpreadAndBoxPlot2_SB(ShockZoneEntries.Figure.(Session_type{sess})([9:12]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); makepretty; xtickangle(45);
title('Shock zone entries'); ylabel('#/min')

subplot(243)
MakeSpreadAndBoxPlot2_SB(ExtraStim.Figure.(Session_type{sess})([9:12]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); makepretty; xtickangle(45);
title('Extra stim'); ylabel('#/min')

subplot(244)
MakeSpreadAndBoxPlot2_SB(Stim_By_SZ_entries.(Session_type{sess})([9:12]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); makepretty; xtickangle(45);
title('SZ entries / extra-stim'); ylabel('entries/shock')

sess=5;
subplot(245)
MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.FigureShock.(Session_type{sess})([9:12]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); makepretty; xtickangle(45);
ylabel('proportion')
ylim([-0.01 0.45])
u=text(-2.5,.15,Session_type{sess}); set(u,'FontSize',20,'FontWeight','bold','Rotation',90);

subplot(246)
MakeSpreadAndBoxPlot2_SB(ShockZoneEntries.Figure.(Session_type{sess})([9:12]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); makepretty; xtickangle(45);
ylabel('#/min')

subplot(247)
MakeSpreadAndBoxPlot2_SB(ExtraStim.Figure.(Session_type{sess})([9:12]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); makepretty; xtickangle(45);
ylabel('#/min')

subplot(248)
MakeSpreadAndBoxPlot2_SB(Stim_By_SZ_entries.(Session_type{sess})([9:12]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); makepretty; xtickangle(45);
ylabel('entries/shock')

a=suptitle('Conditionning sessions analysis, UMaze drugs experiments'); a.FontSize=20;



figure; n=1;
for sess=[6 4 5 7 3]
    subplot(2,5,n)
    MakeSpreadAndBoxPlot2_SB(OccupancyMeanTime.Figure.Shock.(Session_type{sess})([9:12]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); makepretty; xtickangle(45);
    if sess==6; ylabel('Mean time in shock zone (s)'); end
    title(Session_type{sess})
    ylim([-0.01 20])
    
    subplot(2,5,n+5)
    MakeSpreadAndBoxPlot2_SB(OccupancyMeanTime.Figure.Safe.(Session_type{sess})([9:12]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); makepretty; xtickangle(45);
    if sess==6; ylabel('Mean time in safe zone (s)'); end
    ylim([-0.01 60])
    
    n=n+1;
end
a=suptitle('Mean time in zone when unblocked'); a.FontSize=20;


figure
sess=7;
subplot(131)
MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.FigureShock.(Session_type{sess})(9:12),Cols1,X1,Legends_Drugs1,'showpoints',1,'paired',0); makepretty; xtickangle(45);
title('Shock zone occupancy'); 
ylim([-0.01 0.36])
hline(.3501,'--r')

subplot(132)
MakeSpreadAndBoxPlot2_SB(ShockZoneEntries.Figure.(Session_type{sess})(9:12),Cols1,X1,Legends_Drugs1,'showpoints',1,'paired',0); makepretty; xtickangle(45);
title('Shock zone entries'); ylabel('#/min')
hline(2.1365,'--r')

subplot(133)
MakeSpreadAndBoxPlot2_SB(Latency_SZ.Figure.(Session_type{sess})(9:12),Cols1,X1,Legends_Drugs1,'showpoints',1,'paired',0); makepretty; xtickangle(45);
title('Shock zone latency'); ylabel('time (s)')
hline(15.7,'--r')

a=suptitle('Test Post analysis, UMaze drugs experiments'); a.FontSize=20;



%% Ripples
cd('/media/nas6/ProjetEmbReact/DataEmbReact')
load('Ripples_Maze.mat')
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short'...
    'SalineBM_Long','Diazepam_Long','Saline1','Saline2','DZP1','DZP2'};
GetEmbReactMiceFolderList_BM
Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};


for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        Ripples.Shock.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ripples.mean(mouse,5);
        Ripples.Safe.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ripples.mean(mouse,6);
    end
    Mouse_names{mouse}
end

for group=1:length(Drug_Group)
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            try
            Ripples.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Ripples.Shock.(Session_type{sess}).(Mouse_names{mouse});
            Ripples.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Ripples.Safe.(Session_type{sess}).(Mouse_names{mouse});
            end
        end
    end
end

for sess=1:length(Session_type)
    for group=1:length(Drug_Group)
        Ripples.Shock.Figure.(Session_type{sess}){group} = Ripples.Shock.(Drug_Group{group}).(Session_type{sess});
        Ripples.Safe.Figure.(Session_type{sess}){group} = Ripples.Safe.(Drug_Group{group}).(Session_type{sess});
        Ripples.Shock.Figure.(Session_type{sess}){group}(Ripples.Shock.Figure.(Session_type{sess}){group}==0)=NaN;
        Ripples.Safe.Figure.(Session_type{sess}){group}(Ripples.Safe.Figure.(Session_type{sess}){group}==0)=NaN;
    end
end

Cols = {[1 0.5 0.5],[0.5 0.5 1]};
X = [1,2];
Legends = {'Shock','Safe'};
NoLegends = {'',''};

% Max freq
figure; n=1;
for sess=[4 5 3]
    for group=1:8
        subplot(3,8,group+8*(n-1))
        try
        if sess==3; MakeSpreadAndBoxPlot2_SB([Ripples.Shock.Figure.(Session_type{sess}){group} Ripples.Safe.Figure.(Session_type{sess}){group}],Cols,X,Legends,'showpoints',0,'paired',1);
        else; MakeSpreadAndBoxPlot2_SB([Ripples.Shock.Figure.(Session_type{sess}){group} Ripples.Safe.Figure.(Session_type{sess}){group}],Cols,X,NoLegends,'showpoints',0,'paired',1); end
        if group==1; ylabel('Density (Hz)'); end
        if sess==4; title(Drug_Group{group}); end
        ylim([0 1.5])
        end
        end
    n=n+1;
end
a=suptitle('Ripples density during freezing'); a.FontSize=20;


figure; n=1;
for sess=[4 5 3]
    for group=9:12
        subplot(3,4,group-8+4*(n-1))
        try
            if sess==3; MakeSpreadAndBoxPlot2_SB([Ripples.Shock.Figure.(Session_type{sess}){group} Ripples.Safe.Figure.(Session_type{sess}){group}],Cols,X,Legends,'showpoints',0,'paired',1);
            else; MakeSpreadAndBoxPlot2_SB([Ripples.Shock.Figure.(Session_type{sess}){group} Ripples.Safe.Figure.(Session_type{sess}){group}],Cols,X,NoLegends,'showpoints',0,'paired',1); end
            if group==9; ylabel('Hz'); end
            if sess==4; title(Drug_Group{group}); end
            ylim([0 2])
        end
    end
    n=n+1;
end
a=suptitle('Ripples density during freezing'); a.FontSize=20;


figure; n=1;
for sess=[2 3]
    for group=9:12
        subplot(2,4,group-8+4*(n-1))
        try
            if sess==3; MakeSpreadAndBoxPlot2_SB([Ripples.Shock.Figure.(Session_type{sess}){group} Ripples.Safe.Figure.(Session_type{sess}){group}],Cols,X,Legends,'showpoints',0,'paired',1);
            else; MakeSpreadAndBoxPlot2_SB([Ripples.Shock.Figure.(Session_type{sess}){group} Ripples.Safe.Figure.(Session_type{sess}){group}],Cols,X,NoLegends,'showpoints',0,'paired',1); end
            if group==9; ylabel('Hz'); end
            if sess==2; title(Drug_Group{group}); end
            ylim([0 2])
        end
    end
    n=n+1;
end
a=suptitle('Ripples density during freezing'); a.FontSize=20;



%% Occupaancy maps

figure; m=1;
for group=9:12
    
    subplot(4,4,1+(m-1)*4);
    imagesc(OccupMap_squeeze.(Drug_Group{group}).TestPre)
    axis xy; caxis ([0 8e-4])
    if m==1; title('Test Pre'); end
    ylabel(Drug_Group{group}); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    Maze_Frame_BM
    
    subplot(4,4,2+(m-1)*4);
    imagesc(OccupMap_squeeze.(Drug_Group{group}).CondPre)
    axis xy; caxis ([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Cond Pre'); end
    Maze_Frame_BM
    
    subplot(4,4,3+(m-1)*4);
    imagesc(OccupMap_squeeze.(Drug_Group{group}).CondPost)
    axis xy; caxis ([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Cond Post'); end
    Maze_Frame_BM
    
    subplot(4,4,4+(m-1)*4);
    imagesc(OccupMap_squeeze.(Drug_Group{group}).TestPost)
    axis xy; caxis ([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Test Post'); end
    Maze_Frame_BM
    
    colormap jet
    m=m+1;
end
a=suptitle('Occupancy maps for all drugs groups'); a.FontSize=20;
  

%% Time in zones
X = [1:4];
Cols = {[0, 0, 1],[0 0 .8],[0.85, 0.325, 0.098],[0.65, 0.325, 0.098]};
Legends_Drugs ={'Saline1' 'Saline2' 'DZP1','DZP2'};
NoLegends_Drugs ={'', '', '', ''};



figure
for zones=1:5
    n=1;
    for sess=[6 4 5 7]
        
        subplot(5,4,n+(zones-1)*4)
        
        if zones==5; MakeSpreadAndBoxPlot2_SB(Proportion_Time_Spent_In_Zones.Figure.(Session_type{sess}){zones}(9:12)  ,Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
        else; MakeSpreadAndBoxPlot2_SB(Proportion_Time_Spent_In_Zones.Figure.(Session_type{sess}){zones}(9:12)  ,Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0);
        end
        if zones==1; title(Session_type{sess}); end
        if sess==6; ylabel(['Zones ' num2str(zones)]); end 
        n=n+1;
   
    end
end
a=suptitle('Zones occupancy during Maze, drugs'); a.FontSize=20;


figure;
for zones=1:5
    n=1;
    for sess=[4 5 7]
        
        subplot(5,3,n+(zones-1)*3)
        
        if zones==5; MakeSpreadAndBoxPlot2_SB(Proportion_Time_Spent_Freezing_In_Zones.Figure.(Session_type{sess}){zones}(9:12)  ,Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
        else; MakeSpreadAndBoxPlot2_SB(Proportion_Time_Spent_Freezing_In_Zones.Figure.(Session_type{sess}){zones}(9:12)  ,Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0);
        end
        if zones==1; title(Session_type{sess}); end
        if sess==4; ylabel(['Zones ' num2str(zones)]); end
        n=n+1;
        
    end
end
a=suptitle('Freezing proportion in zones during Maze, drugs'); a.FontSize=20;



