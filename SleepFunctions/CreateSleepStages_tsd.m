% CreateSleepStages_tsd
% 02.09.2019 KJ
%
%       SleepStages = CreateSleepStages_tsd(Epochs)
%
%%INPUT
%   Epochs:         array of intervalSet (NREM-REM-Wake or N1-N2-N3-REM-Wake) 
%       
%   (optional)
%   binsize:        size of the binfor the tsd 
%   y_value:        y value for each Epoch
%   x_offset:       offset for start time
%
%
%%OUTPUT
% 
%
% SEE
%  MakeIDfunc_Sleepstages PlotSleepStage
%
%


function SleepStages = CreateSleepStages_tsd(Epochs,varargin)


% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'binsize'
            binsize = varargin{i+1};
            if binsize<=0
                error('Incorrect value for property ''binsize''.');
            end
        case 'y_value'
            y_value = varargin{i+1};
        case 'x_offset'
            x_offset = varargin{i+1};
            if length(x_offset)~=1
                error('Incorrect value for property ''x_offset''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('binsize','var')
    binsize = 500; %50ms
end
if ~exist('y_value','var')
    y_value = 1:length(Epochs);
end
if ~exist('x_offset','var')
    x_offset = 0;
end


%record period
nb_epochs = length(Epochs);    
Record_period = Epochs{1};
for ep=2:nb_epochs
    Record_period = or(Record_period, Epochs{ep});
end

%bin
indtime = min(Start(Record_period)):binsize:max(Stop(Record_period));
timeTsd = ts(indtime);
rg = Range(timeTsd);    


%SleepStages
SleepStages = zeros(length(rg),1);
for ep=1:nb_epochs
    idx = ismember(rg, Range(Restrict(timeTsd,Epochs{ep})))==1;
    SleepStages(idx) = y_value(ep);
end


SleepStages = tsd(rg + x_offset, SleepStages);

end



