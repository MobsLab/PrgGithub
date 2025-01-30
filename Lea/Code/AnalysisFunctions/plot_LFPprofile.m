

%% PLOT_LFPPROFILE function :
%
% 31/03/2020 LP
%
% Function : plot the mean LFP around events. 
%
% ----------------- INPUTS ----------------- :
%
%   - ts_ events : ts of events (ex: ts(Start(deltas_PFCx)) ), in 1E-4 s
%   - all_LFP : cell array with tsd of LFP (as many LFPs as wanted)
%   
%
% -- Optional Parameters -- :
% (as pairs : 'arg_name', arg_value) 
%
%   - 'timewindow' : length of total timewindow to be plotted, in ms 
%              Default : timewindow = 1000 (500ms before and 500ms after
%              event)
%   - 'LFPlegend' : cell array with LFP names 
%              Default :  LFPlegend = {'1','2',...}
%
%   - 'LFPcolor' : cell array with colors to plot LFP
%
%   - 'LineWidth' : cell array with Width values to plot LFP
%
%   - 'newfig' : plot in a new figure if =1. 
%               default = 1
%
% ----------------- OUTPUTS ----------------- :
%
%   - no output (plot)
%
%
% ----------------- Example ----------------- :
%
%              plot_LFPprofile(ts(Start(alldeltas_PFCx)),{LFPdeep,LFPsup},
%                                       'LFPlegend',{'LFPdeep','LFP sup'})
%                                                                       


function plot_LFPprofile(ts_events,all_LFP,varargin)


% ---------------------------------- Check optional parameters ----------------------------------- :

    % Number of arguments :
    if nargin < 2 || mod(length(varargin),2) ~= 0  % At least 2 required arguments, and optional arguments as pairs ('arg_name', arg)  
      error('Incorrect number of parameters.');
    end
    
    % Check that LFP is a cell array
    if ~iscell(all_LFP)
        error('Argument "all_LFP" must be a cell array with the LFP signal(s).')
    end    
    
    % Parse optional parameter list :
    for i = 1:2:length(varargin)    % for each 'arg_name'
        if ~ischar(varargin{i})     % has to be a character array
            error(['Parameter ' num2str(i+2) ' is not a property.']);
        end
        switch (varargin{i})
            case 'timewindow'
                timewindow = varargin{i+1}; % assign argument value
            case 'LFPlegend'
                LFPlegend = varargin{i+1};
            case 'LFPcolor'
                LFPcolor = varargin{i+1};
            case 'LineWidth'
                LineWidth_toplot = varargin{i+1};
            case 'newfig'
                newfig = varargin{i+1};
                if newfig ~= 0 & newfig ~= 1
                    error('Incorrect value for "newfig" : must be 0 or 1.')
                end    
            otherwise
                error(['Unknown property ''' num2str(varargin{i}) '''.']);
        end
    end

    
    %check if exist and assign default value if not
    if ~exist('timewindow','var')
        timewindow = 1000 ;
    end
    if ~exist('LFPlegend','var')
        for i=1:length(all_LFP), LFPlegend{i} = num2str(i); end
    end
     if ~exist('newfig','var')
        newfig = 1 ;
     end
    if ~exist('LineWidth_toplot','var')
        for i=1:length(all_LFP), LineWidth_toplot{i} = 1; end
    end

% ---------------------------------- Plot ----------------------------------- :
    
    % LFP_colors = {[0.25 0.7 0.9],[0 0.25 0.65]} ;

    if newfig
        figure,
    end
    
    hold on,
    
    % Plot each mean LFP around events : 
    for i = 1:length(all_LFP)
        [m,s,t]=mETAverage(Range(ts_events),Range(all_LFP{i}),Data(all_LFP{i}),1,timewindow);
        
        try 
            plot(t,m,'Color',LFPcolor{i},'LineWidth',LineWidth_toplot{i}) %if specified color
        catch
            plot(t,m,'LineWidth',LineWidth_toplot{i}) % if no specified color
        end    
    end
    
    legend(LFPlegend,'Orientation','horizontal','Location','northoutside'), xlabel('Time around event (ms)'), ylabel('Mean LFP signal') ;
    
end