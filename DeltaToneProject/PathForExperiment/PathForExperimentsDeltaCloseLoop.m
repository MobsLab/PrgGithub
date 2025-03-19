function Dir=PathForExperimentsDeltaCloseLoop(experiment)

%
% see PathForExperimentsDeltaLongSleepNew PathForExperimentsRandomTonesSpikes PathForExperimentsDeltaSleepSpikes
%
%


%% Basal condition
a=0;
if strcmpi(experiment,'basal')
    
    % ------------ 243 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse243'; 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243'; %long
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243'; %long
    % ------------ 244 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse244'; %long
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse244'; %long
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244'; %long
   	
    % ------------ 251 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse251'; % Mouse 251 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse251'; % Mouse 251 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150520/Breath-Mouse-251-252-20052015/Mouse251'; % Mouse 251 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse251'; % Mouse 251 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150522/Breath-Mouse-251-252-22052015/Mouse251'; % Mouse 251 - Day 5
    % ------------ 252 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse252'; % Mouse 252 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse252'; % Mouse 252 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150520/Breath-Mouse-251-252-20052015/Mouse252'; % Mouse 252 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse252'; % Mouse 252 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150522/Breath-Mouse-251-252-22052015/Mouse252'; % Mouse 252 - Day 5 
    
    % ------------ 293 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151207/Mouse293/Breath-Mouse-293-07122015'; % Mouse 293 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151208/Mouse293/Breath-Mouse-293-08122015'; % Mouse 293 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151209/Mouse293/Breath-Mouse-293-09122015'; % Mouse 293 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151211/Mouse293/Breath-Mouse-293-11122015'; % Mouse 293 - Day 4
    % ------------ 294 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151207/Mouse294/Breath-Mouse-294-07122015'; % Mouse 294 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151208/Mouse294/Breath-Mouse-294-08122015'; % Mouse 294 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151211/Mouse294/Breath-Mouse-294-11122015'; % Mouse 294 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151218/Mouse294/Breath-Mouse-294-18122015'; % Mouse 294 - Day 4
    
    % ------------ 328 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160322/Breath-Mouse-328-22032016'; % Mouse 328 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160325/Breath-Mouse-328-25032016'; % Mouse 328 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160401/Mouse328/Breath-Mouse-328-01042016'; % Mouse 328 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160404/Mouse328/Breath-Mouse-328-04042016'; % Mouse 328 - Day 5   
    % ------------ 330 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160401/Mouse330/Breath-Mouse-330-01042016'; % Mouse 330 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160404/Mouse330/Breath-Mouse-330-04042016'; % Mouse 330 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160408/Mouse330/Breath-Mouse-330-08042016'; % Mouse 330 - Day 4

    % ------------ 403 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161205/Mouse403/Breath-Mouse-403-05122016/';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161209/Mouse403/Breath-Mouse-403-09122016/';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161212/Mouse403/Breath-Mouse-403-12122016/';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161217/Mouse403/Breath-Mouse-403-17122016/';
    %------------ 451 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161205/Mouse451/Breath-Mouse-451-05122016/';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161209/Mouse451/Breath-Mouse-451-09122016/';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161212/Mouse451/Breath-Mouse-451-12122016/';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161217/Mouse451/Breath-Mouse-451-17122016/';
    
end


%% Random condition
a=0;
if strcmpi(experiment,'RdmTone')
    
    % ------------ 243 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse243'; % M243 16-04-2015 - delay 200ms 
    % ------------ 244 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse244'; % M244 17-04-2015 - delay 200ms
    % ------------ 251 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150603/Breath-Mouse-252-251-03062015/Mouse251'; % 03-06-2015  Random - M252 (delay 140ms!! of M252 detection)
    Dir.delay{a}=0.14;
    % ------------ 252 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150602/Breath-Mouse-251-252-02062015/Mouse252'; % 02-06-2015  Random - M252 (delay 140ms!! of M251 detection)
    Dir.delay{a}=0.14;
    % ------------ 293 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151228/Mouse293/Breath-Mouse-293-28122015'; % 28-12-2015  Random - M293 (delay 140ms!! of M296 detection)
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160215/Mouse293/Breath-Mouse-293-15022016';  % 15-02-2016   Random - M293 (delay 140ms!! of M294 detection)
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160217/Mouse293/Breath-Mouse-293-17022016';  % 17-02-2016   Random - M293 (delay 320ms!! of M294 detection)
    Dir.delay{a}=0.32;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160224/Mouse293/Breath-Mouse-293-24022016';  % 24-02-2016   Random - M293 (delay 490ms!! of M294 detection)
    Dir.delay{a}=0.49;
    % ------------ 294 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151228/Mouse294/Breath-Mouse-294-28122015'; % 28-12-2015  Random - M294 (delay 140ms!! of M296 detection)
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160104/Mouse294/Breath-Mouse-294-04012016'; % 04-01-2016  Random - M294 (delay 140ms!! of M293 detection)
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160216/Mouse294/Breath-Mouse-294-16022016';  % 16-02-2016   Random - M294 (delay 140ms!! of M293 detection)
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160223/Mouse294/Breath-Mouse-294-23022016';  % 23-02-2016   Random - M294 (delay 320ms!! of M293 detection)
    Dir.delay{a}=0.32;
    % ------------ 328 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160502/Mouse328/Breath-Mouse-328-02052016'; % 02-05-2016  Random - M328 (delay 0ms!! of M330 detection)
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160518/Mouse328/Breath-Mouse-328-18052016'; % 18-05-2016  Random - M328 (delay 0ms!! of M330 detection)
    Dir.delay{a}=0; 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160614/Mouse328/Breath-Mouse-328-14062016'; % 14-06-2016  Random - M328 (delay 0ms!! of M330 detection)
    Dir.delay{a}=0;
    % ------------ 330 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160421/Mouse330/Breath-Mouse-330-21042016'; % 21-04-2016  Random - M330 (delay 0ms!! of M328 detection)
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160523/Mouse330/Breath-Mouse-330-23052016'; % 23-05-2016  Random - M330 (delay 0ms!! of M328 detection)
    Dir.delay{a}=0;
    % ------------ 403 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170215/Breath-Mouse-403-451-15022017/Mouse403'; % 15-02-2017  Random - M403 - delay 0ms
    Dir.delay{a}=0;
    %------------ 451 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170213/Breath-Mouse-403-451-13022017/Mouse451'; % 13-02-2017  Random - M451 - delay 0ms
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170130/Breath-Mouse-403-451-30012017/Mouse451'; % 30-01-2017  Random - M451 - delay 0ms
    Dir.delay{a}=0;
    
    
end  


%% DeltaTone condition

a=0;
if strcmpi(experiment,'DeltaT0')
    % ------------ 328 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160421/Mouse328/Breath-Mouse-328-21042016'; % 21-04-2016 > delay 0ms - Mouse 328
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160523/Mouse328/Breath-Mouse-328-23052016'; % 23-05-2016 > delay 0ms - Mouse 328
    Dir.delay{a}=0;
    % ------------ 330 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160502/Mouse330/Breath-Mouse-330-02052016'; % 02-05-2016 > delay 0ms - Mouse 330
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160518/Mouse330/Breath-Mouse-330-18052016'; % 18-05-2016 > delay 0ms - Mouse 330
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160614/Mouse330/Breath-Mouse-330-14062016'; % 14-06-2016 > delay 0ms - Mouse 330
    Dir.delay{a}=0;
    % ------------ 403 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170130/Breath-Mouse-403-451-30012017/Mouse403'; % 30-01-2017 > delay 0 ms - Mouse 403
    Dir.delay{a}=0; 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170213/Breath-Mouse-403-451-13022017/Mouse403'; % 13-02-2017 > delay 0 ms - Mouse 403
    Dir.delay{a}=0;
    %------------ 451 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170215/Breath-Mouse-403-451-15022017/Mouse451'; % 15-02-2017 > delay 0 ms - Mouse 451
    Dir.delay{a}=0;
    
    
end

a=0;
if strcmpi(experiment,'DeltaT140')
    % ------------ 243 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150421/Breath-Mouse-243-21042015';               % 21-04-2015 > delay 140ms - Mouse 243
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150429/Breath-Mouse-243-29042015';               % 29-04-2015 > delay 140ms - Mouse 243
    Dir.delay{a}=0.14;
    % ------------ 244 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150422/Breath-Mouse-244-22042015';               % 22-04-2015 > delay 140ms - Mouse 244
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150430/Breath-Mouse-244-30042015';               % 30-04-2015 > delay 140ms - Mouse 244
    Dir.delay{a}=0.14;
    % ------------ 251 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150614/Breath-Mouse-251-14062015';              % 14-06-2015 > delay 140ms - Mouse 251
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150621/Breath-Mouse-251-21062015';              % 21-06-2015 > delay 140ms - Mouse 251
    Dir.delay{a}=0.14;
    % ------------ 252 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150603/Breath-Mouse-252-251-03062015/Mouse252';  % 03-06-2015 > delay 140ms - Mouse 252
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150610/Breath-Mouse-252-10062015';               % 10-06-2015 > delay 140ms - Mouse 252
    Dir.delay{a}=0.14;
    % ------------ 293 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160216/Mouse293/Breath-Mouse-293-16022016'; % 16-02-2016 > > delay 140ms - Mouse 293
    Dir.delay{a}=0.14;
    % ------------ 294 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160215/Mouse294/Breath-Mouse-294-15022016'; % 15-02-2016 > delay 140ms - Mouse 294
    Dir.delay{a}=0.14;
end

a=0;
if strcmpi(experiment,'DeltaT200')
    % ------------ 243 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse243'; % M243 17-04-2015 - delay 200ms
    Dir.delay{a}=0.2;
    % ------------ 244 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse244'; % M244 16-04-2015 - delay 200ms
    Dir.delay{a}=0.2;
end

a=0;
if strcmpi(experiment,'DeltaT320')
    % ------------ 243 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150423/Breath-Mouse-243-23042015';              % 23-04-2015 > delay 320ms - Mouse 243
    Dir.delay{a}=0.32;
    % ------------ 244 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150424/Breath-Mouse-244-24042015';              % 24-04-2015 > delay 320ms - Mouse 244
    Dir.delay{a}=0.32;
    % ------------ 251 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150617/Breath-Mouse-251-17062015';              % 17-06-2015 > delay 320ms - Mouse 251
    Dir.delay{a}=0.32;
    % ------------ 252 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150605/Breath-Mouse-252-05062015';              % 05-06-2015 > delay 320ms - Mouse 252
    Dir.delay{a}=0.32;
    % ------------ 293 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160223/Mouse293/Breath-Mouse-293-23022016'; % 23-02-2016 > delay 320ms  - Mouse 293
    Dir.delay{a}=0.32;
    % ------------ 294 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160217/Mouse294/Breath-Mouse-294-17022016'; % 17-02-2016 > delay 320ms  - Mouse 294 
    Dir.delay{a}=0.32;
end

a=0;
if strcmpi(experiment,'DeltaT490')
    % ------------ 243 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150425/Breath-Mouse-243-25042015';               % 25-04-2015 > delay 490ms - Mouse 243
    Dir.delay{a}=0.49;
    % ------------ 244 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150426/Breath-Mouse-244-26042015';               % 26-04-2015 > delay 490ms - Mouse 244
    Dir.delay{a}=0.49;
    % ------------ 251 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150619/Breath-Mouse-251-19062015';               % 19-06-2015 > delay 490ms - Mouse 251
    Dir.delay{a}=0.49;
    % ------------ 252 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150608/Breath-Mouse-252-08062015';               % 19-06-2015 > delay 490ms - Mouse 251
    Dir.delay{a}=0.49;
    % ------------ 293 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160301/Mouse293/Breath-Mouse-293-01032016';  % 01-03-2016 > delay 490ms  - Mouse 293
    Dir.delay{a}=0.49;
    % ------------ 294 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160224/Mouse294/Breath-Mouse-294-24022016'; % 24-02-2016 > delay 490ms  - Mouse 294
    Dir.delay{a}=0.49;

end


%% If ALL experiments
if strcmpi(experiment,'all')
    Dir1 = PathForExperimentsDeltaCloseLoop('Basal');
    for p=1:length(Dir1.path)
        Dir1.delay{p}=-1;
    end
    Dir2=PathForExperimentsDeltaCloseLoop('AllTone');
    Dir = MergePathForExperiment(Dir1,Dir2);
    
elseif strcmpi(experiment,'DeltaToneDelay')
    Dir1 = PathForExperimentsDeltaCloseLoop('DeltaT140');
    Dir2 = PathForExperimentsDeltaCloseLoop('DeltaT200');
    Dir3 = PathForExperimentsDeltaCloseLoop('DeltaT320');
    Dir4 = PathForExperimentsDeltaCloseLoop('DeltaT490');
    
    Dir = MergePathForExperiment(Dir1,Dir2);
    Dir = MergePathForExperiment(Dir,Dir3);
    Dir = MergePathForExperiment(Dir,Dir4);
    
elseif strcmpi(experiment,'DeltaToneAll')
    Dir1 = PathForExperimentsDeltaCloseLoop('DeltaT0');
    Dir2 = PathForExperimentsDeltaCloseLoop('DeltaToneDelay');    
    Dir = MergePathForExperiment(Dir1,Dir2);
    
elseif strcmpi(experiment,'AllTone')
    Dir1 = PathForExperimentsDeltaCloseLoop('DeltaToneAll');
    Dir2 = PathForExperimentsDeltaCloseLoop('RdmTone');
    Dir = MergePathForExperiment(Dir1,Dir2);
    
else
    %% names
    for i=1:length(Dir.path)
        Dir.manipe{i}=experiment;
        if Dir.path{i}(end-8)=='/'
            Dir.name{i}=Dir.path{i}(end-7:end);
        else
            Dir.name{i}=Dir.path{i}(strfind(Dir.path{i},'Mouse'):strfind(Dir.path{i},'Mouse')+8);
            Dir.name{i}(Dir.name{i}=='-')=[];
            Dir.name{i}(Dir.name{i}=='/')=[];
        end
        
        if isempty(Dir.name{i})
            Dir.name{i}=Dir.path{i}(strfind(Dir.path{i},'Mouse'):strfind(Dir.path{i},'Mouse')+8);
            Dir.name{i}(Dir.name{i}=='-')=[];
            Dir.name{i}(Dir.name{i}=='/')=[];
        end

    end

    %% Strain
    for i=1:length(Dir.path)
        Dir.group{i}=nan;
    end

    %% Date
    for i=1:length(Dir.path)
        ind=strfind(Dir.path{i},'2015');
        if isempty(ind)
            ind=strfind(Dir.path{i},'2016');
        end
        if isempty(ind)
            ind=strfind(Dir.path{i},'2017');
        end
        if isempty(ind)
            ind=strfind(Dir.path{i},'2018');
        end
        Dir.date{i} = Dir.path{i}(ind(end)-4:ind(end)+3);
    end

end

end

