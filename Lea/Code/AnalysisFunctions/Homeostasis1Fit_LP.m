%% Homeostasis1Fit_LP() function 
%
%
% 10.04.2020 LP
%
% Function : Get info for linear regression on the whole data
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
%   - 'plot' : if = 1, plot quantif_tsd and the regression fit. 
%             (Default = 0)
%   - 'newfig' : if = 1, plot in a new fig.
%                (Default = 1)
%   - 'ZTtime' : tsd of ZT time, to convert time to ZT time.
%
%
% ----------------- OUTPUTS ----------------- :
%
%   - GlobalFit : structure with info about global regression 
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
%      GlobalFit = Homeostasis1Fit_LP(swa_tsd,'plot',1,'ZTtime',NewtsdZT) ;




function GlobalFit = Homeostasis1Fit_LP(quantif_tsd,varargin)
  

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
            case 'plot'
                toplot = varargin{i+1};
                if toplot ~= 0 & toplot ~= 1 
                   error('Incorrect value for optional argument "plot" : must be 0 or 1.') 
                end  
            case 'newfig'
                newfig = varargin{i+1};    
            case 'ZTtime'
                ZTtime = varargin{i+1};                
            otherwise
                error(['Unknown property ''' num2str(varargin{i}) '''.']);
        end
    end

    %check if exist and assign default value if not
    if ~exist('toplot','var')
        toplot = 0 ;
    end

    if ~exist('newfig','var')
        newfig = 1 ;
    end    
        
% ---------------------------------- Get Data ----------------------------------- :

    time = Range(quantif_tsd);
    
    % Convert to ZeitGeber time if required :
    if exist('ZTtime','var')
        time = (time + min(Data(ZTtime)))/3600E4 ;
    end
    
    data = Data(quantif_tsd);
    
    % Find all local maxima (peaks) :
    localmax = LocalMaxima(data) ; 
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

        
   % ---------------------------------- Plot if required ----------------------------------- :
   
    if toplot
       
        fit_colors = {[0.8 0.6 0.2],[0.8 0.4 0.4]} ;
        
        if newfig
            figure,
        end    
        hold on,
        
        plot(time,data)

        % Plot local maxima : 
        plot(t_max,d_max,'.','MarkerSize',10,'Color', fit_colors{2})

        % Plot global fit : 
        y_globalfit = polyval(Pcoeff, t_max) ;
        l= plot(t_max,y_globalfit,'-','Color', fit_colors{1}) ;

        % Legend :
        xlabel('Time'), title('Homeostasis Quantification','FontSize',12) ;
        legend(l,{sprintf('fit global, R2 = %.2f , S = %.2e ', [R2,Pcoeff(1)])},'FontSize',11) ;

  
   end     
        
end       
     
