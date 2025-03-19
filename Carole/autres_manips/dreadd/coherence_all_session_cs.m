Mice=[873, 874, 891];
i=3
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

imagesc(Coherence{2}, Coherence{3}, Coherence{1}');
axis xy
hold on
vline(TTLInfo.InjectTTL, 'r', 'inj');
vline(TTLInfo.ExtTTL, 'r', 'debut ext');
vline(TTLInfo.PostExtTTL, 'r', 'fin ext');
title(strcat('M',num2str(mouse_num),', coherence bulb-pfc'))
