

clear all
Mouse=Drugs_Groups_UMaze_BM(22);
Session_type={'Cond','Ext'};

for sess=1:length(Session_type)
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
'speed');
end
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/OB_Spec.mat','OB_Low_Spec')

ind=13:91; % ind=39:78; 13-91 --> 1-7Hz
for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            
            % shock fz
            if isempty(Start(Epoch1.(Session_type{sess}){mouse,5}))
                OB_PowerEvol_in_Ep_Shock.(Session_type{sess}){mouse}=NaN;
            else
                for ep=1:length(Start(Epoch1.(Session_type{sess}){mouse,5}))
                    try
                        FzEp = subset(Epoch1.(Session_type{sess}){mouse,5},ep);
                        OB_Fz_Shock.(Session_type{sess}){mouse}{ep} = Restrict(OB_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}) , FzEp);
                        
                        clear D
                        D = Data(OB_Fz_Shock.(Session_type{sess}){mouse}{ep});
                        OB_Mean_Fz_Shock.(Session_type{sess}){mouse}(ep,1:size(D,1)) = nansum(D(:,ind)'); % frequency band sum
                        % interpolanting spectrogram
                        for i=1:261
                            OB_SpecNorm_Fz_Shock.(Session_type{sess}){mouse}(ep,i,:) = interp1(linspace(0,1,size(D,1)) , D(:,i) , linspace(0,1,100));
                        end
                        
                        FzLength_Shock.(Session_type{sess}){mouse}(ep) = sum(DurationEpoch(FzEp))/1e4;
                        OB_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse}(ep) = nanmean(nansum(D(:,ind)'));
                        OB_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse}(OB_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse}==0)=NaN;
                        
                        OB_SpecNorm_Fz_Shock.(Session_type{sess}){mouse}(ep,:,:) = OB_SpecNorm_Fz_Shock.(Session_type{sess}){mouse}(ep,:,:)./OB_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse}(ep);
                        OB_PowerEvol_in_Ep_Shock.(Session_type{sess}){mouse}(ep,:) = nanmean(squeeze(OB_SpecNorm_Fz_Shock.(Session_type{sess}){mouse}(ep,ind,:)));
                        OB_PowerEvol_in_Ep_Shock.(Session_type{sess}){mouse}(OB_PowerEvol_in_Ep_Shock.(Session_type{sess}){mouse}==0)=NaN;
                    end
                end
            end
            
            % safe fz
            for ep=1:length(Start(Epoch1.(Session_type{sess}){mouse,6}))
                try
                    FzEp = subset(Epoch1.(Session_type{sess}){mouse,6},ep);
                    OB_Fz_Safe.(Session_type{sess}){mouse}{ep} = Restrict(OB_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}) , FzEp);
                    
                    clear D
                    D = Data(OB_Fz_Safe.(Session_type{sess}){mouse}{ep});
                    OB_Mean_Fz_Safe.(Session_type{sess}){mouse}(ep,1:size(D,1)) = nansum(D(:,ind)');
                    for i=1:261
                        OB_SpecNorm_Fz_Safe.(Session_type{sess}){mouse}(ep,i,:) = interp1(linspace(0,1,size(D,1)) , D(:,i) , linspace(0,1,100));
                    end
                    
                    FzLength_Safe.(Session_type{sess}){mouse}(ep) = sum(DurationEpoch(FzEp))/1e4;
                    OB_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse}(ep) = nanmean(nansum(D(:,ind)'));
                    OB_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse}(OB_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse}==0)=NaN;
                    
                    OB_SpecNorm_Fz_Safe.(Session_type{sess}){mouse}(ep,:,:) = OB_SpecNorm_Fz_Safe.(Session_type{sess}){mouse}(ep,:,:)./OB_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse}(ep);
                    OB_PowerEvol_in_Ep_Safe.(Session_type{sess}){mouse}(ep,:) = nanmean(squeeze(OB_SpecNorm_Fz_Safe.(Session_type{sess}){mouse}(ep,ind,:)));
                    OB_PowerEvol_in_Ep_Safe.(Session_type{sess}){mouse}(OB_PowerEvol_in_Ep_Safe.(Session_type{sess}){mouse}==0)=NaN;
                end
            end
        end
        disp(Mouse_names{mouse})
    end
end


for sess=1:length(Session_type)
    FzLength_Shock_Short.(Session_type{sess}) = FzLength_Shock.(Session_type{sess});
    FzLength_Shock_Long.(Session_type{sess}) = FzLength_Shock.(Session_type{sess});
    FzLength_Safe_Short.(Session_type{sess}) = FzLength_Safe.(Session_type{sess});
    FzLength_Safe_Long.(Session_type{sess}) = FzLength_Safe.(Session_type{sess});
    
    for mouse=1:length(Mouse)
        if ~isempty(OB_SpecNorm_Fz_Shock.(Session_type{sess}){mouse})
            if size(OB_SpecNorm_Fz_Shock.(Session_type{sess}){mouse},1)==1
                All_OB_SpecNorm_Fz_Shock.(Session_type{sess})(mouse,:,:) = squeeze(OB_SpecNorm_Fz_Shock.(Session_type{sess}){mouse});
            else
                All_OB_SpecNorm_Fz_Shock.(Session_type{sess})(mouse,:,:) = squeeze(nanmean(OB_SpecNorm_Fz_Shock.(Session_type{sess}){mouse}));
            end
        end
        if ~isempty(OB_SpecNorm_Fz_Safe.(Session_type{sess}){mouse})
            if size(OB_SpecNorm_Fz_Safe.(Session_type{sess}){mouse},1)==1
                All_OB_SpecNorm_Fz_Safe.(Session_type{sess})(mouse,:,:) = squeeze(OB_SpecNorm_Fz_Safe.(Session_type{sess}){mouse});
            else
                All_OB_SpecNorm_Fz_Safe.(Session_type{sess})(mouse,:,:) = squeeze(nanmean(OB_SpecNorm_Fz_Safe.(Session_type{sess}){mouse}));
            end
        end
        
        FzLength_Shock.(Session_type{sess}){mouse}(FzLength_Shock.(Session_type{sess}){mouse}==0)=NaN;
        FzLength_Shock_Short.(Session_type{sess}){mouse}(FzLength_Shock_Short.(Session_type{sess}){mouse}>5)=NaN;
        FzLength_Shock_Long.(Session_type{sess}){mouse}(FzLength_Shock_Long.(Session_type{sess}){mouse}<5)=NaN;
        
        FzLength_Safe.(Session_type{sess}){mouse}(FzLength_Safe.(Session_type{sess}){mouse}==0)=NaN;
        FzLength_Safe_Short.(Session_type{sess}){mouse}(FzLength_Safe_Short.(Session_type{sess}){mouse}>5)=NaN;
        FzLength_Safe_Long.(Session_type{sess}){mouse}(FzLength_Safe_Long.(Session_type{sess}){mouse}<5)=NaN;
    end
end


figure
for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        try
            [R_shock.(Session_type{sess})(mouse),P_shock.(Session_type{sess})(mouse)] = PlotCorrelations_BM(log10(FzLength_Shock.(Session_type{sess}){mouse}) , log10(OB_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse}));
            [R_safe.(Session_type{sess})(mouse),P_shock.(Session_type{sess})(mouse)] = PlotCorrelations_BM(log10(FzLength_Safe.(Session_type{sess}){mouse}) , log10(OB_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse}));
            
            
            [R_shock_Short.(Session_type{sess})(mouse),P_shock_Short.(Session_type{sess})(mouse)] = PlotCorrelations_BM(FzLength_Shock_Short.(Session_type{sess}){mouse} , OB_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse});
            [R_safe_Short.(Session_type{sess})(mouse),P_safe_Short.(Session_type{sess})(mouse)] = PlotCorrelations_BM(FzLength_Safe_Short.(Session_type{sess}){mouse} , OB_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse});
            
            
            [R_shock_Long.(Session_type{sess})(mouse),P_shock_Long.(Session_type{sess})(mouse)] = PlotCorrelations_BM(FzLength_Shock_Long.(Session_type{sess}){mouse} , OB_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse});
            [R_safe_Long.(Session_type{sess})(mouse),P_safe_Long.(Session_type{sess})(mouse)] = PlotCorrelations_BM(FzLength_Safe_Long.(Session_type{sess}){mouse} , OB_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse});
        end
    end
    R_shock.(Session_type{sess})(R_shock.(Session_type{sess})==0 | R_shock.(Session_type{sess})==-1 | R_shock.(Session_type{sess})==1)=NaN; R_shock_Short.(Session_type{sess})(R_shock_Short.(Session_type{sess})==0 | R_shock_Short.(Session_type{sess})==-1 | R_shock_Short.(Session_type{sess})==1)=NaN; R_shock_Long.(Session_type{sess})(R_shock_Long.(Session_type{sess})==0 | R_shock_Long.(Session_type{sess})==-1 | R_shock_Long.(Session_type{sess})==1)=NaN;
    R_safe.(Session_type{sess})(R_safe.(Session_type{sess})==0 | R_safe.(Session_type{sess})==-1 | R_safe.(Session_type{sess})==1)=NaN; R_safe_Short.(Session_type{sess})(R_safe_Short.(Session_type{sess})==0 | R_safe_Short.(Session_type{sess})==-1 | R_safe_Short.(Session_type{sess})==1)=NaN; R_safe_Long.(Session_type{sess})(R_safe_Long.(Session_type{sess})==0 | R_safe_Long.(Session_type{sess})==-1 | R_safe_Long.(Session_type{sess})==1)=NaN;
end
close

for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        if isnan(nanmean(OB_PowerEvol_in_Ep_Shock.(Session_type{sess}){mouse}))
            OB_PowerEvol_in_Ep_Shock_all.(Session_type{sess})(mouse,:) = NaN(1,100);
        else
            OB_PowerEvol_in_Ep_Shock_all.(Session_type{sess})(mouse,:) = nanmean(OB_PowerEvol_in_Ep_Shock.(Session_type{sess}){mouse});
        end
        if isnan(nanmean(OB_PowerEvol_in_Ep_Safe.(Session_type{sess}){mouse}))
            OB_PowerEvol_in_Ep_Safe_all.(Session_type{sess})(mouse,:) = NaN(1,100);
        else
            OB_PowerEvol_in_Ep_Safe_all.(Session_type{sess})(mouse,:) = nanmean(OB_PowerEvol_in_Ep_Safe.(Session_type{sess}){mouse});
        end
    end
    
    OB_PowerEvol_in_Ep_Shock_all2.(Session_type{sess}) = zscore_nan_BM(OB_PowerEvol_in_Ep_Shock_all.(Session_type{sess})');
    OB_PowerEvol_in_Ep_Safe_all2.(Session_type{sess}) = zscore_nan_BM(OB_PowerEvol_in_Ep_Safe_all.(Session_type{sess})');
end

%% figures
figure, mouse=34; sess=2;
subplot(121)
[R,P]=PlotCorrelations_BM(FzLength_Shock.(Session_type{sess}){mouse} , OB_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse} , 'method' , 'spearman')
axis square
xlabel('fz ep length (s)'), ylabel('Mean OB power in the episode (a.u.)')
title('Shock')

subplot(122)
PlotCorrelations_BM(FzLength_Safe.(Session_type{sess}){mouse} , OB_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse} , 'color' , [.5 .5 1])
axis square
xlabel('fz ep length (s)'), ylabel('Mean OB power in the episode (a.u.)')
title('Safe')

a=suptitle('OB power = f(episode length)'); a.FontSize=20;



figure, mouse=45; sess=2;
subplot(121)
PlotCorrelations_BM(FzLength_Shock_Short.(Session_type{sess}){mouse} , OB_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse} , 'Color' , 'r')
PlotCorrelations_BM(FzLength_Shock_Long.(Session_type{sess}){mouse} , OB_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse} , 'Color' , 'g')
axis square
xlabel('fz ep length (a.u.)'), ylabel('Mean OB power in the episode (a.u.)')
title('Shock')

subplot(122)
PlotCorrelations_BM(FzLength_Safe_Short.(Session_type{sess}){mouse} , OB_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse} , 'Color' , 'r')
PlotCorrelations_BM(FzLength_Safe_Long.(Session_type{sess}){mouse} , OB_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse} , 'Color' , 'g')
axis square
xlabel('fz ep length (a.u.)'), ylabel('Mean OB power in the episode (a.u.)')
title('Safe')


figure, sess=2;
MakeSpreadAndBoxPlot4_SB({R_shock.(Session_type{sess}) R_safe.(Session_type{sess})},{[1 .5 .5],[.5 .5 1]},[1 2],{'Shock','Safe'},'showpoints',1,'paired',0); 
h=hline(0,'--k'); set(h,'LineWidth',2); ylim([-1 1]), ylabel('R values')
makepretty_BM2
[p, h, stats] = signrank(R_shock.(Session_type{sess}),zeros(1,length(R_shock.(Session_type{sess}))))
[p, h, stats] = signrank(R_safe.(Session_type{sess}),zeros(1,length(R_safe.(Session_type{sess}))))




figure, sess=2;
subplot(231)
MakeSpreadAndBoxPlot4_SB({R_shock.(Session_type{sess})(P_shock.(Session_type{sess}))},{[.3 .3 .3]},1,{'Saline'},'showpoints',1,'paired',0);
h=hline(0); set(h,'LineWidth',2); ylim([-1 1])
[h,p]=ttest(R_shock.(Session_type{sess}),zeros(1,length(R_shock.(Session_type{sess}))))
title(['p = ' num2str(p)])

subplot(234)
MakeSpreadAndBoxPlot4_SB({R_safe.(Session_type{sess})},{[.3 .3 .3]},1,{'Saline'},'showpoints',1,'paired',0);
h=hline(0); set(h,'LineWidth',2); ylim([-1 1])
[h,p]=ttest(R_safe.(Session_type{sess}),zeros(1,length(R_safe.(Session_type{sess}))))
title(['p = ' num2str(p)])


subplot(232)
MakeSpreadAndBoxPlot4_SB({R_shock_Short.(Session_type{sess})},{[.3 .3 .3]},1,{'Saline'},'showpoints',1,'paired',0);
h=hline(0); set(h,'LineWidth',2); ylim([-1 1])
[h,p]=ttest(R_shock_Short.(Session_type{sess}),zeros(1,length(R_shock_Short.(Session_type{sess}))))
title(['p = ' num2str(p)])

subplot(235)
MakeSpreadAndBoxPlot4_SB({R_safe_Short.(Session_type{sess})},{[.3 .3 .3]},1,{'Saline'},'showpoints',1,'paired',0);
h=hline(0); set(h,'LineWidth',2); ylim([-1 1])
[h,p]=ttest(R_safe_Short.(Session_type{sess}),zeros(1,length(R_safe_Short.(Session_type{sess}))))
title(['p = ' num2str(p)])


subplot(233)
MakeSpreadAndBoxPlot4_SB({R_shock_Long.(Session_type{sess})},{[.3 .3 .3]},1,{'Saline'},'showpoints',1,'paired',0);
h=hline(0); set(h,'LineWidth',2); ylim([-1 1])
[h,p]=ttest(R_shock_Long.(Session_type{sess}),zeros(1,length(R_shock_Long.(Session_type{sess}))))
title(['p = ' num2str(p)])

subplot(236)
MakeSpreadAndBoxPlot4_SB({R_safe_Long.(Session_type{sess})},{[.3 .3 .3]},1,{'Saline'},'showpoints',1,'paired',0);
h=hline(0); set(h,'LineWidth',2); ylim([-1 1])
[h,p]=ttest(R_safe_Long.(Session_type{sess}),zeros(1,length(R_safe_Long.(Session_type{sess}))))
title(['p = ' num2str(p)])




figure, sess=1;
subplot(121)
MakeSpreadAndBoxPlot4_SB({R_shock.(Session_type{sess})(P_shock.(Session_type{sess})<.05)},{[.3 .3 .3]},1,{'Saline'},'showpoints',1,'paired',0);
h=hline(0); set(h,'LineWidth',2); ylim([-1 1])
[h,p]=ttest(R_shock.(Session_type{sess}),zeros(1,length(R_shock.(Session_type{sess}))))
title(['p = ' num2str(p)])

subplot(122)
MakeSpreadAndBoxPlot4_SB({R_safe.(Session_type{sess})(P_safe.(Session_type{sess})<.05)},{[.3 .3 .3]},1,{'Saline'},'showpoints',1,'paired',0);
h=hline(0); set(h,'LineWidth',2); ylim([-1 1])
[h,p]=ttest(R_safe.(Session_type{sess}),zeros(1,length(R_safe.(Session_type{sess}))))
title(['p = ' num2str(p)])


figure, sess=2;
subplot(121)
MakeSpreadAndBoxPlot_BM({R_shock.(Session_type{sess})},{[1 .5 .5]},1,{'Shock'},1,0);
h=hline(0,'--k'); set(h,'LineWidth',2); ylim([-1.2 1.2])
[h,p]=ttest(R_shock.(Session_type{sess}),zeros(1,length(R_shock.(Session_type{sess}))))
makepretty_BM2
plot([.7 1.3],[1.1 1.1],'-k','LineWidth',1.5);
text(1,1.15,'*','HorizontalAlignment','Center','FontSize',20);
ylabel('R values Fz length = f(OB power)')

subplot(122)
MakeSpreadAndBoxPlot_BM({R_safe.(Session_type{sess})},{[.5 .5 1]},1,{'Safe'},1,0);
h=hline(0,'--k'); set(h,'LineWidth',2); ylim([-1.2 1.2])
[h,p]=ttest(R_safe.(Session_type{sess}),zeros(1,length(R_safe.(Session_type{sess}))))
makepretty_BM2
plot([.7 1.3],[1.1 1.1],'-k','LineWidth',1.5);
text(1,1.15,'*','HorizontalAlignment','Center','FontSize',20);




for sess=2%1:length(Session_type)
    for mouse=1:length(Mouse)
        MeanOB_Power_Shock_short.(Session_type{sess})(mouse) = nanmean(OB_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse}(~isnan(FzLength_Shock_Short.(Session_type{sess}){mouse})));
        MeanOB_Power_Shock_long.(Session_type{sess})(mouse) = nanmean(OB_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse}(~isnan(FzLength_Shock_Long.(Session_type{sess}){mouse})));
        MeanOB_Power_Safe_short.(Session_type{sess})(mouse) = nanmean(OB_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse}(~isnan(FzLength_Safe_Short.(Session_type{sess}){mouse})));
        MeanOB_Power_Safe_long.(Session_type{sess})(mouse) = nanmean(OB_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse}(~isnan(FzLength_Safe_Long.(Session_type{sess}){mouse})));
    end
end


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({MeanOB_Power_Shock_short.(Session_type{sess}) MeanOB_Power_Shock_long.(Session_type{sess})},{[1 .5 .5],[1 .3 .3]},[1:2],{'Shock short','Shock long'},'showpoints',0,'paired',1);
subplot(122)
MakeSpreadAndBoxPlot3_SB({MeanOB_Power_Safe_short.(Session_type{sess}) MeanOB_Power_Safe_long.(Session_type{sess})},{[.5 .5 1],[.3 .3 1]},[1:2],{'Safe short','Safe long',},'showpoints',0,'paired',1);




figure
subplot(223)
Data_to_use = OB_PowerEvol_in_Ep_Shock_all.(Session_type{sess});
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,1,100) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) ,'-r',1); hold on;
xlabel('norm time'), ylabel('OB power (a.u.)'), box off, l=ylim; yticks(l), yticklabels({'0','1'})
title('Shock')
subplot(224)
Data_to_use = OB_PowerEvol_in_Ep_Safe_all.(Session_type{sess});
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,1,100) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) ,'-b',1); hold on;
xlabel('norm time'), box off, l=ylim; yticks(l), yticklabels({'0','1'})
title('Safe')

All_OB_SpecNorm_Fz_Shock.Ext([13 22 36 40 47 48 50 51],: , :) = NaN;
All_OB_SpecNorm_Fz_Shock.(Session_type{sess})(All_OB_SpecNorm_Fz_Shock.(Session_type{sess})==0)=NaN;
All_OB_SpecNorm_Fz_Safe.Ext([7 8 11 13 15:18 24 26 28 33 35 36 48 51],: , :) = NaN;
All_OB_SpecNorm_Fz_Safe.(Session_type{sess})(All_OB_SpecNorm_Fz_Safe.(Session_type{sess})==0)=NaN;


load('B_Low_Spectrum.mat')

subplot(221)
clear Sp; Sp=squeeze(nanmean(All_OB_SpecNorm_Fz_Shock.(Session_type{sess})));
imagesc(linspace(0,1,100) , Spectro{3} , Sp), axis xy
ylabel('Frequency (Hz)'), ylim([0 10])
caxis([0 1.8e-2])

subplot(222)
clear Sp; Sp=squeeze(nanmean(All_OB_SpecNorm_Fz_Safe.(Session_type{sess})));
imagesc(linspace(0,1,100) , Spectro{3} , Sp), axis xy
ylim([0 10])
caxis([0 2e-2])

colormap jet



%% toolbox
D = Data(OB_Fz_Shock{mouse}{ep});
plot(nanmean(D(:,6:91)))

D = Data(OB_Fz_Safe{mouse}{ep});
plot(nanmean(D(:,6:91)))

figure
imagesc(Data(OB_Fz{mouse}{ep})'), axis xy





figure
plot(squeeze(OB_Mean_Fz_Shock{14})')
plot(nanmean(squeeze(OB_Mean_Fz_Shock{14})))


figure, mouse=14;
subplot(121)
clear Sp; Sp=squeeze(nanmean(OB_SpecNorm_Fz_Shock{mouse}));
imagesc(linspace(0,1,100) , Spectro{3} , Sp), axis xy
xlabel('time (s)') , ylabel('Frequency (Hz)'), ylim([.15 15])

subplot(122)
clear Sp; Sp=squeeze(nanmean(OB_SpecNorm_Fz_Safe{mouse}));
imagesc(linspace(0,1,100) , Spectro{3} , Sp), axis xy
xlabel('time (s)') , ylabel('Frequency (Hz)'), ylim([.15 15])


figure
Data_to_use = OB_PowerEvol_in_Ep_Shock{mouse};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,1,100) , Mean_All_Sp,Conf_Inter,'-r',1); hold on;

Data_to_use = OB_PowerEvol_in_Ep_Safe{mouse};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,1,100) , Mean_All_Sp,Conf_Inter,'-b',1); hold on;

xlabel('time (a.u.)') 



%% Blocked 
clear all
Mouse=Drugs_Groups_UMaze_BM(11);
Session_type={'Cond'};

for sess=1:length(Session_type)
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
'speed');
end
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/OB_Spec.mat','OB_Low_Spec')

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
end

ind=13:91; %ind=39:78;
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    try
        
        % shock fz
        if isempty(Start(and(Epoch1.(Session_type{sess}){mouse,5} , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}))))
            OB_PowerEvol_in_Ep_Shock{mouse}=NaN;
        else
            for ep=1:length(Start(and(Epoch1.(Session_type{sess}){mouse,5} , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}))))
                try
                    FzEp = subset(and(Epoch1.(Session_type{sess}){mouse,5} , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse})),ep);
                    OB_Fz_Shock{mouse}{ep} = Restrict(OB_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}) , FzEp);
                    
                    clear D
                    D = Data(OB_Fz_Shock{mouse}{ep});
                    OB_Mean_Fz_Shock{mouse}(ep,1:size(D,1)) = nansum(D(:,ind)'); % 13-91 --> 1-7Hz
                    OB_PowerEvol_in_Ep_Shock{mouse}(ep,:) = interp1(linspace(0,1,sum(squeeze(OB_Mean_Fz_Shock{mouse}(ep,:))~=0)) , squeeze(OB_Mean_Fz_Shock{mouse}(ep,1:sum(squeeze(OB_Mean_Fz_Shock{mouse}(ep,:))~=0))) , linspace(0,1,100));
                    for i=1:261
                        OB_SpecNorm_Fz_Shock{mouse}(ep,i,:) = interp1(linspace(0,1,size(D,1)) , D(:,i) , linspace(0,1,100));
                    end
                    
                    FzLength_Shock{mouse}(ep) = sum(DurationEpoch(FzEp))/1e4;
                    OB_Mean_Fz_ByEp_Shock{mouse}(ep) = nanmean(nansum(D(:,ind)'));
                    OB_Mean_Fz_ByEp_Shock{mouse}(OB_Mean_Fz_ByEp_Shock{mouse}==0)=NaN;
                    
                    OB_SpecNorm_Fz_Shock{mouse}(ep,:,:) = OB_SpecNorm_Fz_Shock{mouse}(ep,:,:)./OB_Mean_Fz_ByEp_Shock{mouse}(ep);
                    OB_PowerEvol_in_Ep_Shock{mouse}(OB_PowerEvol_in_Ep_Shock{mouse}==0)=NaN;
                end
            end
        end
        
        % safe fz
        for ep=1:length(Start(and(Epoch1.(Session_type{sess}){mouse,6} , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}))))
            try
                FzEp = subset(and(Epoch1.(Session_type{sess}){mouse,6} , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse})),ep);
                OB_Fz_Safe{mouse}{ep} = Restrict(OB_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}) , FzEp);
                
                clear D
                D = Data(OB_Fz_Safe{mouse}{ep});
                OB_Mean_Fz_Safe{mouse}(ep,1:size(D,1)) = nansum(D(:,ind)');
                OB_PowerEvol_in_Ep_Safe{mouse}(ep,:) = interp1(linspace(0,1,sum(squeeze(OB_Mean_Fz_Safe{mouse}(ep,:))~=0)) , squeeze(OB_Mean_Fz_Safe{mouse}(ep,1:sum(squeeze(OB_Mean_Fz_Safe{mouse}(ep,:))~=0))) , linspace(0,1,100));
                for i=1:261
                    OB_SpecNorm_Fz_Safe{mouse}(ep,i,:) = interp1(linspace(0,1,size(D,1)) , D(:,i) , linspace(0,1,100));
                end
                
                FzLength_Safe{mouse}(ep) = sum(DurationEpoch(FzEp))/1e4;
                OB_Mean_Fz_ByEp_Safe{mouse}(ep) = nanmean(nansum(D(:,ind)'));
                OB_Mean_Fz_ByEp_Safe{mouse}(OB_Mean_Fz_ByEp_Safe{mouse}==0)=NaN;
                
                OB_SpecNorm_Fz_Safe{mouse}(ep,:,:) = OB_SpecNorm_Fz_Safe{mouse}(ep,:,:)./OB_Mean_Fz_ByEp_Safe{mouse}(ep);
                OB_PowerEvol_in_Ep_Safe{mouse}(OB_PowerEvol_in_Ep_Safe{mouse}==0)=NaN;
            end
        end
    end
    disp(Mouse_names{mouse})
end



%% PFC


GetAllSalineSessions_BM


for sess=2%1:length(Session_type)
    Sessions_List_ForLoop_BM
    for mouse=1:length(Mouse)
        try
            PFC_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'spectrum' , 'prefix' , 'PFCx_Low');
            disp(Mouse_names{mouse})
        end
    end
end



ind=13:91; %ind=39:78; 13-91 --> 1-7Hz
for sess=2%1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            
            % shock fz
            if isempty(Start(Epoch1.(Session_type{sess}){mouse,5}))
                PFC_PowerEvol_in_Ep_Shock.(Session_type{sess}){mouse}=NaN;
            else
                for ep=1:length(Start(Epoch1.(Session_type{sess}){mouse,5}))
                    try
                        FzEp = subset(Epoch1.(Session_type{sess}){mouse,5},ep);
                        PFC_Fz_Shock.(Session_type{sess}){mouse}{ep} = Restrict(PFC_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}) , FzEp);
                        
                        clear D
                        D = Data(PFC_Fz_Shock.(Session_type{sess}){mouse}{ep});
                        PFC_Mean_Fz_Shock.(Session_type{sess}){mouse}(ep,1:size(D,1)) = nansum(D(:,ind)'); % frequency band sum
                        % interpolanting spectrogram
                        for i=1:261
                            PFC_SpecNorm_Fz_Shock.(Session_type{sess}){mouse}(ep,i,:) = interp1(linspace(0,1,size(D,1)) , D(:,i) , linspace(0,1,100));
                        end
                        
                        FzLength_Shock.(Session_type{sess}){mouse}(ep) = sum(DurationEpoch(FzEp))/1e4;
                        PFC_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse}(ep) = nanmean(nansum(D(:,ind)'));
                        PFC_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse}(PFC_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse}==0)=NaN;
                        
                        PFC_SpecNorm_Fz_Shock.(Session_type{sess}){mouse}(ep,:,:) = PFC_SpecNorm_Fz_Shock.(Session_type{sess}){mouse}(ep,:,:)./PFC_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse}(ep);
                        PFC_PowerEvol_in_Ep_Shock.(Session_type{sess}){mouse}(ep,:) = nanmean(squeeze(PFC_SpecNorm_Fz_Shock.(Session_type{sess}){mouse}(ep,ind,:)));
                        PFC_PowerEvol_in_Ep_Shock.(Session_type{sess}){mouse}(PFC_PowerEvol_in_Ep_Shock.(Session_type{sess}){mouse}==0)=NaN;
                    end
                end
            end
            
            % safe fz
            for ep=1:length(Start(Epoch1.(Session_type{sess}){mouse,6}))
                try
                    FzEp = subset(Epoch1.(Session_type{sess}){mouse,6},ep);
                    PFC_Fz_Safe.(Session_type{sess}){mouse}{ep} = Restrict(PFC_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}) , FzEp);
                    
                    clear D
                    D = Data(PFC_Fz_Safe.(Session_type{sess}){mouse}{ep});
                    PFC_Mean_Fz_Safe.(Session_type{sess}){mouse}(ep,1:size(D,1)) = nansum(D(:,ind)');
                    for i=1:261
                        PFC_SpecNorm_Fz_Safe.(Session_type{sess}){mouse}(ep,i,:) = interp1(linspace(0,1,size(D,1)) , D(:,i) , linspace(0,1,100));
                    end
                    
                    FzLength_Safe.(Session_type{sess}){mouse}(ep) = sum(DurationEpoch(FzEp))/1e4;
                    PFC_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse}(ep) = nanmean(nansum(D(:,ind)'));
                    PFC_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse}(PFC_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse}==0)=NaN;
                    
                    PFC_SpecNorm_Fz_Safe.(Session_type{sess}){mouse}(ep,:,:) = PFC_SpecNorm_Fz_Safe.(Session_type{sess}){mouse}(ep,:,:)./PFC_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse}(ep);
                        PFC_PowerEvol_in_Ep_Safe.(Session_type{sess}){mouse}(ep,:) = nanmean(squeeze(PFC_SpecNorm_Fz_Safe.(Session_type{sess}){mouse}(ep,ind,:)));
                    PFC_PowerEvol_in_Ep_Safe.(Session_type{sess}){mouse}(PFC_PowerEvol_in_Ep_Safe.(Session_type{sess}){mouse}==0)=NaN;
                end
            end
        end
        disp(Mouse_names{mouse})
    end
end


for sess=2:length(Session_type)
    FzLength_Shock_Short.(Session_type{sess}) = FzLength_Shock.(Session_type{sess});
    FzLength_Shock_Long.(Session_type{sess}) = FzLength_Shock.(Session_type{sess});
    FzLength_Safe_Short.(Session_type{sess}) = FzLength_Safe.(Session_type{sess});
    FzLength_Safe_Long.(Session_type{sess}) = FzLength_Safe.(Session_type{sess});
    
    for mouse=1:length(Mouse)
        if ~isempty(PFC_SpecNorm_Fz_Shock.(Session_type{sess}){mouse})
            if size(PFC_SpecNorm_Fz_Shock.(Session_type{sess}){mouse},1)==1
                All_PFC_SpecNorm_Fz_Shock.(Session_type{sess})(mouse,:,:) = squeeze(PFC_SpecNorm_Fz_Shock.(Session_type{sess}){mouse});
            else
                All_PFC_SpecNorm_Fz_Shock.(Session_type{sess})(mouse,:,:) = squeeze(nanmean(PFC_SpecNorm_Fz_Shock.(Session_type{sess}){mouse}));
            end
        end
        if ~isempty(PFC_SpecNorm_Fz_Safe.(Session_type{sess}){mouse})
            if size(PFC_SpecNorm_Fz_Safe.(Session_type{sess}){mouse},1)==1
                All_PFC_SpecNorm_Fz_Safe.(Session_type{sess})(mouse,:,:) = squeeze(PFC_SpecNorm_Fz_Safe.(Session_type{sess}){mouse});
            else
                All_PFC_SpecNorm_Fz_Safe.(Session_type{sess})(mouse,:,:) = squeeze(nanmean(PFC_SpecNorm_Fz_Safe.(Session_type{sess}){mouse}));
            end
        end
        
        FzLength_Shock.(Session_type{sess}){mouse}(FzLength_Shock.(Session_type{sess}){mouse}==0)=NaN;
        FzLength_Shock_Short.(Session_type{sess}){mouse}(FzLength_Shock_Short.(Session_type{sess}){mouse}>5)=NaN;
        FzLength_Shock_Long.(Session_type{sess}){mouse}(FzLength_Shock_Long.(Session_type{sess}){mouse}<5)=NaN;
        
        FzLength_Safe.(Session_type{sess}){mouse}(FzLength_Safe.(Session_type{sess}){mouse}==0)=NaN;
        FzLength_Safe_Short.(Session_type{sess}){mouse}(FzLength_Safe_Short.(Session_type{sess}){mouse}>5)=NaN;
        FzLength_Safe_Long.(Session_type{sess}){mouse}(FzLength_Safe_Long.(Session_type{sess}){mouse}<5)=NaN;
    end
end

figure
for sess=2:length(Session_type)
    for mouse=1:length(Mouse)
        try
            [R_shock2.(Session_type{sess})(mouse),P_shock2.(Session_type{sess})(mouse)] = PlotCorrelations_BM(FzLength_Shock.(Session_type{sess}){mouse} , PFC_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse});
            [R_safe2.(Session_type{sess})(mouse),P_safe2.(Session_type{sess})(mouse)] = PlotCorrelations_BM(FzLength_Safe.(Session_type{sess}){mouse} , PFC_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse});
            
            
            [R_shock_Short.(Session_type{sess})(mouse),P_shock_Short.(Session_type{sess})(mouse)] = PlotCorrelations_BM(FzLength_Shock_Short.(Session_type{sess}){mouse} , PFC_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse});
            [R_safe_Short.(Session_type{sess})(mouse),P_safe_Short.(Session_type{sess})(mouse)] = PlotCorrelations_BM(FzLength_Safe_Short.(Session_type{sess}){mouse} , PFC_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse});
            
            
            [R_shock_Long.(Session_type{sess})(mouse),P_shock_Long.(Session_type{sess})(mouse)] = PlotCorrelations_BM(FzLength_Shock_Long.(Session_type{sess}){mouse} , PFC_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse});
            [R_safe_Long.(Session_type{sess})(mouse),P_safe_Long.(Session_type{sess})(mouse)] = PlotCorrelations_BM(FzLength_Safe_Long.(Session_type{sess}){mouse} , PFC_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse});
        end
    end
    R_shock2.(Session_type{sess})(R_shock2.(Session_type{sess})==0 | R_shock2.(Session_type{sess})==-1 | R_shock2.(Session_type{sess})==1)=NaN; R_shock_Short.(Session_type{sess})(R_shock_Short.(Session_type{sess})==0 | R_shock_Short.(Session_type{sess})==-1 | R_shock_Short.(Session_type{sess})==1)=NaN; R_shock_Long.(Session_type{sess})(R_shock_Long.(Session_type{sess})==0 | R_shock_Long.(Session_type{sess})==-1 | R_shock_Long.(Session_type{sess})==1)=NaN;
    R_safe2.(Session_type{sess})(R_safe2.(Session_type{sess})==0 | R_safe2.(Session_type{sess})==-1 | R_safe2.(Session_type{sess})==1)=NaN; R_safe_Short.(Session_type{sess})(R_safe_Short.(Session_type{sess})==0 | R_safe_Short.(Session_type{sess})==-1 | R_safe_Short.(Session_type{sess})==1)=NaN; R_safe_Long.(Session_type{sess})(R_safe_Long.(Session_type{sess})==0 | R_safe_Long.(Session_type{sess})==-1 | R_safe_Long.(Session_type{sess})==1)=NaN;
end
close


for sess=2:length(Session_type)
    for mouse=1:length(Mouse)
        if isnan(nanmean(PFC_PowerEvol_in_Ep_Shock.(Session_type{sess}){mouse}))
            PFC_PowerEvol_in_Ep_Shock_all.(Session_type{sess})(mouse,:) = NaN(1,100);
        else
            PFC_PowerEvol_in_Ep_Shock_all.(Session_type{sess})(mouse,:) = nanmean(PFC_PowerEvol_in_Ep_Shock.(Session_type{sess}){mouse});
        end
        if isnan(nanmean(PFC_PowerEvol_in_Ep_Safe.(Session_type{sess}){mouse}))
            PFC_PowerEvol_in_Ep_Safe_all.(Session_type{sess})(mouse,:) = NaN(1,100);
        else
            PFC_PowerEvol_in_Ep_Safe_all.(Session_type{sess})(mouse,:) = nanmean(PFC_PowerEvol_in_Ep_Safe.(Session_type{sess}){mouse});
        end
    end
    
    PFC_PowerEvol_in_Ep_Shock_all2.(Session_type{sess}) = zscore_nan_BM(PFC_PowerEvol_in_Ep_Shock_all.(Session_type{sess})');
    PFC_PowerEvol_in_Ep_Safe_all2.(Session_type{sess}) = zscore_nan_BM(PFC_PowerEvol_in_Ep_Safe_all.(Session_type{sess})');
end

for sess=2%1:length(Session_type)
    for mouse=1:length(Mouse)
        try
            MeanPFC_Power_Shock_short.(Session_type{sess})(mouse) = nanmean(PFC_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse}(~isnan(FzLength_Shock_Short.(Session_type{sess}){mouse})));
            MeanPFC_Power_Shock_long.(Session_type{sess})(mouse) = nanmean(PFC_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse}(~isnan(FzLength_Shock_Long.(Session_type{sess}){mouse})));
            MeanPFC_Power_Safe_short.(Session_type{sess})(mouse) = nanmean(PFC_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse}(~isnan(FzLength_Safe_Short.(Session_type{sess}){mouse})));
            MeanPFC_Power_Safe_long.(Session_type{sess})(mouse) = nanmean(PFC_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse}(~isnan(FzLength_Safe_Long.(Session_type{sess}){mouse})));
        end
    end
    MeanPFC_Power_Shock_short.(Session_type{sess})(MeanPFC_Power_Shock_short.(Session_type{sess})==0)=NaN;
    MeanPFC_Power_Shock_long.(Session_type{sess})(MeanPFC_Power_Shock_long.(Session_type{sess})==0)=NaN;
    MeanPFC_Power_Safe_short.(Session_type{sess})(MeanPFC_Power_Safe_short.(Session_type{sess})==0)=NaN;
    MeanPFC_Power_Safe_long.(Session_type{sess})(MeanPFC_Power_Safe_long.(Session_type{sess})==0)=NaN;
end

figure, mouse=34; sess=2;
subplot(121)
[R,P]=PlotCorrelations_BM(FzLength_Shock.(Session_type{sess}){mouse} , PFC_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse})
axis square
xlabel('fz ep length (s)'), ylabel('Mean PFC power in the episode (a.u.)')
title('Shock')

subplot(122)
PlotCorrelations_BM(FzLength_Safe.(Session_type{sess}){mouse} , PFC_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse})
axis square
xlabel('fz ep length (s)'), ylabel('Mean PFC power in the episode (a.u.)')
title('Safe')

a=suptitle('PFC power = f(episode length)'); a.FontSize=20;



figure, mouse=45; sess=2;
subplot(121)
PlotCorrelations_BM(FzLength_Shock_Short.(Session_type{sess}){mouse} , PFC_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse} , 'Color' , 'r')
PlotCorrelations_BM(FzLength_Shock_Long.(Session_type{sess}){mouse} , PFC_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse} , 'Color' , 'g')
axis square
xlabel('fz ep length (a.u.)'), ylabel('Mean PFC power in the episode (a.u.)')
title('Shock')

subplot(122)
PlotCorrelations_BM(FzLength_Safe_Short.(Session_type{sess}){mouse} , PFC_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse} , 'Color' , 'r')
PlotCorrelations_BM(FzLength_Safe_Long.(Session_type{sess}){mouse} , PFC_Mean_Fz_ByEp_Safe.(Session_type{sess}){mouse} , 'Color' , 'g')
axis square
xlabel('fz ep length (a.u.)'), ylabel('Mean PFC power in the episode (a.u.)')
title('Safe')


figure, sess=2;
subplot(121)
MakeSpreadAndBoxPlot_BM({R_shock2.(Session_type{sess})},{[1 .5 .5]},1,{'Shock'},1,0);
h=hline(0,'--k'); set(h,'LineWidth',2); ylim([-1.2 1.2])
[h,p]=ttest(R_shock2.(Session_type{sess}),zeros(1,length(R_shock2.(Session_type{sess}))))
makepretty_BM2
plot([.7 1.3],[1.1 1.1],'-k','LineWidth',1.5);
text(1,1.15,'*','HorizontalAlignment','Center','FontSize',20);
ylabel('R values Fz length = f(PFC power)')

subplot(122)
MakeSpreadAndBoxPlot_BM({R_safe2.(Session_type{sess})},{[.5 .5 1]},1,{'Safe'},1,0);
h=hline(0,'--k'); set(h,'LineWidth',2); ylim([-1.2 1.2])
[h,p]=ttest(R_safe2.(Session_type{sess}),zeros(1,length(R_safe2.(Session_type{sess}))))
makepretty_BM2
plot([.7 1.3],[1.1 1.1],'-k','LineWidth',1.5);
text(1,1.15,'*','HorizontalAlignment','Center','FontSize',20);



figure, sess=2;
subplot(121)
MakeSpreadAndBoxPlot_BM({R_shock2.(Session_type{sess})(P_shock2.(Session_type{sess})<.05)},{[1 .5 .5]},1,{'Shock'},1,0);
h=hline(0,'--k'); set(h,'LineWidth',2); ylim([-1.2 1.2])
[h,p]=ttest(R_shock2.(Session_type{sess})(P_shock2.(Session_type{sess})<.05) , zeros(1:length(sum(~isnan(R_shock2.(Session_type{sess})(P_shock2.(Session_type{sess})<.05))))))
makepretty_BM2
plot([.7 1.3],[1.1 1.1],'-k','LineWidth',1.5);
text(1,1.15,'*','HorizontalAlignment','Center','FontSize',20);
ylabel('R values Fz length = f(PFC power)')

subplot(122)
MakeSpreadAndBoxPlot_BM({R_safe2.(Session_type{sess})(P_safe2.(Session_type{sess})<.05)},{[.5 .5 1]},1,{'Safe'},1,0);
h=hline(0,'--k'); set(h,'LineWidth',2); ylim([-1.2 1.2])
[h,p]=ttest(R_safe2.(Session_type{sess}),zeros(1,length(R_safe2.(Session_type{sess}))))
makepretty_BM2
plot([.7 1.3],[1.1 1.1],'-k','LineWidth',1.5);
text(1,1.15,'*','HorizontalAlignment','Center','FontSize',20);











figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({MeanPFC_Power_Shock_short.(Session_type{sess}) MeanPFC_Power_Shock_long.(Session_type{sess})},{[1 .5 .5],[1 .3 .3]},[1:2],{'Shock short','Shock long'},'showpoints',0,'paired',1);
subplot(122)
MakeSpreadAndBoxPlot3_SB({MeanPFC_Power_Safe_short.(Session_type{sess}) MeanPFC_Power_Safe_long.(Session_type{sess})},{[.5 .5 1],[.3 .3 1]},[1:2],{'Safe short','Safe long',},'showpoints',0,'paired',1);






figure
subplot(223)
Data_to_use = PFC_PowerEvol_in_Ep_Shock_all.(Session_type{sess});
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,1,100) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) ,'-r',1); hold on;
xlabel('norm time'), ylabel('PFC power (a.u.)'), box off, l=ylim; yticks(l), yticklabels({'0','1'})
title('Shock')
subplot(224)
Data_to_use = PFC_PowerEvol_in_Ep_Safe_all.(Session_type{sess});
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,1,100) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) ,'-b',1); hold on;
xlabel('norm time'), box off, l=ylim; yticks(l), yticklabels({'0','1'})
title('Safe')

All_PFC_SpecNorm_Fz_Shock.Ext([13 22 36 40 47 48 50 51],: , :) = NaN;
All_PFC_SpecNorm_Fz_Shock.(Session_type{sess})(All_PFC_SpecNorm_Fz_Shock.(Session_type{sess})==0)=NaN;
All_PFC_SpecNorm_Fz_Safe.Ext([7 8 11 13 15:18 24 26 28 33 35 36 48 51],: , :) = NaN;
All_PFC_SpecNorm_Fz_Safe.(Session_type{sess})(All_PFC_SpecNorm_Fz_Safe.(Session_type{sess})==0)=NaN;


load('B_Low_Spectrum.mat')

subplot(221)
clear Sp; Sp=squeeze(nanmean(All_PFC_SpecNorm_Fz_Shock.(Session_type{sess})));
imagesc(linspace(0,1,100) , Spectro{3} , Sp), axis xy
ylabel('Frequency (Hz)'), ylim([0 10])
caxis([0 1e-2])

subplot(222)
clear Sp; Sp=squeeze(nanmean(All_PFC_SpecNorm_Fz_Safe.(Session_type{sess})));
imagesc(linspace(0,1,100) , Spectro{3} , Sp), axis xy
ylim([0 10])
caxis([0 1.5e-2])

colormap jet



%% toolbox
D = Data(OB_Fz_Shock{mouse}{ep});
plot(nanmean(D(:,6:91)))

D = Data(OB_Fz_Safe{mouse}{ep});
plot(nanmean(D(:,6:91)))

figure
imagesc(Data(OB_Fz{mouse}{ep})'), axis xy





figure
plot(squeeze(OB_Mean_Fz_Shock{14})')
plot(nanmean(squeeze(OB_Mean_Fz_Shock{14})))


figure, mouse=14;
subplot(121)
clear Sp; Sp=squeeze(nanmean(OB_SpecNorm_Fz_Shock{mouse}));
imagesc(linspace(0,1,100) , Spectro{3} , Sp), axis xy
xlabel('time (s)') , ylabel('Frequency (Hz)'), ylim([.15 15])

subplot(122)
clear Sp; Sp=squeeze(nanmean(OB_SpecNorm_Fz_Safe{mouse}));
imagesc(linspace(0,1,100) , Spectro{3} , Sp), axis xy
xlabel('time (s)') , ylabel('Frequency (Hz)'), ylim([.15 15])


figure
Data_to_use = OB_PowerEvol_in_Ep_Shock{mouse};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,1,100) , Mean_All_Sp,Conf_Inter,'-r',1); hold on;

Data_to_use = OB_PowerEvol_in_Ep_Safe{mouse};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,1,100) , Mean_All_Sp,Conf_Inter,'-b',1); hold on;

xlabel('time (a.u.)') 


