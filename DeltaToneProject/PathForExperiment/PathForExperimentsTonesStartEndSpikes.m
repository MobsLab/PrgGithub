function Dir=PathForExperimentsTonesStartEndSpikes
%
%
%

a=0;
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150425/Breath-Mouse-243-25042015';               % 25-04-2015 > delay 490ms - Mouse 243
Dir.center{a} = 5*3600e4;
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150426/Breath-Mouse-244-26042015';               % 26-04-2015 > delay 490ms - Mouse 244
Dir.center{a} = 5*3600e4;
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170215/Breath-Mouse-403-451-15022017/Mouse403'; % M403 15-02-2017 - delay 0ms
Dir.center{a} = 5*3600e4;
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170130/Breath-Mouse-403-451-30012017/Mouse451'; % M451 30-01-2017 - delay 0ms
Dir.center{a} = 5*3600e4;
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20160216/Mouse294/Breath-Mouse-294-16022016';  % M294 16-02-2016 - delay 140ms
Dir.center{a} = 5*3600e4;
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160502/Mouse328/Breath-Mouse-328-02052016'; % M328 02-05-2016 - delay 0ms
Dir.center{a} = 5*3600e4;
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160421/Mouse330/Breath-Mouse-330-21042016'; % M330 21-04-2016 - delay 0ms
Dir.center{a} = 5*3600e4;





%% name, manipe, group, date 
for i=1:length(Dir.path)
    Dir.manipe{i}='Tones';
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




