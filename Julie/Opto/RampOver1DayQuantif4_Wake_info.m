% RampOver1DayQuantif4_Wake_Info.m
% 29.08.2017

% appelée par RampOver1DayQuantif4_Wake.m
% 28.08.2017

% RampOver1DayQuantif4.m
% 14.02.2017
sav=1;
% analysis of the ramp over 1 day (during sleep - Sophie experiments)
% this codes 
% - computes spectrum for each stimulation event
% - plots spectra
% - plots power in  1-4Hz bandRampOver1DayQuantif4_REM

% FIGURES
% - spectra for each stimulation : 30sec before & 30sec during stim
% - scatterplot power before stim /during stim for all stimulation frequencies, for bulb and PFC

% SEE ALSO  RampOver1DayQuantif5.m
% same figure by selecting chunks of signal were the 1-4 Hz oscillation
% does exist (with FindStrongOsc)

% OUTPUTS
% - LFPpower et LFPPower_Before : matrix {EXT24,structlist{i}, Dir.path{man}, stim evt, freq range, stim fq}
% - Sp_On and Sp_Off : array of spectra for all stim events: Sp_On{1,i,man,evnt,fq}


%% INPUTS
cd /media/DataMOBsRAIDN/ProjetAversion/RampOver1dayQuantif/Ramp_4_no_selection/
res=pwd;
Dir.path={
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161117';
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161116';
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161123';
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126';
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170127';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170130';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170131';
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170202';
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170203';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170207';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170208';
};
for k=1:length(Dir.path)
    ind_mouse=strfind(Dir.path{k},'Mouse');
    Dir.name{k}=Dir.path{k}(ind_mouse:ind_mouse+7);
end
load /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/f_0-20;
StepName={'Ramp'};%'EXT-48'
% structlist={'Bulb_deep_right','Bulb_deep_left','PFCx_deep_right','PFCx_deep_left'};
structlist={'Bulb_deep_right','Bulb_deep_left','PFCx_deep_right','PFCx_deep_left','dHPC_rip','PiCx_right','PiCx_left','dHPC_local'};

%% INITIALIZE
colori={'b','b','r','r'};
structlistname=structlist;
for i=1:length(structlistname)
    ind_und=strfind(structlistname{i},'_');
    structlistname{i}(ind_und)=' ';
end
man=1;
[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high
 
%% LOAD OR COMPUTE DATA
if 1
try
    cd /media/DataMOBsRAIDN/ProjetAversion/RampOver1dayQuantif/Ramp_4_no_selection
    
    load(['DataRampOver1DayQuantif_no_selection_Wake_info.mat']);
    disp(['Loading existing data from DataRampOver1DayQuantif_no_selection_Wake_info.mat']);
catch
    
    cd /media/DataMOBsRAIDN/ProjetAversion/RampOver1dayQuantif/Ramp_4_no_selection
%     disp(['Loading StimInfoAllMan from DataRampOver1DayQuantif_no_selec_HPC_PiCx.mat']);
%     load(['DataRampOver1DayQuantif_no_selec_HPC_PiCx.mat'], 'StimInfoAllMan');
    
    LFPpower_Info=nan(length(StepName),length(structlist), length(Dir.path),50,1,15); % 50 : nb d'events (max estimé)/ 67 : nb fqce dans le spectre / 15 : nb de fqce de stim dans la rampe (max)

    for man=1:length(Dir.path) 
        cd (Dir.path{man})
        MouseNb=str2num(Dir.name{man}(end-2:end));
        Mousename=['M' Dir.name{man}(end-2:end)];
        disp(Mousename)
        
        load StimInfo
        load StateEpoch MovEpoch
        
        for i=1:length(structlist)

            fq_list=unique(StimInfo.Freq);
            nb_fq=length(unique(StimInfo.Freq));

            for fq=1:nb_fq
                LaserInt{man,fq} =intervalSet(StimInfo.StartTime(StimInfo.Freq==fq_list(fq))*1E4, StimInfo.StopTime(StimInfo.Freq==fq_list(fq))*1E4);
                % Condition : choose stim that started during Wake (1st second)
                LaserIntOneSecBef{man,fq} =intervalSet((StimInfo.StartTime(StimInfo.Freq==fq_list(fq))-1)*1E4, (StimInfo.StartTime(StimInfo.Freq==fq_list(fq)))*1E4);
                ind_IN_Wake=[];
                for k=1:length(Start(LaserIntOneSecBef{man,fq}))
                    if ~isempty(Start(and(subset(LaserIntOneSecBef{man,fq},k),MovEpoch)))
                        ind_IN_Wake=[ind_IN_Wake;1];
                    else
                        ind_IN_Wake=[ind_IN_Wake;0];
                    end
                end
                LFPpower_Info(1,i,man,1:length(ind_IN_Wake),1,fq)=ind_IN_Wake;
            end
        end
    end

    cd(res)
    
    if sav
         save DataRampOver1DayQuantif_no_selection_Wake_Info LFPpower_Info  f1  structlistname fq_list Dir LaserInt  nb_fq fq_list
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for the following steps, see RampOver1DayQuantif4_Wake_Info



%% PLOT SPECTRA
if 0
    for man=1:length(Dir.path) 
        manSpfig=figure('Position', [200          48         1500         926]);
        Mousename=['M' Dir.name{man}(end-2:end)];
        fq_list=unique(StimInfoAllMan{man}.Freq);

        for i=1:length(structlist)
            
            nb_fq=length(unique(StimInfoAllMan{man}.Freq));

            for fq=1:nb_fq
                sub{i,fq}=subplot(length(structlist),nb_fq,nb_fq*(i-1)+fq); hold on
                
                nbevt=sum(~isnan(squeeze(LFPpower(1,i,man,:,2,fq))));
                
                if nbevt==0
                else
                    LFPpower_BeforeM=squeeze(LFPpower_Before(1,i,man,:,:,fq));
                    ind_non_zero=~(nansum(LFPpower_BeforeM,2)==0);
                    LFPpower_BeforeM=LFPpower_BeforeM(ind_non_zero,:);
                    try
                        if length(nanmean(LFPpower_BeforeM))>1
                            shadedErrorBar(f1,nanmean(LFPpower_BeforeM),nanstd(LFPpower_BeforeM)/sqrt(nbevt), {},0);% ,'markerfacecolor',colori{i}
                        else
                            plot(f1,LFPpower_BeforeM);% ,'markerfacecolor',colori{i}
                        end

                    catch
                        keyboard
                    end
                    if strfind(structlist{i}, 'Bulb')
                        shadedErrorBar(f1,nanmean(squeeze(LFPpower(1,i,man,:,:,fq))),nanstd(squeeze(LFPpower(1,i,man,:,:,fq)))/sqrt(nbevt),'b',1);% ,'markerfacecolor',colori{i}
                    elseif strfind(structlist{i}, 'PFC')
                        shadedErrorBar(f1,nanmean(squeeze(LFPpower(1,i,man,:,:,fq))),nanstd(squeeze(LFPpower(1,i,man,:,:,fq)))/sqrt(nbevt),'r',1);% ,'markerfacecolor',colori{i}
                    end

    %                 for evnt=1:length(Start(LaserInt{man,fq}))
    %                     
    %                         plot(f1,squeeze(LFPpower(1,i,man,evnt,:,fq)),'Color',colori{i})
    %                         plot(f1,squeeze(LFPpower_Before(1,i,man,evnt,:,fq)),'Color',[0.5 0.5 0.5])
    % 
    %                 end

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

        end

        %if strfind(Mousename, 'M458') ||strfind(Mousename, 'M465')||strfind(Mousename, 'M466')
        for i=1:length(structlist)
            for fq=1:nb_fq
                sub{i,fq}=subplot(length(structlist),nb_fq,nb_fq*(i-1)+fq); hold on
                if strfind(structlist{i}, 'Bulb')
                    ylim([0 4E5])
                elseif strfind(structlist{i}, 'PFC')
                    ylim([0 1E5])
                end
            end
        end
    % end
        cd(res)
        % cd /media/DataMOBS59/OptoSleepStim
        if sav
            saveas(manSpfig,[ Mousename '_' Dir.path{man}(end-7:end) '_RampOver1Day_mean.fig'])
            saveFigure(manSpfig,[ Mousename '_' Dir.path{man}(end-7:end) '_RampOver1Day_mean'],res)
        end

    end
end
    



if 0
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
                         elseif strfind(structlist{i}, 'PFC')
                             plot(LowPowerStimOn,LowPowerStimOff,'or')
                        end

                    end
                    XL=ylim; YL=ylim;
                    maxi=max(XL(2), YL(2));
                    %line([0 0],[maxi maxi],'Color',[0.7 0.7 0.7])
                    line([0 maxi ],[ 0 maxi],'Color',[0.7 0.7 0.7])
                    xlim([0 maxi]),ylim([0 maxi]),

                    if i==1&&fq==1, text(-0.2,1.3,[StepName{1} ' ' Dir.path{man}(end-7:end) ' - ' Mousename],'units','normalized');end
                    if i==length(structlist), xlabel(['stim ' num2str(fq_list(fq)) 'Hz']);end
                    if fq==1,ylabel(structlistname{i});end
                end
            end
            % cd /media/DataMOBS59/OptoSleepStim
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
                     elseif strfind(structlist{i}, 'PFC')
                         plot(LowPowerStimOn,LowPowerStimOff,'or')
                    end

                    end
                    XL=ylim; YL=ylim;
                    maxi=max(XL(2), YL(2));
                    %line([0 0],[maxi maxi],'Color',[0.7 0.7 0.7])
                    line([0 maxi ],[ 0 maxi],'Color',[0.7 0.7 0.7])
                    xlim([0 maxi]),ylim([0 maxi]),

                    if i==1&&fq==1, text(-0.2,1.3,['x: 30 sec laser ON / y : 30 sec before'],'units','normalized');end
                    if i==length(structlist), xlabel(['stim ' num2str(fq_list(fq)) 'Hz']);end
                    if fq==1,ylabel(structlistname{i});end
                end
            end
        end
    % cd /media/DataMOBS59/OptoSleepStim
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

end
