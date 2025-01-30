%%% single module from Tort et al (2007) paper in Izhikevich form
%%% To add: a phenomenological model of interneuron targets on pyramidal
%%% cell dendrites - Tort et al put all OL-M input into distal dendrites
%%% and all FS input into soma. (Suggests an FS == division model...)
%%% However, module seems to work fine without it....
%
% Mark Humphries 30/5/2008
%
%
%
%
% 1 all to all
% 2 all to all with noise
% 3 with Module
% 4 with module and connection inter-module (inter = intra)
% 5 with module with noise
% 6 with module, with noise and connection inter-module (inter = intra)
% 7 with module and connection inter-module (inter < intra) 
% 8 with module with noise and connection inter-module (inter < intra) 
%
%


%% SIMULATION PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t = 6000;         % length of simulation (ms)
tON = 800;        	% time at which the weights are turned on (ms)  par default 2000
tOFF = 6000;        % time at which the weights are turned off (ms)  par default 12000
tDopaON = 2800;        	% time at which dopamine is turned on (ms)  par default 6000
tDopaOFF = 6000;        % time at which dopamine is turned off (ms)  par default 10000
dt = 0.1;        	% time-step (ms) - try conservative value i.e. dt = 0.1 ms
nsteps = max(t) ./ dt;

%     % switch on/off synaptic weights
%     if time < tON |time > tOFF
%         w = wON;
%     else
%         w = wON;
%     end
%     
%      % switch on/off Dopamine
%     if time > tDopaON |time < tDopaOFF
%         EC=100; Evr=-60; Evt=-40; Ek=EkbD; % par default Ek=0.9; 
%         w=wDopaON;
%     else
%         EC=100; Evr=-60; Evt=-40; Ek=EkaD; % par default Ek=0.7;
%         w=wDopaON;
%     end
    
%% Parameters

Netw=1; % plot the network
try
    FreqAnalysis;
catch
    FreqAnalysis=0;
end
try
CrossCorrAnalysis;
catch
CrossCorrAnalysis=0;
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Noise in the input to neurons
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


try
    NoiseLevel;
catch
    NoiseLevel=0.2;% 0.2 MODIFIE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
end

try
    D;
catch
    D=3;                  % maximal conduction delay in ms
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Type of connectivity matrix
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


try
    choix; 
catch
    choix=1;
end

% 1 all to all
% 2 all to all with noise
% 3 with Module
% 4 with module and connection inter-module (inter = intra)
% 5 with module with noise
% 6 with module, with noise and connection inter-module (inter = intra)
% 7 with module and connection inter-module (inter < intra) 
% 8 with module with noise and connection inter-module (inter < intra) 

NoiseNetwork=0.05; % noise in the connectivity matrix
InterIntra=30;




%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% modification of pyramidal neurons by dopamine
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

try
EkbD;
catch
EkbD=0.6;  % default 0.9
end

try
EkaD;
catch
EkaD=0.5; % default O.5 or 0.7
end

disp(' ')
disp(['Ek before dopamine ',num2str(EkbD)])
disp(' ')
disp(['Ek after dopamine ',num2str(EkaD)])
disp(' ')

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------




rand('state',1);    
randn('state',1);   

%% MODULE PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





Nmod=5; %number of modules
%Ne = 5*Nmod;   Nfs = 4*Nmod;  No = 4*Nmod; N = Ne + Nfs + No;
Ne = 25*Nmod;   Nfs = 20*Nmod;  No = 20*Nmod; N = Ne + Nfs + No;




    Nnetwork(1)=Nmod;
    Nnetwork(2)=Ne;
    Nnetwork(3)=Nfs;
    Nnetwork(4)=No;


% D=3;                  % maximal conduction delay in ms

ixE = 1:Ne;
ixFS = Ne+1:Ne+Nfs;
ixO = Ne+Nfs+1:N;

%--------------------------------------------------------------------------




%% NEURON MODELS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Pyramidal cell (E)
EC=100; Evr=-60; Evt=-40; Ek=0.7; % parameters used for E
Ea=0.03; Eb=-2; Ec=-50; Ed=100; % neocortical pyramidal neurons
Evpeak=35; % spike cutoff
% Eapp = 300; % injection current in pA to get ~ 50 Hz
Eapp = 80; % MODIFIE 100!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%%% FS interneuron (FS)
FSC=20; FSvr=-55; FSvt=-40; FSk=1; 
FSa=0.2; FSb=0.025; FSc=-45; FSvb=-55; 
FSd = 0;
% note that b and d do not appear as normal in the FS inter-neuron model  
FSvpeak=25; % spike cutoff
% FSapp = 90; % injection current in pA to get ~ 25 Hz
FSapp = 80; % MODIFIE 80!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


%%% OL-M interneuron (O)
OC = 120; Ovr = -70; Ovt = -55; Ok = 1.2; Oc = -75; Ovpeak = 40; 
Ob1 = -2; Oa1 = 0.2; Od1 = 100; % Ia 
Ob2 = 5; Oa2 = 0.005;  Od2 = -35; % Ih
OEh = -50;   % de-activation potential of Ih
% Oapp = 0; % to get ~ 3.5 Hz ???? Tort et al's parameter values suggest ~1300 here - too big surely!
Oapp = 0; % MODIFIE 0!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!





%--------------------------------------------------------------------------








%% SYNAPSE MODELS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tort model has only AMPA and GABAa....
% we use single-exponential model here, as rise times are so short
tau_E = 5.3; %ms
tau_FS = 9.1; %ms
tau_O = 25; % 20 ms in paper - make slightly longer here

% maximum conductances in nS - Tort et al (2007) give their values in SI Table 2
GE_O = 3; % 0.3 mS/cm^2 
GE_FS = 1; % 0.1 mS/cm^2
GO_E = 10;  % 10 mS ~ 7634 mS/cm^2 ???????? Assume they meant 10 nS
GO_FS = 2; % 0.1 mS/cm^2
GFS_FS = 2; % 0.2 mS/cm^2 
GFS_E = 5; % 5 mS ~ 3817 mS/cm^2 ???????? Assume they meant 5 nS
GFS_O = 7; % 0.8 mS/cm^2

%--------------------------------------------------------------------------
% GE_O = 4;   % MODIFIE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% GE_FS = 1;  % MODIFIE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% GO_E = 1;   % MODIFIE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% GO_FS = 4;  % MODIFIE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% GFS_FS = 2; % MODIFIE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% GFS_E = 10; % MODIFIE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% GFS_O = 5;  % MODIFIE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%--------------------------------------------------------------------------

% reversal potentials
E_EX = 0;       % glutamate reversal potential
E_FSX = -80;    % GABA reversal potential
E_OX = -80;


%--------------------------------------------------------------------------







%% MAKE NETWORK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% tgt matrix, all to all connectivity within module....
tgts = zeros(N);
tgts(ixE,:) = [zeros(Ne) repmat(ixFS,Ne,1) repmat(ixO,Ne,1)];
tgts(ixFS,:) = [repmat(ixE,Nfs,1) repmat(ixFS,Nfs,1) repmat(ixO,Nfs,1)];
tgts(ixO,:) = [repmat(ixE,No,1) repmat(ixFS,No,1) zeros(No)];

% make weight matrix out of this....
    
%choix
%
% 1 all to all
% 2 all to all with noise
% 3 with Module
% 4 with module and connection inter-module
% 5 with module with noise
% 6 with module, with noise and connection inter-module

[wON,wOFF,wDopaON,wDopaOFF,tgts,celltype]=TortMakeNetwork(choix,NoiseNetwork,ixE,ixFS,ixO,Nmod,Ne,Nfs,No,N,GE_FS,GE_O,GFS_E,GFS_FS,GFS_O,GO_E,GO_FS,InterIntra,1);


%--------------------------------------------------------------------------




% %% SIMULATION PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% t = 5000;         % length of simulation (ms)
% tON = 500;        	% time at which the weights are turned on (ms)  par default 2000
% tOFF = 5000;        % time at which the weights are turned off (ms)  par default 12000
% tDopaON = 2500;        	% time at which dopamine is turned on (ms)  par default 6000
% tDopaOFF = 5000;        % time at which dopamine is turned off (ms)  par default 10000
% dt = 0.1;        	% time-step (ms) - try conservative value i.e. dt = 0.1 ms
% nsteps = max(t) ./ dt;

%%%%% fluctuating background conductance input model (not implemented in
%%%%% code yet)
% tauI = 1;       % ms
% mI = 50;
% sI = 50;
% muI = mI / tauI;      % pA
% sdI = sqrt(2*sI^2/tauI);      % pA

%%%%% shot noise, as used by Tort et al (std dev is 20% of applied current) 

% NoiseLevel=0.2;
% NoiseLevel=0.9;% MODIFIE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

nstdE = Eapp * NoiseLevel;   % std dev of noise in pA
nstdFS = FSapp * NoiseLevel;
nstdO = 50;     % note that our OL-M model fires at ~3Hz spontaneously anyway, so we don't have to apply
                % a negative current to force it down to this value as Tort et al do - so
                % shot noise std dev is arbitrary

noise = [randn(nsteps,Ne)*nstdE, randn(nsteps,Nfs)*nstdFS, randn(nsteps,No)*nstdO];     
% NOTE: if network gets large then above will take a lot of memory, so move to
% within the simulation FOR.. loop below

% start with v's at random voltages
v = [Evr*ones(Ne,1); FSvr*ones(Nfs,1); Ovr*ones(No,1)] + randn(N,1)*20;
u = [rand(Ne,1)*Ed; rand(Nfs,1)*FSd; rand(No,1)*Od1];  % all u(1) at random values in [0 d1]                   
uh = [zeros(Ne+Nfs,1); rand(No,1)*Od2*2]; % second u for OL-M cells in [0 Od2*2]
firings=[-1 0];                         % spike timings [time, cell number]

Iback=zeros(N,1);
permcells = randperm(N);
injcells = permcells(1:10);
I=zeros(N,1);   

s_EX = zeros(N,1);
s_FSX = zeros(N,1);
s_OX = zeros(N,1);


expsynE_X = exp(-dt/tau_E);
expsynFS_X = exp(-dt/tau_FS);
expsynO_X = exp(-dt/tau_O); 

LFP = zeros(nsteps,1);
Vlt = zeros(N,nsteps);


%% RUN SIMULATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%   h = waitbar(0,'Please wait...');
tic
for i=1:nsteps                        
    time = i * dt;
    
    % switch on/off synaptic weights
    if time < tON |time > tOFF
        w = wON;
    else
        w = wON;
    end
    
     % switch on/off Dopamine
    if time < tDopaON % |time < tDopaOFF
        EC=100; Evr=-60; Evt=-40; Ek=EkbD; % par default Ek=0.9; 
        w=wDopaON;
    elseif time > tDopaON+1000
        EC=100; Evr=-60; Evt=-40; Ek=EkaD; % par default Ek=0.7;
        w=wDopaON;
    else
        EC=100; Evr=-60; Evt=-40; Ek=EkbD+(EkaD-EkbD)*(time-tDopaON)/1000; % par default Ek=0.7;
        w=wDopaON;
    end
    
    %% update currents    
    I(ixE) = Eapp + noise(i,ixE);
    I(ixFS) = FSapp + noise(i,ixFS);
    I(ixO) = Oapp + noise(i,ixO);
    
    %Iback = Iback - dt .* Iback ./ tauI + muI * dt + sdI .* randn(N,1) .* sqrt(dt);
    %I = I + Iback;
    
    %%% check what cells fired
    Efired = find(v(ixE)>=Evpeak);                % indices of fired neurons
    FSfired = find(v(ixFS)>=FSvpeak);  
    Ofired = find(v(ixO)>=Ovpeak); 
    
    % reset all fired cells	
    v(ixE(Efired))= Ec;  
    v(ixFS(FSfired))= FSc; 
    v(ixO(Ofired))= Oc;
    
    u(ixE(Efired))=u(ixE(Efired))+Ed;
    u(ixFS(FSfired))=u(ixFS(FSfired))+FSd;      
    u(ixO(Ofired))=u(ixO(Ofired))+Od1;
    uh(ixO(Ofired))=uh(ixO(Ofired))+Od2;
    
    %% record firing times in milliseconds
    firings=[firings;round(i*ones(length(Efired)+length(FSfired)+length(Ofired),1)*dt),[ixE(Efired)'; ixFS(FSfired)'; ixO(Ofired)']];    
   
    %--------------------------------------------------------------------------

    
%     %%%% no delays: instantaneous transmission
%     %% update synapses 
%     s_EX = s_EX * expsynE_X;
%     s_FSX = s_FSX * expsynFS_X;
%     s_OX = s_OX * expsynO_X;
%     
%     
%     
%     for k = 1:length(Efired)
%         s_EX = s_EX + w(ixE(Efired(k)),:)';  
%     end
%     for k = 1:length(FSfired)
%         s_FSX = s_FSX + w(ixFS(FSfired(k)),:)';  
%     end
%     for k = 1:length(Ofired)
%         s_OX = s_OX + w(ixO(Ofired(k)),:)';  
%     end
    
    %--------------------------------------------------------------------------

    
%     keyboard
    
    %%%% With delays
    %% update synapses 
    s_EX = s_EX * expsynE_X;
    s_FSX = s_FSX * expsynFS_X;
    s_OX = s_OX * expsynO_X;
    
    
    for k = 1:length(Efired)
    try
        WED{i,k}=w(ixE(Efired(k)),:)';
        s_EX = s_EX + WED{floor(i-D*10),k};  
    end
    end
    
    for k = 1:length(FSfired)
    try    
        WFD{i,k}=w(ixFS(FSfired(k)),:)';
        s_FSX = s_FSX + WFD{floor(i-D*10),k};  
    end
    end
    
    for k = 1:length(Ofired)
    try
        WOD{i,k}= w(ixO(Ofired(k)),:)';
        s_OX = s_OX + WOD{floor(i-D*10),k};  
    end
    end
    
    %--------------------------------------------------------------------------
    
    
    
    
    
    
    
    %%% update membrane potential
    % synaptic input is lumped
    IsynE = (s_EX(ixE) .* (E_EX - v(ixE)) + (s_OX(ixE) .* (E_OX - v(ixE)))) + (s_FSX(ixE) .* (E_FSX - v(ixE)));
    v(ixE)=v(ixE)+dt.*(Ek.*(v(ixE)-Evr).*(v(ixE)-Evt)-u(ixE)+I(ixE)+ IsynE)./EC;
    
    % synaptic input is lumped: s_pyr(E_pyr - v) + s_fs(E_fs - v) + s_o(E_o - v)
    IsynFS = s_EX(ixFS) .* (E_EX - v(ixFS)) + (s_FSX(ixFS) .* (E_FSX - v(ixFS))) + (s_OX(ixFS) .* (E_OX - v(ixFS)));
    v(ixFS)=v(ixFS)+dt.*(FSk.*(v(ixFS)-FSvr).*(v(ixFS)-FSvt)-u(ixFS)+I(ixFS)+ IsynFS)./FSC;
    
    % synaptic input is lumped: s_pyr(E_pyr - v) + s_fs(E_fs - v) + s_o(E_o - v)
    IsynO = s_EX(ixO) .* (E_EX - v(ixO)) + (s_FSX(ixO) .* (E_FSX - v(ixO))) + (s_OX(ixO) .* (E_OX - v(ixO)));
    v(ixO)=v(ixO)+dt.*(Ok.*(v(ixO)-Ovr).*(v(ixO)-Ovt)-(u(ixO)+uh(ixO))+I(ixO)+ IsynO)./OC;
    
    % compute simple LFP	
    LFP(i) = sum(IsynE) + sum(IsynFS) + sum(IsynO);
    
    %% update slow currents
    % pyramidal neurons
    u(ixE)=u(ixE)+dt* Ea.*(Eb.*(v(ixE)-Evr)-u(ixE));                
   
    % FS inter-neurons
    ix1 = v(ixFS) < FSvb;
    ix2 = v(ixFS) >= FSvb;
    u(ixFS(ix1))=u(ixFS(ix1))+dt*FSa*-u(ixFS(ix1));
    u(ixFS(ix2))=u(ixFS(ix2))+dt*FSa*(FSb*(v(ixFS(ix2))-FSvb).^3-u(ixFS(ix2)));
      
    % OL-M inter-neurons
    u(ixO) = u(ixO) + dt*Oa1*(Ob1*(v(ixO)-Ovr)-u(ixO));        
    % threshold Ih (deactivate when depolarised)
    % this form goes to zero after threshold, and makes contribution to change go to zero as v -> Eh
    uh(ixO) = (v(ixO)<=OEh).* (uh(ixO) + dt*Oa2*(Ob2*(v(ixO)-OEh)-uh(ixO)));
    
    Vlt(:,i)=v;
%     try  
%         Vlt=[Vlt,v];
%     catch
%         Vlt=v;
%     end
    
%     waitbar(i/nsteps,h)

end
toc
% close(h)
nspikes = size(firings(:,1));

% mean rates and split each cell into data structure
meanE = 0; meanFS = 0; meanO = 0;
fixE = []; fixFS = []; fixO = [];
Edata = struct([]); FSdata = struct([]); Odata = struct([]);
for i = 1:Ne
    meanE = meanE + sum(firings(:,2) == ixE(i)) / (Ne * t/1000);
    fixE = [fixE; find(firings(:,2) == ixE(i))];
    Edata(i).times = [firings(firings(:,2) == ixE(i),1)/1000];	% gives spike times in seconds
end
for i = 1:Nfs
    meanFS = meanFS + sum(firings(:,2) == ixFS(i)) / (Nfs * t/1000);
    fixFS = [fixFS; find(firings(:,2) == ixFS(i))];
    FSdata(i).times = [firings(firings(:,2) == ixFS(i),1)/1000];
end
for i = 1:No
    meanO = meanO + sum(firings(:,2) == ixO(i)) / (No * t/1000);
    fixO = [fixO; find(firings(:,2) == ixO(i))];
    Odata(i).times = [firings(firings(:,2) == ixO(i),1)/1000];
end



%% Show spike raster

if Netw

figure('Color',[1 1 1])
clf
plot(firings(fixE,1),firings(fixE,2),'k.', 'MarkerFaceColor', 'k');
hold on
plot(firings(fixFS,1),firings(fixFS,2),'r.', 'MarkerFaceColor', 'r');
plot(firings(fixO,1),firings(fixO,2),'.', 'MarkerFaceColor', 'b');
axis([0 t 0 N+2]); drawnow;
xlabel('Time (ms)');
ylabel('Cell number');
title(['Single module. Mean rates: E-cells ' num2str(meanE) ' spikes/s; FS-cells ' num2str(meanFS) ' spikes/s; O-cells ' num2str(meanO) ' spikes/s.']);
line([tDopaON tDopaOFF],[N+1 N+1],'Color','k','linewidth',4)



end







if FreqAnalysis
    
%% show periodograms of spike trains - uncomment to use
%% NEED CHRONUX TOOLBOX FOR THIS
%% download from: http://chronux.org/chronux/
params.tapers = [3 5];      % default values
params.pad = -1;            % no padding
params.Fs = 1000 / dt;      % sampling frequency
params.fpass = [0 100];     % range of frequencies to analyse
params.err = 0;             % no error bars
params.trialave = 1;        % average over multiple spike trains                                          
fscorr = 0;                 % no finite size correction

%% do tapered-window spectrum analysis
[ES,Ef,ER]=mtspectrumpt(Edata,params,fscorr);
[FSS,FSf,FSR]=mtspectrumpt(FSdata,params,fscorr);
[OS,Of,OR]=mtspectrumpt(Odata,params,fscorr);

figure('Color',[1 1 1])
subplot(311),plot(Ef,ES,'LineWidth',2)
ylabel('Power'); title('Spectrum of E-cell');
subplot(312),plot(FSf,FSS,'LineWidth',2)
ylabel('Power'); title('Mean spectrum of FS-cells');
subplot(313),plot(Of,OS,'LineWidth',2)
xlabel('Frequency (Hz)'); ylabel('Power'); title('Mean spectrum of O-cells');

%% do spectrum of "LFP"
[LFP_S,LFP_f]=mtspectrumc(LFP-mean(LFP),params);
figure('Color',[1 1 1])
plot(LFP_f,LFP_S,'LineWidth',2)
xlabel('Frequency (Hz)')
ylabel('Power')

end



% 1 all to all
% 2 all to all with noise
% 3 with Module
% 4 with module and connection inter-module (inter = intra)
% 5 with module with noise
% 6 with module, with noise and connection inter-module (inter = intra)
% 7 with module and connection inter-module (inter < intra) 
% 8 with module with noise and connection inter-module (inter < intra) 

disp(' ')
switch choix
    case 1
      disp('all to all')
 case 2
      disp('all to all with noise')
case 3
      disp('with Module')
case 4
      disp('with module and connection inter-module (inter = intra)')
case 5
      disp('with module with noise')
case 6
      disp('with module, with noise and connection inter-module (inter = intra)')
case 7
      disp('with module and connection inter-module (inter < intra) ')
case 8
      disp('with module with noise and connection inter-module (inter < intra) ')
end

disp(' ')

if CrossCorrAnalysis

TortCrossCorrAnalysis

end

