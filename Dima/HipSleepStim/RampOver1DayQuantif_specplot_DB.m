% RampOver1DayQuantif4.m
% 14.02.2017

% source script here /home/mobsrick/Dropbox/Kteam/PrgMatlab/Julie/Opto/RampOver1DayQuantif4_forMar2017.m


% analysis of the ramp over 1 day (during sleep - Sophie experiments)
% this codes 
% - computes spectrum for each stimulation event
% - plots spectra
% - plots power in  1-4Hz band

% FIGURES
% - spectra for each stimulation : 30sec before & 30sec during stim
% - scatterplot power before stim /during stim for all stimulation frequencies, for bulb and PFC

% SEE ALSO  RampOver1DayQuantif5.m
% same figure by selecting chunks of signal were the 1-4 Hz oscillation
% does exist (with FindStrongOsc)

% OUTPUTS
% - LFPpower et LFPPower_Before : matrix {EXT24,structlist{i}, Dir.path{man}, stim evt, freq range, stim fq}
% - Sp_On and Sp_Off : array of spectra for all stim events: Sp_On{1,i,man,evnt,fq}

% TODO: clean all bullshit


%% INPUTS
cd ('/media/mobsrick/DataMOBs71/Results_av');
res=pwd;

% Do you want to save these figures? 0 = no, 1 = yes
sav=1;

% List of folders with the data
Dir.path={
    '/media/mobsrick/DataMOBs71/Mouse-534/09062017_SleepStim/FEAR-Mouse-534-09062017';
    '/media/mobsrick/DataMOBs71/Mouse-534/12062017-SleepStim/FEAR-Mouse-534-12062017';
    '/media/mobsrick/DataMOBs71/Mouse-534/14062017-SleepStim/FEAR-Mouse-534-14062017';
    '/media/mobsrick/DataMOBs71/Mouse-534/15062017-SleepStim/FEAR-Mouse-534-15062017';
    '/media/mobsrick/DataMOBs71/Mouse-534/16062017-SleepStim/FEAR-Mouse-534-16062017';
    '/media/mobsrick/DataMOBs71/Mouse-538/06072017_SleepStim/FEAR-Mouse-538-06072017';
    };

% Dir.path={
%     '/media/mobsrick/DataMOBs71/Mouse-538/06072017_SleepStim/FEAR-Mouse-538-06072017';
%     '/media/mobsrick/DataMOBs71/Mouse-538/07072017_SleepStim/FEAR-Mouse-538-07072017'
%     };

for k=1:length(Dir.path)
    ind_mouse=strfind(Dir.path{k},'Mouse');
    Dir.name{k}=Dir.path{k}(ind_mouse:ind_mouse+8);
end

% Frequency resolution
load /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/f_0-20;

% Common name in subfolders???
StepName={'Ramp'};%'EXT-48'

% List of structures to plot and compute
structlist={'dHPC_rip_left', 'PFCx_deep_left', 'Bulb_deep'};

%% INITIALIZE
% colori={'b','b','r','r'}; That is not used
structlistname=structlist;
for i=1:length(structlistname)
    ind_und=strfind(structlistname{i},'_');
    structlistname{i}(ind_und)=' ';
end
man=1;

[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high
 cd 
%% LOAD OR COMPUTE DATA
if 1
try
    
    cd ('/media/mobsrick/DataMOBs71/Results_av');
    disp(['Loading existing data from DataRampOver1DayQuantif_no_selection.mat']);
    load(['DataRampOver1DayQuantif_no_selection.mat']);
    
catch
    % source script here /home/mobsrick/Dropbox/Kteam/PrgMatlab/Julie/Opto/
    % Memory allocation
LFPpower=nan(length(StepName),length(structlist), length(Dir.path),50,67,15); % 50 : nb d'events (max estimé)/ 67 : nb fqce dans le spectre / 15 : nb de fqce de stim dans la rampe (max)
LFPpower_Before=nan(length(StepName),length(structlist), length(Dir.path),50,67,15);

    for man=1:length(Dir.path) 
        cd (Dir.path{man})
        MouseNb=str2num(Dir.name{man}(end-2:end));
        Mousename=['M' Dir.name{man}(end-2:end)];cd 
        disp(Mousename)
        
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
                    eval(['save(''',Dir.path{man},'/SpectrumDataL/Spectrum',num2str(temp.channel),'.mat'',','''Sp'',','''t'',','''f'',','''params'',','''movingwin'');'])
                end
                StsdL=tsd(t*1E4,Sp);

            else
                disp(['no channel for ' structlist{i} ' in this mouse '])
            end
            
            % Calculation of power at the frequencies present in StimInfo
            fq_list=unique(StimInfo.Freq);
            nb_fq=length(unique(StimInfo.Freq));

            for fq=1:nb_fq
                LaserInt{man,fq} =intervalSet(StimInfo.StartTime(StimInfo.Freq==fq_list(fq))*1E4, StimInfo.StopTime(StimInfo.Freq==fq_list(fq))*1E4);

                for evnt=1:length(Start(LaserInt{man,fq}))
Sp_On{1,i,man,evnt,fq}=Data(Restrict(StsdL,subset(LaserInt{man,fq},evnt)));
Sp_Off{1,i,man,evnt,fq}=Data(Restrict(StsdL,shift(subset(LaserInt{man,fq},evnt), -30E4)));

% Sp_On{1,i,man,evnt,fq}=tsd(Range(Restrict(StsdL,subset(LaserInt{man,fq},evnt))),Data(Restrict(StsdL,subset(LaserInt{man,fq},evnt))));
% Sp_Off{1,i,man,evnt,fq}=tsd(Range(Restrict(StsdL,shift(subset(LaserInt{man,fq},evnt), -30E4))),Data(Restrict(StsdL,shift(subset(LaserInt{man,fq},evnt), -30E4))));

% Sp_On(1,i,man,evnt,1:length(f),fq)=tsd(Range(Restrict(StsdL,subset(LaserInt{man,fq},evnt))),Data(Restrict(StsdL,subset(LaserInt{man,fq},evnt))));
% Sp_Off(1,i,man,evnt,1:length(f),fq)=tsd(Range(Restrict(StsdL,shift(subset(LaserInt{man,fq},evnt), -30E4))),Data(Restrict(StsdL,shift(subset(LaserInt{man,fq},evnt), -30E4))));
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
    cd(res)
    
    if sav
        save DataRampOver1DayQuantif_no_selection LFPpower LFPpower_Before f1 f structlistname fq_list Dir LaserInt StimInfoAllMan f Sp_On Sp_Off nb_fq fq_list
    end
end
end
    
        LFPpower_Before_toav = nan(length(structlist),length(Dir.path),50,length(f1),length(fq_list));
        LFPpower_toav = nan(length(structlist),length(Dir.path),50,length(f1),length(fq_list));

%% PLOT SPECTRA
if 1
    for man=1:length(Dir.path) cd 
        manSpfig=figure('Position', [200          48         1500         926]);
        Mousename=['M' Dir.name{man}(end-2:end)];
fq_list=unique(StimInfoAllMan{man}.Freq);

if isnan(fq_list(end)), fq_list(end)=[];end
nb_fq=length(fq_list);

        for i=1:length(structlist)


            for fq=1:nb_fq
                sub{i,fq}=subplot(length(structlist),nb_fq,nb_fq*(i-1)+fq); hold on
                  
                nbevt=sum(~isnan(squeeze(LFPpower(1,i,man,:,2,fq))));
                
                
                LFPpower_BeforeM=squeeze(LFPpower_Before(1,i,man,:,:,fq));
                ind_non_zero=~(nansum(LFPpower_BeforeM,2)==0);
                LFPpower_BeforeM=LFPpower_BeforeM(ind_non_zero,:);
                LFPpower_Before_toav(i,man,:,:,fq) = squeeze(LFPpower_Before(1,i,man,:,:,fq));
                shadedErrorBar(f1,nanmean(LFPpower_BeforeM),nanstd(LFPpower_BeforeM)/sqrt(nbevt), {},0);% ,'markerfacecolor',colori{i}
                

                if strfind(structlist{i}, 'Bulb')
                    shadedErrorBar(f1,nanmean(squeeze(LFPpower(1,i,man,:,:,fq))),nanstd(squeeze(LFPpower(1,i,man,:,:,fq)))/sqrt(nbevt),'b',1);% ,'markerfacecolor',colori{i}
                elseif strfind(structlist{i}, 'dHPC')
                    shadedErrorBar(f1,nanmean(squeeze(LFPpower(1,i,man,:,:,fq))),nanstd(squeeze(LFPpower(1,i,man,:,:,fq)))/sqrt(nbevt),'c',1);% ,'markerfacecolor',colori{i}
                elseif strfind(structlist{i}, 'PFC')
                    shadedErrorBar(f1,nanmean(squeeze(LFPpower(1,i,man,:,:,fq))),nanstd(squeeze(LFPpower(1,i,man,:,:,fq)))/sqrt(nbevt),'r',1);% ,'markerfacecolor',colori{i}
                elseif strfind(structlist{i}, 'vHPC')
                    shadedErrorBar(f1,nanmean(squeeze(LFPpower(1,i,man,:,:,fq))),nanstd(squeeze(LFPpower(1,i,man,:,:,fq)))/sqrt(nbevt),{'markerfacecolor', [1 0.6 0.2]},1);% ,'markerfacecolor',colori{i}
                end
                
                LFPpower_toav(i,man,:,:,fq) = squeeze(LFPpower(1,i,man,:,:,fq));
                

                if fq==1,ylabel(structlistname{i});end
                xlim([0 f1(end)]);
                if strfind(structlist{i}, 'Bulb')
                    ylim([0 8E5])
                elseif strfind(structlist{i}, 'PFC')
                    ylim([0 4E5])
                end
                if i==length(structlist), xlabel(['stim ' num2str(fq_list(fq)) 'Hz']);end
                if i==1&&fq==1, text(-0.2,1.3,[StepName{1} ' ' Dir.path{man}(end-7:end) ' - ' Mousename],'units','normalized');end
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
%         title ('Power spectra before (grey) and during (colored) stimulation - 30 sec');
        cd(res)
        if sav
            saveas(manSpfig,[ Mousename '_' Dir.path{man}(end-7:end) '_RampOver1Day.fig'])
            saveFigure(manSpfig,[ Mousename '_' Dir.path{man}(end-7:end) '_RampOver1Day'],res)
        end

    end
    
    
%%% Average across all folders
    

for m =1:length(Dir.path)
    for fq=1:nb_fq
        num_ep(m,fq)=length(Start(LaserInt{m,fq}));
    end
end

        manSpfig=figure('Position', [200          48         1500         926]);
        Mousename=['M' Dir.name{man}(end-2:end)];
fq_list=unique(StimInfoAllMan{man}.Freq);

if isnan(fq_list(end)), fq_list(end)=[];end
nb_fq=length(fq_list);

        for i=1:length(structlist)


            for fq=1:nb_fq
                sub{i,fq}=subplot(length(structlist),nb_fq,nb_fq*(i-1)+fq); hold on
                  
                LFPpower_Before_av=squeeze(LFPpower_Before_toav(i,:,:,:,fq));
                LFPpower_Before_av=reshape(LFPpower_Before_av, [size(LFPpower_Before_av,1)*size(LFPpower_Before_av,2),...
                    size(LFPpower_Before_av,3)]);
                
                LFPpower_av=squeeze(LFPpower_toav(i,:,:,:,fq));
                LFPpower_av=reshape(LFPpower_av, [size(LFPpower_av,1)*size(LFPpower_av,2),...
                    size(LFPpower_av,3)]);
                
                shadedErrorBar(f1,nanmean(LFPpower_Before_av),nanstd(LFPpower_Before_av)/sqrt(num_ep(man,fq)), {},0);% ,'markerfacecolor',colori{i}
                

                if strfind(structlist{i}, 'Bulb')
                    shadedErrorBar(f1,nanmean(squeeze(LFPpower_av)),nanstd(squeeze(LFPpower_av))...
                        /sqrt(num_ep(man,fq)),'b',1);% ,'markerfacecolor',colori{i}
                elseif strfind(structlist{i}, 'dHPC')
                    shadedErrorBar(f1,nanmean(squeeze(LFPpower_av)),nanstd(squeeze(LFPpower_av))...
                        /sqrt(num_ep(man,fq)),'c',1);% ,'markerfacecolor',colori{i}
                elseif strfind(structlist{i}, 'PFC')
                    shadedErrorBar(f1,nanmean(squeeze(LFPpower_av)),nanstd(squeeze(LFPpower_av))...
                        /sqrt(num_ep(man,fq)),'r',1);% ,'markerfacecolor',colori{i}
                elseif strfind(structlist{i}, 'vHPC')
                    shadedErrorBar(f1,nanmean(squeeze(LFPpower_av)),nanstd(squeeze(LFPpower_av))...
                        /sqrt(num_ep(man,fq)),{'markerfacecolor', [1 0.6 0.2]},1);% ,'markerfacecolor',colori{i}
                end

                

                if fq==1,ylabel(structlistname{i});end
                xlim([0 f1(end)]);
                if strfind(structlist{i}, 'Bulb')
                    ylim([0 8E5])
                elseif strfind(structlist{i}, 'PFC')
                    ylim([0 4E5])
                end
                if i==length(structlist), xlabel(['stim ' num2str(fq_list(fq)) 'Hz']);end
                if i==1&&fq==1, text(-0.2,1.3,'Grand Average','units','normalized');end
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
%         title ('Power spectra before (grey) and during (colored) stimulation - 30 sec');
        cd(res)
        if sav
            saveas(manSpfig,'_RampOver1Day_av.fig')
            saveFigure(manSpfig,'_RampOver1Day_av',res)
        end

end
    
    

% Avearge across 
    
%% Plot efficiency of Low Fq inhibition
% BY MOUSE

    indLow=(f1>1&f1<4);
    for man=1:length(Dir.path) 
        Mousename=['M' Dir.name{man}(end-2:end)];
        manMeanfig=figure('Position', [200          48         1500         926]);
        
        for i=1:length(structlist)
            for fq=1:nb_fq
                sub{i,fq}=subplot(length(structlist),nb_fq,nb_fq*(i-1)+fq); hold on

                for evnt=1:length(Start(LaserInt{man,fq}))
                    
%                     tot_length(Epoch{1,1})*1E-4;
%                     Sp_Off{1,i,man,evnt,fq}=Data(Restrict(StsdL,subset(LaserInt{man,fq},evnt)));


                    LowPowerStimOn=nanmean(squeeze(LFPpower(1,i,man,evnt,indLow,fq)));
                    LowPowerStimOff=nanmean(squeeze(LFPpower_Before(1,i,man,evnt,indLow,fq)));
                    
                if strfind(structlist{i}, 'Bulb')
                     plot(LowPowerStimOn,LowPowerStimOff,'ob')
                elseif strfind(structlist{i}, 'dHPC')
                     plot(LowPowerStimOn,LowPowerStimOff,'oc')
                elseif strfind(structlist{i}, 'PFC')
                     plot(LowPowerStimOn,LowPowerStimOff,'or')
                elseif strfind(structlist{i}, 'vHPC')
                     plot(LowPowerStimOn,LowPowerStimOff,'o', 'Color', [1 0.6 0.2])
                end

                end
                XL=ylim; YL=ylim;
                maxi=max(XL(2), YL(2));
                line([0 maxi ],[ 0 maxi],'Color',[0.7 0.7 0.7])
                xlim([0 maxi]),ylim([0 maxi]),

                if i==1&&fq==1, text(-0.2,1.3,[StepName{1} ' ' Dir.path{man}(end-7:end) ' - ' Mousename],'units','normalized');end
                if i==length(structlist), xlabel(['stim ' num2str(fq_list(fq)) 'Hz']);end
                if fq==1,ylabel(structlistname{i});end
            end
        end
%         title (['Spectral power before (x-axis) and during (y-axis) stimulation - 30 sec' Mousename]);
        cd(res)
        if sav
        saveas(manMeanfig,[ Mousename '_' Dir.path{man}(end-7:end)  '_LowFqInhibition.fig'])
        saveFigure(manMeanfig,[ Mousename '_' Dir.path{man}(end-7:end)  '_LowFqInhibition'],res)
        end
    end
    
%% ALL MOUSE
Allmicefig=figure('Position', [200          48         1500         926]);
indLow=(f1>1&f1<4);
    for man=1:length(Dir.path) 
        
        for i=1:length(structlist)
            for fq=1:nb_fq
                sub{i,fq}=subplot(length(structlist),nb_fq,nb_fq*(i-1)+fq); hold on

                for evnt=1:length(Start(LaserInt{man,fq}))
                    LowPowerStimOn=nanmean(squeeze(LFPpower(1,i,man,evnt,indLow,fq)));
                    LowPowerStimOff=nanmean(squeeze(LFPpower_Before(1,i,man,evnt,indLow,fq)));
                if strfind(structlist{i}, 'Bulb')
                     plot(LowPowerStimOn,LowPowerStimOff,'ob')
                elseif strfind(structlist{i}, 'dHPC')
                     plot(LowPowerStimOn,LowPowerStimOff,'oc')
                elseif strfind(structlist{i}, 'PFC')
                     plot(LowPowerStimOn,LowPowerStimOff,'or')
                elseif strfind(structlist{i}, 'vHPC')
                     plot(LowPowerStimOn,LowPowerStimOff,'o', 'Color', [1 0.6 0.2])
                end

                end
                XL=ylim; YL=ylim;
                maxi=max(XL(2), YL(2));
                line([0 maxi ],[ 0 maxi],'Color',[0.7 0.7 0.7])
                xlim([0 maxi]),ylim([0 maxi]),

                if i==1&&fq==1, text(-0.2,1.3,['x: 30 sec laser ON / y : 30 sec before'],'units','normalized');end
                if i==length(structlist), xlabel(['stim ' num2str(fq_list(fq)) 'Hz']);end
                if fq==1,ylabel(structlistname{i});end
            end
        end
    end
%     title ('Spectral power before (x-axis) and during (y-axis) stimulation - 30 sec - All mice');
cd(res)
if sav
saveas(Allmicefig,[ 'Allmice_LowFqInhibition.fig'])
saveFigure(Allmicefig,[ 'Allmice_LowFqInhibition'],res)
end

MM=[];
for man=1:length(Dir.path), 
    for evnt=1:length(Start(LaserInt{man,fq})), MM=[MM;nanmean(squeeze(LFPpower_Before(1,i,man,evnt,indLow,fq)))];
    end;
end
Mx=[];
for man=1:length(Dir.path), 
    Mx=[Mx;nanmean(squeeze(LFPpower_Before(1,i,man,:,indLow,fq)))];
end
