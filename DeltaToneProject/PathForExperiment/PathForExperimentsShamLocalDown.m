function Dir=PathForExperimentsShamLocalDown(experiment)




if nargin < 1
  experiment = 'random';
end


if strcmpi(experiment,'random')
    a=0;
    % ------------ 243 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse243'; 
    Dir.tetrodes{a} = 1:3;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243'; 
    Dir.tetrodes{a} = 1:3;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243';
    Dir.tetrodes{a} = 1:3;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';
    Dir.tetrodes{a} = 1:3;
    % ------------ 244 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse244';
    Dir.tetrodes{a} = 1:3;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse244';
    Dir.tetrodes{a} = 1:3;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244';
    Dir.tetrodes{a} = 1:3;
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244';
    Dir.tetrodes{a} = 1:3;
    
    % KJ
    % ------------ 403 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161205/Mouse403/Breath-Mouse-403-05122016/';
    Dir.tetrodes{a} = [1:3 6];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161209/Mouse403/Breath-Mouse-403-09122016/';
    Dir.tetrodes{a} = [1:3 6];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161212/Mouse403/Breath-Mouse-403-12122016/';
    Dir.tetrodes{a} = [1:3 6];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161217/Mouse403/Breath-Mouse-403-17122016/';
    Dir.tetrodes{a} = [1:3 6];
%     %------------ 451 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161205/Mouse451/Breath-Mouse-451-05122016/';
    Dir.tetrodes{a} = [1 5 6];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161209/Mouse451/Breath-Mouse-451-09122016/';
    Dir.tetrodes{a} = [1 5 6];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161212/Mouse451/Breath-Mouse-451-12122016/';
    Dir.tetrodes{a} = [1 4 5];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161217/Mouse451/Breath-Mouse-451-17122016/';
    Dir.tetrodes{a} = [1 5 6];
    
    
end



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




