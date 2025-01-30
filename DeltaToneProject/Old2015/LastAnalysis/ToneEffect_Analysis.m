% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
a=0;
a=a+1; Path_M243_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse243';
a=a+1; Path_M243_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse243';
a=a+1; Path_M243_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse243';
a=a+1; Path_M243_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243';
a=a+1; Path_M243_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';

a=0;
a=a+1; Path_M244_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse244';
a=a+1; Path_M244_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse244';
a=a+1; Path_M244_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse244';
a=a+1; Path_M244_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244';
a=a+1; Path_M244_basal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244';

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
a=0;
a=a+1; Path_Mouse243_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150421/Breath-Mouse-243-21042015';               % 21-04-2015 > delay 140ms
a=a+1; Path_Mouse243_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse243';  % 17-04-2015 > delay 200ms
a=a+1; Path_Mouse243_Delta{a}='/media/DataMOBs28/Mice-243-244/20150423/Breath-Mouse-243-23042015';                                          % 23-04-2015 > delay 320ms
a=a+1; Path_Mouse243_Delta{a}='/media/DataMOBs28/Mice-243-244/20150425/Breath-Mouse-243-25042015';                                          % 25-04-2015 > delay 480ms

a=0;
a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBs28/Mice-243-244/20150422/Breath-Mouse-244-22042015';                                          % 22-04-2015 > delay 140ms
a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse244';  % 16-04-2015 > delay 200ms
a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBs28/Mice-243-244/20150424/Breath-Mouse-244-24042015';                                          % 24-04-2015 > delay 320ms
a=a+1; Path_Mouse244_Delta{a}='/media/DataMOBs28/Mice-243-244/20150426/Breath-Mouse-244-26042015';                                          % 26-04-2015 > delay 480ms
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

try 
    struc
catch
    struc='PaCx';
end

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                       LOAD  EPOCH & DELTA for BASAL SLEEP
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% <><><><><><><><><><><><><><>  Mouse 243 : basal sleep <><><><><><><><><><><><><><> 
for a=1:length(Path_Mouse243_Delta)
    cd(Path_Mouse243_Delta{a})
    res=pwd;
    load rawLFP_TONEtime_SWS
    load rawLFP_DeltaDetect_SWS
    for i=1:32
        rawLFP_TONEt1{a,i}=rawLFP_TONEtime1{i};
        rawLFP_TONEt2{a,i}=rawLFP_TONEtime2{i};
        rawLFP_Delta{a,i}=rawLFP_DeltaDetect{i};
    end
end