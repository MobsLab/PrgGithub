
clear all
GetEmbReactMiceFolderList_BM
GetAllSalineSessions_BM

Mouse=Drugs_Groups_UMaze_BM(11);

Side={'All','Shock','Safe'};

load('/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPre_PreDrug/TestPre2/H_Low_Spectrum.mat'); RangeLow=Spectro{3};
Range_to_use = RangeLow;

window_time = 2;

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    try
        Ripples.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'ripples');
        Fz_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}) ,'epoch','epochname','freezeepoch');
        Zone_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}) ,'epoch','epochname','zoneepoch');
        Shock_Epoch.(Mouse_names{mouse}) = Zone_Epoch.(Mouse_names{mouse}){1};
        Safe_Epoch.(Mouse_names{mouse}) = or(Zone_Epoch.(Mouse_names{mouse}){2} , Zone_Epoch.(Mouse_names{mouse}){5});
        
        Fz.All.(Mouse_names{mouse}) = Fz_Epoch.(Mouse_names{mouse});
        Fz.Shock.(Mouse_names{mouse}) = and(Shock_Epoch.(Mouse_names{mouse}) , Fz_Epoch.(Mouse_names{mouse}));
        Fz.Safe.(Mouse_names{mouse}) = and(Safe_Epoch.(Mouse_names{mouse}) , Fz_Epoch.(Mouse_names{mouse}));
        
        PFC_Low_Spec.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'spectrum','prefix','PFCx_Low');
        PFC_Low_Spec_Fz.(Mouse_names{mouse}) = Restrict(PFC_Low_Spec.(Mouse_names{mouse}) , Fz_Epoch.(Mouse_names{mouse}));
        
        for side=1:3
            PFC_Low_Data_Fz.(Side{side}){mouse} = Data(Restrict(PFC_Low_Spec.(Mouse_names{mouse}) , Fz.(Side{side}).(Mouse_names{mouse})));
            Fz_Ripples.(Side{side}).(Mouse_names{mouse}) = Restrict(Ripples.(Mouse_names{mouse}) , Fz.(Side{side}).(Mouse_names{mouse}));
        end
        disp(Mouse_names{mouse})
    end
end


for side=1:3
    if side==1
        ind1=26; ind2=78;
    elseif side==2
        ind1=52; ind2=78;
    else
        ind1=26; ind2=52;
    end
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            n=1; m=1;
            for ep=1:length(Start(Fz.(Side{side}).(Mouse_names{mouse})))
                clear Freezing Ripples_Freezing Ra
                Freezing = subset(Fz.(Side{side}).(Mouse_names{mouse}) , ep);
                Ripples_Freezing = Range(Restrict(Ripples.(Mouse_names{mouse}) , Freezing));
                if size(Ripples_Freezing>10)
                    for rip=1:length(Ripples_Freezing)
                        SmallEp = intervalSet(Ripples_Freezing(rip)-window_time*1e4 , Ripples_Freezing(rip)+window_time*1e4);
                        if (sum(DurationEpoch(and(SmallEp , Freezing)))/1e4)==2*window_time
                            Ra = Range(Restrict(PFC_Low_Spec.(Mouse_names{mouse}) , Freezing));
                            try
                                clear D, D = zscore(Data(Restrict(PFC_Low_Spec.(Mouse_names{mouse}) , SmallEp))')';
                                PFC_Low_Around_Rip.(Side{side}).(Mouse_names{mouse})(n,:,:) = D;
                                PFC_MeanPowerEvol_Around_Rip.(Side{side})(mouse,n,:) = nanmean(D(:,52:78),2)-nanmean(D(:,26:52),2);
                                PFC_MeanPowerEvol_Around_Rip2.(Side{side})(mouse,n,:) = nanmean(D(:,ind1:ind2),2);
                                for r=1:10
                                    rand_time(r) = Ra(round(rand()*length(Ra)));
                                    SmallEp_rand = intervalSet(rand_time(r)-window_time*1e4 , rand_time(r)+window_time*1e4);
                                    clear D, D = zscore(Data(Restrict(PFC_Low_Spec.(Mouse_names{mouse}) , SmallEp_rand))')';
                                    PFC_Low_Around_Rand.(Side{side}).(Mouse_names{mouse})(m,:,:) = D;
                                    PFC_MeanPowerEvol_Around_Rand.(Side{side})(mouse,m,:) = nanmean(D(:,52:78),2)-nanmean(D(:,26:52),2);
                                    PFC_MeanPowerEvol_Around_Rand2.(Side{side})(mouse,m,:) = nanmean(D(:,ind1:ind2),2);
                                    m=m+1;
                                end
                            catch
                                disp('bou')
                            end
                            n=n+1;
                        end
                    end
                end
            end
            PFC_MeanPowerEvol_Around_Rip.(Side{side})(PFC_MeanPowerEvol_Around_Rip.(Side{side})==0)=NaN;
            PFC_MeanPowerEvol_Around_Rand.(Side{side})(PFC_MeanPowerEvol_Around_Rand.(Side{side})==0)=NaN;
            PFC_MeanPowerEvol_Around_Rip2.(Side{side})(PFC_MeanPowerEvol_Around_Rip2.(Side{side})==0)=NaN;
            PFC_MeanPowerEvol_Around_Rand2.(Side{side})(PFC_MeanPowerEvol_Around_Rand2.(Side{side})==0)=NaN;
            
            try
                if size(PFC_Low_Around_Rip.(Side{side}).(Mouse_names{mouse}),1)>1
                    PFC_Low_Around_Rip_All_pre.(Side{side})(mouse,:,:) = squeeze(nanmean(PFC_Low_Around_Rip.(Side{side}).(Mouse_names{mouse})));
                    PFC_Low_Around_Rand_All_pre.(Side{side})(mouse,:,:) = squeeze(nanmean(PFC_Low_Around_Rand.(Side{side}).(Mouse_names{mouse})));
                    PFC_MeanPowerEvol_Around_Rip_All.(Side{side})(mouse,:) = nanmean(squeeze(PFC_MeanPowerEvol_Around_Rip.(Side{side})(mouse,:,:)));
                    PFC_MeanPowerEvol_Around_Rand_All.(Side{side})(mouse,:) = nanmean(squeeze(PFC_MeanPowerEvol_Around_Rand.(Side{side})(mouse,:,:)));
                    PFC_MeanPowerEvol_Around_Rip_All2.(Side{side})(mouse,:) = nanmean(squeeze(PFC_MeanPowerEvol_Around_Rip2.(Side{side})(mouse,:,:)));
                    PFC_MeanPowerEvol_Around_Rand_All2.(Side{side})(mouse,:) = nanmean(squeeze(PFC_MeanPowerEvol_Around_Rand2.(Side{side})(mouse,:,:)));
                else
                    PFC_Low_Around_Rip_All_pre.(Side{side})(mouse,:,:) = squeeze(PFC_Low_Around_Rip.(Side{side}).(Mouse_names{mouse}));
                    PFC_Low_Around_Rand_All_pre.(Side{side})(mouse,:,:) = squeeze(PFC_Low_Around_Rand.(Side{side}).(Mouse_names{mouse}));
                    PFC_MeanPowerEvol_Around_Rip_All.(Side{side})(mouse,:) = squeeze(PFC_MeanPowerEvol_Around_Rip.(Side{side})(mouse,:,:));
                    PFC_MeanPowerEvol_Around_Rand_All.(Side{side})(mouse,:) = squeeze(PFC_MeanPowerEvol_Around_Rand.(Side{side})(mouse,:,:));
                    PFC_MeanPowerEvol_Around_Rip_All2.(Side{side})(mouse,:) = squeeze(PFC_MeanPowerEvol_Around_Rip2.(Side{side})(mouse,:,:));
                    PFC_MeanPowerEvol_Around_Rand_All2.(Side{side})(mouse,:) = squeeze(PFC_MeanPowerEvol_Around_Rand2.(Side{side})(mouse,:,:));
                end
            end
        end
        disp(Mouse_names{mouse})
    end
    PFC_Low_Around_Rip_All_pre.(Side{side})(PFC_Low_Around_Rip_All_pre.(Side{side})==0)=NaN;
    PFC_Low_Around_Rand_All_pre.(Side{side})(PFC_Low_Around_Rand_All_pre.(Side{side})==0)=NaN;
    PFC_Low_Around_Rip_All.(Side{side}) = squeeze(nanmean(PFC_Low_Around_Rip_All_pre.(Side{side})));
    PFC_Low_Around_Rand_All.(Side{side}) = squeeze(nanmean(PFC_Low_Around_Rand_All_pre.(Side{side})));
end

for side=1:3
    for j=1:size(PFC_Low_Around_Rip_All.(Side{side}),2)
        PFC_Low_Around_Rip_All_pretty.(Side{side})(:,j) = interp1(linspace(0,1,size(PFC_Low_Around_Rip_All.(Side{side}),1)) ,  PFC_Low_Around_Rip_All.(Side{side})(:,j) , linspace(0,1,100));
        PFC_Low_Around_Rand_All_pretty.(Side{side})(:,j) = interp1(linspace(0,1,size(PFC_Low_Around_Rand_All.(Side{side}),1)) ,  PFC_Low_Around_Rand_All.(Side{side})(:,j) , linspace(0,1,100));
    end
    for mouse=1:length(Mouse)
        try
            PFC_MeanPowerEvol_Around_Rip_All_pretty.(Side{side})(mouse,:) = interp1(linspace(0,1,size(PFC_MeanPowerEvol_Around_Rip_All.(Side{side}),2)) , PFC_MeanPowerEvol_Around_Rip_All.(Side{side})(mouse,:) , linspace(0,1,100));
            PFC_MeanPowerEvol_Around_Rand_All_pretty.(Side{side})(mouse,:) = interp1(linspace(0,1,size(PFC_MeanPowerEvol_Around_Rand_All.(Side{side}),2)) , PFC_MeanPowerEvol_Around_Rand_All.(Side{side})(mouse,:) , linspace(0,1,100));
            PFC_MeanPowerEvol_Around_Rip_All_pretty2.(Side{side})(mouse,:) = interp1(linspace(0,1,size(PFC_MeanPowerEvol_Around_Rip_All2.(Side{side}),2)) , PFC_MeanPowerEvol_Around_Rip_All2.(Side{side})(mouse,:) , linspace(0,1,100));
            PFC_MeanPowerEvol_Around_Rand_All_pretty2.(Side{side})(mouse,:) = interp1(linspace(0,1,size(PFC_MeanPowerEvol_Around_Rand_All2.(Side{side}),2)) , PFC_MeanPowerEvol_Around_Rand_All2.(Side{side})(mouse,:) , linspace(0,1,100));
        end
    end
    PFC_MeanPowerEvol_Around_Rip_All_pretty.(Side{side})(PFC_MeanPowerEvol_Around_Rip_All_pretty.(Side{side})==0)=NaN;
    PFC_MeanPowerEvol_Around_Rand_All_pretty.(Side{side})(PFC_MeanPowerEvol_Around_Rand_All_pretty.(Side{side})==0)=NaN;
    PFC_MeanPowerEvol_Around_Rip_All_pretty2.(Side{side})(PFC_MeanPowerEvol_Around_Rip_All_pretty2.(Side{side})==0)=NaN;
    PFC_MeanPowerEvol_Around_Rand_All_pretty2.(Side{side})(PFC_MeanPowerEvol_Around_Rand_All_pretty2.(Side{side})==0)=NaN;
end
PFC_MeanPowerEvol_Around_Rip_All_pretty.Safe(13,:)=NaN;
PFC_MeanPowerEvol_Around_Rand_All_pretty.Safe(13,:)=NaN;



%% figures
% rip times
figure
subplot(221)
imagesc(linspace(-window_time,window_time,50) , Range_to_use , SmoothDec(pow2(PFC_Low_Around_Rip_All_pretty.(Side{2})),1)'), axis xy
ylim([1 10]), xlabel('time (s)'), ylabel('Frequency (Hz)'), %caxis([.2 1.3]),
h=vline(0,'--r'); set(h,'LineWidth',2)
makepretty_BM
title('Shock')

subplot(222)
imagesc(linspace(-window_time,window_time,50) , Range_to_use , SmoothDec(pow2(PFC_Low_Around_Rip_All_pretty.(Side{3})),1)'), axis xy
ylim([1 10]), xlabel('time (s)'), ylabel('Frequency (Hz)'), %caxis([.2 1.3]),
h=vline(0,'--r'); set(h,'LineWidth',2)
makepretty_BM
u=colorbar; u.Ticks=[.2 1.3]; u.TickLabels={'0','1'}; u.Label.String = 'Power norm. (a.u.)'; u.Label.FontSize=12;
title('Safe')

colormap jet

subplot(223)
Data_to_use = PFC_MeanPowerEvol_Around_Rip_All_pretty2.Shock;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-window_time,window_time,100), runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-r',1); hold on;
color=[1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=[1 .3 .3]; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = PFC_MeanPowerEvol_Around_Rand_All_pretty2.Shock;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(-window_time,window_time,100), runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;

makepretty, makepretty_BM2
f=get(gca,'Children'); legend([f([5 1])],'ripples times','rand times');
xlabel('time (s)'), ylabel('Power norm. (a.u.)'), %ylim([1.02 1.28])
h=vline(0,'--r'); set(h,'LineWidth',2)


subplot(224)
Data_to_use = PFC_MeanPowerEvol_Around_Rip_All_pretty2.Safe;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-window_time,window_time,100), runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-r',1); hold on;
color=[.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=[.3 .3 1]; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = PFC_MeanPowerEvol_Around_Rand_All_pretty2.Safe;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(-window_time,window_time,100), runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;

makepretty, makepretty_BM2
f=get(gca,'Children'); legend([f([5 1])],'ripples times','rand times');
xlabel('time (s)'), ylabel('Power norm. (a.u.)'), %ylim([1.02 1.28])
h=vline(0,'--r'); set(h,'LineWidth',2)


% rand times
figure
subplot(221)
imagesc(linspace(-window_time,window_time,50) , Range_to_use , SmoothDec(PFC_Low_Around_Rand_All_pretty.(Side{2}),1)'), axis xy
ylim([1 10]), xlabel('time (s)'), ylabel('Frequency (Hz)'), caxis([.4 1.6]),
h=vline(0,'--r'); set(h,'LineWidth',2)
makepretty_BM
colorbar
title('Shock')

subplot(222)
imagesc(linspace(-window_time,window_time,50) , Range_to_use , SmoothDec(PFC_Low_Around_Rand_All_pretty.(Side{3}),1)'), axis xy
ylim([1 10]), xlabel('time (s)'), ylabel('Frequency (Hz)'), caxis([.4 1.6]),
h=vline(0,'--r'); set(h,'LineWidth',2)
makepretty_BM
colorbar
title('Safe')

colormap jet

subplot(223)
Data_to_use = PFC_MeanPowerEvol_Around_Rand_All_pretty.Shock;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-window_time,window_time,100), runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-r',1); hold on;
color=[1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=[1 .3 .3]; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
makepretty_BM
xlabel('time (s)'), ylabel('Power norm. (a.u.)'), ylim([1.02 1.28])
h=vline(0,'--r'); set(h,'LineWidth',2)

subplot(224)
Data_to_use = PFC_MeanPowerEvol_Around_Rand_All_pretty.Safe;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-window_time,window_time,100), runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-r',1); hold on;
color=[.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=[.3 .3 1]; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
makepretty_BM
xlabel('time (s)'), ylabel('Power norm. (a.u.)'), ylim([1.02 1.28])
h=vline(0,'--r'); set(h,'LineWidth',2)


% rip-rand times
figure
subplot(221)
imagesc(linspace(-window_time,window_time,50) , Range_to_use , SmoothDec(PFC_Low_Around_Rip_All_pretty.(Side{2})-PFC_Low_Around_Rand_All_pretty.(Side{2}),1)'), axis xy
ylim([1 10]), ylabel('Frequency (Hz)'), %caxis([-.3 .4])
h=vline(0,'--r'); set(h,'LineWidth',2)
makepretty_BM
colorbar
title('Shock')

subplot(222)
imagesc(linspace(-window_time,window_time,50) , Range_to_use , SmoothDec(PFC_Low_Around_Rip_All_pretty.(Side{3})-PFC_Low_Around_Rand_All_pretty.(Side{3}),1)'), axis xy
ylim([1 10]), %caxis([-.3 .3])
h=vline(0,'--r'); set(h,'LineWidth',2)
makepretty_BM
colorbar
title('Safe')

colormap jet

subplot(223)
Data_to_use = PFC_MeanPowerEvol_Around_Rip_All_pretty.Shock-PFC_MeanPowerEvol_Around_Rand_All_pretty.Shock;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-window_time,window_time,100), runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-r',1); hold on;
color=[1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=[1 .3 .3]; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
makepretty_BM
xlabel('time (s)'), ylabel('Power norm. (a.u.)'), %ylim([-.1 .1])
h=vline(0,'--r'); set(h,'LineWidth',2)

subplot(224)
Data_to_use = PFC_MeanPowerEvol_Around_Rip_All_pretty.Safe-PFC_MeanPowerEvol_Around_Rand_All_pretty.Safe;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-window_time,window_time,100), runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-r',1); hold on;
color=[.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=[.3 .3 1]; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
makepretty_BM
xlabel('time (s)'), %ylim([-.1 .1])
h=vline(0,'--r'); set(h,'LineWidth',2)




%% toolbox
figure, n=1;
for mouse=1:length(Mouse)
    subplot(3,6,n)
    if sum(sum(isnan(squeeze(PFC_Low_Around_Rip_All_pre.(Side{2})(mouse,:,:)))))~=5220
        imagesc(linspace(-window_time,window_time,50) , Range_to_use , squeeze(PFC_Low_Around_Rip_All_pre.(Side{2})(mouse,:,:))')
        axis xy
        disp(mouse)
        n=n+1;
    end
end

figure, n=1;
for mouse=1:length(Mouse)
    subplot(3,6,n)
    if sum(sum(isnan(squeeze(PFC_Low_Around_Rip_All_pre.(Side{2})(mouse,:,:)))))~=5220
        imagesc(linspace(-window_time,window_time,50) , Range_to_use , squeeze(PFC_Low_Around_Rand_All_pre.(Side{2})(mouse,:,:))')
        axis xy
        disp(mouse)
        n=n+1;
    end
end


for side=1:3
    for mouse=1:length(Mouse)
        F.(Side{side})(mouse,:,:) = squeeze(PFC_Low_Around_Rip_All_pre.(Side{side})(mouse,:,:))-squeeze(PFC_Low_Around_Rand_All_pre.(Side{side})(mouse,:,:));
    end
    F_all.(Side{side}) = squeeze(nanmean(F.(Side{side})));
end

figure
subplot(121)
imagesc(linspace(-window_time,window_time,50) , Range_to_use , SmoothDec(F_all.(Side{2}),1)'), axis xy
ylim([1 10]), xlabel('time (s)'), ylabel('Frequency (Hz)'), caxis([-.3 .3])
h=vline(0,'--r'); set(h,'LineWidth',2)
makepretty_BM
colorbar
title('Shock')

subplot(122)
imagesc(linspace(-window_time,window_time,50) , Range_to_use , SmoothDec(F_all.(Side{3}),1)'), axis xy
ylim([1 10]), xlabel('time (s)'), ylabel('Frequency (Hz)'), caxis([-.3 .3])
h=vline(0,'--r'); set(h,'LineWidth',2)
makepretty_BM
colorbar
title('Shock')


figure
subplot(221)
A1 = PFC_Low_Around_Rip_All_pretty.(Side{2})-PFC_Low_Around_Rand_All_pretty.(Side{2});
imagesc(linspace(-window_time,window_time,50) , Range_to_use , SmoothDec(A1,1)'), axis xy
ylim([1 10]), xlabel('time (s)'), ylabel('Frequency (Hz)'), caxis([-.3 .3])
h=vline(0,'--r'); set(h,'LineWidth',2)
makepretty_BM
colorbar
title('Shock')

subplot(222)
A1 = PFC_Low_Around_Rip_All_pretty.(Side{3})-PFC_Low_Around_Rand_All_pretty.(Side{3});
imagesc(linspace(-window_time,window_time,50) , Range_to_use , SmoothDec(A1,1)'), axis xy
ylim([1 10]), xlabel('time (s)'), ylabel('Frequency (Hz)'), caxis([-.3 .3])
h=vline(0,'--r'); set(h,'LineWidth',2)
makepretty_BM
colorbar
title('Shock')


