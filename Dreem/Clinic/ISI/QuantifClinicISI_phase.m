% QuantifClinicISI_phase
% 31.07.2017 KJ
%
% collect data for the quantification of Inter Slow-wave Intervals for different sleep stages
%   - Sleep stages = N1, N2, N3, REM, WAKE
%   - influence of the phase
%
% Here, the data are reformated
%
%   see QuantifClinicISI QuantifClinicISI_bis QuantifClinicISIPlot
%


clear
eval(['load ' FolderPrecomputeDreem 'QuantifClinicISI.mat'])

%params
NameSleepStages = {'N1','N2', 'N3','REM','Wake'}; % Sleep stages
conditions = {'Sham','Random','UpPhase'};
phases_group = [-pi/4 pi/4; pi/4 3*pi/4; 3*pi/4 -3*pi/4; -3*pi/4 -pi/4];
labels_phase = {'peak', 'descending','trough','ascending'};
n2n3 = [3];

failed=1;
success=2;

optiontest='ranksum';

cond_basal = find(strcmpi(conditions,'Sham'));
cond_random = find(strcmpi(conditions,'Random'));
cond_upphase = find(strcmpi(conditions,'UpPhase'));




%% concatenate

%basal
cond = strcmpi(conditions,'Sham');
for sstage=sleepstage_ind
    for i=1:3
        basal_isi = [];
        for p=1:length(basal_res.filename)
            basal_isi = [basal_isi basal_res.isi_slowwave_stage{p,sstage}{i}];
        end
        basal_isi = basal_isi / 1E4; %in ms
        
        isi_clinic.data{cond,sstage,i,1} = basal_isi; %in ms
        isi_clinic.median(cond,sstage,i,1) = nanmedian(basal_isi); %in ms
        isi_clinic.mode(cond,sstage,i,1) = mode(basal_isi); %in ms
    end
end


%Up phase & random
for cond=1:length(conditions)
    if ~strcmpi(conditions{cond},'Sham')
        
        for phg=1:size(phases_group,1)
            for i=1:3
                list_isi_success = [];
                list_isi_failed = [];

                for p=1:length(tone_res.filename)
                    if strcmpi(tone_res.condition{p},conditions{cond})
                        data_isi = tone_res.isi_slowwave_stage{p,i};                        
                        selected_tones = (tone_res.slowwave_triggered{p}==1 & tone_res.tones.rank_tones{p}==1);% | tone_res.tones.rank_tones{p}==2;
                        selected_tones = selected_tones .* ismember(tone_res.sleepstage_tone{p},n2n3)'; %tones really triggered, in the very stage
                    
                        if phases_group(phg,1)<phases_group(phg,2)
                            idx_phases = tone_res.tones.phase{p}>phases_group(phg,1) & tone_res.tones.phase{p}<phases_group(phg,2);
                        else
                            idx_phases = tone_res.tones.phase{p}>phases_group(phg,1) | tone_res.tones.phase{p}<phases_group(phg,2);
                        end
                        selected_tones = selected_tones .* idx_phases;

                        success_tones = selected_tones .* (tone_res.induce_slow_wave{p}==1);
                        data_isi_success = data_isi(success_tones==1);
                        failed_tones = selected_tones .* (tone_res.induce_slow_wave{p}==0);
                        data_isi_failed = data_isi(failed_tones==1);

                        list_isi_success = [list_isi_success data_isi_success];
                        list_isi_failed = [list_isi_failed data_isi_failed];
                    end
                end
                
                list_isi_success = list_isi_success / 1E4; %in s
                list_isi_failed = list_isi_failed / 1E4; %in s
                
                isi_clinic.data{cond,phg,i,success} = list_isi_success;
                isi_clinic.data{cond,phg,i,failed} = list_isi_failed;                
                isi_clinic.median(cond,phg,i,success) = nanmedian(list_isi_success);
                isi_clinic.median(cond,phg,i,failed) = nanmedian(list_isi_failed);
                isi_clinic.mode(cond,phg,i,success) = mode(list_isi_success);
                isi_clinic.mode(cond,phg,i,failed) = mode(list_isi_failed);
            end
        end
    end
end


        


% %% Figure1 - Order by isi
% condition_fig = [cond_random, cond_upphase];
% titles = {'Random','Up Phase'};
% maintitle = 'Inter delta waves interval (Basal night and night with Tones)';
% labels={'Success Tones n+1','Failed Tones n+1','Basal n+1','Success Tones n+2','Failed Tones n+2','Basal n+2','Success Tones n+3','Failed Tones n+3','Basal n+3',};
% bar_color={'b','r',[0.2 0.2 0.2]};
% bar_color = [bar_color bar_color bar_color];
% columtest  = [nchoosek(1:3,2) ; nchoosek(1:3,2) + 3; nchoosek(1:3,2) + 2*3];
% nb_isi = 1:3;
% 
% 
% for cond=1:length(condition_fig)
% 
%     figure, hold on
%     for phg=1:size(phases_group,1)
% 
%         %data
%         data = cell(0);
%         for i=nb_isi
%             data{end+1} = isi_clinic.data{condition_fig(cond),phg,i,success}; %success        
%             data{end+1} = isi_clinic.data{condition_fig(cond),phg,i,failed}; %failed
%             data{end+1} = isi_clinic.data{cond_basal,phg,i,1}; %basal
%         end
% 
%         try
%             %subplot
%             subplot(2,2,phg), hold on,
%                 [~,eb] = PlotErrorBarN_KJ(data,'newfig',0,'paired',0,'horizontal',1,'barcolors',bar_color,'ColumnTest',columtest,'ShowSigstar','sig', 'optiontest',optiontest);
%             title(labels_phase{phg},'fontsize',20), xlabel('s'), hold on,
%             set(eb,'Linewidth',2); %bold error bar
%             set(gca, 'YTickLabel',labels, 'YTick',1:numel(labels),'FontName','Times','fontsize',15), hold on,
%         %     set(gca, 'XTick',0:1000:3000,'XLim',[0 5000]);
%         end
% 
%     end
%     
%     suplabel([maintitle '  -  ' titles{cond}],'t');
% 
% end


%% Figure2 - Curve
condition_fig = [cond_random, cond_upphase];
titles = {'Random','Up Phase'};
maintitle = 'Inter delta waves interval (Basal night and night with Tones)';
nb_isi = 1:3;
NameISI = {'d(n,n+1)','d(n,n+2)','d(n,n+3)','d(n+1,n+2)','d(n+1,n+3)','d(n+2,n+3)'}; %ISI
lineColors = {'b','r',[0.2 0.2 0.2]};
labels = {'Success','Failed','Basal'};


for cond=1:length(condition_fig)

    figure, hold on
    for phg=1:size(phases_group,1)

        %data
        clear x_line bar_line idx_line
        data = cell(0);
        for i=nb_isi
            data{end+1} = isi_clinic.data{condition_fig(cond),phg,i,success}; %success    
        end
        for i=nb_isi
            data{end+1} = isi_clinic.data{condition_fig(cond),phg,i,failed}; %failed
        end
        for i=nb_isi
            data{end+1} = isi_clinic.data{cond_basal,phg,i,1}; %basal
        end
        
        try
            %mean and stderror
            R=[];
            E=[];
            for i=1:length(data)
                [Ri,~,Ei]=MeanDifNan(data{i});
                R=[R,Ri];
                E=[E,Ei];
            end
            %line
            for i=1:length(labels)
                idx_line = (1:length(nb_isi)) + (i-1)*length(nb_isi);
                x_line{i} =  R(idx_line);
                bar_line{i} = E(idx_line);
            end

            %% SUBPLOT 
            subplot(2,2,phg), hold on,
            %lines
            for i=1:length(labels)
                plot(x_line{i}, 1:length(nb_isi),'color',lineColors{i},'Linewidth',2), hold on
            end
            legend(labels)
            %error bar
            for i=1:length(labels)
                eb=herrorbar(x_line{i},1:length(nb_isi),bar_line{i},'.k'); hold on
                set(eb,'Linewidth',2); %bold error bar
            end

            title(labels_phase{phg},'fontsize',20), xlabel('s'), hold on,
            set(gca, 'YTickLabel',NameISI(nb_isi), 'YTick',1:length(nb_isi),'YLim',[0.5 length(nb_isi)+0.5],'FontName','Times','fontsize',15), hold on,
                        
        end
    end
    
    suplabel([maintitle '  -  ' titles{cond}],'t');

end
