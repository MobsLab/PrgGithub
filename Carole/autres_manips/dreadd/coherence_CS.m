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

%%

% eveil preinj
    subplot(2,7,1);
    plot(f,mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Pre_Inj))), 'color', col(i));
    hold on
% "sommeil" preinj
    subplot(2,7,2);
    plot(f,mean(Data(Restrict(CohTSD,Epoch.FreezeAcc_Pre_Inj))), 'color', col(i));
    hold on
% post inj
    subplot(2,7,3);
    plot(f,mean(Data(Restrict(CohTSD,Epoch.Inj))), 'color', col(i));
    hold on
% non freeze ext
    subplot(2,7,4);
    plot(f,mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Ext))), 'color', col(i));
    hold on
%freeze ext
    subplot(2,7,5)
    plot(f,mean(Data(Restrict(CohTSD,Epoch.FreezeAcc_Ext))), 'color', col(i));
    hold on
% eveil post ext
    subplot(2,7,6);
    plot(f,mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Post_Ext))), 'color', col(i));
    hold on
% "sommeil" ppost ext
    subplot(2,7,7);
    plot(f,mean(Data(Restrict(CohTSD,Epoch.FreezeAcc_Post_Ext))), 'color', col(i));
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

%% toute la session

% imagesc(Coherence{2}, Coherence{3}, Coherence{1}');
% axis xy
% hold on
% vline(TTLInfo.InjectTTL, 'r', 'inj');
% vline(TTLInfo.ExtTTL, 'r', 'debut ext');
% vline(TTLInfo.PostExtTTL, 'r', 'fin ext');

% eveil preinj
    subplot(2,7,8);
    plot(f,mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Pre_Inj))), 'color', col(i));
    hold on
% "sommeil" preinj
    subplot(2,7,9);
    plot(f,mean(Data(Restrict(CohTSD,Epoch.FreezeAcc_Pre_Inj))), 'color', col(i));
    hold on
% post inj
    subplot(2,7,10);
    plot(f,mean(Data(Restrict(CohTSD,Epoch.Inj))), 'color', col(i));
    hold on
% non freeze ext
    subplot(2,7,11);
    plot(f,mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Ext))), 'color', col(i));
    hold on
%freeze ext
    subplot(2,7,12)
    plot(f,mean(Data(Restrict(CohTSD,Epoch.FreezeAcc_Ext))), 'color', col(i));
    hold on
% eveil post ext
    subplot(2,7,13);
    plot(f,mean(Data(Restrict(CohTSD,Epoch.Non_FreezeAcc_Post_Ext))), 'color', col(i));
    hold on
% "sommeil" ppost ext
    subplot(2,7,14);
    plot(f,mean(Data(Restrict(CohTSD,Epoch.FreezeAcc_Post_Ext))), 'color', col(i));
    hold on
    
end

subplot(2,7,1)
title('bulb-pfc eveil preinj')
legend('873', '874', '891')

subplot(2,7,8)
title('hp-pfc eveil preinj')
legend('873', '874', '891')

subplot(2,7,2)
title('bulb-pfc dodo preinj')
legend('873', '874', '891')

subplot(2,7,9)
title('hp-pfc dodo preinj')
legend('873', '874', '891')

subplot(2,7,3)
title('bulb-pfc dodo post inj')
legend('873', '874', '891')

subplot(2,7, 10)
title('hp-pfc dodo post inj')
legend('873', '874', '891')

subplot(2,7,4)
title('bulb-pfc activ ext')
legend('873', '874', '891')

subplot(2,7,11)
title('hp-pfc active ext')
legend('873', '874', '891')

subplot(2,7,5)
title('bulb-pfc freeze ext')
legend('873', '874', '891')

subplot(2,7,12)
title('hp-pfc freeze ext')
legend('873', '874', '891')

subplot(2,7,6)
title('bulb-pfc eveil post ext')
legend('873', '874', '891')

subplot(2,7,13)
title('hp-pfc eveil post ext')
legend('873', '874', '891')

subplot(2,7,7)
title('bulb-pfc dodo post ext')
legend('873', '874', '891')

subplot(2,7,14)
title('hp-pfc dodo post ext')
legend('873', '874', '891')

% imagesc(corr(SingleSpectro.ch2{1},Coherence{1})
%  imagesc(corr(SingleSpectro.ch2{1},Coherence{1})
%                                                 ↑
% Error: Expression or statement is incorrect--possibly unbalanced (, {, or [.
%  
% Did you mean:
% imagesc(corr(SingleSpectro.ch2{1},Coherence{1}))
% axis xy
% imagesc(Coherence{3},Coherence{3},corr(SingleSpectro.ch2{1},Coherence{1}))
% axis xy
% figure,imagesc(Coherence{3},Coherence{3},corr(SingleSpectro.ch1{1},Coherence{1}))
% axis xy
% xlabel('PFC power')
% ylabel('PFC OB coh')
% xlabel('OB power')
% ylabel('PFC OB coh')
%     CohTSD=tsd(t*1e4, C);
% CohTSD=tsd(t*1e4,Coherence{1});
% SpecPFCTSD=tsd(t*1e4,SingleSpectro.ch1{1});
% SpecOBTSD=tsd(t*1e4,SingleSpectro.ch2{1});
% load('FreezeEpoch_AccExt.mat')
% imagesc(Coherence{3},Coherence{3},corr(Data(Restrict(SpecOBTSD,Extinction_FreezeAccEpoch)),Data(Restrict(CohTSD,Extinction_FreezeAccEpoch)))
%  imagesc(Coherence{3},Coherence{3},corr(Data(Restrict(SpecOBTSD,Extinction_FreezeAccEpoch)),Data(Restrict(CohTSD,Extinction_FreezeAccEpoch)))
%                                                                                                                                              ↑
% Error: Expression or statement is incorrect--possibly unbalanced (, {, or [.
%  
% Did you mean:
% imagesc(Coherence{3},Coherence{3},corr(Data(Restrict(SpecOBTSD,Extinction_FreezeAccEpoch)),Data(Restrict(CohTSD,Extinction_FreezeAccEpoch))))
% axis xy
% load('FreezeEpoch_AccExt.mat')
% load('M874_PFCx_deep_Bulb_deep_Low_Coherence.mat')
% SpecOBTSD=tsd(t*1e4,SingleSpectro.ch2{1});
% SpecPFCTSD=tsd(t*1e4,SingleSpectro.ch1{1});
% CohTSD=tsd(t*1e4,Coherence{1});
% imagesc(Coherence{3},Coherence{3},corr(Data(Restrict(SpecOBTSD,Extinction_FreezeAccEpoch)),Data(Restrict(CohTSD,Extinction_FreezeAccEpoch))))
% axis xy
% imagesc(Coherence{3},Coherence{3},corr(Data(Restrict(SpecPFCTSD,Extinction_FreezeAccEpoch)),Data(Restrict(CohTSD,Extinction_FreezeAccEpoch))))
% axis xy
% figure,plot(nanmean(Data(Restrict(SpecOBTSD,Extinction_FreezeAccEpoch))))
% figure,plot(Coherence{3},nanmean(Data(Restrict(SpecOBTSD,Extinction_FreezeAccEpoch))))
% figure,imagesc(Coherence{3},Coherence{3},corr(Data(Restrict(SpecOBTSD,Extinction_FreezeAccEpoch)),Data(Restrict(SpecOBTSD,Extinction_FreezeAccEpoch))))
% figure,plot(Coherence{3},nanmean(Data(Restrict(SpecOBTSD,Extinction_FreezeAccEpoch))))
% hold on
% figure,plot(Coherence{3},nanmean(Data(Restrict(SpecPFCTSD,Extinction_FreezeAccEpoch))))
% figure,plot(Coherence{3},nanmean(Data(Restrict(CohTSD,Extinction_FreezeAccEpoch))))
% figure,plot(Coherence{3},log(nanmean(Data(Restrict(SpecPFCTSD,Extinction_FreezeAccEpoch)))))
% imagesc(log(nanmean(Data(Restrict(SpecPFCTSD,Extinction_FreezeAccEpoch)))))
% imagesc(log((Data(Restrict(SpecPFCTSD,Extinction_FreezeAccEpoch)))))
% axis xy
% imagesc(log((Data(Restrict(SpecPFCTSD,Extinction_FreezeAccEpoch))))')
% axis xy
% imagesc(1:10,Coherence{3},log((Data(Restrict(SpecPFCTSD,Extinction_FreezeAccEpoch))))')
% axis xy
% figure
% imagesc(1:10,Coherence{3},log((Data(Restrict(SpecOBTSD,Extinction_FreezeAccEpoch))))')
% axis xy
% figure
% imagesc(1:10,Coherence{3},((Data(Restrict(CohTSD,Extinction_FreezeAccEpoch))))')
% axis xy
% load('M891_PFCx_deep_Bulb_deep_Low_Coherence.mat')
% load('FreezeEpoch_AccExt.mat')
% CohTSD=tsd(t*1e4,Coherence{1});
% SpecPFCTSD=tsd(t*1e4,SingleSpectro.ch1{1});
% SpecOBTSD=tsd(t*1e4,SingleSpectro.ch2{1});
% figure
% imagesc(1:10,Coherence{3},((Data(Restrict(CohTSD,Extinction_FreezeAccEpoch))))')
% axis xy