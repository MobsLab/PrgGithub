function [C_wake,C_sws,C_rem,f] = GetCoherence_MC(Wake,SWSEpoch,REMEpoch,LFP_struct1,LFP_struct2,epoch)

%% parameters
params.Fs=1/median(diff(Range(LFP_struct1,'s')));
% params.tapers=[3,5];
params.tapers=[5,9];
params.fpass=[0 25];
params.err=[2,0.05];
params.pad=0;
movingwin=[3,0.5];

%% coherence for each state (pre and post injection)
[C_wake,phi,S12,S1,S2,t,f,phistd,Cerr]=cohgramc_MC(Data(Restrict(LFP_struct1,and(Wake,epoch))),Data(Restrict(LFP_struct2,and(Wake,epoch))),movingwin,params);

[C_sws,phi,S12,S1,S2,t,f,phistd,Cerr]=cohgramc_MC(Data(Restrict(LFP_struct1,and(SWSEpoch,epoch))),Data(Restrict(LFP_struct2,and(SWSEpoch,epoch))),movingwin,params);

[C_rem,phi,S12,S1,S2,t,f,phistd,Cerr]=cohgramc_MC(Data(Restrict(LFP_struct1,and(REMEpoch,epoch))),Data(Restrict(LFP_struct2,and(REMEpoch,epoch))),movingwin,params);
end