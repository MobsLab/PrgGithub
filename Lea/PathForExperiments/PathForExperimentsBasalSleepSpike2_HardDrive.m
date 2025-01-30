function Dir=PathForExperimentsBasalSleepSpike2_HardDrive

%
% see PathForExperimentsBasalSleepSpike2

a=0;

% GL
% 
% ------------ 243 ------------
a=a+1; Dir.path{a}='/Volumes/LeaMOBs/DataPathForExperimentsBasalSleepSpike2/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse243'; 
a=a+1; Dir.path{a}='/Volumes/LeaMOBs/DataPathForExperimentsBasalSleepSpike2/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243'; 
a=a+1; Dir.path{a}='/Volumes/LeaMOBs/DataPathForExperimentsBasalSleepSpike2/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243';
a=a+1; Dir.path{a}='/Volumes/LeaMOBs/DataPathForExperimentsBasalSleepSpike2/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';
% ------------ 244 ------------
a=a+1; Dir.path{a}='/Volumes/LeaMOBs/DataPathForExperimentsBasalSleepSpike2/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse244';
a=a+1; Dir.path{a}='/Volumes/LeaMOBs/DataPathForExperimentsBasalSleepSpike2/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse244';
a=a+1; Dir.path{a}='/Volumes/LeaMOBs/DataPathForExperimentsBasalSleepSpike2/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244';
a=a+1; Dir.path{a}='/Volumes/LeaMOBs/DataPathForExperimentsBasalSleepSpike2/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244';


%% KJ

%------------ 451 ------------
a=a+1; Dir.path{a}='/Volumes/LeaMOBs/DataPathForExperimentsBasalSleepSpike2/ProjetBreathDeltaFeedback/Mice403-451/20161205/Mouse451/Breath-Mouse-451-05122016/';
a=a+1; Dir.path{a}='/Volumes/LeaMOBs/DataPathForExperimentsBasalSleepSpike2/ProjetBreathDeltaFeedback/Mice403-451/20161209/Mouse451/Breath-Mouse-451-09122016/';
a=a+1; Dir.path{a}='/Volumes/LeaMOBs/DataPathForExperimentsBasalSleepSpike2/ProjetBreathDeltaFeedback/Mice403-451/20161212/Mouse451/Breath-Mouse-451-12122016/';
a=a+1; Dir.path{a}='/Volumes/LeaMOBs/DataPathForExperimentsBasalSleepSpike2/ProjetBreathDeltaFeedback/Mice403-451/20161217/Mouse451/Breath-Mouse-451-17122016/';


%% SB
% ------------ 490 ------------
a=a+1; Dir.path{a}='/Volumes/LeaMOBs/DataPathForExperimentsBasalSleepSpike2/ProjetDeltaToneFeedback/Mouse490/20161124/'; % Mouse 490 - Basal 1 
a=a+1; Dir.path{a}='/Volumes/LeaMOBs/DataPathForExperimentsBasalSleepSpike2/ProjetDeltaToneFeedback/Mouse490/20161129/'; % Mouse 490 - Basal 2 

% ------------ 507 ------------
a=a+1; Dir.path{a}='/Volumes/LeaMOBs/DataPathForExperimentsBasalSleepSpike2/ProjetDeltaToneFeedback/Mouse507/20170126/'; % Mouse 507 - Basal 1 
% ------------ 508 ------------
a=a+1; Dir.path{a}='/Volumes/LeaMOBs/DataPathForExperimentsBasalSleepSpike2/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/'; % Mouse 508 - Basal 1 
a=a+1; Dir.path{a}='/Volumes/LeaMOBs/DataPathForExperimentsBasalSleepSpike2/ProjectEmbReact/Mouse508/20170127/ProjectEmbReact_M508_20170127_BaselineSleep/'; % Mouse 508 - Basal 2
% ------------ 509 ------------
a=a+1; Dir.path{a}='/Volumes/LeaMOBs/DataPathForExperimentsBasalSleepSpike2/ProjectEmbReact/Mouse509/20170127/ProjectEmbReact_M509_20170127_BaselineSleep/'; % Mouse 509 - Basal 1 
a=a+1; Dir.path{a}='/Volumes/LeaMOBs/DataPathForExperimentsBasalSleepSpike2/ProjectEmbReact/Mouse509/20170130/ProjectEmbReact_M509_20170130_BaselineSleep/'; % Mouse 509 - Basal 2


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



