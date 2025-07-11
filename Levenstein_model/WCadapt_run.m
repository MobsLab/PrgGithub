function [ T, Y_sol,Inoise,Ipulse ] = WCadapt_run(simtime,dt,parms,varargin)
%UNTITLED2 Summary of this function goes here
%
%parms
%   .N_neurons
%   .W
%   .I_in
%   .beta
%   .tau_r
%   .tau_a
%   .Ak
%   .A0
%   .noiseamp
%   .noisefreq
%   .pulseparms (optional)   [t_onset magnitude duration]
%
%
%TO DO:
%   -Allow for general activation function as input
%
%%

p = inputParser;
addParameter(p,'init',[]);
parse(p,varargin{:})
init = p.Results.init;



parms.samenoise = false;

%% Establish Vectors etc
N_neurons = parms.N_neurons;
W = parms.W;
I_in = parms.I_in;
beta = parms.beta;
tau_r = parms.tau_r;
tau_a = parms.tau_a;
Ak = parms.Ak;
A0 = parms.A0;
noiseamp = parms.noiseamp;
noisefreq = parms.noisefreq;

pulseparms = [0 0 0];
if isfield(parms,'pulseparms')
    if isempty(parms.pulseparms);pulseparms = [0 0 0];end
    pulseparms = parms.pulseparms;
end


%initial conditions: random activity. 
%                    -can add different initial conditions if desired.
if isempty(init)
r_init = rand(1,N_neurons);
a_init = rand(1,N_neurons);

y0 = [r_init,a_init];       %combine initial conditions 
                             %into one long vector for ode45
else
    y0 = init;
end
                                            
%time and solution arrays for ode45
t_tot = simtime/dt;             %number of iterations
tspan = [0:dt:simtime]';         %interval of integration

%% Noise for Input
switch parms.samenoise
    case true
        numsignals = 1;
    case false
        numsignals = N_neurons;
end 
[ Inoise,noiseT ] = OUNoise(noisefreq,noiseamp,simtime,dt./10,dt,numsignals);
%% System of Equations

    function dy = WCadapt_eqs(t, y)
%         if mod(t/simtime,0.05) == 0
%             display(num2str(t/simtime))
%         end
        %% indices
        r_indexlow = 1;
        r_indexhigh = N_neurons;
        a_indexlow = r_indexhigh + 1;
        a_indexhigh = r_indexhigh + N_neurons;
        
        %% separate the input vector into its e, i, and theta components
        r = y(r_indexlow:r_indexhigh);
        a = y(a_indexlow:a_indexhigh);
        
        %% THE DIFF.EQS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        I_tot = W*r - beta.*a + I_in + interp1(noiseT,Inoise,t)' + pulsefun(t,pulseparms);
        
        F_I = 1./(1+exp(-I_tot));
        Ainf = 1./(1+exp(-Ak.*(r-A0)));
        
        dr = (-r + F_I)./tau_r;
        da = (-a + Ainf)./tau_a;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %% combine the outputs into one vector
        dy = [dr;da];
    end

%% RUN THE ODE SOLVER

[T,Y_sol] = ode45(@WCadapt_eqs,tspan,y0);

%noise
Ipulse = pulsefun(T,pulseparms);
%% Function for pulse
function Ipulse_out = pulsefun(t_in,pulseparms_in)
    t_onset=pulseparms_in(1);magnitude=pulseparms_in(2);duration=pulseparms_in(3);
    t_offset = t_onset + duration;
    
    Ipulse_out = zeros(size(t_in));
    Ipulse_out(t_in >= t_onset & t_in <= t_offset) = magnitude;
    
%     if t_in < t_onset
%         Ipulse_out = 0;
%     elseif t_in >= t_onset && t_in <= t_offset
%         Ipulse_out = magnitude;
%     elseif t_in > t_offset
%         Ipulse_out = 0;
%     end
end

end

