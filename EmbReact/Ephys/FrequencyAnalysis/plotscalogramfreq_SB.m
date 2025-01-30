
function plotscalogramfreq_SB(FourierFactor,sigmaT,wt,freq,t,normfreqflag)

% [w,f,coi,OutParams]=cwt_SB(Data(LFPdowns),250,'NumOctaves',8,'VoicesPerOctave',48);
% plotscalogramfreq(OutParams.FourierFactor,OutParams.sigmaT,w,f,OutParams.t,OutParams.normalizedfreq)



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

imagesc(t,log2(freq),(abs(wt)));

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
try
    plot(AX,t,log2(1./coi),'w--','linewidth',2);
end
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
