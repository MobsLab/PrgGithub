Mice=[873, 874, 891];
col='rmk'
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

% wake after-before
    subplot(2,4,1);
    plot(f,mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Post_Ext)))-mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Pre_Inj))), 'color', col(i));
    hold on
    
% sleep after-before
    subplot(2,4,2);
    plot(f,mean(Data(Restrict(CohTSD,Epoch.FreezeAcc_Post_Ext)))-mean(Data(Restrict(CohTSD,Epoch.FreezeAcc_Pre_Inj))), 'color', col(i));
    hold on
    
% ext freeze-active
    subplot(2,4,3);
    plot(f,mean(Data(Restrict(CohTSD,Epoch.FreezeAcc_Ext)))-mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Ext))), 'color', col(i));
    hold on
    
% freeze - wake before
    subplot(2,4,4);
    plot(f,mean(Data(Restrict(CohTSD,Epoch.FreezeAcc_Ext)))-mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Pre_Inj))), 'color', col(i));
    hold on

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

% wake after-before
    subplot(2,4,5);
    plot(f,mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Post_Ext)))-mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Pre_Inj))), 'color', col(i));
    hold on
    
% sleep after-before
    subplot(2,4,6);
    plot(f,mean(Data(Restrict(CohTSD,Epoch.FreezeAcc_Post_Ext)))-mean(Data(Restrict(CohTSD,Epoch.FreezeAcc_Pre_Inj))), 'color', col(i));
    hold on
    
% ext freeze-active
    subplot(2,4,7);
    plot(f,mean(Data(Restrict(CohTSD,Epoch.FreezeAcc_Ext)))-mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Ext))), 'color', col(i));
    hold on
    
% freeze - wake before
    subplot(2,4,8);
    plot(f,mean(Data(Restrict(CohTSD,Epoch.FreezeAcc_Ext)))-mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Pre_Inj))), 'color', col(i));
    hold on
end

subplot(2,4,1);
title('coh bulb-pfc, wake after-wake before')
legend('873', '874', '891')

subplot(2,4,2);
title('coh bulb-pfc, sleep after-sleep before')
legend('873', '874', '891')

subplot(2,4,3);
title('coh bulb-pfc, freeze-active (ext)')
legend('873', '874', '891')

subplot(2,4,4);
title('coh bulb-pfc, freeze-wake before')
legend('873', '874', '891')

subplot(2,4,5);
title('coh hp-pfc, wake after-wake before')
legend('873', '874', '891')

subplot(2,4,6);
title('coh hp-pfc, sleep after-sleep before')
legend('873', '874', '891')

subplot(2,4,7);
title('coh hp-pfc, freeze-active (ext)')
legend('873', '874', '891')

subplot(2,4,8);
title('coh hp-pfc, freeze-wake before')
legend('873', '874', '891')


    