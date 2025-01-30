% RampOver1Day_quantifPlot_OB_PFC_HPC_Picx_sub.m

% RampOver1Day_quantifPlot_OB_PFC_HPC_Picx.m but deals with LFP36, that is
% the local HPC signal (substraction)
% saved 04.05.2017
% started with RampOver1Day_quantifPlot.m 27.02.2017

% this codes evalues the efficiency of the stimulation for each mouse
% (computes power in the stimulation band)

% FIGURES
% for all mice separately : 
%     - power before stim (---) & during stim (continuous) 
%     - difference (during stim) - (before stim)
%     - percentage of increase during stim : (during-before) / during

% for all mice averaged : 
%     - power before stim (---) & during stim (continuous) 
%     - difference (during stim) - (before stim)
%     - percentage of increase during stim : (during-before) / during
%     - difference (during-before) normalized by power at 1Hz  out of stim    (impedence normalization) : "Diff_norm"
%     - difference (during-before) normalized by power during 20Hz stim ("infection" normalization)

% ratio PFC / bulb

% DATA
% saved as RampOver1Day_quantifPlot.mat
%  type of figure:
allmice_plo=1;
avg_plo=1;
ratio_plo=0;
% measures
perc_plo=0;
ratio_PFC_OB_plo=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS
Dir=PathForExperimentFEAR(experiment,datatype,check);
Dir.path={
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161116';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161117';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161123';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170127';
%     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170130';
%     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170131';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170202';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170203';
%     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170207';
%     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170208';
};

for k=1:length(Dir.path)
    ind_mouse=strfind(Dir.path{k},'Mouse');
    Dir.name{k}=Dir.path{k}(ind_mouse:ind_mouse+7);
end
% Dir.path={
% '/media/DataMOBs61/Mouse-540/FEAR-Mouse-540-21092017';  
% '/media/DataMOBs61/Mouse-542/FEAR-Mouse-542-20092017';
% '/media/DataMOBs61/Mouse-543/FEAR-Mouse-543-19092017';
% };
% res='/media/DataMOBsRAIDN/ProjetAversion/RampOver1dayQuantif/Ramp_4_no_selection/3mice_july17';
% for k=1:length(Dir.path)
%     ind_mouse=strfind(Dir.path{k},'Mouse');
%     Dir.name{k}=Dir.path{k}(ind_mouse(1):ind_mouse(1)+8);
% end

% Dir.path={
% '/media/DataMOBs61/Mouse496/20170404/FEAR-Mouse-496-04042017';  
% '/media/DataMOBs61/Mouse496/20170407/FEAR-Mouse-496-07042017';
% '/media/DataMOBs61/Mouse497/20170405/FEAR-Mouse-497-05042017';
% '/media/DataMOBs61/Mouse497/20170409_attention_rec_du_20170410/FEAR-Mouse-497-09042017';
% };
% res='/media/DataMOBsRAIDN/ProjetAversion/RampOver1dayQuantif/Ramp_4_no_selection/2mice_march17';
% for k=1:length(Dir.path)
%     ind_mouse=strfind(Dir.path{k},'Mouse');
%     Dir.name{k}=Dir.path{k}(ind_mouse(2):ind_mouse(2)+8);
% end


mousenames={'458';'458';'459';'465';'465';'466';'466';'467';'467';'468';'468'};
sav=0;
if 0
    cd /media/DataMOBsRAIDN/ProjetAversion/RampOver1dayQuantif/Ramp_4_no_selection
    load(['DataRampOver1DayQuantif_no_selection.mat']);
    disp(['Loading existing data from DataRampOver1DayQuantif_no_selection.mat']);
end

structlist={'Bulb_deep_right','Bulb_deep_left','PFCx_deep_right','PFCx_deep_left','dHPC_rip','PiCx_right','PiCx_left','dHPC_local'};
colori={'b','b','r','r','c','g','g','c'};
res=pwd;
margin=0.5; % with of the frequency band: ex : [7Hz-margin 7Hz+margin]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZATION 
ind_2remov_by_stt=zeros(length(Dir.path),length(structlist));
%remove : PiCx 468
ind_2remov_by_stt([10 11],6)=1;

if allmice_plo
    BefDurPlot=figure('Position',[   1968         113        1782         862]);        
    DiffPlot=figure('Position',[   1968         113        1782         862]);  
    DiffPercPlot=figure('Position',[   1968         113        1782         862]);  
    DiffNormPlot=figure('Position',[   1968         113        1782         862]);  
    BefDurRatioPlot=figure('Position',[   1968         113        1782         862]);  
    PFC_OB_ratioplot=figure('Position',[   1968         113        1782         500]);  
end
clear Mx_mean_before Mx_std_before Mx_mean_during Mx_std_during Mx_DiffPerc_mean Mx_DiffPerc_std Mx_Diff_norm_mean Mx_Diff_norm_std

Mx_mean_before=nan(length(Dir.path),length(structlist),nb_fq);
Mx_std_before=nan(length(Dir.path),length(structlist),nb_fq);

Mx_mean_during=nan(length(Dir.path),length(structlist),nb_fq);
Mx_std_during=nan(length(Dir.path),length(structlist),nb_fq);
PowerForNorm_m=nan(length(Dir.path),length(structlist));

Mx_DiffPerc_mean=nan(length(Dir.path),length(structlist),nb_fq);
Mx_DiffPerc_std=nan(length(Dir.path),length(structlist),nb_fq);

Mx_Diff_norm_mean=nan(length(Dir.path),length(structlist),nb_fq);
Mx_Diff_norm_std=nan(length(Dir.path),length(structlist),nb_fq);

Ratio_mean=nan(length(Dir.path),length(structlist),nb_fq);
Ratio_std=nan(length(Dir.path),length(structlist),nb_fq);

fq_list_mx=[];
for man=1:length(Dir.path)
    fq_list_mx=[fq_list_mx;fq_list'];
end

%%% COMPUTE - power at stimulation frequency - MOUSE BY MOUSE
try 
    load RampOver1Day_quantifPlot_dHPCsub.mat
catch
    for man=1:length(Dir.path), 

        clear  bbb ddd bbb_mean ddd_mean bbb_std ddd_std bbb_sem ddd_sem

        for i=1:length(structlist)

        % pour la normalisation par la puissance a 1Hz hors stim
        % je prends la valeur du LFP before stim pour les stim 1hz (trop compliquée et peu de plus value de récuperer cette valeur pour toutes les stimulation frequencies 
            fq=1;
            PowerForNorm=squeeze(LFPpower_Before(1,i,man,:,2:5,fq));
            ind_non_zero_PFN=~(nansum(PowerForNorm,2)==0);
            PowerForNorm_m(man,i)=nanmean(nanmean(PowerForNorm(ind_non_zero_PFN,:)));

            for fq=1:nb_fq

                bbb=squeeze(LFPpower_Before(1,i,man,:,:,fq));% bb before
                ddd=squeeze(LFPpower(1,i,man,:,:,fq));% dd during
                ind_non_zero=~(nansum(ddd,2)==0);

                StimFreq=[fq_list(fq)-margin fq_list(fq)+margin];
                ind_StiFq=(f1>StimFreq(1) & f1<StimFreq(2));

                bbb=bbb(ind_non_zero,ind_StiFq);
                ddd=ddd(ind_non_zero,ind_StiFq);

                Mx_mean_before(man,i,fq)=nanmean(nanmean(bbb,2));
                Mx_std_before(man,i,fq)=nanstd(nanmean(bbb,2));

                Mx_mean_during(man,i,fq)=nanmean(nanmean(ddd,2));
                Mx_std_during(man,i,fq)=nanstd(nanmean(ddd,2));    

                Mx_DiffPerc_mean(man,i,fq)=nanmean(nanmean(ddd-bbb,2)./nanmean(bbb,2))*100;
                Mx_DiffPerc_std(man,i,fq)=nanstd(nanmean(ddd-bbb,2)./nanmean(bbb,2))*100;

                Mx_Diff_mean(man,i,fq)=nanmean(nanmean(ddd-bbb,2));
                Mx_Diff_std(man,i,fq)=nanstd(nanmean(ddd-bbb,2));

                Mx_Diff_norm_mean(man,i,fq)=nanmean(nanmean(ddd-bbb,2))/PowerForNorm_m(man,i);
                Mx_Diff_norm_std(man,i,fq)=nanstd(nanmean(ddd-bbb,2)/PowerForNorm_m(man,i));
                
                Mx_Ratio_mean(man,i,fq)=nanmean(nanmean(ddd./bbb,2));   
                Mx_Ratio_std(man,i,fq)=nanstd(nanmean(ddd./bbb,2));   
                %plot(fq_list(fq),nanmean(ddd(ind_non_zero,ind_StiFq),2),'o','Color',colori{i}), hold on
            end
        end
    end
    if sav
        save RampOver1Day_quantifPlot.mat Mx_mean_before Mx_std_before Mx_mean_during Mx_std_during ...
            Mx_DiffPerc_mean Mx_DiffPerc_std Mx_Diff_mean Mx_Diff_std Mx_Diff_norm_mean Mx_Diff_norm_std Mx_Ratio_mean Mx_Ratio_std  nb_fq fq_list
    end
end

for man=1:length(Dir.path), 

    clear  bbb ddd bbb_mean ddd_mean bbb_std ddd_std bbb_std ddd_std

    bbb_mean=squeeze(Mx_mean_before(man,:,:));
    bbb_std=squeeze(Mx_std_before(man,:,:));
    bbb_sem=squeeze(Mx_std_before(man,:,:))/ sqrt(size(squeeze(Mx_mean_before(man,:,:)),1));

    ddd_mean=squeeze(Mx_mean_during(man,:,:));
    ddd_std=squeeze(Mx_std_during(man,:,:));
    ddd_sem=squeeze(Mx_std_during(man,:,:))/ sqrt(size(squeeze(Mx_std_during(man,:,:)),1));

    perc_mean=squeeze(Mx_DiffPerc_mean(man,:,:));
    perc_std=squeeze(Mx_DiffPerc_std(man,:,:));
    perc_sem=squeeze(Mx_DiffPerc_std(man,:,:))/ sqrt(size(squeeze(Mx_DiffPerc_std(man,:,:)),1));
    
    Mx_Diff_mean_=squeeze(Mx_Diff_mean(man,:,:)); % equiv to ddd_mean-bbb_mean
    Mx_Diff_mean_std_=squeeze(Mx_Diff_std(man,:,:));
    Mx_Diff_mean_sem_=squeeze(Mx_Diff_std(man,:,:))/ sqrt(size(squeeze(Mx_Diff_mean(man,:,:)),1));
                
    % normalized by the power at 1Hz
    Mx_Diff_mean_norm=squeeze(Mx_Diff_norm_mean(man,:,:));
    Mx_Diff_std_norm=squeeze(Mx_Diff_norm_std(man,:,:));
    diff_sem_norm=squeeze(Mx_Diff_norm_std(man,:,:))/ sqrt(size(squeeze(Mx_Diff_norm_std(man,:,:)),1));
    
    ratio_mean=squeeze(Mx_Ratio_mean(man,:,:));
    ratio_std=squeeze(Mx_Ratio_std(man,:,:));
    ratio_sem=squeeze(Mx_Ratio_std(man,:,:))/ sqrt(size(squeeze(Mx_Ratio_std(man,:,:)),1));
    
    for i=1:length(structlist)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if allmice_plo
            figure(BefDurPlot)
            subplot(length(structlist),length(Dir.path),(i-1)*length(Dir.path)+man)
            errorbar(fq_list, bbb_mean(i,:),bbb_sem(i,:),'Color',colori{i},'LineStyle','--'), hold on
            errorbar(fq_list, ddd_mean(i,:),ddd_sem(i,:),'Color',colori{i}, 'LineWidth', 2)
    %         if strfind(structlist{i}, 'Bulb'),  ylim([0 50]), elseif strfind(structlist{i}, 'PFC'), ylim([0 15]), end
            xlim([0 20 ])
            if i==1, title([Dir.path{man}(end-11:end-9) '-' Dir.path{man}(end-7:end)]), end
            if man==1, ylabel(structlist{i}), end
            %YL=ylim; ylim([0 YL(2)])
             if i==1 && man==1
                text(-0.8,1.25,'before (--- ) during (cont)   mean +/- sem','units','normalized')
             end
            if ind_2remov_by_stt(man,i), text(0.3,0.5,'bad LFP','units','normalized','fontsize',15),end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if perc_plo
                figure(DiffPercPlot)
                subplot(length(structlist),length(Dir.path),(i-1)*length(Dir.path)+man)
                errorbar(fq_list, perc_mean(i,:),perc_sem(i,:),'Color',colori{i}, 'LineWidth', 2)
                if i==1, title([Dir.path{man}(end-11:end-9) '-' Dir.path{man}(end-7:end)]), end
                if man==1, ylabel(structlist{i}), end
               % YL=ylim; ylim([0 YL(2)])
                xlim([0 20 ])
        %         if strfind(structlist{i}, 'Bulb'),  ylim([0 50]), elseif strfind(structlist{i}, 'PFC'), ylim([0 15]), end
                 if i==1 && man==1
                    text(-0.8,1.25,'percentage   mean +/- sem','units','normalized')
                 end
            end
            if ind_2remov_by_stt(man,i), text(0.3,0.5,'bad LFP','units','normalized','fontsize',15),end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            figure(DiffPlot)
            subplot(length(structlist),length(Dir.path),(i-1)*length(Dir.path)+man)
            errorbar(fq_list, Mx_Diff_mean_(i,:),Mx_Diff_mean_sem_(i,:),'Color',colori{i}, 'LineWidth', 2)
            if i==1, title([Dir.path{man}(end-11:end-9) '-' Dir.path{man}(end-7:end)]), end
            if man==1, ylabel(structlist{i}), end
            xlim([0 20 ])
            %YL=ylim; ylim([0 YL(2)])
    %         if strfind(structlist{i}, 'Bulb'),  ylim([0 50]), elseif strfind(structlist{i}, 'PFC'), ylim([0 15]), end
            if i==1 && man==1
                text(-0.8,1.25,'difference   mean +/- sem','units','normalized')
            end
            if ind_2remov_by_stt(man,i), text(0.3,0.5,'bad LFP','units','normalized','fontsize',15),end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            figure(BefDurRatioPlot)
            subplot(length(structlist),length(Dir.path),(i-1)*length(Dir.path)+man)
            errorbar(fq_list, ratio_mean(i,:),ratio_sem(i,:),'Color',colori{i}, 'LineWidth', 2)        
            if i==1, title([Dir.path{man}(end-11:end-9) '-' Dir.path{man}(end-7:end)]), end
            if man==1, ylabel(structlist{i}), end
            xlim([0 20 ])
            %YL=ylim; ylim([0 YL(2)])
    %         if strfind(structlist{i}, 'Bulb'),  ylim([0 50]), elseif strfind(structlist{i}, 'PFC'), ylim([0 15]), end
            if i==1 && man==1
                text(-0.8,1.25,'ratio during / before    mean +/- sem','units','normalized')
            end
            if ind_2remov_by_stt(man,i), text(0.3,0.5,'bad LFP','units','normalized','fontsize',15),end
        
        end
    end
     %%%%%%%%%%%%%%%%%% EN COURS - not fully correct (ratio of mean instead of mean of ratio)
    if ratio_PFC_OB_plo
         figure(PFC_OB_ratioplot)
        subplot(2,length(Dir.path),man)
        plot(fq_list, ddd_mean(3,:)./ddd_mean(1,:),'Color','k', 'LineWidth', 2)

        subplot(2,length(Dir.path),length(Dir.path)+man)
        plot(fq_list, ddd_mean(4,:)./ddd_mean(2,:),'Color','k', 'LineWidth', 2)
    end

    if i==1, title([Dir.path{man}(end-11:end-9) '-' Dir.path{man}(end-7:end)]), end
    if man==1, ylabel(structlist{i}), end
    xlim([0 20 ])
%         if strfind(structlist{i}, 'Bulb'),  ylim([0 50]), elseif strfind(structlist{i}, 'PFC'), ylim([0 15]), end
    if i==1 && man==1
        text(-0.8,1.25,'ratio during / before    mean +/- sem','units','normalized')
    end
end
% if 0
    if sav
        saveas(BefDurPlot,'power_at_stim_fq_mouse_by_mouse.fig')
        saveFigure(BefDurPlot,'power_at_stim_fq_mouse_by_mouse',res)

        saveas(DiffPercPlot,'powerperc_at_stim_fq_mouse_by_mouse.fig')
        saveFigure(DiffPercPlot,'powerperc_at_stim_fq_mouse_by_mouse',res)

        saveas(DiffPlot,'diff_at_stim_fq_mouse_by_mouse.fig')
        saveFigure(DiffPlot,'diff_at_stim_fq_mouse_by_mouse',res)
        
        saveas(DiffNormPlot,'normdiff_at_stim_fq_mouse_by_mouse.fig')
        saveFigure(DiffNormPlot,'normdiff_at_stim_fq_mouse_by_mouse',res)

        saveas(BefDurRatioPlot,'befdur_ratio_mouse_by_mouse.fig')
        saveFigure(BefDurRatioPlot,'befdur_ratio_mouse_by_mouse',res)

        
    end
% end


%%%%%%%%%%%%%%%%% REMOVE MICE FOR WHICH STIMULATION IS UNEFFICIENT

if 1
%     ampl_th=200;
    ampl_th=1000;
    ind_right_2remov=(squeeze(Mx_DiffPerc_mean(:,1,8))<ampl_th);
    ind_left_2remov=(squeeze(Mx_DiffPerc_mean(:,2,8))<ampl_th);

    Mx_mean_during(ind_right_2remov,[1 3],:)=nan;
    Mx_mean_during(ind_left_2remov,[2 4],:)=nan;

    Mx_mean_before(ind_right_2remov,[1 3],:)=nan;
    Mx_mean_before(ind_left_2remov,[2 4],:)=nan;

    Mx_DiffPerc_mean(ind_right_2remov,[1 3],:)=nan;
    Mx_DiffPerc_mean(ind_left_2remov,[2 4],:)=nan;

    Mx_Diff_norm_mean(ind_right_2remov,[1 3],:)=nan;
    Mx_Diff_norm_mean(ind_left_2remov,[2 4],:)=nan;

    Mx_Diff_mean(ind_right_2remov,[1 3],:)=nan;
    Mx_Diff_mean(ind_left_2remov,[2 4],:)=nan;
    
    Mx_Ratio_mean(ind_right_2remov,[1 3],:)=nan;
    Mx_Ratio_mean(ind_left_2remov,[2 4],:)=nan;
            
        mousenamesright=mousenames(~ind_right_2remov);
        mousenamesleft=mousenames(~ind_left_2remov);
end
ind_not_efficient= [ind_right_2remov ind_left_2remov ind_right_2remov ind_left_2remov ind_right_2remov ind_right_2remov ind_left_2remov];
figure(BefDurPlot)
for man=1:length(Dir.path)
    for i=1:length(structlist)
        subplot(length(structlist),length(Dir.path),(i-1)*length(Dir.path)+man), hold on 
       % if ind_not_efficient(man,i), text(0.3,0.7,'not eff','units','normalized','fontsize',12),end
        if ind_not_efficient(man,i), text(0.3,0.7,'X','units','normalized','fontsize',12),end
        if i==length(structlist)&&man==1,text(0.3,-0.5,['X : removed by OB efficiency thresh ' num2str(ampl_th)],'units','normalized','fontsize',12),end
    end
end
figure(DiffPlot)
for man=1:length(Dir.path)
    for i=1:length(structlist)
        subplot(length(structlist),length(Dir.path),(i-1)*length(Dir.path)+man), hold on 
       % if ind_not_efficient(man,i), text(0.3,0.7,'not eff','units','normalized','fontsize',12),end
        if ind_not_efficient(man,i), text(0.3,0.7,'X','units','normalized','fontsize',12),end
    end
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% AVERAGE ON ALL MICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% power at stimulation frequency - BEFORE AND DURING
if avg_plo
    
h_mice_mean=figure('Position',[20         66         306         911]); 
for i=1:length(structlist)
    
    mm_dur=squeeze(Mx_mean_during(:,i,:));
    mm_bef=squeeze(Mx_mean_before(:,i,:));
    subplot(length(structlist),1,i)
    errorbar(fq_list, nanmean(mm_dur,1), nanstd(mm_dur,1)/sqrt(sum(~isnan(mm_dur(:,1)))),colori{i},'LineWidth',2), hold on
    errorbar(fq_list, nanmean(mm_bef,1), nanstd(mm_bef,1)/sqrt(sum(~isnan(mm_bef(:,1)))),colori{i},'LineStyle','--')
    if i==1,  title(' Power During and Before '), end
    if i==length(structlist),  xlabel('mean +/- sem'), end;
    YL=ylim;
    for fq=1:8
        p{fq}=signrank(Mx_mean_during(:,i,fq),Mx_mean_before(:,i,fq));
        if p{fq}<0.01
            text(fq_list(fq), 0.9*YL(2),'**')
        elseif p{fq}<0.05
            text(fq_list(fq), 0.9*YL(2),'*')
        end
    end        
end
if sav
    saveas(h_mice_mean,'power_at_stim_fq_all_mice.fig')
    saveFigure(h_mice_mean,'power_at_stim_fq_all_mice',res)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  ratio DURING / BEFORE
 % 1er graphe inapproprié car le ratio des moyennes n'est pas la moyenne des ratios 

h_mice_dur_bef_ratio=figure('Position',[350       66         306         911]); 
for i=1:length(structlist)
    
    mm_dur=squeeze(Mx_mean_during(:,i,:));
    mm_bef=squeeze(Mx_mean_before(:,i,:));
    
    figure(h_mice_dur_bef_ratio)
    subplot(length(structlist),1,i)
    plot(fq_list, mm_dur./mm_bef), hold on
    errorbar(fq_list, nanmean(mm_dur./mm_bef,1), nanstd(mm_dur./mm_bef,1)/sqrt(sum(~isnan(mm_bef(:,1)))),colori{i},'LineWidth',2),
    if i==1,  title(' Power ratio During/Before '), end
    if i==length(structlist),  xlabel('mean +/- sem'), end
      
end
% legend(mousenames)
if sav
    saveas(h_mice_dur_bef_ratio,'power_during_before_ratio_all_mice.fig')
    saveFigure(h_mice_dur_bef_ratio,'power_during_before_ratio_all_mice',res)  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  ratio DURING / BEFORE - by event
 % moyenne des ratios calculés pour chaque event
h_mice_dur_bef_ratio_by_evt=figure('Position',[700        66         306         911]); 
for i=1:length(structlist)
    mm_ratio=squeeze(Mx_Ratio_mean(:,i,:));
    subplot(length(structlist),1,i)
    errorbar(fq_list, nanmean(mm_ratio,1), nanstd(mm_ratio,1)/sqrt(sum(~isnan(mm_ratio(:,1)))),colori{i},'LineWidth',2), hold on
    if i==1,  title(' Ratio During /Before '), end
    if i==length(structlist),  xlabel('mean +/- sem'), end;
    YL=ylim;
end
if sav
    saveas(h_mice_dur_bef_ratio_by_evt,'power_dur_bef_ratio_by_evt_all_mice.fig')
    saveFigure(h_mice_dur_bef_ratio_by_evt,'power_dur_bef_ratio_by_evt_all_mice',res)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  difference DURING - BEFORE
h_mice_dur_bef=figure('Position',[950        66         306         911]); 
for i=1:length(structlist)
    mm_dur=squeeze(Mx_mean_during(:,i,:));
    mm_bef=squeeze(Mx_mean_before(:,i,:));
    subplot(length(structlist),1,i)
    plot(fq_list, mm_dur-mm_bef), hold on
    errorbar(fq_list, nanmean(mm_dur-mm_bef,1), nanstd(mm_dur-mm_bef,1)/sqrt(sum(~isnan(mm_dur(:,1)))),colori{i},'LineWidth',2),
    if i==1,  title(' Power difference During-Before '), end
     if i==length(structlist),  xlabel('mean +/- sem'), end
     YL=ylim;
end
legend(mousenames)
if sav
    saveas(h_mice_dur_bef,'power_during-before_all_mice.fig')
    saveFigure(h_mice_dur_bef,'power_during-before_all_mice',res)
end

end % end of avg_plo


figure('Position',[ 950    66   800   873]); 
% subplot(511)
subplot(321)
Mbulb=[squeeze(Mx_mean_during(:,1,:))-squeeze(Mx_mean_before(:,1,:)); squeeze(Mx_mean_during(:,2,:))-squeeze(Mx_mean_before(:,2,:))];
errorbar(fq_list, nanmean(Mbulb), nanstd(Mbulb,1)/sqrt(sum(~isnan(Mbulb(:,1)))),'Color','b','LineWidth',2),
title(['power during - before (n = ' num2str(sum(~isnan(Mbulb(:,1)))) ')'])
ylabel('Bulb'), ylim([0 4E5]), xlim([0 22])

% subplot(512)
subplot(323)
Mpfc=[squeeze(Mx_mean_during(:,3,:))-squeeze(Mx_mean_before(:,3,:)); squeeze(Mx_mean_during(:,4,:))-squeeze(Mx_mean_before(:,4,:))];
errorbar(fq_list, nanmean(Mpfc), nanstd(Mpfc,1)/sqrt(sum(~isnan(Mpfc(:,1)))),'Color','r','LineWidth',2),
ylabel( 'PFC'),ylim([0 4E4]), xlim([0 22])

% subplot(513)
subplot(325)
Mhpc=[squeeze(Mx_mean_during(:,5,:))-squeeze(Mx_mean_before(:,5,:))];
Mhpc_local=[squeeze(Mx_mean_during(:,8,:))-squeeze(Mx_mean_before(:,8,:))];
Mhpc_local_3mice=Mhpc_local;
Mhpc_local_3mice([1 2 6 7 10 11],:)=nan;
errorbar(fq_list, nanmean(Mhpc), nanstd(Mhpc,1)/sqrt(sum(~isnan(Mhpc(:,1)))),'Color','c','LineWidth',2);hold on
errorbar(fq_list, nanmean(Mhpc_local), nanstd(Mhpc_local,1)/sqrt(sum(~isnan(Mhpc_local(:,1)))),'Color',[0.5 0.5 0.5],'LineWidth',2);
errorbar(fq_list, nanmean(Mhpc_local_3mice), nanstd(Mhpc_local_3mice,1)/sqrt(sum(~isnan(Mhpc_local_3mice(:,1)))),'Color',[0.5 0.5 0.5],'LineWidth',1,'LineStyle','--');



XL=xlim;
line([XL(1) XL(2)],[0 0 ],'Color',[0.7 0.7 0.7])
ylabel( 'dHPC'), xlim([0 22])
ylim([-0.5E4 1.5E4]),

% subplot(514)
subplot(322)
Mpicx=[squeeze(Mx_mean_during(:,6,:))-squeeze(Mx_mean_before(:,6,:)); squeeze(Mx_mean_during(:,7,:))-squeeze(Mx_mean_before(:,7,:))];
errorbar(fq_list, nanmean(Mpicx), nanstd(Mpicx,1)/sqrt(sum(~isnan(Mpicx(:,1)))),'Color','g','LineWidth',2),
ylabel( 'PiCx'),ylim([0 1E6]), xlim([0 22])

% subplot(515)
subplot(324)
errorbar(fq_list, nanmean(Mpfc./Mbulb), nanstd(Mpfc./Mbulb,1)/sqrt(sum(~isnan(Mpfc(:,1)))),'Color','r','LineWidth',1), hold on
errorbar(fq_list, nanmean([Mhpc; Mhpc]./Mbulb), nanstd([Mhpc; Mhpc]./Mbulb,1)/sqrt(sum(~isnan(Mpfc(:,1)))),'Color','c','LineWidth',1),
errorbar(fq_list, nanmean(Mpicx./Mbulb)*0.02, nanstd(Mpicx./Mbulb,1)/sqrt(sum(~isnan(Mpfc(:,1))))*0.02,'Color','g','LineWidth',1),
errorbar(fq_list, nanmean([Mhpc_local; Mhpc_local]./Mbulb), nanstd([Mhpc_local; Mhpc_local]./Mbulb,1)/sqrt(sum(~isnan(Mpfc(:,1)))),'Color',[0.5 0.5 0.5],'LineWidth',1),
YL=ylim; ylim([0 YL(2)])
ylabel( ' XXX / bulb'), xlim([0 22])
xlabel('ratio picx/bulb*0.02');
if sav
    saveas(gcf,'power_during-before_all_mice_2_hpc_local.fig')
    saveFigure(gcf,'power_during-before_all_mice_2_hpc_local',res)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  PERCENTAGE
if perc_plo
h_mice_perc=figure('Position',[1700         66         306         911]); 
for i=1:length(structlist)
    
    mm_perc=squeeze(Mx_DiffPerc_mean(:,i,:));
    subplot(length(structlist),1,i) 
    plot(fq_list, mm_perc), hold on
    errorbar(fq_list, nanmean(mm_perc,1), nanstd(mm_perc,1)/sqrt(sum(~isnan(mm_perc(:,1)))),colori{i},'LineWidth',2),
    YL=ylim;
    XL=xlim; hold on, plot([0 XL(2)], [0 0],'-k')
    if i==1,  title('percentage'), end
    if i==length(structlist),  xlabel('mean +/- sem'), end
end
legend(mousenames)
if sav
    saveas(h_mice_perc,'power_perc_all_mice.fig')
    saveFigure(h_mice_perc,'power_perc_all_mice',res)
end
end


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%                                              RATIO PFC /BULB                                                                    %%%%%%%%%%                                              
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ratio_plo

%% RATIO OF POWER DURING STIM
% Right
figure('Position',[2200          66         506         900]); 
mm_Mean_right=squeeze(Mx_mean_during(:,3,:)) ./ squeeze(Mx_mean_during(:,1,:));
subplot(311); 
plot(fq_list,mm_Mean_right),hold on
%errorbar(fq_list, nanmean(mm_Mean_right,1), nanstd(mm_Mean_right,1),'k','LineWidth',2),
errorbar(fq_list, nanmean(mm_Mean_right,1), nanstd(mm_Mean_right,1)/sqrt(sum(~isnan(mm_Mean_right(:,1)))),'k','LineWidth',2),%
title ('ratio PFC/bulb power at stim')
ylabel([ 'right  (n=' num2str(sum(~isnan(mm_Mean_right(:,1)))) ')'])
legend(mousenamesright)
plot([0 25],[0 0 ],'k')
XL=xlim; plot([0 XL(2)],[1 1],'color',[0.7 0.7 0.7])

% Left
mm_Mean_left=squeeze(Mx_mean_during(:,4,:)) ./ squeeze(Mx_mean_during(:,2,:));
subplot(312); 
plot(fq_list,mm_Mean_left),hold on
%errorbar(fq_list, nanmean(mm_Mean_left,1), nanstd(mm_Mean_left,1),'k','LineWidth',2),
errorbar(fq_list, nanmean(mm_Mean_left,1), nanstd(mm_Mean_left,1)/sqrt(sum(~isnan(mm_Mean_left(:,1)))),'k','LineWidth',2),
ylabel([ 'left  (n=' num2str(sum(~isnan(mm_Mean_left(:,1)))) ')'])
legend(mousenamesleft)
plot([0 25],[0 0 ],'k')
XL=xlim; plot([0 XL(2)],[1 1],'color',[0.7 0.7 0.7])

subplot(313); 
plot(fq_list,[mm_Mean_right;mm_Mean_left]),hold on
errorbar(fq_list, nanmean([mm_Mean_right;mm_Mean_left],1), nanstd([mm_Mean_right;mm_Mean_left],1)/sqrt(sum(~isnan([mm_Mean_right(:,1);mm_Mean_left(:,1)]))),'k','LineWidth',2),
xlabel('mean +/- sem')
if sav
    saveas(gcf,'ratio_power_during_all_mice.fig')
    saveFigure(gcf,'ratio_power_during_all_mice',res)
end


    
%% RATIO(PFC/OB) OF POWER RATIO (DURING/BEFORE) - by event
figure('Position',[3200         66         506         900]); 
mm_ratio_by_evt_right=squeeze(Mx_Ratio_mean(:,3,:))./squeeze(Mx_Ratio_mean(:,1,:));
subplot(311); 
plot(fq_list,mm_ratio_by_evt_right),hold on
errorbar(fq_list, nanmean(mm_ratio_by_evt_right,1), nanstd(mm_ratio_by_evt_right,1)/sqrt(sum(~isnan(mm_ratio_by_evt_right(:,1)))),'k','LineWidth',2),
title ('ratio PFC/bulb of during/before ratio - by event')
ylabel('right')
legend(mousenamesright)
plot([0 25],[0 0 ],'k')

mm_ratio_by_evt_left=squeeze(Mx_Ratio_mean(:,4,:))./squeeze(Mx_Ratio_mean(:,2,:));
subplot(312); 
plot(fq_list,mm_ratio_by_evt_left),hold on
errorbar(fq_list, nanmean(mm_ratio_by_evt_left,1), nanstd(mm_ratio_by_evt_left,1)/sqrt(sum(~isnan(mm_ratio_by_evt_right(:,1)))),'k','LineWidth',2),
ylabel('left')
legend(mousenamesleft)
plot([0 25],[0 0 ],'k')

subplot(313); 
plot(fq_list,[mm_ratio_by_evt_right;mm_ratio_by_evt_left;]),hold on
errorbar(fq_list, nanmean([mm_ratio_by_evt_right;mm_ratio_by_evt_left],1), nanstd([mm_ratio_by_evt_right;mm_ratio_by_evt_left],1)/sqrt(sum(~isnan([mm_ratio_by_evt_right(:,1);mm_ratio_by_evt_left(:,1)]))),'k','LineWidth',2),
ylabel([ 'left  (n=' num2str(sum(~isnan([mm_ratio_by_evt_right(:,1);mm_ratio_by_evt_left(:,1)]))) ')'])
legend([mousenamesright;mousenamesleft])
plot([0 25],[0 0 ],'k')

 xlabel('mean +/- sem')
if sav
    saveas(gcf,'ratioPFC-OB_dur_bef_ratio_by_evt_all_mice.fig')
    saveFigure(gcf,'ratioPFC-OB_dur_bef_ratio_by_evt_all_mice',res)
end
%% RATIO(PFC/OB) OF POWER DIFFERENCES (DURING-BEFORE) - by event
figure('Position',[3200         66         506         900]); 
mm_diff_ratio_by_evt_right=squeeze(Mx_Diff_mean(:,3,:))./squeeze(Mx_Diff_mean(:,1,:));
subplot(311); 
plot(fq_list,mm_ratio_by_evt_right),hold on
errorbar(fq_list, nanmean(mm_diff_ratio_by_evt_right,1), nanstd(mm_diff_ratio_by_evt_right,1)/sqrt(sum(~isnan(mm_diff_ratio_by_evt_right(:,1)))),'k','LineWidth',2),
title ('ratio PFC/bulb of (during-before) diff - by event')
ylabel('right')
legend(mousenamesright)
plot([0 25],[0 0 ],'k')

mm_diff_ratio_by_evt_left=squeeze(Mx_Diff_mean(:,4,:))./squeeze(Mx_Diff_mean(:,2,:));
subplot(312); 
plot(fq_list,mm_diff_ratio_by_evt_left),hold on
errorbar(fq_list, nanmean(mm_diff_ratio_by_evt_left,1), nanstd(mm_ratio_by_evt_left,1)/sqrt(sum(~isnan(mm_diff_ratio_by_evt_left(:,1)))),'k','LineWidth',2),
ylabel('left')
legend(mousenamesleft)
plot([0 25],[0 0 ],'k')

subplot(313); 
plot(fq_list,[mm_diff_ratio_by_evt_right;mm_diff_ratio_by_evt_left;]),hold on
errorbar(fq_list, nanmean([mm_diff_ratio_by_evt_right;mm_diff_ratio_by_evt_left],1), nanstd([mm_diff_ratio_by_evt_right;mm_diff_ratio_by_evt_left],1)/sqrt(sum(~isnan([mm_diff_ratio_by_evt_right(:,1);mm_diff_ratio_by_evt_left(:,1)]))),'k','LineWidth',2),
ylabel([ 'left  (n=' num2str(sum(~isnan([mm_ratio_by_evt_right(:,1);mm_ratio_by_evt_left(:,1)]))) ')'])
legend([mousenamesright;mousenamesleft])
plot([0 25],[0 0 ],'k')

 xlabel('mean +/- sem')
if sav
    saveas(gcf,'ratioPFC-OB_dur_bef_diff_by_evt_all_mice.fig')
    saveFigure(gcf,'ratioPFC-OB_dur_bef_diff_by_evt_all_mice',res)
end


%%%%%%%%%%%%%%%%%%%%%

%% RATIO OF POWER DURING STIM
% Right
figure('Position',[1292          66         506         900]); 
mm_right=(squeeze(Mx_mean_during(:,3,:)) ./ squeeze(Mx_mean_before(:,3,:)) ) ./ (squeeze(Mx_mean_during(:,1,:)) ./ squeeze(Mx_mean_before(:,1,:)) );
subplot(311); 
plot(fq_list,mm_right),hold on
% errorbar(fq_list, nanmean(mm_right,1), nanstd(mm_right,1),'k','LineWidth',2),
errorbar(fq_list, nanmean(mm_right,1), nanstd(mm_right,1)/sqrt(sum(~isnan(mm_right(:,1)))),'k','LineWidth',2),

title ('ratio PFC/bulb of during/before ratio')
ylabel([ 'right  (n=' num2str(sum(~isnan(mm_right(:,1)))) ')'])
legend(mousenamesright)
plot([0 25],[0 0 ],'k')
XL=xlim; plot([0 XL(2)],[1 1],'color',[0.7 0.7 0.7])

% Left
mm_left=(squeeze(Mx_mean_during(:,4,:)) ./ squeeze(Mx_mean_before(:,4,:)) ) ./ (squeeze(Mx_mean_during(:,2,:)) ./ squeeze(Mx_mean_before(:,2,:)) );
subplot(312); 
plot(fq_list,mm_left),hold on
% errorbar(fq_list, nanmean(mm_left,1), nanstd(mm_left,1),'k','LineWidth',2),
errorbar(fq_list, nanmean(mm_left,1), nanstd(mm_left,1)/sqrt(sum(~isnan(mm_left(:,1)))),'k','LineWidth',2),

ylabel([ 'left (n=' num2str(sum(~isnan(mm_left(:,1)))) ')'])
legend(mousenamesleft)
plot([0 25],[0 0 ],'k')
XL=xlim; plot([0 XL(2)],[1 1],'color',[0.7 0.7 0.7])

% left and right pooled
subplot(313); 
plot(fq_list,[mm_right;mm_left]),hold on
% errorbar(fq_list, nanmean([mm_right;mm_left],1), nanstd([mm_right;mm_left],1),'k','LineWidth',2),
errorbar(fq_list, nanmean([mm_right;mm_left],1), nanstd([mm_right;mm_left],1)/sqrt(sum(~isnan([mm_right(:,1);mm_left(:,1)]))),'k','LineWidth',2),

ylabel([ 'left and right (n=' num2str(sum(~isnan([mm_right(:,1);mm_left(:,1)]))) ')'])
ylim([0 1])
 xlabel('mean +/- sem')
 legend([mousenamesright;mousenamesleft])
plot([0 25],[0 0 ],'k')
XL=xlim; plot([0 XL(2)],[1 1],'color',[0.7 0.7 0.7])

if sav
    saveas(gcf,'ratioPFC-OB_dur_bef_ratio_all_mice.fig')
    saveFigure(gcf,'ratioPFC-OB_dur_bef_ratio_all_mice',res)
end
end
