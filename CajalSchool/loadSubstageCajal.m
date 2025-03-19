%loadSubstageCajal

clear LFPs
clear LFP
res=pwd;
disp(pwd)

load StateEpochSB Wake REMEpoch SWSEpoch TotalNoiseEpoch
Wake=Wake-TotalNoiseEpoch;
REMEpoch=REMEpoch-TotalNoiseEpoch;
SWSEpoch=SWSEpoch-TotalNoiseEpoch;
WakeEpoch=Wake-TotalNoiseEpoch;

load SleepSubstages
N1=Epoch{1};
N2=Epoch{2};
N3=Epoch{3};
REM=Epoch{4};
WAKE=Epoch{5};

try
load('Ripples.mat')
rip=ts(Ripples(:,2)*10);
Rip=Ripples;
Rip(:,1:3)=Rip(:,1:3)/1E3;
end

load('DeltaWaves.mat')
Delta=[Start(deltas_PFCx,'s') Start(deltas_PFCx,'s')+(End(deltas_PFCx,'s')-Start(deltas_PFCx,'s'))/2 End(deltas_PFCx,'s')];
delta=ts(Start(deltas_PFCx)+(End(deltas_PFCx)-Start(deltas_PFCx))/2);

load('DownState.mat')

load('Spindles.mat')
spi=ts(spindles_PFCx(:,2)*1E4);
Spi=spindles_PFCx;


load('SpikeData.mat')
try
S=tsdArray(S);
end
numNeurons=GetSpikesFromStructure('PFCx');
S=S(numNeurons);

a=1;

try
    clear LFP
   tempchBulb=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
   chBulb=tempchBulb.channel;
   eval(['load(''',res,'','/LFPData/LFP',num2str(chBulb),'.mat'');'])
   LFPs{a}=LFP;
   listChannel{a}='Bulb_deep';
   a=a+1;
end


try
    clear LFP
tempchPFCs=load([res,'/ChannelsToAnalyse/PFCx_sup.mat'],'channel');
chPFCxsup=tempchPFCs.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chPFCxsup),'.mat'');'])
   LFPs{a}=LFP;
   listChannel{a}='PFCx_sup';
   a=a+1;
end
try
    clear LFP
tempchPFCd=load([res,'/ChannelsToAnalyse/PFCx_deep.mat'],'channel');
chPFCxdeep=tempchPFCd.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chPFCxdeep),'.mat'');'])
   LFPs{a}=LFP;
   listChannel{a}='PFCx_deep';
   a=a+1;
end

try
    clear LFP
tempchPFCsp=load([res,'/ChannelsToAnalyse/PFCx_spindle.mat'],'channel');
chPFCxsp=tempchPFCsp.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chPFCxsp),'.mat'');'])
   LFPs{a}=LFP;
   listChannel{a}='PFCx_spindle';
   a=a+1;
end

try
    clear LFP
tempchHpc=load([res,'/ChannelsToAnalyse/dHPC_rip.mat'],'channel');
chHpc=tempchHpc.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chHpc),'.mat'');'])
   LFPs{a}=LFP;
   listChannel{a}='dHPC_rip';
   a=a+1;
end
try
    LFPs=tsdArray(LFPs);
end