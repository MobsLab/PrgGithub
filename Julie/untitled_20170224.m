% 
cd /media/DataMOBsRAIDN/ProjetAversion/RampOver1dayQuantif
load DataRampOver1DayQuantif_selectionCrit
load DataRampOver1DayQuantif LFPpower_Before

%% test on 465 only

structlist={'Bulb_deep_right','Bulb_deep_left','PFCx_deep_right','PFCx_deep_left'};
i=3;
colori={'b','b','r','r'};
man=1;

fq=5;
fq_list(fq)

%% power at stimulation frequency
if 0
    Mx=[];
    Mx_mean=nan(length(Dir.path),length(structlist),nb_fq);
    for man=1:length(Dir.path), 
        figure('Position',[2130          66         306         911]),hold on,  
        for i=1:length(structlist)
            subplot(14,1,i)
            for fq=1:nb_fq


            bbb=squeeze(LFPpower_Before(1,i,man,:,:,fq));
            ind_zero=~(nansum(bbb,2)==0);

            StimFreq=[fq_list(fq)-1 fq_list(fq)+1];
            ind_StimFreq=(f1>StimFreq(1) & f1<StimFreq(2));

            %Mx=[Mx;bbb(ind_zero,ind_StimFreq)];
            Mx_mean(man,i,fq)=nanmean(nanmean(bbb(ind_zero,ind_StimFreq),2));
            Mx_std(man,i,fq)=nanstd(nanmean(bbb(ind_zero,ind_StimFreq),2));
            plot(fq_list(fq),nanmean(bbb(ind_zero,ind_StimFreq),2),'o','Color',colori{i})
            end

        end
    end
end


ss=squeeze(Mx_mean(1,:,:));
tt=squeeze(Mx_std(1,:,:));


errorbar(fq_list, ss(end,:),tt(end,:),'Color',colori{i})



 for fq=1:nb_fq
     freqname{fq}=num2str(fq_list);
 end
 colori={'b','b','r','r'};
 figure, 
 for i=1:length(structlist) 
     aa=squeeze(Mx_mean(:,i,:));
     errorbar(nanmean(aa), nanstd(aa)./sqrt(size(aa,1)), 'Color',colori{i}, 'LineWidth', 1), hold on; 
     plot(1:nb_fq,nanmean(aa), 'o', 'Color',colori{i},'MarkerFaceColor',colori{i}, 'LineWidth', 2), hold on; 
 end
   set(gca,'XTick',[1:8])
 set(gca,'XTickLabel',freqname)
 xlabel('stimulation frequency')
 ylabel('power at stimulation frequency')
title('selection Strong Oscillation')
 saveas(gcf,'power_at_stim fq_a_fct_of_stimfq.fig')
 
 
 %% power at 1-4Hz

StimFreq=[1 4];
ind_StimFreq=(f1>StimFreq(1) & f1<StimFreq(2));
Mx_low=[];
Mx_low_mean=nan(length(Dir.path),length(structlist),nb_fq);
for man=1:length(Dir.path), 
    for i=1:length(structlist)
        for fq=1:nb_fq

            
        bbb=squeeze(LFPpower_Before(1,i,man,:,:,fq));
        ind_zero=~(nansum(bbb,2)==0);
        
        
            
        %Mx_low=[Mx_low;bbb(ind_zero,ind_StimFreq)];
        Mx_low_mean(man,i,fq)=nanmean(nanmean(bbb(ind_zero,ind_StimFreq)));
        end

    end
end


 for fq=1:nb_fq
     freqname{fq}=num2str(fq_list);
 end
 colori={'b','b','r','r'};
 figure, 
 for i=1:length(structlist) 
     aa=squeeze(Mx_low_mean(:,i,:));
     errorbar(nanmean(aa), nanstd(aa)./sqrt(size(aa,1)), 'Color',colori{i}, 'LineWidth', 1), hold on; 
     plot(1:nb_fq,nanmean(aa), 'o', 'Color',colori{i},'MarkerFaceColor',colori{i}, 'LineWidth', 2), hold on; 
 end
   set(gca,'XTick',[1:8])
 set(gca,'XTickLabel',freqname)
 xlabel('stimulation frequency')
 ylabel('power at 1-4Hz')
 title('selection Strong Oscillation')
 saveas(gcf,'power_at_1-4Hz_as_a_fct_if stimfq.fig')
