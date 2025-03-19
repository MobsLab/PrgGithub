% Karim script 20170424

% data RampOver1Day_quantifPlot.m
cd /media/DataMOBsRAIDN/ProjetAversion/RampOver1dayQuantif/Ramp_4_no_selection/fig_sem_efficiency_thr_1000
load RampOver1Day_quantifPlot

% % other interesting data 
% cd /media/DataMOBsRAIDN/ProjetAversion/RampOver1dayQuantif/Ramp_4_no_selection
% load(['DataRampOver1DayQuantif_no_selection.mat']);
% %  big matrix storing power during the stimulation : LFPpower(1,i,man,evnt,1:length(f1),fq) 
% %  - 1 : useless
% %  - i : structure from structlist={'Bulb_deep_right','Bulb_deep_left','PFCx_deep_right','PFCx_deep_left'};
% %  - man : manip from Dir.path
% %  - evnt : stimulation event
% %  - 1:length(f1) : frequencies range from 0Hz and 20 Hz
% %  - fq : stimulation frequency, from [1 2 4 7 10 13 15 20]
% %  


for man=1:9
    
clear  bbb ddd bbb_mean ddd_mean bbb_std ddd_std bbb_std ddd_std

bbb_mean=squeeze(Mx_mean_before(man,:,:));
bbb_std=squeeze(Mx_std_before(man,:,:));
bbb_sem=squeeze(Mx_std_before(man,:,:))/ sqrt(size(squeeze(Mx_mean_before(man,:,:)),1));

ddd_mean=squeeze(Mx_mean_during(man,:,:));
ddd_std=squeeze(Mx_std_during(man,:,:));
ddd_sem=squeeze(Mx_std_during(man,:,:))/ sqrt(size(squeeze(Mx_std_during(man,:,:)),1));

perc_mean=squeeze(DiffPerc_mean(man,:,:));
perc_std=squeeze(DiffPerc_std(man,:,:));
perc_sem=squeeze(DiffPerc_std(man,:,:))/ sqrt(size(squeeze(DiffPerc_std(man,:,:)),1));

% normalized by the power at 1Hz
diff_mean_norm=squeeze(Diff_norm_mean(man,:,:));
diff_std_norm=squeeze(Diff_norm_std(man,:,:));
diff_sem_norm=squeeze(Diff_norm_std(man,:,:))/ sqrt(size(squeeze(Diff_norm_std(man,:,:)),1));

ratio_mean=squeeze(Mx_Ratio_mean(man,:,:));
ratio_std=squeeze(Mx_Ratio_std(man,:,:));
ratio_sem=squeeze(Mx_Ratio_std(man,:,:))/ sqrt(size(squeeze(Mx_Ratio_std(man,:,:)),1));



% 
% 
% figure, 
% subplot(1,2,1),
% plot([1 2 4 7 10 13 15 20],ddd_mean(i,:),'ro-')
% hold on, plot([1 2 4 7 10 13 15 20],bbb_mean(i,:),'bo-')
% hold on, plot([1 2 4 7 10 13 15 20],(ddd_mean(i,:)-bbb_mean(i,:)),'ko-')
% line([0 21],[0 0],'color',[0.7 0.7 0.7])
% subplot(1,2,2),
% plot([1 2 4 7 10 13 15 20],ddd_mean(i,:).*[1 2 4 7 10 13 15 20],'ro-')
% hold on, plot([1 2 4 7 10 13 15 20],bbb_mean(i,:).*[1 2 4 7 10 13 15 20],'bo-')
% hold on, plot([1 2 4 7 10 13 15 20],(ddd_mean(i,:)-bbb_mean(i,:)).*[1 2 4 7 10 13 15 20],'ko-')
% line([0 21],[0 0],'color',[0.7 0.7 0.7])


figure, hold on
plot([1 2 4 7 10 13 15 20],(ddd_mean(3,:)-bbb_mean(3,:))./(ddd_mean(1,:)-bbb_mean(1,:)),'bo-')
plot([1 2 4 7 10 13 15 20],(ddd_mean(4,:)-bbb_mean(4,:))./(ddd_mean(2,:)-bbb_mean(2,:)),'ko-')
title('man')

end


LFPpower(LFPpower==0)=nan;
LFPpower_Before(LFPpower_Before==0)=nan;


% for nfreq=1:8
%     try
% figure('color',[1 1 1]), 
% subplot(2,3,1),
% imagesc(f1,1:11,squeeze(nanmean(squeeze(LFPpower(1,1,:,:,1:length(f1),nfreq)),2))), ylabel(num2str(fq_list(nfreq)))
% subplot(2,3,4),
% imagesc(f1,1:11,squeeze(nanmean(squeeze(LFPpower(1,2,:,:,1:length(f1),nfreq)),2)))
% 
% subplot(2,3,2),
% imagesc(f1,1:11,squeeze(nanmean(squeeze(LFPpower_Before(1,1,:,:,1:length(f1),nfreq)),2)))
% subplot(2,3,5),
% imagesc(f1,1:11,squeeze(nanmean(squeeze(LFPpower_Before(1,2,:,:,1:length(f1),nfreq)),2)))
% 
% subplot(2,3,3),hold on
% plot(f1,nanmean(squeeze(nanmean(squeeze(LFPpower(1,1,:,:,1:length(f1),nfreq)),2)))), ylim([0 4E5])
% plot(f1,nanmean(squeeze(nanmean(squeeze(LFPpower_Before(1,1,:,:,1:length(f1),nfreq)),2))),'b','linestyle',':'), ylim([0 4E5])
% subplot(2,3,6),hold on
% plot(f1,nanmean(squeeze(nanmean(squeeze(LFPpower(1,2,:,:,1:length(f1),nfreq)),2))),'r'), ylim([0 4E5])
% plot(f1,nanmean(squeeze(nanmean(squeeze(LFPpower_Before(1,2,:,:,1:length(f1),nfreq)),2))),'r','linestyle',':'), ylim([0 4E5])
%     end
%     
% end
% 
% 
% clear Mpfc Mbulb
% 
% for nfreq=1:8
% Mbulb{nfreq}=[squeeze(nanmean(squeeze(LFPpower(1,1,:,:,1:length(f1),nfreq)),2));squeeze(nanmean(squeeze(LFPpower(1,2,:,:,1:length(f1),nfreq)),2))];
% end
% 
% 
% 
% for nfreq=1:8
% Mpfc{nfreq}=[squeeze(nanmean(squeeze(LFPpower(1,3,:,:,1:length(f1),nfreq)),2));squeeze(nanmean(squeeze(LFPpower(1,4,:,:,1:length(f1),nfreq)),2))];
% end
% 
% [temp,idx]=sort(Mbulb{8}(:,65));
% figure, 
% for i=1:8
% subplot(1,8,i),plot(nanmean(Mbulb{i}(idx(10:end),:))/max(nanmean(Mbulb{i}(idx(10:end),:))))
% hold on, plot(nanmean(Mpfc{i}(idx(10:end),:))/max(nanmean(Mpfc{i}(idx(10:end),:))),'r')
% title(num2str(fq_list(i)))
% end

% 
% % lim_Inf=14;
% % for i=1:8
% % 
% %     figure(1), hold on,
% %     plot(f1,nanmean(Mbulb{i}(idx(lim_Inf:end),:))/max(nanmean(Mbulb{i}(idx(lim_Inf:end),:))))
% %     idd=find(f1<fq_list(i));
% %     idd=idd(end);
% %     temp_bulb(i,:)=nanmean(Mbulb{i}(idx(lim_Inf:end),:))/max(nanmean(Mbulb{i}(idx(lim_Inf:end),:)));
% %     plot(f1(idd),temp_bulb(i,idd),'ko','markerfacecolor','k')
% %     title(num2str(fq_list(i)))
% %     val(i,1)=temp_bulb(i,idd);
% % 
% %     figure(2),hold on, 
% %     plot(f1,nanmean(Mpfc{i}(idx(lim_Inf:end),:))/max(nanmean(Mpfc{i}(idx(lim_Inf:end),:))),'r')
% %     idd=find(f1<fq_list(i));
% %     idd=idd(end);
% %     temp_pfc(i,:)=nanmean(Mpfc{i}(idx(lim_Inf:end),:))/max(nanmean(Mpfc{i}(idx(lim_Inf:end),:)));
% %     plot(f1(idd),temp_pfc(i,idd),'ko','markerfacecolor','k')
% %     title(num2str(fq_list(i)))
% %     val(i,2)=temp_pfc(i,idd);
% %     
% % end
% % 
% % figure(1), plot(fq_list,val(:,1),'k'), 
% % figure(2), plot(fq_list,val(:,2),'k')
% % 


clear Mpfc Mbulb

for nfreq=1:8
Mbulb{nfreq}=[squeeze(nanmean(squeeze(LFPpower(1,1,:,:,1:length(f1),nfreq)),2));squeeze(nanmean(squeeze(LFPpower(1,2,:,:,1:length(f1),nfreq)),2))];
end



for nfreq=1:8
Mpfc{nfreq}=[squeeze(nanmean(squeeze(LFPpower(1,3,:,:,1:length(f1),nfreq)),2));squeeze(nanmean(squeeze(LFPpower(1,4,:,:,1:length(f1),nfreq)),2))];
end

[temp,idx]=sort(Mbulb{8}(:,65));
%[temp,idx]=sort(Mpfc{8}(:,65));

a=1;

lim_Inf=13;

plo=1; 
figure(a)
close
clear val temp temp_bulb temp_bulb_std temp_pfc temp_pfc_std
for i=1:8
    figure(a), 
    subplot(1,4,1), hold on,
    plot(f1,nanmean(Mbulb{i}(idx(lim_Inf:end),:)))
    iddatemp=find(f1<fq_list(i));
    idda(i)=iddatemp(end);
    temp_bulb(i,:)=nanmean(Mbulb{i}(idx(lim_Inf:end),:));
    temp_bulb_std(i,:)=nanstd(Mbulb{i}(idx(lim_Inf:end),:));
    plot(f1(idda(i)),temp_bulb(i,idda(i)),'ko','markerfacecolor','k')
    %plot(f1,nanmedian(temp_bulb),'k','linewidth',2)
    
    val(i,1)=temp_bulb(i,idda(i));

    val(i,3)=temp_bulb_std(i,idda(i))/sqrt(length(idx(lim_Inf:end)));

    figure(a), subplot(1,4,2),hold on, 
    plot(f1,nanmean(Mpfc{i}(idx(lim_Inf:end),:)),'r')
    iddbtemp=find(f1<fq_list(i));
    iddb(i)=iddbtemp(end);
    temp_pfc(i,:)=nanmean(Mpfc{i}(idx(lim_Inf:end),:));
    temp_pfc_std(i,:)=nanstd(Mpfc{i}(idx(lim_Inf:end),:));
    plot(f1(iddb(i)),temp_pfc(i,iddb(i)),'ko','markerfacecolor','k')
    %plot(f1,nanmedian(temp_pfc),'k','linewidth',2)
    
    val(i,4)=temp_pfc(i,iddb(i));

    val(i,6)=temp_pfc_std(i,iddb(i))/sqrt(length(idx(lim_Inf:end)));
end

temp=nanmedian(temp_bulb);
for i=1:8, val(i,2)=temp(idda(i));end
temp=nanmedian(temp_pfc);
for i=1:8, val(i,5)=temp(iddb(i));end
    
figure(a), subplot(1,4,1),plot(f1,nanmedian(temp_bulb),'k','linewidth',2), plot(fq_list,val(:,1),'k'), ylabel(num2str(lim_Inf))
figure(a), subplot(1,4,2),plot(f1,nanmedian(temp_pfc),'k','linewidth',2), plot(fq_list,val(:,4),'k')
figure(a), subplot(1,4,3), hold on, plot(fq_list,val(:,1)-val(:,2),'b','linewidth',2), if plo, plot(fq_list,val(:,1)-val(:,2)+val(:,3),'b','linewidth',1), plot(fq_list,val(:,1)-val(:,2)-val(:,3),'b','linewidth',1), end
figure(a), subplot(1,4,4), hold on, plot(fq_list,val(:,4)-val(:,5),'r','linewidth',2), if plo, plot(fq_list,val(:,4)-val(:,5)+val(:,6),'r','linewidth',1), plot(fq_list,val(:,4)-val(:,5)-val(:,6),'r','linewidth',1), end
set(gcf,'position',[ 2010         604        1810         343])
a=a+1;

