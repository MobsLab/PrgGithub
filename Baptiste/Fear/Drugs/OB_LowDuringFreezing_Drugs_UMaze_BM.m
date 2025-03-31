
GetEmbReactMiceFolderList_BM

Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};

for sess=[4 5 3]%length(Session_type) % generate all data required for analyses
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'ob_low');
end

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
for group=1:length(Drug_Group)
    
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
    for group=1:length(Drug_Group)
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

Cols = {[1 0.5 0.5],[0.5 0.5 1]};
X = [1,2];
Legends = {'Shock','Safe'};
NoLegends = {'',''};

cd('/media/nas6/ProjetEmbReact/Mouse1161/20210126/ProjectEmbReact_M1161_20210126_Habituation_PreDrug/Hab1')
load('B_Low_Spectrum.mat')

%% corrections
% CondPre
OB_Low_MaxFreq.Shock.Figure.CondPre{1}([2 4])=NaN;
OB_Low_Power.Shock.Figure.CondPre{1}([2 4])=NaN;
OB_Low_MaxFreq.Safe.Figure.CondPre{1}([4])=NaN;
OB_Low_Power.Safe.Figure.CondPre{1}([4])=NaN;

OB_Low_MaxFreq.Shock.Figure.CondPre{2}([1 3 4 5 6])=NaN;
OB_Low_Power.Shock.Figure.CondPre{2}([1 3 4 5 6])=NaN;
OB_Low_MaxFreq.Safe.Figure.CondPre{2}([5])=NaN;
OB_Low_Power.Safe.Figure.CondPre{2}([5])=NaN;

OB_Low_MaxFreq.Shock.Figure.CondPre{3}([1 5])=NaN;
OB_Low_Power.Shock.Figure.CondPre{3}([1 5])=NaN;
OB_Low_MaxFreq.Safe.Figure.CondPre{3}([4])=3.052;
OB_Low_Power.Safe.Figure.CondPre{3}([4])=7.785e5;

OB_Low_MaxFreq.Shock.Figure.CondPre{4}([1 5])=NaN;
OB_Low_Power.Shock.Figure.CondPre{4}([1 5])=NaN;
OB_Low_MaxFreq.Safe.Figure.CondPre{4}([5 6])=[4.044 3.281];
OB_Low_Power.Safe.Figure.CondPre{4}([5 6])=[8.997e5 1.435e5];

OB_Low_MaxFreq.Shock.Figure.CondPre{5}([3 5 7 9])=[NaN NaN NaN 6.256];
OB_Low_Power.Shock.Figure.CondPre{5}([3 5 7 9])=[NaN NaN NaN 3.441e5];
OB_Low_MaxFreq.Safe.Figure.CondPre{5}([10])=NaN;
OB_Low_Power.Safe.Figure.CondPre{5}([10])=NaN;

OB_Low_MaxFreq.Shock.Figure.CondPre{6}([2 8])=[NaN 4.196];
OB_Low_Power.Shock.Figure.CondPre{6}([2 8])=[NaN 2.254e5];

OB_Low_MaxFreq.Shock.Figure.CondPre{7}([4])=NaN;
OB_Low_Power.Shock.Figure.CondPre{7}([4])=NaN;
OB_Low_MaxFreq.Safe.Figure.CondPre{7}([3])=5.417;
OB_Low_Power.Safe.Figure.CondPre{7}([3])=1.544e5;

OB_Low_MaxFreq.Shock.Figure.CondPre{8}([1 4])=[NaN 3.662];
OB_Low_Power.Shock.Figure.CondPre{8}([1 4])=[NaN 2.49e5];
OB_Low_MaxFreq.Safe.Figure.CondPre{8}([1 4])=[NaN 3.662];
OB_Low_Power.Safe.Figure.CondPre{8}([1 4])=[NaN 3.173e5];

% CondPost
OB_Low_MaxFreq.Shock.Figure.CondPost{2}([ 4 5 6])=NaN;
OB_Low_Power.Shock.Figure.CondPost{2}([4 5 6])=NaN;

OB_Low_MaxFreq.Shock.Figure.CondPost{3}([5])=NaN;
OB_Low_Power.Shock.Figure.CondPost{3}([5])=NaN;
OB_Low_MaxFreq.Safe.Figure.CondPost{3}([4])=2.365;
OB_Low_Power.Safe.Figure.CondPost{3}([4])=7.685e5;

OB_Low_MaxFreq.Safe.Figure.CondPost{4}([1])=1.678;
OB_Low_Power.Safe.Figure.CondPost{4}([1])=3.672e5;

OB_Low_MaxFreq.Shock.Figure.CondPost{5}([3])=NaN;
OB_Low_Power.Shock.Figure.CondPost{5}([3])=NaN;
OB_Low_MaxFreq.Safe.Figure.CondPost{5}([4])=NaN;
OB_Low_Power.Safe.Figure.CondPost{5}([4])=NaN;

OB_Low_MaxFreq.Safe.Figure.CondPost{6}([2])=3.815;
OB_Low_Power.Safe.Figure.CondPost{6}([2])=3.067e5;

OB_Low_MaxFreq.Shock.Figure.CondPost{7}([3])=4.959;
OB_Low_Power.Shock.Figure.CondPost{7}([3])=2.313e5;

OB_Low_MaxFreq.Shock.Figure.CondPost{8}([1])=4.73;
OB_Low_Power.Shock.Figure.CondPost{8}([1])=2.388e5;
OB_Low_MaxFreq.Safe.Figure.CondPost{8}([4])=2.899;
OB_Low_Power.Safe.Figure.CondPost{8}([4])=1.322e5;

% Ext
OB_Low_MaxFreq.Shock.Figure.Ext{1}([7])=2.747;
OB_Low_Power.Shock.Figure.Ext{1}([7])=1.092e5;
OB_Low_MaxFreq.Safe.Figure.Ext{1}([4 6 7])=[2.823 NaN 2.67];
OB_Low_Power.Safe.Figure.Ext{1}([4 6 7])=[3.525e5 NaN 1.2e5];

OB_Low_MaxFreq.Safe.Figure.Ext{3}([4])=2.289;
OB_Low_Power.Safe.Figure.Ext{3}([4])=8.181e5;

OB_Low_MaxFreq.Safe.Figure.Ext{4}([6])=NaN;
OB_Low_Power.Safe.Figure.Ext{4}([6])=NaN;

OB_Low_MaxFreq.Shock.Figure.Ext{5}([4])=[NaN];
OB_Low_Power.Shock.Figure.Ext{5}([4])=[NaN];
OB_Low_MaxFreq.Safe.Figure.Ext{5}([4 12])=[2.365 NaN];
OB_Low_Power.Safe.Figure.Ext{5}([4 12])=[2.131e5 NaN];

OB_Low_MaxFreq.Shock.Figure.Ext{6}([4 5])=[NaN 5.112];
OB_Low_Power.Shock.Figure.Ext{6}([4 5])=[NaN 2.868e5];
OB_Low_MaxFreq.Safe.Figure.Ext{6}([4 5 7 8 9])=[NaN NaN 3.357 2.06 NaN];
OB_Low_Power.Safe.Figure.Ext{6}([4 5 7 8 9])=[NaN NaN 3.462e5 4.484e5 NaN];

OB_Low_MaxFreq.Shock.Figure.Ext{7}([5])=4.272;
OB_Low_Power.Shock.Figure.Ext{7}([5])=2.947e5;
OB_Low_MaxFreq.Safe.Figure.Ext{7}([4 5])=NaN;
OB_Low_Power.Safe.Figure.Ext{7}([4 5])=NaN;

OB_Low_MaxFreq.Shock.Figure.Ext{8}([2])=[3.51];
OB_Low_Power.Shock.Figure.Ext{8}([2])=[2.071e5];
OB_Low_MaxFreq.Safe.Figure.Ext{8}([2 4])=[3.357 2.213];
OB_Low_Power.Safe.Figure.Ext{8}([2 4])=[1.884e5 1.175e5];


%% figures
% Max freq
figure; n=1;
for sess=[4 5 3]
    for group=1:length(Drug_Group)
        subplot(3,8,group+8*(n-1))
        if sess==3; MakeSpreadAndBoxPlot2_SB([OB_Low_MaxFreq.Shock.Figure.(Session_type{sess}){group} OB_Low_MaxFreq.Safe.Figure.(Session_type{sess}){group}],Cols,X,Legends,'showpoints',0,'paired',1);
        else; MakeSpreadAndBoxPlot2_SB([OB_Low_MaxFreq.Shock.Figure.(Session_type{sess}){group} OB_Low_MaxFreq.Safe.Figure.(Session_type{sess}){group}],Cols,X,NoLegends,'showpoints',0,'paired',1); end
        if group==1; ylabel('Frequency (Hz)'); u=text(-1.5,2,Session_type{sess}); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
        if sess==4; title(Drug_Group{group}); end
        ylim([.5 7])
    end
    n=n+1;
end
a=suptitle('OB low frequencies during freezing'); a.FontSize=20;

% Power
figure; n=1;
for sess=[4 5 3]
    for group=1:length(Drug_Group)
        subplot(3,8,group+8*(n-1))
        if sess==3; MakeSpreadAndBoxPlot2_SB([log10(OB_Low_Power.Shock.Figure.(Session_type{sess}){group}) log10(OB_Low_Power.Safe.Figure.(Session_type{sess}){group})],Cols,X,Legends,'showpoints',0,'paired',1);
        else; MakeSpreadAndBoxPlot2_SB([log10(OB_Low_Power.Shock.Figure.(Session_type{sess}){group}) log10(OB_Low_Power.Safe.Figure.(Session_type{sess}){group})],Cols,X,NoLegends,'showpoints',0,'paired',1); end
        if group==1; ylabel('Power (a.u.)'); u=text(-1.5,4,Session_type{sess}); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
        if sess==4; title(Drug_Group{group}); end
        ylim([4 6.2])
    end
    n=n+1;
end
a=suptitle('OB low max power during freezing'); a.FontSize=20;

% Mean spectrum
figure; n=1;
for sess=[4 5 3]
    for group=1:length(Drug_Group)
        subplot(3,8,group+8*(n-1))
        
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
        
        if group==1; ylabel('Power (a.u.)'); u=text(-5,.2,Session_type{sess}); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
        if sess==4; title(Drug_Group{group}); end
        xlim([0 10]); ylim([0 1])
    end
    n=n+1;
end
a=suptitle('OB mean spectrums during freezing'); a.FontSize=20;



figure
subplot(131)
MakeSpreadAndBoxPlot2_SB([OB_Low_MaxFreq.Shock.Figure.CondPre{5} OB_Low_MaxFreq.Safe.Figure.CondPre{5} OB_Low_MaxFreq.Shock.Figure.CondPre{6} OB_Low_MaxFreq.Safe.Figure.CondPre{6}],{[1 .5 .5],[.5 .5 1],[.8 .5 .5],[.5 .5 .8]},[1:4],{'Shock Saline','Safe Saline','Shock DZP','Safe DZP'},'showpoints',1,'paired',0);
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


figure
subplot(131)
MakeSpreadAndBoxPlot2_SB([OB_Low_MaxFreq.Shock.Figure.CondPre{1} OB_Low_MaxFreq.Safe.Figure.CondPre{1} OB_Low_MaxFreq.Shock.Figure.CondPre{2} OB_Low_MaxFreq.Safe.Figure.CondPre{2}],{[1 .5 .5],[.5 .5 1],[.8 .5 .5],[.5 .5 .8]},[1:4],{'Shock Saline','Safe Saline','Shock Chronic Flx','Safe Chronic Flx'},'showpoints',1,'paired',0);
ylim([0 8])
title('CondPre'); ylabel('Frequency (Hz)')
subplot(132)
MakeSpreadAndBoxPlot2_SB([OB_Low_MaxFreq.Shock.Figure.CondPost{1} OB_Low_MaxFreq.Safe.Figure.CondPost{1} OB_Low_MaxFreq.Shock.Figure.CondPost{2} OB_Low_MaxFreq.Safe.Figure.CondPost{2}],{[1 .5 .5],[.5 .5 1],[.8 .5 .5],[.5 .5 .8]},[1:4],{'Shock Saline','Safe Saline','Shock Chronic Flx','Safe Chronic Flx'},'showpoints',1,'paired',0);
title('CondPost')
ylim([0 8])
subplot(133)
MakeSpreadAndBoxPlot2_SB([OB_Low_MaxFreq.Shock.Figure.Ext{1} OB_Low_MaxFreq.Safe.Figure.Ext{1} OB_Low_MaxFreq.Shock.Figure.Ext{2} OB_Low_MaxFreq.Safe.Figure.Ext{2}],{[1 .5 .5],[.5 .5 1],[.8 .5 .5],[.5 .5 .8]},[1:4],{'Shock Saline','Safe Saline','Shock Chronic Flx','Safe Chronic Flx'},'showpoints',1,'paired',0);
title('Ext')
ylim([0 8])
a=suptitle('OB low frequencies during freezing'); a.FontSize=20;


%% Active
n=1;
for sess=[4 5 3]
    subplot(3,3,(n-1)*3+1)
    Data_to_use = OB_Low_Spec.Active.Figure.(Session_type{sess}){5};
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
    
    Data_to_use = OB_Low_Spec.Active.Figure.(Session_type{sess}){6};
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter ,'-m',1); hold on;
    
    xlim([0 10]); ylim([0 3e5]); makepretty; if sess==3; xlabel('Frequency (Hz)'); end
    ylabel(Session_type{sess})
    if sess==4; f=get(gca,'Children'); l=legend([f(5),f(1)],'saline','DZP'); end
    if sess==4; title('Active'); end
    
    subplot(3,3,(n-1)*3+2)
    Data_to_use = OB_Low_Spec.Active_Shock.Figure.(Session_type{sess}){5};
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
    
    Data_to_use = OB_Low_Spec.Active_Shock.Figure.(Session_type{sess}){6};
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter ,'-m',1); hold on;
    
    xlim([0 10]); ylim([0 3e5]); makepretty; if sess==3; xlabel('Frequency (Hz)'); end
    if sess==4; title('Active shock'); end
    
    subplot(3,3,(n-1)*3+3)
    Data_to_use = OB_Low_Spec.Active_Safe.Figure.(Session_type{sess}){5};
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
    
    Data_to_use = OB_Low_Spec.Active_Safe.Figure.(Session_type{sess}){6};
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter ,'-m',1); hold on;
    
    xlim([0 10]); ylim([0 3e5]); makepretty; if sess==3; xlabel('Frequency (Hz)'); end
    if sess==4; title('Active safe'); end
    
    n=n+1;
end
a=suptitle('OB Low during Active'); a.FontSize=20;




