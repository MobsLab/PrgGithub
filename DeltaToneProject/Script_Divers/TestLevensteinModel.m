%TestLevensteinModel
%24.01.2018 KJ  
%
%
% 
% see
%   BatchSimulate_WCadapt FindBestScaleFactor WCadapt_DwellTimeMatch WCadapt_run
%


N_neurons = 50*ones(20,1);
W = linspace(4,7,20);
I_in = linspace(1,5,20);
beta = linspace(0,1,20);
tau_r = linspace(0.1,1,20);
tau_a = linspace(0.4,1.5,20);
Ak = [10 9];
A0 = [5 6];
noiseamp = [1 2];
noisefreq = [500 500];

simtime = [30,60];
dt = [0.05,0.05];

for nn=1:length(N_neurons)
    modelparms(nn).N_neurons = N_neurons(nn);
    modelparms(nn).W = W(nn);
    modelparms(nn).I_in = I_in(nn);
    modelparms(nn).beta = beta(nn);
    modelparms(nn).tau_r = tau_r(nn);
    modelparms(nn).tau_a = tau_a(nn);
    modelparms(nn).Ak = Ak(nn);
    modelparms(nn).A0 = A0(nn);
    modelparms(nn).noiseamp = noiseamp(nn);
    modelparms(nn).noisefreq = noisefreq(nn);    
    
    simparms(nn).simtime = simtime(nn);
    simparms(nn).dt = dt(nn);

end


[ dwelltimes,ratehist,fspec ] = BatchSimulate_WCadapt(modelparms,simparms);








