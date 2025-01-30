%% REPLACE IN TSD function
%
% 11/03/2020 LP
%
% Function : replace values of tsd by NaN / a specified value, when timestamps of tsd belong to
% an intervalSet. (or when do not belong, Cf. varargin)
%
% ----------------- INPUTS ----------------- :
%
%   - tsd_object : tsd 
%   - intervals : intervalSet 
%   - value : value by which tsd values (with timestamps belonging to 'intervals') will be
%   replaced. Can be numerical or NaN. 
%
% -- Optional Parameters -- :
% (as pairs : 'arg_name', arg_value) 
%
%   - 'out' : if =1, replaces values with timestamps OUTSIDE of
%   'intervals'. Default : = 0. 
%
%
% ----------------- OUTPUTS ----------------- :
%
%   - new_tsd : new tsd with replaced values.
%
%
% ----------------- Examples ----------------- :
%
%                    bandpow_tsd_sleep = replaceinTSD(bandpow_tsd,WAKE,NaN)  
%                       # to replace all bandpower values by NaN when not during sleep


function new_tsd = replaceinTSD(tsd_object,intervals,value,varargin)


% ---------------------------------- Check optional parameters ----------------------------------- :

    % Number of arguments :
    if nargin < 3 || mod(length(varargin),2) ~= 0  % At least 3 required arguments, and optional arguments as pairs ('arg_name', arg)  
      error('Incorrect number of parameters.');
    end

    % Parse optional parameter list :
    for i = 1:2:length(varargin)    % for each 'arg_name'
        if ~ischar(varargin{i})     % has to be a character array
            error(['Parameter ' num2str(i+2) ' is not a property.']);
        end
        switch(lower(varargin{i}))
            case 'out'
                out = varargin{i+1}; % assign argument value
                if (out~= 0 & out~=1)
                    error('Error : Optional Argument "out" must be 0 or 1.')
                end
            otherwise
                error(['Unknown property ''' num2str(varargin{i}) '''.']);
        end
    end

    
    %check if exist and assign default value if not
    if ~exist('out','var')
        out=0;
    end


% ---------------------------------- Create New TSD ----------------------------------- :

    times = Range(tsd_object) ;
    
    if out
        times_tochange = find(~belong(intervals,times));
    else
        times_tochange = find(belong(intervals,times));
    end
        
    data = Data(tsd_object) ;
    data(times_tochange) = value ;

    new_tsd = tsd(times,data) ;
end