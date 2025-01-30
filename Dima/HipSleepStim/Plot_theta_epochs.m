% Plot_theta_epochs.m

%% Parameters

sav=1; % Do you want to save the pictures?

chan = 'dHPC_rip'; % Name of channel to compute theta

chan_toplot = 'PFCx_deep';

fq_list=[1 2 4 7 10 13 15 20]; % List of frequencies used
max_ev = 50; % Maximum number of events for one freq
max_res = 67; % Maximum resolution allowed for FFT
max_fq = 15; % Maximum number of frequencies that could be used

low_rat = 1; % Threshold ratio fot the low frequency states
high_rat = 2; % Threshold ratio fot the theta frequency states

Dir.path={
    '/media/mobsrick/DataMOBs71/Mouse-534/09062017_SleepStim/FEAR-Mouse-534-09062017';
    '/media/mobsrick/DataMOBs71/Mouse-534/12062017-SleepStim/FEAR-Mouse-534-12062017';
    '/media/mobsrick/DataMOBs71/Mouse-534/14062017-SleepStim/FEAR-Mouse-534-14062017';
    '/media/mobsrick/DataMOBs71/Mouse-534/15062017-SleepStim/FEAR-Mouse-534-15062017';
    '/media/mobsrick/DataMOBs71/Mouse-534/16062017-SleepStim/FEAR-Mouse-534-16062017'
    };

% Dir.path={
%     '/media/mobsrick/DataMOBs71/Mouse-534/16062017-SleepStim/FEAR-Mouse-534-16062017'
%     };


for k=1:length(Dir.path)
    ind_mouse=strfind(Dir.path{k},'Mouse');
    Dir.name{k}=Dir.path{k}(ind_mouse:ind_mouse+8);
end

% Load res_matrix
load /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/f_0-20;

dirpath_res = '/media/mobsrick/DataMOBs71/Mouse-534/Results/Theta_epochs_pfcx_deep'; % Folder to save the pictures

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


%% Plot spectra
% Load data
    for man=1:length(Dir.path) 
        cd (Dir.path{man})
        Mousename=['M' Dir.name{man}(end-3:end)];
        disp(Mousename)
        
        load StimInfo

            % Spectra loadinf
                if exist([Dir.path{man},'/ChannelsToAnalyse/', chan_toplot,'.mat']) 
                   temp=load([Dir.path{man},'/ChannelsToAnalyse/',chan_toplot,'.mat']);
                try
                    load([Dir.path{man},'/SpectrumDataL/Spectrum' num2str(temp.channel),'.mat'],'Sp', 't', 'f') % t en secondes
                    disp(['SpectrumDataL/Spectrum' num2str(temp.channel),'... loaded'])
                catch
                    disp('No spectrum found for this channel')
                end
                end
            
                Stsd{man}=tsd(t*1E4,Sp);
                
            % Calculation of power at the frequencies present in Sti% ,'markerfacecolor',colori{i}mInfo
            for fq=1:length(fq_list);
                LaserInt{man,fq} =intervalSet(StimInfo.StartTime(StimInfo.Freq==fq_list(fq))*1E4-25E4,...
                    StimInfo.StopTime(StimInfo.Freq==fq_list(fq))*1E4+25E4);


            end
    end
    cd(dirpath_res)


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


for m=1:length(Dir.path)
    for fq=1:length(fq_list)
            O = squeeze(idx_events_high(m,fq,:)); % indexes of high theta epochs with nans
            H = O(find(~isnan(O)));
            
                
         if isempty(H)
            continue
         else
                
            for i = 1:length(H)
            st=Start(subset(LaserInt{m,fq},H(i)));
            En=End(subset(LaserInt{m,fq},H(i)));
            figure
            imagesc(Range(Restrict(Stsd{m},subset(LaserInt{m,fq},H(i))),'s'),f...
                ,10*log10(Data(Restrict(Stsd{m},subset(LaserInt{m,fq},H(i))))'));
            axis xy, caxis([20 55]);
            line([st+25E4 st+25E4]/1E4,ylim,'color','k');
            line([En-25E4 En-25E4]/1E4,ylim,'color','k');  
            A = [Dir.path{m}(end-7:end) '-' num2str(fq_list(fq)) 'Hz-Epoch' num2str(H(i))];
            title (A);
            
            
            Mousename=['M' Dir.name{m}(end-2:end)];
            cd(dirpath_res)
            if sav
                saveas(gcf,[Mousename A '.fig'])
                saveFigure(gcf,[Mousename A], dirpath_res)
            end
            end
        end
    end
end

