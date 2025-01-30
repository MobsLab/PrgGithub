
GetEmbReactMiceFolderList_BM

Session_type={'Fear','Cond','Ext','CondPre','CondPost'};
cd('/media/nas6/ProjetEmbReact/Mouse1189/20210420/ProjectEmbReact_M11189_20210420_UMazeCondBlockedShock_PostDrug/Cond2'); load('B_Low_Spectrum.mat')
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short'};
Side={'All','Shock','Safe'}; Side_ind=[3 5 6];
X = [1:8];
Cols = {[0, 0, 1],[1, 0, 0],[1, 0.5, 0.5],[0, 0.5, 0],[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83],[0.75, 0.225, 0]};
Legends_Drugs ={'SalineSB' 'Chronic Flx' 'Acute Flx' 'Midazolam','Saline_Short','DZP_Short','Saline_Long','DZP_Long'};
NoLegends_Drugs ={'', '', '', '','','','',''};

for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch]=MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'respi_freq_BM');
end

for sess=1:length(Session_type) % generate all data required for analyses
    for mouse = 1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for side=1:length(Side)
            try
                h=histogram(Data(TSD_DATA.(Session_type{sess}).respi_freq_bm.tsd{mouse,Side_ind(side)}),'BinLimits',[1 8],'NumBins',91); % 91=nansum(and(1<Spectro{3},Spectro{3}<8))
                HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = h.Values;
            end
        end
    end
end


for group=1:length(Drug_Group)
Mouse=Drugs_Groups_UMaze_BM(group);    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            for side=1:length(Side)
                try
                    if isnan(runmean_BM(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})),3))
                        HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = NaN(1,91);
                    else
                        HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = runmean(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})),3);
                    end
                catch
                    HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = NaN(1,91);
                end
            end
        end
    end
end

% if you want pie chart run :
GetEmbReactMiceFolderList_BM
Create_Behav_Drugs_BM

%% Plot shock safe side freezing
for group=1:4
    n=1;
    for sess=[4 5 3]
        
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


for group=1:4
    n=1;
    for sess=[4 5 3]
        
        axes('Position',[.24+(group-1)*.208 .85-(n-1)*.29 .05 .05]); box on
        a= pie([nanmean(FreezingProp.All.(Drug_Group{group}).(Session_type{sess})) 1-nanmean(FreezingProp.All.(Drug_Group{group}).(Session_type{sess}))]); set(a(1), 'FaceColor', [0 0 0]); set(a(3), 'FaceColor', [1 1 1]);
        axes('Position',[.24+(group-1)*.208 .77-(n-1)*.29 .05 .05]); box on
        a= pie([nanmean(FreezingProp.Shock.(Drug_Group{group}).(Session_type{sess})) 1-nanmean(FreezingProp.Shock.(Drug_Group{group}).(Session_type{sess}))]); set(a(1), 'FaceColor', [1 0.5 0.5]); set(a(3), 'FaceColor', [0.5 0.5 1]);
        
        n=n+1;
    end
end

    
figure
for group=5:8
    n=1;
    for sess=[4 5 3] % generate all data required for analyses
        
        subplot(3,4,4*(n-1)+group-4)
        
        Conf_Inter=nanstd(HistData.Shock.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(HistData.Shock.(Drug_Group{group}).(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.Shock.(Drug_Group{group}).(Session_type{sess})),Conf_Inter,'r',1); hold on;
        Conf_Inter=nanstd(HistData.Safe.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(HistData.Safe.(Drug_Group{group}).(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.Safe.(Drug_Group{group}).(Session_type{sess})),Conf_Inter,'b',1); hold on;
        makepretty; grid on
        ylim([0 .06]);
        if and(n==1,group==5); u=text(-2,0.02,'CondPre','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if and(n==2,group==5); u=text(-2,0.02,'CondPost','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if and(n==3,group==5); u=text(-2,0.02,'Ext','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if n==1; title(Drug_Group{group}); end
        if n==3; xlabel('Frequency (Hz)'); end
        if and(n==1,group==1); f=get(gca,'Children'); legend([f(8),f(4)],'Shock','Safe'); end
        
        n=n+1;
    end
end
a=suptitle('Breathing frequency during freezing, spent time analysis'); a.FontSize=20;

for group=5:8
    n=1;
    for sess=[4 5 3]
        
        axes('Position',[.24+(group-5)*.208 .85-(n-1)*.29 .05 .05]); box on
        a= pie([nanmean(FreezingProp.All.(Drug_Group{group}).(Session_type{sess})) 1-nanmean(FreezingProp.All.(Drug_Group{group}).(Session_type{sess}))]); set(a(1), 'FaceColor', [0 0 0]); set(a(3), 'FaceColor', [1 1 1]);
        axes('Position',[.24+(group-5)*.208 .77-(n-1)*.29 .05 .05]); box on
        a= pie([nanmean(FreezingProp.Shock.(Drug_Group{group}).(Session_type{sess})) 1-nanmean(FreezingProp.Shock.(Drug_Group{group}).(Session_type{sess}))]); set(a(1), 'FaceColor', [1 0.5 0.5]); set(a(3), 'FaceColor', [0.5 0.5 1]);
        
        n=n+1;
    end
end


figure; n=1;
for sess=[4 5 3]
    for side=2:3
        subplot(3,2,2*(n-1)+side-1)
       Conf_Inter=nanstd(HistData.(Side{side}).SalineSB.(Session_type{sess}))/sqrt(size(HistData.(Side{side}).SalineSB.(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.(Side{side}).SalineSB.(Session_type{sess})),Conf_Inter,'b',1); hold on;
        Conf_Inter=nanstd(HistData.(Side{side}).SalineBM_Short.(Session_type{sess}))/sqrt(size(HistData.(Side{side}).SalineBM_Short.(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.(Side{side}).SalineBM_Short.(Session_type{sess})),Conf_Inter,'m',1); hold on;
        Conf_Inter=nanstd(HistData.(Side{side}).SalineBM_Long.(Session_type{sess}))/sqrt(size(HistData.(Side{side}).SalineBM_Long.(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.(Side{side}).SalineBM_Long.(Session_type{sess})),Conf_Inter,'k',1); hold on;
       makepretty; grid on
        if sess==3; xlabel('Frequency (Hz)'); end
        if side==2; ylabel(Session_type{sess}); end
        a=ylim; ylim([0 a(2)]); xlim([0 8])
        if and(n==1,side==2); f=get(gca,'Children'); legend([f(9),f(5),f(1)],'SB','BM short','BM long'); title('Shock'); end
        if and(n==1,side==3); title('Safe'); end
        
    end
    n=n+1;
end

a=suptitle('Saline groups comparison'); a.FontSize=20;


figure; n=1;
for sess=[4 5 3]
    for side=2:3
        subplot(3,2,2*(n-1)+side-1)
        if  side==2
            Conf_Inter=nanstd(HistData.(Side{side}).SalineBM_Short.(Session_type{sess}))/sqrt(size(HistData.(Side{side}).SalineBM_Short.(Session_type{sess}),1));
            shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.(Side{side}).SalineBM_Short.(Session_type{sess})),Conf_Inter,'r',1); hold on;
        else
            Conf_Inter=nanstd(HistData.(Side{side}).SalineBM_Short.(Session_type{sess}))/sqrt(size(HistData.(Side{side}).SalineBM_Short.(Session_type{sess}),1));
            shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.(Side{side}).SalineBM_Short.(Session_type{sess})),Conf_Inter,'b',1); hold on;
        end
        Conf_Inter=nanstd(HistData.(Side{side}).Diazepam_Short.(Session_type{sess}))/sqrt(size(HistData.(Side{side}).Diazepam_Short.(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.(Side{side}).Diazepam_Short.(Session_type{sess})),Conf_Inter,'k',1); hold on;
        makepretty; grid on
        if sess==3; xlabel('Frequency (Hz)'); end
        if side==2; ylabel(Session_type{sess}); end
        a=ylim; ylim([0 a(2)]); xlim([0 8])
        if and(n==1,side==2); f=get(gca,'Children'); legend([f(5),f(1)],'Saline BM short','Diazepam short'); title('Shock'); end
        if and(n==1,side==3); title('Safe'); end
        
    end
    n=n+1;
end
a=suptitle('Short groups comparison'); a.FontSize=20;


figure; n=1;
for sess=[4 5 3]
    for side=2:3
        subplot(3,2,2*(n-1)+side-1)
        if side==2;
            Conf_Inter=nanstd(HistData.(Side{side}).SalineBM_Long.(Session_type{sess}))/sqrt(size(HistData.(Side{side}).SalineBM_Long.(Session_type{sess}),1));
            shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.(Side{side}).SalineBM_Long.(Session_type{sess})),Conf_Inter,'r',1); hold on;
        else
            Conf_Inter=nanstd(HistData.(Side{side}).SalineBM_Long.(Session_type{sess}))/sqrt(size(HistData.(Side{side}).SalineBM_Long.(Session_type{sess}),1));
            shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.(Side{side}).SalineBM_Long.(Session_type{sess})),Conf_Inter,'b',1); hold on;
        end
        Conf_Inter=nanstd(HistData.(Side{side}).Diazepam_Long.(Session_type{sess}))/sqrt(size(HistData.(Side{side}).Diazepam_Long.(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.(Side{side}).Diazepam_Long.(Session_type{sess})),Conf_Inter,'k',1); hold on;
        makepretty; grid on
        if sess==3; xlabel('Frequency (Hz)'); end
        if side==2; ylabel(Session_type{sess}); end
        a=ylim; ylim([0 a(2)]); xlim([0 8])
        if and(n==1,side==2); f=get(gca,'Children');  legend([f(5),f(1)],'Saline BM long','Diazepam long'); title('Shock'); end
        if and(n==1,side==3); title('Safe'); end
        
    end
    n=n+1;
end
a=suptitle('Long groups comparison'); a.FontSize=20;


% mean of distribution
figure
subplot(131)
MakeSpreadAndBoxPlot2_SB([{nanmean((HistData.Shock.SalineBM_Short.CondPre.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Safe.SalineBM_Short.CondPre.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Shock.Diazepam_Short.CondPre.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Safe.Diazepam_Short.CondPre.*(Spectro{3}(13:103)))')*100}]',{[1 .5 .5],[.5 .5 1],[.8 .5 .5],[.5 .5 .8]},[1:4],{'Shock Saline','Safe Saline','Shock DZP','Safe DZP'},'showpoints',1,'paired',0);
ylim([3 8])
title('CondPre'); ylabel('Frequency (Hz)')
subplot(132)
MakeSpreadAndBoxPlot2_SB([{nanmean((HistData.Shock.SalineBM_Short.CondPost.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Safe.SalineBM_Short.CondPost.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Shock.Diazepam_Short.CondPost.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Safe.Diazepam_Short.CondPost.*(Spectro{3}(13:103)))')*100}]',{[1 .5 .5],[.5 .5 1],[.8 .5 .5],[.5 .5 .8]},[1:4],{'Shock Saline','Safe Saline','Shock DZP','Safe DZP'},'showpoints',1,'paired',0);
title('CondPost')
ylim([3 8])
subplot(133)
MakeSpreadAndBoxPlot2_SB([{nanmean((HistData.Shock.SalineBM_Short.Ext.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Safe.SalineBM_Short.Ext.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Shock.Diazepam_Short.Ext.*(Spectro{3}(13:103)))')*100} ; {nanmean((HistData.Safe.Diazepam_Short.Ext.*(Spectro{3}(13:103)))')*100}]',{[1 .5 .5],[.5 .5 1],[.8 .5 .5],[.5 .5 .8]},[1:4],{'Shock Saline','Safe Saline','Shock DZP','Safe DZP'},'showpoints',1,'paired',0);
title('Ext')
ylim([3 8])
a=suptitle('OB low frequencies during freezing'); a.FontSize=20;




%% All freezing
figure
for group=1:4
    n=1;
    for sess=[4 5 3] % generate all data required for analyses
        
        subplot(3,4,4*(n-1)+group)
        
        Conf_Inter=nanstd(HistData.All.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(HistData.All.(Drug_Group{group}).(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.All.(Drug_Group{group}).(Session_type{sess})),Conf_Inter,'k',1); hold on;
        makepretty; grid on
        a=ylim; ylim([0 a(2)]);
        if and(n==1,group==1); u=text(-2,0.02,'CondPre','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if and(n==2,group==1); u=text(-2,0.02,'CondPost','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if and(n==3,group==1); u=text(-2,0.02,'Ext','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if n==1; title(Drug_Group{group}); end
        if n==3; xlabel('Frequency (Hz)'); end
    
    n=n+1;
    end
end
a=suptitle('Breathing frequency during freezing, spent time analysis'); a.FontSize=20;

for group=1:4
    n=1;
    for sess=[4 5 3]
        
        axes('Position',[.24+(group-1)*.208 .85-(n-1)*.29 .05 .05]); box on
        a= pie([nansum(nansum(HistData.All.(Drug_Group{group}).(Session_type{sess})(:,40:end)))/nansum(nansum(HistData.All.(Drug_Group{group}).(Session_type{sess}))) 1-nansum(nansum(HistData.All.(Drug_Group{group}).(Session_type{sess})(:,40:end)))/nansum(nansum(HistData.All.(Drug_Group{group}).(Session_type{sess})))]); set(a(1), 'FaceColor', [0 0 0]); set(a(3), 'FaceColor', [1 1 1]);
        
        n=n+1;
    end
end
a=suptitle('Breathing frequency during freezing, spent time analysis'); a.FontSize=20;


figure
for group=5:8
    n=1;
    for sess=[4 5 3]
        
        subplot(3,4,4*(n-1)+group-4)
        
        Conf_Inter=nanstd(HistData.All.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(HistData.All.(Drug_Group{group}).(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.All.(Drug_Group{group}).(Session_type{sess})),Conf_Inter,'k',1); hold on;
        makepretty; grid on
        a=ylim; ylim([0 a(2)]);
        if and(n==1,group==5); u=text(-2,0.02,'CondPre','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if and(n==2,group==5); u=text(-2,0.02,'CondPost','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if and(n==3,group==5); u=text(-2,0.02,'Ext','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if n==1; title(Drug_Group{group}); end
        if n==3; xlabel('Frequency (Hz)'); end
        
        n=n+1;
    end
end

for group=5:8
    n=1;
    for sess=[4 5 3]
        
        axes('Position',[.24+(group-5)*.208 .85-(n-1)*.29 .05 .05]); box on
        a= pie([nansum(nansum(HistData.All.(Drug_Group{group}).(Session_type{sess})(:,40:end)))/nansum(nansum(HistData.All.(Drug_Group{group}).(Session_type{sess}))) 1-nansum(nansum(HistData.All.(Drug_Group{group}).(Session_type{sess})(:,40:end)))/nansum(nansum(HistData.All.(Drug_Group{group}).(Session_type{sess})))]); set(a(1), 'FaceColor', [0 0 0]); set(a(3), 'FaceColor', [1 1 1]);
        
        n=n+1;
    end
end

a=suptitle('Breathing frequency during freezing, spent time analysis'); a.FontSize=20;


figure; n=1;
for sess=[4 5 3]
    for side=1
        subplot(3,1,n)
        Conf_Inter=nanstd(HistData.All.SalineSB.(Session_type{sess}))/sqrt(size(HistData.All.SalineSB.(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.All.SalineSB.(Session_type{sess})),Conf_Inter,'b',1); hold on;
        Conf_Inter=nanstd(HistData.All.SalineBM_Short.(Session_type{sess}))/sqrt(size(HistData.All.SalineBM_Short.(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.All.SalineBM_Short.(Session_type{sess})),Conf_Inter,'m',1); hold on;
        Conf_Inter=nanstd(HistData.All.SalineBM_Long.(Session_type{sess}))/sqrt(size(HistData.All.SalineBM_Long.(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.All.SalineBM_Long.(Session_type{sess})),Conf_Inter,'k',1); hold on;
        makepretty; grid on
        if sess==3; xlabel('Frequency (Hz)'); end
        if side==1; ylabel(Session_type{sess}); end
        a=ylim; ylim([0 a(2)]); xlim([0 8])
        if and(n==1,side==1); f=get(gca,'Children'); legend([f(9),f(5),f(1)],'SB','BM short','BM long'); title('Shock'); end
        
    end
    n=n+1;
end
a=suptitle('Saline groups comparison'); a.FontSize=20;


figure; n=1;
for sess=[4 5 3]
    for side=1
        subplot(3,1,n)
         Conf_Inter=nanstd(HistData.(Side{side}).SalineBM_Short.(Session_type{sess}))/sqrt(size(HistData.(Side{side}).SalineBM_Short.(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.(Side{side}).SalineBM_Short.(Session_type{sess})),Conf_Inter,'k',1); hold on;
        Conf_Inter=nanstd(HistData.(Side{side}).Diazepam_Short.(Session_type{sess}))/sqrt(size(HistData.(Side{side}).Diazepam_Short.(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.(Side{side}).Diazepam_Short.(Session_type{sess})),Conf_Inter,'m',1); hold on;
        makepretty; grid on
        if sess==3; xlabel('Frequency (Hz)'); end
        if side==1; ylabel(Session_type{sess}); end
        a=ylim; ylim([0 a(2)]); xlim([0 8])
        if and(n==1,side==1); f=get(gca,'Children'); legend([f(5),f(1)],'Saline BM short','Diazepam short'); title('Shock'); end
        
    end
    n=n+1;
end
a=suptitle('Short groups comparison'); a.FontSize=20;


figure; n=1;
for sess=[4 5 3]
    for side=1
        subplot(3,1,n)
         Conf_Inter=nanstd(HistData.(Side{side}).SalineBM_Long.(Session_type{sess}))/sqrt(size(HistData.(Side{side}).SalineBM_Long.(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.(Side{side}).SalineBM_Long.(Session_type{sess})),Conf_Inter,'k',1); hold on;
        Conf_Inter=nanstd(HistData.(Side{side}).Diazepam_Long.(Session_type{sess}))/sqrt(size(HistData.(Side{side}).Diazepam_Long.(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.(Side{side}).Diazepam_Long.(Session_type{sess})),Conf_Inter,'m',1); hold on;
        makepretty; grid on
        if sess==3; xlabel('Frequency (Hz)'); end
        if side==1; ylabel(Session_type{sess}); end
        a=ylim; ylim([0 a(2)]); xlim([0 8])
        if and(n==1,side==1); f=get(gca,'Children'); legend([f(5),f(1)],'Saline BM long','Diazepam long'); title('Shock'); end
        
    end
    n=n+1;
end
a=suptitle('Long groups comparison'); a.FontSize=20;










