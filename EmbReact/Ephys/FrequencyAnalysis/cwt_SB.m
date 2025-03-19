function [wt,p,coi,OutParams] = cwt_SB(x,varargin)
%CWT Continuous 1-D wavelet transform
% WT = CWT(X) returns the continuous wavelet transform (CWT) of the
% real-valued signal X. X must have at least 4 samples. The CWT is obtained
% using the analytic Morse wavelet with the symmetry parameter (gamma)
% equal to 3 and the time-bandwidth product equal to 60. The CWT uses 10
% voices per octave. The minimum and maximum scales are determined
% automatically based on the wavelet's energy spread in frequency and time.
%
% WT = CWT(X,WAVNAME) uses the wavelet corresponding to the string
% WAVNAME. Valid options for WAVNAME are: 'morse', 'amor', or
% 'bump'. If you do not specify WAVNAME, WAVNAME defaults
% to 'morse'. 
%
% [WT,F] = CWT(...,Fs) specifies the sampling frequency, Fs, in
% hertz as a positive scalar and returns the scale-to-frequency conversions
% in hertz, F. If you do not specify a sampling frequency, CWT returns F in
% cycles/sample.
%
% [WT,PERIOD] = CWT(...,Ts) uses the positive scalar <a href="matlab:help duration">duration</a>, Ts, 
% to compute the scale-to-period conversions, PERIOD. PERIOD is an array of 
% durations with the same Format property as Ts.
%
% [WT,F,COI] = CWT(...) returns the cone of influence in
% cycles/sample for the wavelet transform. If you specify a sampling
% frequency, Fs, in hertz, the cone of influence is returned in hertz.
%
% [WT,PERIOD,COI] = CWT(...,Ts) returns the cone of influence
% in periods for the wavelet transform. Ts is a positive <a href="matlab:help duration">duration</a>. 
% COI is an array of durations with same Format property as Ts.
%
% [...] = CWT(...,'ExtendSignal',EXTENDFLAG) specifies whether to
% symmetrically extend the signal by reflection to mitigate boundary
% effects. EXTENDFLAG can be one of the following options [ {true} |
% false]. If unspecified, EXTENDFLAG defaults to true.
%
% [...] = CWT(...,'VoicesPerOctave',NV) discretizes the scales using NV
% voices per octave. NV is an even integer between 4 and 48. The minimum
% and maximum scales are determined automatically for each wavelet based on
% the wavelet's energy spread in frequency and time. If unspecified, NV
% defaults to 10.
%
% [...] = CWT(...,'NumOctaves',NO) uses the positive integer scalar NO as
% the number of octaves. NO cannot exceed floor(log2(numel(X)))-1.
% Specifying NO overrides the automatic determination of the maximum scale.
%
% [...] = CWT(...,'TimeBandwidth',TB) specifies the time-bandwidth
% parameter of the Morse wavelet with the symmetry parameter fixed at 3. TB
% is a positive number strictly greater than 3 and less than or equal to
% 120. The larger the time-bandwidth parameter, the more spread out the
% wavelet is in time and narrower the wavelet is in frequency. The standard
% deviation of the Morse wavelet in time is approximately sqrt(TB/2). The
% standard deviation in frequency is approximately 1/2*sqrt(2/TB). You
% cannot specify both the 'TimeBandwidth' and 'WaveletParameter' name-value
% pairs.
%
% [...] = CWT(...,'WaveletParameters',PARAM) uses the parameters PARAM to
% specify the Morse wavelet. PARAM is a two-element vector. The first
% element is the symmetry parameter (gamma), which must be greater than or
% equal to 1. The second element is the time-bandwidth parameter, which
% must be strictly greater than gamma. The ratio of the time-bandwidth
% parameter to gamma cannot exceed 40. When gamma is equal to 3, the Morse
% wavelet is perfectly symmetric in the frequency domain. The skewness is
% equal to 0. Values of gamma greater than 3 result in positive skewness,
% while values of gamma less than 3 result in negative skewness.
%
% CWT(...) with no output arguments plots the absolute value of the
% continuous wavelet transform as a function of time and frequency. The
% cone of influence showing where edge effects become significant is also
% plotted. If you do not specify a sampling frequency or interval, the
% frequencies are plotted in cycles/sample. If you supply a sampling
% frequency, Fs, the scalogram is plotted in hertz. If you supply a
% sampling interval using a duration, the absolute value of the
% continuous wavelet transform is plotted as a function of time and
% periods. The frequency or period axis in the scalogram uses a log2 scale.
%
%   % Example 1: Plot the CWT of the Kobe earthquake data using the default
%   %   Morse wavelet. Specify the sampling frequency to be 1 Hz.
%   load kobe;
%   plot((1:numel(kobe))./60,kobe); 
%   xlabel('mins'); ylabel('nm/s^2');
%   grid on;
%   title('Kobe Earthquake Data');
%   figure;
%   cwt(kobe,1)
%
%   % Example 2: Create two sine waves with frequencies of 32 and 64 Hz.
%   %   The data is sampled at 1000 Hz. The two sine waves have disjoint
%   %   support in time. Add white Gaussian noise with a standard deviation
%   %   of 0.05. Obtain and plot the CWT using a Morse wavelet. 
%   Fs = 1e3;
%   t = 0:1/Fs:1;
%   x = cos(2*pi*32*t).*(t>=0.1 & t<0.3)+sin(2*pi*64*t).*(t>0.7);
%   wgnNoise = 0.05*randn(size(t));
%   x = x+wgnNoise;
%   cwt(x,1000)
%
% See also ICWT


% pass outputs to legacy CWT

if iscell(x) && isnumeric(varargin{1}) && isnumeric(varargin{2})
    scales = varargin{1};
    PSI = varargin{2};
    wt = wavelet.internal.cwt(x,scales,PSI);
    return;
end


if (numel(varargin)>=2) && isnumeric(varargin{1}) && ...
        (ischar(varargin{2}) || iscell(varargin{2}))
    
    wavinfo = cellstr(wavemngr('tfsn'));
    
    
    
    if iscell(varargin{2})
        WAV = varargin{2};
        wavscales = varargin{1};
        varargin(1:2) = [];
        switch nargout
            
            case {0,1}
                wt = wavelet.internal.cwt(x,wavscales,WAV,varargin{:});
                return;
            case 2
                
                [wt,p] = wavelet.internal.cwt(x,wavscales,WAV,varargin{:});
                return;
                
            case 3
                
                [wt,p,coi] = wavelet.internal.cwt(x,wavscales,WAV,varargin{:});
                return;
            otherwise
                error(message('Wavelet:cwt:UnsupportedLegacy'));
        end
    end
    
    if ischar(varargin{2}) 
        
        
        WAVnoNum = deblank(regexprep(varargin{2},'\d',''));
        pat = '-';
        WAVnoPat = deblank(regexprep(WAVnoNum,pat,''));
        pat = '\.';
        tfdot = regexp(WAVnoPat,pat);
        if any(tfdot)
            WAVnoPat(tfdot) = [];
        end
        
        if any(strcmp(WAVnoPat,wavinfo))
            WAV = varargin{2};
            wavscales = varargin{1};
            varargin(1:2) = [];
            switch nargout
                
                case {0,1}
                    wt = wavelet.internal.cwt(x,wavscales,WAV,varargin{:});
                    return;
                case 2
                    
                    [wt,p] = wavelet.internal.cwt(x,wavscales,WAV,varargin{:});
                    return;
                    
                case 3
                    
                    [wt,p,coi] = wavelet.internal.cwt(x,wavscales,WAV,varargin{:});
                    return;
                otherwise
                    error(message('Wavelet:cwt:UnsupportedLegacy'));
            end
            
            
        end
        
    end
end



%Check nargin and nargout cwt
narginchk(1,14);
nargoutchk(0,4);
validateattributes(x,{'double'},{'vector','finite','nonempty','real'});
% Detrend signal
x = detrend(x,0);
x = x(:)';

if numel(x)<4
    error(message('Wavelet:synchrosqueezed:NumInputSamples'));
end

% Record original signal length
Norig = numel(x);
% Validate attributes on signal. May extend to accept complex
params = parseinputs(Norig,varargin{:});
wavname = params.WAV;
ga = params.ga;
be = params.be;
n = Norig;
nv = params.nv;
ds = 1/nv;


% If sampling frequency is specified, dt = 1/fs
if (isempty(params.fs) && isempty(params.Ts))
    % The default sampling interval is 1 for normalized frequency
    dt = params.dt;
    fs = 1;
elseif (~isempty(params.fs) && isempty(params.Ts))
    % Accept the sampling frequency in hertz
    fs = params.fs;
    dt = 1/fs;
elseif (isempty(params.fs) && ~isempty(params.Ts))
    % Get the dt and Units from the duration object
    [dt,Units] = getDurationandUnits(params.Ts);
    fs = 1/dt;
end



if params.pad
    padvalue = floor(Norig/2);
    x =[fliplr(x(1:padvalue)) x x(end:-1:end-padvalue+1)];
    % Length of data plus any extension
    n = length(x);
end


% Define Scales
if isempty(params.no)
    [~,~,wavscales] = getDefaultScales(wavname,Norig,ga,be,ds);
    NbSc = length(wavscales);
  
elseif ~isempty(params.no)
    s0 = getDefaultScales(wavname,Norig,ga,be,ds);
    numoct = params.no;
    a0 = 2^ds;
    wavscales = s0*a0.^(0:numoct*params.nv);
    NbSc = length(wavscales);
    
    
end

% Frequency vector sampling the Fourier transform of the wavelet
omega = (1:fix(n/2));
omega = omega.*(2*pi)/n;
omega = [0, omega, -omega(fix((n-1)/2):-1:1)];


OutParams=params;

% Compute FFT of the (padded) time series
f = fft(x);

% Loop through all scales and compute transform
if strcmpi(wavname,'morse')
    
    [psift,freq] = wavelet.internal.morsewavft(omega,wavscales,ga,be);
    FourierFactor = (2*pi)/wavelet.internal.morsepeakfreq(ga,be);
    % Find time standard deviation of Morse wavelet
    [~,~,~,sigmaT,~] = wavelet.internal.morseproperties(ga,be);
    coiScalar = FourierFactor/sigmaT;
else
    [psift,freq]  = wavelet.internal.waveft(wavname,omega,wavscales);
end

if strcmpi(wavname,'amor')
    FourierFactor = (2*pi)/6;
    sigmaT = 1/sqrt(2);
    coiScalar = FourierFactor/sigmaT;
elseif strcmpi(wavname,'bump')
    FourierFactor = (2*pi)/5;
    %Result for bump wavelet obtained by integration
    sigmaT = 2.9268;
    coiScalar = FourierFactor/sigmaT;
end



cwtcfs = ifft(repmat(f,NbSc,1).*psift,[],2);
if params.pad
    cfs = cwtcfs(:,padvalue+1:padvalue+Norig);
else
    cfs = cwtcfs;
end
freq = (freq.*fs)';
coitmp = coiScalar*dt*[1E-5,1:((Norig+1)/2-1),fliplr((1:(Norig/2-1))),1E-5];
coitmp = coitmp(:);
t = 0:dt:Norig*dt-dt;

OutParams=params;
OutParams.FourierFactor=FourierFactor;
OutParams.sigmaT=sigmaT;
OutParams.coiScalar=coiScalar;
OutParams.t=t;

if nargout == 0 && ~isempty(params.Ts)
    plotscalogramperiod(cfs,freq,t,coitmp,Units)
elseif nargout == 0 && (~isempty(params.fs) || params.normalizedfreq)
    plotscalogramfreq(FourierFactor,sigmaT,cfs,freq,t,params.normalizedfreq)
    
elseif nargout>0
    wt = cfs;
    p = freq;
    coi = 1./coitmp;
    if ~isempty(params.Ts)
        p = 1./freq;
        % Create period duration object output with correct format
        p = createDurationObject(p,Units);
        p.Format = params.Ts.Format;
        % Create COI duration object output with correct format
        coi = createDurationObject(coitmp,Units);
        coi.Format = params.Ts.Format;
    end
    
    
    
end

%-------------------------------------------------------------------------
function params = parseinputs(n,varargin)
% Set defaults.
params.fs = [];
params.dt = 1;
params.Ts = [];
params.TimeFormat = [];
params.sampinterval = false;
params.engunitflag = true;
params.WAV = 'morse';
params.ga = 3;
params.be = 20;
params.nv = 10;
params.no = [];
params.pad = true;
params.normalizedfreq = true;

% Error out if there are any calendar duration objects
tfcalendarDuration = cellfun(@iscalendarduration,varargin);
if any(tfcalendarDuration)
    error(message('Wavelet:FunctionInput:CalendarDurationSupport'));
end

tfsampinterval = cellfun(@isduration,varargin);

if (any(tfsampinterval) && nnz(tfsampinterval) == 1)
    params.sampinterval = true;
    params.Ts = varargin{tfsampinterval>0};
    if (numel(params.Ts) ~= 1 ) || params.Ts <= 0 || isempty(params.Ts)
        error(message('Wavelet:FunctionInput:PositiveScalarDuration'));
    end
    
    params.engunitflag = false;
    params.normalizedfreq = false;
    varargin(tfsampinterval) = [];
end

%Look for Name-Value pairs
numvoices = find(strncmpi('voicesperoctave',varargin,1));

if any(numvoices)
    params.nv = varargin{numvoices+1};
    %validate the value is numeric, even and between 4 and 48
    validateattributes(params.nv,{'numeric'},{'positive','scalar',...
        'even','>=',4,'<=',48},'cwt','VoicesPerOctave');
    varargin(numvoices:numvoices+1) = [];
    if isempty(varargin)
        return;
    end
end

numoctaves = find(strncmpi('numoctaves',varargin,1));
if any(numoctaves)
    params.no = varargin{numoctaves+1};
    %validate the value is positive integer between 1 and floor(log2(N))-1
    maxnumoct = floor(log2(n))-1;
    validateattributes(params.no,{'numeric'},{'positive','scalar',...
        'integer','>=',1, '<=',maxnumoct},'cwt','NumOctaves');
    varargin(numoctaves:numoctaves+1) = [];
    if isempty(varargin)
        return;
    end
end



morseparams = find(strncmpi('waveletparameters',varargin,1));
timeBandwidth = find(strncmpi('timebandwidth',varargin,1));
if any(morseparams) && any(timeBandwidth)
    error(message('Wavelet:cwt:paramsTB'));
end

if (any(morseparams) && (nnz(morseparams) == 1))
    morseParameter = varargin{morseparams+1};
    validateattributes(morseParameter,{'numeric'},{'numel',2,...
        'positive','nonempty'},'cwt','WaveletParameters');
    
    params.ga = morseParameter(1);
    tb = morseParameter(2);
    validateattributes(params.ga,{'numeric'},{'scalar',...
        'positive','>=',1},'cwt','gamma');
    validateattributes(tb,{'numeric'},{'scalar',...
        '>',params.ga},'cwt','TimeBandwidth');
    % beta must be greater than 1
    params.be = tb/params.ga;
    if params.be>40
        error(message('Wavelet:cwt:TBupperbound'));
    end
    varargin(morseparams:morseparams+1) = [];
    
end


if (any(timeBandwidth) && (nnz(timeBandwidth) == 1))
    params.timebandwidth = varargin{timeBandwidth+1};
    validateattributes(params.timebandwidth,{'numeric'},{'scalar',...
        'positive','>' 3,'<=',120},'cwt','TimeBandwidth');
    params.ga = 3;
    params.be = params.timebandwidth/params.ga;
    varargin(timeBandwidth:timeBandwidth+1) = [];
end




extendsignal = find(strncmpi('extendsignal',varargin,1));

if any(extendsignal)
    params.pad = varargin{extendsignal+1};
    
    if ~isequal(params.pad,logical(params.pad))
        error(message('Wavelet:FunctionInput:Logical'));
    end
    varargin(extendsignal:extendsignal+1) = [];
    if isempty(varargin)
        return;
    end
end


% Only scalar left must be sampling frequency or sampling interval
% Only scalar left must be sampling frequency
tfsampfreq = cellfun(@(x) (isscalar(x) && isnumeric(x)),varargin);

if (any(tfsampfreq) && (nnz(tfsampfreq) == 1) && isempty(params.Ts))
    params.fs = varargin{tfsampfreq};
    validateattributes(params.fs,{'numeric'},{'positive'},'cwt','Fs');
    params.normalizedfreq = false;
    params.engunits = true;
elseif any(tfsampfreq) && ~isempty(params.Ts)
    error(message('Wavelet:FunctionInput:SamplingIntervalOrDuration'));
elseif nnz(tfsampfreq)>1
    error(message('Wavelet:FunctionInput:Invalid_ScalNum'));
end

%Only char variable left must be wavelet
tfwav = cellfun(@ischar,varargin);
if (nnz(tfwav) == 1)
    params.WAV = varargin{tfwav>0};
    params.WAV = ...
        validatestring(params.WAV,{'morse','bump','amor'},'cwt','WAVNAME');
elseif nnz(tfwav)>1
    error(message('Wavelet:FunctionInput:InvalidChar'));
    
end

if any(strcmp(params.WAV,{'bump','amor'})) && (any(morseparams) || any(timeBandwidth))
    error(message('Wavelet:cwt:InvalidParamsWavelet'));
end








%----------------------------------------------------------------------
function [s0,ds,scales] = getDefaultScales(WAV,nbSamp,ga,be,ds)

wname = WAV;
nv = 1/ds;


switch wname
    case 'amor'
        
        % Determine smallest useful scale for wavelet
        hi = wavelet.internal.wavhighfreq(wname,[],[]);
        s0 = min(2,hi/pi);
        % Determine longest useful scale for wavelet
        maxScale = floor(nbSamp/(sqrt(2)*s0));
        if maxScale <= 1
            maxScale = floor(nbSamp/2);
        end
        maxScale = floor(nv*log2(maxScale));
        a0 = 2^ds;
        %maxScale = nv*floor(log2(2^maxScale/s0));
        scales = s0*a0.^(0:maxScale);             
        
        
    case 'bump'
        
        % Determine smallest useful scale for wavelet
        hi = wavelet.internal.wavhighfreq(wname,[],[]);
        s0 = min(2,hi/pi);
        % Time standard deviation of bump wavelet.
        % Obtained by trapezoidal integration
        sigmaT = 2.9268;
        maxScale = floor(nbSamp/(2*sigmaT*s0));
        if maxScale <= 1
            maxScale = floor(nbSamp/2);
        end
        maxScale = floor(nv*log2(maxScale));
        a0 = 2^ds;
        scales = s0*a0.^(0:maxScale);        
        
        
    case 'morse'
        
        hi = wavelet.internal.wavhighfreq(wname,ga,be);
        s0 = min(2,hi/pi);
        [~,~,~,sigmaT,~] = wavelet.internal.morseproperties(ga,be);
        maxScale = floor(nbSamp/(2*sigmaT*s0));
        if maxScale <= 1
            maxScale = floor(nbSamp/2);
        end
        maxScale = floor(nv*log2(maxScale));
        a0 = 2^ds;
        scales = s0*a0.^(0:maxScale);
        
        
        
        
        
        
end

%-----------------------------------------------------------------------

function plotscalogramperiod(wt,freq,t,coitmp,Units)

period = (1./freq);
switch Units
    case 'years'
        Yticks = 2.^(round(log2(min(period))):round(log2(max(period))));
        logYticks = log2(Yticks(:));
        YtickLabels = num2str(sprintf('%g\n',Yticks));
    case 'days'
        Yticks = 2.^(round(log2(min(period))):round(log2(max(period))));
        logYticks = log2(Yticks(:));
        YtickLabels = num2str(sprintf('%g\n',Yticks));
    case 'hrs'
        Yticks = 2.^(round(log2(min(period))):round(log2(max(period))));
        logYticks = log2(Yticks(:));
        YtickLabels = num2str(sprintf('%g\n',Yticks));
    case 'mins'
        Yticks = 2.^(round(log2(min(period)),1):round(log2(max(period)),1));
        logYticks = log2(Yticks(:));
        YtickLabels = num2str(sprintf('%g\n',Yticks));
    case 'secs'
        Yticks = 2.^(round(log2(min(period)),2):round(log2(max(period)),2));
        logYticks = log2(Yticks(:));
        YtickLabels = num2str(sprintf('%g\n',Yticks));
end
%

imagesc(t,log2(period),abs(wt));

AX = gca;
AX.YLim = log2([min(period), max(period)]);
AX.YTick = logYticks;
AX.YDir = 'normal';
set(AX,'YLim',log2([min(period),max(period)]), ...
    'layer','top', ...
    'YTick',logYticks, ...
    'YTickLabel',YtickLabels, ...
    'layer','top')
ylabel([getString(message('Wavelet:wcoherence:Period')) ' (' Units ') ']);
xlabel([getString(message('Wavelet:wcoherence:Time'))  ' (' Units ')']);
title(getString(message('Wavelet:cwt:ScalogramTitle')));
hold(AX,'on');
hcol = colorbar;
hcol.Label.String = getString(message('Wavelet:cwt:Magnitude'));
plot(AX,t,log2(coitmp),'w--','linewidth',2);
hold(AX,'off');



function plotscalogramfreq(FourierFactor,sigmaT,wt,freq,t,normfreqflag)



if normfreqflag
    frequnitstrs = wgetfrequnitstrs;
    freqlbl = frequnitstrs{1};
    coifactorfreq = 1;
    
elseif ~normfreqflag
    [freq,eng_exp,uf] = wengunits(freq,'unicode');
    coifactorfreq = eng_exp;
    freqlbl = wgetfreqlbl([uf 'Hz']);
    
end

Yticks = 2.^(round(log2(min(freq))):round(log2(max(freq))));


if normfreqflag
    ut = 'Samples';
    dt = 1;
    coifactortime = 1;
else
    
    [t,eng_exp,ut] = wengunits(t,'unicode','time');
    coifactortime = eng_exp;
    dt = mean(diff(t));
    
end


N = size(wt,2);

% We have to recompute the cone of influence for whatever scaling
% is done in time and frequency by wengunits
%dt = dt*coifactortime;
FourierFactor = FourierFactor/coifactorfreq;
sigmaT = sigmaT*coifactortime;
coiScalar = FourierFactor/sigmaT;

coi = coiScalar*dt*[1E-5,1:((N+1)/2-1),fliplr((1:(N/2-1))),1E-5];

imagesc(t,log2(freq),abs(wt));

AX = gca;
AX.YLim = log2([min(freq), max(freq)]);
AX.YTick = log2(Yticks);
AX.YDir = 'normal';
set(AX,'YLim',log2([min(freq),max(freq)]), ...
    'layer','top', ...
    'YTick',log2(Yticks(:)), ...
    'YTickLabel',num2str(sprintf('%g\n',Yticks)), ...
    'layer','top')
ylabel(freqlbl)
xlbl = [getString(message('Wavelet:getfrequnitstrs:Time')) ' (' ut ')'];
xlabel(xlbl);
title(getString(message('Wavelet:cwt:ScalogramTitle')));
hcol = colorbar;
hcol.Label.String = 'Magnitude';
hold(AX,'on');
plot(AX,t,log2(1./coi),'w--','linewidth',2);
hold(AX,'off');




function [new_x,eng_exp,units_x] = wengunits(x, arg1, arg2)
% ENGUNITS Convert scalar input to engineering units.
%   [Y,E,U]= WENGUNITS(X) converts input value X into a new value Y,
%   with associated scale factor E, such that Y = X * E.  The
%   engineering unit prefix is returned as a character in U.  If X
%   is a matrix the largest value will be used to determine the scale.
%
%   [...]= WENGUNITS(X,'latex') returns engineering unit prefix
%   U in Latex format where appropriate, for use with the TEXT
%   command.  In particular, U='u' for micro, whereas U='\mu'
%   if the Latex flag is passed.
%
%   [...]= WENGUNITS(X,'unicode') returns engineering unit prefix U using
%   unicode where appropriate.  In particular, U='u' for micro, whereas
%   U=char(956) if the unicode flag is passed.
%
%   [...]= WENGUNITS(...,'time') will cause conversion from
%   seconds to mins/hrs/days/etc when appropriate, and the new
%   units in U.
%
%   EXAMPLE:
%   [y,e,u] = wengunits(1000);
%
%   See also CONVERT2ENGSTRS.

%   Copyright 1988-2014 The MathWorks, Inc.

if nargin==1
    % General engineering units conversion:
    [new_x, eng_exp, units_x] = getEngPrefix(x);
elseif nargin==2
    if strcmpi(arg1,'time')
        [new_x, eng_exp, units_x] = getTimeUnits(x);
    else
        [new_x, eng_exp, units_x] = getEngPrefix(x,arg1);
    end
else %nargin==3
    if strcmpi(arg2,'time')
        [new_x, eng_exp, units_x] = getTimeUnits(x,arg1);
    else
        [new_x, eng_exp, units_x] = getEngPrefix(x,arg1);
    end
end

%--------------------------------------------------------------
function [new_x, eng_exp, units_x] = getTimeUnits(x, latex)
% getTimeUnits Return new time-domain units from a seconds-based input

time_units = {'secs','mins','hrs','days','years'};
time_scale = [1,60,3600,86400,31536000];

% Use max to find the largest value to support matrices
i = find(max(x(:))>=time_scale, 1, 'last' );

if isempty(i),
    % No conversion to a higher unit - use general engineering prefix:
    if nargin==1
        [new_x,eng_exp,units_x] = getEngPrefix(x);
    else
        [new_x,eng_exp,units_x] = getEngPrefix(x, latex);
    end
    if eng_exp == 1,
        units_x = 'secs';
    else
        units_x = [units_x 's'];
    end
else
    new_x   = x./time_scale(i);
    eng_exp = 1./time_scale(i);
    units_x = time_units{i};
end





% --------------------------------------------------------------
function [new_x, eng_exp, units_x] = getEngPrefix(x, latex)
% getEngPrefix Return prefix for appropriate engineering units

eng_units = 'yzafpnum kMGTPEZY';
units_offset = 9; %find(eng_units==' ');
units_len = 17; %length(eng_units);
mu_offset = 7; %find(eng_units=='u');

% Normalize input such that
%    x = norm_x * 10^norm_exp
norm_exp = max(max(floor(log10(abs(x(x~=0)))))); % normalized exponent
if isempty(norm_exp)
    norm_exp = 0;
end

% Round to the nearest multiple of 3:
eng_exp    = 3.*floor(norm_exp./3);
scale_mant = x .* 10.^(-eng_exp);

% Select appropriate engineering units:
i = eng_exp./3 + units_offset;

% Update this section for vector inputs, if they
% become a required part of the spec:
%
if isnan(i) || i<1 || i>units_len || i==units_offset
    % Out of range or no offset required - return input unchanged:
    new_x   = x;
    units_x = '';
    eng_exp = 0;
else
    new_x = scale_mant;
    if nargin<2 || i~= mu_offset
        units_x = eng_units(i);
    elseif strcmp(latex,'unicode')
        units_x = char(956);
    else % latex
        units_x = '\mu';
    end
end

% Convert exponent to proper power of 10 for return:
eng_exp = 10 .^ (-eng_exp);




% [EOF]
function xlbl = wgetfreqlbl(xunits)
%WGETFREQLBL Returns a label for the frequency axis.

%   Author(s): J. Schickler
%   Copyright 1988-2002 The MathWorks, Inc.

options = wgetfrequnitstrs;

xlbl = options{1};
for i = length(options):-1:1,
    if strfind(options{i}, xunits),
        xlbl = options{i};
    end
end

% [EOF]

function frequnits = wgetfrequnitstrs(menuflag)
%WGETFREQUNITSTRS Return a cell array of frequency units strings.
%
%   STRS = WGETFREQUNITS returns a cell array of standard frequency units 
%   strings.

%   STRS = WGETFREQUNITS(MENUFLAG) returns a cell array of frequency units
%   with the "Normalized Frequency" string for use in a uimenu.

%   Author(s): P. Costa
%   Copyright 1988-2002 The MathWorks, Inc.

frequnits = {[getString(message('Wavelet:getfrequnitstrs:NormalizedFrequency')) '  (cycles/sample)'],...
            [getString(message('Wavelet:getfrequnitstrs:Frequency')) ' (Hz)'],...
            [getString(message('Wavelet:getfrequnitstrs:Frequency')) ' (kHz)'],...
            [getString(message('Wavelet:getfrequnitstrs:Frequency')) ' (MHz)'],...
            [getString(message('Wavelet:getfrequnitstrs:Frequency')) ' (GHz)'],...
            [getString(message('Wavelet:getfrequnitstrs:Frequency')) ' (THz)'],...
            [getString(message('Wavelet:getfrequnitstrs:Frequency')) ' (PHz)'],...
            [getString(message('Wavelet:getfrequnitstrs:Frequency')) ' (EHz)'],...
            [getString(message('Wavelet:getfrequnitstrs:Frequency')) ' (ZHz)'],...
            [getString(message('Wavelet:getfrequnitstrs:Frequency')) ' (YHz)'],...
            [getString(message('Wavelet:getfrequnitstrs:Frequency')) ' (yHz)'],...
            [getString(message('Wavelet:getfrequnitstrs:Frequency')) ' (zHz)'],...
            [getString(message('Wavelet:getfrequnitstrs:Frequency')) ' (aHz)'],...
            [getString(message('Wavelet:getfrequnitstrs:Frequency')) ' (fHz)'],...
            [getString(message('Wavelet:getfrequnitstrs:Frequency')) ' (pHz)'],...
            [getString(message('Wavelet:getfrequnitstrs:Frequency')) ' (nHz)'],...
            [getString(message('Wavelet:getfrequnitstrs:Frequency')) ' (\muHz)'],...
            [getString(message('Wavelet:getfrequnitstrs:Frequency')) ' (' char(956) 'Hz)'],...
            [getString(message('Wavelet:getfrequnitstrs:Frequency')) ' (mHz)']};

% Return the proper version of the Normalized Frequency string
% for the X-axis label or menu item.
if nargin == 1,
    frequnits{1} = getString(message('Wavelet:getfrequnitstrs:NormalizedFrequency'));
end

% [EOF]
