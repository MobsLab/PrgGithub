function Dir=PathForExperimentsRandomTonesSpikes
%
% see PathForExperimentsDeltaLongSleepNew PathForExperimentsRandomShamSpikes PathForExperimentsDeltaSleepSpikes
%
% Path for all records of with spikes/down and random tones
% For tones in Up<>Down projects
%

a=0;
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse243'; % M243 16-04-2015 - delay 200ms 
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse244'; % M244 17-04-2015 - delay 200ms
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170215/Breath-Mouse-403-451-15022017/Mouse403'; % M403 15-02-2017 - delay 0ms
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170213/Breath-Mouse-403-451-13022017/Mouse451'; % M451 13-02-2017 - delay 0ms
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160216/Mouse294/Breath-Mouse-294-16022016';  % M294 16-02-2016 - delay 140ms
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160502/Mouse328/Breath-Mouse-328-02052016'; % M328 02-05-2016 - delay 0ms
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160421/Mouse330/Breath-Mouse-330-21042016'; % M330 21-04-2016 - delay 0ms

% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160523/Mouse330/Breath-Mouse-330-23052016'; % M330 23-05-2016 - delay 0ms
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160223/Mouse294/Breath-Mouse-294-23022016';  % M294 23-02-2016 - delay 320ms
% a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse874/20190502/'; % M874 02-05-2019 - delay 0ms



%% name, manipe, group, date 
for i=1:length(Dir.path)
    Dir.manipe{i}='Basal';
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



%% Not enough neurons for downstates
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150602/Breath-Mouse-251-252-02062015/Mouse252'; % M252 02-06-2015 - delay 0ms


%% Not so good for tones in Down<>Up

% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151228/Mouse294/Breath-Mouse-294-28122015'; % M294 28-12-2015 - delay 0ms (two click ?)
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160104/Mouse294/Breath-Mouse-294-04012016'; % M294 04-01-2016 - delay 0ms
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160215/Mouse293/Breath-Mouse-293-15022016';  % M293 15-02-2016 - delay 140ms
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160518/Mouse328/Breath-Mouse-328-18052016'; % M328 18-05-2016 - delay 0ms
% a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170130/Breath-Mouse-403-451-30012017/Mouse451'; % M451 30-01-2017 - delay 0ms
% a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse873/20190517/'; % M873 17-05-2019 - Tones 0ms (not random)
% a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse874/20190510/'; % M874 10-05-2019 - Tones 0ms (not random)



