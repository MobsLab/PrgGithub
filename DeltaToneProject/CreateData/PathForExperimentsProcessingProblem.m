% Function that list records with processing problems
% 
% 


function Dir=PathForExperimentsProcessingProblem(process)

%% Missing PFC sup
a=0;
if strcmpi(process,'MissingPFCsup')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse161/20141209/BULB-Mouse-161-09122014'; % Mouse 161 - Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse161/20141211/BULB-Mouse-161-11122014'; % Mouse 161 - Trec- REVERSE ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse161/20141217/BULB-Mouse-161-17122014'; % Mouse 161 - Trec- REVERSE ok
end

%% Missing epochs
a=0;
if strcmpi(process,'MissingEpochs')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse251'; % Mouse 251 - Day 1
end


%% problem generating waveform
a=0;
if strcmpi(process,'NoWaveforms')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse251'; % Mouse 251
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse251'; % Mouse 251
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150520/Breath-Mouse-251-252-20052015/Mouse252'; % Mouse 252
end

a=0;
if strcmpi(process,'NREMEpochsML')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243'; % Mouse 252
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243'; % Mouse 330
end


end
