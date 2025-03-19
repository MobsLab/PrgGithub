% FiringRateBeforeAfterStim.m
% 02.06.2017
% suite au skyp du 01.06.12017, 
% questions: is the firing rate differently modified in fct of stimulation frequency

% INITIALIZATION
% COMPUTE +PLOT 1fig per neuron : for each stim freq, one point per event)
% COMPUTE +PLOT 1 figure per mouse: firing rate before/ during /after, normalized by 'before FR'
% PLOT, for all stim freq, for all neurons
% - FR during normalized by 'before FR' : 
% - Firing Rate modulation index

%% INITIALIZATION
sav=0
;
cd /media/DataMOBsRAIDN/ProjetAversion/SleepStim;
res=pwd;
Dir.path={
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161117';
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161123';
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126';
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170202';
};
choose_Py_or_IN='all_neu'; % can by  'Py' or 'IN' or 'all neu';
compute_FR=0;
plo_indiv_neurones=0;
plo_indiv_mice=0;
plo_FRdur_normBypre=0;
plo_FRMI=1;
corr_Kappa_FR_variation=0;
corr_Kappa_FRincrease_variation=0;
corr_KappaMI_FRMI=0;
corr_KappaMI_FRMI_4_10=1;
try 
    load Py_or_IN_ID
catch
    Py_or_IN=[];
    for man=1:length(Dir.path)
        cd(Dir.path{man})
        load('WaveformsSorted_Py_IN');
        Py_or_IN=[Py_or_IN;UnitID];
        clear UnitID 
    end
    cd(res)
    save Py_or_IN_ID Py_or_IN Dir
    clear UnitIDOld WFInfo
end
%% COMPUTE FIRING RATE BEFORE- DURING - AFTER
if compute_FR
    for man=1:length(Dir.path)
        
        cd(Dir.path{man})
        load StimInfo
        load ModNeurons_dur
        load SpikeData
        for fq=1:8,
            ind_OI{fq}=find(StimInfo.Freq==fq_list(fq));
        end

        stim_int_dur=subset(int_laser,ind_OI{1});
        stim_int_bef=shift(stim_int_dur,-30*1E4);
        stim_int_aft=shift(stim_int_dur,30*1E4);

        %%  for each neuron, firing rate increase for each stimulation frequency, for each stim event
        try 
            load FiringRateBeforeAfter
        catch
            FR=nan(3,length(NumNeurons),length(fq_list),50); 
            Mxfig=figure; 
            for num=1:length(NumNeurons);

                for fq=1:8
                    stim_int_dur=subset(int_laser,ind_OI{fq});
                    stim_int_bef=shift(stim_int_dur,-30*1E4);
                    stim_int_aft=shift(stim_int_dur,30*1E4);

                    for evt=1:length(Start(stim_int_dur))
                        FR(1,num,fq,evt)=[size(Data(Restrict(S{NumNeurons(num)},subset(stim_int_bef,evt))),1)/30];
                        FR(2,num,fq,evt)=[size(Data(Restrict(S{NumNeurons(num)},subset(stim_int_dur,evt))),1)/30];
                        FR(3,num,fq,evt)=[size(Data(Restrict(S{NumNeurons(num)},subset(stim_int_aft,evt))),1)/30];
                    end
                end
                if plo_indiv_neurones
                    figure('Position',[161         138        2542         460])
                    YLall=[];
                    for fq=1:8
                        SP{fq}=subplot(1,8,fq);
                        PlotErrorBarN(squeeze(FR(:,num,fq,:))',0);
                        xlabel([ num2str(fq_list(fq)) ' Hz']);
                        YL=ylim;
                        YLall=[YLall; YL];
                    end
                    for fq=1:8,
                        subplot(SP{fq});
                        ylim(max(YLall));
                    end  
                end
            end
            for num=1:length(NumNeurons);
                figure(Mxfig)
                Mx{num}=nanmean(squeeze(FR(:,num,:,:)),3);
                subplot(6,10,num);
                imagesc(Mx{num}');
            end

            if sav
                save FiringRateBeforeAfter FR fq_list NumNeurons
            end
        end
    end
end

%% ONE FIGURE PER MOUSE
%%  mean firing rate for each stimulation frequency 
%% mean firing rate increase for each stimulation frequency (normalised by pre)
cd /media/DataMOBsRAIDN/ProjetAversion/SleepStim
res=pwd;
try 
    load FiringRateBeforeAfter_allmice
catch
    FRall_1=[];
    FRall_2=[];
    FRall_3=[];
    for man=1:length(Dir.path)
        cd(Dir.path{man})
        mousename=Dir.path{man}(end-11:end-9);
        clear FR fq_list
        load FiringRateBeforeAfter FR fq_list

        FRall_1=[FRall_1;nanmean(squeeze(FR(1,:,:,:)),3)];
        FRall_2=[FRall_2;nanmean(squeeze(FR(2,:,:,:)),3)];
        FRall_3=[FRall_3;nanmean(squeeze(FR(3,:,:,:)),3)];

        FRperc_Fqfig_bar=figure('Position',[  93         409        3005         329]);     
        %FR_Fqfig_bar=figure('Position',[108          40        1853         329]);         
        for fq= 1:8

            FqMx{fq}=nanmean(squeeze(FR(:,:,fq,:)),3);
            FqMx_perc{fq}=nanmean(squeeze(FR(:,:,fq,:)),3)./[nanmean(squeeze(FR(1,:,fq,:)),2) nanmean(squeeze(FR(1,:,fq,:)),2) nanmean(squeeze(FR(1,:,fq,:)),2)]';

            figure(FRperc_Fqfig_bar);
            subplot(1,8,fq);
            PlotErrorBarN(FqMx_perc{fq}',0);
            xlabel([ num2str(fq_list(fq)) ' Hz']);
            ylim([0 2])
            if fq==1,
                ylabel('Firing rate norm by pre')
                text(-0.3,1.05,mousename,'units','normalized')
            end
            set(gca,'XTick',[1:3],'XTicklabel',{'pre','stim','post'}); 
    %         figure(FR_Fqfig_bar);
    %         subplot(1,8,fq);
    %         PlotErrorBarN(FqMx{fq}',0);
    %         xlabel([ num2str(fq_list(fq)) ' Hz']);
    %         if fq==1,ylabel('Firing rate norm by pre'),end
    %         set(gca,'XTick',[1:3],'XTicklabel',{'pre','stim','post'});
        end
        if sav
            cd (res)
            saveas(gcf,['FRperc_bef_aft_' mousename '.fig'])
            saveFigure(gcf,['FRperc_bef_aft_' mousename ],res)
        end
    end
    
    cd(res)
    save FiringRateBeforeAfter_allmice FRall_1 FRall_2 FRall_3  FqMx FqMx_perc Dir fq_list
end
%% FIGURE FOR ALL MICE ALL NEURONS : before-during-after
if plo_indiv_mice
    figure('Position',[  93         409        3005         329]);  
        for fq= 1:8

            subplot(1,8,fq);
    %         PlotErrorBarN([FRall_1(:,fq) FRall_2(:,fq) FRall_3(:,fq) ],0);hold on
            PlotErrorSpreadN_KJ([FRall_1(:,fq) FRall_2(:,fq) FRall_3(:,fq) ],'plotcolors',[0.7 0.7 0.7],'newfig',0,'markersize',5);hold on
            set(gca,'XTick',[1:3],'XTicklabel',{'pre','stim','post'});
            title([ num2str(fq_list(fq)) ' Hz']);
            if fq==1,
                ylabel('Firing rate norm by pre')
                text(-0.3,1.05,'all mice','units','normalized')
            end
        end
    if sav
        saveas(gcf,'FRperc_bar.fig')
        saveFigure(gcf,'FRperc_bar',res)
    end
end
%% FIGURE FOR ALL MICE ALL NEURONS : 
if strcmp(choose_Py_or_IN,'Py')
    FRall_1=FRall_1(Py_or_IN==1,:);
    FRall_2=FRall_2(Py_or_IN==1,:);
    color2plot=[0 0 1];
elseif strcmp(choose_Py_or_IN,'IN')
    FRall_1=FRall_1(Py_or_IN==-1,:);
    FRall_2=FRall_2(Py_or_IN==-1,:);
    color2plot=[1 0 0];
else
    color2plot=[0.7 0.7 0.7];
end

%% FR during normalized by pre
if plo_FRdur_normBypre
    
    FRdur=figure('Position',[ 1956         489        1048         444]);
    subplot(121)
    PlotErrorBarN(FRall_2./FRall_1 ,0);hold on 
    p=anova1(FRall_2./FRall_1 );close: close;
    figure(FRdur);
    title([' anova1, p= ' sprintf('%0.3f',p)])
    YL=ylim;
    clear p
    for fq=1:length(fq_list)
        [h,p{fq},ci,stats] = ttest(FRall_2(:,fq),FRall_1(:,fq)); % paired t-test
    %     [h,p{fq},ci,stats] = ttest(FRall_2(:,fq)./FRall_1(:,fq),1);
        if p{fq}<0.001,text2plot='***';elseif p{fq}<0.01,text2plot='**';elseif p{fq}<0.05,text2plot='*';else text2plot='';end
        text(fq, 0.9*(YL(2)),text2plot,'color','k')
        clear text2plot
    end
    set(gca,'XTick',[1:8],'XTickLabel',fq_list)
    ylabel('Firing rate norm by pre')
    xlabel('k: paired t-test before-during   r :comp to 1st col')

    subplot(122)
    PlotErrorSpreadN_KJ(FRall_2./FRall_1,'plotcolors',color2plot,'newfig',0,'markersize',5);hold on
    [p,anovatab,stats] = kruskalwallis(FRall_2./FRall_1);close: close;
    figure(FRdur); 
    subplot(122), hold on, title([' kruskal, p= ' sprintf('%0.3f',p)])
    for fq=1:length(fq_list)
        YL=ylim;
        p=signrank(FRall_2(:,fq),FRall_1(:,fq));
        if p<0.001,text2plot='***';elseif p<0.01,text2plot='**';elseif p<0.05,text2plot='*';else text2plot='';end
        text(fq, 0.9*(YL(2)),text2plot,'color','k')
       clear p text2plot
    end
    set(gca,'XTickLabel',fq_list)
    xlabel('k: signrank before-during')
    XL=xlim; plot([0 XL(2)],[1 1], '-','Color',[0.5 0.5 0.5])
end
%% FR modulation index pre/dur
if plo_FRMI
    FR_MI=(FRall_2-FRall_1)./(FRall_1 +FRall_2);
    p=anova1(FR_MI );close: close;
    FRMIfig=figure('Position',[ 1956         489        1048         444]);
    subplot(121)
    PlotErrorBarN((FRall_2-FRall_1)./(FRall_1 +FRall_2),0);hold on
    title([' anova1, p= ' sprintf('%0.3f',p)])
    set(gca,'XTickLabel',fq_list)
    subplot(122)
    PlotErrorSpreadN_KJ((FRall_2-FRall_1)./(FRall_1 +FRall_2),'plotcolors',color2plot,'newfig',0,'markersize',5);hold on
    [p,anovatab,stats] = kruskalwallis(FR_MI);close: close;
    hold on, title([' kruskal, p= ' sprintf('%0.3f',p)])
    for fq=1:length(fq_list)
        YL=ylim;
        [h,p]=ttest(FR_MI(:,fq));
        if p<0.001,text2plot='***';elseif p<0.01,text2plot='**';elseif p<0.05,text2plot='*';else text2plot='';end
        text(fq, 0.9*(YL(2)),text2plot,'color','k')
       clear p text2plot
    end
    set(gca,'XTickLabel',fq_list)
    xlabel('stars: t-test')
    if sav
        saveas(gcf,['FRMI_allmice_' choose_Py_or_IN '.fig'])
        saveFigure(gcf,['FRMI_allmice_' choose_Py_or_IN ],res)
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FR modulation index 4/10Hz
FR_MI_4_10=(FRall_2(:,3)-FRall_2(:,5))./(FRall_2(:,3)+FRall_2(:,5));
figNormality=figure('Position',[2002         486         600         335]); 
subplot(121),hist(FR_MI_4_10,25), 
[h,p_li,kstat] = lillietest(FR_MI_4_10);% Lilliefors
[h,p_jb,jbstat] = jbtest(FR_MI_4_10);% Jarques-Bera
[H, p_sw, SWstatistic] = swtest(FR_MI_4_10); % Shapiro -Wilks
title(['lillie p '  sprintf('%0.2f', p_li) ', JB p ' sprintf('%0.2f', p_jb) ', S-Wilks p ' sprintf('%0.2f', p_sw)])

fig_FRMI_and_corr=figure('Position',[2002         486         600         335]); 
subplot(121),
plotSpread(FR_MI_4_10,'distributionColors',color2plot);
line(1+[-0.2 0.2],median(FR_MI_4_10)+[0 0],'Color','k','Linewidth',2);

% [p_mw, h, stats]=ranksum(FRall_2(:,3),FRall_2(:,5));
[p_sr, h, stats]=signrank(FR_MI_4_10);

% PlotErrorSpreadN_KJ(FR_MI_4_10,'plotcolors',color2plot,'newfig',0,'markersize',5);
[h,p_tt]=ttest(FR_MI_4_10);
ylabel(' FR MI 4Hz - 10Hz')
xlabel(['signrank ' sprintf('%0.2f', p_sr) '/ t-test ' sprintf('%0.2f', p_tt)])
% title(['not normal, ranksum FR 4 vs 10 Hz p ' sprintf('%0.2f', p_mw) ])
title(['not normal, median plotted'])
set(gca,'XTickLabel','')
ylim([-0.6 0.6])
if sav
   saveas(gcf,['FRMI_4_10_allmice_' choose_Py_or_IN '.fig'])
    saveFigure(gcf,['FRMI_4_10_allmice_' choose_Py_or_IN ],res) 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% correlation Kappa MI /FR modulation index 4/10Hz
if corr_KappaMI_FRMI_4_10
    load ModNeurons_dur
    Kappa_MI_4_10=(Kappa(:,3)-Kappa(:,5))./(Kappa(:,3)+Kappa(:,5));
   if strcmp(choose_Py_or_IN,'Py')
        Kappa_MI_4_10=Kappa_MI_4_10(Py_or_IN==1,:);
    elseif strcmp(choose_Py_or_IN,'IN')
        Kappa_MI_4_10=Kappa_MI_4_10(Py_or_IN==-1,:);
   end

figure(figNormality)
subplot(122),hist(Kappa_MI_4_10,25), hold on
[h,p_li,kstat] = lillietest(Kappa_MI_4_10);% Lilliefors
[h,p_jb,jbstat] = jbtest(Kappa_MI_4_10);% Jarques-Bera
[H, p_sw, SWstatistic] = swtest(Kappa_MI_4_10); % Shapiro -Wilks
title(['lillie p '  sprintf('%0.2f', p_li) ', JB p ' sprintf('%0.2f', p_jb) ', S-Wilks p ' sprintf('%0.2f', p_sw)])

   figure(fig_FRMI_and_corr)
   subplot(122),
plot(FR_MI_4_10,Kappa_MI_4_10,'.','Color',color2plot)
[r1,p1]=corr(Kappa_MI_4_10(~isnan(Kappa_MI_4_10)),FR_MI_4_10(~isnan(Kappa_MI_4_10)),'type','Spearman');
title(['Spearman Rho p '  sprintf('%0.2f', r1) ',  p ' sprintf('%0.2f', p1) ])
xlabel('FR MI 4Hz - 10Hz')
ylabel('Kappa MI 4Hz - 10Hz')
xlim([-0.6 0.6])
if sav
   saveas(gcf,['FRMI_4_10_allmice_' choose_Py_or_IN '.fig'])
    saveFigure(gcf,['FRMI_4_10_allmice_' choose_Py_or_IN ],res) 
       saveas(gcf,['FRMI_4_10_allmice_' choose_Py_or_IN '_normalityfig'])
    saveFigure(gcf,['FRMI_4_10_allmice_' choose_Py_or_IN '_normality'],res) 
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% correlation Kappa/firing rate increase
if corr_Kappa_FRincrease_variation

    load ModNeurons_dur
    K=Kappa;
    K(pval>0.05)=nan;
    if strcmp(choose_Py_or_IN,'Py')
        K=K(Py_or_IN==1,:);
        Kappa=Kappa(Py_or_IN==1,:);
    elseif strcmp(choose_Py_or_IN,'IN')
        K=K(Py_or_IN==-1,:);
        Kappa=Kappa(Py_or_IN==-1,:);
    end

    FRall_2_normBy1=FRall_2./FRall_1;
    FRall_2_normBy1_sig=FRall_2_normBy1;
    FRall_2_normBy1_sig(isnan(K))=nan;
    
    Cor_FRperc_KappaFig=figure('Position',[  93         409        3005         329]);          
    YLall=[];XLall=[];
    for fq= 1:8
        SP{fq}=subplot(1,8,fq);hold on
        plot(FRall_2_normBy1(:,fq),Kappa(:,fq),'.k')
        plot(FRall_2_normBy1(:,fq),K(:,fq),'.','Color',color2plot)
        [r1,p1]=corr(FRall_2_normBy1(:,fq),Kappa(:,fq),'type','Pearson');
        
        [r2,p2]=corr(FRall_2_normBy1_sig(~isnan(FRall_2_normBy1_sig(:,fq)),fq),K(~isnan(K(:,fq)),fq),'type','Pearson');
        
        xlabel([ 'all R ' sprintf('%.2f',(r1)) '  p ' sprintf('%.2f',(p1)) ])
        title (['sig R ' sprintf('%.2f',(r2)) '  p ' sprintf('%.2f',(p2))],'Color',color2plot)
        
        ylabel([ num2str(fq_list(fq)) ' Hz']);
%         xlabel('firing rate increase')
        if fq==1,ylabel('Kappa'),end
        YL=ylim;
        XL=xlim;
        XLall=[XLall; XL];
        YLall=[YLall; YL];
    end

    for fq=1:8
        subplot(SP{fq});
        ylim([min(min(YLall)) max(max(YLall))]);
        xlim([min(min(XLall)) max(max(XLall))]);
        plot([1 1],[0 max(max(YLall))],'Color',[0.7 0.7 0.7])
    end
     if sav
        cd(res)
        saveas(gcf,'FRperc_Kappa_corr.fig')
        saveFigure(gcf,'FRperc_Kappa_corr',res)
    end 
end
    %% correlation Kappa Modulation Index /firing rate Modulation Index
if corr_KappaMI_FRMI

load ModNeurons_dur
Kappa1=Kappa;
load ModNeurons_bef
Kappa2=Kappa;
KappaMI=(Kappa2-Kappa1)./(Kappa1+Kappa2);
FRall_MI=(FRall_2-FRall_1)./(FRall_1+FRall_2);
if strcmp(choose_Py_or_IN,'Py')
    KappaMI=KappaMI(Py_or_IN==1,:);
elseif strcmp(choose_Py_or_IN,'IN')
    KappaMI=KappaMI(Py_or_IN==-1,:);
end

Cor_FRMI_KappaMI_Fig=figure('Position',[93         409        2942         288]);          
YLall=[];XLall=[];
for fq= 1:8
    SP{fq}=subplot(1,8,fq);hold on
    plot(FRall_MI(:,fq),KappaMI(:,fq),'.k')
%     plot(FRall_2_normBy1(:,fq),K(:,fq),'.','Color',color2plot)
    [r1,p1]=corr(FRall_MI(~isnan(KappaMI(:,fq)),fq),KappaMI(~isnan(KappaMI(:,fq)),fq),'type','Pearson');

%     [r2,p2]=corr(FRall_2_normBy1_sig(~isnan(FRall_2_normBy1_sig(:,fq)),fq),K(~isnan(K(:,fq)),fq),'type','Pearson');

    title([ 'all R ' sprintf('%.2f',(r1)) '  p ' sprintf('%.2f',(p1)) ])
%     title (['sig R ' sprintf('%.2f',(r2)) '  p ' sprintf('%.2f',(p2))],'Color',color2plot)

    ylabel(['Kappa' num2str(fq_list(fq)) ' Hz']);

   
    YL=ylim;
    XL=xlim;
    XLall=[XLall; XL];
    YLall=[YLall; YL];
end
    
    if sav
        cd(res)
        saveas(gcf,['FRMI_KappaMI_corr_' choose_Py_or_IN '.fig'])
        saveFigure(gcf,['FRMI_KappaMI_corr_' choose_Py_or_IN ],res)
    end 
    
    

end




    %% correlation Kappa/firing rate
if corr_Kappa_FR_variation
    Cor_FR_KappaFig=figure('Position',[  93         409        3005         329]);  
        for fq= 1:8
        SP{fq}=subplot(1,8,fq);hold on
        plot(FqMx{fq}(2,:)',Kappa(:,fq),'.')
        plot(FqMx{fq}(2,:)',K(:,fq),'.r')
        title([ num2str(fq_list(fq)) ' Hz']);
        xlabel('firing rate')
        if fq==1,ylabel('Kappa'),end
        ylim([0 0.5])
        end
    if sav
        cd(res)
        saveas(gcf,'FRdur_Kappa_corr.fig')
        saveFigure(gcf,'FRdur_Kappa_corr',res)
    end 
end

if 0
    %% y a t-til une difference de baseline entre les stim frequencies ? 
    figure('Position',[   93   115   915   623]); 
    subplot(121)
    PlotErrorSpreadN_KJ(nanmean(squeeze(FR(1,:,:,:)),3),'plotcolors',[0.7 0.7 0.7],'newfig',0)
    ylabel('firing rate')
    xlabel('stim frequency')
    subplot(122)
    PlotErrorBarN(nanmean(squeeze(FR(1,:,:,:)),3),0);
    ylabel('firing rate')
    xlabel('stim frequency')
    [p,anovatab,stats] = kruskalwallis(nanmean(squeeze(FR(1,:,:,:)),3));
    title(['kruskal p = ' num2str(p)])
end