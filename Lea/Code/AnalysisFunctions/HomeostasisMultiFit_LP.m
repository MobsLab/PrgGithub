%% HomeostasisMultiFit_LP() function 
%
%
% 10.04.2020 LP
%
% Function : Get info for linear regressions on multiple sleep episodes,
% when separated by "long" wake episodes
% Rq. fit only if >5 data points to be fitted. 
%
% ----------------- INPUTS ----------------- :
%
%   - quantif_tsd : tsd with quantification on which to compute the
%   regression. Ex. tsd with mean bandpower timecourse
%
%   - wake : intervalSet with wake episodes
%
%   - wake_thresh : duration threshold above which a new sleep episode is
%   defined for the regression, in minutes
%
%
% -- Optional Parameters -- : 
% (as pairs : 'arg_name', arg_value)
%   
%   - 'plot' : if = 1, plot quantif_tsd and the regression fit(s). 
%                (Default = 0)
%   - 'newfig' : if = 1, plot in a new fig.
%                (Default = 1)
%   - 'ZTtime' : tsd of ZT time, to convert time to ZT time.
%               
%   _ 'fit_start' : first time (in ts unit) after which to compute the fits
%               (Default = 0, ie. fit on whole quantif_tsd) 
%
% ----------------- OUTPUTS ----------------- :
%
%   - GlobalFit : structure with info about global regression 
%
%   - MultiFit : structure with info about the multiple regressions, in
%   cell arrays (values for all fits)
%
% Structure fields :
%       - time
%       - data
%       - idx_localmax : indices of data points in tsd corresponding to
%       local maxima used for regression
%       - reg_coeff : coefficients of linear regression (in descending
%       power, Cf. polyfit() function)
%       - R2 : determination coefficient
%       - R2global (MultiFit only) : determination coefficient of global
%       fit calculated on each sleep period of multiple fits
%
%
% ----------------- Example ----------------- :
%
%      [GlobalFit, MultiFit] = HomeostasisMultiFit_LP(swa_tsd,WAKE,20,'plot',1,'ZTtime',NewtsdZT) ;




function [GlobalFit, MultiFit] = HomeostasisMultiFit_LP(quantif_tsd,wake,wake_thresh,varargin)
  

% ---------------------------------- Check optional parameters ----------------------------------- :

 
    if nargin < 3 || mod(length(varargin),2) ~= 0
      error('Incorrect number of parameters.');
    end

    % Parse parameter list
    for i = 1:2:length(varargin)
        if ~ischar(varargin{i})
            error(['Parameter ' num2str(i+2) ' is not a property.']);
        end
        switch (varargin{i})
            case 'plot'
                toplot = varargin{i+1};
                if toplot ~= 0 & toplot ~= 1 
                   error('Incorrect value for optional argument "plot" : must be 0 or 1.') 
                end
            case 'newfig'
                newfig = varargin{i+1};
            case 'ZTtime'
                ZTtime = varargin{i+1};     
            case 'fit_start'
                fit_start = varargin{i+1};                   
            otherwise
                error(['Unknown property ''' num2str(varargin{i}) '''.']);
        end
    end

    %check if exist and assign default value if not
    if ~exist('toplot','var')
        toplot = 0 ;
    end
    
    if ~exist('newfig','var')
        if toplot
            newfig = 1 ;
        else
            newfig = 0 ;
        end    
    end   
    
    if ~exist('fit_start','var')
        fit_start = 0 ; 
    end
    

% ---------------------------------- Get Data ----------------------------------- :

    time = Range(quantif_tsd);
    data = Data(quantif_tsd);
    
    % Find all local maxima (peaks), after fit_start time :
    localmax = LocalMaxima(data) ; 
        % Keep only local maxima if after fit_start time :
    localmax = localmax(time(localmax) >= fit_start) ;   
    
    % Convert to ZeitGeber time if required :
    if exist('ZTtime','var')
        time = (time + min(Data(ZTtime)))/3600E4 ;
    end
    
    t_max = time(localmax) ; d_max = data(localmax) ; 

% ---------------------------------- Get Homeostasis info ----------------------------------- :

    
    % GLOBAL LINEAR FIT :     
    
        % Regression :
        Pcoeff = polyfit(t_max, d_max,1) ;
        y_globalfit = polyval(Pcoeff, t_max) ; 

        % R2 determination Coeff :
        SStot = sum((d_max - mean(d_max)).^2); SSres = sum((d_max - y_globalfit).^2); 
        R2 = 1 - SSres/SStot ;

        % Store linear regression info in structure :
        GlobalFit.time = time ;
        GlobalFit.data = data ;
        GlobalFit.idx_localmax = localmax ;
        GlobalFit.reg_coeff = Pcoeff ; 
        GlobalFit.R2 = R2 ;

        
    % MULTIPLE LINEAR FITS   
        
        % --- Define episodes for Multiple Fits --- :
    longwake_idx = find(Data(length(wake)) > wake_thresh*60e4) ; % idx of long wake periods (with duration > wake_thresh)
    longwake_end = getfield(End(wake),{longwake_idx}) ; % end times of those 'long' wake periods
    
    if ~exist('ZTtime','var')
        multifit_times = [time(1) ; longwake_end ; time(end) ]; % limit times for the fit periods separated by long wake periods
    else
        multifit_times = [time(1) ; (longwake_end+min(Data(ZTtime)))/3600E4 ; time(end) ]; % idem with ZT time (hours)
    end
    
    
        % --- Get linear fit for each episode --- : 

    all_idx_localmax = {} ;
    all_reg_coeff = {} ;
    all_R2 = {} ;
    all_R2global = {} ;
    
    for i=1:length(multifit_times)-1 
        
        idx_fit = find( (time(localmax)>multifit_times(i)) & (time(localmax)<multifit_times(i+1)) ) ;   % index of local maxima belonging to this period
        
        
        if length(idx_fit) > 5 % if sleep episode has more than 5 local maxima to be fitted
            
            Pcoeff_fit = polyfit(t_max(idx_fit), d_max(idx_fit),1) ;
            y_fit = polyval(Pcoeff_fit, t_max(idx_fit)) ;  
            
            % R2 determination Coeff :
            SStot = sum((d_max(idx_fit) - mean(d_max(idx_fit))).^2); SSres = sum((d_max(idx_fit) - y_fit).^2); 
            R2_fit = 1 - SSres/SStot ;
            
            % Global R2 on this sleep episode :
            y_globalfit = polyval(Pcoeff, t_max(idx_fit)) ;
            SStot = sum((d_max(idx_fit) - mean(d_max(idx_fit))).^2); SSres = sum((d_max(idx_fit) - y_globalfit).^2); 
            R2global = 1 - SSres/SStot ;
        
            % Store fit info :
            all_idx_localmax{end+1} = idx_fit ;
            all_reg_coeff{end+1} = Pcoeff_fit ;
            all_R2{end+1} = R2_fit ;
            all_R2global{end+1} = R2global ;
        end    
      
    end   
    
    % Store multifit linear regression info :
        MultiFit.time = time ;
        MultiFit.data = data ;
        MultiFit.idx_localmax = all_idx_localmax ;
        MultiFit.reg_coeff = all_reg_coeff ; 
        MultiFit.R2 = all_R2 ;
        MultiFit.R2global = all_R2global ;
   
        
        
   % ---------------------------------- Plot if required ----------------------------------- :
   
    if toplot
       
        fit_colors = {[0.8 0.6 0.2],[0.8 0.4 0.4]} ;
        
        if newfig
            figure,
        end   
        
        plot(time,data), hold on,

        % Plot local maxima : 
        plot(t_max,d_max,'.','MarkerSize',10,'Color', fit_colors{2})

        % Plot global fit : 
        y_globalfit = polyval(Pcoeff, t_max) ;
        l= plot(t_max,y_globalfit,'-','Color', fit_colors{1}) ;


        % ---- Plot multiple fits ---- :

        % to store all fit plot handles and legends :
        fitplots = [l] ;
        fitlegend = {sprintf('fit global, R2 = %.2f , S = %.2e ', [R2,Pcoeff(1)])};
        all_R2 = [R2] ;
        all_slope = [Pcoeff(1)] ;

        % for each fit :
        for i=1:length(MultiFit.R2) 
            Pcoeff_fit = MultiFit.reg_coeff{i} ;
            idx_fit = MultiFit.idx_localmax{i} ;
            y_fit = polyval(Pcoeff_fit, t_max(idx_fit)) ;  
            l = plot(t_max(idx_fit),y_fit,'-','Color', fit_colors{2}) ;
            R2 = MultiFit.R2{i} ;
            R2glob = MultiFit.R2global{i} ;

            % Save regression info :
            all_R2(end+1) = R2 ; all_slope(end+1) = Pcoeff_fit(1) ; 
            fitplots(end+1) = l ; % save fit plot handle for legend
            fitlegend{end+1} = sprintf('fit %d, R2 = %.2f , S = %.2e, R2glob = %.2f', [length(all_R2)-1,R2,Pcoeff_fit(1),R2glob]) ;
        end

        % Legend :
        xlabel('Time'), title('Homeostasis Quantification','FontSize',12) ;
        legend(fitplots,fitlegend,'FontSize',11) ;

  
   end     
        
end       
     
