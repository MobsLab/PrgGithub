%% Homeostasis2Fit_LP() function 
%
%
% 10.04.2020 LP
%
% Function : Get info for linear regressions on 2 parts of the data (1st
% fit on '1stfit_window' and 2nd fit on the rest of the session, default =
% 1st fit on the 1st 3 hours, starting at the first detected local maxima) ; 
%
%
% ----------------- INPUTS ----------------- :
%
%   - quantif_tsd : tsd with quantification on which to compute the
%   regression. Ex. tsd with mean bandpower timecourse.
%
%
% -- Optional Parameters -- : 
% (as pairs : 'arg_name', arg_value)
%
%   - 'firstfit_duration' : duration of the first fit, starting at the 
%   first detected local maxima. Second fit is on the rest of the session. 
%   Unit = hours. 
%             (Default = 3)
%   
%   - 'plot' : if = 1, plot quantif_tsd and the regression fit. 
%             (Default = 0)
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
%   - TwoFit : structure with info about the 2 successive regressions
%
% Structure fields :
%       - time
%       - data
%       - idx_localmax : indices of data points in tsd corresponding to
%       local maxima used for regression
%       - reg_coeff : coefficients of linear regression (in descending
%       power, Cf. polyfit() function)
%       - R2 : determination coefficient
%
%
% ----------------- Example ----------------- :
%
%      [GlobalFit,TwoFit] = Homeostasis2Fit_LP(evt_density,'firstfit_duration',3,'plot',1,'ZTtime',NewtsdZT) ;




function [GlobalFit,TwoFit] = Homeostasis2Fit_LP(quantif_tsd,varargin)
  

% ---------------------------------- Check optional parameters ----------------------------------- :

 
    if nargin < 1 || mod(length(varargin),2) ~= 0
      error('Incorrect number of parameters.');
    end

    % Parse parameter list
    for i = 1:2:length(varargin)
        if ~ischar(varargin{i})
            error(['Parameter ' num2str(i+2) ' is not a property.']);
        end
        switch (varargin{i})
            case 'firstfit_duration'
                firstfit_duration = varargin{i+1}; 
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
    if ~exist('firstfit_duration','var')
        firstfit_duration = 3 ; % default = 1st fit on the first 3 hours
    end
    if ~exist('toplot','var')
        toplot = 0 ;
    end

    if ~exist('newfig','var')
        newfig = 1 ;
    end 
    if ~exist('fit_start','var')
        fit_start = 0 ; 
    end
    
        
% ---------------------------------- Get Data ----------------------------------- :

    time = Range(quantif_tsd);
    data = Data(quantif_tsd);
    
    % Convert to ZeitGeber time if required :
    if exist('ZTtime','var')
        time = (time + min(Data(ZTtime)))/3600E4 ;
    else
        firstfit_duration = firstfit_duration*3600e4 ; % convert duration in right unit if no ZT time
    end
    
    % Find Local maxima : 
    localmax = LocalMaxima(data) ; 
        % Keep only local maxima if after fit_start time :
        localmax = localmax(time(localmax) >= fit_start) ;
        
    t_max = time(localmax) ; d_max = data(localmax) ;
    
    % Define 1st and 2nd fit times and local maxima : 
    fit1_ix = find(t_max <= (t_max(1) + firstfit_duration)) ; 
    fit2_ix = find(t_max > (t_max(1) + firstfit_duration)) ;
    
   
    

% ---------------------------------- Get Homeostasis info ----------------------------------- :

% GLOBAL LINEAR FIT :     
    
    % Regression :
    Pcoeff = polyfit(t_max, d_max,1) ;
    y_globalfit = polyval(Pcoeff, t_max) ; 

    % R2 determination Coeff :
    SStot = sum((d_max - mean(d_max)).^2); SSres = sum((d_max - y_globalfit).^2); 
    
     if SStot == 0
        R2 = NaN ; % 
        disp('Warning : Residual sum of squares = 0 for homeostasis regression, R2 set to NaN.')
     else
        R2 = 1 - SSres/SStot ;
     end

    % Store linear regression info in structure :
    GlobalFit.time = time ;
    GlobalFit.data = data ;
    GlobalFit.idx_localmax = localmax ;
    GlobalFit.reg_coeff = Pcoeff ; 
    GlobalFit.R2 = R2 ;    


% 2 LINEAR FIT :     
    
    allfits_ix = {fit1_ix,fit2_ix} ; 
    TwoFit.time = time ;
    TwoFit.data = data ;

    % For each fit :
    
    for f = 1:length(allfits_ix) 

        % Regression :
        fit_ix = allfits_ix{f} ; 
        tmax_fit = t_max(fit_ix) ; dmax_fit = d_max(fit_ix) ; 
        Pcoeff_fit = polyfit(tmax_fit,dmax_fit,1) ;
        y_globalfit = polyval(Pcoeff_fit, tmax_fit) ; 
        SStot = sum((dmax_fit - mean(dmax_fit)).^2); SSres = sum((dmax_fit - y_globalfit).^2); 
        if SStot == 0
            R2_fit = NaN ; % 
            disp('Warning : Residual sum of squares = 0 for homeostasis regression, R2 set to NaN.')
        else
            R2_fit = 1 - SSres/SStot ;
        end
        
        % Store linear regression info in structure :
        TwoFit.idx_localmax{f} = fit_ix ;
        TwoFit.reg_coeff{f} = Pcoeff_fit ; 
        TwoFit.R2{f} = R2_fit ;
        
    end 

    

        
   % ---------------------------------- Plot if required ----------------------------------- :
   
    if toplot
       
        fit_colors = {[0.8 0.6 0.2],[0.8 0.4 0.4]} ;
        
        if newfig
            figure,
        end    
        hold on,
        
        plot(time,data)

        % ---- Plot Global Fit ---- :
        
        % Plot local maxima : 
        plot(t_max,d_max,'.','MarkerSize',10,'Color', fit_colors{2})

        % Plot global fit : 
        y_globalfit = polyval(Pcoeff, t_max) ;
        l= plot(t_max,y_globalfit,'-','Color', fit_colors{1}) ;

        
        % ---- Plot 2 Fits ---- :
        
        % to store all fit plot handles and legends :
        fitplots = [l] ;
        fitlegend = {sprintf('fit global, R2 = %.2f , S = %.2e ', [R2,Pcoeff(1)])};
        all_R2 = [R2] ;
        all_slope = [Pcoeff(1)] ;

        % for each fit :
        for i=1:length(TwoFit.R2) 
            Pcoeff_fit = TwoFit.reg_coeff{i} ;
            idx_fit = TwoFit.idx_localmax{i} ;
            y_fit = polyval(Pcoeff_fit, t_max(idx_fit)) ;  
            l = plot(t_max(idx_fit),y_fit,'-','Color', fit_colors{2}) ;
            R2 = TwoFit.R2{i} ;

            % Save regression info :
            all_R2(end+1) = R2 ; all_slope(end+1) = Pcoeff_fit(1) ; 
            fitplots(end+1) = l ; % save fit plot handle for legend
            fitlegend{end+1} = sprintf('fit %d, R2 = %.2f , S = %.2e', [length(all_R2)-1,R2,Pcoeff_fit(1)]) ;
        end
        
        % Legend :
        xlabel('Time'), title('Homeostasis Quantification','FontSize',12) ;
        legend(fitplots,fitlegend,'FontSize',11) ;

   end     
        
end       
     
