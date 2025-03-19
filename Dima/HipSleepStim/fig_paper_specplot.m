%% INPUTS
cd ('/media/mobsrick/DataMOBs71/pics');
res=pwd;

% Do you want to save these figures? 0 = no, 1 = yes
sav=1;

% List of folders with the data
Dir.path={
    '/media/mobsrick/DataMOBs71/Mouse-534/09062017_SleepStim/FEAR-Mouse-534-09062017';
    '/media/mobsrick/DataMOBs71/Mouse-534/12062017-SleepStim/FEAR-Mouse-534-12062017';
    '/media/mobsrick/DataMOBs71/Mouse-534/14062017-SleepStim/FEAR-Mouse-534-14062017';
    '/media/mobsrick/DataMOBs71/Mouse-534/15062017-SleepStim/FEAR-Mouse-534-15062017';
    '/media/mobsrick/DataMOBs71/Mouse-534/16062017-SleepStim/FEAR-Mouse-534-16062017'
    };

for k=1:length(Dir.path)
    ind_mouse=strfind(Dir.path{k},'Mouse');
    Dir.name{k}=Dir.path{k}(ind_mouse:ind_mouse+8);
end

% Frequency list
fq_list = [1 2 4 7 10 13 15 20];
nb_fq=length(fq_list);

% Frequency resolution
load /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/f_0-20;

% List of structures to plot and compute
structlist={'dHPC_rip', 'PFCx_deep', 'Bulb_deep'};

% Channel to separate SWS and REM
chan = 'dHPC_rip';

% Margin for plotting
margin = 0.5;

%% INITIALIZE
structlistname=structlist;
for i=1:length(structlistname)
    ind_und=strfind(structlistname{i},'_');
    structlistname{i}(ind_und)=' ';
end

[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high
 cd
 
%% Load or compute data
 try
    
    cd ('/media/mobsrick/DataMOBs71/pics');
    disp(['Loading existing data from DataRampOver1DayQuantif_no_selection.mat']);
    load(['DataRampOver1DayQuantif_no_selection.mat']);
    
 catch
    % Memory allocation
LFPpower=nan(length(structlist), length(Dir.path),50,length(fq_list),length(f1)); % 50 : nb d'events (max estimé)
LFPpower_Before=nan(length(structlist), length(Dir.path),50,length(fq_list),length(f1));

    for man=1:length(Dir.path) 
        cd (Dir.path{man})
        
        load StimInfo
        StimInfoAllMan{man}=StimInfo;
        
        for i=1:length(structlist)

            % Spectra calculation and saving
            if exist([Dir.path{man},'/ChannelsToAnalyse/',structlist{i},'.mat']) 
                temp=load([Dir.path{man},'/ChannelsToAnalyse/',structlist{i},'.mat']);
                try
                    load([Dir.path{man},'/SpectrumDataL/Spectrum' num2str(temp.channel),'.mat'],'Sp', 't', 'f') % t en secondes
                    disp(['SpectrumDataL/Spectrum' num2str(temp.channel),'... loaded'])
                catch

                    if ~exist([Dir.path{man},'/SpectrumDataL'],'dir'), mkdir([Dir.path{man},'/SpectrumDataL']);end
                    eval(['temp2=load(''',Dir.path{man},'/LFPData/LFP',num2str(temp.channel),'.mat'');'])
                    disp(['Computing SpectrumDataL/Spectrum' num2str(temp.channel),'... '])
                    [Sp,t,f]=mtspecgramc(Data(temp2.LFP),movingwin,params);
                    eval(['save(''',Dir.path{man},'/SpectrumDataL/Spectrum',num2str(temp.channel),...
                        '.mat'',','''Sp'',','''t'',','''f'',','''params'',','''movingwin'');'])
                end
                StsdL=tsd(t*1E4,Sp);

            else
                disp(['no channel for ' structlist{i} ' in this mouse '])
            end
            

            for fq=1:nb_fq
                LaserInt{man,fq} =intervalSet(StimInfo.StartTime(StimInfo.Freq==fq_list(fq))*1E4,...
                    StimInfo.StopTime(StimInfo.Freq==fq_list(fq))*1E4);

                for evnt=1:length(Start(LaserInt{man,fq}))
                    if length(f)>67
                        LFPpower(i,man,evnt,fq,1:length(f1))= interp1(f,mean(Data(Restrict(StsdL,subset(LaserInt{man,fq},evnt)))),f1);
                        LFPpower_Before(i,man,evnt,fq,1:length(f1))= interp1(f,mean(Data(Restrict(StsdL,shift(subset(LaserInt{man,fq},...
                            evnt), -30E4)))),f1);
                    else
                        LFPpower(i,man,evnt,fq,1:length(f1))= mean(Data(Restrict(StsdL,subset(LaserInt{man,fq},evnt))));
                        LFPpower_Before(i,man,evnt,fq,1:length(f1))= mean(Data(Restrict(StsdL,shift(subset(LaserInt{man,fq},...
                            evnt), -30E4))));
                        
                    end
                end
            end

        end
    end
    cd(res)
    
    if sav
        save DataRampOver1DayQuantif_no_selection LFPpower LFPpower_Before f1 f structlistname fq_list Dir LaserInt StimInfoAllMan nb_fq
    end
 end  
        
        
%% Plot the spectra

for m =1:length(Dir.path)
    for fq=1:nb_fq
        num_ep(m,fq)=length(Start(LaserInt{m,fq}));
    end
end

cols=lines(8);
cols=cols([1,6,5,3,2],:);cols=[[0 0 0.5];cols;[0.8 0 0;0.5 0 0]];


        for i=1:length(structlist)
            manSpfig=figure('Position', [200          48         1500         926]);
            
                LFPpower_Before_av=squeeze(LFPpower_Before(i,:,:,:,:));
                LFPpower_Before_av=reshape(LFPpower_Before_av, [size(LFPpower_Before_av,1)*size(LFPpower_Before_av,2)*...
                    size(LFPpower_Before_av,3),size(LFPpower_Before_av,4)]);
                
                shadedErrorBar(f1,nanmean(LFPpower_Before_av),nanstd(LFPpower_Before_av)/sqrt(sum(num_ep(:))), {},0);
                hold on
                
            

            for fq=1:nb_fq
                
                LFPpower_av=squeeze(LFPpower(i,:,:,fq,:));
                LFPpower_av=reshape(LFPpower_av, [size(LFPpower_av,1)*size(LFPpower_av,2),...
                    size(LFPpower_av,3)]);
                M = nanmean(LFPpower_av);
                
                PeakVal(fq)=mean(M(find(f1<fq_list(fq),1,'last')));
                
                plot(f1,nanmean(LFPpower_av),'linewidth',3,'color',cols(fq,:)), hold on
                
        cd(res)

            end
            
            plot(fq_list,PeakVal,'--','linewidth',0.5,'color',[0.4 0.4 0.4]);
            
            xlabel('Frequency (Hz)');
            ylabel ('Spectral power (a.u.)');
            set(gca, 'FontSize', 14);
%             ylim([0 2.5E5]);
%             title([structlist{i} ' Average']);
            
        if sav
            saveas(manSpfig,[num2str(structlist{i}) '.fig'])
            saveFigure(manSpfig,num2str(structlist{i}),res)
        end
        end
        
        
 %% Do calculations for graph
 
% Memory allocation
Mx_mean_before=nan(length(structlist),nb_fq);
Mx_sem_before=nan(length(structlist),nb_fq);

Mx_mean_during=nan(length(structlist),nb_fq);
Mx_sem_during=nan(length(structlist),nb_fq);

Mx_Diff_mean=nan(length(structlist),nb_fq);
Mx_Diff_sem=nan(length(structlist),nb_fq);

try 
    load RampOver1Day_quantifPlot.mat
catch

        clear  bbb ddd bbb_mean ddd_mean bbb_std ddd_std bbb_sem ddd_sem

        for i=1:length(structlist)

            for fq=1:nb_fq

                bbb=squeeze(LFPpower_Before(i,:,:,fq,:));% Power before the stimulation on the frequency requested
                ddd=squeeze(LFPpower(i,:,:,fq,:));% Power during the stimulation on the frequency requested

                StimFreq=[fq_list(fq)-margin fq_list(fq)+margin];
                ind_StiFq=(f1>StimFreq(1) & f1<StimFreq(2));

                bbb=bbb(:,:,ind_StiFq);
                ddd=ddd(:,:,ind_StiFq);
                
                % Mean power before and during stimulation
                Mx_mean_before(i,fq)=nanmean(bbb(:));
                Mx_sem_before(i,fq)=nanstd(nanmean(nanmean(bbb,3),2))/sqrt(size(bbb,1));
                
                Mx_mean_during(i,fq)=nanmean(ddd(:));
                Mx_sem_during(i,fq)=nanstd(nanmean(nanmean(ddd,3),2))/sqrt(size(ddd,1));
                
                % Difference of during and before 
                diff = ddd-bbb;
                Mx_Diff_mean(i,fq)=nanmean(diff(:));
                Mx_Diff_sem(i,fq)=nanstd(nanmean(nanmean(diff,3),2))/sqrt(size(diff,1)); 
            end
        end
    if sav
        save RampOver1Day_quantifPlot.mat Mx_mean_before Mx_sem_before Mx_mean_during Mx_sem_during ...
            Mx_Diff_mean Mx_Diff_sem nb_fq fq_list
    end
end

% Plot it

for i=1:length(structlist)
    
    
    % Both before and after
    h = figure('Position', [200          48         1500         926]);
    errorbar(fq_list, Mx_mean_before(i,:),Mx_sem_before(i,:),'Color','k','LineStyle','--'), hold on
    errorbar(fq_list, Mx_mean_during(i,:),Mx_sem_during(i,:),'Color','k', 'LineWidth', 2);
    xlim([0 20 ]);
%     ylim([0 3E5]);
    xlabel('Frequency (Hz)');
    ylabel ('Spectral power (a.u.)');
    set(gca, 'FontSize', 14);
            if sav
            saveas(h,[num2str(structlist{i}) '_During_before_av.fig'])
            saveFigure(h,[num2str(structlist{i}) '_During_before_av'],res)
            end
    
            
   % Difference
   g = figure('Position', [200          48         1500         926]);
   errorbar(fq_list, Mx_Diff_mean(i,:),Mx_Diff_sem(i,:),'Color','k', 'LineWidth', 2);
   xlim([0 20 ]);
%    ylim([0 12E4]);
   xlabel('Frequency (Hz)');
   ylabel ('Difference in spectral power (stimulation- presimulation) (a.u.)');
   set(gca, 'FontSize', 14);
            if sav
            saveas(g,[num2str(structlist{i}) '_Difference_av.fig'])
            saveFigure(g,[num2str(structlist{i}) '_Difference_av'],res)
            end
   
   
end

%% Separate SWS and REM with pictures

% Memory allocation
LFPpower610=nan(length(Dir.path),50,length(f1),length(fq_list)); 
LFPpower36=nan(length(Dir.path),50,length(f1),length(fq_list));


% Load data

for m = 1:length(Dir.path)
    cd(Dir.path{m});
    load StimInfo
    
    % Spectrum loading
                if exist([Dir.path{m},'/ChannelsToAnalyse/', chan,'.mat']) 
                   temp=load([Dir.path{m},'/ChannelsToAnalyse/',chan,'.mat']);
                try
                    load([Dir.path{m},'/SpectrumDataL/Spectrum' num2str(temp.channel),'.mat'],'Sp', 't', 'f') % t en secondes
                    disp(['SpectrumDataL/Spectrum' num2str(temp.channel),'... loaded'])
                catch
                    disp('No spectrum found for this channel')
                end
                end

% Take 6-9 Hz and 3-6 Hz
ind_610 = find(f>6&f<10);
Sp_610 = Sp(:,ind_610);
Stsd_610=tsd(t*1E4,Sp_610);

ind_36 = find(f>3&f<6);
Sp_36 = Sp(:,ind_36);
Stsd_36=tsd(t*1E4,Sp_36);

% Make Epochs

for fq=1:length(fq_list)
        Prestim{m,fq} =intervalSet(StimInfo.StartTime(StimInfo.Freq==fq_list(fq))*1E4-10E4,...
            StimInfo.StartTime(StimInfo.Freq==fq_list(fq))*1E4);


%Calculate power
    for ev = 1:length(Start(Prestim{m,fq}))
        if length(ind_610)>length(f1)
            LFPpower610(m,ev,1:length(f1),fq) = interp1(f,mean(Data(Restrict(Stsd_610,subset(Prestim{m,fq},ev)))),f1);
        else
            LFPpower610(m,ev,1:length(ind_610),fq) = mean(Data(Restrict(Stsd_610,subset(Prestim{m,fq},ev))));
        end
        
        if length(ind_36)>length(f1)
            LFPpower36(m,ev,1:length(f1),fq) = interp1(f,mean(Data(Restrict(Stsd_36,subset(Prestim{m,fq},ev)))),f1);
        else
            LFPpower36(m,ev,1:length(ind_36),fq) = mean(Data(Restrict(Stsd_36,subset(Prestim{m,fq},ev))));
        end
        
    end
    
end


end

% Separate epochs with ratio < 1 and ratio > 2
a = squeeze(nanmean(LFPpower610,3))./squeeze(nanmean(LFPpower36,3)); % Ratio matrix (days*stims*freqstims)

idx_events_low = nan(length(Dir.path), length(fq_list), 50);
idx_events_high = nan(length(Dir.path), length(fq_list), 50);


for m = 1:length(Dir.path)
    for k = 1:length(fq_list)
                l = length(find(squeeze(a(m,:,k))<1));
                idx_events_low(m,k,1:l) = find(squeeze(a(m,:,k))<1);
                h = length(find(squeeze(a(m,:,k))>2));
                idx_events_high(m,k,1:h) = find(squeeze(a(m,:,k))>2);
    end
end

% Prepare arrays for averaging
LFPpower_Before_low = nan(length(structlist),length(Dir.path),50,length(fq_list),length(f1));
LFPpower_low = nan(length(structlist),length(Dir.path),50,length(fq_list),length(f1));
LFPpower_Before_high = nan(length(structlist),length(Dir.path),50,length(fq_list),length(f1));
LFPpower_high = nan(length(structlist),length(Dir.path),50,length(fq_list),length(f1));

for u = 1:length(Dir.path)
    for o = 1:length(structlist)
        for fq = 1:length(fq_list)
            id_low = squeeze(idx_events_low(u, fq, :));
            id_low(find(isnan(id_low))) = [];
            LFPpower_Before_low(o,u,1:length(id_low),fq,:) = squeeze(LFPpower_Before(o,u,id_low,fq,:));
            LFPpower_low(o,u,1:length(id_low),fq,:) = squeeze(LFPpower(o,u,id_low,fq,:));
            
            
            id_high = squeeze(idx_events_high(u, fq, :));
            id_high(find(isnan(id_high))) = [];
            LFPpower_Before_high(o,u,1:length(id_high),fq,:) = squeeze(LFPpower_Before(o,u,id_high,fq,:));
            LFPpower_high(o,u,1:length(id_high),fq,:) = squeeze(LFPpower(o,u,id_high,fq,:));
        end
    end
end

% Plot this shit

cols=lines(8);
cols=cols([1,6,5,3,2],:);cols=[[0 0 0.5];cols;[0.8 0 0;0.5 0 0]];


        for i=1:length(structlist)
                
                e=figure('Position', [200          48         1500         926]);
            

            for fq=1:nb_fq
                
                LFPpower_av_low=squeeze(LFPpower_low(i,:,:,fq,:));
                LFPpower_av_low=reshape(LFPpower_av_low, [size(LFPpower_av_low,1)*size(LFPpower_av_low,2),...
                    size(LFPpower_av_low,3)]);

                plot(f1,nanmean(LFPpower_av_low),'linewidth',1.5, 'LineStyle', '--', 'color',cols(fq,:)), hold on
                
                
                LFPpower_av_high=squeeze(LFPpower_high(i,:,:,fq,:));
                LFPpower_av_high=reshape(LFPpower_av_high, [size(LFPpower_av_high,1)*size(LFPpower_av_high,2),...
                    size(LFPpower_av_high,3)]);

                plot(f1,nanmean(LFPpower_av_high),'linewidth',3, 'color',cols(fq,:)), hold on
                
        cd('/media/mobsrick/DataMOBs71/pics')

            end
            
            
            xlabel('Frequency (Hz)');
            ylabel ('Spectral power (a.u.)');
            set(gca, 'FontSize', 14);
%             ylim([0 2.5E5]);
%             title([structlist{i} ' Average']);
            
        if sav
            saveas(e,[num2str(structlist{i}) '_SWS_REM.fig'])
            saveFigure(e,[num2str(structlist{i}) '_SWS_REM'],res)
        end
        end
        
%%% Difference graph for SWS and REM epochs

% Memory allocation
Mx_mean_before_low=nan(length(structlist),nb_fq);
Mx_sem_before_low=nan(length(structlist),nb_fq);
Mx_mean_before_high=nan(length(structlist),nb_fq);
Mx_sem_before_high=nan(length(structlist),nb_fq);

Mx_mean_during_low=nan(length(structlist),nb_fq);
Mx_sem_during_low=nan(length(structlist),nb_fq);
Mx_mean_during_high=nan(length(structlist),nb_fq);
Mx_sem_during_high=nan(length(structlist),nb_fq);

Mx_Diff_mean_low=nan(length(structlist),nb_fq);
Mx_Diff_sem_low=nan(length(structlist),nb_fq);
Mx_Diff_mean_high=nan(length(structlist),nb_fq);
Mx_Diff_sem_high=nan(length(structlist),nb_fq);

        clear  bbb ddd bbb_mean ddd_mean bbb_std ddd_std bbb_sem ddd_sem

        for i=1:length(structlist)

            for fq=1:nb_fq
                
                
                StimFreq=[fq_list(fq)-margin fq_list(fq)+margin];
                ind_StiFq=(f1>StimFreq(1) & f1<StimFreq(2));
                
                % Low frequency
                bbb_low=squeeze(LFPpower_Before_low(i,:,:,fq,:));% Power before the stimulation on the frequency requested
                ddd_low=squeeze(LFPpower_low(i,:,:,fq,:));% Power during the stimulation on the frequency requested

                bbb_low=bbb_low(:,:,ind_StiFq);
                ddd_low=ddd_low(:,:,ind_StiFq);
                
                % Mean power before and during stimulation
                Mx_mean_before_low(i,fq)=nanmean(bbb_low(:));
                Mx_sem_before_low(i,fq)=nanstd(nanmean(nanmean(bbb_low,3),2))/sqrt(size(bbb_low,1));
                
                Mx_mean_during_low(i,fq)=nanmean(ddd_low(:));
                Mx_sem_during_low(i,fq)=nanstd(nanmean(nanmean(ddd_low,3),2))/sqrt(size(ddd_low,1));
                
                % Difference of during and before 
                diff_low = ddd_low-bbb_low;
                Mx_Diff_mean_low(i,fq)=nanmean(diff_low(:));
                Mx_Diff_sem_low(i,fq)=nanstd(nanmean(nanmean(diff_low,3),2))/sqrt(size(diff_low,1)); 
                
                
                % high frequency
                bbb_high=squeeze(LFPpower_Before_high(i,:,:,fq,:));% Power before the stimulation on the frequency requested
                ddd_high=squeeze(LFPpower_high(i,:,:,fq,:));% Power during the stimulation on the frequency requested

                bbb_high=bbb_high(:,:,ind_StiFq);
                ddd_high=ddd_high(:,:,ind_StiFq);
                
                % Mean power before and during stimulation
                Mx_mean_before_high(i,fq)=nanmean(bbb_high(:));
                Mx_sem_before_high(i,fq)=nanstd(nanmean(nanmean(bbb_high,3),2))/sqrt(size(bbb_high,1));
                
                Mx_mean_during_high(i,fq)=nanmean(ddd_high(:));
                Mx_sem_during_high(i,fq)=nanstd(nanmean(nanmean(ddd_high,3),2))/sqrt(size(ddd_high,1));
                
                % Difference of during and before 
                diff_high = ddd_high-bbb_high;
                Mx_Diff_mean_high(i,fq)=nanmean(diff_high(:));
                Mx_Diff_sem_high(i,fq)=nanstd(nanmean(nanmean(diff_high,3),2))/sqrt(size(diff_high,1)); 
            end
        end

% Plot it

for i=1:length(structlist)
            
    
   % Difference
   q = figure('Position', [200          48         1500         926]);
   errorbar(fq_list, Mx_Diff_mean_low(i,:),Mx_Diff_sem_low(i,:),'Color','k', 'LineWidth', 2, 'LineStyle', '--'); hold on
   errorbar(fq_list, Mx_Diff_mean_high(i,:),Mx_Diff_sem_high(i,:),'Color','k', 'LineWidth', 2);
   xlim([0 20 ]);
%    ylim([0 12E4]);
   xlabel('Frequency (Hz)');
   ylabel ('Difference in spectral power (stimulation- presimulation) (a.u.)');
   set(gca, 'FontSize', 14);
   legend('\fontsize{20} Slow wave sleep', '\fontsize{20} REM sleep', 'Location', 'east');
            if sav
            saveas(q,[num2str(structlist{i}) '_Difference_av_SWS_REM.fig'])
            saveFigure(q,[num2str(structlist{i}) '_Difference_av_SWS_REM'],res)
            end
   
   
end