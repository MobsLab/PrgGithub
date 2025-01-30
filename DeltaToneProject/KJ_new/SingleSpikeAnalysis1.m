%SingleSpikeAnalysis1
% 19.09.2016 KJ
%
%
% 
%


a=0;
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse244';  % 17-04-2015 > random tone effect  - Mouse 244 (delay 200ms!! of M243 detection)
Dir.delay{a}=0.2; Dir.condition{a}='Random';
Dir.title{a}='Mouse244 - 17042015';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse243';  % 17-04-2015 > delay 200ms - Mouse 243
Dir.delay{a}=0.2; Dir.condition{a}='DeltaTone';
Dir.title{a}='Mouse243 - 17042015';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse244';  % 16-04-2015 > delay 200ms - Mouse 244
Dir.delay{a}=0.2; Dir.condition{a}='DeltaTone';
Dir.title{a}='Mouse244 - 16042015';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150421/Breath-Mouse-243-21042015';               % 21-04-2015 > delay 140ms - Mouse 243
Dir.delay{a}=0.14; Dir.condition{a}='DeltaTone';
Dir.title{a}='Mouse243 - 21042015';

p=1;
disp(' ')
disp('****************************************************************')
eval(['cd(Dir.path{',num2str(p),'}'')'])
disp(pwd)   
%% load

%epoch
load StateEpochSB SWSEpoch Wake
%delta and down
load newDownState.mat
load DeltaPFCx.mat
%tones
load('DeltaSleepEvent.mat', 'TONEtime2')
delay = Dir.delay{p}*1E4; %in 1E-4s
ToneEvent = Restrict(ts(TONEtime2 + delay),SWSEpoch);
nb_tones = length(ToneEvent);
% spikes
load SpikeData
eval('load SpikesToAnalyse/PFCx_Neurons')
NumNeurons=number;
clear number

binsize=50; %in ms
Q = MakeQfromS(S(NumNeurons),binsize*10);
Qsws = Restrict(Q, SWSEpoch);

%pca
data = full(Data(Qsws));
coerr_qsws = corrcoef(data);
coerr_qsws(isnan(coerr_qsws))=0;
[coeff_qsws, latent, explained]= pcacov(coerr_qsws);









