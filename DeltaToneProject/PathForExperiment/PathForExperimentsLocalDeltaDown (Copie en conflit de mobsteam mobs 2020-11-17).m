function Dir=PathForExperimentsLocalDeltaDown(experiment)

%
% see PathForExperimentsBasalSleepSpike
%
% Path for all records of basal Sleep with good detection of delta waves 


if nargin < 1
  experiment = 'all';
end


if strcmpi(experiment,'all')
    a=0;

    % ------------ 243 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse243'; 
    Dir.tetrodes{a} = [1 2 3];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243'; 
    Dir.tetrodes{a} = [1 2 3];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243';
    Dir.tetrodes{a} = [1 2 3];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';
    Dir.tetrodes{a} = [1 2 3];
    % ------------ 244 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse244';
    Dir.tetrodes{a} = [1 2 3];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse244';
    Dir.tetrodes{a} = [1 2 3];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244';
    Dir.tetrodes{a} = [1 2 3];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244';
    Dir.tetrodes{a} = [1 2 3];
    %------------ 451 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161205/Mouse451/Breath-Mouse-451-05122016/';
    Dir.tetrodes{a} = [1 5 6];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161209/Mouse451/Breath-Mouse-451-09122016/';
    Dir.tetrodes{a} = [1 5 6];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161212/Mouse451/Breath-Mouse-451-12122016/';
    Dir.tetrodes{a} = [1 4 5];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161217/Mouse451/Breath-Mouse-451-17122016/';
    Dir.tetrodes{a} = [1 5 6];
    % ------------ 490 ------------
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse490/20161124/'; % Mouse 490 - Basal 1 
    Dir.tetrodes{a} = [1 4];
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse490/20161129/'; % Mouse 490 - Basal 2 
    Dir.tetrodes{a} = [1 5];
    % ------------ 507 ------------
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse507/20170126/'; % Mouse 507 - Basal 1 
    Dir.tetrodes{a} = [1 2 4 5];
    % ------------ 508 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/'; % Mouse 508 - Basal 1 
    Dir.tetrodes{a} = [1:3 5 7:9];
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170127/ProjectEmbReact_M508_20170127_BaselineSleep/'; % Mouse 508 - Basal 2
    Dir.tetrodes{a} = [1:3 5 7:9];
    % ------------ 509 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170127/ProjectEmbReact_M509_20170127_BaselineSleep/'; % Mouse 509 - Basal 1
    Dir.tetrodes{a} = [1 2 8 9];
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170130/ProjectEmbReact_M509_20170130_BaselineSleep/'; % Mouse 509 - Basal 2
    Dir.tetrodes{a} = [1 2 7:9];
    
    
    
elseif strcmpi(experiment,'hemisphere')
    a=0;
     % ------------ 243 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse243'; 
    Dir.tetrodes{a} = [1 2 3];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243'; 
    Dir.tetrodes{a} = [1 2 3];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243';
    Dir.tetrodes{a} = [1 2 3];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';
    Dir.tetrodes{a} = [1 2 3];
    % ------------ 244 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse244';
    Dir.tetrodes{a} = [1 2 3];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse244';
    Dir.tetrodes{a} = [1 2 3];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244';
    Dir.tetrodes{a} = [1 2 3];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244';
    Dir.tetrodes{a} = [1 2 3];
    %------------ 451 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161205/Mouse451/Breath-Mouse-451-05122016/';
    Dir.tetrodes{a} = [1 5 6];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161209/Mouse451/Breath-Mouse-451-09122016/';
    Dir.tetrodes{a} = [1 5 6];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161212/Mouse451/Breath-Mouse-451-12122016/';
    Dir.tetrodes{a} = [1 4 5];
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161217/Mouse451/Breath-Mouse-451-17122016/';
    Dir.tetrodes{a} = [1 5 6];
    % ------------ 490 ------------
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse490/20161124/'; % Mouse 490 - Basal 1 
    Dir.tetrodes{a} = [1 4];
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse490/20161129/'; % Mouse 490 - Basal 2 
    Dir.tetrodes{a} = [1 5];
    % ------------ 507 ------------
    a=a+1; Dir.path{a}='/media/nas4/ProjetDeltaToneFeedback/Mouse507/20170126/'; % Mouse 507 - Basal 1 
    Dir.tetrodes{a} = [1 2 4 5];
    % ------------ 508 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/'; % Mouse 508 - Basal 1 
    Dir.tetrodes{a} = [1 2 3 5]; Dir.hemisphere{a} = 'l';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/'; % Mouse 508 - Basal 1 
    Dir.tetrodes{a} = [7 8 9]; Dir.hemisphere{a} = 'r';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170127/ProjectEmbReact_M508_20170127_BaselineSleep/'; % Mouse 508 - Basal 2
    Dir.tetrodes{a} = [1 2 3 5]; Dir.hemisphere{a} = 'l';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170127/ProjectEmbReact_M508_20170127_BaselineSleep/'; % Mouse 508 - Basal 2
    Dir.tetrodes{a} = [7 8 9]; Dir.hemisphere{a} = 'r';
    % ------------ 509 ------------
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170127/ProjectEmbReact_M509_20170127_BaselineSleep/'; % Mouse 509 - Basal 1
    Dir.tetrodes{a} = [1 2]; Dir.hemisphere{a} = 'l';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170127/ProjectEmbReact_M509_20170127_BaselineSleep/'; % Mouse 509 - Basal 1
    Dir.tetrodes{a} = [8 9]; Dir.hemisphere{a} = 'r';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170130/ProjectEmbReact_M509_20170130_BaselineSleep/'; % Mouse 509 - Basal 2
    Dir.tetrodes{a} = [1 2]; Dir.hemisphere{a} = 'l';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170130/ProjectEmbReact_M509_20170130_BaselineSleep/'; % Mouse 509 - Basal 2
    Dir.tetrodes{a} = [7 8 9]; Dir.hemisphere{a} = 'r';
    
    
end


%% name, manipe, group, date 
for i=1:length(Dir.path)
    Dir.manipe{i}='Basal';
    Dir.group{i}='WT';

    %mouse name
    Dir.name{i}=Dir.path{i}(strfind(Dir.path{i},'/Mouse'):strfind(Dir.path{i},'/Mouse')+8);
    Dir.name{i}(Dir.name{i}=='-')=[];
    Dir.name{i}(Dir.name{i}=='/')=[];
    
    %date
    ind = strfind(Dir.path{i},'/201');
    Dir.date{i} = Dir.path{i}(ind + [7 8 5 6 1:4]);

end



end