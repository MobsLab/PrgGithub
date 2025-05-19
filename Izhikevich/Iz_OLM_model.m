%% script to run Izhikevich OL-M neuron

I = -30:10:30;
% model parameters
C = 120; %108; % 112;      % pF  
vr = -70; % -62.7;   % 62.7 mV  
vt = -55;   % 54.5 mV
gin = 4.65; %17.2;   % nS  
Ir = -25;     % pA
vmax = (vr - vt)/2 + vt;

k = (gin*(vmax - vr)-Ir) / (vmax - vr)^2;
b1 = -2; % Ia
b2 = gin + k*(vr-vt);               % Ih  
b2 = 5;
k = 1.2;

a1 = 0.2; % 0.05;   % IA  = 5ms activation time constant
a2 = 0.005; %0.001;  % Ih ~ 2000-4000 ms
Eh = -50;   % de-activation potential of Ih

c = -75;    %  ??   
d1 = 100;    % ??
d2 = -35;
vpeak = 40; % default: 40

% shot-noise
nstd = 10;   % std dev of noise in pA

% simulation parameters
T = 5000; % duration of simulation (milliseconds)
dt = 0.25; % time step - was 0.01????
tau = dt;

%% Maccaferi et al (1996) f-I data (data-point for I=30pA is a guess....)
dataf = [0 0.5 2.5 5.5 7 10 13];

%%% set up values
t = 0:dt:T;
n = length(t); % number of time points
f_start = 1000/dt;
f_end = T/dt;
f_time = (f_end - f_start) * 1e-3 * dt;

nInj = numel(I);

% -------------------------------------------------------------------------
% GO SIMULATIONS
%% f-I curves

V = [];
U1 = [];
U2 = [];
fI = zeros(nInj,1);

for loop = 1:nInj
%     loop
    % v = ones(1,n)+b2/k+vt;
    v = ones(1,n)*vr;
    u1=zeros(1,n); u2 = zeros(1,n);
    noise = randn(n,1) .* nstd;
    
    for i = 1:n-1
        %--- basic model
        v(i+1) = v(i) + dt*(k*(v(i)-vr)*(v(i)-vt)-(u1(i)+u2(i)) + I(loop))/C;
        
        %--- with channel noise
        % v(i+1) = v(i) + dt*(k*(v(i)-vr)*(v(i)-vt)-(u1(i)+u2(i)) + I(loop) + noise(i))/C;
        
        %-- Ia current
        u1(i+1) = u1(i) + dt*a1*(b1*(v(i)-vr)-u1(i));
        
        
        %u2(i+1) = u2(i) + dt*a2*(b2*(v(i)-vr)-u2(i));
        
        % threshold Ih (deactivate when depolarised)
        % this form goes to zero after threshold, and makes contribution to change go to zero as 
        % v -> Eh
        u2(i+1) = (v(i)<=Eh)* (u2(i) + dt*a2*(b2*(v(i)-Eh)-u2(i)));

       
        % spikes?   
        if v(i+1)>=vpeak
            v(i)=vpeak; v(i+1)=c; 
            u1(i+1)=u1(i+1)+d1; 
            u2(i+1)=u2(i+1)+d2;
        end
    end

    % firing rate at this current
    fI(loop) = sum(v(f_start:f_end) == vpeak) ./ f_time;
    
    % store membrane potential traces
    V = [V; v];
    U1 = [U1; u1];
    U2 = [U2; u2];
end

figure(1)
clf
plot(I,fI,'+-','LineWidth',1.5)
hold on
plot(I,dataf,'rs:','LineWidth',1.5)
xlabel('Tonic current (pA)')
ylabel('Output frequency (spikes/s)')
legend('Model','Data','Location','Best')

figure(2) 
subplot(311),plot(t,V(4,:));
ylabel('V (mv)')
subplot(312),plot(t,U1(4,:));
ylabel('u1 (Ia)')
subplot(313),plot(t,U2(4,:));
xlabel('time (ms)')
ylabel('u2 (Ih)')

%% ----------------------------------------------------------------------
%% test voltage sag....
r = input('Press any key to test voltage sag')
%%

t_on = 100;
t_off = 300;
t_end = 400;

tsag = 0:dt:t_end;
nsag = length(tsag); % number of time points

%%% these values match those from the Saraga
%%% et al (2003) model, with inputs in range [-0.5,0.1] nA,
Isag = [-500, -300, -100, 100];
Vsag = [];
Uhsag = [];

nIsag = numel(Isag);

for loop = 1:nIsag
    % start with voltage at rest
    v = ones(1,nsag)*vr; u1=zeros(1,nsag); u2 = zeros(1,nsag);

    for i = 1:nsag-1
        if i*dt >= t_on & i*dt <= t_off
            Ia = Isag(loop);
        else
            Ia = 0;
        end
        %--- basic model
        v(i+1) = v(i) + dt*(k*(v(i)-vr)*(v(i)-vt)-(u1(i)+u2(i)) + Ia)/C;
        
        %--- with channel noise
        % v(i+1) = v(i) + dt*(k*(v(i)-vr)*(v(i)-vt)-(u1(i)+u2(i)) + Ia + noise(i))/C;
        
        %-- Ia current
        u1(i+1) = u1(i) + dt*a1*(b1*(v(i)-vr)-u1(i));
        
        % threshold Ih (deactivate when depolarised)
        % this form goes to zero after threshold, and makes contribution to change go to zero as 
        % v -> Eh
        u2(i+1) = (v(i)<=Eh)* (u2(i) + dt*a2*(b2*(v(i)-Eh)-u2(i)));

        % spikes?   
        if v(i+1)>=vpeak
            v(i)=vpeak; v(i+1)=c; 
            u1(i+1)=u1(i+1)+d1; 
            u2(i+1)=u2(i+1)+d2;
        end
    end     
        
    Vsag = [Vsag; v];
    Uhsag = [Uhsag; u2];
end

figure(3)
clf
hold on
    for i = 1:nIsag
        %eval(['subplot(' num2str(nIsag) '1' num2str(i) '), plot(tsag,Vsag(' num2str(i) ',:))']);
        eval(['plot(tsag,Vsag(' num2str(i) ',:),''k'',''LineWidth'',2)']);
    end
xlabel('Time (ms)')
ylabel('Membrane potential (mV)')
    
figure(4)
clf
hold on
    for i = 1:nIsag
        %eval(['subplot(' num2str(nIsag) '1' num2str(i) '), plot(tsag,Uhsag(' num2str(i) ',:))']);
        eval(['plot(tsag,Uhsag(' num2str(i) ',:))']);
    end    
    
    
% %%_______________________________________________________________________
% %% values of b
% vecb1 = 0.5:0.5:10;
% nb1 = numel(vecb1);
% Vb1 = [];
% U1b1 = [];
% U2b1 = [];
% fb1 = zeros(nbl,1);
% I = 0;
% 
% for loop = 1:nb1
%     loop
%     v = vr*ones(1,n)+5; u1=zeros(1,n); u2 = zeros(1,n)+d2;
%     b1 = vecb1(loop);
%     for i = 1:n-1
%         %--- basic model
%         v(i+1) = v(i) + dt*(k*(v(i)-vr)*(v(i)-vt)-(u1(i)+u2(i)) + I)/C;
%         u1(i+1) = u1(i) + dt*a1*(b1*(v(i)-vr)-u1(i));
%         u2(i+1) = u2(i) + dt*a2*(b2*(v(i)-vr)-u2(i));
%         % spikes?   
%         if v(i+1)>=vpeak
%             v(i)=vpeak; v(i+1)=c; 
%             u1(i+1)=u1(i+1)+d1; 
%             u2(i+1)=u2(i+1)+d2;
%         end
%     end
% 
%     % firing rate at this current
%     fb1(loop) = sum(v(f_start:f_end) == vpeak) ./ f_time;
%     
%     % store membrane potential traces
%     Vb1 = [V; v];
%     U1b1 = [U1b1; u1];
%     U2b1 = [U2b1; u2];
% end
% 
% figure(4)
% plot(vecb1,fb1,'+:')
% xlabel('b1')
% ylabel('frequency (spikes/s)')