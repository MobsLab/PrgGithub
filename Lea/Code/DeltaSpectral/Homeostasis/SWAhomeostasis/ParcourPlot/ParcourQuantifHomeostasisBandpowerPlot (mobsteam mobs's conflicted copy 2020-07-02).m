%% ParcourQuantifHomeostasisBandpowerPlot
%
% 15/04/2020 LP 
%
% Plot homeostasis on event occupancy for each session + mean of all sessions. 
% "Homeostasis" computed here through linear regression of local maxima 
% on bandpower (sup/deep PFCx and Olfactory Bulb). 
% -> Global fit for whole session and Multifit for separate sleep episodes 
%
%
% SEE : QuantifHomeostasisBandpower ParcourQuantifHomeostasisBandpower
%
% /!\ Can plot only after getting the data with ParcourQuantifHomeostasisBandpower


clear

% ----------------------------------------- CHOOSE DATA ----------------------------------------- :

% Wake duration threshold for multifit (choose data file to be plotted) :

freqband_choice = 3 ; 
multifit_thresh = 'none' ; % wake duration (in minutes) between separate sleep episodes if multifit. 'none' for 1 or 2 fits.
twofit_duration = 3 ; % duration of the 1st of two fits, in hours. / 'none' for 1 fit. 
afterREM1 = false ; 
% ----------------------------------------- LOAD DATA ----------------------------------------- :

% -- Define description for filename, based on parameters -- :

if multifit_thresh == 'none' % if one or two fits : 
    if twofit_duration == 'none' % 1 fit
        description = 'globalfit' ; 
    else % 2 fits
        description = ['twofit_' num2str(twofit_duration)] ; 
    end
else % multifit
    description = ['multifit_' num2str(multifit_thresh)] ; 
end 

if afterREM1 
    description = [description '_afterREM1']
end

description = [description '_freqband' num2str(freqband_choice)] ; 

% -- Load file -- :

try 
    eval(['load ' FolderDataLP_DeltaSpectral 'Data/ParcourQuantifHomeostasisBandpower_' description '.mat']) % path if on lab computer
    dir_path = [FolderDataLP_DeltaSpectral 'Results/Homeostasis/Bandpower/Bandpower_' description'] ; 
    if ~exist(dirpath,'dir'); mkdir(dir_path); end
    cd(dir_path)  
    
catch
    eval(['load /Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/DeltaSpectral/Data/ParcourQuantifHomeostasisBandpower_' description '.mat']) % if on personal computer   
    dir_path = ['/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/DeltaSpectral/Results/Homeostasis/Bandpower/Bandpower_' description] ;
    if ~exist(dir_path,'dir'); mkdir(dir_path); end
    cd(dir_path)
    
end    



%% ----------------------------------------- PLOT DATA separately for each session ----------------------------------------- :


fit_colors = {[0.8 0.6 0.2],[0.8 0.4 0.4]} ;
subplot_list = {1 3 4};

struct_names = {'PFCx sup','PFCx deep','Olfactory Bulb deep'} ;
struct_data = {Homeo_res.PFCsup,Homeo_res.PFCdeep,Homeo_res.OBdeep} ;


% Choose sessions to be plotted :
ToPlot = 1:length(Homeo_res.path) ; % Plot all sessions
%ToPlot = [1 3] ; % Choose sessions to plot

for p = ToPlot
    
    figure,

    % ------------------ One subplot for each quantif ------------------ :   
    
    for q = 1:length(struct_names) 
        
        % Extract variables
        Homeo = struct_data{q} ;
        all_fields = fieldnames(Homeo) ;
        for i = 1:length(all_fields)
            field = all_fields{i} ;
            eval([field '= Homeo.' field '{p} ;'])
        end
        
   % ------ Plot Bandpower & Homeostasis ------ : 

        subplot(2,2,subplot_list{q}),

        hold on,
        plot(time,data) 
   
        % GLOBAL FIT :
        
        % Plot local maxima :
        t_max = time(idx_localmax); d_max = data(idx_localmax) ;
        plot(t_max,d_max,'.','MarkerSize',10,'Color', fit_colors{2}),
        % Plot global fit : 
        y_fit = polyval(reg_coeff, t_max) ; 
        l = plot(t_max,y_fit,'-','Color', fit_colors{1}) ;
        
        
        
        % 2-FIT :
        if (multifit_thresh == 'none') & (twofit_duration ~= 'none')
            
            % to store all fit plot handles and legends :
            fitplots = [l] ;
            fitlegend = {sprintf('fit global, R2 = %.2f , S = %.2e ', [R2,reg_coeff(1)])};
            all_slope = [reg_coeff(1)] ;

           % for each fit :
            for i=1:length(twofitR2) 
                reg_coeff_fit = twofitreg_coeff{i} ;
                idx_fit = twofitidx_localmax{i} ;
                if ~isempty(idx_fit)
                    y_fit = polyval(reg_coeff_fit, t_max(idx_fit)) ;  
                    l = plot(t_max(idx_fit),y_fit,'-','Color', fit_colors{2}) ;

                    % Save regression info :
                    all_slope(end+1) = reg_coeff_fit(1) ; 
                    fitplots(end+1) = l ; % save fit plot handle for legend
                    fitlegend{end+1} = sprintf('fit %d, R2 = %.2f , S = %.2e', [i,twofitR2{i},reg_coeff_fit(1)]) ;
                end
            end
            
            % Legend :
            xlabel('ZT Time (hour)'), title(struct_names{q},'FontSize',12) ;
            legend(fitplots,fitlegend,'FontSize',11) ;  
        
               % Title :
            subplot(2,2,2),
            text(0.5,0.8,'Bandpower Homeostasis','FontSize',30,'HorizontalAlignment','center'), axis off
            text(0.5,0.6,sprintf('Frequency Band : %g - %g Hz',freqband(1),freqband(2)),'FontSize',20,'HorizontalAlignment','center'), axis off
            text(0.5,0.45,['Windowsize : ' num2str(windowsize) 's'],'FontSize',20,'HorizontalAlignment','center'), axis off

            
        % MULTIPLE FITS :  
        elseif multifit_thresh ~= 'none'

            % to store all fit plot handles and legends :
            fitplots = [l] ;
            fitlegend = {sprintf('fit global, R2 = %.2f , S = %.2e ', [R2,reg_coeff(1)])};
            all_slope = [reg_coeff(1)] ;

           % for each fit :
            for i=1:length(multiR2) 
                reg_coeff_fit = multireg_coeff{i} ;
                idx_fit = multiidx_localmax{i} ;
                y_fit = polyval(reg_coeff_fit, t_max(idx_fit)) ;  
                l = plot(t_max(idx_fit),y_fit,'-','Color', fit_colors{2}) ;

                % Save regression info :
                all_slope(end+1) = reg_coeff_fit(1) ; 
                fitplots(end+1) = l ; % save fit plot handle for legend
                fitlegend{end+1} = sprintf('fit %d, R2 = %.2f , S = %.2e, R2glob = %.2f', [i,multiR2{i},reg_coeff_fit(1),multiR2global{i}]) ;
            end 
            
                % Legend :
            xlabel('ZT Time (hour)'), title(struct_names{q},'FontSize',12) ;
            legend(fitplots,fitlegend,'FontSize',11) ;   
            
                % Title :
            subplot(2,2,2),
            text(0.5,0.8,'Bandpower Homeostasis','FontSize',30,'HorizontalAlignment','center'), axis off
            text(0.5,0.6,sprintf('Frequency Band : %g - %g Hz',freqband(1),freqband(2)),'FontSize',20,'HorizontalAlignment','center'), axis off
            text(0.5,0.45,['Windowsize : ' num2str(windowsize) 's'],'FontSize',20,'HorizontalAlignment','center'), axis off
            text(0.5,0.3,['Multifit Wake Threshold : ' num2str(wake_thresh) 'min'],'FontSize',20,'HorizontalAlignment','center'), axis off

            
        end
        

    end
    
    
    
        % Save Plot :   
    saveas(gcf,['./ParcourQuantifHomeostasisBandpowerPlot' num2str(p) '_' Homeo_res.name{p} '.png']) 
    %saveas(gcf,['epsFigures/ParcourQuantifHomeostasisBandpowerPlot' num2str(p) '_' Homeo_res.name{p} '.eps'],'epsc')
    
end




  
%% ----------------------------------------- MEAN PLOT for all sessions : GLOBAL FIT ----------------------------------------- :


% GLOBAL FIT ONLY : 

fit_colors = {[0.8 0.6 0.2],[0.8 0.4 0.4]} ;
subplot_list = {1 3 4};

struct_names = {'PFCx sup','PFCx deep','Olfactory Bulb deep'} ;
struct_data = {Homeo_res.PFCsup,Homeo_res.PFCdeep,Homeo_res.OBdeep} ;


% Choose sessions to be plotted :
ToPlot = 1:length(Homeo_res.path) ; % Plot all sessions
%ToPlot = [1 3] ; % Choose sessions to plot

figure,
    
    % ------------------ One subplot for each quantif ------------------ :   
    
for q = 1:length(struct_names) 

    Homeo = struct_data{q} ;

    % ------ Plot Event Occupancy Homeostasis (all) ------ :
    
    subplot(2,2,subplot_list{q}),
    hold on,
 
    for p=ToPlot
        
        % Extract variables
        time = Homeo.time{p} ;
        data = Homeo.data{p} ;
        idx_localmax = Homeo.idx_localmax{p} ;
        reg_coeff = Homeo.reg_coeff{p} ;
        
        t_max = time(idx_localmax); d_max = data(idx_localmax) ;
        y_fit = polyval(reg_coeff, t_max) ;
        d = plot(t_max,d_max,'.','MarkerSize',10,'Color', [0.77 0.77 0.77]); % grey dots for all local maxima from all sessions
        l = plot(t_max,y_fit,'-','Color', fit_colors{2},'LineWidth',2) ; % lines for global fits from all sessions
        uistack(d,'bottom'); % put dots in bakground
    end
    
    xlabel('Time (hours)'), ylabel('Slow Wave Activity (% of mean NREM SWA)');
    title([struct_names{q}],'FontSize',12) ;
    mean_reg_coeff = mean(vertcat(Homeo.reg_coeff{ToPlot})) ; % mean slope coeff (linear regression)
    legend([d,l],{'Bandpower Local Maxima (all)', 
        [sprintf('Linear Regression, mean R2 = %.2f', nanmean([Homeo.R2{ToPlot}])) newline sprintf('Mean Slope = %.3e', mean_reg_coeff(1))] },'FontSize',11)  % mean R2 value
       
    
end         
  

subplot(2,2,2),
text(0.5,0.8,'Mean Bandpower Homeostasis','FontSize',30,'HorizontalALignment','center'), axis off
text(0.5,0.6,sprintf('Frequency Band : %g - %g Hz',freqband(1),freqband(2)),'FontSize',20,'HorizontalAlignment','center'), axis off
text(0.5,0.45,['Windowsize : ' num2str(windowsize) 's'],'FontSize',20,'HorizontalAlignment','center'), axis off
text(0.5,0.3,['Global fits only'],'FontSize',20,'HorizontalAlignment','center'), axis off



    % Save Plot :   
saveas(gcf,['./ParcourQuantifHomeostasisBandpowerPlot_GlobalMean.png']) 
%saveas(gcf,['epsFigures/ParcourQuantifHomeostasisBandpowerPlot_GlobalMean.eps'],'epsc')



  
%% ----------------------------------------- MEAN PLOT for all sessions : MULTIPLE FITS ----------------------------------------- :

if multifit_thresh ~= 'none'
    
    % MULTIPLE FITS ONLY : 

    fit_colors = {[0.8 0.6 0.2],[0.8 0.4 0.4]} ;
    subplot_list = {1 3 4};

    struct_names = {'PFCx sup','PFCx deep','Olfactory Bulb deep'} ;
    struct_data = {Homeo_res.PFCsup,Homeo_res.PFCdeep,Homeo_res.OBdeep} ;


    % Choose sessions to be plotted :
    ToPlot = 1:length(Homeo_res.path) ; % Plot all sessions
    %ToPlot = [1 3] ; % Choose sessions to plot

    figure,

        % ------------------ One subplot for each quantif ------------------ :   

    for q = 1:length(struct_names) 

        Homeo = struct_data{q} ;
        all_slopes = [] ; % to store slope values
        all_R2diff = [] ; % to store R2diff values (difference between R2 and R2global on each of the multiple fits)

        % ------ Plot Event Occupancy Homeostasis (all) ------ :

        subplot(2,2,subplot_list{q}),
        hold on,

        for p=ToPlot

            % Extract variables
            time = Homeo.time{p} ;
            data = Homeo.data{p} ;
            idx_localmax = Homeo.idx_localmax{p} ;
            multireg_coeff = Homeo.multireg_coeff{p} ;
            multiidx_localmax = Homeo.multiidx_localmax{p} ;

            % grey dots for all local maxima from all sessions :
            t_max = time(idx_localmax); d_max = data(idx_localmax) ;
            d = plot(t_max,d_max,'.','MarkerSize',10,'Color', [0.77 0.77 0.77]); 
            uistack(d,'bottom'); % put dots in bakground 


            % line for each fit :
            for i=1:length(multireg_coeff)    
                reg_coeff_fit = multireg_coeff{i} ;
                idx_fit = multiidx_localmax{i} ;
                y_fit = polyval(reg_coeff_fit, t_max(idx_fit)) ;  
                l = plot(t_max(idx_fit),y_fit,'-','Color', fit_colors{2},'LineWidth',2) ;
                all_slopes(end+1) = reg_coeff_fit(1) ; % store slope value            
            end

            R2_diff = cell2mat(Homeo.multiR2{p})-cell2mat(Homeo.multiR2global{p}) ;
            all_R2diff = [all_R2diff, R2_diff] ;

        end

        xlabel('Time (hours)'), ylabel('Slow Wave Activity (% of mean NREM SWA)');
        title([struct_names{q}],'FontSize',12) ;

        % mean slope coeff : 
        mean_slope = nanmean(all_slopes) ; % mean slope coeff (linear regression)
        legend([d,l],{'Bandpower Local Maxima (all)', 
            [sprintf('Linear Regression, Mean R2diff = %.2f',nanmean(all_R2diff)) newline sprintf('Mean Slope = %.3e', mean_slope)] },'FontSize',11) 


    end         


    subplot(2,2,2),
    text(0.5,0.8,'Mean Bandpower Homeostasis','FontSize',30,'HorizontalALignment','center'), axis off
    text(0.5,0.6,sprintf('Frequency Band : %g - %g Hz',freqband(1),freqband(2)),'FontSize',20,'HorizontalAlignment','center'), axis off
    text(0.5,0.45,['Windowsize : ' num2str(windowsize) 's'],'FontSize',20,'HorizontalAlignment','center'), axis off
    text(0.5,0.3,['Multifit Wake Threshold : ' num2str(wake_thresh) 'min'],'FontSize',20,'HorizontalAlignment','center'), axis off



        % Save Plot :   
    saveas(gcf,['./ParcourQuantifHomeostasisBandpowerPlot_MultipleMean.png']) 
    %saveas(gcf,['epsFigures/ParcourQuantifHomeostasisBandpowerPlot_MultipleMean.eps'],'epsc')


end




  
%% ----------------------------------------- MEAN PLOT for all sessions : TWO FITS ----------------------------------------- :


if (multifit_thresh == 'none') & (twofit_duration ~= 'none')

    fit_colors = {[0.8 0.6 0.2],[0.8 0.4 0.4]} ;
    subplot_list = {1 3 4};

    struct_names = {'PFCx sup','PFCx deep','Olfactory Bulb deep'} ;
    struct_data = {Homeo_res.PFCsup,Homeo_res.PFCdeep,Homeo_res.OBdeep} ;


    % Choose sessions to be plotted :
    ToPlot = 1:length(Homeo_res.path) ; % Plot all sessions
    %ToPlot = [1 3] ; % Choose sessions to plot

    figure,

        % ------------------ One subplot for each quantif ------------------ :   

    for q = 1:length(struct_names) 

        Homeo = struct_data{q} ;
        all_slopes_1 = [] ; % to store slope values for 1st fits
        all_slopes_2 = [] ; % to store slope values for 2nd fits
        all_R2_1 = [] ; % idem for R2
        all_R2_2 = [] ; % idem for R2

        % ------ Plot Event Occupancy Homeostasis (all) ------ :

        subplot(2,2,subplot_list{q}),
        hold on,

        for p=ToPlot

            % Extract variables
            time = Homeo.time{p} ;
            data = Homeo.data{p} ;
            idx_localmax = Homeo.idx_localmax{p} ;
            twofitreg_coeff = Homeo.twofitreg_coeff{p} ;
            twofitidx_localmax = Homeo.twofitidx_localmax{p} ;
            twofit_R2 = (Homeo.twofitR2{p}) ; 

            % grey dots for all local maxima from all sessions :
            t_max = time(idx_localmax); d_max = data(idx_localmax) ;
            d = plot(t_max,d_max,'.','MarkerSize',10,'Color', [0.77 0.77 0.77]); 
            uistack(d,'bottom'); % put dots in bakground 


            % line for each fit :
            for i=1:length(twofitreg_coeff)  
                reg_coeff_fit = twofitreg_coeff{i} ;
                idx_fit = twofitidx_localmax{i} ;
                y_fit = polyval(reg_coeff_fit, t_max(idx_fit)) ;  
                eval(['l' num2str(i) '= plot(t_max(idx_fit),y_fit,"-","Color", fit_colors{3-i},"LineWidth",2) ;']) % plot and store handle for the legend 
                eval(['all_slopes_' num2str(i) '(end+1) = reg_coeff_fit(1);']); % store slope values for the corresponding fit   
                eval(['all_R2_' num2str(i) '(end+1) = twofit_R2{i};']) % store slope values for the corresponding fit     
            end

        end

        xlabel('Time (hours)'), ylabel('Slow Wave Activity (% of mean NREM SWA)');
        title([struct_names{q}],'FontSize',12) ;
        mean_reg_coeff = mean(vertcat(Homeo.reg_coeff{ToPlot})) ; % mean slope coeff (linear regression)
        legend([d,l1,l2],{'Density Local Maxima',[sprintf('1st Fit : mean R2 = %.2f, Mean Slope = %.3e', nanmean(all_R2_1),nanmean(all_slopes_1))], [sprintf('2nd Fit : mean R2 = %.2f, Mean Slope = %.3e', nanmean(all_R2_2),nanmean(all_slopes_2))]},'FontSize',11)  % mean R2diff value
        ylim([30 280]) ; 

    end         


    subplot(2,2,2),
    text(0.5,0.8,'Mean Bandpower Homeostasis','FontSize',30,'HorizontalALignment','center'), axis off
    text(0.5,0.6,sprintf('Frequency Band : %g - %g Hz',freqband(1),freqband(2)),'FontSize',20,'HorizontalAlignment','center'), axis off
    text(0.5,0.45,['Windowsize : ' num2str(windowsize) 's'],'FontSize',20,'HorizontalAlignment','center'), axis off



        % Save Plot :   
    saveas(gcf,['./ParcourQuantifHomeostasisBandpowerPlot_2FitMean.png']) 
    %saveas(gcf,['epsFigures/ParcourQuantifHomeostasisBandpowerPlot_2FitMean.eps'],'epsc')


    

end