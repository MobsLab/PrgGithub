%% 

% Prerequisite : MakeLowSpectroMC.m must have been run

dir_sal = '/media/mobshamilton/DataMOBS173/DREADD_CRH_VLPO_1371_1372_saline_sleepPostEPM_230125_100723/1371/';
dir_cno = '/media/mobshamilton/DataMOBS173/DREADD_CRH_VLPO_1371_1372_cno_sleepPostEPM_230202_101623/1371/';

dir_to_use = {dir_sal, dir_cno};

for imouse =1:length(dir_to_use)
    cd(dir_to_use{imouse})
    
    sleep_stages{imouse} = load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch','TotalNoiseEpoch','Info');
    
    %injection period
    st_recording{imouse} = 0*1E8;
    en_epoch_preInj{imouse} = 1.4*1E8;
    st_epoch_postInj{imouse} = 1.65*1E8;
    
    %define time epoch
    durtotal{imouse} = max([max(End(sleep_stages{imouse}.Wake)),max(End(sleep_stages{imouse}.SWSEpoch))]);
    %pre injectionclear
    epoch_pre{imouse} = intervalSet(0,en_epoch_preInj{imouse});
    %post injection
    epoch_post{imouse}= intervalSet(st_epoch_postInj{imouse},durtotal{imouse});
    
    % x hours post injection
    x{imouse}=2; %% parameter to change
    epoch_xhPostInj{imouse}=intervalSet(st_recording{imouse},st_recording{imouse}+x{imouse}*3600*1e4);


    %%
    %==========================================================================
    %                            SPECTRO
    %==========================================================================
    %%load spectro
    %PFC
    SpectroP{imouse} = load('PFCx_deep_Low_Spectrum','Spectro');
    freqP{imouse} = SpectroP{imouse}.Spectro{3};
    sptsdP{imouse} = tsd(SpectroP{imouse}.Spectro{2}*1e4, SpectroP{imouse}.Spectro{1});
    %HPC
    SpectroH{imouse} = load('dHPC_deep_Low_Spectrum','Spectro');
    freqH{imouse} = SpectroH{imouse}.Spectro{3};
    sptsdH{imouse} = tsd(SpectroH{imouse}.Spectro{2}*1e4, SpectroH{imouse}.Spectro{1});
    %OBhigh
    SpectroOBhigh{imouse} = load('B_High_Spectrum','Spectro');
    freqOBhigh{imouse} = SpectroOBhigh{imouse}.Spectro{3};
    sptsdOBhigh{imouse} = tsd(SpectroOBhigh{imouse}.Spectro{2}*1e4, SpectroOBhigh{imouse}.Spectro{1});
    %OBlow
    SpectroOBlow{imouse} = load('Bulb_deep_Low_Spectrum','Spectro');
    freqOBlow{imouse} = SpectroOBlow{imouse}.Spectro{3};
    sptsdOBlow{imouse} = tsd(SpectroOBlow{imouse}.Spectro{2}*1e4, SpectroOBlow{imouse}.Spectro{1});
    %get time vector in hours of the day
    VecTimeDay{imouse} = GetTimeOfTheDay_MC(Range(sptsdOBlow{imouse}), 0);
    
    
    %%
    %threshold on speed to get period of high/low activity
    thresh{imouse} = sleep_stages{imouse}.Info.mov_threshold;
    behav{imouse} = load('behavResources.mat', 'MovAcctsd');
    thresh{imouse} = mean(Data(behav{imouse}.MovAcctsd))+std(Data(behav{imouse}.MovAcctsd));
    highMov{imouse} = thresholdIntervals(behav{imouse}.MovAcctsd, thresh{imouse}, 'Direction', 'Above');
    lowMov{imouse}= thresholdIntervals(behav{imouse}.MovAcctsd, thresh{imouse}, 'Direction', 'Below');
end
    %%
    
    col = {'k', 'r'};
for imouse =1:length(dir_to_use)
    %%mean OB low spectrum
    subplot(4,3,1),hold on
    plot(freqOBlow{imouse},mean(10*(Data(Restrict(sptsdOBlow{imouse}, epoch_xhPostInj{imouse})))),'color',col{imouse},'linewidth',2); 
    xlim([0 15])
    title('all')
    ylabel('OB low')
    
    
    subplot(4,3,2),
    plot(freqOBlow{imouse},mean(10*(Data(Restrict(sptsdOBlow{imouse}, and(highMov{imouse}, epoch_xhPostInj{imouse}))))),'color',col{imouse},'linewidth',2); hold on
    xlim([0 15])
    title('low movement')
    
    subplot(4,3,3),
    plot(freqOBlow{imouse},mean(10*(Data(Restrict(sptsdOBlow{imouse}, and(lowMov{imouse}, epoch_xhPostInj{imouse}))))),'color',col{imouse},'linewidth',2); hold on
    xlim([0 15])
    title('high movement')
    
    
    %%mean OB high spectrum
    subplot(4,3,4),
    plot(freqOBhigh{imouse},mean(10*(Data(Restrict(sptsdOBhigh{imouse}, epoch_xhPostInj{imouse})))),'color',col{imouse},'linewidth',2); hold on
    xlim([20 90])
    ylabel('OB high')
    
    
    subplot(4,3,5),
    plot(freqOBhigh{imouse},mean(10*(Data(Restrict(sptsdOBhigh{imouse}, and(highMov{imouse}, epoch_xhPostInj{imouse}))))),'color',col{imouse},'linewidth',2); hold on
    xlim([20 90])
    
    subplot(4,3,6),
    plot(freqOBhigh{imouse},mean(10*(Data(Restrict(sptsdOBhigh{imouse}, and(lowMov{imouse}, epoch_xhPostInj{imouse}))))),'color',col{imouse},'linewidth',2); hold on
    xlim([20 90])
    
    
    %%mean PFC spectrum
    subplot(4,3,7),
    plot(freqP{imouse},mean(10*(Data(Restrict(sptsdP{imouse}, epoch_xhPostInj{imouse})))),'color',col{imouse},'linewidth',2); hold on
    xlim([0 15])
    ylabel('PFC')
    
    
    subplot(4,3,8),
    plot(freqP{imouse},mean(10*(Data(Restrict(sptsdP{imouse}, and(highMov{imouse}, epoch_xhPostInj{imouse}))))),'color',col{imouse},'linewidth',2); hold on
    xlim([0 15])
    
    subplot(4,3,9),
    plot(freqP{imouse},mean(10*(Data(Restrict(sptsdP{imouse}, and(lowMov{imouse}, epoch_xhPostInj{imouse}))))),'color',col{imouse},'linewidth',2); hold on
    xlim([0 15])
    
    %%mean HPC spectrum
    subplot(4,3,10),
    plot(freqH{imouse},mean(10*(Data(Restrict(sptsdH{imouse}, epoch_xhPostInj{imouse})))),'color',col{imouse},'linewidth',2); hold on
    xlim([0 15])
    ylabel('HPC')
    
    
    subplot(4,3,11),
    plot(freqH{imouse},mean(10*(Data(Restrict(sptsdH{imouse}, and(highMov{imouse}, epoch_xhPostInj{imouse}))))),'color',col{imouse},'linewidth',2); hold on
    xlim([0 15])
    
    subplot(4,3,12),
    plot(freqH{imouse},mean(10*(Data(Restrict(sptsdH{imouse}, and(lowMov{imouse}, epoch_xhPostInj{imouse}))))),'color',col{imouse},'linewidth',2); hold on
    xlim([0 15])
    
end

%% Injections 10h

imouse=2;

figure
    %%mean OB low spectrum
    subplot(4,3,1),hold on
    % plot(freqOBlow{imouse},mean(10*(Data(Restrict(sptsdOBlow{imouse}, epoch_pre{imouse})))),':k','linewidth',2); hold on
    plot(freqOBlow{imouse},mean(10*(Data(Restrict(sptsdOBlow{imouse}, epoch_xhPostInj{imouse})))),'k','linewidth',2); 
    xlim([0 15])
    title('all')
    ylabel('OB low')
    
    
    subplot(4,3,2),
    % plot(freqOBlow{imouse},mean(10*(Data(Restrict(sptsdOBlow{imouse}, and(highMov{imouse}, epoch_pre{imouse}))))),':k','linewidth',2); hold on
    plot(freqOBlow{imouse},mean(10*(Data(Restrict(sptsdOBlow{imouse}, and(highMov{imouse}, epoch_xhPostInj{imouse}))))),'k','linewidth',2); hold on
    xlim([0 15])
    title('low movement')
    
    subplot(4,3,3),
    % plot(freqOBlow{imouse},mean(10*(Data(Restrict(sptsdOBlow{imouse}, and(lowMov{imouse}, epoch_pre{imouse}))))),':k','linewidth',2); hold on
    plot(freqOBlow{imouse},mean(10*(Data(Restrict(sptsdOBlow{imouse}, and(lowMov{imouse}, epoch_xhPostInj{imouse}))))),'k','linewidth',2); hold on
    xlim([0 15])
    title('high movement')
    
    
    %%mean OB high spectrum
    subplot(4,3,4),
    % plot(freqOBhigh{imouse},mean(10*(Data(Restrict(sptsdOBhigh{imouse}, epoch_pre{imouse})))),':k','linewidth',2); hold on
    plot(freqOBhigh{imouse},mean(10*(Data(Restrict(sptsdOBhigh{imouse}, epoch_xhPostInj{imouse})))),'k','linewidth',2); hold on
    xlim([20 90])
    ylabel('OB high')
    
    
    subplot(4,3,5),
    % plot(freqOBhigh{imouse},mean(10*(Data(Restrict(sptsdOBhigh{imouse}, and(highMov{imouse}, epoch_pre{imouse}))))),':k','linewidth',2); hold on
    plot(freqOBhigh{imouse},mean(10*(Data(Restrict(sptsdOBhigh{imouse}, and(highMov{imouse}, epoch_xhPostInj{imouse}))))),'k','linewidth',2); hold on
    xlim([20 90])
    
    subplot(4,3,6),
    % plot(freqOBhigh{imouse},mean(10*(Data(Restrict(sptsdOBhigh{imouse}, and(lowMov{imouse}, epoch_pre{imouse}))))),':k','linewidth',2); hold on
    plot(freqOBhigh{imouse},mean(10*(Data(Restrict(sptsdOBhigh{imouse}, and(lowMov{imouse}, epoch_xhPostInj{imouse}))))),'k','linewidth',2); hold on
    xlim([20 90])
    
    
    %%mean PFC spectrum
    subplot(4,3,7),
    % plot(freqP{imouse},mean(10*(Data(Restrict(sptsdP{imouse}, epoch_pre{imouse})))),':k','linewidth',2); hold on
    plot(freqP{imouse},mean(10*(Data(Restrict(sptsdP{imouse}, epoch_xhPostInj{imouse})))),'k','linewidth',2); hold on
    xlim([0 15])
    ylabel('PFC')
    
    
    subplot(4,3,8),
    % plot(freqP{imouse},mean(10*(Data(Restrict(sptsdP{imouse}, and(highMov{imouse}, epoch_pre{imouse}))))),':k','linewidth',2); hold on
    plot(freqP{imouse},mean(10*(Data(Restrict(sptsdP{imouse}, and(highMov{imouse}, epoch_xhPostInj{imouse}))))),'k','linewidth',2); hold on
    xlim([0 15])
    
    subplot(4,3,9),
    % plot(freqP{imouse},mean(10*(Data(Restrict(sptsdP{imouse}, and(lowMov{imouse}, epoch_pre{imouse}))))),':k','linewidth',2); hold on
    plot(freqP{imouse},mean(10*(Data(Restrict(sptsdP{imouse}, and(lowMov{imouse}, epoch_xhPostInj{imouse}))))),'k','linewidth',2); hold on
    xlim([0 15])
    
    %%mean HPC spectrum
    subplot(4,3,10),
    % plot(freqH{imouse},mean(10*(Data(Restrict(sptsdH{imouse}, epoch_pre{imouse})))),':k','linewidth',2); hold on
    plot(freqH{imouse},mean(10*(Data(Restrict(sptsdH{imouse}, epoch_xhPostInj{imouse})))),'k','linewidth',2); hold on
    xlim([0 15])
    ylabel('HPC')
    
    
    subplot(4,3,11),
    % plot(freqH{imouse},mean(10*(Data(Restrict(sptsdH{imouse}, and(highMov{imouse}, epoch_pre{imouse}))))),':k','linewidth',2); hold on
    plot(freqH{imouse},mean(10*(Data(Restrict(sptsdH{imouse}, and(highMov{imouse}, epoch_xhPostInj{imouse}))))),'k','linewidth',2); hold on
    xlim([0 15])
    
    subplot(4,3,12),
    % plot(freqH{imouse},mean(10*(Data(Restrict(sptsdH{imouse}, and(lowMov{imouse}, epoch_pre{imouse}))))),':k','linewidth',2); hold on
    plot(freqH{imouse},mean(10*(Data(Restrict(sptsdH{imouse}, and(lowMov{imouse}, epoch_xhPostInj{imouse}))))),'k','linewidth',2); hold on
    xlim([0 15])