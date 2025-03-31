Mice=[873, 874, 891];
for i=1:length(Mice)
    mouse_num=Mice(i);
    path=strcat('/media/mobschapeau/09E7077B1FE07CCB/DREADD/', num2str(mouse_num), '/cond/day2_sleep_ext_sleep');
    cd(path)
    load('ExpeInfo.mat');
    load('behavResources.mat');
    load('Epoch.mat')
    
    channel_pfc=ExpeInfo.ChannelToAnalyse.PFCx_deep;
    channel_bulb=ExpeInfo.ChannelToAnalyse.Bulb_deep;
    channel_hp=ExpeInfo.ChannelToAnalyse.dHPC_sup;

    %LowCohgramSB(strcat('M',num2str(mouse_num),'_'),channel_pfc,'PFCx_deep',channel_bulb,'Bulb_deep')
    %LowCohgramSB(strcat('M',num2str(mouse_num),'_'),channel_pfc,'PFCx_deep',channel_hp,'dHPC_sup')

    %% coherence bulb-pfc
    
    load(strcat('M',num2str(mouse_num),'_PFCx_deep_Bulb_deep_Low_Coherence.mat'));
    C=Coherence{1};
    t=Coherence{2};
    f=Coherence{3};
    CohTSD=tsd(t*1e4, C);
% Coherence={C,t,f};
% SingleSpectro.ch1={S1,t,f};
% SingleSpectro.ch2={S2,t,f};
% CrossSpectro={S12,t,f};

%% toute la session

% imagesc(Coherence{2}, Coherence{3}, Coherence{1}');
% axis xy
% hold on
% vline(TTLInfo.InjectTTL, 'r', 'inj');
% vline(TTLInfo.ExtTTL, 'r', 'debut ext');
% vline(TTLInfo.PostExtTTL, 'r', 'fin ext');
couleurs='kmcrgby'
% eveil preinj
    subplot(2,3,i);
%     plot(f,mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Pre_Inj)))-mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Pre_Inj))), 'color', couleurs(1));
%     hold on
% "sommeil" preinj
    plot(f,mean(Data(Restrict(CohTSD,Epoch.FreezeAcc_Pre_Inj)))-mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Pre_Inj))), 'color', couleurs(2));
    hold on
% non freeze ext
    plot(f,mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Ext)))-mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Pre_Inj))), 'color',couleurs(3));
    hold on
%freeze ext
    plot(f,mean(Data(Restrict(CohTSD,Epoch.FreezeAcc_Ext)))-mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Pre_Inj))), 'color', couleurs(4));
    hold on
% eveil post ext
    plot(f,mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Post_Ext)))-mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Pre_Inj))), 'color', couleurs(5));
    hold on
% "sommeil" ppost ext
    plot(f,mean(Data(Restrict(CohTSD,Epoch.FreezeAcc_Post_Ext)))-mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Pre_Inj))), 'color', couleurs(6));
    hold on
    
    title(strcat('M',num2str(mouse_num),', coh bulb pfc'))
    legend('sleep bef-B','Act ext-B', 'freeze-B', 'wake aft-B', 'sleep aft-B')
    text(1,1,'B=wake before')

%% coherence hp-pfc
    
    load(strcat('M',num2str(mouse_num),'_PFCx_deep_dHPC_sup_Low_Coherence.mat'));
    C=Coherence{1};
    t=Coherence{2};
    f=Coherence{3};
    CohTSD=tsd(t*1e4, C);
% Coherence={C,t,f};
% SingleSpectro.ch1={S1,t,f};
% SingleSpectro.ch2={S2,t,f};
% CrossSpectro={S12,t,f};

%% toute la session

% imagesc(Coherence{2}, Coherence{3}, Coherence{1}');
% axis xy
% hold on
% vline(TTLInfo.InjectTTL, 'r', 'inj');
% vline(TTLInfo.ExtTTL, 'r', 'debut ext');
% vline(TTLInfo.PostExtTTL, 'r', 'fin ext');

% eveil preinj
    subplot(2,3,3+i);
%     plot(f,mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Pre_Inj)))-mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Pre_Inj))), 'color', couleurs(1));
%     hold on
% "sommeil" preinj
    plot(f,mean(Data(Restrict(CohTSD,Epoch.FreezeAcc_Pre_Inj)))-mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Pre_Inj))), 'color', couleurs(2));
    hold on
% non freeze ext
    plot(f,mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Ext)))-mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Pre_Inj))), 'color', couleurs(3));
    hold on
%freeze ext
    plot(f,mean(Data(Restrict(CohTSD,Epoch.FreezeAcc_Ext)))-mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Pre_Inj))), 'color', couleurs(4));
    hold on
% eveil post ext
    plot(f,mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Post_Ext)))-mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Pre_Inj))), 'color', couleurs(5));
    hold on
% "sommeil" ppost ext
    plot(f,mean(Data(Restrict(CohTSD,Epoch.FreezeAcc_Post_Ext)))-mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Pre_Inj))), 'color', couleurs(6));
    hold on
    
    title(strcat('M',num2str(mouse_num),', coh hp pfc'))
    legend('sleep bef-B','Act ext-B', 'freeze-B', 'wake aft-B', 'sleep aft-B')
    text(1,1,'B=wake before')
end
