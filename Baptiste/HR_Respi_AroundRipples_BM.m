
clear all
GetEmbReactMiceFolderList_BM
GetAllSalineSessions_BM

Mouse=Drugs_Groups_UMaze_BM(22);
% Mouse=Drugs_Groups_UMaze_BM(23);

Side={'All','Shock','Safe'};

cd('/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPre_PreDrug/TestPre2')
load('H_Low_Spectrum.mat'); RangeLow=Spectro{3};
load('B_Middle_Spectrum.mat'); RangeMiddle=Spectro{3};
load('B_High_Spectrum.mat'); RangeHigh=Spectro{3};
load('H_VHigh_Spectrum.mat'); RangeVHigh=Spectro{3};
window_time=5;
lin = window_time*20;

%%
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    Fz_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}) ,'epoch','epochname','freezeepoch');
    Zone_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}) ,'epoch','epochname','zoneepoch');
    try, Ripples.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'ripples'); end
    try, HeartRate.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'heartrate'); end
    try, HeartRateVar.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'heartratevar'); end
    try, Respi.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'instfreq','method','WV','suffix_instfreq','B'); end
    
    Shock_Epoch.(Mouse_names{mouse}) = Zone_Epoch.(Mouse_names{mouse}){1};
    Safe_Epoch.(Mouse_names{mouse}) = or(Zone_Epoch.(Mouse_names{mouse}){2} , Zone_Epoch.(Mouse_names{mouse}){5});
    
    Fz.All.(Mouse_names{mouse}) = Fz_Epoch.(Mouse_names{mouse});
    Fz.Shock.(Mouse_names{mouse}) = and(Fz_Epoch.(Mouse_names{mouse}) , Shock_Epoch.(Mouse_names{mouse}));
    Fz.Safe.(Mouse_names{mouse}) = and(Fz_Epoch.(Mouse_names{mouse}) , Safe_Epoch.(Mouse_names{mouse}));

    for side=1:3
        try, Ripples_Fz.(Side{side}).(Mouse_names{mouse}) = Restrict(Ripples.(Mouse_names{mouse}) , Fz.(Side{side}).(Mouse_names{mouse})); end
        try, HeartRate_Fz.(Side{side}).(Mouse_names{mouse}) = Restrict(HeartRate.(Mouse_names{mouse}) , Fz.(Side{side}).(Mouse_names{mouse})); end
        try, HeartRateVar_Fz.(Side{side}).(Mouse_names{mouse}) = Restrict(HeartRateVar.(Mouse_names{mouse}) , Fz.(Side{side}).(Mouse_names{mouse})); end
        try, Respi_Fz.(Side{side}).(Mouse_names{mouse}) = Restrict(Respi.(Mouse_names{mouse}) , Fz.(Side{side}).(Mouse_names{mouse})); end
        %         RipplesDensity.(Side{side}).(Mouse_names{mouse}) = length(Restrict(Ripples.(Mouse_names{mouse}) , Fz.(Side{side}).(Mouse_names{mouse})))./(sum(DurationEpoch(Fz.Shock.(Mouse_names{mouse})))/1e4);
        Fz_Duration.(Side{side}).(Mouse_names{mouse}) = sum(DurationEpoch(Fz.(Side{side}).(Mouse_names{mouse})))/1e4;
    end
    
    disp(Mouse_names{mouse})
end


clear HR_Around_Rip HR_Around_Rand HR_Around_Rip_All HR_Around_Rand_All
clear HRVar_Around_Rip HRVar_Around_Rand HRVar_Around_Rip_All HRVar_Around_Rand_All
clear Respi_Around_Rip Respi_Around_Rand Respi_Around_Rip_All Respi_Around_Rand_All
for side=1:3
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            n=1; m=1;
            for ep=1:length(Start(Fz.(Side{side}).(Mouse_names{mouse})))
                clear Freezing Ripples_Freezing Ra
                Freezing = subset(Fz.(Side{side}).(Mouse_names{mouse}) , ep);
                Ripples_Freezing = Range(Restrict(Ripples.(Mouse_names{mouse}) , Freezing));
                if size(Ripples_Freezing>1)
                    for rip=1:length(Ripples_Freezing)
                        SmallEp = intervalSet(Ripples_Freezing(rip)-window_time*1e4 , Ripples_Freezing(rip)+window_time*1e4);
                        if (sum(DurationEpoch(and(SmallEp , Freezing)))/1e4)==2*window_time
                            try
                                Ra = Range(Restrict(HeartRate.(Mouse_names{mouse}) , Freezing));
                                
                                %                               clear D, D = log2(Data(Restrict(HeartRate.(Mouse_names{mouse}) , SmallEp))./(nanmean(Data(Restrict(HeartRate.(Mouse_names{mouse}) , Fz.(Side{side}).(Mouse_names{mouse}))))));
                                clear D, D = Data(Restrict(HeartRate.(Mouse_names{mouse}) , SmallEp))./(nanmean(Data(Restrict(HeartRate.(Mouse_names{mouse}) , Fz.(Side{side}).(Mouse_names{mouse})))));
                                HR_Around_Rip_norm.(Side{side})(mouse,n,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,lin));
                                clear D, D = Data(Restrict(HeartRate.(Mouse_names{mouse}) , SmallEp));
                                HR_Around_Rip.(Side{side})(mouse,n,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,lin));
                                %                               clear D, D = log2(Data(Restrict(HeartRateVar.(Mouse_names{mouse}) , SmallEp))./(nanmean(Data(Restrict(HeartRateVar.(Mouse_names{mouse}) , Fz.(Side{side}).(Mouse_names{mouse}))))));
                                clear D, D = Data(Restrict(HeartRateVar.(Mouse_names{mouse}) , SmallEp))./(nanmean(Data(Restrict(HeartRateVar.(Mouse_names{mouse}) , Fz.(Side{side}).(Mouse_names{mouse})))));
                                HRVar_Around_Rip_norm.(Side{side})(mouse,n,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,lin));
                                clear D, D = Data(Restrict(HeartRateVar.(Mouse_names{mouse}) , SmallEp));
                                HRVar_Around_Rip.(Side{side})(mouse,n,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,lin));
                                
                                for r=1:10
                                    rand_time(r) = Ra(round(rand()*length(Ra)));
                                    SmallEp_rand = intervalSet(rand_time(r)-window_time*1e4 , rand_time(r)+window_time*1e4);
                                    %                                   clear D, D = log2(Data(Restrict(HeartRate.(Mouse_names{mouse}) , SmallEp_rand))./(nanmean(Data(Restrict(HeartRate.(Mouse_names{mouse}) , Fz.(Side{side}).(Mouse_names{mouse}))))));
                                    clear D, D = Data(Restrict(HeartRate.(Mouse_names{mouse}) , SmallEp_rand))./(nanmean(Data(Restrict(HeartRate.(Mouse_names{mouse}) , Fz.(Side{side}).(Mouse_names{mouse})))));
                                    HR_Around_Rand_norm.(Side{side})(mouse,m,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,lin));
                                    clear D, D = Data(Restrict(HeartRate.(Mouse_names{mouse}) , SmallEp_rand));
                                    HR_Around_Rand.(Side{side})(mouse,m,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,lin));
                                    %                                   clear D, D = log2(Data(Restrict(HeartRateVar.(Mouse_names{mouse}) , SmallEp_rand))./(nanmean(Data(Restrict(HeartRateVar.(Mouse_names{mouse}) , Fz.(Side{side}).(Mouse_names{mouse}))))));
                                    clear D, D = Data(Restrict(HeartRateVar.(Mouse_names{mouse}) , SmallEp_rand))./(nanmean(Data(Restrict(HeartRateVar.(Mouse_names{mouse}) , Fz.(Side{side}).(Mouse_names{mouse})))));
                                    HRVar_Around_Rand_norm.(Side{side})(mouse,m,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,lin));
                                    clear D, D = Data(Restrict(HeartRateVar.(Mouse_names{mouse}) , SmallEp_rand));
                                    HRVar_Around_Rand.(Side{side})(mouse,m,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,lin));
                                    
                                    m=m+1;
                                end
                            catch
                                disp('bou')
                            end
                            try
                                Ra = Range(Restrict(Respi.(Mouse_names{mouse}) , Freezing));
                                
                                clear D, D = Data(Restrict(Respi.(Mouse_names{mouse}) , SmallEp));
                                Respi_Around_Rip.(Side{side})(mouse,n,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,lin));
                                clear D, D = Data(Restrict(Respi.(Mouse_names{mouse}) , SmallEp))./(nanmean(Data(Restrict(Respi.(Mouse_names{mouse}) , Fz.(Side{side}).(Mouse_names{mouse})))));
                                Respi_Around_Rip_norm.(Side{side})(mouse,n,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,lin));
                                
                                for r=1:10
                                    rand_time(r) = Ra(round(rand()*length(Ra)));
                                    SmallEp_rand = intervalSet(rand_time(r)-window_time*1e4 , rand_time(r)+window_time*1e4);
                                    clear D, D = Data(Restrict(Respi.(Mouse_names{mouse}) , SmallEp_rand));
                                    Respi_Around_Rand.(Side{side})(mouse,m,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,lin));
                                    clear D, D = Data(Restrict(Respi.(Mouse_names{mouse}) , SmallEp_rand))./(nanmean(Data(Restrict(Respi.(Mouse_names{mouse}) , Fz.(Side{side}).(Mouse_names{mouse})))));
                                    Respi_Around_Rand_norm.(Side{side})(mouse,m,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,lin));
                                    
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
            HR_Around_Rip.(Side{side})(HR_Around_Rip.(Side{side})==0)=NaN;
            HR_Around_Rand.(Side{side})(HR_Around_Rand.(Side{side})==0)=NaN;
            HRVar_Around_Rip.(Side{side})(HRVar_Around_Rip.(Side{side})==0)=NaN;
            HRVar_Around_Rand.(Side{side})(HRVar_Around_Rand.(Side{side})==0)=NaN;
            
            HR_Around_Rip_norm.(Side{side})(HR_Around_Rip_norm.(Side{side})==0)=NaN;
            HR_Around_Rand_norm.(Side{side})(HR_Around_Rand_norm.(Side{side})==0)=NaN;
            HRVar_Around_Rip_norm.(Side{side})(HRVar_Around_Rip_norm.(Side{side})==0)=NaN;
            HRVar_Around_Rand_norm.(Side{side})(HRVar_Around_Rand_norm.(Side{side})==0)=NaN;
            
            Respi_Around_Rip.(Side{side})(Respi_Around_Rip.(Side{side})==0)=NaN;
            Respi_Around_Rip_norm.(Side{side})(Respi_Around_Rip_norm.(Side{side})==0)=NaN;
            Respi_Around_Rand.(Side{side})(Respi_Around_Rand.(Side{side})==0)=NaN;
            Respi_Around_Rand_norm.(Side{side})(Respi_Around_Rand_norm.(Side{side})==0)=NaN;
            
            try
                if size(HR_Around_Rip.(Side{side}),1)>1
                    HR_Around_Rip_All.(Side{side})(mouse,:) = squeeze(nanmean(HR_Around_Rip.(Side{side})(mouse,:,:),2));
                    HR_Around_Rand_All.(Side{side})(mouse,:) = squeeze(nanmean(HR_Around_Rand.(Side{side})(mouse,:,:),2));
                    HRVar_Around_Rip_All.(Side{side})(mouse,:) = squeeze(nanmean(HRVar_Around_Rip.(Side{side})(mouse,:,:),2));
                    HRVar_Around_Rand_All.(Side{side})(mouse,:) = squeeze(nanmean(HRVar_Around_Rand.(Side{side})(mouse,:,:),2));
                    
                    HR_Around_Rip_All_norm.(Side{side})(mouse,:) = squeeze(nanmean(HR_Around_Rip_norm.(Side{side})(mouse,:,:),2));
                    HR_Around_Rand_All_norm.(Side{side})(mouse,:) = squeeze(nanmean(HR_Around_Rand_norm.(Side{side})(mouse,:,:),2));
                    HRVar_Around_Rip_All_norm.(Side{side})(mouse,:) = squeeze(nanmean(HRVar_Around_Rip_norm.(Side{side})(mouse,:,:),2));
                    HRVar_Around_Rand_All_norm.(Side{side})(mouse,:) = squeeze(nanmean(HRVar_Around_Rand_norm.(Side{side})(mouse,:,:),2));
                else
                    HR_Around_Rip_All.(Side{side})(mouse,:) = squeeze(HR_Around_Rip.(Side{side}));
                    HR_Around_Rand_All.(Side{side})(mouse,:) = squeeze(HR_Around_Rand.(Side{side}));
                    HRVar_Around_Rip_All.(Side{side})(mouse,:) = squeeze(HRVar_Around_Rip.(Side{side}));
                    HRVar_Around_Rand_All.(Side{side})(mouse,:) = squeeze(HRVar_Around_Rand.(Side{side}));
                    
                    HR_Around_Rip_All_norm.(Side{side})(mouse,:) = squeeze(HR_Around_Rip_norm.(Side{side}));
                    HR_Around_Rand_All_norm.(Side{side})(mouse,:) = squeeze(HR_Around_Rand_norm.(Side{side}));
                    HRVar_Around_Rip_All_norm.(Side{side})(mouse,:) = squeeze(HRVar_Around_Rip_norm.(Side{side}));
                    HRVar_Around_Rand_All_norm.(Side{side})(mouse,:) = squeeze(HRVar_Around_Rand_norm.(Side{side}));
                end
            end
            try
                if size(Respi_Around_Rip.(Side{side}),1)>1
                    Respi_Around_Rip_All.(Side{side})(mouse,:) = squeeze(nanmean(Respi_Around_Rip.(Side{side})(mouse,:,:),2));
                    Respi_Around_Rand_All.(Side{side})(mouse,:) = squeeze(nanmean(Respi_Around_Rand.(Side{side})(mouse,:,:),2));
                    Respi_Around_Rip_All_norm.(Side{side})(mouse,:) = squeeze(nanmean(Respi_Around_Rip_norm.(Side{side})(mouse,:,:),2));
                    Respi_Around_Rand_All_norm.(Side{side})(mouse,:) = squeeze(nanmean(Respi_Around_Rand_norm.(Side{side})(mouse,:,:),2));
                else
                    Respi_Around_Rip_All.(Side{side})(mouse,:) = squeeze(Respi_Around_Rip.(Side{side}));
                    Respi_Around_Rand_All.(Side{side})(mouse,:) = squeeze(Respi_Around_Rand.(Side{side}));
                    Respi_Around_Rip_All_norm.(Side{side})(mouse,:) = squeeze(Respi_Around_Rip_norm.(Side{side}));
                    Respi_Around_Rand_All_norm.(Side{side})(mouse,:) = squeeze(Respi_Around_Rand_norm.(Side{side}));
                end
            end
        end
        disp(Mouse_names{mouse})
    end
    HR_Around_Rip_All.(Side{side})(HR_Around_Rip_All.(Side{side})==0)=NaN;
    HR_Around_Rand_All.(Side{side})(HR_Around_Rand_All.(Side{side})==0)=NaN;
    HRVar_Around_Rip_All.(Side{side})(HRVar_Around_Rip_All.(Side{side})==0)=NaN;
    HRVar_Around_Rand_All.(Side{side})(HRVar_Around_Rand_All.(Side{side})==0)=NaN;
    HR_Around_Rip_All_norm.(Side{side})(HR_Around_Rip_All_norm.(Side{side})==0)=NaN;
    HR_Around_Rand_All_norm.(Side{side})(HR_Around_Rand_All_norm.(Side{side})==0)=NaN;
    HRVar_Around_Rip_All_norm.(Side{side})(HRVar_Around_Rip_All_norm.(Side{side})==0)=NaN;
    HRVar_Around_Rand_All_norm.(Side{side})(HRVar_Around_Rand_All_norm.(Side{side})==0)=NaN;
    Respi_Around_Rip_All.(Side{side})(Respi_Around_Rip_All.(Side{side})==0)=NaN;
    Respi_Around_Rand_All.(Side{side})(Respi_Around_Rand_All.(Side{side})==0)=NaN;
    Respi_Around_Rip_All_norm.(Side{side})(Respi_Around_Rip_All_norm.(Side{side})==0)=NaN;
    Respi_Around_Rand_All_norm.(Side{side})(Respi_Around_Rand_All_norm.(Side{side})==0)=NaN;
end
HR_Around_Rip_All.Shock([21],:)=NaN;
HR_Around_Rand_All.Shock([21],:)=NaN;
HRVar_Around_Rip_All.Shock([21],:)=NaN;
HRVar_Around_Rand_All.Shock([21],:)=NaN;

Respi_Around_Rip_All.Safe([2],:)=NaN;
Respi_Around_Rip_All_norm.Safe([2],:)=NaN;
Respi_Around_Rand_All.Safe([2],:)=NaN;
Respi_Around_Rand_All_norm.Safe([2],:)=NaN;

%% figures
%
figure
subplot(311)
Data_to_use = Respi_Around_Rip_All.Safe-nanmean(Respi_Around_Rip_All.Safe')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
h=shadedErrorBar(linspace(-window_time,window_time,lin), Mean_All_Sp , Conf_Inter ,'-r',1); hold on;
color=[.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = Respi_Around_Rand_All.Safe-nanmean(Respi_Around_Rand_All.Safe')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
shadedErrorBar(linspace(-window_time,window_time,lin), Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
makepretty, makepretty_BM2
f=get(gca,'Children'); legend([f([5 1])],'ripples times','rand times');
xlabel('time (s)'), ylabel('ΔBreathing (Hz)'), ylim([-.7 .4])
h=vline(0,'--r'); set(h,'LineWidth',2), text(-.3,.25,'rip time','Color','r','FontSize',15)

subplot(312)
Data_to_use = HR_Around_Rip_All.Safe-nanmean(HR_Around_Rip_All.Safe')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
h=shadedErrorBar(linspace(-window_time,window_time,lin), Mean_All_Sp , Conf_Inter ,'-r',1); hold on;
color=[.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = HR_Around_Rand_All.Safe-nanmean(HR_Around_Rand_All.Safe')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
shadedErrorBar(linspace(-window_time,window_time,lin), Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
makepretty, makepretty_BM2
f=get(gca,'Children'); legend([f([5 1])],'ripples times','rand times');
ylabel('ΔHeart rate (Hz)'), ylim([-.25 .25])
h=vline(0,'--r'); set(h,'LineWidth',2), text(-.3,.25,'rip time','Color','r','FontSize',15)

subplot(313)
Data_to_use = HRVar_Around_Rip_All.Safe-nanmean(HRVar_Around_Rip_All.Safe')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
h=shadedErrorBar(linspace(-window_time,window_time,lin), Mean_All_Sp , Conf_Inter ,'-r',1); hold on;
color=[.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = HRVar_Around_Rand_All.Safe-nanmean(HRVar_Around_Rand_All.Safe')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
shadedErrorBar(linspace(-window_time,window_time,lin), Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
makepretty, makepretty_BM2
xlabel('time (s)'), ylabel('ΔHeart rate variability (Hz)')
h=vline(0,'--r'); set(h,'LineWidth',2), ylim([-.03 .04])


% HR
figure
subplot(121)
Data_to_use = pow2(HR_Around_Rip_All.Shock);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
h=shadedErrorBar(linspace(-window_time,window_time,lin), runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-r',1); hold on;
color=[1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=[1 .3 .3]; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = pow2(HR_Around_Rand_All.Shock);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
shadedErrorBar(linspace(-window_time,window_time,lin), runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;

makepretty, makepretty_BM2
f=get(gca,'Children'); legend([f([5 1])],'ripples times','rand times');
xlabel('time (s)'), ylabel('Power norm. (a.u.)'), ylim([.92 1.01])
h=vline(0,'--r'); set(h,'LineWidth',2), 

subplot(122)
Data_to_use = pow2(HR_Around_Rip_All.Safe);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
h=shadedErrorBar(linspace(-window_time,window_time,lin), runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-r',1); hold on;
color=[.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = pow2(HR_Around_Rand_All.Safe);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
shadedErrorBar(linspace(-window_time,window_time,lin), runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;

makepretty, makepretty_BM2
f=get(gca,'Children'); legend([f([5 1])],'ripples times','rand times');
xlabel('time (s)'), ylabel('Power norm. (a.u.)'), ylim([.92 1.01])
h=vline(0,'--r'); set(h,'LineWidth',2)


% Respi
figure
subplot(121)
Data_to_use = pow2(Respi_Around_Rip_All.Shock);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
h=shadedErrorBar(linspace(-window_time,window_time,lin), runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-r',1); hold on;
color=[1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=[1 .3 .3]; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = pow2(Respi_Around_Rand_All.Shock);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
shadedErrorBar(linspace(-window_time,window_time,lin), runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;

makepretty, makepretty_BM2
f=get(gca,'Children'); legend([f([5 1])],'ripples times','rand times');
xlabel('time (s)'), ylabel('Power norm. (a.u.)'), ylim([.75 1.05])
h=vline(0,'--r'); set(h,'LineWidth',2)


subplot(122)
Data_to_use = pow2(Respi_Around_Rip_All.Safe);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
h=shadedErrorBar(linspace(-window_time,window_time,lin), runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-r',1); hold on;
color=[.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = pow2(Respi_Around_Rand_All.Safe);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
shadedErrorBar(linspace(-window_time,window_time,lin), runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;

makepretty, makepretty_BM2
f=get(gca,'Children'); legend([f([5 1])],'ripples times','rand times');
xlabel('time (s)'), ylabel('Power norm. (a.u.)'), ylim([.75 1.05])
h=vline(0,'--r'); set(h,'LineWidth',2)





%% Sleep
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
GetEmbReactMiceFolderList_BM
GetAllSalineSessions_BM

Mouse=[483 484 485 490 507 508 509 567 569 666 668 669 739 777 849 1170 1171 1189 1391 1392 1393 1394 1224 1225 1226];


cd('/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPre_PreDrug/TestPre2')
load('H_Low_Spectrum.mat'); RangeLow=Spectro{3};
load('B_Middle_Spectrum.mat'); RangeMiddle=Spectro{3};
load('B_High_Spectrum.mat'); RangeHigh=Spectro{3};
load('H_VHigh_Spectrum.mat'); RangeVHigh=Spectro{3};
window_time = 5;

Session_type={'sleep_pre','sleep_post'};
for sess=1:length(Session_type) 
    [OutPutData2.(Session_type{sess}) , Epoch2.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'ripples');
end

clear Mouse_names
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    try % are you sure ?
        UMazeSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
        SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
        if length(UMazeSleepSess.(Mouse_names{mouse}))==3
            SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
            SleepPostPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(2);
            SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(3);
        else
            try
                SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
                SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(2);
            catch % for 11203... grrr
                SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
                SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
            end
        end
    end
end

for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        try
            %             Ripples.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ripples');
            Ripples_NREM.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Ripples.(Session_type{sess}).(Mouse_names{mouse}) , Epoch2.(Session_type{sess}){mouse,4});
        end
        %         try
        %             HeartRate.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartrate');
        %             HeartRate_NREM.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HeartRate.(Session_type{sess}).(Mouse_names{mouse}) , Epoch2.(Session_type{sess}){mouse,4});
        %         end
        
        disp(Mouse_names{mouse})
    end
end


for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        try
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Data_to_use = HeartRate.(Session_type{sess}).(Mouse_names{mouse});    Range_to_use = 1;
            clear R; R=Range(Ripples_NREM.(Session_type{sess}).(Mouse_names{mouse}));
            
            if isfield(Ripples.(Session_type{sess}) , Mouse_names{mouse})
                for rip=1:size(R,1)
                    SmallEp = intervalSet(R(rip)-window_time*1e4 , R(rip)+window_time*1e4);
                    if (sum(DurationEpoch(and(SmallEp , Epoch2.(Session_type{sess}){mouse,4})))/1e4)==2*window_time
                        clear Data_temp
                        Data_temp = Data(Restrict(Data_to_use , SmallEp));
                        if and(~isempty(Data_temp) , length(Data_temp)>1)
                            DATA.(Session_type{sess}).(Mouse_names{mouse})(rip,:) =  interp1(linspace(0,1,size(Data_temp , 1)) ,  Data_temp' , linspace(0,1,50));
                        end
                    end
                end
            end
            
            try, DATA.(Session_type{sess}).(Mouse_names{mouse})(DATA.(Session_type{sess}).(Mouse_names{mouse})==0)=NaN; end
            
        end
        disp(Mouse_names{mouse})
    end
end



for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            if size(DATA.(Session_type{sess}).(Mouse_names{mouse}),1)==1
                DATA_all.(Session_type{sess})(mouse,:) = zscore(DATA.(Session_type{sess}).(Mouse_names{mouse})')';
                DATA_all2.(Session_type{sess})(mouse,:) = DATA.(Session_type{sess}).(Mouse_names{mouse})-nanmean(DATA.(Session_type{sess}).(Mouse_names{mouse}));
            else
                DATA_all.(Session_type{sess})(mouse,:) = nanmean(zscore(DATA.(Session_type{sess}).(Mouse_names{mouse})')');
                DATA_all2.(Session_type{sess})(mouse,:) = nanmean((DATA.(Session_type{sess}).(Mouse_names{mouse})'-nanmean(DATA.(Session_type{sess}).(Mouse_names{mouse})'))');
            end
        end
    end
    DATA_all.(Session_type{sess})(DATA_all.(Session_type{sess})==0)=NaN;
    DATA_all2.(Session_type{sess})(DATA_all2.(Session_type{sess})==0)=NaN;
end



%% figures
% by mouse
figure
subplot(121)
plot(zscore(DATA_all.(Session_type{sess})(5,:)))
subplot(122)
plot(zscore(DATA_all.(Session_type{sess}).M1189'))


% zscore method
figure
Data_to_use = DATA_all.sleep_pre;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
shadedErrorBar(linspace(-window_time,window_time,50) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Data_to_use = DATA_all.sleep_post;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
shadedErrorBar(linspace(-window_time,window_time,50) , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
xlabel('time (s)'), ylabel('Heart rate (a.u.)')
f=get(gca,'Children'); l=legend([f(5),f(1)],'sleep pre','sleep post'); l.Box='off';
box off, v=vline(0,'--r'); set(v,'LineWidth',2);
title('HR evolution around ripples (zscore method)')

% substract mean
figure
Data_to_use = DATA_all2.sleep_pre; 
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
shadedErrorBar(linspace(-window_time,window_time,50) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Data_to_use = DATA_all2.sleep_post;  Data_to_use(26,:)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
shadedErrorBar(linspace(-window_time,window_time,50) , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
xlabel('time (s)'), ylabel('Heart rate (Frequency (Hz))')
f=get(gca,'Children'); l=legend([f(5),f(1)],'sleep pre','sleep post'); l.Box='off';
box off, v=vline(0,'--r'); set(v,'LineWidth',2);
title('HR evolution around ripples (substract mean method)')





















