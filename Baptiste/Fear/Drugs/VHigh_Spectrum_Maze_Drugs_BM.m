
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long','Saline1','Saline2','DZP1','DZP2','RipInhib','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired'};
GetEmbReactMiceFolderList_BM
Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};

for group=[5 6 13 16]
    clear Mouse
    Drugs_Groups_UMaze_BM
    for sess=1:length(Session_type) % generate all data required for analyses
        [OutPutData.(Drug_Group{group}).(Session_type{sess}) , Epoch1.(Drug_Group{group}).(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'h_vhigh');
    end
end

load('H_VHigh_Spectrum.mat')

for sess=1:length(Session_type)
    n=1;
    for group=[5 6 16 13]
        Drugs_Groups_UMaze_BM
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            VHigh_Spec_HPC.Shock.(Session_type{sess}){n}(mouse,:) = Spectro{3}.*squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).h_vhigh.mean(mouse,5,:))';
            VHigh_Spec_HPC.Safe.(Session_type{sess}){n}(mouse,:) = Spectro{3}.*squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).h_vhigh.mean(mouse,6,:))';
            
            VHigh_Spec_HPC.Shock.(Session_type{sess}){n}(VHigh_Spec_HPC.Shock.(Session_type{sess}){n}==0)=NaN;
            VHigh_Spec_HPC.Safe.(Session_type{sess}){n}(VHigh_Spec_HPC.Safe.(Session_type{sess}){n}==0)=NaN;
            
        end
        n=n+1;
    end
end


figure
for group=1:4
    subplot(3,4,group)
    Conf_Inter=nanstd(VHigh_Spec_HPC.Shock.CondPre{group})/sqrt(size(VHigh_Spec_HPC.Shock.CondPre{group},1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(VHigh_Spec_HPC.Shock.CondPre{group});
    shadedErrorBar(Spectro{3},Mean_All_Sp,Conf_Inter,'-r',1); hold on;
    Conf_Inter=nanstd(VHigh_Spec_HPC.Safe.CondPre{group})/sqrt(size(VHigh_Spec_HPC.Safe.CondPre{group},1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(VHigh_Spec_HPC.Safe.CondPre{group});
    shadedErrorBar(Spectro{3},Mean_All_Sp,Conf_Inter,'-b',1); hold on;
    %     set(gca , 'Yscale', 'log'); makepretty; xlim([120 250]); ylim([1e3 1e5])
    vline(175,'--r')
    title(Drug_Group{group});
    if group==1; ylabel('CondPre'); f=get(gca,'Children'); legend([f(5),f(1)],'Shock','Safe'); end
    
    subplot(3,4,group+4)
    Conf_Inter=nanstd(VHigh_Spec_HPC.Shock.CondPost{group})/sqrt(size(VHigh_Spec_HPC.Shock.CondPost{group},1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(VHigh_Spec_HPC.Shock.CondPost{group});
    shadedErrorBar(Spectro{3},Mean_All_Sp,Conf_Inter,'-r',1); hold on;
    Conf_Inter=nanstd(VHigh_Spec_HPC.Safe.CondPost{group})/sqrt(size(VHigh_Spec_HPC.Safe.CondPost{group},1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(VHigh_Spec_HPC.Safe.CondPost{group});
    shadedErrorBar(Spectro{3},Mean_All_Sp,Conf_Inter,'-b',1); hold on;
    %     set(gca , 'Yscale', 'log'); makepretty; xlim([120 250]); ylim([1e3 1e5])
    vline(175,'--r')
    if group==1; ylabel('CondPost'); end
    
    subplot(3,4,group+8)
    Conf_Inter=nanstd(VHigh_Spec_HPC.Shock.Ext{group})/sqrt(size(VHigh_Spec_HPC.Shock.Ext{group},1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(VHigh_Spec_HPC.Shock.Ext{group});
    shadedErrorBar(Spectro{3},Mean_All_Sp,Conf_Inter,'-r',1); hold on;
    Conf_Inter=nanstd(VHigh_Spec_HPC.Safe.Ext{group})/sqrt(size(VHigh_Spec_HPC.Safe.Ext{group},1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(VHigh_Spec_HPC.Safe.Ext{group});
    shadedErrorBar(Spectro{3},Mean_All_Sp,Conf_Inter,'-b',1); hold on;
    %     set(gca , 'Yscale', 'log'); makepretty; xlim([120 250]); ylim([1e3 1e5])
    vline(175,'--r')
    if group==1; ylabel('Ext'); end
end
a=suptitle('VHigh Spectrum during freezing, drugs, UMaze, on freezing epoch'); a.FontSize=20;

figure
for group=1:length(Drug_Group)
    subplot(3,8,group)
    Conf_Inter=nanstd(VHigh_Spec_HPC.Shock.CondPre{group})/sqrt(size(VHigh_Spec_HPC.Shock.CondPre{group},1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(VHigh_Spec_HPC.Shock.CondPre{group});
    shadedErrorBar(Spectro{3},Mean_All_Sp,Conf_Inter,'-r',1); hold on;
    Conf_Inter=nanstd(VHigh_Spec_HPC.Safe.CondPre{group})/sqrt(size(VHigh_Spec_HPC.Safe.CondPre{group},1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(VHigh_Spec_HPC.Safe.CondPre{group});
    shadedErrorBar(Spectro{3},Mean_All_Sp,Conf_Inter,'-b',1); hold on;
    set(gca , 'Yscale', 'log'); makepretty; xlim([120 250]); ylim([8e3 6e5])
    vline(175,'--r')
    title(Drug_Group{group});
    if group==1; ylabel('CondPre'); f=get(gca,'Children'); legend([f(5),f(1)],'Shock','Safe'); end
    
    subplot(3,8,group+8)
    Conf_Inter=nanstd(VHigh_Spec_HPC.Shock.CondPost{group})/sqrt(size(VHigh_Spec_HPC.Shock.CondPost{group},1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(VHigh_Spec_HPC.Shock.CondPost{group});
    shadedErrorBar(Spectro{3},Mean_All_Sp,Conf_Inter,'-r',1); hold on;
    Conf_Inter=nanstd(VHigh_Spec_HPC.Safe.CondPost{group})/sqrt(size(VHigh_Spec_HPC.Safe.CondPost{group},1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(VHigh_Spec_HPC.Safe.CondPost{group});
    shadedErrorBar(Spectro{3},Mean_All_Sp,Conf_Inter,'-b',1); hold on;
    set(gca , 'Yscale', 'log'); makepretty; xlim([120 250]); ylim([8e3 6e5])
    vline(175,'--r')
    if group==1; ylabel('CondPost'); end
    
    subplot(3,8,group+16)
    Conf_Inter=nanstd(VHigh_Spec_HPC.Shock.Ext{group})/sqrt(size(VHigh_Spec_HPC.Shock.Ext{group},1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(VHigh_Spec_HPC.Shock.Ext{group});
    shadedErrorBar(Spectro{3},Mean_All_Sp,Conf_Inter,'-r',1); hold on;
    Conf_Inter=nanstd(VHigh_Spec_HPC.Safe.Ext{group})/sqrt(size(VHigh_Spec_HPC.Safe.Ext{group},1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(VHigh_Spec_HPC.Safe.Ext{group});
    shadedErrorBar(Spectro{3},Mean_All_Sp,Conf_Inter,'-b',1); hold on;
    set(gca , 'Yscale', 'log'); makepretty; xlim([120 250]); ylim([8e3 6e5])
    vline(175,'--r')
    if group==1; ylabel('Ext'); end
end
a=suptitle('VHigh Spectrum during freezing, drugs, UMaze, on freezing and ripples epoch'); a.FontSize=20;

Conf_Inter=nanstd(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe)/sqrt(size(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe);
h=shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-b',1); hold on;
makepretty;
xlabel('Frequency (Hz)'); ylabel('Power (A.U.)'); xlim([0 10]);
[c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock));
vline(Spectro{3}(d),'--r')
[c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe(:,26:end)));
vline(Spectro{3}(d+25),'--b')
f=get(gca,'Children');
legend([f(5),f(1)],'Shock side freezing','Safe side freezing')
title('mean OB spectrum for all mice')


%% frequencies shock safe saline
subplot(121)
Conf_Inter=nanstd(VHigh_Spec_HPC.Shock.CondPre{group})/sqrt(size(VHigh_Spec_HPC.Shock.CondPre{group},1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(VHigh_Spec_HPC.Shock.CondPre{group});
shadedErrorBar(Spectro{3},Mean_All_Sp,Conf_Inter,'-r',1); hold on;

Conf_Inter=nanstd(VHigh_Spec_HPC.Shock.CondPost{group})/sqrt(size(VHigh_Spec_HPC.Shock.CondPost{group},1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(VHigh_Spec_HPC.Shock.CondPost{group});
shadedErrorBar(Spectro{3},Mean_All_Sp,Conf_Inter,'-m',1); hold on;

Conf_Inter=nanstd(VHigh_Spec_HPC.Shock.Ext{group})/sqrt(size(VHigh_Spec_HPC.Shock.Ext{group},1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(VHigh_Spec_HPC.Shock.Ext{group});
shadedErrorBar(Spectro{3},Mean_All_Sp,Conf_Inter,'-k',1); hold on;

set(gca , 'Yscale', 'log'); makepretty; xlim([120 250]); ylim([8e3 6e5])

subplot(122)
Conf_Inter=nanstd(VHigh_Spec_HPC.Safe.CondPre{group})/sqrt(size(VHigh_Spec_HPC.Safe.CondPre{group},1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(VHigh_Spec_HPC.Safe.CondPre{group});
shadedErrorBar(Spectro{3},Mean_All_Sp,Conf_Inter,'-b',1); hold on;

Conf_Inter=nanstd(VHigh_Spec_HPC.Safe.CondPost{group})/sqrt(size(VHigh_Spec_HPC.Safe.CondPost{group},1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(VHigh_Spec_HPC.Safe.CondPost{group});
shadedErrorBar(Spectro{3},Mean_All_Sp,Conf_Inter,'-c',1); hold on;

Conf_Inter=nanstd(VHigh_Spec_HPC.Safe.Ext{group})/sqrt(size(VHigh_Spec_HPC.Safe.Ext{group},1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(VHigh_Spec_HPC.Safe.Ext{group});
shadedErrorBar(Spectro{3},Mean_All_Sp,Conf_Inter,'-k',1); hold on;

set(gca , 'Yscale', 'log'); makepretty; xlim([120 250]); ylim([8e3 6e5])

Cols = {[1 0.5 0.5],[0.5 0.5 1]};
X = [1,2];
Legends = {'Shock','Safe'};
NoLegends = {'',''};

figure; n=1; %VHigh_Spec_HPC_Max.Shock.(Session_type{sess}){2}(4)=NaN;
for sess=[2]
    for group=1:length(Drug_Group)
        subplot(1,8,(n-1)*8+group)
        MakeSpreadAndBoxPlot2_SB([VHigh_Spec_HPC_Max.Shock.(Session_type{sess}){group} VHigh_Spec_HPC_Max.Safe.(Session_type{sess}){group}],Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
        ylim([170 220]);
    end
    n=n+1;
end

a=suptitle('Ripples frequencies during freezing, saline-like, conditionning sessions'); a.FontSize=20;

figure; sess=5;
MakeSpreadAndBoxPlot2_SB({[VHigh_Spec_HPC_Max.Shock.(Session_type{sess}){1} ; VHigh_Spec_HPC_Max.Shock.(Session_type{sess}){4}] , [VHigh_Spec_HPC_Max.Safe.(Session_type{sess}){1} ; VHigh_Spec_HPC_Max.Safe.(Session_type{sess}){4}]},Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);



%%
for mouse=61:length(Mouse_names)
    figure
    subplot(121)
    plot(Spectro{3} , Spectro{3}.*squeeze(OutPutData.Fear.h_vhigh.mean(mouse,1,:))')
    set(gca , 'Yscale', 'log')
    hold on
    plot(Spectro{3} , Spectro{3}.*squeeze(OutPutData.Fear.h_vhigh.mean(mouse,2,:))')
    plot(Spectro{3} , Spectro{3}.*squeeze(OutPutData.Fear.h_vhigh.mean(mouse,3,:))')
    plot(Spectro{3} , Spectro{3}.*squeeze(OutPutData.Fear.h_vhigh.mean(mouse,4,:))')
    legend(NameEpoch(1:4))
    makepretty
    
    subplot(122)
    plot(Spectro{3} , Spectro{3}.*squeeze(OutPutData.Fear.h_vhigh.mean(mouse,5,:))')
    set(gca , 'Yscale', 'log')
    hold on
    plot(Spectro{3} , Spectro{3}.*squeeze(OutPutData.Fear.h_vhigh.mean(mouse,6,:))')
    plot(Spectro{3} , Spectro{3}.*squeeze(OutPutData.Fear.h_vhigh.mean(mouse,7,:))')
    plot(Spectro{3} , Spectro{3}.*squeeze(OutPutData.Fear.h_vhigh.mean(mouse,8,:))')
    legend(NameEpoch(5:8))
    makepretty
    
    a=suptitle(num2str(Mouse(mouse))); a.FontSize=20;
end

