% RampOver1DayQuantif4_Wake.m
% 28.08.2017

% RampOver1DayQuantif4.m
% 14.02.2017
sav=1;
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
colori={'b','b','r','r','c','g','g','c'};
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
    load(['DataRampOver1DayQuantif_no_selection_Wake.mat']);
    disp(['Loading existing data from DataRampOver1DayQuantif_no_selection_Wake.mat']);
catch
    if 1
    cd /media/DataMOBsRAIDN/ProjetAversion/RampOver1dayQuantif/Ramp_4_no_selection
    load(['DataRampOver1DayQuantif_no_selec_HPC_PiCx_sub.mat']);
    disp(['Loading LFPpower from DataRampOver1DayQuantif_no_selection.mat']);  
    load(['DataRampOver1DayQuantif_no_selection_Wake_Info.mat']);
    end
    LFPpower_Before_Wake=LFPpower_Before;
    LFPpower_Wake=LFPpower;
    
    for man=1:length(Dir.path) 

        MouseNb=str2num(Dir.name{man}(end-2:end));
        Mousename=['M' Dir.name{man}(end-2:end)];
        disp(Mousename)
        
        
        for i=1:length(structlist)

            StimInfo=StimInfoAllMan{1,man};
            fq_list=unique(StimInfo.Freq);
            nb_fq=length(unique(StimInfo.Freq));

            for fq=1:nb_fq
                ind_evt=squeeze(LFPpower_Info(1,i,man,:,1,fq));
                ind_evt(isnan(ind_evt))=0;
%                 events not in Wake are put to nan
                ind_evt=logical(1-ind_evt);
                LFPpower_Before_Wake(1,i,man,ind_evt,1:length(f1),fq)=nan;
                LFPpower_Wake(1,i,man,ind_evt,1:length(f1),fq)=nan;
            end  
        end
    end
LFPpower=LFPpower_Wake;
LFPpower_Before=LFPpower_Before_Wake;
    cd(res)
    
    if sav
        save DataRampOver1DayQuantif_no_selection_Wake LFPpower LFPpower_Before f1 f structlistname fq_list Dir LaserInt StimInfoAllMan f Sp_On Sp_Off nb_fq fq_list
    end
end
end
    

%% PLOT SPECTRA

%         LFPpower_Before_mean=nanmean(LFPpower_Before,4);
%         LFPpower_Before_std=nanstd(LFPpower_Before,0,4);
%         LFPpower_Before_notnan=~isnan(LFPpower_Before);
%         LFPpower_During_mean=nanmean(LFPpower,4);
%         LFPpower_During_std=nanstd(LFPpower,0,4);

struct2plot=[1 3 5 6 8]; hemi='right';%right+HPC
% struct2plot=[2 4 5 7 8]; hemi='left'; %right+HPC
if 1
    YLmx=nan(length(Dir.path),length(structlist),nb_fq);
    for man=1:length(Dir.path) 
        manSpfig=figure('Position', [200          48         1500         926]);
        Mousename=['M' Dir.name{man}(end-2:end)];
        fq_list=unique(StimInfoAllMan{man}.Freq);
a=0;
%         for i=1:length(structlist)
        titleok=0;
        for i=struct2plot;
            a=a+1;
            nb_fq=length(unique(StimInfoAllMan{man}.Freq));

            for fq=1:nb_fq
%                 sub{i,fq}=subplot(length(structlist),nb_fq,nb_fq*(i-1)+fq); hold on
                sub{i,fq}=subplot(length(struct2plot),nb_fq,nb_fq*(a-1)+fq); hold on
                nbevt=sum(~isnan(squeeze(LFPpower(1,i,man,:,2,fq))));%nbevt=nansum(squeeze(+LFPpower_Before_notnan(1,i,man,:,2,fq)));
               if nbevt>0
                   
                   
                    LFPpower_BeforeM=squeeze(LFPpower_Before(1,i,man,:,:,fq));
                    LFPpower_M=squeeze(LFPpower(1,i,man,:,:,fq));
                    ind_non_zero=~(nansum(LFPpower_BeforeM,2)==0);
                    LFPpower_BeforeM=LFPpower_BeforeM(ind_non_zero,:);
                    LFPpower_M=LFPpower_M(ind_non_zero,:);
                   
                   try
                        if size(LFPpower_BeforeM,1)>1
                            shadedErrorBar(f1,nanmean(LFPpower_BeforeM),nanstd(LFPpower_BeforeM)/sqrt(nbevt), {},0);% ,'markerfacecolor',colori{i}
                            shadedErrorBar(f1,nanmean(LFPpower_M),nanstd(LFPpower_M)/sqrt(nbevt), colori{i},0);% ,'markerfacecolor',colori{i}
                        else
                            plot(f1,LFPpower_BeforeM,'Color',[0.5 0.5 0.5])% ,'markerfacecolor',colori{i}
                            plot(f1,LFPpower_M,'Color',colori{i})% ,'markerfacecolor',colori{i}
                        end

                    catch
                        keyboard
                    end
                   
                   
              
                hold on
                YL=ylim;
                YLmx(man,i,fq)=YL(2);
                
                %% to plot individual stim
%                 for evnt=1:length(Start(LaserInt{man,fq}))
%                         plot(f1,squeeze(LFPpower(1,i,man,evnt,:,fq)),'Color',colori{i})
%                         plot(f1,squeeze(LFPpower_Before(1,i,man,evnt,:,fq)),'Color',[0.5 0.5 0.5])
%                 end

               else
                   disp(['no spectrum for ' Mousename 'fq ' num2str(fq_list(fq)) 'Hz'])
               end
               
               
                if fq==1,ylabel(structlistname{i});end
                xlim([0 f1(end)]);
                if i==length(structlist), xlabel(['stim ' num2str(fq_list(fq)) 'Hz']);end
%                 if i==1&&fq==1, text(-0.2,1.3,[StepName{1} ' ' Dir.path{man}(end-7:end) ' - ' Mousename],'units','normalized');end
                if titleok==0, text(-0.2,1.3,[StepName{1} ' ' Dir.path{man}(end-7:end) ' - ' Mousename],'units','normalized');titleok=1;end
            end
        end
        a=0;
            for i=struct2plot;
            a=a+1;
%             for i=1:length(structlist)
                for fq=1:nb_fq
%                     sub{i,fq}=subplot(length(structlist),nb_fq,nb_fq*(i-1)+fq); hold on
                    sub{a,fq}=subplot(length(struct2plot),nb_fq,nb_fq*(a-1)+fq); hold on
                    try
                        ylim([0 nanmean(squeeze(YLmx(man,i,:)))]);
                    
                        if strcmp(Mousename, 'M465') && strcmp(structlist{i},'PiCx_right')
                            ylim([0 2E4])
                        elseif strcmp(Mousename, 'M467') && strcmp(structlist{i},'PiCx_right')
                            ylim([0 2E4])
                        elseif strcmp(Mousename, 'M468') && strcmp(structlist{i},'PiCx_right')
                            ylim([0 2E4])
                        elseif strcmp(Mousename, 'M468') && strcmp(structlist{i},'PiCx_left')
                            ylim([0 1E4])
                            elseif strcmp(Mousename, 'M466') && strcmp(structlist{i},'dHPC_local')
                            ylim([0 1E5])
                        end
                    end
                end
            end
        cd(res)

        if sav
            saveas(manSpfig,[ Mousename '_' Dir.path{man}(end-7:end) '_' hemi '_RampOver1Day_mean_Wake.fig'])
            saveFigure(manSpfig,[ Mousename '_' Dir.path{man}(end-7:end)  '_' hemi '_RampOver1Day_mean_Wake'],res)
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
