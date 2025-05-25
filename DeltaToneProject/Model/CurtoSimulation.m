%%CurtoSimulation
% 01.04.2016 KJ
%
% Get v, w and dv/dt from MUA 
%
% [v_data, w_data] = CurtoSimulation
%
% INPUT:
% - a1, a2, a3, I, b       = parameters
%
%
% OUTPUT:
% - v_data                = tsd - excitation or smoothed MUA
% - w_data                = tsd - adaptation
%
%
% EXAMPLE
%   model_params.a1=-0.0271; model_params.a2=0.394; model_params.a3=-1; model_params.I=0.00217; model_params.b=-0.0374;
%   CurtoSimulation(model_params)
%   
%   model_params.a1=-0.0271; model_params.a2=0.394; model_params.a3=-0.9; model_params.I=0.00017; model_params.b=-0.0374;
%   CurtoSimulation(model_params)
%
%   model_params.a1=0; model_params.a2=0.4; model_params.a3=-1; model_params.I=0.00019; model_params.b=-0.05;
%   CurtoSimulation(model_params)
% 
% 
%   see 
%       CurtoModelTest GetCurtoData_KJ      
%



function [v_data, w_data] = CurtoSimulation(model_params, varargin)

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
        case 'stim_params'
            stim_params = varargin{i+1};
            if isstruct(stim_params)
                error('Incorrect value for property ''stim_params''.');
            end
        case 'nb_data'
            nb_data = varargin{i+1};
            if nb_data<=0
                error('Incorrect value for property ''nb_data''.');
            end
        case 'tau'
            tau = varargin{i+1};
            if tau<=0
                error('Incorrect value for property ''tau''.');
            end
        case 'dt'
            dt = varargin{i+1};
            if dt<=0
                error('Incorrect value for property ''dt''.');
            end
        case 'toplot'
            toPlot = varargin{i+1};
            if toPlot~=0 && toPlot~=1
                error('Incorrect value for property ''toPlot''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('nb_data','var')
    nb_data = 3500;
end
if ~exist('tau','var')
    tau = 100;
end
if ~exist('dt','var')
    dt = 0.8;
end
if ~exist('toPlot','var')
    toPlot = 1;
end

%stim params
if ~exist('stim_params','var')
    stim_params=cell(0);
end
if ~isfield('stim_params','alpha')
    stim_params.alpha=0.0036;
end
if ~isfield('stim_params','beta')
    stim_params.beta=5;
end
if ~isfield('stim_params','t0')
    stim_params.t0=10;
end


%in ts
tau = tau*10;
dt = dt*10;

%model_params (a1, a2, a3, I, b)
a1 = model_params.a1;
a2 = model_params.a2;
a3 = model_params.a3;
I  = model_params.I;
b  = model_params.b;

%stim_params (alpha, t0, beta)
alpha = stim_params.alpha;
beta = stim_params.beta;
t0 = stim_params.t0;


%% simulation

%epsilon series
epsilon_list = zeros(1,nb_data);
for i=1:nb_data
    epsilon_list(i) = lognrnd(0.05,1);
end
epsilon_list = epsilon_list / 654;

v_data = zeros(1, nb_data);
w_data = zeros(1, nb_data);
v = 0;
w = 0;
for i=1:nb_data
    epsilon = epsilon_list(i);
    new_v = v + (a3*v^3 + a2*v^2 + a1*v + b*w + I + epsilon) * dt;
    new_w = w + ((v-w)/tau) * dt;
    v = max(0, new_v);
    w = new_w;
    v_data(i) = v;
    w_data(i) = w;
end

%nullclines
nc = linspace(0,0.4,200);
nullclines1 = (a3*nc.^3 + a2*nc.^2 + a1*nc + I) / (-b);
nullclines2 = nc;


%% plot simulation
if toPlot
    t_range = (1:nb_data) * dt/10;
    figure; hold on

    %MUA with time
    subplot(2,1,1), hold on
    plot(t_range, v_data),  hold on

    %phase diagram
    subplot(2,1,2), hold on
    plot(v_data, w_data), hold on
    plot(nc, nullclines1, 'r'), hold on
    plot(nc, nullclines2, 'r'), hold on
    xlim([0 0.4]), ylim([0 0.25]),

end

end




