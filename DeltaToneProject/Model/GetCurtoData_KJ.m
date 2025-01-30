%%GetCurtoData_KJ
% 01.04.2018 KJ
%
% Get v, w and dv/dt from MUA 
%
% [V, W, Vdt] = GetCurtoData_KJ(MUA,varargin)
%
% INPUT:
% - MUA                       = tsd of the MUA
%                                 
% - hannwin_len (optional)    = frequency range for the spectral power (denominator)                           
%                               (default 16 ms)
% - tau (optional)            = frequency range for the spectral power (denominator)                           
%                               (default 100 ms)
%
%
% OUTPUT:
% - V                = tsd - excitation or smoothed MUA
% - W                = tsd - adaptation
% - Vdt              = tsd - time derivation of V 
%
%   see 
%       
%


function [V, W, Vdt] = GetCurtoData_KJ(MUA,varargin)


%% CHECK INPUTS

if nargin < 1 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

%% Initiation
% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'smoothing'
            smoothing = varargin{i+1};
            if smoothing<=0
                error('Incorrect value for property ''smoothing''.');
            end
        case 'tau'
            tau = varargin{i+1};
            if tau<=0
                error('Incorrect value for property ''tau''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('smoothing','var')
    smoothing = 6;
end
if ~exist('tau','var')
    tau = 100;
end


tau = tau *10; % in ts
dt = median(diff(Range(MUA)));


%% V smoothed MUA

%Smooth
v_data = Smooth(Data(MUA), smoothing);
v_data = v_data / (2*max(v_data));


%% W adaptation
nb_data = length(v_data);
w_data = zeros(nb_data,1);
for i=1:nb_data-1
    w = w_data(i);
    v = v_data(i);
    
    w_data(i+1) = w + ((v-w)/tau) * dt;
end


%% Vdt time derivative
v_deriv = [0 ; diff(v_data)/dt];


%% tsd
V   = tsd(Range(MUA), v_data);
W   = tsd(Range(MUA), w_data);
Vdt = tsd(Range(MUA), v_deriv);


end





