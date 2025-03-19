clear all
%% Load the FolderPath
FolderPath_2Eyelid_Audiodream_AF

%% Stim counter
StimValues = {'V10','V15','V20','V25','V30'};
SleepTypes = {'OB','Acc','Piez'};
for st = 1:length(StimValues)
    for sl = 1:length(SleepTypes)
        n.(SleepTypes{sl}).(StimValues{st}) = 0;
        ResponsePostStim.(SleepTypes{sl}).(StimValues{st}) = [];
        MeanValPostStim.(SleepTypes{sl}).(StimValues{st}) = [];
        MeanValPreStim.(SleepTypes{sl}).(StimValues{st}) = [];
    end
end

%% Parameters
duration_poststim = 1e4 ; % e4 -> en secondes
duration_endstim = 10e4 ;  %
duration_preStimSleep = 5e4;


for fol = 1:length(FolderName)
    % Load
    cd(FolderName{fol});
    disp(FolderName{fol});
    load('behavResources.mat')

    
%     % Recalculate gamm no smoothing
%     load('ChannelsToAnalyse/Bulb_deep.mat','channel')
%     load([cd,'/LFPData/LFP',num2str(channel)],'LFP');
%     FilGamma=FilterLFP(LFP,[50 70],1024);
%     HilGamma=hilbert(Data(FilGamma));
%     H=abs(HilGamma);
%     tot_ghi=tsd(Range(LFP),H);
%     TotalEpoch = intervalSet(0,max(Range(tot_ghi)));
%     tot_ghi = Restrict(tot_ghi,TotalEpoch-TTLInfo.StimEpoch);
%     save('SleepScoring_OBGamma_Audiodream.mat','tot_ghi','-append')

    %% Get the scoring and raw daya
    load('SleepScoring_OBGamma_Audiodream.mat','tot_ghi')
    SlSc.OB = load('SleepScoring_OBGamma_Audiodream.mat','Wake','Sleep');
    SlSc.OB.Raw = tot_ghi;
    load('SleepScoring_Accelero.mat','tsdMovement')
    SlSc.Acc = load('SleepScoring_Accelero.mat','Wake','Sleep');
    SlSc.Acc.Raw = MovAcctsd;
    load('PiezoData_SleepScoring.mat','Piezo_Mouse_tsd')
    Smooth_actimetry = tsd(Range(Piezo_Mouse_tsd), abs(zscore(Data(Piezo_Mouse_tsd)))); % smooth time =3s
    SlSc.Piez = load('PiezoData_SleepScoring.mat','WakeEpoch_Piezo','SleepEpoch_Piezo');
    SlSc.Piez.Wake = SlSc.Piez.WakeEpoch_Piezo;
    SlSc.Piez.Sleep = SlSc.Piez.SleepEpoch_Piezo;
    SlSc.Piez = rmfield(SlSc.Piez,{'WakeEpoch_Piezo','SleepEpoch_Piezo'});
    SlSc.Piez.Raw = Smooth_actimetry;
    
    
    %% Get stim events intan
    Stim_Event = [Start(TTLInfo.StimEpoch)];
    Stim_Epoch_Start = Stim_Event+duration_poststim;
    Stim_Epoch_End = Stim_Event + duration_endstim;
    
    %% Create the Stim Epoch
    Epoch_Stim = intervalSet(Stim_Epoch_Start, Stim_Epoch_End);
    Event_Stim = intervalSet(Stim_Event, Stim_Event+0.2e4);
    
    %% Get stim identity
    load('journal_stim.mat')
    StimId = cell2mat(journal_stim(:,1));
    for st = 1:length(StimValues)
        tps_stim.(StimValues{st}) = Stim_Event(StimId==eval(StimValues{st}(2:end))/10);
    end
    
    
    for st = 1:length(StimValues)
        PreStimEpoch = intervalSet(tps_stim.(StimValues{st})-duration_preStimSleep,tps_stim.(StimValues{st})-0.2*1e4);
        
        if length(Start(PreStimEpoch))>0
            %% Get the sleepy stims
            clear PreStimSleep
            for stim = 1:length(Start(PreStimEpoch))
                PreStimEpoch_OfInterest = subset(PreStimEpoch,stim);
                PreStimSleep(stim) = sum(Stop(and(PreStimEpoch_OfInterest,SlSc.Piez.Sleep)) - Start(and(PreStimEpoch_OfInterest,SlSc.Piez.Sleep)));
            end
            StimStart_InSleep = ts(tps_stim.(StimValues{st})(PreStimSleep>(duration_preStimSleep-0.3*1e4)));
            
            if  length(Range(StimStart_InSleep))>1
                StimStart_InSleep_vect = Range(StimStart_InSleep);
                
                for sl = 1:length(SleepTypes)
                    % Quantity of wake post stim
                    for stim = 1:length(StimStart_InSleep)
                        
                        EpochAfterStim = intervalSet(StimStart_InSleep_vect(stim)+duration_poststim,StimStart_InSleep_vect(stim)+duration_endstim);
                        n.(SleepTypes{sl}).(StimValues{st}) = n.(SleepTypes{sl}).(StimValues{st})+1;
                        WakeTimePostStim.(SleepTypes{sl}).(StimValues{st})(n.(SleepTypes{sl}).(StimValues{st}),1) = ...
                            sum(Stop(and(SlSc.(SleepTypes{sl}).Wake,EpochAfterStim),'s') - Start(and(SlSc.(SleepTypes{sl}).Wake,EpochAfterStim),'s'));
                    end
                    
                    % Response profile raw data post stim
                    [M,T] = PlotRipRaw(SlSc.(SleepTypes{sl}).Raw,Range(StimStart_InSleep,'s'),[-10 10]*1e3,0,0,0);
                    T(T==0) = NaN;
                    %                     T = naninterp(T')';
                    ResponsePostStim.(SleepTypes{sl}).(StimValues{st}) = [ ResponsePostStim.(SleepTypes{sl}).(StimValues{st});T];
                    time.(SleepTypes{sl}) = M(:,1);
                    % Average value of raw data post stim
                    MeanValPostStim.(SleepTypes{sl}).(StimValues{st}) = [MeanValPostStim.(SleepTypes{sl}).(StimValues{st});nanmean(T(:,end/2+1:end),2)];
                    MeanValPreStim.(SleepTypes{sl}).(StimValues{st}) = [ MeanValPreStim.(SleepTypes{sl}).(StimValues{st});nanmean(T(:,1:end/2-1),2)];
                end
            end
        end
    end
end

%% Plot Raw data
figure
% cols = summer(length(StimValues));
cols = magma(length(StimValues))
for sl = 1:length(SleepTypes)
    subplot(length(SleepTypes),1,sl)
    for st = 1:length(StimValues)-1
        plot(time.(SleepTypes{sl}),nanmean(ResponsePostStim.(SleepTypes{sl}).(StimValues{st})),'color',cols(st,:),'linewidth',3)
        hold on
    end
    legend('1V','1,5V','2V','2,5V')
    title(SleepTypes{sl})
    xlabel('Temps (s)')
end
subplot(length(SleepTypes),1,1)
ylim([100 700])


figure
cols = summer(length(StimValues));
for sl = 1:length(SleepTypes)
    for st = 1:length(StimValues)-1
        subplot(length(SleepTypes),length(StimValues)-1,(sl-1)*(length(StimValues)-1)+st)
        NStim = size((ResponsePostStim.(SleepTypes{sl}).(StimValues{st})),1);
                imagesc(time.(SleepTypes{sl}),1:NStim,(ResponsePostStim.(SleepTypes{sl}).(StimValues{st})))
        hold on
        title(StimValues{st})
        if st ==1
            ylabel(SleepTypes{sl})
        end
        cax(st,:) = caxis;
    end
    for st = 1:length(StimValues)-1
        subplot(length(SleepTypes),length(StimValues)-1,(sl-1)*(length(StimValues)-1)+st)
        caxis(mean(cax))
        colorbar
    end
end
sl=2;
for st = 1:length(StimValues)-1
    subplot(length(SleepTypes),length(StimValues)-1,(sl-1)*(length(StimValues)-1)+st)
    caxis([0 1.5e8])
end

% % 
% % 
% % for st = 1:length(StimValues)-1
% %     for sl = 1:length(SleepTypes)
% %         for n = 1:length(ResponsePostStim_Smooth)
% %         ResponsePostStim_Smooth.(SleepTypes{sl}).(StimValues{st}) = runmean(ResponsePostStim.(SleepTypes{sl}).(StimValues{st}),300)
% %         end
% %     end
% % end
% % figure
% % cols = summer(length(StimValues));
% % for sl = 1:length(SleepTypes)
% %     for st = 1:length(StimValues)-1
% %         subplot(length(SleepTypes),length(StimValues)-1,(sl-1)*(length(StimValues)-1)+st)
% %         NStim = size((ResponsePostStim.(SleepTypes{sl}).(StimValues{st})),1);
% %                 imagesc(time.(SleepTypes{sl}),1:NStim,(runmean(ResponsePostStim.(SleepTypes{sl}).(StimValues{st}),300)))
% %         hold on
% %         title(StimValues{st})
% %         if st ==1
% %             ylabel(SleepTypes{sl})
% %         end
% %         cax(st,:) = caxis;
% %     end
% %     for st = 1:length(StimValues)-1
% %         subplot(length(SleepTypes),length(StimValues)-1,(sl-1)*(length(StimValues)-1)+st)
% %         caxis(mean(cax))
% %         colorbar
% %     end
% % end



%% Correlate Raw data Pre stim : 
SleepMix = [1,2;3,1;3,2];
cols = magma(length(StimValues))
color = cols;
figure
for st = 1:length(SleepMix)
    subplot(1,length(SleepMix),st)
        for sl = 1:length(StimValues)-1
            plot(MeanValPreStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl}),...
                MeanValPreStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl}),'color',color(sl,:),'LineStyle','none','Marker','.','MarkerSize',25)  % MODIFFFFF
        xlabel(SleepTypes{SleepMix(st,1)})
        ylabel(SleepTypes{SleepMix(st,2)})
        hold on
        legend('1V','1,5V','2V','2,5V','Location','northwest')       
        end
end     
        




%% Correlate Wake amount
SleepMix = [1,2;3,1;3,2];
cols = magma(length(StimValues))
color = cols;
figure
for st = 1:length(SleepMix)
    subplot(1,length(SleepMix),st)
        for sl = 1:length(StimValues)-1
            plot(WakeTimePostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl}),...
                WakeTimePostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl}),'color',color(sl,:),'LineStyle','none','Marker','.','MarkerSize',20)  % MODIFFFFF
        xlabel(SleepTypes{SleepMix(st,1)})
        ylabel(SleepTypes{SleepMix(st,2)})
        hold on
%         legend('1V','1,5V','2V','2,5V','Location','northwest')       
        end
        line([0 9],[0 9],'color','k')
        legend('1V','1,5V','2V','2,5V','Location','southoutside')       
        xlim([0 9])
end     
         



SleepMix = [1,2;3,1;3,2];
cols = magma(length(StimValues))
color = cols;
figure
for st = 1:length(SleepMix)
    subplot(1,length(SleepMix),st)
        for sl = 1:length(StimValues)-1
        x = WakeTimePostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl});
        x(x==0) = x(x==0)+randn(length(x(x==0)),1)*0.2;
        y = WakeTimePostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl});
        y(y==0) = y(y==0)+randn(length(y(y==0)),1)*0.2;
        plot(x,y,'color',color(sl,:),'LineStyle','none','Marker','.','MarkerSize',20)
        xlabel(SleepTypes{SleepMix(st,1)})
        ylabel(SleepTypes{SleepMix(st,2)})
        hold on
%         legend('1V','1,5V','2V','2,5V','Location','northwest')       
        end
        axis square
        line([0 9],[0 9],'color','k')
        legend('1V','1,5V','2V','2,5V','Location','southoutside')       
        xlim([0 9])
end   


% Just randomize x = 0 et y =0
SleepMix = [1,2;3,1;3,2];
cols = magma(length(StimValues))
color = cols;
figure
for st = 1:length(SleepMix)
    subplot(1,length(SleepMix),st)
        for sl = 1:length(StimValues)-1
        x = WakeTimePostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl});
        y = WakeTimePostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl});
        for nbx = 1:length(x)
            if x(nbx) == 0 & y(nbx)==0
                x(nbx) = x(nbx)+randn(length(x(nbx)),1)*0.2;
                y(nbx) = y(nbx)+randn(length(y(nbx)),1)*0.2;
            end
        end
        plot(x,y,'color',color(sl,:),'LineStyle','none','Marker','.','MarkerSize',20)
        xlabel(SleepTypes{SleepMix(st,1)})
        ylabel(SleepTypes{SleepMix(st,2)})
        hold on
%         legend('1V','1,5V','2V','2,5V','Location','northwest')       
        end
        line([0 9],[0 9],'color','k')
        legend('1V','1,5V','2V','2,5V','Location','southoutside')       
        xlim([0 9])
end  

%% Correlate Wake amount
SleepMix = [1,2;3,1;3,2];
cols = magma(length(StimValues))
color = cols;
figure
for st = 1:length(SleepMix)
    %           subplot(1,length(SleepMix),st)
    for sl = 1:length(StimValues)-1
        subplot(length(SleepMix),length(StimValues)-1,(st-1)*(length(StimValues)-1)+sl)
        x = WakeTimePostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl});
        x(x==0) = x(x==0)+randn(length(x(x==0)),1)*0.2;
        y = WakeTimePostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl});
        y(y==0) = y(y==0)+randn(length(y(y==0)),1)*0.2;
        plot(x,y,'color',color(sl,:),'LineStyle','none','Marker','.','MarkerSize',20)  % MODIFFFFF
        xlabel(SleepTypes{SleepMix(st,1)})
        ylabel(SleepTypes{SleepMix(st,2)})
        hold on
        %         legend('1V','1,5V','2V','2,5V','Location','northwest')
        
        axis square
        line([0 9],[0 9],'color','k')
        xlim([-1 10])
        ylim([-1 10])
    end
end


% Just randomize x=0 et y=0
SleepMix = [1,2;3,1;3,2];
cols = magma(length(StimValues))
color = cols;
figure
for st = 1:length(SleepMix)
    %           subplot(1,length(SleepMix),st)
    for sl = 1:length(StimValues)-1
        subplot(length(SleepMix),length(StimValues)-1,(st-1)*(length(StimValues)-1)+sl)
        x = WakeTimePostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl});
        y = WakeTimePostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl});
        for nbx = 1:length(x)
            if x(nbx) == 0 & y(nbx)==0
                x(nbx) = x(nbx)+randn(length(x(nbx)),1)*0.2;
                y(nbx) = y(nbx)+randn(length(y(nbx)),1)*0.2;
            end
        end
        plot(x,y,'color',color(sl,:),'LineStyle','none','Marker','.','MarkerSize',20)  % MODIFFFFF
        xlabel(SleepTypes{SleepMix(st,1)})
        ylabel(SleepTypes{SleepMix(st,2)})
        hold on
        %         legend('1V','1,5V','2V','2,5V','Location','northwest')
        
        axis square
        line([0 9],[0 9],'color','k')
        xlim([-1 10])
        ylim([-1 10])
    end
end



%% Correlate Wake amount
SleepMix = [2,1;3,1;3,2];
cols = magma(length(StimValues));
color = cols;
figure
for st = 1:length(SleepMix)
    subplot(1,length(SleepMix),st)
        for sl = 1:length(StimValues)-1
            plot(WakeTimePostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl}),...
                WakeTimePostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl}),'color',color(sl,:),'LineStyle','none','Marker','.','MarkerSize',20)  % MODIFFFFF
        xlabel(SleepTypes{SleepMix(st,1)})
        ylabel(SleepTypes{SleepMix(st,2)})
        hold on
        legend('1V','1,5V','2V','2,5V','Location','southoutside')
        xlim([0 9])
        end
axis square
end     



SleepMix = [2,1;3,1;3,2];
cols = magma(length(StimValues));
color = cols;
figure
for st = 1:length(SleepMix)
    subplot(1,length(SleepMix),st)
        for sl = 1:length(StimValues)-1
            plot(MeanValPostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl}),...
                MeanValPostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl}),'color',color(sl,:),'LineStyle','none','Marker','.','MarkerSize',25)  % MODIFFFFF
        xlabel(SleepTypes{SleepMix(st,1)})
        ylabel(SleepTypes{SleepMix(st,2)})
        hold on
       legend('1V','1,5V','2V','2,5V','Location','southoutside')       
        end
end     





%% Corr: 
SleepMix = [2,1;3,1;3,2];
Corr = {'OBAcc','PiezOB','PiezAcc'};
for st = 1:length(SleepMix)
        for sl = 1:length(StimValues)-1
          [coef, pval] = corr(MeanValPostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl}),...
                MeanValPostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl}))
           corr_coef.(Corr{st}).(StimValues{sl}) = coef
           corr_pval.(Corr{st}).(StimValues{sl}) = pval
        end
end     



SleepMix = [2,1;3,1;3,2];
Corr = {'OBAcc','PiezOB','PiezAcc'};
for st = 1:length(SleepMix)
        for sl = 1:length(StimValues)-1
          [coef, pval] = corr(WakeTimePostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl}),...
                WakeTimePostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl}))
           corr_coef_duration.(Corr{st}).(StimValues{sl}) = coef
           corr_pval_duration.(Corr{st}).(StimValues{sl}) = pval
        end
end     


%% 
SleepMix = [2,1;3,1;3,2];
Corr = {'OBAcc','PiezOB','PiezAcc'};
for st = 1:length(SleepMix)
        for sl = 1:length(StimValues)-1
          [coef, pval] = corr(MeanValPostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl}),...
                MeanValPostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl}),'type','Spearman')
           corr_coef.(Corr{st}).(StimValues{sl}) = coef
           corr_pval.(Corr{st}).(StimValues{sl}) = pval
        end
end     



SleepMix = [2,1;3,1;3,2];
Corr = {'OBAcc','PiezOB','PiezAcc'};
for st = 1:length(SleepMix)
        for sl = 1:length(StimValues)-1
          [coef, pval] = corr(WakeTimePostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl}),...
                WakeTimePostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl}),'type','Spearman')
           corr_coef_duration.(Corr{st}).(StimValues{sl}) = coef
           corr_pval_duration.(Corr{st}).(StimValues{sl}) = pval
        end
end     



% Enlever zéro et faire les 2

% By stimvalues:
SleepMix = [2,1;3,1;3,2];
Corr = {'OBAcc','PiezOB','PiezAcc'};
for st = 1:length(SleepMix)
        for sl = 1:length(StimValues)-1
            A_st1 = WakeTimePostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl});
            A_st2 = WakeTimePostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl});
            ToExclude = find(A_st1 ==0 & A_st2 ==0);
            A_st1_corr = A_st1; A_st1_corr(ToExclude) = [];
            A_st2_corr = A_st2; A_st2_corr(ToExclude) = [];
            [coef, pval] = corr(A_st1,A_st2,'type','Spearman');
            corr_coef_duration.(Corr{st}).(StimValues{sl}) = coef;
            corr_pval_duration.(Corr{st}).(StimValues{sl}) = pval;
        end
end    

SleepMix = [2,1; 3,1; 3,2];
Corr = {'OBAcc','PiezOB','PiezAcc'};
cols = magma(length(StimValues));
color = cols;

figure
for st = 1:length(SleepMix)
    subplot(1, length(SleepMix), st)
    hold on
    for sl = 1:length(StimValues)-1
        % Extract the data points
        x = WakeTimePostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl});
        y = WakeTimePostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl});
        
        % Plot the data points
        plot(x, y, 'color', color(sl,:), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 25)
        
        % Calculate the correlation
        A_st1 = WakeTimePostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl});
        A_st2 = WakeTimePostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl});
        ToExclude = find(A_st1 == 0 & A_st2 == 0);
        A_st1_corr = A_st1; A_st1_corr(ToExclude) = [];
        A_st2_corr = A_st2; A_st2_corr(ToExclude) = [];
        [coef, pval] = corr(A_st1_corr, A_st2_corr, 'type', 'Spearman');
        corr_coef_duration.(Corr{st}).(StimValues{sl}) = coef;
        corr_pval_duration.(Corr{st}).(StimValues{sl}) = pval;
        
        % Add the line of best fit over the full range of the data
        fit = polyfit(x, y, 1);
        xfit = linspace(min(x), max(x), 100);
        yfit = polyval(fit, xfit);
        plot(xfit, yfit, 'color', color(sl,:), 'LineWidth', 1)

        % Add annotation for the correlation coefficient
        text(mean(x), mean(y), sprintf('r = %.2f', coef), 'FontSize', 10, 'HorizontalAlignment', 'center')
    end
    
    xlabel(SleepTypes{SleepMix(st,1)})
    ylabel(SleepTypes{SleepMix(st,2)})
    legend('1V', '1.5V', '2V', '2.5V', 'Location', 'southoutside')
    hold off
end




% For all : 
SleepMix = [2,1; 3,1; 3,2];
Corr = {'OBAcc','PiezOB','PiezAcc'};
cols = magma(length(StimValues));
color = cols;
% For all : 
SleepMix = [2,1; 3,1; 3,2];
Corr = {'OBAcc','PiezOB','PiezAcc'};
cols = magma(length(StimValues));
color = cols;
n=1;
nn=1;
figure
for st = 1:length(SleepMix)
    subplot(1, length(SleepMix), st)
    hold on
    
    all_x = [];
    all_y = [];
    
    for sl = 1:length(StimValues)-1
        % Extract the data points
        x = WakeTimePostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl});
        y = WakeTimePostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl});
        for nbx = 1:length(x)
            if x(nbx) == 0 & y(nbx)==0
                x(nbx) = x(nbx)+randn(length(x(nbx)),1)*0.2;
                y(nbx) = y(nbx)+randn(length(y(nbx)),1)*0.2;
            end
        end
        % Aggregate data points
        all_x = [all_x; x];
        all_y = [all_y; y];
        
        % Plot the data points
        plot(x, y, 'color', color(sl,:), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 25)
    end
    
    % Calculate the correlation over the aggregated data
    A_st1_all = [];
    A_st2_all = [];
    for sl = 1:length(StimValues)
        A_st1_all = [A_st1_all; WakeTimePostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl})];
        A_st2_all = [A_st2_all; WakeTimePostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl})];
    end
    ToExclude = find(A_st1_all == 0 & A_st2_all == 0);
    A_st1_corr = A_st1_all; A_st1_corr(ToExclude) = [];
    A_st2_corr = A_st2_all; A_st2_corr(ToExclude) = [];
    [coef, pval] = corr(A_st1_corr, A_st2_corr, 'type', 'Spearman');
    corr_coef(n) = coef;
    corr_pval(n) = pval;
    
    [coef_all, pval_all] = corr(A_st1_all, A_st2_all, 'type', 'Kendall');
    corr_coef_all(nn) = coef_all;
    corr_pval_all(nn) = pval_all;
    
    % Add the line of best fit over the full range of the aggregated data
    fit = polyfit(A_st1_corr, A_st2_corr, 1);
    xfit = linspace(min(A_st1_corr), max(A_st1_corr), 100);
    yfit = polyval(fit, xfit);
    plot(xfit, yfit, 'k-', 'LineWidth', 1)

    % Add annotation for the correlation coefficient
    text(mean(A_st1_corr), mean(A_st2_corr), sprintf('r = %.2f', coef), 'FontSize', 10, 'HorizontalAlignment', 'center')
    text(mean(A_st1_corr), mean(A_st2_corr), sprintf('p = %.2f', pval), 'FontSize', 10, 'HorizontalAlignment', 'center')
    
        % Add the line of best fit over the full range of the aggregated data
    fit = polyfit(A_st1_all, A_st2_all, 1);
    xfit = linspace(min(A_st1_all), max(A_st1_all), 100);
    yfit = polyval(fit, xfit);
    plot(xfit, yfit, 'r-', 'LineWidth', 1)

    % Add annotation for the correlation coefficient
    text(mean(A_st1_all), mean(A_st2_corr), sprintf('r = %.2f', coef_all), 'FontSize', 10, 'HorizontalAlignment', 'center')
    text(mean(A_st1_all), mean(A_st2_corr), sprintf('p = %.2f', pval_all), 'FontSize', 10, 'HorizontalAlignment', 'center')
    
    
    
    xlabel(SleepTypes{SleepMix(st,1)})
    ylabel(SleepTypes{SleepMix(st,2)})
    legend('1V', '1.5V', '2V', '2.5V', 'Location', 'southoutside')
    hold off
    xlim([0 9 ])
    axis square
    
    n= n+1;
    nn = nn+1;
end


% For all for MeanValuePostStim
SleepMix = [2,1; 3,1; 3,2];
Corr = {'OBAcc','PiezOB','PiezAcc'};
cols = magma(length(StimValues));
color = cols;
n = 1
figure
for st = 1:length(SleepMix)
    subplot(1, length(SleepMix), st)
    hold on
    
    all_x = [];
    all_y = [];
    
    for sl = 1:length(StimValues)-1
        % Extract the data points
        x = MeanValPostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl});
        y = MeanValPostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl});
        
        % Aggregate data points
        all_x = [all_x; x];
        all_y = [all_y; y];
        
        % Plot the data points
        plot(x, y, 'color', color(sl,:), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 25)
    end
    
    % Calculate the correlation over the aggregated data
    A_st1_all = [];
    A_st2_all = [];
    for sl = 1:length(StimValues)
        A_st1_all = [A_st1_all; MeanValPostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl})];
        A_st2_all = [A_st2_all; MeanValPostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl})];
    end
   
    [coef, pval] = corr(A_st1_all, A_st2_all, 'type', 'Spearman');
    corr_coef_duration.(Corr{st}) = coef;
    corr_pval_duration.(Corr{st}) = pval;
    corr_coef(n) = coef;
    corr_pval(n) = pval;
    
    % Add the line of best fit over the full range of the aggregated data
    fit = polyfit(A_st1_all, A_st2_all, 1);
    xfit = linspace(min(A_st1_all), max(A_st1_all), 100);
    yfit = polyval(fit, xfit);
    plot(xfit, yfit, 'k-', 'LineWidth', 1)

    % Add annotation for the correlation coefficient
    text(mean(A_st1_all), mean(A_st2_all), sprintf('r = %.2f', coef), 'FontSize', 10, 'HorizontalAlignment', 'center')
    text(mean(A_st1_all), mean(A_st2_all) * 1.1, sprintf('p = %.2f', pval), 'FontSize', 10, 'HorizontalAlignment', 'center')
    
    xlabel(SleepTypes{SleepMix(st,1)})
    ylabel(SleepTypes{SleepMix(st,2)})
    legend('1V', '1.5V', '2V', '2.5V', 'Location', 'southoutside')
    hold off
    xlim([0 max(x)])
        axis square

        
    n = n+1;
end



% Without small values
SleepMix = [2,1; 3,1; 3,2];
Corr = {'OBAcc','PiezOB','PiezAcc'};
cols = magma(length(StimValues));
color = cols;
n = 1
figure
for st = 1:length(SleepMix)
    subplot(1, length(SleepMix), st)
    hold on
    
    all_x = [];
    all_y = [];
    
    for sl = 1:length(StimValues)-1
        % Extract the data points
        x = MeanValPostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl});
        y = MeanValPostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl});
        
        % Aggregate data points
        all_x = [all_x; x];
        all_y = [all_y; y];
        
        % Plot the data points
        plot(x, y, 'color', color(sl,:), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 25)
    end
    
    % Define limits based on the subplot
    if st == 1
        limit1 = 300;
        limit2 = 0.7e7;
    elseif st == 2
        limit1 = 300;
        limit2 = 0.2;
    elseif st == 3
        limit1 = 0.7e7;
        limit2 = 0.2;
    end
    
    % Plot the limit lines
    plot([limit2 limit2], ylim, 'r--', 'LineWidth', 1.5); % Vertical line at limit1
    plot(xlim, [limit1 limit1], 'r--', 'LineWidth', 1.5); % Horizontal line at limit2
    
    % Calculate the correlation over the aggregated data
    A_st1_all = [];
    A_st2_all = [];
    for sl = 1:length(StimValues)
        A_st1_all = [A_st1_all; MeanValPostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl})];
        A_st2_all = [A_st2_all; MeanValPostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl})];
    end
    
    ToExclude = find(A_st1_all <= limit1 & A_st2_all <= limit2);
    A_st1_corr = A_st1_all; A_st1_corr(ToExclude) = [];
    A_st2_corr = A_st2_all; A_st2_corr(ToExclude) = [];
    [coef, pval] = corr(A_st1_corr, A_st2_corr, 'type', 'Spearman');
    corr_coef_duration.(Corr{st}) = coef;
    corr_pval_duration.(Corr{st}) = pval;
    corr_coef(n) = coef;
    corr_pval(n) = pval;
    
    % Add the line of best fit over the full range of the aggregated data
    fit = polyfit(A_st1_all, A_st2_corr, 1);
    xfit = linspace(min(A_st1_all), max(A_st1_all), 100);
    yfit = polyval(fit, xfit);
    plot(xfit, yfit, 'k-', 'LineWidth', 1)

    % Add annotation for the correlation coefficient
    text(mean(A_st1_all), mean(A_st2_corr), sprintf('r = %.2f', coef), 'FontSize', 10, 'HorizontalAlignment', 'center')
    text(mean(A_st1_all), mean(A_st2_corr) * 1.1, sprintf('p = %.2f', pval), 'FontSize', 10, 'HorizontalAlignment', 'center')
    
    xlabel(SleepTypes{SleepMix(st,1)})
    ylabel(SleepTypes{SleepMix(st,2)})
    legend('1V', '1.5V', '2V', '2.5V', 'Location', 'southoutside')
    hold off
    xlim([0 max(x)])
        axis square

        
    n = n+1;
end

      
%% Corr Kendall
Corr = {'OBAcc','PiezOB','PiezAcc'};
for st = 1:length(SleepMix)
        for sl = 1:length(StimValues)-1
          [coef, pval] = corr(MeanValPostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl}),...
                MeanValPostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl}),'type','Kendall')
           corr_coefkd.(Corr{st}).(StimValues{sl}) = coef
           corr_pvalkd.(Corr{st}).(StimValues{sl}) = pval
        end
end     


SleepMix = [2,1;3,1;3,2];
Corr = {'OBAcc','PiezOB','PiezAcc'};
for st = 1:length(SleepMix)
        for sl = 1:length(StimValues)-1
          [coef, pval] = corr(WakeTimePostStim.(SleepTypes{SleepMix(st,1)}).(StimValues{sl}),...
                WakeTimePostStim.(SleepTypes{SleepMix(st,2)}).(StimValues{sl}),'type','Kendall')
           corr_coef_durationkd.(Corr{st}).(StimValues{sl}) = coef
           corr_pval_durationkd.(Corr{st}).(StimValues{sl}) = pval
        end
end     


%% Histogramme with barplot avec statistiques
cols = magma(length(StimValues));
StimValues_corrected = {'V10','V15','V20','V25'}

for st = 1:length(StimValues)
    for sl = 1:length(SleepTypes)
        n.(SleepTypes{sl}).(StimValues{st}) = 0;
        ResponsePostStim.(SleepTypes{sl}).(StimValues{st}) = [];
        MeanValPostStim.(SleepTypes{sl}).(StimValues{st}) = [];
        MeanValPreStim.(SleepTypes{sl}).(StimValues{st}) = [];
    end
end

figure
for st = 1:length(SleepTypes)
    subplot(1,length(SleepTypes),st)
    A = {WakeTimePostStim.(SleepTypes{st}).(StimValues{1}),WakeTimePostStim.(SleepTypes{st}).(StimValues{2}),...
       WakeTimePostStim.(SleepTypes{st}).(StimValues{3}),WakeTimePostStim.(SleepTypes{st}).(StimValues{4})};
    Cols = {[0.0015 0.0005 0.0139],[0.3151 0.0712 0.4848],[0.7132    0.2139    0.4763],[0.9859    0.5300    0.3801]};
    X = [1,2,3,4];
    Legends = {'1V','1,5V','2V','2,5V'};
    ShowPoints = 1;
    [boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
    ylabel('Durée des épisodes de sommeil en seconde')
    title(SleepTypes{st})

    n = 1;
    for i = 1:length(A)
        for j = i+1:length(A)
            % Perform Wilcoxon-Mann-Whitney test
            p(n)= ranksum(A{i},A{j});
            % Display p-value on the plot
            disp(['Data for ' SleepTypes{st} ' with stimulation ' (StimValues{i}) 'et' (StimValues{j}) ' p = ' num2str(p)]);
            nbi(n) = i
            nbj(n) = j
            n = n+1;
        end
    end
    for n = 1:3
        sigstar_DB([nbi(n) nbj(n)], p(n))
    end    
end

% With randomize zéro
figure
for st = 1:length(SleepTypes)
    subplot(1,length(SleepTypes),st)
    
    % Create the original A for statistics
    A = {WakeTimePostStim.(SleepTypes{st}).(StimValues{1}),WakeTimePostStim.(SleepTypes{st}).(StimValues{2}),...
         WakeTimePostStim.(SleepTypes{st}).(StimValues{3}),WakeTimePostStim.(SleepTypes{st}).(StimValues{4})};
    
    % Create a copy of A for plotting
    A_plot = A;
    
    % Randomize points with a value of 0 in A_plot
    for k = 1:length(A_plot)
        zero_indices = A_plot{k} == 0;
        A_plot{k}(zero_indices) = -0.25 + (0.25 - (-0.25)) * rand(sum(zero_indices), 1);
    end
    
    Cols = {[0.0015 0.0005 0.0139],[0.3151 0.0712 0.4848],[0.7132 0.2139 0.4763],[0.9859 0.5300 0.3801]};
    X = [1,2,3,4];
    Legends = {'1V','1.5V','2V','2.5V'};
    ShowPoints = 1;
    
    % Use the modified A_plot for plotting
    [boxhandle, pointshandle] = MakeBoxPlot_DB(A_plot, Cols, X, Legends, ShowPoints, 'connectdots', 1);
    
    ylabel('Durée des épisodes de sommeil en seconde')
    title(SleepTypes{st})
    
    n = 1;
    for i = 1:length(A)
        for j = i + 1:length(A)
            % Perform Wilcoxon-Mann-Whitney test using the original A
            p(n) = ranksum(A{i}, A{j});
            % Display p-value on the plot
            disp(['Data for ' SleepTypes{st} ' with stimulation ' (StimValues{i}) ' et ' (StimValues{j}) ' p = ' num2str(p(n))]);
            nbi(n) = i;
            nbj(n) = j;
            n = n + 1;
        end
    end
    
    for n = 1:3
        sigstar_DB([nbi(n) nbj(n)], p(n));
    end    
end

figure
for st = 1:length(SleepTypes)
    subplot(1,length(SleepTypes),st)
    A = {MeanValPostStim.(SleepTypes{st}).(StimValues{1}),MeanValPostStim.(SleepTypes{st}).(StimValues{2}),...
       MeanValPostStim.(SleepTypes{st}).(StimValues{3}),MeanValPostStim.(SleepTypes{st}).(StimValues{4})};
    Cols = {[0.0015 0.0005 0.0139],[0.3151 0.0712 0.4848],[0.7132    0.2139    0.4763],[0.9859    0.5300    0.3801]};
    X = [1,2,3,4];
    Legends = {'1V','1,5V','2V','2,5V'};
    ShowPoints = 1;
    [boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
    ylabel('Durée des épisodes de sommeil en seconde')
    title(SleepTypes{st})

    n = 1;
    for i = 1:length(A)
        for j = i+1:length(A)
            % Perform Wilcoxon-Mann-Whitney test
            p(n)= ranksum(A{i},A{j});
            % Display p-value on the plot
            disp(['Data for ' SleepTypes{st} ' with stimulation ' (StimValues{i}) 'et' (StimValues{j}) ' p = ' num2str(p)]);
            nbi(n) = i
            nbj(n) = j
            n = n+1;
        end
    end
    for n = 1:3
        sigstar_DB([nbi(n) nbj(n)], p(n))
    end    
end


%% Brouillon Statistiques

[p,anovatab,stats] = kruskalwallis(A);

.(SleepTypes{st}).(StimValues{1})




st = 3
    A = {WakeTimePostStim.(SleepTypes{st}).(StimValues{1}),WakeTimePostStim.(SleepTypes{st}).(StimValues{2}),...
       WakeTimePostStim.(SleepTypes{st}).(StimValues{3}),WakeTimePostStim.(SleepTypes{st}).(StimValues{4})};
   % Add path to swtest function

    for i = 1:length(A)
        [h, p] = swtest(A{i});
        if h == 1
            disp(['Data for ' SleepTypes{st} ' with stimulation ' Legends{i} ' is not normally distributed. p = ' num2str(p)]);
        else
            disp(['Data for ' SleepTypes{st} ' with stimulation ' Legends{i} ' is normally distributed. p = ' num2str(p)]);
        end
    end

hold on
    for i = 1:length(A)
        for j = i+1:length(A)
            % Perform Wilcoxon-Mann-Whitney test
            p= ranksum(A{i}, A{j});
            % Display p-value on the plot
            disp(['Data for ' SleepTypes{st} ' with stimulation ' (StimValues{i}) 'et' (StimValues{j}) ' p = ' num2str(p)]);
 
        end
    end
    
    

   [h,p] = swtest(A{i}, A{j}) % Shapiro
    p = ranksum(A{i}, A{j}) % Wilcoxo6Mann-Whitney


st = 1
    A = {MeanValPostStim.(SleepTypes{st}).(StimValues{1}),MeanValPostStim.(SleepTypes{st}).(StimValues{2}),...
       MeanValPostStim.(SleepTypes{st}).(StimValues{3}),MeanValPostStim.(SleepTypes{st}).(StimValues{4})};
   % Add path to swtest function
    for i = 1:length(A)
        [h, p] = swtest(A{i});
        if h == 1
            disp(['Data for ' SleepTypes{st} ' with stimulation ' Legends{i} ' is not normally distributed. p = ' num2str(p)]);
        else
            disp(['Data for ' SleepTypes{st} ' with stimulation ' Legends{i} ' is normally distributed. p = ' num2str(p)]);
        end
    end
    
  
   [h,p] = swtest(A{i}, A{j}) % Shapiro
    p = ranksum(A{i}, A{j}) % Wilcoxo6Mann-Whitney


for st = 1:length(SleepTypes)
    subplot(1,length(SleepTypes),st)
    A = [WakeTimePostStim.(SleepTypes{st}).(StimValues{1}),WakeTimePostStim.(SleepTypes{st}).(StimValues{2}),...
       WakeTimePostStim.(SleepTypes{st}).(StimValues{3}),WakeTimePostStim.(SleepTypes{st}).(StimValues{4})];
end
% % anova2(A)
% % [H,P] = ttest(WakeTimePostStim.(SleepTypes{st}).(StimValues{1}))

figure
for st = 1:length(SleepTypes)
    subplot(1,length(SleepTypes),st)
    A = {MeanValPostStim.(SleepTypes{st}).(StimValues{1}),MeanValPostStim.(SleepTypes{st}).(StimValues{2}),...
       MeanValPostStim.(SleepTypes{st}).(StimValues{3}),MeanValPostStim.(SleepTypes{st}).(StimValues{4})};
Cols = {[0.0015 0.0005 0.0139],[0.3151 0.0712 0.4848],[0.7132    0.2139    0.4763],[0.9859    0.5300    0.3801]};
X = [1,2,3,4];
Legends = {'1V','1,5V','2V','2,5V'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
    clear A
ylabel('Moyenne des données bruts après la stim')
title(SleepTypes{st})
end

