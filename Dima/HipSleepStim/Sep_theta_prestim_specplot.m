% Sep_theta_prestim.m

%% Parameters

sav=0; % Do you want to save the pictures?

chan = 'dHPC_rip_left';  % Name of channel to compute theta

fq_list=[1 2 4 7 10 13 15 20]; % List of frequencies used
max_ev = 50; % Maximum number of events for one freq
max_res = 67; % Maximum resolution allowed for FFT
max_fq = 15; % Maximum number of frequencies that could be used

low_rat = 1; % Threshold ratio fot the low frequency states
high_rat = 1.5; % Threshold ratio fot the theta frequency states

% Dir.path={
%     '/media/mobsrick/DataMOBs71/Mouse-534/09062017_SleepStim/FEAR-Mouse-534-09062017';
%     '/media/mobsrick/DataMOBs71/Mouse-534/12062017-SleepStim/FEAR-Mouse-534-12062017';
%     '/media/mobsrick/DataMOBs71/Mouse-534/14062017-SleepStim/FEAR-Mouse-534-14062017';
%     '/media/mobsrick/DataMOBs71/Mouse-534/15062017-SleepStim/FEAR-Mouse-534-15062017';
%     '/media/mobsrick/DataMOBs71/Mouse-534/16062017-SleepStim/FEAR-Mouse-534-16062017'
%     };

Dir.path={
    '/media/mobsrick/DataMOBs71/Mouse-538/06072017_SleepStim/FEAR-Mouse-538-06072017';
    '/media/mobsrick/DataMOBs71/Mouse-538/07072017_SleepStim/FEAR-Mouse-538-07072017'
    };


dirpath_res = '/media/mobsrick/DataMOBs71/Mouse-538/Results/theta_low_0607'; % Folder to save the pictures


% Load res_matrix
load /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/f_0-20;

% List of structures to plot and compute
structlist={'dHPC_rip', 'PFCx_deep', 'PFCx_deep_left', 'dHPC_deep', 'dHPC_rip_left', 'vHPC_rip'};


% Memory allocation
LFPpower610=nan(length(Dir.path),max_ev,max_res,length(fq_list)); 
LFPpower36=nan(length(Dir.path),max_ev,max_res,length(fq_list));


%% Load data

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

%% Take 6-9 Hz and 3-6 Hz
ind_610 = find(f>6&f<10);
Sp_610 = Sp(:,ind_610);
Stsd_610=tsd(t*1E4,Sp_610);

ind_36 = find(f>3&f<6);
Sp_36 = Sp(:,ind_36);
Stsd_36=tsd(t*1E4,Sp_36);

%% Make Epochs

for fq=1:length(fq_list)
        Prestim{m,fq} =intervalSet(StimInfo.StartTime(StimInfo.Freq==fq_list(fq))*1E4-10E4,...
            StimInfo.StartTime(StimInfo.Freq==fq_list(fq))*1E4);


%% Calculate power
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


%% Plot ratio

h=figure(1);
k=1;
for m=1:length(Dir.path)
    for i = 1:length(fq_list)
        figplot{m,i} = subplot(length(Dir.path),length(fq_list),k); hold on
        if length(Dir.path) == 1
            a = squeeze(nanmean(LFPpower610,3))./squeeze(nanmean(LFPpower36,3)); % Ratio
            b = 1:1:sum(~isnan(a(:,i))); % number of events per frequency per day
            a = (a(b,i))'; % Ratio for each event
            plot (b, a);
            ylim([0 5]);
            k=k+1;
        else
            a = squeeze(nanmean(LFPpower610,3))./squeeze(nanmean(LFPpower36,3)); % Ratio
            b = 1:1:sum(~isnan(a(m,:,i))); % number of events per frequeny per day
            a = a(m,b,i); % Ratio for each event
            plot (b, a); 
            ylim([0 5]);
            k=k+1;
        end
        
    end
end


        cd(dirpath_res)
        if sav
            saveas(h,'ratio_all.fig')
            saveFigure(h,'ratio_all',dirpath_res)
        end


%% Plot spectra
% Load or compute data
try
    
    cd (dirpath_res);
    disp(['Loading existing data from DataRampOver1DayQuantif_no_selection.mat']);
    load(['DataRampOver1DayQuantif_no_selection.mat']);
    
catch
    % Memory allocation
    LFPpower=nan(length(StepName),length(structlist), length(Dir.path),50,67,15); % 50 : nb d'events (max estimé)/ 67 : nb fqce dans le spectre / 15 : nb de fqce de stim dans la rampe (max)
    LFPpower_Before=nan(length(StepName),length(structlist), length(Dir.path),50,67,15);

    for man=1:length(Dir.path) 
        cd (Dir.path{man})
        MouseNb=str2num(Dir.name{man}(end-2:end));
        Mousename=['M' Dir.name{man}(end-2:end)];cd 
        disp(Mousename)
        
        load StimInfo
        
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
                    eval(['save(''',Dir.path{man},'/SpectrumDataL/Spectrum',num2str(temp.channel),'.mat'',','''Sp'',','''t'',','''f'',','''params'',','''movingwin'');'])
                end
                StsdL=tsd(t*1E4,Sp);

            else
                disp(['no channel for ' structlist{i} ' in this mouse '])
            end
            
            % Calculation of power at the frequencies present in Sti% ,'markerfacecolor',colori{i}mInfo
            for fq=1:nb_fq
                LaserInt{man,fq} =intervalSet(StimInfo.StartTime(StimInfo.Freq==fq_list(fq))*1E4, StimInfo.StopTime(StimInfo.Freq==fq_list(fq))*1E4);

                for evnt=1:length(Start(LaserInt{man,fq}))

                    if length(f)>67%164
                        LFPpower(1,i,man,evnt,1:length(f1),fq)= interp1(f,mean(Data(Restrict(StsdL,subset(LaserInt{man,fq},evnt)))),f1);
                        LFPpower_Before(1,i,man,evnt,1:length(f1),fq)= interp1(f,mean(Data(Restrict(StsdL,shift(subset(LaserInt{man,fq},evnt), -30E4)))),f1);
                    else
                        LFPpower(1,i,man,evnt,1:length(f1),fq)= mean(Data(Restrict(StsdL,subset(LaserInt{man,fq},evnt))));
                        LFPpower_Before(1,i,man,evnt,1:length(f1),fq)= mean(Data(Restrict(StsdL,shift(subset(LaserInt{man,fq},evnt), -30E4))));
                    end
                end
            end

        end
    end
    cd(dirpath_res)
    
    if sav
        save DataRampOver1DayQuantif_no_selection LFPpower LFPpower_Before f1 f structlistname fq_list Dir LaserInt StimInfoAllMan f nb_fq fq_list
    end
end
    


% Separate epochs with ratio < 1 and ratio > 2
a = squeeze(nanmean(LFPpower610,3))./squeeze(nanmean(LFPpower36,3)); % Ratio matrix (days*stims*freqstims)

idx_events_low = nan(length(Dir.path), length(fq_list), max_ev);
idx_events_high = nan(length(Dir.path), length(fq_list), max_ev);


for m = 1:length(Dir.path)
    for k = 1:length(fq_list)
                l = length(find(squeeze(a(m,:,k))<low_rat));
                idx_events_low(m,k,1:l) = find(squeeze(a(m,:,k))<low_rat);
                h = length(find(squeeze(a(m,:,k))>high_rat));
                idx_events_high(m,k,1:h) = find(squeeze(a(m,:,k))>high_rat);
    end
end


% Plot the distribution of ratios
RAR = reshape (a, [1 size(a,1)*size(a,2)*size(a,3)]);
RAR(find(isnan(RAR))) = [];
r = figure;
hist(RAR,100);
title('Ratio 6-10Hz/3-6Hz');


        cd(dirpath_res)
        if sav
            saveas(r,'ratio_610_36.fig')
            saveFigure(r,'ratio_610_36',dirpath_res)
        end
                
        save ratio12 a idx_events_low idx_events_high
        
        LFPpower_Before_low = nan(length(structlist),length(Dir.path),max_ev,length(f1),length(fq_list));
        LFPpower_low = nan(length(structlist),length(Dir.path),max_ev,length(f1),length(fq_list));
        
        
% Plot spectra for ratio < 1

    for man=1:length(Dir.path) cd 
        manSpfig=figure('Position', [200          48         1500         926]);
        Mousename=['M' Dir.name{man}(end-2:end)];
                
        nb_fq=length(fq_list);

        for i=1:length(structlist)


            for fq=1:nb_fq
                sub{i,fq}=subplot(length(structlist),nb_fq,nb_fq*(i-1)+fq); hold on
                  
                
                id_low = squeeze(idx_events_low(man, fq, :));
                id_low(find(isnan(id_low))) = [];
                LFPpower_BeforeM=squeeze(LFPpower_Before(1,i,man,id_low,:,fq));
                LFPpower_Before_low(i,man,1:length(id_low),:,fq) = squeeze(LFPpower_Before(1,i,man,id_low,:,fq));
                
                
                if length(id_low) > 1
                    shadedErrorBar(f1',nanmean(LFPpower_BeforeM),nanstd(LFPpower_BeforeM)/sqrt(length(id_low)), {},0);
                elseif length(id_low) == 1
                    plot(f1',LFPpower_BeforeM, 'k');
                else
                    plot ([1:5], [1:5]);
                end
                
                

                if strfind(structlist{i}, 'Bulb')
                    if length(id_low) > 1
                    shadedErrorBar(f1',nanmean(squeeze(LFPpower(1,i,man,id_low,:,fq))),nanstd(squeeze(LFPpower(1,i,man,id_low,:,fq)))/...
                        sqrt(length(id_low)),'b',1);
                    elseif length(id_low) == 1
                        plot(f1,squeeze(LFPpower(1,i,man,id_low,:,fq)), 'b');
                    else
                        plot ([1:5], [1:5]);
                    end
                elseif strfind(structlist{i}, 'dHPC')
                    if length(id_low) > 1
                    shadedErrorBar(f1',nanmean(squeeze(LFPpower(1,i,man,id_low,:,fq))),nanstd(squeeze(LFPpower(1,i,man,id_low,:,fq)))/...
                        sqrt(length(id_low)),'c',1);
                    elseif length(id_low) == 1
                        plot(f1',squeeze(LFPpower(1,i,man,id_low,:,fq)), 'c');
                    else
                        plot ([1:5], [1:5]);
                    end
                elseif strfind(structlist{i}, 'PFC')
                    if length(id_low) > 1
                    shadedErrorBar(f1',nanmean(squeeze(LFPpower(1,i,man,id_low,:,fq))),nanstd(squeeze(LFPpower(1,i,man,id_low,:,fq)))/...
                        sqrt(length(id_low)),'r',1);
                    elseif length(id_low) == 1
                        plot(f1,squeeze(LFPpower(1,i,man,id_low,:,fq)), 'r');
                    else
                        plot ([1:5],[1:5]);
                    end
                elseif strfind(structlist{i}, 'vHPC')
                    if length(id_low) > 1
                    shadedErrorBar(f1',nanmean(squeeze(LFPpower(1,i,man,id_low,:,fq))),nanstd(squeeze(LFPpower(1,i,man,id_low,:,fq)))/...
                        sqrt(length(id_low)),{'markerfacecolor', [1 0.6 0.2]},1);
                    elseif length(id_low) == 1
                        plot(f1,squeeze(LFPpower(1,i,man,id_low,:,fq)),'Color', [1 0.6 0.2]);
                    else
                        plot ([1:5], [1:5]);
                    end
                end
                
                LFPpower_low(i,man,1:length(id_low),:,fq) = squeeze(LFPpower(1,i,man,id_low,:,fq));
                
                
                if fq==1,ylabel(structlistname{i});end
                xlim([0 f1(end)]);
                if strfind(structlist{i}, 'Bulb')
                    ylim([0 8E5])
                elseif strfind(structlist{i}, 'PFC')
                    ylim([0 4E5])
                end
                if i==length(structlist), xlabel(['stim ' num2str(fq_list(fq)) 'Hz']);end
                if i==1&&fq==1, text(-0.2,1.3,[' ' Dir.path{man}(end-7:end) ' - ' Mousename ' Low frequency state'],'units','normalized');end
                xlabel(num2str(length(id_low)));
            end

        end

        for i=1:length(structlist)
            for fq=1:nb_fq
                sub{i,fq}=subplot(length(structlist),nb_fq,nb_fq*(i-1)+fq); hold on
                if strfind(structlist{i}, 'Bulb')
                    ylim([0 4E5])
%                 elseif strfind(structlist{i}, 'HPC')
%                     ylim([0 4E5])
                elseif strfind(structlist{i}, 'PFC')
                    ylim([0 9E4])
                end
            end
        end
        
        cd(dirpath_res)
        if sav
            saveas(manSpfig,[ Mousename '_' Dir.path{man}(end-7:end) '_Spec_low_freq.fig'])
            saveFigure(manSpfig,[ Mousename '_' Dir.path{man}(end-7:end) '_Spec_low_freq'],dirpath_res)
        end

    end

    % Plot spectra averaged across days for ratio < 1

    idx_sum_low = nan(1,length(fq_list));
        for y = 1:length(Dir.path)
            for c = 1:length(fq_list)
                idx_tosum_low = squeeze(idx_events_low(y,c,:));
                idx_sum_low(y,c) = length(idx_tosum_low(find(~isnan(idx_tosum_low))));
            end
        end

        idx_sum_low = sum(idx_sum_low,1);

        manSpfig=figure('Position', [200          48         1500         926]);
        Mousename=['M' Dir.name{man}(end-2:end)];

        nb_fq=length(fq_list);

        for i=1:length(structlist)


            for fq=1:nb_fq
                sub{i,fq}=subplot(length(structlist),nb_fq,nb_fq*(i-1)+fq); hold on
                  
                
                LFPpower_Before_av_low=squeeze(LFPpower_Before_low(i,:,:,:,fq));
                LFPpower_Before_av_low=reshape(LFPpower_Before_av_low, [size(LFPpower_Before_av_low,1)*size(LFPpower_Before_av_low,2),...
                    size(LFPpower_Before_av_low,3)]);
                
                LFPpower_av_low = squeeze(LFPpower_low(i,:,:,:,fq));
                LFPpower_av_low=reshape(LFPpower_av_low, [size(LFPpower_av_low,1)*size(LFPpower_av_low,2),...
                    size(LFPpower_av_low,3)]);
                
                
                if idx_sum_low(fq) > 1
                    shadedErrorBar(f1',nanmean(LFPpower_Before_av_low),nanstd(LFPpower_Before_av_low)/sqrt(idx_sum_low(fq)), {},0);
                elseif idx_sum_low(fq) == 1
                    plot(f1',nanmean(LFPpower_Before_av_low), 'k');
                else
                    plot ([1:5], [1:5]);
                end
                
                

                if strfind(structlist{i}, 'Bulb')
                    if idx_sum_low(fq) > 1
                    shadedErrorBar(f1',nanmean(LFPpower_av_low),nanstd(LFPpower_av_low)/...
                        sqrt(idx_sum_low(fq)),'b',1);
                    elseif idx_sum_low(fq) == 1
                        plot(f1,nanmean(LFPpower_Before_av_low), 'b');
                    else
                        plot ([1:5], [1:5]);
                    end
                elseif strfind(structlist{i}, 'dHPC')
                    if idx_sum_low(fq) > 1
                    shadedErrorBar(f1',nanmean(LFPpower_av_low),nanstd(LFPpower_av_low)/...
                        sqrt(idx_sum_low(fq)),'c',1);
                    elseif idx_sum_low(fq) == 1
                        plot(f1,nanmean(LFPpower_Before_av_low), 'c');
                    else
                        plot ([1:5], [1:5]);
                    end
                elseif strfind(structlist{i}, 'PFC')
                    if idx_sum_low(fq) > 1
                    shadedErrorBar(f1',nanmean(LFPpower_av_low),nanstd(LFPpower_av_low)/...
                        sqrt(idx_sum_low(fq)),'r',1);
                    elseif idx_sum_low(fq) == 1
                        plot(f1,nanmean(LFPpower_Before_av_low), 'r');
                    else
                        plot ([1:5], [1:5]);
                    end
                elseif strfind(structlist{i}, 'vHPC')
                    if idx_sum_low(fq) > 1
                    shadedErrorBar(f1',nanmean(LFPpower_av_low),nanstd(LFPpower_av_low)/...
                        sqrt(idx_sum_low(fq)),{'markerfacecolor', [1 0.6 0.2]},1);
                    elseif idx_sum_low(fq) == 1
                        plot(f1,nanmean(LFPpower_Before_av_low),'Color', [1 0.6 0.2]);
                    else
                        plot ([1:5], [1:5]);
                    end
                end
                
                
                if fq==1,ylabel(structlistname{i});end
                xlim([0 f1(end)]);
                if strfind(structlist{i}, 'Bulb')
                    ylim([0 8E5])
                elseif strfind(structlist{i}, 'PFC')
                    ylim([0 4E5])
                end
                if i==length(structlist), xlabel(['stim ' num2str(fq_list(fq)) 'Hz']);end
                if i==1&&fq==1, text(-0.2,1.3,[Mousename ' Low frequency state Average'],'units','normalized');end
                xlabel(num2str(idx_sum_low(fq)));
            end

        end

        for i=1:length(structlist)
            for fq=1:nb_fq
                sub{i,fq}=subplot(length(structlist),nb_fq,nb_fq*(i-1)+fq); hold on
                if strfind(structlist{i}, 'Bulb')
                    ylim([0 4E5])
%                 elseif strfind(structlist{i}, 'HPC')
%                     ylim([0 4E5])
                elseif strfind(structlist{i}, 'PFC')
                    ylim([0 9E4])
                end
            end
        end
        
        cd(dirpath_res)
        if sav
            saveas(manSpfig,[ Mousename '_' Dir.path{man}(end-7:end) '_Spec_low_freq_av.fig'])
            saveFigure(manSpfig,[ Mousename '_' Dir.path{man}(end-7:end) '_Spec_low_freq_av'],dirpath_res)
        end
        
        
        
        LFPpower_Before_high = nan(length(structlist),length(Dir.path),max_ev,length(f1),length(fq_list));
        LFPpower_high = nan(length(structlist),length(Dir.path),max_ev,length(f1),length(fq_list));
        
% Plot spectra for ratio > 2

    for man=1:length(Dir.path) cd 
        manSpfig=figure('Position', [200          48         1500         926]);
        Mousename=['M' Dir.name{man}(end-2:end)];

        nb_fq=length(fq_list);

        for i=1:length(structlist)


            for fq=1:nb_fq
                sub{i,fq}=subplot(length(structlist),nb_fq,nb_fq*(i-1)+fq); hold on
                  
                
                id_high = squeeze(idx_events_high(man, fq, :));
                id_high(find(isnan(id_high))) = [];
                LFPpower_BeforeM=squeeze(LFPpower_Before(1,i,man,id_high,:,fq));
                LFPpower_Before_high(i,man,1:length(id_high),:,fq) = squeeze(LFPpower_Before(1,i,man,id_high,:,fq));
                
                if length(id_high) > 1
                    shadedErrorBar(f1',nanmean(LFPpower_BeforeM),nanstd(LFPpower_BeforeM)/sqrt(length(id_high)), {},0);
                elseif length(id_high) == 1
                    plot(f1',LFPpower_BeforeM, 'k');
                else
                    plot ([1:5], [1:5]);
                end
                
                

                if strfind(structlist{i}, 'Bulb')
                    if length(id_high) > 1
                    shadedErrorBar(f1',nanmean(squeeze(LFPpower(1,i,man,id_high,:,fq))),nanstd(squeeze(LFPpower(1,i,man,id_high,:,fq)))/...
                        sqrt(length(id_high)),'b',1);
                    elseif length(id_high) == 1
                        plot(f1,squeeze(LFPpower(1,i,man,id_high,:,fq)), 'b');
                    else
                        plot ([1:5], [1:5]);
                    end
                elseif strfind(structlist{i}, 'dHPC')
                    if length(id_high) > 1
                    shadedErrorBar(f1',nanmean(squeeze(LFPpower(1,i,man,id_high,:,fq))),nanstd(squeeze(LFPpower(1,i,man,id_high,:,fq)))/...
                        sqrt(length(id_high)),'c',1);
                    elseif length(id_high) == 1
                        plot(f1',squeeze(LFPpower(1,i,man,id_high,:,fq)), 'c');
                    else
                        plot ([1:5], [1:5]);
                    end
                elseif strfind(structlist{i}, 'PFC')
                    if length(id_high) > 1
                    shadedErrorBar(f1',nanmean(squeeze(LFPpower(1,i,man,id_high,:,fq))),nanstd(squeeze(LFPpower(1,i,man,id_high,:,fq)))/...
                        sqrt(length(id_high)),'r',1);
                    elseif length(id_high) == 1
                        plot(f1,squeeze(LFPpower(1,i,man,id_high,:,fq)), 'r');
                    else
                        plot ([1:5], [1:5]);
                    end
                elseif strfind(structlist{i}, 'vHPC')
                    if length(id_high) > 1
                    shadedErrorBar(f1',nanmean(squeeze(LFPpower(1,i,man,id_high,:,fq))),nanstd(squeeze(LFPpower(1,i,man,id_high,:,fq)))/...
                        sqrt(length(id_high)),{'markerfacecolor', [1 0.6 0.2]},1);
                    elseif length(id_high) == 1
                        plot(f1,squeeze(LFPpower(1,i,man,id_high,:,fq)),'Color', [1 0.6 0.2]);
                    else
                        plot ([1:5], [1:5]);
                    end
                end
                
                LFPpower_high(i,man,1:length(id_high),:,fq) = squeeze(LFPpower(1,i,man,id_high,:,fq));
                

                if fq==1,ylabel(structlistname{i});end
                xlim([0 f1(end)]);
                if strfind(structlist{i}, 'Bulb')
                    ylim([0 8E5])
                elseif strfind(structlist{i}, 'PFC')
                    ylim([0 4E5])
                end
                if i==length(structlist), xlabel(['stim ' num2str(fq_list(fq)) 'Hz']);end
                if i==1&&fq==1, text(-0.2,1.3,[' ' Dir.path{man}(end-7:end) ' - ' Mousename ' Theta state'],'units','normalized');end
                xlabel(num2str(length(id_high)));
            end

        end

        for i=1:length(structlist)
            for fq=1:nb_fq
                sub{i,fq}=subplot(length(structlist),nb_fq,nb_fq*(i-1)+fq); hold on
                if strfind(structlist{i}, 'Bulb')
                    ylim([0 4E5])
%                 elseif strfind(structlist{i}, 'HPC')
%                     ylim([0 4E5])
                elseif strfind(structlist{i}, 'PFC')
                    ylim([0 9E4])
                end
            end
        end
        
        cd(dirpath_res)
        if sav
            saveas(manSpfig,[ Mousename '_' Dir.path{man}(end-7:end) '_spec_theta_state.fig'])
            saveFigure(manSpfig,[ Mousename '_' Dir.path{man}(end-7:end) '_spec_theta_state'],dirpath_res)
        end

    end
    
    
     % Plot spectra averaged across days for ratio > 2

    idx_sum_high = nan(1,length(fq_list));
        for y = 1:length(Dir.path)
            for c = 1:length(fq_list)
                idx_tosum_high = squeeze(idx_events_high(y,c,:));
                idx_sum_high(y,c) = length(idx_tosum_high(find(~isnan(idx_tosum_high))));
            end
        end

        idx_sum_high = sum(idx_sum_high,1);

        
        manSpfig=figure('Position', [200          48         1500         926]);
        Mousename=['M' Dir.name{man}(end-2:end)];

        nb_fq=length(fq_list);

        for i=1:length(structlist)


            for fq=1:nb_fq
                sub{i,fq}=subplot(length(structlist),nb_fq,nb_fq*(i-1)+fq); hold on
                  
                
                LFPpower_Before_av_high=squeeze(LFPpower_Before_high(i,:,:,:,fq));
                LFPpower_Before_av_high=reshape(LFPpower_Before_av_high, [size(LFPpower_Before_av_high,1)*size(LFPpower_Before_av_high,2),...
                    size(LFPpower_Before_av_high,3)]);
                
                LFPpower_av_high = squeeze(LFPpower_high(i,:,:,:,fq));
                LFPpower_av_high=reshape(LFPpower_av_high, [size(LFPpower_av_high,1)*size(LFPpower_av_high,2),...
                    size(LFPpower_av_high,3)]);
                
                
                if idx_sum_high(fq) > 1
                    shadedErrorBar(f1',nanmean(LFPpower_Before_av_high),nanstd(LFPpower_Before_av_high)/sqrt(idx_sum_high(fq)), {},0);
                elseif idx_sum_high(fq) == 1
                    plot(f1',nanmean(LFPpower_Before_av_high), 'k');
                else
                    plot ([1:5], [1:5]);
                end
                
                

                if strfind(structlist{i}, 'Bulb')
                    if idx_sum_high(fq) > 1
                    shadedErrorBar(f1',nanmean(LFPpower_av_high),nanstd(LFPpower_av_high)/...
                        sqrt(idx_sum_high(fq)),'b',1);
                    elseif idx_sum_high(fq) == 1
                        plot(f1,nanmean(LFPpower_av_high), 'b');
                    else
                        plot ([1:5], [1:5]);
                    end
                elseif strfind(structlist{i}, 'dHPC')
                    if idx_sum_high(fq) > 1
                    shadedErrorBar(f1',nanmean(LFPpower_av_high),nanstd(LFPpower_av_high)/...
                        sqrt(idx_sum_high(fq)),'c',1);
                    elseif idx_sum_high(fq) == 1
                        plot(f1,nanmean(LFPpower_av_high), 'c');
                    else
                        plot ([1:5], [1:5]);
                    end
                elseif strfind(structlist{i}, 'PFC')
                    if idx_sum_high(fq) > 1
                    shadedErrorBar(f1',nanmean(LFPpower_av_high),nanstd(LFPpower_av_high)/...
                        sqrt(idx_sum_high(fq)),'r',1);
                    elseif idx_sum_high(fq) == 1
                        plot(f1,nanmean(LFPpower_av_high), 'r');
                    else
                        plot ([1:5], [1:5]);
                    end
                elseif strfind(structlist{i}, 'vHPC')
                    if idx_sum_high(fq) > 1
                    shadedErrorBar(f1',nanmean(LFPpower_av_high),nanstd(LFPpower_av_high)/...
                        sqrt(idx_sum_high(fq)),{'markerfacecolor', [1 0.6 0.2]},1);
                    elseif idx_sum_high(fq) == 1
                        plot(f1,nanmean(LFPpower_av_high),'Color', [1 0.6 0.2]);
                    else
                        plot ([1:5], [1:5]);
                    end
                end
                
                
                if fq==1,ylabel(structlistname{i});end
                xlim([0 f1(end)]);
                if strfind(structlist{i}, 'Bulb')
                    ylim([0 8E5])
                elseif strfind(structlist{i}, 'PFC')
                    ylim([0 4E5])
                end
                if i==length(structlist), xlabel(['stim ' num2str(fq_list(fq)) 'Hz']);end
                if i==1&&fq==1, text(-0.2,1.3,[Mousename ' high frequency state Average'],'units','normalized');end
                xlabel(num2str(idx_sum_high(fq)));
            end

        end

        for i=1:length(structlist)
            for fq=1:nb_fq
                sub{i,fq}=subplot(length(structlist),nb_fq,nb_fq*(i-1)+fq); hold on
                if strfind(structlist{i}, 'Bulb')
                    ylim([0 4E5])
%                 elseif strfind(structlist{i}, 'HPC')
%                     ylim([0 4E5])
                elseif strfind(structlist{i}, 'PFC')
                    ylim([0 9E4])
                end
            end
        end
        
        cd(dirpath_res)
        if sav
            saveas(manSpfig,[ Mousename '_' Dir.path{man}(end-7:end) '_Spec_high_freq_av.fig'])
            saveFigure(manSpfig,[ Mousename '_' Dir.path{man}(end-7:end) '_Spec_high_freq_av'],dirpath_res)
        end
        
        
 % Plot spectra averaged across days for both ratios simultaneously

        
        manSpfig=figure('Position', [200          48         1500         926]);

        nb_fq=length(fq_list);

        for i=1:length(structlist)


            for fq=1:nb_fq
                sub{i,fq}=subplot(length(structlist),nb_fq,nb_fq*(i-1)+fq); hold on
                
                LFPpower_Before_av_low=squeeze(LFPpower_Before_low(i,:,:,:,fq));
                LFPpower_Before_av_low=reshape(LFPpower_Before_av_low, [size(LFPpower_Before_av_low,1)*size(LFPpower_Before_av_low,2),...
                    size(LFPpower_Before_av_low,3)]);
                
                LFPpower_av_low = squeeze(LFPpower_low(i,:,:,:,fq));
                LFPpower_av_low=reshape(LFPpower_av_low, [size(LFPpower_av_low,1)*size(LFPpower_av_low,2),...
                    size(LFPpower_av_low,3)]);
                
                
                LFPpower_Before_av_high=squeeze(LFPpower_Before_high(i,:,:,:,fq));
                LFPpower_Before_av_high=reshape(LFPpower_Before_av_high, [size(LFPpower_Before_av_high,1)*size(LFPpower_Before_av_high,2),...
                    size(LFPpower_Before_av_high,3)]);
                
                LFPpower_av_high = squeeze(LFPpower_high(i,:,:,:,fq));
                LFPpower_av_high=reshape(LFPpower_av_high, [size(LFPpower_av_high,1)*size(LFPpower_av_high,2),...
                    size(LFPpower_av_high,3)]);
                
                
%                 if idx_sum_high(fq) > 1
%                     shadedErrorBar(f1',nanmean(LFPpower_Before_av_low),nanstd(LFPpower_Before_av_low)/sqrt(idx_sum_low(fq)), {},0);
%                     shadedErrorBar(f1',nanmean(LFPpower_Before_av_high),nanstd(LFPpower_Before_av_high)/sqrt(idx_sum_high(fq)),...
%                         {'k--','markerfacecolor','k'},0);
%                 elseif idx_sum_high(fq) == 1
%                     plot(f1',nanmean(LFPpower_Before_av_low), 'k');
%                     plot(f1,nanmean(LFPpower_av_high), 'LineStyle','--','Color', 'k');
%                 else
%                     plot ([1:5], [1:5]);
%                 end
                
                

%                 if strfind(structlist{i}, 'Bulb')
%                     if idx_sum_high(fq) > 1
%                     shadedErrorBar(f1',nanmean(LFPpower_av_low),nanstd(LFPpower_av_low)/...
%                         sqrt(idx_sum_low(fq)),'b',1);
%                     shadedErrorBar(f1',nanmean(LFPpower_av_high),nanstd(LFPpower_av_high)/...
%                         sqrt(idx_sum_high(fq)),{'--','markerfacecolor','g'},1);
%                     elseif idx_sum_high(fq) == 1
%                         plot(f1,nanmean(LFPpower_av_low), 'b');
%                         plot(f1,nanmean(LFPpower_av_high), 'LineStyle','--','Color', 'g');
%                     else
%                         plot ([1:5], [1:5]);
%                     end
%                 elseif strfind(structlist{i}, 'dHPC')
%                     if idx_sum_high(fq) > 1
%                     shadedErrorBar(f1',nanmean(LFPpower_av_low),nanstd(LFPpower_av_low)/...
%                         sqrt(idx_sum_low(fq)),'c',1);
%                     shadedErrorBar(f1',nanmean(LFPpower_av_high),nanstd(LFPpower_av_high)/...
%                         sqrt(idx_sum_high(fq)),{'--','markerfacecolor','g'},1);
%                     elseif idx_sum_high(fq) == 1
%                         plot(f1,nanmean(LFPpower_av_low), 'c');
%                         plot(f1,nanmean(LFPpower_av_high), 'LineStyle','--','Color', 'g');
%                     else
%                         plot ([1:5], [1:5]);
%                     end
%                 elseif strfind(structlist{i}, 'PFC')
%                     if idx_sum_high(fq) > 1
%                     shadedErrorBar(f1',nanmean(LFPpower_av_low),nanstd(LFPpower_av_low)/...
%                         sqrt(idx_sum_low(fq)),'r',1);
%                     shadedErrorBar(f1',nanmean(LFPpower_av_high),nanstd(LFPpower_av_high)/...
%                         sqrt(idx_sum_high(fq)),{'--','markerfacecolor','g'},1);
%                     elseif idx_sum_high(fq) == 1
%                         plot(f1,nanmean(LFPpower_av_low), 'r');
%                         plot(f1,nanmean(LFPpower_av_high), 'LineStyle','--','Color', 'g');
%                     else
%                         plot ([1:5], [1:5]);
%                     end
%                 elseif strfind(structlist{i}, 'vHPC')
%                     if idx_sum_high(fq) > 1
%                     shadedErrorBar(f1',nanmean(LFPpower_av_low),nanstd(LFPpower_av_low)/...
%                         sqrt(idx_sum_low(fq)),{'markerfacecolor', [1 0.6 0.2]},1);
%                     shadedErrorBar(f1',nanmean(LFPpower_av_high),nanstd(LFPpower_av_high)/...
%                         sqrt(idx_sum_high(fq)),{'--', 'markerfacecolor', 'g'},1);
%                     elseif idx_sum_high(fq) == 1
%                         plot(f1,nanmean(LFPpower_av_low),'Color', [1 0.6 0.2]);
%                         plot(f1,nanmean(LFPpower_av_high),'LineStyle','--','Color', 'g');
%                     else
%                         plot ([1:5], [1:5]);
%                     end
%                 end
                
                if strfind(structlist{i}, 'Bulb')
                    if idx_sum_high(fq) > 1
                    shadedErrorBar(f1',nanmean(LFPpower_av_low),nanstd(LFPpower_av_low)/...
                        sqrt(idx_sum_low(fq)),'k',1);
                    shadedErrorBar(f1',nanmean(LFPpower_av_high),nanstd(LFPpower_av_high)/...
                        sqrt(idx_sum_high(fq)),{'--','markerfacecolor','b'},1);
                    elseif idx_sum_high(fq) == 1
                        plot(f1,nanmean(LFPpower_av_low), 'k');
                        plot(f1,nanmean(LFPpower_av_high), 'LineStyle','--','Color', 'b');
                    else
                        plot ([1:5], [1:5]);
                    end
                elseif strfind(structlist{i}, 'dHPC')
                    if idx_sum_high(fq) > 1
                    shadedErrorBar(f1',nanmean(LFPpower_av_low),nanstd(LFPpower_av_low)/...
                        sqrt(idx_sum_low(fq)),'k',1);
                    shadedErrorBar(f1',nanmean(LFPpower_av_high),nanstd(LFPpower_av_high)/...
                        sqrt(idx_sum_high(fq)),{'--','markerfacecolor','c'},1);
                    elseif idx_sum_high(fq) == 1
                        plot(f1,nanmean(LFPpower_av_low), 'k');
                        plot(f1,nanmean(LFPpower_av_high), 'LineStyle','--','Color', 'c');
                    else
                        plot ([1:5], [1:5]);
                    end
                elseif strfind(structlist{i}, 'PFC')
                    if idx_sum_high(fq) > 1
                    shadedErrorBar(f1',nanmean(LFPpower_av_low),nanstd(LFPpower_av_low)/...
                        sqrt(idx_sum_low(fq)),'k',1);
                    shadedErrorBar(f1',nanmean(LFPpower_av_high),nanstd(LFPpower_av_high)/...
                        sqrt(idx_sum_high(fq)),{'--','markerfacecolor','r'},1);
                    elseif idx_sum_high(fq) == 1
                        plot(f1,nanmean(LFPpower_av_low), 'k');
                        plot(f1,nanmean(LFPpower_av_high), 'LineStyle','--','Color', 'r');
                    else
                        plot ([1:5], [1:5]);
                    end
                elseif strfind(structlist{i}, 'vHPC')
                    if idx_sum_high(fq) > 1
                    shadedErrorBar(f1',nanmean(LFPpower_av_low),nanstd(LFPpower_av_low)/...
                        sqrt(idx_sum_low(fq)),{'markerfacecolor', 'k'},1);
                    shadedErrorBar(f1',nanmean(LFPpower_av_high),nanstd(LFPpower_av_high)/...
                        sqrt(idx_sum_high(fq)),{'--', 'markerfacecolor', [1 0.6 0.2]},1);
                    elseif idx_sum_high(fq) == 1
                        plot(f1,nanmean(LFPpower_av_low),'Color', 'k');
                        plot(f1,nanmean(LFPpower_av_high),'LineStyle','--','Color', [1 0.6 0.2]);
                    else
                        plot ([1:5], [1:5]);
                    end
                end

                
                if fq==1,ylabel(structlistname{i});end
                xlim([0 f1(end)]);
                if strfind(structlist{i}, 'Bulb')
                    ylim([0 8E5])
                elseif strfind(structlist{i}, 'PFC')
                    ylim([0 4E5])
                end
                if i==length(structlist), xlabel(['stim ' num2str(fq_list(fq)) 'Hz']);end
                if i==1&&fq==1, text(-0.2,1.3,[Mousename ' solid - low, brown - theta: Average'],'units','normalized');end
            end

        end

        for i=1:length(structlist)
            for fq=1:nb_fq
                sub{i,fq}=subplot(length(structlist),nb_fq,nb_fq*(i-1)+fq); hold on
                if strfind(structlist{i}, 'Bulb')
                    ylim([0 4E5])
%                 elseif strfind(structlist{i}, 'HPC')
%                     ylim([0 4E5])
                elseif strfind(structlist{i}, 'PFC')
                    ylim([0 9E4])
                end
            end
        end
        
        cd(dirpath_res)
        if sav
            saveas(manSpfig,[ Mousename '_' Dir.path{man}(end-7:end) '_all.fig'])
            saveFigure(manSpfig,[ Mousename '_' Dir.path{man}(end-7:end) '_all'],dirpath_res)
        end