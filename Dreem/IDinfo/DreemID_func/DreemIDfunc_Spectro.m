% DreemIDfunc_Spectro
% 27.03.2018 KJ
%
%   [Specg, t_spg, f_spg, swa_power] = DreemIDfunc_Spectro(filespectro)
%
%%INPUT
% 
% 
%%OUTPUT
% 
%
% SEE
%   DreemIDStimImpact DreemIDfunc_Stimcurves DreemIDfunc_SlowDynamics
%
%


function [Specg, t_spg, f_spg, swa_power] = DreemIDfunc_Spectro(filespectro, varargin)

if nargin < 1 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'filereference'
            filereference = varargin{i+1};
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end


%% load spectrogram
load(filespectro,'Spectro');
Specg = Spectro{1};
t_spg = Spectro{2};
f_spg = Spectro{3};


%% SWA
%params
smoothing = 400;
freqSWA = [0.5 4];
th=1.4;

%power
Sp = Specg(:, f_spg>=freqSWA(1) & f_spg<=freqSWA(2));
spectrum = mean(Sp,2);

%clean
threshold = exp(mean(log(spectrum)) * th);
spectrum(spectrum>threshold) = 1;

swa_power = smooth(spectrum,smoothing);


end












