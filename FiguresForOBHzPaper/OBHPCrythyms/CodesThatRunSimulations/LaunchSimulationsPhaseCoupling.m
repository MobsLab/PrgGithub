clear all
% Parameters that don't change
Options.n=1; % n:m coupling
Options.m=1; % n:m coupling
Options.dt=0.001; % time step for euler method, seconds
Options.TMax=100; % duration of simulation, seconds
Options.FreqRange1=[4:12;6:14]; % Frequencies to filter
Options.FreqRange2=[27.5:5:52.5;32.5:5:57.5]; % Frequencies to filter
Options.BinNum=80;
Options.Shuffles=100;
Options.NMRatiosToTest=[1,1;1,1.5;1,2;1,3;1,4];
Options.MeanFrq1=8*(2*pi); % Mean Freq for first oscillator
Options.MeanFrq2=40*(2*pi); % Mean Freq for first oscillator
Options.alpha=0.01;
Options.StdFrq1=1*(2*pi); % Std of freq for first oscillator
Options.StdFrq2=4*(2*pi); % Std of freq for first oscillator

%  different degrees of coupling
Str=[0,0.2,1,3,10,50];
for k=1:6
    Options.smoofactfreq=100; % what timescale should frequency noise vary on
    Options.eps=Str(k); % strength of coupling
    [Res.Index{k,1},Res.IndexRand{k,1},Res.IsSig{k,1},Res.LFP1{k,1},Res.LFP2{k,1},Res.PhaseDiff{k,1}]=SimulatePhaseCoupling(Options,1);
    Res.Options{k,1}=Options;
end

Options.n=1; % n:m coupling
Options.m=5; % n:m coupling
%  different degrees of coupling
Str=[0,0.2,1,3,10,50];
for k=1:6
    Options.smoofactfreq=100; % what timescale should frequency noise vary on
    Options.eps=Str(k); % strength of coupling
    [Res.Index{k,2},Res.IndexRand{k,2},Res.IsSig{k,2},Res.LFP1{k,2},Res.LFP2{k,2},Res.PhaseDiff{k,2}]=SimulatePhaseCoupling(Options,1);
    Res.Options{k,2}=Options;
end
cd /home/vador/Documents

save('ModelCoupledOscillatorsFast.mat','Res','-v7.3')