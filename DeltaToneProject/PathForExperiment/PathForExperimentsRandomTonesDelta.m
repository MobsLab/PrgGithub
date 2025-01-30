function Dir=PathForExperimentsRandomTonesDelta
%
% see PathForExperimentsRandomTonesSpikes PathForExperimentsDeltaCloseLoop PathForExperimentsRandomShamDelta
%
% Path for all records of with delta waves and random tones
% For tones in Up<>Down projects
%

a=0;
% ------------ 243 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse243'; % M243 16-04-2015 - delay 200ms 
Dir.delay{a}=0.2;
% ------------ 244 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse244'; % M244 17-04-2015 - delay 200ms
Dir.delay{a}=0.2;
% ------------ 251 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150603/Breath-Mouse-252-251-03062015/Mouse251'; % 03-06-2015  Random - M252 (delay 140ms!! of M252 detection)
Dir.delay{a}=0.14;
% ------------ 252 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150602/Breath-Mouse-251-252-02062015/Mouse252'; % 02-06-2015  Random - M252 (delay 140ms!! of M251 detection)
Dir.delay{a}=0.14;
% ------------ 294 ------------
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
% ------------ 403 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170215/Breath-Mouse-403-451-15022017/Mouse403'; % 15-02-2017  Random - M403 - delay 0ms
Dir.delay{a}=0;
%------------ 451 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170213/Breath-Mouse-403-451-13022017/Mouse451'; % 13-02-2017  Random - M451 - delay 0ms
Dir.delay{a}=0;
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170130/Breath-Mouse-403-451-30012017/Mouse451'; % 30-01-2017  Random - M451 - delay 0ms
Dir.delay{a}=0;


%% name, manipe, group, date 
for i=1:length(Dir.path)
    Dir.manipe{i}='RdmTone';
    Dir.group{i}='WT';

    %mouse name
    Dir.name{i}=Dir.path{i}(strfind(Dir.path{i},'/Mouse'):strfind(Dir.path{i},'/Mouse')+8);
    Dir.name{i}(Dir.name{i}=='-')=[];
    Dir.name{i}(Dir.name{i}=='/')=[];
    
    if isempty(Dir.name{i})
        Dir.name{i}=Dir.path{i}(strfind(Dir.path{i},'Mouse'):strfind(Dir.path{i},'Mouse')+8);
        Dir.name{i}(Dir.name{i}=='-')=[];
        Dir.name{i}(Dir.name{i}=='/')=[];
    end
    
    %date
    ind = strfind(Dir.path{i},'/201');
    Dir.date{i} = Dir.path{i}(ind + [7 8 5 6 1:4]);

end

    
end




