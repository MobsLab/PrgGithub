
clear all

GetEmbReactMiceFolderList_BM


%%
Session_type={'CondPre','CondPost','Ext'};

for group=1:8
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:length(Session_type)
            
            Sessions_List_ForLoop_BM
            try
                TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'respi_freq_bm'))));
                FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'all_freeze_epoch');
                ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse})-FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse});
                ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'all_zoneepoch');
                Respi.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'respi_freq_bm');
                
                ShockZone.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
                SafeZone.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2} , ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
                
                Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockZone.(Session_type{sess}).(Mouse_names{mouse}));
                Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeZone.(Session_type{sess}).(Mouse_names{mouse}));
                Active_Shock.(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockZone.(Session_type{sess}).(Mouse_names{mouse}));
                Active_Safe.(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeZone.(Session_type{sess}).(Mouse_names{mouse}));
                
                Respi_Fz.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                Respi_Fz_Shock.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Session_type{sess}).(Mouse_names{mouse}) , Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}));
                Respi_Fz_Safe.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Session_type{sess}).(Mouse_names{mouse}) , Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}));
                
                UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'blockedepoch');
            end
        end
        disp(Mouse_names{mouse})
    end
end


for group=1:8
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            try
                Respi_Fz_Evol.(Session_type{sess}){group}(mouse,:) = interp1(linspace(0,1,length(Data(Respi_Fz.(Session_type{sess}).(Mouse_names{mouse})))) , Data(Respi_Fz.(Session_type{sess}).(Mouse_names{mouse})) , linspace(0,1,100));
                if isempty(Data(Respi_Fz_Shock.(Session_type{sess}).(Mouse_names{mouse})))
                    Respi_Fz_Evol_Shock.(Session_type{sess}){group}(mouse,:) = NaN(1,100);
                else
                    Respi_Fz_Evol_Shock.(Session_type{sess}){group}(mouse,:) = interp1(linspace(0,1,length(Data(Respi_Fz_Shock.(Session_type{sess}).(Mouse_names{mouse})))) , Data(Respi_Fz_Shock.(Session_type{sess}).(Mouse_names{mouse})) , linspace(0,1,100));
                end
                if isempty(Data(Respi_Fz_Safe.(Session_type{sess}).(Mouse_names{mouse})))
                    Respi_Fz_Evol_Safe.(Session_type{sess}){group}(mouse,:) = NaN(1,100);
                else
                    Respi_Fz_Evol_Safe.(Session_type{sess}){group}(mouse,:) = interp1(linspace(0,1,length(Data(Respi_Fz_Safe.(Session_type{sess}).(Mouse_names{mouse})))) , Data(Respi_Fz_Safe.(Session_type{sess}).(Mouse_names{mouse})) , linspace(0,1,100));
                end
            end
        end
        Respi_Fz_Evol_Shock.(Session_type{sess}){group}(Respi_Fz_Evol_Shock.(Session_type{sess}){group}==0)=NaN;
        Respi_Fz_Evol_Safe.(Session_type{sess}){group}(Respi_Fz_Evol_Safe.(Session_type{sess}){group}==0)=NaN;
        Respi_Fz_Evol_Diff.(Session_type{sess}){group} = Respi_Fz_Evol_Shock.(Session_type{sess}){group}-Respi_Fz_Evol_Safe.(Session_type{sess}){group};
    end
end


% correction for 1096
for sess=1:3
    Respi_Fz_Evol_Shock.(Session_type{sess}){1}(7,:) = NaN;
    Respi_Fz_Evol_Safe.(Session_type{sess}){1}(7,:) = NaN;
    Respi_Fz_Evol_Diff.(Session_type{sess}){1}(7,:) = NaN;
end

%% figures
% evol
Cols1 = {'-b','-r','-m','-g','-c','-c','-m','-g'};

figure
for sess=1:3
    for group=1:4
        subplot(211)
        Data_to_use = Respi_Fz_Evol_Shock.(Session_type{sess}){group};
        Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
        clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
        shadedErrorBar([1+100*(sess-1):100+100*(sess-1)] , runmean_BM(Mean_All_Sp,25) , runmean_BM(Conf_Inter,25) ,Cols1{group},1); hold on;
        makepretty
        ylim([1.5 5.8])
        xticklabels({''})
        if sess==1; ylabel('Frequency (Hz)'); u=text(-20,3,'Shock Fz'); set(u,'Rotation',90,'FontSize',15,'FontWeight','bold'); end
        
        subplot(212)
        Data_to_use = Respi_Fz_Evol_Safe.(Session_type{sess}){group};
        Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
        clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
        shadedErrorBar([1+100*(sess-1):100+100*(sess-1)] , runmean_BM(Mean_All_Sp,25) , runmean_BM(Conf_Inter,25) ,Cols1{group},1); hold on;
        
        makepretty
        ylim([1.5 5.8])
        xlabel('freezing time (a.u.)')
        if sess==1; ylabel('Frequency (Hz)'); u=text(-20,3,'Safe Fz'); set(u,'Rotation',90,'FontSize',15,'FontWeight','bold'); end
    end
end
subplot(211), vline([100,200],'--k'), hline(4,'--r'), hline(2.5,'--b')
u=text(40,6,'CondPre'); set(u,'FontSize',15,'FontWeight','bold'); 
u=text(140,6,'CondPost'); set(u,'FontSize',15,'FontWeight','bold');
u=text(240,6,'Ext'); set(u,'FontSize',15,'FontWeight','bold');
f=get(gca,'Children'); legend([f(29),f(24)],'Saline','Chronic Flx');
subplot(212), vline([100,200],'--k'), hline(4,'--r'), hline(2.5,'--b')

a=suptitle('Respi frequency evolution, drugs, UMaze'); a.FontSize=20;


figure
for sess=1:3
    for group=5:6
        subplot(211)
        Data_to_use = Respi_Fz_Evol_Shock.(Session_type{sess}){group};
        Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
        clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
        h=shadedErrorBar([1+100*(sess-1):100+100*(sess-1)] , runmean_BM(Mean_All_Sp,25) , runmean_BM(Conf_Inter,25) ,Cols1{group},1); hold on;
        if group==6; h.mainLine.Color=[0.85, 0.325, 0.1]; h.patch.FaceColor=[0.85, 0.325, 0.1]; h.edge(1).Color=[0.85, 0.325, 0.1]; h.edge(2).Color=[0.85, 0.325, 0.1]; end
        makepretty
        ylim([1.5 5.8])
        if sess==1; ylabel('Frequency (Hz)'); u=text(-20,3,'Shock Fz'); set(u,'Rotation',90,'FontSize',15,'FontWeight','bold'); end
        
        subplot(212)
        Data_to_use = Respi_Fz_Evol_Safe.(Session_type{sess}){group};
        Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
        clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
        h=shadedErrorBar([1+100*(sess-1):100+100*(sess-1)] , runmean_BM(Mean_All_Sp,25) , runmean_BM(Conf_Inter,25) ,Cols1{group},1); hold on;
        if group==6; h.mainLine.Color=[0.85, 0.325, 0.1]; h.patch.FaceColor=[0.85, 0.325, 0.1]; h.edge(1).Color=[0.85, 0.325, 0.1]; h.edge(2).Color=[0.85, 0.325, 0.1]; end
        if sess==1; ylabel('Frequency (Hz)'); u=text(-20,3,'Safe Fz'); set(u,'Rotation',90,'FontSize',15,'FontWeight','bold'); end
        
        makepretty
        ylim([1.5 5.8])
        xlabel('freezing time (a.u.)')
    end
end
subplot(211), vline([100,200],'--k'), hline(4,'--r'), hline(2.5,'--b')
u=text(40,6,'CondPre'); set(u,'FontSize',15,'FontWeight','bold'); 
u=text(140,6,'CondPost'); set(u,'FontSize',15,'FontWeight','bold');
u=text(240,6,'Ext'); set(u,'FontSize',15,'FontWeight','bold');
f=get(gca,'Children'); legend([f(29),f(24)],'Saline','Diazepam');
subplot(212), vline([100,200],'--k'), hline(4,'--r'), hline(2.5,'--b')

a=suptitle('Respi frequency evolution, drugs, UMaze'); a.FontSize=20;


figure
for sess=1:3
    for group=[1 5]
        subplot(211)
        Data_to_use = Respi_Fz_Evol_Shock.(Session_type{sess}){group};
        Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
        clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
        h=shadedErrorBar([1+100*(sess-1):100+100*(sess-1)] , runmean_BM(Mean_All_Sp,25) , runmean_BM(Conf_Inter,25) ,Cols1{group},1); hold on;
        if group==6; h.mainLine.Color=[0.85, 0.325, 0.1]; h.patch.FaceColor=[0.85, 0.325, 0.1]; h.edge(1).Color=[0.85, 0.325, 0.1]; h.edge(2).Color=[0.85, 0.325, 0.1]; end
        makepretty
        ylim([1.5 5.8])
        if sess==1; ylabel('Frequency (Hz)'); u=text(-20,3,'Shock Fz'); set(u,'Rotation',90,'FontSize',15,'FontWeight','bold'); end
        
        subplot(212)
        Data_to_use = Respi_Fz_Evol_Safe.(Session_type{sess}){group};
        Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
        clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
        h=shadedErrorBar([1+100*(sess-1):100+100*(sess-1)] , runmean_BM(Mean_All_Sp,25) , runmean_BM(Conf_Inter,25) ,Cols1{group},1); hold on;
        if group==6; h.mainLine.Color=[0.85, 0.325, 0.1]; h.patch.FaceColor=[0.85, 0.325, 0.1]; h.edge(1).Color=[0.85, 0.325, 0.1]; h.edge(2).Color=[0.85, 0.325, 0.1]; end
        if sess==1; ylabel('Frequency (Hz)'); u=text(-20,3,'Safe Fz'); set(u,'Rotation',90,'FontSize',15,'FontWeight','bold'); end
        
        makepretty
        ylim([1.5 5.8])
        xlabel('freezing time (a.u.)')
    end
end
subplot(211), vline([100,200],'--k'), hline(4,'--r'), hline(2.5,'--b')
u=text(40,6,'CondPre'); set(u,'FontSize',15,'FontWeight','bold'); 
u=text(140,6,'CondPost'); set(u,'FontSize',15,'FontWeight','bold');
u=text(240,6,'Ext'); set(u,'FontSize',15,'FontWeight','bold');
f=get(gca,'Children'); legend([f(27),f(23)],'Saline long','Saline short');
subplot(212), vline([100,200],'--k'), hline(4,'--r'), hline(2.5,'--b')

a=suptitle('Respi frequency evolution, drugs, UMaze'); a.FontSize=20;




% diff
% figure
% for group=1:4
%     for sess=1:3
%         Data_to_use = Respi_Fz_Evol_Diff.(Session_type{sess}){group};
%         Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
%         clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
%         shadedErrorBar([1:100] , runmean_BM(Mean_All_Sp,25) , runmean_BM(Conf_Inter,25) ,Cols1{group}',1); hold on;
%         ylim([-.5 3.5])
%         makepretty
%     end
% end

figure
for group=1:4
    for sess=1:3
        Mean_All_Sp = nanmean(Respi_Fz_Evol_Shock.(Session_type{sess}){group})-nanmean(Respi_Fz_Evol_Safe.(Session_type{sess}){group});
        Conf_Inter=nanmean([nanstd(Respi_Fz_Evol_Shock.(Session_type{sess}){group})/sqrt(size(Respi_Fz_Evol_Shock.(Session_type{sess}){group},1)) ; nanstd(Respi_Fz_Evol_Safe.(Session_type{sess}){group})/sqrt(size(Respi_Fz_Evol_Safe.(Session_type{sess}){group},1))]);
        shadedErrorBar([1+100*(sess-1):100+100*(sess-1)] , runmean_BM(Mean_All_Sp,25) , runmean_BM(Conf_Inter,25) ,Cols1{group}',1); hold on;
        ylim([-1 2.5])
        makepretty
    end
end
u=text(40,2.5,'CondPre'); set(u,'FontSize',15,'FontWeight','bold'); 
u=text(140,2.5,'CondPost'); set(u,'FontSize',15,'FontWeight','bold');
u=text(240,2.5,'Ext'); set(u,'FontSize',15,'FontWeight','bold');
vline([100,200],'--k'), hline(0,'--k')
f=get(gca,'Children'); legend([f(27),f(15)],'Saline','Chronic flx');

a=suptitle('Respi frequency evolution, drugs, UMaze'); a.FontSize=20;


figure
for group=5:6
    for sess=1:3
        Mean_All_Sp = nanmean(Respi_Fz_Evol_Shock.(Session_type{sess}){group})-nanmean(Respi_Fz_Evol_Safe.(Session_type{sess}){group});
        Conf_Inter=nanmean([nanstd(Respi_Fz_Evol_Shock.(Session_type{sess}){group})/sqrt(size(Respi_Fz_Evol_Shock.(Session_type{sess}){group},1)) ; nanstd(Respi_Fz_Evol_Safe.(Session_type{sess}){group})/sqrt(size(Respi_Fz_Evol_Safe.(Session_type{sess}){group},1))]);
        h=shadedErrorBar([1+100*(sess-1):100+100*(sess-1)] , runmean_BM(Mean_All_Sp,25) , runmean_BM(Conf_Inter,25) ,Cols1{group}',1); hold on;
        if group==6; h.mainLine.Color=[0.85, 0.325, 0.1]; h.patch.FaceColor=[0.85, 0.325, 0.1]; h.edge(1).Color=[0.85, 0.325, 0.1]; h.edge(2).Color=[0.85, 0.325, 0.1]; end
        ylim([-1 2.5])
        makepretty
    end
end
u=text(40,2.5,'CondPre'); set(u,'FontSize',15,'FontWeight','bold');
u=text(140,2.5,'CondPost'); set(u,'FontSize',15,'FontWeight','bold');
u=text(240,2.5,'Ext'); set(u,'FontSize',15,'FontWeight','bold');
vline([100,200],'--k'), hline(0,'--k')
f=get(gca,'Children'); legend([f(27),f(15)],'Saline','Chronic flx');

a=suptitle('Respi frequency evolution, drugs, UMaze'); a.FontSize=20;



figure
for group=[1 5]
    for sess=1:3
        Mean_All_Sp = nanmean(Respi_Fz_Evol_Shock.(Session_type{sess}){group})-nanmean(Respi_Fz_Evol_Safe.(Session_type{sess}){group});
        Conf_Inter=nanmean([nanstd(Respi_Fz_Evol_Shock.(Session_type{sess}){group})/sqrt(size(Respi_Fz_Evol_Shock.(Session_type{sess}){group},1)) ; nanstd(Respi_Fz_Evol_Safe.(Session_type{sess}){group})/sqrt(size(Respi_Fz_Evol_Safe.(Session_type{sess}){group},1))]);
        h=shadedErrorBar([1+100*(sess-1):100+100*(sess-1)] , runmean_BM(Mean_All_Sp,25) , runmean_BM(Conf_Inter,25) ,Cols1{group}',1); hold on;
        ylim([-1 2.5])
        makepretty
    end
end
u=text(40,2.5,'CondPre'); set(u,'FontSize',15,'FontWeight','bold');
u=text(140,2.5,'CondPost'); set(u,'FontSize',15,'FontWeight','bold');
u=text(240,2.5,'Ext'); set(u,'FontSize',15,'FontWeight','bold');
vline([100,200],'--k'), hline(0,'--k')
f=get(gca,'Children'); legend([f(27),f(15)],'Saline','Chronic flx');

a=suptitle('Respi frequency evolution, drugs, UMaze'); a.FontSize=20;






