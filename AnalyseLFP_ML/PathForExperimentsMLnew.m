function Dir=PathForExperimentsMLnew(experiment)

% input:
% name of the experiment.
% possible choices: 'BASAL' 'Spikes' 'SD6h' 'SD24h' ...
%
% output
% Dir = structure containing paths / names / strains / name of the
% experiment (manipe) / correction for amplification (default=1000)
%
%   example:
% Dir=PathForExperimentsML('BASAL');
%
% 	merge two Dir:
% Dir=MergePathForExperiment(Dir1,Dir2);
%
%   restrict Dir to mice or group:
% Dir=RestrictPathForExperiment(Dir,'nMice',[245 246])
% Dir=RestrictPathForExperiment(Dir,'Group',{'OBX','hemiOBX'})
% Dir=RestrictPathForExperiment(Dir,'Group','OBX')

% similar functions:
% PathForExperimentFEAR.m
% PathForExperimentsBULB.m
% PathForExperimentsDeltaSleep.m
% PathForExperimentsKB.m PathForExperimentsKBnew.m 


%% Path
a=0;
if strcmp(experiment,'Spikes')
    % ProjetDelta
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse244';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse251';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse251';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150520/Breath-Mouse-251-252-20052015/Mouse251';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse251';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150522/Breath-Mouse-251-252-22052015/Mouse251';
    % OR
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160704';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160704';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160718';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160718';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse402/20160822-PoolDayAndNight';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse403/20160822-PoolDayAndNight';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20161010';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20161010';
    
    % SD24h check good spikes
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160906';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160906';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160906';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160913';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160913';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160913';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160913';
    
elseif strcmp(experiment,'SpikesDownStates')
    % ProjetDelta
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse244';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244';
    % OR
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160718';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20161010';
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160913';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160913';
    
    
elseif strcmp(experiment,'BASALlongSleep') 

    %  ------------ 251 ------------
    %a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse251'; % Mouse 251 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse251'; % Mouse 251 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150520/Breath-Mouse-251-252-20052015/Mouse251'; % Mouse 251 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse251'; % Mouse 251 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150522/Breath-Mouse-251-252-22052015/Mouse251'; % Mouse 251 - Day 5
    % ------------  252 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse252'; % Mouse 252 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse252'; % Mouse 252 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150520/Breath-Mouse-251-252-20052015/Mouse252'; % Mouse 252 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse252'; % Mouse 252 - Day 4
    %  ------------ 293 294 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151209/Mouse293/Breath-Mouse-293-09122015'; % Mouse 293 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151207/Mouse294/Breath-Mouse-294-07122015'; % Mouse 294 - Day 1
    % ------------ 296 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151207/Mouse296/Breath-Mouse-296-07122015'; % Mouse 296 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151209/Mouse296/Breath-Mouse-296-09122015'; % Mouse 296 - Day 3
    % ------------ 328 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160322/Breath-Mouse-328-22032016'; % Mouse 328 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160325/Breath-Mouse-328-25032016'; % Mouse 328 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160401/Mouse328/Breath-Mouse-328-01042016'; % Mouse 328 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160404/Mouse328/Breath-Mouse-328-04042016'; % Mouse 328 - Day 5
    % ------------ 330 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160401/Mouse330/Breath-Mouse-330-01042016'; % Mouse 330 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160404/Mouse330/Breath-Mouse-330-04042016'; % Mouse 330 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160621';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160906';
    % ------------ 393 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160704';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160711';
    % ------------ 394 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160704';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160711';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160718';%ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160906';
    % ------------ 395 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160718';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160725';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160726';% refait->Run
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160906';
    % ------------ 400 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160718';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160726';%ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160913';
    % ------------ 402 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse402/20160822-PoolDayAndNight';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse402/20160830';
    % ------------ 403 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse403/20160822-PoolDayAndNight';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160830';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160913';
    % ------------ 450 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160913';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20161010';
    % ------------ 451 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160913';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20161010';
    
    
elseif strcmp(experiment,'BASAL')

    % ------------ 294 ------------
    %     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160621'; % manque début rec
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160627';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160628';%ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160906';
    
    % ------------ 330 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160621';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160627';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160628';% refait->Run
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160906';
    
    % ------------ 393 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160704';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160711';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160718'; % pas de signaux début rec
    
    
    % ------------ 394 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160704';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160711';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160718';%ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160906';
    
    % ------------ 395 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160718';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160725';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160726';% refait->Run
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160906';
    
    % ------------ 400 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160718';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160725';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160726';%ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160913';
    
    % ------------ 402 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse402/20160822-PoolDayAndNight';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse402/20160830';
    
    % ------------ 403 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse403/20160822-PoolDayAndNight';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160830';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160913';
    
    % ------------ 450 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160913';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20161010';
    
    % ------------ 451 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160913';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20161010';


elseif strcmp(experiment,'BASAL-night')
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160906-night';% very short, rest is noise
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160906-night';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160906-night';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160906-night';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160913-night';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160913-night';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160913-night';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160913-night';
    
elseif strcmp(experiment,'SD6h')
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160629';% refait->Run
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160629';% ->Run
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160719';% refait->Run
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160719';% refait->Run
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160727';% refait
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160727';% refait
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse402/20160831';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse403/20160831';
    
elseif strcmp(experiment,'SD6h-NextDAY')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160630';%ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160630';%ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160720';% refait->Run
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160720';% refait->Run
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160728';%ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160728';%ok
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse402/20160901';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160901';
    
elseif strcmp(experiment,'SD24h')
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160908';% high noise
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160908';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160908';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160908';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160915';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160915';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160915';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160915';
    
elseif strcmp(experiment,'SD24h-night')
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160908-night';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160908-night';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160908-night';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160908-night';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160915-night';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160915-night';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160915-night';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160915-night';
    
elseif strcmp(experiment,'SD24h-NextDAY')
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160909';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160909';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160909';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160909';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160916';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160916';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160916';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160916';
    
elseif strcmp(experiment,'SD24h-NextDAY-night')
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160909-night';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160909-night';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160909-night';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160909-night';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160916-night';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160916-night';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160916-night';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160916-night';
    
elseif strcmp(experiment,'OR'),
    
    % hab
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160705';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160705';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse402/20160823';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse403/20160823';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20161011';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20161011';
    
    % test
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160706';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160706';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse402/20160824';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse403/20160824';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20161012';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20161012';
    

else
    error('Invalid name of experiment')
end

%% names

for i=1:length(Dir.path)
    Dir.manipe{i}=experiment;
    try Dir.name{i}=Dir.path{i}(max(strfind(Dir.path{i},'Mouse'))+[0:8]);
    catch, Dir.name{i}=Dir.path{i}(max(strfind(Dir.path{i},'Mouse'))+[0:7]);
    end
    Dir.name{i}(strfind(Dir.name{i},'-'))=[];
    Dir.name{i}(strfind(Dir.name{i},'/'))=[];
end


%% Strain

for i=1:length(Dir.path)
    Dir.group{i}='WT';
end

%% Correction if gain 1000 was not applied for signal aquisition

for i=1:length(Dir.path)
    Dir.CorrecAmpli(i)=1;
end
