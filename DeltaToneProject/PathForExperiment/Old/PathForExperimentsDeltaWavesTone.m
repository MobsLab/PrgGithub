function Dir=PathForExperimentsDeltaWavesTone(experiment)

%
% see PathForExperimentsDeltaLongSleep PathForExperimentsDeltaSleepSpikes
%

%% Basal condition
a=0;
if strcmpi(experiment,'BASAL')
    %GL
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse243'; % Mouse 243 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse244'; % Mouse 244 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243'; % Mouse 243 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse244'; % Mouse 244 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243'; % Mouse 243 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244'; % Mouse 244 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243'; % Mouse 243 - Day 5
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244'; % Mouse 244 - Day 5
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse251'; % Mouse 251 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse252'; % Mouse 252 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse251'; % Mouse 251 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse252'; % Mouse 252 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150520/Breath-Mouse-251-252-20052015/Mouse251'; % Mouse 251 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150520/Breath-Mouse-251-252-20052015/Mouse252'; % Mouse 252 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse251'; % Mouse 251 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse252'; % Mouse 252 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150522/Breath-Mouse-251-252-22052015/Mouse251'; % Mouse 251 - Day 5
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150522/Breath-Mouse-251-252-22052015/Mouse252'; % Mouse 252 - Day 5
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151207/Mouse293/Breath-Mouse-293-07122015'; % Mouse 293 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151207/Mouse294/Breath-Mouse-294-07122015'; % Mouse 294 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151207/Mouse296/Breath-Mouse-296-07122015'; % Mouse 296 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151208/Mouse293/Breath-Mouse-293-08122015'; % Mouse 293 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151208/Mouse294/Breath-Mouse-294-08122015'; % Mouse 294 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151208/Mouse296/Breath-Mouse-296-08122015'; % Mouse 296 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151209/Mouse293/Breath-Mouse-293-09122015'; % Mouse 293 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151209/Mouse296/Breath-Mouse-296-09122015'; % Mouse 296 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151211/Mouse293/Breath-Mouse-293-11122015'; % Mouse 293 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151211/Mouse294/Breath-Mouse-294-11122015'; % Mouse 294 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151211/Mouse296/Breath-Mouse-296-11122015'; % Mouse 296 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151218/Mouse293/Breath-Mouse-293-18122015'; % Mouse 293 - Day 5
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151218/Mouse294/Breath-Mouse-294-18122015'; % Mouse 294 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151218/Mouse296/Breath-Mouse-296-18122015'; % Mouse 296 - Day 5
    
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160322/Breath-Mouse-328-22032016'; % Mouse 328 - Day 1
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160325/Breath-Mouse-328-25032016'; % Mouse 328 - Day 2    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160329/Mouse328/Breath-Mouse-328-29032016'; % Mouse 328 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160401/Mouse328/Breath-Mouse-328-01042016'; % Mouse 328 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160401/Mouse330/Breath-Mouse-330-01042016'; % Mouse 330 - Day 2
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160404/Mouse328/Breath-Mouse-328-04042016'; % Mouse 328 - Day 5
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160404/Mouse330/Breath-Mouse-330-04042016'; % Mouse 330 - Day 3
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160408/Mouse328/Breath-Mouse-328-08042016'; % Mouse 328 - Day 6
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160408/Mouse330/Breath-Mouse-330-08042016'; % Mouse 330 - Day 4
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160418/Mouse328/Breath-Mouse-328-18042016'; % Mouse 328 - Day 7
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160418/Mouse330/Breath-Mouse-330-18042016'; % Mouse 330 - Day 5
    
%     
%     % OR
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160704';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160704';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160718';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160718';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse402/20160822-PoolDayAndNight';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetNREM/Mouse403/20160822-PoolDayAndNight';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20161010';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20161010';
    
%     %ML
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse051/20130313/BULB-Mouse-51-13032013'; % Mouse 51 - Trec- apres manipes dpcpx
% 
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130422/BULB-Mouse-60-22042013'; % Mouse 60 - Trec- REVERSE ok
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013'; % Mouse 60 - Trec- REVERSE fixed (-LFP)
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130416/BULB-Mouse-60-16042013'; % Mouse 60 - Trec- REVERSE ok
% 
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130422/BULB-Mouse-61-22042013'; % Mouse 61 - Trec- REVERSE fixed (-LFP)
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130415/BULB-Mouse-61-15042013'; % Mouse 61 - Trec- REVERSE fixed (-LFP)
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130416/BULB-Mouse-61-16042013'; % Mouse 61 - Trec- REVERSE fixed (-LFP)
% 
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130729/BULB-Mouse-82-29072013'; % Mouse 82 - Trec- REVERSE ok
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130730/BULB-Mouse-82-30072013'; % Mouse 82 - Trec- DPCPX % REVERSE ok
% 
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse083/20130723/BULB-Mouse-83-23072013'; % Mouse 83 - Trec- REVERSE ok
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse083/20130729/BULB-Mouse-83-29072013'; % Mouse 83 - Trec- REVERSE ok
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse083/20130730/BULB-Mouse-83-30072013'; % Mouse 83 - Trec- DPCPX % REVERSE ok
% 
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse147/20140804/BULB-Mouse-147-04082014'; % Mouse 87 - Trec- % REVERSE ok
% 
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse148/20140828/BULB-Mouse-148-28082014'; % Mouse 148 - Trec- REVERSE ok
% 
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse160/20141219/BULB-Mouse-160-19122014'; % Mouse 160 - Trec- REVERSE ok
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse160/20141222/BULB-Mouse-160-22122014'; % Mouse 160 - Trec- REVERSE ok
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse160/20141223/BULB-Mouse-160-23122014'; % Mouse 160 - Trec- REVERSE ok
% 
%     % 161 has no PFCx sup channel
% %     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse161/20141209/BULB-Mouse-161-09122014'; % Mouse 161 - Trec- REVERSE ok
% %     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse161/20141211/BULB-Mouse-161-11122014'; % Mouse 161 - Trec- REVERSE ok
% %     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse161/20141217/BULB-Mouse-161-17122014'; % Mouse 161 - Trec- REVERSE ok
% 
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse162/20141215/BULB-Mouse-162-15122014'; % Mouse 162 - Trec- REVERSE ok
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse162/20141216/BULB-Mouse-162-16122014'; % Mouse 162 - Trec- REVERSE ok
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse162/20141218/BULB-Mouse-162-18122014'; % Mouse 162 - Trec- REVERSE ok

end


%% Random condition
a=0;
if strcmpi(experiment,'RdmTone')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse243'; % 16-04-2015 > random tone effect  - Mouse 243 (delay 200ms!! of M244 detection)
    Dir.delay{a}=0.2;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse244'; % 17-04-2015 > random tone effect  - Mouse 244 (delay 200ms!! of M243 detection)
    Dir.delay{a}=0.2;
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150603/Breath-Mouse-252-251-03062015/Mouse251'; % 03-06-2015 > random tone effect  - Mouse 251 (delay 140ms!! of M252 detection)
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150602/Breath-Mouse-251-252-02062015/Mouse252'; % 02-06-2015 > random tone effect  - Mouse 252 (delay 140ms!! of M251 detection)
    Dir.delay{a}=0; % actual delay between timestamp and sound
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151227/Mouse296/Breath-Mouse-296-27122015'; % 27-12-2015 > random tone effect  - Mouse 296 (delay 140ms!! of M294 detection)
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151228/Mouse293/Breath-Mouse-293-28122015'; % 28-12-2015 > random tone effect  - Mouse 293 (delay 140ms!! of M296 detection)
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151228/Mouse294/Breath-Mouse-294-28122015'; % 28-12-2015 > random tone effect  - Mouse 294 (delay 140ms!! of M296 detection)
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160104/Mouse294/Breath-Mouse-294-04012016'; % 04-01-2016 > random tone effect  - Mouse 294 (delay 140ms!! of M293 detection)
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160104/Mouse296/Breath-Mouse-296-04012016'; % 04-01-2016 > random tone effect  - Mouse 296 (delay 140ms!! of M293 detection)
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160215/Mouse293/Breath-Mouse-293-15022016';  % 15-02-2016 > random tone effect - Mouse 293 (delay 140ms!! of M294 detection)
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160216/Mouse294/Breath-Mouse-294-16022016';  % 16-02-2016 > random tone effect - Mouse 294 (delay 140ms!! of M293 detection)
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160217/Mouse293/Breath-Mouse-293-17022016';  % 17-02-2016 > random tone effect - Mouse 293 (delay 320ms!! of M294 detection)
    Dir.delay{a}=0.32;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160223/Mouse294/Breath-Mouse-294-23022016';  % 23-02-2016 > random tone effect - Mouse 294 (delay 320ms!! of M293 detection)
    Dir.delay{a}=0.32;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160224/Mouse293/Breath-Mouse-293-24022016';  % 24-02-2016 > random tone effect - Mouse 293 (delay 490ms!! of M294 detection)
    Dir.delay{a}=0.49;
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160421/Mouse330/Breath-Mouse-330-21042016'; % 21-04-2016 > random tone effect  - Mouse 330 (delay 140ms!! of M328 detection)
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160502/Mouse328/Breath-Mouse-328-02052016'; % 02-05-2016 > random tone effect  - Mouse 328 (delay 140ms!! of M330 detection)
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160518/Mouse328/Breath-Mouse-328-18052016'; % 18-05-2016 > random tone effect  - Mouse 328 (delay 320ms!! of M330 detection)
    Dir.delay{a}=0; 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160523/Mouse330/Breath-Mouse-330-23052016'; % 23-05-2016 > random tone effect  - Mouse 330 (delay 480ms!! of M328 detection)
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160614/Mouse328/Breath-Mouse-328-14062016'; % 14-06-2016 > random tone effect  - Mouse 328 (delay 480ms!! of M330 detection)
    Dir.delay{a}=0;
    
end  


%% DeltaTone condition

a=0;
if strcmpi(experiment,'DeltaT0')
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160421/Mouse328/Breath-Mouse-328-21042016'; % 21-04-2016 > delay 0ms - Mouse 328
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160502/Mouse330/Breath-Mouse-330-02052016'; % 02-05-2016 > delay 0ms - Mouse 330
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160517/Mouse328/Breath-Mouse-328-17052016'; % 17-05-2016 > delay 0ms - Mouse 328
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160518/Mouse330/Breath-Mouse-330-18052016'; % 18-05-2016 > delay 0ms - Mouse 330
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160523/Mouse328/Breath-Mouse-328-23052016'; % 23-05-2016 > delay 0ms - Mouse 328
    Dir.delay{a}=0;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160614/Mouse330/Breath-Mouse-330-14062016'; % 14-06-2016 > delay 0ms - Mouse 330
    Dir.delay{a}=0;
end

a=0;
if strcmpi(experiment,'DeltaT140')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150421/Breath-Mouse-243-21042015'; % 21-04-2015 > delay 140ms - Mouse 243
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150422/Breath-Mouse-244-22042015'; % 22-04-2015 > delay 140ms - Mouse 244
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150614/Breath-Mouse-251-14062015'; % 14-06-2015 > delay 140ms - Mouse 251
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150603/Breath-Mouse-252-251-03062015/Mouse252';  % 03-06-2015 > delay 140ms - Mouse 252
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160215/Mouse294/Breath-Mouse-294-15022016'; % 15-02-2016 > delay 140ms - Mouse 294
    Dir.delay{a}=0.14;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160216/Mouse293/Breath-Mouse-293-16022016'; % 16-02-2016 > > delay 140ms - Mouse 293
    Dir.delay{a}=0.14;
    
end

a=0;
if strcmpi(experiment,'DeltaT200')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse243';  % 17-04-2015 > delay 200ms - Mouse 243
    Dir.delay{a}=0.2;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse244';  % 16-04-2015 > delay 200ms - Mouse 244
    Dir.delay{a}=0.2;
end

a=0;
if strcmpi(experiment,'DeltaT320') 
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150423/Breath-Mouse-243-23042015';               % 23-04-2015 > delay 320ms - Mouse 243
    Dir.delay{a}=0.32;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150424/Breath-Mouse-244-24042015';               % 24-04-2015 > delay 320ms - Mouse 244
    Dir.delay{a}=0.32;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150617/Breath-Mouse-251-17062015';               % 17-06-2015 > delay 320ms - Mouse 251
    Dir.delay{a}=0.32;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150605/Breath-Mouse-252-05062015';               % 05-06-2015 > delay 320ms - Mouse 252
    Dir.delay{a}=0.32;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160217/Mouse294/Breath-Mouse-294-17022016'; % 17-02-2016 > delay 320ms  - Mouse 294 
    Dir.delay{a}=0.32;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160223/Mouse293/Breath-Mouse-293-23022016'; % 23-02-2016 > delay 320ms  - Mouse 293
    Dir.delay{a}=0.32;
    
end

a=0;
if strcmpi(experiment,'DeltaT490')
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150425/Breath-Mouse-243-25042015';               % 25-04-2015 > delay 490ms - Mouse 243
    Dir.delay{a}=0.49;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150426/Breath-Mouse-244-26042015';               % 26-04-2015 > delay 490ms - Mouse 244
    Dir.delay{a}=0.49;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150619/Breath-Mouse-251-19062015';               % 19-06-2015 > delay 490ms - Mouse 251
    Dir.delay{a}=0.49;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150608/Breath-Mouse-252-08062015';               % 08-06-2015 > delay 490ms - Mouse 252
    Dir.delay{a}=0.49;  
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160224/Mouse294/Breath-Mouse-294-24022016'; % 24-02-2016 > delay 490ms  - Mouse 294
    Dir.delay{a}=0.49;
    
end



%% If ALL experiments
if strcmpi(experiment,'all')
    Dir1 = PathForExperimentsDeltaWavesTone('Basal');
    for p=1:length(Dir1.path)
        Dir1.delay{p}=-1;
    end
    Dir2=PathForExperimentsDeltaWavesTone('RdmTone');
    Dir3=PathForExperimentsDeltaWavesTone('DeltaToneAll');
    Dir = MergePathForExperiment(Dir2,Dir3);
    Dir = MergePathForExperiment(Dir1,Dir);

    
elseif strcmpi(experiment,'DeltaToneAll')
    Dir1 = PathForExperimentsDeltaWavesTone('DeltaT0');
    Dir2 = PathForExperimentsDeltaWavesTone('DeltaT140');
    Dir3 = PathForExperimentsDeltaWavesTone('DeltaT200');
    Dir4 = PathForExperimentsDeltaWavesTone('DeltaT320');
    Dir5 = PathForExperimentsDeltaWavesTone('DeltaT490');
    
    Dir = MergePathForExperiment(Dir1,Dir2);
    Dir = MergePathForExperiment(Dir,Dir3);
    Dir = MergePathForExperiment(Dir,Dir4);
    Dir = MergePathForExperiment(Dir,Dir5);
    
    for i=1:length(Dir.path)
       Dir.manipe{i}='DeltaToneAll'; 
    end
    
    
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
        Dir.date{i} = Dir.path{i}(ind(end)-4:ind(end)+3);
    end

end

end

