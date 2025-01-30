% PLOT_HYPNOGLP() function
%
% 03/04/2020
%
% Function : plot the hypnogramm with N1, N2, N3, REM, WAKE substages 
%
% ----------------- INPUTS ----------------- :
%   
%
% -- Optional Parameters -- : 
% (as pairs : 'arg_name', arg_value) 
%
%   - 'ZTtime' : tsd with Zeitgeber time
%   - 'Colors' : cell array with plot colors for the substages
%   - 'newfig' : if = 1, plot on a new figure. Default : newfig = 1;
%   - 'NREMsubstages' : if = 1, plot N1,N2,N3 separately. If = 0, plot
%   NREM. Default = 1 ; 
%
% ----------------- OUTPUTS ----------------- :
%
%   - no output (plot)
%
%
% ----------------- Example ----------------- :
%
%        ex. plot_hypnogLP('ZTtime',NewtsdZT)




function plot_hypnogLP(varargin)



% ---------------------------------- Check optional parameters ----------------------------------- :

    % Number of arguments :
    if mod(length(varargin),2) ~= 0  % At least 5 required arguments, and optional arguments as pairs ('arg_name', arg)  
      error('Incorrect number of parameters.');
    end
    
    load('SleepSubstages.mat')
    N1 = Epoch{strcmpi(NameEpoch,'N1')} ; N2 = Epoch{strcmpi(NameEpoch,'N2')} ; N3 = Epoch{strcmpi(NameEpoch,'N3')} ;  
    REM = Epoch{strcmpi(NameEpoch,'REM')} ; WAKE = Epoch{strcmpi(NameEpoch,'WAKE')}; SWS = Epoch{7} ;
    substages_list = {N1, N2, N3, REM, WAKE} ;

    % Zeitgeber time
    load('behavResources.mat', 'NewtsdZT')
    ZTtime = NewtsdZT ;

    
    % Parse optional parameter list :
    for i = 1:2:length(varargin)    % for each 'arg_name'
        if ~ischar(varargin{i})     % has to be a character array
            error(['Parameter ' num2str(i+2) ' is not a property.']);
        end
        switch (varargin{i})
            case 'ZTtime'
                ZTtime = varargin{i+1}; % assign argument value
            case 'Colors'
                Colors = varargin{i+1};
            case 'newfig'
                newfig = varargin{i+1};
            case 'NREMsubstages'
                NREMsubstages = varargin{i+1};                
            otherwise
                error(['Unknown property ''' num2str(varargin{i}) '''.']);
        end
    end

    
    %check if exist and assign default value if not

    if ~exist('Colors','var')
        Colors = {[0.5 0.3 1], [1 0.5 1], [0.8 0 0.7], [0.1 0.7 0], [0.5 0.2 0.1]};  %substage colors
    end
    if ~exist('newfig','var')
        newfig = 1 ;  %substage colors
    end
    if ~exist('NREMsubstages','var')
        NREMsubstages = 1 ;  %substage colors
    end     
 
% ---------------------------------- Plot ----------------------------------- :   

    % New figure if newfig = true :
    if newfig
        fig = figure ;
        set(fig,'WindowStyle','normal');
        set(gcf,'position',[100,500,1000,150])
    end
    
    % Plot :
    if NREMsubstages % N!, N2, N3, REM, WAKE
        substages_list = {N1,N2,N3,REM,WAKE} ;
        substages_names = {'N1','N2','N3','REM','Wake'} ; 
        legendhandle = [];
        yplot_list = [3 2 1 4 5] ; % order of the different substages on the plot
    else
        % SWS, REM, WAKE
        substages_list = {SWS,REM,WAKE} ;
        substages_names = {'NREM','REM','Wake'} ; 
        legendhandle = [];
        yplot_list = [1 2 3] ; % order of the different substages on the plot
    end
    
    
    for i = 1:length(substages_list)
        s = Start(substages_list{i})/(3600e4);
        e = End(substages_list{i})/(3600e4);
        
        if exist('ZTtime','var') % convert to ZT time if required
            s = s + getfield(Data(ZTtime),{1})/(3600e4) ; 
            e = e + getfield(Data(ZTtime),{1})/(3600e4); 
        end
        
        yplot = yplot_list(i)*0.5 ;
        hold on, c = plot([s,e],[yplot,yplot], 'color', Colors{i}, 'LineWidth', 8) ;
        legendhandle = [legendhandle, c(1)] ;
    end
    ylim([0,(length(substages_list)+1)*0.5]), set(gca,'ytick',[]);
    legend(legendhandle,substages_names, 'Location', 'southoutside', 'Orientation', 'horizontal'); legend boxoff ; 
    
    
end 